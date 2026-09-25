# Darwin Spring Boot Migration Guide

## Migration Guide from a Darwin Spring Boot Application to Santander Spring Boot

This guide summarizes the necessary changes to migrate an application
from the `darwin-spring-boot` to `santander-spring-boot` framework.
In order to use the new framework, it is necessary to update a set of files,
components, and references used by the applications.

!!! note

    To make the migration successfully, the minimum version used of **Darwin Spring Boot** must be `6.3.x`.
    To migrate to the last version of **Darwin Spring Boot**,
    please check the [Darwin Migration Assistant section](../../../darwin/framework/migration-assistant/index.md).
    The migration target version of this guide is `1.y.x` of **Santander Spring Boot**.

!!! tip

    This migration guide is valid for migrating both Darwin Spring Boot Microservices and Darwin Spring Boot Libraries.

## Migrate using the Migration Assistant

### Prerequisites

To start the migration of the microservice or library,
you need to check if there are Darwin Spring Boot libraries in the `pom.xml`,
and you must ensure that the project complies with these **two mandatory requirements**:

1. Ensure that the microservice or library is at least on Darwin Spring Boot version 6.3.x.

2. Execute the `Update workflow` on the default branch.

   If you are using a previous version of the **Darwin Java Microservice template** where the `migration workflows` weren't available,
   you must execute the `Update workflow` **as many times as necessary** to update the component to the latest version of Gluon Workflows.
   When you have the latest version of the workflows,
   you will have the `Migrate to Santander Component` and `Migrate to Santander Framework 1.X` workflows available.
   The `Update workflow` is located in the `Actions` tab in the GitHub repository.

!!! warning "Important"

    With an earlier version of the Update workflow, it may be necessary to fill in a `Component template's version to update` field, 
    but this one is currently unused, so we can provide any value, for example, `1.0.0`.
    The Update workflow should be run on the default branch (main or development depending on the branch strategy selected).

If so, you should migrate them to the Santander Spring Boot Framework before continuing with the migration.

!!! note

    If the `pom.xml` contains a reference to the `darwin-migration-assistant-maven-plugin`,
    it is recommended to remove it so that the latest version is used automatically.

Once you have ensured that the project is at the required minimum version,
have some Darwin Spring Boot dependencies, and the Gluon workflows are updated to the last version
having the migration workflows available,
you can proceed to run the automatic migration with some of the following methods:

#### Using command line

