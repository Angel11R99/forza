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
  testWidgets('profile summary reflects preferences loaded from storage', (
    WidgetTester tester,
  ) async {
    final storage = _MemoryProfilePreferencesStorage();
    final repository = ProfileSettingsRepository(storage: storage);
    await repository.saveAppPreferences(
      const AppPreferences(
        weightUnit: 'lb',
        weekStartsOn: 'Domingo',
        hapticsEnabled: false,
      ),
    );
    await repository.saveNotifications(
      const NotificationSettings(
        workoutReminders: true,
        reminderHour: 7,
        reminderMinute: 35,
      ),
    );
    await repository.savePrivacy(const PrivacySettings(privateProfile: false));
    final locale = LocaleController(
      repository: LocaleRepository(_MemoryLocalePreferences()),
    );
    final accountAuth = AccountAuthViewModel(
      repository: _GuestAccountAuthRepository(),
    );

    await tester.pumpWidget(_app(repository, locale, accountAuth));
    await tester.pumpAndSettle();

    expect(find.text('No account'), findsOneWidget);
    expect(find.text('FORZA athlete'), findsNothing);
    expect(find.text('AF'), findsNothing);
    expect(find.text('Edit profile'), findsNothing);
    expect(find.textContaining('Weight lb'), findsOneWidget);
    expect(find.textContaining('week starts Sunday'), findsOneWidget);
    expect(find.textContaining('haptics off'), findsOneWidget);
    expect(find.textContaining('Reminder at 7:35'), findsOneWidget);
    expect(find.text('Visible profile'), findsNothing);
    locale.dispose();
    accountAuth.dispose();
  });

  testWidgets('guest profile links to Google sign in and keeps local options', (
    tester,
  ) async {
    final profileRepository = ProfileSettingsRepository(
      storage: _MemoryProfilePreferencesStorage(),
    );
    final locale = LocaleController(
      repository: LocaleRepository(_MemoryLocalePreferences()),
    );
    final accountAuth = AccountAuthViewModel(
      repository: _GuestAccountAuthRepository(),
    );
    addTearDown(locale.dispose);
    addTearDown(accountAuth.dispose);

    await tester.pumpWidget(
      _app(profileRepository, locale, accountAuth, localeCode: 'es'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sin cuenta'), findsOneWidget);
    expect(
      find.text('Sin cuenta · datos guardados en este dispositivo'),
      findsOneWidget,
    );
    expect(find.text('Atleta FORZA'), findsNothing);
    expect(find.text('AF'), findsNothing);
    expect(find.text('Editar perfil'), findsNothing);
    expect(find.text('Privacidad'), findsNothing);
    expect(find.text('Mi plan de entrenamiento'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsWidgets);

    await tester.tap(find.text('Continuar con Google'));
    await tester.pumpAndSettle();
    expect(find.text('Una cuenta es opcional.'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'authenticated profile uses provider identity and signs out safely',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final storage = _MemoryProfilePreferencesStorage();
      final profileRepository = ProfileSettingsRepository(storage: storage);
      await profileRepository.saveAppPreferences(
        const AppPreferences(weightUnit: 'lb'),
      );
      final locale = LocaleController(
        repository: LocaleRepository(_MemoryLocalePreferences()),
      );
      final accountAuth = AccountAuthViewModel(
        repository: _GuestAccountAuthRepository(
          account: const AccountIdentity(
            providerUserId: 'google-user',
            email: 'ana@example.com',
          ),
        ),
      );
      addTearDown(locale.dispose);
      addTearDown(accountAuth.dispose);

      await tester.pumpWidget(
        _app(
          profileRepository,
          locale,
          accountAuth,
          localeCode: 'en',
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ana@example.com'), findsOneWidget);
      expect(find.text('Connected with Google'), findsOneWidget);
      expect(find.text('FORZA athlete'), findsNothing);
      expect(find.text('AF'), findsNothing);
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.textContaining('Build strength'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsWidgets);

      await tester.tap(find.text('Account and access'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out').last);
      await tester.pumpAndSettle();
      expect(find.text('Continue with Google'), findsOneWidget);
      Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
      await tester.pumpAndSettle();

      expect(find.text('No account'), findsOneWidget);
      expect(find.text('ana@example.com'), findsNothing);
      expect(find.text('Edit profile'), findsNothing);
      expect(find.textContaining('Weight lb'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _app(
  ProfileSettingsRepository repository,
  LocaleController locale,
  AccountAuthViewModel accountAuth, {
  String localeCode = 'en',
  Brightness brightness = Brightness.light,
}) => MaterialApp(
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
    accountAuthViewModel: accountAuth,
    profileSettingsRepository: repository,
    themeMode: ThemeMode.system,
    onThemeModeChanged: (_) async {},
    onManageBackups: () {},
    localeController: locale,
  ),
);

class _GuestAccountAuthRepository implements AccountAuthRepository {
  _GuestAccountAuthRepository({this.account});

  AccountIdentity? account;

  @override
  AccountIdentity? get currentAccount => account;

  @override
  Stream<AccountIdentity?> get accountChanges =>
      const Stream<AccountIdentity?>.empty();

  @override
  Future<void> initialize() async {}

  @override
  Future<AccountIdentity?> restore() async => account;

  @override
  Future<AccountIdentity?> signInWithGoogle() async => account;

  @override
  Future<void> signOut() async => account = null;
}

class _MemoryProfilePreferencesStorage implements ProfilePreferencesStorage {
  final Map<String, String> values = {};

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
