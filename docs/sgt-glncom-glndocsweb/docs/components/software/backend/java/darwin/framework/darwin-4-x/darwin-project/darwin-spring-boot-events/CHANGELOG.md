# Change Log

## 4.3.2-RELEASE Version

<!tag:432>

- The KafkaHealthIndicator bean is conditional on there being a bootstrap server configured at least.
  If there are no bootstrap servers defined, a warning log when is printed.

<!end:432>

## 4.3.0-RELEASE Version

<!tag:430>

- W3CTraceContext feature was activated by default for the Events library. Now it is disabled by default.

<!end:430>

## 4.2.0-RELEASE Version

<!tag:420>

- Solve issue in GLUON log format. The appKey was not correctly informed.
- Amend pom.xml to verify module in native mode.

<!end:420>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- Previously Darwin Events forced you to define AVRO or JSON as a serialiser/deserialiser value.
  Now, it is possible to define any serialiser/deserialiser value
  for Kafka Clients instrumented by the library.

- W3C TraceContext distributed treceability no longer enabled by default in postprocessor.

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Fix a bug that configures automatic BusinessEvent with an empty endpoint list.

<!end:327>

## 3.2.0-RELEASE Version

<!tag:320>

- New functionality that allows **Business Events** to be sent automatically by endpoints,
  by annotations or to be sent manually.

- The fields **entity** and **acceptlanguage** are now optional instead of mandatory for creating a **Darwin Cloud Event**

- Remove unnecessary dependencies.

- Support new `GLOBAL` format for Activity trace patterns.

- Added the ObfuscateBusinessEvent annotation to provide obfuscation capacities to Business Events automatic instrumentation and Business Event annotation.

- Added documentation about how to consume Cloud Event messages in AVRO format.

<!end:320>

## 3.1.2-RELEASE Version

<!tag:312>

- Remove translate traceability headers from Sleuth format to Cloud Events format.

<!end:312>

## 3.1.0-RELEASE Version

<!tag:310>

- Adding new fields in activity pattern and technical pattern.

    - Adding the messaging instrumentation in order to fill in the channel field with the channel information from DarwinContext.

- Add `specific.avro.reader=true` property to AVRO consumers' properties if wasn't configured.

- Remove `kafka_2.13` *provided* dependency.

- **Configure Confluent's monitoring interceptors** for consumer/producer if the dependency is present.

- Remove translate traceability headers from Sleuth format to Cloud Events format.

<!end:310>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Added Sampling support for activity traces in Messaging instrumentation.

- When logging trace-context mode is disabled,
  and events contain W3CTraceContext headers, these won't be altered, and they will be propagated as were received.
  This feature is not available in the reactive event processing.

- Add Reactive support for events

    - Fix bug in DarwinCloudEvent build. Authentication and authorization value weren't extracted properly and their values were mixed.

- Customizing authorizationExceptionRetryInterval property for KafkaListenerContainerFactory. Adding authorizationExceptionRetryInterval property to Darwin event properties.

- Update README, added missing configuration property `darwin.events.resilienceMode`.

- Update the metadata files with all defined properties and those that have been deprecated.

- Dependencies and plugins upgrade:

    - Using new module Spring Cloud Sleuth brave

- Fix Sonar issues

    - Removed unreachable code from DarwinSleuthKafkaConfiguration#wrapListenerContainerCreation()

    - Changed toBytes() method in AvroCloudEventData to return a copy of a mutable object.

- Fix conditions for "tracestate" header update in InterceptorProducer.

- Translation of the README.adoc file from Spanish to English.

- Use DefaultKafkaConsumerFactoryCustomizer to config the ConsumerFactory.

- Removing token validations from InterceptorUtils. Now validations are done within the AuthenticationParameters method.

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Use AuthenticationBearerToken and Token objects from SecurityContext in Servlet applications

- Using new API of Reactor for tests.

- Refactoring use of ReactiveDarwinContextHolder.

    - Creating DarwinContext as Object instead of a Mono&lt;DarwinContext&gt;

    - Refactoring ReactiveContextUtil to use createAuthenticationBearerToken(headers) and extractDarwinInfo(headers, appKey) from InterceptorUtils.

- Use property authExceptionRetryInterval of spring-kafka instead of the one defined in framework, which has been removed.

<!end:300>

## 2.11.3-RELEASE Version

<!tag:2113>

- Bug fix: Some kafkaFactory properties were not being added to the configuration correctly.

- When a resilience mode is enabled and I also define that kafka property with another value, the latter overwrites the one specified in the resilience mode.

<!end:2113>

## 2.11.2-RELEASE Version

<!tag:2112>

- Customizing authorizationExceptionRetryInterval property for KafkaListenerContainerFactory. Adding authorizationExceptionRetryInterval property to Darwin event properties.

<!end:2112>

## 2.11.1-RELEASE Version

<!tag:2111>

- The activity traces generated by Darwin Producer Interceptor and Darwin Consumer Interceptor can be disabled by the logging property *darwin.logging.activity.enabled*.

<!end:2111>

## 2.11.0-RELEASE Version

<!tag:2110>

- Extending the functionality of the interceptors to create an activity trace associated with the sending and receiving of messages.

- Now, use is made of the official cloudevents libraries

- Now, the library is able to handle W3C and B3 headers. In addition, previously the module forced the use of W3C, now this is optional, in which case B3 headers are managed

- Add Configurable Deserialization error handler to avoid poison pill scenarios.

<!end:2110>

## 2.10.1-RELEASE Version

<!tag:2101>

- Add Resilience Mode support.

<!end:2101>

## 2.10.0-RELEASE Version

<!tag:2100>

- Add AVRO support

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- We launch **darwin-spring-boot-events** library **first version** with the following functionality:

    - Events Generation support according to the CloudEvents v1.0 specification

<!end:290>
