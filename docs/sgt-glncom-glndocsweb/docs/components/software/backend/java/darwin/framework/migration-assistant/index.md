# Darwin Migration Assistant ![6.4.x](https://img.shields.io/badge/6.4.x-FF073D)

## Introduction

`Darwin Migration Assistant` is a project based in the **[OpenRewrite](https://docs.openrewrite.org/)**[^1] plugin, which allows in a simple and transparent way
for the developer to migrate files, properties, dependencies and Java source code that have been modified from previous versions of
**Darwin Spring Boot**[^2] (or NUAR) and **Spring Boot** to the latest versions.

!!! Note "Use only for minor/major versions"

    The Migration Assistant project is intended to be used only for minor/major versions upgrades of Darwin Spring Boot.
    For patch versions, you can just upgrade the Darwin Parent version in your *pom.xml*.

## How to use

Darwin Migration Assistant includes a Maven plugin (`migration-assistant-maven-plugin`) to help you to **migrate your project
to the latest version of Darwin Spring Framework directly from command line**.

To use the plugin, you can run the plugin using the following command from you Darwin project root folder:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate
```

!!! tip "Set encoding for JVM"

    If you are using a Java version prior to Java 18 we recommend to set the **UTF-8** encoding for JVM to execute the recipes correctly.
    You can configure it using the **MAVEN\_OPTS** environment variable in the command line: `set MAVEN_OPTS=-Dfile.encoding=UTF-8`

!!! Note "Dynamic Darwin Spring Boot version"

    The plugin will always use the latest version of Darwin Spring Boot available in the [versions](../versions.md) file.
    The same command can migrate to different versions depending on the latest recipes available.

As the Migration Assistant plugin is an extension of the OpenRewrite plugin, you can still use the params provided by
[OpenRewrite Maven plugin](https://docs.openrewrite.org/reference/rewrite-maven-plugin#plugin-configuration).
E.g. to only migrate Java to Java 17, you can run the following command to define the recipe:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.UpgradeToJava17
```

### Use OpenRewrite Maven Plugin instead

**We recommend using the Migration Assistant Maven plugin from command line** to avoid configuring OpenRewrite and Migration Assistant
versions in your pom.xml. However, if you want to use the **OpenRewrite Maven plugin** and execute the **Darwin Migration Assistant Recipes**
to migrate to the latest Darwin version, you can do so by adding the following to the plugin section in your pom.xml:

{! include-markdown './migration-assistant-recipes/readme.md' start='<!tag:pluginConfig>' end='<!end:pluginConfig>' !}

!!! warning

    Using DarwinMigration recipe will migrate from Darwin 4 to the latest major version of Darwin Spring Boot.
    In case you wish to migrate from a previous version to the next one, please configure [this](migration-assistant-recipes/readme.md#migrate-from-older-versions).

{! include-markdown './migration-assistant-recipes/readme.md' start='<!tag:pluginExec>' end='<!end:pluginExec>' !}

You can find **more information about the recipes and how to configure them** in the [Darwin Migration Assistant Recipes document](migration-assistant-recipes/readme.md).

## Frequently Asked Questions

### Java FAQs

#### When to add @DarwinQualifier to RestTemplate and ObjectMapper

Darwin provides applications with a Bean of type **RestTemplate** and **ObjectMapper**, making use of the
**@DarwinQualifier** annotation. If the application handles different RestTemplate or ObjectMapper Beans,
we can use this annotation to ensure that we are referring to the Bean provided by Darwin.

Automatically, those variables or methods declared as RestTemplate or ObjectMapper are configured with the **@DarwinQualifier** annotation to access the Bean managed by DARWIN, except if by default the application has defined the **@Qualifier** annotation.

### Sonar FAQs

#### How to avoid critical issues

When five or more imports of the same package are updated in a class, the tool automatically groups the imports with an
asterisk. This can later cause a critical problem in Sonar. To avoid it, it is important to include the `NoStarImports` style
in the plugin configuration. If you are using the [Migration Assistant Maven plugin](#how-to-use) it's automatically configured,
but if you're using directly the OpenRewrite Maven plugin you must add it manually:

```xml
<plugin>
  <groupId>org.openrewrite.maven</groupId>
  <artifactId>rewrite-maven-plugin</artifactId>
  <version>plugin.version</version>
  <configuration>
    <activeRecipes>
      <recipe>recipe name apply</recipe>
    </activeRecipes>
    <activeStyles>
      <style>com.santander.darwin.migrationassistant.NoStarImports</style>
    </activeStyles>
  </configuration>
  <dependencies>
    <dependency>
      <groupId>com.santander.darwin</groupId>
      <artifactId>migration-assistant</artifactId>
      <version>ma.version</version>
    </dependency>
  </dependencies>
</plugin>
```

### Most frequent errors

#### How running Darwin Migration Assistant with JDK 17

The Darwin Migration Assistant is Java 17 compatible; but an error may occur when trying to run the tool with **JDK 17** if there is a Lombok dependency defined in the maven file (pom.xml) with a version that is not Java 17 compatible.

    [STDOUT] [INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ migration_to_java17 ---
    [STDOUT] [INFO] Changes detected - recompiling the module!
    [STDOUT] [INFO] Compiling 3 source files to C:\ma\target\maven-it\MAIT\toJava17\maven_project\project\target\classes
    [STDOUT] [INFO] ------------------------------------------------------------------------
    [STDOUT] [INFO] BUILD FAILURE
    [STDOUT] [INFO] ------------------------------------------------------------------------
    [STDOUT] [INFO] Total time:  42.572 s
    [STDOUT] [INFO] Finished at: 2023-01-09T11:16:26+01:00
    [STDOUT] [INFO] ------------------------------------------------------------------------
    [STDOUT] [ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project migration_to_java17: Fatal error compiling: java.lang.ExceptionInInitializerError: Unable to make field private com.sun.tools.javac.processing.JavacProcessingEnvironment$DiscoveredProcessors com.sun.tools.javac.processing.JavacProcessingEnvironment.discoveredProcs accessible: module jdk.compiler does not "opens com.sun.tools.javac.processing" to unnamed module @bd273b2 -> [Help 1]

To fix this problem you must manually update the Lombok version to be compatible with Java 17. According to the [projectlombok.org](https://projectlombok.org/changelog) changelog, Lombok supports Java 17 since version **1.18.22**.

#### We found duplicate dependencies or the parent is not updated correctly in the pom.xml file

When reviewing the generated **pom.xml** we see that the parent has not been updated to the latest version or we can see duplicated Darwin Framework dependencies.

We can also see when executing the plugin WARNINGS like the following indicating that it does not find the version of a Darwin library.

    [WARNING] Failed to determine version for es.santander.darwin:darwin-spring-boot-common. Initial value was null. Including POM is at RawMaven{from=file://C:\Users\n129586\workspace\leancore-codeTables-development\pom.xml / pom=RawPom(groupId=com.santander.darwin.codetables, artifactId=codetables, version=2.7.0-SNAPSHOT, snapshotVersion=null)}

To solve it we can add/replace the following mirror in the *settings.xml* file of the maven configuration used to run the plugin.

```xml
<mirrors>
  <mirror>
    <id>nexus</id>
    <url>http://nexus.alm.europe.cloudcenter.corp/repository/maven-public</url>
    <mirrorOf>central</mirrorOf>
  </mirror>
</mirrors>
```

#### Error with plugin org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources

After migrating the application, when compiling it, we encountered the following error:

    [ERROR] Failed to execute goal org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources (default-resources) on project api-authorization: Input length = 1 -> [Help 1]

This is because the latest versions of this plugin verify that the files they copy comply with the code page indicated in the **pom.xml**.

To identify the file with the wrong format you can run maven with the **-X** parameter.

    [DEBUG] Using 'UTF-8' encoding to copy filtered resource 'errors_es_ES.properties'.
    [DEBUG] filtering C:\Users\n129586\workspace\api-authorization\src\main\resources\errors\errors_es_ES.properties to C:\Users\n129586\workspace\api-authorization\target\classes\errors\errors_es_ES.properties
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD FAILURE
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  37.473 s
    [INFO] Finished at: 2022-01-24T13:23:13+01:00
    [INFO] ------------------------------------------------------------------------
    [ERROR] Failed to execute goal org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources (default-resources) on project api-authorization: Input length = 1 -> [Help 1]
    org.apache.maven.lifecycle.LifecycleExecutionException: Failed to execute goal org.apache.maven.plugins:maven-resources-plugin:3.2.0:resources (default-resources) on project api-authorization: Input length = 1

And to solve the problem you must add to the maven-resources-plugin the "propertiesEncoding" parameter with the correct encoding.

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-resources-plugin</artifactId>
  <configuration>
    <encoding>${project.build.sourceEncoding}</encoding>
    <propertiesEncoding>ISO-8859-1</propertiesEncoding>
  </configuration>
</plugin>
```

#### Error with plugin org.apache.maven.plugins:maven-compiler-plugin

After migrating the application to **Darwin Spring Boot 3.0.x**, when compiling it, we encountered the following error: ***Fatal error compiling: invalid flag: --release***

    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD FAILURE
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  37.473 s
    [INFO] Finished at: 2022-01-24T13:23:13+01:00
    [INFO] ------------------------------------------------------------------------
    [ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project spring-rest: Fatal error compiling: invalid flag: --release -> [Help 1]
    [ERROR]

This error occurs because a JDK not supported by the latest version of the **Darwin Spring Boot** framework is being used for the compilation. You can check the minimum requirements in the [**Darwin Spring Boot** documentation](../current/ABOUT.md#minimum-requirements).

To know the JDK version used to compile in maven you can use the command ***"mvn --version"***.

##### Command to check the JDK version used in maven

    C:\>mvn --version
    Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
    Maven home: C:\Users\x271091\Aplicaciones\apache-maven-3.6.3\bin\..
    Java version: 11.0.4, vendor: AdoptOpenJDK, runtime: C:\Users\x271091\Aplicaciones\java11_openjdk
    Default locale: es_ES, platform encoding: Cp1252
    OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"

#### Errors with the encoding. Some characters are incorrectly encoded

After performing the migration, extended characters, typically accents or ñ, appear badly coded in the configuration files.

To avoid this, it is important to perform the steps indicated in the following [chapter](./migration-assistant-recipes/readme.md#execute-recipes). Especially regarding the correct reporting of the environment variable **MAVEN\_OPTS**.

#### Do not upgrade to the latest version of the Darwin Spring Boot framework

If you are having problems upgrading to the latest version of the Darwin Spring Boot framework,
it may be due to the cache that exists in the Darwin Migration Assistant tool.
To fix this you must delete the ***".rewrite-cache"*** folder that is created at your user level.

#### Could not resolve version for \[GroupArtifact(groupId=io.grpc, artifactId=grpc-core)\]

When you want to migrate to a 3.0.x or higher version of Darwin Framework, sometimes the following error occurs:

    [ERROR] Failed to execute goal org.openrewrite.maven:rewrite-maven-plugin:4.37.0:run (default-cli) on project migration_to_darwin_3: Execution default-cli of goal org.openrewrite.maven:rewrite-maven-plugin:4.37.0:run failed: Could not resolve version for [GroupArtifact(groupId=io.grpc, artifactId=grpc-core)] matching version requirements RangeSet={[1.43.0,1.43.0]} -> [Help 1]

This is caused by the presence of the "darwin-spring-boot-starter-sagacity" library in the maven file. To fix it, comment out this library before migrating.

## Known limitations

The following limitations have been found and should be taken into account. In these cases, manual changes will be required after the automation has run if needed.

### Maven POM

#### OpenAPI Generator Maven Plugin for Spring Boot 3.X

If you are using the **OpenAPI Generator Maven Plugin** to generate the API client,
when you migrate a **Darwin Spring Boot** version based on **Spring Boot 3.x**, you must update the plugin configuration
to add the `useSpringBoot3` option to the `configOptions` section inside the `configuration` tags.
This is necessary to ensure that the generated code is compatible with Spring Boot 3.x.

```pom.xml
</configuration>
    <configOptions>
        <useSpringBoot3>true</useSpringBoot3>
        ...
    </configOptions>
</configuration>
```

#### Omnichannel User Agent from Darwin 4.x

From **Darwin Spring Boot Framework 4.1.0-RELEASE** `yauaa` library is not included in Omnichannel library by default and the **ContactPoint is not populated with User-Agent information**.

This feature has a **high memory cost at start-up**, and **we recommend don’t use it** if it’s not necessary.
If you need this feature you can include `com.santander.darwin:darwin-spring-boot-starter-omnichannel-ua-parser` instead
on "basic" Omnichannel starter manually.

#### Extended-Error error model deprecated

Extended-Error error model **has been deprecated in Darwin 4.1 and 3.2.9** in favor of Gluon error model (same structure
but *code* field is a String). To use it you have to configure `darwin.core.exceptions.error-format` to **GLUON**
and remove Extended-Error starter if not required.

!!! info

    Extended-Error error model was **removed in Darwin 4.0 and 3.2.7** but it was **recovered (and deprecated) in Darwin 4.1 and 3.2.9** to avoid issues from projects that were using it.

#### Resilience4J dependency Darwin 4.x or higher

Resilience4J has created a new library compatible with Spring Boot 3 (`resilience4j-spring-boot3`) as there was a
library compatible with Spring Boot 2 (**resilience4j-spring-boot2**), but at the moment there isn't a recipe to migrate
this. If you were configuring resilience4j-spring-boot2 directly in your pom there will be a conflict
because **Darwin is updated to Spring Boot 3 version**.

To solve this issue by now you have to **update your artifact and may be any Java import** or remove your resilience4j-spring-boot2 dependency (and get the new version from Darwin transitively).

#### Sagacity dependency Darwin 3.2.x or higher

In case of using the **Sagacity dependency**, it is not possible to migrate to version 3.2.x and higher of Darwin Framework.

### Java sources

#### Darwin Sprint Boot 5.x migration limitations

- Migrating `Darwin Batch` have some limitations:
  - The method constructor `LoggingChainProcessor(LoggingService<Void>, int)` had been deprecated and if being used, you will have to manually change it to `LoggingChainProcessor(int)` instead.
- Migrating `Darwin Security Authentication` have some limitations:
  - Class 'DefaultToken&lt;Token.TokenType, ? extends Serializable&gt;' declaration has now been modified, you will have to manually change it to `DefaultToken<Token.TokenType>` instead.

#### Darwin Sprint Boot 4.x migration limitations

- Migrating `Darwin Logging` have some limitations:
  - `LoggerReactiveContext` methods have been **deprecated**, and we recommend stop using those "logOnXXXX" to log in reactive applications, and using **manual instrumentation** (*tap* and *handle* operators) instead

!!! note

    You can find an example in [Darwin Migration guide](../current/MIGRATION-DETAILS.md#migrate-sleuth-context-propagation-in-reactive-applications)

- Migrating `Darwin Batch applications` have some limitations:
  - When migrating **JobBuilderFactory** and **StepBuilderFactory**, it will only migrate to **JobBuilder** and
    **StepBuilder** in the classes where the method "get" from those factories are used. For example, if you are
    injecting JobBuilderFactory Bean in a config class (A) and using it as argument for other class (B) constructor
    where you use the *get* method, it will only migrate the B class code.
  - When migrating **StepBuilderFactory**, in some methods, the argument will still present but not used, you can safely remove it manually along with its import statement.
  - Additionally, **StepBuilderFactory** migration process doesn't change the deprecated ***tasklet()*** nor ***chunk()*** methods. You must do it manually, injecting a `PlatformTransactionManager` Bean and add it to your Step.

#### Darwin Spring Boot 3.0 migration limitations

- When migrating from ***Sagacity archetype*** it is no longer mandatory to return a **SagaExecutionResult** as a
  response from the controller and the application is free to decide the format of the response. If you want to keep the
  error format that was automatically returned before, you must add the next `@ControllerAdvice`. More information
  [here](../current/MIGRATION-DETAILS.md#module-darwin-spring-boot-sagacity).
- In the ***Darwin Spring Boot Core*** module, the method **withDarwinContext** of class **ReactiveDarwinContextHolder**
  now it has a **DarwinContext** argument instead of **Mono&lt;DarwinContext&gt;**. You must update it manually.
  More information [here](../current/MIGRATION-DETAILS.md#module-darwin-spring-boot-core).
- In the ***Darwin Spring Boot Authentication*** module, several internal classes that should not be used have been
  removed. In case you make use of these classes, to continue using the authentication services,
  you must manually use the **TokenService** class. More information about how to use the TokenService class
  [here](../current/darwin-project/darwin-spring-boot-security-authentication/README.md#library-use-cases).
- In the ***Darwin Spring Boot Authentication*** module, the **getBKSCorpFromSecurityContextOrHeaderToken** and
  **getBKSTokenFromHeaders** methods disappear and must be manually replaced by the getBKSToken method of TokenService.
  More information on how to get the token [here](../current/darwin-project/darwin-spring-boot-security-authentication/README.md#how-to-get-tokens-in-the-application).

#### Migrating from SpringFox

- Only if you have multiple Docket beans, in SwaggerConfig, replace them with GroupedOpenApi beans. Also, if there is ApiInfo bean in SwaggerConfig, replace it with OpenAPI bean, else, add bean of OpenAPI type in SwaggerConfig class. More Info [here](https://springdoc.org/#migrating-from-springfox).

#### AuthenticationParameter constructor

- The AuthenticationParameters constructor is now private, so it cannot be instantiated. Replace with one of its static methods: **fromJWTToken, fromCorpToken, fromOcJwtToken or fromJocToken**. More information on how get the token [here](../current/darwin-project/darwin-spring-boot-security-authentication/README.md#how-to-get-tokens-in-the-application).

#### TokenConverter from NUAR to Darwin 2.x

When migrating from NUAR to Darwin 2.x, you must keep in mind that the ***TokenConverter*** class will always return a token when called or throw an exception if it cannot convert the object. In no case will it return a null object.

### Java Test sources

#### JUnit4 to JUnit5 Migration

Not every JUnit 4 feature or library has a direct JUnit 5 equivalent. In these cases, manual changes will be required after the automation has run. This list is not exhaustive.

- Currently, only the following implementations are taken into account when migrating @Rule, @ClassRule and @MethodRule annotations:
  - TestRule to TestInfo
  - Update MockWebServer
  - TemporaryFolder to TempDir
  - MockitoRule to MockitoExtension

!!! warning

    In case you use another implementation, please note that it will not be migrated correctly. In this case, the @Rule and @ClassRule annotations must be replaced by @ExtendWith and @RegisterExtension.

- Powermock has no JUnit 5 equivalent.
- The JUnit5 equivalent to JUnit4 ClassPathSuite is not yet released.
- `JUnitPlatform` (runner) is not removed from @RunWith annotations because it's already deprecated in JUnit4. You can replace it with `JUnit4` runner before the migration and it'll be removed as part of the migration process.

Further more information, [see](https://docs.openrewrite.org/tutorials/migrate-from-junit-4-to-junit-5#known-limitations).

## Other useful Upgrades

### Upgrade to JUnit 5 from JUnit 4

OpenRewrite provides a recipe that performs an automated migration from the venerable JUnit 4 testing framework to its successor JUnit 5.
JUnit is a popular tool with which many other libraries and frameworks interact.

!!! warning

    You only need to use this recipe if you are migrating to a 2.11.x version of Darwin Spring Boot. If we migrate to higher versions this recipe is already included.

In case you also want to migrate to JUnit 5 (Jupiter), you must also include the recipe **org.openrewrite.java.spring.boot2.SpringBoot2JUnit4to5Migration** as shown below:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipe=com.santander.darwin.migrationassistant.DarwinMigration_2_11,org.openrewrite.java.spring.boot2.SpringBoot2JUnit4to5Migration
```

!!! note

    **SpringBoot2JUnit4to5Migration** is a superset of the normal JUnit 4 to 5 and Mockito 1 to 3 recipes, with some additional Spring-specific functionality.
    If you activate this recipe it is not necessary to also activate the base JUnit or Mockito migration recipes.

For more information, see [OpenRewrite's JUnit Jupiter migration guide](https://docs.openrewrite.org/recipes/java/spring/boot2/springboot2junit4to5migration) for Spring Boot 2.x projects.

!!! warning

    Not every JUnit 4 feature or library has a direct JUnit 5 equivalent. In these cases, manual changes will be required after the automation has run.
    For more information you can consult the [known limitations](#java-test-sources) identified.

### Upgrade to Java 11 from Java 8

OpenRewrite provides a recipe that to perform an automated migration from Java 8 to Java 11.
In case you also want to migrate to Java 11, you must also include the recipe **org.openrewrite.java.migrate.Java8toJava11** as shown below:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipe=com.santander.darwin.migrationassistant.DarwinMigration,org.openrewrite.java.migrate.Java8toJava11
```

For more information, see [OpenRewrite's Java8 to Java11 migration guide](https://docs.openrewrite.org/recipes/java/migrate/java8tojava11).

[//]: # (TODO Why not using migrate-to-java-17 recipe?)

### Upgrade to Java 17

OpenRewrite provides a recipe that to perform an automated migration to Java 17.
In case you also want to migrate to Java 17, you must also include the recipe **com.santander.darwin.migrationassistant.UpgradeToJava17** as shown below:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipe=com.santander.darwin.migrationassistant.DarwinMigration,org.openrewrite.java.migrate.UpgradeToJava17
```

[//]: # (TODO Why not using migrate-to-java-21 recipe?)

### Upgrade to Java 21

OpenRewrite provides a recipe that to perform an automated migration to Java 21.
In case you also want to migrate to Java 21, you must also include the recipe **com.santander.darwin.migrationassistant.UpgradeToJava21** as shown below:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipe=com.santander.darwin.migrationassistant.DarwinMigration,org.openrewrite.java.migrate.UpgradeToJava21 -DplainTextMasks=.env,Dockerfile
```

- The &lt;plainTextMasks&gt; is needed for the recipe to recognize some files and correctly migrate to Java21. This is a temporary workaround and it will be removed soon

### Migrate Infinispan properties for Red Hat Data Grid 8.3

Darwin Migration Assistant provides a recipe for updating the infinispan configuration to use RHDG 8.3.
To execute said recipe, just include the recipe **com.santander.darwin.migrationassistant.darwinMigrateToRDHG_8_3**:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipe=com.santander.darwin.migrationassistant.darwinMigrateToRDHG_8_3
```

[^1]: OpenRewrite works by making changes to Abstract Syntax Trees (AST) representing your source code and printing the modified trees back into source code.
You can then review the changes in your code and commit.

[^2]: The latest version of the Darwin Spring Framework is available [here](../versions.md).
