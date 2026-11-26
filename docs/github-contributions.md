# Configuración del repositorio en GitHub

## Mantenedores y estados

Las Issue Forms agregan `status:pending-review`. El workflow sugiere Issues parecidos sin cerrarlos automáticamente. El propietario o un colaborador con permiso `admin` o `maintain` puede aprobar, rechazar o marcar un duplicado aplicando la etiqueta correspondiente; el workflow descarta estados aplicados por otros usuarios y mantiene un único estado. Una vez aprobado, cualquier contribuidor puede tomar el Issue; la asignación es opcional. El número del Issue determina la rama `issue/NN-descripcion-corta`. La política bloquea un segundo PR mientras haya otro PR abierto para el mismo Issue. La línea `Closes #NN` cierra el Issue automáticamente cuando se integra el PR en `main`.

Las etiquetas definidas en `.github/labels.json` se crean o actualizan sin borrar etiquetas ajenas mediante `pwsh tool/sync_github_labels.ps1 -Repository Angel11R99/forza` (requiere `gh` autenticado con permisos de etiquetas).

## Protección de `main`

La rama `main` ya tiene protección aplicada en GitHub: requiere Pull Request, una aprobación, descarta aprobaciones obsoletas, exige `contribution-policy` y `flutter-checks`, exige resolver conversaciones, bloquea force-push y borrado, e incluye a administradores. Como las nuevas definiciones de Actions aún deben llegar a `main`, GitHub mostrará los checks requeridos una vez que los workflows estén en la rama base. La protección se administra desde Settings → Branches y no desde archivos versionados.

## APK firmado

El workflow **Publish Android APK** solo se inicia manualmente desde Actions, con `main` seleccionado y por el propietario del repositorio. La ayuda del selector resume el uso de cada tipo; aquí se conservan los ejemplos completos. Ofrece seis tipos, partiendo de `v1.2.3`:

- `patch`: `v1.2.3` → `v1.2.4`.
- `minor`: `v1.2.3` → `v1.3.0`.
- `major`: `v1.2.3` → `v2.0.0`.
- `alpha`: `v1.2.3` → `v1.2.4-alpha.1`.
- `beta`: `v1.2.4-alpha.1` → `v1.2.4-beta.1`.
- `rc` (release candidate): `v1.2.4-beta.1` → `v1.2.4-rc.1`.

Los releases `alpha`, `beta` y `rc` se publican marcados como preliminares en GitHub. Sus números se incrementan por canal; al elegir `patch` después de una preliminar se publica la versión estable de esa misma base. `patch` sube el último número hasta `.99`; al desbordar, incrementa minor y reinicia patch, o incrementa major si minor ya está en `9`. `minor` reinicia patch y, al pasar de `9`, incrementa major. Si todavía no hay releases, usa la versión de `pubspec.yaml` como base.

Configura estos repository secrets con la clave de firma de producción existente:

- `ANDROID_KEYSTORE_BASE64`: contenido del keystore existente codificado en Base64.
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

No se genera una clave nueva. Sin cualquiera de estos secretos, la publicación falla antes de compilar. El workflow valida, ejecuta análisis y pruebas, genera únicamente el APK release firmado, crea el tag y adjunta `forza-vVERSION.apk` con notas automáticas. No ejecutes el workflow desde una rama distinta de `main`.

Para registrar Google Sign-In en Firebase, ejecuta **Show Android signing fingerprint** desde Actions, con `main` seleccionado. La acción imprime solo la SHA-1 pública de la clave configurada y no publica un APK. Registra esa huella junto con la SHA-1 debug en Firebase Console.

## Límites de GitHub

GitHub no impide que terceros desarrollen en ramas privadas o en forks. El estado aprobado, el nombre de rama convenido y la política de PR controlan qué contribuciones acepta el proyecto. GitHub no puede evitar todos los bypass si se cambia la configuración de protección. La publicación requiere secrets configurados en GitHub; los archivos de este repositorio no crean esas credenciales.
