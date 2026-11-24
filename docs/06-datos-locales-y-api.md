# Datos locales, migraciones y contrato de API

## Estado actual

FORZA usa SQLite local a través de Drift. La base se crea en el directorio de documentos de la aplicación con el nombre `forza`; el archivo y su ruta son responsabilidad de `drift_flutter`. La app puede guardar y leer estos datos sin red:

- Preferencias del plan: objetivo, experiencia, duración por sesión, días elegidos y equipo disponible.
- Sesiones terminadas: fecha planificada, fecha de finalización, objetivo, duración, cantidad de ejercicios, IDs estables del catálogo, versión y snapshot del plan de origen, y si se marcaron como completadas fuera de la app.
- Resultados por serie: repeticiones o duración y carga registrada para cada ejercicio de una sesión.
- Borrador de entrenamiento activo: ejercicio actual, tiempo transcurrido y series registradas, guardados en `app_metadata` para recuperar la sesión.
- Agenda: sesiones de los próximos 120 días, fecha original al reprogramar, estado pendiente/en curso/completada/omitida y snapshot de la rutina que corresponde a cada sesión. Omitir una sesión no crea un registro de entrenamiento y se puede deshacer desde Actividad.
- Objetivos personales: sesiones completadas por semana o carga máxima objetivo por ejercicio.
- Metadatos: finalización del onboarding y control de importaciones.

El catálogo de ejercicios sigue en `assets/data/exercises.json`: es un catálogo incluido, de solo lectura, y no se duplica en SQLite. El perfil personal, medidas corporales, notificaciones y sincronización entre dispositivos todavía no son datos persistidos. La agenda mantiene 120 días de sesiones próximas y sincroniza Inicio, Actividad y la sesión activa mediante el mismo repositorio.

## Exportar y restaurar datos

Desde Perfil se puede guardar un respaldo JSON o seleccionar uno para restaurarlo. El formato lleva el identificador `FORZA_BACKUP` y una versión propia independiente de la versión del esquema SQLite. La versión 1 contiene el plan, el historial con resultados por serie, la agenda, los objetivos personales, el borrador activo y la apariencia. No incluye el catálogo incluido ni las preferencias de perfil que todavía no se guardan localmente.

La restauración limita el archivo a 10 MB y valida formato, versión, tipos, rangos y duplicados antes de mostrar la confirmación. Al confirmar, reemplaza en una transacción los datos locales incluidos; una operación fallida revierte esos cambios. La apariencia se aplica después de completar la restauración de SQLite. El archivo es una copia local portable, no sincroniza dispositivos ni cifra el contenido.

Las tablas actuales están declaradas en `lib/data/database/app_database.dart`. Los repositorios de `lib/data/repositories/` mantienen aislada la persistencia del ViewModel para permitir añadir una implementación remota más adelante.

| Tabla SQLite | Uso |
|---|---|
| `training_plans` | Preferencias, datos principales y versión creciente del plan activo. |
| `training_plan_days` | Días de la semana elegidos para entrenar. |
| `training_plan_equipment` | Equipo disponible elegido por el usuario. |
| `workout_sessions` | Historial y resumen de sesiones terminadas, con versión y snapshot del plan de origen. |
| `workout_session_exercises` | Ejercicios guardados en cada resumen, ordenados por posición y vinculados por ID de catálogo cuando aplica. |
| `workout_set_entries` | Resultados registrados por ejercicio y serie. |
| `scheduled_training_sessions` | Agenda próxima, reprogramaciones, estado, versión y rutina congelada para cada sesión. |
| `personal_goals` | Metas elegidas y objetivos de sesiones o carga. |
| `app_metadata` | Marcadores, importaciones y borrador del entrenamiento activo. |

La versión actual del esquema es `5`. La migración `0005_plan_versions_and_snapshots.sql` añade IDs de catálogo, versión del plan y snapshots serializados; los registros anteriores conservan los valores predeterminados de versión `1` y los snapshots vacíos o nulos. Las instantáneas serializadas están en `drift_schemas/schema_v1.json` a `schema_v5.json`. Las actualizaciones preservan el historial existente.

## Importación de instalaciones anteriores

Las versiones anteriores guardaban `training_days`, `training_session_minutes`, `training_goal`, `training_experience`, `training_equipment`, `training_setup_complete` y `workout_records` con `shared_preferences`. `LegacySharedPreferencesMigration` lee esos valores una sola vez y los inserta en SQLite; escribe el marcador `migration_shared_preferences_v1` solo después de procesar los datos. Las sesiones duplicadas por fecha se reemplazan, y un registro JSON inválido no impide importar los demás.

Se conserva `shared_preferences` como dependencia mientras esa importación sea necesaria. No se borran las claves antiguas en esta fase; una versión futura puede retirarlas después de confirmar que las instalaciones existentes ya migraron.

## Cómo añadir una migración SQLite

1. Editar las tablas de Drift en `app_database.dart` y aumentar `schemaVersion`.
2. Implementar la actualización en `MigrationStrategy.onUpgrade` para que transforme las instalaciones existentes. No confiar solo en `onCreate`: ese callback solo sirve para instalaciones nuevas.
3. Regenerar el código: `dart run build_runner build`.
4. Crear el snapshot versionado correspondiente: `dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/schema_vN.json`.
5. Exportar y revisar el SQL de creación: `dart run drift_dev schema export lib/data/database/app_database.dart`. Añadir el SQL de la nueva versión a `database/migrations/sqlite/` y revisar que el `onUpgrade` preserve los datos.
6. Mantener snapshots y migraciones anteriores sin reescribirlos. Al subir más de una versión, encadenar las transformaciones de cada versión intermedia.