You have to run the following command in the terminal at the root of the project:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.UpgradeToSantanderFramework
```

!!! warning

    If you are using the PowerShell terminal, you must use a single quote (') or double quotes (") to define the maven parameter value,
    as shown below:

    ```shell
    mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate '-Drewrite.activeRecipes=com.santander.darwin.migrationassistant.UpgradeToSantanderFramework'
    ```

After executing the command, the migration changes will be applied directly to the project files.
You must review the changes
and commit them to your repository using for example a new branch `feature/`+BaseBranch+`-santander-fwk`.

You must open a new Pull Request (you could use as title `feat: migrate to Santander Framework 1.X`) containing the
changes made by the migration assistant.
The Pull Request should point at the default branch according to the branch strategy selected for the component.

#### Using the 'Migrate to Santander Framework 1.X' workflow

- **1. Select the Action's tab.** Go to the project GitHub repository and click on the 'Actions' tab present above the
  repository name.

- **2. Locate the Migrate to Santander Framework 1.X.** On the following screen, you will see the latest executions and
  on the upper left corner is provided the workflows of this repository. Select the 'Migrate to Santander Framework 1.X'
  workflow.

- **3. Run the Migrate to Santander Framework 1.X.** After the selection, it will be shown the message 'This workflow
  has a workflow_dispatch event trigger' and a new button will appear. Select the 'Run Workflow' button.

!!! note

    We recommend running the workflow on the default branch according to the branch strategy selected for the component.

!!! warning

    The `migrate-to-santander-fwk.yml` workflow is added to version `1.5.0` of this component.
    Remember that you need to update it first using the `update-component-workflow.yml`
    [workflow](../../../../../../../application/component-management/update-component.md#updating-your-component).

If everything goes well, a Pull Request named `feat: migrate to Santander Framework 1.X` will be generated with the
changes made by the migration assistant. The Pull Request will use as base the branch from which the workflow was
launched and as source a new branch named BaseBranch+`-santander-fwk`.

!!! note

    In case the Pull Request already exists or the source branch already exists, the workflow will fail.

### Executing the 'Migrate to Santander Component' workflow

Once the Pull Request with the migration changes is approved and integrated into the base branch
(main or develop depending on the branch strategy selected),
the `Integration workflow` is executed automatically on the base branch
to verify that everything works correctly after the migration.
After the successful execution of the `Integration` workflow,
the `Migrate to Santander Component` workflow will be executed
to migrate the component template from **Darwin Spring Boot template** the **Santander Spring Boot template**.

When the process finishes successfully,
the `Migrate to Santander Component` workflow also removes the migration workflows
(`Migrate to Santander Component` and `Migrate to Santander Framework 1.X`) from the repository.
If the project is using the Git Flow strategy,
the migration changes will be taken from the develop branch to the main branch automatically.
This operation doesn't execute any workflow after merging the changes.
It is necessary to do this to have the same Gluon Workflows updated in both branches: main and develop.

!!! warning "Important"

    If the project is using `Git Flow` as branch strategy and the default branch is `development`,
    once the `Migrate to Santander Component` workflow is executed,
    and the migration changes are merged into the main branch,
    **the Release workflow is not launched automatically**.
    Therefore, **if you want to integrate and deploy a new version of the component,
    you must integrate a new Pull Request with some changes in the main branch to trigger the CI/CD workflow again**.

### Review after the migration

After the automatic migration, it is recommended to review the following points:

- Check the code for any usage of the `@Value` annotation that injects Darwin configuration properties. Update these references to use the new `santander.*` properties if necessary.
- Ensure that all configuration properties have been migrated from the `darwin.*` namespace to `santander.*`. Verify that the application does not introduce new properties under the `darwin.*` domain.

## Migrate in a manual way

### How to update the `pom.xml` file

To migrate the `pom.xml` file from **Darwin Spring Boot** to **Santander Spring Boot**,
as general rule, it is necessary to update the `groupId`,
`artifactId`, and `version` of all the dependencies, and parent:

| **Tag**    | **Old**              | **New**                            |
|------------|----------------------|------------------------------------|
| groupId    | com.santander.darwin | com.santander.framework.springboot |
| artifactId | darwin-spring-boot-x | santander-spring-boot-x            |
| version    | 6.3.x                | 1.y.x                              |

The `groupId` must be updated from `com.santander.darwin` to `com.santander.framework.springboot`.
The `artifactId` must be updated to reflect the new prefix in the name of the artifacts,
from `darwin-spring-boot-*` to `santander-spring-boot-*`.
The `version` must be updated from the `6.3.x` release of **Darwin Spring Boot**
to the latest version of **Santander Spring Boot**, which is `1.y.x` or later.

!!! note

    As best practice, the version should be defined only in the parent section.

The dependencies must be updated as follows:

For example, from a **Darwin Spring Boot** starter parent:

```xml
<parent>
    <groupId>com.santander.darwin</groupId>
    <artifactId>darwin-spring-boot-starter-parent</artifactId>
    <version>6.3.4</version>
</parent>
```

To the **Santander Spring Boot** starter parent:

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-parent</artifactId>
    <version>1.2.1</version>
</parent>
```

#### Parent section

Update the parent tag in the `pom.xml` files to use the new parents' artifact.

