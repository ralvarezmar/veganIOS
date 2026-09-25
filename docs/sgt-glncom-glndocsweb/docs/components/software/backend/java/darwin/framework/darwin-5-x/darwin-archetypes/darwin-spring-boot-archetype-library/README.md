# Darwin Spring Boot Library Archetype ![5.8.2](https://img.shields.io/badge/5.8.2-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The Maven archetype for Darwin Spring Boot libraries allows the rapid creation of a 'skeleton' for Spring Boot libraries incorporating the necessary dependencies for their use.

## Dependency management

This project will serve as Parent POM for the Santander Spring Boot libraries based on Darwin, providing dependencies and plugin management.

The idea is that developers should not worry about which dependency version of any library to use, as well as providing the list of all available dependencies. It also includes some fixed dependencies and plugins that must be used in all libraries.

## Java support

When generating a project, the archetype use java 17 by default.

## Project generation

As a prerequisite to running the archetype, access to the Nexus repository must be configured in our Maven configuration, which is where the archetypes and proprietary Maven artefacts are stored.

    <repositories>
        <repository>
            <id>maven-public</id>
            <url>http://nexus.alm.europe.cloudcenter.corp/repository/maven-public/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>

In the command line and from the directory in which you want to create the new project, you must execute a maven command like the following, substituting the value of the parameters for those of the project you want to create:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-library -DarchetypeVersion={darwin-version} -Dcomponent-name={component} -Dacronym-app={acronym} [-Dsystem={system} -Dsub-system-code={subsystem} -Dfunctional-application-code={application} -Dfunctional-sub-application-code={subapplication}]

!!! info "Important"

    The parameters in square brackets **are not mandatory**, the function and mandatory nature of each one is detailed below.

### Archetype parameters

There are a number of parameters that **should not be changed** to ensure the correct execution of the archetype, these are:

- ***-B***: indicates that the archetype will be executed in *Batch* mode.

- ***archetypeGroupId***: Group to which the archetype to be used belongs, its value is `com.santander.darwin`.

- ***archetypeArtifactId***: Id of the archetype to be used, its value is `darwin-spring-boot-archetype-library`.

- ***archetypeVersion***: Version of the archetype, it is important to run the latest version of the archetype (it goes hand in hand with the latest version of the framework). You can check the latest version available at the following link:
    [Changelog](../../CHANGELOG.md). In this example the version is {darwin-version}.

Next to the fixed parameters, there are some **mandatory parameters that will customize the generated project**, these are:

- ***component\_name***: Name of the component/application (it will be the name of the Maven artifact).

!!! caution

    In versions previous to 4.0.2-RELEASE the value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9-\]{1,32}***.

- ***acronym-app***: Application key.

!!! caution

    In versions previous to 4.0.2-RELEASE the value we give to this property must comply with the following regular expression: ***\[a-z\]\[a-z0-9\]***.

!!! note

    This property corresponds to the AppKey of the Darwin framework.

- ***system***: Value received from ATLAS with the name of the system the application belongs to. This parameter corresponds to the logging property: system. Optional

- ***sub-system***: Value received from ATLAS with the name of the subsystem to which the application belongs.This parameter corresponds to the logging property: subsystem. Optional

- ***functional-application-code***: Value received from ATLAS with the name of the application to which it belongs. This parameter corresponds to the logging property: application. Optional

- ***functional-sub-application-code***: Value received from ATLAS with the name of the sub-application to which the application belongs. This parameter corresponds to the logging property: subapplication. Optional

A From these parameters the **properties needed for any maven project** are formed automatically:

- ***groupId***: The `groupId` to appear in the project pom shall be generated from the `acronym-app` parameter as follows:

      com.santander.{acronym-app}

- ***artifactId***: The `artifactId` that will appear in the project's pom will have the same value that we have given to the `component-name` parameter.

- ***version***: The default version for a new project will always be **1.0.0-SNAPSHOT**.

- ***package***: The `package` of the Java project will be generated from the `groupId` and `artifactId` values as follows:

      {groupId}.{artifactId.replaceAll("-", "").replaceAll("_", "")}

- ***description***: The default project description shall have the following text:

      ${acronym-app} darwin spring boot library: ${component-name}

### Examples of use

Here are some examples of how to use the maven command to configure the project according to the parameters:

1. Valid parameters: the command is executed by entering valid values in the parameters.

2. Invalid parameters: the command is executed by entering some invalid value in the parameters.

#### Valid parameters

