# Contribuir a FORZA

FORZA es una aplicación Flutter para organizar entrenamientos, explorar ejercicios y seguir el progreso. Agradecemos propuestas para sus módulos de inicio, ejercicios, actividad, progreso, perfil, incorporación, localización y datos locales.

## Flujo

1. Abre un Issue con una de las plantillas: error, mejora o funcionalidad. El Issue queda pendiente de revisión; las coincidencias posibles se sugieren para revisión humana.
2. Espera la decisión del mantenedor. Solo el propietario o alguien con permiso `admin`/`maintain` puede cambiar las etiquetas de estado. Una etiqueta `status:approved` significa que la propuesta puede desarrollarse.
3. Después de la aprobación, solicita que te asignen el Issue. No empieces una contribución oficial antes de estar asignado. La rama debe llamarse `issue/42-descripcion-corta` (minúsculas, números y guiones), usando el número asignado.
4. Abre un Pull Request hacia `main`. Incluye `Closes #42`, resume el cambio y explica cómo lo comprobaste. Solo puede haber un PR abierto por Issue; el autor debe ser la persona asignada, salvo una excepción registrada por el mantenedor.
5. Atiende las observaciones y espera la revisión y aprobación final. Los PR deben pasar `contribution-policy`, `flutter-checks` y la revisión requerida por la protección de `main`.

Ejemplo: si te asignan el Issue #42, trabaja en `issue/42-filtro-ejercicios` y abre un PR cuya descripción incluya `Closes #42`.

## Comprobaciones locales

```sh
flutter pub get
flutter analyze --fatal-infos
flutter test
```
