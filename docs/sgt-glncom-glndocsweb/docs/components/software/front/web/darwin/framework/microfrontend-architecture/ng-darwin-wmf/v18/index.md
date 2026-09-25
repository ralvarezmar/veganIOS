# @ng-darwin-wmf 18.x.x

## 18.1.0 - 2025-03-17

### Added

- `@ng-darwin-wmf/microfront` compatibility with S3 through the __webpack_public_path__ variable.

## 18.0.0 - 2024-11-19

### Added

- Angular 18 compatibility.
- Updated `@ng-darwin` dependencies to `18.0.0` release.

### Breaking Changes

- `microfrontRef` is now a signal of type `Signal<ElementRef>`: `this.currentContainer.microfrontRef().nativeElement.<method>`.
- `isLoaded` is now a signal of type `WritableSignal<boolean>`: `@if (isLoaded()) { ... }`.
