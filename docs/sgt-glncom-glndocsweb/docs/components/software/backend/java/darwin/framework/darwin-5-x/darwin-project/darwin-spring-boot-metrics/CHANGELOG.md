# Change Log

## 5.1.0-RELEASE Version

<!tag:510>

- Enhanced documentation for native compilation support

<!end:510>

## 4.2.0-RELEASE Version

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add support for working without log4j, necessary for native image.
- Starter don't bring kafka dependencies, it is using logging-basic.

<!end:420>

## 4.1.0-RELEASE Version

<!tag:410>

- Solve issue in GLUON log format. The appKey was not correctly informed.

<!end:410>

## Version 4.0.1-RELEASE

<!tag:401>

- Fix bug related to metrics format. The bug affect only to version 4.0.0

<!end:401>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## Version 3.2.7-RELEASE

<!tag:327>

- Change header in metric format (from "tags" to "\_tags").

<!end:327>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize Logging dependencies. Deleted unused dependencies and exclude **spring-boot-starter-logging** dependency.

- Remove unnecessary starter dependencies.

<!end:320>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- `spring-cloud-config-client` with scope test dependency is deleted.

- Using @EmbeddedKafka

- Translate to english the documentation.

<!end:300>

## 2.10.1-RELEASE Version

<!tag:2101>

- Metric logger will be created with additivity property set to false.

- Update the metadata files with all defined properties and those that have been deprecated.

<!end:2101>

## 2.10.0-RELEASE Version

<!tag:2100>

- Log4j2 XML configuration is added to the documentation.

- Now the metrics module is enabled whether the darwin.logging.metric.enabled property is not set or is set to true.

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- Allow logging custom configuration

    - Now, MetricsLogHelper class is part of the module.

    - Metrics autoconfiguration creates the metrics logger and metrics kafka appender.

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

<!end:290>

## 2.6.2-RELEASE Version

<!tag:262>

- When trying to start an application that only added the metric dependency, the starting process used to crash. This was because there was a logback dependency in the classpath but a logback LoggerContext had not been defined for the
    LoggerFactory. Such dependency is excluded.

<!end:262>

## 2.6.1-RELEASE Version

<!tag:261>

- An error has been solved where metrics of type `FunctionCounter` were sent as `Counter` metrics

- We added the **region** field to the generated metrics format

<!end:261>

## 2.6.0-RELEASE Version

<!tag:260>

- Dependency with `micrometer-core` (previously obtained from the **darwin-spring-boot-core** module) has been added

- The **joda-time** API use has been removed, from now on it will only be used the JDK **java-time** API

<!end:260>

## 2.5.0-RELEASE Version

<!tag:250>

- The darwin-spring-boot-metrics library has been created.

- We added a formatter for metrics publication with Darwin log format.

- A stepwise metric registry has been added. This metric log collects and publishes metrics at configurable time intervals.

- We added a consumer that trace the metrics in Kafka metrics topic.

- The white list metric has been modified to accept AntPath format with the '.' as a separator.

<!end:250>
