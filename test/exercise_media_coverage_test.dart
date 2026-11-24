import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/repositories/demo_exercise_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'catalog media coverage has licensed matches and explicit fallbacks',
    () async {
      final repository = DemoExerciseRepository.instance;
      await repository.load();
      final exercises = repository.search();
      final animated = exercises.where(
        (exercise) => exercise.animation != null,
      );
      final withoutAnimation = exercises.where(
        (exercise) => exercise.animation == null,
      );

      expect(exercises, hasLength(1324));
      expect(
        exercises.every((exercise) => exercise.target?.isNotEmpty ?? false),
        isTrue,
      );
      expect(
        exercises.every((exercise) => exercise.secondaryMuscles.isNotEmpty),
        isTrue,
      );
      expect(animated, hasLength(1260));
      expect(withoutAnimation, hasLength(64));

      for (final id in ['2141', '1429', '0859']) {
        final exercise = repository.findById(id)!;
        final animation = exercise.animation!;
        expect(animation.frames, hasLength(2));
        for (final frame in animation.frames) {
          await rootBundle.load(frame);
        }
      }

      final raw = jsonDecode(
        await rootBundle.loadString('assets/data/exercises.json'),
      ) as List<dynamic>;
      for (final id in ['2141', '1429', '0859']) {
        final item = raw.cast<Map<String, dynamic>>().singleWhere(
          (exercise) => exercise['id'] == id,
        );
        expect(item['animation']['license'], 'CC0-1.0');
        expect(item['animation']['attribution'], contains('Marvin Nazari'));
        expect(item['animation']['source'], contains('2786aefa4b36a08f'));
      }
    },
  );
}
