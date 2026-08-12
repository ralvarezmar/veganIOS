# Changelog

Todos los cambios notables de VeganLens (iOS) se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Sin publicar]

### Cambiado
- Las aportaciones a Open Food Facts se explican correctamente: no requieren cuenta ni inicio de sesión y se publican a través de la cuenta de la aplicación.
- La caché sin conexión caduca a los 60 días y los datos caducados ya no se muestran.
- Los datos nutricionales y el veredicto se leen como unidades completas con lectores de pantalla, incluyendo sus valores y unidades.
- El veredicto explica qué ingrediente lo provoca y si la conclusión procede de datos de Open Food Facts o de una detección orientativa en el texto; también reconoce sellos veganos y categorías de sustitutos de carne.
- Se comprueba con un corpus compartido que los casos clave del motor mantienen resultados coherentes.
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
