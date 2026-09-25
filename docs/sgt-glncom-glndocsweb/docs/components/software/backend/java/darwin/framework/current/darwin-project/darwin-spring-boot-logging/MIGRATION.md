# Darwin-spring-boot-logging Migration guides

## 6.0.0 Version

<!tag:600>

- Remove property `darwin.logging.observability.gluon-features.enabled`. The gluon behavior is always enabled. If you
  want your application as a default Spring Boot application instead accomplish Gluon observability standards, you have
  to set the properties:
  - `management.tracing.propagation.type` to `W3C`
  - `management.tracing.brave.span-joining-supported` to `false`
- Delete classes related to logging interceptors. They were internal classes used to propagate the context in the
  application. Now, the context is propagated by the baggage fields using remote propagation. Classes:
  `AbstractServletLoggingInterceptor`, `LoggingFilter`, `LoggingFilterFunction`, `LoggingInterceptor`, `LoggingReactiveFilterFunction`, `LoggingServletInterceptorConfig`
- Remove classes related to activity log using filters. They were internal classes used to log the activity in the
  application. Now, the activity is logged using the new capabilities in observability of Spring Boot. Classes: `ActivityLoggingFilter`,
  `ReactiveActivityLogger`, `ReactiveActivityLoggerImpl`, `ActivityLogger`, `ActivityLoggerImpl`, `AbstractActivityLogger`,
  `ReactiveActivityLoggingWebFilter`.
- Remove class `BaggageFieldUpdater`. It was an internal class used to update the baggage fields in the context. Now, the
  baggage fields are automatically updated using `ObservationHandler` classes.

<!end:600>

## Version 4.1.0-RELEASE

<!tag:410>

We have marked as deprecated the `com.santander.darwin.logging.config.DarwinLoggingConfiguration.DarwinLoggerName` property in favour of the `com.santander.darwin.logging.config.DarwinLoggerNames`.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

The following properties have been migrated to use the new domain of configuration:

| Old                               | New                                     |
|-----------------------------------|-----------------------------------------|
| spring.sleuth.sampler.rate        | management.tracing.sampling.rate        |
| spring.sleuth.sampler.probability | management.tracing.sampling.probability |

<!end:400>

## Version 3.2.3-RELEASE

<!tag:323>

We have marked as deprecated the `darwin.logging.gravity.appender.packages` property in favour of the `darwin.logging.gravity.appender.package-info` property. This new property accepts a custom topic for each package/class specified where the traces
will be sent.

Before, the `darwin.logging.gravity.appender.packages` property only accepted two values:

    darwin:
     logging:
        gravity:
          appender:
            packages:
              darwin.some.package.processor: DEBUG

Now, the property manages three fields:

    darwin:
     logging:
        gravity:
          appender:
            package-info:
              - name: partenon.another.package.execution
                level: WARN
                topic: execution-topic

Topic and level fields are not mandatory. If the topic field is not defined, it will use the value of the `darwin.logging.gravity.kafka.topic` property. If this property is not defined either, then no Kafka appender will be created. If level field
is not defined, `INFO` will be the value by default.

<!end:323>

## Version 3.2.0-RELEASE

<!tag:320>

- We've removed the following deprecated methods:

    - Static method `log(String traceLog, Map<String, Object> businessLog)` in `FunctionalReactiveLogHelper`.

    - Static method `log(SecurityLogData securityLogData)` in `SecurityReactiveLogHelper`.

    - Method `log(HttpStatus httpStatus, T request)` in `ActivityLogger`.

    - Method `log(String input, String output, T t)` in `FunctionalLogger`.

    - Method `isLoggableEndpoint(@Nullable MediaType contentType, @Nullable String path)` in `FunctionalLogger`.

    - Static method `trace(ContextView contextView, Logger log, String format, Object…​ arguments)` in `LoggerReactiveContext`.

    - Static method `debug(ContextView contextView, Logger log, String format, Object…​ arguments)` in `LoggerReactiveContext`.

    - Static method `info(ContextView contextView, Logger log, String format, Object…​ arguments)` in `LoggerReactiveContext`.

    - Static method `warn(ContextView contextView, Logger log, String format, Object…​ arguments)` in `LoggerReactiveContext`.

    - Static method `error(ContextView contextView, Logger log, String format, Object…​ arguments)` in `LoggerReactiveContext`.

    - Static method `error(ContextView contextView, Logger log, String format, Throwable t)` in `LoggerReactiveContext`.

