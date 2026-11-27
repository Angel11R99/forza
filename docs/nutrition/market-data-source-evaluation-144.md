# Evaluación de fuentes de mercado para alimentos (#144)

Verificación: 27 de noviembre de 2026. El alcance de esta fase es informar la decisión de producto; no se importaron precios al catálogo ni se desplegó infraestructura.

## Decisión

**No conectar todavía ninguna fuente al ranking de accesibilidad.** Los datos que encontramos no dan una base comparable, reciente y suficientemente representativa en los cinco países piloto. Unas fuentes son casi exclusivamente mayoristas; otras son observaciones comunitarias escasas y concentradas en algunos mercados. Mezclarlas para ordenar comidas produciría falsa precisión.

Mantener el fallback actual de catálogo curado y accesibilidad `unknown` cuando no haya cobertura. La ausencia de observaciones nunca se interpreta como precio alto, escasez ni indisponibilidad. El MVP no espera a que se desarrolle una integración externa.

## Comparación

| Fuente | Acceso y coste publicado | Cobertura / frecuencia | Licencia y limitaciones | Decisión |
| --- | --- | --- | --- | --- |
| **WFP Food Prices por HDX / HAPI** | Descarga de CSV y consulta HAPI pública; sin coste anunciado. El feed global actual se actualizó el 22 nov 2026. | HAPI describe 98 países y ~3.000 mercados; mayormente series mensuales, feed refrescado semanalmente. Revisé los CSV globales 2025 y 2026. En 2026, Colombia tenía 4.658 filas, 25 mercados y 58 alimentos, todas mayoristas, última fecha 15 jun 2026. En 2025, Colombia tenía 9.306 filas/25 mercados hasta 15 dic 2025; República Dominicana, 28 filas/1 mercado hasta 15 feb 2025. No encontré filas 2025/2026 para México, España o Argentina. | HDX marca el dataset WFP con CC BY-IGO. El esquema incluye tipo de precio (retail/wholesale), unidad, moneda, mes y mercado; el feed estandariza parte de la geografía. No equiparar mercados mayoristas con precios al consumidor. | Mejor opción para contexto mayorista y series donde sí haya datos; cobertura piloto actual insuficiente para ranking minorista. Revalidar por país y alimento antes de cada snapshot. |
| **Open Prices / Open Food Facts** | API REST y exports públicos; no se anuncia tarifa de consulta. | La página pública de países mostraba estas observaciones/ubicaciones: España 1.159/285, México 344/44, Argentina 57/20, Colombia 21/10, República Dominicana 7/5. Cobertura global amplia, pero aportes comunitarios; conteos pequeños en cuatro pilotos y no garantizan productos comparables ni frescura regular. | La guía de datos pide cumplir ODbL, atribuir y no mezclar con datos no libres que no puedan redistribuirse legalmente como datos abiertos. Los productos observados son marcas y tamaños comerciales, no una serie homogénea por alimento base. | No usar todavía para puntuación automática. Puede servir para exploración futura de cobertura local si un análisis legal acepta ODbL y se define un umbral de muestra/frescura. |
| **FAO GIEWS FPMA** | Acceso gratuito y descarga de bases estadísticas; API técnica publicada sin autenticación. | FAO reporta más de 2.900 series mensuales domésticas de retail/wholesale en 126 países (resumen de enero de 2024); disponibilidad concreta varía por país, mercado, producto y tipo. No es una canasta homogénea de compra minorista. | Los términos estadísticos de FAO indican CC BY 4.0 por defecto, pero incluyen excepciones de terceros y una condición que prohíbe usar los datasets para promover una empresa o producto comercial. FORZA no debe integrarla en un producto comercial sin aclaración de derechos para las series concretas. | No seleccionada hasta resolver permiso comercial/terceros y medir una cesta piloto específica. |
| **DANE SIPSA (Colombia)** | Servicio SOAP público; consulta diaria/semanal y mensual. No se publica tarifa en la página consultada. | Precios mayoristas de centrales de abasto; el portal también publica abastecimiento. DANE declara actualización diaria/semanal al día y mensual el día 8. Solo cubre Colombia y no equivale a precio minorista doméstico. | Los términos generales de DANE autorizan análisis con atribución, pero describen acceso como licencia individual y excluyen comercialización/usufructo. El portal de Datos Abiertos permite reutilización comercial en general; el registro concreto y sus metadatos vigentes deben resolver cuál condición aplica antes de redistribuir SIPSA. | Candidata para contexto mayorista colombiano, no para comparación directa ni distribución hasta confirmar los términos del dataset SIPSA específico. |

