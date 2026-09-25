# Santander Spring Boot Microservice Archetype ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

Santander Spring Boot's Maven archetype for Spring Boot applications allows for the rapid creation of a 'skeleton' for Spring Boot applications (Web and NotWeb), incorporating the necessary dependencies for their use.
The archetype creates a project following hexagonal architecture, a pattern that separates the application into several layers, each with a specific responsibility.
The aim of hexagonal architecture is to make the application more flexible and easier to maintain, allowing to keep the business logic separate from framework-specific code.
The microservice archetype was adapted to hexagonal architecture by Mexico´s DCoE (Development Center of Excellence).
This architecture is composed of three main layers: Domain, Application and Infrastructure. The Domain layer contains the core business objects and logic of the application.
The Application layer facilitates controlled interaction with the domain, and the Infrastructure layer isolates the application´s core from external technology or framework-specific code.
This architecture ensures that the core business logic remains reusable and adaptable across different environments.

### Application types

The archetype is capable of handling up to three application types based on the runtime environments of a `Spring Boot` application which they define as
[WebApplicationType](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/WebApplicationType.html) (NONE, SERVLET and REACTIVE):

- ***NotWeb*** (NONE): The application does not run as a web application and therefore **should not** boot an `embedded web server` but includes the Spring HTTP Clients, `RestTemplate` and `WebClient`.

- ***Batch*** (NONE): The application does not run as a web application and therefore **should not** boot an `embedded web server` but includes the Spring HTTP Clients, `RestTemplate` and `WebClient`. It is intended for microservices running on
    Batch architecture. Makes available the use of the **Spring Batch** and **Spring Cloud Task** libraries.

- ***Web Servlet*** (SERVLET): The application runs as a `Servlet` based web application and therefore should start an `embedded web server`, by default `Tomcat`.

- ***Web Reactive*** (REACTIVE): The application runs as a `WebFlux` based reactive web application and therefore should start an `embedded web server`, by default `Netty`.

### Dependency management

During the execution of the archetype and according to the needs reflected by the user, the archetype is able to manage the Maven dependencies for the following libraries:

- [Spring Cloud Config Client](https://docs.spring.io/spring-cloud-config/reference/4.3/#_spring_cloud_config_client)

- [Spring Web MVC](https://docs.spring.io/spring-framework/docs/6.2.11/reference/html/web.html#spring-web) y [Spring WebFlux](https://docs.spring.io/spring-framework/docs/6.2.11/reference/html/web-reactive.html#spring-webflux)

- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/3.5.6/reference/html/actuator.html#actuator)

- Spring HTTP Clients: [RestTemplate y WebClient](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html)

- [Spring Cloud Task](https://docs.spring.io/spring-cloud-task/docs/current/reference/html/#_spring_cloud_task)

- [Spring Batch](https://docs.spring.io/spring-batch/docs/current/reference/html/#_spring_batch)

- [Springdoc-OpenAPI (Swagger)](https://springdoc.org/)

- [Oracle](https://www.oracle.com/database/)

- [H2 Database](https://h2database.com/html/main.html)

- [PostgreSQL](https://jdbc.postgresql.org/)

- [Arsenal JPA Code Generator](https://gluon.gs.corp/community/docs/latest/components/software/backend/microservice/arsenal/framework/arsenal-backend/tutorials/code-generator-jpa-maven-plugin/)

- [MongoDB](https://www.mongodb.com/)

- Framework Santander Spring Boot:

    - [Santander Spring Boot Core](../../santander-project/santander-spring-boot-core/README.md)

    - [Santander Spring Boot Cache](../../santander-project/santander-spring-boot-cache/README.md)

    - [Santander Spring Boot Logging](../../santander-project/santander-spring-boot-logging/README.md)

    - [Santander Spring Boot Authentication](../../santander-project/santander-spring-boot-security-authentication/README.md)

    - [Santander Spring Boot Authorization](../../santander-project/santander-spring-boot-security-authorization/README.md)

    - [Santander Spring Boot WebService](../../santander-project/santander-spring-boot-webservice/README.md)

    - [Santander Spring Boot Partenon](../../santander-project/santander-spring-boot-partenon/README.md)

    - [Santander Spring Boot Events](../../santander-project/santander-spring-boot-events/README.md)

    - [Santander Spring Boot Batch](../../santander-project/santander-spring-boot-batch/README.md)

    - [Santander Spring Boot GraphQL](../../santander-project/santander-spring-boot-graphql/README.md)

### Correlation table

Based on the above information and in order to give an overview of what will be developed later, the following table is provided with the correspondences between the application types and the dependencies that **are included by default**:

| Dependencies                       | NotWeb | Servlet | Reactive |
|------------------------------------|--------|---------|----------|
| **Spring Cloud Config Client** (1) | Yes    | Yes     | Yes      |
| **Spring Web MVC**                 | No     | Yes     | No       |
| **Spring WebFlux**                 | Yes    | Yes     | Yes      |
| **Spring Boot Actuator**           | Yes    | Yes     | Yes      |
| **Spring HttpClients**             | Yes    | Yes     | Yes      |
| **Springdoc OpenAPI**              | No     | Yes     | Yes      |
| **Santander Spring Boot Core**                    | Yes    | Yes     | Yes      |
| **Santander Spring Boot Cache** (2)               | Yes    | Yes     | Yes      |
| **Santander Spring Boot Omnichannel**             | No     | No      | No       |
| **Santander Spring Boot Logging**                 | Yes    | Yes     | Yes      |
| **Santander Spring Boot Authentication**          | Yes    | Yes     | Yes      |
| **Santander Spring Boot Authorization**           | No     | No      | No       |
| **Santander Spring Boot WebService**              | No     | No      | No       |
| **Santander Spring Boot Metrics**                 | No     | No      | No       |
| **Santander Spring Boot Partenon**                | No     | No      | No       |
| **Santander Spring Boot Events**                  | No     | No      | No       |
| **Santander Spring Boot GraphQL**                 | No     | No      | No       |

1. This dependency can be disabled using the corresponding archetype parameter, `config-client`.

2. `Caffeine` cache as default.

!!! info "Important"

    Since version 3.2 of the archetype the omnichannel library is not included by default, consider adding it if you need it.

### Java support

When generating a project, the archetype use java 17 by default.

!!! info "Important"

    Santander Spring Boot 4.x.y versions are only supported with java 17. Santander Spring Boot 3.x.y versions are supported for use with java 11 and java 17. Santander Spring Boot 2.X versions are only supported with java 11.

## Santander Spring Boot Starter Parent

The Santander Spring Boot archetype uses this starter as the basis for the projects it generates. It is intended to be the main POM for all Santander applications, providing dependencies and plugin management.
This POM can also be used in libraries as dependency management.

The idea is that developers should not worry about which library version they are going to use, as well as providing the list of all available dependencies. It also includes some fixed dependencies and plugins that must be used in all applications,
such as lombok, spring boot starters, jacoco plugin, etc.

!!! note

    More information can be found at the following link: [Santander Spring Boot Starters](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/santander-project/santander-spring-boot-starters/).

## Project generation

As a prerequisite to running the archetype, access to the Nexus repository must be configured in our Maven configuration, which is where the archetypes and proprietary Maven artefacts are stored.

    <repositories>
        <repository>
            <id>maven-public</id>
            <url>https://nexus.alm.europe.cloudcenter.corp/repository/maven-public/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>

In the command line and from the directory in which you want to create the new project, you must execute a maven command like the following, replacing the value of the parameters with those of the project you want to build:

!!! info "Important"

    The parameters in square brackets **are not mandatory**, the function and mandatory nature of each one is detailed below.

!!! tip "Caution"

    If you include Authorization library (*-Dauthorization-library*) to be used with SPAIN authorization service (used by default) you must include the Omnichannel library (*-Domnichannel-library*)

!!! info "Important"

    For batch applications in local environment security is disabled by default. To enable it change "env.security-enabled" in application-local.properties to true.

### Archetype parameters

| Name                                  | Description                                                                                                                                                                                                                                                      | Value                                                                                                                                                     | Required                            |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| ***-B***                              | Indicates that the archetype is running in *Batch* mode.                                                                                                                                                                                                         |                                                                                                                                                           | True                                |
| ***archetypeGroupId***                | Group to which the archetype you want to use belongs.                                                                                                                                                                                                            | `com.santander.framework.springboot`                                                                                                                      | True                                |
| ***archetypeArtifactId***             | Id of the archetype you want to use, its value is `santander-spring-boot-archetype-library`.                                                                                                                                                                        |                                                                                                                                                           | True                                |
| ***archetypeVersion***                | Version of the archetype. It is important to run the latest version of the archetype (goes hand in hand with the latest version of the version of the framework).                                                                                                | You can check the latest version available at the following link: [Changelog](../../CHANGELOG.md). In this example the version is {santander-version}. | True                                |
| ***component-name***                  | Component/application name (this will be the name of the Maven artefact).                                                                                                                                                                                        | For ***non-Gluon applications***: ***\[a-z\]\[a-z0-9-\]{1,32}***. (**maximum length of 33 characters**).                                                  | True                                |
| ***acronym-app***                     | For ***non-Gluon applications***, the Application Key (value in ATLAS if configured) corresponds to the AppKey property of the Santander Spring Boot framework. For ***Gluon applications***, The Application name corresponds to the AppName property of the Santander Spring Boot framework. | For ***non-Gluon applications***, the value must comply with this pattern: ***\[a-z0-9\]+***                                                              | True                                |
| ***system***                          | Value received from ATLAS with the name of the system the application belongs to. This parameter corresponds to the logging property: system.                                                                                                                    |                                                                                                                                                           | Only if it has ATLAS classification |
| ***sub-system***                      | Value received from ATLAS with the name of the subsystem to which the application belongs. This parameter corresponds to the logging property: subsystem.                                                                                                        |                                                                                                                                                           | Only if it has ATLAS classification |
| ***functional-application-code***     | Value received from ATLAS with the name of the application to which it belongs. This parameter corresponds to the logging property: application.                                                                                                                 |                                                                                                                                                           | Only if it has ATLAS classification |
| ***functional-sub-application-code*** | Value received from ATLAS with the name of the sub-application to which the application belongs. This parameter corresponds to the logging property: subapplication.                                                                                             |                                                                                                                                                           | Only if it has ATLAS classification |
| ***groupId***                         | The `groupId` displayed in the project pom will be generated from the `acronym-app`.                                                                                                                                                                             | e.g. com.santander.{acronym-app}                                                                                                                          | True                                |
| ***artifactId***                      | The `artifactId` displayed in the project pom will have the same value as the `component-name` parameter.                                                                                                                                                        |                                                                                                                                                           | True                                |
| ***version***                         | The default version for a new project.                                                                                                                                                                                                                           | **1.0.0-SNAPSHOT**                                                                                                                                        | True                                |
| ***package***                         | The `package` of the Java project is generated from the values of the `groupId` and `artifactId`.                                                                                                                                                                | {groupId}.{artifactId.replaceAll("-", "").replaceAll("\_", "")}                                                                                           | True                                |
| ***description***                     | The default project description has the following text.                                                                                                                                                                                                          | \${acronym-app} santander spring boot microservice: \${component-name}                                                                                    | True                                |
| ***config-client***                   | Indicates whether you want to include the configuration service client dependency.                                                                                                                                                                               | {Y,N,true,false} - By default: ***Y***                                                                                                                    | False                               |
| ***cache-type***                      | Sets the type of cache to be incorporated into the application.                                                                                                                                                                                                  | -Dcache-type= **caffeine**, **infinispan** and **dual**. By default, the value will be **dual**.                                                          | False                               |
| ***authorization-library***           | Indicates that you want to use the application authorisation library.                                                                                                                                                                                            | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***metrics-component***               | Indicates that you want to incorporate the metrics component into the application.                                                                                                                                                                               | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***webservice-component***            | Indicates that you want to incorporate the webservice component into the application.                                                                                                                                                                            | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***partenon-component***              | Indicates that you want to incorporate the component with the partenon connector into the application.                                                                                                                                                           | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***events-component***                | Indicates that the event component is to be incorporated into the application.                                                                                                                                                                                   | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***graphql***                         | Indicates that the app use GraphQL. This param add dependencies and example code.                                                                                                                                                                                | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***api-first***                       | Indicates that the app will be generated as an API First app. Only available for servlet and reactive apps.                                                                                                                                                      | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***api-spec-url***                    | The Location of the OpenAPI schema to be used when is an API First app (typically an URL).                                                                                                                                                                       | Default: {project.basedir}/src/main/resources/config/openapi.yaml                                                                                         | False                               |
| ***logging-kafka***                   | Indicates that the app load kafka appenders for logging.                                                                                                                                                                                                         | {Y,N,true,false} Default: Y                                                                                                                               | False                               |
| ***logging-entity***                  | To identify the application's country in the monitoring systems (by default, the value will be ESP).                                                                                                                                                             | -logging-entity=ESP                                                                                                                                       | False                               |
| ***gluon***                           | Indicates that the app will comply with GLUON properties and requirements.                                                                                                                                                                                       | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***gluonlog-company***                | The company code in Gluon. Previously, this attribute was named as "entity".                                                                                                                                                                                     |                                                                                                                                                           | False                               |
| ***gluonlog-component-name***         | The component short name in Gluon.                                                                                                                                                                                                                               |                                                                                                                                                           | False                               |
| ***gluonlog-component-id***           | The component identifier in Gluon.                                                                                                                                                                                                                               |                                                                                                                                                           | False                               |
| ***gluonlog-component-type***         | The type of component in Gluon.                                                                                                                                                                                                                                  |                                                                                                                                                           | False                               |
| ***gluonlog-app-id***                 | The technical application identifier in Gluon.                                                                                                                                                                                                                   |                                                                                                                                                           | False                               |
| ***webAppType***                      | Type of application to be generated in relation to the values of the property [WebApplicationType](https://docs.spring.io/spring-boot/docs/2.0.x/api/org/springframework/boot/WebApplicationType.html) property of Spring Boot.                                             | -DwebAppType= **notweb** (*NONE*), **batch** (*NONE*), **servlet** (*SERVLET*) o **reactive** (*REACTIVE*). By default, the value will be **servlet**.    | False                               |
| ***batch-integration***               | Whether to create the batch archetype with Batch Accelerator or not.                                                                                                                                                                                             | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***batch-integration-version***       | The version of the Batch Accelerator to use. By default it uses the version specified in Santander Spring Boot Dependencies                                                                                                                                         | Default: N                                                                                                                                                | False                               |
| ***database-client***                 | Indicates that you want to incorporate the component with a database connector into the application.                                                                                                                                                             | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***database-client-type***            | The database to use in the servlet archetype.                                                                                                                                                                                                                    | {oracle,postgresql,UNDEFINED}                                                                                                                             | False                               |
| ***native-compilation***              | The microservice is going to be created native compatible                                                                                                                                                                                                        | {Y,N,true,false} Default: N                                                                                                                               | False                               |
| ***mongo-component***                 | Indicates that you want to incorporate the component with the mongo connector into the application.                                                                                                                                                              | {Y,N,true,false} Default: N                                                                                                                               | False                               |

There are some parameters that **should not be changed** to ensure the correct execution of the archetype, these are:

- ***-B***: indicates that the archetype will be executed in *Batch* mode.

- ***archetypeGroupId***: Group to which the archetype to be used belongs, its value is `com.santander.framework.springboot`.

- ***archetypeArtifactId***: Id of the archetype to be used, its value is `santander-spring-boot-archetype-microservice`.

- ***archetypeVersion***: Version of the archetype, it is important to run the latest version of the archetype (it goes hand in hand with the latest version of the framework). You can check the latest version available at the following link:
    [Changelog](../../CHANGELOG.md). In this example the version is {santander-version}.

#### Mandatory parameters

Next to the fixed parameters, there are some **mandatory parameters that will customize the generated project**, these are:

- ***component\_name***: Name of the component (it will be the name of the Maven artifact).

!!! warning

    For ***non-Gluon applications*** the value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9-\]{1,32}***. It must start with a lowercase letter and continue with lowercase letters, numbers and hyphens, having a **maximum length of 33 characters**.

- ***acronym-app***: This parameter represents the key or name for any kind of Application generated through the Santander Spring Boot archetype.

!!! info "Important"

    - For ***non-Gluon applications***, ***acronym-app*** corresponds to the AppKey property (***santander.app-key***).
    
    - For ***Gluon applications***, ***acronym-app*** corresponds to the AppName property (***santander.app-name***).

!!! warning

    For ***non-Gluon applications***, the value we give to ***acronym-app*** must comply with the following regular expression: ***\[a-z0-9\]+***. It must contain one or more characters (lowercase letter or number).

- ***webAppType***: Application type of the [mentioned above](#application-types) that we want to generate in relation to the values of the Spring Boot
      [WebApplicationType](https://docs.spring.io/spring-boot/docs/3.5.6/api/org/springframework/boot/WebApplicationType.html) property. of Spring Boot.
      Possible values: **batch** (*NONE*), **notweb** (*NONE*), **servlet** (*SERVLET*) or **reactive** (*REACTIVE*).

!!! info "Important"

    This question will have a lot of value for the dependencies and structure of the project.

From these parameters the **properties needed for any maven project** are formed automatically:

- ***groupId***: The `groupId` to appear in the project pom shall be generated from the `acronym-app` parameter as follows:

<!-- -->

    com.santander.{acronym-app}

- ***artifactId***: The `artifactId` that will appear in the project's pom will have the same value that we have given to the `component-name` parameter.

- ***version***: The default version for a new project will always be **1.0.0-SNAPSHOT**.

- ***package***: The `package` of the Java project will be generated from the `groupId` and `artifactId` values as follows:

<!-- -->

    {groupId}.{artifactId.replaceAll("-", "").replaceAll("_", "")}

!!! warning

    If it is defined as input, the value of the *_package_* parameter cannot be equal to 'com.santander.framework.springboot'.

- ***description***: The default project description shall have the following text:

<!-- -->

    ${acronym-app} santander spring boot microservice: ${component-name}

- ***job-name***: Mandatory parameter for batch project generation. It’s not necessary for other projects, the default value for those would be `customerJob`

#### Optional parameters

Finally, there are some optional parameters with which we can specify the libraries and some configuration we want to include in it.

- ***system***: Value received from ATLAS with the name of the system to which the application belongs.

- ***sub-system***: Value received from ATLAS with the name of the subsystem to which the application belongs.

- ***functional-application-code***: Value received from ATLAS with the name of the application to which the application belongs.

- ***functional-sub-application-code***: Value received from ATLAS with the name of the sub-application to which the application belongs.

!!! note

    These parameters correspond to the logging properties: system, subsystem, application and subapplication.

To include/exclude the ***Spring Cloud Service Config*** client dependency, we have the following parameter:

- ***client-config***: Indicates if we want to include or exclude the Spring Cloud Configuration client, but **it won't be configured anyway**. If the parameter is not defined, the default value will be ***Y*** (dependency included), therefore, to
    not include this dependency the parameter must have value ***N*** in the generation of the microservice.

As for the **framework libraries and others external to the framework**, by default **none of the following libraries are included**, to include them, we simply **add the parameter** to the maven command (-D*parameter-name*) or **assign the value
Y** (-D*parameter-name*=Y). These are:

- ***cache-type***: Sets the type of cache to be incorporated into the application. Possible values: `caffeine`, `infinispan` and `dual`. By default, the value will be `caffeine`.
- ***authorization-library***: Indicates that you want to use the authorization library to the application.
- ***omnichannel-library***: Indicates that you want to use the omnichannel library to the application.
- ***metrics-component***: Indicates that you want to incorporate the metrics component to the application.
- ***webservice-component***: Indicates that you want to incorporate the webservice component into the application.
- ***partenon-component***: Indicates that you want to incorporate the component with the partenon connector into the application.
- ***events-component***: Indicates that you want to incorporate the events component into the application.
- ***graphql***: Indicates that the app use GraphQL. This param add dependencies and example code.
- ***logging-kafka***: Indicates that the app load kafka appenders for logging.
- ***logging-entity***: To identify the application's country in the monitoring systems (by default, the value will be ESP).
- ***api-first***: Indicates that the app will be generated as an API First. This param adds the necessary generator and a sample OpenApi Specification file. Only available for servlet and reactive apps.
- ***api-spec-url***: Indicates the current Location of the OpenAPI schema for be used as a param to the microservice archetype in the context of API First app (typically an URL). Only available for servlet and reactive app.
- ***gluon***: Indicates that the application will use Gluon error format. (by default, the value will be 'N')
- ***batch-integration***: Indicates whether to create the batch archetype with Batch Accelerator or not. (by default, the value will be 'N').
- ***batch-integration-version***: Indicates the version of the Batch Accelerator to use. By default, it uses the version specified in Santander Spring Boot Dependencies.
- ***database-client***: Indicates that you want to incorporate the component with a database connector into the application.
- ***database-client-type***: Indicates the database to use in the servlet archetype. It is possible to choose between oracle and postgresql.
- ***native-compilation***: Indicates if the native compilation is going to be used. (by default, the values will be 'N').
- ***mongo-component***: Indicates that you want to incorporate the component with the mongo connector into the application.

!!! note

    Remember that the Santander Spring Boot Logging, Authentication and Cache libraries, the Spring Http clients and the Spring Cloud Config Client module are **always** included in the generated applications.

!!! info "Important"

    Since version 3.2, if you add the authorization module and use the Spain mode, you need to add the omnichannel module.

#### Gluon Logging Parameters

The following are required when the ***gluon*** parameter is set to 'Y' or 'true':

- ***gluonlog-company*** : The company code in Gluon. Previously, this attribute was named as "entity".

- ***gluonlog-component-name*** : The component short\_name in Gluon.

- ***gluonlog-component-id*** : The component id in Gluon.

- ***gluonlog-component-type*** : The type of component in Gluon.

- ***gluonlog-app-id*** : The technical application short name in Gluon.

### Examples of use

Here are some examples of how to use the maven command to configure the project according to the parameters:

1. Basic application: the command is executed only with the mandatory parameters.

2. Application with added libraries: the command is executed adding some optional parameters to add those libraries.

3. GraphQl application: the command is executed to create a GraphQl application.

4. Application with invalid parameters: the command is executed by entering an invalid value in the parameters.

#### Basic application

The first example corresponds to the generation of an application with only the mandatory parameters and dependencies, and in which we only have to choose the type of application, which will be: NotWeb, Servlet or Reactive. For example, for a
Servlet application:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=servlet
```

#### Gluon application

This case corresponds to the generation of a ***Gluon*** application with the mandatory parameters and dependencies, and in which we only have to choose the type of application, which will be: NotWeb, Servlet or Reactive. For example, for a Reactive
application:

For creating a Gluon application, additionally, it is mandatory to provide the following parameters:

- ***gluon***
- ***gluonlog-company***
- ***gluonlog-component-name***
- ***gluonlog-component-id***
- ***gluonlog-component-type***
- ***gluonlog-app-id***

!!! note

    Remember that the ***acronym-app*** parameter corresponds to AppName property.

Example of Gluon application:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=applicationgluon -Dacronym-app=gluonapp -DwebAppType=reactive -Dgluon=Y -Dgluonlog-company=ESP -Dgluonlog-component-name=gluon-component -Dgluonlog-component-id=gluon-id -Dgluonlog-component-type=gluon-type -Dgluonlog-app-id=gluon-app-id
```

#### Application with added libraries

If we want to add any of the optional libraries, we only need to add its associated parameter to our command, for example, to add the Authorization library and the WebService component:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-1 -Dacronym-app=myapplication2 -DwebAppType=reactive -Dauthorization-library -Domnichannel-library -Dwebservice-component=Y
```

#### Application with PostgreSQL

If we want to create the application with PostgreSQL database, we need to add  `database-client=true` and `database-client-type=postgresql` parameter to our command, for example:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=servlet -Ddatabase-client=true -Ddatabase-client-type=postgresql
```

#### Application with native compilation support

If we want to create the application with native compilation support, we need to add `native-compilation=true`, for example:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=applicationgluon -Dacronym-app=gluonapp -DwebAppType=reactive -Dgluon=Y -Dgluonlog-company=ESP -Dgluonlog-component-name=gluon-component -Dgluonlog-component-id=gluon-id -Dgluonlog-component-type=gluon-type -Dgluonlog-app-id=gluon-app-id -Dnative-compilation=true
```

#### Application with API First

If we want to create an application with an API First approach, we only need to add the api-first parameter to our command, for example:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-2 -Dacronym-app=myapps -DwebAppType=reactive -Dapi-first
```

If we also want to indicate the URL which contains the OpenAPI definition file
(for example "https://catalog-api/domain/resources/openapi.yaml"), we have to include both parameter of API First params as follows:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-2 -Dacronym-app=myapps -DwebAppType=reactive -Dapi-first -Dapi-spec-url='https://catalog-api/domain/resources/openapi.yaml'
```

#### Application with graphQL

If we want to create the application with graphQL API, we only need to add graphql parameter to our command, for example:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=reactive -Dgraphql
```

#### Application with Apache Camel

If we want to create the application with Apache Camel, we only need to add `camel` parameter to our command, for example:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=servlet -Dcamel=true

#### Application with invalid parameters

As we have seen before, some parameters have a validation of their content, in case of not complying with it, an error message will be displayed and the generated project will be deleted.

For example, the parameter ***component-name*** must comply with the following validation: "*begin with a lowercase letter and continue with lowercase letters, numbers or hyphens, with a maximum of 33 characters*" If we use the value "Application-1"
the following will happen:

```shell
mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.framework.springboot -DarchetypeArtifactId=santander-spring-boot-archetype-microservice -DarchetypeVersion=1.2.1 -Dcomponent-name=Application-1 -Dacronym-app=myapps -DwebAppType=notweb

[INFO] Scanning for projects...
[INFO]
[INFO] ------------------< org.apache.maven:standalone-pom >-------------------
[INFO] Building Maven Stub Project (No POM) 1
[INFO] --------------------------------[ pom ]---------------------------------
[INFO]
[INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-pom >>>
[INFO]
[INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
[INFO]
[INFO]
[INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
[INFO] Generating project in Batch mode
(...)
[INFO] ----------------------------------------------------------------------------
[INFO] Using following parameters for creating project from Archetype: santander-spring-boot-archetype-microservice:1.0.0-RELEASE
[INFO] ----------------------------------------------------------------------------
[INFO] Parameter: groupId, Value: com.santander.myapps
[INFO] Parameter: artifactId, Value: Application-1
[INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
[INFO] Parameter: package, Value: com.santander.myapps.Application1
[INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/Application1
[INFO] Parameter: package, Value: com.santander.myapps.Application1
[INFO] Parameter: config-client, Value: Y
[INFO] Parameter: metrics-component, Value: N
[INFO] Parameter: groupId, Value: com.santander.myapps
[INFO] Parameter: description, Value: myapps santander spring boot microservice: Application-1
[INFO] Parameter: webservice-component, Value: N
[INFO] Parameter: partenon-component, Value: N
[INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
[INFO] Parameter: component-name, Value: Application-1
[INFO] Parameter: omnichannel-library, Value: N
[INFO] Parameter: authorization-library, Value: N
[INFO] Parameter: events-component, Value: N
[INFO] Parameter: artifactId, Value: Application-1
[INFO] Parameter: webAppType, Value: notweb
[INFO] Parameter: acronym-app, Value: myapps
[INFO] Parameter: logging-kafka, Value: Y
[INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  15.919 s
[INFO] Finished at: 2020-06-09T11:15:26+02:00
[INFO] ------------------------------------------------------------------------
Exception in thread "main" java.lang.AssertionError: The component-name parameter must start with a lower case letter and can have up to 32 other characters: lower case letters, numbers or '-'. Value: Application-1. Expression: componentNameMatch. Values: componentNameMatch = false
        at org.codehaus.groovy.runtime.InvokerHelper.assertFailed(InvokerHelper.java:422)
        at org.codehaus.groovy.runtime.ScriptBytecodeAdapter.assertFailed(ScriptBytecodeAdapter.java:663)
        at Script1.run(Script1.groovy:32)
        at groovy.lang.GroovyShell.evaluate(GroovyShell.java:574)
        at groovy.lang.GroovyShell.evaluate(GroovyShell.java:612)
        at groovy.lang.GroovyShell.evaluate(GroovyShell.java:583)
        ...
```

!!! note

    For each parameter with validation, a separate message will be displayed with its valid format.

## Resulting project

The structure and content of the resulting project files will depend on the value given to some parameters.

### Project structure

The structure of the project will depend on the use (or not) of API GraphQL and the type of application chosen: NotWeb or Web (Servlet or Reactive).
Following hexagonal architecture principles, projects can have multiple layers (domain, application, infrastructure, etc.) and will be organized in packages according to the chosen architecture.
The package structure generated may vary depending on the type of application that you need. The application will follow hexagonal architecture, which means it will have three main packages: domain, application, and infrastructure.
Take a look at a typical package structure:

- **Domain Package**
The domain package contains the core business logic of the application. It includes entities, value objects, and services that represent the core business concepts.
The domain package is independent of other layers and should not contain any framework-specific code. Think of the domain layer as the heart of the application, where information is processed and decisions are made.

| Sub-packages   | Description                                                                                                     |
|----------------|-----------------------------------------------------------------------------------------------------------------|
| entity         | Entities or objects that represent the core business concepts the application, encapsulating state and behavior |
| service        | Services that implement the core operations and workflows of your application, orchestrate entities' interaction|

- **Application Package**
The application package contains the use cases that drive the application’s behavior. It coordinates the domain layer with external services and interfaces.
To do this, the application layer also contains input and output ports that define the contracts the application uses to communicate with external services.
In our examples, input ports are implementations of the use case interfaces, defining the ways in which the outside world can interact with our application.
They are meant to be used as dependencies for input adapter classes, while output ports are interfaces that define the application’s interactions with external services.
Think of input ports as the entry points to the application, that input adapters can use to get access to the application’s use cases.
Output ports define the interfaces the application uses to communicate with external services, and are implemented by output adapters that define specific implementations for these interfaces with each required external technology.

| Sub-packages   | Description                                                                                                                       |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------|
| usecases       | Use cases define the main goals the application must achieve, they serve as the application’s behavior blueprint                  |
| ports/input    | Input ports implement the use case interfaces, orchestrating the flow of information between the domain and infrastructure layers |
| ports/output   | Output ports define the interfaces the application uses to communicate with external services                                     |

- **Infrastructure Package**
The infrastructure package contains the adapters that connect the application to external services and interfaces. Adapters, like ports, can be input or output.
Input adapters define the classes that allow users or systems to interact with the application and use input ports to execute use cases. They are the components that implement communication from outside systems into the application, using input ports.
Think of REST, graphql, or SOAP controllers as input adapters, as they allow external systems to interact with the application.
Output adapters implement the interfaces defined by output ports, allowing the application to communicate with external services. They contain framework-specific code or annotations required to interact with external services.
Think of database repositories, message queues or external APIs, as output adapters, as they allow the application to interact with external services.
The infrastructure also contains the configuration classes that set up framework-specific configurations, such as swagger configuration, spring related configurations, etc.
When using native-compilation options, AOT hints can also be added to the infrastructure package.

| Sub-packages   | Description                                                                                                                            |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------|
| adapters/input | Input adapters define the classes that allow users or systems to interact with the application, using input ports to execute use cases |
| adapters/output| Output adapters implement the interfaces defined by output ports, allowing the application to communicate with external services       |
| config         | Configuration classes that set up framework-specific configurations, such as swagger configuration, spring related configurations, etc |

The biggest advantage of hexagonal architecture is that it allows you to build an application that is independent of external services and interfaces.
If a new database or API is introduced, you can simply create a new adapter without modifying the core business logic. Only the infrastructure layer needs to be changed. This makes the application more flexible and easier to maintain.

#### Basic structure (NotWeb application)

For `NotWeb` applications, the generated project will have the following structure:

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                   └── Application.java
        │   └── resources
        │       ├── banner.txt
        │       └── config
        │           ├── application.yml
        |           └── application-local.properties
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── ApplicationTest.java

- Highlight the [**pom.xml**](#pom) file, which contains all the information that Maven uses to manage dependencies, metadata, etc.

In the main folder we find:

- The java folder with the source code of our project: Only the **Application.java** class will be included to start the application using the appropriate `WebApplicationType`. For this case, a `NotWeb` application, this class will also implement
    a `CommandLineRunner` with an example *run* method.

- In the *resources* folder we will have:

    - The *config* subfolder where an **application.yml** file will be generated along with an **application-local.properties** with the [properties files](#property-files-in-production-scope)
necessary to configure the libraries that have been chosen during the creation of the project.

In the *test* folder we will have an **ApplicationTest.java** file that we use to test that the application is correctly built.

Notice that the `NotWeb` does not have the packages that conform hexagonal architecture (domain, application, infrastructure).
As a simple application, it only has the main class and the configuration files, but feel free to add the packages and classes to create a hexagonal architecture application if you need it.

#### Basic structure (Batch Application)

For `NotWeb` applications with `Batch` mode, the generated project will have the following structure:

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                      ├── application
        |   |                      |        └── ports
        |   |                      |        |       └── input
        |   |                      |        |              └── CustomerManagementInputPort.java
        |   |                      |        └── usecases
        |   |                      |               └── CustomerUseCase.java
        │   │                      ├── domain
        │   │                      │     └── enitity
        |   |                      |     |         └── Customer.java
        │   │                      │     └── service
        |   |                      |               └── CustomerService.java
        │   │                      ├── infrastructure
        │   │                      │     └── adapters
        |   |                      |     |       └── input
        |   |                      |     |              └── job
        |   |                      |     |                   └── CustomerJob.java
        |   |                      |     |              └── step
        |   |                      |     |                   └── chunk
        |   |                      |     |                   |     └── CustomerProcessorAdapter.java
        |   |                      |     |                   |     └── CustomerItemReader.java
        |   |                      |     |                   |     └── CustomerItemWriter.java
        |   |                      |     |                   └── tasklet
        |   |                      |     |                   |      └── CustomerTasklet.java
        |   |                      |     |                   └── CustomerChunkStep.java
        |   |                      |     |                   └── CustomerTaskletStep.java
        |   |                      |     └── config
        |   |                      |            └── ApplicationAutoConfig.java
        │   │                      └── Application.java
        │   │                    
        │   └── resources
        │       ├── banner.txt
        │       └── config
        │           ├── application.yml
        │           ├── sample-data.csv
        │           └── application-local.properties
        │
        │
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── application
                                |       └── ports
                                |       |       └── input
                                |       |              └── CustomerManagementInputPortTest.java
                                └── infrastructure
                                |        └── adapters
                                |               └── input
                                |                      └── step
                                |                           └── chunk
                                |                           |     └── CustomerProcessorAdapterTest.java
                                |                           |     └── CustomerItemReaderTest.java
                                |                           |     └── CustomerItemWriterTest.java
                                |                           └── tasklet
                                |                                  └── SampleTaskletTest.java
                                └── ApplicationTest.java

In the main folder we find:

- The main java folder with the source code of the project:

    - Domain folder, with domain classes, such as the **Customer.java** class, which represents a data object, and the **CustomerService.java** class, which is used to transform the data.

    - Application folder, with the use cases and input ports, such as the **CustomerUseCase.java** class, which states out use cases, and the **CustomerManagementInputPort.java** class, which is used to implement the use case.

    - infrastructure folder, with the adapters that connect the application to external services and interfaces:

        - Adapters folder, with the input adapters. The classes here set-up a batch job using Spring Batch.

        - Config folder, which contains the configuration classes that set up Spribg Batch framework-specific configurations, such as the **ApplicationAutoConfig.java** class.

- In the *resources* folder we find:

    - The subfolder *config* where an **application.yml** file will be generated, together with a **application-local.properties** file with the [properties files](#property-files-in-production-scope)
necessary to configure the libraries that have been chosen during the creation of the project.

    - We can also find a sample csv file with some data entries.

In the *test* folder we will have an **ApplicationTests.java** file that we use to test that the application is correctly built, as well as unit tests for other classes in our application.

#### Web Application Structure

In the case of a microservice (`Servlet` or `Reactive`), the generated application example also follows hexagonal architecture.
The domain folder contains the **HelloWorldService.java** class, which is used to implement the core business logic of the application, saying hello.
The application folder contains the **HelloWorldUseCase.java** class, which is used to define the use case, and the **HelloWorldInputPort.java** class, which is used to implement the use case and access the domain logic.
The infrastructure folder contains the rest adapter to interact with our application. The following is generated in the **infrastructure** package of the project:

- A `config` folder with a **SwaggerConfig.java** class that implements a configuration for using Swagger in a microservice.

- A `adapters/input/rest` folder with a **HelloController.java** class that implements a controller (`Servlet` or `Reactive`) that returns \`Hello World!' when an HTTP GET request is made to the */${artifactId}/hello* endpoint.

In addition, in the **resources** folder, an errors.properties file is added for the [configuration of exceptions](../../santander-project/santander-spring-boot-core/README.md#exception-handling) and a subfolder errors with a Resource Bundle of
configurations, for multi-language exceptions (in this case: Spanish (es\_ES) and US English (en\_US)).

The corresponding tests for these classes will also be added: **SwaggerConfigTest.java**, **HelloControllerTest.java**, **HelloWorldServiceTest.java** and **HelloWorldInputPortTest.java**.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                      ├── application
        |   |                      |        └── ports
        |   |                      |        |       └── input
        |   |                      |        |              └── HelloWorldInputPort.java
        |   |                      |        └── usecases
        |   |                      |               └── HelloWorldUseCase.java
        │   │                      ├── domain
        │   │                      │     └── service
        |   |                      |               └── HelloWorldService.java
        │   │                      ├── infrastructure
        │   │                      │     └── adapters
        |   |                      |     |       └── input
        |   |                      |     |              └── rest
        |   |                      |     |                   └── HelloWorldController.java
        |   |                      |     └── config
        |   |                      |            └── ApplicationConfiguration.java
        |   |                      |            └── SwaggerConfig.java
        │   │                      └── Application.java
        │   │                    
        │   └── resources
        │       ├── banner.txt
        |       ├── errors.properties
        |       |── errors
        |       |   └── errors_en.properties
        |       |   └── errors_es.properties
        │       └── config
        │           ├── application.yml
        │           └── application-local.properties
        │
        │
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── application
                                |       └── ports
                                |              └── input
                                |                     └── HelloWorldInputPortTest.java
                                |── domain
                                |       └── service
                                |              └── HelloWorldServiceTest.java
                                └── infrastructure
                                |       └── adapters
                                |       |       └── input
                                |       |              └── rest
                                |       |                   └── HelloWorldControllerTest.java
                                |       |──config
                                |       |       └── SwaggerConfigTest.java
                                └── ApplicationTest.java

#### Web Application with GraphQL Structure

In the case of a microservice (`Servlet` or `Reactive`) with GraphQL the following will also be generated in the **main** of the project:

- A `domain` folder in *java* with a **Person.java** class, which is used to define the entity of the application.

- A `application/usecases` folder in *java* with a **PersonUseCase.java** class, which is used to define the use case of the application.

- A `application/ports/input` folder inside **application** with a **PersonManagementInputPort.java** class that implements the use case of the application.

- A `application/ports/output` folder inside **application** with a **PersonManagementOutputPort.java** class that defines the output port of the application.

- A `adapters/input/graphql` folder inside **infrastructure** with a **PersonController.java** class that implements the queries/mutations of **schema.graphqls** file.

- A `adapters/output` folder inside **infrastructure** with a **PersonManagementAdapter.java** class that implements the output port of the application and uses a java list to store the data.

- A `graphql` folder in *resources* with a **schema.graphqls** file, which contain queries and mutations of graphql.

In addition, in the **resources** folder, an errors.properties file is added for the [configuration of exceptions](../../santander-project/santander-spring-boot-core/README.md#exception-handling) and a subfolder errors with a Resource Bundle of
configurations, for multi-language exceptions (in this case: Spanish (es) and English (en)).

The corresponding tests for these classes will also be added: **Person.java**, **PersonController.java**, **PersonManagementAdapter.java**, **PersonManagementInputPort.java**.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                      ├── application
        |   |                      |        └── ports
        |   |                      |        |       └── input
        |   |                      |        |       |       └── PersonManagementInputPort.java
        |   |                      |        |       └── output
        |   |                      |        |              └── PersonManagementOutputPort.java
        |   |                      |        └── usecases
        |   |                      |               └── PersonUseCase.java
        │   │                      ├── domain
        │   │                      │     └── entity
        |   |                      |               └── Person.java
        │   │                      ├── infrastructure
        │   │                      │     └── adapters
        |   |                      |     |       └── input
        |   |                      |     |       |       └── graphql
        |   |                      |     |       |            └── PersonController.java
        │   │                      |     |       └── output
        |   |                      |     |              └── PersonManagementAdapter.java
        |   |                      |     └── config
        |   |                      |            └── ApplicationConfiguration.java
        │   │                      └── Application.java
        │   │                    
        │   └── resources
        |       ├── graphql
        |       |   └── schema.graphqls
        │       ├── banner.txt
        |       ├── errors.properties
        |       |── errors
        |       |   └── errors_en.properties
        |       |   └── errors_es.properties
        │       └── config
        │           ├── application.yml
        │           └── application-local.properties
        │
        │
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── application
                                |       └── ports
                                |              └── input
                                |                     └── PersonManagementInputPortTest.java
                                |── domain
                                |       └── entity
                                |              └── PersonTest.java
                                └── infrastructure
                                |       └── adapters
                                |       |       └── input
                                |       |       |       └── graphql
                                |       |       |            └── PersonControllerTest.java
                                |       |       └── output
                                |       |              └── PersonManagementAdapterTest.java
                                └── ApplicationTest.java

#### Web Application with Events Component Structure

In the case of a microservice (`Servlet`, `Reactive`, or `NotWeb`) with Events library the following will also be generated in the **main** of the project:

- A `avro` folder in *resources* with a **user.avsc** file, which contains a sample data schema of a user.

<!-- -->

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                      ├── application
        |   |                      |        └── ports
        |   |                      |        |       └── input
        |   |                      |        |       |       └── PersonManagementInputPort.java
        |   |                      |        |       └── output
        |   |                      |        |              └── PersonManagementOutputPort.java
        |   |                      |        └── usecases
        |   |                      |               └── PersonUseCase.java
        │   │                      ├── domain
        │   │                      │     └── entity
        |   |                      |               └── Person.java
        │   │                      ├── infrastructure
        │   │                      │     └── adapters
        |   |                      |     |       └── input
        |   |                      |     |       |       └── graphql
        |   |                      |     |       |            └── PersonController.java
        │   │                      |     |       └── output
        |   |                      |     |              └── PersonManagementAdapter.java
        |   |                      |     └── config
        |   |                      |            └── ApplicationConfiguration.java
        │   │                      └── Application.java
        │   │                    
        │   └── resources
        |       ├── avro
        |       |   └── user.avsc
        |       ├── graphql
        |       |   └── schema.graphqls
        │       ├── banner.txt
        |       ├── errors.properties
        |       |── errors
        |       |   └── errors_en.properties
        |       |   └── errors_es.properties
        │       └── config
        │           ├── application.yml
        │           └── application-local.properties
        │
        │
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── application
                                |       └── ports
                                |              └── input
                                |                     └── PersonManagementInputPortTest.java
                                |── domain
                                |       └── entity
                                |              └── PersonTest.java
                                └── infrastructure
                                |       └── adapters
                                |       |       └── input
                                |       |       |       └── graphql
                                |       |       |            └── PersonControllerTest.java
                                |       |       └── output
                                |       |              └── PersonManagementAdapterTest.java
                                └── ApplicationTest.java

#### Web Application with PostgreSQL Database Structure

In the case of a microservice (`Servlet`) with PostgreSQL database the following will also be generated in the **main** of the project:

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── santander
        │   │               └── testapp
        │   │                      ├── application
        |   |                      |        └── ports
        |   |                      |        |       └── input
        |   |                      |        |              └── HelloWorldInputPort.java
        |   |                      |        |              └── UserManagementInputPort.java                
        |   |                      |        └── usecases
        |   |                      |               └── HelloWorldUseCase.java
        |   |                      |               └── UserManagementUseCase.java
        │   │                      ├── domain
        |   |                      |     └── entity
        |   |                      |     |       └── ExampleUserRecord.java
        │   │                      │     └── service
        |   |                      |               └── HelloWorldService.java
        │   │                      ├── infrastructure
        │   │                      │     └── adapters
        |   |                      |     |       └── input
        |   |                      |     |       |      └── rest
        |   |                      |     |       |           └── HelloWorldController.java
        |   |                      |     |       |           └── DatabaseController.java
        |   |                      |     |       └── output
        |   |                      |     |              └── jpa
        |   |                      |     |                   └── data
        |   |                      |     |                   |     └── ExampleUser.java
        |   |                      |     |                   |── repository
        |   |                      |     |                   |     └── ExampleUserRepository.java
        |   |                      |     |                   |── mapper
        |   |                      |     |                   |     └── UserJPAMapper.java
        |   |                      |     |                   └── UserManagementJPAApdater.java
        |   |                      |     └── config
        |   |                      |            └── ApplicationConfiguration.java
        |   |                      |            └── SwaggerConfig.java
        │   │                      └── Application.java
        │   │                    
        │   └── resources
        |       ├── schema.sql
        │       ├── banner.txt
        |       ├── errors.properties
        |       |── errors
        |       |   └── errors_en.properties
        |       |   └── errors_es.properties
        │       └── config
        │           ├── application.yml
        │           └── application-local.properties
        │
        │
        └── test
            └── java
                └── com
                    └── santander
                        └── santander
                            └── testapp
                                └── application
                                |       └── ports
                                |              └── input
                                |                     └── HelloWorldInputPortTest.java
                                |                     └── UserManagementInputPortTest.java
                                |── domain
                                |       └── service
                                |              └── HelloWorldServiceTest.java
                                └── infrastructure
                                |       └── adapters
                                |       |       └── input
                                |       |       |      └── rest
                                |       |       |           └── HelloWorldControllerTest.java
                                |       |       |           └── DatabaseControllerTest.java
                                |       |       └── output
                                |       |              └── jpa
                                |       |                   └── data
                                |       |                   |     └── ExampleUserTest.java
                                |       |                   |── repository
                                |       |                   |     └── ExampleUserRepositoryTest.java
                                |       |                   |── mapper
                                |       |                   |     └── UserJPAMapperTest.java
                                |       |                   └── UserManagementJPAApdaterTest.java
                                |       |──config
                                |       |       └── SwaggerConfigTest.java
                                └── ApplicationTest.java

The `src/main/java` folder includes :

- An **Application.java** class to start the application using the appropriate `WebApplicationType`.
- A `domain` package with a **ExampleUserRecord.java** record to represent the user entity.
- A `application/usecases` package with a **UserManagementUseCase.java** class that defines the use case of the application.
- A `application/ports/input` package with a **UserManagementInputPort.java** class that implements the use case of the application.
- A `application/ports/output` package with a **UserManagementOutputPort.java** class that defines the output port of the application.
- An `infrastructure` package with the following sub-packages:
    - An `adapters/input/rest` package with a **DatabaseController.java** class that implements a Servlet controller for creating and retrieving data from the database.
    - An `adapters/output/jpa/data` package with an **ExampleUser.java** entity class that represents the user entity in the database.
    - An `adapters/output/jpa/repository` package with an **ExampleUserRepository.java** interface that extends JpaRepository.
    - An `adapters/output/jpa/mapper` package with a **UserJPAMapper.java** class that maps the user entity to the user record from our domain.
    - An `adapters/output` package with a **UserManagementJPAApdater.java** class that implements the output port of the application and uses the jpa repository to store the data.

Also, the classes from the HelloWorld! example will also be included in the project.

#### Web Application with API First Approach

In case of building a microservice following an API First approach, the following file will also be generated:

- An **openapi.yaml** file in the 'resources/config' folder, with a sample OpenAPI Specification file.

!!! note

    In order to generate the skeleton code of the microservice, replace the openapi.yaml file with your [specification](https://swagger.io/specification/) and execute the command: **mvn compile**

        ├── mvnw
        ├── mvnw.cmd
        ├── pom.xml
        └── src
            └── main
                └── resources
                    ├── banner.txt
                    ├── errors.properties
                    └── config
                        ├── application.yml
                        ├── application-local.properties
                        └── openapi.yaml

    If we pass the URL where our OpenAPI specification file is hosted to the api-spec-url parameter, the microservice archetype will use it to generate the skeleton code of the microservice and the sample OpenAPI specification file will not be present in 'resources/ config'. file
    as follows

        ├── mvnw
        ├── mvnw.cmd
        ├── pom.xml
        └── src
            └── main
                └── resources
                    ├── banner.txt
                    ├── errors.properties
                    └── config
                        ├── application.yml
                        └── application-local.properties

### Configuration files

#### POM

The **pom.xml** file contains all the information that Maven uses to identify the generated project and manage its dependencies.

At the beginning it will always have the identification/metadata of the application we have created:

      <groupId>com.santander.framework.springboot</groupId>
        <artifactId>testapp</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>

        <name>testapp</name>
        <description>myapps santander spring boot microservice: testapp</description>

The Santander Spring Boot framework defines the POM parent [mentioned previously](#santander-spring-boot-starter-parent) to manage library versions so that there are no conflicts between them:

        <parent>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-parent</artifactId>
            <version>{santander-version}</version>
        </parent>

!!! info "Important"

    Note that due to this POM parent, none of the dependencies that will be shown below are versioned.

Next, we define as a property, the java version we want to compile with. The version that will appear by default in the *pom.xml* will be ***17***.

      <properties>
            <java.version>17</java.version>
        </properties>

From here we define the dependencies and plugins that the project will use. There are certain dependencies (as we have seen in the [correlation table](#correlation-table)) that will be **included in any application** and will therefore **appear in
all pom**:

    (...)
        <dependencies>

            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId> (1)
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-kafka</artifactId> (2)
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

2. Unless otherwise specified, the Santander Spring Boot Starter Logging Kafka is included in every application. You can disable it with *-Dlogging-kafka=N*.

The dependencies with **test** scope and plugins section will also be common for all projects; however, there are dependencies that the project will have depending on the value of some parameters.

Below are five examples of possible resulting files.

##### Example: Basic NotWeb application

A basic `NotWeb` application in which no other libraries have been selected generates the same pom as above, with the only mandatory dependencies for all applications.

##### Example: NotWeb application in Batch mode

A basic `NotWeb` application in which no other libraries have been selected generates the same pom as above, with the only mandatory dependencies for all applications, plus Spring Batch and Spring Task, as well as a H2 in-mem database dependency for
testing purposes.

    (...)
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-batch</artifactId>
            </dependency>

            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-task</artifactId>
            </dependency>
            (...)
    </dependencies>
    (...)

We use the local \[-p\] profile to load the H2 dependency. If we install with a different profile the H2 dependency will not be loaded.

    (...)
      <profiles>
         <profile>
         <id>local</id>
           <dependencies>
           <!-- We use the H2 database as a test, replace by the appropriate database -->
             <dependency>
               <groupId>com.h2database</groupId>
               <artifactId>h2</artifactId>
             </dependency>
           </dependencies>
         </profile>
      </profiles>
    (...)

##### Example: Application with added libraries

For this example we are going to start from the basic pom of a `NotWeb` application where the Authorization library and the WebService component have been specified, the archetype will incorporate the following dependencies:

    (...)
        <dependencies>

            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId> (1)
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- Authorization dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authorization</artifactId>
            </dependency>
            <!-- Webservice dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-webservice</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->

            <!-- Test Dependencies -->
            (...)
    </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

!!! note

    This would also be the case when adding a library to a Servlet or Reactive application, so these examples will be ignored.

##### Example: Application without Santander Spring Boot Logging Kafka

If the same application from last example didn't include the Santander Spring Boot Logging Kafka Starter (*-Dlogging-kafka=N*) the archetype will modify the Santander Spring Boot Logging Starter dependency:

    (...)
    <dependencies>
            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>

            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId> (1)
            </dependency>
            <!-- Spring Cloud Services -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-function-adapter-azure</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.experimental</groupId>
                <artifactId>spring-graalvm-native</artifactId>
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-basic</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->
        </dependencies>
        <!-- Test dependencies -->
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

##### Example: Servlet application

For a `Servlet` application the archetype will incorporate some dependencies on the common ones:

    (...)
        <dependencies>

            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId> (1)
            </dependency>
            <!-- Servlet WebApp starter  -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!-- OpenAPI al arquetipo -->
            <dependency>
                <groupId>org.springdoc</groupId>
                <artifactId>springdoc-openapi-ui</artifactId>
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

##### Example: Reactive application

For a basic `Reactive` application, the archetype will incorporate the following dependencies:

    (...)
        <dependencies>

            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId> (1)
            </dependency>
            <!-- Reactive WebApp Starter -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-webflux</artifactId>
            </dependency>
            <!-- OpenAPI al arquetipo -->
            <dependency>
                <groupId>org.springdoc</groupId>
                <artifactId>springdoc-openapi-webflux-ui</artifactId>
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

##### Example: Servlet application with graphql

For a `Servlet` application with GraphQl, the archetype will remove and incorporate some dependencies from the common ones: it will remove openAPI dependency (**springdoc-openapi-ui** in *servlet* or **springdoc-openapi-webflux-ui** in *reactive*)
and add graphql starter and test dependencies:

    (...)
        <dependencies>

            <!-- Spring Boot Actuator dependency -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <!-- Spring Config Service Client dependency -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId>
            </dependency>
            <!-- Servlet WebApp starter  -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!-- Santander Santander Spring Boot libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- Graphql dependency -->
            <dependency>
                <groupId>com.santander.framework.springboot</groupId>
                <artifactId>santander-spring-boot-starter-graphql</artifactId>
            </dependency>
            <!-- End Santander Santander Spring Boot libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

##### Example: Servlet with PostgreSQL database application

For a `Servlet` application with a `PostgreSQL` database, the archetype will incorporate some dependencies on the common ones:

    (...)
        <dependencies>

        <!-- Spring Boot Actuator dependency -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>

        <!-- Spring Config Service Client dependency -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-config</artifactId>
        </dependency>

        <!-- Servlet WebApp starter	-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- OpenAPI dependency -->
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        </dependency>
        <!-- Santander Santander Spring Boot libraries -->
        <!-- Core dependency -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-core</artifactId>
        </dependency>
        <!-- Logging dependency -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-logging-basic</artifactId>
        </dependency>
        <!-- Cache dependency -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-cache-caffeine</artifactId>
        </dependency>
        <!-- Authentication dependency -->
        <dependency>
            <groupId>com.santander.framework.springboot</groupId>
            <artifactId>santander-spring-boot-starter-authentication</artifactId>
        </dependency>
        <!-- End Santander Santander Spring Boot libraries -->

        (...)
        <!-- Postgresql dependencies -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
        </dependency>
        <!-- JPA dependencies -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <!-- H2 dependencies -->
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- Spring security dependency for testing -->
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>
        </dependencies>
        (...)
        <build>
        <!-- Build plugins -->
        <plugins>
        <!-- Arsenal JPA Code Generator for Database Entities and Repositories -->
            <plugin>
                <groupId>com.santander.ars</groupId>
                <artifactId>gln-back-arsenal-jpa-codegen-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <sqlScript>${project.basedir}\src\main\resources\schema.sql</sqlScript>
                    <entityPackage>${package}.entity</entityPackage>
                    <repositoryPackage>${package}.repository</repositoryPackage>
                    <fileOverride>false</fileOverride> <!-- This property is false by default -->
                </configuration>
            </plugin>
    (...)

##### Example: Native application

For a `Native` application, the archetype will incorporate the following changes:

- In pom.xml
  - Related to logging dependencies:
    - Don't include the logging based in log4j dependencies `santander-spring-boot-starter-logging-basic` or `santander-spring-boot-starter-logging-kafka`.
    - Exclude from `santander-spring-boot-starter-events` the `santander-spring-boot-starter-logging` dependency
  - In case infinispan cache is selected, then add `infinispan-core-graalvm` and `infinispan-client-hotrod-graalvm` dependencies.
  - Include `process-aot` and `process-test-aot` steps to build an application. Necessaries for GraalVM native image generation.
  - Include `native-maven-plugin` configured for GraalVM native image generation.
- Added `application-native.properties` with the properties necessary to execute in native mode.
- Added package `aot` with hints for GraalVM native image generation.

#### Property files in production scope

The archetype has generated a series of property files to configure what is necessary, according to the libraries that have been previously included.
These properties must be fulfilled in the `application.yml` file, which is the main configuration file in the application, independent of the environment chosen.

##### Application.yml file

Similar to pom.xml, the content of this file has a **fixed part** that will be configured in any application:

- The default active profile is *local*.

- The PaaS region is defined (default *boae*).

- The application name is set.

- Santander Spring Boot AppKey (with the value of *acronym-app*).

- Santander Spring Boot Logging Library properties.

- Setting Spring Session to "none".

- Default technical log levels.

- Disable configuration server health.

<!-- -->

    santander:
      region: boae
      suffix:
      app-key: santander
      logging:
        entity: ESP
        paas-app-version: "@project.version@"
        kafka:
          server: ${env.logging-server} (1)
        security:
          connectors:
            pkm-connector:
              pkm-endpoint:
                - ${env.pkm-endpoint}

    spring:
      application:
        name: testapp
      profiles:
        active: local
      session:
        store-type: none
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m

    logging.level: (2)
      com.santander.framework.springboot.testapp.Application: INFO
      root: WARN

    health:
      config:
        enabled: false

1. `santander.logging.kafka.server` is included by default but it will be removed if *-Dlogging-kafka=N* is used.

2. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

Below we show 4 examples of possible resulting files according to the values of some parameters.

!!! note

    Remember the relationship between the type of application and the dependencies included in the [correlation table](#correlation-table), as this affects the properties to be configured in each case.

- **Application with Authorization**

    In case you have selected the **Authorization library**, the archetype will add the Operational Control properties. For example, if we base it on the basic file, it would look like this:

        santander:
          region: boae
          suffix:
          app-key: santander
          logging:
            entity: ESP
            paas-app-version: "@project.version@"
            kafka:
              server: ${env.logging-server}
            security:
              connectors:
                pkm-connector:
                  pkm-endpoint:
                    - ${env.pkm-endpoint}
              authorization:
                remote:
                  coc: ${env.coc-endpoint}
                  con: ${env.con-endpoint}

        spring:
          application:
            name: testapp
          profiles:
            active: local
          session:
            store-type: none
          cache:
            type: caffeine
            caffeine:
              spec: expireAfterWrite=10m

        logging.level: (1)
          com.santander.framework.springboot.testapp.Application: INFO
          root: WARN

        health:
          config:
            enabled: false

    1. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

- **NotWeb Batch Application**

    If the application is a NotWeb Batch app, the application.yml will be generated with these extra options:

    - Base configuration for architecture databases, corresponding to Spring Batch and Spring Task datasources. This configuration allows (in a persistent database) to relaunch and manage jobs with SCDF.

    <!-- -->

        santander:
          batch:
            santander-info:
              locale: esES
              channel: sampleChannel
              entity: sampleEntity
              thirdParty: sampleThirdParty
              appInit: sampleAppInit
            logging-context:
              platform-log: samplePlatformLog
              user-agent: sampleUserAgent
          region: boae
          suffix:
          app-key: myapps
          logging:
            entity: ESP
            paas-app-version: "@project.version@"
            kafka:
              server: ${env.logging-server}
          security:
            connectors:
              pkm-connector:
                pkm-endpoint:
                  - ${env.pkm-endpoint}

        spring:
          application:
            name: testapp
          session:
            store-type: none
          cache:
            type: CAFFEINE #Activated cache caffeine by default (If you want to change the cache to JBoss DataGrid, check the documentacion in confluence)
            caffeine:
              spec: expireAfterWrite=10m #Specifies that each entry should be automatically removed from the cache once that duration has elapsed after the entry's creation
          batch:
            jdbc:
              initialize-schema: always
            datasource:
              jdbc-url: jdbc:h2:mem:mydb;DB_CLOSE_DELAY=-1;DATABASE_TO_UPPER=false
              username: sa
              password: sa
              driver-class: org.h2.Driver

        logging.level: (1)
          com.santander.framework.springboot.testapp.Application: INFO
          root: WARN

    1. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

- **Web application**

    If it is a Web application (Servlet or Reactive) a file will be generated that also includes:

    - Configuration of Spring Security filters.

    - Actuator endpoints configuration.

    - Springdoc configuration for Swagger endpoints.

    - Configuration for the server:

        - Management of **proxy variables**: Spring doc does not have the functionality to support the use of proxy variables as X-Forwarded-Prefix and delegates to Spring the conversion. To enable the use of proxy variables, the ***framework***
            strategy is defined.

        - ***Graceful*** shutdown mode. This mode is defined from the ***server.shutdown*** property, and with *spring.lifecycle.timeout-per-shutdown-phase* we set the **graceful\_time** to 2 minutes (if this property is not defined, a default
            value of 30 seconds will be applied).

    <!-- -->

        santander:
          region: boae
          suffix:
          app-key: santander
          logging:
            entity: ESP
            paas-app-version: "@project.version@"
            kafka:
              server: ${env.logging-server}
            security:
              connectors:
                pkm-connector:
                  pkm-endpoint:
                    - ${env.pkm-endpoint}

        spring:
          application:
            name: testapp
          profiles:
            active: local
          session:
            store-type: none
          cache:
            type: caffeine
            caffeine:
              spec: expireAfterWrite=10m
          lifecycle.timeout-per-shutdown-phase: 2m

        logging.level: (1)
          com.santander.framework.springboot.testapp.Application: INFO
          root: WARN

        management:
          endpoint.health:
            show-details: ALWAYS

        health:
          config:
            enabled: false

        springdoc:
          swagger-ui:
            disable-swagger-default-url: true
            path: /swagger-ui.html

        server:
          max-http-request-header-size: 128KB
          forward-headers-strategy: framework
          shutdown: graceful

    1. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

- **Application with Partenon Connector**

    If in any of the possible applications we select the dependency with the Partenon component, its configuration will be added to the generated file:

        santander:
          partenon:
            default:
              host: ${env.partenon-host}
              port: ${env.partenon-port}
              portForToken: ${env.partenon-token-port}

#### Property files in test scope

##### Application-local.properties file

The *application-local.properties* is an auxiliary file with properties associated with the local environment..
It is used to define the properties of the application in the local environment, such as the database connection, the server port, etc.

##### Application-test.properties file

This file will have at least the PKM and STS properties of the security library.
It also has an optional property called `santander.logging.console-log-format` that allows to change the technical console log format.
By default, is set to the value 'HUMAN_READABLE' to show the Console Technical Log Pattern, but it can be changed to 'JSON' to show the Technical Log Pattern instead.
Additionally, the file will also include the property to define the kafka server to connect with the logging library (for local environments we leave it empty), but we can
remove it using *-Dlogging-kafka=N*, and the property to disable Spring Cloud Config (if not disabled) in local environments:

    env.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
    env.sts-endpoint: https://srvnuarintra.santander.dev.corp/sts
    env.logging-server:

    spring.cloud.config.enabled: false

- If the **Authorisation Library** is used, in addition to the above, the following shall be added:

<!-- -->

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract

- If the **Partenon component** has been included, it will be added:

<!-- -->

    env.partenon-host: dbd1.isban.dev.corp
    env.partenon-port: 5100
    env.partenon-token-port: 5144
