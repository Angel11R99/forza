# Módulos recomendados para FORZA

Estado contrastado con el código de `main` el 24-11-2026. La app ya cubre buena parte del ciclo individual de entrenamiento en local. Las prioridades siguientes se enfocan en los huecos reales y pueden ajustarse según uso y comentarios.

## Implementado

- **Registro de series y recuperación:** SQLite guarda repeticiones, carga o duración por serie y el borrador de una sesión activa para reanudarla.
- **Agenda compartida:** Inicio, Actividad y entrenamiento consultan sesiones de los próximos 120 días desde SQLite. Las reprogramaciones y omisiones sobreviven al reinicio; las sesiones omitidas se pueden restaurar desde Actividad y no se cuentan como completadas.
- **Progreso básico:** historial y detalle usan datos persistidos. El resumen de 30 días calcula series, repeticiones y volumen; las sesiones registradas como realizadas fuera de la app no aportan series.
- **Objetivos personales:** metas semanales de sesiones y de carga por ejercicio se guardan localmente y se calculan desde las sesiones/series.
- **Medidas corporales:** peso y perímetros opcionales por fecha, con validación, edición/eliminación, evolución del peso y respaldo local.
- **Accesibilidad y adaptación:** la navegación conserva etiquetas semánticas, selección y acciones; sus targets son de 48 dp y respeta movimiento reducido. Encabezados y pestañas se adaptan a 320 px y texto 2×. El contraste de texto y acciones está comprobado en ambos temas. Inicio, Actividad, Ejercicios y teclado se revisaron en emulador Android; iOS queda sin validar porque no hay simulador disponible.
- **Calentamiento y vuelta a la calma:** hay secuencias breves opcionales antes y después del entrenamiento. La vuelta a la calma se adapta a los grupos musculares de la sesión, muestra instrucciones por paso y se puede omitir; no modifica los resultados ni la duración registrada.
- **Guías de ejercicios:** catálogo local de 1.324 ejercicios, instrucciones en español e inglés y 1.260 medios animados. 509 ejercicios reciben notas técnicas de familias con fuentes; 815 variantes permanecen sin notas curadas y conservan las instrucciones y el fallback. El inventario por ID y grupo está en [notas técnicas pendientes](11-inventario-notas-tecnicas.md).
- **Respaldo:** exportación/restauración local en JSON con validación y confirmación antes de reemplazar datos. No incluye catálogo ni preferencias de perfil que aún no persisten.

## Siguiente trabajo

| Módulo | Issue | Qué falta |
|---|---|---|
| Flujo de entrenamiento guiado | [#3](https://github.com/Angel11R99/forza/issues/3) | Hacer explícitas las fases, acciones, objetivos y avance; mantener disponible la instrucción y distinguir actividad por tiempo de series por repeticiones. |
| Versionado de rutina | [#13](https://github.com/Angel11R99/forza/issues/13) | Guardar snapshot/versión de rutina por sesión. |
| Preferencias y localización horaria | [#7](https://github.com/Angel11R99/forza/issues/7), [#6](https://github.com/Angel11R99/forza/issues/6) | Auditar preferencias persistidas y respetar formatos horarios del dispositivo. |
| Recordatorios | [#12](https://github.com/Angel11R99/forza/issues/12) | Programar y cancelar avisos locales con permisos, horario y zona horaria correctos. |
| Medidas y métricas | [#10](https://github.com/Angel11R99/forza/issues/10), [#11](https://github.com/Angel11R99/forza/issues/11) | Reemplazar gráficas/records de demostración con cálculos verificables sobre registros reales. |
| Instrucciones de ejercicios | [#1](https://github.com/Angel11R99/forza/issues/1), [#2](https://github.com/Angel11R99/forza/issues/2), [#18](https://github.com/Angel11R99/forza/issues/18) | Mejorar presentación y ampliar notas únicamente con técnica verificada, coordinando el alcance con el flujo de sesión. |
| Datos y portabilidad | [#8](https://github.com/Angel11R99/forza/issues/8), [#16](https://github.com/Angel11R99/forza/issues/16) | Auditar persistencia y ofrecer un reinicio local seguro; el respaldo/restauración ya existe. |

## Mejoras posteriores

- **Cobertura de medios autorizados:** hay 1.260 ejercicios con fotogramas y 64 con fallback. Se añadieron tres coincidencias de la fuente CC0 y se inventariaron los casos restantes; mantener fallback si la fuente no representa con precisión el ejercicio ([#17](https://github.com/Angel11R99/forza/issues/17); [inventario](10-inventario-medios-ejercicios.md)).
- **Cuenta:** autenticación opcional solo si se decide ofrecer cuentas o sincronización entre dispositivos ([#5](https://github.com/Angel11R99/forza/issues/5)).
- **Gym Bro:** investigación futura dependiente de decisiones de cuenta, persistencia y privacidad; diseñar primero y solicitar aprobación antes de cualquier backend ([#22](https://github.com/Angel11R99/forza/issues/22)).

La propuesta de Gym Bro está en [diseño y evaluación](12-diseno-gym-bro.md). No implica que haya backend o cuenta social implementados.

No distribuir animaciones de terceros sin licencia verificada. Nutrición, feed social, retos competitivos y mensajería general no son requisitos para validar el ciclo personal de entrenamiento.
