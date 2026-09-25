# Santander Spring Boot Starters ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

The `Santander Spring Boot` architecture provides a set of starters in charge of automatically managing both the dependencies and the components auto-configuration.

!!! info "Important"

    Normally, projects make use of the starters provided by `Santander Spring Boot` in order to auto-configure the libraries, but if you want to import the libraries without an auto-configuration, you must import the library associated with the
    starter. For example, imagine a project who wants to import the omnichannel library components but not its auto-configuration, in this case it should import the `santander-spring-boot-omnichannel` dependency instead of
    `santander-spring-boot-starter-omnichannel` .

## Santander Spring Boot Starter Core

Starter with the required dependencies for the Core infrastructure auto-configuration provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will get an **initialized Context** object in our application's context, **asynchronous execution** configuration, **exceptions management**, etc.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-core</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the authentication starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>

    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-core</artifactId>
    <name>Santander Spring Boot Core Starter</name>

    <dependencies>
        <!-- Santander Spring Boot Core -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-core</artifactId>
        </dependency>
        <!--    Spring Starters    -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-json</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the core starter, see the [Core](../santander-spring-boot-core/README.md) documentation.

## Santander Spring Boot Starter Authentication

Starter with the required dependencies for the authentication infrastructure auto-configuration provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will get functionalities that allow us to use the Public Key Manager (PKM) and the Security Token Service (STS) for token conversions.

In the case of a web application, we will achieve authentication by token, so any request to a URL will need authentication by `JWT` or corporate token. Actuator's `info` and `health` URLs have been waived and do not require authentication.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-authentication</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the authentication starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Authentication Starter</name>
    <artifactId>santander-spring-boot-starter-authentication</artifactId>

<dependencies>
    <!--  Santander Spring Boot Spring Boot Security Authentication  -->
    <dependency>
        <groupId>com.santander.framework.springboot</groupId>
        <artifactId>santander-spring-boot-security-authentication</artifactId>
    </dependency>
    <dependency>
        <groupId>com.santander.framework.springboot</groupId>
        <artifactId>santander-spring-boot-starter-core</artifactId>
    </dependency>
</dependencies>
</project>
```

For more information on how to configure the authentication starter, see the [Authentication](../santander-spring-boot-security-authentication/README.md) documentation.

## Santander Spring Boot Starter Authorization

Starter with the required dependencies to autoconfigure the authorization infrastructure provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will be able to manage whether the user and client requesting an action via Rest are authorized to perform it.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-security-authorization</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the de authorization starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Authorization Starter</name>
    <artifactId>santander-spring-boot-starter-authorization</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-security-authorization</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-authentication</artifactId>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-aop -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>


    </dependencies>
</project>
```

For more information on how to configure authorization starter, see the [Authorization](../santander-spring-boot-security-authorization/README.md) documentation.

## Santander Spring Boot Starter Batch

Starter with the required dependencies to autoconfigure the Batch infrastructure provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency we will get the dependencies for configuring Spring Batch and Spring Cloud Task.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-batch</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the batch starter automatically incorporates are the following:

```xml
<dependencies>
    <dependency>
        <groupId>com.santander.framework.springboot</groupId>
        <artifactId>santander-spring-boot-batch</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-batch</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-task</artifactId>
    </dependency>
</dependencies>
```

For more information on how to configure the batch starter, see the [Batch](../santander-spring-boot-batch/README.md) documentation.

## Santander Spring Boot Starter Cache

Starter with the required dependencies to autoconfigure the Cache infrastructure provided by `Santander Spring Boot`.

### Installation

Depending on the startup that we include as a dependency of Maven we will obtain the management of a cache or another.

If we want to use the **Caffeine** cache, we must add:

#### Caffeine dependency

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-cache-caffeine</artifactId>
</dependency>
```

and in case we want to use the **Data Grid** cache, we will have to add:

#### Data Grid dependency

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-cache-infinispan</artifactId>
</dependency>
```

and in case we want any dependency, then we could add:

#### Without extra cache dependencies

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-cache-base</artifactId>
</dependency>
```

!!! warning

    If you want to use both caches, you must import both starters, since the old starter that loads both caches will be **deprecated** in future versions.

### Managed dependencies

The dependencies that the Caffeine cache initiator automatically incorporates are as follows:

#### santander-spring-boot-starter-cache-caffeine

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>

    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-cache-caffeine</artifactId>
    <name>Santander Spring Boot Cache Starter Caffeine</name>

    <description>Pom providing dependency management and auto-configuration for Caffeine cache in Santander Spring Boot</description>

    <dependencies>
        <!-- Santander Spring Boot Starter Cache base -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-cache-base</artifactId>
        </dependency>

        <!-- caffeine caching provider -->
        <dependency>
            <groupId>com.github.ben-manes.caffeine</groupId>
            <artifactId>caffeine</artifactId>
        </dependency>

    </dependencies>
</project>
```

