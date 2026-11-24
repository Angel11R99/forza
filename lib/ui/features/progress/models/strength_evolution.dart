import '../../../../domain/models/workout_record.dart';

class StrengthEvolutionPoint {
  const StrengthEvolutionPoint({required this.date, required this.loadKg});

  final DateTime date;
  final double loadKg;
}

class StrengthEvolutionSeries {
  const StrengthEvolutionSeries({
    required this.exerciseKey,
    required this.exerciseName,
    required this.points,
  });

  final String exerciseKey;
  final String exerciseName;
  final List<StrengthEvolutionPoint> points;
}

/// Builds one point per completed workout using that workout's heaviest
/// positive logged load for the exercise. Duration-only and unlogged sets are
/// excluded because they cannot describe a comparable working weight.
List<StrengthEvolutionSeries> buildStrengthEvolutionSeries(
  List<WorkoutRecord> records, {
  required DateTime now,
  int? periodDays,
}) {
  final start = periodDays == null
      ? null
      : DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: periodDays - 1));
  final series = <String, _SeriesBuilder>{};

  for (final record in records) {
    if (start != null && record.date.isBefore(start)) continue;
    final maxPosition = record.setResults
        .where((set) => set.loadKg != null && set.loadKg! > 0)
        .fold<int>(
          -1,
          (max, set) => set.exercisePosition > max ? set.exercisePosition : max,
        );
    for (var position = 0; position <= maxPosition; position++) {
      if (position >= record.exercises.length) continue;
      final name = record.exercises[position].trim();
      if (name.isEmpty) continue;
      final exerciseId = position < record.exerciseIds.length
          ? record.exerciseIds[position]
          : null;
      final key = exerciseId == null || exerciseId.isEmpty
          ? 'name:${name.toLowerCase()}'
          : 'id:$exerciseId';
      final load = record.setResults
          .where(
            (set) =>
                set.exercisePosition == position &&
                set.loadKg != null &&
                set.loadKg!.isFinite &&
                set.loadKg! > 0,
          )
          .fold<double>(0, (max, set) => set.loadKg! > max ? set.loadKg! : max);
      if (load <= 0) continue;
      final builder = series.putIfAbsent(key, () => _SeriesBuilder(key, name));
      builder.add(record.date, load);
    }
  }

  final result = series.values.map((builder) => builder.build()).toList()
    ..sort((a, b) => a.exerciseName.compareTo(b.exerciseName));
  return result;
}

class _SeriesBuilder {
  _SeriesBuilder(this.key, this.name);

  final String key;
  final String name;
  final Map<DateTime, double> loadsByDate = {};

  void add(DateTime date, double load) {
    final day = DateTime(date.year, date.month, date.day);
    final current = loadsByDate[day] ?? 0;
    if (load > current) loadsByDate[day] = load;
  }

  StrengthEvolutionSeries build() {
    final points =
        loadsByDate.entries
            .map(
              (entry) =>
                  StrengthEvolutionPoint(date: entry.key, loadKg: entry.value),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return StrengthEvolutionSeries(
      exerciseKey: key,
      exerciseName: name,
      points: points,
    );
  }
}
