# Auditoría de módulos indispensables

Estado contrastado con el código de `main` el 24-11-2026. Esta tabla distingue lo ya disponible de los huecos que siguen abiertos; las prioridades ordenan el trabajo del MVP, no obligan a implementar todos los módulos antes de publicarlo. Los enlaces apuntan a los issues de seguimiento.

## Módulos y prioridades

| Prioridad | Módulo | Estado actual | Trabajo pendiente |
|---|---|---|---|
| P0 | Entrenamiento activo y registro | La sesión registra repeticiones, carga o duración por serie en SQLite. El borrador conserva ejercicio, temporizador, series y pantalla para reanudar. | Mejorar el flujo guiado de fases, instrucciones y progreso de sesión; validar registro y finalización anticipada ([#3](https://github.com/Angel11R99/forza/issues/3)). |
| P0 | Plan semanal y calendario | La agenda de 120 días persiste en SQLite, sincronizada entre Inicio, Actividad y entrenamiento. Se pueden reprogramar sesiones; existen estados pendiente, en curso y completada. | Añadir estado y acción para omitir sesiones ([#15](https://github.com/Angel11R99/forza/issues/15)). |
| P0 | Progreso basado en resultados | El historial y el resumen de 30 días usan sesiones y series reales; se calculan series, repeticiones y volumen. | Registrar medidas corporales y conectar evolución de fuerza y récords con datos reales ([#9](https://github.com/Angel11R99/forza/issues/9), [#10](https://github.com/Angel11R99/forza/issues/10), [#11](https://github.com/Angel11R99/forza/issues/11)). |
| P0 | Planificador y reglas de rutina | `TrainingPlanBuilder` crea sesiones desde preferencias y plantillas locales; plan y agenda persisten. | Usar IDs estables del catálogo y guardar la versión o snapshot del plan que originó cada sesión ([#13](https://github.com/Angel11R99/forza/issues/13)). |
| P1 | Perfil y preferencias | Preferencias del plan, tema e idioma persisten. Perfil, unidades, inicio de semana, notificaciones y privacidad aún son demostrativos. | Auditar la persistencia por módulo y guardar/restaurar las preferencias funcionales ([#8](https://github.com/Angel11R99/forza/issues/8), [#7](https://github.com/Angel11R99/forza/issues/7)). |
| P1 | Horarios y recordatorios | La aplicación localiza la interfaz; los controles de notificaciones no programan avisos. | Adaptar selector/formato de hora a región y preferencia del sistema; después implementar recordatorios locales opcionales ([#6](https://github.com/Angel11R99/forza/issues/6), [#12](https://github.com/Angel11R99/forza/issues/12)). |
| P1 | Adaptación del plan | El plan usa objetivo, experiencia, días, tiempo disponible y equipo. | Permitir excluir movimientos y aplicar sustituciones explicadas, sin presentar la función como diagnóstico ([#14](https://github.com/Angel11R99/forza/issues/14)). |
| P2 | Cuenta y sincronización | Hay formularios de acceso de demostración; no existe proveedor de identidad, backend ni sincronización. | Considerar acceso opcional con Google cuando se defina una necesidad de cuenta/sincronización y la configuración de privacidad ([#5](https://github.com/Angel11R99/forza/issues/5)). |
| P2 | Exportar y reiniciar datos | Exportación y restauración local JSON están implementadas; el respaldo incluye plan, sesiones, series, agenda, objetivos, borrador y apariencia. | Añadir un reinicio seguro de los datos locales, con confirmación y respaldo opcional ([#16](https://github.com/Angel11R99/forza/issues/16)). |

## Orden recomendado

1. Completar el flujo de entrenamiento guiado, preservando registro y recuperación de sesión ([#3](https://github.com/Angel11R99/forza/issues/3)).
2. Versionar las rutinas y cerrar los estados de la agenda ([#13](https://github.com/Angel11R99/forza/issues/13), [#15](https://github.com/Angel11R99/forza/issues/15)).
3. Auditar la persistencia existente y corregir preferencias que no sobreviven al reinicio ([#8](https://github.com/Angel11R99/forza/issues/8), [#7](https://github.com/Angel11R99/forza/issues/7)).
4. Adaptar el formato horario y luego conectar recordatorios a la agenda ([#6](https://github.com/Angel11R99/forza/issues/6), [#12](https://github.com/Angel11R99/forza/issues/12)).
5. Completar datos de progreso que aún son demostrativos ([#9](https://github.com/Angel11R99/forza/issues/9), [#10](https://github.com/Angel11R99/forza/issues/10), [#11](https://github.com/Angel11R99/forza/issues/11)).
6. Añadir personalización de movimientos a evitar ([#14](https://github.com/Angel11R99/forza/issues/14)).
7. Evaluar autenticación y sincronización solo si el producto requiere varios dispositivos o respaldo remoto ([#5](https://github.com/Angel11R99/forza/issues/5)).

Las guías de ejercicio, animaciones, pulido visual y funciones sociales amplían el producto, pero no sustituyen el ciclo individual de planificar, entrenar y entender los resultados. Ver también [módulos recomendados](08-modulos-recomendados.md) y [estado por pantalla](02-modulos-y-pantallas.md).
