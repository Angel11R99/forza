# Exercise dataset provenance

- Source: [jlfernandezfernandez/exercises-dataset-es](https://github.com/jlfernandezfernandez/exercises-dataset-es), pinned at commit `5a5dd652f102c34bb09fcb0db3c2f3ae4dd53cbe`.
- English names and instructions: [hasaneyldrm/exercises-dataset](https://github.com/hasaneyldrm/exercises-dataset), pinned at commit `7455efae41b330c265e7cd4b78dfa848e7ce5ebd`.
- The 1,324 matching exercise IDs are combined into one asset. Spanish display names and instructions remain the default; the English locale uses the English names and ordered instruction steps. Muscle-group and equipment labels are mapped to FORZA's Spanish UI and localized at display time.
- Only text metadata is included. Image, GIF, media ID, attribution, and source media paths are omitted.
- The source repository's MIT license is included in `LICENSE`. Its media exception still applies: this project does not bundle or use those media files.
- Regenerate the bilingual normalized asset with `python tool/import_exercise_dataset.py <path-to-spanish-exercises.json> <path-to-english-exercises.json>`. The importer verifies that both sources have the same IDs and requires an English name and instruction steps for every exercise. The English source is available from the pinned upstream commit; it is not copied into this repository.
