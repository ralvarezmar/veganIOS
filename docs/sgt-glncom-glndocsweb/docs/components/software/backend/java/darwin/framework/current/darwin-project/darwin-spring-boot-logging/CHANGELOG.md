# Change Log

## Version 6.3.4

<!tag:634>

### 🐞 Bug Fixes

- The `Darwin Task Decorator` and `@Observed` annotation observations are included in the extended-traces configuration class to exclude their creation when the `darwin.logging.activity.extended-traces.enabled` property is set to false.

### 📔 Documentation

- Improved documentation regarding the automatic activity traces.  

<!end:634>

## Version 6.3.2

<!tag:632>

### 🐞 Bug Fixes

- The issue where the @ObfuscateFunctionalLog annotation did not work correctly when the REST mapping controller was defined in the interface instead of in the implementation class has been resolved.
- The issue where Functional helpers were always configured with an `ObfuscationServiceImpl` instance, even when the JsonPath dependency was excluded, has been resolved.

<!end:632>

## Version 6.3.0

<!tag:630>

### 🐞 Bug Fixes

- Fixed issue that prevented `excludeLoggingPaths` from being overwritten if any bean of type `Set.class` was defined in the application.

<!end:630>

## 6.2.0 Version

<!tag:620>

### ⭐ New Features

- Added `coreUserId` claim from JWT tokens to traces with `GLUONLOG` format. This property is extracted from JWT authentication tokens, stored in DarwinContext, and now properly mapped to logging traces.

<!end:620>

## 6.1.2 Version

<!tag:612>

### 🐞 Bug Fixes

- Web client activity log now displays the destination URL in case of response error.

### 📔 Documentation

- Documented that it is necessary to add the property `management.observations.annotations.enabled=true` for the correct
  functioning of the `@Observed` annotation.

<!end:612>

## 6.1.1 Version

<!tag:611>

### 🐞 Bug Fixes

- Bug fix that caused a mistake when the LogFormat was `GLUONLOG`. The environment configured for the traces wasn't valid.

<!end:611>

## 6.1.0 Version

<!tag:610>

### ⭐ New Features

- New properties to disable kafka validation for Darwin Logging (`darwin.logging.kafka.validation.enabled`)
  and Gravity (`darwin.logging.gravity.kafka.validation.enabled`).
- Optimize validation of the connection to Kafka for Gravity topics. Validate once instead of once per topic.

### 🐞 Bug Fixes

- Bug fix that caused logging configuration (both Darwin and Gravity logging) to fail, don't retry and abort when creating the Kafka `AdminClient` returned an `org.apache.kafka.common.KafkaException: Failed to create new KafkaAdminClient`.

<!end:610>

## 6.0.0 Version

<!tag:600>

- Added new property to filter Spring observations `darwin.logging.observability.filter.black-list`. We change the
  default value of `darwin.logging.observability.filter.white-list` to empty and set the black-list to spring security
  observations `"spring.security.authorizations", "spring.security.filterchains","spring.security.http.secured.requests", "spring.security.http.unsecured.requests"`.
- All Spring observations are traces as activity log.
  This includes http request, client http calls, Darwin task decorator, observed annotation, and other.
  If you want recover the old behaviour you can disable the property `darwin.logging.activity.extended-traces.enabled`.

- Remove property `darwin.logging.observability.gluon-features.enabled`. The gluon behavior is always enabled.
- Added new property to set traceId size `darwin.logging.observability.traceid-128-bit-enabled`, default value `false`.
- Complete documentation about tracing and observability.
- Added new property to enable join span tracing `darwin.logging.observability.span-joining-enabled`.
- Improve documentation about baggage fields configuration.

<!end:600>

## 5.7.0 Version

<!tag:570>

- Fixed an issue where some traces were displayed at microservice startup when using Logback logging.

<!end:570>

## 5.6.0 Version

<!tag:560>

- Added a new method for FunctionalLogHelper and FunctionalReactiveLogHelper to include the error field in logs .
- Fix **GLUONLOG** format to comply with the **GLOBALOG v3.0.0** standard: Add fields `isGluon=true` and `customLog.userId` and the `error` field is modified to be a `Boolean` instead of a `String`.

