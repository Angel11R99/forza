# Auditoría de módulos para una app de entrenamiento funcional

Esta revisión separa lo que ya funciona en FORZA de lo que falta para que la persona pueda seguir un plan, entrenar y entender su progreso. La prioridad se basa en el valor central del producto: ayudar a completar entrenamientos y registrar resultados. No implica agregar todos los módulos antes de una primera versión.

## Módulos y prioridad

| Prioridad | Módulo | Estado actual | Qué necesita para funcionar bien |
|---|---|---|---|
| P0 | Entrenamiento activo y registro | Se inicia una sesión, se avanza ejercicio por ejercicio y se guarda el resumen al terminar. | Registrar cada serie: repeticiones, carga o duración y estado; permitir corregir una serie; conservar una sesión en curso al salir; guardar todo en SQLite. Sin estos datos, FORZA no sabe qué hizo la persona ni puede recomendar una progresión concreta. |
| P0 | Plan semanal y calendario | Las preferencias del plan se guardan en SQLite y las sesiones semanales se calculan localmente. | Guardar las sesiones planificadas y sus estados (pendiente, en curso, completada, omitida), y persistir los cambios de fecha. Así Inicio, Actividad y el entrenamiento activo mostrarán la misma agenda después de cerrar y abrir la app. |
| P0 | Progreso basado en resultados | El historial de sesiones completadas sí se guarda y se lista. | Derivar métricas de series reales, por ejemplo repeticiones, carga por ejercicio y volumen; mostrar de dónde sale cada cifra. Ahora las medidas corporales y varios gráficos son de demostración, y el historial no contiene cargas. |
| P0 | Planificador y reglas de rutina | El usuario puede elegir objetivo, experiencia, días, duración y equipo; `TrainingPlanBuilder` arma sesiones a partir de plantillas locales. | Vincular las prescripciones con el catálogo y guardar la versión del plan que produjo cada sesión. Validar que objetivo, días y equipo elegidos den una rutina coherente. Las plantillas actuales son limitadas y no son una prescripción adaptativa. |
| P1 | Perfil y preferencias persistentes | La configuración del plan persiste. Nombre, correo, unidades, inicio de semana, notificaciones y privacidad usan valores temporales/de demostración. | Guardar preferencias localmente; hacer que cada ajuste cambie realmente el comportamiento o quitar el control hasta implementarlo. Autenticación y sincronización pueden esperar mientras el producto sea offline. |
| P1 | Recordatorios | La pantalla ofrece opciones de notificación, pero no programa notificaciones. | Implementar permisos, hora local, zona horaria, cancelación al desactivar y actualización al mover una sesión. Los recordatorios deben ser opcionales y respetar el horario elegido. |
| P1 | Seguridad y adaptación del plan | La personalización usa meta, experiencia, disponibilidad, minutos y equipo. | Preguntar de forma opcional por movimientos que se deben evitar y limitaciones relevantes; aplicar sustituciones visibles. Presentarlo como personalización general, no como evaluación o tratamiento médico. |
| P2 | Cuenta y sincronización | Los formularios de acceso son demostraciones y no existe servidor. | Añadir cuentas solo cuando haya backend, recuperación de cuenta, sincronización y manejo de conflictos entre dispositivos. No es requisito para un MVP local de un solo dispositivo. |
| P2 | Exportar y reiniciar datos | Los datos quedan en el dispositivo; existe la migración de `shared_preferences` a SQLite. | Ofrecer exportación y borrado/reinicio de los datos del usuario para facilitar respaldo, cambio de dispositivo y control de la información. |

## Flujo recomendado para el MVP

1. La persona configura el objetivo, experiencia, días, duración y equipo.
2. FORZA crea una semana visible en Inicio y Actividad; las sesiones se pueden mover sin perder el resto del plan.
3. Al comenzar, se crea una sesión en curso persistida. Cada ejercicio muestra la prescripción y cada serie permite registrar carga/repeticiones o tiempo.
4. La persona puede pausar, salir y continuar después. Al finalizar, la sesión pasa a completada y se guarda una copia de los resultados.
5. Progreso resume sesiones completadas y resultados capturados; cada métrica enlaza con el ejercicio o sesión que la produjo.

Esto resuelve la duda principal de producto: la acción de “marcar como hecho” ya existe en Actividad, pero completar una tarjeta no equivale todavía a registrar un entrenamiento útil para mejorar la rutina.

## Orden de construcción sugerido

1. Modelo y migración SQLite para sesiones planificadas, sesión en curso, ejercicios y series.
2. Interfaz de registro durante la sesión, incluyendo pausa y recuperación después de cerrar la app.
3. Agenda persistente, reprogramación, estados y prevención de duplicados.
4. Progreso calculado solo desde datos capturados; retirar las métricas ficticias de producción.
5. Guardado real de preferencias y recordatorios locales opcionales.
6. Cuentas y sincronización cuando el negocio requiera varios dispositivos o respaldo remoto.

## Lo que puede esperar

Comunidad, feed social, mensajes, clasificación competitiva, pagos y panel de administración no son indispensables para el ciclo de entrenamiento personal del MVP. Antes de añadirlos conviene validar que las personas crean un plan, terminan sesiones y vuelven a entrenar.