If valid values are used in the parameters, the expected project will be generated without any problem:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-library -DarchetypeVersion=4.0.0-RELEASE -Dcomponent-name=greetings -Dacronym-app=darwin
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
    [INFO] Archetype repository not defined. Using the one from [com.santander.darwin:darwin-spring-boot-archetype-library:3.2.1-RELEASE] found in catalog remote
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-library:3.2.1-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.darwin
    [INFO] Parameter: artifactId, Value: greetings
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.darwin.greetings
    [INFO] Parameter: packageInPathFormat, Value: com/santander/darwin/greetings
    [INFO] Parameter: component-name, Value: greetings
    [INFO] Parameter: package, Value: com.santander.darwin.greetings
    [INFO] Parameter: groupId, Value: com.santander.darwin
    [INFO] Parameter: description, Value: Librería Spring Boot de darwin: greetings
    [INFO] Parameter: artifactId, Value: greetings
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: acronym-app, Value: darwin
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    WARNING: An illegal reflective access operation has occurred
    WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/.m2/repository/org/codehaus/groovy/groovy/2.4.16/groovy-2.4.16.jar) to method java.lang.Object.finalize()
    WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
    WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
    WARNING: All illegal access operations will be denied in a future release
    [INFO] Project created from Archetype in dir: ...\workspace\greetings
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  18.554 s
    [INFO] Finished at: 2020-06-23T16:08:26+02:00
    [INFO] ------------------------------------------------------------------------

#### Invalid parameters

However, as we have seen before, some parameters have a validation of their content. In case of non-compliance, an error message will be displayed and the generated project will be deleted.

For example, the parameter ***component-name*** must comply with the following validation:
"*begin with a lowercase letter and continue with lowercase letters, numbers or hyphens, with a maximum of 33 characters*".
If we use the value "Greeting$" the following will occur:

    mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate -DarchetypeGroupId=com.santander.darwin -DarchetypeArtifactId=darwin-spring-boot-archetype-library -DarchetypeVersion=4.0.0-RELEASE -Dcomponent-name=Greeting$ -Dacronym-app=darwin
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
    [INFO] Archetype repository not defined. Using the one from [com.santander.darwin:darwin-spring-boot-archetype-library:3.2.1-RELEASE] found in catalog remote
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: darwin-spring-boot-archetype-library:3.2.1-RELEASE
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.darwin
    [INFO] Parameter: artifactId, Value: Greeting$
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.darwin.Greeting$
    [INFO] Parameter: packageInPathFormat, Value: com/santander/darwin/Greeting$
    [INFO] Parameter: component-name, Value: Greeting$
    [INFO] Parameter: package, Value: com.santander.darwin.Greeting$
    [INFO] Parameter: groupId, Value: com.santander.darwin
    [INFO] Parameter: description, Value: Librería Spring Boot de darwin: Greeting$
    [INFO] Parameter: artifactId, Value: Greeting$
    [INFO] Parameter: version, Value: 1.0.0-SNAPSHOT
    [INFO] Parameter: acronym-app, Value: darwin
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    WARNING: An illegal reflective access operation has occurred
    WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/.m2/repository/org/codehaus/groovy/groovy/2.4.16/groovy-2.4.16.jar) to method java.lang.Object.finalize()
    WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
    WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
    WARNING: All illegal access operations will be denied in a future release
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD FAILURE
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  16.759 s
    [INFO] Finished at: 2020-06-23T16:11:27+02:00
    [INFO] ------------------------------------------------------------------------
    Exception in thread "main" java.lang.AssertionError: The component-name parameter must start with a lower case letter and can have up to 32 other characters: lower case letters, numbers or '-'. Value: Greeting$. Expression: componentNameMatch. Values: componentNameMatch = false
            at org.codehaus.groovy.runtime.InvokerHelper.assertFailed(InvokerHelper.java:422)
            at org.codehaus.groovy.runtime.ScriptBytecodeAdapter.assertFailed(ScriptBytecodeAdapter.java:663)
            at Script1.run(Script1.groovy:10)
            at groovy.lang.GroovyShell.evaluate(GroovyShell.java:574)
            at groovy.lang.GroovyShell.evaluate(GroovyShell.java:612)
            at groovy.lang.GroovyShell.evaluate(GroovyShell.java:583)

## Resulting project

The project generated by the archetype is intended to show a basic structure and files for a Spring Boot library.

### Project structure

Taking the values from the previous example, the structure of the project will be as follows:

    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── santander
        │   │           └── darwin
        │   │               └── greetings
        │   │                   ├── config
        │   |                   |   ├── HelloWorldAutoConfig.java
        │   |                   |   └── HelloWorldConfigProperties.java
        │   |                   └── components
        │   |                       └── HelloWorldBean.java
        │   └── resources
        │       └── META-INF
        │           └── spring
        │               └── org.springframework.boot.autoconfigure.AutoConfiguration.imports
        └── test
            ├── java
            │   └── com
            │       └── santander
            │           └── darwin
            │               └── greetings
            │                   ├── config
            |                   |   ├── HelloWorldAutoConfigTest.java
            |                   |   └── HelloWorldConfigPropertiesTest.java
            |                   └── components
            |                       └── HelloWorldBeanTest.java
            └── resources
                └── application.yml

