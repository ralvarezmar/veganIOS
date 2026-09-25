# Changelog

All notable changes to project `arsenal-backend-embeddedcrypto` will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [3.13.1]

<!tag:3131>

### Fixed

- Handled Jwt claims as Map, instead of String. This change of behavior in spring security was caused by a dependency upgrade from the com.nimbusds:nimbus-jose-jwt library.
  The JSON parser has been changed from json-smart to GSON.

### Removed

- Duplicated dependency mockito-junit-jupiter

<!end:3131>

## [3.12.0]

<!tag:3120>

### Fixed

- Fixed sonar issues

<!end:3120>

## [3.11.2]

<!tag:3112>

### Fixed

- Fixed embedded crypto enabling configuration

<!end:3112>

## [3.11.1]

<!tag:3111>

### Fixed

- Fixed null pointer when encrypting empty or null object

<!end:3111>

## [3.11.0]

<!tag:3110>

### Fixed

- Fixed thread safe behaviour

<!end:3110>

## [3.10.0]

<!tag:3100>

### Added

- Feature to get encrypted object from jwt

<!end:3100>
