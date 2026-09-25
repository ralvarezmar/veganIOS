# Arsenal Integration OpenAPI Maven Plugin {!include-markdown '../../snippets/versions.md' start='<!tag:int-version-schema>' end='<!end:int-version-schema>'!}

{!include-markdown '../../snippets/versions.md' start='<!tag:int-current>' end='<!end:int-current>'!}

### Description

Arsenal Integration OpenAPI Maven Plugin includes a helper for the rapid creation of camel routes and processors based on the OpenAPI contract.

### Java support

By default, the plugin uses Java 17 during the generation process.

!!! info "Important"

    It is important to note that only Java 17 is compatible with Arsenal Integration versions 4.x.y.

### Maven support

When generating source code, it is required to have a minimum version of Maven 3.8.x.

### Configuration

When using the [`Arsenal Integration Rest Archetype`](archetype-rest.md), some properties have default values assigned to them.

#### OpenAPI Contract Path

When using the archetype, the `openapi-contract-path` property is set by default as shown below:

    <properties>
        <openapi-contract-path>${basedir}/src/main/resources/openapi/user-contract.yaml</openapi-contract-path>
    </properties>

The purpose of this property is to specify the location of our OpenAPI contract.

#### Properties

| Property  | Default value | Details |
| --- | --- | --- |
| skip | false | Determines whether the plugin is executed. |
| fileSwaggerYamlJsonLocation | empty | Location of the OpenAPI file. |
| rootPackageClass | empty | Directory where the generated classes are located. |
| outputGeneratedClasses | empty | Root source directory, generally  `{sourceDirectory}/src/main/java`. |
| outputGeneratedTestClasses | empty | Directory of the generated test classes. |
| isGluon | false | When true, the plugin generates routes with gluon dependency and default error processor. |
| skipOverwrite | false | When true, the plugin the will not replace an existing file with the same name |
| historicEnabled | false | When true, all files from `rootPackageClass` are copied to `arsenal-integration` folder in root project |

???+ Warning

    If the `skipOverwrite` property is set to false, which is the default value, any changes made will be lost when running the `mvn generate-sources` command.

### Generating from OpenAPI Contract

Code generation is achieved using the custom plugin `gln-back-arsenal-integration-openapi-maven-plugin`. The first step is to configure the plugin.

#### Configuration

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
                    <skip>false</skip>
                    <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                    <rootPackageClass>com.santander.gluon.demo.rest</rootPackageClass>
                    <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                    <outputGeneratedTestClasses>${project.build.testSourceDirectory}</outputGeneratedTestClasses>
                </configuration>
            </execution>
        </executions>
    </plugin>

Camel routes will be generated based on the openAPI file with this configuration.

#### Maven command

    mvn generate-sources

#### Resulting project

``` bash
📦project
 ┣ 📂src
 ┃ ┣ 📂main
 ┃ ┃ ┣ 📂java
 ┃ ┃ ┃ ┗ 📂com
 ┃ ┃ ┃ ┃ ┗ 📂santander
 ┃ ┃ ┃ ┃ ┃ ┗ 📂gluon
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂demo
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂rest
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂processor
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂error
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜ErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜SocketTimeoutErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersPOSTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersUserIdGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜TransformUsersUserIdPUTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂route
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜MainRestRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersPOSTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdDELETERouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜UsersUserIdPUTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜IntegrationApplication.java
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┣ 📂openapi
 ┃ ┃ ┃ ┃ ┗ 📜user-contract.yaml
 ┃ ┃ ┃ ┗ 📜application.yml
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┗ 📜application.yml
 ┣ 📜pom.xml
```

### Generating from OpenAPI Contract with skipOverwrite property

When using this configuration, the plugin will no longer overwrite classes with the same name. This is particularly useful when updating the openapi contract with new functionalities.

#### Configuration

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
                    <skip>false</skip>
                    <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                    <rootPackageClass>com.santander.gluon.demo.rest</rootPackageClass>
                    <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                    <outputGeneratedTestClasses>${project.build.testSourceDirectory}</outputGeneratedTestClasses>
                    <skipOverwrite>true</skipOverwrite>
                </configuration>
            </execution>
        </executions>
    </plugin>

#### Maven command

    mvn generate-sources

#### Resulting project

``` bash
📦project
 ┣ 📂src
 ┃ ┣ 📂main
 ┃ ┃ ┣ 📂java
 ┃ ┃ ┃ ┗ 📂com
 ┃ ┃ ┃ ┃ ┗ 📂santander
 ┃ ┃ ┃ ┃ ┃ ┗ 📂gluon
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂demo
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂rest
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂processor
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂error
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜ErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜SocketTimeoutErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersPOSTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersUserIdGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜TransformUsersUserIdPUTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂route
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜MainRestRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersPOSTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdDELETERouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜UsersUserIdPUTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜IntegrationApplication.java
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┣ 📂openapi
 ┃ ┃ ┃ ┃ ┗ 📜user-contract.yaml
 ┃ ┃ ┃ ┗ 📜application.yml
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┗ 📜application.yml
 ┣ 📜pom.xml
```

