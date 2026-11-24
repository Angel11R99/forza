# Configuración de Google Sign-In

FORZA permite seguir como invitado. El inicio con Google solo valida la identidad con el proveedor y muestra nombre, correo y foto en el perfil; no crea una cuenta de servidor ni sincroniza entrenamientos. El paquete oficial usado es [`google_sign_in`](https://pub.dev/packages/google_sign_in) 7.2.0, con API de autenticación básica y sin permisos adicionales.

## OAuth de Android

1. En Google Cloud, configura la pantalla de consentimiento y crea un cliente OAuth de tipo Android con el `applicationId` de FORZA y el SHA-1 del certificado de cada variante.
2. El identificador Android actual del repositorio es `com.example.forza`, un valor de plantilla. Define primero el ID final de publicación y crea el cliente OAuth con ese ID antes de distribuir la app.
3. Crea también un cliente OAuth de tipo Web en el mismo proyecto. Como el proyecto no usa `google-services.json` ni Firebase, el cliente Android de `google_sign_in` requiere ese ID Web como `serverClientId`:

```powershell
flutter run --dart-define=FORZA_GOOGLE_ANDROID_SERVER_CLIENT_ID=CLIENTE_WEB.apps.googleusercontent.com
```

El ID de cliente OAuth no es un secreto. No agregues al repositorio claves privadas, client secrets ni tokens. El SDK registra el paquete Android junto al SHA-1; configura tanto la firma de depuración como la firma definitiva de Play.

## OAuth de iOS

1. Crea un cliente OAuth de tipo iOS que use el bundle ID actual `com.example.forza`. Este también es un identificador de plantilla y debe definirse antes de publicación.
2. Configura `FORZA_GOOGLE_IOS_CLIENT_ID` como Dart define al compilar:

```powershell
flutter run --dart-define=FORZA_GOOGLE_IOS_CLIENT_ID=CLIENTE_IOS.apps.googleusercontent.com
```

3. En `ios/Runner/Info.plist`, define `GIDClientID` con ese mismo ID y reemplaza `FORZA_GOOGLE_IOS_REVERSED_CLIENT_ID` por el valor `REVERSED_CLIENT_ID` del cliente iOS (formato `com.googleusercontent.apps.…`). El URL scheme es obligatorio para retornar de Google a la app.
4. Prueba en un dispositivo con firma Apple configurada. El simulador iOS no está disponible en el entorno actual.

No se configura `GIDServerClientID` porque FORZA no tiene backend. Tampoco se solicita acceso a contactos, Drive, calendario u otros datos.

## Alcance de privacidad y validación

- El usuario puede omitir Google y usar las funciones locales.
- Iniciar, cerrar o cambiar la cuenta no modifica SQLite, las preferencias, los respaldos ni los entrenamientos.
- FORZA no persiste el correo, foto, ID de Google ni tokens en sus tablas locales; la identidad se conserva en memoria de la app. La sesión del proveedor se gestiona mediante el SDK del sistema.
- Cancelar el selector vuelve a la pantalla sin error; errores de configuración/conexión ofrecen un mensaje y permiten reintentar o seguir como invitado.
- Como el login es opcional y no desbloquea funciones, esta entrega no crea una cuenta primaria de FORZA. Si en el futuro se añaden funciones dependientes de una cuenta, revisar las reglas vigentes de [App Store Review 4.8](https://developer.apple.com/app-store/review/guidelines/) y de privacidad antes de decidir proveedores o backend.

La verificación automatizada puede cubrir estados, errores, cancelar, iniciar/cerrar y persistencia local. El flujo OAuth real requiere un proyecto de Google Cloud, los IDs de cliente y firmas correctas; no se puede validar en CI ni sin esos datos específicos de la app.
