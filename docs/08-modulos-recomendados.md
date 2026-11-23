# Módulos recomendados para FORZA

Este documento reúne módulos que pueden ampliar FORZA sin perder el foco en crear un plan, entrenar y entender los resultados. Las prioridades indican el orden sugerido, no una obligación de incluir todo en la primera versión.

## Avance

- **Registro de series y recuperación de sesión:** implementados en SQLite. La sesión activa conserva el ejercicio, tiempo y series; cada serie admite repeticiones y carga, o duración para ejercicios cronometrados. Al completar, esos resultados se guardan junto al historial.
- **Pendiente de esta secuencia:** agenda persistente compartida, métricas de Progreso basadas en series, metas, calentamiento, guías y exportación/respaldo.

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
| Exportación y respaldo | Dar control sobre los datos locales y facilitar el cambio de dispositivo. | Exportar historial y preferencias; restaurar desde un archivo validado. |

## Secuencia sugerida

1. Completar el registro de series y la recuperación de una sesión interrumpida.
2. Conectar Inicio, Actividad y el entrenamiento activo a la misma agenda persistente.
3. Calcular Progreso a partir de los resultados registrados.
4. Añadir objetivos personales y calentamientos cortos según lo que pidan las personas usuarias.
5. Incorporar medios de ejercicios y respaldo cuando existan recursos y una necesidad validada.

## Módulos para evaluar más adelante

Nutrición, comunidad, retos competitivos y mensajería pueden ampliar el producto, pero agregan contenido, moderación o mantenimiento. Es mejor validarlos después de comprobar que las personas crean un plan, completan sesiones y vuelven a entrenar.
