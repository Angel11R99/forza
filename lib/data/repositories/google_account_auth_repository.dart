import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/account_identity.dart';
import '../../domain/repositories/account_auth_repository.dart';

class GoogleAccountAuthRepository implements AccountAuthRepository {
  GoogleAccountAuthRepository({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  static const _iosClientId = String.fromEnvironment(
    'FORZA_GOOGLE_IOS_CLIENT_ID',
  );
  static const _androidServerClientId = String.fromEnvironment(
    'FORZA_GOOGLE_ANDROID_SERVER_CLIENT_ID',
  );

  final GoogleSignIn _googleSignIn;
  final StreamController<AccountIdentity?> _accountChanges =
      StreamController<AccountIdentity?>.broadcast();
  Future<void>? _initialization;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _eventSubscription;
  AccountIdentity? _currentAccount;

  @override
  AccountIdentity? get currentAccount => _currentAccount;

  @override
  Stream<AccountIdentity?> get accountChanges => _accountChanges.stream;

  @override
  Future<void> initialize() async {
    final existing = _initialization;
    if (existing != null) return existing;

    final initialization = _initializeGoogleSignIn();
    _initialization = initialization;
    try {
      await initialization;
    } on Object catch (error) {
      if (identical(_initialization, initialization)) _initialization = null;
      throw _mapFailure(error);
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    await _googleSignIn.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? _configuredValue(_iosClientId)
          : null,
      serverClientId: defaultTargetPlatform == TargetPlatform.android
          ? _configuredValue(_androidServerClientId)
          : null,
    );
    await _eventSubscription?.cancel();
    _eventSubscription = _googleSignIn.authenticationEvents.listen(
      (event) => switch (event) {
        GoogleSignInAuthenticationEventSignIn(:final user) => _publish(
          _toIdentity(user),
        ),
        GoogleSignInAuthenticationEventSignOut() => _publish(null),
      },
    );
  }

  @override
  Future<AccountIdentity?> restore() async {
    await initialize();
    try {
      final pending = _googleSignIn.attemptLightweightAuthentication();
      if (pending == null) return _currentAccount;
      final user = await pending;
      if (user == null) return _currentAccount;
      final identity = _toIdentity(user);
      _publish(identity);
      return identity;
    } on Object catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<AccountIdentity?> signInWithGoogle() async {
    await initialize();
    if (!_googleSignIn.supportsAuthenticate()) {
      throw const AccountAuthException(AccountAuthFailure.unavailable);
    }
    try {
      final user = await _googleSignIn.authenticate();
      final identity = _toIdentity(user);
      _publish(identity);
      return identity;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw _mapFailure(error);
    } on Object catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    await initialize();
    try {
      await _googleSignIn.signOut();
      _publish(null);
    } on Object catch (error) {
      throw _mapFailure(error);
    }
  }

  AccountIdentity _toIdentity(GoogleSignInAccount user) => AccountIdentity(
    providerUserId: user.id,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoUrl,
  );

  void _publish(AccountIdentity? identity) {
    _currentAccount = identity;
    if (!_accountChanges.isClosed) _accountChanges.add(identity);
  }

  AccountAuthException _mapFailure(Object error) {
    if (error is AccountAuthException) return error;
    if (error is GoogleSignInException) {
      final configurationError =
          error.code == GoogleSignInExceptionCode.clientConfigurationError ||
          error.code == GoogleSignInExceptionCode.providerConfigurationError;
      return AccountAuthException(
        configurationError
            ? AccountAuthFailure.configuration
            : AccountAuthFailure.unavailable,
      );
    }
    return const AccountAuthException(AccountAuthFailure.unknown);
  }

  String? _configuredValue(String value) =>
      value.trim().isEmpty ? null : value.trim();
}
