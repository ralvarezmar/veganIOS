
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html)

## **Release 4.3.0** - 29-09-2025

### Common Features

**End of support for Node.js 18.x. The minimum supported version is now Node.js 20.x, ensuring compatibility with the latest features and security updates.**
**Migration to Nodejs v22 in all libraries.**

### Logger Library

#### [4.3.0] - 18-09-2025

#### Removed

- Unused FORTIFY_PROJECT variable from properties.env

### Error Handler Library

#### [4.3.0] - 19-09-2025

#### Updated

- Fastify dependency to v5.6.x

#### Removed

- Unused FORTIFY_PROJECT variable from properties.env

### Middleware Library

#### [4.3.0] - 24-09-2025

#### Removed

- Unused FORTIFY_PROJECT variable from properties.env

### Security Library

#### [4.3.0] - 25-09-2025

#### Updated

- Fastify dependency to v5.6.x

#### Removed

- Unused FORTIFY_PROJECT variable from properties.env

### Apollo Server Plugins

#### [4.3.0] - 25-09-2025

#### Removed

- Unused FORTIFY_PROJECT variable from properties.env

### Composer Library

#### [4.3.1] - 03-10-2025

#### Bugfix

- Updated @fastify/swagger-ui to v5
- Updated @fastify/swagger to v9
- Updated @fastify/formbody to v8

## **Release 4.2.0** - 29-01-2025

### Common Features

**End of support for Node.js 16.x. The minimum supported version is now Node.js 18.x, ensuring compatibility with the latest features and security updates.**
**Migration to Nodejs v20 in all libraries.**

### Security Library

#### [4.2.0] - 21-01-2025

##### Fixed

- Fix [CVE-2024-45296](https://nvd.nist.gov/vuln/detail/CVE-2024-45296)

### Middlewares Library

#### [4.2.0] - 22-01-2025

##### Added

- Added Thundera observability headers businessid and sessionid into customLog logging, tracing and propagation.

### Logger Library

#### [4.2.0] - 21-01-2025

### Added

- sessionReference and businessReference to default customLog.
- DARWIN_LOGGING_KAFKA_ACTIVITY_TOPIC environment variable.
- DARWIN_LOGGING_KAFKA_TECHNICAL_TOPIC environment variable.
- DARWIN_LOGGING_KAFKA_FUNCTIONAL_TOPIC environment variable.

### Error Handler Library

#### [4.2.0] - 21-01-2025

##### Bugfix

- Fix vulnerabilities [CVE-2024-38998](https://nvd.nist.gov/vuln/detail/CVE-2024-38998)

## **Release 4.1.2** - 09-11-2024

### Apollo Server Plugins

#### [4.1.0] - 16-09-2024

#### Added

- `core.config.js` for i18n check.
- Integrated i18n to Apollo `context`.

#### Bugfix

- Npm audit

### Darwin Composer

#### [4.1.1] - 18-09-2024

#### Added

- All framework environment variables table in readme

#### Removed

- Enable/disable i18n through parameter.

### Error Handler

#### [4.1.0] - 16-06-2024

#### Bugfix

- Npm audit

### Logger

#### [4.1.0] - 11-09-2024

#### Removed

- Environment variable 'DARWIN_LOGGING_KERBEROS_AUTHENTICATION'
- Default values for 'DARWIN_LOGGING_KAFKA_HOST'
- Debug library added as a dependency.

#### Changed

- Kerberos authentication always enabled when transport mode is kafka
- Environment variable from 'DARWIN_LOGGER_KAFKA_HOST' to 'DARWIN_LOGGING_KAFKA_HOST'

#### BugFix

- 'DARWIN_LOGGING_KAFKA_HOST' correctly accepts various hosts.
- Npm audit
- Prettier-Eslint now ignores package.json and package-lock.json

### Middlewares

#### [4.1.0] - 16-09-2024

#### Added

- Internationalization middleware support for Fastify and GraphQL microservice.

#### Fix

- Fix Sonar issues
- Npm audit

### Relay Cursor Connections Library

#### [3.0.1] - 23-05-2023

#### Changed

- Update dependences
- Remove proxy from `package.json`

### Security

#### [4.1.0] - 19-06-2024

#### Bugfix

- Npm audit
