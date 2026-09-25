# @ng-darwin-wmf 16.x.x

## 16.0.2 - 2024-11-19

### Fix

- Now the global variable `_dwZone_` is created to make available the NgZone instance coming from the Shell for later use in Microfronts in versions equal or higher than 18.

## 16.0.1 - 2024-09-17

### Fix

- Internal QA issues has been solved.

## 16.0.0 - 2024-02-27

### Added

- Angular 16 migration and updated @ng-darwin dependencies in order to use v`16.0.0`.
- The event `externalNavigate` now allows attaching queryParams and props to any route as Angular normal navigate would do.

### Breaking Changes

- The property `queryParams` of the type `MicrofrontNavigation` now instead of being a Map, is an object key and value string.
