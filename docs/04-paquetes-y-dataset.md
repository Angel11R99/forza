# Paquetes y dataset

Consulta siempre pub.dev y el `pubspec.lock` antes de instalar: las versiones publicadas cambian. Los números abajo son la versión que aparecía en pub.dev el 20-11-2026 al preparar esta guía, no una orden de copiarla sin verificar.

## Reutilizar paquetes

| Necesidad | Opción para evaluar | Cuándo encaja |
|---|---|---|
| Componentes Material | [material_ui](https://pub.dev/packages/material_ui) (`^1.11.1`, resuelto en lockfile) | API Material desacoplada de Flutter SDK para Flutter 3.47+; requerida por `native_glass_navbar` 2.x. |
| Calendario | [table_calendar](https://pub.dev/packages/table_calendar) (`^3.3.0`, resuelto en lockfile) | Calendario mensual con selección, marcadores de sesiones, gestos y estilos FORZA; configurado con locale `es_DO` y semana desde lunes. |
| Rutas | `Navigator`/`MaterialApp` de Flutter | Seleccionado para el primer hito; no se agrega `go_router` mientras no haya necesidad de deep links o redirecciones. |
| Navbar iOS | [native_glass_navbar](https://pub.dev/packages/native_glass_navbar) (`^2.0.0`, resuelto en lockfile) | Seleccionado junto con `material_ui ^1.11.1`, la API vigente en Flutter 3.50.1. El plugin iOS admite hasta cinco pestañas; Android usa el fallback Flutter. iOS requiere Xcode 27 o posterior. |
| Navbar lista configurable | [persistent_bottom_nav_bar_v2](https://pub.dev/packages/persistent_bottom_nav_bar_v2) | Alternativa si aún no hay barra elegida y se busca un componente personalizable multiplataforma. Revisar compatibilidad con la versión de Flutter y su integración con el router. |
| Iconos | [lucide_flutter](https://pub.dev/packages/lucide_flutter) o [phosphor_icons](https://pub.dev/packages/phosphor_icons) | Elegir una sola familia coherente con el Figma. Confirmar versión, mantenimiento y licencia; no cambiar una dependencia existente sin razón. |
| Gráficos | [fl_chart](https://pub.dev/packages/fl_chart) (`1.3.1` consultado) | Líneas y barras para evolución/actividad; envolver en un widget FORZA para que el paquete no se filtre por todo el código. |
| Dibujar SVG | [flutter_svg](https://pub.dev/packages/flutter_svg) (`2.5.0` consultado) | Solo si el diseño incluye vectores SVG propios y no se cubre con el paquete iconográfico existente. |

El router y la barra resuelven responsabilidades diferentes. En el primer hito FORZA usa navegación Flutter nativa y un paquete de barra únicamente para la presentación iOS; Android recibe el fallback propio. No se añade otro paquete de navbar.

## Criterio de adopción

Antes de añadir cada paquete:

1. Buscar si el proyecto ya lo incluye (`pubspec.yaml`/`pubspec.lock`) o si existe un componente compartido equivalente.
2. Revisar versión estable, SDK mínimo, changelog, licencia, actividad de mantenimiento, issues relevantes y soporte de plataformas objetivo.
3. Añadir solo la dependencia necesaria; fijar una restricción compatible y registrar por qué se eligió.
4. Encapsular el paquete bajo un widget/adaptador de FORZA para facilitar reemplazarlo sin reescribir pantallas.

## Dataset de ejercicios

Fuente integrada: [jlfernandezfernandez/exercises-dataset-es](https://github.com/jlfernandezfernandez/exercises-dataset-es), fijada en `5a5dd652f102c34bb09fcb0db3c2f3ae4dd53cbe`, más los nombres e instrucciones en inglés de [hasaneyldrm/exercises-dataset](https://github.com/hasaneyldrm/exercises-dataset), fijado en `7455efae41b330c265e7cd4b78dfa848e7ce5ebd`. Los 1.324 IDs coinciden. La importación conserva nombres e instrucciones en ambos idiomas, mapea equipo/grupo a etiquetas FORZA y elimina las referencias a medios del dataset upstream. El transformador está en `tool/import_exercise_dataset.py`; procedencia y licencias están en `third_party/exercises-dataset/`. Regenera ambos idiomas con `python tool/import_exercise_dataset.py <ruta-json-español> <ruta-json-inglés>`.

FORZA incluye además ilustraciones animadas vectoriales bajo `third_party/flow-exercise-dataset/`, separadas del dataset upstream. Su procedencia, alcance de licencia y limitaciones están descritos en `third_party/flow-exercise-dataset/NOTICE.md`.

### Licencia: separar datos de medios

El README declara MIT para código, estructura de datos/texto de instrucciones, pero especifica que las imágenes y GIFs son de Gym visual y que el uso de esos medios se rige por los términos de Gym visual. El README pide mantener la atribución `© Gym visual — https://gymvisual.com/` y obtener licencia propia antes de reutilizar los archivos del dataset. La licencia oficial permite usar medios de alta resolución sin marca de agua que se hayan comprado para ilustrar aplicaciones iOS/Android y otros medios electrónicos. También prohíbe revender o redistribuir esos medios y asignar sus derechos a terceros; para cualquier uso dudoso, remite a soporte. [Licencia oficial](https://gymvisual.com/content/9-license). Por tanto:

- No distribuir los archivos que vienen en el dataset basándose únicamente en la licencia MIT del repositorio.
- Antes de integrar medios comprados, confirmar con Gym visual que el empaquetado en la app, la caché/descarga bajo demanda y el alcance de distribución de FORZA cumplen la prohibición de redistribución. Conservar comprobantes de compra y la atribución pedida por el README del dataset.
- Si no se obtiene una licencia apropiada, utilizar solo los datos cuyo uso esté cubierto y conseguir imágenes/animaciones de una fuente licenciada de forma independiente.
- Mantener `ExerciseMedia` desacoplado del JSON: una fuente de datos no debe decidir cómo se representa el componente.
- Las animaciones vectoriales locales se usan con controles de pausa y respeto a la preferencia de movimiento reducido. Videos y medios externos siguen fuera hasta tener una fuente y licencia revisadas.

Estructura conceptual para más adelante:

```text
Exercise(id, name, bodyPart, target, equipment, instructionsByLocale, media)
ExerciseRepository.search(query, filters, page)
ExerciseMedia(thumbnail, animation, attribution, licenseStatus)
```

La disponibilidad técnica de un URL público no equivale a permiso de reutilización.

### Guías de ejecución

El detalle de ejercicios presenta las animaciones locales disponibles y los pasos del catálogo. Las notas técnicas curadas cubren familias reconocibles del catálogo (bisagras/peso muerto, sentadilla, zancada, flexiones, press de pecho y hombro, remos, dominadas, plancha frontal, crunch, curl de bíceps, curl femoral, extensión de piernas, pantorrillas, step-up y puente de glúteos). Cada familia muestra la referencia de ACE que sustenta sus indicaciones; el peso muerto rumano conserva además sus notas específicas. No se infieren errores para ejercicios que no coinciden con una familia revisada.

El catálogo dispone de 1.257 animaciones vectoriales locales para 1.324 ejercicios. Los ejercicios sin una animación correspondiente conservan la ilustración de grupo muscular y los pasos escritos; la vista los identifica como ejercicios sin animación, en vez de sugerir que hay una. Las animaciones disponibles se presentan como ilustraciones orientativas, no como certificación técnica ni prescripción de ritmo.