<!end:560>

## 5.5.0 Version

<!tag:550>

- Show a warning log when there is no logging kafka server configured.
- With logback and kafka mode active if we have issues sending traces to kafka don't show in console functional or security logs to avoid confidentiality issues.
- With logback and kafka mode active if we have issues sending traces to kafka keep the console log format instead of use JSON always.
- Logback implementation don't send logs to kafka if it doesn't have a valid broker configured.
- Fixed the problem using JSON Technical pattern trace format. From this version onwards, the JSON format is applied to the root logger as well.

<!end:550>

## 5.4.0 Version

<!tag:540>

- Added SASL_SSL security protocol to the list of supported security protocols for Kafka.
- Updated documentation about Functional Reactive Log Helper which now states that is not recommended its use in @Async and Reactive modes due to limitations.
- Manage new "businessId" and "sessionId" observability fields.
  - Read and propagate the "businessId" and "sessionId" headers.
  - Add these fields to the Gluon customLog as "businessReference" and "sessionReference".
- Extracted Logging Patterns formats documentation to an independent file LOGGING-PATTERNS.md.
- Support the `@Observed` annotation of micrometer. With this annotation we can observe methods and have them reflected in the activity log.
- Allow update observability fields `SessionId` and `BusinessId` with the new annotation `@UpdateBaggage`.

<!end:540>

## 5.2.0 Version

<!tag:520>

- Added `spring-boot-starter-aop` to `darwin-spring-boot-starter-logging-logback-basic` because is necessary for obfuscate logging functionality.
- Define a property to allow disabling events traceability.
- Improve documentation regarding context progressing in reactive mode.

<!end:520>

## 5.1.0 Version

<!tag:510>

- New module of logging `darwin-spring-boot-logging-logback` using logback as backend
- Fixed the issue that caused the Kafka trace mode to always load when the Kafka client dependency was present. Now it only loads if the `darwin-spring-boot-starter-logging-kafka` dependency is present.

<!end:510>

## 5.0.2 Version

<!tag:502>

- Fix error using LoggingProperties as CGLIB proxy.

<!end:502>

## 5.0.0 Version

<!tag:500>

- Add a new property (`darwin.logging.console-log-format`) to configure the format of *Console Technical traces* with `HUMAN_READABLE` or `JSON` format.
- Fix RestTemplate/WebClient BeanPostProcessor creation to avoid creating LoggingProperties early.
    - Modify LoggingInterceptor and LoggingFilterFunction constructor method.
- Add info about how Gluon "componentVersion" field is set in the documentation.
- Unify the Darwin Interceptors creation to improve the performance.

<!end:500>

## 4.3.0-RELEASE Version

<!tag:430>

- Gluon log is sent to kafka without replace variables:
    - Fix issue with empty fields when sending logs with Gluon format to Kafka
    - Fix bug with Gluon format logs when using W3C traceability mode

<!end:430>

## 4.2.0-RELEASE Version

<!tag:420>

- Fixed documentation typo on the global logging technical format JSON.
- The `ROOT` (`logging.level.ROOT`) property can be used to configure the log-level for the Root logger.
- Amend pom.xml to verify module in native mode.-
- Add compilation hints support for native image.
- New class DarwinLoggerNames & deprecated DarwinLoggingConfiguration.DarwinLoggerName.
- Add support for working without log4j, necessary for native image.
- Change in filters to support changes in spring framework 6.0.14. (Later initialization of span in http requests).
- Necessary changes to allow channel from Jwt token to be written in logs.

<!end:420>

## 4.1.1-RELEASE Version

<!tag:411>

- Change the level from `WARN` to `ERROR` in the applyPath method trace inside ObfuscationServiceImpl class
- Set `PLAINTEXT` as default security protocol for Gravity Kafka appenders.

<!end:411>

## 4.1.0-RELEASE Version

<!tag:410>

- Adding new fields in functional patterns and technical patterns.
  These fields refer to the Job and Step ID and are only visible during the execution of a batch.