### Generating from OpenAPI Contract with isGluon property

When this configuration is used, the plugin will delegate error handling to `Arsenal Integration Gluon Error Starter`, and no ErrorProcessor.java class will be generated.

#### Configuration

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
                    <skip>false</skip>
                    <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                    <rootPackageClass>com.santander.gluon.demo.rest</rootPackageClass>
                    <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                    <outputGeneratedTestClasses>${project.build.testSourceDirectory}</outputGeneratedTestClasses>
                    <skipOverwrite>true</skipOverwrite>
                    <isGluon>true</isGluon>
                </configuration>
            </execution>
        </executions>
    </plugin>

#### Maven command

    mvn generate-sources

#### Resulting project

``` bash
📦project
 ┣ 📂src
 ┃ ┣ 📂main
 ┃ ┃ ┣ 📂java
 ┃ ┃ ┃ ┗ 📂com
 ┃ ┃ ┃ ┃ ┗ 📂santander
 ┃ ┃ ┃ ┃ ┃ ┗ 📂gluon
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂demo
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂rest
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂processor
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂error
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜SocketTimeoutErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersPOSTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersUserIdGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜TransformUsersUserIdPUTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂route
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜MainRestRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersPOSTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdDELETERouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜UsersUserIdPUTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜IntegrationApplication.java
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┣ 📂openapi
 ┃ ┃ ┃ ┃ ┗ 📜user-contract.yaml
 ┃ ┃ ┃ ┗ 📜application.yml
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┗ 📜application.yml
 ┣ 📜pom.xml
```

### Generating from OpenAPI Contract with historicEnabled property

By using this configuration, the plugin will generate a folder to store all update history.

#### Configuration

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
                    <skip>false</skip>
                    <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                    <rootPackageClass>com.santander.gluon.demo.rest</rootPackageClass>
                    <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                    <outputGeneratedTestClasses>${project.build.testSourceDirectory}</outputGeneratedTestClasses>
                    <isGluon>true</isGluon>
                    <skipOverwrite>true</skipOverwrite>
                    <historicEnabled>true</historicEnabled>
                </configuration>
            </execution>
        </executions>
    </plugin>

#### Maven command

    mvn generate-sources

#### Resulting project

``` bash
📦project
 ┣ 📂arsenal-integration
 ┃ ┗ 📂2023-10-30-18-24-29
 ┃ ┃ ┣ 📂processor
 ┃ ┃ ┃ ┣ 📂error
 ┃ ┃ ┃ ┃ ┣ 📜ErrorProcessor.java
 ┃ ┃ ┃ ┃ ┗ 📜SocketTimeoutErrorProcessor.java
 ┃ ┃ ┃ ┣ 📜TransformUsersGETResponse.java
 ┃ ┃ ┃ ┣ 📜TransformUsersPOSTRequest.java
 ┃ ┃ ┃ ┣ 📜TransformUsersUserIdGETResponse.java
 ┃ ┃ ┃ ┗ 📜TransformUsersUserIdPUTRequest.java
 ┃ ┃ ┣ 📂route
 ┃ ┃ ┃ ┣ 📜MainRestRouteBuilder.java
 ┃ ┃ ┃ ┣ 📜UsersGETRouteBuilder.java
 ┃ ┃ ┃ ┣ 📜UsersPOSTRouteBuilder.java
 ┃ ┃ ┃ ┣ 📜UsersUserIdDELETERouteBuilder.java
 ┃ ┃ ┃ ┣ 📜UsersUserIdGETRouteBuilder.java
 ┃ ┃ ┃ ┗ 📜UsersUserIdPUTRouteBuilder.java
 ┃ ┃ ┗ 📜application.yml
 ┣ 📂src
 ┃ ┣ 📂main
 ┃ ┃ ┣ 📂java
 ┃ ┃ ┃ ┗ 📂com
 ┃ ┃ ┃ ┃ ┗ 📂santander
 ┃ ┃ ┃ ┃ ┃ ┗ 📂gluon
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂demo
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂rest
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂processor
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂error
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜SocketTimeoutErrorProcessor.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersPOSTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜TransformUsersUserIdGETResponse.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜TransformUsersUserIdPUTRequest.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📂route
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜MainRestRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersPOSTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdDELETERouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜UsersUserIdGETRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜UsersUserIdPUTRouteBuilder.java
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜IntegrationApplication.java
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┣ 📂openapi
 ┃ ┃ ┃ ┃ ┗ 📜user-contract.yaml
 ┃ ┃ ┃ ┗ 📜application.yml
 ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┗ 📜application.yml
 ┣ 📜pom.xml
```
