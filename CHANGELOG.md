# Changelog

Todos los cambios notables de VeganLens (iOS) se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Sin publicar]

### Corregido
- Los resultados muestran niveles de huella de carbono y estimaciones del impacto del envase y el transporte.
- Los sellos veganos tienen prioridad sobre las etiquetas no veganas, las trazas de contaminación cruzada no condenan el producto y se nombran los ingredientes en conflicto.
- Las etiquetas de análisis no veganas ahora se contrastan con la lista de ingredientes antes de condenar el producto.
- La galería de mascotas mantiene visibles los apodos del detalle y la última fila frente a las barras del sistema.

## [1.10.2 (37)] - 2026-09-01

### Corregido
- Los resultados de productos usan los valores nutricionales preparados cuando Open Food Facts no tiene valores del producto tal cual se vende, e indican la base nutricional mostrada.

## [1.10.1 (36)] - 2026-09-01

### Corregido
- La huella de carbono también se lee del bloque heredado `ecoscore_data` de Open Food Facts.

## [1.10.0 (35)] - 2026-08-31

### Añadido
- El resultado del producto muestra el Green Score con su valor numérico, los niveles de nutrientes de Open Food Facts, los azúcares añadidos y la huella de carbono, indicando si está declarada en el envase o estimada a partir de Agribalyse.

## [1.8.0 (33)] - 2026-08-26
- Las mascotas de la galería ahora tienen un nombre propio.

## [1.5.0 (29)] - 2026-08-25

### Añadido
- Veintiocho personajes nuevos de la nueva lámina de ilustraciones se suman a la rotación de la portada, hasta un total de cuarenta y tres.
- Se mejora la calidad de las ilustraciones de los personajes de la portada y se redibujan sus chapitas «VEGAN».
- Una pequeña galería oculta de mascotas espera a las personas curiosas que quieran conocer a todos los personajes de la portada.
- Se añade una fila visible de agradecimientos para las personas que prueban la aplicación antes de cada versión.

## [1.4.1 (28)] - 2026-08-24

### Añadido
- Se incorpora la mascota de VeganLens como icono y una portada ilustrada rotatoria al iniciar la aplicación.

- El catálogo de aditivos de iOS queda sincronizado con Android, incluidos los códigos E de origen animal e incierto.
- Al compartir un resultado se incluye la imagen del producto cuando está disponible y se conserva el enlace de Open Food Facts.

### Cambiado
- La portada permanece visible hasta cinco segundos y sus recortes, junto con el icono recentrado, usan las ilustraciones revisadas.
- Se retira el personaje `citrus` de la rotación de la portada.
- El análisis fotográfico extrae la sección relevante, admite los seis idiomas del OCR y trata con más seguridad los envases multilingües y los compuestos alemanes.

## [1.2.0 (24)] - 2026-08-20

### Añadido
- Se incorporan los aditivos E270 y E428 al catálogo, con información sobre su origen.
- Se pueden fotografiar listas de ingredientes y analizarlas localmente con OCR editable, veredictos conservadores y avisos sobre segmentos no reconocidos.

### Cambiado
- La caché sin conexión conserva los productos durante 14 días antes de considerarlos caducados.
- Los aditivos identificados como de origen animal hacen que el producto se marque como no vegano y se muestran como causa del veredicto.

## [1.1.0 (23)] - 2026-08-12

### Cambiado
- El veredicto explica qué ingrediente lo provoca y si la conclusión procede de datos de Open Food Facts o de una detección orientativa en el texto; también reconoce sellos veganos y categorías de sustitutos de carne.
- Se comprueba con un corpus compartido que los casos clave del motor mantienen resultados coherentes.
- La normalización de ingredientes elimina el marcado HTML de Open Food Facts antes de resolver sus entidades.

## [1.0.1 (22)] - 2026-08-07

### Cambiado
- Las aportaciones a Open Food Facts se explican correctamente: no requieren cuenta ni inicio de sesión y se publican a través de la cuenta de la aplicación.
- La caché sin conexión caduca a los 60 días y los datos caducados ya no se muestran.
- Los datos nutricionales y el veredicto se leen como unidades completas con lectores de pantalla, incluyendo sus valores y unidades.
- Mejorados los procesos de distribución, pruebas automáticas, localizaciones y capturas de la aplicación; la aplicación y su documentación usan ahora el nombre VeganLens.

