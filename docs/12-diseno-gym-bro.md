# Propuesta de Gym Bro

Estado: propuesta para revisión del propietario. Investigación consultada el 24-11-2026. Este documento no crea cuentas, servicios, backend ni sincronización.

## Resumen de la propuesta

Gym Bro debe ser un espacio privado para entrenar con personas conocidas. La primera versión puede soportar parejas y grupos pequeños con invitación explícita, objetivos semanales flexibles y un resumen de sesión que cada persona decide compartir. Las medidas corporales, el peso y las rutinas personales permanecen privados por defecto. No habrá perfil público, feed abierto, ubicación, chat general ni alarmas que intenten despertar a otra persona.

Para el piloto se recomienda diseñar con grupos de 2 a 6 integrantes, aunque la primera prueba de UX puede limitarse a parejas. La arquitectura debe admitir grupos sin publicar ni descubrir cuentas. La alternativa técnica que mejor encaja con los datos relacionales y las reglas de acceso es Supabase con PostgreSQL, Auth y RLS; se recomienda solo como candidata para prototipo después de la aprobación del propietario. Drift permanece como base local y fuente de verdad de los registros personales.

## Casos de uso

| Caso | Flujo esperado | Privacidad predeterminada |
|---|---|---|
| Invitar a un compañero | Crear enlace, código o QR que vence en 24 horas; el invitado ve quién invita y el nombre del grupo, acepta o rechaza, y solo entonces se crea la membresía. | El enlace no muestra entrenamientos ni estadísticas. Es de un solo uso y puede revocarse. |
| Compartir una sesión | Al terminar una sesión, la persona elige “Compartir con Gym Bro”, selecciona el grupo y revisa un resumen antes de enviarlo. | No se publica automáticamente. Ejercicios, pesos y notas quedan fuera salvo selección explícita posterior. |
| Acordar una sesión | Proponer día y hora local, recibir aceptación, rechazo o alternativa; el estado indica quién confirmó. | La confirmación es voluntaria y no demuestra llegada ni asistencia. |
| Dar un toque | Enviar un mensaje predefinido a un compañero con una sesión pendiente. Se registra dentro de la app y se entrega push solo si el receptor lo habilitó. | La persona receptora controla horas, push y frecuencia; el emisor no puede elevar la intensidad. |
| Participar en un objetivo grupal | Elegir una meta semanal compartida y declarar la frecuencia individual que cada integrante se compromete a cumplir. | No requiere compartir peso, medidas o detalles del plan. Descansos y pausas no cuentan como fallas. |
| Salir o bloquear | Abandonar el grupo o bloquear a una persona desde sus ajustes de miembros. El acceso de esa persona se revoca en servidor y se cierran sus canales activos. | La revocación impide nuevas lecturas; el tratamiento de resúmenes previos se explica y confirma antes de salir. |

## Alcance

### MVP propuesto

1. Crear un espacio privado y enviar invitación por enlace, código o QR. Los códigos son aleatorios, de un solo uso, almacenados como hash y con vencimiento configurable (24 horas por defecto).
2. Aceptar o rechazar antes de revelar cualquier dato; aceptar las reglas de privacidad del grupo; permitir revocar invitaciones y expulsar miembros.
3. Compartir un resumen de sesión completada solo tras confirmación manual. El resumen inicial contiene fecha local, duración opcional y una nota breve opcional; sin ejercicios, series, carga, récords ni medidas.
4. Proponer una sesión, responder “Voy”, “No puedo” o sugerir otro horario; permitir “Llegué” como acción manual sin GPS.
5. Definir una meta grupal de sesiones por semana y reacciones positivas predefinidas. Sin rankings, rachas diarias ni mensajes libres.
6. Permitir un toque manual dentro de la app y push opcional, bajo límites y horarios definidos por quien lo recibe.
7. Mostrar una línea de actividad finita y ordenada por fecha, con controles para ocultar, retirar o borrar contenido compartido.

### Fases posteriores, sujetas a validación

- Compartir ejercicios, series, récords, rutinas versionadas o métricas: requiere permisos separados y datos consistentes. La rutina compartida depende del versionado de #13. Para estadísticas y récords deben completarse #10 y #11.
- Retos privados y grupos mayores: validar que aporten valor sin convertir descanso o menor volumen en una señal de fracaso.
- Recetas: excluir del MVP. Si entrevistas muestran una necesidad, probar primero compartir un enlace externo, sin crear nutrición, dietas ni catálogo de alimentos.
- Mensajería general, presencia en vivo, descubrimiento de personas, feed público, ubicación, ranking competitivo y alertas de pantalla completa: fuera del alcance recomendado.

