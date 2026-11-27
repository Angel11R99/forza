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

### Estado del motor de objetivos (#138)

`NutritionTargetReadiness` es una barrera preventiva pura de dominio, no una fórmula. Enumera los datos críticos ausentes y bloquea objetivos automatizados para menores, embarazo/lactancia, riesgo de trastorno alimentario y condiciones que requieren supervisión. La edad se usa solo como dato ya disponible en `NutritionProfile`; las señales clínicas se pasan de forma efímera y no se persisten como diagnóstico. El peso debe venir de las medidas ya almacenadas; actividad cotidiana y meta deben conocerse, no inferirse. La agenda conserva días/minutos y distingue día de entrenamiento o descanso como contexto: no estima calorías por sesión ni suma actividad dos veces.

Actualmente siempre se incluye `professionalReviewRequired` y `targets` permanece nulo: revisar artículos o tener tests no equivale a validación profesional para esta población y producto. Por tanto no hay números de calorías/macros ni dietas generados automáticamente. Para habilitar un motor cuantitativo hace falta una regla versionada con población, entradas/unidades, fuentes y revisión profesional identificable; hasta entonces la interfaz debe ofrecer educación general/orientación profesional y dejar usar el entrenamiento normalmente. Las recomendaciones deportivas deben individualizarse por deporte, fase y contexto, como señalan el [consenso SEÑ 2025 (PMID 41470807)](https://pubmed.ncbi.nlm.nih.gov/41470807/) y la [posición conjunta ACSM/ADA/Canada (PMID 19225360)](https://pubmed.ncbi.nlm.nih.gov/19225360/).

### Estado del planificador (#139)

`NutritionWeekPlanner` genera siete días reproducibles desde el catálogo local, usa los patrones dietarios editoriales, restricciones explícitas, comidas configurables y calendario de entreno/descanso. No estima calorías de entrenamientos ni inventa precios, horarios o disponibilidad. Los totales son estimaciones por receta calculadas de los gramos editoriales; cualquier nutriente faltante continúa nulo. La compra agrega gramos por alimento y no inventa equivalencias de medidas caseras. Como todos los alérgenos de la selección siguen sin revisar, una alergia/intolerancia produce “sin recetas seguras”, no un plan potencialmente peligroso. Las etiquetas vegana/vegetariana se limitan a los ingredientes editoriales listados y no declaran ausencia de contaminación cruzada.

La regeneración pura incrementa versión, conserva intactos los días anteriores al corte y recalcula la lista de compra. La sustitución devuelve una vista previa inmutable, vuelve a validar patrón/restricciones y exige nutrientes comparables (todos los valores disponibles entre energía, proteína y carbohidrato dentro de ±20 %); datos incomparables bloquean la sustitución. Todavía faltan presentación/edición de menú en UI, persistencia de versiones/historial y validación profesional/editorial del ranking y tags; no se debe presentar esta fase como un menú completo. Presupuesto y país no alteran el orden mientras el catálogo carezca de metadatos regionales fiables; los desconocidos no se tratan como baratos o caros. Esas limitaciones están cubiertas en el flujo de #137/#138 y deben resolverse antes de cerrar el issue.

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
