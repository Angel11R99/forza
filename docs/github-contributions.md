# Configuración del repositorio en GitHub

## Mantenedores y estados

Las Issue Forms agregan `status:pending-review`. El workflow sugiere Issues parecidos sin cerrarlos automáticamente. El propietario o un colaborador con permiso `admin` o `maintain` puede aprobar, rechazar o marcar un duplicado aplicando la etiqueta correspondiente; el workflow descarta estados aplicados por otros usuarios y mantiene un único estado. Asignar una propuesta aprobada la marca en progreso. El responsable de la Issue debe ser el autor del PR, excepto cuando un mantenedor registra `contrib:exception-approved`.

Las etiquetas definidas en `.github/labels.json` se crean o actualizan sin borrar etiquetas ajenas mediante `pwsh tool/sync_github_labels.ps1 -Repository Angel11R99/forza` (requiere `gh` autenticado con permisos de etiquetas).

## Protección de `main`

La rama `main` ya tiene protección aplicada en GitHub: requiere Pull Request, una aprobación, descarta aprobaciones obsoletas, exige `contribution-policy` y `flutter-checks`, exige resolver conversaciones, bloquea force-push y borrado, e incluye a administradores. Como las nuevas definiciones de Actions aún deben llegar a `main`, GitHub mostrará los checks requeridos una vez que los workflows estén en la rama base. La protección se administra desde Settings → Branches y no desde archivos versionados.

## APK firmado

El workflow **Publish Android APK** solo se inicia manualmente desde Actions, con `main` seleccionado y por el propietario del repositorio. Configura estos repository secrets con la clave de firma de producción existente:

- `ANDROID_KEYSTORE_BASE64`: contenido del keystore existente codificado en Base64.
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

No se genera una clave nueva. Sin cualquiera de estos secretos, la publicación falla antes de compilar. El workflow valida, ejecuta análisis y pruebas, genera únicamente el APK release firmado, crea el tag y adjunta `forza-vX.Y.Z.apk` con notas automáticas. No ejecutes el workflow desde una rama distinta de `main`.

## Límites de GitHub

GitHub no impide que terceros desarrollen en ramas privadas o en forks. La asignación, rama con nombre convenido y política de PR controlan qué contribuciones acepta el proyecto. GitHub no puede evitar todos los bypass si se cambia la configuración de protección. La publicación requiere secrets configurados en GitHub; los archivos de este repositorio no crean esas credenciales.