| **Old**                               | **New**                                  |
|---------------------------------------|------------------------------------------|
| darwin-spring-boot-dependencies       | santander-spring-boot-starter-parent     |
| darwin-spring-boot-starter-parent     | santander-spring-boot-starter-parent     |
| darwin-spring-boot-starter-parent-lib | santander-spring-boot-starter-parent-lib |

The parent tag must be updated as follows:

For example, from the **Darwin Spring Boot** parent:

```xml
<parent>
    <groupId>com.santander.darwin</groupId>
    <artifactId>darwin-spring-boot-starter-parent-lib</artifactId>
    <version>6.3.4</version>
</parent>
```

To the **Santander Spring Boot** parent:

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-parent-lib</artifactId>
    <version>1.2.1</version>
</parent>
```

#### Starters dependencies

Update the starters artifact names in the `pom.xml` files to reflect the new Santander naming convention.

| **Old**                                          | **New**                                             |
|--------------------------------------------------|-----------------------------------------------------|
| darwin-spring-boot-starter-core                  | santander-spring-boot-starter-core                  |
| darwin-spring-boot-starter-codetables            | santander-spring-boot-starter-codetables            |
| darwin-spring-boot-starter-events                | santander-spring-boot-starter-events                |
| darwin-spring-boot-starter-extended-error        | santander-spring-boot-starter-extended-error        |
| darwin-spring-boot-starter-graphql               | santander-spring-boot-starter-graphql               |
| darwin-spring-boot-starter-logging               | santander-spring-boot-starter-logging               |
| darwin-spring-boot-starter-logging-basic         | santander-spring-boot-starter-logging-basic         |
| darwin-spring-boot-starter-logging-kafka         | santander-spring-boot-starter-logging-kafka         |
| darwin-spring-boot-starter-logging-logback-basic | santander-spring-boot-starter-logging-logback-basic |
| darwin-spring-boot-starter-logging-logback-kafka | santander-spring-boot-starter-logging-logback-kafka |
| darwin-spring-boot-starter-metrics               | santander-spring-boot-starter-metrics               |
| darwin-spring-boot-starter-partenon              | santander-spring-boot-starter-partenon              |
| darwin-spring-boot-starter-test                  | santander-spring-boot-starter-test                  |
| darwin-spring-boot-starter-webservice            | santander-spring-boot-starter-webservice            |
| darwin-spring-boot-starter-cache                 | santander-spring-boot-starter-cache                 |
| darwin-spring-boot-starter-cache-base            | santander-spring-boot-starter-cache-base            |
| darwin-spring-boot-starter-cache-caffeine        | santander-spring-boot-starter-cache-caffeine        |
| darwin-spring-boot-starter-cache-infinispan      | santander-spring-boot-starter-cache-infinispan      |
| darwin-spring-boot-starter-authentication        | santander-spring-boot-starter-authentication        |
| darwin-spring-boot-starter-omnichannel           | santander-spring-boot-starter-omnichannel           |
| darwin-spring-boot-starter-authorization         | santander-spring-boot-starter-authorization         |
| darwin-spring-boot-starter-business-events       | santander-spring-boot-starter-business-events       |
| darwin-spring-boot-starter-batch                 | santander-spring-boot-starter-batch                 |

A starter dependency tags must be updated as follows:

For example, from the **Darwin Spring Boot** starter dependency:

```xml
<parent>
    <groupId>com.santander.darwin</groupId>
    <artifactId>darwin-spring-boot-starter-core</artifactId>
</parent>
```

To the **Santander Spring Boot** starter dependency:

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-core</artifactId>
</parent>
```

#### Libraries dependencies

Update the library dependencies in the `pom.xml` files to use the new artifact names.

