# Nutrición: dominio, fuentes y alcance

## Estado actual auditado

- `BodyMeasurement` y `BodyMeasurements` conservan peso y medidas fechadas. No existe estatura.
- `TrainingSettings` contiene objetivo deportivo, días de entrenamiento, duración, experiencia y equipo. Se mantiene como fuente canónica del entrenamiento.
- `PersonalGoal` registra frecuencia semanal o carga de ejercicio; no representa el objetivo nutricional.
- `ScheduledTrainingSession` conserva agenda, estado y versión/captura del plan.
- No se encontró edad/fecha de nacimiento, actividad cotidiana fuera del gimnasio ni perfil nutricional persistido. No inferirlos ni duplicar el peso.
- Los modelos existentes dependen de la app en algunos casos; los nuevos contratos de `lib/domain/models/nutrition/` son Dart puro y no importan Flutter ni Drift.

## Contratos y dependencias

`NutritionProfile` contiene preferencias mínimas propias de nutrición y versiona cambios. Datos que pertenecen al perfil/entrenamiento existentes se consultan desde sus repositorios; las medidas se leen de `BodyMeasurementRepository`. `NutritionCatalogFood` y `NutritionCatalogRecipe` son catálogo versionado con fuentes, IDs y campos por 100 g; su acceso regional (`FoodAccess`) admite desconocido, confianza, procedencia y versión. El menú guarda las versiones del perfil, catálogo y objetivos que usó. `MealEntry` permite registrar alimento o receta sin exigir un menú. Fuentes, permisos y límites de la primera selección están en [catalog-sources.md](catalog-sources.md).

País de compra es una preferencia confirmada manualmente y distinta del idioma, unidades y zona horaria. La región es texto opcional y amplio. Si no hay país confirmado o cobertura, se resuelve catálogo general y se informa cobertura; nunca se solicitan coordenadas ni se interpreta locale como residencia.

Flujo de casos de uso: perfil/agenda/medidas canónicos → validación de datos disponibles → objetivos solo si existe método aprobado y perfil suficiente → catálogo regional local → propuesta de menú con fallback ante datos desconocidos → registro y revisión. Persistencia se añade en la capa data (Drift/repositorios), UI solo depende de contratos/casos de uso. MVP local-first; no requiere IA remota, pagos ni servicios de precios en vivo.

## Reglas y seguridad

- Objetivo deportivo y objetivo nutricional son conceptos distintos y opcionales.
- No calcular ni mostrar calorías/macros hasta que método, población aplicable, unidades, validación profesional y límites estén documentados. `NutritionTargets` requiere procedencia/versionado; los valores nulos significan que no se prescribe.
- Somatotipo no es diagnóstico ni fórmula dietética. No inferirlo por aspecto.
- Alergia, intolerancia, preferencia y exclusión se representan por separado. Si el dato de alérgenos o disponibilidad es desconocido, no afirmar que un alimento es seguro/disponible.
- Minimizar datos sensibles, guardarlos localmente, permitir omisión/borrado y no requerir cuenta. Los casos clínicos o poblaciones especiales requieren orientación profesional, sin solicitar diagnósticos detallados como condición de uso.
- El coste solo ordena opciones después de seguridad y adecuación; no reemplaza esas reglas.

## Navegación y responsabilidades previstas

- Perfil → Perfil nutricional: datos y preferencias opcionales, editables en una sola fuente de verdad.
- Nutrición → Hoy / Semana / Recetas / Compras: menú y registro.
- Actividad: agenda de entrenamiento; Nutrición puede consultarla contextualizando horarios, sin editarla como copia.
- Progreso: tendencias y revisiones, sin diagnosticar.
- Perfil → Notificaciones y Conexiones de salud: ajustes transversales; integraciones externas son optativas y posteriores al MVP.

## Fases coordinadas

1. Contratos puros y límites (este documento).
2. Perfil nutricional opcional, persistencia local y fuentes canónicas.
3. Catálogo curado regional, restricciones y clasificación de coste/disponibilidad versionada.
4. Ranking seguro, recetas, planificación, registro/revisión.
5. Adaptadores de fuentes externas con snapshots verificables; la app funciona offline si fallan.

La referencia de consenso SEÑ recalca individualizar estrategias según deporte, fase y contexto, con guía profesional: [PubMed, PMID 41470807](https://pubmed.ncbi.nlm.nih.gov/41470807/). Somatotipos no se usan para prescribir.
