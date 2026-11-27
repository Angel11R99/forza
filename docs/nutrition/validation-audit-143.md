# Auditoría de validación del módulo de nutrición (#143)

Fecha de esta revisión: 27 de noviembre de 2026.

## Resultado

La validación de código y pruebas automatizadas pasa en Windows. El APK `debug` también compila y abre en el emulador Android 16 (API 36). Esto no constituye certificación para producción: quedan bloqueadas la revisión por un profesional cualificado, las pruebas manuales completas de accesibilidad/flujo y la validación iOS en macOS/Xcode. El módulo mantiene deshabilitada la prescripción automatizada de calorías/macros hasta que exista una revisión profesional documentada.

## Evidencia reproducible

| Comprobación | Resultado | Evidencia |
| --- | --- | --- |
| Análisis estático Dart | Pasó | `flutter analyze --fatal-infos` — sin hallazgos |
| Suite automatizada | Pasó | `flutter test` — 196 pruebas |
| Android debug | Pasó | `flutter build apk --debug` |
| Arranque Android | Pasó | `flutter run -d emulator-5554 --no-resident`, Pixel/Phone virtual Android 16, API 36; actividad Flutter iniciada |
| Android físico | Pendiente | No hay dispositivo físico conectado |
| iOS simulador/dispositivo, Xcode y VoiceOver | Bloqueado | Este entorno es Windows; no dispone de macOS/Xcode ni dispositivos iOS |
| Revisión clínica/editorial cualificada | Bloqueada | Aún no hay revisor cualificado ni dictamen/fuentes revisadas para reglas, porciones, alérgenos y salvaguardas |
| Integración automatizada | Pendiente | El repositorio no contiene `integration_test/`; hay pruebas unitarias y de widgets |
| Declaraciones de privacidad en tiendas | Pendiente | Requiere inventario final de datos y revisión de las fichas de distribución |

La compilación `debug` inicialmente estaba bloqueada por una excepción de firma `release` aplicada durante la configuración de cualquier variante. Se movió la comprobación para que solo falle cuando el grafo de tareas solicita una variante `Release`; los builds `debug` locales no requieren secretos de firma de producción.

## Cobertura revisada en pruebas

- Modelos, serialización, campos opcionales y datos regionales desconocidos: `test/domain/models/nutrition/nutrition_models_test.dart`.
- Restricciones, conocimiento de alérgenos desconocido y elegibilidad conservadora: `test/domain/models/nutrition/nutrition_catalog_test.dart` y `test/domain/models/nutrition/nutrition_target_readiness_test.dart`.
- Generación de semana, consistencia y regeneración/sustitución: `test/domain/use_cases/nutrition_week_planner_test.dart`.
- Edición inicial del perfil, búsqueda/selección manual de país y región: `test/nutrition_profile_page_test.dart`.
- Registro, actualización, borrado, persistencia offline y migración de datos locales: `test/nutrition_meal_log_repository_test.dart`, `test/database_migration_v8_test.dart`.
- Backup nuevo/antiguo, merge, restauración local y consentimiento de datos nutricionales: `test/backup_repository_sync_merge_test.dart`, `test/profile_settings_repository_test.dart` y `test/cloud_sync_settings_page_test.dart`.
- Presentación responsive de Nutrición a 320 dp, escala de texto 2×, ES/EN y claro/oscuro: `test/nutrition_home_page_test.dart`, `test/nutrition_profile_page_test.dart` y `test/cloud_sync_settings_page_test.dart`.

Estas pruebas son evidencia de comportamiento automatizado; no sustituyen pruebas manuales con TalkBack/VoiceOver, teclado físico, inspección visual en dispositivos ni una revisión clínica.

## Riesgos funcionales que siguen abiertos

1. No existe revisión profesional identificable para los alimentos, recetas, porciones, ranking, alérgenos y salvaguardas. El catálogo marca disponibilidad/coste y alérgenos como desconocidos donde no están revisados; no convertir esos datos en afirmaciones de seguridad o disponibilidad. `NutritionTargetReadiness` conserva `professionalReviewRequired` y los objetivos cuantitativos permanecen nulos.
2. La selección incluida de USDA es una base general offline, no cobertura nacional/local validada. La redistribución de las tablas nacionales candidatas sigue pendiente de licencia; véase [catalog-sources.md](catalog-sources.md).
3. Los criterios de integración/persistencia de planes, historial, tendencias y otros datos nutricionales dependen de #142 y #144–#152. No afirmar sincronización completa de esos tipos hasta probar sus migraciones, conflictos, exportación y borrado.
4. No se ejecutaron flujos manuales exhaustivos de invitado/cuenta y cambio de cuenta en Android/iOS, reproducción offline tras reinstalación, permisos de salud, navegación/teclado, ni captura comparativa visual. Requieren ampliar escenarios y evidencia antes de release.
5. AGP 9.1.1 y Kotlin Gradle Plugin 2.4.10 compilan, pero Flutter 3.50.1 avisa que versiones futuras exigirán AGP 9.3.1 y Kotlin 2.4.20 o superior. Planificar esa actualización en una tarea separada.

## Decisión de release

No liberar el módulo de nutrición como generador de objetivos o menú clínicamente personalizado hasta resolver la revisión profesional. Mantener los límites preventivos ya descritos en [architecture.md](architecture.md). El cierre de este issue requiere anexar dictamen profesional y completar o documentar como bloqueada la validación multiplataforma iOS; los resultados locales anteriores no equivalen a esas aprobaciones.