| **Old**                                           | **New**                                              |
|---------------------------------------------------|------------------------------------------------------|
| darwin-spring-boot-core                           | santander-spring-boot-core                           |
| darwin-spring-boot-codetables                     | santander-spring-boot-codetables                     |
| darwin-spring-boot-events                         | santander-spring-boot-events                         |
| darwin-spring-boot-extended-error                 | santander-spring-boot-extended-error                 |
| darwin-spring-boot-graphql                        | santander-spring-boot-graphql                        |
| darwin-spring-boot-logging                        | santander-spring-boot-logging                        |
| darwin-spring-boot-logging-logback-basic          | santander-spring-boot-logging-logback-basic          |
| darwin-spring-boot-logging-logback-kafka-appender | santander-spring-boot-logging-logback-kafka-appender |
| darwin-spring-boot-metrics                        | santander-spring-boot-metrics                        |
| darwin-spring-boot-partenon                       | santander-spring-boot-partenon                       |
| darwin-spring-boot-test                           | santander-spring-boot-test                           |
| darwin-spring-boot-webservice                     | santander-spring-boot-webservice                     |
| darwin-spring-boot-cache                          | santander-spring-boot-cache                          |
| darwin-spring-boot-security-authentication        | santander-spring-boot-security-authentication        |
| darwin-spring-boot-omnichannel                    | santander-spring-boot-omnichannel                    |
| darwin-spring-boot-security-authorization         | santander-spring-boot-security-authorization         |
| darwin-spring-boot-business-events                | santander-spring-boot-business-events                |
| darwin-spring-boot-batch                          | santander-spring-boot-batch                          |

A library dependency tags must be updated as follows:

For example, from the **Darwin Spring Boot** dependency:

```xml
<parent>
    <groupId>com.santander.darwin</groupId>
    <artifactId>darwin-spring-boot-cache</artifactId>
</parent>
```

To the **Santander Spring Boot** dependency:

```xml
<parent>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-cache</artifactId>
</parent>
```

### How to update the Java classes

The name of some Java classes, packages, and `@Bean`s have changed to reflect the new Santander naming convention.

#### How to migrate the package names

Migrate the package names declared in the Java classes to use the ones defined in the new **Santander Spring Boot** framework.

| **Old**                           | **New**                             |
|-----------------------------------|-------------------------------------|
| com.santander.darwin              | com.santander.framework.springboot  |

An import of a Darwin Java class must be updated as follows:

For example, from the Darwin package reference:

```java
import com.santander.darwin.core.authorization.AuthorizationService;
```

To the Santander package reference:

```java
import com.santander.framework.springboot.core.authorization.AuthorizationService;
```

#### How to update the Java types

To migrate the Java types, it is necessary to update the import statements
and any reference to some of these Java types used in the implementation.

