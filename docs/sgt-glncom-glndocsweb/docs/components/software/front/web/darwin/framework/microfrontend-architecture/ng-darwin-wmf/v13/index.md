# @ng-darwin-wmf 13.x.x

## 13.2.2 - 2023-08-07

### Fixed

- The use of `changeDetectorRef.detectChanges` is replaced by `ngZone.run`, thus avoiding rendering problems when having promises at the start of the Microfront.

## 13.2.1 - 2023-06-16

### Fixed

- Problems initializing a microfront with empty routes and queryParams.

## 13.2.0 - 2023-05-04

### Added

- Navigation between Microfronts while passing information:  
    When navigating between microfronts, it is now possible to attach information such as queryParams, props,
    and extra data. This allows for navigation with returns, where Microfront A can navigate to Microfront B and specify that
    it should return to the first microfront when finished.
- Navigation between Microfront using projectId:  
    The externalNavigate event and `MicrofrontNavigationTarget` (a new type) have a `target` property,
    which can contain either the microfront URL (the expected behaviour until now) or a projectId, which will later be translated to the microfront URL by the library.

### Fixed

- `if` condition for the initial navigation:
    The navigation update now only executes when the `MicrofrontDirective` has the `mountPath` property.
- Fixed detection for navigate to:
    The navigation now refreshes the view in a specific case.

## 13.1.0 - 2023-03-23

### Breaking Changes

- `MicrofrontContainerDirective` does not require the `APP_BASE_HREF` parameter in the `constructor`.
- When using the `MicrofrontDirective`, the `mountPath` property does not have to contain the relative path of the shell. For example, if you have a shell with relative path `/relative/path`, and the Microfront is mounted on `/microfront-a`, the `mountPath` property should just be `microfront-a`. <!-- markdownlint-disable MD013 -->

### Added

#### Utils

- The `locationStrategyFactory` provider allows Microfronts to be integrated into a hashed shell.

## 13.0.0 - 2023-01-20

### Added

#### Directives

- `MicrofrontContainerDirective`
- `MicrofrontDirective`

#### Modules

- `MicrofrontModule`

#### Pipes

- `PrefixAssetPipe`
- `MountPathPipe`

#### Services

- `MountPathService`

#### Types

- `BreadcrumbLink`
