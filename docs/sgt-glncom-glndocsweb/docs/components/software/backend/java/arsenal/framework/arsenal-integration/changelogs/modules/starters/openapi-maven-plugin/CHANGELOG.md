# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.16.11] - 2025-10-23

<!tag:41611>

### Changed

- Rest DSL generation now explicitly disables inline routes using `inlineRoutes(false)` in Rest Configuration due to changes in Camel 4.5 version.

<!end:41611>

## [4.12.0] - 2024-06-05

<!tag:4120>

### Added

- Initial Arsenal OpenAPI Codegen Generator Maven Plugin implementation.

<!end:4120>

## [4.7.4] - 2023-09-14

<!tag:474>

### Added

- Default Actuator Configurations

<!end:474>

## [4.4.0] - 2023-07-03

<!tag:440>

### Updated

- renamed parameter errorGluonFormat to isGluon
- change generated openapi file with new observability fields

### Fixed

- Considering schemas definition using the first occurrence of allOf

<!end:440>

## [4.3.0] - 2023-06-23

<!tag:430>

### Added

- parameter errorGluonFormat that switch between the code that will handles the Exceptions.

### Fixed

- Code comments translated to english

<!end:430>

## [4.2.0] - 2023-06-16

<!tag:420>

### Added

- Log Technical error when a Exception is thrown

<!end:420>

## [4.1.0] - 2023-06-16

<!tag:410>

### Added

- Observability starter
- Annotation @AutoConfigureObservability to test template

<!end:410>

## [4.0.0] - 2023-05-15

<!tag:400>

### Added

- Adapt project to gluon standards and upgrade the version following the parent that receives the upgrade of the Apache Camel v4.0.0-M3

<!end:400>

## [3.7.6] - 2021-07-23

<!tag:376>

### Added

- Handling encrypted data in routes
- OAUTH token cryptographic context extraction
- Generation of new OAUTH token with cryptographic context data using Client Credentials

### Changed

- Generic error handling to return formatted data

### Fixed

- exception handling so that the flow is interrupted in case of error (.stop)

<!end:376>
