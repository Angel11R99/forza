# Guía de implementación Flutter

## Principios de trabajo

1. **Respetar la referencia visual.** Usar los frames A–G del archivo `.fig` como inventario; validar cada pantalla contra su frame y conservar la intención del diseño.
2. **Reutilizar.** Antes de crear navbar, icono, selector, gráficos, inputs o animaciones propias, revisar dependencias presentes y paquetes compatibles en pub.dev.
3. **Separar lo visual de lo funcional.** Widgets de presentación reciben datos/acciones; estado, rutas y repositorios van fuera de las vistas.
4. **Construir por flujo.** Completar un flujo pequeño de punta a punta para fijar patrones antes de propagar componentes por toda la app.
5. **No acoplar los GIFs.** El catálogo de ejercicios debe consumir un contrato de datos; su fuente de medios podrá cambiar tras revisar permisos/licencias.

## Arquitectura sugerida (ligera, feature-first)

No introducir capas/paquetes de arquitectura hasta que la necesidad lo justifique. Separar módulos por feature y compartir piezas de UI:

```text
lib/
  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_radius.dart
  core/
    widgets/                 # botones, superficies, campos, estados vacíos
    utils/
  features/
    onboarding/
      presentation/
    home/
      presentation/
    activity/
      presentation/
    exercises/
      data/                  # DTO, fuente de datos y repositorio al integrar datos
      domain/                # modelos/contratos solo si hacen falta
      presentation/
    progress/
      presentation/
    profile/
      presentation/
    settings/
      presentation/
```

Una pantalla debería ensamblar componentes del design system y widgets del módulo. Evitar un único `main.dart` gigante y también evitar crear una abstracción compartida para una sola aparición.

## Navegación

- Definir las cinco áreas principales sugeridas por el diseño: **Inicio**, **Actividad**, **Explorar ejercicios**, **Progreso** y **Perfil**.
- Mantener el navbar que el proyecto ya adopte. Si todavía no existe, evaluar `go_router` junto con la barra elegida; `ShellRoute` permite mantenerla visible entre destinos.
- Tratar onboarding, detalle de ejercicio, filtros, sesión/día e historial como rutas de detalle o subrutas, no como pestañas de primer nivel.
- Los nombres de ruta deben ser estables y semánticos (por ejemplo, `/exercises/:id`, `/activity/day/:date`).
- Al usar un paquete de navegación, confirmar comportamiento de Android Back, restauración de estado por pestaña, deep links y ocultar/mostrar barra en pantallas de detalle.

## Tema y widgets

Centralizar colores, tipografía, espaciado y radios. No dispersar HEX ni números mágicos por los widgets. Convertir colores en tokens semánticos (`background`, `surface`, `textPrimary`, `textSecondary`, `accent`, `divider`, `success`, `error`). El token `accent` queda pendiente de medir con precisión en Figma.

Componentes compartidos candidatos:

- `AppScaffold` (safe areas y estructura base; usa el navbar del paquete instalado).
- `PrimaryButton`, `SecondaryButton`, `SectionHeader`.
- `SurfaceCard`, `StatCard`, `ExerciseCard`.
- `SearchField`, `FilterChip`/filtro, `EmptyState`, `LoadingState`, `ErrorState`.
- `ProgressChart` como adaptador local sobre el paquete de gráficos elegido.

El diseño usa superficies claras, texto oscuro, secundarios grises, bloques fotográficos de ejercicios, tarjetas y botones anchos de alto contraste. Validar padding de sistema, teclado, texto largo y pantallas pequeñas.

## Fases recomendadas

### Fase 0 · Reconocimiento

- Revisar `pubspec.yaml`, `pubspec.lock`, `lib/` y el paquete real de navbar/iconos del equipo.
- Inspeccionar frames y prototipos en Figma; extraer el HEX del acento y tipografías si el fichero fuente lo permite.
- Acordar alcance y dependencias. No añadir una dependencia que duplique lo que ya usa el proyecto.

### Fase 1 · Cimientos visuales

- Añadir tema/tokens y definir `AppScaffold` integrando el navbar existente.
- Crear estados, botones, tarjetas y campos comunes.
- Preparar navegación y tamaños adaptativos.

### Fase 2 · Flujos de UI

Orden sugerido: Inicio/entrada → Actividad/calendario → Explorar/biblioteca y detalle → Progreso → Perfil/ajustes. Implementar los frames A–G por grupos, manteniendo cada vista en su feature.

### Fase 3 · Datos

- Definir modelo `Exercise` y contrato `ExerciseRepository` separado de widgets.
- Empezar con fixtures locales para verificar layouts; luego conectar API/dataset aprobado.
- Paginación/búsqueda/filtros deben resolverse en el origen de datos cuando exista catálogo real; no cargar todos los GIFs de golpe.

### Fase 4 · Medios animados y pulido

- Solo tras aprobación de licencia: crear un widget de media que acepte miniatura, URL/asset, estado de carga y fallback.
- Revisar rendimiento, accesibilidad, contraste y layouts largos en Android/iOS.

## Criterios de aceptación visual

- El orden y jerarquía de cada pantalla corresponden a su frame de referencia.
- Los colores salen de tokens centrales y el color de acento se fijó con un HEX verificado.
- La barra de navegación es la del paquete elegido y conserva su estilo mediante configuración/tema.
- Estados vacío, carga y error no colapsan el layout.
- Los formularios se desplazan con el teclado y los textos escalan sin recortes.
- Cada pantalla usa scroll y constraints adaptables en vez de asumir dimensiones fijas del mockup.
- No se empaquetan GIFs del dataset hasta verificar la licencia correspondiente.

## Notas sobre el repo existente

El proyecto revisado es un starter Flutter: `lib/main.dart` es la única fuente de app y `pubspec.yaml` solo incluye Flutter y `cupertino_icons`. A la hora de iniciar el desarrollo, confirmar si esa inspección sigue vigente, porque puede haber cambios después de esta guía. El SDK declarado es `^3.13.7`; verificar compatibilidad real de cada paquete con ese SDK antes de fijarlo.

## Archivo fuente de diseño

Usa el archivo versionado en [docs/figma/FORZA — Premium Fitness Experience.fig](figma/FORZA%20%E2%80%94%20Premium%20Fitness%20Experience.fig) como referencia visual del proyecto.
