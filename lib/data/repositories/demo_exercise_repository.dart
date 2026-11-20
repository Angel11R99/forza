import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class DemoExerciseRepository implements ExerciseRepository {
  DemoExerciseRepository._();

  static final instance = DemoExerciseRepository._();
  static const _assetPath = 'assets/data/exercises.json';

  List<Exercise>? _entries;
  Future<void>? _loadOperation;

  @override
  bool get isLoaded => _entries != null;

  @override
  Future<void> load() async {
    if (_entries != null) return;

    final existingOperation = _loadOperation;
    if (existingOperation != null) return existingOperation;

    final operation = _readAsset();
    _loadOperation = operation;
    try {
      await operation;
    } on Object {
      _loadOperation = null;
      rethrow;
    }
  }

  Future<void> _readAsset() async {
    final source = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(source);
    if (decoded is! List<dynamic>) {
      throw const FormatException('El catálogo debe ser una lista JSON.');
    }

    _entries = List<Exercise>.unmodifiable(
      decoded.map((entry) => Exercise.fromJson(_asObject(entry))),
    );
  }

  Map<String, Object?> _asObject(Object? value) {
    if (value is! Map) {
      throw const FormatException('Un ejercicio del catálogo no es un objeto.');
    }
    return Map<String, Object?>.from(value);
  }

  List<Exercise> get _loadedEntries {
    final entries = _entries;
    if (entries == null) {
      throw StateError('Llama a load() antes de consultar el catálogo.');
    }
    return entries;
  }

  @override
  List<String> get muscleGroups =>
      _loadedEntries.map((exercise) => exercise.muscleGroup).toSet().toList()
        ..sort();

  @override
  List<String> get equipmentTypes =>
      _loadedEntries.map((exercise) => exercise.equipment).toSet().toList()
        ..sort();

  @override
  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  }) {
    final normalizedQuery = _foldForSearch(query);
    return _loadedEntries
        .where((exercise) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              _foldForSearch(exercise.name).contains(normalizedQuery) ||
              _foldForSearch(exercise.muscleGroup).contains(normalizedQuery) ||
              _foldForSearch(exercise.equipment).contains(normalizedQuery);
          final matchesMuscle =
              muscleGroups.isEmpty ||
              muscleGroups.contains(exercise.muscleGroup);
          final matchesEquipment =
              equipment.isEmpty || equipment.contains(exercise.equipment);
          return matchesQuery && matchesMuscle && matchesEquipment;
        })
        .toList(growable: false);
  }

  @override
  Exercise? findById(String id) {
    for (final exercise in _loadedEntries) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  @override
  List<Exercise> alternativesFor(Exercise exercise) {
    final byId = exercise.alternativeIds
        .map(findById)
        .whereType<Exercise>()
        .toList(growable: false);
    if (byId.isNotEmpty) return byId;

    return _loadedEntries
        .where(
          (candidate) =>
              candidate.id != exercise.id &&
              candidate.muscleGroup == exercise.muscleGroup,
        )
        .take(12)
        .toList(growable: false);
  }
}

String _foldForSearch(String value) => value
    .trim()
    .toLowerCase()
    .replaceAll(RegExp('[áàäâ]'), 'a')
    .replaceAll(RegExp('[éèëê]'), 'e')
    .replaceAll(RegExp('[íìïî]'), 'i')
    .replaceAll(RegExp('[óòöô]'), 'o')
    .replaceAll(RegExp('[úùüû]'), 'u')
    .replaceAll('ñ', 'n');
