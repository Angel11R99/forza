# Revisión del plan nutricional · Issue #147

## Flujo entregado

- El repaso aparece en Nutrición después de 14 días sin revisión. Se puede abrir manualmente desde Nutrición o desde Progreso.
- La frecuencia puede cambiarse a 2 o 4 semanas, posponerse por 7 días o desactivarse. Los cambios del perfil después de una revisión vuelven a habilitar la sugerencia; durante el aplazamiento se respeta la fecha elegida.
- Energía, apetito, facilidad de recetas, acceso a alimentos, recuperación y rendimiento son preguntas opcionales. Las respuestas se guardan localmente; no se envían a la nube ni se usan para ajustar el plan de forma automática.
- Editar preferencias desde el repaso abre el perfil como borrador. El plan se vuelve a generar para una vista previa; el perfil y el plan actual no se guardan hasta que la persona acepta. Si el catálogo no puede formar un menú compatible, no se permite aplicar esa propuesta.
- Mantener el plan cierra el repaso sin cambiar el perfil ni el historial. Al aceptar una versión nueva, el ID del plan incluye la versión del perfil; los registros de comidas previos se conservan.

## Comprobaciones

- `flutter analyze --no-pub`: limpio.
- `flutter test`: suite completa aprobada.
- `flutter build apk --debug`: APK generado.
- Emulador Android 16: navegación Progreso → Nutrición → repaso en español y menú de frecuencia revisados visualmente. Capturas: `evidence-147-review-android.png` y `evidence-147-review-cadence-android.png`.
- Widget tests: ancho 320 dp, escala de texto 2×, español/inglés y temas claro/oscuro para Nutrición; persistencia del repaso, aplazamiento, intervalos configurables y mantenimiento del plan actual.

## Pendiente

- iOS/VoiceOver no se pudo probar desde este entorno Windows.
- TalkBack y una revisión por profesional cualificado aún requieren comprobación independiente. Las respuestas del repaso son contexto para la persona y no se interpretan como evaluación médica.