| **Old**                                                                   | **New**                                                                                    |
|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| com.santander.darwin.core.context.DarwinInfo                              | com.santander.framework.springboot.core.context.Info                                       |
| com.santander.darwin.core.context.DarwinContext                           | com.santander.framework.springboot.core.context.Context                                    |
| com.santander.darwin.core.context.DarwinContextHolder                     | com.santander.framework.springboot.core.context.ContextHolder                              |
| com.santander.darwin.core.context.ReactiveDarwinContextHolder             | com.santander.framework.springboot.core.context.ReactiveContextHolder                      |
| com.santander.darwin.core.context.DarwinContextHolderStrategy             | com.santander.framework.springboot.core.context.DarwinContextHolderStrategy                |
| com.santander.darwin.core.resilience4j.Is5xxPredicate                     | com.santander.framework.springboot.core.resilience4j.Is5xxPredicate                        |
| com.santander.darwin.core.exceptions.DarwinException                      | com.santander.framework.springboot.core.exceptions.SantanderException                      |
| com.santander.darwin.core.exceptions.HttpBaseDarwinException              | com.santander.framework.springboot.core.exceptions.HttpBaseException                       |
| com.santander.darwin.core.exceptions.BadRequestDarwinException            | com.santander.framework.springboot.core.exceptions.BadRequestException                     |
| com.santander.darwin.core.exceptions.ConflictDarwinException              | com.santander.framework.springboot.core.exceptions.ConflictException                       |
| com.santander.darwin.core.exceptions.ForbiddenDarwinException             | com.santander.framework.springboot.core.exceptions.ForbiddenException                      |
| com.santander.darwin.core.exceptions.InternalServerErrorDarwinException   | com.santander.framework.springboot.core.exceptions.InternalServerErrorException            |
| com.santander.darwin.core.exceptions.NotFoundDarwinException              | com.santander.framework.springboot.core.exceptions.NotFoundException                       |
| com.santander.darwin.core.exceptions.UnauthorizedDarwinException          | com.santander.framework.springboot.core.exceptions.UnauthorizedException                   |
| com.santander.darwin.core.exceptions.NoContentDarwinException             | com.santander.framework.springboot.core.exceptions.NoContentException                      |
| com.santander.darwin.core.exceptions.DarwinErrorsPropertiesAccessor       | com.santander.framework.springboot.core.exceptions.SantanderErrorsPropertiesAccessor       |
| com.santander.darwin.core.exceptions.reactive.DarwinErrorAttributes       | com.santander.framework.springboot.core.exceptions.reactive.SantanderErrorAttributes       |
| com.santander.darwin.core.exceptions.web.DarwinErrorAttributes            | com.santander.framework.springboot.core.exceptions.web.SantanderErrorAttributes            |
| com.santander.darwin.core.exceptions.web.DarwinExceptionHandlerController | com.santander.framework.springboot.core.exceptions.web.SantanderExceptionHandlerController |
| com.santander.darwin.core.interceptor.DarwinContextInterceptor            | com.santander.framework.springboot.core.interceptor.ContextInterceptor                     |
| com.santander.darwin.core.interceptor.DarwinContextServletFilterFunction  | com.santander.framework.springboot.core.interceptor.ContextServletFilterFunction           |
| com.santander.darwin.core.interceptor.DarwinContextReactiveFilterFunction | com.santander.framework.springboot.core.interceptor.ContextReactiveFilterFunction          |
| com.santander.darwin.core.filter.DarwinContextWebFilter                   | com.santander.framework.springboot.core.filter.ContextWebFilter                            |
| com.santander.darwin.core.filter.DarwinContextFilter                      | com.santander.framework.springboot.core.filter.ContextFilter                               |
| com.santander.darwin.core.annotation.DarwinQualifier                      | com.santander.framework.springboot.core.annotation.SantanderQualifier                      |
| com.santander.darwin.core.cache.DarwinCacheMono                           | com.santander.framework.springboot.core.cache.SantanderCacheMono                           |
| com.santander.darwin.core.config.DarwinWebClientCustomizer                | com.santander.framework.springboot.core.config.WebClientConfigCustomizer                   |
| com.santander.darwin.core.security.DarwinReactiveHttpSecurityCustomizer   | com.santander.framework.springboot.core.security.ReactiveHttpSecurityCustomizer            |
| com.santander.darwin.metrics.formatter.DarwinMessageFormatter             | com.santander.framework.springboot.metrics.formatter.MessageFormatter                      |
| com.santander.darwin.metrics.consumer.DarwinRegistryConsumerImpl          | com.santander.framework.springboot.metrics.consumer.RegistryConsumerImpl                   |
| com.santander.darwin.ws.helper.DarwinWSRequestHelper                      | com.santander.framework.springboot.ws.helper.WSRequestHelper                               |
| com.santander.darwin.events.DarwinCloudEvent                              | com.santander.framework.springboot.events.SantanderCloudEvent                              |

An import of a Darwin Java class must be updated as follows:

For example, from the Darwin package and Java type reference:

```java
import com.santander.darwin.core.context.DarwinInfo;
...
DarwinInfo darwinInfo = DarwinInfo.builder().buid();
```

To the Santander package and Java type reference:

```java
import com.santander.framework.springboot.core.context.Info;
...
Info info = Info.builder().buid();
```

#### How to migrate the Bean Names

