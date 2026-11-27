# Issue #146: registro local de hidratación

## Implementado

- Acceso desde Nutrición > Hoy, también antes de configurar el perfil nutricional.
- Registro rápido con vaso y botella configurables, cantidad manual por tipo de bebida y visualización en ml/L. La meta diaria es opcional; no se propone un objetivo universal ni se estima agua desde alimentos.
- Historial local por fecha con edición de volumen/fecha, eliminación y deshacer. Las escrituras se serializan para evitar perder registros en toques rápidos. La pantalla distingue un día sin datos de un valor cero.
- Respaldo/restauración dentro del consentimiento de Nutrición. El filtro de sincronización elimina también la hidratación si ese consentimiento no está activo; una copia antigua sin datos de hidratación no borra datos nutricionales locales.
- Copys ES/EN, tema claro/oscuro, controles con etiquetas y objetivos táctiles nativos de al menos 48 dp.

## Comprobaciones

- `flutter analyze --no-pub`: sin problemas.
- `flutter test`: 208 pruebas aprobadas, incluidas pruebas de concurrencia, edición de fecha/volumen, metas optativas, restauración autorizada, exclusión por consentimiento y recorridos UI de vaso, cantidad manual, deshacer, ancho 320 dp y texto 2× en ES/EN y tema claro/oscuro.
- APK Android debug compilado e instalado en emulador Android 16. Capturas del estado vacío en claro y oscuro: [claro ES](evidence-146-android-welcome.png), [oscuro ES](evidence-146-android-welcome-dark-es.png).

## Pendiente de validación antes de cerrar

- No hay macOS/Xcode ni dispositivo/simulador iOS en este entorno; falta comprobar VoiceOver e iOS. TalkBack tampoco se probó manualmente. Los controles sí exponen nombres y acciones semánticas y están cubiertos por pruebas de widget.
- Validar teclado y selector de fechas en un dispositivo, y restauración desde una instalación limpia/dispositivo distinto.
- Falta revisión profesional del texto general de seguridad. No se publica una recomendación universal de volumen ni se calculan líquidos a partir de comidas hasta contar con esa revisión.

El issue debe seguir abierto con `status:approved` hasta completar estas comprobaciones de plataforma y accesibilidad.