And the dependencies that the Data Grid cache initiator automatically incorporates are as follows:

#### santander-spring-boot-starter-cache-infinispan

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>

    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-cache-infinispan</artifactId>
    <name>Santander Spring Boot Cache Starter Infinispan</name>

    <description>Pom providing dependency management and auto-configuration for Infinispan cache in Santander Spring Boot</description>

    <dependencies>
        <!-- Santander Spring Boot Starter Cache base -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-cache-base</artifactId>
        </dependency>

        <!-- RHDG Spring Boot Starter -->
        <dependency>
            <groupId>org.infinispan</groupId>
            <artifactId>infinispan-spring-boot-starter-remote</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>org.infinispan</groupId>
                    <artifactId>infinispan-client-hotrod</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>org.infinispan</groupId>
            <artifactId>infinispan-client-hotrod-jakarta</artifactId>
        </dependency>

        <!-- JBoss Marshalling -->
        <dependency>
            <groupId>org.infinispan</groupId>
            <artifactId>infinispan-jboss-marshalling</artifactId>
        </dependency>

    </dependencies>
</project>
```

For more information on how to configure the cache starter, see the [Cache](../santander-spring-boot-cache/README.md) documentation.

## Santander Spring Boot Starter GraphQL

Starter with the required dependencies to autoconfigure the GraphQL support provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency we will get GraphQL support for Santander Spring Boot web applications.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-graphql</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the GraphQL starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-graphql</artifactId>
    <name>Santander Spring Boot GraphQL Starter</name>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-graphql</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the GraphQL starter, see the [Santander Spring Boot GraphQL](../santander-spring-boot-graphql/README.md) documentation.

## Santander Spring Boot Starter Logging

Starters with the required dependencies to autoconfigure the logging and trace infrastructure provided by `Santander Spring Boot`.

### Installation

Santander Spring Boot Logging supports both Log4j and Logback implementations. We will manage which one we use by including different starters.

Installing one of the two starters listed below (_basic_ or _kafka_) as a `Maven` dependency, we will get the necessary elements to automatically generate the traces with a specific `Json` format.
Depending on which one we choose they will be managed by the monitoring architecture or stay locally.

#### Log4j

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-logging-basic</artifactId>
</dependency>
```

or

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>
</dependency>
```

#### Logback

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-logging-logback-basic</artifactId>
</dependency>
```

or

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-logging-logback-kafka</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the logging starters automatically incorporates also depends on the chosen starter:

#### santander-spring-boot-starter-logging-basic

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Logging Basic Starter</name>
    <artifactId>santander-spring-boot-starter-logging-basic</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-logging</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-log4j2</artifactId>
        </dependency>
    </dependencies>
</project>
```

#### santander-spring-boot-starter-logging-kafka

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Logging kafka Starter</name>
    <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging-basic</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.kafka</groupId>
            <artifactId>kafka-clients</artifactId>
        </dependency>
    </dependencies>
</project>
```

#### santander-spring-boot-starter-logging-logback-basic

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
<parent>
<artifactId>santander-spring-boot-starters</artifactId>
<groupId>com.santander.framework.springboot</groupId>
<version>${revision}</version>
</parent>
<modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Logging Logback Basic Starter</name>
    <artifactId>santander-spring-boot-starter-logging-logback-basic</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-logging</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </dependency>
    </dependencies>
</project>
```

#### santander-spring-boot-starter-logging-logback-kafka

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
<parent>
<artifactId>santander-spring-boot-starters</artifactId>
<groupId>com.santander.framework.springboot</groupId>
<version>${revision}</version>
</parent>
<modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Logging Logback Kafka Starter</name>
    <artifactId>santander-spring-boot-starter-logging-logback-kafka</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging-logback-basic</artifactId>
        </dependency>
        <!-- TODO: Add kafka dependency when selected, might be com.github.danielwegener:logback-kafka-appender that depends on org.apache.kafka:kafka-clients -->
    </dependencies>
</project>
```

For more information on how to configure the logging starters, see the [Logging](../santander-spring-boot-logging/README.md) documentation.

## Santander Spring Boot Starter Metrics

Starter with the required dependencies to autoconfigure the metrics infrastructure provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will get the necessary elements to be able to record and consume the different micrometer traces through Santander Spring Boot's metric system.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-metrics</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the metrics starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Metrics Starter</name>
    <artifactId>santander-spring-boot-starter-metrics</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-metrics</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the metric starter, see the [Metrics](../santander-spring-boot-metrics/README.md) documentation.

## Santander Spring Boot Starter Omnichannel