- Add boot version in functional, activity and technical patterns.
- Removing literal "End of method" and "End of endpoint" from Manual Activity Log, from Automatic Functional Log and from Activity Log.
- Manual Functional Log: The traceLog field is now optional and if it is not specified, it will be obtained by taking the URL of the context or as a empty space in case it is empty.
- Manual Functional Log: now it is possible to add a new field "functionalCustomLog" to include extra information.
- Solve issue in GLUON log format. The appKey was not correctly informed.
- Clarify documentation about:
  - Explain the behaviour of the loggers and appenders after setting a custom the Gravity configuration.
  - Logging configuration when basic starter is used.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- New bean `darwinObservationTaskDecorator` to progress observation context and instrument async thread pool.

- **Use Micrometer-Reactor solution** to propagate context and update MDC in Reactive applications (previously done with Sleuth).

- Keep **support to joined spans** by default.

- Add **white-list with enabled observations** and flag to enable or disable such white-list.

- Added new property `darwin.logging.observability.gluon-features.enabled` to enable/disable observability functionality required by GLUON.

- **Set traceId to 64 bits** by default

- Added individual Gravity logging patterns.

- Updating the domain of the Sampling properties.

- Add new log format GLUONLOG by default.

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Update timeout for DefaultValidator from 1500ms to 5000ms. This validator is used to validate the kafka endpoints of logging and business event

- Fix a bug that configures automatic Functional traces with an empty endpoints list

- Add new log format GLUONLOG.

- Allow customization of ObjectMapper in Logging Helpers.

<!end:327>

## 3.2.5-RELEASE Version

<!tag:325>

- Fixed an issue where the logging environment was not correctly set in SPAIN mode

- Added individual Gravity logging patterns.

<!end:325>

## 3.2.4-RELEASE Version

<!tag:324>

- Document ***darwin.logging.kafka.unique-topic*** property

- Escape activity Log to avoid vulnerabilities

- Traces (functional, security & technical) logged in console depending on kafka server

<!end:324>

## 3.2.3-RELEASE Version

<!tag:323>

- Improving the Logging Gravity configuration in order to allow the projects to specify a topic for each package/class defined: `darwin.logging.gravity.appender.package-info`

<!end:323>

## 3.2.1-RELEASE Version

<!tag:321>

- New deferred appenders configured don't use the Darwin's "kafkaValidator" as default *BooleanSupplier* validator.

- Improving the LoggingConfig API. Now Developers can add AppenderRefs in order to associate a DeferAppenders that already exists to a custom logger.

- Adding the Logging Gravity configuration in order to add the Gravity Kafka appender.

<!end:321>

## 3.2.0-RELEASE Version

<!tag:320>

- Make kafka dependencies optional. Create new starter to import logging without kafka.

- Deleting deprecated components in logging module.

- Optimize dependencies. Eliminate redundant, unused and deprecated dependencies.

- Support new blockable `ReactiveFunctionalLogger` interface.

- Support multiple `FunctionalLogger` or `ReactiveFunctionalLogger` working at the same time

- Move code (before in omnichannel module) witch recover contactPoint baggageField from context and update such bagaggeField.

- Now Darwin Core can enable/disable the propagation headers.

- Write a **custom ActivityLog trace after Partenon executions**

- Support new `GLOBAL` format for Activity, Technical,
  Functional and Security trace patterns.

- Functional Data Obfuscation

    - Added support for the ObfuscateFunctionalLog annotation in order to be used with automatic Functional traces.

    - FunctionalLogHelper and FunctionalReactiveLogHelper now support obfuscation annotation capacities.

    - Documentation "how to add fields in log patterns".

- Logging `SPAIN format` has been marked as **Deprecated,** and it will be removed in the following version.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Adding support for logging operation type and operation name in activity traces and functional traces. In order to that, ActivityLogger and FunctionalLogger implementations have been change to print a new message where operation type and
    operation name is used. Logging web filters (both reactive and servlet) have been updated in order to read and propagate properly the operation name and operation type. The necessary instrumentation for adding the new values to the MDC is added
    as well.

