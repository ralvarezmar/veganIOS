# Change Log

## Version 4.3.1-RELEASE

<!tag:431>

- Expose all created `TrxOpService` as beans.

<!end:431>

## Version 4.3.0-RELEASE

<!tag:430>

- Now, `activateLocalDateResponse` property in the Darwin properties of Partenon is being transferred correctly to the created object.

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.

<!end:420>

## 4.0.0-RELEASE Version

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.2.3-RELEASE Version

<!tag:323>

- Add new headers to partenon (if there are availables): appInit & general channel

<!end:323>

## 3.2.0-RELEASE Version

<!tag:320>

- Remove unnecessary dependencies in starter and library. Make the brave dependency optional.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Change PartenonAutoConfigTest to avoid slow initial protocol testing.

<!end:310>

## 3.0.4-RELEASE Version

<!tag:304>

- Setting JWT token with TokenService in PartenonAction when execution mode is configured for using TOKEN\_JWT\_GENERIC\_USER or TOKEN\_JWT\_LOGGED\_USER.

- Adding **lombok (provide) dependency** to avoid compile error with new version of Partenon

- Fix TrxOpService bean creation for autowired injection

<!end:304>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Remove Darwin Common dependency and use Darwin Core with compile scope.

- Update the metadata files with all defined properties and those that have been deprecated.

- Update PartenonConnectSwitchReactive with new reactive TokenService (prev. ReactiveTokenConverter)

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor for tests.

- Translate Readme.adoc to english.

- Put TOKEN1 and TOKEN2 headers in PartenonAction with Sleuth TracerContext' traceId and spanId

<!end:300>

## 2.11.0-RELEASE Version

<!tag:2110>

- Use PartenonConnect physicalChannel property if it's configured instead of ContactPoint value.

- Reactive applications with any JWT `executionMode`, now retrieve token JWT from Spring SecurityContext.

- Now `darwin-spring-boot-authentication` library is included here and Darwin Partenon starter also includes `darwin-spring-boot-starter-authentication`.

- New Partenon Connector analysis section and new token propagation for MPS use case in README.

<!end:2110>

## 2.10.1-RELEASE Version

<!tag:2101>

- Fix bug. Remove "connectors:" property from partenon connectors config at document.

<!end:2101>

## 2.9.0-RELEASE Version

<!tag:290>

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

<!end:290>

## 2.8.0-RELEASE Version

<!tag:280>

- We release **darwin-spring-boot-partenon** library **first version**, with the following functionality:

    - To be able to configure several Partenon connectors according to the channel.

    - Use connectors in Servlet environments through the **PartenonConnectOperations** interface (with **PartenonConnectSwitch** implementation).

    - Use connectors in Reactive environments through the **PartenonConnectOperationsReactive** interface (with **PartenonConnectSwitchReactive** implementation).

    - Add headers with default values in PartenonAction objects of the transactions.

<!end:280>
