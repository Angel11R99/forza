# Guía de implementación Flutter

## Principios de trabajo

1. **Respetar la referencia visual.** Usar los frames A–G del archivo `.fig` como inventario; validar cada pantalla contra su frame y conservar la intención del diseño.
2. **Reutilizar.** Antes de crear navbar, icono, selector, gráficos, inputs o animaciones propias, revisar dependencias presentes y paquetes compatibles en pub.dev.
3. **Separar lo visual de lo funcional.** Widgets de presentación reciben datos/acciones; estado, rutas y repositorios van fuera de las vistas.
4. **Construir por flujo.** Completar un flujo pequeño de punta a punta para fijar patrones antes de propagar componentes por toda la app.
5. **No acoplar los GIFs.** El catálogo de ejercicios debe consumir un contrato de datos; su fuente de medios podrá cambiar tras revisar permisos/licencias.

## Arquitectura sugerida (ligera, feature-first)

Organizar la presentación por feature y reservar `data/` y `domain/` para cuando existan datos o reglas que lo necesiten. Así se mantiene la separación UI/lógica/datos recomendada para Flutter sin crear ViewModels, repositorios ni casos de uso vacíos para una entrega inicialmente visual.

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
  ui/
    core/
      widgets/               # botones, superficies, campos, estados vacíos
    features/
      home/
        views/
        view_models/         # solo si la vista necesita estado/lógica
      activity/
        views/
      exercises/
        views/
      progress/
        views/
      profile/
        views/
  data/                      # servicios/repositorios al integrar fuentes
  domain/                    # modelos/casos de uso cuando haya reglas reales
```

Una pantalla debería ensamblar componentes del design system y widgets del módulo. Evitar un único `main.dart` gigante y también evitar crear una abstracción compartida para una sola aparición.

En esta primera entrega, `ViewModel` se añade únicamente cuando una vista tenga estado que deba sobrevivir o coordinarse fuera de un widget (por ejemplo, filtros aplicados o selección persistente). Para interacción local, breve y puramente visual, el estado puede permanecer en el widget. Al conectar datos, mover el acceso a servicios y repositorios; introducir casos de uso solo si una regla de negocio resulta compleja o compartida.

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

- **Dependencias resueltas:** `pubspec.yaml` declara `material_ui: ^1.11.1` y `native_glass_navbar: ^2.0.0`; `flutter pub get` completó correctamente y fijó ambas versiones en `pubspec.lock`. La app usa `package:material_ui/material_ui.dart`, API alineada con Flutter 3.50.1 y con la rama 2.x del plugin.
- **Navbar seleccionada:** `native_glass_navbar` en iOS, con fallback Flutter de estilo FORZA en Android. El plugin admite hasta cinco pestañas, coincidente con las cinco áreas principales. Para compilar iOS requiere Xcode 27 o posterior. Se evita añadir un segundo paquete de navbar. Referencia: [pub.dev](https://pub.dev/packages/native_glass_navbar).
- **Router seleccionado:** conservar `Navigator`/`MaterialApp` de Flutter para el primer hito y gestionar las cinco pestañas con estado persistente de vistas; no añadir `go_router` todavía porque el alcance actual no requiere deep links ni redirecciones de autenticación.
- **Alcance inicial:** demo navegable de UI. La app ahora conserva localmente la configuración del plan y el historial de entrenamientos en SQLite; API, autenticación real y medios animados siguen fuera del alcance implementado.
- **Referencia visual:** las superficies y textos base están registrados en `03-sistema-visual.md`. El HEX de acento, tipografía y medidas exactas de forma/espaciado no están confirmados en la inspección existente; deben permanecer como tokens provisionales pendientes de validar contra el archivo Figma antes de cerrar el tema visual.

### Fase 1 · Cimientos visuales (primer hito)

El primer cambio de producto debe dejar una base FORZA visible y navegable, antes de construir todas las pantallas. En el starter actual esto reemplaza la pantalla de contador de Flutter.

**Estado:** implementada en `lib/`. La app tiene tema claro y tokens centrales, Inicio con contenido marcado como ejemplo, cinco destinos con estado de pestaña conservado, barra nativa iOS y fallback Flutter para el resto de plataformas. El color de acento y la tipografía siguen pendientes de validar en Figma.

#### Orden de implementación

1. **Usar el marco de navegación elegido.** Mantener `Navigator`/`MaterialApp` para rutas y cinco pestañas con estado persistente. Integrar `native_glass_navbar ^2.0.0` para iOS y un fallback Flutter alineado visualmente para Android; la dependencia ya está resuelta en `pubspec.lock`.
2. **Crear la entrada de app.** Mover la configuración de `MaterialApp` fuera de `main.dart`, fijar el título FORZA y dejar `main()` como punto de arranque pequeño. Mantener rutas semánticas para Inicio, Actividad, Ejercicios, Progreso y Perfil; onboarding y detalles quedan fuera de las pestañas principales.
3. **Definir los tokens confirmados.** Crear `AppColors`, `AppSpacing` y `AppRadius` a partir de `03-sistema-visual.md`. Usar únicamente HEX verificados. El acento queda sin asignar hasta medirlo en el archivo fuente; no crear un verde provisional que parezca definitivo.
4. **Configurar el tema claro.** Conectar los tokens a `ThemeData`/`ColorScheme` y tipografía del sistema mientras la familia tipográfica de Figma no esté confirmada. Fijar estilos de superficies, texto, divisores y botones sin copiar estilos del starter.
5. **Construir el scaffold compartido.** Implementar safe areas, área de contenido adaptable y navbar elegido. La barra mantiene selección coherente al navegar entre las cinco áreas; las rutas de detalle la ocultan cuando el flujo de diseño así lo requiera.
6. **Añadir solo componentes base necesarios.** Empezar con botón primario, encabezado de sección, superficie/tarjeta y campo de búsqueda. Crear estados vacío/carga/error cuando la primera pantalla los consuma; no construir un catálogo de componentes sin uso.
7. **Entregar la primera vista conectada.** Usar Inicio como ruta inicial y componerla con el scaffold, tokens y componentes anteriores. Poblarla con contenido de presentación claramente identificable como fixture; no simular datos reales ni persistencia.

#### Archivos esperados

```text
lib/
  main.dart
  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_radius.dart
  ui/
    core/widgets/app_scaffold.dart
    features/home/views/home_view.dart
    features/activity/views/activity_view.dart
    features/exercises/views/exercises_view.dart
    features/progress/views/progress_view.dart
    features/profile/views/profile_view.dart