- Adding support for `MANUAL` instrumentation type.

    - Adding changes in logging instrumentation in order to adapt it to instrumentation mode defined.

    - LoggerReactiveContext utility class is refactored in order to support dual instrumentation. New functions are added in order to facility to trace on Reactor operators.

    - `FunctionalReactiveLogHelper`: `trace` method has been added in order to facility the use of helper class. The new public method returns a consumer function which one should be used on `doOnEach` operator.

    - Static method `log(String traceLog, Map<String, Object> businessLog)` in `FunctionalReactiveLogHelper` has been marked as `Deprecated`: Now it recommends to trace `trace(SecurityLogData securityLogData)`.

    - `SecurityReactiveLogHelper`: `trace` method has been added in order to facility the use of helper class. The new public method returns a consumer function which one should be used on `doOnEach` operator.

    - Static method `log(SecurityLogData securityLogData)` in `SecurityReactiveLogHelper` has been marked as `Deprecated`. Now it recommends to trace `trace(SecurityLogData securityLogData)`.

    - `LoggingServiceReactiveImpl` has been marked as `Deprecated`. Now it recommends to use the new class service `LoggingServiceReactorImpl`.

    - `LoggingServiceReactorImpl` has been added in order to facility the use of the service on reactor streams. The class has a public method `log` that it returns a consumer function which one should be used on `doOnEach` operator.

    - Removing `darwin.logging.reactive.disable-hook` property and deleting LoggingEnvironmentPostProcessor class.

    - Marking as `Deprecated` the following methods in `LoggerReactiveContext` class:

        - ***trace(ContextView contextView, Logger log, String format, Object…​ arguments)***

        - ***debug(ContextView contextView, Logger log, String format, Object…​ arguments)***

        - ***info(ContextView contextView, Logger log, String format, Object…​ arguments)***

        - ***warn(ContextView contextView, Logger log, String format, Object…​ arguments)***

        - ***error(ContextView contextView, Logger log, String format, Object…​ arguments)***

        - ***error(ContextView contextView, Logger log, String format, Throwable t)***

- Adding support for content-type "application/graphql+json" and some content-type related bugs are fixed.

    - Do not cache content-type to validate whether an endpoint has to write the functional log. This entails removing the field `MediaType contentType` from the public method `isLoggableEndpoint`. We have left the old method deprecated to ensure
        compatibility.

    - Check the content-type using the method `isCompatibleWith`.

    - Remove unused and undocumented public method from `AbstractFunctionalLogger`.

    - Removed condition to support a null path in the protected method `log`. A path with value must always arrive to this method.

- Fix bug to support ***input*** field from FunctionalLog in async requests

    - Also wrap and propagate the request using a ResettableStreamHttpServletRequest only once.

- Adding new fields in activity pattern and technical pattern.

    - Adding the new `channel` field to technical pattern and activity pattern.

    - Adding the `contactPoint` field to the activity pattern.

    - Adding the http instrumentation in order to fill in the channel field with the channel information from DarwinContext.

    - Now, in the reactive filter, the TraceContext is used for updating BaggageField. In this way, it is ensured that the BaggageFields values are added to the proper context.

- Resolve *error* field from ActivityLog for GraphQl applications too.

- New ***log(HttpStatus, T, Map&lt;String, String&gt;)*** method in `ActivityLogger` to deprecate previous *log(HttpStatus, T)* method.

- Optimize DarwinLoggingFilter in async request. Only update baggages in first step

- New filter to inform user as Baggage Field (before we do it in security module)

- Adding the new `darwin.logging.kafka.protocol-validation.enabled` property in order to allow to disable security protocol verification. This verification only supports `PLAINTEXT` and `SSL` protocols. Disabling the validation is possible to use
    `SASL_PLAINTEXT` and `SASL_SSL` as security protocol for Kafka communications.

- Reading darwin region as property instead of environment variable. Before it was mandatory to define it as environment variable. Now, it can be defined as property or environment variable and it will appear filled both kibana traces and console
    traces. Issue in connection with

- Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

<!end:310>

## 3.0.4-RELEASE Version

<!tag:304>

- Substituting manually env variables value references in the logs pattern for the Kafka Appenders in order to solve the bug found in the traces sent to Kibana after upgrading the log4j2 version for replacing the dependency version with
    vulnerabilities.

<!end:304>

## 3.0.3-RELEASE Version

<!tag:303>

- Updating TracestateFormat in order to adapt the implementation to the new changes in the interface.

