# Auditoría de persistencia

Auditoría del código de `main` al 24-11-2026. SQLite local mediante Drift es la fuente de verdad para datos de entrenamiento. `shared_preferences` guarda las selecciones simples de apariencia e idioma. No hay cuenta ni servidor remoto; los controles que sugieren funciones sociales o notificaciones no implican que esos datos se sincronicen o se ejecuten.

## Inventario por módulo

| Módulo/dato | Fuente de verdad y ciclo de vida | Crear, actualizar, eliminar y recuperar | Resultado |
|---|---|---|---|
| Plan de entrenamiento | `training_plans`, `training_plan_days`, `training_plan_equipment`; el repositorio guarda los campos relacionados en una transacción. | Guardar crea o actualiza el plan, reemplaza días/equipo y aumenta la versión solo si cambió la configuración. Se carga al iniciar y se incluye en el respaldo. | Persistente en SQLite. La importación heredada ya no reemplaza un plan que exista si falla antes de escribir su marcador. |
| Agenda y rutinas | `scheduled_training_sessions`; incluye estado, versión y snapshot. | Crear/refrescar agenda, reprogramar, marcar pendiente/en curso/completada/omitida, deshacer omisión; se consulta desde Inicio y Actividad. Respaldo exporta/restaura sesiones. | Persistente en SQLite y actualizado durante el arranque sin reemplazar sesiones movidas, omitidas o completadas. |
| Historial, ejercicios y series | `workout_sessions`, `workout_session_exercises`, `workout_set_entries`. | Guardar reemplaza el resumen de la misma fecha y sus ejercicios/series; cargar ordena por fecha/posición; eliminar el resumen elimina dependencias por claves foráneas. Respaldo restaura el conjunto. | Persistente en SQLite; récords, resúmenes, rachas y metas derivadas se calculan desde registros completados, no desde estados de agenda. |
| Entrenamiento en curso | `app_metadata.active_workout_v1`. | Guardar/actualizar borrador, leerlo tras reiniciar, borrar al completar o salir definitivamente. | Persistente en SQLite y recuperable al iniciar. |
| Metas personales | `personal_goals`. | Crear/actualizar por ID, eliminar y cargar al iniciar; se incluyen en respaldo. | Persistente en SQLite. |
| Tema | Clave `appearance_theme_mode` de `shared_preferences`. | Guardar sistema/claro/oscuro y leer en el inicio de la app. El respaldo lleva el tema y lo aplica tras restaurar SQLite. | Persistente entre reinicios. El fallo del plugin conserva el valor solo durante la ejecución actual. |
| Idioma | Clave `app_locale_language_code` de `shared_preferences`. | Guardar inglés/español/automático y leer en el inicio. | Persistente entre reinicios; no se incluye en el respaldo. |
| Preferencias del perfil | Claves versionadas `profile_app_preferences_v1`, `profile_notifications_v1` y `profile_privacy_v1` de `shared_preferences`. | Guardar cada grupo al confirmar su formulario; al abrir Perfil, leer y validar tipos/rangos. Fallos de lectura bloquean la edición; fallos de guardado conservan el valor anterior y muestran un error. No forman parte del respaldo JSON. | Unidad, inicio de semana, hápticos, recordatorios/hora y privacidad persisten entre reinicios. Resumen semanal/alertas de récord se retiraron hasta tener eventos reales. |
| Avisos de entrenamiento | El permiso lo controla Android/iOS; el horario usa la preferencia `profile_notifications_v1`, la agenda SQLite y la zona horaria IANA obtenida del dispositivo. | Al activar se solicita permiso; se programan/cancelan avisos para sesiones pendientes, por fecha, al actualizar plan, agenda, preferencias, idioma y al reanudar la app. Mantiene como máximo 50 avisos próximos. En Android usa alarmas inexactas para evitar permiso de alarma exacta. | Los avisos persisten en el SO tras cerrar la app y Android los restaura al reiniciar. Android puede retrasar avisos inexactos; el límite de 50 se renueva cuando la app vuelve a abrirse. |
| Perfil/cuenta/privacidad/medidas | Nombre, acceso, medidas y privacidad siguen siendo demostrativos; no hay proveedor de identidad ni publicación/sincronización. | No existe CRUD de cuenta/medidas ni servicio que publique las preferencias de privacidad. | No presentar esos controles como cuenta real o datos compartidos. |
| Catálogo y localización | Ejercicios en `assets/data/exercises.json`; mensajes en ARB/código generado. | Solo lectura, se actualizan con una versión de la app. | No son datos personales ni se guardan en SQLite/respaldo. |
| Selección de pestaña, fecha del calendario y formularios | Estado de widgets/ViewModels. | Se reinicia según la navegación; el borrador guiado es la excepción y vive en `app_metadata`. | Estado temporal, no historial ni preferencias persistentes. |

## Riesgos revisados y correcciones

- Los ajustes del plan guardan plan, días y equipo en una transacción; una igualdad de preferencias mantiene la versión sin cambios.
- Los resúmenes del entrenamiento reemplazan por fecha para que un reintento no duplique sesiones. Las series y ejercicios dependen del resumen y se guardan junto a este.
- El respaldo valida el contenido antes de confirmar y restaura las tablas incluidas en una transacción. Apariencia se aplica después de SQLite; idioma y preferencias del perfil guardadas por separado quedan fuera del archivo JSON.
- La migración de `shared_preferences` usa un marcador idempotente y guarda registros por fecha. Si el proceso se interrumpe antes del marcador, una segunda ejecución puede reintentar sin duplicar registros y ahora no sobrescribe un plan SQLite existente con valores heredados.
- Las migraciones Drift v2–v5 conservan las tablas existentes; los tests de migración cubren los saltos a v5 desde v2 y v4.
- Tema e idioma persisten antes de cambiar el estado visible; los errores se muestran y no anuncian un guardado exitoso.

## Verificación de ciclo de vida

`test/persistence_roundtrip_audit_test.dart` usa un archivo SQLite temporal y comprueba escritura, actualización, eliminación, cierre/reapertura del archivo, respaldo y restauración del plan, agenda, omisión, historial con series, metas y borrador. También verifica que la importación heredada sea idempotente y no sustituya un plan nuevo. `test/profile_settings_repository_test.dart`, `test/profile_view_preferences_test.dart` y `test/app_preferences_lifecycle_test.dart` comprueban guardado/restauración de todas las preferencias locales, reflejo en Perfil y manejo de errores. Los tests de migración versionada comprueban los esquemas anteriores.

Cerrar y abrir el archivo representa el ciclo de proceso de la base local. La compatibilidad con una actualización se cubre mediante los tests de migración y el importador heredado; no es un test de instalación real en Android/iOS.
