import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../domain/models/account_identity.dart';
import '../../../../domain/repositories/account_auth_repository.dart';

class AccountAuthViewModel extends ChangeNotifier {
  AccountAuthViewModel({required this.repository}) {
    _accountSubscription = repository.accountChanges.listen((_) {
      notifyListeners();
    });
  }

  final AccountAuthRepository repository;
  late final StreamSubscription<AccountIdentity?> _accountSubscription;
  bool _isLoading = false;
  bool _hasRestored = false;
  AccountAuthFailure? _failure;

  AccountIdentity? get account => repository.currentAccount;
  bool get isLoading => _isLoading;
  AccountAuthFailure? get failure => _failure;

  Future<void> restore() async {
    if (_isLoading || _hasRestored) return;
    _hasRestored = true;
    _setLoading(true);
    try {
      await repository.restore();
      _failure = null;
    } on AccountAuthException catch (error) {
      _failure = error.failure;
    } on Object {
      _failure = AccountAuthFailure.unknown;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle({bool changeAccount = false}) async {
    if (_isLoading) return;
    _setLoading(true);
    try {
      if (changeAccount && account != null) await repository.signOut();
      await repository.signInWithGoogle();
      _failure = null;
    } on AccountAuthException catch (error) {
      _failure = error.failure;
    } on Object {
      _failure = AccountAuthFailure.unknown;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    if (_isLoading || account == null) return;
    _setLoading(true);
    try {
      await repository.signOut();
      _failure = null;
    } on AccountAuthException catch (error) {
      _failure = error.failure;
    } on Object {
      _failure = AccountAuthFailure.unknown;
    } finally {
      _setLoading(false);
    }
  }

  void clearFailure() {
    if (_failure == null) return;
    _failure = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_accountSubscription.cancel());
    super.dispose();
  }
}
