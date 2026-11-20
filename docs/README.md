# FORZA · Guía de implementación

> Guía basada en el archivo `FORZA — Premium Fitness Experience.fig` y el starter Flutter que existe en `C:\Users\User\Documents\forza` al 20-11-2026.

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
- Se conserva el paquete de iconos/navbar que el equipo elija; el diseño no obliga a dibujar esos elementos desde cero.
- El foco de esta guía es estructura visual, color, espaciado, componentes de interfaz y rutas.
- Animaciones de ejercicios: integrarlas en otra fase, después de resolver derechos de uso de cada medio.
- Las páginas de ajustes y perfil aparecen en el Figma; su backend y lógica de cuenta no forman parte de una primera entrega visual.

## Estado del proyecto consultado

El árbol `lib/` contiene solo `main.dart`; `pubspec.yaml` declara Flutter SDK y `cupertino_icons`. La guía propone una arquitectura inicial para ese starter, no afirma que esos módulos o paquetes ya estén implementados.

## Decisiones pendientes antes de construir

1. Confirmar cuál paquete de navbar/iconos ya usa el equipo y su versión actual.
2. Confirmar el alcance del primer hito: demo navegable, UI lista para API, o producto conectado.
3. Conseguir una licencia adecuada para GIFs/imágenes del dataset si se desean distribuir en la app.
4. Resolver y fijar el color de acento exacto desde el archivo editable; el tono menta se aprecia visualmente, pero la inspección disponible no verificó su HEX.
