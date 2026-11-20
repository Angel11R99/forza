# Exercise dataset provenance

- Source: [jlfernandezfernandez/exercises-dataset-es](https://github.com/jlfernandezfernandez/exercises-dataset-es), pinned at commit `5a5dd652f102c34bb09fcb0db3c2f3ae4dd53cbe`.
- Upstream: [hasaneyldrm/exercises-dataset](https://github.com/hasaneyldrm/exercises-dataset).
- The imported asset retains Spanish display names and Spanish instructions, with muscle-group and equipment labels mapped to FORZA's Spanish UI.
- Only text metadata is included. Image, GIF, media ID, attribution, and source media paths are omitted.
- The source repository's MIT license is included in `LICENSE`. Its media exception still applies: this project does not bundle or use those media files.
- Regenerate the normalized asset with `python tool/import_exercise_dataset.py <path-to-exercises.json>`.
