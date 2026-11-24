# Módulos recomendados para FORZA

Estado contrastado con el código de `main` el 24-11-2026. La app ya cubre buena parte del ciclo individual de entrenamiento en local. Las prioridades siguientes se enfocan en los huecos reales y pueden ajustarse según uso y comentarios.

## Implementado

- **Registro de series y recuperación:** SQLite guarda repeticiones, carga o duración por serie y el borrador de una sesión activa para reanudarla.
- **Agenda compartida:** Inicio, Actividad y entrenamiento consultan sesiones de los próximos 120 días desde SQLite. Las reprogramaciones y omisiones sobreviven al reinicio; las sesiones omitidas se pueden restaurar desde Actividad y no se cuentan como completadas.
- **Progreso básico:** historial y detalle usan datos persistidos. El resumen de 30 días calcula series, repeticiones y volumen; las sesiones registradas como realizadas fuera de la app no aportan series.
- **Objetivos personales:** metas semanales de sesiones y de carga por ejercicio se guardan localmente y se calculan desde las sesiones/series.
- **Calentamiento:** hay una secuencia breve opcional antes del entrenamiento. No hay una fase de vuelta a la calma confirmada.
- **Guías de ejercicios:** catálogo local de 1.324 ejercicios, instrucciones en español e inglés y 1.257 animaciones vectoriales. Las notas técnicas curadas cubren familias con fuentes; el resto conserva instrucciones del catálogo y un fallback visual.
- **Respaldo:** exportación/restauración local en JSON con validación y confirmación antes de reemplazar datos. No incluye catálogo ni preferencias de perfil que aún no persisten.

## Siguiente trabajo

| Módulo | Issue | Qué falta |
|---|---|---|
| Flujo de entrenamiento guiado | [#3](https://github.com/Angel11R99/forza/issues/3) | Hacer explícitas las fases, acciones, objetivos y avance; mantener disponible la instrucción y distinguir actividad por tiempo de series por repeticiones. |
| Versionado de rutina | [#13](https://github.com/Angel11R99/forza/issues/13) | Guardar snapshot/versión de rutina por sesión. |
| Preferencias y localización horaria | [#7](https://github.com/Angel11R99/forza/issues/7), [#6](https://github.com/Angel11R99/forza/issues/6) | Auditar preferencias persistidas y respetar formatos horarios del dispositivo. |
| Recordatorios | [#12](https://github.com/Angel11R99/forza/issues/12) | Programar y cancelar avisos locales con permisos, horario y zona horaria correctos. |
| Medidas y métricas | [#9](https://github.com/Angel11R99/forza/issues/9), [#10](https://github.com/Angel11R99/forza/issues/10), [#11](https://github.com/Angel11R99/forza/issues/11) | Persistir medidas y reemplazar gráficas/records de demostración con cálculos verificables sobre registros reales. |
| Instrucciones de ejercicios | [#1](https://github.com/Angel11R99/forza/issues/1), [#2](https://github.com/Angel11R99/forza/issues/2), [#18](https://github.com/Angel11R99/forza/issues/18) | Mejorar presentación y ampliar notas únicamente con técnica verificada, coordinando el alcance con el flujo de sesión. |
| Datos y portabilidad | [#8](https://github.com/Angel11R99/forza/issues/8), [#16](https://github.com/Angel11R99/forza/issues/16) | Auditar persistencia y ofrecer un reinicio local seguro; el respaldo/restauración ya existe. |

## Mejoras posteriores

- **Cobertura de medios autorizados:** inventariar los 67 ejercicios sin animación y buscar recursos con licencia comprobable; conservar fallback si no hay permiso ([#17](https://github.com/Angel11R99/forza/issues/17)).
- **Vuelta a la calma:** valorar una secuencia breve y opcional al terminar, sin bloquear la finalización ([#19](https://github.com/Angel11R99/forza/issues/19)).
- **Accesibilidad y adaptación:** revisar Android/iOS, tamaño de texto, contraste, targets, lectores de pantalla, navegación y temas ([#20](https://github.com/Angel11R99/forza/issues/20)).
- **Cuenta:** autenticación opcional solo si se decide ofrecer cuentas o sincronización entre dispositivos ([#5](https://github.com/Angel11R99/forza/issues/5)).
- **Gym Bro:** investigación futura dependiente de decisiones de cuenta, persistencia y privacidad; diseñar primero y solicitar aprobación antes de cualquier backend ([#22](https://github.com/Angel11R99/forza/issues/22)).

No distribuir animaciones de terceros sin licencia verificada. Nutrición, feed social, retos competitivos y mensajería general no son requisitos para validar el ciclo personal de entrenamiento.
