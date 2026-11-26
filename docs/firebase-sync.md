# Firebase y sincronización

FORZA usa el proyecto Firebase `forza-6cd98`, Firebase Authentication con Google y Firestore Standard `(default)` en `us-east1`. Android, iOS, web, macOS y Windows tienen registros FlutterFire. Android usa las huellas SHA-1 de debug y release registradas en el proyecto. iOS y macOS incluyen el OAuth client ID y su URL scheme nativo en `Info.plist`; la compilación y el login real de Apple deben validarse desde macOS. Linux inicia sin Firebase porque los plugins no están disponibles allí.

## Datos sincronizados

La sincronización está apagada por defecto. Iniciar sesión solo crea la sesión Firebase y el perfil mínimo del usuario; no sube la copia local. En Perfil, la persona debe activar la sincronización y aceptar una explicación de los datos que se van a compartir. Puede desactivarla después sin borrar la copia remota. También puede borrar la copia de Firestore con confirmación, manteniendo sus datos locales y la cuenta de Google.

Una vez aceptada, la app escribe en `users/{uid}/sync/current`. El manifiesto apunta a una instantánea dividida en fragmentos; al confirmar una nueva instantánea se eliminan los fragmentos anteriores. La copia incluye plan y preferencias de entrenamiento, agenda, sesiones e historial, objetivos, medidas, sesión activa, apariencia, idioma, ajustes de perfil, notificaciones y privacidad.

La combinación compara la copia local y la nube con la última instantánea común guardada en Drift. Los cambios locales ganan cuando ambos dispositivos editaron el mismo valor. Una eliminación de uno de los lados se propaga si el otro no modificó ese registro desde la base común. Las copias locales se separan por UID; al cambiar de cuenta, la app guarda el espacio local de la cuenta anterior y abre el espacio de la nueva identidad antes de sincronizar. El estado pendiente y la fecha de la última sincronización se conservan localmente; los fallos reintentan con espera creciente hasta cinco minutos, y se reintenta al abrir o volver a la app.

## Modelo y validación local

- `users/{uid}` guarda el perfil privado de Google; no se permiten consultas de colección.
- `users/{uid}/sync/current` es el manifiesto versionado de una copia completa. `snapshots/{snapshotId}/chunks/chunk_NNN` contiene los fragmentos de respaldo; no se replica el catálogo de ejercicios.
- Drift sigue siendo la fuente inmediata para entrenar sin conexión. `local_account_backups` conserva el espacio local por UID y `cloud_sync_baselines` la última base común necesaria para resolver ediciones y borrados.
- Ejecuta `npm ci --prefix firebase-tests` y `npx firebase-tools emulators:exec --only firestore --project demo-forza-firestore-rules "npm test --prefix firebase-tests"` para probar acceso anónimo, propiedad, acceso entre cuentas, campos inválidos y límites de tamaño. CI corre estas pruebas en cada PR.

## Seguridad y despliegue

- `firestore.rules` permite cada perfil y copia solo a su propio UID autenticado y valida el esquema y tamaño de los fragmentos.
- `firestore.indexes.json` mantiene la configuración de índices.
- `firebase.json` apunta a ambos archivos y guarda la configuración de FlutterFire.
- Los SDK cliente de Firebase y las reglas se despliegan por separado; la configuración del proyecto está en Firebase Console.

## Lecturas, escrituras y cuotas

Firestore Standard tiene cuota gratuita de 1 GiB almacenado, 50 000 lecturas/día, 20 000 escrituras/día, 20 000 eliminaciones/día y 10 GiB de transferencia saliente/mes; son límites gratuitos, no un límite de gasto. La cuota se comparte con todo el proyecto y se reinicia diariamente según la zona horaria de Google. [Precios y cuotas oficiales](https://firebase.google.com/docs/firestore/pricing).

Cada sincronización completa lee el manifiesto y los fragmentos actuales. Al publicar una copia escribe un documento por fragmento y el manifiesto, lee el manifiesto anterior y elimina sus fragmentos; el listener de tiempo real añade lecturas al recibir una nueva manifestación. La app agrupa cambios por dos segundos y no escribe mientras la sincronización está desactivada. Vigila la pestaña Firestore Usage de Firebase Console: al superar las cuotas gratuitas, las operaciones pueden requerir el plan Blaze y generar cargos. No se habilitó facturación en esta integración.

## Firma y prueba de Android

Google Sign-In valida la combinación de application ID y certificado. Registra en Firebase la SHA-1 debug para probar builds locales y la SHA-1 del certificado release para el APK publicado en GitHub. La acción **Show Android signing fingerprint** calcula la huella de los secretos ya configurados, sin exponer la keystore ni generar una publicación. Añade el resultado en Firebase Console → Configuración del proyecto → app Android → Huellas SHA.

El flujo de release requiere los cuatro secretos `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` y `ANDROID_KEY_PASSWORD`, analiza el proyecto, ejecuta pruebas y compila un APK release firmado. Google Sign-In real debe probarse en el teléfono después de registrar las huellas correspondientes.
