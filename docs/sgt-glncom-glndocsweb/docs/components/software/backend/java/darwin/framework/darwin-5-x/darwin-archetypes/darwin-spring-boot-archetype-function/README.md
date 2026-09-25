# Darwin Spring Boot Function Archetype ![5.8.2](https://img.shields.io/badge/5.8.2-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The Maven archetype for function applications with Darwin Spring Boot enables the rapid creation of a 'skeleton' for
Spring Boot Serverless applications, incorporating the necessary dependencies for their use.

!!! info "Important"

    Function archetype is only available to use in Spain infrastructure.

### Application types<span id="AppTypes"></span>

The archetype is able to manage up to three types of application based on the execution environments of a function application and the technology used to deploy those functions.

- ***Azure*** (AZURE): In addition to the Spring function, an AzureHandler is generated, which maps the Spring function to the Azure function. The archetype prepares a project ready to be deployed in Azure with the correct configuration.

- ***AWS*** (AWS): A Spring Cloud Function is generated that adds the AWS Cloud Function dependency. This dependency allows the function application to be easily deployed on AWS.

- ***Knative Web Servlet*** (KNATIVE SERVLET): A Spring Cloud Function is generated that adds the Spring Cloud Web Starter dependency. The application runs as a `Servlet` based web application. It does not include special dependencies related to
    Knative.

- ***Knative Web Reactive*** (KNATIVE REACTIVE): A Spring Cloud Function is generated that adds the Spring Cloud Webflux Starter dependency. The application runs as a web application based on `Reactive`. It does not include special dependencies
    related to Knative.

### Dependency management

During the execution of the archetype and according to the needs reflected by the user, the archetype is able to manage the Maven dependencies for the following libraries:

- [Spring Cloud Config Client](https://docs.spring.io/spring-cloud-config/docs/4.1.x/reference/html/#_spring_cloud_config_client)

- [Spring Web MVC](https://docs.spring.io/spring-framework/docs/6.1.20/reference/html/web.html#spring-web) y [Spring WebFlux](https://docs.spring.io/spring-framework/docs/6.1.20/reference/html/web-reactive.html#spring-webflux)

- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/3.3.12/reference/html/actuator.html#actuator)

- Spring HTTP Clients: [RestTemplate y WebClient](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html)

- [Springdoc-OpenAPI (Swagger)](https://springdoc.org/)

- Framework Darwin Spring Boot:

    - [Darwin Core](../../darwin-project/darwin-spring-boot-core/README.md)

    - [Darwin Cache](../../darwin-project/darwin-spring-boot-cache/README.md)

    - [Darwin Omnichannel](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/darwin-project/darwin-spring-boot-omnichannel/)

    - [Darwin Logging](../../darwin-project/darwin-spring-boot-logging/README.md)

    - [Darwin Authentication](../../darwin-project/darwin-spring-boot-security-authentication/README.md)

    - [Darwin Authorization](../../darwin-project/darwin-spring-boot-security-authorization/README.md)

    - [Darwin WebService](../../darwin-project/darwin-spring-boot-webservice/README.md)

    - [Darwin Metrics](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/darwin-project/darwin-spring-boot-metrics/)

    - [Darwin Partenon](../../darwin-project/darwin-spring-boot-partenon/README.md)

    - [Darwin Events](../../darwin-project/darwin-spring-boot-events/README.md)

### Correlation table

Based on the above information and in order to give an overview of what will be developed later, the following table is provided with the correspondences between the application types and the dependencies that **are included by default**:

| Dependencies                       | Azure | AWS | Knative Servlet | Knative Reactive |
|------------------------------------|-------|-----|-----------------|------------------|
| **Spring Cloud Config Client** (1) | Yes   | Yes | Yes             | Yes              |
| **Spring Web MVC**                 | No    | No  | Yes             | No               |
| **Spring WebFlux**                 | No    | No  | No              | Sí               |
| **Spring Boot Actuator**           | Yes   | Yes | Yes             | Yes              |
| **Spring HttpClients**             | Yes   | Yes | Yes             | Yes              |
| **Springdoc OpenAPI**              | No    | No  | Yes             | Yes              |
| **Darwin Core**                    | Yes   | Yes | Yes             | Yes              |
| **Darwin Cache**                   | Yes   | Yes | Yes             | Yes              |
| **Darwin Omnichannel**             | No    | No  | No              | No               |
| **Darwin Logging**                 | Yes   | Yes | Yes             | Yes              |
| **Darwin Authentication**          | Yes   | Yes | Yes             | Yes              |
| **Darwin Authorization**           | No    | No  | No              | No               |
| **Darwin WebService**              | No    | No  | No              | No               |
| **Darwin Metrics**                 | No    | No  | No              | No               |
| **Darwin Partenon**                | No    | No  | No              | No               |
| **Darwin Events**                  | No    | No  | No              | No               |

1. This dependency can be disabled using the corresponding archetype parameter, `config-client`.

!!! info "Important"

    Since version 3.2 of the archetype the omnichannel library is not included by default, consider adding it if you need it.

### Java support

When generating a project, the archetype allows you to specify the java version you want to use, by default java 11.

If it is necessary to create a function application in order to execute it on Java 17, the archetype of functions accepts one parameter for configuring the java version to Java 17. For more information, visit the [Optional parameters
section](#optional-parameters)

!!! info "Important"

    Darwin 4.x.y versions are supported for use with java 11 and java 17. Darwin 3.X versions are only supported with java 11.

## Darwin Spring Boot Starter parent

The Darwin archetype uses this starter as the basis for the projects it generates. It is intended to be the main POM for all Santander applications, providing dependencies and plugin management. This POM can also be used in libraries as dependency
management.

The idea is that developers should not worry about which library version they are going to use, as well as providing the list of all available dependencies. It also includes some fixed dependencies and plugins that must be used in all applications,
such as lombok, spring boot starters, jacoco plugin, etc.

!!! note

    More information can be found at the following link: [Darwin Spring Boot Starters](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/darwin-project/darwin-spring-boot-starters/).

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

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion={darwin-version} -Dcomponent-name={component}  -Dcloud-platform={cloudPlatform} -Dacronym-app={acronym} -DwebAppType={webAppType} [-Dauthorization-library -Domnichannel-library -Dwebservice-library -Dmetrics-component -Dpartenon-component  -Dadd-controller -Devents-component -Dconfig-client -Dlogging-kafka -Dcache-type={cacheType}]

!!! info "Important"

    The parameters in square brackets **are not mandatory**, the function and mandatory nature of each one is detailed below.

### Archetype parameters

There are a number of parameters that **should not be changed** to ensure the correct execution of the archetype, these are:

- ***-B***: indicates that the archetype will be executed in *Batch* mode.

- ***archetypeGroupId***: Group to which the archetype to be used belongs, its value is `com.santander.darwin`.

- ***archetypeArtifactId***: Id of the archetype to be used, its value is `darwin-spring-boot-archetype-microservice`.

- ***archetypeVersion***: Version of the archetype, it is important to run the latest version of the archetype (it goes hand in hand with the latest version of the framework). You can check the latest version available at the following link:
    [Changelog](../../CHANGELOG.md). In this example the version is {darwin-version}.

#### Required parameters

Next to the fixed parameters, there are some **mandatory parameters that will customize the generated project**, these are:

- ***component\_name***: Name of the component/application (it will be the name of the Maven artifact).

!!! warning

    The value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9-\]{1,32}***.It must start with a lowercase letter and continue with lowercase letters, numbers and hyphens, having a
    **maximum length of 33 characters**.

- ***acronym-app***: Application key.

!!! warning

    The value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9\]***.It must start with a lowercase letter and continue with lowercase letters and numbers, having a **maximum length of
    6 characters**.

!!! note

    This property corresponds to the AppKey of the Darwin framework.

- ***cloud-platform*** \*: Name of the cloud platform to be used in the project. Values can be (knative|azure|aws)

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

    ${acronym-app} darwin spring boot function: ${component-name}

#### Optional parameters

Finally, there are some optional parameters with which we can specify the libraries we want to include in it.

To include/exclude the ***Spring Cloud Service Config*** client dependency, we have the following parameter:

- ***config-client***: Indicates if we want to include or exclude the Spring Cloud Configuration client, but **it won't be configured anyway**. If the parameter is not defined, the default value will be ***Y*** (dependency included), therefore, to
    not include this dependency the parameter must have value ***N*** in the generation of the application.

!!! tip "Caution"

    From **Darwin 3.2.0-RELEASE** the Spring Cloud Config client configuration is delegated to the application deployment method (via Darwin JavaSE Chart or Darwin JavaSE Template).

As for the **framework libraries and others external to the framework**, by default **none of the following libraries are included**, to include them, we simply **add the parameter** to the maven command (-D*parameter-name*) or **assign the value
Y** (-D*parameter-name*=Y).These are:

- ***cache-type***: Sets the type of cache to be incorporated into the application. Possible values: `caffeine`, `infinispan` and `dual`. By default, the value will be `dual`.

- ***authorization-library***: Indicates that you want to use the authorization library to the application.

- ***omnichannel-library***: Indicates that you want to use the omnichannel library to the application.

- ***metrics-component***: Indicates that you want to incorporate the metrics component to the application.

- ***webservice-component***: Indicates that you want to incorporate the webservice component into the application.

- ***partenon-component***: Indicates that you want to incorporate the component with the partenon connector into the application.

- ***events-component***: Indicates that you want to incorporate the events component into the application.

- ***add-controller***: Indicates that you want to add the RestController class for the function application to be deployed in KNative, which exposes the basic function created. (By default, the value will be Y|true).

- ***java17***: Indicates that the app has to be configured for using Java 17.

- ***logging-kafka***: Indicates that you want to load kafka appenders for logging library (by default, the value will be Y).

- ***logging-entity***: To identify the application's country in the monitoring systems (by default, the value will be ESP).

!!! note

    Remember that the Darwin Logging, Authentication and Cache libraries, the Spring Http clients and the Spring Cloud Config Client module are **always** included in the generated applications.

!!! info "Important"

    Since version 3.2, if you add the authorization module and use the Spain mode, you need to add the omnichannel module.

### Examples of use

Here are some examples of how to use the maven command to configure the project according to the parameters:

1. Basic application: the command is executed only with the mandatory parameters.

2. Application with a cloud platform other than Knative: the command is executed with the mandatory parameters and we specify the cloud-platform parameter as AWS and remove the webAppType variable.

3. Application with added libraries: the command is executed adding some optional parameters to add those libraries.

4. Application with invalid parameters: the command is executed by entering some invalid value in the parameters.

#### Basic application

The first example corresponds to the generation of an application with only the mandatory parameters and dependencies, and in which we must choose the type of application it will be and the platform. For example, for a Knative Servlet application
with a Controller added:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId='com.santander.darwin' -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion=4.0.0-RELEASE -Dcomponent-name=application1 -Dcloud-platform=knative -Dacronym-app=myapps -DwebAppType=servlet -Dadd-controller=Y
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-pom>>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-function:4.0.0-RELEASE
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
    [INFO] Parameter: description, Value: myapps darwin spring boot function: application-1
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application-1
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: add-controller, Value: Y    
    [INFO] Parameter: artifactId, Value: application-1
    [INFO] Parameter: webAppType, Value: servlet
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: cloud-platform, Value: knative
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: ...\workspace\application-1
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  32.968 s
    [INFO] Finished at: 2020-06-09T10:57:40+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with cloud platform other than Knative

This second example corresponds to the generation of a Spring Cloud Function project to be deployed in Azure. To do this, we specify the cloud-platform parameter in Azure and remove the webAppType variable:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId='com.santander.darwin' -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion='3.2.1-RELEASE' -Dcomponent-name=azure -Dcloud-platform=azure -Dacronym-app=myapps

    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.2.0:generate (default-cli) > generate-sources @ standalone-pom>>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.2.0:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.2.0:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-function:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: azure
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.azure
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/azure
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: artifactId, Value: azure    
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: package, Value: com.santander.myapps.azure
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: webAppType, Value: servlet
    [INFO] Parameter: cloud-platform, Value: azure
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: add-controller, Value: Y
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: description, Value: Value: myapps darwin spring boot function: azure
    [INFO] Parameter: component-name, Value: azure
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: C:\azure
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  9.746 s
    [INFO] Finished at: 2021-02-24T09:23:48+01:00
    [INFO] ------------------------------------------------------------------------

#### Application with added libraries

If we want to add any of the optional libraries, we only need to add its associated parameter to our command. For example, to add the Authorization library and the WebService component:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId='com.santander.darwin' -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion='3.2.1-RELEASE' -Dcomponent-name=application3 -Dcloud-platform=knative -Dacronym-app=myapps -DwebAppType=servlet -Dauthorization-library -Dwebservice-component=Y
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-pom>>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-function:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application-3
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application3
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application3
    [INFO] Parameter: package, Value: com.santander.myapps.application3
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot function: application-3
    [INFO] Parameter: webservice-component, Value: Y
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application-3
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: true
    [INFO] Parameter: events-component, Value: N    
    [INFO] Parameter: artifactId, Value: application-3
    [INFO] Parameter: webAppType, Value: reactive
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: cloud-platform, Value: knative
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: ...\workspace\application-3
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  16.978 s
    [INFO] Finished at: 2020-06-09T11:03:41+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with Java 17

If we want to create a function application using Java 17, we only need to add Java 17 parameter to our command, for example:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion=4.0.0-RELEASE -Dcomponent-name=application3 -Dcloud-platform=knative -Dacronym-app=myapps -DwebAppType=servlet -Djava17
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-pom>>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-function:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: application3
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.application3
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/application3
    [INFO] Parameter: package, Value: com.santander.myapps.application3
    [INFO] Parameter: cloud-platform, Value: knative
    [INFO] Parameter: add-controller, Value: Y
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: java17, Value: true
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot function: application3
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: application3
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N    
    [INFO] Parameter: artifactId, Value: application3
    [INFO] Parameter: webAppType, Value: servlet
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: logging-kafka, Value: Y
    [WARNING] Does not override file C:\Users\n933274\Desktop\jira_testing\application3\src\main\java\com\santander\myapps\application3
    [WARNING] Does not override file C:\Users\n933274\Desktop\jira_testing\application3\src\main\azure\com\santander\myapps\application3
    [WARNING] Property 'gitignore' was not specified, so the token in '//__gitignore__' is not being replaced.
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: C:\Users\n933274\Desktop\jira_testing\application3
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  8.310 s
    [INFO] Finished at: 2022-09-01T13:04:02+02:00
    [INFO] ------------------------------------------------------------------------

#### Application with invalid parameters

As we have seen before, some parameters have a validation of their content. In case of non-compliance, an error message will be displayed and the generated project will be deleted.

For example, the parameter ***component-name*** must comply with the following validation: "*begin with a lowercase letter and continue with lowercase letters, numbers or hyphens, with a maximum of 33 characters*". If we use the value
"Application-4" the following will occur:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-function -DarchetypeVersion=4.0.0-RELEASE -Dcomponent-name=Application-4 -Dacronym-app=myapps -DwebAppType=servlet
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.1.2:generate (default-cli) > generate-sources @ standalone-pom>>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.1.2:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.1.2:generate (default-cli) @ standalone-pom ---
    [INFO] Generating project in Batch mode
    (...)
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-function:4.0.0-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: artifactId, Value: Application-4
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.myapps.Application4
    [INFO] Parameter: packageInPathFormat, Value: com/santander/myapps/Application4
    [INFO] Parameter: package, Value: com.santander.myapps.Application4
    [INFO] Parameter: config-client, Value: Y
    [INFO] Parameter: metrics-component, Value: N
    [INFO] Parameter: groupId, Value: com.santander.myapps
    [INFO] Parameter: description, Value: myapps darwin spring boot function: Application-4
    [INFO] Parameter: webservice-component, Value: N
    [INFO] Parameter: partenon-component, Value: N
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: component-name, Value: Application-4
    [INFO] Parameter: omnichannel-library, Value: N
    [INFO] Parameter: authorization-library, Value: N
    [INFO] Parameter: events-component, Value: N    
    [INFO] Parameter: artifactId, Value: Application-4
    [INFO] Parameter: webAppType, Value: servlet
    [INFO] Parameter: acronym-app, Value: myapps
    [INFO] Parameter: logging-kafka, Value: Y
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD FAILURE
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  15.919 s
    [INFO] Finished at: 2020-06-09T11:15:26+02:00
    [INFO] ------------------------------------------------------------------------
    Exception in thread "main" java.lang.AssertionError: The component-name parameter must start with a lower case letter and can have up to 32 other characters: lower case letters, numbers or '-'. Value: Application-4. Expression: componentNameMatch. Values: componentNameMatch = false
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

The structure and content of the function files shall depend on the value of the parameters entered in the archetype.

The function shall have an endpoint ***/hello*** of type POST, whose BODY shall be of type JSON. The input of the operation is represented by the **HelloInput** class and the return by the **HelloOutput** class. The response of the application shall
be a JSON with the text sent in upper case.

    Request:
    { "input" : "Hello World" }

    Response:
    { "output" : "HELLO WORLD" }

### Project structure

The structure of the project will depend on the type of application we have chosen: AWS, Azure, or KNative (Servlet or Reactive).

#### Knative Application Structure

In the case of an application (`Servlet` or `Reactive`) the following will be generated in the **main** of the project:

- A `functions` folder with a **HelloFunction.java** class that implements a basic function with a controller (`Servlet` or `Reactive`) that returns the message sent in uppercase when an HTTP POST request is made to the */hello* endpoint.

- A `web` folder, if the `add-controller` option has been added, with a **HelloController.java** class that will implement a basic controller that will expose the following endpoint */${artifactId}/hello*.

- A `model` folder with the DTOs that will use the function mentioned above. The classes are **HelloInput.java** and **HelloOutput.java**.

- A `service` folder with the business logic to be used by the function. The classes are `HelloService` and `HelloServiceImpl`, the implementation of the interface.

The corresponding tests for these classes will also be added: **ApplicationTest.java**, **FunctionsTest.java** and **HelloControllerTest.java** (with the `add-controller` option).

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        |   |           └──${acronym-app}
        │   │              └── ${component-name}
        │   │                  └── Application.java
        |   |                      └── functions
        |   |                          └── HelloFunction.java
        |   |                      └── model
        |   |                          └── HelloInput.java
        |   |                          └── HelloOutput.java
        |   |                      └── service
        |   |                          └── HelloService.java
        |   |                          └── impl
        |   |                              └── HelloServiceImpl.java
        |   |                      └── web
        |   |                          └── HelloController.java
        |   |
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       └── errors
        │           └── Resource Bundle 'errors
        |               ├── errors_en_US.properties
        │               └── errors_es_ES.properties
        └── test
            └── java
                └── com
                    └── santander
                        └── ${acronym-app}
                            └── ${component-name}
                                 ├── ApplicationTest.java
                                 └── functions
                                     └── FunctionsTest.java
                                 └── web
                                     └── HelloControllerTest.java

#### Azure Application Structure

In the case of an AWS application the following will be generated in the **main** of the project:

- A `functions` folder with a **HelloFunction.java** class that implements a basic function that returns the message sent in uppercase when an HTTP POST request is made to the */hello* endpoint.

- A `model` folder with the DTOs to be used by the above function. The classes are **HelloInput.java** and **HelloOutput.java**.

- A `service` folder with the business logic to be used by the function. The classes are `HelloService` and `HelloServiceImpl`, the implementation of the interface.

- A `handler` folder, where you will find the class that will extend AzureSpringBootRequestHandler to unify Azure functions with Spring Cloud Functions. In this case, the **HelloHandler.java** is the one that performs this function.

Corresponding tests will also be added for these classes: **ApplicationTest.java** and **FunctionsTest.java**.

Apart from these files, the **azure** package will be generated, which will contain two configuration files needed to test the application locally when deployed with Maven. These files are:

- [host.json](https://docs.microsoft.com/es-es/azure/azure-functions/functions-host-json)

- [local.settings.json](https://docs.microsoft.com/es-es/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#local-settings-file)

These are local configuration files that do not initially need any further modification. The rest of the files needed for Azure deployment will be generated in the **src/target/azure-functions** folder.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├──azure
        │   │  └── com
        │   │      └── santander
        |   |          └──${acronym-app}
        │   │             └── ${component-name}
        │   │                 └── local.settings.json
        │   │                 └── host.json
        │   ├── java
        │   │   └── com
        │   │       └── santander
        |   |           └──${acronym-app}
        │   │              └── ${component-name}
        │   │                  └── Application.java
        |   |                      └── functions
        |   |                          └── HelloFunction.java
        |   |                      └── model
        |   |                          └── HelloInput.java
        |   |                          └── HelloOutput.java
        |   |                      └── handler
        |   |                          └── HelloHandler.java
        |   |                      └── service
        |   |                          └── HelloService.java
        |   |                          └── impl
        |   |                              └── HelloServiceImpl.java
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       └── errors
        │           └── Resource Bundle 'errors
        |               ├── errors_en_US.properties
        │               └── errors_es_ES.properties
        └── test
            └── java
                └── com
                    └── santander
                        └── ${acronym-app}
                            └── ${component-name}
                                 ├── ApplicationTest.java
                                 └── functions
                                     └── FunctionsTest.java

#### AWS Application Structure

In the case of an AWS application the following will be generated in the **main** of the project:

- A `functions` folder with a **HelloFunction.java** class that implements a basic function that returns the message sent in uppercase when an HTTP POST request is made to the */hello* endpoint.

- A `model` folder with the DTOs to be used by the above function. The classes are **HelloInput.java** and **HelloOutput.java**.

- A `service` folder with the business logic to be used by the function. The classes are `HelloService` and `HelloServiceImpl`, the implementation of the interface.

The corresponding tests for these classes will also be added: \*ApplicationTest.java\` and \*FunctionsTest.java\`.

    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        |   |           └──${acronym-app}
        │   │              └── ${component-name}
        │   │                  └── Application.java
        |   |                      └── functions
        |   |                          └── HelloFunction.java
        |   |                      └── model
        |   |                          └── HelloInput.java
        |   |                          └── HelloOutput.java
        |   |                      └── service
        |   |                          └── HelloService.java
        |   |                          └── impl
        |   |                              └── HelloServiceImpl.java
        |   |
        │   └── resources
        │       ├── banner.txt
        │       ├── errors.properties
        │       ├── config
        │       │   ├── application.yml
        |       │   └── application-local.properties
        │       └── errors
        │           └── Resource Bundle 'errors
        |               ├── errors_en_US.properties
        │               └── errors_es_ES.properties
        └── test
            └── java
                └── com
                    └── santander
                        └── ${acronym-app}
                            └── ${component-name}
                                 ├── ApplicationTest.java
                                 └── functions
                                     └── FunctionsTest.java

### Configuration files

#### POM

The **pom.xml** file contains all the information that Maven uses to identify the generated project and manage its dependencies.

At the beginning it will always have the ID/metadata of the application we have created:

    <groupId>com.santander.darwin</groupId>
    <artifactId>testapp</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>testapp</name>
    <description>myapps darwin spring boot function: testapp</description>

The Darwin Spring Boot framework defines the POM parent [mentioned previously](#darwin-spring-boot-starter-parent) to manage library versions so that there are no conflicts between them:

    <parent>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-parent</artifactId>
        <version>{darwin-version}</version>
    </parent>

!!! info "Important"

    Note that due to this POM parent, none of the dependencies that will be shown below are versioned.

Next, we define as a property, the java version we want to compile with. The version that will appear in the *pom.xml* will be ***11***.

      <properties>
            <java.version>11</java.version>
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

##### Example: application with added libraries

For this example we will start from the basic pom of an Azure application, the archetype will incorporate the following dependencies:

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
        </dependencies>
        <!-- Test dependencies -->
    (...)

1. Unless otherwise specified, the Spring Cloud Config Client module is **always included** in the generated applications.

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

##### Example: KNative Servlet application

For a `KNative Servlet` application the archetype will incorporate some dependencies on the common ones:

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
                <artifactId>spring-cloud-starter-function-web</artifactId>
            </dependency>
            <!-- Santander Darwin libraries -->
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

##### Example: Knative Reactive application

For a basic `KNative Reactive` application, the archetype will incorporate the following dependencies:

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
                <artifactId>spring-cloud-starter-function-webflux</artifactId>
            </dependency>

            <!-- Santander Darwin libraries -->
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

#### Properties files

The archetype has generated a number of property files to configure what is needed according to the libraries that have been previously included:

- *application.yml*: main environment-independent application configuration file.

- *application-local.properties*: auxiliary file with properties associated with the environment (in this case for a local environment).

We recommend
reading the [Darwin application configuration guide](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16524089097/Darwin+Applications+Configuration) for more details on the configuration of the applications and on these files.

##### Application.yml file

Similar to pom.xml, the content of this file has a **fixed part** that will be configured in any application:

- The default active profile is *local*.

- The PaaS region is defined (default *boae*).

- The application name is set.

- Darwin AppKey (with the value of *acronym-app*).

- Darwin Logging Library.

- Setting Spring Session to "none".

- Default technical log levels.

- Package to be scanned to identify functions.

- Disable configuration server health.

- Spring Configuration Service client configuration is added (Optional, but included by default).

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

    logging.level:
      com.santander.darwin.testapp: INFO
      root: ERROR

    health:
      config:
        enabled: false

1. `darwin.logging.kafka.server` is included by default but it will be removed if *-Dlogging-kafka=N* is used.

Below we show 3 examples of possible resulting files according to the values of some parameters.

!!! note

    Remember the relationship between the type of application and the dependencies included in the [correlation table](#correlation-table), as this affects the properties that we must configure in each case.

- Application with Authorization

    In case we have selected the **Authorization library**, the archetype will add the Operational Control properties. For example, if we base it on the basic file, it would look like this:

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

        logging.level:
          com.santander.darwin.testapp: INFO
          root: ERROR

        health:
          config:
            enabled: false

- **Web Application**

    If it is a KNative application (Servlet or Reactive) a file will be generated that also includes:

    - Spring Security filter configuration.

    - Configuration of Actuator endpoints.

    - Springdoc configuration for Swagger endpoints in case of adding the `add-controller` option.

    - Management of proxy variables.

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

        logging.level:
          com.santander.darwin.testapp: INFO
          root: ERROR

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

- **Application with Partenon Connector**

    If in any of the possible applications we select the dependency with the Partenon component, its configuration will be added to the generated file:

        darwin:
          partenon:
            default:
              host: ${env.partenon-host}
              port: ${env.partenon-port}
              portForToken: ${env.partenon-token-port}

- **Proxy variable management**

    Spring doc does not have the functionality to support the use of proxy variables as X-Forwarded-Prefix and delegates the conversion to Spring.

    In order to support the use of proxy variables, the following default configuration is added to web applications:

        server.forward-headers-strategy: framework

##### Application-local.properties file

This file will have at least the PKM and STS properties of the security library. By default, it will also include the property to define the kafka server to connect with the logging library (for local environments we leave it empty), but we can
remove it using *-Dlogging-kafka=N*, and the property to disable Spring Cloud Config (if not disabled) in local environments:

    env.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
    env.sts-endpoint: https://srvnuarintra.santander.dev.corp/sts
    env.logging-server:

    spring.cloud.config.enabled: false

- If the **Authorization Library** is used, in addition to the above, the following shall be added:

<!-- -->

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract

- If the **Partenon component** has been included, it will be added:

<!-- -->

    env.partenon-host: dbd1.isban.dev.corp
    env.partenon-port: 5100
    env.partenon-token-port: 5144
