# FORZA

<p align="center">
  <img src="assets/brand/forza-app-icon.png" alt="Icono de FORZA" width="180">
</p>

<p align="center"><strong>Entrena con intención. Sigue tu progreso.</strong></p>

FORZA es una app Flutter para organizar entrenamientos, explorar ejercicios y consultar la actividad y el progreso. Guarda localmente el plan, la agenda y el historial; no requiere una API para esas funciones.

## La app

<p align="center">
  <img src="assets/brand/forza-overview.png" alt="Vistas de Actividad, Inicio y Progreso de FORZA" width="780">
</p>

<p align="center">
  <img src="assets/brand/forza-mobile.png" alt="Pantalla de Inicio de FORZA en móvil" width="260">
</p>

## Arquitectura

FORZA usa una estructura por funcionalidades en la capa de interfaz, junto con capas `domain` y `data`. La UI coordina los flujos y consume contratos/modelos del dominio; los repositorios de datos implementan la persistencia local y la carga del catálogo.

```mermaid
flowchart TB
    subgraph app["Aplicación Flutter · lib/"]
        main["main.dart<br/>inicialización y arranque"] --> shell["app/<br/>ForzaApp · tema · rutas · idioma"]
        shell --> ui["ui/<br/>scaffold y navegación"]
        ui --> features["features/<br/>Inicio · Actividad · Ejercicios<br/>Progreso · Perfil · Onboarding"]
        ui --> core["core/<br/>widgets compartidos y ViewModel del shell"]
    end

    subgraph layers["Capas de datos y reglas"]
        features --> domain["domain/<br/>modelos · contratos · casos de uso"]
        core --> repos["data/repositories/<br/>plan · agenda · historial · objetivos<br/>respaldo · ejercicios"]
        features --> repos
        repos --> domain
        repos --> db["data/database/<br/>Drift sobre SQLite"]
        repos --> catalog["assets/data/exercises.json<br/>catálogo local de solo lectura"]
        db --> migrations["Migraciones versionadas<br/>database/migrations/sqlite/ y drift_schemas/"]
        legacy["SharedPreferences existentes"] --> migration["migrations/<br/>importación heredada"] --> db
    end

    classDef presentation fill:#111,color:#fff,stroke:#666;
    classDef data fill:#eee,color:#111,stroke:#777;
    class shell,ui,features,core presentation;
    class domain,repos,db,catalog,migrations,legacy,migration data;
```

### Flujo de datos local

```mermaid
flowchart LR
    screen["Pantallas por feature"] --> repo["Repositorios de data"]
    repo -->|"plan, sesiones, agenda y objetivos"| drift["Drift"]
    drift --> sqlite[("SQLite local")]
    repo -->|"lectura"| json["assets/data/exercises.json"]
    repo -->|"exportar / restaurar JSON"| backup["Archivo de respaldo del usuario"]
    domain["Modelos y reglas de domain"] --- repo
```

**Estado de backend:** no hay API ni sincronización remota implementadas. Los endpoints descritos en la [documentación de persistencia y API](docs/06-datos-locales-y-api.md) son una propuesta futura.

### Mapa del código

| Ruta | Responsabilidad |
|---|---|
| `lib/main.dart` | Inicializa Flutter, formatos de fecha y modos de sistema; arranca la app. |
| `lib/app/` | Configura `MaterialApp`, rutas, tema, apariencia e idioma. |
| `lib/ui/core/` | Scaffold, widgets compartidos y estado de navegación. |
| `lib/ui/features/` | Vistas y componentes agrupados por flujo de producto. |
| `lib/domain/` | Modelos, contratos de repositorio y reglas de entrenamiento independientes de SQLite. |
| `lib/data/repositories/` | Implementaciones para configuración, agenda, historial, objetivos, catálogo y respaldo. |
| `lib/data/database/` | Base SQLite y tablas Drift. |
| `database/migrations/sqlite/` y `drift_schemas/` | SQL de referencia y snapshots versionados del esquema. |
| `assets/data/exercises.json` | Catálogo de ejercicios incluido con la aplicación. |

## Desarrollo

Requisitos: Flutter y Dart compatibles con las versiones declaradas en `pubspec.yaml`.

```sh
flutter pub get
flutter run
```

Para Linux con X11:

```sh
GDK_BACKEND=x11 flutter run -d linux
```

## Documentación

- [Cómo contribuir](CONTRIBUTING.md)
- [Configuración de contribuciones, reglas y APK en GitHub](docs/github-contributions.md)
- [Guía de implementación](docs/01-implementacion.md)
- [Pantallas y módulos](docs/02-modulos-y-pantallas.md)
- [Sistema visual](docs/03-sistema-visual.md)
- [Paquetes y dataset](docs/04-paquetes-y-dataset.md)
- [Persistencia local, migraciones y contrato futuro de API](docs/06-datos-locales-y-api.md)
- [Auditoría de módulos y prioridades del MVP](docs/07-auditoria-modulos-indispensables.md)
- [Módulos recomendados y secuencia de trabajo](docs/08-modulos-recomendados.md)
