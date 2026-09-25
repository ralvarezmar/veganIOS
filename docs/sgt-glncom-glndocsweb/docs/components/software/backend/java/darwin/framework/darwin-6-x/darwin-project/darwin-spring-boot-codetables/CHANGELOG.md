# Change Log

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.

<!end:420>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize dependencies.

- Remove unnecessary dependencies in starter and library.

- To improve traceability, the HttpClient wiretap can now be enabled from config.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

<!end:310>

## 3.0.3-RELEASE Version

<!tag:303>

- The way of creating a HttpClient has changed with the new version of reactor-netty.
  To maintain the back compatibility, HttpClient MaxConnections property is set to 500
  (default values is calculated according to the number processor).

<!end:303>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- `CodeTablesAccessor` beans marked with **@ConditionalOnMissingBean** so they can be overridden.

- Update the metadata files with all defined properties and those that have been deprecated.

- Reduce NotWeb configuration modes:

    - Replace NotWebWithHttpClient references with `NotWeb`.

    - Remove `httpClient` dependency (unused).

- Use `darwin-spring-boot-cache` dependency
  to compile instead of `darwin-spring-boot-starter-cache`,it is used only in test scope
  and is included in `darwin-spring-boot-starter-codetables`.

- Update CodeTablesConnector constructor to use a webClient with an already defined Url

- Use CIRCUIT\_BREAKER\_PREDICATE from Core ResiliencePredicates

- Using HttpClient instead of TcpClient in order to create connectors of the WebClient.

- Remove unnecessary WebClien.Builder clones.

- Performing warm-up for CodeTables HttpClient.

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor.

    - Using Mono.defer(supplier) into SwitchIfEmpty operator when a Mono.error(throwable) is defined. The target of this use is to avoid creating the exception during assembly time.

- Refactoring use of ReactiveDarwinContextHolder.

    - Using new mapNotNull(function) operator to simplify streams.

- BugFix for WebClient customization: now all WebClient properties can be configured without any binding with other properties.

- Translate Readme.adoc to english.

<!end:300>

## 2.11.0-RELEASE Version

<!tag:2110>

- We launch **Darwin Spring Boot Code Table** library **first version** with CodeTablesService for call Code Table service

<!end:2110>