<!end:303>

## 3.0.2-RELEASE Version

<!tag:302>

- Changing the log level from error to warn for errors during the validation of the connection. In addition, error trace is added if it is not possible to connect to kafka.

- Deleting deprecated `logLevel` class property and deprecated `getLogLevel` getter from LoggingProperties. In addition, all the documentation about the use of `darwin.logging.log-level` property has been deleted from Logging Documentation.

<!end:302>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Disabled AdminClient retries. Kafka validator retries have to be controlled by Darwin retry component.Timeout (6000 ms) for list topics operation is set.

- Translate to english.

- Remove ThreadName BaggageField

- Dependencies and plugins upgrade:

    - Now, Logging configuration create ***PARENT\_ID*** and ***SAMPLED*** BaggageFields.

    - Using new module Spring Cloud Sleuth Brave

    - B3 MDC fields have changed. Using new names: traceId, spanId, parentId, sampled. Updated patterns with new MDC references in LoggingProperties and appender filter to use sampled MDC field in Sampling instrumentation.

- Added Sampling support for activity traces in HTTP instrumentation.
  In addition, threshold mode by log level is configurable for technical traces.
  For activity traces, threshold mode only will be applied for Error log level.

- Darwin ListenerMethodInterceptor is improved to fill in traceState
  and traceParent BaggageFields either from span context
  or from ingoing event W3C TraceContext headers if these exist.

- Update the metadata files with the rules defined in the Darwin Spring Migration Checklist.

- Deleted deprecated property `darwin.logging.log-level` and its effective use.

- **Reduce NotWeb application modes**: now there is a unique NotWeb mode which **always include HttpClients** (RestTemplate/WebClient)..

    - Remove `RestTemplate/WebClient's` ConditionalOnClass from configuration.

    - Remove `org.apache.httpcomponents:httpclient` dependency.

- `ResettableStreamHttpServletRequest` moved from Common library.

- Solved bug at functional log property `darwin.functional.logged-endpoints` about lists values.

- Added Sampling support for functional traces in HTTP instrumentation.

- Fix Sonar issues

- Using @EmbeddedKafka

- Parallelising the load of deferred appenders using an Executor. Now, Deferred appenders are loaded in parallel with the load of logging configuration.

- Refactoring Sampling documentation. Adding `darwin.logging.threshold.mode` property to set sampling mode for threshold filter.

- Rename "securityLogData" field from `SecurityLogData` class to "**status**"

- Remove in all parts of the FW the property allow-bean-definition-overriding

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- The classes and interfaces 'DefaultLoggingConfig', 'DefaultLoggingConfigBuilder', 'DeferAppender', 'LoggingConfig' and 'LoggingConfigCustomizer' are moved from package 'com.santander.darwin.logging.config' to package
    'com.santander.darwin.logging'. In addition, the configuration classes 'LoggingServletAutoConfig' and 'LoggingReactiveAutoConfig' are made private

- Using new API of Reactor.

    - Using new readonly reactor context object (ContextView) to access to the values of the context.

    - Using new getContextView() function from Signal object to access the values of the Reactor context.

- Simplifying and unifying BaggageField class configuration. Improving readability of the classes and beans names.

- Refactoring use of ReactiveDarwinContextHolder.

    - Removing LoggingContext properties that they already exist in DarwinInfo

    - Removing unnecessary use of ReactiveDarwinContextHolder.

    - Simplifying reactive stream limiting the access to the reactor context

- Validating that the type of connections with the Kafka host match the security protocol defined (SSL default).

- Removing MDC.clear() from LoggingWebFilter. MDC was dropped at first and the tracing values weren't removed. Traces had traceId and spanId fields empty.

<!end:300>

## 2.11.1-RELEASE Version

<!tag:2111>

- Now it is possible to disable the automatic generation of activity traces in the Kafka MessageListenerMethodInterceptor
  using the logging property *darwin.logging.activity.enabled*.

<!end:2111>

## 2.11.0-RELEASE Version

<!tag:2110>

- Now, SSL is enabled in the communication (by default) with the logging topic. It is necessary to update the darwin logging configuration [to
    migrate](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/migration.html) from older versions.

