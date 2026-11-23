CREATE TABLE IF NOT EXISTS "workout_set_entries" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "session_id" TEXT NOT NULL REFERENCES workout_sessions (id) ON DELETE CASCADE,
    "exercise_position" INTEGER NOT NULL,
    "set_index" INTEGER NOT NULL,
    "repetitions" INTEGER NULL,
    "load_kg" REAL NULL,
    "duration_seconds" INTEGER NULL,
    UNIQUE ("session_id", "exercise_position", "set_index")
);