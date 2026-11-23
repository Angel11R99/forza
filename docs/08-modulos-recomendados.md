# Módulos recomendados para FORZA

Este documento reúne módulos que pueden ampliar FORZA sin perder el foco en crear un plan, entrenar y entender los resultados. Las prioridades indican el orden sugerido, no una obligación de incluir todo en la primera versión.

## Avance

- **Registro de series y recuperación de sesión:** implementados en SQLite. La sesión activa conserva el ejercicio, tiempo y series; cada serie admite repeticiones y carga, o duración para ejercicios cronometrados. Al completar, esos resultados se guardan junto al historial.
- **Agenda compartida entre Inicio, Actividad y entrenamiento:** implementada en SQLite para los próximos 120 días. Las sesiones conservan su estado pendiente, en curso o completada; las reprogramaciones sobreviven al reinicio y las tres superficies consultan el mismo calendario.
- **Progreso basado en resultados:** implementado para los últimos 30 días. La vista resume repeticiones, series y volumen (repeticiones × carga); el detalle muestra el registro de cada ejercicio. Las sesiones marcadas fuera de la app no generan métricas de series.
- **Objetivos personales:** implementados con metas semanales de sesiones y marcas de carga para un ejercicio. Se guardan localmente y se pueden editar o retirar; el avance se calcula desde las sesiones y series registradas.
- **Calentamiento y movilidad:** implementados antes de cada sesión, con una secuencia breve según el enfoque del entrenamiento y una opción visible para omitirla.
- **Guías de ejercicios:** implementadas en el detalle con animaciones locales disponibles, instrucciones numeradas y notas técnicas vinculadas a fuentes ACE para familias de movimientos presentes en el catálogo. Los ejercicios sin animación muestran su alternativa visual y los pasos escritos.
- **Exportación y respaldo:** implementados como archivo JSON local. Incluye plan, historial y series, agenda, objetivos, sesión activa y apariencia; al restaurar valida el archivo y pide confirmación antes de reemplazar los datos.
- **Siguiente mejora posible:** revisar individualmente las variantes no cubiertas por las familias de notas y ampliar el catálogo de animaciones cuando haya material revisado y autorizado.

## Prioridad alta: cerrar el ciclo de entrenamiento

| Módulo | Propósito | Alcance inicial |
|---|---|---|
| Inicio / resumen | Ayudar a decidir qué hacer al abrir la app. | Próxima sesión, avance semanal y acceso para iniciar o continuar el entrenamiento. |
| Registro de series | Guardar el trabajo real hecho en una sesión. | Registrar repeticiones, carga o duración por serie; permitir corregir datos y retomar una sesión en curso. |

Estos dos módulos se complementan: Inicio conduce a la sesión y el registro alimenta el historial y Progreso. Conviene enlazarlos con la agenda de Actividad para evitar que cada pantalla muestre una versión distinta del plan.

## Prioridad media: apoyar cada sesión

| Módulo | Propósito | Alcance inicial |
|---|---|---|
| Calentamiento y movilidad | Preparar el cuerpo y dar estructura al comienzo y cierre del entrenamiento. | Secuencias breves relacionadas con la sesión, con opción de omitir y sin bloquear el entrenamiento. |
| Objetivos personales | Dar seguimiento a metas concretas elegidas por la persona. | Metas como sesiones por semana o una marca personal; mostrar avance y permitir editar o retirar una meta. |
| Guías de ejercicios | Facilitar la ejecución de los movimientos. | Video o animación cuando haya medios disponibles, más instrucciones de técnica y errores frecuentes. |

## Prioridad posterior: portabilidad y continuidad

| Módulo | Propósito | Alcance inicial |
|---|---|---|
| Exportación y respaldo | Dar control sobre los datos locales y facilitar el cambio de dispositivo. | Implementado: exportar los datos persistidos a JSON y restaurarlos desde un archivo validado. |

## Secuencia sugerida

1. Completar el registro de series y la recuperación de una sesión interrumpida.
2. Conectar Inicio, Actividad y el entrenamiento activo a la misma agenda persistente.
3. Calcular Progreso a partir de los resultados registrados.
4. Añadir objetivos personales y calentamientos cortos según lo que pidan las personas usuarias.
5. Incorporar medios de ejercicios adicionales cuando existan recursos y una necesidad validada.

## Módulos para evaluar más adelante

Nutrición, comunidad, retos competitivos y mensajería pueden ampliar el producto, pero agregan contenido, moderación o mantenimiento. Es mejor validarlos después de comprobar que las personas crean un plan, completan sesiones y vuelven a entrenar.
