# Changelog

Todos los cambios notables de VeganCheck (iOS) se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Sin publicar]

### Añadido
- Descripción para la App Store en el README (subtítulo, texto promocional y descripción completa).
- Open Pet Food Facts como cuarta base de datos de respaldo.
- Estado de carga mientras se consultan las bases de datos.
- Resaltado por color de los ingredientes de origen animal o dudoso dentro de la lista.
- Marco de enfoque, texto de ayuda, feedback háptico y confirmación visual en el escáner.
- Estados vacíos y de error más claros, con botón "Reintentar" ante fallos de red.
- Historial en tarjetas con miniatura del producto.
- Mejor soporte de modo oscuro con colores y materiales del sistema.

### Cambiado
- Renombrada la app a **VeganCheck** (antes VeganChecker).
- Rediseño general de la interfaz: banner de veredicto con subtítulo e indicador de fuente.
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
