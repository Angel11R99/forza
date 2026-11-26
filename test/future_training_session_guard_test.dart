import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/ui/core/view_models/app_shell_view_model.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'support/shared_preferences_async_test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupSharedPreferencesAsyncForTest();
  test(
    'application state refuses to start a future scheduled session',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final viewModel = AppShellViewModel(database: database);
      try {
        await viewModel.restore();
        final now = DateTime.now();
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        await viewModel.saveTrainingSettings(
          TrainingSettings(
            trainingDays: {tomorrow.weekday},
            equipment: const {'Peso corporal'},
          ),
        );

        expect(await viewModel.markSessionStarted(tomorrow), isFalse);
        final session = viewModel.scheduledSessions.singleWhere(
          (session) =>
              session.scheduledDate.year == tomorrow.year &&
              session.scheduledDate.month == tomorrow.month &&
              session.scheduledDate.day == tomorrow.day,
        );
        expect(session.status, 'pending');
        expect(viewModel.hasActiveWorkout, isFalse);
      } finally {
        viewModel.dispose();
        await database.close();
      }
    },
  );
}