Starter with the required dependencies to autoconfigure the omnichannel infrastructure provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will be able to store and manage all the configurable properties associated with each input channel.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-omnichannel</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the omnichannel starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-omnichannel</artifactId>
    <name>Santander Spring Boot Omnichannel Starter</name>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-omnichannel</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the omnichannel starter, see the [Omnichannel](../santander-spring-boot-omnichannel/README.md) documentation.

## Santander Spring Boot Starter Web Service

Starter with the required dependencies to autoconfigure the authentication in the communication with `SOAP` services provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will automatically inject security credentials in addition to selecting `endpoints` based on the channel for the invocation of `Web Services`.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-webservice</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the de web services starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-webservice</artifactId>
    <name>Santander Spring Boot Webservice Starter</name>

    <dependencies>
        <!--  Santander Spring Boot Spring Boot Web Service  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-webservice</artifactId>
        </dependency>
        <!--  Santander Spring Boot Spring Boot Security Authentication Starter -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-authentication</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the web services starter, see the [Web Services](../santander-spring-boot-webservice/README.md) documentation.

## Santander Spring Boot Starter Partenon

Starter with the required dependencies to auto configure the Santander Spring Boot switch/wrapper for the `Partenon TrxOp` Connector.

### Installation

By including the starter as a `Maven` dependency, we will be able to replace the original connector with the Santander Spring Boot Partenon connectors associated with the channels.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-partenon</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the Partenon starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-partenon</artifactId>
    <name>Santander Spring Boot Partenon Starter</name>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-partenon</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.serenity.corporate.data</groupId>
            <artifactId>partenon-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <!--  Santander Spring Boot Spring Boot Security Authentication Starter -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-authentication</artifactId>
        </dependency>
    </dependencies>

</project>
```

For more information on how to configure the `Partenon` starter, see the [Santander Spring Boot Partenon](../santander-spring-boot-partenon/README.md) documentation.

## Santander Spring Boot Starter Events

Starter with the required dependencies to autoconfigure the event module provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will be able to generate events compatible with the `CloudEvent` specification.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-events</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the events starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Events Starter</name>
    <artifactId>santander-spring-boot-starter-events</artifactId>

    <dependencies>
        <!--  Santander Spring Boot Spring Boot events library  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-events</artifactId>
        </dependency>
        <!--  Santander Spring Boot starter libraries  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the event starter, see the [Santander Spring Boot Event](../santander-spring-boot-events/README.md) documentation.

## Santander Spring Boot Starter Business Events

Starter with the required dependencies to autoconfigure the event module provided by `Santander Spring Boot`.

### Installation

By including the starter as a `Maven` dependency, we will be able to generate business events that contain functional information compatible with the `CloudEvent` specification..

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-business-events</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the events starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Business Events Starter</name>
    <artifactId>santander-spring-boot-starter-business-events</artifactId>

    <dependencies>
        <!--  Santander Spring Boot Spring Boot events library  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-events</artifactId>
        </dependency>

        <!--  Santander Spring Boot starter libraries  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging</artifactId>
        </dependency>

        <!--   Spring Starter AOP     -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the event starter, see the [Santander Spring Boot Event](../santander-spring-boot-events/README.md) documentation.

## Santander Spring Boot Starter Extended Error

Starter with the required dependencies to autoconfigure the Extended Error Model.

### Installation

By including the starter as a `Maven` dependency, we will be able to replace Santander Spring Boot's error model with the Extended Error model (`ErrorModelExtendedError`).

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-extended-error</artifactId>
</dependency>
```

### Managed dependencies

The dependencies that the ExtendedError starter automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Extended Error Starter</name>
    <artifactId>santander-spring-boot-starter-extended-error</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-extended-error</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the ExtendedError starter, see the [ExtendedError](../santander-spring-boot-extended-error/README.md) documentation.

## Santander Spring Boot Starter Test

Starter to autoconfigure the Santander Spring Boot Test library.

### Installation

By including the starter as a `Maven` dependency, we will be able to include Santander Spring Boot Test features in our tests: Logging test console logs, "Servicios Comunes" mocks, etc.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

### Managed dependencies

The Santander Spring Boot Test starter only includes automatically its own Santander Spring Boot Test library:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-test</artifactId>
    <name>Santander Spring Boot Test Starter</name>

    <dependencies>
        <!--  Santander Spring Boot Test  -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-test</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the Test starter, see the [Santander Spring Boot Test](../santander-spring-boot-test/README.md) documentation.

## Santander Spring Boot Codetables

Starter to autoconfigure the Santander Spring Boot `codetables` in order to provide a simple API for the invocation of the code tables service being able to obtain and validate the table codes associated to a domain.

### Installation

By including the starter as a Maven dependency, we will be able use the API it provides for a CodeTables service.

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-codetables</artifactId>
</dependency>
```

### Managed dependencies

The Santander Spring Boot Codetables starter includes the following dependencies:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-starters</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <name>Santander Spring Boot Code Tables Starter</name>
    <artifactId>santander-spring-boot-starter-codetables</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-codetables</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
    </dependencies>
</project>
```