- Adding logging support to extend the functionality of the interceptors to create an activity trace associated with the sending and receiving of messages.

- Adding W3C headers in the logging patterns. In addition, sleuth parentSpansId header is added to logging patterns as well.

- Adding support for propagation of W3C headers. When a request contains tracestate and traceparent headers, both of them will be propagated in any outgoing request.

- Clean MDC properly when doing an automatic activity/functionalLog and when using FunctionalLogHelper and SecurityLogHelper.

- The *app-init* header is no longer propagated in this module. The *app-init* header now propagates on the core module (filters and interceptors).

- The *Contact-Point* header is no longer propagated in this module, now this functionality is part of the **darwin-spring-boot-omnichannel** module.

<!end:2110>

## 2.10.3-RELEASE Version

<!tag:2103>

- Modify the disable-hook mode: the sleuth connector for WebClient is used and the userId is obtained from a Baggage.

- The log for the reactive web application gets TraceContext directly instead of through the MDC.

<!end:2103>

## 2.10.2-RELEASE Version

<!tag:2102>

- Removing use of MDC in Servlet interceptors for RestTemplate and WebClient. Now, Sleuth instrumentation and BaggageFields are used.

- Adding support for Baggage Propagation in Darwin W3cTraceContext. When W3C TraceContext has not compatibility with B3, it is disabled, a CompositePropagation is created with TraceContext as the first propagation method applied. B3propagation is
    also added to keep the compatibility with Baggage propagation.

<!end:2102>

## 2.10.1-RELEASE Version

<!tag:2101>

- Improving templates to validate more field in the patterns of the appenders output.

- By default, all loggers will be created with additivity property set to false.

- Remove **@Deprecated** annotation in LoggerReactiveContext class.

- Clean MDC after do an activityLog in reactive noHook mode.

<!end:2101>

## 2.10.0-RELEASE Version

<!tag:2100>

- The *organization* header is no longer propagated in this module. The *organization* header now propagates on the core module (filters and interceptors).

- Remove lifter hook for reactive environment. Now, Baggage will be used to work with the MDC on the web filters and service components.

- Allows adding deferred appender with custom validator.

- Log4j2 XML configuration is added to the documentation.

- Allow customization of ActivityLogger and FunctionalLogger for Web requests filters.

- Documented how to enable traces for Tomcat and Catalina. Removed individual Log4j2 dependencies and added Spring Boot Log4j2 starter

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- Allow logging custom configuration

    - LoggingConfig.Builder interface has been created to allow full customization over the logging configuration.

    - LoggingConfig interface has been created to represent the logging configuration.

    - MetricsLogHelper class change its location to Metrics library.

    - The creation of the metrics logger and the metrics kafka appender is moved to Metrics library.

    - Test property has been removed. Now, It is possible to define custom logging configurations by environments.

- Misbehavior of loggeg-endpoints property as List fixed

- W3C TraceContext support added

- Logging filter order changed from -5 to -105

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

- Configuration ProxyBeanMethod set to 'false' in DisableHookConfiguration class.

- AppKey property modification @NotBlank. From now on, this property can't be empty

- The **inputTimeStamp** defined in the reactive DarwinContext DarwinInfo is used for activity traces

<!end:290>

## 2.8.0-RELEASE Version

<!tag:280>

- The Kafka appender creation process runs asynchronously. For the of connection validation with Kafka, the retry resilience pattern has been applied.

- WARN traces that were printed in the log during the validation process of Kafka connection have been removed.

- The content of the functional log "output" object has been modeled to be in the correct JSON format.

- In the logging filter, the request body has been prevented from being cached for certain `content-type` (APPLICATION\_PDF, IMAGE\_GIF, IMAGE\_JPEG, IMAGE\_PNG, MULTIPART\_FORM\_DATA, TEXT\_MARKDOWN) leaving it as an empty parameter in the
    functional log trace. Also for reactive log filter, any request body larger than 1 MB is not cached.

- The `log4j2.DiscardThreshold` property value has been set to `OFF` for all logs of any level to be discarded when the queue is full.

- The `ServletLoggingService` and `ReactiveLoggingService` classes referring to notWeb environments have been renamed to `LoggingServiceImpl` and `LoggingServiceReactiveImpl` respectively.