## [1.0.0 (20)] - 2026-08-06

### Cambiado
- El changelog y las notas de prueba de TestFlight se dividen por versión publicada.

## [0.1.2] - 2026-08-05

### Añadido
- Energía en kJ cuando el producto no aporta kilocalorías.
- Pruebas de decodificación del modelo con respuestas de ejemplo de Open Food Facts.

### Cambiado
- Ajustado el flujo de CI para asignar correctamente las compilaciones al grupo de TestFlight.
- Tiempos de espera de red más cortos y un único reintento en las lecturas; las escrituras no se reintentan.

### Corregido
- Decodificación tolerante de respuestas de Open Food Facts: un campo mal formado ya no descarta el producto completo y `nova_group` acepta número o texto.
- El estado de las contribuciones se interpreta tanto si llega como número como si llega como texto, con mensajes de error más claros.

## [0.1.1] - 2026-08-05

### Corregido
- Los valores nutricionales no se mostraban en la pantalla de resultado: ahora
  se solicita el producto completo a Open Food Facts y se aceptan valores
  numéricos entregados como texto, igual que en Android.
- Las contribuciones a Open Food Facts fallaban porque OFF ya no acepta envíos anónimos; ahora se autentican con una cuenta compartida de la app configurada por CI.

## [0.1.0] - 2026-08-04

### Añadido
- Veredicto basado en ingredientes con ajustes de accesibilidad y nuevo icono de la app.

## [0.0.2] - 2026-08-04

### Cambiado
- Ajustes del flujo de firma, exportación y validación de la distribución para el App Store.

## [0.0.1] - 2026-08-03

### Añadido
- Idiomas italiano y portugués, traducción de ingredientes en el dispositivo,
  explicaciones de puntuaciones, aviso sobre aceite de palma y widget de
  escaneo en la pantalla de inicio.
- CI de compilación para macOS en GitHub Actions.
- Email de contacto, políticas de privacidad en español e inglés en GitHub Pages y enlace desde la app.
- Renombrada la app a VeganLens, con el identificador actualizado a `com.ralvarezmar.vcheck`.
- Distribución de macronutrientes y badge de Nutri-Score en la pantalla de resultado.
- Atribución visible a Open Food Facts (ODbL), accesibilidad con subrayado/lectura de ingredientes señalados, localización completa ES/EN y licencia MIT.
- Descripción para la App Store en el README (subtítulo, texto promocional y descripción completa).
- Open Pet Food Facts como cuarta base de datos de respaldo.
- Estado de carga mientras se consultan las bases de datos.
- Resaltado por color de los ingredientes de origen animal o dudoso dentro de la lista.
- Marco de enfoque, texto de ayuda, feedback háptico y confirmación visual en el escáner.
- Estados vacíos y de error más claros, con botón "Reintentar" ante fallos de red.
- Historial en tarjetas con miniatura del producto.
- Mejor soporte de modo oscuro con colores y materiales del sistema.
- Política de privacidad (`PRIVACY.md` y página en `/docs` para GitHub Pages).

### Cambiado
- Acento lavanda en el modo oscuro, manteniendo el verde en el modo claro.
- Renombrada la app a **VeganLens**.
- Rediseño general de la interfaz: banner de veredicto con subtítulo e indicador de fuente.
- Lista de ingredientes como texto corrido; solo se resaltan los dudosos y los no aptos.
- Limpieza más robusta de los nombres de ingredientes (entidades HTML, marcadores y espacios).
- La búsqueda sigue consultando el resto de bases cuando una fuente no aporta datos veganos; "Sin datos suficientes" solo se muestra si ninguna los aporta.

## [2026-07-03]

### Añadido
- App SwiftUI para iOS 17+ con escáner de códigos de barras EAN/UPC vía AVFoundation.
- Consulta de producto a Open Food Facts (ingredientes, aditivos, alérgenos y nutrición).
- Veredicto vegano (Apto / No apto / Dudoso / Sin datos) a partir del análisis de ingredientes.
- Fuentes de respaldo Open Beauty Facts y Open Product Facts.
- Mensaje con las bases de datos consultadas cuando no hay información suficiente.
- Historial local de escaneos con SwiftData.

### Cambiado
- Redacción del veredicto a "producto apto para veganos".

### Corregido
- Las respuestas HTTP 404 se tratan como "producto no encontrado" en lugar de error de red.
