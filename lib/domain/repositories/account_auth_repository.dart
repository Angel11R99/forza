import '../models/account_identity.dart';

enum AccountAuthFailure { configuration, unavailable, unknown }

class AccountAuthException implements Exception {
  const AccountAuthException(this.failure);

  final AccountAuthFailure failure;
}

abstract interface class AccountAuthRepository {
  AccountIdentity? get currentAccount;

  Stream<AccountIdentity?> get accountChanges;

  Future<void> initialize();

  Future<AccountIdentity?> restore();

  Future<AccountIdentity?> signInWithGoogle();

  Future<void> signOut();
}
