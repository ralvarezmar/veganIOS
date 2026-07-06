# VeganCheck

iOS SwiftUI app para escanear códigos de barras EAN/UPC, consultar Open Food Facts con fallback a Open Beauty Facts, Open Product Facts y Open Pet Food Facts, mostrar un veredicto vegano prominente y guardar historial local con SwiftData.

## Descripción para la App Store

**Subtítulo (máx. 30 caracteres):**

> ¿Es apto para veganos?

**Texto promocional (máx. 170 caracteres):**

> Escanea el código de barras de cualquier producto y descubre al instante si es apto para veganos, con sus ingredientes, aditivos, alérgenos e información nutricional.

**Descripción completa:**

VeganCheck es tu asistente de compra vegana. Apunta la cámara al código de barras de cualquier producto alimentario o cosmético y descubre en segundos si es **apto para veganos**, junto con su lista completa de ingredientes, aditivos, alérgenos e información nutricional.

Olvídate de leer etiquetas interminables o de buscar ingredientes de origen animal uno a uno. VeganCheck analiza la composición del producto y te muestra un veredicto claro y con color:

• Apto para veganos — sin ingredientes de origen animal ni dudoso.
• No apto para veganos — contiene ingredientes de origen animal (te los enumera).
• Origen dudoso — incluye ingredientes de procedencia incierta (te los enumera).
• Sin datos suficientes — no hay información vegana en las bases consultadas.

Funciones principales:

• Escáner de códigos de barras (EAN y UPC) rápido y fluido, con marco de enfoque y confirmación al detectar el código.
• Veredicto vegano destacado, con explicación y resaltado de los ingredientes problemáticos dentro de la lista.
• Ingredientes, aditivos, alérgenos y valores nutricionales por cada producto.
• Búsqueda con respaldo en varias bases de datos abiertas: Open Food Facts, Open Beauty Facts, Open Product Facts y Open Pet Food Facts. Si una no tiene datos suficientes, se consultan las siguientes automáticamente y se indica la fuente.
• Historial local de tus escaneos recientes para volver a consultarlos cuando quieras.
• Interfaz nativa SwiftUI con soporte de modo oscuro.

Privacidad: VeganCheck solo usa la cámara para leer códigos de barras y se conecta a Internet para consultar la información pública de los productos. No requiere registro ni recopila datos personales; el historial se guarda únicamente en tu dispositivo.

La información de los productos procede de las bases colaborativas y abiertas de Open Food Facts y sus proyectos hermanos. VeganCheck no está afiliada a dichos proyectos.

*Nota: el veredicto vegano se basa en los datos disponibles en las bases consultadas y puede estar incompleto o desactualizado. Ante cualquier duda, consulta siempre el etiquetado oficial del producto.*

## Funcionalidades

- Escaneo de códigos de barras con cámara usando AVFoundation.
- Consulta con respaldo a Open Food Facts, Open Beauty Facts, Open Product Facts y Open Pet Food Facts.
- Veredicto vegano destacado: Vegano, No vegano, Dudoso o Sin datos suficientes.
- Lista de ingredientes, aditivos, alérgenos, nutrición y fuente de datos.
- Historial local de escaneos recientes con SwiftData.
- Interfaz nativa SwiftUI en español.

## Requisitos

- Xcode 15 o superior
- iOS 17 o superior
- Cámara física para probar el escáner

## Abrir el proyecto

```bash
open VeganChecker.xcodeproj
```

## Ejecutar

1. Abre el proyecto en Xcode.
2. Selecciona un dispositivo físico iPhone.
3. Ejecuta la app y concede permiso de cámara.

> Nota: el escaneo requiere un dispositivo real; el simulador no proporciona cámara.

## Fallback de regeneración

El repositorio incluye `project.yml` para XcodeGen como plan de respaldo. Si el archivo `.xcodeproj` tuviera algún problema, puedes regenerarlo con:

```bash
xcodegen generate
```

## Permisos

- `NSCameraUsageDescription`: necesario para escanear códigos de barras.

## Atribución

La app usa datos de [Open Food Facts](https://world.openfoodfacts.org/), [Open Beauty Facts](https://world.openbeautyfacts.org/) y [Open Product Facts](https://world.openproductfacts.org/).