<!end:280>

## 2.6.2-RELEASE Version

<!tag:262>

- The `LoggingEnvironmentListener` will now reconfigure Darwin's logging context when the configuration is refreshed by calling ***/actuator/refresh (RefreshScopeRefreshedEvent)***.

- Fixed a bug in `DarwinLoggingFilter` where the functional log did not retrieve the ***output*** when the response has been wrapped in a **ResponseEntity**.

- Hook configuration for reactive environments now is done in the postConstruct of the LoggingProperties. This ensures that the code is executed when all the configuration parameters have been resolved correctly.

<!end:262>

## 2.6.0-RELEASE Version

<!tag:260>

- The ReactiveLoggingService and ServletLoggingService classes are created which allow launching an activity trace from a not-web application.

- When checking the connection to the Kafka server, the timeout is removed leaving its default value to 2 minutes and making it configurable under the 'request.timeout.ms' property.

- Error in the functional log implemented by the framework

- The link that points to the "Common and specific log fields" in Confluence has been corrected in the documentation

- We added `reactor-netty` and `spring-webflux` dependencies as **optional**, they were previously obtained from the **darwin-spring-boot-core** module

- The components auto-configuration is conditioned depending on the application type to instantiate. The logging library can be used for both web applications (**Servlet or Reactive**) or not-web applications:

    - `LoggingAutoConfigWebClient` is created as a conditional configuration class. It's created for **WebClient** configuration if it is in the classpath of **Servlet or Reactive** web applications.

    - The `DarwinRestTemplatePostProcessor` with Logging interceptor is now configured only for **Servlet** web applications.

    - The `RestTemplateInterceptorInjector` class is eliminated because its functionality is already implemented within the `LoggingWebAutoConfig` class through the use of `DarwinRestTemplatePostProcessor`.

    - `LoggingReactiveAutoConfig` configuration class instantiation is conditional for **reactive** environments. It only contains the required beans for this application type.

    - `LoggingWebAutoConfig` configuration class instantiation is conditioned for **Servlet** environments. It only contains the required beans for this application type.

    - The `LoggingAutoConfig` configuration class has the basic functionality to be instantiated and is independent of the type of application.

    - All not basic dependencies and whose use is tied to a particular type of application are marked as optional.

    - The HTTP clients instrumentation is refactored and added to the LoggingAutoConfiguration class, its instantiation is conditioned only for supported cases.

- The use of the **joda-time** API is eliminated and only the **java-time** API of the JDK is used.

<!end:260>

## 2.5.2-RELEASE Version

<!tag:252>

- The `REGION` field is added to the activity log.

<!end:252>

## 2.5.1-RELEASE Version

<!tag:251>

- Warning trace when executing functional log, has been removed.

<!end:251>

## 2.5.0-RELEASE Version

<!tag:250>

- The reactive automatic functional log is enabled for the configured endpoints, correcting a memory leak in it.

- When neither the functional log nor the activity log have been activated, the Logging filter that performs the automatic log will not be instantiated.

- By default, for reactive applications, "log4j2.asyncLoggerWaitStrategy" is set to "Sleep". The goal is to minimize the work of the producer thread.

- A new log type has been added to be able to record metrics on Darwin platform. The MetricsLogHelper class is provided for the generation of these logs.

- Logging environment sanitation is changed.
  Now, it is done directly in the logging properties class instead of the LoggingEnvironmentListener.
  This, allows to access the sanitized logging environment whenever the property is used. \#NUARMICROS-1460**

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- Documentation modification to recommend to the projects to use the default configuration of the `darwin.logging.paasproject` property
  and `darwin.logging.kafka.topic.(functional | security | activity | technical)` kafka topics.

- The logLevel property getter of LoggingProperties has been overwritten to return a deep copy instead of a value as a reference (shallow copy).

- LoggingEnvironmentListener collects and gives preference to logLevels for technical packages defined in the Spring properties ("logging.level") over Darwin properties ("darwin.logging.log-level").

<!end:243>

## 2.4.1-RELEASE Version

<!tag:241>

- Two new fields have been included in the FRONTEND pattern: dwVersion and wrapperDwVersion.

