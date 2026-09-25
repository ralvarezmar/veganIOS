# Change Log

## Version 6.1.2-RELEASE

<!tag:612>

### 🐞 Bug Fixes

- Fixed error `java.lang.IllegalArgumentException: Could not find class [com.santander.darwin.security.authorization.config.AuthorizationAutoConfig]` using `darwin-spring-boot-test`.

<!end:612>

## Version 6.1.1-RELEASE

<!tag:611>

### 🐞 Bug Fixes

- If we are using ´spring-boot:test-run´ with `darwin-spring-boot-test` dependency you cannot use a token valid for the pkm that is already configured. We fix that and also add a valid fixed token `MOCK.TOKEN` with test purposes.

<!end:611>

## Version 6.0.0-RELEASE

<!tag:600>

- Added `@AutoConfigureDarwinLogging` annotation to slice testing using the Darwin Logging Configuration.

<!end:600>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.
- Add support for working with log4j necessary for native image.
- Add custom claim functionality to TokenUtils.

<!end:420>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.1.0-RELEASE Version

<!tag:310>

- Change Token generator class implementations because upgrade nimbus dependency

- Adding new methods in JocTokenGenerator, JocTokenUtil, OCJwtTokenGenerator, and TokenUtils in order to create authorization tokens allowing to customize more fields.

<!end:310>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- **Remove uses of @Primary** in mock beans creation, those original beans now are @ConditionalOnMissingBean.

- Authentication, Authorization, CodeTables and Metrics TestAutoConfigs now are **loaded from starter' *spring.factories***.

- Update the metadata files with all defined properties and those that have been deprecated.

- Update Authentication mocks after unify STS connectors/service:
  use common MockSTSService

- Update Authentication mocks after unify PKM connectors: common MockPKMService

- Update Authorization mocks after replace Resilience4j annotations

- Update Authorization (COConnector) mocks to use AuthenticationBearerToken and Token objects in Servlet applications

- Using new API of Reactor.

    - Using new mapNotNull(function) operator to simplify streams.

- Deleting vulnerabilities: Refactor the security properties that allow to improve user properties readability

- Translate Readme.adoc to english.

<!end:300>

## 2.11.0-RELEASE Version

<!tag:2110>

- Unifying MockMultiEntityCOCConnector and MockMultiEntityCONConnector into a single connector.
  MultiEntity logic has been simplified to use a single Control Operative Service.

- First release of Darwin Spring Boot Test library:

    - Include new Functional, Security and Metrics console appenders.

    - Replace Darwin components to mock requests to PKM and STS services.

    - Replace Darwin components to mock requests to OC services.

    - Replace Darwin components to mock requests to CodeTables service.

    - Configurable pattern (*console/json*) for technical console logs.

<!end:2110>
