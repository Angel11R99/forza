# Sistema visual FORZA

## Lectura del diseño

La hoja contiene pantallas móviles de 393 × 852 px (dimensiones de un frame de ejercicio observado) y una apariencia principalmente clara: fondo/superficies claras, texto carbón, divisores grises y fotografías de ejercicios. Se ven botones negros de ancho amplio y un acento verde/menta usado en algunas selecciones/estados.

## Colores confirmados en las propiedades observadas

| Token provisional | HEX | Uso sugerido |
|---|---:|---|
| `surfaceSoft` | `#FAFAFA` | Fondo/superficie clara observada en un frame. |
| `textPrimary` | `#111111` | Texto y elementos oscuros. |
| `textSecondary` | `#666666` | Texto auxiliar. |
| `surface` | `#FFFFFF` | Superficies blancas. |
| `surfaceMuted` | `#D6DED2` | Tono gris verdoso claro observado; reservar a fondo/estado suave hasta confirmar su uso exacto. |
| `accent` | **Pendiente** | El prototipo muestra un acento menta/verde; no se verificó su valor HEX, por tanto no copiar un valor aproximado a producción. |

La capa seleccionada también mostraba un color de página `#1E1E1E` en el editor, pero el canvas visible detrás de los teléfonos es el fondo de Figma, no necesariamente el fondo de la app. No usarlo como token de aplicación sin confirmar el nodo.

## Forma y jerarquía

Observaciones cualitativas para trasladar a Flutter:

- Diseño móvil, contenido vertical en secciones, encabezados simples y jerarquía de texto clara.
- Tarjetas y paneles para sesiones, ejercicios, estadísticas y preferencias.
- Botones principales oscuros y de ancho amplio en distintas pantallas.
- Imágenes de ejercicios integradas como bloques destacados y miniaturas.
- Navegación inferior común visible en muchos frames.
- Gráficas de barras/líneas simples para evolución y métricas.

Los radios, espacios y tipografías exactos requieren revisión del frame con zoom/inspector. Como punto de partida de implementación, define escalas únicas (por ejemplo 4/8/12/16/24/32) y radios semánticos, y ajústalas comparando con Figma; no son medidas confirmadas por el archivo.

## Tokens Flutter propuestos

Crear constantes semánticas para:

```dart
// Ejemplo estructural; sustituir el HEX de accent tras inspeccionarlo en Figma.
class AppColors {
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF666666);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFFAFAFA);
  static const surfaceMuted = Color(0xFFD6DED2);
  // static const accent = Color(...); // pendiente de verificación
}
```

Evitar que el ejemplo se copie con un color de acento inventado. Conectar después a `ColorScheme`/`ThemeData`, y hacer que botones, chips, estados seleccionados y navbar reciban el mismo token de acento.

## Responsive y accesibilidad

- Tratar 393 × 852 como el tamaño de referencia de un frame, no como tamaño fijo de dispositivo.
- Usar SafeArea, constraints, scroll y widgets flexibles; evitar `Positioned` absoluto para contenido común.
- Verificar targets táctiles, contraste, escalado de texto, labels semánticos en iconos funcionales y foco visible.
- Imágenes remotas: definir proporción, `BoxFit`, placeholder, error y caché; evitar saltos de layout.
- Revisar modo oscuro solo si el producto lo solicita; no asumir que el panel oscuro de Figma representa una variante oscura de la app.
