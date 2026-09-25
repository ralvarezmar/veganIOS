# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.16.11] - 2025-10-23

<!tag:41611>

### Changed

- Rest DSL configuration file now explicitly disables inline routes using `inlineRoutes(false)` due to changes in Camel 4.5 version.

<!end:41611>

## [4.14.2]

<!tag:4142>

### Fixed

- Fixing sonar issue for generated application not using fields in tests

<!end:4142>

## [4.14.1]

<!tag:4141>

### Fixed

- Fixing openapi contract security configuration for the archetype generation

<!end:4141>

## [4.14.0]

<!tag:4140>

### Updated

- Updating archunit to new repository project version

### Added

- Adding flag isSecurityEnabled that generate security configurations for application

<!end:4140>

## [4.13.2]

<!tag:4132>

### Added

- Adding global security to open api yaml contract example

<!end:4132>

## [4.13.0]

<!tag:4130>

### Added

- Adding native compilation profiles

<!end:4130>

## [4.9.0] - 2023-12-18

<!tag:490>

### Added

- Adding Arch Unit core and plugin

<!end:490>

## [4.7.4] - 2023-09-14

<!tag:474>

### Added

- Default Actuator Configurations

<!end:474>

## [4.7.3] - 2023-09-04

<!tag:473>

### Updated

- Update to Camel 4.0
- Fix dependencies inclusion of project generated

<!end:473>

## [4.7.0] - 2023-07-03

<!tag:470>

### Updated

- Added new fields related to observability
- Dependency gln-back-arsenal-integration-openapi-maven-plugin to 4.4.0
- Dependency gln-back-arsenal-integration-observability-starter to 4.2.0

<!end:470>

## [4.4.0] - 2023-06-16

<!tag:440>

### Updated

- Dependency gln-back-arsenal-integration-openapi-maven-plugin to 4.2.0

<!end:440>

## [4.3.0] - 2023-06-16

<!tag:430>

### Added

- Observability dependency gln-back-arsenal-integration-observability-starter
- @AutoConfigureObservability annotation in test templates
- Observability parameters at application.yml

### Updated

- Dependency gln-back-arsenal-integration-openapi-maven-plugin to 4.1.0

<!end:430>

## [4.0.0] - 2023-05-16

<!tag:400>

### Added

- First release at Gluon based on gln-back-arsenal-integration-parent:4.0.0 with Apache Camel 4.0.0-M3

<!end:400>
