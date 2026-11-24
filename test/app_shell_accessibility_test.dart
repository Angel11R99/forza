import 'dart:ui' show Tristate;

import 'package:drift/native.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/theme/appearance_controller.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/migrations/legacy_shared_preferences_migration.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/data/repositories/training_settings_repository.dart';
import 'package:forza/ui/core/view_models/app_shell_view_model.dart';
import 'package:forza/ui/core/widgets/app_scaffold.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets(
    'bottom navigation remains accessible at 320 px with large text and reduced motion',
    (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final database = AppDatabase(NativeDatabase.memory());
      final settingsRepository = TrainingSettingsRepository(database: database);
      await settingsRepository.save(const TrainingSettings());
      await settingsRepository.completeSetup();
      await database
          .into(database.appMetadata)
          .insert(
            AppMetadataCompanion.insert(
              key: LegacySharedPreferencesMigration.migrationKey,
              value: 'true',
            ),
          );
      final viewModel = AppShellViewModel(
        database: database,
        settingsRepository: settingsRepository,
      );
      await viewModel.restore();
      final semanticsHandle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2),
              disableAnimations: true,
            ),
            child: AppScaffold(
              appearance: AppearanceController(
                preferences: _MemoryAppearancePreferences(),
              ),
              localeController: LocaleController(
                repository: LocaleRepository(_MemoryLocalePreferences()),
              ),
              profileSettingsRepository: ProfileSettingsRepository(
                storage: _MemoryProfileSettingsStorage(),
              ),
              viewModel: viewModel,
            ),
          ),
        ),
      );

      Finder activityDestination = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Actividad',
      );
      for (
        var attempt = 0;
        attempt < 20 && activityDestination.evaluate().isEmpty;
        attempt++
      ) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pump();
      }

      expect(activityDestination, findsOneWidget);
      final activitySemantics = find.semantics.byPredicate(
        (node) => node.label == 'Actividad' && node.flagsCollection.isButton,
      );
      expect(activitySemantics, findsOneWidget);
      expect(
        activitySemantics.evaluate().single.flagsCollection.isButton,
        isTrue,
      );
      expect(
        activitySemantics.evaluate().single.getSemanticsData().hasAction(
          SemanticsAction.tap,
        ),
        isTrue,
      );
      expect(
        activitySemantics.evaluate().single.rect.height,
        greaterThanOrEqualTo(48),
      );

      await tester.tap(activityDestination);
      await tester.pump();
      expect(
        activitySemantics.evaluate().single.flagsCollection.isSelected,
        Tristate.isTrue,
      );
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(800, 320);
      await tester.pump();
      expect(tester.takeException(), isNull);

      semanticsHandle.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      await database.close();
    },
  );
}

class _MemoryAppearancePreferences implements AppearancePreferences {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _MemoryLocalePreferences implements LocalePreferences {
  @override
  Future<String?> readLocale() async => null;

  @override
  Future<void> writeLocale(String? languageCode) async {}
}

class _MemoryProfileSettingsStorage implements ProfilePreferencesStorage {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}
