# Change Log

## Version 5.8.0

<!tag:580>

### 🐞 Bug Fixes

- Solve issue that avoid create a Darwin Async executor if there is an executor bean in context.

<!end:580>

## Version 5.7.1

<!tag:571>

- New functionality that allows using a simple obfuscation service that does not support JSONPath expressions if the
  `com.jayway.jsonpath:json-path` dependency is excluded when bringing in `darwin-spring-boot-starter-core`.
  This is useful to avoid using the `net.minidev:json-smart` dependency, which currently has an unresolved vulnerability `CVE-2024-57699`.

<!end:571>

## Version 5.6.0

<!tag:560>

- Improve the documentation related to context propagation between imperative and reactive code.

<!end:560>

## Version 5.3.1

<!tag:531>

- Rename property `darwin.core.headers.include-api-client-id` to `darwin.core.headers.gluon-clientid-propagation` and set default value to false. Also, propagate x-client-id header with JWTClientId value if the property is true.

<!end:531>

## Version 5.3.0

<!tag:530>

- Propagate "JWTClientId" property from context to "x-santander-client-id", "x-ibm-client-id" and "X-API-Key" headers
in Darwin's managed Http clients (can be disabled via config property).

<!end:530>

## Version 5.2.0

<!tag:520>

- Using all properties from `spring.messages` to configure the MessageSource, it adds support to use other formats than ISO-8859-1.
- Fix initializing error when bootstrap context is active (don't find darwin.app-key or darwin.app-name).

<!end:520>

## Version 5.0.2

<!tag:502>

- Create and load new `ThreadLocalAccessor` (`ServletRequestContextAccessor`) to propagate Servlet `RequestAttributes` to Reactor Context in Servlet applications.
- The `ForbiddenDarwinException` class now progresses in a way that matches the original cause of the exception.

<!end:502>

## Version 5.0.1

<!tag:501>

- Use default hostnameVerifier for SSL connections in RestTemplate/RestClient.

<!end:501>

## Version 5.0.0

<!tag:500>

- Added a guide to configure HTTP Interfaces.
- Update classes `DarwinErrorAttributes::getErrorAttributes` in case there in no error attributes it response a empty Map instead of a `null` value.
- The `ConnectionsUtils::createHttpClient` method is no longer public.
- Adds new properties in `darwin.core.exceptions.response-content-type` that will be used in the ExceptionHandler to render the outcome of the errorModel object.
- Removed the current configuration of the asynchronous thread pool and replaced it from our custom "Discard" policy to a property `thread-pool-policy` that can be configured
  with all existent policies and is set to `ABORT_POLICY` by default.
- Fix CoreConfigPostProcessor bean creation to avoid creating CoreProperties early.
- Add new constructor to DarwinErrorAttributes to allow using a custom objectMapper.
- Unify the Darwin Interceptors creation to improve the performance.
- Add support to Spring RestClient with Darwin features
- Complete section about WebClient/WebClient.Builder features in README
- Add documentation about RestTemplate *connection-time-to-live* configuration property
- Rename RestTemplate/WebClient config properties section in README to fix redirect links

<!end:500>

## Version 4.3.3-RELEASE

<!tag:433>

- New section in the documentation about internationalization in Darwin.

<!end:433>

## Version 4.3.2-RELEASE

<!tag:432>

- Add examples about Gluon Error Model customization in documentation.

<!end:432>

## Version 4.3.1-RELEASE

<!tag:431>

- Fix: don't overwrite messageSource in parent context. This solves issues when the dependency
`spring-cloud-starter-bootstrap` is included in the microservice.

<!end:431>

## Version 4.3.0-RELEASE

<!tag:430>

- New feature that allows loading i18n files from the filepath. Previously they could only be loaded from classpath.

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- Fix on ErrorModelDarwin bean creation so the property 'darwin.core.exceptions.error-format' now accepts an empty string to avoid bean definition error.
- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.
- Add hints to support external libraries in native compilation.
- Fix DarwinRestTemplatePostProcessor to support native compilation.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:410>

- Fix issue with health check for not web applications when there are several application context-refresh events.
- Change of the behavior of the error literals.
  Previously, if a channel and entity were reported, only the error literal with a channel and entity were searched.
  Now, in case it does not find it, it looks for it without a channel and entity.

- The *Code field* in the Gluon Error model is now of the *String type*.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Upgrade Apache HttpClient API used to 5.x

- Add hints to support native compilation.

- Now GenericDarwinException has a builder to build exceptions together with a specific function for Throwable Exceptions.

- Remove Yauaa dependency.

- The bean `darwinTaskDecorator` could be overwritten and Darwin Context is registered
  for his propagation using the functionality of the library `io.micrometer.context-propagation`.

- New property `darwin.core.reactor.context-propagation` to configure automatic context propagation (LIMITED by default) in reactive streams.

- `DarwinContextHolder` now include a method to retrieve DarwinContext with a flag to create or not if empty.

- **darwin.appkey** only is required for no-gluon apps. In the case that **darwin.app-name** is reported, this field will be taken instead of **darwin.appkey**.

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Moved Extended Error Model from Extended error library to Core module and renamed to Gluon Error Model

- Fix **bugs for BodyRequestCacheWebFilter**:

    - Configure filter to allow to **read request body twice** when **Business Event endpoints are configured in a Reactive Application**.

    - Fix references to the property used to enable the filter.

    - Now the filter cannot be configured with an empty list for automatic Functional traces.

- *darwin.appkey* only is required for no-gluon apps. In the case that *darwin.app-name* is reported, this field will be taken instead of *darwin.appkey*.

<!end:327>

## 3.2.6-RELEASE Version

<!tag:326>

- Never send X-Santander-client-id to avoid error calling IBM API-Connect.

<!end:326>

## 3.2.5-RELEASE Version

<!tag:325>

- Added new property that allows the Darwin webclient to use the system proxy if it is defined. `darwin.core.web-client.proxy-system-settings`

- Moved OnScheduleHook from Authorization library to Core module in order to copy Servlet context when there is change of thread inside a Reactor stream. Only available in Servlet and NotWeb applications .

<!end:325>

## 3.2.4-RELEASE Version

<!tag:324>

- Change header `x-clientId` by `x-santander-client-id`. Adding new property `xclientid-compability` to propagate app identifier in `x-clientId` header.

- Include exception cause as optional constructor parameter in `HttpBaseDarwinException` and `HttpBaseDarwinException`

- Using throwable instead of exception in `DarwinExceptionHandlerController#createErrorModelAttributes`

<!end:324>

## 3.2.3-RELEASE Version

<!tag:323>

- Modify access `DarwinExceptionHandlerController#createErrorModelAttributes` to protected and add parameter Exception in order to promote reusability

<!end:323>

## 3.2.2-RELEASE Version

<!tag:322>

- To improve traceability, the HttpClient wiretap format can now be enabled from config.

- Move ContactPointUtils to omnichannel module

- Add new method `toJsonString` to `ContactPoint`

<!end:322>

## 3.2.0-RELEASE Version

<!tag:320>

- Now Darwin Core doesn't load its configuration automatically.

- Optimize dependencies: remove org.slf4j:slf4j-api, net.minidev:json-smart and org.apache.commons:commons-lang3, and commons-io:commons-io moved to test scope.

    - ErrorModelGateway and ContactPointUtils now use Spring's JSONObject.

- Now Darwin Core can enable/disable the propagation headers.

- Adding ObfuscationService interface and its default implementation for obfuscating data.

- Adding NoContentDarwinException.

- To improve traceability, the HttpClient wiretap can now be enabled from config.

- We advise against using @DarwinQualifier on ObjectMapper injection.

- Adding getOrDefault() method to DarwinContext API.

- Adding documentation about the known limitation of resilience4j annotations in a micro servlet when they are applied on a reactive method.

- Remove ReactorUtils class instead of `block()` method.

- Added `@ExceptionHandler` to handle Authentication and Authorization exceptions.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Adding `containsKey` function to Darwin Context implementation.

- Refactor `GenericDarwinException` constructor from Exception to admit a **Throwable**.

- Fix bug to **include DarwinContext** from the original request for the **Async dispatch** in Servlet applications

    - Clean DarwinContext from ThreadLocal for any filter execution result.

- `ErrorModelDarwin` implements `GraphQLErrorModel` to be compatible with GraphQL errors.

- Add a task decorator to give access to Darwin Context in applicationTaskExecutor in async tomcat request

- New interface to allow customization of security from logging module. Avoid logging dependencies in security module

- New ***allowCoreThreadTimeOut*** configurable property for Darwin Async threadPoolTaskExecutor.

- Add support to new architecture header "mode". It's related to Istio application mode (hidden or live)

- Add a default error trace when a webflux throw some error

- Adding a new instrumentation for Servlet applications
  to copy the Darwin Context from the execution thread to the Reactor context
  before a new reactive stream is subscribed.

- Change level error reading Contact-point header from error to warning.

<!end:310>

## 3.0.3-RELEASE Version

<!tag:303>

- The way of creating a HttpClient has changed with the new version of reactor-netty.
  To maintain the back compatibility, HttpClient MaxConnections property is set to 500
  (default values is calculated according to the number processor).

<!end:303>

## 3.0.2-RELEASE Version

<!tag:302>

- Modify `ContactPoint` to accept ***appName*** and ***os*** fields from "Contact-Point" header deserialization in addition to *application* and *operatingSystem*.

    - Step up "Contact-Point" header condition from "notEmpty" to "notBlank".

<!end:302>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Translate Readme.adoc to english.

- Update the metadata files with the rules defined in the Darwin Spring Migration Checklist.

- Delete deprecated properties `darwin.restTemplate.*` from metadata.json.

- Removed deprecated method "**buildFromException**" from `ErrorModelBuilder` in favor of "**buildErrorModel**".

- **Merge Common library into Core**:

    - **Refactor Darwin cross classes/packages** from Common to Core packages: annotation, authorization, conditions, config, constants, context, exceptions, omnichannel and support.

    - **Remove Common `clientprofile` and `data` packages**.

    - **Added Common dependencies**: jackson-databind, jackson-annotations, commons-lang3, commons-io, swagger-annotations and yauaa.

- **Reduce NotWeb application modes**: now there is a unique NotWeb mode which **always include HttpClients** (RestTemplate/WebClient):

    - **spring-webflux**, **reactor-netty** and **httpclient** now are transient dependencies.

    - **Remove RestTemplate/WebClient's ConditionalOnClass** from configuration.

- **spring-boot-actuator-autoconfigure** dependency moved to test scope.

- Removed ConditionalOnClass for Darwin ObjectMapper bean.

- Now, not web applications expose healthchecks through actuator urls.

- Fixed bug that causes Yauaa module load multiple times.

- Fixed the formatting of the messages for mediaTypeNotAcceptable and mediaTypeNotSupported exceptions for Servlet/Reactive,
  and the `errorName` from *HttpMessageNotReadableException*.

- DarwinContext as a Builder.

- Dependencies and plugins upgrade:

    - `ResourceProperties` class is deprecated. Now `WebProperties` is used.

    - Using `ApplicationListener<ContextRefreshedEvent>` instead of `@PostConstruct` in ***HealthCheckConfig***. BeanFactory didn't find the required beans in postConstruct phase.

    - Deleted `spring-cloud-starter-netflix-hystrix` in test scope.

    - `ConfigFileApplicationContextInitializer` is deprecated. Instead, `ConfigDataApplicationContextInitializer` is used.

- Fixed sonar issues

- **Moved *createEmptyContext()*** method from DarwinContextHolderStrategy implementations to `DarwinContextHolderStrategy` interface.

- Removed `isReactive` bean. Bean `webApplicationType` has been created to indicate the type of application.

- New ResiliencePredicates class with static Predicates

- Using HttpClient instead of TcpClient in order to create connectors of the WebClient.

- Remove in all parts of the FW the property allow-bean-definition-overriding

- New class ReactorUtils with generic utils for reactive environments.
  Add methods to block a Reactive Stream making a correct management of exceptions.
  Refactor class GenericUtils to Utils.

- Performing warm-up for default HttpClient.

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Added condition `havingValue = "true"` to @ConditionalOnProperty in CoreAsyncAutoConfig

- Update getBody for DefaultDataBuffer in ServerWebExchangeUtils

- Using new API of Reactor.

    - Using new Reactor Context API to access and to write the Darwin Context.

- Refactoring use of ReactiveDarwinContextHolder.

    - Now, DarwinContext is stored in Reactor context as an object, not as a `Mono`.

    - Simplifying the access to the reactor context.

- Replace "message" with "shortMessage" to find in error properties files for ErrorModelDarwin

- Rename CoreProperties.WebClient class to WebClientConfigProperties.

- BugFix for WebClient customization: now all WebClient properties can be configured without any binding with other properties.

- Remove PropertiesDeprecatedTest and darwin migration assistance dependency

- New class SSLSocketUtils with validation method for SSL connections.

- Refactoring Darwin async configuration to simplify implementation.
  Now LazyTraceExecutor is created through Sleuth bean postprocessor when Sleuth dependencies are present.

- Remove unused `DarwinExceptionCode` enum

<!end:300>

## 2.11.4-RELEASE Version

<!tag:2114>

- `darwin-spring-boot-common`:

    - Modify `ContactPoint` to accept ***appName*** and ***os*** fields from "Contact-Point" header deserialization in addition to *application* and *operatingSystem*.

        - Step up "Contact-Point" header condition from "notEmpty" to "notBlank".

<!end:2114>

## 2.11.2-RELEASE Version

<!tag:2112>

- `darwin-spring-boot-common`:

    - Fixed bug that causes Yauaa module load multiple times.

<!end:2112>

## 2.11.1-RELEASE Version

<!tag:2111>

- New boolean "isReactive" bean loads if it's a Reactive application or not.

<!end:2111>

## 2.11.0-RELEASE Version

<!tag:2110>

- Kebab-case support for Core reactive properties.

- Fix.Now supports property files by language if defined by the project.

- The *app-init* header now propagates on the core module (filters and interceptors).

- `darwin-spring-boot-common`:

    - Fix bug with HttpBaseDarwinException's equals(): wasn't calling super (GenericDarwinException) equals(), so it was only checking "status" field.

<!end:2110>

## 2.10.0-RELEASE Version

<!tag:2100>

- **Generalize** error models attributes used to build:
  new methods in `ErrorModelFactory` and `ErrorModelDarwin`
  **using a generic map** and mark old methods as ***@Deprecated***

- New property to **disable Darwin exceptions management**: `darwin.core.exceptions.enabled`, it's enabled by default.

    - Remove old unused *darwin.core.leanCore.errorFormat* property.

- Changed DarwinContext entity source from *X-Santander-Entity* header to *organization* header. This change applies to filters and interceptors for headers propagation.

- Change **DarwinErrorsPropertiesAccessor**'s attributes visibility to ***protected***, so they can be used easily from classes that extend it.

- Added maxLifeTime to WebClients.

- Setting `connectionTimeToLive` RestTemplate property to 60000.

- `darwin-spring-boot-common`:

    - ENTITY constant value changed to "*organization*" (old X-Santander-Entity).

    - Added support for DefaultDataBuffer in ServerWebExchangeUtils class.

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- Configuration ProxyBeanMethod set to "false" in `DarwinHystrixMetricsConfig` class.

- `AppKey` property is **@NotBlank**. From now on, this property can't be empty.

- Complete `DarwinInfo` uses from DarwinContext in Reactor `Context`:

    - `DarwinContextWebFilter` initialize `DarwinInfo` object using request headers.

    - Create and refactor classes related to **`DarwinContext` interceptors**:

        - AbstractServletDarwinContextInterceptor → **AbstractDarwinContextInterceptor**

        - DarwinContextFilterFunction → **DarwinContextServletFilterFunction**

        - **DarwinContextFilterFunction** (**New**): interface to be used by `ExchangeFilterFunction` classes that propagate the **DarwinInfo** object into WebClient headers.

        - **DarwinContextReactiveFilterFunction** (**New**): implements the previous interface using **Reactor Context** to get **DarwinInfo** object and propagate it into WebClient headers.

- New way to **disable `DarwinContext` 's filters** using the property `darwin.core.filter.darwin-context.enable` with **false** value (enabled by default).

- Update **`DarwinContext` interceptors** to propagate the headers/fields defined in **new DarwinContext's field "headers"**.

- Refactor **Darwin exceptions hierarchy**

    - `HttpBaseDarwinException` class moved to **darwin-spring-boot-common** module.

    - Update old `BaseDarwinException` uses with `GenericDarwinException`, and its old uses with `HttpBaseDarwinException`.

- **Update Darwin exception management to enable custom configuration:**

    - **Customizable error properties access**: `DarwinErrorsPropertiesAccessor` now implements a **BiFunction&lt;String, DarwinContext, String&gt;** (ErrorsPropertiesAccessor interface is removed) with an unique method to get an error property
        using the error property name and a DarwinContext object.,

    - New `@CustomErrorModel` annotation to annotate an error model as **customizable using the error properties**.

    - New `ErrorModelFactory` class as the **core class to create customizables error models** using all the related pieces: the **configured ErrorModelBuilder** (with or without @CustomErrorModel, default is ErrorModelDarwin) and the **error
        properties accessor BiFunction** (default is DarwinErrorsPropertiesAccessor).

    - **Update Servlet Darwin exception management**:

        - Remove old RedirectUnknownUrls class.

        - Update `DarwinExceptionHandlerController` and `DarwinErrorAttributes` to new exceptions management implementation and make them customizables.

        - Override ***shouldNotFilterErrorDispatch()*** method from `DarwinContextFilter` to return "**false**", so the filter will be executed also in ***error dispatcher***.

    - **Update Reactive Darwin exception management**:

        - `DarwinErrorWebExceptionHandler` now extends **AbstractErrorWebExceptionHandler** instead of DefaultErrorWebExceptionHandler.

        - Update `DarwinErrorAttributes` to new exceptions management implementation and define **two non-Darwin controlled exceptions** (UnsupportedMediaTypeStatusException and NotAcceptableStatusException)

- Everything related to **LeanCore error model** has been moved to a new `darwin-spring-boot-leancore` module.

- `darwin-spring-boot-common`:

    - README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

    - The possibility of defining a map "headers" with headers that will be propagated in the application calls has been added to the `DarwinContext`.

    - Access to the constant **DarwinContextImpl.DARWIN\_INFO\_KEY** is privatized

    - **Darwin exception hierarchy** refactored:

        - The `BaseDarwinException` class is dropped and an abstract `DarwinException` class is created.

        - The `GenericDarwinException` class is now the class with the generic structure for Darwin exceptions.

        - The `HttpBaseDarwinException` class is included in this module as a base exception for Web exceptions (with HttpStatus).

<!end:290>

## 2.8.1-RELEASE Version

<!tag:281>

- The `HttpMessageConverter` of Darwin's `RestTemplate` has been reordered to give priority to the JSON converter
  over the XML one and to resolve a bug when the Partenon library is included.

<!end:281>

## 2.8.0-RELEASE Version

<!tag:280>

- The `AppKeyFilterFunction` class has been renamed to `DarwinContextFilterFunction`
  and new functionality
  has been added for the propagation of the headers found in the `DarwinInfo` of the `DarwinContextHolder`,
  as well as the appKey.

- `DarwinErrorsPropertiesAccessor` has been modified to be internationalized via the Accept-Language header. With this value it will access an error\_&lt;localeValue&gt;.properties (for example: errors\_es\_ES.properties) to obtain the literals
    defined for that locale.

- A new HTTP filter with name `DarwinContextFilter` which intercepts HTTP calls and initializes the `DarwinInfo` object stored in `DarwinContext` from http headers (Accept-Language, X-Santander-Channel, X-Santander-Entity, X-Santander-ThirdParty,
    X-Santander-Device and X-ClientId) and from configuration information (specifically the app-key), has been created.

- Added **detailedMessaged** field customization for exceptions in Servlet applications, and the customization possibility is extended to all the exceptions.

- The new BodyRequestCacheWebFilter filter is created. The filter allows caching the requests Body in reactive applications.

- Properties are created so that projects can modify the default order of the HTTP filters according to their needs.

- A new functionality that allows you to change the output error format by defining a configuration property has been added. The formats that are now available are: Darwin's original and API's CTO. For this to be possible, the
    `ErrorModelExtendedError` class has been added.

- A *Bean* of the `DarwinErrorAttributes` class has been exposed to define the error format when using the BasicErrorController (whitelabel error page).

- `darwin-spring-boot-common`:

    - The `AppKeyInterceptor` class has been renamed to `DarwinContextInterceptor` new functionality has been added to propagate the headers found in the `DarwinInfo` of the `DarwinContextHolder`.

    - The `DarwinInfo` object that encapsulates the information from the headers (and application settings (appKey)) and which is provided to the projects through the `DarwinContext` context has been created.

    - A new functionality that allows you to change the format of the error output by defining a configuration property has been added. Now, the following formats are available: Darwin's original and API's CTO. For this to be possible, a new
        `LeancoreErrorModel` class has been added, equivalent to `ErroModel` and containing the new format..

<!end:280>

## 2.7.0-RELEASE Version

<!tag:270>

- The new DarwinErrorWebExceptionHandler class overrides the behavior of the Spring ErrorWebExceptionHandler class so that, when the request only accepts HTML, if an error occurs during the execution of the business logic, it is always returned
    in JSON format.

<!end:270>

## 2.6.2-RELEASE Version

<!tag:262>

- The Swagger properties are created.

- `darwin-spring-boot-common`:

    - The NoProductiveProfile annotation is created. This class allows you to annotate Components that will only be created in non-productive environments.:

        - Additionally, new methods for managing profiles are created through DarwinUtils.

<!end:262>

## 2.6.1-RELEASE Version

<!tag:261>

- A bug with the configuration of SSL certificates for RestTemplate has been fixed.

- A bug with the default configuration for WebClient and WebClient.Builder has been fixed.

- `darwin-spring-boot-common`:

    - The ErrorModelGateway class is published to model a Gateway error

<!end:261>

## 2.6.0-RELEASE Version

<!tag:260>

- In order to access the literals defined in the error.properties,
  a class is created providing a bean of ErrorsPropertiesAccessor in the context
  and making the obtaining of these resources independently of the web environment.

- Socket level timeouts and waiting time to retrieve a pool connection for WebClient are configurable, in addition the default values of the RestTemplate pool have been modified

- Two new thread management strategies are added for DarwinContext.

- The code created to solve the issue in the fallback of previous versions of resilience4j is eliminated

- Resilience4j dependencies are moved to the Authentication library to avoid unnecessary transitive dependencies.

- DarwinExceptionHandlerController and DarwinErrorAttributes are adapted to handle all Darwin exceptions from BaseDarwinException.

- **CoreAutoConfig** web component's auto configuration is conditioned:

    - A conditional configuration class **CoreAsyncAutoConfig** is created for the decorators configuration in asynchronous invocations.

    - A conditional configuration class **CoreServletAutoConfig** is created for the configuration of applications in Servlet environments.

    - A conditional configuration class **CoreReactiveAutoConfig** is created for the configuration in Reactive applications environments.

    - A conditional configuration class **CoreActuatorAutoConfig** is created for the actuator endpoints configuration.

    - An internal configuration class is created in **CoreHystrixAutoConfig** in order to condition the creation of a `HystrixMetricsBinder` bean when is a Web Application that includes a `WebEndpointProperties` bean.

    - The `CoreProperties.WebClient` class is extracted to a separate class to enable these properties on the condition that the Spring WebClient is in the classpath.

    - The following dependencies are marked as optional: spring-webflux, httpclient, reactor-netty, spring-boot-actuator-autoconfigure, and micrometer-core.

- Two classes that implement the following conditions are created::

    - `ServletOrNotWebCondition`: Servlet or NotWebApp Web Applications

    - `ReactiveOrNotWebCondition`: Reactive or NotWebApp Web Applications

- New interceptor that copies the security and darwin contexts between the Tomcat transport thread (main thread) and the WebClient thread (reactor thread).

- `darwin-spring-boot-common`:

    - Separate module competencies focused on Web applications:

        - The dependency for reactor-netty is replaced by spring-webflux, and it is marked as an optional dependency along with the one for spring-web.

        - BaseDarwinException is defined as Darwin's base exception, being GenericDarwinException the first in the hierarchy to contain HttpStatus.

        - ErrorModel is adapted to be able to generate the JSON of any Darwin exception from BaseDarwinException.

    - `AuthorizationService` interface and the `AuthorizationData` class added in order to implement the Authorization api in NotWeb applications.

<!end:260>

## 2.5.1-RELEASE Version

<!tag:251>

- The maximum number of total connections and per route in the provided RestTemplate and the maximum number of total connections in the provided WebClient Builder are made configurable.
  Adding three new properties to the core configuration.

<!end:251>

## 2.5.0-RELEASE Version

<!tag:250>

- Prevent from showing as activity trace the calls to actuator in reactive micros with application and actuator configuration on different ports.

- DarwinResilience4jConfig auto-configuration class is removed

- `darwin-spring-boot-common`:

    - The constructor of AuthenticationParameters is replaced by three static methods so that one of the possible tokens is always included: JWT, Corporate (BKS) or ocJWT.

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- The log level is changed to warning and the stackTrace is suppressed when exceptions are thrown due to the user not being authenticated, the error stackTrace is traced at debug level.

<!end:243>

## 2.4.0-RELEASE Version

<!tag:240>

- A refactoring of the package has been performed. It includes the following changes::

    - "Core" is defined as the root package for the library.

    - A common and specific self-configuration is defined according to the Web execution environment: Servlet or Reactive.

    - All configuration classes and properties are located within a single "config" folder.

    - Restructuring of the existing packages (filter, exceptions, async, etc.).

- Added to the documentation how to manage the "mapExtendedMessage" field corresponding to Darwin exceptions

<!end:240>

## 2.3.2-RELEASE Version

<!tag:232>

- DarwinContextWebFilter creation is included in the automatic configuration.

- A bug in the WebFilter chain (DarwinContextWebFilter) whereby the existence of the DarwinContext in the reactive context was not correctly checked for its creation has been fixed.

<!end:232>

## 2.3.0-RELEASE Version

<!tag:230>

- The first version compatible with Spring-MVC and Spring-WebFlux is released.

- The documentation is improved indicating the new functionalities of WebClient.Builder. New entries for DarwinContext in its servlet and reactive paradigms.

- Starting with this release, it will no longer be necessary to mark beans of type WebClient and WebClient.Builder with the @DarwinQualifier annotation. At application startup, all beans of type WebClient and WebClient.Builder will be detected and
    the AppKeyFilterFunction interceptor will be injected. This will be the default behavior, and you can disable it through the darwin.core.webclient.enabled = false property.

- The DarwinContextWebFilter class is included, and its corresponding test, which creates a Darwin Context at the beginning of the execution.

- The DarwinErrorAttributes class is included. This class, generates the response body for the exception handler in a Reactive application, maintaining the structure used in the exception handler for Servlet applications. Depending on the type of
    application, one or the other will be configured.

- `darwin-spring-boot-common`:

    - PLR channel is added

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- Fixed a bug where the AppKeyFilterFunction was not being injected into @Darwin WebClient.Builder.

- The 'org.hibernate' group of the hibernate-validator dependency is modified to 'org.hibernate.validator'. Also, the dependency specific version is set by the Spring framework itself.

<!end:220>

## 2.1.0-RELEASE Version

<!tag:210>

- Added a metric publisher for Hystrix to capture the state of the circuits.

- The way the application name is retrieved in case of exception has been changed in order to avoid an error.

- A WebClient.Builder bean type is created for the components to inject it. The bean contains the necessary filters to propagate all the Darwin information in the calls made with it.

<!end:210>

## 2.0.0-RELEASE Version

<!tag:200>

- The AppKeyInterceptor class has been moved from the core library to common and has change its package to `es.santander.darwin.common.interceptors`

- `darwin-spring-boot-common`:

    - We moved the AppKeyInterceptor class from the core library to common and change its package to `es.santander.darwin.common.interceptors`

    - The SantanderUserDetails interface is renamed to DarwinUserDetails.

    - The DarwinUserDetails interface is modified to return Optional in the methods in which we cannot ensure that there will always be data.

    - The AuthenticationParameters class is modified to conform to the changes made in DarwinUserDetails

<!end:200>
