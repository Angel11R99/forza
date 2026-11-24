# Pantallas y módulos observados en Figma

El archivo muestra frames agrupados por letra (A–G). A continuación se conserva el nombre visible en el panel Layers cuando fue legible y se traduce a una agrupación de producto. La clasificación es una propuesta; no implica que cada pantalla tenga lógica funcional definida.

## Módulos de navegación principal

| Área sugerida | Frames relacionados | Responsabilidad UI |
|---|---|---|
| Acceso y entrenamiento | A1–A4, B1–B5, C1–C8 | Acceso a cuenta, personalización de plan y flujo de una sesión de entrenamiento. |
| Actividad | D1–D4 | Calendario mensual, detalle de día y reprogramación. |
| Ejercicios | E1–E5 | Resultados, filtros, biblioteca, detalle y alternativas de ejercicio. |
| Progreso | F1–F6 | Historial, detalle de sesión, evolución de fuerza y corporal, medidas y récords personales. |
| Cuenta y ajustes | G1–G6 | Editar perfil, configuración de entrenamiento, preferencias, notificaciones, privacidad/cuenta y confirmación de cuenta. |

## Estado de implementación

- **Acceso (A1–A4):** Perfil ofrece modo invitado y conexión opcional con Google. Nombre, correo y foto solo aparecen al conectar el proveedor; no se solicita correo manualmente ni se crea cuenta de servidor. Los entrenamientos permanecen locales y cambiar/cerrar sesión no los borra. Ver [configuración OAuth](google-sign-in-setup.md).
- **Configuración de plan (B1–B5):** resumen de personalización, preparación local del plan, selección de día, detalle de ejercicios y confirmación final. Las preferencias del plan, incluidos los movimientos a evitar, se guardan en SQLite; la rutina filtra el catálogo local por equipo y exclusiones, y explica las opciones compatibles o si no hay alternativas. No es un diagnóstico médico ni usa generación remota.
- **Sesión de entrenamiento (C1, C3–C8):** preparación, descanso temporizado, lista de ejercicios, pausa, confirmación de abandono, finalización y resumen, accesibles desde una sesión programada en Actividad. Al terminar o marcar una sesión realizada, su resumen y ejercicios se agregan al historial SQLite. C2 no aparece en el panel de capas.
- **Actividad (D2–D4):** calendario mensual, detalle del día y reprogramación de sesiones planificadas. La agenda de 120 días y sus cambios de fecha se guardan en SQLite y se comparten con Inicio y el entrenamiento; estados actuales: pendiente, en curso y completada. Aún no existe un estado para omitir una sesión ([#15](https://github.com/Angel11R99/forza/issues/15)).
- **Ejercicios (E1–E5):** biblioteca local de 1.324 ejercicios con nombres e instrucciones en español e inglés, búsqueda por ejercicio/músculo/equipo, filtros combinables, detalle y alternativas. La interfaz, las etiquetas de grupo/equipo y las notas técnicas admiten ambos idiomas. `ExerciseRepository` carga el JSON incluido y la UI muestra estados de carga/error. El catálogo es de solo lectura y no está en SQLite; no hay API. Un asset vectorial independiente aporta animaciones a 1.257 ejercicios; los demás muestran el icono de su grupo muscular.
- **Progreso (F1–F6):** historial y detalle usan sesiones y series reales guardadas en SQLite; el resumen de los últimos 30 días calcula series, repeticiones y volumen. Las medidas corporales se guardan por fecha, se pueden editar o eliminar y forman parte del respaldo. La evolución de fuerza compara la mayor carga con peso de cada sesión, por ejercicio y periodo; excluye sesiones sin cargas registradas. Los récords se derivan de las series guardadas e indican fecha y unidad.
- **Perfil/Cuenta (G1–G6):** plan, tema, idioma y preferencias persisten localmente. Los recordatorios opcionales usan la agenda y requieren permiso del sistema; el resumen semanal y las alertas de récord se omiten si no hay eventos reales. Google solo muestra identidad del proveedor; no publica ni sincroniza datos. #5 requiere configurar IDs OAuth de Android/iOS del proyecto para probar login real. Ver [configuración](google-sign-in-setup.md), [#7](https://github.com/Angel11R99/forza/issues/7) y [#12](https://github.com/Angel11R99/forza/issues/12).

## Inventario legible del panel de capas

- `A1 - Bienvenida`.
- `A2 - Crear cuenta`.
- `A3 - Iniciar sesión`.
- `A4 - Recuperar contraseña`.
- `B1 - Resumen de personalización`.
- `B2 - Preparando el plan`.
- `B3 - Mi plan personalizado`.
- `B4 - Detalle de día del plan`.
- `B5 - Confirmacion del plan`.
- `C1 - Preparación del entrenamiento`.
- `C3 - Descanso`.
- `C4 - Lista de ejercicios`.
- `C5 - Entrenamiento pausado`.
- `C6 - Confirmar abandono`.
- `C7 - Entrenamiento completado`.
- `C8 - Resumen de sesión`.
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

El panel no mostró ninguna capa C2; se conserva ese hueco de numeración sin inventar una pantalla. A2–A4 describen los frames originales de Figma, no los formularios actuales: Perfil muestra acceso opcional con Google y no pide contraseña/correo manual. La integración del proveedor no crea una cuenta de servidor; no añadir borrado de cuenta solo por la presencia de esos frames.

## Componentes candidatos compartidos

- Navegación inferior persistente para las cinco áreas principales.
- Cabecera de pantalla, secciones, tarjetas de resumen, botones primarios/ secundarios.
- Tarjeta/listado de ejercicio, etiqueta de músculo/equipo, búsqueda y filtros.
- Selector/calendario y tarjeta de sesión.
- Gráfico de progreso y tarjeta de métrica.
- Filas y controles de preferencias, toggles, campos de perfil.

Reutilizar la navegación existente en `AppScaffold`. Esta lista describe espacios visuales, no exige añadir paquetes de iconos o navbar.

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
