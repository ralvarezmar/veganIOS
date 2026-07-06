# VeganCheck

iOS SwiftUI app para escanear códigos de barras EAN/UPC, consultar Open Food Facts con fallback a Open Beauty Facts y Open Product Facts, mostrar un veredicto vegano prominente y guardar historial local con SwiftData.

## Funcionalidades

- Escaneo de códigos de barras con cámara usando AVFoundation.
- Consulta a Open Food Facts, Open Beauty Facts y Open Product Facts.
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