For more information on how to configure the Codetables starter, see the [Santander Spring Boot Codetables](../santander-spring-boot-codetables/README.md) documentation.

## Santander Spring Boot Starter Parent

Starter that contains the `PARENT POM` to provide dependency management and plugins of the Santander Spring Boot framework in the microservices.

### Installation

By making our microservice inherit from the `POM` associated with the starter, all the dependencies versions are configured, as well as the plugin configuration.

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-parent</artifactId>
</parent>
```

### Managed dependencies and plugins

The dependencies and plugins that the starter parent automatically incorporates are the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>santander-spring-boot-parent</artifactId>
        <groupId>com.santander.framework.springboot</groupId>
        <version>${revision}</version>
        <relativePath>../../santander-spring-boot-parent</relativePath>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>santander-spring-boot-starter-parent</artifactId>
    <packaging>pom</packaging>
    <name>Santander Spring Boot Starter Parent</name>

    <description>Parent pom providing dependency and plugin management for applications built with Maven for Santander Spring Boot Applications</description>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-core</artifactId>
                <version>${spring-framework.version}</version>
                <exclusions>
                    <exclusion>
                        <groupId>commons-logging</groupId>
                        <artifactId>commons-logging</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
        </dependencies>
    </dependencyManagement>
    <dependencies>
        <!-- If the Santander Spring Boot Logging library is added, it is necessary to exclude the
		spring-boot-starter-logging dependency of spring-boot-starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-starter-logging</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

    <build>
        <!-- Turn on filtering by default for application properties -->
        <resources>
            <resource>
                <directory>${basedir}/src/main/resources</directory>
                <filtering>true</filtering>
                <includes>
                    <include>**/application*.yml</include>
                    <include>**/application*.yaml</include>
                    <include>**/application*.properties</include>
                </includes>
            </resource>
            <resource>
                <directory>${basedir}/src/main/resources</directory>
                <excludes>
                    <exclude>**/application*.yml</exclude>
                    <exclude>**/application*.yaml</exclude>
                    <exclude>**/application*.properties</exclude>
                </excludes>
            </resource>
        </resources>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.codehaus.mojo</groupId>
                    <artifactId>flatten-maven-plugin</artifactId>
                    <inherited>false</inherited>
                    <executions>
                        <execution>
                            <!-- Flatten and simplify our own POM for install/deploy -->
                            <id>flatten</id>
                            <phase>process-resources</phase>
                            <goals>
                                <goal>flatten</goal>
                            </goals>
                            <configuration>
                                <updatePomFile>true</updatePomFile>
                                <flattenMode>oss</flattenMode>
                                <pomElements>
                                    <parent>expand</parent>
                                    <distributionManagement>remove</distributionManagement>
                                    <repositories>remove</repositories>
                                </pomElements>
                            </configuration>
                        </execution>
                        <execution>
                            <id>flatten-clean</id>
                            <phase>clean</phase>
                            <goals>
                                <goal>clean</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <!-- Apply more sensible defaults for user projects -->
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-surefire-plugin</artifactId>
                </plugin>
            </plugins>
        </pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>flatten-maven-plugin</artifactId>
                <inherited>false</inherited>
                <executions>
                    <execution>
                        <!-- Flatten and simplify our own POM for install/deploy -->
                        <id>flatten</id>
                        <phase>process-resources</phase>
                        <goals>
                            <goal>flatten</goal>
                        </goals>
                        <configuration>
                            <updatePomFile>true</updatePomFile>
                            <pomElements>
                                <parent>expand</parent>
                                <name>keep</name>
                                <description>keep</description>
                                <url>expand</url>
                                <properties>keep</properties>
                                <pluginManagement>keep</pluginManagement>
                                <dependencyManagement>keep</dependencyManagement>
                                <build>keep</build>
                            </pomElements>
                        </configuration>
                    </execution>
                    <execution>
                        <id>flatten-clean</id>
                        <phase>clean</phase>
                        <goals>
                            <goal>clean</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <!-- We include santander-code-analysis-plugin here because we want to launch this plugin in test phase -->
            <!-- for all microservices created with santander microservice archetype that use that pom as parent -->
            <plugin>
                <groupId>com.santander.gluon.plugins</groupId>
                <artifactId>santander-code-analysis-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>test</phase>
                        <goals>
                            <goal>arch-test</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

    <reporting>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-report-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <reportSets>
                    <reportSet>
                        <reports>
                            <!-- select non-aggregate reports -->
                            <report>report</report>
                        </reports>
                    </reportSet>
                </reportSets>
            </plugin>
        </plugins>
    </reporting>
</project>
```
