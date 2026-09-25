# Angular 17 Breaking Changes

## Support for NodeJS has been updated

Angular 17 removed support for NodeJS **16**.

NodeJS versions **18.13.0** and **20.9.0** are supported.

## ZoneJS version updated

The **ZoneJS** version has been updated to **0.14.0**.

## Support for TypeScript

Minimum support for **TypeScript v5.2** added. Versions **prior** to this will no longer be supported.

> For more information, visit the [official documentation on **TypeScript v5.2**](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-2.html).

## Changes in ZoneJS importation

Deep and legacy imports from `dist/` such as `zone.js/bundles/zone-testing.js` and `zone.js/dist/zone` are no longer allowed.

`zone-testing-bundle` and `zone-testing-node-bundle` are also no longer part of the package.

The correct way to import now is:

```javascript
import 'zone.js';
import 'zone.js/testing';
```

This change was made to improve code modularity and prevent compatibility issues with future versions of ZoneJS.