## Evidencia y método

- Para WFP consulté la API de metadatos de HDX, descargué temporalmente las hojas de precios globales 2025 y 2026 y conté filas por ISO3, `pricetype`, mercado, alimento y fecha máxima. Los ficheros temporales no se añadieron al repositorio. El CSV 2026 tiene 338.895 filas; el recurso pesaba 44.736.439 bytes al consultar. La cifra cuenta observaciones, no cobertura de tiendas minoristas.
- Para Open Prices usé la página pública de países indexada a 22 nov 2026; los conteos son registros de precio y ubicaciones observadas, no cobertura estadística o garantía de que cada registro sea alimento básico.
- El dato de 98 países/~3.000 mercados y actualización semanal/mensual es la descripción de HAPI, no una afirmación de presencia en cada uno de los cinco pilotos.
- No solicitamos coordenadas ni perfil del usuario a estas fuentes; no se hace scraping de tiendas. La selección regional actual sigue dependiendo del país que el usuario confirma voluntariamente.

## Arquitectura recomendada si se amplía después

1. Mantener adaptadores en backend/proceso editorial, no llamadas por cada dieta ni claves en la app. Publicar snapshots pequeños, fechados y versionados; preservar el último snapshot válido si falla una importación.
2. Normalizar por fuente, país, mercado, alimento canónico, clase del producto, tipo de mercado, unidad comestible, cantidad, moneda, fecha observada, fuente/licencia, versión y confianza. No promediar retail con wholesale ni unidad con kilogramo sin conversión documentada.
3. Derivar bandas relativas por producto y mercado con muestras recientes y comparables. La conversión de divisas no vuelve comparables productos, tamaños, costos de preparación ni tipos de mercado.
4. Exigir evidencia mínima de cobertura/frescura que defina el producto y revisión de licencias antes de encender cada país. Si no pasa esa puerta, dejar accesibilidad y disponibilidad en `unknown` y conservar la propuesta alimentaria normal.
5. Probar fixtures de unidades, monedas, outliers, datos vencidos, huecos regionales y fallos de red. Antes de ranking real, comparar un lote autorizado con el catálogo y validar que el costo no altera filtros clínicos, alérgenos ni restricciones.

## Próximo paso para completar el issue

Una vez aprobada la estrategia de derechos y los mínimos de cobertura, elegir un feed minorista representativo para la cesta de alimentos de cada piloto. En particular, confirmar explícitamente uso comercial para FAO/FPMA y DANE SIPSA, revisar los términos ODbL de Open Prices, y buscar una fuente/mercado minorista autorizado para República Dominicana, Colombia, México y Argentina. Hasta entonces no publicar snapshots experimentales ni cambiar el ranking.

## Referencias consultadas

- [HAPI: Food Prices & Market Monitor](https://hdx-hapi.readthedocs.io/en/latest/data_usage_guides/food_security_nutrition_and_poverty/)
- [HDX: Global Food Prices Database (WFP)](https://data.humdata.org/dataset/global-wfp-food-prices)
- [Open Prices: datos, exports y ODbL](https://openfoodfacts.github.io/open-prices/guides/data/)
- [Open Prices: países y observaciones](https://prices.openfoodfacts.org/countries?filter=location_count_gte_1)
- [FAO: FPMA y licencias de bases estadísticas](https://www.fao.org/contact-us/terms/db-terms-of-use/)
- [FAO: resumen del FPMA](https://www.fao.org/giews/data-tools/en)
- [DANE: servicio SOAP SIPSA y frecuencia de actualización](https://www.dane.gov.co/index.php/estadisticas-por-tema/agropecuario/sistema-de-informacion-de-precios-sipsa/servicio-web-para-consulta-de-la-base-de-datos-de-sipsa)
- [DANE: términos de uso del portal](https://www.dane.gov.co/index.php/terrminos-y-condiciones-dane)
- [Portal Datos Abiertos de Colombia: términos generales](https://herramientas.datos.gov.co/terminos)
