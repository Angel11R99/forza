import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/body_measurement.dart';
import 'package:forza/ui/features/progress/views/progress_detail_pages.dart';

void main() {
  testWidgets('shows empty state and validates the required weight', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        theme: AppTheme.light,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: BodyEvolutionPage(
          measurements: const [],
          onSaveMeasurement: (_, {previous}) async {
            throw StateError('save failed');
          },
          onDeleteMeasurement: (_) async {},
        ),
      ),
    );

    expect(find.textContaining('Aún no hay medidas'), findsOneWidget);
    await tester.tap(find.text('Registrar medidas'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));

    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar registro'));
    await tester.tap(find.text('Guardar registro'));
    await tester.pumpAndSettle();
    expect(find.text('Ingresa el peso corporal.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '70');
    await tester.tap(find.text('Guardar registro'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      '70',
    );
    expect(
      find.text('No se pudo guardar el registro. Inténtalo de nuevo.'),
      findsOneWidget,
    );

    tester.view.physicalSize = const Size(812, 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('edits and deletes a persisted measurement entry', (
    tester,
  ) async {
    final date = DateTime.now().subtract(const Duration(days: 2));
    final initial = BodyMeasurement(
      date: DateTime(date.year, date.month, date.day),
      weightKg: 72.4,
      waistCm: 84,
    );
    BodyMeasurement? saved;
    BodyMeasurement? prior;
    DateTime? deleted;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        theme: AppTheme.light,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: BodyEvolutionPage(
          measurements: [initial],
          onSaveMeasurement: (entry, {previous}) async {
            saved = entry;
            prior = previous;
          },
          onDeleteMeasurement: (entryDate) async => deleted = entryDate,
        ),
      ),
    );

    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Editar medida'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar medida'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      '72.4',
    );
    await tester.enterText(find.byType(TextFormField).first, '70');
    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar registro'));
    await tester.tap(find.text('Guardar registro'));
    await tester.pumpAndSettle();
    expect(saved?.weightKg, 70);
    expect(prior?.id, initial.id);
    expect(find.text('70.0 kg'), findsNWidgets(2));

    await tester.drag(find.byType(ListView).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Eliminar medida'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Eliminar medida'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retirar'));
    await tester.pumpAndSettle();
    expect(deleted, initial.date);
    expect(find.textContaining('Aún no hay medidas'), findsOneWidget);
  });
}
