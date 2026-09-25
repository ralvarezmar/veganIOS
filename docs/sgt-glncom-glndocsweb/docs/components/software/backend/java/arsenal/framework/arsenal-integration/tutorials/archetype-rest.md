# Arsenal Integration Rest Archetype {!include-markdown '../../snippets/versions.md' start='<!tag:int-version-schema>' end='<!end:int-version-schema>'!}

{!include-markdown '../../snippets/versions.md' start='<!tag:int-current>' end='<!end:int-current>'!}

## Description

Arsenal Maven archetype for Spring Boot / Apache Camel
applications for the rapid creation of a 'skeleton',
incorporating the necessary dependencies for their use.

### Application types

The archetype can handle one type of application, based on OpenAPI contracts. Currently, it only handles a sample internal archetype contract.

### Dependency management

During the execution of the archetype and according to the needs reflected by the user, the archetype is able to manage the Maven dependencies for the following libraries:

- [Spring Doc OpenAPI Starter Web MVC UI](https://springdoc.org/)
- [Spring Boot Starter Web](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html)
- [Spring Boot Starter Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Camel Spring Boot Starter](https://camel.apache.org/camel-spring-boot/4.0.x/index.html)
- [Camel OpenAPI Java Starter](https://camel.apache.org/components/4.0.x/others/openapi-java.html)
- [Camel Servlet Starter](https://camel.apache.org/components/4.0.x/servlet-component.html)
- [Camel Http Starter](https://camel.apache.org/camel-spring-boot/4.0.x/list.html)
- [Camel Jackson Starter](https://camel.apache.org/components/4.0.x/dataformats/jackson-dataformat.html)
- [Jackson Datatype jsr310](https://javadoc.io/doc/com.fasterxml.jackson.datatype/jackson-datatype-jsr310/latest/index.html)
- Framework Arsenal
    - Arsenal Integration Gluon Error Starter
    - [Arsenal Integration Observability Starter](../how-to-guides/observability/observability.md)

### Java support

When generating a project, the archetype use java 17 by default.

!!! info "Important"

    Arsenal Integration 4.x.y versions are only supported with java 17.

### Maven support

When generating a project, the minimum maven version is 3.8.x

## Arsenal Integration from scratch without OpenAPI contract

Open your command terminal (`PowerShell`, `Terminal` or `Shell`) and run the command below:

Windows (PowerShell):

``` { .powershell .copy }
mvn archetype:generate `
  "-DarchetypeGroupId=com.santander.ars" `
  "-DarchetypeArtifactId=gln-back-integration-rest-archetype" `
  "-DarchetypeVersion={!include-markdown '../../snippets/versions.md' start='<!tag:int-version>' end='<!end:int-version>'!}" `
  "-DgroupId=com.santander.gluon.demo" `
  "-Dversion=0.1.0-SNAPSHOT" `
  "-DartifactId=gln-back-arsenal-integration-demo"
```

Linux or MacOS:

``` { .bash .copy }
mvn archetype:generate \
  -DarchetypeGroupId=com.santander.ars \
  -DarchetypeArtifactId=gln-back-integration-rest-archetype \
  -DarchetypeVersion={!include-markdown '../../snippets/versions.md' start='<!tag:int-version>' end='<!end:int-version>'!} \
  -DgroupId=com.santander.gluon.demo \
  -Dversion=0.1.0-SNAPSHOT \
  -DartifactId=gln-back-arsenal-integration-demo
```

!!! info "Important"

    Variables that you need to change

| Property     | Default   | Description                                                                                              |
|--------------|-----------|----------------------------------------------------------------------------------------------------------|
| *groupId*    | empty     | Identifier of your application domain group                                                              |
| *artifactId* | empty     | Application artifact identifier                                                                          |
| *version*    | empty     | Artifact version                                                                                         |
| *ApiYaml*    | NoApiYaml | File path or a URL to a Open API Specification file                                                      |
| *isGluon*    | false     | When *true* enables a gluon error format and requires some properties filled to start up the application |

## Resulting project

The structure and content of the resulting project files will depend on the value given to some parameters.

### Project structure

The structure of the project will depend on the use (or not) of `isGluon` property.

#### Integration Application Structure

    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── gluon
        │   │               └── demo
        │   │                   ├── IntegrationApplication.java
        │   │                   ├── processor
        │   │                   |   └── error
        │   │                   │   │   ├── ErrorProcessor.java
        │   │                   │   │   ├── SocketTimeoutErrorProcessor.java
        │   │                   │   ├── Tranform{Resource}{HttpVerb}Request.java
        │   │                   │   ├── Tranform{Resource}{HttpVerb}Response.java
        │   │                   └── route
        │   │                       └── MainRestRouteBuilder.java
        │   │                       └── {Resource}{HttpVerb}RouteBuilder.java
        │   └── resources
        │       ├── application.yml
        │       ├── openapi
        │           ├── user-contract.yaml
        └── test
            └── java
                └── com
                    └── santander
                        └── gluon
                            └── demo
                                ├── IntegrationApplicationTest.java
                                └── processor
                                    └── error
                                    │   └── ErrorProcessorTest.java
                                    │   └── SocketTimeoutErrorProcessorTest.java
                                    └── {Resource}{HttpVerb}TransformTest

!!! info "Important"

    When we don't enter an OpenAPI contract to generate an archetype, the project structure is automatically generated. However, in future versions, we plan to allow for the specification of a contract to ensure that the archetype generates as desired.

    To generate this structure currently, you can use the Maven plugin gln-back-arsenal-integration-openapi-maven-plugin.

### Configuration files

#### Arsenal integration Parent

The Arsenal Integration Rest archetype uses this starter as the basis for the projects it generates. It is intended to be the main POM for all Santander applications, providing dependencies and plugin management.

This POM can also be used in libraries as dependency management.

The idea is that developers should not worry about which library version they are going to use, as well as providing the list of all available dependencies. It also includes some fixed dependencies and plugins that must be used in all applications,
such as lombok, spring boot starters, jacoco plugin, etc.

#### POM

The `pom.xml` file contains all the information that Maven uses to identify the generated project and manage its dependencies.

The Arsenal integration Parent defines the POM parent [mentioned previously](#arsenal-integration-parent) to manage library versions so that there are no conflicts between them:

    <parent>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-integration-lib-parent</artifactId>
        <version>{arsenal-version}</version>
    </parent>

!!! info "Important"

    Note that due to this POM parent, none of the dependencies that will be shown below are versioned.

Next, we as a property, the openapi-contract-path.

    <properties>
        <openapi-contract-path>${basedir}/src/main/resources/openapi/user-contract.yaml</openapi-contract-path>
    </properties>

From here we define the dependencies and plugins that the project will use.

    <dependencies>
        <!-- Springdoc -->
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        </dependency>
        <!-- Spring Boot -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <!-- Camel -->
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-openapi-java-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-servlet-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-http-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-jackson-starter</artifactId>
        </dependency>
        <!-- Json Parser -->
        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
        </dependency>
        <!-- Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-test-spring-junit5</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>io.rest-assured</groupId>
            <artifactId>rest-assured</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- Santander -->
    </dependencies>

If the `isGluon` property is enabled, the archetype will have an additional dependency:

    <dependency>
      <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-gluon-error-starter</artifactId>
    </dependency>
    <dependency>
      <groupId>com.santander.ars</groupId>
      <artifactId>gln-back-arsenal-integration-observability-starter</artifactId>
    </dependency>

#### Property files

The archetype has generated a series of property files to configure what is necessary according to the libraries that have been previously included:

- *application.yml*: main application configuration file independent of the environment.

##### application.yml file

Similar to pom.xml, the content of this file has a **fixed part** that will be configured in any application:

<!-- -->
    camel:
      servlet:
        mapping:
          contextPath: {camel context path}
      dataformat:
        jackson:
          module-class-names: com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
          disable-features: WRITE_DATES_AS_TIMESTAMPS,FAIL_ON_EMPTY_BEANS

    openapi:
      server:
        path: {openapi server path}

    backend:
      url: {backend.url}

    spring:
      application:
        name: {application name}
      jackson:
        visibility:
          getter: NONE
      mvc:
        servlet:
          path: {mvc servlet path}

    arsenal:
      logging:
        console-log: true
        isGluon: false

        If the `isGluon` property is enabled:

        company: {Santander company whose component is generating the logs.}
        componentName: {Name of the component that generates the log.}
        componentId: {Identifier of the component that generates the log.}
        componentType: {The type of the Gluon component (e.g., microservice, API...)}
        appName: {The technical application name}
        appId: {Identifier of the application of the component that generates the log.}