```

Este árbol es una guía de salida, no exige crear pantallas vacías de todos los módulos en el mismo cambio. Si el primer incremento solo implementa Inicio, las rutas restantes pueden añadirse con su primera pantalla real. Mantener `data/` y `domain/` fuera hasta que una feature consuma datos o reglas de negocio.

#### Criterios para cerrar el primer hito

- La app abre Inicio con identidad FORZA y ya no muestra el contador del starter.
- La vista utiliza el tema y tokens centrales; no hay colores ni espaciados globales duplicados en línea.
- Navbar y router tienen una sola decisión documentada, compatible con el SDK declarado, y permiten llegar a las áreas principales.
- El contenido respeta safe areas, puede desplazarse y no depende de un frame de 393 × 852 fijo.
- Los textos/iconos funcionales tienen nombres accesibles y controles con targets táctiles adecuados.
- El acento continúa pendiente hasta medirlo; no se empaquetan medios del dataset durante este hito.

### Fase 2 · Flujos de UI

Orden sugerido: Inicio/entrada → Actividad/calendario → Explorar/biblioteca y detalle → Progreso → Perfil/ajustes. Implementar los frames A–G por grupos, manteniendo cada vista en su feature.

**Estado:** Acceso A1–A4 implementa formularios de demostración, sin autenticación ni envío de correo. Plan B1–B5 permite personalizar una rutina local. La sesión C1 y C3–C8 incluye preparación, lista de ejercicios, descanso, pausa, abandono y finalización; el historial de entrenamientos se persiste localmente. Actividad (D2–D4) muestra calendario, detalle y reprogramación de demostración; el cambio de fecha aún no se persiste. Ejercicios (E1–E5) usa el catálogo incluido como asset local. Progreso (F1–F6) muestra historial de sesiones persistidas y vistas de medidas/gráficos que aún no se guardan. Perfil/Cuenta (G1–G6) conserva configuración de entrenamiento local; acceso, notificaciones y privacidad continúan en modo de demostración. No hay sincronización ni API.

### Fase 3 · Datos

- **Estado:** modelo `Exercise` trasladado a `domain`, contrato `ExerciseRepository` definido y repositorio asíncrono carga el dataset local fijado en un commit, con 1.324 nombres/instrucciones en español. Las ilustraciones animadas son un asset vectorial local independiente del dataset, con alternativa de icono para ejercicios sin animación. La biblioteca muestra carga/error; búsqueda, filtros, detalle y alternativas consultan el repositorio. Planes e historial se guardan en SQLite mediante Drift; el catálogo de ejercicios permanece como asset. No hay API.
- [x] Definir modelo `Exercise` y contrato `ExerciseRepository` separados de widgets.
- [x] Incluir el dataset de texto como asset local y separar las ilustraciones vectoriales; omitir las imágenes y GIFs upstream.
- [ ] Conectar una API solo si aparece un servicio remoto aprobado y necesario.
- [ ] Si el catálogo pasa a una API, paginar y resolver búsqueda/filtros en el origen; no cargar todos los GIFs de golpe.

### Fase 4 · Medios animados y pulido

- **Estado:** la biblioteca y la pantalla de alternativas usan tarjetas que aumentan de alto con `TextScaler`; el calendario mensual adapta las filas y el círculo del día al escalado de texto; Perfil y los datos de sesión, medición y valores de Progreso pueden ocupar varias líneas sin truncamiento. La búsqueda ignora tildes y anuncia los resultados a tecnologías de asistencia. `flutter analyze` y la compilación Windows pasan. Pendiente de una pasada en Android/iOS con texto grande y de validar el HEX de acento en Figma; esos dispositivos no están disponibles en el entorno actual. Los medios siguen fuera hasta resolver su licencia.
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

El starter ya cuenta con la base inicial FORZA en `lib/`. `pubspec.yaml` declara Flutter, `cupertino_icons`, `material_ui: ^1.11.1` y `native_glass_navbar: ^2.0.0`; `pubspec.lock` los resuelve. El SDK declarado es Dart `^3.13.7`; la máquina de desarrollo usa Flutter 3.50.1/Dart 3.14. Para compilar iOS con la barra nativa se necesita Xcode 27 o posterior.

## Archivo fuente de diseño

Usa el archivo versionado en [docs/figma/FORZA — Premium Fitness Experience.fig](figma/FORZA%20%E2%80%94%20Premium%20Fitness%20Experience.fig) como referencia visual del proyecto.
