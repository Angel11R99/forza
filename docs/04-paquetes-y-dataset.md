# Paquetes y dataset

Consulta siempre pub.dev y el `pubspec.lock` antes de instalar: las versiones publicadas cambian. Los números abajo son la versión que aparecía en pub.dev el 20-11-2026 al preparar esta guía, no una orden de copiarla sin verificar.

## Reutilizar paquetes

| Necesidad | Opción para evaluar | Cuándo encaja |
|---|---|---|
| Rutas / navegación declarativa | [go_router](https://pub.dev/packages/go_router) (`18.1.4` consultado) | Rutas anidadas, deep links, redirecciones y `ShellRoute` para mantener una barra entre tabs. |
| Navbar lista configurable | [persistent_bottom_nav_bar_v2](https://pub.dev/packages/persistent_bottom_nav_bar_v2) | Si aún no hay barra elegida y se busca un componente con estilos predefinidos y personalización. Revisar compatibilidad con la versión de Flutter y su integración con el router. |
| Iconos | [lucide_flutter](https://pub.dev/packages/lucide_flutter) o [phosphor_icons](https://pub.dev/packages/phosphor_icons) | Elegir una sola familia coherente con el Figma. Confirmar versión, mantenimiento y licencia; no cambiar una dependencia existente sin razón. |
| Gráficos | [fl_chart](https://pub.dev/packages/fl_chart) (`1.3.1` consultado) | Líneas y barras para evolución/actividad; envolver en un widget FORZA para que el paquete no se filtre por todo el código. |
| Dibujar SVG | [flutter_svg](https://pub.dev/packages/flutter_svg) (`2.5.0` consultado) | Solo si el diseño incluye vectores SVG propios y no se cubre con el paquete iconográfico existente. |

`go_router` y un navbar visual resuelven responsabilidades diferentes; se pueden combinar, pero no añadir dos soluciones de navbar. Si el proyecto ya usa otro router, documentar la decisión y seguir con él.

## Criterio de adopción

Antes de añadir cada paquete:

1. Buscar si el proyecto ya lo incluye (`pubspec.yaml`/`pubspec.lock`) o si existe un componente compartido equivalente.
2. Revisar versión estable, SDK mínimo, changelog, licencia, actividad de mantenimiento, issues relevantes y soporte de plataformas objetivo.
3. Añadir solo la dependencia necesaria; fijar una restricción compatible y registrar por qué se eligió.
4. Encapsular el paquete bajo un widget/adaptador de FORZA para facilitar reemplazarlo sin reescribir pantallas.

## Dataset de ejercicios (uso futuro)

Repositorio indicado: [hasaneyldrm/exercises-dataset](https://github.com/hasaneyldrm/exercises-dataset). El README consultado informa 1.324 registros con categorías, equipos, músculos, instrucciones en varios idiomas y rutas a miniaturas de 180×180 y GIFs. Incluye `data/exercises.json` y un JSON Schema.

### Licencia: separar datos de medios

El README declara MIT para código, estructura de datos/texto de instrucciones, pero especifica que las imágenes y GIFs son de Gym visual y que el uso de esos medios se rige por los términos de Gym visual. El propio README pide mantener la atribución `© Gym visual — https://gymvisual.com/` y obtener licencia propia antes de reutilizar los medios. Por tanto:

- No distribuir GIFs ni imágenes dentro de FORZA basándose únicamente en la licencia MIT del repositorio.
- Verificar con Gym visual permiso comercial, redistribución en aplicación, almacenamiento/caché, atribución y límites de uso antes de integrar medios.
- Si no se obtiene una licencia apropiada, utilizar solo los datos cuyo uso esté cubierto y conseguir imágenes/animaciones de una fuente licenciada de forma independiente.
- Mantener `ExerciseMedia` desacoplado del JSON: una fuente de datos no debe decidir cómo se representa el componente.
- Las animaciones son fase futura: definir estados de carga/error, fallback y tamaño estable; cargar bajo demanda y no bajar el catálogo completo al abrir la app.

Estructura conceptual para más adelante:

```text
Exercise(id, name, bodyPart, target, equipment, instructionsByLocale, media)
ExerciseRepository.search(query, filters, page)
ExerciseMedia(thumbnail, animation, attribution, licenseStatus)
```

La disponibilidad técnica de un URL público no equivale a permiso de reutilización.
