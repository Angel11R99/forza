CREATE TABLE IF NOT EXISTS "body_measurements" (
  "measurement_date" TEXT NOT NULL,
  "weight_kg" REAL NOT NULL,
  "chest_cm" REAL NULL,
  "waist_cm" REAL NULL,
  "hips_cm" REAL NULL,
  "arm_cm" REAL NULL,
  PRIMARY KEY ("measurement_date")
);

CREATE UNIQUE INDEX "body_measurements_date_idx" ON "body_measurements" ("measurement_date");