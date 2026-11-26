import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/account_identity.dart';
import 'package:forza/domain/repositories/account_auth_repository.dart';
import 'package:forza/ui/features/onboarding/view_models/account_auth_view_model.dart';
import 'package:forza/ui/features/onboarding/views/account_access_pages.dart';

void main() {
  testWidgets('account is optional and no manual email form is shown', (
    tester,
  ) async {
    final repository = _FakeAccountAuthRepository();
    final viewModel = AccountAuthViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    addTearDown(repository.dispose);

    await tester.pumpWidget(_app(viewModel));
    await tester.pumpAndSettle();

    expect(find.text('An account is optional.'), findsOneWidget);
    expect(find.text('Continue without an account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Google access errors show actionable copy and allow retry', (
    tester,
  ) async {
    final repository = _FakeAccountAuthRepository()
      ..signInFailure = const AccountAuthException(
        AccountAuthFailure.configuration,
      );
    final viewModel = AccountAuthViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    addTearDown(repository.dispose);

    await tester.pumpWidget(_app(viewModel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Google sign-in could not start. Check the Android or iOS OAuth setup and try again.',
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );

    repository.signInFailure = null;
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Athlete One'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelled Google access leaves guest option available', (
    tester,
  ) async {
    final repository = _FakeAccountAuthRepository()..cancelSignIn = true;
    final viewModel = AccountAuthViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    addTearDown(repository.dispose);

    await tester.pumpWidget(_app(viewModel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Continue without an account'), findsOneWidget);
    expect(
      find.text('We couldn\'t complete sign-in. Try again.'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Google identity appears after sign in and disappears on sign out',
    (tester) async {
      final repository = _FakeAccountAuthRepository();
      final viewModel = AccountAuthViewModel(repository: repository);
      addTearDown(viewModel.dispose);
      addTearDown(repository.dispose);

      await tester.pumpWidget(_app(viewModel));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      expect(find.text('Athlete One'), findsOneWidget);
      expect(find.text('athlete@example.com'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out').last);
      await tester.pumpAndSettle();

      expect(find.text('Athlete One'), findsNothing);
      expect(find.text('Continue without an account'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _app(AccountAuthViewModel viewModel) => MaterialApp(
  theme: AppTheme.light,
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: AccountWelcomePage(accountAuthViewModel: viewModel),
);

class _FakeAccountAuthRepository implements AccountAuthRepository {
  final _changes = StreamController<AccountIdentity?>.broadcast();
  AccountIdentity? _account;
  AccountAuthException? signInFailure;
  bool cancelSignIn = false;

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
    if (cancelSignIn) return null;
    _account = const AccountIdentity(
      providerUserId: 'google-user',
      displayName: 'Athlete One',
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
