# Google Sign-In con Firebase

FORZA usa Firebase Authentication como proveedor de sesión. Android inicia Google Sign-In de forma nativa y cambia la credencial de Google por una sesión de Firebase; web usa el popup de Firebase. Después del inicio, la app crea o actualiza `users/{uid}` en Firestore. El inicio de sesión es opcional y los datos siguen disponibles localmente.

## Android

- Firebase project: `forza-6cd98`.
- Android application ID actual: `com.example.forza`.
- Archivo generado: `android/app/google-services.json`.
- El plugin Google Services se configura en Gradle; FlutterFire configura las opciones Dart.
- Registra en Firebase las huellas SHA-1 de cada certificado usado para firmar: debug para builds de prueba y release para el APK de GitHub. La pantalla de configuración de la app Android permite añadir ambas.
- La acción manual **Show Android signing fingerprint**, disponible en GitHub Actions después de integrar esta configuración en `main`, muestra la SHA-1 del certificado guardado en los secretos de release. Solo imprime la huella pública; no publica un APK.

Si tienes el keystore local, puedes consultar la huella con:

```powershell
keytool -list -v -keystore "C:\ruta\release.jks" -alias "ALIAS"
```

`keytool` solicitará la contraseña. En GitHub, los valores de los secretos no se pueden recuperar; usa la acción anterior para consultar su certificado.

## Firestore

La app sincroniza el contenido del respaldo local con una copia privada del usuario autenticado. Las reglas de `firestore.rules` limitan cada perfil y copia al UID de Firebase Authentication, y deniegan el acceso por defecto. Para el modelo y resolución de conflictos, consulta [Firebase y sincronización](firebase-sync.md).

## iOS y macOS

Los registros Firebase y opciones FlutterFire están creados. El URL scheme nativo de Google Sign-In todavía requiere completar los valores del cliente iOS en los archivos `Info.plist`; esta integración no se debe considerar validada en Apple hasta configurar y compilar en macOS con los identificadores OAuth finales.
