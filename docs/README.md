# FORZA · Guía de implementación

> Guía basada en el archivo [`FORZA — Premium Fitness Experience.fig`](figma/FORZA%20%E2%80%94%20Premium%20Fitness%20Experience.fig) y el estado del repositorio al 24-11-2026. Cuando esta guía difiera del código, prevalece el código y debe corregirse la documentación.

## En una frase

FORZA es una app Flutter con flujos de entrenamiento locales y respaldo remoto Firebase opcional con consentimiento. Este índice enlaza la documentación de arquitectura, UI y datos; el estado funcional y las prioridades vigentes están en [README](../README.md), [auditoría de módulos](07-auditoria-modulos-indispensables.md) y [módulos recomendados](08-modulos-recomendados.md).

## Documentos

- [Guía de implementación](01-implementacion.md): alcance, arquitectura sugerida, estructura Flutter y secuencia de trabajo.
- [Pantallas y módulos](02-modulos-y-pantallas.md): inventario de los flujos observados en Figma y su agrupación.
- [Sistema visual](03-sistema-visual.md): colores confirmados, reglas de forma y adaptación responsive.
- [Paquetes y dataset](04-paquetes-y-dataset.md): opciones de pub.dev, criterios de selección y condiciones de medios.
- [Agentes y skills](05-agentes-y-skills.md): roles recomendados, skills que ayudan y cómo colaborar con agentes.
- [Propuesta Gym Bro](12-diseno-gym-bro.md): alcance MVP, UX, consentimiento, rachas, sincronización, seguridad, costes y alertas; pendiente de aprobación antes de implementar.
- [Configuración de Google Sign-In](google-sign-in-setup.md): IDs OAuth, autenticación Firebase y pasos Android/iOS; no contiene secretos.

## Alcance que se asume

- La navegación usa `MaterialApp`/`Navigator` y widgets Flutter propios: barra inferior en pantallas estrechas y `NavigationRail` en anchas.
- La apariencia y el idioma se guardan localmente; preferencias del plan (incluidos movimientos a evitar), agenda, sesiones, series y objetivos usan SQLite/Drift.
- El acceso con Google es opcional; el respaldo Firestore se activa por separado con consentimiento. Ver [Firebase y sincronización](firebase-sync.md).
- El catálogo tiene 1.324 ejercicios y 1.257 animaciones vectoriales locales con fallback escrito/visual. Los medios upstream de terceros no se redistribuyen.

## Estado del proyecto consultado

El árbol `lib/` contiene las cinco áreas de navegación, configuración de plan, sesión guiada, calendario y reprogramación persistentes, catálogo local de ejercicios, historial y progreso. Las medidas, la evolución de fuerza y los récords personales se calculan desde datos guardados. `material_ui ^1.11.1` está declarado; `native_glass_navbar` no forma parte de `pubspec.yaml` ni `pubspec.lock`. No hay backend ni sincronización.

## Decisiones de la primera entrega

1. Conservar entrenamiento local sin cuenta y permitir una copia remota Firestore opcional, privada por UID y activada con consentimiento.
2. Usar cinco pestañas: Inicio, Actividad, Ejercicios, Progreso y Perfil. El plugin iOS admite cinco y Android usa fallback Flutter.
3. Mantener sin HEX el acento hasta validarlo en Figma. No distribuir imágenes o GIFs de terceros hasta confirmar sus términos de licencia.

