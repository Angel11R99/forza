import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/account_identity.dart';
import '../../domain/repositories/account_auth_repository.dart';
import '../../firebase_options.dart';

class GoogleAccountAuthRepository implements AccountAuthRepository {
  GoogleAccountAuthRepository({
    this.firebaseAuth,
    this.firestore,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  static const _androidServerClientId = String.fromEnvironment(
    'FORZA_GOOGLE_ANDROID_SERVER_CLIENT_ID',
  );

  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firestore;
  FirebaseAuth get _auth => firebaseAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _database => firestore ?? FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn;
  Future<void>? _initialization;
  StreamSubscription<User?>? _authSubscription;
  AccountIdentity? _currentAccount;

  @override
  AccountIdentity? get currentAccount => _currentAccount;

  @override
  Stream<AccountIdentity?> get accountChanges async* {
    yield _currentAccount;
    if (Firebase.apps.isNotEmpty || firebaseAuth != null) {
      yield* _auth.authStateChanges().map(_toIdentity);
    }
  }

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
    if (!kIsWeb) {
      await _googleSignIn.initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? DefaultFirebaseOptions.ios.iosClientId
            : defaultTargetPlatform == TargetPlatform.macOS
            ? DefaultFirebaseOptions.macos.iosClientId
            : null,
        serverClientId: defaultTargetPlatform == TargetPlatform.android
            ? _configuredValue(_androidServerClientId)
            : null,
      );
    }
    await _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((user) {
      _currentAccount = _toIdentity(user);
    });
    _currentAccount = _toIdentity(_auth.currentUser);
  }

  @override
  Future<AccountIdentity?> restore() async {
    await initialize();
    return _toIdentity(_auth.currentUser);
  }

  @override
  Future<AccountIdentity?> signInWithGoogle() async {
    await initialize();
    if (!kIsWeb && !_googleSignIn.supportsAuthenticate()) {
      throw const AccountAuthException(AccountAuthFailure.unavailable);
    }
    try {
      final UserCredential result;
      if (kIsWeb) {
        result = await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        final googleUser = await _googleSignIn.authenticate();
        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        result = await _auth.signInWithCredential(credential);
      }
      final user = result.user;
      if (user == null) return null;
      final userDocument = _database.collection('users').doc(user.uid);
      final existingUser = await userDocument.get();
      await userDocument.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'provider': 'google.com',
        'updatedAt': FieldValue.serverTimestamp(),
        if (!existingUser.exists) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _currentAccount = _toIdentity(user);
      return _currentAccount;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw _mapFailure(error);
    } on FirebaseAuthException catch (error) {
      throw _mapFailure(error);
    } on Object catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    await initialize();
    try {
      await _auth.signOut();
      if (!kIsWeb) await _googleSignIn.signOut();
      _currentAccount = null;
    } on Object catch (error) {
      throw _mapFailure(error);
    }
  }

  AccountIdentity? _toIdentity(User? user) => user == null
      ? null
      : AccountIdentity(
          providerUserId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );

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
    if (error is FirebaseAuthException) {
      return AccountAuthException(
        error.code == 'invalid-credential' ||
                error.code == 'operation-not-allowed'
            ? AccountAuthFailure.configuration
            : AccountAuthFailure.unavailable,
      );
    }
    return const AccountAuthException(AccountAuthFailure.unknown);
  }

  String? _configuredValue(String value) =>
      value.trim().isEmpty ? null : value.trim();
}
