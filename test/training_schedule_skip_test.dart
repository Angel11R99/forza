import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/repositories/training_schedule_repository.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  test('skipping persists, stays out of history, and can be undone', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = TrainingScheduleRepository(database: database);
    const settings = TrainingSettings(
      trainingDays: {DateTime.monday},
      sessionMinutes: 45,
      goal: 'Ganar fuerza',
      experience: 'Estoy empezando',
      equipment: {'Peso corporal'},
    );
    final monday = DateTime(2026, 1, 5);

    await repository.ensureUpcoming(settings, from: monday, daysAhead: 0);
    expect(await repository.skip(monday), isTrue);
    expect((await repository.load()).single.isSkipped, isTrue);
    expect(await repository.skip(monday), isFalse);
    expect(await database.select(database.workoutSessions).get(), isEmpty);

    await repository.ensureUpcoming(settings, from: monday, daysAhead: 0);
    expect((await repository.load()).single.isSkipped, isTrue);

    expect(await repository.undoSkip(monday), isTrue);
    expect((await repository.load()).single.status, 'pending');
    expect(await repository.undoSkip(monday), isFalse);

    await repository.setStatus(monday, 'completed');
    expect(await repository.skip(monday), isFalse);
    await expectLater(
      repository.setStatus(monday, 'unknown'),
      throwsArgumentError,
    );
    await database.close();
  });
}
