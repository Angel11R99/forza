ALTER TABLE training_plans
ADD COLUMN avoided_exercise_ids TEXT NOT NULL DEFAULT '[]';
