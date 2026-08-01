# App Store assets — VeganLens / VCheck

Recursos de marketing para el envío a App Store Connect (bundle id `com.ralvarezmar.vcheck`).

## Icono de marketing

- `marketing-icon-1024.png` — 1024 × 1024 px, RGB **sin canal alfa** (requisito de Apple).
  Es una copia del icono real de la app (`Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`).
  Se sube en App Store Connect → App Information → App Icon (si se pide) y se usa como
  referencia. El icono que muestra la app lo genera Xcode desde el asset catalog.

## Capturas de pantalla

Las capturas se generan automáticamente en el runner **macOS de GitHub Actions** (workflow
`iOS CI`, job `build`, paso *Capture App Store screenshots*) ejecutando
`VeganCheckerUITests/ScreenshotUITests` en varios simuladores. Tras cada ejecución se suben
como artefacto descargable **`ios-app-store-screenshots`**, con una subcarpeta por dispositivo.

Descarga ese artefacto y coloca las PNG en las carpetas correspondientes de aquí:

| Carpeta            | Clase de dispositivo App Store        | Simulador usado (aprox.)      | Resolución nativa (px) |
|--------------------|---------------------------------------|-------------------------------|------------------------|
| `iphone-6-9/`      | iPhone 6.9" (obligatoria)             | iPhone 16 Pro Max             | 1320 × 2868            |
| `iphone-6-5/`      | iPhone 6.5" (opcional / compatib.)    | iPhone 11 Pro Max             | 1242 × 2688            |
| `ipad-13/`         | iPad 13" (obligatoria si hay iPad)    | iPad Pro 13" (M4) / 12.9"     | 2064 × 2752 / 2048 × 2732 |

> App Store Connect acepta la resolución nativa del simulador de cada clase de dispositivo.
> Apple exige al menos el set de **iPhone 6.9"** (o 6.7") y, si la app soporta iPad, el de
> **iPad 13"** (o 12.9"). El resto son opcionales.

Pantallas capturadas por dispositivo: onboarding, escáner, Ajustes/Accesibilidad, perfil,
historial, favoritos y búsqueda.

## Textos de ficha

- `listing-es.md`, `listing-en.md`, `listing-de.md`, `listing-fr.md` — nombre, subtítulo,
  descripción, keywords y notas, respetando los límites de caracteres de App Store.
- `APP_PRIVACY.md` — respuestas de privacidad (App Privacy) para el cuestionario de Apple.
- `RELEASE_SETUP.md` — guía del pipeline de firma/subida vía App Store Connect API.

## Nota

Los ficheros de `docs/` (`app_icon.png` 512×512, `feature_graphic.png` 1024×500) son formato
**Google Play** y no se usan para App Store.
