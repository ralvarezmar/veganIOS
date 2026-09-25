# @ng-darwin-wmf 15.x.x

## 15.0.2 - 2023-10-11

### Added

- Fixed problems using `externalNavigate` when the routes does not have path.

## 15.0.1 - 2023-09-15

### Added

- Problems sending props through `externalNavigate` navigation when Shell routing has children or complex routes.

## 15.0.0 - 2023-08-18

### Added

- Angular 15 compatibility.

### [Breaking Changes](./breaking-changes.md)

- The `constructor` of the `MicrofrontContainerDirective` and `MicrofrontDirective` directives should no longer be called with any dependencies.
