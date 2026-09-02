# Changelog

All notable changes to VeganLens (iOS) are documented in this file.

This is the primary changelog in English. `CHANGELOG.es.md` is its Spanish
translation. Update both changelog files together when adding or publishing a
version so that App Store Connect can provide notes in both languages.

## [Unreleased]

### Added
- Product results now show carbon-footprint levels and estimated packaging and transportation impacts.

### Changed
- Release notes are now published in English as well as Spanish.

## [1.10.3 (38)] - 2026-09-02

### Fixed
- Vegan seals take precedence over non-vegan tags, cross-contamination traces do not condemn the product, and conflicting ingredients are named.
- Non-vegan analysis tags are now checked against the ingredient list before condemning the product.
- The mascot gallery keeps detail nicknames and the last row clear of system bars.

## [1.10.2 (37)] - 2026-09-01

### Fixed
- Product results use prepared nutrition values when Open Food Facts has no as-sold values, and indicate the nutrition basis shown.

## [1.10.1 (36)] - 2026-09-01

### Fixed
- Carbon-footprint data is now also read from Open Food Facts' legacy `ecoscore_data` block.

## [1.10.0 (35)] - 2026-08-31

### Added
- Product results show the Green Score with its numeric value, Open Food Facts nutrient levels, added sugars, and the carbon footprint, indicating whether it is declared on the packaging or estimated from Agribalyse.

## [1.8.0 (33)] - 2026-08-26
- Gallery mascots now have their own names.

## [1.5.0 (29)] - 2026-08-25

### Added
- Twenty-eight new characters from the new artwork sheet join the welcome-cover rotation, for a total of forty-three.
- The welcome-cover character artwork has been improved and its «VEGAN» badges redrawn.
- A little hidden mascot gallery is waiting for curious people who want to meet all the welcome-cover characters.
- A visible acknowledgements row thanks the people who test the app before each release.

## [1.4.1 (28)] - 2026-08-24

### Added
- The VeganLens mascot is added as the app icon, along with a rotating illustrated welcome cover.

- The iOS additive catalogue is synchronized with Android, including E-codes of animal and uncertain origin.
- Sharing a result includes the product image when available and keeps the Open Food Facts link.

### Changed
- The welcome cover remains visible for up to five seconds, and its crops together with the recentered icon use the revised artwork.
- The `citrus` character is removed from the welcome-cover rotation.
- Photo ingredient analysis extracts the relevant section, supports all six OCR languages, and handles multilingual packs and German compounds more safely.

## [1.2.0 (24)] - 2026-08-20

### Added
- E270 and E428 are added to the catalogue, with information about their origin.
- Ingredient lists can be photographed and analyzed locally with editable OCR, conservative verdicts, and warnings about unrecognized segments.

### Changed
- The offline cache keeps products for 14 days before considering them expired.
- Ingredients identified as animal-derived cause the product to be marked as non-vegan and are shown as the reason for the verdict.

## [1.1.0 (23)] - 2026-08-12

### Changed
- The verdict explains which ingredient causes it and whether the conclusion comes from Open Food Facts data or an indicative text detection; it also recognizes vegan seals and meat-substitute categories.
- A shared corpus checks that the analyzer's key cases continue to produce consistent results.
- Ingredient normalization removes Open Food Facts HTML markup before resolving its entities.

## [1.0.1 (22)] - 2026-08-07

### Changed
- Open Food Facts contributions are explained correctly: they do not require an account or sign-in and are published through the app account.
- The offline cache expires after 60 days, and expired data is no longer shown.
- Nutritional data and the verdict are read as complete units by screen readers, including their values and units.
- Distribution, automated testing, localization, and screenshot processes are improved; the app and its documentation now use the VeganLens name.

## [1.0.0 (20)] - 2026-08-06

### Changed
- The changelog and TestFlight testing notes are split by published version.

## [0.1.2] - 2026-08-05

### Added
- Energy is shown in kJ when the product does not provide kilocalories.
- Model decoding tests use example responses from Open Food Facts.

### Changed
- The CI flow is adjusted to assign builds to the TestFlight group correctly.
- Network timeouts are shorter and reads have a single retry; writes are not retried.

### Fixed
- Tolerant decoding of Open Food Facts responses means a malformed field no longer discards the whole product, and `nova_group` accepts a number or text.
- Contribution status is interpreted whether it arrives as a number or text, with clearer error messages.

## [0.1.1] - 2026-08-05

### Fixed
- Nutritional values were not shown on the result screen: the complete product is now requested from Open Food Facts and numeric values delivered as text are accepted, as on Android.
- Contributions to Open Food Facts failed because OFF no longer accepts anonymous submissions; they are now authenticated with a shared app account configured by CI.

## [0.1.0] - 2026-08-04

### Added
- Ingredient-based verdicts with accessibility improvements and a new app icon.

## [0.0.2] - 2026-08-04

### Changed
- Signing, export, and distribution-validation flow adjustments for the App Store.

## [0.0.1] - 2026-08-03

### Added
- Italian and Portuguese languages, on-device ingredient translation, score explanations, a palm-oil warning, and a scanning widget on the home screen.
- macOS build CI in GitHub Actions.
- A contact email, Spanish and English privacy policies on GitHub Pages, and a link from the app.
- The app is renamed to VeganLens, with the identifier updated to `com.ralvarezmar.vcheck`.
- Macronutrient distribution and a Nutri-Score badge on the result screen.
- Visible attribution to Open Food Facts (ODbL), accessibility with underlining and reading of highlighted ingredients, complete ES/EN localization, and an MIT license.
- An App Store description in the README (subtitle, promotional text, and full description).
- Open Pet Food Facts as a fourth fallback database.
- A loading state while databases are queried.
- Color highlighting of animal-derived or doubtful ingredients in the list.
- A focus frame, help text, haptic feedback, and visual confirmation in the scanner.
- Clearer empty and error states, with a “Retry” button for network failures.
- History in cards with a product thumbnail.
- Better dark-mode support with system colors and materials.
- A privacy policy (`PRIVACY.md` and a `/docs` page for GitHub Pages).

### Changed
- A lavender accent in dark mode while keeping green in light mode.
- The app is renamed to **VeganLens**.
- A general interface redesign: a verdict banner with a subtitle and source indicator.
- The ingredient list is shown as flowing text; only doubtful and unsuitable items are highlighted.
- More robust ingredient-name cleanup, including HTML entities, markers, and spaces.
- Search continues querying the remaining databases when one source does not provide vegan data; “Not enough data” is shown only if none of them do.

## [2026-07-03]

### Added
- A SwiftUI app for iOS 17+ with an EAN/UPC barcode scanner using AVFoundation.
- Product queries to Open Food Facts (ingredients, additives, allergens, and nutrition).
- A vegan verdict (Suitable / Not suitable / Doubtful / No data) based on ingredient analysis.
- Open Beauty Facts and Open Product Facts as fallback sources.
- A message with the databases consulted when there is not enough information.
- A local scan history with SwiftData.

### Changed
- The verdict wording is changed to “product suitable for vegans”.

### Fixed
- HTTP 404 responses are treated as “product not found” instead of a network error.
