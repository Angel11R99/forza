# FORZA · Guía de implementación

> Guía basada en el archivo [`FORZA — Premium Fitness Experience.fig`](figma/FORZA%20%E2%80%94%20Premium%20Fitness%20Experience.fig) y el starter Flutter que existe en `C:\Users\User\Documents\forza` al 20-11-2026.

## En una frase

Implementar las pantallas y el lenguaje visual FORZA en Flutter, reutilizando paquetes maduros para navegación, iconos y gráficos. La primera entrega es de UI y navegación; los datos reales, persistencia, autenticación y animaciones de ejercicios se conectan en etapas posteriores.

## Documentos

- [Guía de implementación](01-implementacion.md): alcance, arquitectura sugerida, estructura Flutter y secuencia de trabajo.
- [Pantallas y módulos](02-modulos-y-pantallas.md): inventario de los flujos observados en Figma y su agrupación.
- [Sistema visual](03-sistema-visual.md): colores confirmados, reglas de forma y adaptación responsive.
- [Paquetes y dataset](04-paquetes-y-dataset.md): opciones de pub.dev, criterios de selección y condiciones de medios.
- [Agentes y skills](05-agentes-y-skills.md): roles recomendados, skills que ayudan y cómo colaborar con agentes.

## Alcance que se asume

- El proyecto objetivo es Flutter y el repositorio consultado es `C:\Users\User\Documents\forza`.
- La navegación del primer hito usa `Navigator`/`MaterialApp`; en iOS se integra `native_glass_navbar ^2.0.0` y en Android su fallback visual Flutter.
- El foco de esta guía es estructura visual, color, espaciado, componentes de interfaz y rutas.
- Animaciones de ejercicios: integrarlas en otra fase, después de resolver derechos de uso de cada medio.
- Las páginas de ajustes y perfil aparecen en el Figma; su backend y lógica de cuenta no forman parte de una primera entrega visual.

## Estado del proyecto consultado

El árbol `lib/` contiene la base FORZA, las cinco áreas de navegación y los flujos de Actividad D2–D4 y Ejercicios E1–E5 con datos locales de demostración. `material_ui ^1.11.1` y `native_glass_navbar ^2.0.0` están declarados y resueltos en `pubspec.lock`. Progreso y Cuenta tienen pantallas de entrada, aún sin sus flujos completos.

## Decisiones de la primera entrega

1. Entregar una demo navegable de UI con contenido de presentación; datos reales, persistencia y autenticación quedan fuera.
2. Usar cinco pestañas: Inicio, Actividad, Ejercicios, Progreso y Perfil. El plugin iOS admite cinco y Android usa fallback Flutter.
3. Mantener sin HEX el acento hasta validarlo en Figma. No distribuir imágenes o GIFs de terceros hasta confirmar sus términos de licencia.

