# Changelog

All notable changes to project `gln-back-arsenal-backend-archetype-grpc` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.16.5]

<!tag:3165>

### Added

- Content Security Policy configuration on Spring Security due to Fortify reported issue HTML5: Missing Content Security Policy

<!end:3165>

## [3.14.1]

<!tag:3141>

### Fixed

- Fixing openapi contract security configuration for the archetype generation

<!end:3141>

## [3.14.0]

<!tag:3140>

### Updated

- Updating archunit to new repository project version

### Improvement

- Added the possibility to include security configuration for the archetype generation with parameter 'isSecurityEnabled'

<!end:3140>

## [3.13.4]

<!tag:3134>

### Fixed

- Fixing fortify issues for open api contract

<!end:3134>

## [3.13.0]

<!tag:3130>

### Changed

- Changing tests implementation to use unit tests

<!end:3130>

## [3.11.0]

<!tag:3110>

### Changed

- i18n and l10n implementation

<!end:3110>

## [3.10.0]

<!tag:3100>

### Changed

- i18n and l10n implementation

<!end:3100>

## [3.8.0] - 2023-12-07

<!tag:380>

### Fixed

- Refactor of Template form for gluon portal
- Fortify and Sonar issues
- Version upgrades
- Import SQL script corrections for test databases

<!end:380>

## [3.7.1] - 2023-09-14

<!tag:371>

### Added

- Health Check custom configurations

<!end:371>

## [3.6.2] - 2023-08-18

<!tag:362>

### Changed

- Remove deprecated parameter `max-http-header-size` and replace with `max-http-request-header-size`and `tomcat.max-http-response-header-size`
- Remove deprecated parameter `spring.datasource.continue-on-error` and replace with `replace to sql.init.continue-on-error`
- Remove deprecated parameter `spring.datasource.platform` and replace with `replace to sql.init.platform`

### Fixed

- Translate archetype-resource Readme.md from portuguese to english.

<!end:362>

## [3.6.1] - 2023-07-17

<!tag:361>

### Added

- First version of gluon Arsenal Backend gRPC archetype

<!end:361>
