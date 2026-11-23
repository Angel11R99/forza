CREATE TABLE IF NOT EXISTS "scheduled_training_sessions" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "scheduled_date" TEXT NOT NULL,
    "original_date" TEXT NULL,
    "session_index" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "focus" TEXT NOT NULL,
    "duration_minutes" INTEGER NOT NULL,
    "exercise_count" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending'
);

CREATE UNIQUE INDEX scheduled_training_sessions_date_idx
    ON scheduled_training_sessions (scheduled_date);