Update the public **Darwin** bean names used in the application code to use the new **Santander** bean names:

| **Old**                           | **New**                             |
|-----------------------------------|-------------------------------------|
| getDarwinObjectMapper             | santanderObjectMapper               |
| getDarwinErrorsPropertiesAccessor | santanderErrorsPropertiesAccessor   |
| setDarwinInterceptors             | santanderRestTemplateInterceptors   |
| darwinWSRequestHelper             | santanderWSRequestHelper            |
| darwinAsyncExecutor               | santanderAsyncExecutor              |
| darwinMessageFormatter            | santanderMessageFormatter           |
| darwinRegistryConsumer            | santanderRegistryConsumer           |
| darwinAuthorizationConfiguration  | santanderAuthorizationConfiguration |

The names of the beans could be unambiguous references to identify them in Spring context and use the correct reference,
which is why it is important to update any reference to a bean that is used in the following way:

- Using `@Qualifier` annotation.
- Using `@Autowired` annotation.
- Using `@Resource` annotation.
- Using `applicationContext.getBean("beanName")` method.
- Using a `bean name` as an input parameter in a constructor.

A Darwin bean name must be updated as follows:

For example, from the **Darwin bean name**:

```java
@Autowired ObjectMapper getDarwinObjectMapper;
```

To the **Santander bean name**:

```java
@Autowired ObjectMapper santanderObjectMapper;
```

### How to update the configuration files

#### Property names

Update the property names in the configuration files to reflect the new Santander naming convention.

| **Old**                                                                           | **New**                                                                                 |
|-----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| darwin.x                                                                          | santander.x                                                                             |
| darwin.batch.darwin-info-properties.                                              | santander.batch.santander-info-properties.                                              |
| darwin.batch.darwin-info                                                          | santander.batch.info                                                                    |
| darwin.core.filter.darwin-context                                                 | santander.core.filter.context                                                           |
| logging.com.santander.darwin                                                      | logging.com.santander.framework.springboot                                              |

The configuration files of a **Darwin Spring Boot application** must be updated as follows:

For example, from the **Darwin properties references**:

```yaml
darwin:
  region: boae
  app-name: my-app
```

To the **Santander properties references**:

```yaml
santander:
  region: boae
  app-name: my-app
```

#### Property values

Some of the property values have also changed to reflect the new **Santander naming convention**.

- If the `Is5xxPredicate` class is used in the configuration file, update its reference:

| **Old**                                               | **New**                                                             |
|-------------------------------------------------------|---------------------------------------------------------------------|
| com.santander.darwin.core.resilience4j.Is5xxPredicate | com.santander.framework.springboot.core.resilience4j.Is5xxPredicate |

- If the white list of the **Metric registry** is used in the configuration file, update its reference:

Update the list of **darwin** packages whose metrics you want to avoid publishing:

```yaml
darwin:
  logging:
    metric:
      meter-white-list:
        - darwin.**
        - resilience4j.**
```

To use the new **santander** property and packages:

```yaml
santander:
  logging:
    metric:
      meter-white-list:
        - santander.**
        - resilience4j.**
```

### How to update the resources

#### Channels File

Update the name of the `darwinchannels.json` file to `santanderchannels.json` in the resources' directory.

| **Old**              | **New**                  |
|----------------------|--------------------------|
| darwinchannels.json  | santanderchannels.json   |

#### Application banner

If desired, you could migrate the application `banner` from **Darwin Spring Boot** to **Santander Spring Boot**.

The banner can be found in the resources' directory: `src/main/resources/banner.txt`.
Simply replace the existing banner with the new one.
The new banner can be found in the following repository: [Santander Spring Boot Banner](https://github.com/santander-group-shared-assets/gln-back-java-framework-spring-boot/blob/4afc3200165129cafbe34450db217f1e54cb01ad/santander-archetypes/santander-spring-boot-archetype-microservice/src/main/resources/archetype-resources/src/main/resources/banner.txt)
