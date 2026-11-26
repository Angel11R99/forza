# Contribuir a FORZA

FORZA es una aplicación Flutter para organizar entrenamientos, explorar ejercicios y seguir el progreso. Agradecemos propuestas para sus módulos de inicio, ejercicios, actividad, progreso, perfil, incorporación, localización y datos locales.

## Flujo

1. Abre un Issue con una de las plantillas: error, mejora o funcionalidad. El Issue queda pendiente de revisión; las coincidencias posibles se sugieren para revisión humana.
2. Espera la decisión del mantenedor. Solo el propietario o alguien con permiso `admin`/`maintain` puede cambiar las etiquetas de estado. Una etiqueta `status:approved` significa que la propuesta puede desarrollarse.
3. Cuando un Issue esté aprobado, cualquier persona puede trabajarlo. Antes de empezar, confirma que no haya otro PR abierto para ese Issue. Usa una rama con el número del Issue: `issue/42-descripcion-corta` (minúsculas, números y guiones). No es necesario pedir que te asignen el Issue.
4. Abre un Pull Request hacia `main`. Incluye `Closes #42` y un resumen breve del cambio. Solo puede haber un PR abierto por Issue. GitHub cerrará el Issue automáticamente cuando el PR se integre.
5. Atiende las observaciones y espera la revisión y aprobación final. Los PR deben pasar `contribution-policy`, `flutter-checks` y la revisión requerida por la protección de `main`.

Ejemplo: si el Issue #42 está aprobado y no tiene un PR abierto, trabaja en `issue/42-filtro-ejercicios` y abre un PR cuya descripción incluya `Closes #42`.

## Comprobaciones locales

```sh
flutter pub get
flutter analyze --fatal-infos
flutter test
```
