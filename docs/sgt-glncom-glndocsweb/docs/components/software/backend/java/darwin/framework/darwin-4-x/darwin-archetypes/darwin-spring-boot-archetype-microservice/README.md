# Darwin Spring Boot Microservice Archetype ![4.3.3-RELEASE](https://img.shields.io/badge/4.3.3-RELEASE-FF073D)

![GA](https://img.shields.io/badge/GA-C81D11)

## Description

Darwin's Maven archetype for Spring Boot applications allows for the rapid creation of a 'skeleton' for Spring Boot applications (Web and NotWeb), incorporating the necessary dependencies for their use.

### Application types

The archetype is capable of handling up to three application types based on the runtime environments of a `Spring Boot` application which they define as
[WebApplicationType](https://docs.spring.io/spring-boot/docs/3.1.12/api/org/springframework/boot/WebApplicationType.html) (NONE, SERVLET and REACTIVE):

- ***NotWeb*** (NONE): The application does not run as a web application and therefore **should not** boot an `embedded web server` but includes the Spring HTTP Clients, `RestTemplate` and `WebClient`.

- ***Batch*** (NONE): The application does not run as a web application and therefore **should not** boot an `embedded web server` but includes the Spring HTTP Clients, `RestTemplate` and `WebClient`. It is intended for microservices running on
    Batch architecture. Makes available the use of the **Spring Batch** and **Spring Cloud Task** libraries.

- ***Web Servlet*** (SERVLET): The application runs as a `Servlet` based web application and therefore should start an `embedded web server`, by default `Tomcat`.

- ***Web Reactive*** (REACTIVE): The application runs as a `WebFlux` based reactive web application and therefore should start an `embedded web server`, by default `Netty`.

### Dependency management

During the execution of the archetype and according to the needs reflected by the user, the archetype is able to manage the Maven dependencies for the following libraries:

- [Spring Cloud Config Client](https://docs.spring.io/spring-cloud-config/docs/4.0.5/reference/html/#_spring_cloud_config_client)

- [Spring Web MVC](https://docs.spring.io/spring-framework/docs/6.0.21/reference/html/web.html#spring-web) y [Spring WebFlux](https://docs.spring.io/spring-framework/docs/6.0.21/reference/html/web-reactive.html#spring-webflux)

- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/3.1.12/reference/html/actuator.html#actuator)

- Spring HTTP Clients: [RestTemplate y WebClient](https://confluence.alm.europe.cloudcenter.corp)

- [Spring Cloud Task](https://docs.spring.io/spring-cloud-task/docs/current/reference/html/#_spring_cloud_task)

- [Spring Batch](https://docs.spring.io/spring-batch/docs/current/reference/html/#_spring_batch)

- [Springdoc-OpenAPI (Swagger)](https://springdoc.org/)

- Framework Darwin Spring Boot:

    - [Darwin Core](../../darwin-project/darwin-spring-boot-core/README.md)

    - [Darwin Cache](../../darwin-project/darwin-spring-boot-cache/README.md)

    - [Darwin Logging](../../darwin-project/darwin-spring-boot-logging/README.md)

    - [Darwin Authentication](../../darwin-project/darwin-spring-boot-security-authentication/README.md)

    - [Darwin Authorization](../../darwin-project/darwin-spring-boot-security-authorization/README.md)

    - [Darwin WebService](../../darwin-project/darwin-spring-boot-webservice/README.md)

    - [Darwin Partenon](../../darwin-project/darwin-spring-boot-partenon/README.md)

    - [Darwin Events](../../darwin-project/darwin-spring-boot-events/README.md)

    - [Darwin Batch](../../darwin-project/darwin-spring-boot-batch/README.md)

    - [Darwin GraphQL](../../darwin-project/darwin-spring-boot-graphql/README.md)

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
| **Darwin Core**                    | Yes    | Yes     | Yes      |
| **Darwin Cache** (2)               | Yes    | Yes     | Yes      |
| **Darwin Omnichannel**             | No     | No      | No       |
| **Darwin Logging**                 | Yes    | Yes     | Yes      |
| **Darwin Authentication**          | Yes    | Yes     | Yes      |
| **Darwin Authorization**           | No     | No      | No       |
| **Darwin WebService**              | No     | No      | No       |
| **Darwin Metrics**                 | No     | No      | No       |
| **Darwin Partenon**                | No     | No      | No       |
| **Darwin Events**                  | No     | No      | No       |
| **Darwin GraphQL**                 | No     | No      | No       |
| **Darwin Railroad Switch**         | No     | No      | No       |

1. This dependency can be disabled using the corresponding archetype parameter, `config-client`.

2. `Caffeine` cache as default.

!!! info "Important"

    Since version 3.2 of the archetype the omnichannel library is not included by default, consider adding it if you need it.

### Java support

When generating a project, the archetype use java 17 by default.

!!! info "Important"

    Darwin 4.x.y versions are only supported with java 17. Darwin 3.x.y versions are supported for use with java 11 and java 17. Darwin 2.X versions are only supported with java 11.

## Darwin Spring Boot Starter Parent

The Darwin archetype uses this starter as the basis for the projects it generates. It is intended to be the main POM for all Santander applications, providing dependencies and plugin management. This POM can also be used in libraries as dependency
management.

The idea is that developers should not worry about which library version they are going to use, as well as providing the list of all available dependencies. It also includes some fixed dependencies and plugins that must be used in all applications,
such as lombok, spring boot starters, jacoco plugin, etc.

!!! note

    More information can be found at the following link: [Darwin Spring Boot Starters](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/darwin-project/darwin-spring-boot-starters/).

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

!!! tip "Caution"

    As of version **2.7.0-RELEASE** of the archetype, the only valid execution mode is in *Batch* mode.

        mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion={darwin-version} -Dcomponent-name={component} -Dacronym-app={acronym} -DwebAppType={webAppType} [-Dauthorization-library -Domnichannel-library -Dwebservice-library -Dmetrics-component -Dpartenon-component -Devents-component -Dconfig-client -Drailroad-switch-library -Dgraphql -Dlogging-kafka -Dcache-type={cacheType} -Dsystem={system} -Dsub-system-code={subsystem} -Dfunctional-application-code={application} -Dfunctional-sub-application-code={subapplication}]

!!! info "Important"

    The parameters in square brackets **are not mandatory**, the function and mandatory nature of each one is detailed below.

!!! tip "Caution"

    If you include Authorization library (*-Dauthorization-library*) to be used with SPAIN authorization service (used by default) you must include the Omnichannel library (*-Domnichannel-library*)

!!! info "Important"

    For batch applications in local environment darwin security is disabled by default. To enable it change "env.security-enabled" in application-local.properties to true.

### Archetype parameters

| Name                                  | Description                                                                                                                                                                                                                                                      | Value                                                                                                                                                  | Required                            |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| ***-B***                              | Indicates that the archetype is running in *Batch* mode.                                                                                                                                                                                                         |                                                                                                                                                        | True                                |
| ***archetypeGroupId***                | Group to which the archetype you want to use belongs.                                                                                                                                                                                                            | `com.santander.darwin`                                                                                                                                 | True                                |
| ***archetypeArtifactId***             | Id of the archetype you want to use, its value is `darwin-spring-boot-archetype-library`.                                                                                                                                                                        |                                                                                                                                                        | True                                |
| ***archetypeVersion***                | Version of the archetype. It is important to run the latest version of the archetype (goes hand in hand with the latest version of the version of the framework).                                                                                                | You can check the latest version available at the following link: [Changelog](../../CHANGELOG.md). In this example the version is {darwin-version}. | True                                |
| ***component-name***                  | Component/application name (this will be the name of the Maven artefact).                                                                                                                                                                                        | For ***non-Gluon applications***: ***\[a-z\]\[a-z0-9-\]{1,32}***. (**maximum length of 33 characters**).                                               | True                                |
| ***acronym-app***                     | For ***non-Gluon applications***, the Application Key (value in ATLAS if configured) corresponds to the AppKey property of the Darwin framework. For ***Gluon applications***, The Application name corresponds to the AppName property of the Darwin framework. | For ***non-Gluon applications***, the value must comply with this pattern: ***\[a-z0-9\]+***                                                           | True                                |
| ***system***                          | Value received from ATLAS with the name of the system the application belongs to. This parameter corresponds to the logging property: system.                                                                                                                    |                                                                                                                                                        | Only if it has ATLAS classification |
| ***sub-system***                      | Value received from ATLAS with the name of the subsystem to which the application belongs. This parameter corresponds to the logging property: subsystem.                                                                                                        |                                                                                                                                                        | Only if it has ATLAS classification |
| ***functional-application-code***     | Value received from ATLAS with the name of the application to which it belongs. This parameter corresponds to the logging property: application.                                                                                                                 |                                                                                                                                                        | Only if it has ATLAS classification |
| ***functional-sub-application-code*** | Value received from ATLAS with the name of the sub-application to which the application belongs. This parameter corresponds to the logging property: subapplication.                                                                                             |                                                                                                                                                        | Only if it has ATLAS classification |
| ***groupId***                         | The `groupId` displayed in the project pom will be generated from the `acronym-app`.                                                                                                                                                                             | e.g. com.santander.{acronym-app}                                                                                                                       | True                                |
| ***artifactId***                      | The `artifactId` displayed in the project pom will have the same value as the `component-name` parameter.                                                                                                                                                        |                                                                                                                                                        | True                                |
| ***version***                         | The default version for a new project.                                                                                                                                                                                                                           | **1.0.0-SNAPSHOT**                                                                                                                                     | True                                |
| ***package***                         | The `package` of the Java project is generated from the values of the `groupId` and `artifactId`.                                                                                                                                                                | {groupId}.{artifactId.replaceAll("-", "").replaceAll("\_", "")}                                                                                        | True                                |
| ***description***                     | The default project description has the following text.                                                                                                                                                                                                          | \${acronym-app} darwin spring boot microservice: \${component-name}                                                                                    | True                                |
| ***config-client***                   | Indicates whether you want to include the configuration service client dependency.                                                                                                                                                                               | {Y,N,true,false} - By default: ***Y***                                                                                                                 | False                               |
| ***cache-type***                      | Sets the type of cache to be incorporated into the application.                                                                                                                                                                                                  | -Dcache-type= **caffeine**, **infinispan** and **dual**. By default, the value will be **dual**.                                                       | False                               |
| ***authorization-library***           | Indicates that you want to use the application authorisation library.                                                                                                                                                                                            | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***metrics-component***               | Indicates that you want to incorporate the metrics component into the application.                                                                                                                                                                               | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***webservice-component***            | Indicates that you want to incorporate the webservice component into the application.                                                                                                                                                                            | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***partenon-component***              | Indicates that you want to incorporate the component with the partenon connector into the application.                                                                                                                                                           | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***events-component***                | Indicates that the event component is to be incorporated into the application.                                                                                                                                                                                   | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***railroad-switch-library***         | Indicates that you want to incorporate the RDS library into the application.                                                                                                                                                                                     | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***graphql***                         | Indicates that the app use GraphQL. This param add dependencies and example code.                                                                                                                                                                                | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***logging-kafka***                   | Indicates that the app load kafka appenders for logging.                                                                                                                                                                                                         | {Y,N,true,false} Default: Y                                                                                                                            | False                               |
| ***api-first***                       | Indicates that the app will be generated as an API First app. Only available for servlet and reactive apps.                                                                                                                                                      | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***api-spec-url***                    | The Location of the OpenAPI schema to be used when is an API First app (typically an URL)                                                                                                                                                                        | Default: {project.basedir}/src/main/resources/config/openapi.yaml                                                                                      | False                               |
| ***logging-entity***                  | To identify the application's country in the monitoring systems (by default, the value will be ESP).                                                                                                                                                             | -logging-entity=ESP                                                                                                                                    | False                               |
| ***gluon***                           | Indicates that the app will comply with GLUON properties and requirements                                                                                                                                                                                        | {Y,N,true,false} Default: N                                                                                                                            | False                               |
| ***gluonlog-company***                | The company code in Gluon. Previously, this attribute was named as "entity".                                                                                                                                                                                     |                                                                                                                                                        | False                               |
| ***gluonlog-component-name***         | The component short name in Gluon.                                                                                                                                                                                                                               |                                                                                                                                                        | False                               |
| ***gluonlog-component-id***           | The component identifier in Gluon.                                                                                                                                                                                                                               |                                                                                                                                                        | False                               |
| ***gluonlog-component-type***         | The type of component in Gluon.                                                                                                                                                                                                                                  |                                                                                                                                                        | False                               |
| ***gluonlog-app-id***                 | The technical application identifier in Gluon.                                                                                                                                                                                                                   |                                                                                                                                                        | False                               |
| ***webAppType***                      | Type of application to be generated in relation to the values of the property [WebApplicationType](https://docs.spring.io/spring-boot/docs/2.0.x/api/org/springframework/boot/WebApplicationType.html) property of Spring Boot.                                             | -DwebAppType= **notweb** (*NONE*), **batch** (*NONE*), **servlet** (*SERVLET*) o **reactive** (*REACTIVE*). By default, the value will be **servlet**. | False                               |

There are some parameters that **should not be changed** to ensure the correct execution of the archetype, these are:

- ***-B***: indicates that the archetype will be executed in *Batch* mode.

- ***archetypeGroupId***: Group to which the archetype to be used belongs, its value is `com.santander.darwin`.

- ***archetypeArtifactId***: Id of the archetype to be used, its value is `darwin-spring-boot-archetype-microservice`.

- ***archetypeVersion***: Version of the archetype, it is important to run the latest version of the archetype (it goes hand in hand with the latest version of the framework). You can check the latest version available at the following link:
    [Changelog](../../CHANGELOG.md). In this example the version is {darwin-version}.

#### Mandatory parameters

Next to the fixed parameters, there are some **mandatory parameters that will customize the generated project**, these are:

- ***component\_name***: Name of the component (it will be the name of the Maven artifact).

!!! warning

    For ***non-Gluon applications*** the value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9-\]{1,32}***. It must start with a lowercase letter and continue with lowercase letters, numbers and hyphens, having a **maximum length of 33 characters**.

- ***acronym-app***: This parameter represents the key or name for any kind of Application generated through the Darwin archetype.

!!! info "Important"

    - For ***non-Gluon applications***, ***acronym-app*** corresponds to the AppKey property (***darwin.app-key***).
    
    - For ***Gluon applications***, ***acronym-app*** corresponds to the AppName property (***darwin.app-name***).

!!! warning

    For ***non-Gluon applications***, the value we give to ***acronym-app*** must comply with the following regular expression: ***\[a-z0-9\]+***. It must contain one or more characters (lowercase letter or number).

- ***webAppType***: Application type of the [mentioned above](#application-types) that we want to generate in relation to the values of the Spring Boot
      [WebApplicationType](https://docs.spring.io/spring-boot/docs/3.1.12/api/org/springframework/boot/WebApplicationType.html) property. of Spring Boot.
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

    If it is defined as input, the value of the *_package_* parameter cannot be equal to 'com.santander.darwin'.

- ***description***: The default project description shall have the following text:

<!-- -->

    ${acronym-app} darwin spring boot microservice: ${component-name}

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

!!! tip "Caution"

    From **Darwin 3.2.0-RELEASE** the Spring Cloud Config client configuration is delegated to the application deployment method (via Darwin JavaSE Chart or Darwin JavaSE Template).

As for the **framework libraries and others external to the framework**, by default **none of the following libraries are included**, to include them, we simply **add the parameter** to the maven command (-D*parameter-name*) or **assign the value
Y** (-D*parameter-name*=Y). These are:

- ***cache-type***: Sets the type of cache to be incorporated into the application. Possible values: `caffeine`, `infinispan` and `dual`. By default, the value will be `caffeine`.

- ***authorization-library***: Indicates that you want to use the authorization library to the application.

- ***omnichannel-library***: Indicates that you want to use the omnichannel library to the application.

- ***metrics-component***: Indicates that you want to incorporate the metrics component to the application.

- ***webservice-component***: Indicates that you want to incorporate the webservice component into the application.

- ***partenon-component***: Indicates that you want to incorporate the component with the partenon connector into the application.

- ***events-component***: Indicates that you want to incorporate the events component into the application.

- ***railroad-switch-library***: Indicates that you want to incorporate the RDS library into the application.

- ***graphql***: Indicates that the app use GraphQL. This param add dependencies and example code.

- ***logging-kafka***: Indicates that the app load kafka appenders for logging.

- ***logging-entity***: To identify the application's country in the monitoring systems (by default, the value will be ESP).

- ***api-first***: Indicates that the app will be generated as an API First. This param adds the necessary generator and a sample OpenApi Specification file. Only available for servlet and reactive apps.

- ***api-spec-url***: Indicates the current Location of the OpenAPI schema for be used as a param to the microservice archetype in the context of API First app (typically an URL). Only available for servlet and reactive app.

- ***gluon***: Indicates that the application will use Gluon error format. (by default, the value will be 'N')

!!! note

    Remember that the Darwin Logging, Authentication and Cache libraries, the Spring Http clients and the Spring Cloud Config Client module are **always** included in the generated applications.

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

    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=servlet
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
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application1
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application1
    [INFO] Parameter: package, Value: com.santander.myapps.application1
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot microservice: application-1
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application-1
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: railroad-switch-library, Value: N
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: webAppType, Value: servlet
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: graphql, Value: N
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: ...\workspace\application-1
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  32.968 s
    [INFO] Finished at: 2020-06-09T10:57:40+02:00
    [INFO] ------------------------------------------------------------------------

#### Gluon application

This case corresponds to the generation of a ***Gluon*** application with the mandatory parameters and dependencies, and in which we only have to choose the type of application, which will be: NotWeb, Servlet or Reactive. For example, for a Reactive
application:

!!! note

    For creating a Gluon application, additionally, it is mandatory to provide the following parameters:

    - ***gluon***

    - ***gluonlog-company***

    - ***gluonlog-component-name***

    - ***gluonlog-component-id***

    - ***gluonlog-component-type***

    - ***gluonlog-app-id***

    Remember that the ***acronym-app*** parameter corresponds to AppName property.

Example of Gluon application:

      mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=applicationgluon -Dacronym-app=gluonapp -DwebAppType=reactive -Dgluon=Y -Dgluonlog-company=ESP -Dgluonlog-component-name=gluon-component -Dgluonlog-component-id=gluon-id -Dgluonlog-component-type=gluon-type -Dgluonlog-app-id=gluon-app-id
      [INFO] Scanning for projects...
      [INFO]
      [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
      [INFO] Building Maven Stub Project (No POM) 1
      [INFO] --------------------------------[ pom ]---------------------------------
      [INFO]
      [INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-po>>>
      [INFO]
      [INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
      [INFO]
      [INFO]
      [INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
      [INFO] Generating project in Batch mode
      (...)
      [INFO] ----------------------------------------------------------------------------
      [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:3.2.7-RELEASE
      [INFO] ----------------------------------------------------------------------------
      [INFO] Parameter: groupId, Value: com.santander.gluon-app
      [INFO] Parameter: artifactId, Value: application-gluon
      [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
      [INFO] Parameter: package, Value: com.santander.gluon-app.applicationgluon
      [INFO] Parameter: packageInPathFormat, Value: com/santander/gluon-app/applicationgluon
      [INFO] Parameter: config-client, Value: Y
      [INFO] Parameter: metrics-component, Value: N
      [INFO] Parameter: groupId, Value: com.santander.gluon-app
      [INFO] Parameter: gluonlog-component-type, Value: gluon-type
      [INFO] Parameter: description, Value: gluon-app darwin spring boot microservice: application-gluon
      [INFO] Parameter: partenon-component, Value: N
      [INFO] Parameter: gluon, Value: Y
      [INFO] Parameter: logging-kafka, Value: Y
      [INFO] Parameter: railroad-switch-library, Value: N
      [INFO] Parameter: artifactId, Value: application-gluon
      [INFO] Parameter: gluonlog-component-name, Value: gluon-component
      [INFO] Parameter: graphql, Value: N
      [INFO] Parameter: gluonlog-app-id, Value: gluon-app-id
      [INFO] Parameter: cache-type, Value: dual
      [INFO] Parameter: gluonlog-company, Value: ESP
      [INFO] Parameter: package, Value: com.santander.gluon-app.applicationgluon
      [INFO] Parameter: java17, Value: N
      [INFO] Parameter: webservice-component, Value: N
      [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
      [INFO] Parameter: omnichannel-library, Value: N
      [INFO] Parameter: functional-application-code, Value: UNDEFINED
      [INFO] Parameter: component-name, Value: application-gluon
      [INFO] Parameter: system, Value: UNDEFINED
      [INFO] Parameter: functional-sub-application-code, Value: UNDEFINED
      [INFO] Parameter: authorization-library, Value: N
      [INFO] Parameter: sub-system-code, Value: UNDEFINED
      [INFO] Parameter: events-component, Value: N
      [INFO] Parameter: webAppType, Value: reactive
      [INFO] Parameter: gluonlog-component-id, Value: gluon-id
      [INFO] Parameter: acronym-app, Value: gluon-app
      [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
      [INFO] Project created from Archetype in dir: ...\workspace\application-gluon
      [INFO] ------------------------------------------------------------------------
      [INFO] BUILD SUCCESS
      [INFO] ------------------------------------------------------------------------
      [INFO] Total time:  32.968 s
      [INFO] Finished at: 2020-06-09T10:57:40+02:00
      [INFO] ------------------------------------------------------------------------

#### Application with added libraries

If we want to add any of the optional libraries, we only need to add its associated parameter to our command, for example, to add the Authorization library and the WebService component:

    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=application-1 -Dacronym-app=myapplication2 -DwebAppType=reactive -Dauthorization-library -Domnichannel-library -Dwebservice-component=Y
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
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapplication2
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapplication2.application1
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapplication2/application1
    [INFO] Parameter: package, Value: com.santander.myapplication2.application1
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapplication2
    [INFO] Parameter: description, Value: myapplication2 darwin spring boot microservice: application-1
    [INFO] Parameter: webservice-component, Value: Y
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application-1
    [INFO] Parameter: omnichannel-library, Value: Y
    [INFO] Parameter: authorization-library, Value: true
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: railroad-switch-library, Value: N
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: webAppType, Value: reactive
    [INFO] Parameter: acronym-app, Value: myapplication2
    [INFO] Parameter: graphql, Value: N
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: ...\workspace\application-1
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  16.978 s
    [INFO] Finished at: 2020-06-09T11:03:41+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with graphQL

If we want to create the application with graphQL API, we only need to add graphql parameter to our command, for example:

    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=application-1 -Dacronym-app=myapps -DwebAppType=reactive -Dgraphql
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.2.1:generate (default-cli) > generate-sources @ standalone-pom >>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.2.1:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.2.1:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    [INFO] Archetype repository not defined. Using the one from [com.santander.darwin:darwin-spring-boot-archetype-microservice:4.0.0-RELEASE] found in catalog remote
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application1
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application1
    [INFO] Parameter: package, Value: com.santander.myapps.application1
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot microservice: application-1
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application-1
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: railroad-switch-library, Value: N
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: webAppType, Value: reactive
    [INFO] Parameter: graphql, Value: true
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: logging-kafka, Value: Y
    [WARNING] Property 'gitignore' was not specified, so the token in '//__gitignore' is not being replaced.
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: c:\test-projects\test-graphql\application-1
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  29.011 s
    [INFO] Finished at: 2022-04-28T12:10:44+02:00
    [INFO] ----------------------------------------------------------------------------

#### Application with API First

If we want to create an application with an API First approach, we only need to add the api-first parameter to our command, for example:

    - --
    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=application-2 -Dacronym-app=myapps -DwebAppType=reactive -Dapi-first
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> archetype:3.2.1:generate (default-cli) > generate-sources @ standalone-pom >>>
    [INFO]
    [INFO] <<< archetype:3.2.1:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- archetype:3.2.1:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.3.3-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application-2
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application2
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application2
    [INFO] Parameter: api-first, Value: true
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot microservice: application-2
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Parameter: railroad-switch-library, Value: N
    [INFO] Parameter: artifactId, Value: application-2
    [INFO] Parameter: graphql, Value: N
    [INFO] Parameter: cache-type, Value: dual
    [INFO] Parameter: package, Value: com.santander.myapps.application2
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: functional-application-code, Value: UNDEFINED
    [INFO] Parameter: component-name, Value: application-2
    [INFO] Parameter: system, Value: UNDEFINED
    [INFO] Parameter: functional-sub-application-code, Value: UNDEFINED
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: sub-system-code, Value: UNDEFINED
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: webAppType, Value: reactive
    [INFO] Parameter: acronym-app, Value: myapps
    [WARNING] Don't override file C:\Users\x650308\Documents\tmp\application-2\src\main\java\com\santander\myapps\application2
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: C:\Users\x650308\Documents\tmp\application-2
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  15.699 s
    [INFO] Finished at: 2023-07-13T12:03:56+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with API First and remote OpenAPI Schema

If we want to create an application with an API First approach, and at the same time indicate the URL which contains the OpenAPI definition file
(for example "https://catalog-api/domain/resources/openapi.yaml"), we have to include both parameter of API First params as follows:

    - --
    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=application-2 -Dacronym-app=myapps -DwebAppType=reactive -Dapi-first -Dapi-spec-url='https://catalog-api/domain/resources/openapi.yaml'
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> archetype:3.2.1:generate (default-cli) > generate-sources @ standalone-pom >>>
    [INFO]
    [INFO] <<< archetype:3.2.1:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- archetype:3.2.1:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.3.3-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application-2
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application2
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application2
    [INFO] Parameter: api-first, Value: true
    [INFO] Parameter: api-spec-url, Value:https://catalog-api/domain/resources/openapi.yaml
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot microservice: application-2
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Parameter: railroad-switch-library, Value: N
    [INFO] Parameter: artifactId, Value: application-2
    [INFO] Parameter: graphql, Value: N
    [INFO] Parameter: cache-type, Value: dual
    [INFO] Parameter: package, Value: com.santander.myapps.application2
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: functional-application-code, Value: UNDEFINED
    [INFO] Parameter: component-name, Value: application-2
    [INFO] Parameter: system, Value: UNDEFINED
    [INFO] Parameter: functional-sub-application-code, Value: UNDEFINED
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: sub-system-code, Value: UNDEFINED
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: webAppType, Value: reactive
    [INFO] Parameter: acronym-app, Value: myapps
    [WARNING] Don't override file C:\Users\x650308\Documents\tmp\application-2\src\main\java\com\santander\myapps\application2
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: C:\Users\x650308\Documents\tmp\application-2
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  15.699 s
    [INFO] Finished at: 2023-07-13T12:03:56+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with invalid parameters

As we have seen before, some parameters have a validation of their content, in case of not complying with it, an error message will be displayed and the generated project will be deleted.

For example, the parameter ***component-name*** must comply with the following validation: "*begin with a lowercase letter and continue with lowercase letters, numbers or hyphens, with a maximum of 33 characters*" If we use the value "Application-1"
the following will happen:

    mvn -B archetype:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-microservice -DarchetypeVersion=4.3.3-RELEASE -Dcomponent-name=Application-1 -Dacronym-app=myapps -DwebAppType=notweb
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
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-microservice:4.0.0-RELEASE
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
    [INFO] Parameter: description, Value: myapps darwin spring boot microservice: Application-1
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: Application-1
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: railroad-switch-library, Value: N
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

!!! note

    For each parameter with validation, a separate message will be displayed with its valid format.

## Resulting project

The structure and content of the resulting project files will depend on the value given to some parameters.

### Project structure

The structure of the project will depend on the use (or not) of API GraphQL and the type of application chosen: NotWeb or Web (Servlet or Reactive).

#### Basic structure (NotWeb application)

For `NotWeb` applications and as a **basis for the other application types**, the generated project will have the following structure:

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── darwin
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
                        └── darwin
                            └── testapp
                                └── ApplicationTest.java

- Highlight the [**pom.xml**](#pom) file, which contains all the information that Maven uses to manage dependencies, metadata, etc.

In the main folder we find:

- The java folder with the source code of our project: Only the **Application.java** class will be included to start the application using the appropriate `WebApplicationType`. For this case, a `NotWeb` application, this class will also implement
    a `CommandLineRunner` with an example *run* method.

- In the *resources* folder we will have:

    - The *config* subfolder where an **application.yml** file will be generated along with an **application-local.properties** with the
     [properties files](#property-files) necessary to configure the libraries that have been chosen during the creation of the project.

In the *test* folder we will have an **ApplicationTest.java** file that we use to test that the application is correctly built.

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
        │   │           └── darwin
        │   │               └── testapp
        │   │                      ├── Application.java
        │   │                      ├── config
        │   │                      │     └── ApplicationAutoConfig.java
        │   │                      ├── job
        │   │                      │     └── CustomerJob.java
        │   │                      ├── model
        │   │                      │     └── Customer.java
        │   │                      └── step
        │   │                          ├── chunk
        │   │                          │     ├── CustomerItemProcessor.java
        │   │                          │     ├── CustomerItemReader.java
        │   │                          │     └── CustomerItemWriter.java
        │   │                          └── tasklet
        │   │                                └── CustomerTasklet.java
        │   └── resource
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
                        └── darwin
                            └── testapp
                                └── ApplicationTests.java

In the main folder we find:

- The main java folder with the source code of the project:

    - Config folder, that will allow us to store the batch microservice configuration.

    - Job folder, which contains the job's definition, as well as the job's listeners.

    - Step folder, which contains the steps' definitions, as well as their listeners, chunks and tasklets processors.

    - Model folder, which contains the data objects class.

- In the *resources* folder we find:

    - The subfolder *config* where an **application.yml** file will be generated, together with a **application-local.properties**
     file with the [properties files](#property-files) necessary to configure the libraries that have been chosen during the creation of the project.

    - We can also find a sample csv file with some data entries.

In the *test* folder we will have an **ApplicationTests.java** file that we use to test that the application is correctly built

#### Web Application Structure

In the case of a microservice (`Servlet` or `Reactive`) the following will also be generated in the **main** of the project:

- A `config` folder with a **SwaggerConfig.java** class that implements a configuration for using Swagger in a microservice.

- A `web` folder with a **HelloController.java** class that implements a controller (`Servlet` or `Reactive`) that returns \`Hello World!' when an HTTP GET request is made to the */${artifactId}/hello* endpoint.

In addition, in the **resources** folder, an errors.properties file is added for the [configuration of exceptions](../../darwin-project/darwin-spring-boot-core/README.md#exception-handling) and a subfolder errors with a Resource Bundle of
configurations, for multi-language exceptions (in this case: Spanish (es\_ES) and US English (en\_US)).

The corresponding tests for these classes will also be added: **SwaggerConfigTest.java** and **HelloControllerTest.java**.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── darwin
        │   │               └── testapp
        │   │                   ├── Application.java
        │   │                   ├── config
        │   │                   |   └── SwaggerConfig.java
        │   │                   └── web
        │   │                       └── HelloController.java
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       └── errors
        │           └── Resource Bundle 'errors
        |               ├── errors_en.properties
        │               └── errors_es.properties
        └── test
            └── java
                └── com
                    └── santander
                        └── darwin
                            └── testapp
                                ├── ApplicationTest.java
                                ├── config
                                |   └── SwaggerConfigTest.java
                                └── web
                                    └── HelloControllerTest.java

#### Web Application with GraphQL Structure

In the case of a microservice (`Servlet` or `Reactive`) with GraphQL the following will also be generated in the **main** of the project:

- A `graphql` folder in *resources* with a **schema.graphqls** file, which contain queries and mutations of graphql.

- A `web` folder with a **PersonController.java** class that implements a queries/mutations of **schema.graphqls** file.

- A `domain` folder with a **Person.java** class. This is a model data to graphql example.

In addition, in the **resources** folder, an errors.properties file is added for the [configuration of exceptions](../../darwin-project/darwin-spring-boot-core/README.md#exception-handling) and a subfolder errors with a Resource Bundle of
configurations, for multi-language exceptions (in this case: Spanish (es) and English (en)).

The corresponding tests for these classes will also be added: **Person.java** and **PersonController.java**.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── darwin
        │   │               └── testapp
        │   │                   ├── Application.java
        │   │                   ├── domain
        │   │                   │   └── Person.java
        │   │                   └── web
        │   │                       └── PersonController.java
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       ├── errors
        │       │   └── Resource Bundle 'errors
        |       │       ├── errors_en.properties
        │       │       └── errors_es.properties
        │       └── graphql
        │           └── schema.graphqls
        └── test
            └── java
                └── com
                    └── santander
                        └── darwin
                            └── testapp
                                ├── ApplicationTest.java
                                ├── domain
                                │   └── PersonTest.java
                                └── web
                                    └── PersonControllerTest.java

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
        │   │           └── darwin
        │   │               └── testapp
        │   │                   ├── Application.java
        │   │                   ├── domain
        │   │                   │   └── Person.java
        │   │                   └── web
        │   │                       └── PersonController.java
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       ├── errors
        │       │   └── Resource Bundle 'errors
        |       │       ├── errors_en.properties
        │       │       └── errors_es.properties
        │       └── avro
        |           └── user.avsc
        └── test
            └── java
                └── com
                    └── santander
                        └── darwin
                            └── testapp
                                ├── ApplicationTest.java
                                ├── domain
                                │   └── PersonTest.java
                                └── web
                                    └── PersonControllerTest.java

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

      <groupId>com.santander.darwin</groupId>
        <artifactId>testapp</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>

        <name>testapp</name>
        <description>myapps darwin spring boot microservice: testapp</description>

The Darwin Spring Boot framework defines the POM parent [mentioned previously](#darwin-spring-boot-starter-parent) to manage library versions so that there are no conflicts between them:

        <parent>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-parent</artifactId>
            <version>{darwin-version}</version>
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
            <!-- Santander Darwin libraries -->
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-kafka</artifactId> (2)
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

2. Unless otherwise specified, the Darwin Starter Logging Kafka is included in every application. You can disable it with *-Dlogging-kafka=N*.

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
            <!-- Santander Darwin libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- Authorization dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authorization</artifactId>
            </dependency>
            <!-- Webservice dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-webservice</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->

            <!-- Test Dependencies -->
            (...)
    </dependencies>
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

!!! note

    This would also be the case when adding a library to a Servlet or Reactive application, so these examples will be ignored.

##### Example: Application without Darwin Logging Kafka

If the same application from last example didn't include the Darwin Logging Kafka Starter (*-Dlogging-kafka=N*) the archetype will modify the Darwin Logging Starter dependency:

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
            <!-- Santander Darwin libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-basic</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->
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
            <!-- Santander Darwin libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->

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
            <!-- Santander Darwin libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->

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
            <!-- Santander Darwin libraries -->
            <!-- Core dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-core</artifactId>
            </dependency>
            <!-- Logging dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging-kafka</artifactId>
            </dependency>
            <!-- Cache dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-cache</artifactId>
            </dependency>
            <!-- Authentication dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>
            <!-- Graphql dependency -->
            <dependency>
                <groupId>com.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-graphql</artifactId>
            </dependency>
            <!-- End Santander Darwin libraries -->

            <!-- Test Dependencies -->
            (...)
        </dependencies>
    (...)

#### Property files

The archetype has generated a series of property files to configure what is necessary according to the libraries that have been previously included:

- *application.yml*: main application configuration file independent of the environment.

- *application-local.properties*: auxiliary file with properties associated with the environment (in this case for a local environment).

We recommend reading [Darwin application configuration guide](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16524089097/Darwin+Applications+Configuration) for more details on the configuration of the applications and on these files.

##### Application.yml file

Similar to pom.xml, the content of this file has a **fixed part** that will be configured in any application:

- The default active profile is *local*.

- The PaaS region is defined (default *boae*).

- The application name is set.

- Darwin AppKey (with the value of *acronym-app*).

- Darwin Logging Library properties.

- Setting Spring Session to "none".

- Default technical log levels.

- Disable configuration server health.

<!-- -->

    darwin:
      region: boae
      suffix:
      app-key: darwin
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
      com.santander.darwin.testapp.Application: INFO
      root: WARN

    health:
      config:
        enabled: false

1. `darwin.logging.kafka.server` is included by default but it will be removed if *-Dlogging-kafka=N* is used.

2. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

Below we show 4 examples of possible resulting files according to the values of some parameters.

!!! note

    Remember the relationship between the type of application and the dependencies included in the [correlation table](#correlation-table), as this affects the properties to be configured in each case.

- **Application with Authorization**

    In case you have selected the **Authorization library**, the archetype will add the Operational Control properties. For example, if we base it on the basic file, it would look like this:

        darwin:
          region: boae
          suffix:
          app-key: darwin
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
          com.santander.darwin.testapp.Application: INFO
          root: WARN

        health:
          config:
            enabled: false

    1. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

- **NotWeb Batch Application**

    If the application is a NotWeb Batch app, the application.yml will be generated with these extra options:

    - Base configuration for architecture databases, corresponding to Spring Batch and Spring Task datasources. This configuration allows (in a persistent database) to relaunch and manage jobs with SCDF.

    <!-- -->

        darwin:
          batch:
            darwin-info:
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
          com.santander.darwin.testapp.Application: INFO
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

        darwin:
          region: boae
          suffix:
          app-key: darwin
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
          com.santander.darwin.testapp.Application: INFO
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
          forward-headers-strategy: framework
          shutdown: graceful

    1. To reduce the number of traces generated, the trace level of the Application class is set to INFO, and WARN is set as the default trace level.

- **Application with Partenon Connector**

    If in any of the possible applications we select the dependency with the Partenon component, its configuration will be added to the generated file:

        darwin:
          partenon:
            default:
              host: ${env.partenon-host}
              port: ${env.partenon-port}
              portForToken: ${env.partenon-token-port}

##### Application-local.properties file

This file will have at least the PKM and STS properties of the security library. By default, it will also include the property to define the kafka server to connect with the logging library (for local environments we leave it empty), but we can
remove it using *-Dlogging-kafka=N*, and the property to disable Spring Cloud Config (if not disabled) in local environments:

    env.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
    env.sts-endpoint: https://srvnuarintra.santander.dev.corp/sts
    env.logging-server:

    spring.cloud.config.enabled: false

- If the **Authorisation Library** is used, in addition to the above, the following shall be added:

<!-- -->

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract

- If the **Parthenon component** has been included, it will be added:

<!-- -->

    env.partenon-host: dbd1.isban.dev.corp
    env.partenon-port: 5100
    env.partenon-token-port: 5144