## Reglas de descanso, metas y rachas

- No mostrar una racha diaria compartida. La unidad de progreso es la semana local de cada integrante.
- Cada integrante escoge su objetivo semanal individual (por ejemplo, 2, 3 o 4 sesiones) y sus días de entrenamiento. La meta común es el número de semanas consecutivas en que cada integrante activo alcanza su propio objetivo, no que todos entrenen el mismo día.
- Una sesión solo cuenta cuando termina y se guarda como completada en el historial local. Sesiones planificadas, aceptaciones, toques y “Llegué” no cuentan como entrenamiento.
- Un día de descanso no reduce el progreso. Una semana por debajo del objetivo pausa la secuencia y se muestra como “meta semanal pendiente”; no se publica como fallo ni envía reproches.
- Vacaciones, enfermedad, lesión, cambio de horario o pausa voluntaria permiten pausar a una persona o al grupo. Durante la pausa no se incrementa ni se reinicia la racha. Un miembro nuevo comienza a contar desde su primera semana completa; salir del grupo elimina su contribución futura.
- Las semanas se calculan en la zona horaria de cada integrante. El resumen grupal cierra cuando termina la semana local más tardía entre los miembros; no se deducen horarios ni ubicaciones.
- Las metas se acuerdan; no se pueden cambiar unilateralmente para alterar el historial compartido. Cambiar una meta tiene vigencia desde la semana siguiente y conserva quién la cambió y cuándo.

## UX y consentimiento

### Navegación sugerida

En Perfil o Actividad: entrada “Gym Bro” con estado vacío, botón “Crear espacio” y explicación de qué datos nunca se comparten automáticamente. En el espacio: nombre, miembros y controles de compartir; objetivo semanal; próxima sesión; actividad reciente; menú “Privacidad y miembros”. Evitar un feed infinito y contadores de interacción.

Al crear o unirse, mostrar un resumen breve: quién integra el grupo, qué puede compartirse y cómo salir/bloquear. Cada tipo de dato tiene un control separado y empieza apagado. El consentimiento del grupo no concede permisos en nombre de otra persona. Cada sesión se revisa antes de compartir; cambiar un permiso no publica contenido histórico por sorpresa.

Los estados “invitación pendiente”, “sesión propuesta”, “confirmada”, “pausada” y “revocada” deben tener texto e icono, no depender solo del color. Mantener acciones táctiles grandes, lector de pantalla, movimiento reducido, texto ampliable y apariencia monocromática existente. Los avisos no deben usar lenguaje de culpa ni presión para entrenar.

### Flujo Gym Bro Touch

1. Una persona propone una hora y la zona horaria se deriva del dispositivo únicamente para interpretar ese horario, sin compartir la ubicación.
2. El compañero recibe un aviso dentro de la app. Si autorizó push, se envía un push normal y discreto con caducidad; puede responder “Voy”, “No puedo” o proponer otro momento.
3. Un toque adicional es manual, caduca al terminar o cancelar la sesión y está limitado a un toque por sesión y destinatario. Se aplica también un máximo configurable por día para impedir hostigamiento.
4. “Llegué” y “Empezar” son confirmaciones manuales. No se infiere llegada por geolocalización, Bluetooth, sueño, estado de pantalla o silencio.
5. El receptor puede definir horas tranquilas, apagar los toques de una persona, pausar todos los avisos o bloquear. Rechazar no exige explicación.