- That should be replaced by the following methods:

    - `log(HttpStatus httpStatus, T request)` of `ActivityLogger` → Use `log(HttpStatus httpStatus, T request, Map<String, String> customValues)` instead.

    - `log(String input, String output, T t)` of `FunctionalLogger` → Use `log(String input, String output, T t, DarwinContext darwinContext)` instead.

    - `isLoggableEndpoint(@Nullable MediaType contentType, @Nullable String path)` of `FunctionalLogger` → Use `isLoggableEndpoint(@Nullable String path)` instead.

    - `log(String traceLog, Map<String, Object> businessLog)` of `FunctionalReactiveLogHelper` → Use `trace(String traceLog, Map<String, Object> businessLog)` instead.

    - `log(SecurityLogData securityLogData)` of `SecurityReactiveLogHelper` → Use `trace(SecurityLogData securityLogData)` instead.

- Also, we removed the following unused dependencies: **commons-text, json-sanitizer, commons-lang3, commons-collections4, commons-io**. If you were using any of them now you have to include them directly in your pom file.

- The interface 'ActivityWebLogger' has been replaced by `ActivityLogger` and `ReactiveActivityLogger` if you are implementing it in your code, you must implement the new interfaces that replace it.

- The interface `FunctionalLogger` has been replaced by `FunctionalLogger` and `ReactiveFunctionalLogger` if you are implementing it in your code, you must implement the new interfaces that replace it.

- **Darwin Logging old format has been replaced by Global Format by default**. `The old one (SPAIN format) will be deprecated in the following version`. In order to continue using the old format, you have to configure `darwin.logging.format`
    property to **SPAIN** value. If you use the new Global Format, these properties are not used anymore: **system, subsystem, application and subapplication**

<!end:320>

## Version 3.1.0-RELEASE

<!tag:310>

- Static method `log(String traceLog, Map<String, Object> businessLog)` in `FunctionalReactiveLogHelper` has been marked as `Deprecated`: Now it recommends to use `trace(String traceLog, Map<String, Object> businessLog)` method on `doOnEach`
    operator.

- Static method `log(SecurityLogData securityLogData)` in `SecurityReactiveLogHelper` has been marked as `Deprecated`. Now it recommends to trace `trace(SecurityLogData securityLogData)` method on `doOnEach` operator.

- `LoggingServiceReactiveImpl` has been marked as `Deprecated`. Now it recommends to use the new class service `LoggingServiceReactorImpl`.

- Removing `darwin.logging.reactive.disable-hook` property. The equivalent functionality is to use Sleuth ´MANUAL´ instrumentation and its property: `spring.sleuth.reactor.instrumentation-type`.

