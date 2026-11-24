import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/ui/features/exercises/widgets/exercise_flip_card.dart';

void main() {
  testWidgets('tap flips to the information and back without mirroring it', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('exercise-flip-card')));
    await tester.pumpAndSettle();

    expect(find.text('GIF preview'), findsNothing);
    expect(find.text('Exercise information'), findsOneWidget);
    final semantics = tester
        .getSemantics(find.byKey(const Key('exercise-flip-card-semantics')))
        .getSemanticsData();
    expect(semantics.label, contains('Exercise information'));
    expect(semantics.hint, 'Tap or swipe to return to the GIF');
    expect(semantics.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byKey(const Key('exercise-flip-card')));
    await tester.pumpAndSettle();
    expect(find.text('GIF preview'), findsOneWidget);
    expect(find.text('Exercise information'), findsNothing);
  });

  testWidgets('horizontal swipes flip both ways, vertical scroll does not', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final card = find.byKey(const Key('exercise-flip-card'));

    await tester.drag(card, const Offset(-90, 0));
    await tester.pumpAndSettle();
    expect(find.text('Exercise information'), findsOneWidget);

    await tester.drag(card, const Offset(90, 0));
    await tester.pumpAndSettle();
    expect(find.text('GIF preview'), findsOneWidget);

    await tester.drag(card, const Offset(0, -90));
    await tester.pumpAndSettle();
    expect(find.text('GIF preview'), findsOneWidget);
  });

  testWidgets('reduced motion changes faces without a 3D animation', (
    tester,
  ) async {
    await tester.pumpWidget(_app(reduceMotion: true));
    await tester.tap(find.byKey(const Key('exercise-flip-card')));
    await tester.pump();

    expect(find.text('GIF preview'), findsNothing);
    expect(find.text('Exercise information'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _app({bool reduceMotion = false}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: ExerciseFlipCard(
          key: const Key('exercise-flip-card'),
          frontHint: 'Tap or swipe to see details',
          backHint: 'Tap or swipe to return to the GIF',
          front: const SizedBox(
            width: 220,
            height: 220,
            child: ColoredBox(
              color: Colors.black,
              child: Center(child: Text('GIF preview')),
            ),
          ),
          back: const SizedBox(
            width: 220,
            height: 220,
            child: ColoredBox(
              color: Colors.white,
              child: Center(child: Text('Exercise information')),
            ),
          ),
        ),
      ),
    ),
  ),
);