**Alertas especiales:** no incluir sonido forzado, vibración insistente ni pantalla completa. Android reserva el permiso de pantalla completa para llamadas y alarmas configuradas por el usuario en Android 14+ ([política/plataforma Android](https://developer.android.com/about/versions/14/behavior-changes-14)). Las alarmas exactas requieren permiso especial y se deniegan por defecto en muchos casos de Android 14 ([alarmas exactas](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)). Apple exige que Apple otorgue un entitlement especial para Critical Alerts, que puede atravesar silencio y No molestar ([entitlement de Apple](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.usernotifications.critical-alerts)). No se debe basar una función social en esos permisos ni prometer entrega de un push. Para sesiones que el propio usuario programó, evaluar después avisos locales normales conforme a #12 y preferencias del sistema.

## Modelo lógico y permisos

Modelo conceptual; no es una migración ni una decisión de esquema final.

| Entidad | Campos clave | Regla de acceso propuesta |
|---|---|---|
| `profiles` | `user_id`, alias opcional, zona horaria | Solo el usuario edita su alias; el grupo recibe solo el alias compartido, nunca email o proveedor de login. |
| `groups` | `id`, nombre, `created_by`, estado, fechas | Solo miembros activos leen; creador administra nombre y estado, pero no cambia consentimiento ajeno. |
| `group_members` | `group_id`, `user_id`, rol, estado, `joined_at`, `revoked_at` | Un usuario acepta su propia membresía; roles del grupo no conceden acceso a datos personales fuera del grupo. Índice único por grupo/usuario. |
| `invitations` | token hash, grupo, creador, vencimiento, usos, revocación | No listar tokens desde clientes; la aceptación valida expiración, uso único, bloqueo y cupo en una transacción. Nunca guardar el token en claro. |
| `sharing_preferences` | `user_id`, `group_id`, categoría, habilitado, revisión | Cada usuario controla su fila. Compartir perfiles, resumen, ejercicios, récords o rutina son permisos distintos y apagados inicialmente. |
| `shared_workout_summaries` | ID estable local, propietario, grupo, fecha, duración opcional, nota opcional, estado | Solo el propietario crea/retira su resumen; miembros activos del grupo leen solo si la preferencia sigue habilitada. Excluir métricas corporales. |
| `group_goals` | grupo, métrica, valor, semana efectiva, versión | Miembros activos leen; cambios se confirman y aplican a partir de la próxima semana. Guardar autor y versión para resolver edición concurrente. |
| `session_proposals` | grupo, creador, hora, zona horaria, estado, vencimiento | Miembros activos leen y responden solo por sí mismos; los avisos no equivalen a asistencia. |
| `reactions` | contenido, actor, reacción permitida, fecha | Miembros activos; catálogo pequeño y positivo, sin texto libre ni conteos competitivos. |
| `nudge_preferences` / `nudge_events` | receptor, canal, horas tranquilas, límites, caducidad, deduplicación, emisor | El receptor modifica preferencias; el servidor valida opt-in y límites antes de encolar. Los eventos guardan trazabilidad mínima y vencen pronto. |
| `blocks` | bloqueador, bloqueado, fecha | Solo el bloqueador puede crear/quitar su bloqueo; bloqueos impiden invitación, búsqueda por token emitido y nuevos toques entre ambos. |

### Límites de seguridad

- Activar RLS en todas las tablas visibles por el cliente y definir políticas para cada operación; limitar también los `GRANT`, porque RLS no revoca por sí solo permisos SQL. Cada lectura de grupo comprueba membresía activa y cada inserción valida propiedad, consentimiento, vigencia y pertenencia. Ver [guía de RLS de Supabase](https://supabase.com/docs/guides/database/postgres/row-level-security).
- No incluir tokens, contraseñas, medidas, historial completo ni secretos de servidor en metadatos editables por usuarios o en claims que el cliente controla. La clave administrativa que omite RLS solo vive en servidor.
- Las tablas y canales Realtime son privados; autorizar membresía al conectar, minimizar eventos y cerrar la suscripción al retirar a una persona. Supabase indica que la autorización de un canal Realtime queda cacheada durante la conexión; la revocación debe desconectar el socket y renovarlo, además de cambiar membresía ([autorización Realtime](https://supabase.com/docs/guides/realtime/authorization)). Para cambios sensibles, preferir eventos mínimos y no transmitir filas completas.
- No confiar en notificaciones push para proteger datos. Un push solo contiene un aviso neutro y un ID opaco; al abrirlo, la app vuelve a pedir el contenido al servidor, que revalida permisos.
- Registrar consentimiento con usuario, grupo, categoría, versión del texto y fecha. Permitir retirar consentimiento, descargar datos compartidos y solicitar borrado. Definir retención corta para invitaciones, eventos de toque, sesiones canceladas y contenido retirado.
- Si una persona sale, cancelar tokens y canales, invalidar su membresía, detener futuras entregas y eliminar o desasociar su contenido según una opción clara explicada antes de confirmar. El cliente debe borrar su caché local del grupo.

## Drift, sincronización y conflictos

La app ya guarda entrenamientos y datos personales en SQLite/Drift y funciona sin cuenta. Gym Bro no debe reemplazar esa experiencia.

1. Mantener el registro personal local como fuente principal. La sincronización social es una copia selectiva que solo se crea tras consentimiento, no una subida automática de todas las tablas de Drift.
2. Asignar UUID estable a cada evento compartible, una cola local de salida idempotente, estado `pendiente/enviado/error/revocado`, fecha de servidor y versión. Reintentar con backoff; una repetición con el mismo UUID no duplica el resumen.
3. Si no hay red, las propuestas y cambios propios quedan en cola y muestran “Pendiente de conexión”. Al reconectar, autenticar y comprobar membresía/consentimiento antes de enviar. Una revocación local no se debe presentar como confirmada hasta que el servidor la acepte; bloquear inmediatamente nuevas acciones en el cliente.
4. Los registros completados son eventos inmutables con corrección explícita o tombstone; para dos ediciones del mismo resumen, gana la revisión más nueva del propietario, no una edición de otro miembro. Las metas usan número de versión y conflicto visible para que el creador vuelva a confirmar. Las membresías, bloqueos y permisos se resuelven en servidor, nunca por “última escritura gana”.
5. Las consultas offline solo muestran los grupos ya sincronizados y marcan cuándo se actualizaron. No inventar estadísticas incompletas ni dar por enviada una invitación o un toque sin confirmación del servidor.
6. Revocar acceso exige limpiar la caché social local, cerrar canales y cancelar avisos en cola. No borrar el historial de entrenamiento propio en Drift al salir de Gym Bro.

Firestore ofrece persistencia offline en sus SDK móviles y sincroniza al reconectar; cuando varias escrituras modifican el mismo documento aplica “last write wins” ([offline Firestore](https://firebase.google.com/docs/firestore/manage-data/enable-offline)). Eso facilita disponibilidad, pero no resuelve por sí solo conflictos de consentimiento o membresía; esas decisiones necesitan reglas explícitas del servidor.

## Alternativas de infraestructura y coste

Precios y cuotas consultados el 24-11-2026; son referencia de tarifa pública en USD antes de impuestos, moneda, región, extras y volumen. Recalcular con una estimación real antes de activar cobros.

| Opción | Ajuste para Forza | Coste público observado | Riesgo o trabajo |
|---|---|---|---|
| **Supabase: PostgreSQL, Auth, RLS, Realtime** | Mejor encaje conceptual para grupos, membresías, permisos por categoría y eventos relacionales. Cliente Flutter; Drift sigue siendo la base offline. Candidata recomendada para prototipo. | Free: $0, 50.000 MAU, 500 MB DB, 5 GB egress, 1 GB de archivos; máximo 2 proyectos activos y los Free pueden pausarse tras una semana inactivos. Pro: desde $25/mes, incluye $10 de crédito de cómputo suficiente para un proyecto Micro, 8 GB DB, 250 GB egress y respaldos diarios 7 días; excesos y proyectos adicionales suben el costo ([precios Supabase](https://supabase.com/pricing), [facturación](https://supabase.com/docs/guides/platform/billing-on-supabase)). | Requiere diseñar y probar RLS de cada tabla/canal; Realtime puede retener autorización en sockets existentes. Límites/consumo Realtime también pueden generar extras ([precios Realtime](https://supabase.com/docs/guides/realtime/pricing)). No resuelve por sí solo el sync local de Drift. |
| **Firebase: Auth, Firestore, FCM** | SDK Flutter y persistencia offline integrada. Adecuado para actividad/documentos y push; modelo de documentos exige duplicar y revisar reglas para cada vía de lectura. | FCM figura sin coste. Firestore incluye 1 GiB, 50.000 lecturas/día, 20.000 escrituras/día, 20.000 borrados/día y 10 GiB/mes de salida en la cuota gratuita de una base por proyecto; luego cobra operaciones, almacenamiento y red según región ([precios Firebase](https://firebase.google.com/pricing), [precios Firestore](https://firebase.google.com/docs/firestore/pricing)). | SDK offline aplica last-write-wins por documento. Hay que medir lecturas de listeners, reconexión y reglas para no inflar coste ni filtrar datos. FCM es transporte; entrega y presentación dependen del dispositivo y permisos. |
| **Appwrite Cloud: Auth, TablesDB, Functions, Realtime** | SDK oficial Flutter y componentes integrados; sirve como alternativa gestionada y posible candidato de autoalojamiento. | Free: $0, 75.000 MAU, 5 GB transferencia y 2 GB storage; pausa proyectos inactivos tras una semana. Pro desde $25/mes con $10 en créditos de cómputo de base; revisar cuotas y extras vigentes ([precios Appwrite](https://appwrite.io/pricing), [SDKs](https://appwrite.io/docs/sdks)). | Validar límites de permisos por fila, exportación, Realtime y estrategia offline para el caso real antes de elegir; autoalojar añade operación, copias, actualizaciones y disponibilidad. |

No hace falta contratar nada para aprobar el diseño. Primera estimación para un piloto de desarrollo: $0 en Free mientras se acepte la pausa por inactividad; para producción con disponibilidad continua, reservar al menos la tarifa inicial pública de Pro de la opción elegida y medir 30 días de MAU, almacenamiento, eventos/lecturas y tráfico antes de fijar presupuesto. Evitar subir fotografías/archivos en el MVP.

## Pruebas que deben preceder cualquier implementación

### Seguridad y privacidad

- Miembro activo ve solo sus grupos; usuario externo, usuario bloqueado y miembro revocado no pueden leer, escribir ni recibir eventos de ese grupo.
- Invitación vencida, usada, revocada, manipulada o emitida por una persona bloqueada falla sin revelar si el grupo existe.
- No se lee ni escribe sin consentimiento de la categoría; cambiar un toggle no publica registros históricos.
- Pesos, medidas y sesiones privadas no aparecen en API, logs, push, analytics, búsqueda ni payload de Realtime.
- Salir/bloquear corta suscripciones existentes, invalida caché y evita nueva entrega; probar dos dispositivos conectados y token sin renovar.
- Exportar y borrar datos propios, revocar cada categoría, eliminar grupo y retener solo lo que se explique claramente a los miembros restantes.

### Función, sincronización y alertas

- Aceptar/rechazar invitación por cada canal; caducidad, uso único, cupo, revocación y carrera entre dos aceptaciones simultáneas.
- Guardar/editar una sesión offline, cerrar la app, reconectar y reintentar varias veces sin duplicar; conflicto de dos cambios a una meta y de edición del resumen por su propietario.
- Semanas con horarios de verano, zonas distintas, metas diferentes, descanso, pausa, viaje, miembro nuevo y salida; ninguna pausa de descanso rompe una racha personal diaria porque no se define esa racha.
- Toque con receptor sin push, horas tranquilas, límite alcanzado, sesión cancelada, permiso OS denegado y token push inválido; ninguna interfaz afirma que el otro llegó o que el push se entregó.
- Accesibilidad: VoiceOver/TalkBack, escala de texto, contraste, foco/teclado, reduced motion y estados no expresados solo por color.

## Decisiones pendientes del propietario

1. Aprobar o cambiar el MVP y decidir si la primera beta es solo parejas o permite grupos de hasta 6 desde el inicio.
2. Confirmar las categorías exactas que se podrán compartir. La propuesta mantiene apagados detalles de ejercicios, peso, récords y rutinas.
3. Aprobar la evaluación técnica de Supabase para un prototipo gratuito; el documento no activa servicio ni compra.
4. Decidir más adelante si compartir recetas merece otro estudio. Recomendación actual: no incorporarlo en Gym Bro inicial.

### Fuentes oficiales

- [Supabase: precios](https://supabase.com/pricing), [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security), [autorización Realtime](https://supabase.com/docs/guides/realtime/authorization), [costes Realtime](https://supabase.com/docs/guides/realtime/pricing).
- [Firebase: precios](https://firebase.google.com/pricing), [cuotas y facturación de Firestore](https://firebase.google.com/docs/firestore/pricing), [persistencia offline](https://firebase.google.com/docs/firestore/manage-data/enable-offline), [FCM](https://firebase.google.com/products/cloud-messaging/).
- [Appwrite: precios](https://appwrite.io/pricing), [SDKs](https://appwrite.io/docs/sdks).
- [Android: permisos de alarma exacta](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms), [intents de pantalla completa](https://developer.android.com/about/versions/14/behavior-changes-14).
- [Apple: entitlement Critical Alerts](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.usernotifications.critical-alerts).
