# Darwin Spring Boot Extended Error ![4.3.3-RELEASE](https://img.shields.io/badge/4.3.3-RELEASE-FF073D)

![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Extended Error` library contains specific functionality for projects
that want to use the Extended error model with the Darwin Spring Boot framework.
This library adds extra support to a new error model
that replaces the Darwin error model in its exception handling and also implements in the error handling the call to the error translation service.

!!! warning

    Extended Error format is deprecated and will be removed in future versions.

!!! info "Important"

    For the use of this functionality, it is necessary to have deployed the `Error Translation service` of DBStack in the infrastructure.

## Functionality

### Error output format

This library overrides Darwin's default error model with the Extended error model,
by setting the `darwin.core.exceptions.error-format` property to `EXTENDED_ERROR`.
The default Extended error model format follows this schema, which can be expanded:

    {
        "errors": [
            {
                "code": "Integer",
                "description": "String",
                "level": "String",
                "message": "String"
            }
        ]
    }

This new error model constructs the error responses following the steps
indicated in the [Core library documentation](../darwin-spring-boot-core/README.md#replace-darwin-error-model) and according to the following:

    code -> errorModelAttributes.get("status")
    
    description -> errorModelAttributes.get("shortMessage")
    
    level -> "error"
    
    message -> "{timeStamp}-{errorModelAttributes.get("appName")}-{errorModelAttributes.get("errorName")}-{errorModelAttributes.get("detailedMessage")}"

In addition, the error model uses the `@CustomErrorModel` annotation,
which allows *customising any of these fields* using the [customisation from Darwin error property files](../darwin-spring-boot-core/README.md#customize-error-model-fields).

[Some examples of this customization](#library-use-cases) are shown below.

### Error translation service

The Extended Error Library offers a translation service to customize exceptions for both Darwin and Gluon error formats.

!!! info "Important"

    In order to enable error translation, and thus, to be able to call the translation service, the darwin.extended-error.translate.url property must be defined. For more information, please consult the section [Error translation
    configuration](#error-translation-configuration).

!!! note

    The error translation service's resilience can be configured through the use of CircuitBreaker and Retry patterns. For more information, please consult the sections [CircuitBreaker](#circuitbreaker) and [Retry](#retry).

!!! info "Important"

    Currently the call to the error translation service is resolved by a block() (not a valid solution for reactive environments, as it is not the purpose of this library).

## Installation

To use the library you have to include the library starter as a Maven dependency in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-extended-error</artifactId>
    </dependency>

In this way, the library automatically configures the Extended Error model, replacing Darwin's original one.

### Error translation configuration

<!tag:properties>

| Name                                                                | Default value | Required | Description                                                                                                                                                                                                                                                         | Supported values |
|---------------------------------------------------------------------|---------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| darwin.extended-error.errorTranslateUrl                             | N/A           | No       | Endpoint to error translation service.                                                                                                                                                                                                                              | Cadena           |
| darwin.extended-error.errorTranslateConnector.connectTimeout        | 5000          | No       | Defines the timeout (in milliseconds) to wait until a connection is established.                                                                                                                                                                                    | Number           |
| darwin.extended-error.errorTranslateConnector.maxConnections        | 500           | No       | ESets the maximum number of simultaneously open connections for a WebClient.Builder, This is accomplished by modifying the size of the connection pool associated with that WebClient.Builder.                                                                      | Number           |
| darwin.extended-error.errorTranslateConnector.pendingAcquireTimeout | 45000         | No       | Defines the timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by a WebClient.Builder.                                                                                                                                 | Number           |
| darwin.extended-error.errorTranslateConnector.readTimeout           | 5000          | No       | Defines the timeout (in milliseconds) to wait to get data over the established connection.                                                                                                                                                                          | Number           |
| darwin.extended-error.errorTranslateConnector.writeTimeout          | 5000          | No       | Defines the timeout (in milliseconds) to wait when writing data over the established connection.                                                                                                                                                                    | Number           |
| darwin.extended-error.errorTranslateConnector.wiretap               | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:[^1] `logging.level.reactor.netty.http.client=DEBUG` | Boolean          |

<!end:properties>

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## Library use cases

By installing this library, we are overriding Darwin's default error model with the Extended Error model.
Therefore, if we throw the same exception proposed at the beginning of [in this case from the Core
library](../darwin-spring-boot-core/README.md#darwin-exception-scheme), the JSON we would get would be the following:

    {
        "errors": [
            {
                "code": 400,
                "description": "Account doesn't exist",
                "level": "error",
                "message": "1513268058750-exceptions-demo-account_doesnot_exist-The requested account was not found, maybe the account doesn't exist or the user have no access to it."
            }
        ]
    }

We could also make use of Darwin's *channel-entity and language customisation*. For example, with these files:

- _errors.properties_

      account_doesnot_exist.description=Account service error
      account_doesnot_exist.message=The requested account doesn't exist in database
      
      INT.0049.account_doesnot_exist.message=The account doesn't exist

- _errors_es_ES.properties_

      account_doesnot_exist.description=Error en el servicio de cuentas
      account_doesnot_exist.message=La cuenta no existe en la base de datos

If the request had been made with the _locale_ (_Accept-Language_ header) "es-ES", the result would be as follows:

    {
        "errors": [
            {
                "code": 400,
                "description": "Error en el servicio de cuentas",
                "level": "error",
                "message": "La cuenta no existe en la base de datos"
            }
        ]
    }

Whereas,
if it had been done with another _locale_ but with the channel (header _X-Santander-Channel_) "INT" and the entity (header _organization_) "0049",
the response would have been:

    {
        "errors": [
            {
                "code": 400,
                "description": "Account service error",
                "level": "error",
                "message": "The account doesn't exist"
            }
        ]
    }

### Error Translation

Error translation can be applied for two possible scenarios:

- **Extended Error output format error translation**:

To apply the *Extended Error* output format, just add the starter 'darwin-spring-boot-starter-extended-error'
and the autoconfiguration will take care of raising the Bean that overwrites the original Darwin behaviour.

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-extended-error</artifactId>
    </dependency>

- **Error translation with another output format**:

To apply another output format, just add the starter 'darwin-spring-boot-starter-extended-error'
and set the `darwin.core.exceptions.error-format` to either `DARWIN` or `GLUON` in the `application.yaml`.

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-extended-error</artifactId>
    </dependency>

    darwin:
        core:
            exceptions:
                error-format: DARWIN | GLUON

### Error translation service connector

The `ErrorTranslateConnector` class is responsible for implementing the call to the translation service.
It makes use of Resilience4j for the implementation of Retry and CircuitBreaker when the call is made.

### How to set up CircuitBreaker and Retry for the error translation service call

For any environment, the Resilience4j CircuitBreaker and Retry is enabled,
in case you want to configure it, you have to take into account the following information.

The retry and circuit breaker instances configurable in the library are:

- **ErrorTranslateConnector:** Controls the call to the error translation service.

#### CircuitBreaker

The basic CircuitBreaker properties and their default values are as follows:

- **minimumNumberOfCalls:** The size of the buffer ring when the circuit is closed. The failure rate will not be calculated until this minimum number of calls is registered. The default value is ***100***.

- **permittedNumberOfCallsInHalfOpenState:** The size of the buffer ring when the circuit is half open.
  This ring is used when the circuit breaker transitions from open to half-open to assess the health of the circuit.
  Failure to exceed the fault rate after this number of calls will result in the circuit being closed.
  The default value is ***10***.

- **waitDurationInOpenState:** The time the circuit breaker must wait before transitioning from open to half open. The default value is ***60*** \[s\].

- **failureRateThreshold:** The failure rate threshold in percent, at which the circuit breaker will open the circuit and start shorting calls. The default value is ***50***.

- **recordFailurePredicate:** The predicate class that evaluates which exceptions should be used to open the circuit. By default, the loop will be opened with exceptions corresponding to an HTTP 5xx status of the called server.

If we want to change this configuration, the properties must be configured as follows:

    resilience4j.circuitbreaker:
      instances:
        errorTranslateConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 10
          waitDurationInOpenState: 60
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate

!!! note

    For more information about the operation or additional parameters of this CircuitBreaker, please refer to the product documentation: [Resilience4j CircuitBreaker](https://resilience4j.readme.io/docs/circuitbreaker).

#### Retry

The basic Retry properties and their default values are as follows:

- **retryExceptionPredicate:** The predicate class that evaluates which exceptions to retry and which not to retry. By default, exceptions corresponding to an HTTP 5xx status of the called server will be retried.

- **maxAttempts:** The maximum number of retries. By default, there will be three retries.

- **waitDuration:** A fixed timeout between retries. Default ***500*** \[ms\].

If we want to change these values, the properties must be configured as follows:

    resilience4j.retry:
      instances:
        errorTranslateConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500

!!! note

    For more information about the operation or additional parameters of this Retry, please refer to the product documentation: [Resilience4j Retry](https://resilience4j.readme.io/docs/retry).
