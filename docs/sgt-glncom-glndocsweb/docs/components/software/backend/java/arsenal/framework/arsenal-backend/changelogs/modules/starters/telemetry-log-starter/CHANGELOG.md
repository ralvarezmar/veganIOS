# Changelog

All notable changes to project `gln-back-arsenal-backend-telemetry-log-starter` will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [3.18.6]

<!tag:3186>

### Updated

- commons-beanutils due to vulnerability CVE-2025-48734

<!end:3186>

## [3.17.0]

<!tag:3170>

### Updated

- com.squareup.okhttp3:okhttp on SantanderDynatraceOtl due to vulnerability CVE-2021-0341

<!end:3170>

## [3.16.3]

<!tag:3163>

### Updated

- Updated logback version used on dependencies to use property defined on parent pom

<!end:3163>

## [3.16.2]

<!tag:3162>

### Fixed

- Update mina-core version due to vulnerability

<!end:3162>

## [3.16.0]

<!tag:3160>

### Fixed

- Correcting format of log messages in logback configuration

<!end:3160>

## [3.13.7]

<!tag:3137>

### Fixed

- Updating dependency SantanderDynatraceOtl version 2.4.2 and removing java-client to fix vulnerabilities

<!end:3137>

## [3.13.6]

<!tag:3136>

### Fixed

- Removing unused dependency commons-collections because of vulnerability

<!end:3136>

## [3.13.0]

<!tag:3130>

### Fixed

- Removing Janino conditions in logback configuration for native image compatibility

<!end:3130>

## [3.12.3]

<!tag:3123>

### Fixed

- Removing log messages when catch an error sending an event to dynatrace

<!end:3123>

## [3.12.0]

<!tag:3120>

### Fixed

- Fixed sonar issues

<!end:3120>

## [3.11.1]

<!tag:3111>

### Fixed

- Fix logging issues with logstash

### Removed

- gln-back-arsenal-backend-logback-plugin due to vulnerability issues in Sysdig.

<!end:3111>

## [3.9.4] - 2024-02-16

<!tag:394>

### Fixed

- Correcting vulnerability upgrading cucumber version
- Correcting vulnerability removing version of library xstream inherited from `io.cucumber.cucumber-testng` in SantanderDynatraceOtl
- Correcting vulnerability removing version of library jackson-databind inherited from logback plugin

<!end:394>
