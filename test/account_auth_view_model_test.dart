import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/account_identity.dart';
import 'package:forza/domain/repositories/account_auth_repository.dart';
import 'package:forza/ui/features/onboarding/view_models/account_auth_view_model.dart';

void main() {
  test('Google sign in and sign out leave guest mode available', () async {
    final repository = _FakeAccountAuthRepository();
    final viewModel = AccountAuthViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    addTearDown(repository.dispose);

    await viewModel.restore();
    expect(viewModel.account, isNull);

    await viewModel.signInWithGoogle();
    expect(viewModel.account?.email, 'athlete@example.com');

    await viewModel.signOut();
    expect(viewModel.account, isNull);
    expect(viewModel.failure, isNull);
  });

  test('failed sign in exposes a recoverable failure and can retry', () async {
    final repository = _FakeAccountAuthRepository()
      ..signInFailure = const AccountAuthException(
        AccountAuthFailure.configuration,
      );
    final viewModel = AccountAuthViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    addTearDown(repository.dispose);

    await viewModel.signInWithGoogle();
    expect(viewModel.failure, AccountAuthFailure.configuration);

    repository.signInFailure = null;
    await viewModel.signInWithGoogle();
    expect(viewModel.account?.displayName, 'Atleta');
    expect(viewModel.failure, isNull);
  });
}

class _FakeAccountAuthRepository implements AccountAuthRepository {
  final _changes = StreamController<AccountIdentity?>.broadcast();
  AccountIdentity? _account;
  AccountAuthException? signInFailure;

  @override
  AccountIdentity? get currentAccount => _account;

  @override
  Stream<AccountIdentity?> get accountChanges => _changes.stream;

  @override
  Future<void> initialize() async {}

  @override
  Future<AccountIdentity?> restore() async => _account;

  @override
  Future<AccountIdentity?> signInWithGoogle() async {
    final failure = signInFailure;
    if (failure != null) throw failure;
    _account = const AccountIdentity(
      providerUserId: 'google-user',
      displayName: 'Atleta',
      email: 'athlete@example.com',
    );
    _changes.add(_account);
    return _account;
  }

  @override
  Future<void> signOut() async {
    _account = null;
    _changes.add(null);
  }

  Future<void> dispose() => _changes.close();
}
