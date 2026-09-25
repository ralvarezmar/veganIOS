# 16.x.x

## 16.1.2 - 2024-09-17

### Fixed

- `initializeFromAccessToken` get request instead of post request to get the BKS token from an Access Token.

## 16.1.1 - 2024-09-04

### Fixed

- Authorization header was not being added correctly when it should when using `SecurityLiteModule`.

## 16.1.0 - 2024-05-21

### Added

- Possibility to add the security BKS token if the request contains the `x-santander-backend-service-id` header.

## 16.0.0 - 2024-02-22

### Added

- Angular 16 compatibility.
- Tealium integration added to the Logger module.
- `protectedResources` property in the security configuration. The requests will be checked against the protected resources to add the common and security headers.
- `architecture` property in the base config settings.
- `endpointCorp` property in the security settings to exchange Access Token for Spain local token (BKS).
- `initializeFromAccessToken` method to initialize corporative security from an Access Token.

### Changed

- Dependencies of Darwin modules 4.X.X

### Breaking Changes

- MSAL library has been migrated from MSAL V2 to MSAL V3 (there is no compatibility between Angular 16 and MSAL V2). With this change, Msal requires initialization from the very beginning and it will be performed by the @ng-darwin library.
- Removed `noPrefixConfigPath` optional property from `ConfigSettings`. Now the request to get the configuration will be directly done to `<TECHNICALGROPING>/config.json` instead of `config/<TECHNICALGROPING>/config.json`.
