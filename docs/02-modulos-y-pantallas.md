# Pantallas y módulos observados en Figma

El archivo muestra frames agrupados por letra (A–G). A continuación se conserva el nombre visible en el panel Layers cuando fue legible y se traduce a una agrupación de producto. La clasificación es una propuesta; no implica que cada pantalla tenga lógica funcional definida.

## Módulos de navegación principal

| Área sugerida | Frames relacionados | Responsabilidad UI |
|---|---|---|
| Inicio / onboarding | A1–A4, B1–B5, C1–C8 | Bienvenida, creación/configuración inicial y pantallas de preparación/entrada según el prototipo. Validar los nombres exactos de cada frame. |
| Actividad | D1–D4 | Calendario mensual, detalle de día y reprogramación. |
| Ejercicios | E1–E5 | Resultados, filtros, biblioteca, detalle y alternativas de ejercicio. |
| Progreso | F1–F6 | Historial, detalle de sesión, evolución de fuerza y corporal, medidas y récords personales. |
| Cuenta y ajustes | G1–G6 | Editar perfil, configuración de entrenamiento, preferencias, notificaciones, privacidad/cuenta y confirmación de cuenta. |

## Estado de implementación

- **Inicio / onboarding (A–C):** configurador inicial local de tres pasos para objetivo, experiencia y frecuencia/duración de entrenamiento. Se abre desde Perfil y devuelve la configuración elegida a la sesión actual. Es una interpretación funcional del grupo; los nombres y el mapeo exacto de A1–C8 siguen pendientes de confirmación contra frames individuales.
- **Actividad (D2–D4):** calendario mensual, detalle del día y flujo de reprogramación implementados con datos de ejemplo locales. El cambio de fecha se conserva durante la sesión abierta de la app, sin persistencia.
- **Ejercicios (E1–E5):** biblioteca de demostración con búsqueda por ejercicio/músculo/equipo, filtros combinables, detalle con instrucciones y selección de alternativas. Catálogo local sin imágenes/GIFs; no hay datos persistentes.
- **Progreso (F1–F6):** historial, detalle de sesión, evolución de fuerza/corporal, formulario temporal de medidas y récords personales implementados con datos de ejemplo.
- **Perfil/Cuenta (G1–G6):** edición de datos, preferencias de entrenamiento, unidades y comienzo de semana, controles de notificaciones/privacidad y confirmación de datos implementados localmente. No hay autenticación, sincronización ni persistencia.

## Inventario legible del panel de capas

- `D2 - Calendario mensual` (se observan capas `Actividad D` y `Día D`).
- `D3 - Detalle de día`.
- `D4 - Reprogramar sesión`.
- `E1 - Resultados de busqueda`.
- `E2 - Filtros de explorar`.
- `E3 - Biblioteca de ejercicios`.
- `E4 - Detalle de ejercicio`.
- `E5 - Alternativas de ejercicio`.
- `F1 - Historial de entrenamientos`.
- `F2 - Detalle de sesión anterior`.
- `F3 - Evolución de fuerza`.
- `F4 - Evolución corporal`.
- `F5 - Registrar medidas`.
- `F6 - Records personales`.
- `G1 - Editar perfil`.
- `G2 - Configuracion de entrenamiento`.
- `G3 - Preferencias`.
- `G4 - Notificaciones`.
- `G5 - Privacidad y cuenta`.
- `G6 - Confirmacion de cuenta`.

Los nombres de A1–C8 se leen parcialmente en la vista general; deben confirmarse directamente en cada frame antes de asignar rutas definitivas. El configurador actual es un flujo provisional de UI, no una reproducción confirmada de todas esas pantallas. No inferir una función sensible (por ejemplo, autenticación real o borrado de cuenta) solo a partir de un frame.

## Componentes candidatos compartidos

- Navegación inferior persistente para las cinco áreas principales.
- Cabecera de pantalla, secciones, tarjetas de resumen, botones primarios/ secundarios.
- Tarjeta/listado de ejercicio, etiqueta de músculo/equipo, búsqueda y filtros.
- Selector/calendario y tarjeta de sesión.
- Gráfico de progreso y tarjeta de métrica.
- Filas y controles de preferencias, toggles, campos de perfil.

Reusar el paquete que ya se eligió para iconos y navbar. Esta lista describe sus espacios visuales, no exige dibujar glifos ni construir una barra propietaria.

## Estructura de rutas ilustrativa

```text
/                         inicio
/onboarding/...           pasos iniciales
/activity                 calendario
/activity/day/:date       detalle del día
/activity/reschedule/:id  reprogramar
/exercises                explorar/biblioteca
/exercises/search         resultados
/exercises/filters        filtros
/exercises/:id            detalle
/exercises/:id/alternatives alternativas
/progress                 resumen de progreso
/progress/history         historial
/progress/sessions/:id    detalle de sesión
/progress/measurements    registrar medidas
/profile                  perfil
/settings/...             preferencias y cuenta
```

Ajustar la ruta inicial y el mapa final al prototipo completo y a la navegación del proyecto.
