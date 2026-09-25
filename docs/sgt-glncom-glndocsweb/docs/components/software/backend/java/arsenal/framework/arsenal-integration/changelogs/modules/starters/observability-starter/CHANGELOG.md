# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [4.14.3]

<!tag:4143>

### Fixed

- Fixed names of headers to be used in the logs due to update in classes in arsenal-global-observability-starter.

<!end:4143>

### [4.14.0]

<!tag:4140>

### Added

- Adding new headers for observability, sessionId and businessId to be used in the logs.

<!end:4140>

### [4.13.0]

<!tag:4130>

### Updated

- Changing altair conector to not use JAB fwk

<!end:4130>

## [4.3.0] - 2023-07-03

<!tag:430>

### Updated

- Intercept route names
- Set isGluon value from property value instead of fixed true.

### Added

- new fields componentVersion e logVersion

<!end:430>

## [4.2.0] - 2023-07-03

<!tag:420>

### Updated

- Dependency arsenal-global-observability-starter to 3.3.0

<!end:420>

## [4.1.1] - 2023-06-26

<!tag:411>

### Fixed

- Cleans MDC fields after log to not mix data from one component with another that is been observed.

<!end:411>

## [4.1.0] - 2023-06-16

<!tag:410>

### Updated

- Dependency arsenal-global-observability-starter to 3.2.0

<!end:410>

## [4.0.0] - 2023-06-16

<!tag:400>

### Added

- First release at Gluon based on gln-back-arsenal-integration-parent:4.0.0 with Apache Camel 4.0.0-M3

<!end:400>
