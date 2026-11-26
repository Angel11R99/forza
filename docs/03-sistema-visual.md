# Sistema visual FORZA

## Lectura del diseño

La hoja contiene pantallas móviles de 393 × 852 px (dimensiones de un frame de ejercicio observado) y una apariencia principalmente clara: fondo/superficies claras, texto carbón, divisores grises y fotografías de ejercicios. Se ven botones negros de ancho amplio y un acento verde/menta usado en algunas selecciones/estados.

## Paleta FORZA de implementación

Paleta simplificada a neutrales claros a partir de la referencia compartida: fondo cálido casi blanco, superficies blancas, texto carbón y un gris neutro para bloques suaves. El verde queda fuera de la interfaz general. Estos valores son tokens de implementación; no se presentan como mediciones del archivo `.fig`.

| Token provisional | HEX | Uso sugerido |
|---|---:|---|
| `surfaceSoft` | `#FAFAF8` | Fondo cálido de la app. |
| `textPrimary` | `#1F211E` | Texto y elementos oscuros. |
| `textSecondary` | `#686B66` | Texto auxiliar. |
| `surface` | `#FFFFFF` | Superficies blancas. |
| `surfaceMuted` | `#F0F1EE` | Fondo neutro suave para iconos y selecciones. |
| `divider` | `#E7E8E5` | Bordes y divisores discretos. |
| `accent` | **Pendiente** | El prototipo muestra un acento menta/verde; no se verificó su valor HEX, por tanto no copiar un valor aproximado a producción. |

La capa seleccionada también mostraba un color de página `#1E1E1E` en el editor, pero el canvas visible detrás de los teléfonos es el fondo de Figma, no necesariamente el fondo de la app. No usarlo como token de aplicación sin confirmar el nodo.

## Forma y jerarquía

Reglas de interfaz para trasladar a Flutter:

- Diseño móvil, contenido vertical en secciones, encabezados simples y jerarquía de texto clara.
- Tarjetas blancas con bordes finos para sesiones, ejercicios, estadísticas y preferencias.
- Botones de alto contraste con esquinas moderadas, sin forma de píldora.
- Imágenes de ejercicios integradas como bloques destacados y miniaturas.
- Navegación inferior común visible en muchos frames.
- Gráficas de barras/líneas simples para evolución y métricas.
- Evitar fondos saturados, gradientes, sombras decorativas, etiquetas en mayúsculas y ornamentos que no expliquen una acción.

Los radios, espacios y tipografías exactos requieren revisión del frame con zoom/inspector. Como punto de partida de implementación, define escalas únicas (por ejemplo 4/8/12/16/24/32) y radios semánticos, y ajústalas comparando con Figma; no son medidas confirmadas por el archivo.

## Tokens Flutter propuestos

Crear constantes semánticas para:

```dart
// Tokens neutrales de FORZA; el acento sigue pendiente de revisión en Figma.
class AppColors {
  static const textPrimary = Color(0xFF1F211E);
  static const textSecondary = Color(0xFF686B66);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFFAFAF8);
  static const surfaceMuted = Color(0xFFF0F1EE);
  static const divider = Color(0xFFE7E8E5);
  // static const accent = Color(...); // pendiente de verificación
}
```

Evitar que el ejemplo se copie con un color de acento inventado. Conectar después a `ColorScheme`/`ThemeData`, y hacer que botones, chips, estados seleccionados y navbar reciban el mismo token de acento.

## Responsive y accesibilidad

- Tratar 393 × 852 como el tamaño de referencia de un frame, no como tamaño fijo de dispositivo.
- Usar SafeArea, constraints, scroll y widgets flexibles; evitar `Positioned` absoluto para contenido común.
- Verificar targets táctiles, contraste, escalado de texto, labels semánticos en iconos funcionales y foco visible.
- En pantallas estrechas y con texto ampliado, apilar los encabezados con acciones y permitir que las etiquetas de navegación envuelvan el texto sin reducir la fuente.
- Respetar `disableAnimations` en cambios de destino y exponer nombre, selección y acción de cada pestaña en Semantics.
- Imágenes remotas: definir proporción, `BoxFit`, placeholder, error y caché; evitar saltos de layout.
- Revisar modo oscuro solo si el producto lo solicita; no asumir que el panel oscuro de Figma representa una variante oscura de la app.

### Validación de accesibilidad y adaptación

- Prueba de widgets: shell a 320 × 800 con escalado de texto 2× y movimiento reducido, y a 800 × 320 en horizontal; comprueba nombres, acción, selección y target táctil mínimo de 48 dp en navegación.
- Contraste automatizado: texto primario/secundario y acciones principales con al menos 4,5:1 en los fondos de los temas claro y oscuro.
- Emulador Android 16 (API 36): navegación y búsqueda de ejercicios; el teclado en pantalla deja visible el campo de búsqueda. La pantalla Inicio también se inspeccionó con escala de fuente del sistema en 2×.
- No hay simulador iOS disponible en este entorno; VoiceOver y pruebas en dispositivo iOS siguen pendientes.
