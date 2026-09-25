# Darwin Spring Boot Code Tables ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Code Tables` library exposes an API that allows the invocation of the code table service.
This service aims to present in a simple way a method for the validation and obtaining of the lists of values associated with a domain,
which is defined through a country code, channel, and language. These parameters will be obtained from the application configuration and its execution domain.

For more information on the code table service, you can consult the documentation on its [design](https://confluence.alm.europe.cloudcenter.corp/pages/viewpage.action?pageId=50593876) and the [service user guide](https://confluence.alm.europe.cloudcenter.corp/display/COMM/Microservice+Guide+Code+Tables).

!!! info "Important"

    For the use of this functionality, it is necessary to have deployed the `Code Tables service` of DBStack in the infrastructure.

## Functionality

`Darwin Spring Boot` auto-configuration will detect the type of application it is running in,
autoconfiguring only those functionalities that apply to that environment.

Visit the [Application Type section](../../ABOUT.md#darwin-flavours)
to get more info about how to work the application type detection.

!!! note

    Both the supported functionality and the use of the library will be equivalent in both Web (Servlet / Reactive) and non-web implementations, so it will be integrated automatically for projects.

### Invoke the Code Tables service

A `Bean` that implements the `CodeTablesService` interface is configured and exposed. It provides a series of methods that allow access to each endpoint of the Code Tables service in a simple way.

### Cache

REST calls to the code table service are stored if the application has a cache enabled and configured.

In this way, the response to requests to the service is streamlined, avoiding repeating a REST call twice with the same input parameters.

To store the responses from the codetable service, the following **cachenames** is used:

- codeTables

It is important to configure such caches in the cache service that the application uses.

## Installation

To use the library, you must include the library's starter as a Maven dependency in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-codetables</artifactId>
    </dependency>

In this way, the library is configured automatically.

### Configuration

<!tag:properties>

| Name                                               | Default value | Mand. | Description                                                                                                                                                                                                                                                         | type    |
|----------------------------------------------------|---------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| darwin.code-tables.url                             | N/A           | Yes   | Path to Code Tables service.                                                                                                                                                                                                                                        | String  |
| darwin.code-tables.webClient.connectTimeout        | 5000          | No    | Defines the timeout (in milliseconds) to wait until a connection is established.                                                                                                                                                                                    | Number  |
| darwin.code-tables.webClient.maxConnections        | 500           | No    | Sets the maximum number of connections open simultaneously for a WebClient.Builder, This is achieved by modifying the size of the connection pool associated with said WebClient.Builder.                                                                           | Number  |
| darwin.code-tables.webClient.pendingAcquireTimeout | 45000         | No    | Defines the timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by a WebClient.Builder.                                                                                                                                 | Number  |
| darwin.code-tables.webClient.readTimeout           | 5000          | No    | Defines the timeout (in milliseconds) to wait to get data through the established connection.                                                                                                                                                                       | Number  |
| darwin.code-tables.webClient.writeTimeout          | 5000          | No    | Defines the timeout (in milliseconds) to wait when writing data over the established connection.                                                                                                                                                                    | Number  |
| darwin.code-tables.webClient.wiretap               | false         | No    | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:[^3] `logging.level.reactor.netty.http.client=DEBUG` | Boolean |

<!end:properties>

### Basic configuration

The most basic configuration of the Code Tables module sets the definition of the url of the Code Tables service.

These properties can be configured directly in the `application.yml`, but to have an **environment-dependent configuration** it is recommended to use variables defined in the `application-{environment}.properties` generated for each environment, so
that the configuration file is unique:

#### application.yml

    darwin:
      code-tables:
        url: ${env.code-tables-endpoint}

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## Exposed API

| Name                                                                                                          | Type                                                                                                                      | Description                                                                          |
|---------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| [CodeTablesReactiveService](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/service/CodeTablesReactiveService.html)                | [CodeTablesService&lt;CodeTable, Boolean&gt;](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/service/CodeTablesService.html)                  | Service that exposes the API for Code Tables service use in `reactive` environments. |
| [CodeTablesServletService](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/service/CodeTablesServletService.html)                  | [CodeTablesService&lt;CodeTable, Boolean&gt;](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/service/CodeTablesService.html)                  | Service that exposes the API for Code Tables service use in `servlet` environments.  |
| [FallbackCodeTablesConnector](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/accessor/connector/FallbackCodeTablesConnector.html) | [FallbackCodeTablesConnector&lt;T, R&gt;](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/accessor/connector/FallbackCodeTablesConnector.html) | Interface that defines the fallback methods that are used by the connector.          |
| [CodeTable](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/domain/CodeTable.html)                                                 | [CodeTable](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/codetables/domain/CodeTable.html)                                                             | POJO that represents a Code Table element.                                           |

## Use cases

### How to invoke the Code Tables service in reactive environments

When the library is added to an application that constitutes a non-blocking execution environment, both web and non-web, the autoconfiguration exposes a `Bean` of type `CodeTablesReactiveService`. This service provides a series of methods for
interacting with the Code Tables service:

An example of use would be the following:

    import com.santander.darwin.codetables.domain.CodeTable;
    import org.springframework.stereotype.Service;

    @Service
    public class CodeTablesReactiveService {

        private final CodeTablesReactiveService codeTablesService;

        public CodeTablesReactiveServiceTest(CodeTablesReactiveService codeTablesService) {
            this.codeTablesService = codeTablesService;
        }

        public Mono<List<CodeTable>> getListCodeTable() {
            return this.codeTablesService.getList();
        }

        public Mono<Boolean> getValidateCodeTable(String param, String code) {
            return this.codeTablesService.validateCode(param, code);
        }

        public Mono<CodeTable> getCodeTable(String param, String code) {
            return this.codeTablesService.getLiteral(param, code);
        }

        public Mono<List<CodeTable>> getCodeTableByParam(String param) {
            return this.codeTablesService.getListByParam(param);
        }
    }

### How to invoke the Code Tables service in servlet environments

When the library is added to an application that constitutes a blocking execution environment, both web and non-web, the autoconfiguration exposes a `Bean` of type `CodeTablesServletService`. This service provides a series of methods for interacting
with the Code Tables service:

An example of use would be the following:

    import com.santander.darwin.codetables.domain.CodeTable;
    import org.springframework.stereotype.Service;

    @Service
    public class CodeTablesServletService {

        private final CodeTablesServletService codeTablesService;

        public CodeTablesServletServiceTest(CodeTablesServletService codeTablesService) {
            this.codeTablesService = codeTablesService;
        }

        public List<CodeTable> getListCodeTable() {
            return this.codeTablesService.getList();
        }

        public Boolean getValidateCodeTable(String param, String code) {
            return this.codeTablesService.validateCode(param, code);
        }

        public CodeTable getCodeTable(String param, String code) {
            return this.codeTablesService.getLiteral(param, code);
        }

        public List<CodeTable> getCodeTableByParam(String param) {
            return this.codeTablesService.getListByParam(param);
        }
    }

### How to define a custom fallback for service calls

The library creates and configures a connector to communicate with the Code Tables service. Said connector implements both the Circuit Breaker and Retry resilience patterns and, therefore, establishes a fallback method for each of the interactions
with the service. For the fallback implementation, the `FallbackCodeTablesConnector<T, R>` interface is set, which defines the fallback methods that are used by the connector. Conditionally on the non-existence of another implementation, the
configuration creates a `Bean` that contains an instance of the default fallback class, which implements each of the methods in a simple way: it adds an error trace with the exception that has occurred and returns an empty `Mono`.

To create a custom fallback class and set it as the default connector implementation, it would be as simple as the following example shows:

    import com.santander.darwin.codetables.domain.CodeTable;
    import java.util.Collections;
    import lombok.extern.slf4j.Slf4j;
    import reactor.core.publisher.Mono;

    import java.util.List;
    import java.util.function.Function;

    @Slf4j
    public class CustomFallbackCodeTables implements FallbackCodeTablesConnector<CodeTable, Boolean> {

        @Override
        public Function<Throwable, Mono<CodeTable>> applyLiteral(String param, String code) {
            return (Throwable throwable) -> {
                log.error("CustomCodeTablesFallback - exception message: {}",
                        throwable.getMessage());
                return Mono.empty();
            };
        }

        @Override
        public Function<Throwable, Mono<List<CodeTable>>> applyLiterals() {
            return (Throwable throwable) -> {
                log.error("CustomCodeTablesFallback - exception message: {}",
                        throwable.getMessage());
                return Mono.just(Collections.emptyList());
            };
        }

        @Override
        public Function<Throwable, Mono<List<CodeTable>>> applyLiteralsByParam(String param) {
            return (Throwable throwable) -> {
                log.error("CustomCodeTablesFallback - exception message: {}",
                        throwable.getMessage());
                return Mono.just(Collections.emptyList());
            };
        }

        @Override
        public Function<Throwable, Mono<Boolean>> applyValidation(String param, String code) {
            return (Throwable throwable) -> {
                log.error("CustomCodeTablesFallback - exception message: {}",
                        throwable.getMessage());
                return Mono.just(Boolean.FALSE);
            };
        }
    }

!!! note

    In case the default implementation of the `DefaultFallbackCodeTables` class covered part of the requirements of an application, it would be possible to extend it and only overwrite those methods that were necessary.

The creation of the new `Bean` that implements the custom fallback class is added to the configuration class.

    import com.santander.darwin.codetables.domain.CodeTable;
    import org.springframework.boot.autoconfigure.AutoConfigureBefore;
    import org.springframework.context.annotation.Configuration;

    @Configuration(proxyBeanMethods = false)
    @AutoConfigureBefore(CodeTablesAutoConfig.class)
    public class LocalConfiguration {

        @Bean
        public FallbackCodeTablesConnector<CodeTable, Boolean> customFallbackCodeTables(){
            return new CustomFallbackCodeTables();
        }
    }

### How to configure the CircuitBreaker and Retry for the Code Tables service call

Resilience4j CircuitBreaker and Retry are enabled for any environment. In case it is necessary to change any of the default values, the following information must be taken into account.

The instances of retry and circuit breaker configurable in the library are:

- **codeTablesConnector:** Control calls to the Code Tables service.

#### CircuitBreaker

The basic properties of the CircuitBreaker and their default values are as follows:

- **minimumNumberOfCalls:** The size of the buffer ring when the circuit is closed. The failure rate will not be calculated until this minimum number of calls are registered. The default value is ***100***.

- **permittedNumberOfCallsInHalfOpenState:** The size of the buffer ring when the circuit is half open. This ring is used when the circuit breaker transitions from open to half open to evaluate the health of the circuit. If the failure rate is not
    exceeded, once this number of calls have been made, the circuit will be closed. The default value is ***10***.

- **waitDurationInOpenState:** The time the circuit breaker must wait before going from open to half open. The default value is ***60*** \[s\].

- **failureRateThreshold:** The threshold of the failure rate in percentage, after which the circuit breaker will open the circuit and begin to short-circuit calls. The default value is ***50***.

- **recordFailurePredicate** The predicate class that evaluates which exceptions should be used to open the circuit. By default, the circuit will be opened with the exceptions that correspond to an HTTP 5xx status of the server that is called.

If we want to change this configuration, the properties must be configured as follows:

    resilience4j.circuitbreaker:
      instances:
        codeTablesConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 10
          waitDurationInOpenState: 60
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate

!!! note

    For more information about the operation or additional parameters of this CircuitBreaker, we can consult the product documentation at: [Resilience4j CircuitBreaker](https://resilience4j.readme.io/docs/circuitbreaker)

#### Retry

The basic properties of Retry and their default values are the following:

- **retryExceptionPredicate:** The predicate class that evaluates which exceptions should and should not be retried. By default, exceptions that correspond to an HTTP 5xx status of the called server will be retried.

- **maxAttempts:** The maximum number of retries. By default there will be 3 retries.

- **waitDuration:** A fixed wait time between retries. By default ***500*** \[ms\].

If we want to change these values, the properties must be configured as follows:

    resilience4j.retry:
      instances:
        codeTablesConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500

!!! note

    For more information about the operation or additional parameters of this Retry, we can consult the product documentation at: [Resilience4j Retry](https://resilience4j.readme.io/docs/retry)
