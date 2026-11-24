import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/app/localization/generated/app_localizations_en.dart';
import 'package:forza/app/localization/generated/app_localizations_es.dart';
import 'package:forza/domain/models/exercise.dart';
import 'package:forza/ui/features/exercises/models/exercise_guide_notes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'lateral raise notes are sourced and scoped to matching variations',
    () async {
      final decoded = jsonDecode(
        await rootBundle.loadString('assets/data/exercises.json'),
      ) as List<dynamic>;
      final exercises = decoded
          .cast<Map<String, Object?>>()
          .map(Exercise.fromJson)
          .toList(growable: false);
      final byId = {for (final exercise in exercises) exercise.id: exercise};

      for (final id in ['0178', '0192', '0334', '0355', '0396']) {
        final notes = ExerciseGuideNotes.forExercise(byId[id]!);
        expect(notes, isNotNull, reason: 'Expected a guide for exercise $id');
        expect(
          notes!.sourceUrl,
          'https://www.acefitness.org/resources/everyone/exercise-library/26/lateral-raise/',
        );
        expect(notes.commonMistakesFor(AppLocalizationsEs()), hasLength(3));
        expect(notes.commonMistakesFor(AppLocalizationsEn()), hasLength(3));
      }

      for (final id in ['0977', '0380']) {
        expect(
          ExerciseGuideNotes.forExercise(byId[id]!),
          isNull,
          reason: 'Front and rear raises are different movements',
        );
      }
    },
  );

  test(
    'guide inventory stays aligned with the documented catalog snapshot',
    () async {
      final decoded = jsonDecode(
        await rootBundle.loadString('assets/data/exercises.json'),
      ) as List<dynamic>;
      final exercises = decoded
          .cast<Map<String, Object?>>()
          .map(Exercise.fromJson)
          .toList(growable: false);
      final uncovered = exercises
          .where((exercise) => ExerciseGuideNotes.forExercise(exercise) == null)
          .toList(growable: false);
      final byGroup = <String, int>{};
      for (final exercise in uncovered) {
        byGroup.update(
          exercise.muscleGroup,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      expect(exercises, hasLength(1324));
      expect(uncovered, hasLength(815));
      expect(byGroup, {
        'Brazos': 176,
        'Core': 142,
        'Pecho': 120,
        'Piernas': 119,
        'Hombros': 116,
        'Espalda': 111,
        'Cardio': 29,
        'Cuello': 2,
      });
    },
  );
}
