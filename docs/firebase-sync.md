# Firebase y sincronización

FORZA usa el proyecto Firebase `forza-6cd98`, Firebase Authentication con Google y Firestore Standard `(default)` en `us-east1`. Android, iOS, web, macOS y Windows tienen registros FlutterFire; Google Sign-In se valida en Android y web, y iOS/macOS requieren completar el esquema URL nativo descrito en [Google Sign-In](google-sign-in-setup.md). Linux inicia sin Firebase porque los plugins no están disponibles allí.

## Datos sincronizados

Al autenticarse, la app exporta el respaldo local versionado y lo replica en `users/{uid}/sync/current`. El manifiesto referencia una instantánea inmutable en fragmentos; tras confirmar una nueva instantánea, los fragmentos de la anterior se eliminan. El respaldo incluye planes y preferencias de entrenamiento, agenda, sesiones e historial, objetivos, medidas, sesión activa, apariencia y ajustes de perfil, notificaciones y privacidad.

La sincronización es local-first. En el primer inicio combina registros remotos y locales, y ante registros con el mismo identificador conserva el valor local. Los cambios del dispositivo se suben después de una breve pausa; las instantáneas remotas se combinan en SQLite y se vuelven a publicar si la copia combinada contiene datos locales adicionales. Cerrar sesión detiene el listener sin borrar SQLite.

## Seguridad y despliegue

- `firestore.rules` permite cada perfil y copia solo a su propio UID autenticado y valida el esquema y tamaño de los fragmentos.
- `firestore.indexes.json` mantiene la configuración de índices.
- `firebase.json` apunta a ambos archivos y guarda la configuración de FlutterFire.
- Los SDK cliente de Firebase y las reglas se despliegan por separado; la configuración del proyecto está en Firebase Console.

## Firma y prueba de Android

Google Sign-In valida la combinación de application ID y certificado. Registra en Firebase la SHA-1 debug para probar builds locales y la SHA-1 del certificado release para el APK publicado en GitHub. La acción **Show Android signing fingerprint** calcula la huella de los secretos ya configurados, sin exponer la keystore ni generar una publicación. Añade el resultado en Firebase Console → Configuración del proyecto → app Android → Huellas SHA.

El flujo de release requiere los cuatro secretos `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` y `ANDROID_KEY_PASSWORD`, analiza el proyecto, ejecuta pruebas y compila un APK release firmado. Google Sign-In real debe probarse en el teléfono después de registrar las huellas correspondientes.