- From the root of the project, the file [**pom.xml**](#pom), which contains all the information used by Maven to manage dependencies, metadata, etc., must be highlighted.

- In the `main` package, all the classes and files with the library functionality will be included:

    - **HelloWorldAutoConfig.java**: auto-configuration class of the library in which to load the beans needed or to be exposed.

    - **HelloWorldConfigProperties.java**: class to load the file properties that configure the library.

    - **HelloWorldBean.java**: class with functionality that will be exposed as a *Bean*.

    - **AutoConfiguration.imports**: file to define the configuration classes to load when an application includes this library.

- In the `test` package we include some tests (unit and/or embedded) with which to test the different pieces of the library and a properties file **application.yml** on which some tests are supported.

### Configuration files

#### POM

The **pom.xml** file contains all the information that Maven uses to identify the generated project and manage its dependencies.

At the beginning it will always have the identification/metadata of the library we have created:

    <groupId>com.santander.darwin</groupId>
    <artifactId>greetings</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>greetings</name>
    <description>myapp darwin spring boot library: greetings</description>

The Darwin Spring Boot framework defines the parent POM [mentioned previously](#dependency-management) to manage library versions so that there are no conflicts between them:

    <parent>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-dependencies</artifactId>
        <version>{darwin-version}</version>
    </parent>

!!! info "Important"

    Note that due to this parent POM none of the dependencies that will be shown below are versioned.

From here we define the dependencies and plugins that the project will use.

```xml
    <dependencies>
        <!-- Spring Boot starter -->
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

        <!-- Optional dependencies -->
        <!-- Spring indexer to improve startup time -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context-indexer</artifactId> <!-- <1> -->
            <optional>true</optional>
        </dependency>

        <!-- Provided dependencies   -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <scope>provided</scope>
        </dependency>

        <!-- Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-starter-logging</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>junit</groupId>
                    <artifactId>junit</artifactId>
                </exclusion>
            </exclusions>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.platform</groupId>
            <artifactId>junit-platform-launcher</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- Enables any legacy JUnit 3 and JUnit 4 tests you may have. Not needed for JUnit 5 tests. -->
        <dependency>
            <groupId>org.junit.vintage</groupId>
            <artifactId>junit-vintage-engine</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- plugins configuration -->
        </plugins>
    </build>

    <reporting>
        <plugins>
            <!-- reporting plugins configuration -->
        </plugins>
    </reporting>
```

1. `spring-context-indexer` dependency is used to improve the startup time of the application when the library is loaded
**via component-scan**.

#### AutoConfiguration.imports file

With this file we define the configuration classes to be loaded when the library is loaded in an application **via auto-configuration**.
In the example above the content of this file would be as follows:

    com.santander.darwin.greetings.config.HelloWorldAutoConfig

## Library use cases

Once we have created the Spring Boot project with the library, we are going to show a use case in an application.
For this example, we will rely on a Web application generated with the [Darwin Spring Boot microservice archetype](../darwin-spring-boot-archetype-microservice/README.md).

### Install artifact in maven repository

In order to be able to add the dependency with the new library later in the application, it must be in some maven repository
with which it has visibility. For this example we will use our team's local repository, running the `install` phase of the
maven lifecycle on our library:

    mvn install

### Include dependency in the application's POM

With the artefact installed in the repository, we can now add the library dependency to the application's POM along
with the rest of the dependencies:

    (...)
    <dependencies>
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>greetings</artifactId>
            <version>1.0.0-SNAPSHOT</version>
        </dependency>

        <!-- Spring Boot Actuator dependency -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
    (...)

### Using the new exposed functionality

Thanks to the `spring.factories` file, when we start the application our library will be configured automatically.
To test it, we have included the following changes in the application:

- **application.yml**: we add the property of our library to configure the HelloWorldBean message.

```yaml
    greetings.helloValue: fromApplicationYml

    darwin:
      app-key: darwin
      logging:
```

- **HelloController.java**: we inject the HelloWorldBean bean into the controller to return the string it generates with the above property as a response to the */hello* endpoint.

```java
    public class HelloController {

        @Autowired
        HelloworldBean helloworldBean;

        @GetMapping(produces=MediaType.TEXT_PLAIN_VALUE)
        public String sayHello() {
            log.info("Log from Servlet controller");
            return helloWorldBean.sayHelloProperty();
        }
    }
```

If we now make a request to the controller we will get the following response:

    Hello World with property value: fromApplicationYml
