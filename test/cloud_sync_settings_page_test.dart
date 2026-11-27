import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/data/services/firestore_backup_sync_service.dart';
import 'package:forza/domain/models/account_identity.dart';
import 'package:forza/ui/features/profile/views/cloud_sync_settings_page.dart';

void main() {
  testWidgets(
    'nutrition sync consent stays usable at narrow width, large text and both themes',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final locale in [const Locale('en'), const Locale('es')]) {
        for (final dark in [false, true]) {
          final repository = ProfileSettingsRepository(
            storage: _MemoryStorage(),
          );
          await repository.setCloudSyncEnabled('uid-test', true);
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: dark ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: [
                ...AppLocalizations.localizationsDelegates,
                ...GlobalMaterialLocalizations.delegates,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: CloudSyncSettingsPage(
                service: _FakeCloudSyncController(),
                settingsRepository: repository,
                uid: 'uid-test',
                account: const AccountIdentity(
                  providerUserId: 'uid-test',
                  email: 'user@example.test',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          final nutritionTitle = locale.languageCode == 'es'
              ? 'Sincronizar datos de nutrición'
              : 'Sync nutrition data';
          final titleFinder = find.text(nutritionTitle);
          for (
            var attempt = 0;
            attempt < 6 && titleFinder.evaluate().isEmpty;
            attempt++
          ) {
            await tester.drag(
              find.byType(ListView).first,
              const Offset(0, -380),
            );
            await tester.pumpAndSettle();
          }
          expect(titleFinder, findsOneWidget);
          await tester.ensureVisible(titleFinder);
          await tester.pumpAndSettle();
          final nutritionSwitch = find.ancestor(
            of: titleFinder,
            matching: find.byType(SwitchListTile),
          );
          final semantics = tester
              .getSemantics(nutritionSwitch)
              .getSemanticsData();
          expect(semantics.flagsCollection.isToggled, Tristate.isFalse);
          expect(semantics.hasAction(SemanticsAction.tap), isTrue);
          final switchBox = tester.renderObject(nutritionSwitch) as RenderBox;
          expect(switchBox.size.height, greaterThanOrEqualTo(48));
          expect(
            await repository.isNutritionCloudSyncEnabled('uid-test'),
            isFalse,
          );
        }
      }

      tester.view.physicalSize = const Size(720, 320);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'nutrition sync is enabled only after the separate consent dialog',
    (tester) async {
      final repository = ProfileSettingsRepository(storage: _MemoryStorage());
      await repository.setCloudSyncEnabled('uid-test', true);
      await tester.pumpWidget(_app(repository, _FakeCloudSyncController()));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      final nutritionSwitch = find.ancestor(
        of: find.text('Sync nutrition data'),
        matching: find.byType(SwitchListTile),
      );
      await tester.ensureVisible(find.text('Sync nutrition data'));
      await tester.pumpAndSettle();
      final switchSemantics = tester
          .getSemantics(nutritionSwitch)
          .getSemanticsData();
      expect(switchSemantics.flagsCollection.isToggled, Tristate.isFalse);
      expect(switchSemantics.hasAction(SemanticsAction.tap), isTrue);
      await tester.tap(nutritionSwitch);
      await tester.pumpAndSettle();
      expect(find.text('Sync nutrition data?'), findsOneWidget);
      expect(await repository.isNutritionCloudSyncEnabled('uid-test'), isFalse);

      await tester.tap(find.text('Allow nutrition sync'));
      await tester.pumpAndSettle();
      expect(await repository.isNutritionCloudSyncEnabled('uid-test'), isTrue);

      await tester.tap(nutritionSwitch);
      await tester.pumpAndSettle();
      expect(await repository.isNutritionCloudSyncEnabled('uid-test'), isFalse);

      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete nutrition copy from cloud'));
      await tester.pumpAndSettle();
      expect(find.text('Delete cloud nutrition data?'), findsOneWidget);
      await tester.tap(find.text('Delete nutrition copy from cloud').last);
      await tester.pumpAndSettle();
      expect(
        find.text('Nutrition data was removed from the cloud backup.'),
        findsOneWidget,
      );
    },
  );
}

Widget _app(
  ProfileSettingsRepository repository,
  CloudSyncSettingsController controller,
) => MaterialApp(
  locale: const Locale('en'),
  theme: AppTheme.light,
  localizationsDelegates: [
    ...AppLocalizations.localizationsDelegates,
    ...GlobalMaterialLocalizations.delegates,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: CloudSyncSettingsPage(
    service: controller,
    settingsRepository: repository,
    uid: 'uid-test',
    account: const AccountIdentity(
      providerUserId: 'uid-test',
      email: 'user@example.test',
    ),
  ),
);

class _FakeCloudSyncController extends ChangeNotifier
    implements CloudSyncSettingsController {
  @override
  CloudSyncStatus get status => const CloudSyncStatus(CloudSyncPhase.synced);

  @override
  Future<void> retryNow() async {}

  @override
  Future<void> deleteRemoteData() async {}

  @override
  Future<bool> deleteRemoteNutritionData() async => true;
}

class _MemoryStorage implements ProfilePreferencesStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
