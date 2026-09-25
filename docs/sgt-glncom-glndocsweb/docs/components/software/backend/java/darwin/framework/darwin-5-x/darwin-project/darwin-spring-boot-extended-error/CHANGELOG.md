# Change Log

## Version 5.0.0

<!tag:500>

- Fix error when use Gluon error and extended-error dependency.

<!end:500>

## Version 4.3.2

<!tag:432>

- *Backport from 5.0.0*. Fix error when use Gluon error and extended-error dependency.
- Fix error when use Darwin error and extended-error starter dependency.

<!end:432>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:410>

- Recovered the Extended Error Model. This format is marked as deprecated

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Moved Extended Error Model to Core and renamed to Gluon Error Model

<!end:327>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize dependencies.

- To improve traceability, the HttpClient wiretap can now be enabled from config.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- `ErrorModelExtendedError` implements `GraphQLErrorModel` to be compatible with GraphQL errors.

- Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

<!end:310>

## 3.0.4-RELEASE Version

<!tag:304>

- Fix error property checked for ErrorTranslate service when Darwin ErrorModel is used (now we check "shortMessage").

<!end:304>

## 3.0.3-RELEASE Version

<!tag:303>

- The way of creating a HttpClient has changed with the new version of reactor-netty.
  To maintain the back compatibility, HttpClient MaxConnections property is set to 500
  (default values is calculated according to the number processor).

<!end:303>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Translate Readme.adoc to english.

- Removed deprecate method "**buildFromException**" in favor of "**buildErrorModel**".

- Replaced the current annotation configuration by *Resilience4j API*.

- Update the metadata files with all defined properties and those that have been deprecated.

- Reduce NotWeb configuration modes: **remove httpClient (unused) and spring-web** dependencies as they always come from Darwin Core.

- Dependencies and plugins upgrade:

    - `ConfigFileApplicationContextInitializer` is deprecated. Instead, `ConfigDataApplicationContextInitializer` is used.

- Use CIRCUIT\_BREAKER\_PREDICATE from Core ResiliencePredicates

- Using HttpClient instead of TcpClient to create connectors of the WebClient.
  In addition, `maxLifeTime`
  WebClient property is added to ErrorTranslate connector properties and configured to be used.

- Remove unnecessary WebClient.Builder clones.

- Performing warm-up for ErrorTranslate HttpClient.

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor.

    - Using Mono.defer(supplier) into SwitchIfEmpty operator when a Mono.error(throwable) is defined. The target of this use is to avoid creating the exception during assembly time.

- BugFix for WebClient customization: now all WebClient properties can be configured without any binding with other properties.

<!end:300>

## 2.10.3-RELEASE Version

<!tag:2103>

- Changing translate message field. Adapted to Darwin format and extendedError format.

<!end:2103>

## 2.10.0-RELEASE Version

<!tag:2100>

- Override new "**buildErrorModel**" method in `ErrorModelExtendedError` to build error model using generic map
  and mark old "**buildFromException**" method as ***@Deprecated***.

- Created `ExtendedErrorErrorsPropertiesAccessor` class to implement "**error translate**" functionality. This class, extends from core class `DarwinErrorsPropertiesAccessor`.

- Created `ErrorTranslateConnector` class to call Error Translate service.

- New config class added to configure Error Translate (`ErrorTranslateAutoConfig` and `ExtendedErrorProperties`).

- The module has been renamed to `darwin-spring-boot-extended-error`.

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- We launch **Darwin Spring Boot LeanCore** library **first version** with `ErrorModelExtendedError` for Darwin exceptions management.

<!end:290>
