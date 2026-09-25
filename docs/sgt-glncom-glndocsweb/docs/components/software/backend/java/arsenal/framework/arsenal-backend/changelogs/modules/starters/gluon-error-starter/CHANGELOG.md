# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.18.2]

<!tag:3182>

### Added

- Added exception handler for Resilience4j

- BulkheadFullException
- CallNotPermittedException
- IllegalStateTransitionException
- ResultRecordedAsFailureException
- RequestNotPermitted
- MaxRetriesExceededException
- TimeoutException

<!end:3182>

## [3.17.1]

<!tag:3171>

### Added

- Added exception handler for CompletionException

<!end:3171>

## [3.12.0]

<!tag:3120>

### Changed

- Removed unnecessary bean creation

### Fixed

- Fixed constraint violation exception handling
- Fixed sonar issues

<!end:3120>

## [3.11.0]

<!tag:3110>

### Changed

- ChannelHolder and EntityHolder to i18n/l10n
- i18n implementation
- Updated i18n documentation

<!end:3110>

## [3.10.0]

<!tag:3100>

### Changed

- i18n and l10n implementation

<!end:3100>

## [3.1.0] - 2023-06-26

<!tag:310>

### Fixed

- Correcting duplicate beans problem in ArsenalDefaultExceptionHandler

<!end:310>

## [3.0.0] - 2023-06-22

<!tag:300>

### Added

- First version of gluon error starter

<!end:300>
