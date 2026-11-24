# Auditoría de módulos indispensables

Estado contrastado con el código de `main` el 24-11-2026. Esta tabla distingue lo ya disponible de los huecos que siguen abiertos; las prioridades ordenan el trabajo del MVP, no obligan a implementar todos los módulos antes de publicarlo. Los enlaces apuntan a los issues de seguimiento.

## Módulos y prioridades

| Prioridad | Módulo | Estado actual | Trabajo pendiente |
|---|---|---|---|
| P0 | Entrenamiento activo y registro | La sesión registra repeticiones, carga o duración por serie en SQLite. El borrador conserva ejercicio, temporizador, series y pantalla para reanudar. | Mejorar el flujo guiado de fases, instrucciones y progreso de sesión; validar registro y finalización anticipada ([#3](https://github.com/Angel11R99/forza/issues/3)). |
| P0 | Plan semanal y calendario | La agenda de 120 días persiste en SQLite y se comparte entre Inicio, Actividad y entrenamiento. Las sesiones guardan su snapshot; se pueden reprogramar, omitir y restaurar desde Actividad. Las omisiones no cuentan como entrenamientos completados. | — |
| P0 | Progreso basado en resultados | El historial, las medidas corporales, el resumen de 30 días, la evolución de fuerza y los récords personales usan datos persistidos; la serie muestra la mayor carga por sesión y los récords incluyen kg, repeticiones o duración. | — |
| P0 | Planificador y reglas de rutina | `TrainingPlanBuilder` crea sesiones con IDs estables del catálogo; preferencias validadas y plan versionado. Agenda e historial conservan la versión y el snapshot de rutina que los originó ([#13](https://github.com/Angel11R99/forza/issues/13)). | — |
| P1 | Perfil y preferencias | Preferencias del plan, tema, idioma, perfil y privacidad persisten localmente. Google Sign-In es opcional y muestra la identidad del proveedor sin cuenta de servidor ni sincronización. Los recordatorios usan la agenda local; no se ofrecen alertas semanales o de récord sin eventos reales. | — Ver inventario y límites funcionales ([auditoría](09-auditoria-persistencia.md)). |
| P1 | Horarios y recordatorios | Selectores/horas respetan región y preferencia de 24 horas. Los recordatorios requieren permiso del sistema, se programan para sesiones pendientes y se recalculan al reanudar la app o cambiar la agenda. | — Avisos Android inexactos pueden retrasarse; iOS conserva hasta 64 avisos pendientes y FORZA limita los propios a 50 ([#6](https://github.com/Angel11R99/forza/issues/6), [#12](https://github.com/Angel11R99/forza/issues/12)). |
| P1 | Adaptación del plan | El plan usa objetivo, experiencia, días, tiempo disponible, equipo y movimientos que el usuario prefiere evitar; la vista previa explica la selección y avisa si no hay alternativas. Es una preferencia personal, no un diagnóstico médico ([#14](https://github.com/Angel11R99/forza/issues/14)). | — |
| P2 | Cuenta y sincronización | Google Sign-In opcional para perfil visual; no hay cuenta de servidor ni sincronización. El login de producción espera IDs OAuth y firmas por plataforma. | Configurar los clientes OAuth del proyecto cuando se definan los IDs finales de Android/iOS; evaluar backend por separado ([#5](https://github.com/Angel11R99/forza/issues/5); [configuración](google-sign-in-setup.md)). |
| P2 | Exportar y reiniciar datos | Exportación/restauración JSON y reinicio local con confirmación; el reinicio permite guardar un respaldo y conserva preferencias de la app y el catálogo. | — |

## Orden recomendado

1. Completar el flujo de entrenamiento guiado, preservando registro y recuperación de sesión ([#3](https://github.com/Angel11R99/forza/issues/3)).
2. Versionar las rutinas y cerrar los estados de la agenda ([#13](https://github.com/Angel11R99/forza/issues/13), [#15](https://github.com/Angel11R99/forza/issues/15)).
3. Auditar la persistencia existente y corregir preferencias que no sobreviven al reinicio ([#8](https://github.com/Angel11R99/forza/issues/8), [#7](https://github.com/Angel11R99/forza/issues/7)).
4. Adaptar el formato horario y luego conectar recordatorios a la agenda ([#6](https://github.com/Angel11R99/forza/issues/6), [#12](https://github.com/Angel11R99/forza/issues/12)).
5. Completar datos de progreso que aún son demostrativos ([#9](https://github.com/Angel11R99/forza/issues/9), [#10](https://github.com/Angel11R99/forza/issues/10), [#11](https://github.com/Angel11R99/forza/issues/11)).
6. Añadir personalización de movimientos a evitar ([#14](https://github.com/Angel11R99/forza/issues/14)).
7. Evaluar cuentas de servidor y sincronización solo si el producto requiere varios dispositivos o respaldo remoto ([#5](https://github.com/Angel11R99/forza/issues/5)).

Las guías de ejercicio, animaciones, pulido visual y funciones sociales amplían el producto, pero no sustituyen el ciclo individual de planificar, entrenar y entender los resultados. Ver también [módulos recomendados](08-modulos-recomendados.md) y [estado por pantalla](02-modulos-y-pantallas.md).
