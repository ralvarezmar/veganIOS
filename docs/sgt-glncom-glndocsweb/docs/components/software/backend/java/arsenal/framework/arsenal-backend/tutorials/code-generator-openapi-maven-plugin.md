# OpenAPI Generator for the arsenal-backend library {!include-markdown '../../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}

{!include-markdown '../../snippets/versions.md' start='<!tag:back-current>' end='<!end:back-current>'!}

## Overview

Arsenal Backend OpenAPI Code Generator is a code generator project that parses a
yaml contract with OAS 3.0 specifications and translates them into Java classes.
With this, the app and domain layers are generated with all the respective
classes defined in the contract. The main objective is to help the developer
with a start of coding the application's persistence layer, doing the boring and
repetitive work of creating entities, creating classes, associating Java
annotations and mapping between the app and domain layers.

## What's OpenAPI

The goal of OpenAPI is to define a standard, language-agnostic interface to REST
APIs which allows both humans and computers to discover and understand the
capabilities of the service without access to source code, documentation, or
through network traffic inspection. When properly described with OpenAPI, a
consumer can understand and interact with the remote service with a minimal
amount of implementation logic. Similar to what interfaces have done for
lower-level programming, OpenAPI removes the guesswork in calling the service.

Check out [OpenAPI-Spec](https://github.com/OAI/OpenAPI-Specification) for
additional information about the OpenAPI project, including additional libraries
with support for other languages and more.

## How do I use this?

To use the Arsenal Backend OpenAPI Code Generator, we must declare the plugin
within the pom.xml. In versions of Framework Arsenal, starting from 2.X, we
already use the Open API plugin, so just add one more execution.

### Plugin declaration

```xml
<properties>
    <springApiPackage>your.package.api</springApiPackage>
    <springModelPackage>your.package.model</springModelPackage>
    <backendApiArsenalPackage>your.package</backendApiArsenalPackage>
    <backendModelArsenalPackage>your.package.domain.entity</backendModelArsenalPackage>
    <openApiContractFile>${project.basedir}/src/main/resources/openapi.yaml</openApiContractFile>
</properties>

<!-- <springApiPackage> : Package where we need to generate the spring API files in target folder -->
<!-- <springModelPackage> : Package where we need to generate the spring Model (DTOs) files in target folder -->
<!-- <backendApiArsenalPackage> : Package where we generate files in source folder for app and domain layers -->
<!-- <backendModelArsenalPackage> : Package where we generate entities for domain layer -->

<!-- Be careful to follow the same definition standards as the packages above, changing only your.package! -->
<!-- <openApiContractFile> It's the path to your contract. Both executions will use the same contract! -->

<plugin>
    <groupId>org.openapitools</groupId>
    <artifactId>openapi-generator-maven-plugin</artifactId>
    <version>7.2.0</version>
    <executions>
        <execution>
            <id>spring-generator</id>
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <skipValidateSpec>true</skipValidateSpec>
                <inputSpec>${openApiContractFile}</inputSpec>
                <generatorName>spring</generatorName>
                <apiPackage>${springApiPackage}</apiPackage>
                <modelPackage>${springModelPackage}</modelPackage>
                <supportingFilesToGenerate>ApiUtil.java</supportingFilesToGenerate>
                <templateDirectory>${project.basedir}/src/main/resources</templateDirectory>
                <configOptions>
                    <useSpringBoot3>true</useSpringBoot3>
                    <delegatePattern>true</delegatePattern>
                    <openApiNullable>false</openApiNullable>
                    <dateLibrary>java8</dateLibrary>
                    <generateBuilders>true</generateBuilders>
                    <booleanGetterPrefix>is</booleanGetterPrefix>
                    <hideGenerationTimestamp>true</hideGenerationTimestamp>
                    <useBeanValidation>false</useBeanValidation>
                    <useTags>true</useTags>
                    <useSwaggerAnnotations>false</useSwaggerAnnotations>
                    <async>true</async>
                    <returnResponse>true</returnResponse>
                    <additionalModelTypeAnnotations>@SuppressWarnings({"hiding", "static-method", "unused"})</additionalModelTypeAnnotations>
                </configOptions>
            </configuration>
        </execution>

        <execution>
            <id>arsenal-backend-code</id>
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <inputSpec>${openApiContractFile}</inputSpec>
                <generatorName>arsenal-backend</generatorName>
                <apiPackage>${backendApiArsenalPackage}</apiPackage>
                <modelPackage>${backendModelArsenalPackage}</modelPackage>
                <generateSupportingFiles>false</generateSupportingFiles>
                <output>src/main/java</output>
                <configOptions>
                    <useSpringBoot3>true</useSpringBoot3>
                    <delegatePattern>true</delegatePattern>
                    <openApiNullable>false</openApiNullable>
                    <dateLibrary>java8</dateLibrary>
                    <generateBuilders>true</generateBuilders>
                    <booleanGetterPrefix>is</booleanGetterPrefix>
                    <hideGenerationTimestamp>true</hideGenerationTimestamp>
                    <useBeanValidation>false</useBeanValidation>
                    <useTags>true</useTags>
                    <useSwaggerAnnotations>false</useSwaggerAnnotations>
                    <async>true</async>
                    <returnResponse>true</returnResponse>
                    <additionalModelTypeAnnotations>@lombok.Data</additionalModelTypeAnnotations>
                </configOptions>
                <additionalProperties>appApiPackage=${springApiPackage},appApiModelPackage=${springModelPackage}</additionalProperties>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.santander.ars</groupId>
            <artifactId>gln-back-arsenal-backend-openapi-generator</artifactId>
            <version>{!include-markdown '../../snippets/versions.md' start='<!tag:back-version>' end='<!end:back-version>'!}</version>
        </dependency>
    </dependencies>
</plugin>
```

Note that both executions use the same patterns and configurations, with the
main differences being for the generatorName and the output, where in the
arsenal-backend generator, we generate the code within src/main/java, that is,
we generate executable code and not inside the target folder.

### Plugin execution

The plugin's execution lifecycle is for the generate-sources phase, so to run
it, simply execute the following command:

```bash
mvn generate-sources
```

When executing the above command, notice that in the src/main/java/your/package
directory, packages were generated within app, domain, and some classes within
infra that will link with the database layer, leaving you with the following
structure:

```bash
.
|- pom.xml
|-- src
|--- main
|---- java
|----- your.package
|------ app
|------- mapper
|------- resource
|------- service
|------ domain
|------- entity
|------- usecase
|------ infra
|------- dataprovider
|-------- mapper
```

After that, simply adjust and correct any project needs, and apply your business
rules! If you do not want the plugin to run again, overwriting any changes made,
simply remove the plugin from running.
