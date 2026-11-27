import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/domain/models/account_identity.dart';
import 'package:forza/domain/repositories/account_auth_repository.dart';
import 'package:forza/ui/features/onboarding/view_models/account_auth_view_model.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'package:forza/ui/features/profile/views/profile_view.dart';

void main() {
  testWidgets(
    'Google name is shown and email stays read-only in profile edit',
    (tester) async {
      final harness = _ProfileHarness(
        account: const AccountIdentity(
          providerUserId: 'uid-one',
          displayName: 'Ana Rivera',
          email: 'ana@example.com',
        ),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      expect(find.text('Ana Rivera'), findsOneWidget);
      expect(find.text('ana@example.com'), findsOneWidget);

      await tester.tap(find.text('Edit profile'));
      await tester.pumpAndSettle();
      final fields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );
      expect(fields, hasLength(2));
      expect(fields.first.controller!.text, 'Ana Rivera');
      expect(fields.last.initialValue, 'ana@example.com');
      expect(
        find.text('This display name is saved on this device only.'),
        findsOneWidget,
      );
      final emailField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField).last,
          matching: find.byType(TextField),
        ),
      );
      expect(emailField.readOnly, isTrue);
      expect(find.text('Goal'), findsNothing);
    },
  );

  testWidgets('missing Google name remains optional and input is validated', (
    tester,
  ) async {
    final harness = _ProfileHarness(
      account: const AccountIdentity(
        providerUserId: 'uid-no-name',
        email: 'athlete@example.com',
      ),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    expect(find.text('athlete@example.com'), findsOneWidget);
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      isEmpty,
    );
    await tester.enterText(find.byType(TextFormField).first, 'A' * 81);
    await tester.tap(find.text('Review changes'));
    await tester.pumpAndSettle();
    expect(find.text('Name must be 80 characters or fewer.'), findsOneWidget);
    expect(find.text('Review profile'), findsNothing);
  });

  testWidgets(
    'custom name is scoped to its account and Google name can be restored',
    (tester) async {
      final harness = _ProfileHarness(
        localeCode: 'es',
        brightness: Brightness.dark,
        account: const AccountIdentity(
          providerUserId: 'uid-one',
          displayName: 'Ana Rivera',
          email: 'ana@example.com',
        ),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar perfil'));
      await tester.pumpAndSettle();
      expect(
        find.text('Este nombre visible se guarda solo en este dispositivo.'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextFormField).first,
        '  Ana María Álvarez  ',
      );
      await tester.tap(find.text('Revisar cambios'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar perfil'));
      await tester.pumpAndSettle();
      expect(find.text('Ana María Álvarez'), findsOneWidget);
      expect(
        await harness.settings.loadProfileDisplayName('uid-one'),
        'Ana María Álvarez',
      );

      harness.authRepository.setAccount(
        const AccountIdentity(
          providerUserId: 'uid-two',
          displayName: 'Luis Gómez',
          email: 'luis@example.com',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Luis Gómez'), findsOneWidget);
      expect(find.text('Ana María Álvarez'), findsNothing);

      harness.authRepository.setAccount(
        const AccountIdentity(
          providerUserId: 'uid-one',
          displayName: 'Ana Rivera',
          email: 'ana@example.com',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ana María Álvarez'), findsOneWidget);

      await tester.tap(find.text('Editar perfil'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Usar nombre de Google'));
      await tester.tap(find.text('Revisar cambios'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar perfil'));
      await tester.pumpAndSettle();
      expect(find.text('Ana Rivera'), findsOneWidget);
      expect(await harness.settings.loadProfileDisplayName('uid-one'), isNull);
    },
  );
}

class _ProfileHarness {
  _ProfileHarness({
    required AccountIdentity account,
    this.localeCode = 'en',
    this.brightness = Brightness.light,
  }) : authRepository = _MutableAccountRepository(account),
       settings = ProfileSettingsRepository(
         storage: _MemoryProfileSettingsStorage(),
       ),
       localeController = LocaleController(
         repository: LocaleRepository(_MemoryLocalePreferences()),
       ) {
    auth = AccountAuthViewModel(repository: authRepository);
  }

  final _MutableAccountRepository authRepository;
  final ProfileSettingsRepository settings;
  final LocaleController localeController;
  final String localeCode;
  final Brightness brightness;
  late final AccountAuthViewModel auth;

  Widget app() => MaterialApp(
    theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
    locale: Locale(localeCode),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: ProfileView(
      trainingSettings: const TrainingSettings(),
      onTrainingSettingsChanged: (_) {},
      profileSettingsRepository: settings,
      accountAuthViewModel: auth,
      themeMode: ThemeMode.system,
      onThemeModeChanged: (_) async {},
      onManageBackups: () {},
      localeController: localeController,
    ),
  );

  void dispose() {
    auth.dispose();
    authRepository.dispose();
    localeController.dispose();
  }
}

class _MutableAccountRepository implements AccountAuthRepository {
  _MutableAccountRepository(this._account);

  final _changes = StreamController<AccountIdentity?>.broadcast();
  AccountIdentity? _account;

  @override
  AccountIdentity? get currentAccount => _account;

  @override
  Stream<AccountIdentity?> get accountChanges => _changes.stream;

  @override
  Future<void> initialize() async {}

  @override
  Future<AccountIdentity?> restore() async => _account;

  @override
  Future<AccountIdentity?> signInWithGoogle() async => _account;

  @override
  Future<void> signOut() async => setAccount(null);

  void setAccount(AccountIdentity? account) {
    _account = account;
    _changes.add(account);
  }

  Future<void> dispose() => _changes.close();
}

class _MemoryProfileSettingsStorage implements ProfilePreferencesStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

class _MemoryLocalePreferences implements LocalePreferences {
  @override
  Future<String?> readLocale() async => null;

  @override
  Future<void> writeLocale(String? languageCode) async {}
}
