# Libraries Ready with Native Image

Not all libraries are compatible with native compilation Find further information [here](https://www.graalvm.org/latest/reference-manual/native-image/metadata/Compatibility/)

In this document, we attempt to inventory the status of different libraries regarding native compilation.

## Darwin Spring Boot Support

Darwin Spring Boot is compatible with native compilation, but with some limitations:

- Log4j is not compatible with native compilation,
which is why we have developed a new logging starter that is compatible with native compilation `darwin-spring-boot-starter-logging-logback-basic`/`darwin-spring-boot-starter-logging-logback-kafka`.
The logback logging starter does not support all the functionality that the log4j one currently has. You can find more details in the [documentation](../current/darwin-project/darwin-spring-boot-logging/README.md#logback-vs-log4j)
- The starter `darwin-spring-boot-starter-webservice` is not compatible in servlet mode because the `spring-ws` library is not compatible with native compilation.
You can find more details in the [documentation](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-with-GraalVM).
In reactive mode, it is compatible because the implementation is not based on that library.
- The starters `darwin-spring-boot-starter-metrics` and `darwin-spring-boot-starter-batch` are currently not compatible with native compilation.

## Spring Boot Support

Spring Boot is compatible with native compilation, but with some [limitations](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-with-GraalVM)

## General Support for Third-Party Libraries via graalvm-reachability-metadata

On this [page](https://www.graalvm.org/native-image/libraries-and-frameworks/), we find a list of third-party libraries that are compatible with native compilation, either directly or through [graalvm-reachability-metadata](https://github.com/oracle/graalvm-reachability-metadata)

## Darwin Library Support

Darwin adds initial support for native compilation of some third-party and internal libraries. This support is not exhaustive and will be expanded over time.

The fact that a library is not supported does not mean it cannot be used, it simply means that its use with native compilation has not been tested.

The included libraries are not fully supported, but minimal tests have been done.
It is likely that more hints will need to be added for the library to work correctly,
for this you can follow the [development guide](./native-development-guide.md#how-to-collect-metadata-with-the-tracing-agent)

Third-party libraries supported by Darwin:

| Starter                                          | Supported library                                   |
|--------------------------------------------------|-----------------------------------------------------|
| darwin-spring-boot-starter-cache-infinispan      | infinispan-spring-boot3-starter-remote              |
| darwin-spring-boot-starter-core                  | hamcrest                                            |
| darwin-spring-boot-starter-core                  | kafka-clients (support for kerberos authentication) |
| darwin-spring-boot-starter-core                  | tomcat (for reactive mode)                          |
| darwin-spring-boot-starter-core                  | springdoc                                           |
| darwin-spring-boot-starter-core                  | spring-retry                                        |
| darwin-spring-boot-starter-core                  | wiremock                                            |
| darwin-spring-boot-starter-events                | brave (tracing kafka consumers and producers)       |
| darwin-spring-boot-starter-events                | confluent (avro and cloudevent support)             |
| darwin-spring-boot-starter-omnichannel-ua-parser | yauaa                                               |

Internal libraries supported by Darwin:

| Starter                             | Supported library |
|-------------------------------------|-------------------|
| darwin-spring-boot-starter-core     | Sat               |
| darwin-spring-boot-starter-partenon | Partenon          |
