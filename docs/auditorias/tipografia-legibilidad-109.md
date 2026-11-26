# Auditoría de tipografía y legibilidad (#109)

## Criterios comunes

`AppTheme` es la fuente de roles tipográficos compartidos. Barlow se usa en interfaz y Barlow Condensed en títulos de display. La jerarquía mantiene tamaños de display 32/28, encabezados 24, títulos 18/16/14, cuerpo 16/14 y etiquetas 12/14, con interlineado explícito para títulos y cuerpo. Los componentes Material de AppBar, ListTile, navegación, botones y chips reutilizan estos roles. `AppSpacing` conserva la escala común de 4/8/12/16/24/32/48.

El contraste de texto primario, secundario y acciones principales se calcula en `test/app_theme_accessibility_test.dart` para fondos de ambos temas; las combinaciones comprobadas cumplen 4.5:1. El texto secundario se conserva en los tokens de alto contraste claro/oscuro y los elementos de marca mantienen sus estilos propios.

## Inventario por módulo

| Módulo / flujo | Hallazgo | Ajuste y comprobación |
| --- | --- | --- |
| Inicio | La animación de racha se escala dentro de un marco para preservar el arte del widget. | Se conserva como contenido gráfico, no texto de interfaz; las etiquetas siguen los roles compartidos. |
| Actividad y calendario | El texto de selección del calendario no heredaba un rol semántico completo. | Reutiliza `bodyMedium`; fechas seleccionadas añaden solo color/peso. Claro y oscuro cubiertos por tokens de tema. |
| Catálogo y detalle de ejercicios | Títulos/metadatos del catálogo podían cortarse. El pie de la tarjeta de ejercicio tenía una sola línea y ellipsis. El reverso dejaba espacio inferior sin aprovechar. | Los nombres y metadatos envuelven texto; las celdas tienen más altura; el pie de la tarjeta envuelve y la tarjeta crece según su contenido; el reverso reparte el espacio disponible y mantiene scroll para texto ampliado. Pruebas a 320/360/390/tablet y escalado 200%, ES/EN y temas claro/oscuro. |
| Sesión activa, preparación, calentamiento, descansos y resumen | Inspección de restricciones y roles: el contenido de entrenamiento usa estilos del tema y vistas con desplazamiento. | No se altera lógica ni estructura funcional. Los estilos de controles compartidos se centralizan en `AppTheme`; pruebas existentes de sesión mantienen cobertura. |
| Progreso y formularios | Gráfica pintaba etiquetas con `fontSize: 12` manual; el botón de ejercicio y opciones largas del formulario podían ellipsizar. Error del campo definía estilo fuera del tema. | Gráfica usa `labelSmall` escalado; selector y opciones permiten wrapping; error hereda `bodySmall`. |
| Perfil, preferencias, onboarding y diálogos | Se usan temas/controles comunes, con estilos locales limitados a jerarquía o color. | Botones y chips usan roles semánticos globales. No se requieren cambios de contenido o navegación. |
| Navegación inferior y lateral | Etiqueta inferior reducía su tamaño con `FittedBox` y solo permitía una línea. | Se eliminó la reducción automática; etiqueta usa `labelSmall`, envuelve hasta dos líneas y conserva semántica seleccionada. |

## Comparación visual registrada

El issue describe como referencia anterior la tarjeta «Para qué sirve»: pie auxiliar truncado en una línea y bloque de información agrupado en la parte superior, con espacio vacío al final. El cuerpo del issue no contiene un archivo de captura descargable. Tras el cambio, el pie envuelve sin perder texto y el reverso reparte el contenido verticalmente; los textos crecen con el escalado del sistema y permanecen desplazables si superan el área.

La comprobación visual reproducible queda en `test/exercise_detail_instructions_test.dart`: comprueba el pie completo y el reverso en teléfonos de 320, 360 y 390 px, tablet de 800 px, ambos temas, español/inglés y escala de texto 2×. El catálogo tiene también una prueba responsive hasta 2×. La comparación de contraste se ejecuta en `test/app_theme_accessibility_test.dart`. No se adjunta una imagen «antes» porque el issue no aporta el archivo fuente de la captura.

## Alcance y límites

La auditoría cubre jerarquía global, pantallas listadas arriba y patrones de truncamiento/tamaño manual localizados con búsqueda de código. Los textos de marca conservan sus tamaños expresivos; los datos de gráficas conservan sus restricciones geométricas. Las capturas de dispositivos iOS no se generan en este entorno; la documentación existente registra que no hay simulador iOS disponible.
