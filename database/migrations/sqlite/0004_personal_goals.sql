CREATE TABLE IF NOT EXISTS "personal_goals" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "type" TEXT NOT NULL,
    "target_value" REAL NOT NULL,
    "exercise_name" TEXT NULL,
    "created_at" TEXT NOT NULL
);