<!end:241>

## 2.4.0-RELEASE Version

<!tag:240>

- Any reference to the `darwin.logging.functional.active` property has been removed from the documentation as it was set as deprecated in the Darwin migration guide.

- The **functional log helper** and **security log** have been implemented in a reactive way.

- The bug found in the non-reactive part of the **helper functional log**, whereby the sent log was not being correctly formed, has been solved.

<!end:240>

## 2.3.2-RELEASE Version

<!tag:232>

- The `darwin.logging.​functional.active` property has been removed from the documentation (Configuration section) as it was set as deprecated in the Darwin migration guide.

<!end:232>

## 2.3.1-RELEASE Version

<!tag:231>

- The Default value of the security topic has been corrected:

    - security = "nuar-segu-log";

- Vulnerabilities detected by Fortify tool have been fixed.

<!end:231>

## 2.3.0-RELEASE Version

<!tag:230>

- The first version of the logging starter compatible with Spring-MVC and Spring-WebFlux, has been released.

- Starting with this release, it will no longer be required to mark `WebClient` and `WebClient.Builder` bean types with the annotation `@DarwinQualifier`. At application startup, all `WebClient` and `WebClient.Builder` bean types will be detected,
    and the interceptor `LoggingFilterFunction` will be injected. This will be the default behavior, and you can disable it through the `darwin.core.webclient.enabled = false` property.

- The topics associated with the log type will be set by default:

    - functional = "nuar-func-log";

    - activity = "nuar-act-log";

    - security = "nuar-sec-log";

    - technical = "nuar-msrv-log";

    - frontend = "nuar-front-log";

- The `paasProject` logging property will be filled automatically from the `PROJECT_NAME` environment variable.

- The bug in which the root logger was not being correctly created, has been fixed.

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- We fixed a bug whereby `LoggingFilterFunction` was not being injected into `@Darwin WebClient.Builder`.

- A bug that caused some cases to not write the functional log input correctly has been fixed.

- We fixed bug about activity log inputtimestamp.

<!end:220>

## 2.1.4-RELEASE Version

<!tag:214>

- All Spring AOP dependencies have been removed. Now the logging library has been re-implemented using filters instead of aspects.

- The fact that `ResettableStreamHttpServletRequest` is not resettable in multiparts, caused a bug that has been fixed.

- A bug that caused a wrong behavior in the logging library and using SSE (Sever-Sent Events) has been fixed.

<!end:214>

## 2.1.3-RELEASE Version

<!tag:213>

- The bug whereby activity traces were not being generated when the request was content-type = multipart type, has been fixed .

<!end:213>

## 2.1.2-RELEASE Version

<!tag:212>

- In order to avoid excessive memory use we added default values to the configuration of the asynchronous logs of log4j.

- In order to increase performance to the Kafka appender configuration, we added default values to the configuration.

- It is allowed to add log4j system properties from the application configuration (darwin.logging.system-properties).

<!end:212>

## 2.1.0-RELEASE Version

<!tag:210>

- The aspects that were in charge of tracing the activity and functional requests in the microservices,have been eliminated. As of this version, these traces will be generated from the `DarwinLoggingFilter` filter.

- A `WebClient` filter has been created. From now on all the requests will carry the `X-Client-Id` header with the application AppKey value.

<!end:210>

## 2.0.2-RELEASE Version

<!tag:202>

- The `es.santander.darwin.logging.logger.ExtendedLogger` class has been created, this class allows generating traces with `FATAL` log level.

- A dependency in `es.santander.darwin.logging.aop.CommonAspect` with `javax.servlet.http.HttpServletRequest` (that could cause errors in certain cases) has been deleted. From now on, the class gets the current request from the
    `RequestContextHolder` object and contemplates it may not exist.

<!end:202>

## 2.0.1-RELEASE Version

<!tag:201>

- In order to make them more resistant to errors, we have modified the way in which the activity and functional logs were generated.

<!end:201>

## 2.0.0-RELEASE Version

<!tag:200>

- The `darwin.logging.activity` property has been renamed to `darwin.logging.activity.enabled`.

- All configuration properties have been documented using "Kebab case" instead of "camel case".

<!end:200>
