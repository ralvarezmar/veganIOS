# Arsenal Integration Migration Guide

## Migration Guide from an Arsenal Integration Application to Santander Spring Boot

This guide summarizes the necessary changes to migrate an application
from the `arsenal-integration-spring` to `santander-spring-boot` framework.
In order to use the new framework, it is necessary to update a set of files,
components, and references used by the applications.

!!! note

    To make the migration successfully, the minimum version used of **Arsenal Integration Spring** must be `4.16.x`.

!!! tip

    This migration guide is only valid for migrating Arsenal Integration Microservices, for Arsenal Backend see this [guide](./arsenal-backend-to-santander-framework.md).

## Migrate using GitHub Copilot

### Prerequisites

Ensure your microservice is running **Arsenal Integration version 4.16.x or higher** before starting the migration.

### Quick Start Guide

For a complete AI-assisted migration experience:

### Step 1: Setup Instructions

Follow the detailed [Using Copilot Migration Guide](https://github.com/santander-group-shared-assets/gln-back-santander-java-framework-migration-guides) to:

   - Configure VS Code with GitHub Copilot
   - Set up the workspace for optimal AI assistance
   - Install required extensions and settings

### Step 2: Run Migration

Use the [Arsenal Integration Recipe](https://github.com/santander-group-shared-assets/gln-back-santander-java-framework-migration-guides/blob/main/docs/recipe-ars-integration/full-arsenal-to-santander-fwk-copilot-integration.md) for AI-guided transformation.

> **⚠️ Important**: AI accelerates the process but requires developer oversight. Always review generated code, validate architectural decisions, and test thoroughly before committing changes.

## Migrate in a manual way

### 🚨 CRITICAL: Pre-Migration Setup

### Step 1: Understand the Transformation Scope

This is a **COMPLETE REPLACEMENT** migration, not an additive migration:

- Remove ALL Arsenal Integration dependencies and configurations
- Replace with Santander Spring Boot equivalents
- Transform package structure completely
- Remove Arsenal-specific security and configuration classes

### Update pom.xml file

Keep the Maven configurations below:

### Step 2: Preserve Maven Project Structure

#### Do not change

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns="http://maven.apache.org/POM/4.0.0"
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
<modelVersion>4.0.0</modelVersion>
```

**Why this is important:** These Maven project declarations are standard and must remain unchanged to maintain proper project structure.

Remove the parent from Arsenal Integration:

### Step 3: Remove Arsenal Integration Parent

#### Remove

```xml
<parent>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-lib-parent</artifactId>
    <version>4.16.6</version>
</parent>
```

Add the parent from Santander Framework:

### Step 4: Add Santander Framework Parent

#### Add

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-parent</artifactId>
    <version>1.0.1</version>
</parent>
```

**Why this is critical:** The Santander Framework parent provides all necessary dependency management and plugin configurations for the new architecture.

Add the Java version property:

### Step 5: Configure Java Version Properties

#### Add

```xml
<!-- Java compile version -->
<properties>
    <java.version>17</java.version>
</properties>
```

Remove the dependencyManagement block:

### Step 6: Remove Arsenal Integration Dependency Management

#### Remove

```xml
<dependencyManagement>
    <dependencies>
    <!-- Spring Boot BOM -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>${spring-boot.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!-- Camel Spring Boot BOM -->
        <dependency>
            <groupId>org.apache.camel.springboot</groupId>
            <artifactId>camel-spring-boot-bom</artifactId>
            <version>${apache-camel.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!-- Camel BOM -->
        <dependency>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-bom</artifactId>
            <version>${apache-camel.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

**Why this is important:** The Santander Framework parent already provides all necessary dependency management, making these explicit declarations redundant.

### 🚨 CRITICAL: Remove Arsenal Integration Dependencies

### Step 7: Remove Arsenal Integration Dependencies

#### Remove

```xml
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
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

**Why this is important:** These Arsenal Integration dependencies are specific to Camel-based integration patterns and must be replaced with Santander Framework equivalents.

### 🚨 CRITICAL: Add Santander Framework Dependencies

### Step 8: Add Santander Framework Core Dependencies

#### Add

```xml
<!-- 🌐 SPRING BOOT CORE DEPENDENCIES -->
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

<!-- 🔄 APACHE CAMEL DEPENDENCIES -->
<!-- Spring Boot Apache Camel dependency -->
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-spring-boot-starter</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-observation-starter</artifactId>
</dependency>

<!-- Apache Camel dependency -->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-http</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-jackson</artifactId>
</dependency>

<!-- Servlet WebApp starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- OpenAPI dependency -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
</dependency>

<!-- 🚨 SANTANDER FRAMEWORK DEPENDENCIES -->
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
    <artifactId>santander-spring-boot-starter-cache-caffeine</artifactId>
</dependency>
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-cache-infinispan</artifactId>
</dependency>

<!-- Authentication dependency -->
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
        <artifactId>santander-spring-boot-starter-authentication</artifactId>
</dependency>

<!-- 🛠️ DEVELOPMENT DEPENDENCIES -->
<!-- Provided dependencies -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <scope>provided</scope>
</dependency>

<!-- 🧪 TEST DEPENDENCIES -->
<!-- Test Dependencies -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<!-- Junit 5 Dependencies -->
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

<!-- Spring security dependency for testing -->
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-test</artifactId>
    <scope>test</scope>
</dependency>

<!-- Apache Camel Spring dependency for testing -->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-test-spring-junit5</artifactId>
    <scope>test</scope>
</dependency>
```

**Why this is critical:** These dependencies provide the complete Santander Framework stack including core functionality, authentication, logging, caching, and comprehensive testing capabilities.

### 🚨 CRITICAL: Remove Arsenal Integration Build Plugins

### Step 9: Remove Arsenal Integration Build Plugins

#### Remove

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
        </plugin>
        <!-- CONFIGURATION OF THE PLUGIN TO GENERATE CAMEL CODE BASED ON SWAGGER.YAML -->
        <plugin>
            <groupId>com.santander.ars</groupId>
            <artifactId>gln-back-arsenal-integration-openapi-maven-plugin</artifactId>
            <executions>
                <execution>
                    <phase>generate-sources</phase>
                    <goals>
                        <goal>generator</goal>
                    </goals>
                    <configuration>
                        <skip>true</skip>
                        <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                        <rootPackageClass>com.santander.gluon.demo</rootPackageClass>
                        <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                        <outputGeneratedTestClasses>${project.build.testSourceDirectory}
                        </outputGeneratedTestClasses>
                        <isGluon>false</isGluon>
                        <skipOverwrite>true</skipOverwrite>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        <plugin>
            <groupId>org.openapitools</groupId>
            <artifactId>openapi-generator-maven-plugin</artifactId>
            <version>${openapi-generator-maven-plugin.version}</version>
            <executions>
                <execution>
                    <goals>
                        <goal>generate</goal>
                    </goals>
                    <configuration>
                        <inputSpec>${openapi-contract-path}</inputSpec>
                        <generatorName>spring</generatorName>
                        <modelPackage>com.santander.gluon.demo.model.dto</modelPackage>
                        <generateModels>true</generateModels>
                        <generateSupportingFiles>false</generateSupportingFiles>
                        <generateModelTests>false</generateModelTests>
                        <generateModelDocumentation>false</generateModelDocumentation>
                        <generateApis>false</generateApis>
                        <generateApiTests>false</generateApiTests>
                        <generateApiDocumentation>false</generateApiDocumentation>
                        <configOptions>
                            <dateLibrary>java8</dateLibrary>
                            <useBeanValidation>false</useBeanValidation>
                            <openApiNullable>false</openApiNullable>
                            <useJakartaEe>true</useJakartaEe>
                        </configOptions>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        <!-- END CONFIGURATION OF THE PLUGIN TO GENERATE CAMEL CODE BASED ON SWAGGER.YAML -->
        <!-- jacoco plugin to generate the report to sonar -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>${jacoco-maven-plugin.version}</version>
            <executions>
                <execution>
                    <phase>test-compile</phase>
                    <id>default-prepare-agent</id>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <phase>test</phase>
                    <id>default-report</id>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        <plugin>
            <groupId>com.santander.ars</groupId>
            <artifactId>gln-back-arsenal-integration-archunit-plugin-v2</artifactId>
            <version>${arsenal-archunit.version}</version>
            <executions>
                <execution>
                    <phase>test</phase>
                    <goals>
                        <goal>arch-test</goal>
                    </goals>
                </execution>
            </executions>
            <dependencies>
                <dependency>
                    <groupId>com.santander.ars</groupId>
                    <artifactId>gln-back-arsenal-integration-archunit-core-v2</artifactId>
                    <version>${arsenal-archunit.version}</version>
                </dependency>
            </dependencies>
        </plugin>
    </plugins>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
</project>
```

**Why this is important:** These Arsenal Integration build plugins are specific to the old architecture and must be completely replaced with Santander Framework equivalents.

### 🚨 CRITICAL: Add Santander Framework Build Plugins

### Step 10: Add Santander Framework Build Plugins

#### Add

```xml
<build>
    <!-- 🔧 BUILD PLUGINS -->
    <plugins>
        <!-- Spring Boot Maven Plugin -->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>

        <!-- Maven Plugin for the encoding -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-resources-plugin</artifactId>
            <configuration>
                <encoding>${project.build.sourceEncoding}</encoding>
                <propertiesEncoding>ISO-8859-1</propertiesEncoding>
            </configuration>
        </plugin>

        <!-- Jacoco Maven Plugin for coverage -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <executions>
                <execution>
                    <id>default-prepare-agent</id>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>default-report</id>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>

        <!-- 🚨 CRITICAL: OpenAPI Generator Plugin -->
        <plugin>
            <groupId>org.openapitools</groupId>
            <artifactId>openapi-generator-maven-plugin</artifactId>
            <executions>
                <execution>
                    <goals>
                        <goal>generate</goal>
                    </goals>
                    <configuration>
                        <!-- specify the OpenAPI yaml -->
                        <inputSpec>${project.basedir}/src/main/resources/config/user-contract.yaml</inputSpec>

                        <!-- target to generate java server code -->
                        <generatorName>spring</generatorName>

                        <!-- temporal to allow use test slice annotations as @DataJpaTest -->
                        <templateDirectory>${project.basedir}/src/main/resources/openapi-templates</templateDirectory>

                        <!-- hint: if you want to generate java client code
                             you can use the following generator: <generatorName>java</generatorName> -->
                        <apiPackage>com.santander.demo.infrastructure.adapters.input.rest</apiPackage>
                        <modelPackage>com.santander.demo.infrastructure.adapters.input.rest.data</modelPackage>
                        <invokerPackage>com.santander.demo</invokerPackage>

                        <!-- pass any necessary config options -->
                        <configOptions>
                            <documentationProvider>springdoc</documentationProvider>
                            <serializableModel>true</serializableModel>
                            <snapshotVersion>true</snapshotVersion>
                            <implicitHeaders>true</implicitHeaders>
                            <openApiNullable>false</openApiNullable>
                            <delegatePattern>true</delegatePattern>
                            <useSpringBoot3>true</useSpringBoot3>
                            <configPackage>com.santander.demo.infrastructure.config</configPackage>
                        </configOptions>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>

    <!-- 📁 RESOURCE CONFIGURATION -->
    <resources>
        <resource>
            <directory>${project.basedir}/src/main/resources</directory>
            <filtering>true</filtering>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.yml</include>
                <include>**/*.yaml</include>
                <include>**/banner.txt</include>
                <include>**/santanderchannels.json</include>
            </includes>
        </resource>
    </resources>
</build>
```

**Why this is critical:** These Santander Framework build plugins provide the complete build configuration including Spring Boot packaging, resource encoding, code coverage reporting, and OpenAPI code generation with proper package structure.

### 🚨 CRITICAL: OpenAPI Templates Configuration

### Step 11: Create OpenAPI Templates Directory

#### Create this directory

``` plaintext
src/main/resources/openapi-templates
```

### Step 12: Create OpenAPI Spring Boot Template

#### Create this file: `openapi2SpringBoot.mustache`

#### With this content

```java
package {{basePackage}};

{{#openApiNullable}}
import com.fasterxml.jackson.databind.Module;
import org.openapitools.jackson.nullable.JsonNullableModule;
{{/openApiNullable}}
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.FullyQualifiedAnnotationBeanNameGenerator;

@SpringBootApplication(
    nameGenerator = FullyQualifiedAnnotationBeanNameGenerator.class,
    scanBasePackages = {"{{basePackage}}", "{{apiPackage}}", "{{configPackage}}"}
)
public class OpenApiGeneratorApplication {

    public static void main(String[] args) {
        SpringApplication.run(OpenApiGeneratorApplication.class, args);
    }

{{#openApiNullable}}
    @Bean(name = "{{basePackage}}.OpenApiGeneratorApplication.jsonNullableModule")
    public Module jsonNullableModule() {
        return new JsonNullableModule();
    }
{{/openApiNullable}}

}
```

**Why this is critical:** This template ensures proper Spring Boot application generation with correct package scanning and component configuration for the Santander Framework architecture.

### 🚨 CRITICAL: Packages and Classes Migration

### 🔄 Migrating Apache Camel Routes

### Step 13: Copy RouteBuilder Classes

#### Copy the classes that extend the RouteBuilder class

- **From:** `com.santander.gluon.demo.route`
- **To:** `com.santander.demo.infrastructure.adapters.output.camel`

See the example directory structure below:

```plaintext
src/
└── main/
    └── java/
        └── com/
            └── santander/
                └── demo/
                    └── infrastructure/
                        └── adapters/
                            └── output/
                                └── camel/
                                    ├── UsersPOSTRouteBuilder.java
                                    ├── UsersGETRouteBuilder.java
                                    ├── UsersUserIdPUTRouteBuilder.java
                                    ├── UsersUserIdDELETERouteBuilder.java
                                    └── UsersUserIdGETRouteBuilder.java
```

### Step 14: Update Package Declarations

#### Update the package of the copied classes

The package name must match the directory structure where the class is located.

**Example:**

- **From:** `package com.santander.gluon.demo.route;`
- **To:** `package com.santander.demo.infrastructure.adapters.output.camel;`

### Step 15: Create Processor Directory

#### Create processor directory and copy Processor classes

- Create directory: `src/main/java/com/santander/demo/infrastructure/adapters/output/camel/processor`
- Copy all classes that implement the Processor class into this directory

See the example directory structure below:

```plaintext
src/
└── main/
    └── java/
        └── com/
            └── santander/
                └── demo/
                    └── infrastructure/
                        └── adapters/
                            └── output/
                                └── camel/
                                    └── processor/
                                        ├── TransformUsersUserIdPUTRequest.java
                                        ├── TransformUsersPOSTResponse.java
                                        ├── TransformUsersUserIdGETResponse.java
                                        ├── TransformUsersPOSTRequest.java
                                        ├── TransformUsersGETResponse.java
```

### Step 16: Update Processor Package Declarations

#### Update the package of the copied processor classes

**Example:**

- **From:** `package com.santander.gluon.demo.processor;`
- **To:** `package com.santander.demo.infrastructure.adapters.output.camel.processor;`

### Step 17: Update RouteBuilder Import References

#### Update import references in RouteBuilder classes

In the classes that implement RouteBuilder copied in step 13, update the import references to the new path of the classes inside the processor directory.

**Example:**

- **From:** `import com.santander.gluon.demo.processor.TransformUsersGETResponse;`
- **To:** `import com.santander.demo.infrastructure.adapters.output.camel.processor.TransformUsersGETResponse;`

### Step 18: Create Error Processor Directory

#### Create error directory inside processor

- Create directory: `src/main/java/com/santander/demo/infrastructure/adapters/output/camel/processor/error`

### Step 19: Copy Error Processor Classes

#### Copy error processor classes

- **From:** `src/main/java/com.santander.gluon.demo.processor.error`
- **To:** `src/main/java/com.santander.demo.infrastructure.adapters.output.camel.processor.error`

See the example directory structure below:

```plaintext
src/
└── main/
    └── java/
        └── com/
            └── santander/
                └── demo/
                    └── infrastructure/
                        └── adapters/
                            └── output/
                                └── camel/
                                    └── processor/
                                        ├── TransformUsersUserIdPUTRequest.java
                                        ├── TransformUsersPOSTResponse.java
                                        ├── TransformUsersUserIdGETResponse.java
                                        ├── TransformUsersPOSTRequest.java
                                        ├── TransformUsersGETResponse.java
                                        └── error/
                                            ├── SocketTimeoutErrorProcessor.java
                                            └── ErrorProcessor.java
```

### Step 20: Update Error Processor Package Declarations

#### Update the package of the copied error processor classes

**Example:**

- **From:** `package com.santander.gluon.demo.processor.error;`
- **To:** `package com.santander.demo.infrastructure.adapters.output.camel.processor.error;`

### Step 21: Update RouteBuilder Error Import References

#### Update imports in RouteBuilder classes

Update the imports of the classes that extend the RouteBuilder class to reference the new path of the error processor classes.

**Examples:**

- **From:** `import com.santander.gluon.demo.processor.error.ErrorProcessor;`
- **To:** `import com.santander.demo.infrastructure.adapters.output.camel.processor.error.ErrorProcessor;`

- **From:** `import com.santander.gluon.demo.processor.error.SocketTimeoutErrorProcessor;`
- **To:** `import com.santander.demo.infrastructure.adapters.output.camel.processor.error.SocketTimeoutErrorProcessor;`

### 🚨 CRITICAL: Package Configuration Migration

### Step 22: Copy Configuration Classes

#### Copy configuration classes

- **From:** `src/main/java/com/santander/gluon/demo/config`
- **To:** `src/main/java/com/santander/demo/infrastructure/config`

### Step 23: Update Configuration Package Declarations

#### Update the package of the copied configuration classes

**Example:**

- **From:** `package com.santander.gluon.demo.config;`
- **To:** `package com.santander.demo.infrastructure.config;`

### Step 24: Copy OpenAPI Contract File

#### Copy the OpenAPI contract file

- **From:** `src/main/resources/openapi/user-contract.yaml`
- **To:** `src/main/resources/config/user-contract.yaml`

### Step 25: Update POM.xml OpenAPI Path Reference

#### Update the OpenAPI file path in pom.xml

**Example:**

- **From:** `<inputSpec>${project.basedir}/src/main/resources/config/openapi.yaml</inputSpec>`
- **To:** `<inputSpec>${project.basedir}/src/main/resources/config/user-contract.yaml</inputSpec>`

### 🚨 CRITICAL: Delegate Class Implementation

### Step 26: Create REST Delegate Implementation

#### Create the DelegateImpl class

- Create directory: `src/main/java/com/santander/demo/infrastructure/adapters/input/rest`
- Create DelegateImpl class to implement the correct interface generated in: `target/generated-sources/openapi/src/main/java/com/santander/demo/infrastructure/adapters/input/rest/**[ApiDelegate].java`

### Step 27: Implement API Delegate Interface

#### After implementing the UsersApiDelegate

- Use the CamelAdapterInputPort to invoke methods of your implementation

### Step 28: Add Required Annotations

#### The DelegateImpl must contain these annotations

```java
@Service
@Slf4j
@RequiredArgsConstructor
```

### Step 29: Update DTO Imports

#### Imports from DTO classes must reference classes generated by OpenAPI

### 🚨 CRITICAL: UseCase Interface Creation

### Step 30: Create UseCase Interface

#### Create the interface named CamelAdapterUseCase.java

- Directory: `src/main/java/com/santander/demo/application/usecases`

See the example directory structure below:

```plaintext
src
└── main
    └── java
        └── com
            └── santander
                └── demo
                    ├── application
                    │   ├── usecases
                    │   └── CamelAdapterUseCase.java
```

### Step 31: Add Package Declaration

#### Add the package declaration

```java
package com.santander.demo.application.usecases;
```

### Step 32: Add TODO Documentation

#### Mark this interface with a Javadoc comment

```java
/**
 * TODO: Change the name of the interface according to the domain or functionality it will represent.
 * Ex: UserManagementUseCase.
 */
```

### Step 33: Define Interface Methods

#### For each method created in the ApiDelegateImpl, create an equivalent

```java
public interface CamelAdapterUseCase {
    PageableUser usersGET(String limit, String page, String age);
    void usersPOST(CreateUserType messageBody);
    void usersUserIdPUT(String userId, UpdateUserType updateData);
    void usersUserIdDELETE(String userId);
}
```

### Step 34: Add Required Imports

#### Add all necessary imports

```java
import com.santander.demo.infrastructure.adapters.input.rest.data.CreateUserType;
```

### Step 35: Create Method Documentation

#### Create Javadoc comments to explain the purpose, input parameters, and return of each method

### Step 36: Configure Dependency Injection

#### Use dependency injection to connect the implementation to the ApiDelegateImpl

```java
private final CamelAdapterUseCase useCase;
```

### Step 37: Add Interface Import to ApiDelegateImpl

#### Add the import of the interface

```java
import com.santander.demo.application.usecases.CamelAdapterUseCase;
```

### Create the implementation of the UseCase interface

Step 1:

- Create the class named CamelAdapterInputPort.java in the directory (src/main/java/com/santander/myapps/santanderfwk/application/ports/input).
See the example directory structure below.

Example:

```plaintext
src
└── main
    └── java
        └── com
            └── santander
                └── myapps
                    └── santanderfwk
                        ├── application
                        │   ├── ports
                        │   │   ├── input
                        │   │   │   └── CamelAdapterInputPort.java
```

Step 2:

- Add the package declaration to the newly created class. The package name must match the directory structure where the class is located.

Example:

``` java
package com.santander.myapps.santanderfwk.application.ports.input;
```

Step 3:

- Add the implementation of the CamelAdapterUseCase interface.

Example:

``` java
public class CamelAdapterInputPort implements CamelAdapterUseCase {}
```

Step 4:

- Add the import of the interface added in step 3.

Example:

``` java
import com.santander.myapps.santanderfwk.application.usecases.CamelAdapterUseCase;
```

Step 5:

- Use the annotations @Service, @Slf4j, and @RequiredArgsConstructor in the class.

Example:

``` java
@Slf4j
@Service
@RequiredArgsConstructor
public class CamelAdapterInputPort implements CamelAdapterUseCase {}
```

Step 6:

- Add the import of the annotations added in step 5.

Example:

``` java
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
```

Step 8:

- For each method defined in the CamelAdapterUseCase interface, add its implementation.

Example:

``` java
@Override
public PageableUser usersGET(String limit, String page, String age) {
    log.info("Executing usersGET use case: limit={}, page={}, age={}", limit, page, age);
    return camelAdapterOutputPort.usersGET(limit, page, age);
}
```

### Create the OutputPort Interface

Step 1:

- Create the interface named CamelAdapterOutputPort.java in the directory (src/main/java/com/santander/myapps/santanderfwk/application/ports/output).
See the example directory structure below.

Example:

``` plaintext
src
└── main
    └── java
        └── com
            └── santander
                └── myapps
                    └── santanderfwk
                        ├── application
                        │   ├── ports
                        │   │   ├── input
                        │   │   └── output
                        │   │       ├── CamelAdapterOutputPort.java
```

Step 2:

- Add the package declaration to the newly created class. The package name must match the directory structure where the class is located.

Example:

``` java
package com.santander.myapps.santanderfwk.application.ports.output;
```

Step 3:

- Mark this interface with a javadoc comment of type "TODO:", containing the text: Change the name of the interface according to the domain or functionality it will represent Ex: CamelAdapterOutputPort.

Step 4:

- Use dependency injection to add the interface to CamelAdapterInputPort.java.

Example:

``` java
private final CamelAdapterOutputPort camelAdapterOutputPort;
```

Step 5:

- Add the import of the interface added in step 4 to camelAdapterOutputPort.

Example:

``` java
import com.santander.myapps.santanderfwk.application.ports.output.CamelAdapterOutputPort;
```

### Create the InputPort Class

Step 1:

- Create the class named CamelAdapterInputPort.java in the directory (src/main/java/com/santander/myapps/santanderfwk/application/ports/input)
See the example directory structure below.

Example:

``` plaintext
src
└── main
    └── java
        └── com
            └── santander
                └── myapps
                    └── santanderfwk
                        ├── application
                        │   ├── ports
                        │   │   ├── input
                        │   │   │   └── CamelAdapterInputPort.java
                        │   │   └── output
```

Step 2:

- The package name must match the directory structure where the class is located.

Example:

``` java
package com.santander.myapps.santanderfwk.application.ports.input;
```

Step 3:

- Add the implementation of the CamelAdapterUseCase interface.

Example:

``` java
public class CamelAdapterInputPort implements CamelAdapterUseCase
```

Step 4:

- Add the import of the interface added in step 3.

Example:

``` java
import com.santander.myapps.santanderfwk.application.usecases.CamelAdapterUseCase;
```

Step 5:

- Use the annotations @Service, @Slf4j, and @RequiredArgsConstructor in the class.

Example:

``` java
@Slf4j
@Service
@RequiredArgsConstructor
public class CamelAdapterInputPort implements CamelAdapterUseCase {}
```

Step 6:

- Add the import of the annotations added in step 5.

Example:

``` java
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
```

Step 8:

- For each method in the CamelAdapterUseCase interface, add the implementation.

Example:

``` java
@Override
public PageableUser usersGET(String limit, String page, String age) {
    log.info("Executing usersGET use case: limit={}, page={}, age={}", limit, page, age);
    return camelAdapterOutputPort.usersGET(limit, page, age);
}
```

### Create the Adapter Class

Step 1:

- Create the class named CamelAdapter.java in the directory (src/main/java/com/santander/myapps/santanderfwk/infrastructure/adapters/output/camel/)
See the example directory structure below.

Example:

``` plaintext
src
└── main
    └── java
        └── com
            └── santander
                └── myapps
                    └── santanderfwk
                        ├── application
                        ├── domain
                        ├── infrastructure
                        │   ├── config
                        │   ├── adapters
                        │   │   └── output
                        │   │       └── camel
                        │   │           ├── CamelAdapter.java
```

Step 2:

- Add the package declaration to the newly created class. The package name must match the directory structure where the class is located.

Example:

``` java
package package com.santander.myapps.santanderfwk.infrastructure.adapters.output.camel;
```

Step 3:

- Add CamelAdapterOutputPort interface implementation.

Example:

``` java
public class CamelAdapter implements CamelAdapterOutputPort
```

Step 4:

- Use the annotations @Service, @Slf4j, and @RequiredArgsConstructor in the class.

Example:

``` java
@Slf4j
@Component
@RequiredArgsConstructor
public class CamelAdapter implements CamelAdapterOutputPort {}
```

Step 5:

- Add the import of the annotations added in step 5.

Example:

``` java
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
```

Step 6:

- Use dependency injection to add the interface to ProducerTemplate.java.

Example:

``` java
@Autowired
private ProducerTemplate producerTemplate;
```

Step 7:

- Add the import of the annotations added in step 6.

``` java
import org.apache.camel.ProducerTemplate;
import org.springframework.beans.factory.annotation.Autowired;
```

Step 8:

- Identify the REST operations and their Camel endpoints. In the RouteBuilder, each REST operation (GET, POST, PUT, DELETE) ends with a .to("direct:TO_...").

Example:

``` plaintext
GET users → direct:TO_UsersGET
POST users → direct:TO_UsersPOST
GET /users/{userId} → direct:TO_UsersUserIdGET
PUT /users/{userId} → direct:TO_UsersUserIdPUT
DELETE /users/{userId} → direct:TO_UsersUserIdDELETE
```

Step 9:

- Create Java methods for each operation. In the CamelAdapter class, create public methods for each operation, using the ProducerTemplate to call the Camel routes.

Example:

``` java
public PageableUser usersGET(String limit, String page, String age);
public void usersPOST(CreateUserType messageBody);
public GetUser userGET(String userId);
public void usersUserIdPUT(String userId, UpdateUserType updateData);
public void usersUserIdDELETE(String userId);
```

Step 10:

- Map REST parameters to headers or body. In the CamelAdapter class, create a Map<String, Object> for the route/query/path parameters. Use requestBodyAndHeaders to send body and headers together.

Example:

``` java
Map<String, Object> params = new HashMap<>();
params.put("_limit", limit);
params.put("page", page);
params.put("age", age);
return producerTemplate.requestBodyAndHeaders(
        "direct:TO_UsersGET",
        null,
        params,
        PageableUser.class);
```

### Step 38: Delete MainRestRouteBuilder

#### Delete MainRestRouteBuilder class

- Reason: Replaced by CamelAdapter class and adapter pattern

### 🚨 CRITICAL: Security Configuration

### Step 39: Update Application Properties File Location

#### The properties file must be in the `/resources/config/` directory

### Step 40: Configure Application Properties

#### The properties must contain the following settings

``` yaml
spring.profiles.active: local
---
spring:
  application:
    name: santander-fwk-camel
  session:
    store-type: none
  cache:
    type: CAFFEINE #Activated cache caffeine by default (If you want to change the cache to JBoss DataGrid, check the documentacion in confluence)
    caffeine:
      spec: expireAfterWrite=10m #Specifies that each entry should be automatically removed from the cache once that duration has elapsed after the entry's creation
  lifecycle.timeout-per-shutdown-phase: 2m

logging.level:
  com.santander.demo.OpenApiGeneratorApplication: INFO
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
```

### Step 41: Remove PKM Configuration

#### Remove pkm configuration

``` yaml
santander:
  [...]
  security:
    connectors:
      pkm-connector:
        pkm-endpoint:
          - ${env.pkm-endpoint}
```

### Step 42: Add RHSSO Variables

#### Add RHSSO variables before spring tag

``` yaml
RHSSO_HOST: https://login.azure.paas.santanderbr.dev.corp
RHSSO_REALM: corp
```

### Step 43: Add Spring Security Configuration

#### Add spring security configuration

``` yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: ${RHSSO_HOST}/auth/realms/${RHSSO_REALM}/protocol/openid-connect/certs
```

### Step 44: Delete SecurityConfig Class

#### Delete SecurityConfig class

- **Reason:** Replaced by security library and security configuration on properties file

### 🚨 CRITICAL: Tests Configuration

### Step 45: Create and Update Test Classes

#### Create the classes and implement the tests for your application

- Create test classes as needed for your business logic
- Update test structure: Reorganize tests to match new package structure
- Remove `@CamelSpringBootTest` annotations

### Step 46: Add ApplicationTestRun Class

#### Add ApplicationTestRun class using OpenApiGeneratorApplication

``` java
@SpringBootTest(classes =
    {OpenApiGeneratorApplication.class},
    webEnvironment = SpringBootTest.WebEnvironment.NONE,
    useMainMethod = SpringBootTest.UseMainMethod.WHEN_AVAILABLE
)
```

### 🚨 CRITICAL: Package Structure Cleanup

### Step 47: Remove Legacy Package Structure

#### Remove legacy package structure and all legacy files

- **Example:** `com.santander.gluon.demo`

### Step 48: Update Data Model Imports

#### Updated all data model imports

- Use generated OpenAPI classes instead of legacy model classes

**Why this is critical:** This ensures complete migration from the old Arsenal Integration architecture to the new Santander Framework hexagonal architecture, removing all legacy dependencies and ensuring clean separation of concerns.
