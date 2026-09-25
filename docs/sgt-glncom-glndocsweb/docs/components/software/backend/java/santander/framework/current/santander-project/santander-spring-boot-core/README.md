# Santander Spring Boot Core ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Santander Spring Boot Core` library is in charge of initializing and configuring common components that can be
reused both by the rest of the Santander Spring Boot libraries and by the projects themselves.

!!! info "Important"

    All the `starters` of the architecture transitively incorporate this dependency, so except in exceptional cases it will not be necessary to add it explicitly to the `pom` of the project.

## Features

`Santander Spring Boot` auto-configuration will detect the type of application it is running in,
autoconfiguring only those functionalities that apply to that environment.

Visit the [Santander Spring Boot Flavours section](../../ABOUT.md#santander-spring-boot-flavours)
to get more info about how to work the application type detection.

The `Santander Spring Boot Core` library provides the following functionalities depending on the application topology:

### NotWeb application

#### ObjectMapper

- A `Bean` of the `ObjectMapper` class from the `JSON` "Jackson" treatment library and designed to work in a "thread-safe" way, which allows a single instance of this class to serve an entire application. This is provided directly from Sprint.

!!! warning

    For backward compatibility reasons Santander Spring Boot Spring Framework also provides an `ObjectMapper` bean. This bean is accessible using the @SantanderQualifier annotation. This bean is deprecated and may be removed in the future so we
    recommend using the one provided by Spring.

#### DefaultAsyncConfigurer and santanderAsyncExecutor

- To use it, just set the `santander.core.async.enabled` variable to true.

    - A `ThreadPoolTaskExecutor` named `asyncExecutor` to be used for both `@Async` marked methods and asynchronous web requests.

    - A `Bean` of type `DefaultAsyncConfigurer` that provides an `AsyncUncaughtExceptionHandler` for handling uncaught exceptions thrown from asynchronous methods.

#### Task Decorator

- By default, a `TaskDecorator` is created and used for the creation of `Threads` with pools that support it (for example the one created by Santander Spring Boot if
    `santander.core.async.enabled` is configured or the one created by default by Spring to handle
    asynchronous web requests).

    This decorator is in charge of progressing all the contexts managed by `ContextRegistry` from `io.micrometer.context-propagation` library. For example the Santander Spring Boot context is registered automatically.

    This bean is only created if there is no `TaskDecorator` available. Therefore, if the application wishes, you can create your own custom `TaskDecorator`.

#### Exceptions Santander Spring Boot

- An abstract class `SantanderException` is defined from which all exceptions generated with the Santander Spring Boot framework will inherit.

    - A `GenericException` class extends it, defining the [Santander Spring Boot exception scheme](#exception-scheme) of a Santander Spring Boot exception.

#### Health Checks

- `Health checks` type `HTTP` endpoints are exposed for `NotWeb` type applications. `Santander Spring Boot` makes use of the `Spring Boot Actuator`
    to generate the endpoints that allow applications to check the status of the application. These endpoints are
    exposed via `HTTP` or via `JMX`. As in `NotWeb` type applications we do not have an `HTTP` server, we do not have the possibility of publishing said endpoints to consume them through this protocol, therefore a functionality has been implemented
    that starts a lightweight `HTTP` server with the sole objective of continuing to consume These endpoints in `NotWeb` type applications as if it were a `Web` application, this allows us to establish the same `kubernetes probes` configuration
    regardless of the type of application.

    - A Bean of type `HttpServer` is defined with name `healthCheckHttpServer` in charge of configuring a `Http` server (by default `localhost` and port 8080). This Bean is annotated with `@ConditionalOnMissingBean(name="healthCheckHttpServer")`.
        The default implementation is limited to configuring an `HttpServer` on the port specified by the `management.server.port` property, or port 8080 if it is not defined and defines the actuator routes that will be implemented by the Handlers.
        It is important to note that it is not necessary to overwrite this Bean to customize the behavior of the Health Checks.

    - A `Bean` of type `HttpHandler` is defined with name `healthCheckLivenessHttpHandler` in charge of managing the requests made to the `/ actuator / health / liveness` endpoint. This `Handler` is injected into the previously mentioned
        `HttpServer` server. The default implementation of this `Bean` is based on [Spring Boot Actuator lifecycle](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator.endpoints.kubernetes-probes.lifecycle) and the
        management of states that indicate the state of the application, so that if the status is `CORRECT`, an http code with value 200 and message `{"status": "UP"}` is returned, otherwise a code 503 is returned and message `{"status": "DOWN"}`.
        This `Bean` is annotated with `@ConditionalOnMissingBean(name="livenessHttpHandler")`.
        The default implementation provided by `Santander Spring Boot` generates the response based on the state provided by `actuator` for `liveness`. To add new checks it is
        not necessary to overwrite this bean, but to add `Health Indicators` following the specifications of [Spring Boot
        Actuator](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator.endpoints.kubernetes-probes.external-state).

    - A `Bean` of type `HttpHandler` is defined with name `healthCheckReadinessHttpHandler` in charge of managing the requests made to the `/ actuator / health / readiness` endpoint. This `Handler` is injected into the previously mentioned
        `HttpServer` server. The default implementation of this `Bean` is based on [Spring Boot Actuator lifecycle](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator.endpoints.kubernetes-probes.lifecycle) and the
        management of states that indicate the state of the application, so that if the status is `ACCEPTING_TRAFFIC`, an http code with value 200 is returned and the message `{"status": "UP"}`, otherwise a 503 code is returned and the message
        `{"status": "DOWN"}`. This `Bean` is annotated with `@ConditionalOnMissingBean(name="readinessHttpHandler")`,
        allowing projects to modify the default implementation. The default implementation provided by `Santander Spring Boot` generates the response
        based on the state provided by `actuator` for `readiness`. To add new checks it is not necessary to overwrite this bean, but to add `Health Indicators` following the specifications of [Spring Boot
        Actuator](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator.endpoints.kubernetes-probes.external-state).

    - The properties to manage this functionality will be the same as [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator.monitoring.customizing-management-server-port) currently exposes,
        therefore, if for example you want to disable this functionality it We can do it through the property `management.endpoint.health.probes.enabled: false` or to change the assigned port we will use `management.server.port: 9999`

!!! note

    This functionality is only enabled in `not web applications,` since in `web / reactive` applications it will be the embedded server `(Tomcat / Netty)` in charge of managing these endpoints.

- An abstract class `SantanderException` is defined from which all exceptions generated with the Santander Spring Boot framework will inherit.

    - A `GenericException` class extends it, defining the [Santander Spring Boot exception scheme](#exception-scheme) of a Santander Spring Boot exception.

#### Context

- A context named `Context` is provided, automatically managed by the architecture and providing:

    - A `ContactPoint` object with the information associated with the 'Contact Point'.

    - A `Info` object with the **appKey** of the application plus information from **Http headers**.

    - A map of type `Map <String, Object>` so that projects can store and retrieve the information they need.

    - A map "**headers**" of type `Map <String, String>` so that projects can add the **key-value inputs that they want to propagate as headers** in the application requests.

- In order to make use of `Context` in non-reactive environments, the architecture provides the class `ContextHolder`,
    for `Reactive` environments the architecture provides the class `ReactiveContextHolder` based on the `Context`
    object of the Reactor project.

!!! note

    The Santander Spring Boot context is registered through an accessor (`ContextAccessor`) to be automatically propagated by the `io.micrometer.context-propagation` library.

#### Propagate context between imperative and reactive code

To propagate the context between imperative and reactive code, Santander Spring Boot configures two [ThreadLocalAccessor](https://javadoc.io/doc/io.micrometer/context-propagation/1.1.3/io/micrometer/context/ThreadLocalAccessor.html): `BootContextAccessor`
and `ServletRequestContextAccessor`.

They have two main functionalities:

- Access the imperative context from reactive code: The ThreadLocalAccessor allows you direct access to the ThreadLocal
in a Publisher if done inside the tap or handle operators with the default setting santander.core.reactor.context-propagation=LIMITED.
If santander.core.reactor.context-propagation=AUTO is set, it will be accessible anywhere in Publisher.
- Access the reactive context from reactive code executed in an servlet/imperative application. For example, in a WebClient
interceptor, we can access the reactive context in a micro servlet.

!!! warning "Performance impact"

    **Enabling `santander.core.reactor.context-propagation=AUTO` can lead to decrease performance** because of wrapping the execution of each operator in order to propagate all managed contexts.

!!! tip "Important"

    Whenever you switch to a reactive context from imperative code, you need to call contextCapture() to propagate the context.

For more information about how to propagate contexts, reads the following section: [How to propagate contexts from/to Reactor stream](#how-to-propagate-context-fromto-reactor-stream)

##### ContextAccessor

To progress the Context between ThreadLocals and Reactor Context.

This allows you to access the Santander Spring Boot context with `ReactiveContextHolder` inside a `Publisher` (ie: `Mono`, `Flux`)
and with `ContextHolder` in the rest of the code, as long as the `Publisher` call uses the `contextCapture` operator.

##### ServletRequestContextAccessor

To progress the servlet RequestAttributes between ThreadLocals and Reactor Context.

!!! tip "Info"

    `ServletRequestContextAccessor` is only loaded for servlet applications.

If you are in a servlet application and you want to get the request inside a `Publisher` you can get it from the reactive context by searching for the key `ServletRequestContextAccessor.SERVLET_REQUEST_KEY`.

#### RestTemplate

Customization for Spring's `RestTemplateBuilder` **beans** autoconfiguring the HttpClient as for [RestTemplate](#resttemplate)
from the [Santander Spring Boot RestClient properties](#restclient-properties).

Instead of the Santander Framework properties, you can use the new properties made available by Spring Boot 3.4,
but if both are used, the Santander Framework properties take precedence.

```properties
spring.http.client.connect-timeout
spring.http.client.read-timeout
```
  
!!! Important

    Since Santander Spring Boot 5, Santander Spring Boot provides the same features for Spring `RestClient` (more modern/fluent API for sync requests).
    Both share the same infrastructure, so any improvement by Spring will be shared as well. However, RestClient is the focus for new higher-level features.

!!! note

    Santander Spring Boot's RestTemplate *Bean* will not be available in Reactive applications due to the obligation to use the WebClient client.

##### Interceptor RestTemplate

- Inject a `SantanderClientHttpRequestInterceptor` in charge of adding HTTP headers from the content of the `Context`:

    - From the `Info` fields (if they exist) the following headers are added:

        - info.getLocale() → HttpHeader with name "Accept-Language"

        - info.getChannel() → HttpHeader with name "X-Santander-Channel"

        - info.getEntity() → HttpHeader with name "organization"

        - info.getThirdParty() → HttpHeader with name "X-Santander-ThirdParty"

        - info.getDevice() → HttpHeader with name "X-Santander-Device"

        - info.getSessionId() → HttpHeader with name "Session-Id"

        - info.getAppId() → HttpHeader with name "X-ClientId"

        - info.getAppInit() → HttpHeader with name "app-init"

        - info.getMode() → HttpHeader with name "mode"

    - From the map "**headers**" as many headers are added as there are entries, where the key of the map corresponds to the name of the header and its value associated with that of the header.

    - From the "JWTClientId" field add headers with name "x-santander-client-id", "x-ibm-client-id" and "X-API-Key".

    - The "X-Appkey" http header is the identification of the client on Apigee (Api Gateway) for the Arsenal Microservice architecture.
      If present, It's read from the request, and its key-value is stored in the **header map** inside the Context to be propagated in the request.

    - The "X-TraceId" http header is **Arsenal traceability legacy header** for backward compatibility.
      If present, It's read from the request, and its key-value is stored in the **header map** inside the Context to be propagated in the request.

!!! info "Important"

    The `HttpHeaders` class implements a **MultiValueMap&lt;String, String&gt;**, so that if an entry with the name of an existing header is defined in the "headers" map, this new value **would be added to the value list** of the
    header.

#### RestClient

Customization for Spring's `RestClient.Builder` **beans** autoconfiguring the HttpClient as for [RestTemplate](#resttemplate)
from the [Santander Spring Boot RestClient properties](#restclient-properties).

Instead of the Santander Framework properties, you can use the new properties made available by Spring Boot 3.4,
but if both are used, the Santander Framework properties take precedence.

```properties
spring.http.client.connect-timeout
spring.http.client.read-timeout
```

##### RestClient Interceptor

- Inject a `SantanderClientHttpRequestInterceptor` in charge of adding HTTP headers from Context content in the same way as the [interceptor of RestTemplate](#interceptor-resttemplate).

#### WebClient/WebClient.Builder Configuration

Configure all `WebClient` **beans** and all `WebClient.Builder` **bean injections** in the application with the properties
configured in the [Santander Spring Boot WebClient properties](#webclient-properties) (maximum number and timeout of connections, reading time and writing, etc.)

Instead of the Santander Framework properties, you can use the new properties made available by Spring Boot 3.5,
but if both are used, the Santander Framework properties take precedence.

```properties
spring.http.reactiveclient.connect-timeout
spring.http.reactiveclient.read-timeout
```

!!! tip "Caution"

    The project needs to register a `WebClient` bean or inject a Spring's `WebClient.Builder` bean to contain these features.
    If the project only instantiates a `WebClient` using "create()" or "builder().build()" in the code, the instrumentation will **NOT** be applied.

##### Interceptor WebClient

- All **Beans** of `WebClient` and `WebClient.Builder` are also configured with an `ExchangeFilterFunction` in charge of adding the information
of the `Context` in the HTTP headers in the same way as the [interceptor of RestTemplate](#interceptor-resttemplate).

#### HTTP Interfaces

Santander Spring Boot is compatible with the use of the HTTP Interfaces provided in `spring-boot` and it enables us to define declarative HTTP services using Java Interfaces and annotated methods.

For more information about HTTP Interfaces, visit the [official Spring documentation](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html#rest-http-interface)

With HTTP Interfaces it is possible to include [Santander Spring Boot Interceptors](#interceptor-webclient) by injecting a bean of type `WebClient.Builder`, `RestClient.Builder` or `RestTemplateBuilder`,
create a client with it, and using the correct adapter over the `HttpServiceProxyFactory` , create the HTTP Interface.

An example of configuration can be found in [How to use HTTP Interfaces](#how-to-use-http-interfaces)

#### Automatic configuration of proxy for HTTP clients

Santander Spring Boot provides automatic configuration of the proxy for HTTP clients (Resttemplate, RestClient or WebClient), allowing
the use of the proxy defined in the system properties or in the environment variables.

Currently support HTTP/S proxies without authentication or with basic authentication.

To activate this functionality you have to enable the property `santander.core.proxy.enabled` with the value `true`.

If you set to true `santander.core.proxy.use-system-properties` you have to set the **java system properties**: `http.proxyHost`,
`http.proxyPort`, `http.proxyUser`, `http.proxyPassword`, `https.proxyHost`, `https.proxyPort`, `https.proxyUser` and
`https.proxyPassword`.

In other case you could use the **Spring configuration properties**: `santander.core.proxy.host`, `santander.core.proxy.port`,
`santander.core.proxy.user-name`, `santander.core.proxy.password`, `santander.core.proxy.non-proxy-hosts`.

More detail regarding this properties can be found in the [Proxy properties](#proxy-properties-for-web-clients) section.

!!! note

    There is different behavior depending on the HTTP client used. 

    With Netty (WebClient):

    - If there is already only an HTTP proxy defined, it will be used for HTTPS.
    - If an HTTPS proxy is defined, it will always be used.
    - The user and password are `http.proxyUser`,`http.proxyPassword` for HTTP and `https.proxyUser`,`https.proxyPassword` for HTTPS.

    With Apache Client (Resttemplate and RestClient):
    
    - Always use http proxy for http endpoints and https proxy for https endpoints.  
    - The user and password are always `http.proxyUser`,`http.proxyPassword` for HTTP and HTTPS proxies.

#### Obfuscation

Santander Spring Boot offers the obfuscation feature for hiding sensible information on a data structure.
In order to do that,
it provides a **Service** that it accepts two input parameters:
the data structure to process and a set of sensitive fields.
The data will be parsed to JSON String format and hidden the values of the sensible fields defined.

The obfuscation implementation allows developers to use two ways of defining that fields have to be hidden inside the data structure:

1. Simple references of the fields to hide all their appearances.

2. Using accurate expressions through [Jayway JsonPath specification](https://github.com/json-path/JsonPath#getting-started).

!!! note

    If the application excludes `com.jayway.jsonpath:json-path` library
    from the `santander-spring-boot-starter-core` dependency,
    the obfuscation feature with JsonPath will not be available.
    You only could obfuscate using fields names in plain format.

### Servlet application

#### Web Filter ContextFilter

- An `OncePerRequestFilter` with name **santanderContextFilter** is configured in charge of filling the object `Info` located in `Context` of with the following values:

    - Info.getInputTimeStamp() → inputTimeStamp generated at the start of the request.

    - Info.getLocale() → Value collected from the Locale associated with the Request.

    - Info.getChannel() → Value collected from the HttpHeader with name "X-Santander-Channel"

    - Info.getEntity() → HttpHeader with name "organization"

    - Info.getThirdParty() → HttpHeader with name "X-Santander-ThirdParty"

    - Info.getDevice() → HttpHeader with name "X-Santander-Device"

    - Info.getSessionId() → HttpHeader with name "Session-Id"

    - Info.getAppKey() → Value retrieved from configuration property `santander.app-key`

    - Info.getAppId() → Value retrieved from configuration property `santander.app-key` for no-gluon app and `santander.app-name` for gluon app.
      In the case that both are reported, the value that will be taken will be that of the appName.

    - Info.getAppInit() → HttpHeader with name "app-init"

    - Info.getMode() → HttpHeader with name "mode"

    - Info.getEncryptedObject() → Value collected from JWT Token or the HttpHeader with name "X-EncryptedObject" if present.

- The "X-Appkey" http header is the identification of the client on Apigee (Api Gateway) for the Arsenal Microservice architecture.
  It's read from the request, and its key-value is stored in the **header map** inside the Context, if present.

- The "X-TraceId" http header is **Arsenal traceability legacy header** for backward compatibility.
  It's read from the request, and its key-value is stored in the **header map** inside the Context, if present.

- The default order will be Ordered.HIGHEST\_PRECEDENCE. That is, it will be the first in the entire chain.

!!! note

    There is the possibility to disable this filter with the [properties](#web-filters) `santander.core.filter.santander-context.enable`.

#### Exception handling

- The error model can be configured to either be the Santander Spring Boot error model (`ErrorModelSantander` or the GLUON error model (`GluonErrorModel`). The chosen error model defines the structure of the
    application's error responses when an exception is thrown.

- A `SantanderExceptionHandlerController` exception handler is provided that extends Spring's **ResponseEntityExceptionHandler**,
    capable of catching any exception thrown by the application. This driver will return to the client a JSON formatted with
    the error model that has been configured (by default it will be the [structure defined](#error-model) by Santander Spring Boot) and an error trace will be written with the exception handled. The exceptions handled by this controller are:

    - Santander Spring Boot Exceptions (***Exception***):

        - Exceptions `GenericException`: being exceptions that are not associated with web applications, by default they will be treated as INTERNAL\_SERVER\_ERROR (500).

            - Exceptions `HttpBaseException` or one of its [specializations](#exception-types), which extends the previous class by adding an **httpStatus** field with the status associated with the error.

    - Internal Spring MVC exceptions defined in base class **ResponseEntityExceptionHandler**.

    - Any other unhandled exceptions that are thrown that inherit from `SantanderException`.

- An implementation of the `ErrorAttributes` interface is also provided, which uses the same error model, for errors that are not resolved by the [old controller](#exception-handling) and end in the "*whitelabel error page*".

    !!! note

        There are certain error situations in which an exception is not generated (eg use of HttpServletResponse*. SendError()*) or are not resolved with the exception handler (eg calling a non-existent endpoint (*controller not
        found*)) In these situations, the error is resolved by invoking the handler **/error** (*whitelabel error page*), which uses the **SantanderErrorAttributes**.

!!! warning

    The Spring Boot functionality to include/exclude fields from the ErrorAttributes with the **ErrorAttributeOptions** is not available with Santander Spring Boot's error handling.

- The necessary functionalities are included to **customize the error response** from properties files according to the **configured error model and the exception** that has been thrown. The parts in charge of
    getting it are:

    - `@CustomErrorModel` annotation.

    - Class `ErrorModelFactory`.

    - `SantanderErrorsPropertiesAccessor` class.

!!! note

    Later there is a [section with an example of how it work](#customize-error-model-fields).

- There is the possibility to **override/customize various pieces of Santander Spring Boot** exception handling. For this, below there is a section with the different [customization possibilities and the steps to follow](#customize-exception-handling).

- It is also possible **to disable all Santander Spring Boot exception handling** to apply its own or keep Spring's by default, setting the `santander.core.exceptions.enabled` property with **false**.

#### Known limitation

The following limitations have been identified, which should be taken into account when using Servlet applications.

##### Use of Resilience4j annotations on methods with Mono or Flux

If, in a Servlet application, a Resilience4j annotation is used on a method that returns a Mono or a Flux, the security context and the Santander Spring Boot context will be empty.

### Reactive app

#### Web Filter-ContextWebFilter

- A `WebFilter` with name **santanderContextWebFilter** is configured in charge of [fill the object `Info`](#web-filter-contextfilter) of the context `Context` and subscribe it to the reactive string,
    with this we get access to **Context** throughout the request flow.

- The default order will be Ordered.HIGHEST\_PRECEDENCE. That is, it will be the first in the entire chain.

!!! note

    There is the possibility to disable this filter with the [property](#web-filters) `santander.core.filter.santander-context.enable`.

#### Web Filter-BodyRequestCacheWebFilter

- A `WebFilter` with name `bodyRequestCacheWebFilter` is configured in charge of storing in an attribute of the object `ServerWebExchange` the `body` of the request (The key of the attribute will be "cachedRequestBody"). In addition, a `Decorator`
    is created on the getBody method so that the `Body` of the cached object is automatically retrieved. This filter allows reactive applications to be able to read the `Body` as many times as necessary. Without this filter it can only be read once.

- The default order will be OrderedWebFilter.REQUEST\_WRAPPER\_FILTER\_MAX\_ORDER - 10 == 0 - 10 == -10. That is, it will be the first in the entire chain.

#### Exception handling

- As in Servlet applications, either the Santander Spring Boot error model (`ErrorModelSantander`) or the GLUON error model (`GluonErrorModel`) can be configured to define the content of the error responses.

- An implementation of the `ErrorAttributes` interface is provided to manage the responses to any error generated by the application, returning a JSON with the error model that has been configured. Similar to the [controller in Servlet
    applications](#exception-handling), this class handles the following exceptions:

    - Santander Spring Boot Exceptions: either `GenericException` or `HttpBaseException` specializations.

    - Internal Spring WebFlux exceptions inheriting from `ResponseStatusException`.

    - Any other exception or error that occurs in the application.

!!! warning

    The Spring Boot functionality to include/exclude fields from the ErrorAttributes with the **ErrorAttributeOptions** is not available with Santander Spring Boot's error handling.

- Includes the ability to [customize error response](#customize-error-model-fields) with the default implementation of `SantanderErrorsPropertiesAccessor`. Later there is a [section explaining how it works](#customize-error-model-fields).

- Again, there is the possibility to **override/customize various pieces of Santander Spring Boot** exception handling. To do this, later there is a section with the [different customization possibilities and the steps to follow](#customize-exception-handling).

- It is also possible **to disable all Santander Spring Boot exception handling** to apply its own or keep Spring's by default, setting the `santander.core.exceptions.enabled` property with **false**.

## Installation and configuration

To use the library, include the maven dependency of its starter in the `pom.xml` file:

           <dependency>
             <groupId>com.santander.framework.springboot</groupId>
             <artifactId>santander-spring-boot-starter-core</artifactId>
           </dependency>

If we only include this library in a `Spring Boot` application, the default configuration is going to be ***NotWeb***, so the way to define any of the ["flavours"](#features) that this library can manage is including the corresponding dependencies.

With this purpose, we include this table where the necessary dependencies to include for any application type are described:

| Application Type            | Desired Configuration | Dependencies                                                                                                                    |
|-----------------------------|-----------------------|---------------------------------------------------------------------------------------------------------------------------------|
| WebApplicationType.NONE     | NotWeb a              | com.santander.framework.springboot:**santander-spring-boot-core**                                                                                |
| WebApplicationType.SERVLET  | Servlet a             | <ul><li>com.santander.framework.springboot:**santander-spring-boot-core**</li><li>org.springframework.boot:**spring-boot-starter-web**</li></ul> |
| WebApplicationType.REACTIVE | Reactive a            | com.santander.framework.springboot:**santander-spring-boot-core** * org.springframework.boot:**spring-boot-starter-webflux**                     |

!!! info "Important"

    Although you can add the dependencies manually and the application type, the archetype has been redesigned to include all configuration possibilities, so we strongly recommend the use of
    Santander Spring Boot Archetypes to avoid errors. In case of migration of architecture versions, check the [migration guides](../../MIGRATION.md).

### Configuration

<!tag:properties>

| Name                                           | Default value      | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                      | Supported values                                     |
|------------------------------------------------|--------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| santander.app-key                                 | N/A                | No       | Indicates the application key. The core library includes a REST request interceptor that automatically sends the app-key value (only ff santander.app-name is not reported) as an "X-ClientId" header in order to identify the calling application. It is a global variable required for no-gluon Santander Spring Boot applications.                                                                            | String                                               |
| santander.appName                                 | N/A                | No       | <ul><li><p>Source for Gluon components: The technical application short name in Gluon. For gluon app is required.</p></li><li><p>Source for non-Gluon components: The technical application short name in the CMDB.</p></li></ul><p>The core library includes a REST request interceptor that automatically sends the app-name value as an "X-ClientId" header in order to identify the calling application.</p> | String                                               |
| santander.region                                  | N/A                | No       | Indicates the region of the PaaS where the application is deployed.                                                                                                                                                                                                                                                                                                                                              | String                                               |
| santander.context.strategy                        | MODE_THREADLOCAL   | No       | Sets the execution strategy for Context (do not reactivate). Possible values are MODE_THREADLOCAL, MODE_INHERITABLETHREADLOCAL, and MODE_GLOBAL.                                                                                                                                                                                                                                            | String                                               |
| santander.core.exceptions.enabled                 | true               | No       | Allows you to disable Santander Spring Boot exception handling.                                                                                                                                                                                                                                                                                                                                                  | Boolean                                              |
| santander.core.exceptions.error-format            | 'DARWIN'           | No       | Set the error format to Santander Spring Boot, Gluon, or Extended Error. Possible values are `DARWIN`, `GLUON`, or `EXTENDED_ERROR`.                                                                                                                                                                                                                                                                             | String                                               |
| santander.core.exceptions.response-content-type   | 'application/json' | No       | Set content type response that will be used in the ExceptionHandler to render the outcome of the errorModel object.                                                                                                                                                                                                                                                                                              | MediaType.ALL                                        |
| santander.core.headers.enable                     | true               | No       | Allows to enable/disable Santander Headers propagation.                                                                                                                                                                                                                                                                                                                                                          | Boolean                                              |
| santander.core.headers.gluon-clientid-propagation | false              | No       | Enable/Disable sending x-client-id", "x-santander-client-id", "x-ibm-client-id" and "X-API-Key" headers with clientId value from context.                                                                                                                                                                                                                                                                        | Boolean                                              |
| santander.core.headers.exclude                    | []                 | No       | Array with all exclusions                                                                                                                                                                                                                                                                                                                                                                                        | Array                                                |
| santander.core.headers.exclude[n].endpoint        | N/A                | No       | Host to exclude the headers propagation                                                                                                                                                                                                                                                                                                                                                                          | String                                               |
| santander.core.headers.exclude[n].common          | N/A                | No       | Exclude common headers to be propagated                                                                                                                                                                                                                                                                                                                                                                          | Boolean                                              |
| santander.core.headers.exclude[n].security        | N/A                | No       | Exclude security headers to be propagated                                                                                                                                                                                                                                                                                                                                                                        | Boolean                                              |
| santander.core.headers.exclude[n].logging         | N/A                | No       | Exclude logging headers to be propagated                                                                                                                                                                                                                                                                                                                                                                         | Boolean                                              |
| santander.core.headers.xclient-compatibility      | true               | No       | If enabled, the clientId log field could be set from "x-clientId" header when "x-santander-client-id" is not received. In another case, is only obtained from "x-santander-client-id".                                                                                                                                                                                                                           | Boolean                                              |
| santander.core.reactor.context-propagation        | LIMITED            | No       | Define Context propagation type for Reactor streams:<ul><li>**LIMITED:** contexts propagation from Reactor Context to ThreadLocals using ThreadLocalAccessors is only available using *tap* or *handle* operators. *Recommended option. It has more performance.*</li><li>**AUTO:** Context propagation in every Reactor operator</li></ul>                                                                      | <ul><li><p>LIMITED</p></li><li><p>AUTO</p></li></ul> |
| santander.core.reactor.context-schedule-hook-enabled | true               | No       | Use a Schedulers.onScheduleHook to progress Context, RequestContext and SecurityContext to reactor Schedulers. Only for servlet or notweb applications                                                                                                                                                                                                                                      | Boolean                                              |

!!! tip "Caution"

    `santander-spring-boot-extended-error` is deprecated and it will be removed in future versions. 

!!! info "Important"

    For using the `EXTENDED_ERROR` format, in addition, it is necessary to define the `santander-spring-boot-starter-extended-error` dependency in the pom.xml.

### Asynchrony

| Name                                         | Default value              | Required | Description                                                                                                                                         | Supported values                                                                                                                               |
|----------------------------------------------|----------------------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| santander.core.async.enabled                    | false                      | No       | Indicates whether a ThreadPoolExecutor will be created on microservice initialization.                                                              | Boolean                                                                                                                                        |
| santander.core.async.core-pool-size             | 5                          | No       | Initial size of the thread pool that will keep the service active.                                                                                  | Number                                                                                                                                         |
| santander.core.async.max-pool-size              | 100                        | No       | Maximum number of concurrent threads that can be created.                                                                                           | Number                                                                                                                                         |
| santander.core.async.queue-capacity             | 0                          | No       | Size of the waiting queue while the thread pool is full.                                                                                            | Number                                                                                                                                         |
| santander.core.async.await-termination-seconds  | 5                          | No       | Time, in seconds, that the ThreadPoolExecutor will wait before terminating the different threads created and destroying itself.                     | Number                                                                                                                                         |
| santander.core.async.keep-alive-seconds         | 5                          | No       | Specifies the time that threads that have been created exceeding the value of "corePoolSize" will be kept "alive" when they finish their execution. | Number                                                                                                                                         |
| santander.core.async.thread-name-prefix         | DefaultTaskExecutor- | No       | Prefix that will carry the name of the thread created by the ThreadPoolExecutor.                                                                    | String                                                                                                                                         |
| santander.core.async.allow-core-thread-time-out | false                      | No       | Enables core thread to time out.                                                                                                                    | Boolean                                                                                                                                        |
| santander.core.async.thread-pool-policy         | ABORT_POLICY               | No       | Modifies the thread pool policy.                                                                                                                    | <ul><li>ABORT_POLICY</li><li>DISCARD_OLDEST_POLICY</li><li>DISCARD_POLICY</li><li>CALLER_RUNS_POLICY</li><li>DARWIN_DISCARD_POLICY</li></ul>   |

### Web filters

| Name                                                 | Default value                                          | Required | Description                                                                                                                  | Supported values |
|------------------------------------------------------|--------------------------------------------------------|----------|------------------------------------------------------------------------------------------------------------------------------|------------------|
| santander.core.filter.cache-request-body-filter.order   | REQUEST_WRAPPER_FILTER_MAX_ORDER - 10 == 0 - 10 == -10 | No       | Order where the filter will be placed in the chain.                                                                          | Number           |
| santander.core.filter.cache-request-body-filter.enabled | false                                                  | No       | Allows you to enable the filter. By default, it is enabled when functional traces or automatic BusinessEvents are activated. | Boolean          |
| santander.core.filter.santander-context.order              | Ordered.HIGHEST_PRECEDENCE == -2147483648              | No       | Order where the filter will be placed in the chain.                                                                          | Number           |
| santander.core.filter.santander-context.enable             | true                                                   | No       | Allows you to disable Context filters.                                                                                 | Boolean          |

### Apache HttpClient properties

| Name                                                                   | Default value | Required | Description                                                                                                                                                                                                                 | Supported values |
|------------------------------------------------------------------------|---------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| santander.core.http-clients.apache-http-client.enabled                    | true          | No       | Allows disabling the autoconfiguration that Santander Spring Boot performs on RestTemplateBuilder (Santander Spring Boot interceptors and configuration of pools and connection timeouts).                                                                | Boolean          |
| santander.core.http-clients.apache-http-client.connect-timeout            | 5000          | No       | Timeout (in milliseconds) to wait until a connection is established. A value of 0 indicates an infinite wait time.                                                                                                          | Number           |
| santander.core.http-clients.apache-http-client.read-timeout               | 5000          | No       | Timeout (in milliseconds) to wait to obtain data through the established connection, or in other words, the maximum period of inactivity between two consecutive data packets. A value of 0 indicates an infinite wait time. | Number           |
| santander.core.http-clients.apache-http-client.connection-request-timeout | 5000          | No       | Timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by the *Connection Manager*. A value of 0 indicates an infinite wait time.                                                  | Number           |
| santander.core.http-clients.apache-http-client.max-total-connections      | 100           | No       | Maximum number of connections open simultaneously, modifying the maximum size of the pool of concurrent connections that can be managed by the *Connection Manager*.                                                        | Number           |
| santander.core.http-clients.apache-http-client.max-route-connections      | 10            | No       | Maximum allowed number of connections open simultaneously for each route, also modifying the size of the connection pool for each route. Number                                                                             | Number           |
| santander.core.http-clients.apache-http-client.connection-time-to-live    | 60_000L       | No       | Total span of time connections can be kept alive or execute requests                                                                                                                                                        | Long Number      |

!!! note

    If you set up the properties `santander.core.resttemplate` or `santander.core.rest-client` then this properties will be ignored to be backward compatible.

### Netty HttpClient properties

| Name                                                               | Default value | Required | Description                                                                                                                                                                                                                                                         | Supported values          |
|--------------------------------------------------------------------|---------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| santander.core.http-clients.netty-http-client.enabled                 | true          | No       | Allows disabling the autoconfiguration that Santander Spring Boot performs on WebClient.Builder and WebClient (Santander Spring Boot interceptors and configuration of pools and connection timeouts).                                                                                            | Boolean                   |
| santander.core.http-clients.netty-http-client.connect-timeout         | 5000          | No       | Defines the timeout (in milliseconds) to wait until a connection is established.                                                                                                                                                                                    | Number                    |
| santander.core.http-clients.netty-http-client.read-timeout            | 5000          | No       | Defines the timeout (in milliseconds) to wait to get data through the established connection.                                                                                                                                                                       | Number                    |
| santander.core.http-clients.netty-http-client.write-timeout           | 5000          | No       | Defines the timeout (in milliseconds) to wait when writing data over the established connection.                                                                                                                                                                    | Number                    |
| santander.core.http-clients.netty-http-client.max-connections         | 500           | No       | Sets the maximum number of connections open simultaneously for a WebClient.Builder, this is achieved by modifying the size of the connection pool associated with said WebClient.Builder.                                                                           | Number                    |
| santander.core.http-clients.netty-http-client.pending-acquire-timeout | 45000         | No       | Defines the timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by a WebClient.Builder.                                                                                                                                 | Number                    |
| santander.core.http-clients.netty-http-client.max-life-time           | 60000         | No       | Defines the maximum time (in milliseconds) after which the connection will be closed in the connection pool.                                                                                                                                                        | Number                    |
| santander.core.http-clients.netty-http-client.wiretap                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:[^3] `logging.level.reactor.netty.http.client=DEBUG` | Boolean                   |
| santander.core.http-clients.netty-http-client.wiretap-format          | null          | No       | Determines the wiretap logging format. See HttpClient documentation                                                                                                                                                                                                 | SIMPLE, HEX_DUMP, TEXTUAL |
| santander.core.http-clients.netty-http-client.proxy-system-settings   | false         | No       | Enable Santander Spring Boot WebClient to use the Java system properties proxy settings                                                                                                                                                                                            | Boolean                   |

!!! note

    If you set up the properties `santander.core.webclient` then this properties will be ignored to be backward compatible.

### RestTemplate properties (Deprecated use Apache HttpClient properties instead)

| Name                                                               | Default value | Required | Description                                                                                                                                                                                                                 | Supported values |
|--------------------------------------------------------------------|---------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| santander.core.resttemplate.enabled                                   | true          | No       | Allows disabling the autoconfiguration that Santander Spring Boot performs on RestTemplateBuilder (Santander Spring Boot interceptors and configuration of pools and connection timeouts).                                                                | Boolean          |
| santander.core.resttemplate.customize-beans                           | false         | No       | Restore the old mode of operation of the restemplate interceptors. The interceptors are injected into the restemplate objects instead of only in the builders. Also a restemplate object is created                         | Boolean          |
| santander.core.resttemplate.connect-timeout __deprecated__            | 5000          | No       | Timeout (in milliseconds) to wait until a connection is established. A value of 0 indicates an infinite wait time.                                                                                                          | Number           |
| santander.core.resttemplate.read-timeout __deprecated__               | 5000          | No       | Timeout (in milliseconds) to wait to obtain data through the established connection, or in other words, the maximum period of inactivity between two consecutive data packets. A value of 0 indicates an infinite wait time. | Number           |
| santander.core.resttemplate.connection-request-timeout __deprecated__ | 5000          | No       | Timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by the *Connection Manager*. A value of 0 indicates an infinite wait time.                                                  | Number           |
| santander.core.resttemplate.max-total-connections __deprecated__      | 100           | No       | Maximum number of connections open simultaneously, modifying the maximum size of the pool of concurrent connections that can be managed by the *Connection Manager*.                                                        | Number           |
| santander.core.resttemplate.max-route-connections __deprecated__      | 10            | No       | Maximum allowed number of connections open simultaneously for each route, also modifying the size of the connection pool for each route. Number                                                                             | Number           |
| santander.core.resttemplate.connection-time-to-live __deprecated__    | 60_000L       | No       | Total span of time connections can be kept alive or execute requests                                                                                                                                                        | Long Number      |

!!! note

    All properties related to connection configuration has been deprecated in favor of the new properties `santander.core.http-clients.apache-http-client`

### RestClient properties

| Name                                                                | Default value | Required | Description                                                                                                                                                                                                                  | Supported values |
|---------------------------------------------------------------------|---------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| santander.core.rest-client.enabled                                     | true          | No       | Allows disabling the autoconfiguration that Santander Spring Boot performs on RestClient.Builder (Santander Spring Boot interceptors and configuration of pools and connection timeouts).                                                                  | Boolean          |
| santander.core.rest-client.connect-timeout __deprecated__              | 5000          | No       | Timeout (in milliseconds) to wait until a connection is established. A value of 0 indicates an infinite wait time.                                                                                                           | Number           |
| santander.core.rest-client.read-timeout __deprecated__                 | 5000          | No       | Timeout (in milliseconds) to wait to obtain data through the established connection, or in other words, the maximum period of inactivity between two consecutive data packets. A value of 0 indicates an infinite wait time. | Number           |
| santander.core.rest-client.connection-request-timeout __deprecated__   | 5000          | No       | Timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by the *Connection Manager*. A value of 0 indicates an infinite wait time.                                                   | Number           |
| santander.core.rest-client.max-total-connections __deprecated__        | 100           | No       | Maximum number of connections open simultaneously, modifying the maximum size of the pool of concurrent connections that can be managed by the *Connection Manager*.                                                         | Number           |
| santander.core.rest-client.max-route-connections __deprecated__        | 10            | No       | Maximum allowed number of connections open simultaneously for each route, also modifying the size of the connection pool for each route. Number                                                                              | Number           |
| santander.core.rest-client.connection-time-to-live __deprecated__      | 60_000L       | No       | Total span of time connections can be kept alive or execute requests                                                                                                                                                         | Long Number      |

!!! warning

    If you set up the properties `santander.core.resttemplate` and `santander.core.rest-client` then `santander.core.rest-client`
    will be ignored and use the `santander.core.rest-template` for RestClients configuration.

!!! note

    All properties related to connection configuration has been deprecated in favor of the new properties `santander.core.http-clients.apache-http-client`

### WebClient properties

| Name                                                         | Default value | Required | Description                                                                                                                                                                                                                                                         | Supported values          |
|--------------------------------------------------------------|---------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| santander.core.webclient.enabled                                | true          | No       | Allows disabling the autoconfiguration that Santander Spring Boot performs on WebClient.Builder and WebClient (Santander Spring Boot interceptors and configuration of pools and connection timeouts).                                                                                            | Boolean                   |
| santander.core.webclient.customize-beans                        | false         | No       | Restore the old mode of operation of the webclient interceptors. The interceptors are injected into the WebClient objects instead of only in the builders                                                                                                           | Boolean                   |
| santander.core.webclient.connect-timeout __deprecated__         | 5000          | No       | Defines the timeout (in milliseconds) to wait until a connection is established.                                                                                                                                                                                    | Number                    |
| santander.core.webclient.read-timeout __deprecated__            | 5000          | No       | Defines the timeout (in milliseconds) to wait to get data through the established connection.                                                                                                                                                                       | Number                    |
| santander.core.webclient.write-timeout __deprecated__           | 5000          | No       | Defines the timeout (in milliseconds) to wait when writing data over the established connection.                                                                                                                                                                    | Number                    |
| santander.core.webclient.max-connections __deprecated__         | 500           | No       | Sets the maximum number of connections open simultaneously for a WebClient.Builder, this is achieved by modifying the size of the connection pool associated with said WebClient.Builder.                                                                           | Number                    |
| santander.core.webclient.pending-acquire-timeout __deprecated__ | 45000         | No       | Defines the timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by a WebClient.Builder.                                                                                                                                 | Number                    |
| santander.core.webclient.max-life-time __deprecated__           | 60000         | No       | Defines the maximum time (in milliseconds) after which the connection will be closed in the connection pool.                                                                                                                                                        | Number                    |
| santander.core.webclient.wiretap __deprecated__                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:[^3] `logging.level.reactor.netty.http.client=DEBUG` | Boolean                   |
| santander.core.webclient.wiretap-format  __deprecated__         | null          | No       | Determines the wiretap logging format. See HttpClient documentation                                                                                                                                                                                                 | SIMPLE, HEX_DUMP, TEXTUAL |
| santander.core.webclient.proxy-system-settings __deprecated__   | false         | No       | Enable Santander Spring Boot WebClient to use the Java system properties proxy settings                                                                                                                                                                                            | Boolean                   |

!!! note

    All properties related to connection configuration has been deprecated in favor of the new properties `santander.core.http-clients.netty-http-client

### Proxy properties for web clients

| Name                                    | Default value | Required | Description                                                                                                                                                                                                                                                                                | Supported values |
|-----------------------------------------|---------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| santander.core.proxy.enabled               | false         | No       | Allows enabling the proxy configuration for WebClient, RestClient and RestTemplate.                                                                                                                                                                                                        | Boolean          |
| santander.core.proxy.host                  |               | No       | Proxy host.                                                                                                                                                                                                                                                                                | String           |
| santander.core.proxy.port                  |               | No       | Proxy port.                                                                                                                                                                                                                                                                                | Integer          |
| santander.core.proxy.user-name             |               | No       | Proxy user in case of authentication needed.                                                                                                                                                                                                                                               | String           |
| santander.core.proxy.password              |               | No       | Proxy password in case of authentication needed.                                                                                                                                                                                                                                           | String           |
| santander.core.proxy.non-proxy-hosts       |               | No       | A list of hosts that should be reached directly, bypassing the proxy. This is a list of patterns separated by '\|'. The patterns may start or end with a '*' for wildcards. Any host matching one of these patterns will be reached through a direct connection instead of through a proxy | String           |
| santander.core.proxy.use-system-properties | false         | No       | Use the Java system properties proxy settings.                                                                                                                                                                                                                                             | Boolean          |

### Swagger

| Name                                  | Default value                                                                                                                                                                                  | Required | Description                                                         | Supported values |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------------------------------------------------------------------|------------------|
| santander.core.swagger.enabled           | true                                                                                                                                                                                           | No       | Enables the use of Swagger within the application.                  | Boolean          |
| santander.core.swagger.permittedProfiles | local, cert, dev, pre, test, prep                                                                                                                                                              | No       | List of profiles allowed for the use of Swagger.                    | List             |
| santander.core.swagger.swaggerEndpoints  | <ul><li><p>/**/v2/api-docs/**</p></li><li><p>/**/swagger-ui**/**</p></li><li><p>/**/swagger-resources/**</p></li><li><p>/**/v3/api-docs/**</p></li><li><p>**/swagger-config**/**</p></li></ul> | No       | List of Swagger endpoints to which Santander Spring Boot security is not applied . | List             |

<!end:properties>

### Basic configuration

If we do not specify any type of configuration relative to the default core library, the ObjectMapper bean will be created.

    santander:
      app-key: myApp

### Async Configuration

If we set the `santander.core.async.enabled` property to **true** the Bean "*santanderAsyncExecutor*"of type `Executor` will be created with its default configuration.

We can also overwrite any of its configuration properties:

    santander:
      app-key: myApp
      core:
        async:
          enabled: true
          core-pool-size: 5
          max-pool-size: 5
          queue-capacity: 0
          await-termination-seconds: 5
          keep-alive-seconds: 5
          thread-name-prefix: MyAppThreadPrefix

#### Thread Pool Policy property configuration

It is possible to modify the Thread Pool policy on the asynchronous configuration by using the property `santander.core.async.thread-pool-policy`. This property admits five different
policies to set, which are the following:

1. `ABORT_POLICY`: Discards task and throws an exception.
2. `DISCARD_POLICY`: Discards the tasks, but it does not throw an exception.
3. `DISCARD_OLDEST_POLICY`: Discards the oldest task and leave space for newer ones.
4. `CALLER_RUNS_POLICY`: Executes the task in the thread of the caller.
5. `DARWIN_DISCARD_POLICY`: Same as `DISCARD_POLICY` but it provides an additional log.

In case the property `santander.core.async.thread-pool-policy` is not set, `ABORT_POLICY` will be established by default. In case we wanted to overwrite this policy, we will
only need to add it to the property list just like in this example:

    santander:
      app-key: myApp
      core:
        async:
          enabled: true
          core-pool-size: 5
          max-pool-size: 5
          queue-capacity: 0
          await-termination-seconds: 5
          keep-alive-seconds: 5
          thread-name-prefix: MyAppThreadPrefix
          thread-pool-policy: DARWIN_DISCARD_POLICY

### RestTemplate and WebClient configuration

For applications that incorporate the `Spring Web` package (includes the `RestTemplate` class) and httpclient, **in addition to the previous configuration**, by default a `Bean` of type `RestTemplate` will be created with the default configuration.

Again, we can override any of its configuration properties:

    santander:
      app-key: myApp
      core:
        (...)
        rest-template:
          connect-timeout: 10000
          read-timeout: 10000
          connection-request-timeout: 2000
          max-total-connections: 50
          max-route-connections: 5
          connection-time-to-live: 50000

If the dependency of `Spring Webflux` (includes the WebClient class) and reactor-netty has also been loaded, the beans of `WebClient` and `WebClient.Builder` will be configured with their default configuration, being able to modify the maximum
number of connections and timeouts:

    santander:
      app-key: myApp
      core:
        (...)
        webClient:
          connect-timeout: 10000
          read-timeout: 10000
          write-timeout: 10000
          max-connections: 100
          pending-acquire-timeout: 30000
          max-life-time: 60000

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

### Support for third party libraries

Added native compilation support for 3rd party libraries used in the Santander Spring Boot framework.

!!! warning

    This support is limited to the functionality used in Santander Spring Boot tests, projects using these dependencies may need to add more hints for proper operation.

The supported libraries are:

- partenon-sat-spring-boot-starter
- hamcrest
- wiremock
- openapi

And the functionality covered is:

- Tomcat reactive
- Authentication with Kerberos using Kafka

## Exposed API

| Name                                                                                                            | Type                                                                                                                                                                                                              | Description                                                                                                                                                                                                               | Application Type                                          |
|-----------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| [ObjectMapper](https://www.javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/2.19.2/com/fasterxml/jackson/databind/ObjectMapper.html)                                                            | [ObjectMapper](https://www.javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/2.19.2/com/fasterxml/jackson/databind/ObjectMapper.html)                                                                                                                                                              | An ObjectMapper bean that can be used to handle JSON-formatted strings or convert objects to JSON strings.                                                                                                                | <ul><li>All</li></ul>                                     |
| [ErrorModelBootBuilder](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/dto/ErrorModel.ErrorModelBootBuilder.html)           | [ErrorModelBuilder](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/dto/ErrorModelBuilder.html)                                                                                                                                   | Builder that builds objects with Santander Spring Boot's error model (ErrorModelSantander).                                                                                                                                                 | <ul><li>Servlet</li><li>Reactive</li></ul>                |
| [CustomErrorModel](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/annotation/CustomErrorModel.html)                                    | Annotation                                                                                                                                                                                                        | Valid annotation in POJO classes that define an error model returned in an ErrorModelBuilder, to indicate that its fields can be customizable from error properties files.                                                | <ul><li>Servlet</li><li>Reactive</li></ul>                |
| [ResourceBundleMessageSource](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/context/support/ResourceBundleMessageSource.html)              | [MessageResource](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/context/MessageSource.html)                                                                                                                                                  | Bean with which to access the Resource Bundle "errors" within the properties folder with the same name "errors".                                                                                                          | <ul><li>Servlet</li><li>Reactive</li></ul>                |
| [SantanderErrorsPropertiesAccessor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/SantanderErrorsPropertiesAccessor.html)            | [BiFunction<String, Context, String>](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/function/BiFunction.html)                                                                                                           | BiFunction that finds a property from the 'Errors' Resource Bundle and the errors.properties file using the content of the Context.                                                                                 | <ul><li>Servlet</li><li>Reactive</li></ul>                |
| [Context](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/Context.html)                                                 | [Context](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/Context.html)                                                                                                                                                  | Builder that builds access objects to the Santander Spring Boot context.                                                                                                                                                                 | <ul><li>All</li></ul>                                     |
| [ContextHolderStrategy](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/ContextHolderStrategy.html)                     | Interface                                                                                                                                                                                                         | Interface that implement all supported strategies.                                                                                                                                                                        | <ul><li>NotWeb</li><li>Servlet</li></ul>                  |
| ContextHolder                                                                                                   | [ContextHolder](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/ContextHolder.html)                                                                                                                                      | Class with static methods that allows you to retrieve and initialize the Context.                                                                                                                                   | <ul><li>NotWeb</li><li>Servlet</li></ul>                  |
| ReactiveContextHolder                                                                                           | [ReactiveContextHolder](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/ReactiveBootContextHolder.html)                                                                                                                      | Class with static methods that allows you to retrieve and initialize the Context in reactive environments.                                                                                                          | <ul><li>NotWeb</li><li>Reactive</li></ul>                 |
| RestTemplateBuilder                                                                                             | [RestTemplateBuilder](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/client/RestTemplateBuilder.html)                                                                                                                                           | Bean of RestTemplateBuilder type in which all those interceptors that are necessary for the proper functioning of the framework will be included.                                                                         | <ul><li>NotWeb</li><li>Servlet</li></ul>                  |
| [ContextInterceptor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/ContextInterceptor.html)                       | [SantanderClientHttpRequestInterceptor](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/http/client/SantanderClientHttpRequestInterceptor.html), [AbstractContextInterceptor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/AbstractBootContextInterceptor.html)      | The purpose of this class is to include the information of the Info object of the Context in all requests made from the application through RestTemplate.                                                     | <ul><li>NotWeb</li><li>Servlet</li></ul>                  |
| [ContextFilter](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/filter/ContextFilter.html)                                      | [OncePerRequestFilter](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/filter/OncePerRequestFilter.html)                                                                                                                                   | Filter that initializes the Info object located in the Context.                                                                                                                                               | <ul><li>Servlet</li></ul>                                 |
| errorAttributesContext                                                                                          | [Supplier&lt;Context&gt;](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/function/Supplier.html)                                                                                                                         | Supplier of the *context used during error handling Santander Spring Boot Servlet*, in this case it returns an object of type Context.                                                                                             | <ul><li>Servlet</li></ul>                                 |
| [SantanderExceptionHandlerController](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/web/SantanderExceptionHandlerController.html)  | [@ControllerAdvice](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/bind/annotation/ControllerAdvice.html)                                                                                                                                 | Santander Spring Boot exception handler for Servlet applications.                                                                                                                                                                        | <ul><li>Servlet</li></ul>                                 |
| [ErrorAttributes](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/web/SantanderErrorAttributes.html)                        | [ErrorAttributes](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/web/servlet/error/SantanderErrorAttributes.html)                                                                                                                                     | Santander Spring Boot's implementation of ErrorAttributes to use the error model defined in other application errors.                                                                                                                    | <ul><li>Servlet</li></ul>                                 |
| WebClient Builder                                                                                               | [WebClient.Builder](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/reactive/function/client/WebClient.Builder.html)                                                                                                                       | Bean of type WebClient.Builder in which all those interceptors and configuration that are necessary for the proper functioning of the framework will be included.                                                         | <ul><li>NotWeb</li><li>Servlet</li><li>Reactive</li></ul> |
| [ContextServletFilterFunction](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/ContextServletFilterFunction.html)   | [ExchangeFilterFunction](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/reactive/function/client/ExchangeFilterFunction.html), [AbstractContextInterceptor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/AbstractBootContextInterceptor.html) | The purpose of this class is to include the information of the Info object of the Context in all requests made from the application using beans of type WebClient and / or WebClient.Builder.                 | <ul><li>NotWeb</li><li>Servlet</li></ul>                  |
| [ContextReactiveFilterFunction](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/ContextReactiveFilterFunction.html) | [ExchangeFilterFunction](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/reactive/function/client/ExchangeFilterFunction.html), [AbstractContextInterceptor](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/interceptor/AbstractBootContextInterceptor.html) | The purpose of this class is to include the information of the Info object of the Reactive Context in all the requests made from the application through beans of type WebClient and/or WebClient.Builder.    | <ul><li>NotWeb</li><li>Reactive</li></ul>                 |
| [ContextWebFilter](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/filter/ContextWebFilter.html)                                | [WebFilter](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/WebFilter.html)                                                                                                                                                         | Filter that initializes the Info object located in a new Context.                                                                                                                                             | <ul><li>Reactive</li></ul>                                |
| [BodyRequestCacheWebFilter](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/filter/BodyRequestCacheWebFilter.html)                      | [WebFilter](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/WebFilter.html)                                                                                                                                                         | Filter that caches the Body of the request.                                                                                                                                                                               | <ul><li>Reactive</li></ul>                                |
| errorAttributesContext                                                                                          | [Function<ServerRequest, Context>](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/function/Function.html)                                                                                                                | Function that generates the context used during Santander Spring Boot's Reactive error handling from a ServerRequest, in this case it returns an object of type Context.                                                           | <ul><li>Servlet</li></ul>                                 |
| [ErrorAttributes](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/reactive/SantanderErrorAttributes.html)                   | [ErrorAttributes](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/web/reactive/error/SantanderErrorAttributes.html)                                                                                                                                    | Santander Spring Boot implementation of ErrorAttributes for handling exceptions in a Reactive application.                                                                                                                               | <ul><li>Reactive</li></ul>                                |
| WebApplicationType                                                                                              | [WebApplicationType](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/WebApplicationType.html)                                                                                                                                                                 | Bean that indicates the type of web application (REACTIVE/SERVLET/NONE).                                                                                                                                                  | <ul><li>NotWeb</li><li>Servlet</li><li>Reactive</li></ul> |
| [HttpServer](https://docs.oracle.com/en/java/javase/17/docs/api/jdk.httpserver/com/sun/net/httpserver/HttpServer.html)                               | [Bean](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/context/annotation/Bean.html)                                                                                                                                                           | Bean with name healthCheckHttpServer and that represents the Http server in charge of managing the actuator endpoints, specifically /actuator/health/liveness and /actuator/health/readiness.                             | <ul><li>NotWeb</li></ul>                                  |
| [HttpHandler](https://docs.oracle.com/en/java/javase/17/docs/api/jdk.httpserver/com/sun/net/httpserver/HttpHandler.html)                             | [Bean](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/context/annotation/Bean.html)                                                                                                                                                           | Two Beans with names livenessHttpHandler and readinessHttpHandler are generated that represent the handlers that will respond to requests against the endpoints /actuator/health/liveness and /actuator/health/readiness. | <ul><li>NotWeb</li></ul>                                  |
| [ObfuscationService](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/obfuscation/ObfuscationServiceImpl.html)                           | [ObfuscationService](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/obfuscation/ObfuscationService.html)                                                                                                                                    | Service for sensitizing information inside a data structure.                                                                                                                                                              | <ul><li>All</li></ul>                                     |

## Internationalization (i18n)

Santander Spring Boot customize the mechanism that manage internationalization by configuring a `MessageSource` that can read properties
from classpath and other filesystem paths.

By default, the `MessageSource` is configured using `spring.messages` properties but define other defaults value than Spring,
also add `classpath:errors/errors` to `spring.messages.basename` property. Attached a more detailed table:

| property                                    | description                                                                                                                                                                                                                                                                                          | default value santander framework                         | original default value   |
|---------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|--------------------------|
| spring.messages.always-use-message-format   | Whether to always apply the MessageFormat rules, parsing even messages without arguments.                                                                                                                                                                                                            | false                                                     | false                    |
| spring.messages.basename                    | Comma-separated list of basenames (essentially a fully-qualified classpath location), each following the ResourceBundle convention with relaxed support for slash based locations. If it doesn't contain a package qualifier (such as "org.mypackage"), it will be resolved from the classpath root. | Always add **classpath:errors/errors** to configure value | messages                 |
| spring.messages.cache-duration              | Loaded resource bundle files cache duration. When not set, bundles are cached forever. If a duration suffix is not specified, seconds will be used.                                                                                                                                                  |                                                           |                          |
| spring.messages.encoding                    | Message bundles encoding.                                                                                                                                                                                                                                                                            | **ISO-8859-1**                                            | UTF-8                    |
| spring.messages.fallback-to-system-locale   | Whether to fall back to the system Locale if no files for a specific Locale have been found. if this is turned off, the only fallback will be the default file (e.g. "messages.properties" for basename "messages"). | true                                                      | true                     |
| spring.messages.use-code-as-default-message | Whether to use the message code as the default message instead of throwing a "NoSuchMessageException". Recommended during development only. | **true**                                                  | false                    |

This mechanism is active by default for web applications, but it can be disabled by setting the property `santander.core.exceptions.enabled` to `false`.

???+ warning "Scope of santander.core.exceptions.enabled"

      `santander.core.exceptions.enabled` property is used to enable or disable the completely Santander Spring Boot exception handling mechanism. 
      Not just the internationalization part

This mechanism is used to manage the custom error fields that are returned in the error responses, [here](#internationalize-custom-errors)
is explained how to use internationalization for custom errors.

You can also use this mechanism to manage the internationalization of the messages that are returned in the error responses
following [this guide](#how-to-use-properties-files-for-internationalization).

## Exceptions

<span id="exception-structure"></span>

### Application name for exceptions

To correctly configure exception handling **in web applications** it is necessary to make sure that the microservice has a name established in the configuration file (*application.yml*):

    spring:
        application:
            name: application-demo

Or we can also define an application name that will be used only for exceptions in the error configuration file
(resources/*errors.properties*):

    # App name for exceptions
    exceptions.app.name = exceptions-demo

If the latter is defined, **it will take precedence over the** `spring.application.name` property.

### Exception types

An **abstract class** `SantanderException` is provided that can be extended to create new exceptions generated with the Santander Spring Boot framework.
In addition, there is a **generic exception** (`GenericException`) that implements the [base
structure](#exception-scheme) used by Santander Spring Boot exceptions, which can be extended by the project for non-web exceptions.

- Exception

    - GenericException

        - HttpBaseException

            - BadRequestException

            - and so on

Along with the generic class, the Core library provides a series of **exceptions for Web applications** that correspond to the most common HTTP errors:

| Exception                                                                                                     | HTTP code | Description                                                                                                                                                                                                                                                                                                                                             | Causes                                                                                                                                                                                                                                       |
|---------------------------------------------------------------------------------------------------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [HttpBaseException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/HttpBaseBootException.html)                       | N/A       | This is the basis for all Santander Spring Boot's own web exceptions, this exception should never be thrown directly. Instead, if necessary, it should be extended by the project to generate a new exception of its own.                                                                                                                                              | It should never be launched.                                                                                                                                                                                                                 |
| [BadRequestException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/BadRequestBootException.html)                   | 400       | Used to indicate that a call has been made incorrectly.                                                                                                                                                                                                                                                                                                 | <ul><li>The parameters received in the request are not correct.</p></li><li>With the received parameters it is not possible to complete the request</li></ul>                                                                                |
| [ConflictException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/ConflictBootException.html)                       | 409       | This exception should be used to indicate that a requested action cannot be performed because the resource it must access to complete is in an incompatible state.                                                                                                                                                                                      | <ul><li>You are trying to modify a resource that has been deleted</li><li>You are trying to delete a resource that is currently being modified.</li></ul>                                                                                    |
| [ForbiddenException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/ForbiddenBootException.html)                     | 403       | Exception indicating that you are trying to access a resource for which you do not have the required permissions.                                                                                                                                                                                                                                       | <ul><li>A resource has been requested for which you do not have permissions.</li><li>A protected resource has been requested that does not exist.</li></ul>                                                                                  |
| [InternalServerErrorException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/InternalServerErrorBootException.html) | 500       | This exception should be thrown whenever an unrecoverable error has occurred on the server that is not related to the functional logic of the application.                                                                                                                                                                                              | <ul><li>It is not possible to connect to the database.</li><li>Cannot connect to token validation services</li></ul>                                                                                                                         |
| [NotFoundException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/NotFoundBootException.html)                       | 404       | Exception indicating that the requested resource could not be found. In general, it is usually used to indicate that the request made has not been able to return data. It is important to indicate that if a request is made against an endpoint that does not exist, a 404 error will always be returned without the need for developer intervention. | <ul><li>Data has been requested from a client that does not exist.</li><li>A request for movements has been made for an account that does not exist.</li><li>Movements of an account have been requested and it does not have any.</li></ul> |
| [UnauthorizedException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/UnauthorizedBootException.html)               | 401       | This exception should only be thrown by the authentication library if the request that is made does not have a valid authentication token.                                                                                                                                                                                                              | N/A                                                                                                                                                                                                                                          |
| [NoContentException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/NoContentBootException.html)                     | 204       | This exception indicating that there is no additional content to send in the response payload body.                                                                                                                                                                                                                                                     | N/A                                                                                                                                                                                                                                          |

!!! info "Important"

    Regardless of being a `Servlet` or `Reactive` environment and although the project can create its own exceptions from scratch, it is recommended to extend the class `HttpBaseException` (**with HttpStatus**) or
    `GenericException` (**without HttpStatus**) for better handling of the fields defined in the error model.

#### Exception scheme

All exceptions generated from `GenericException` will follow the following scheme:

        String errorName; (1)
        int internalCode; (2)
        String shortMessage; (3)
        String detailedMessage; (4)
        Map mapExtendedMessage; (5)

Where:

1. Name of the error supplied in the Santander Spring Boot exception constructor.

2. Internal code of the error provided in the constructor of the Santander Spring Boot exception or "-1" if it is not defined.

3. Short message describing the exception briefly, it should not be more than one sentence.

4. Descriptive message of the exception, it can include all the information that the developer considers that it may be necessary to solve the problem.

5. Map to add the information that the developer considers relevant for solving the problem.

Unlike the previous field, here you can use **Serializable** objects with various information.

In addition to the above, the exceptions generated from `HttpBaseException` (focused on **web applications**) will also have a" **status** "field with the HttpStatus associated with the generated HTTP response:

        String errorName;
        int internalCode; (1)
        HttpStatus status;
        String shortMessage;
        String detailedMessage;
        Map mapExtendedMessage;

1. For these exceptions, if a value is not defined, this field will default to the value of the Http code associated with the exception.

### Error handlers and models

A series of **Santander Spring Boot** handlers have been implemented (`SantanderExceptionHandlerController` and `SantanderErrorAttributes` for Servlet,
and another `SantanderErrorAttributes` for Reactive) in charge of collecting all the exceptions and errors that are
thrown in the application and returning a response with **the structure of the error model configured** in the body and the **status corresponding to the error** found.

These handlers will use the `ErrorModelFactory` class to **generate the error model** of the response, being able to customize it from error properties files ([this functionality is detailed later](#customize-error-model-fields)).
This class is provided from the handlers a **map with the following structure**, which contains the information of the exception **from which to generate the error models**:

        String errorName; (1)
        int internalCode; (2)
        int status; (3)
        String shortMessage; (4)
        String detailedMessage; (5)
        Map mapExtendedMessage; (6)

1. **Name of the exception/error**, it corresponds to the field of the same name in the Santander Spring Boot exceptions or to the [values defined for the rest of the exceptions](#non-framework-exceptions-errorname).

2. **Internal code of the error**, it corresponds to the field of the same name in the Santander Spring Boot exceptions and the value "-1" for the rest.

3. **Http status code of the error handled**. **Non-Http** exceptions (such as GenericException, NullPointerException, etc.) will have the **HttpStatus.INTERNAL\_SERVER\_ERROR (500)** code associated with them.

4. **Reason for the error collected**, it corresponds to the field of the same name in the Santander Spring Boot exceptions and generated with information about the error for the rest.

5. **Detailed information on the error collected**, corresponds to the field of the same name in the Santander Spring Boot exceptions and generated with error information for the rest.

6. It corresponds to the field of the same name in the Santander Spring Boot exceptions, for the rest it will have no value.

It is possible to override / customize this base structure or the management for certain exceptions of these handlers, [later](#customize-management-for-controlled-exceptions) are these possible customizations.
Also, it is possible to write / create some instances of this structure using a builder: GenericException gde = GenericException.builder().someData(Data).build()

!!! tip "Caution"

    If the base structure is replaced in the handlers, it would also be necessary to [define a new error model](#replace-error-model) based on this structure, otherwise the configured error model could not be built correctly.

#### Error model

The error model defines the structure that the responses of the microservice will have when an exception has been thrown or an error occurs. By default,
the framework uses the **Santander Spring Boot error model (ErrorModelSantander)**, which uses the base structure
previously defined in the handlers adding some fields:

        {
         "appName": "String", (1)
         "timeStamp": "long", (2)
         "errorName": "String",
         "internalCode": "Integer",
         "status": "Integer",
         "shortMessage": "String",
         "detailedMessage": "String",
         "mapExtendedMessage": "Map"
        }

1. Name of the configured application ([How to define it](#application-name-for-exceptions)).

2. Time the exception was raised in milliseconds.

#### Gateway error model

The `ErrorModelGateway` class defines this error model to be able to process the errors emitted by a Santander Spring Boot Gateway.
When a microservice is **invoked through one of these Gateway** this will be the error model that we will receive, although **the
microservice internally will continue to use the Santander Spring Boot error model** seen above. The format is as follows:

      {
        "httpCode": "Integer",
        "httpMessage": "String",
        "moreInformation": "String"
      }

!!! note

    All the information can be found in the official documentation [Santander Spring Boot Gateway: Managing Errors](https://github.alm.europe.cloudcenter.corp/pages/sanes-santander-backend/gateway/#gestion-errores)

#### GLUON error model

The GLUON error model Format is used in GLUON microservices, and replaces the Santander Spring Boot Error model if:

- `santander.core.exceptions.error-format` property is set to `GLUON`.

OR

- [Santander Spring Boot Extended Error library](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/santander-project/santander-spring-boot-extended-error/) is in the project's classpath.

A *Builder* bean of the `GluonErrorModel` is configured to replace the {core-doc}#exceptions-scheme\[Santander Spring Boot error model\] in your exception handling:

    {
        "errors": [
            {
                "code": "String",
                "description": "String",
                "level": "String",
                "message": "String"
            }
        ]
    }

The Gluon error model constructs the error responses following the steps indicated in the [Replace Santander Spring Boot error model section](#replace-error-model) and according to the following:

    code -> String.valueOf(errorModelAttributes.get("status"))
    description -> errorModelAttributes.get("shortMessage")
    level -> "error"
    message -> "{timeStamp}-{errorModelAttributes.get("appName")}-{errorModelAttributes.get("errorName")}-{errorModelAttributes.get("detailedMessage")}"

In addition, the error model uses the `@CustomErrorModel` annotation, which allows **customising any of these fields** using the [customization from Santander Spring Boot error property files](#customize-error-model-fields).

An example of an error with its basic fields:

    {
        "errors": [
            {
                "code": "400",
                "description": "Account doesn't exist",
                "level": "error",
                "message": "1513268058750-exceptions-demo-account_doesnot_exist-The requested account was not found, maybe the account doesn't exist or the user have no access to it."
            }
        ]
    }

### Non-Framework Exceptions ErrorName

The errorName is a required field in Santander Spring Boot exceptions, not in the rest of the exceptions. In order to easily identify and customize some typical **non-Framework** web exceptions, their own **errorName** have been defined.
Below are the errorName for these exceptions in each type of web application.

#### ErrorName in Servlet applications

The relationship between exceptions handled in Servlet applications and their errorName is as follows:

| Exception                                                                                                                                                   | errorName                            |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|
| [MissingServletRequestParameterException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/bind/MissingServletRequestParameterException.html)                                         | missing_servlet_request_parameter    |
| [HttpMediaTypeNotSupportedException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/HttpMediaTypeNotSupportedException.html)                                                        | http_media_type_is_not_supported     |
| [HttpMediaTypeNotAcceptableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/HttpMediaTypeNotAcceptableException.html)                                                      | http_media_type_is_not_acceptable    |
| [MethodArgumentNotValidException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/bind/MethodArgumentNotValidException.html)                                                         | method_argument_not_valid_exception  |
| [HttpMessageNotReadableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/http/converter/HttpMessageNotReadableException.html)                                                   | http_message_not_readable_exception  |
| [HttpMessageNotWritableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/http/converter/HttpMessageNotWritableException.html)                                                   | http_message_not_writable_exception  |
| [NoHandlerFoundException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/servlet/NoHandlerFoundException.html)                                                                      | http_page_not_found_exception        |
| Other exceptions Spring MVC from [ResponseEntityExceptionHandler](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/servlet/mvc/method/annotation/ResponseEntityExceptionHandler.html) | http_internal_exception              |
| Other exceptions                                                                                                                                            | Complete name of the exception class |

The "Complete name" for other exceptions is the one generated by the ***getClass().getName()*** methods of the exception. For example, for the **NullPointerException → java.lang.NullPointerException** exception.

#### ErrorName for Reactive applications

The relationship between exceptions handled in Reactive applications and their errorName is as follows:

| Exception                                                                                                     | errorName                            |
|---------------------------------------------------------------------------------------------------------------|--------------------------------------|
| [UnsupportedMediaTypeStatusException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/UnsupportedMediaTypeStatusException.html) | http_media_type_is_not_supported     |
| [NotAcceptableStatusException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/NotAcceptableStatusException.html)               | http_media_type_is_not_acceptable    |
| Other exceptions                                                                                              | Complete name of the exception class |

The "Complete name" for other exceptions is the one generated by the ***getClass().getName()*** methods of the exception. For example, for the **NullPointerException → java.lang.NullPointerException** exception.

### Customize Error Model Fields

There is the possibility to customize the values of some fields from the configured Error Models using the error
configuration files (*errors.properties*):

- For **Santander Spring Boot Error Model** these fields are: **internalCode**, **shortMessage**, and **detailedMessage**.
- For **Gluon Error Model** you can customize **all fields** (code, description, level and message).

The **pattern** defined to look for these properties in the files is: ***errorName.fieldName***

For example, to customize some fields of a **BadRequestException** that would generate this response:

      {
        "errorName": "account_doesnot_exist",
        "internalCode": 400,
        "status": 400,
        "shortMessage": "Bad request",
        "detailedMessage": "The requested account was not found, maybe the account doesn't exist or the user have no access to it.",
        "mapExtendedMessage": {
          "accountId": "fooBar",
          "users": {
            "user": "userId1",
            "retries": 0
          }
        }
      }

We could define the following properties **for Santander Spring Boot Error Model**:

    # BadRequestException exception message
    account_doesnot_exist.shortMessage = Account doesn't exist
    account_doesnot_exist.internalCode = 1001

!!! tip "Caution"

    In versions prior to "Santander Spring Boot 3.0.0", the name of the property that allows modifying the "shortMessage" field was "message", therefore in these versions the previous configuration should be modified by:
    "account\_doesnot\_exist.message = Account doesn't exist ".

And the final answer will be:

      {
        "appName": "exceptions-demo",
        "timeStamp": 1513268058750,
        "errorName": "account_doesnot_exist",
        "internalCode": 1001,
        "status": 400,
        "shortMessage": "Account doesn't exist",
        "detailedMessage": "The requested account was not found, maybe the account doesn't exist or the user have no access to it.",
        "mapExtendedMessage": {
          "accountId": "fooBar",
          "users": {
            "user": "userId1",
            "retries": 0
          }
        }
      }

Or **for Gluon Error Model**:

    # BadRequestException exception message
    account_doesnot_exist.description = Account doesn't exist
    account_doesnot_exist.code = 1001

And the answer for this will be:

    {
    "errors": [
        {
            "code": "1001",
            "description": "Account doesn't exist",
            "level": "error",
            "message": "1513268058750-exceptions-demo-account_doesnot_exist-The requested account was not found, maybe the account doesn't exist or the user have no access to it."
        }
    ]
    }

!!! note "Error Model used in examples"

    All examples below about errors customization only includes Santander Spring Boot Error Model fields to simplify, but the same customizations
    can be applied using Gluon Error Model fields.

As we have seen in the [previous section](#non-framework-exceptions-errorname), **errorName has been defined for exceptions and errors other than Santander Spring Boot**, so we can also customize these cases.
For exceptions that do not have a specific errorName and **the fullname of the class** is used, in the properties files we must use this **errorName in lowercase and replacing the '.' for '\_'**.

For example, for **MissingServletRequestParameterException** (Servlet), **UnsupportedMediaTypeStatusException** (Reactive), or **NullPointerException** exceptions:

| Exception                               | ErrorName                         | ErrorName in the properties       |
|-----------------------------------------|-----------------------------------|-----------------------------------|
| MissingServletRequestParameterException | missing_servlet_request_parameter | missing_servlet_request_parameter |
| UnsupportedMediaTypeStatusException     | http_media_type_is_not_supported  | http_media_type_is_not_supported  |
| NullPointerException                    | java.lang.NullPointerException    | java_lang_nullpointerexception    |

Therefore, they would be customized:

    missing_servlet_request_parameter.shortMessage = Missing a request parameter
    missing_servlet_request_parameter.internalCode = 12

    http_media_type_is_not_supported.shortMessage = Media Type not supported in controller
    http_media_type_is_not_supported.internalCode = 14

    java_lang_nullpointerexception.shortMessage = Null object used
    java_lang_nullpointerexception.detailedMessage = Trying to use a null object

There is also the possibility of doing a **multi-channel and multi-entity customization** for these properties, indicating before the *errorName* **the channel and the entity** to which you want to associate. For example, to customize some of the
above exceptions for channel `INT` and `OFI`, and with a `0049` entity:

    INT.0049.account_doesnot_exist.shortMessage = Account doesn't exist for INT
    INT.0049.account_doesnot_exist.internalCode = 1001

    OFI.0049.account_doesnot_exist.shortMessage = Account doesn't exist for OFI
    OFI.0049.account_doesnot_exist.internalCode = 1002

    INT.0049.missing_servlet_request_parameter.internalCode = 101

    INT.0049.http_media_type_is_not_supported.internalCode = 103

!!! info "Important"

    For this channel-entity customization it is necessary to define **necessarily** both the channel and the entity.

#### Internationalize custom errors

It is an "extension" of the previous customization, being able **to customize the value of the error model fields depending on the language of the request**. For this, it will be necessary to create an error properties file for each supported
language with the format **_errors\_&lt;locale&gt;.properties_**, and place them in the **/errors** folder within the application resources (/src/main/resources). For example:

    _../src/main/resources/errors/errors_es_ES.properties # Spanish from Spain
    _../src/main/resources/errors/errors_en.properties # All English (EN-GB, EN-US...)

In this way we could personalize the messages depending on the language:

- errors\_es\_ES.properties

        INT.0049.account_doesnot_exist.shortMessage=No existe cuenta para INT
        INT.0049.account_doesnot_exist.internalCode=1001

        OFI.0049.account_doesnot_exist.shortMessage=No existe cuenta para OFI
        OFI.0049.account_doesnot_exist.internalCode=1002

- errors\_en.properties

        INT.0049.account_doesnot_exist.shortMessage = Account doesn't exist for INT
        INT.0049.account_doesnot_exist.internalCode = 1001

        OFI.0049.account_doesnot_exist.shortMessage = Account doesn't exist for OFI
        OFI.0049.account_doesnot_exist.internalCode = 1002

If you want to use a file other than `errors_*.properties` from the classpath you must add their path to the Spring Boot `spring.messages.basename` property.
This property supports several path separated by commas. You can load files directly from the file system with the prefix "file:" or from the classpath with the prefix "classpath:".

For example:

    spring.messages.basename=file:/data/i18n/messages,classpath:i18n/otherMessages

## Customize exception handling

There is the ability to **customize or replace various pieces of Santander Spring Boot's exception handling** to suit the needs of each project. The following are the possible customization cases:

### Replace error model

[As discussed](#error-model), the error model defines the **structure for error responses**. If we want the microservice to return another structure, modify field types or implement any other requirement, it is possible **to replace the
error model proposed by Santander Spring Boot (ErrorModelSantander)** with any other with minimal changes. For this we must do the following:

1. Create a POJO class with the structure of the new Error model. For example:

        public class ErrorModelExample {

            private int code;

            private String error;
        }

2. Create a *Builder* class for the above class that implements the `ErrorModelBuilder` interface, whose parameter is the type of the previous class:

        @JsonDeserialize(builder = ErrorModelExampleBuilder.class)
        @Builder
        public class ErrorModelExample {

            private int code;

            private String error;
        }

        @JsonPOJOBuilder(withPrefix = "")
        public class ErrorModelExampleBuilder implements ErrorModelBuilder<ErrorModelExample> {

            @Override
            public ErrorModelExample buildErrorModel(String appName, Map<String, Object> errorModelAttributes) {

                return builder().error(errorModelAttributes.get("errorName") + "-" + errorModelAttributes.get("shortMessage")).status((int) errorModelAttributes.get("status")).build();
            }
        }

The ***buildErrorModel*** method should indicate how to build the new error model from the given parameters: the **appName** for exceptions and a map with the **exception information** collected in the [Santander Spring Boot error handlers and
models](#error-handlers-and-models). For example, in this case we are generating the fields as follows: E

    "code" -> errorModelAttributes.get("status")
    "error" -> "{errorModelAttributes.get("errorName")}-{errorModelAttributes.get("shortMessage")}"

1. In a configuration class **annotated with @AutoConfigureBefore (CoreAutoConfig.class)**, create a *Bean* of the *Builder* class as follows:

        @Configuration
        @AutoConfigureBefore(CoreAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ErrorModelBuilder<ErrorModelExample> errorModelExample(){
                return ErrorModelExample.builder();
            }
        }

2. Additionally, if we want to be able **to customize the fields of the new model** from the error properties files ([Customize Santander Spring Boot Error Model Fields](#customize-error-model-fields)),
   we must add to the POJO class the annotation **@CustomErrorModel** and **define the *Setter*** methods of those fields that can be customized. If we use the annotation without parameters,
   all the fields will be customizable:

        @JsonDeserialize(builder = ErrorModelExampleBuilder.class)
        @Builder
        @CustomErrorModel
        @Setter
        public class ErrorModelExample {

            private int code;

            private String error;
        }

While with the **properties** parameter we can indicate which ones we want them to be. For example, so that only the "error" field can be customized:

    @JsonDeserialize(builder = ErrorModelExampleBuilder.class)
    @Builder
    @CustomErrorModel(properties = "error")
    public class ErrorModelExample {

        private int code;

        @Setter
        private String error;
    }

Equivalent to the [Customize Error Model Fields](#customize-error-model-fields) with the Santander Spring Boot error model, we could now customize the fields of the new model
**keeping the rest of the functionalities** (errorNames, customization by channel-entity and language, and so on):

- *errors.properties*

        account_doesnot_exist.error = Account doesn't exist
        INT.0049.account_doesnot_exist.error = Account doesn't exist channel-entity

- *errors\_en\_GB.properties*

        account_doesnot_exist.error = Account doesn't exist british

### Customize the search for error properties in files

As we have [seen previously](#customize-error-model-fields), there is the possibility of customizing the response fields from properties files according to the error model.
Of the [pieces that intervene in this functionality](#replace-error-model), we can substitute the class `SantanderErrorsPropertiesAccessor` (Santander Spring Boot's default implementation):
in charge of searching the properties and filtering by channel-entity and language using the information from the Context.

How to modify this piece will depend on whether we are going to use `Context` (or some of its content) to search/filter the error properties or not, and whether we want to override or extend the current behavior.

#### Override the behavior using the Context

If you want to replace the current behavior of this piece while maintaining the use of Context, we must follow the following steps:

1. Implement a `ErrorsPropertiesAccessor <Context>` with a constructor equivalent to **SantanderErrorsPropertiesAccessor** and define in the *getLiteralError* method the logic to access those properties:

        public class NewErrorsPropertiesAccessor implements SantanderErrorsPropertiesAccessor<Context> {

            public NewErrorsPropertiesAccessor(Environment environment, MessageSource messageSource) {
                this.environment = environment; (1)
                this.messageSource = messageSource; (2)
            }

            @Override
            public String getLiteralError(String errorProperty, Context context, (3)
                    List<String> placeHolders) { (4)
                Info info = context.getInfo();
                String propertyName = errorProperty;
                if (info != null && "DeviceA".equals(info.getDevice())) {
                    propertyName = info.getDevice() + "." + errorProperty;
                }
                /*
                    Try to get propertyName using environment or
                    messageSource (for locale Resource Bundle "errors")
                 */
            }
        }

    !!! info "Important"

        The **errorProperty** parameter will always be: "***errorName*.*errorModelProperty***". Being *errorModelProperty* the names of the customizable fields of the configured error model.

    1. The Environment interface bean allows us to search for properties in **files loaded by Spring** such as *errors.properties*.

    2. Santander Spring Boot exposes a MessageSource *bean* to look up the properties in the **Resource Bundle "errors" according to the language** (*errors\_en\_GB.properties*, *errors\_es\_ES.properties*, etc.).

    3. In this example, if the *device* of Info is "DeviceA" we will include it in the property name, so that properties can be defined as follows:

            {errorName}. {errorModelProperty} = Property value for other device
            DeviceA. {ErrorName}. {ErrorModelProperty} = Property value for DeviceA

    4. An array of arguments that will be filled in for params within the message (params look like "{0}", "{1,date}", "{2,time}" within a message in errors.properties. It is not necessary to use it.

2. In a configuration class **annotated with @AutoConfigureBefore (CoreAutoConfig.class)**, create a *Bean* of type `BiFunction`:

        @Configuration
        @AutoConfigureBefore(CoreAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ErrorsPropertiesAccessor<Context> newErrorsPropertiesAccessor(Environment environment, MessageSource messageSource){
                return new NewErrorsPropertiesAccessor(environment, messageSource);
            }
        }

#### Extend the behavior using the Context

If what you want is to extend the current behavior of this piece to **add another type of search/filter**, keeping the use of Context, we must follow the following steps:

1. Extend the `SantanderErrorPropertiesAccessor` class with a constructor that invokes the one of this class and define in the *getLiteralError* method the new logic that extends the current behavior:

        public class NewErrorsPropertiesAccessor extends SantanderErrorsPropertiesAccessor {

            private AccessorService accessorService;

            public NewErrorsPropertiesAccessor(Environment environment, MessageSource messageSource, AccessorService accessorService) {
                super(environment, messageSource);
                this.accessorService = accessorService; (1)
            }

            @Override
            public String getLiteralError(String errorProperty, Context context, List<String> placeHolders) {
                String result = accessorService.findProperty(errorProperty); (2)
                if (result == null) {
                    Info info = context.getInfo();
                    result = environment.getProperty(info.getDevice() + "." + errorProperty); (3)
                    if (result == null) {
                        result = super.apply(errorProperty, context, placeHolders); (4)
                    }
                }
                return result;
            }
        }

    !!! info "Important"

        The **errorProperty** parameter will always be: "***errorName*.*errorModelProperty***". Being *errorModelProperty* the names of the customizable fields of the configured error model.

    1. In addition to invoking the SantanderErrorsPropertiesAccessor constructor we can add the necessary objects for the new logic, in this example we add an object of a class "**AccessorService**".

    2. We use a *findProperty()* method of the invented class to try to resolve the property.

    3. We can also make use of the objects used by the ErrorPropertiesAccessor (Environment and MessageSource) to add new filter or search logic,
        in this case to search for the property by adding the *device* field of the Info at the
        beginning of it.

    4. Finally, if the new logic has not provided us with a value for that property, we execute the [original logic of the ErrorPropertiesAccessor](#customize-error-model-fields).

        !!! note

            If we want to prioritize the original logic of the ErrorPropertiesAccessor, we can change the order and execute its *apply()* method elsewhere in the new method. If the original method cannot resolve the
            property, it will return a *null* value.

2. In a configuration class **annotated with @AutoConfigureBefore (CoreAutoConfig.class)**, create a *Bean* of type `ErrorsPropertiesAccessor`:

        @Configuration
        @AutoConfigureBefore(CoreAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ErrorsPropertiesAccessor<Context> newErrorsPropertiesAccessor(Environment environment, MessageSource messageSource){
                return new NewErrorsPropertiesAccessor(environment, messageSource);
            }
        }

#### Substitute behavior using other information

If instead of using the information from Context to search/filter in the properties, we want to use the information contained in **a new type "NewInfo"**, some steps will be added/modified with respect to the previous case:

1. Implement a **SantanderErrorsPropertiesAccessor&lt;NewInfo&gt;** and define in the *getLiteralError* method the logic to access those properties::

        public class NewErrorsPropertiesAccessor implements SantanderErrorsPropertiesAccessor<NewInfo> {

            public NewErrorsPropertiesAccessor(Environment environment, MessageSource messageSource) {
                this.environment = environment; (1)
                this.messageSource = messageSource; (2)
            }

            @Override
            public String getLiteralError(String errorProperty, NewInfo newInfo, List<String> placeHolders) { (3)
                String propertyName = errorProperty;
                if ("foo".equals(newInfo.getFlag())){
                    propertyName = newInfo.getFlag() + "." + errorProperty;
                }
                /*
                    Try to get propertyName using environment or
                    messageSource (for locale Resource Bundle "errors")
                 */
            }
        }

    !!! info "Important"

        The **errorProperty** parameter will always be: "***errorName*.*errorModelProperty***". Being *errorModelProperty* the names of the customizable fields of the configured error model.

    1. The Environment interface bean allows us to search for properties in **files loaded by Spring** such as *errors.properties*.

    2. Santander Spring Boot exposes a MessageSource *bean* to look up the properties in the **Resource Bundle "errors" according to the language** (*errors\_en\_GB.properties*, *errors\_es\_ES.properties*, etc.).

    3. In this example, if the *flag* field of the new NewInfo type is "foo" we will include it in the property name, so that properties can be defined as follows:

            {errorName}.{errorModelProperty} = Property value for other flag
            foo. {errorName}.{errorModelProperty} = Property value for foo

    4. An array of arguments that will be filled in for params within the message (params look like "{0}", "{1,date}", "{2,time}" within a message in errors.properties. It is not necessary to use it.

2. In a configuration class **annotated with @AutoConfigureBefore (CoreAutoConfig.class)**,
   we will create the *Bean* of type `SantanderErrorsPropertiesAccessor`.In addition,
   a *Bean* called **errorAttributesContext** capable of generating an object of type "NewInfo" must be created.
   The type of this *Bean* will depend on the type of web application:

    1. **Servlet Applications**: this *Bean* will have to be of type `Supplier <NewInfo>` and the class in which it will be created should be **annotated with @AutoConfigureBefore (CoreServletAutoConfig.class)**:

            @Configuration
            @AutoConfigureBefore({CoreAutoConfig.class, CoreServletAutoConfig.class})
            public class ExampleAutoConfiguration {

                @Bean
                public ErrorsPropertiesAccessor<NewInfo> newErrorsPropertiesAccessor(Environment environment, MessageSource messageSource){
                    return new NewErrorsPropertiesAccessor(environment, messageSource);
                }

                @Bean
                public Supplier<NewInfo> errorAttributesContext(){
                    return () -> //Supplier code return NewInfo
                }
            }

    2. **Reactive Applications**: this *Bean* will have to be of type `Function <ServerRequest, NewInfo>` (the ServerRequest type parameter is the request in which the exception was generated) and the class in which it will be generated should be
        **annotated with @AutoConfigureBefore (CoreReactiveAutoConfig.class)**:

            @Configuration
            @AutoConfigureBefore({CoreAutoConfig.class, CoreReactiveAutoConfig.class})
            public class ExampleAutoConfiguration {

                @Bean
                public ErrorsPropertiesAccessor<NewInfo> newErrorsPropertiesAccessor(Environment environment, MessageSource messageSource){
                    return new NewErrorsPropertiesAccessor(environment, messageSource);
                }

                @Bean
                public Function<ServerRequest, NewInfo> errorAttributesContext(){
                    return (ServerRequest request) -> //Function code return NewInfo
                }
            }

!!! tip "Caution"

    The execution of this Function (in ErrorAttributes) is not carried out as a continuation of the application's filter chain, so **we will not have the information that has been subscribed to the reactive context** in
    them or during the execution of the application logic. Instead, **we will have the original request** to form the object if necessary.

### Customize management for controlled exceptions

In the [Santander Spring Boot error handlers and models](#error-handlers-and-models) **a specific handling is carried out for certain exceptions handled** (in addition to the GenericException themselves)
by defining specific values in the base structure of the error models: [Non-Framework Exceptions ErrorName](#non-framework-exceptions-errorname), internalCode, shortMessage, and detailedMessage.
It is possible **to modify the default behavior for these exceptions** in order to generate/define that content in another way before passing it to the error model.

#### Customize exceptions handled in Servlet

The piece in charge of handling these exceptions in Servlet applications is `SantanderExceptionHandlerController`, to modify its behavior:

1. We extend this class and replicate its constructor:

        public class ExampleExceptionHandlerController<T, S> extends SantanderExceptionHandlerController<T, S> {

            public ExampleExceptionHandlerController(ErrorModelFactory<T, S> errorModelFactory,
                    Supplier<S> errorAttributesContext) {
                super(errorModelFactory, errorAttributesContext);
            }
        }

    !!! info "Important"

        We can add to the class and the constructor whatever we need for the new implementation, but we must always call the constructor of the extended class first.

2. We override the methods of the exceptions that we want to modify. The relationship between handled exceptions and methods is as follows:

   | Exception                                                                                                                                                                                                               | Method                                 |
   |-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
   | [GenericException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/GenericBootException.html)               | *handleGenericException*         |
   | [MissingServletRequestParameterException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/bind/MissingServletRequestParameterException.html)                                    | *handleMissingServletRequestParameter* |
   | [HttpMediaTypeNotSupportedException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/HttpMediaTypeNotSupportedException.html)                                                   | *handleHttpMediaTypeNotSupported*      |
   | [HttpMediaTypeNotAcceptableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/HttpMediaTypeNotAcceptableException.html)                                                 | *handleHttpMediaTypeNotAcceptable*     |
   | [MethodArgumentNotValidException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/bind/MethodArgumentNotValidException.html)                                                    | *handleMethodArgumentNotValid*         |
   | [HttpMessageNotReadableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/http/converter/HttpMessageNotReadableException.html)                                              | *handleHttpMessageNotReadable*         |
   | [HttpMessageNotWritableException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/http/converter/HttpMessageNotWritableException.html)                                              | *handleHttpMessageNotWritable*         |
   | [NoHandlerFoundException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/servlet/NoHandlerFoundException.html)                                                                 | *handleNoHandlerFoundException*        |
   | Other Spring MVC exceptions [ResponseEntityExceptionHandler](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/servlet/mvc/method/annotation/ResponseEntityExceptionHandler.html) | *handleExceptionInternal*              |
   | Other exceptions                                                                                                                                                                                                        | *handleException*                      |  

For example, if we want to customize the behavior for **MissingServletRequestParameterException** exceptions:

    public class ExampleExceptionHandlerController<T, S> extends SantanderExceptionHandlerController<T, S> {

        // Constructor

        @Override
        public ResponseEntity<Object> handleMissingServletRequestParameter(MissingServletRequestParameterException ex, HttpHeaders headers, HttpStatus status, WebRequest request) {
            String errorName = "missing_servlet_request_parameter";

            String shortMessage = "Missing Request Parameter in Controller";
            String detailedMessage = "Missing request param: " + ex.getParameterName();

            Map<String, Object> errorModelAttributes = new HashMap<>();
            errorModelAttributes.put("errorName", errorName);
            errorModelAttributes.put("internalCode", 23);
            errorModelAttributes.put("shortMessage", shortMessage);
            errorModelAttributes.put("detailedMessage", detailedMessage);
            errorModelAttributes.put("status", status.value());

            // Create configured error model using errorModelFactory
            T errorModel = errorModelFactory.getErrorModel(errorModelAttributes, errorAttributesContext.get());

            return ResponseEntity.status(status).body(errorModel);
        }
    }

In this proposed customization, the base structure of the [Santander Spring Boot error handlers and models](#error-handlers-and-models) has been used to be used by the Santander Spring Boot error model:
**keeping the errorName** and defining **new values for the shortMessage, detailedMessage and internalCode** in a map to generate the error model with the class `ErrorModelFactory`.
The content of the **errorAttributesContext** is also passed to it for the [customization of the error model from properties files](#customize-error-model-fields).

1. Finally, we create in a configuration class **annotated with @AutoConfigureBefore(CoreServletAutoConfig.class)** a *Bean* of the new exception handler:

        @Configuration
        @AutoConfigureBefore(CoreServletAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ExceptionHandlerController exampleExceptionHandlerController(ErrorModelFactory<?, ?> errorModelFactory, Supplier<?> errorAttributesContext){
                return new ExampleExceptionHandlerController(errorModelFactory, errorAttributesContext);
            }
        }

In Servlet applications, error cases can be generated that do not come directly from the throwing of an exception, for example: **when there is no handler for the request endpoint** or when **the *sendError* method of HttpServletResponse** is used.
For these cases there is a Santander Spring Boot implementation of **ErrorAttribute** (`SantanderErrorAttributes`) that manages the responses to these errors.

It is also possible to override the default behavior in these cases in order to modify the way of generating the data that will be passed to the error model:

1. We extend the class and replicate its constructor:

        public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

            public ExampleErrorAttributes(ErrorModelFactory<T, S> errorModelFactory, Supplier<S> errorAttributesContext) {
                super(errorModelFactory, errorAttributesContext);
            }
        }

    !!! note

        We can add to the class and to the constructor what we need for the new code that we are going to implement, but we must always call the constructor of the extended class first.

2. We override the ***fromDefaultErrorAttributes*** method. This method is executed after having executed the Spring solution in
    [DefaultErrorAttributes](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/web/servlet/error/DefaultErrorAttributes.html), with the idea of reusing the content of its response (map "defaultErrorAttributes") and the
    Throwable to form our error model.

        public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

            // Constructor

            @Override
            protected T fromDefaultErrorAttributes(Map<String, Object> defaultErrorAttributes, Throwable throwable) {

                String shortMessage = "ErrorAttributes controlled error";

                Map<String, Object> errorModelAttributes = new HashMap<>();
                errorModelAttributes.put("errorName", defaultErrorAttributes.get("exception"));
                errorModelAttributes.put("internalCode", 11);
                errorModelAttributes.put("shortMessage", shortMessage);
                errorModelAttributes.put("detailedMessage", defaultErrorAttributes.get("message"));
                errorModelAttributes.put("status", defaultErrorAttributes.get("status"));

                return errorModelFactory.getErrorModel(errorModelAttributes, errorAttributesContext.get());
            }
        }

In this example again we have kept the base structure defined in the [Santander Spring Boot error handlers and models](#error-handlers-and-models), assigned some **fixed values** (internalCode and shortMessage)
and others we have removed from the map **defaultErrorAttributes** (errorName, status and detailedMessage) to generate an error model with the `ErrorModelFactory` class.
The content of the **errorAttributesContext** is also passed to it for the [customization of the error model from properties files](#customize-error-model-fields).

1. Finally, we create in a configuration class **annotated with @AutoConfigureBefore (CoreServletAutoConfig.class)** a *Bean* of the new ErrorAttributes:

        @Configuration
        @AutoConfigureBefore(CoreServletAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ErrorAttributes exampleErrorAttributes(ErrorModelFactory<?, ?> errorModelFactory, Supplier<?> errorAttributesContext){
                return new ExampleErrorAttributes(errorModelFactory, errorAttributesContext);
            }
        }

#### Customize exceptions handled in Reactive

The piece in charge of handling **all the exceptions and errors** in Reactive applications is `SantanderErrorAttributes`, to modify its behavior:

1. We extend this class and replicate its constructor:

        public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

            public ExampleErrorAttributes(ErrorModelFactory<T, S> errorModelFactory, Function<ServerRequest, S> errorAttributesContext) {
                super(errorModelFactory, errorAttributesContext);
            }
        }

    !!! note

        We can add to the class and to the constructor whatever we need for the new code that we are going to implement, but we must always first call the constructor of the extended class with its parameters.

2. We override the methods of the exceptions that we want to modify. The relationship between handled exceptions and methods is as follows:

   | Exception                                                                                                                                                                                                 | Method                                      |
   |-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
   | [GenericException](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/exceptions/GenericBootException.html) | *handleGenericException*              |
   | [UnsupportedMediaTypeStatusException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/UnsupportedMediaTypeStatusException.html)                            | *handleUnsupportedMediaTypeStatusException* |
   | [NotAcceptableStatusException](https://docs.spring.io/spring-framework/docs/6.2.11/javadoc-api/org/springframework/web/server/NotAcceptableStatusException.html)                                          | *handleNotAcceptableStatusException*        |
   | Other errors and exceptions                                                                                                                                                                               | *fromDefaultErrorAttributes*                |

For example, if we want to customize the behavior for **NotAcceptableStatusException** exceptions:

    public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

        // Constructor

        @Override
        public T handleNotAcceptableStatusException(NotAcceptableStatusException ex, ServerRequest request) {

            String errorName = "http_media_type_is_not_acceptable";
            String detailedMessage = "Media types accepted: " + ex.getSupportedMediaTypes();

            Map<String, Object> errorModelAttributes = new HashMap<>();
            errorModelAttributes.put("errorName", errorName);
            errorModelAttributes.put("internalCode", 15);
            errorModelAttributes.put("shortMessage", "Media Type Not Accepted");
            errorModelAttributes.put("detailedMessage", detailedMessage);
            errorModelAttributes.put("status", ex.getStatus().value());

            // Create configured error model using errorModelFactory
            return errorModelFactory.getErrorModel(errorModelAttributes, errorAttributesContext.apply(request));
        }
    }

In this proposed customization, the base structure defined in the [Santander Spring Boot error handlers and models](#error-handlers-and-models) has been used:
using the same **errorName**, but defining new values for the **shortMessage, detailedMessage and internalCode** in a map to generate the error model using the `ErrorModelFactory` class.
It is also passed the result of executing the **errorAttributesContext** with the current request for the [customization of the error model from properties files](#customize-error-model-fields).

The case of the ***fromDefaultErrorAttributes*** method is different from the rest, since this method is executed after executing the Spring solution in
[DefaultErrorAttributes](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/web/servlet/error/DefaultErrorAttributes.html), with the idea of reusing the content of your response (map "defaultErrorAttributes") and the
Throwable to form our error model.

    public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

        // Constructor

        @Override
        protected T fromDefaultErrorAttributes(Map<String, Object> defaultErrorAttributes, ServerRequest request, Throwable error) {

            String errorName = defaultErrorAttributes.get("exception");
            int status = defaultErrorAttributes.get("status");
            int internalCode = 11;
            String shortMessage = "ErrorAttributes controlled error";
            String detailedMessage = defaultErrorAttributes.get("message");


            return errorModelFactory.getErrorModel(
                    new HttpBaseException(errorName, status, internalCode, shortMessage, detailedMessage),
                    errorAttributesContext.apply(request));
        }
    }

In this example we have assigned some **fixed values** (internalCode and shortMessage) and others we have removed from the map **defaultErrorAttributes**
(errorName, status and detailedMessage) to create an HttpBaseException object and
generate an error model with the class `ErrorModelFactory`.
This class is also passed the result of executing the **errorAttributesContext** with the current request for the [customization of the error model from properties files](#customize-error-model-fields).

1. Finally, we create in a configuration class **annotated with @AutoConfigureBefore (CoreReactiveAutoConfig.class)** a *Bean* of the new ErrorAttributes:

        @Configuration
        @AutoConfigureBefore(CoreReactiveAutoConfig.class)
        public class ExampleAutoConfiguration {

            @Bean
            public ErrorAttributes exampleErrorAttributes(ErrorModelFactory<?, ?> errorModelFactory, Function<ServerRequest, ?> errorAttributesContext){
                return new ExampleErrorAttributes(errorModelFactory, errorAttributesContext);
            }
        }

!!! note

        By default, exception handling uses application/json in order to determine the response media type for the ErrorModel Object.
        Set specify desired representation type for the ErrorModel Object by modify the santander.core.exceptions.response-content-type properties establishing their own custom representation media type.

### Add new handled exceptions

If instead of [modifying the management of any of the controlled exceptions](#customize-management-for-controlled-exceptions) as was the previous case,
you want to add the management to a new controlled exception **to generate/predefine the content of the response**, we can also do it by overwriting the Santander Spring Boot exception handling handlers and adding new cases.

#### Add a handled exception in Servlet

To add a new exception handled in a Servlet application we must extend the class `SantanderExceptionHandlerController` in the same way as in [Customize exceptions handled in Servlet](#customize-exceptions-handled-in-servlet),
but this time we will have to add a method with the annotation **@ExceptionHandler** indicating the exception that we want to handle.

For example, if we want to give a special behavior for a **NewApplicationException** own exception, the resulting class would be the following:

    public class ExampleExceptionHandlerController<T, S> extends SantanderExceptionHandlerController<T, S> {

        // Constructor

        @ExceptionHandler(NewApplicationException.class)
        public ResponseEntity<Object> handleNewApplicationException(NewApplicationException exception) {

            HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

            Map<String, Object> errorModelAttributes = new HashMap<>();
            errorModelAttributes.put("errorName", "application_exception");
            errorModelAttributes.put("internalCode", -1);
            errorModelAttributes.put("shortMessage", "Application exception launched");
            errorModelAttributes.put("detailedMessage", exception.getLocalizedMessage());
            errorModelAttributes.put("status", status.value());

            // Create configured error model using errorModelFactory
            T errorModel = errorModelFactory.getErrorModel(errorModelAttributes, errorAttributesContext.get());

            return ResponseEntity.status(status).body(errorModel);
        }
    }

!!! info "Important"

    The @ExceptionHandler annotation will catch any exceptions of type NewApplicationException **and any exceptions that extend from it**.

As in previous examples, the structure defined in the [Santander Spring Boot error handlers and models](#error-handlers-and-models) has been maintained, defining an errorName, internalCode, status and shortMessage **default**,
and assigning the detailedMessage the value of the *getLocalizedMessage()* method. We have collected this information in a map and we have generated the error model using the class `ErrorModelFactory` passing it
the content of the errorAttributesContext for the [customization of Error Model Fields](#customize-error-model-fields). With this object and the previously defined status we create the ResponseEntity of the controller.

#### Add a handled exception in Reactive

To add a new exception handled in a Reactive application we must extend the class `SantanderErrorAttributes` in the same way as in [Customize exceptions handled in Reactive](#customize-exceptions-handled-in-reactive),
but in that case we will do the following:

1. Override the **main method for handled exceptions** (*fromManagedExceptions*).

2. Add with an *if* **the case of the new exception** and generate the **map with the necessary information**.

3. Add with an *else* the execution of the original method **so as not to lose the handling of the exceptions handled by default**.

For example, if we want to give a special behavior for the **NewApplicationException** exception, the resulting class would be the following:

    public class ExampleErrorAttributes<T, S> extends SantanderErrorAttributes<T, S> {

        // Constructor

        @Override
        protected Map<String, Object> fromManagedExceptions(Throwable error, ServerRequest request) {
            if (error instanceof NewApplicationException) {

                HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

                Map<String, Object> errorModelAttributes = new HashMap<>(); (1)
                errorModelAttributes.put("errorName", "application_exception");
                errorModelAttributes.put("internalCode", -1);
                errorModelAttributes.put("shortMessage", "Application exception launched");
                errorModelAttributes.put("detailedMessage", exception.getLocalizedMessage());
                errorModelAttributes.put("status", status.value());

                T errorModel = errorModelFactory.getErrorModel(errorModelAttributes, errorAttributesContext.apply(request)); (2)

                Map<String, Object> managedErrorAttributes = objectMapper.convertValue(errorModel, Map.class); (3)

                // And put one extra field to get response status
                managedErrorAttributes.put(RESPONSE_STATUS_KEY, status.value()); (4)
                return managedErrorAttributes;
            }
            else {
                return super.fromManagedExceptions(error, request); (5)
            }
        }
    }

!!! info "Important"

    The **instanceof** operator will validate any exception of type NewApplicationException **and the exceptions that extend from this**.

In this example we have:

1. Defined an errorName, internalCode and shortMessage **default**, and assigned to the detailedMessage the value of the *getLocalizedMessage()* method, following the structure defined in the [Santander Spring Boot error handlers and
    models](#error-handlers-and-models).

2. Generated an error model with the class `ErrorModelFactory`, passing it the result of executing the errorAttributesContext with the current request for the [customization of Error Model Fields](#customize-error-model-fields).

3. Converted the error model to a map with the **objectMapper** object that we have.

4. We add a field `RESPONSE_STATUS_KEY` **(mandatory to define the response status)** to the map with the value of the previously defined status (HttpStatus.INTERNAL\_SERVER\_ERROR).

5. If it wasn't the new exception handled, we just **called the default method** and returned its result.

## Propagation Headers

This feature is in charge of propagating headers in outgoing requests, whether they are HTTP or HTTPS. With this feature we allow us to Enable/Disable the Santander Headers. We propagate the following headers by default:

- <span id="logging-headers"></span>**Logging**:

    - Contact-Point

- <span id="security-headers"></span>**Security**:

    - X-Control-Operativo
    - X-Santander-OC
    - Authorization
    - BKS-Token

- <span id="common-headers"></span>**Common**:

    - X-Santander-Channel
    - organization
    - X-Santander-ThirdParty
    - X-Santander-Device
    - Session-Id
    - X-ClientId
    - app-init
    - mode
    - Accept-Language
    - x-santander-client-id
    - x-ibm-client-id
    - X-API-Key
    - X-Appkey
    - X-TraceId
    - X-EncryptedObject

For more information on headers and their functionality visit [here](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/24272994492/Enriched+Communication+Policy)

In addition, an array of exclusions is provided, which excludes the propagation of headers at the path level,
this array contains an object with the following properties:

- **endpoint**: Host to exclude, can be excluded **at a general level** (Exclude all suffixes ..test/) or an **atomic level**

- **logging**: **true** to exclude "logging" headers seen previously.

- **security**: **true** to exclude "security" headers seen previously.

- **common**: **true** to exclude "common" headers seen previously.

Configuration example

    santander:
        core:
            headers:
              enabled: true # Enable/disable propagation headers
              exclude:
                - endpoint: "https://some.api/v1/test"
                  common: true
                  logging: true
                  security: false

In this example, if we make a http request to the endpoint, common and logging headers will not be propagated.
Only security headers will be propagated.

## Library use cases

### How to use the Bean ObjectMapper

The core library exposes a bean of this class so that it can be used at any point in a microservice. To access this `Bean` we should use the
`Qualifier` qualifier and ensure that we refer to the `Bean` provided by `Santander Spring Boot`. For example:

        public DemoController(@SantanderQualifier ObjectMapper objectMapper) { (1)
           this.objectMapper = objectMapper;
        }

        public void someMethod(){
            String json = "{ \"name\" : \"Jhon\", \"surname\" : \"Doe\" }";
            Person person = objectMapper.readValue(json, Person.class);  (2)
        }

1. We inject the `ObjectMapper` bean into the component in which we are going to use it.

2. With the readValue method we convert the json string into an instance of the `Person` class.

### How to use the Bean RestTemplate

To use a `RestTemplate` with all the [features provided by Santander Spring Boot](#resttemplate) we just need to inject a `RestTemplateBuilder` bean
in our application and build a `RestTemplate` with it:

```java
private final RestTemplate restTemplate;

public DemoService(RestTemplateBuilder restTemplateBuilder) {
    this.restTemplate = restTemplateBuilder.build();
}

public String someMethod(){
    String fooResourceUrl = "http://anyHost:8080/anyService/";
    return restTemplate.getForObject(fooResourceUrl + "/anyEndpoint", String.class);
}
```

This `RestTemplate` has an interceptor included by default to propagate the `Info` object that is retrieved from the **Context** in HTTP headers.

!!! info "Important"

    Each `Santander Spring Boot` library may include its own interceptors in order to enrich the information sent between microservices.

### How to use the RestClient

To use a `RestClient` with all the [features provided by Santander Spring Boot](#restclient) we just need to inject a `RestClient.Builder` bean
in our application and build a `RestClient` with it:

```java
private final RestClient restClient;

public DemoService(RestClient.Builder restClientBuilder) {
    this.restClient = restClientBuilder.baseUrl("http://anyHost:8080/anyService/").build();
}

public String someMethod(){
    return restClient.get("/anyEndpoint").retrieve().body(String.class);
}
```

<!-- TODO: complete with custom configuration as WebClient?  -->

### How to use the WebClient.Builder

`Spring Boot` provides by default `Beans` of type `WebClient.Builder` which implies that `Santander Spring Boot`  does not create them, it simply pre-configures them for the application.
The functionalities that are added are:

- Timeout associated with the connection, as well as properties associated with the connection pool according to the values defined in the properties `santander.core.webclient.**`

- Interceptors `ContextFilterFunction` of type `ExchangeFilterFunction` in charge of propagating the object **Info** of the Context in HTTP headers.

To make use of the `Beans` of type `WebClient.Builder`  we must follow the [official documentation](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/io.html#io.rest-client.webclient).
Therefore, to invoke a microservice located at the endpoint `http://localhost:8080/foo` we could do:

```java
private final WebClient webClient;

public HelloController(WebClient.Builder webClientBuilder) {
    this.webClient = webClientBuilder.baseUrl("http://localhost:8080").build();
}

@GetMapping("/foo")
public Mono<String> someMethod() {
    return this.webClient.get().uri("/foo").retrieve().bodyToMono(String.class);
}
```

!!! info "Important"

    Whenever possible, it is recommended to instantiate `WebClient` from `WebClient.Builder`. The `WebClient.Builder` instances are stateful: any change in the `builder` is reflected in all `webClient` created from said
    `builder`, this allows `Spring Boot` to configure a `WebClient.Builder` with a series of `HTTP` resources, codecs, etc. that can be shared by all `WebClients` and make more efficient use of them.

#### Timeouts Settings

All the `Beans` of type `WebClient.Builder` that we inject into the application will have by default the timeouts set in the `santander.core.webclient.**` properties. This will be valid for most use cases, but it is true that there will be occasions
where these defaults are not enough so we will have to customize the connections depending on the backend we want to invoke. Here is an example of how to customize the timeouts associated with a `WebClient.Builder`.

        public void customize(WebClient.Builder webClientBuilder) {
            ConnectionProvider.Builder connPro = ConnectionProvider.builder("custom");
            HttpClient httpClient = HttpClient.create(connPro.build()) (1)
            // Connection Timeout
            .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 15000)
            .doOnConnected((Connection connection) -> connection
                    // Read Timeout
                    .addHandlerLast(
                            new ReadTimeoutHandler(15000, TimeUnit.MILLISECONDS))
                    // Write Timeout
                    .addHandlerLast(
                            new WriteTimeoutHandler(15000, TimeUnit.MILLISECONDS)));
             webClientBuilder.baseUrl("http://localhost:8080")
                        .clientConnector(new ReactorClientHttpConnector(httpClient)); (2)
             WebClient webClient = webClientBuilder.build(); (3)
        }

1. We create an object of type `reactor.netty.http.client.HttpClient` with the timeouts that are considered appropriate. We provide a `ConnectionProvider` in order to use a default configuration for the pool of the connections, this it is necessary
    because the default constructor of `HttpClient` doesn't create a pool by default.

2. We modify the `Builder` connector to make use of the new `HttpClient`.

3. We create as many `WebClient` as we need. All of them will share the timeouts defined in the `HttpClient` object.

Another option is to reuse an existing `WebClient.Builder` that we have previously configured and where we only want to alter the configuration of the timeouts. For this we would do the following:

        builderOrigin.baseUrl("http://foo_builder1").defaultHeader("header", "foo"); (1)
        WebClient.Builder newBuilder =  builderOrigin.clone(); (2)
        HttpClient httpClient = HttpClient.create() (3)
        .(...)

1. builderOrigin represents a previously configured `WebClient.Builder` from which we want to create the new `WebClient.Builder`.

2. We clone the original `WebClient.Builder` to retrieve a new instance of `WebClient.Builder`.

3. We follow the same steps detailed in the previous point.

!!! info "Important"

    It is important to note that when creating an object of type `ReactorClientHttpConnector` from an `HttpClient` where only timeouts are established and the connection pool is not configured, this it happens because the default
    constructor of `HttpClient` doesn't create a pool by default. Therefore, if the project had defined the santander.core.webclient.max-connections property with a value of 250, the `WebClient.Builder` won't be configured with a pool of connections. For
    this specific case, it is advisable to complete the timeouts configuration and to establish a number of connections with a connection pool as described in point [Connection pool configuration](#connection-pool-configuration). If, on the other
    hand, the project did not define this property, it would be necessary to provide a `ConnectionProvider` in order to set a pool with default configuration of `Netty`, that is, size according to the number of availability processors.

#### Connection pool configuration

As in the previous point, all the `Beans` of type `WebClient.Builder` that we inject into the application will have by default a connection pool with the size defined by the `santander.core.webclient.max-connections` property. . This will be valid for
most use cases, but there will be occasions where these defaults are not enough so we will have to customize the pool based on the backend we want to invoke. Below is an example of how to customize the connection pool associated with a
`WebClient.Builder` together with the timeouts configuration detailed in the previous point.

        public void customize(WebClient.Builder webClientBuilder) {
           HttpClient httpClient = HttpClient.create(ConnectionProvider.builder("santanderFixedPool") // (1)
                                    .maxConnections(250)
                                    .pendingAcquireTimeout(30000)
                                    .build())
                                    .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 15000) // Connection Timeout (2)
                                    .doOnConnected((Connection connection) -> connection
                                            // Read Timeout
                                            .addHandlerLast(
                                                    new ReadTimeoutHandler(15000, TimeUnit.MILLISECONDS))
                                            // Write Timeout
                                            .addHandlerLast(
                                                    new WriteTimeoutHandler(15000, TimeUnit.MILLISECONDS)));
             webClientBuilder.baseUrl("http://localhost:8080")
                        .clientConnector(new ReactorClientHttpConnector(httpClient)); // (3)
             WebClient webClient = webClientBuilder.build(); // (4)
        }

1. We create an object of type `reactor.netty.http.client.HttpClient` passing the configuration of the new pool to the constructor, in this case with size 250 and connection acquisition timeout of 30 seconds.

2. We customize `HttpClient` with the timeouts that we consider appropriate.

3. We modify the `Builder` connector to make use of the new\` HttpClient\`.

4. We create as many `WebClient` as we need. All of them will share the pool and timeouts defined in the `HttpClient` object.

#### Configuration of new interceptors

Santander Spring Boot **configures for all Beans of type `WebClient.Builder` and/or `WebClient`** a set of interceptors of type `ExchangeFilterFunction` that allow setting `HTTP` headers in invocations between microservices.
The headers that are established will
depend on the `Santander Spring Boot Starters` that we have associated with the project, for example, if we have the authentication starter,
the headers will be added with the user's authentication token, the logging starter adds information for the management of
traces such as tracing headers, etc.

There will be times when the project needs to create new interceptors to add functionality in the invocations, or simply modify the original interceptors list and remove the ones that are not of interest, also remember that the project could set the
`santander.core property. webclient.enabled = false` to disable the autoconfiguration of `Santander Spring Boot` and later add the interceptors that you need either for project requirements, creation of unit tests, etc.

Here is an example to add an interceptor to a `WebClient.Builder` and/or `WebClient`:

        WebClient otherWebClient = webClient.mutate().filters(addFilterFunctionIfNotPresent(new MyFilterFunction())).build(); (1)
        WebClient.Builder otherWebClientBuilder = webClientBuilder.filters(addFilterFunctionIfNotPresent(new MyFilterFunction())).build(); (2)

        private Consumer<List<ExchangeFilterFunction>> addFilterFunctionIfNotPresent( (3)
                ExchangeFilterFunction... filterFunctions) {
            return functions -> Arrays.stream(filterFunctions).forEach((ExchangeFilterFunction function) -> {
                if (function != null && functions.stream().noneMatch(f -> f.equals(function))) {
                    functions.add(function);
                }
            });
        }

1. In the case of having a `WebClient` (whether or not it contains other interceptors), we mutate it and add the new `MyFilterFunction` interceptor through the `addFilterFunctionIfNotPresent` function.

2. In the case of having a `WebClient.Builder` (whether or not it contains other interceptors), we directly add the new `MyFilterFunction` interceptor through the `addFilterFunctionIfNotPresent` function.

3. The function that adds the new interceptor to the interceptor list, as long as it does not already exist.

In case you want to remove an `Interceptor`, it would be done in the same way, only by invoking the `removeFilterFunctions` function.
Below is an example of how to remove interceptors of type `MyFilterFunction` and `OCServletFilterFunction` from the list of interceptors;

     private Consumer<List<ExchangeFilterFunction>> removeFilterFunctions() {
            return (List<ExchangeFilterFunction> functions) -> {
                functions.removeIf((ExchangeFilterFunction interceptor) -> interceptor.getClass().getName()
                        .contains("MyFilterFunction"));
                functions.removeIf((ExchangeFilterFunction interceptor) -> interceptor.getClass().getName()
                        .contains("OCServletFilterFunction"));
            };
        }

### How to use HTTP Interfaces

With Http interfaces we can define an Http service as a Java interface using annotated methods (based on `@HttpExchange` annotation).
Santander Spring Boot includes already configured `beans` that allow to use the configurations explained in the two previous sections of this document.

To correctly configure the HTTP Interfaces, first, it is necessary to define the HTTP Interface for the client

    @HttpExchange
    public interface SantanderClient {
          @GetExchange(value = "/headers") // (1)
          Map<String, Object> getAnyMethodName();
    }

1. Using this `@GetExchange` annotation, this method will execute a GET Request to '/headers' endpoint.

After that, you will have to create a `bean` of the type of the interface defined, in this case `Client`. To create such bean, it is necessary to use the
`HttpServiceProxyFactory` class and provide the desired HTTP client.

You can use any of the already configured Santander Spring Boot HTTP Clients (to include features such as interceptors) but we recommend to inject a bean of type `WebClient.Builder`.

    @Bean
    SantanderClient serviceClient(WebClient.Builder webClient) {

        WebClient client = (WebClient) webClient.baseUrl("http://localhost:8082").build();  // (1)

        WebClientAdapter adapter = WebClientAdapter.create(client);
        HttpServiceProxyFactory factory = HttpServiceProxyFactory.builderFor(adapter).build();
        return factory.createClient(SantanderClient.class);
    }

1. The base URL taken in the exchange methods is `http://localhost:8082` in this example.

Once this is configured, the only step that remains is to inject `Client` bean into the desired component

    @RestController
    public class ExampleController {
        public ExampleController(SantanderClient client) {
            this.client = client;
        }

        @GetMapping(value = "/otherController", produces = MediaType.APPLICATION_JSON_VALUE)
        public Map<String, Object> getAnyMethodController() {
            return client.getAnyMethodName(); // (1)
        }
    }

1. This method will make a GET Request to 'http://localhost:8082/headers'

### How to use conditionals to distinguish the type of application

Spring offers some conditionals that let you know if the application is of type `SERVLET`,\` REACTIVE\` or `NONE`:

    @Bean
    @ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
    public void foo () {
    }

    @Bean
    @ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.REACTIVE)
    public void foo () {
    }

To detect if the application is of type `NONE` we will have to use: `@ConditionalOnNotWebApplication`

In addition to the conditionals that spring-boot provides by default, Santander Spring Boot offers additional conditionals that, unlike those already provided by Spring Boot,
allow us to do dual checks. That is, see if the application is `REACTIVE or NOTWEB`, or
see if it is `SERVLET or NOTWEB`. They can be used in both configuration classes and Beans registered by the application

In configuration classes :.

- **ReactiveOrNotWebCondition**: Detects if the application is of type `REACTIVE` or `NOTWEB`.

- **ServletOrNotWebConditio**: Detects if the application is of type `SERVLET` or `NOTWEB`.

In application beans:

- **ReactiveOrNotWebMehtodCondition** Will only register *@Bean* if the application is of type `REACTIVE` or `NOTWEB`.

- **ServletOrNotWebMehtodCondition** Will only register *@Bean* if the application is of type `SERVLET` or `NOTWEB`.

The difference between conditionals of type *Condition* and *MethodCondition* is that the first is only used in configuration classes and the second is only used for *@Bean*

In the following example we can see how the *ReactiveOrNotWebCondition* and *ReactiveOrNotWebMethodCondition* conditionals are used

    @Configuration(proxyBeanMethods = false)
    @Conditional(ReactiveOrNotWebCondition.class)
    public class MyAppAutoConfig {
    }

    @Bean
    @Conditional(ReactiveOrNotWebMethodCondition.class)
    public Foo myBean() {
    xxxx
    }

### Header propagation in NotWeb applications

In `NotWeb` type applications we cannot make as direct use of `RestTemplate`, `RestClient` or `WebClient` as in `Web` applications.

This is because **the interceptors that we inject in these Http clients make use of the `Context`** to retrieve the information,
and in **Web applications** this **Context** is initialized thanks to some Web filters that are included; however,
in these applications we do not have such filters.

This forces us to manually initialize the `Context` object before using the `RestTemplate`, `RestClient` or `WebClient`.

#### Non-reactive environments

When we are going to use Santander Spring Boot's `RestTemplate`, a `RestClient` or a `WebClient` in a **non-reactive environment** we should do something like the following:

```java
@Autowired
private RestTemplateBuilder restTemplateBuilder; // (1)

@Autowired
private RestClient.Builder restClientBuilder; // (1)

@Autowired
private WebClient.Builder webClientBuilder; // (1)
// ...
// ...

Info info = Info.builder().locale(...).channel(...){}.build(); // (2)

ContextHolder.setCurrentContext(Context.builder().info(info).build()); // (3)
// (...)

/*
    Uso RestTemplate, RestClient o WebClient // (4)
 */
```

1. We inject the bean of `RestTemplateBuilder`, `RestClient.Builder` or `WebClient.Builder` to create the `RestTemplate`, `RestClient` or `WebClient`.

2. We create a `Info` object with the information that we want to propagate in the headers (locale, channel, etc).

3. We put the above object in the current Context using the `ContextHolder`.

4. We make use of the `RestTemplate`, `RestClient` or `WebClient` to perform the invocation with the interceptors.

#### Reactive environments

When we are going to use a `WebClient` in a **reactive environment** we must include it in the `Context` of Reactor:

```java
@Autowired
private WebClient.Builder; // (1)
// ...
// ...

Info info = Info.builder().locale(...).channel(...){}.build(); // (2)
Context context = Context.builder().info(info).build();

webClientCallMethod()                                     // (4)
    .map(result -> ...)
    .contextWrite(ReactiveContextHolder
                        .withContext(context)) // (3)
    });
```

1. We inject the `WebClient.Builder` bean.

2. We create a `Info` object with the information that we want to propagate in the headers (locale, channel, etc) and we put it in a `Context`.

3. In the subscription of the stream of the call with the webclient we put the **Context** using the `ReactiveContextHolder`.

4. We make use of `WebClient` with the context including the **ContactPoint** above.

### How to use the Context

The `Context` builder represents a context that is self-managed by the architecture and is available throughout the entire request lifecycle.

`Context` provides projects with:

- A `ContactPoint` object with the information associated with the 'Contact Point'.

- A `Info` object initialized with information from the request.

- A map of type `Map<String, Object>` so that projects can store and retrieve the information they need.

- A `Headers` map of type\` Map &lt;String, String&gt; \`with the information associated with the headers.

#### Non-reactive environments

For all non-reactive applications (they do not make use of `Reactor`) the `ContextHolder` class is provided which allows retrieving or even initialize the `Context`.

##### Info

Here is an example to access the `Info` object:

        @GetMapping("/servlet-context")
        public String getInfofromContext() {
            return ContextHolder.getCurrentContext().getInfo();
        }

The `Info` object is automatically initialized with the following information:

```java
    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class Info {
        private String inputTimeStamp; // Initial inputTimeStamp from request
        private Locale locale;         // Locale related with the request
        private String channel;        // Value from HttpHeader "X-Santander-Channel"
        private String entity;         // Value from HttpHeader "organization"
        private String thirdParty;     // Value from HttpHeader "X-Santander-ThirdParty"
        private String device;         // Value from HttpHeader "X-Santander-Device"
        private String appKey;         // Value from configuration property `santander.app-key`
        private String appId;          // Value from configuration property `santander.app-key` for no-gluon app and `santander.app-name` for gluon app. In the case that both are reported, the value that will be taken will be that of the appName.
        private String appInit;        // Value from HttpHeader "app-init"
        private String mode;           // Value from HttpHeader "mode". Deployment mode for Istio applications
        private String encryptedObject; // Encrypted object associated with the request. This is used for cryptographic operations during the request lifecycle.
    }
```

##### General purpose map

To add an object in `Context` with the key 'foo' we will use this code:

    ContextHolder.getCurrentContext().put("foo", "foo-value");

In order to retrieve the object stored in the 'foo' key we will use this code:

        @GetMapping("/servlet-context")
        public String getValueFromContext() {
            return (String) ContextHolder.getCurrentContext().get("foo"); // (1)
        }

1. We return the value associated with the key "foo" stored in `Context`.

##### ContactPoint

If the application has the omnichannel filter configured, the `ContactPoint` information will be automatically added to the `Context`, so to retrieve it, all you have to do is:

        @GetMapping("/servlet-context")
        public String getChannelFromContext() {
            final ContactPoint contactPoint = ContextHolder.getCurrentContext().getContactPoint();
            return contactPoint != null ? contactPoint.getOriginChannel() : "NO CHANNEL";
        }

##### Headers map

To define at any point in the application a header that we want to be propagated in the requests that are made, we can use the `Context` in the following way:

    @Autowired
    @SantanderQualifier
    private RestTemplate restTemplate; // (1)

    @Autowired
    private RestClient restClient;

    @Autowired
    private WebClient.Builder webClientBuilder;
    ...

    ContextHolder.getCurrentContext().toBuilder().header("headerKey", "headerValue");  // (2)

    ...
    /*
        Uso del RestTemplate o WebClient // (3)
     */

1. We inject Santander Spring Boot's `RestTemplate`, a `RestClient.Builder` or a `WebClient/WebClient.Builder` bean

2. We access the `Context` and with the *header(String, String)* or *headers(Map)* methods we define the headers that we want to propagate.

3. We make use of the RestTemplate, RestClient or WebClient

##### Context concurrency strategies

For this topology of applications, three strategies are supported that define how `Context` is stored according to the needs of the project:
**[`MODE_THREADLOCAL`](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/ThreadLocalBootContextHolderStrategy.html): The `Context` context is
stored in the `ThreadLocal` associated with the request.**
[`MODE_INHERITABLETHREADLOCAL`](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/InheritableThreadLocalBootContextHolderStrategy.html): The
`Context` context is stored in an `InheritableThreadLocal` associated with the request. \*\*
[`MODE_GLOBAL`](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/GlobalBootContextHolderStrategy.html): The `Context` context is handled as a
static class. This means that all threads / instances in the `JVM` share the same `Context`, which is very useful for standalone (non-web) applications.

The default strategy will be `MODE_THREADLOCAL`.

If the project needs to modify the strategy to be applied, it can do so in two ways:

- Through the system variable `santander.context.strategy` with the value of the strategy we want to set: `MODE_THREADLOCAL`, `MODE_INHERITABLETHREADLOCAL` or `MODE_GLOBAL`.

- Through the `ContextHolder` class from code, for example to configure the `MODE_INHERITABLETHREADLOCAL` strategy:

```java
ContextHolder.setStrategyName(ContextHolder.MODE_INHERITABLETHREADLOCAL);
```

If the project needs to implement a new strategy, all it has to do is:

- Create a new class with the logic of the new strategy implementing the interface
    [`ContextHolderStrategy`](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/core/context/ContextHolderStrategy.html).

- Load the new strategy through any of the two mechanisms detailed in the previous paragraph, only that the name of the strategy will be the name of the class.

!!! warning

    **NATIVE COMPILATION**

    In the case that the project creates a class to implement a new strategy, if you want to compile natively, you should add the necessary Hints for the reflection of that class.

#### Reactive environments

For all reactive applications that make use of `Spring WebFlux` and/or `Reactor`, the Santander framework architecture provides the `ReactiveContextHolder` class
which, although functionally equivalent to `ContextHolder`, differs both in its
implementation and use.

##### Info

This functionality is totally equivalent to the [use case in non-reactive environments](#info), being able to access said information in the following way:

        ReactiveContextHolder.getContext() // (1)
                                    .map(Context::getInfo) // (2)
                                    .map(info -> {
                                       ...; // (3)
                                    });

1. We retrieve the `Context` context stored in the `Context` object.

2. We continue the chain of operators with the object `Info` from the retrieved context.

3. We use the information from **Info** and the pipeline continues with the execution of other operators.

##### General purpose map

To add an object in `Context` with the key 'foo' we will use this code:

        ReactiveContextHolder.getContext() // (1)
                                   .map(context -> {
                                       context.put("foo", "foo-value"); // (2)
                                       ...; // (3)
                                   });

1. We retrieve the `Context` context stored in the `Context` object.

2. We add `Context` to the key" foo "with the value" foo-value ".

3. The pipeline continues with the execution of other operators.

In order to retrieve the object stored in the 'foo' key we will use this code:

        @GetMapping("/reactive-context")
        public Mono<String> getValueFromContext() {
            return ReactiveContextHolder.getContext() // (1)
                                              .map(context -> (String)context.get("foo")); // (2)
        }

1. We retrieve the `Context` context stored in the `Context` object.

2. We return the value associated to the key "foo" stored in `Context`.

##### ContactPoint

Like the `Spring Servlet` version, if the application has the omnichannel filter configured, the `ContactPoint` information will be automatically added in `Contex` so to retrieve it, all you have to do is:

        @GetMapping("/reactive-context")
        public Mono<String> getChannelFromContext() {
            return ReactiveContextHolder.getContext()
                                              .map(context -> context.getContactPoint().getOriginChannel());
        }

In applications of type `NotWeb` of type reactive (that is, they use `Reactor` but not `Spring WebFlux`) a `Web` environment will not be available so the `ContextWebFilter`
filter will not be available (This filter takes care of subscribe the
`Context` context to the reactive string), and we would have to subscribe `Context` manually:

        public Mono<Void> reactiveContext() {}
            return Mono.just(Context.builder().build())
            .map(context -> {
                context.put("foo", "test");
                return doWithContext().contextWrite(ReactiveContextHolder.withContext(context));
            }).then();
        }

        private <T> Mono<T> doWithContext() {
            return ReactiveContextHolder.getContext()
            .map(context -> context.get("foo"))
            .(...)
        }

!!! info "Important"

    The concept of strategies only makes sense for non-reactive applications, hence there is no equivalent in this section.

##### Headers map

To define at any point in the application a header that we want to be propagated in the requests that are made, we can use the `Context` in the following way:

    @Autowired
    private WebClient.Builder webClientBuilder; // (1)
    ...

    ReactiveContextHolder.getContext()    // (2)
        .doOnNext(context -> context.toBuilder().header("headerKey", "headerValue"))  // (3)
        .flatMap(context ->
            /*
                Uso del WebClient // (4)
             */
        );

1. We inject a `WebClient/WebClient.Builder` bean.

2. We access the reactive string of the `Context`.

3. We use the *header(String, String)* or *headers(Map)* methods to add the headers that we want to propagate.

4. We make use of the WebClient following the reactive chain that we have started in step 2.

##### Working with ContextView

Some Reactor operators expose the Reactor Context as `ContextView` instance. This `Object` is readonly, and it cannot be modified. Through it, any value stored in Reactor Context can be accessed easily as an Object.

Form example, `doOnEach(Signal)` operator expose Reactor Context through the Signal instance:

    doOnEach((Signal<?> signal) -> {
        ContextView contextView = signal.getContextView();
        Context context = ReactiveContextHolder.getContext(contextView);
        ...
    });

Another example, `deferContextual(Function<ContextView,T>)` operator expose Reactor Context as ContextView instance:

    Mono.deferContextual((ContextView contextView) -> {
        Context context = ReactiveContextHolder.getContext(contextView);
        ...
        return Mono.just(...);
    });

### How to customize the Santander Spring Boot ThreadExecutor

The Santander Spring Boot Core library provides a basic asynchronous configuration that allows new threads generated by asynchronous executions to obtain all the information contained in the parent thread.

If the microservice already had its own asynchronous configuration, it would be necessary to simply include the TaskDecorator from the library by invoking the setTaskDecorator method. You have two ways to use it:

1. The task decorator is available a bean of type `TaskDecorator taskDecorator` and you could use it.

2. Also, you could create a new one

        ContextSnapshotFactory contextSnapshotFactory = ContextSnapshotFactory.builder().build();
        TaskDecorator taskDecorator = runnable -> contextSnapshotFactory.captureAll().wrap(runnable);

After that, you could set the task decorator:

    threadPoolTaskExecutor.setTaskDecorator(taskDecorator);

In the event that the microservice already had its own `TaskDecorator`, it will be necessary to call the Micrometer's ContextSnapshot code to copy contexts (you could see it few line before) and keep the information of the parent thread in the
child.

!!! info "Important"

    The ThreadExecutor concept only makes sense for non-reactive applications.

#### Example of use

To use this Executor it would be enough to follow the following steps:

- The `santander.core.async.enabled` property is set to true in the microservice configuration file.

- (Optional) Set the rest of the configurable properties:

<!-- -->

    santander:
      core:
        async:
          enabled: true
          core-pool-size: 5
          max-pool-size: 5
          queue-capacity: 0

- The bean is injected with the `ThreadExecutor` as follows:

<!-- -->

    @Autowired
    @Qualifier("santanderAsyncExecutor")
    Executor executor;

- The `ThreadExecutor` could already be used:

<!-- -->

    executor.execute(new RunnableWork());

### How to throw a Santander Spring Boot exception and customize it using the error.properties file

For these examples, the [used in previous sections](#customize-error-model-fields) will be used as the error.properties file.

!!! info "Important"

    We remember that the customization of exceptions using the `error.properties` **will only be available in web applications**.

When throwing any Santander Spring Boot exception passing it as a parameter only the 'errorName', the properties defined in the `error.properties` file will be used to generate the exception. If we throw the following exception:

      throw new BadRequestException("account_doesnot_exist");

We would get the following JSON response:

        {
         "appName": "exceptions-demo",
         "timeStamp": 1513268058750,
         "errorName": "account_doesnot_exist",
         "status": 400,
         "internalCode": 1001,
         "shortMessage": "Account doesn't exist",
         "detailedMessage": "The request was invalid or cannot be otherwise served. An accompanying error message will explain further. For security reasons, requests without authentication are considered invalid and will yield this response."
      }

All the fields generated from the error.properties are susceptible to being modified by the exception itself. For example, if instead of the previous one we throw the exception in the following way:

      throw new BadRequestException("account_doesnot_exist", "La cuenta existe pero el cliente no tiene acceso a ella");

We would get the following JSON response:

        {
         "appName": "exceptions-demo",
         "timeStamp": 1513268058750,
         "errorName": "account_doesnot_exist",
         "status": 400,
         "internalCode": 1001,
         "shortMessage": "Account doesn't exist",
         "detailedMessage": "La cuenta existe pero el cliente no tiene acceso a ella"
      }

Finally, if in addition to this information, you want to pass data about the situation in which the exception has been generated, you can use the `mapExtendedMessage`:

      Map<String,String> mapExtendedMessage = new HashMap<>();
      mapExtendedMessage.put("clientId","cliente123")

      throw new BadRequestException("account_doesnot_exist", "La cuenta existe pero el cliente no tiene acceso a ella", mapExtendedMessage);

We would get the following JSON response:

        {
         "appName": "exceptions-demo",
         "timeStamp": 1513268058750,
         "errorName": "account_doesnot_exist",
         "status": 400,
         "internalCode": 1001,
         "shortMessage": "Account doesn't exist",
         "detailedMessage": "La cuenta existe pero el cliente no tiene acceso a ella",
         "mapExtendedMessage": {
            "clientId": "cliente123"
         }
      }

A new feature in Santander Spring Boot 6.0 and later versions is the ability to add information at runtime to the default messages in the errors.properties files.  `errorsMessagePlaceholders`.

For example, if we define the following properties **for Santander Spring Boot Error Model**:

        # BadRequestException exception message
        account_doesnot_exist.shortMessage=Account {0} doesn't exist

When throwing any Santander Spring Boot exception passing the `errorName` and `errorsMessagePlaceholders` fields:

      throw new BadRequestException("account_doesnot_exist", Map.of("shortMessage",List.of("ES6714651767888815635491")));

We would get the following JSON response:

        {
         "appName": "exceptions-demo",
         "timeStamp": 1513268058750,
         "errorName": "account_doesnot_exist",
         "status": 400,
         "internalCode": 1001,
         "shortMessage": "Account ES6714651767888815635491 doesn't exist",
         "detailedMessage": "The request was invalid or cannot be otherwise served. An accompanying error message will explain further. For security reasons, requests without authentication are considered invalid and will yield this response."
        }

Or **for Gluon Error Model**:

      throw new BadRequestException("account_doesnot_exist", Map.of("description", List.of("ES6714651767888815635491")));

We would get the following JSON response:

        {
            "errors": [
                {
                    "code": "400",
                    "description": "Account ES6714651767888815635491 doesn't exist",
                    "level": "error",
                    "message": "The requested account was not found."
                }
            ]
        }

For Gluon Error Model, we can also use the following constructor, which by default would populate the placeholder values of the description field:

      throw new BadRequestException("account_doesnot_exist", List.of("ES6714651767888815635491"));

### How to propagate context from/to Reactor stream

When an application is developed using Reactor streams to implement the logic business, it is probably necessary to access to the context for getting, for example, info object or contact point data.

Thus, for binding the context associated with the execution thread and the reactor context,
Santander Spring Boot provides a [ThreadLocalAccessor](https://javadoc.io/doc/io.micrometer/context-propagation/1.1.3/io/micrometer/context/ThreadLocalAccessor.html) to be used by Micrometer's context-propagation library
in order to copy automatically the Santander Spring Boot Context from/to the execution thread to the Reactor Context.

This feature can be activated manually or automatically. You can find more in depth examples and explanations about context propagation between Reactive and Imperative at this [Spring's
post](https://spring.io/blog/2023/03/30/context-propagation-with-project-reactor-3-unified-bridging-between-reactive)

!!! tip "Important"

    Whenever you switch to a reactive context from imperative code, you need to call contextCapture() to propagate the context.

#### Manual method

You can include all Servlet ThreadLocals managed by a *ThreadLocalAccessor* in Reactor context using the operator `contextCapture()` at the beginning of the stream in subscription time. Also, if you already have any information in Reactor
Context, you can make it accessible via ThreadLocals within *tap* and *handle* operators:

```java
public class AppConfig {

    // ...

    public String myMethod() {
        Context context = ContextHolder.getCurrentContext(); // (1)
        context.put("myKey", "myValue");

        ReactiveContextHolder.getContext()
            .map(dContext -> { dContext.get("myKey"); } ) // (3)
            .tap(() -> new DefaultSignalListener<>() {
                @Override
                public void doOnComplete() {
                    ContextHolder.getCurrentContext().get("myKey"); // (4)
                }
            })
            .contextCapture() // (2)
            .block();
    }
}
```

1. Set information in Context ThreadLocal.

2. Use *contextCapture()* to load Reactor Context in subscription time.

3. You can use Context from ContextView with propagated info, but NOT directly from ThreadLocals within a map operator.

4. With *tap* and *handle* methods we can access ThreadLocals for this code block.

#### Automatic method

You can make ThreadLocals accessible for any Reactor operator using `Hooks.enableAutomaticContextPropagation()` in any point of your application. Santander Spring Boot has a property to do it transparently to the application:

```properties
santander.core.reactor.context-propagation: AUTO
```

Using this property no you can access ThreadLocals from any operator as shown:

```java
public class AppConfig {

    // ...

    public String myMethod() {
        Context context = ContextHolder.getCurrentContext();
        context.put("myKey", "myValue");

        ReactiveContextHolder.getContext()
            .map(dContext -> ContextHolder.getCurrentContext().get("myKey"))
            .doOnNext(value -> log.info(ContextHolder.getCurrentContext().get("myKey")))
            .tap(() -> new DefaultSignalListener<>() {
                @Override
                public void doOnComplete() {
                    ContextHolder.getCurrentContext().get("myKey");
                }
            })
            .contextCapture()
            .block();
    }

}
```

1. You can access now ThreadLocals from map operator

2. Also, from any other like doOnNext

3. tap and handle operators are still propagating context

!!! tip "Caution"

    **Enabling `santander.core.reactor.context-propagation=AUTO` can lead to decrease performance** because of wrapping the execution of each operator in order to propagate all managed contexts.

### How to use the Obfuscation service

Sometimes the information that it is being processed could contain sensible data that it cannot be exposed.
In order to avoid showing confidential information,
the Obfuscation feature provides a `Service` that it accepts two input parameters:
the data structure to process and a set of sensitive fields.
The sensible fields defined are searched inside data structure and
their values are hidden with the symbols of the obfuscation: `****`.

The implementation that it is charge of searching the fields inside data structure and
changing the values for the symbols of obfuscation is based on `Jayway JsonPath`.
This library provides the use of expressions in order to define the path inside
JSON structure.
Additionally,
if the name of the field is defined in plain format i.e. simply the name of the fields without using a path expression,
the implementation will hide all the appearances of these fields inside the data structure.

!!! note

    If the application excludes `com.jayway.jsonpath:json-path` library
    from the `santander-spring-boot-starter-core` dependency,
    the obfuscation feature with JsonPath will not be available.
    You only could obfuscate using fields names in plain format.

To use the ***Obfuscation service***,
it is simply necessary to inject the `ObfuscationService` instance inside the component where we want to use it.

!!! note

    For more information about how to define JSON paths expressions,
    you can look up the documentation of the [Jayway JsonPath](https://github.com/json-path/JsonPath#getting-started) library.

For this first example, we are going to use the following simple reference: `nickname`.

**Example of hiding sensible information using the name of the field in a simple way.**

    import com.santander.framework.springboot.core.obfuscation.core.ObfuscationService;
    import lombok.AllArgsConstructor;
    import lombok.Data;
    import lombok.NoArgsConstructor;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    @Service
    public class BusinessEventMarkedMethod {

        @Autowired
        ObfuscationService obfuscationService;

        public String doingBusinessLogic(String username) {
            List<String> sensibleFields = List.of("nickname");
            DataUser data = new DataUser(username, new User(1, username));
            return obfuscationService.obfuscate(data, sensibleFields);
        }
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    class DataUser {
        private String nickname;
        private User user;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    class User {
        private int id;
        private String nickname;

    }

Here, the important thing is that if the sensible field is defined in a simple way (**not as an expression**),
the implementation will hide all the appearances of that field in the data structure.
In the previous code example, the result will be
processed and all the occurrences of the field ***name*** will be hidden with the symbols of the obfuscation.

The output field in the business event will have the following form:

    {
      "nickname": "****",
      "user": {
        "nickname": "****",
        "id": 1
      }
    }

If it is necessary to be more accurate,
the JsonPath expressions can be used in order to specify the path inside JSON structure.

In this one,
we are going to use the following ***JsonPath*** expression: `$.user.nickname`.

**Example of hiding sensible fields using specific path expression.**

    import com.santander.framework.springboot.core.obfuscation.core.ObfuscationService;
    import lombok.AllArgsConstructor;
    import lombok.Data;
    import lombok.NoArgsConstructor;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    @Service
    public class BusinessEventMarkedMethod {

        @Autowired
        ObfuscationService obfuscationService;

        public String doingBusinessLogic(String username) {
            List<String> sensibleFields = List.of("$.user.nickname");
            DataUser data = new DataUser(username, new User(1, username));
            return obfuscationService.obfuscate(data, sensibleFields);
        }
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    class DataUser {
        private String nickname;
        private User user;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    class User {
        private int id;
        private String nickname;

    }

In this case,
only the `nickname` field of the User object defined inside DataUser class will be hide.
The value of the `nickname` property in the DataUser object won't be processed.
The output will have the following form:

    {
      "nickname": "Paul",
      "user": {
        "nickname": "****",
        "id": 1
      }
    }

Additionally,
the Obfuscation service allows developers to define any kind of JsonPath expression.
The following table contains some examples on how to create new ones:

Given the json:

    {
      "city": "Liverpool",
      "users": [
        {
          "nickname": "Paul",
          "id": 1
        },
        {
          "nickname": "John",
          "id": 2
        },
        {
          "nickname": "George",
          "id": 3
        },
        {
          "nickname": "Ringo",
          "id": 4
        }
      ]
    }

Applying these expressions:

| JsonPath                            | Result                                                                        |
|-------------------------------------|-------------------------------------------------------------------------------|
| \$.city                             | Hide the city value                                                           |
| \$..nickname                        | Hide all nicknames                                                            |
| \$.users.\*                         | Hide all user information                                                     |
| \$.users\[2\].\*                    | Hide the third user information.                                              |
| \$.users\[1:2\].\*                  | Hide all user information from index 1 (inclusive) until index 2 (exclusive). |
| \$.users\[?(@.id &gt; 1)\].nickname | Hide all nickname of users whose id fields are greater than 1.                |
| \$..\*                              | Hide everything                                                               |

!!! warning

    **NATIVE COMPILATION**

    It is necessary to add the hints for reflection for all classes used as parameters in the obfuscation service.

### How to use properties files for internationalization?

#### How to load a properties files for internationalization from file path

In case you want to load property files for internationalization from file you must add their path to the Spring Boot `spring.messages.basename` property. This property supports several path separated by commas.

For example, if we have the files in the filepath:

    /data/i18n/messages.properties
    /data/i18n/messages_en.properties
    /data/i18n/messages_es.properties

We should add the property:

    spring.messages.basename=file:/data/i18n/messages

In case we wanted to load files from classpath we could use:

    spring.messages.basename=classpath:i18n/messages

#### How to use properties files for internationalization in code

In order to use the properties files for internationalization in the code, we must use the `MessageSource` class. This class is a Spring component that allows us to access the messages defined in the properties files.

    @Autowired
    MessageSource messageSource;

    var propertyKey = "keyMessage";
    Object[] args = null; // you can add args to the message
    var locale = ContextHolder.getCurrentContext().getInfo().getLocale();

    // Getting translation for key message
    var i18Response = messageSource.getMessage(propertyKey, args, locale);

## Integration with OpenAPI 3

Santander Spring Boot has Swagger integration through Springdoc OpenAPI. This allows the generation, in a uniform way, of the API's documentation, being the same for both `reactive` and `servlet` applications. Furthermore, this documentation will be exposed
through Swagger UI in HTML format. For this, it will not be necessary to authenticate, or the inclusion of any additional endpoint in the authentication or authorization whitelists.

To access the application's API documentation in HTML format, you must access the following address from the browser. Depending on the type of application, the following are available:

!!! note

    For accessing to the API documentation of a Reactive Application, it can use the following URI: `http://micro-url:port/path-to-micro/webjars/swagger-ui/index.html?configUrl=/v3/api-docs/swagger-config`. It necessary to fill
    in the specific values of the application (micro-url,port,path-to-micro).

!!! note

    For accessing to the API documentation of a Servlet Application, it can use the following URI: `http://micro-url:port/path-to-micro/swagger-ui/index.html?configUrl=/v3/api-docs/swagger-config`. It necessary to fill in the
    specific values of the application (micro-url,port,path-to-micro).

To consult the API information in JSON format, you can use a similar URI filling in with the specific values of your application (micro-url,port,path-to-micro): `http://micro-url:port/path-to-micro/v3/api-docs`

## Migration from previous releases

Due to the changes made in the core library, a small migration guide exclusive to this library is included. [Migration Guide](../../MIGRATION.md)
