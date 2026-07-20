# App Store Connect App Privacy checklist

This checklist describes the current VeganLens iOS app and gives the concrete
answers to select in App Store Connect. Review the live App Privacy questions
when submitting because Apple can change the form wording.

## Privacy questionnaire answers

### Data collection

- **Does this app collect data?** Select **No, we do not collect data from
  this app** for personal-data collection.
- The app has no account, login, analytics, crash reporting, advertising SDK,
  or third-party tracker.
- Scan history, favourites, cached products, preferences, allergen settings,
  strict mode, and watchlists are stored locally on the device.
- There is no cloud sync for this local data.

### Tracking

- **Do you or your third-party partners use data for tracking?** Select **No**.
- The app does not track users across apps or websites and does not use
  advertising or analytics identifiers.

### Data linked to the user

- Select **None**. The app does not create accounts or collect personal
  identifiers, contact details, credentials, or payment information.

### Data not linked to the user

- Select **None** for personal-data categories.
- Do not declare local scan history, favourites, cache, preferences, or
  watchlists as collected data; they remain on the device.

### Purposes

- No data-collection purpose should be selected.
- Do not select analytics, advertising, product personalisation, or app
  functionality as a reason for collecting personal data.

## Camera and on-device OCR

The camera supports barcode scanning and ingredient-list capture. Ingredient
OCR uses Apple's Vision framework on the device:

- The OCR image is processed in memory.
- The image is not uploaded for OCR.
- The image is not persisted for OCR.
- Recognized text is copied into the editable ingredients field.
- The OCR result is not used to calculate a vegan verdict.

Camera permission is therefore a device capability, not collection of personal
data. No camera image should be declared in App Privacy as collected for OCR.

## Anonymous, user-initiated contributions

When the user actively chooses to contribute, the app sends the product fields
they entered and any product photos they explicitly selected to the selected
Open Food Facts, Open Beauty Facts, Open Product Facts, or Open Pet Food Facts
database. This flow is anonymous:

- No account, login, password, user ID, or personal identifier is sent.
- It is not automatic, background collection, analytics, advertising, or
  tracking.
- Product photos are optional and independent from the in-memory OCR image.
- The OCR image is not uploaded unless the user separately selects an image
  as an intentional product-photo contribution.

This user-directed product submission contains open product content, not
personal data linked to the user. Keep the App Privacy personal-data answers
above as **no data collected**. If Apple presents a separate question about
user-generated content or product submissions, describe this anonymous,
explicitly user-initiated product contribution there.

## Local data and deletion

Local history, favourites, cached products, preferences, allergen profile,
strict-mode setting, and custom watchlists remain on the device. The Settings
screen can clear the cache; this does not delete history or favourites. The
user can remove all local app data by deleting the app.

## Public privacy details

Privacy policy: https://ralvarezmar.github.io/veganIOS/

Contact: r.alvarezmar@gmail.com