El snapshot representa la estructura deseada para Drift; el archivo SQL es una referencia portable y revisable del DDL. La aplicación ejecuta las migraciones Dart de `AppDatabase`, no los archivos `.sql` directamente.

## Contrato remoto futuro

Las rutas siguientes son una propuesta de API, **no están implementadas**. Se recomienda una API REST bajo `/v1`, JSON en UTF-8, fechas ISO-8601 UTC, autenticación Bearer cuando existan cuentas reales y errores con formato uniforme. Las listas grandes usan cursor y límite; las operaciones que crean o completan sesiones aceptan `Idempotency-Key` para evitar duplicados en reintentos.

Formato de error sugerido:

```json
{
  "error": {
    "code": "validation_error",
    "message": "La duración debe estar entre 20 y 90 minutos.",
    "details": { "sessionMinutes": "out_of_range" }
  }
}
```

### Ejercicios

| Método y ruta | Uso en la app | Contrato principal |
|---|---|---|
| `GET /v1/exercises?q=&muscleGroup=&equipment=&level=&cursor=&limit=` | Biblioteca, búsqueda y filtros. | Devuelve `items` con `id`, `name`, `instructions`, `muscleGroups`, `equipment`, `level` y `nextCursor`. Aplicar filtros en el servidor y limitar `limit` (por ejemplo, máximo 100). |
| `GET /v1/exercises/{exerciseId}` | Abrir detalle de ejercicio. | Devuelve un ejercicio con instrucciones numeradas, músculos, equipo y medios opcionales. `404` si el identificador no existe. |
| `GET /v1/exercises/{exerciseId}/alternatives` | Acción “Ver alternativas”. | Devuelve ejercicios compatibles con `exerciseId` y el motivo de compatibilidad; admite cursor. |

### Plan de entrenamiento

| Método y ruta | Uso en la app | Contrato principal |
|---|---|---|
| `GET /v1/me/training-plan` | Restaurar el plan del usuario después de iniciar sesión o sincronizar. | Devuelve el plan activo o `null` si todavía no existe. Incluye `goal`, `experience`, `sessionMinutes`, `trainingDays`, `equipment`, `createdAt` y `updatedAt`. |
| `PUT /v1/me/training-plan` | Crear o ajustar preferencias del plan. | Reemplaza el plan activo de forma idempotente. Recibe objetivo, experiencia, duración, días (1 lunes–7 domingo) y equipo; valida duración 20–90, días únicos y valores permitidos. Devuelve el plan persistido. |
| `GET /v1/me/training-plan/weeks/{weekStart}` | Mostrar la rutina sugerida para una semana concreta. | `weekStart` es la fecha del lunes (`YYYY-MM-DD`). Devuelve las sesiones planificadas con fecha y ejercicios; `weekStart` debe ser válido. |

El servidor no debe interpretar ni exponer los códigos internos del onboarding. El cliente manda preferencias legibles y el servidor devuelve nombres, fechas y sesiones visibles para el usuario.

### Historial y finalización

| Método y ruta | Uso en la app | Contrato principal |
|---|---|---|
| `GET /v1/me/workout-sessions?from=&to=&cursor=&limit=` | Historial, actividad y progreso. | Filtra por rango inclusivo de fechas y pagina con cursor. Cada item resume fecha, finalización, duración, objetivo y ejercicios. |
| `POST /v1/me/workout-sessions` | Guardar una sesión que se completó dentro o fuera del flujo guiado. | Recibe fecha planificada, `completedAt`, título, objetivo, duración, ejercicios y `completedOutsideApp`. Devuelve `201` y la sesión canónica; la clave de idempotencia evita duplicados. |
| `GET /v1/me/workout-sessions/{sessionId}` | Ver el resumen y detalle de una sesión. | Devuelve el resumen más ejercicios ordenados; `404` si no pertenece al usuario o no existe. |
| `POST /v1/me/workout-sessions/{sessionId}/complete` | Confirmar fin desde el flujo de entrenamiento. | Recibe `completedAt` y los datos finales de ejercicios/duración. Repetir la misma clave de idempotencia devuelve el mismo resultado. |

La agenda local ya representa sesiones planificadas como recursos independientes y guarda las reprogramaciones y omisiones en SQLite. La propuesta de API remota aún no define endpoints para consultar o editar esas sesiones; habrá que añadirlos si se implementa sincronización. No hay hoy sincronización remota.

### Orden sugerido de implementación remota

1. Implementar autenticación y perfil solo cuando exista un proveedor real de cuentas y una política de privacidad definida.
2. Sincronizar plan e historial con `GET/PUT training-plan` y `GET/POST workout-sessions`; conservar SQLite como caché local y definir resolución de conflictos por `updatedAt`/versión del servidor.
3. Sustituir el asset de ejercicios por los endpoints de biblioteca, detalle y alternativas cuando catálogo, licencia y servicio estén listos.
4. Añadir endpoints para medidas/progreso o cuenta únicamente cuando esas funciones guarden datos en la app y tengan campos/retención definidos.

La migración a un backend no consiste en mover el archivo SQLite del dispositivo. Se conserva el modelo de dominio y se añade una implementación remota de los repositorios con caché SQLite y sincronización explícita.
