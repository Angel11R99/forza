# Catálogo local de alimentos

## Snapshot incluido

`assets/data/nutrition_catalog.json` incluye 31 alimentos del archivo oficial USDA FoodData Central **Foundation Foods, octubre de 2026** (versión publicada el 29-10-2026), más 11 recetas editoriales sencillas en español e inglés. El snapshot de fuente mide 9.3 MB y no se distribuye dentro de la aplicación; solo se incluye la selección necesaria. Se conservan IDs FDC, fecha de publicación por alimento, nombre fuente, forma cruda/seca/enlatada, puntos de datos por nutriente y medidas domésticas con gramaje solo cuando Foundation Foods las publica. Los valores nutricionales son por 100 g de porción comestible.

USDA declara FoodData Central en dominio público bajo CC0 1.0 y pide atribución. El release, archivos y documentación de porciones se consultaron en [USDA Downloadable Data](https://fdc.nal.usda.gov/download-datasets/), [USDA Foundation Foods Documentation](https://fdc.nal.usda.gov/Foundation_Foods_Documentation/) y [USDA API Guide, Licensing](https://fdc.nal.usda.gov/api-guide/). Cita conservada en el asset: U.S. Department of Agriculture, Agricultural Research Service. FoodData Central. Foundation Foods, October 2026.

## Datos ausentes, alérgenos y acceso

- Trece nutrientes seleccionados se guardan por 100 g. Cada campo se conserva explícitamente; `null` significa que el snapshot no da un valor. Un cero reportado se distingue de un faltante. Se guardan kcal, proteína, grasa, carbohidratos, fibra, azúcares, sodio, calcio, hierro, potasio, vitamina C, vitamina A RAE y vitamina B12.
- Solo se convierten porciones cuando FDC trae un peso de porción específico para ese alimento. No se infiere que una taza, unidad o cucharada tenga el mismo peso en otros alimentos.
- Foundation Foods no es una tabla de composición regional para RD, Colombia, México, España o Argentina. Sus valores no se etiquetan como locales. Disponibilidad, coste y temporada quedan `unknown`; el catálogo no muestra precios ni afirma stock.
- El release no aporta una lista completa revisada de alérgenos para estos registros. Se conserva `allergenKnowledge: unknown`; el filtro de restricciones excluye estos elementos en vez de llamarlos seguros. Revisar etiquetas comerciales y contaminación cruzada sigue siendo necesario.
- Las recetas son propuestas culinarias editoriales sin afirmación de equivalencia nutricional ni aptitud clínica. Los gramos son cantidades de ingredientes, no recomendaciones dietéticas. La cocción del pollo remite a 165 °F (73.9 °C) con termómetro según [USDA FSIS](https://ask.fsis.usda.gov/article/What-is-a-safe-internal-temperature-for-cooking-meat-and-poultry).

## Fuentes nacionales candidatas

- La página oficial de [TCAC 2018 del ICBF](https://www.icbf.gov.co/nutricion/tabla-de-composicion-de-alimentos-colombianos) reporta 773 datos de alimentos, pero su portal indica © Gobierno de Colombia y “Todos los derechos reservados”. No se redistribuyen sus registros sin una licencia explícita o autorización.
- [FAO/INFOODS Tables and Databases](https://www.fao.org/infoods/infoods/tables-and-databases/en/) es un directorio, advierte que muchas tablas no están en poder de la Secretaría y que a menudo se obtienen en bibliotecas. No equivale a una licencia de redistribución.

Por esas condiciones, la selección incluida hoy es una base general offline, no la cobertura regional aprobada. Hasta añadir fuentes nacionales con derechos confirmados y revisión de datos, el motor debe mostrar cobertura/acceso desconocidos y no inventar metadatos locales. La ampliación debe conservar el esquema/versionado y añadir por país solo filas cuya fuente y permiso estén documentados.
