ALTER TABLE training_plans ADD COLUMN version INTEGER NOT NULL DEFAULT 1;
ALTER TABLE workout_sessions ADD COLUMN plan_version INTEGER NOT NULL DEFAULT 1;
ALTER TABLE workout_sessions ADD COLUMN plan_snapshot TEXT;
ALTER TABLE workout_session_exercises ADD COLUMN catalog_id TEXT;
ALTER TABLE scheduled_training_sessions ADD COLUMN plan_version INTEGER NOT NULL DEFAULT 1;
ALTER TABLE scheduled_training_sessions ADD COLUMN plan_snapshot TEXT NOT NULL DEFAULT '';