- Marking as `Deprecated` the following methods in `LoggerReactiveContext` class:

    - ***trace(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***debug(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***info(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***warn(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***error(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***error(ContextView contextView, Logger log, String format, Throwable t)***

- ***Common pattern log*** has changed its template in order to get the Darwin Region value from a different source. Instead of getting its value from environment variable `${env:DARWIN_REGION}`, now it is read as a property from logging
    properties class `${darwinRegion}`. This allows to define the Darwin Region as an environment variable in the deployment file or as a property (`darwin.region`) in the application.yaml. For any custom pattern where Darwin Region is used, the
    value of this field has to be updated: `${darwinRegion}`.

- New fields have been added to the default Activity pattern: ***ContactPoint*** and ***Channel***.

<!-- -->

    {\"timeStamp\":\"%d{${timeStampPattern}}{UTC}Z\",\"environment\":\"${environment}\",\"system\":\"${system}\",\"subSystem\":\"${subsystem}\",\"application\":\"${application}\",\"subApplication\":\"${subapplication}\",\"paasProject\":\"${paasproject}\",\"component\":\"%notEmpty{%X{alert-component} - }%c\",\"sessionId\":\"%X{sessionId}\",\"userId\":\"%X{userId}\",\"correlationTraceId\":\"%X{X-B3-TraceId}\",\"correlationSpanId\":\"%X{X-B3-SpanId}\",\"correlationParentSpanId\":\"%X{X-B3-ParentSpanId}\",\"wTraceParent\":\"%X{traceParent}\",\"wTraceState\":\"%X{traceState}\",\"logLevel\":\"%level\",\"log\":\"%enc{%m %ex{full}}{JSON} \",\"platformLog\": \"%enc{%X{platformLog}}{JSON}\",\"appKey\":\"${appKey}\", \"paasApp\":\"${env:APP_NAME}\", \"paasAppVersion\": \"${paasAppVersion}\", \"appInit\": \"%X{appInit}\",\"serverId\": \"${env:HOSTNAME}\",\"region\": \"${darwinRegion}\" ,\"extensionType\":\"activityLog\",\"contactPoint\": \"%X{contactPoint}\",\"channel\": \"%X{channel}\",\"inputTimeStamp\": \"%X{inputTimeStamp}\",\"error\": \"%X{errorOccurred}\",\"method\": \"%X{method}\",\"url\": \"%X{URL}\",\"returnCode\":\"%X{returnCode}\",\"threadId\": \"%threadName\"" + ", \"clientId\": \"%X{clientId}\" %notEmpty{,"customLog.opType": "%X{operationType}", "customLog.opName": "%X{operationName}" }} %ex{0}%n

- A new field has been added to the default Technical pattern: ***Channel***.

<!-- -->

    {\"timeStamp\":\"%d{${timeStampPattern}}{UTC}Z\",\"environment\":\"${environment}\",\"system\":\"${system}\",\"subSystem\":\"${subsystem}\",\"application\":\"${application}\",\"subApplication\":\"${subapplication}\",\"paasProject\":\"${paasproject}\",\"component\":\"%notEmpty{%X{alert-component} - }%c\",\"sessionId\":\"%X{sessionId}\",\"userId\":\"%X{userId}\",\"correlationTraceId\":\"%X{X-B3-TraceId}\",\"correlationSpanId\":\"%X{X-B3-SpanId}\",\"correlationParentSpanId\":\"%X{X-B3-ParentSpanId}\",\"wTraceParent\":\"%X{traceParent}\",\"wTraceState\":\"%X{traceState}\",\"logLevel\":\"%level\",\"log\":\"%enc{%m %ex{full}}{JSON} \",\"platformLog\": \"%enc{%X{platformLog}}{JSON}\",\"appKey\":\"${appKey}\", \"paasApp\":\"${env:APP_NAME}\", \"paasAppVersion\": \"${paasAppVersion}\", \"appInit\": \"%X{appInit}\",\"serverId\": \"${env:HOSTNAME}\",\"region\": \"${darwinRegion}\" ,\"extensionType\":\"microservices\",\"contactPoint\": \"%X{contactPoint}\",\"channel\": \"%X{channel}\",\"threadId\": \"%threadName\"} %ex{0}%n

<!end:310>

## Version 3.0.0-RELEASE

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- The autoconfigurations by application type, ***NotWeb*** and ***NotWebWithHttpClient*** are now unified into a single one, ***NotWeb***, detecting the presence of the dependency `restTemplate` and/or `webClient` so they are autoconfigured with
    the `Darwin interceptors`.

- Renamed "securityLogData" field from `SecurityLogData` class to "**status**".

- With the updates of Reactor API, `LoggerReactiveContext` wrapper class is updated to use readonly `ContextView` object instead of modificable `Context` object in some public methods. It is necessary to update the input parameter of these methods
    to use the proper context object: `ContextView`: The following methods use `ContextView` as input:

    - ***trace(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***debug(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***info(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***warn(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***error(ContextView contextView, Logger log, String format, Object…​ arguments)***

    - ***error(ContextView contextView, Logger log, String format, Throwable t)***

    - ***log(ContextView contextView, Runnable log)***

- Removed unused `LoggingEnvironmentPostProcessor` class from the **config** package.

### Moved/Renamed classes

These classes have been moved to another package:

| Old                                                               | New                                                               |
|-------------------------------------------------------------------|-------------------------------------------------------------------|
| es.santander.darwin.logging.config.DarwinSleuthKafkaConfiguration | com.santander.darwin.events.config.DarwinSleuthKafkaConfiguration |
| es.santander.darwin.logging.config.DefaultLoggingConfig           | com.santander.darwin.logging.DefaultLoggingConfig                 |
| es.santander.darwin.logging.config.DefaultLoggingConfigBuilder    | com.santander.darwin.logging.DefaultLoggingConfigBuilder          |
| es.santander.darwin.logging.config.DeferAppender                  | com.santander.darwin.logging.DeferAppender                        |
| es.santander.darwin.logging.config.LoggingConfig                  | com.santander.darwin.logging.LoggingConfig                        |
| es.santander.darwin.logging.config.LoggingConfigCustomizer        | com.santander.darwin.logging.LoggingConfigCustomizer              |

<!end:300>

## Version 2.X-RELEASE

<!tag:2110>

### SSL communication protocol for logging topics

In this version, the use of SSL is enabled by default for all communication with logging topics. Until now, the mode used was `PLAINTEXT` and the servers and ports required were those corresponding to this protocol.

To migrate to version 2.11.0 or higher, it is necessary to update the Darwin configuration for the logging module in such a way that it sets the servers and ports enabled for the `SSL` mode.

If you have any type of doubt about how to configure the communication protocol, consult the section [Kafka communication protocol
configuration](README.md#configuration-kafka-communication-protocol).

[In this link](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16816242958/Configuraci+n+de+la+comunicaci+n+de+los+microservicios+con+los+t+picos+de+logging) You can consult the list of servers for each environment, whether they are `SSL` or
the deprecated ones with `PLAINTEXT` support.

<!end:2110>

<!tag:290>

### Clase MetricsLogHelper

The `MetricsLogHelper` class that allows the generation of metrics manually has changed module.

This class is now in the metrics module and to be able to use it it is necessary to have the metrics library starter as a dependency.

    <dependency>
            <groupId>es.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-metrics</artifactId>
    </dependency>

Also, you have to update the package reference, from the old location:

    import es.santander.darwin.logging.helper.MetricsLogHelper;

to the new:

    import com.santander.darwin.metrics.helper.MetricsLogHelper;

<!end:290>

### Details for Logging migration from NUAR

<!tag:2x0>

#### Technical logger

All logging configuration variables have been renamed from `es.santander.nuar.logging` to `darwin.logging`

The variables `technical.package`, `log-level.root` have disappeared, now the configuration of the technical traces is done simply by indicating the level of trace that we want for a specific package, for example, if in our application we want to
trace the packages es.app.service and es.app.web differently, our configuration would be as follows:

    darwin.logging:
        log-level:
            es.app.service: DEBUG
            es.app.web: ERROR

#### Activity logger

If you want to disable the activity logger, you must specify it as follows:

    darwin.logging:
        activity:
            enabled: false

By default, it is enabled.

#### Environment

The variable `es.santander.nuar.logging.environment` is no longer mandatory, now the value will be automatically retrieved from `spring.profiles.active` if the value of `es.santander.nuar.logging.environment` is populated then this will prevail over
the spring profile.

#### AppKey

The AppKey variable is now global to the entire Darwin architecture, it does not belong exclusively to the logging library, therefore instead of being placed within the logging properties it is now hanging directly from the `darwin` prefix:

    es.santander.nuar.logging.appKey: appname

    darwin.app-key: appname

#### Kafka Topics

Until now, the logging library allowed to establish a single kafka topic for all appenders by specifying this in the property `es.santander.nuar.logging.kafka.topic`. This is no longer possible, now it is mandatory to establish each topic that we
are going to use independently.

#### Properties

| Name                                       | Default value                   | Mandatory | Description                                                                                                                                                                                                                                                                        | Example                                                          |
|--------------------------------------------|---------------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| darwin.logging.log-level                   | N/A                             | No        | Indicates the log level of each technical logger                                                                                                                                                                                                                                   | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.environment                 | Value of spring.profiles.active | No        | Indicates the log level of each technical logger                                                                                                                                                                                                                                   | darwin.logging.environment: CERT                                 |
| darwin.logging.system                      | N/A                             | Yes       | Value received from ATLAS with the name of the system to which the microservice belongs                                                                                                                                                                                            | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.subsystem                   | N/A                             | Yes       | Value received from ATLAS with the name of the subsystem to which the microservice belongs                                                                                                                                                                                         | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.application                 | N/A                             | Yes       | Value received from ATLAS with the name of the application to which the microservice belongs                                                                                                                                                                                       | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.subapplication              | N/A                             | Yes       | Value received from ATLAS with the name of the subapplication to which the microservice belongs                                                                                                                                                                                    | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.paasproject                 | N/A                             | Yes       | Name of the PaaS to which the microservice belongs                                                                                                                                                                                                                                 | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.paas-app-version            | N/A                             | Yes       | The version of the maven artifact being generated. In order for it to be filled in automatically when generating the artifact, we must indicate the value "@project.version@" and tell Maven to process the resources so that it replaces the string with the corresponding value. | darwin.logging.logLevel.es.santander: INFO                       |
| darwin.logging.functional.logged-endpoints | N/A                             | No        | Indicates the endppoints that should automatically generate functional traces                                                                                                                                                                                                      | darwin.logging.functional.logged-endpoints: '//credit*, /order'  |
| darwin.logging.activity.enabled            | true                            | No        | Boolean value indicating whether or not the activity traces should be generated                                                                                                                                                                                                    | darwin.logging.activity: false                                   |
| darwin.logging.kafka.server                | N/A                             | No        | Path to the Kafka server to which the functional and security traces will be sent, it must have the format host: port                                                                                                                                                              | darwin.logging.kafka.server: kafkadarwin.santander.dev.corp:9092 |
| darwin.logging.kafka.topic.functional      | N/A                             | No        | Kafka topic to which functional logs should be sent                                                                                                                                                                                                                                | darwin.logging.kafka.topic.functional: nuar-func-log             |
| darwin.logging.kafka.topic.security        | N/A                             | No        | Kafka topic to which security logs should be sent                                                                                                                                                                                                                                  | darwin.logging.kafka.topic.security: nuar-segu-log               |
| darwin.logging.kafka.topic.activity        | N/A                             | No        | Kafka topic to which activity logs should be sent                                                                                                                                                                                                                                  | darwin.logging.kafka.topic.activity: nuar-act-log                |
| darwin.logging.kafka.topic.technical       | N/A                             | No        | Kafka topic to which technical logs should be sent                                                                                                                                                                                                                                 | darwin.logging.kafka.topic.technical: nuar-msrv-log              |

#### Configuration conversion example

As an example, the following NUAR configuration file:

          es.santander.nuar.logging:
            active: true
            technical:
              package: es.demo
            functional:
              active: true
              logged-endpoints: '/**'
            activity: true
            system: SYSTEM
            subsystem: SUBSYSTEM
            application: DEMO
            subapplication: SUBAPPLICATION
            paasproject: PAASPROJECT
            subapplication-version: SUBAPPLICATIONVERSION
            paas-app-version: "@project.version@"
            app-key: nuar
            environment: CERT
            kafka:
              server: kafkadarwin.santander.dev.corp:9092
              topic: nuar-msrv-log

In DARWIN it would be as follows:

        darwin:
          app-key: nuar
          logging:
            log-level:
              es.demo: INFO
            functional:
              logged-endpoints: '/**'
            system: SYSTEM
            subsystem: SUBSYSTEM
            application: DEMO
            subapplication: SUBAPPLICATION
            paasproject: PAASPROJECT
            subapplication-version: SUBAPPLICATIONVERSION
            paas-app-version: "@project.version@"
            kafka:
              server: kafkadarwin.santander.dev.corp:9092
              topic:
                technical: nuar-msrv-log

<!end:2x0>
