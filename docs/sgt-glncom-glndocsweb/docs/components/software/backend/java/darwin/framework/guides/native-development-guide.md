# Native Images Development Guide

## Pre-requisites

- Linux AMD64 operating system
- GraalVM distribution for Java 17 of higher
- Native Image tool installed
- gcc and g++ installed

By default in Darwin, we are using [static native executable](https://www.graalvm.org/jdk17/reference-manual/native-image/guides/build-static-executables/)
If you want to use in your local machine the static native execution, you will also need:

- A 64-bit musl toolchain, make, and configure
- The latest zlib library

If you want to use dynamically linked binaries, you have to remove the flags `--static`and `--libc=musl` from `native-maven-plugin` configuration in the `pom.xml` file.

## Limitations

To learn more about the current limitations in native compilation, please check [the known GraalVM Native Image limitations](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-with-GraalVM)

As not all libraries are compatible with native compilation, you will be able to find more information about this in [Libraries and Frameworks Tested with Native Image](https://www.graalvm.org/native-image/libraries-and-frameworks/):

Also, not all Santander internal libraries are compatible with native compilation. You could check the current compatibility
in the [Santander libraries native compilation compatibility](./native-ready-libraries.md)

## Changes in archetype to support native image compilation

To support native image compilation, you have the next changes in the `pom.xml` file:

- Using logback instead of log4j2. Log4j2 is not compatible with native image compilation. You could use the `darwin-spring-boot-starter-logging-logback-basic` or `darwin-spring-boot-starter-logging-logback-kafka` starters to use logback.
- In case you use infinispan, we add the dependency `infinispan-core-graalvm` and `infinispan-client-hotrod-graalvm` to support native image compilation.
- We force the execution of AOT process for tests even if we are no use `native` o `nativeTest` profile. This is because we want to show the AOT compilation error as soon as possible.
- We add the `native-maven-plugin` to support native image compilation with a default configuration.
- [Spring boot issue 36997](https://github.com/spring-projects/spring-boot/issues/36997) avoid to create more than one context using AOT and logback.
  To allow tests to run in native mode with more than one context we temporally use `slf4j-simple` as the logging implementation for test execution.

Also we include the next properties in file `application-native.properties` to support native image compilation:

```properties
# Set springdoc native support
springdoc.enable-native-support: true

# Set platform
spring.main.cloud-platform: KUBERNETES

# Disable refresh is not supported in native mode
spring.cloud.refresh.enabled: false
```

And set empty values for all properties related to environment variables in the `application-native.properties` file.

```properties
env.pkm-endpoint:
env.sts-endpoint:

....
```

## How to build a native image and pass test in native mode

You could build a native image using the `native-maven-plugin` with the following command:

```shell
mvn native:compile -Pnative
```

Also, you could pass test in native mode with:

```shell
mvn verify -PnativeTest
```

## Using Gluon pipeline

If you want to build a native image with a Gluon pipeline,
you have to configure the properties.env file with the following content:

```properties
ARTIFACT_NATIVE_COMPILATION=true

JAVA_VERSION="oracle-graalvm-21.0.1"
```

Note that JAVA_VERSION is the GraalVM version that you want to use.

When `ARTIFACT_NATIVE_COMPILATION` is set to `true`:

- `maven-ci-image.yml` is going to verify the native image using `mvn verify -PnativeTest`
- `maven-ci-image.yml` is going to create de docker image using the artifact created with `mvn native:compile -Pnative` and it's going to use `Dockerfile.native` as Dockerfile.

## Compilation time and performance

The native image compilation time is longer than the JVM compilation time. This is because the native image compilation process is more complex and involves more steps than the JVM compilation process.

In order to improve the compilation time, you can use the `native-maven-plugin` with the following property `-Ob`, that improve the time of compile but decrease the performance of the native image.

For the image to use in production, it's better to use `-O2` and `-march=native` to improve the performance of the native image, in order to get the best performance.

## Metadata

### Why need add metadata to use native image

The native image tool needs to know about the reflection, resources, serialization, and proxy usage of your application. This information is used to build a more efficient native image. You have provide this information in the form of hints.

Regarding how dynamic features are supported, you can check the [GraalVM Dynamic Feature documentation](https://www.graalvm.org/latest/reference-manual/native-image/dynamic-features/)

### Hot to add metadata

We could add metadata in different ways. Some of the most common ways are:

- [Specifying Metadata with JSON](https://www.graalvm.org/latest/reference-manual/native-image/metadata/#specifying-metadata-with-json)
- Using the capabilities that [Spring provide](https://docs.spring.io/spring-framework/reference/core/aot.html#aot.hints)

### How to collect metadata with the tracing agent

To collect metadata with the tracing agent, you have to add the tracing agent to the JVM arguments when running your application.
The tracing agent will collect metadata about the reflection, resources, serialization, and proxy usage of your application.

You can add the tracing agent to the JVM arguments with the following command:

```shell
java -agentlib:native-image-agent=config-output-dir=src/main/resources/META-INF/native-image -jar target/my-app.jar
```

or you can add the tracing agent to the surefile plugin arguments in the `pom.xml` file to tracing tests:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <argLine>@{argLine} -agentlib:native-image-agent=config-output-dir=src/main/resources/META-INF/native-image</argLine>
    </configuration>
</plugin>
```

Also, you could check [Automatic Metadata Collection](https://www.graalvm.org/latest/reference-manual/native-image/metadata/AutomaticMetadataCollection/) to get more information about how to collect metadata.
