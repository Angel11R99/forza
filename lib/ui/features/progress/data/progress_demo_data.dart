import '../models/progress_models.dart';

abstract final class ProgressDemoData {
  static List<WorkoutHistoryEntry> sessions(DateTime today) => [
    WorkoutHistoryEntry(
      id: 'session-1',
      title: 'Fuerza total',
      date: _dayBefore(today, 2),
      durationMinutes: 48,
      exerciseCount: 6,
      totalVolumeKg: 4320,
      exercises: const [
        'Sentadilla goblet',
        'Press con mancuernas',
        'Remo con mancuerna',
        'Peso muerto rumano',
        'Flexiones',
        'Plancha frontal',
      ],
    ),
    WorkoutHistoryEntry(
      id: 'session-2',
      title: 'Piernas y core',
      date: _dayBefore(today, 5),
      durationMinutes: 52,
      exerciseCount: 7,
      totalVolumeKg: 5180,
      exercises: const [
        'Sentadilla con barra',
        'Peso muerto rumano',
        'Plancha frontal',
        'Sentadilla goblet',
        'Jalón al pecho',
        'Press con mancuernas',
        'Peso muerto rumano',
      ],
    ),
    WorkoutHistoryEntry(
      id: 'session-3',
      title: 'Tren superior',
      date: _dayBefore(today, 8),
      durationMinutes: 44,
      exerciseCount: 6,
      totalVolumeKg: 3860,
      exercises: const [
        'Press de banca',
        'Jalón al pecho',
        'Press de hombros',
        'Remo con mancuerna',
        'Flexiones',
        'Sentadilla goblet',
      ],
    ),
    WorkoutHistoryEntry(
      id: 'session-4',
      title: 'Fuerza total',
      date: _dayBefore(today, 12),
      durationMinutes: 46,
      exerciseCount: 6,
      totalVolumeKg: 4070,
      exercises: const [
        'Sentadilla con barra',
        'Press con mancuernas',
        'Remo con mancuerna',
        'Plancha frontal',
        'Press de hombros',
        'Flexiones',
      ],
    ),
    WorkoutHistoryEntry(
      id: 'session-5',
      title: 'Tren superior',
      date: _dayBefore(today, 16),
      durationMinutes: 43,
      exerciseCount: 5,
      totalVolumeKg: 3620,
      exercises: const [
        'Press de banca',
        'Jalón al pecho',
        'Press de hombros',
        'Flexiones',
        'Plancha frontal',
      ],
    ),
  ];

  static List<PersonalRecord> records(DateTime today) => [
    PersonalRecord(
      exercise: 'Press de banca',
      value: 67.5,
      unit: 'kg',
      date: _dayBefore(today, 8),
    ),
    PersonalRecord(
      exercise: 'Sentadilla con barra',
      value: 85,
      unit: 'kg',
      date: _dayBefore(today, 12),
    ),
    PersonalRecord(
      exercise: 'Peso muerto rumano',
      value: 95,
      unit: 'kg',
      date: _dayBefore(today, 16),
    ),
    PersonalRecord(
      exercise: 'Plancha frontal',
      value: 90,
      unit: 'seg',
      date: _dayBefore(today, 21),
    ),
  ];

  static DateTime _dayBefore(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day - days);
}
