# Darwin Migration Assistant Recipes

## Introduction

**Darwin Migration Assistant Recipes** contains the [OpenRewrite](https://docs.openrewrite.org/)[^1] recipes that allow developers to migrate files, properties, dependencies, and Java source code
that have been modified from previous versions of **Darwin Spring Boot** (or NUAR) and **Spring Boot** to the latest versions.

## Configuration & Use

To use these recipes together with the **OpenRewrite Maven Plugin**,
in the pom.xml you must execute the following command:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate
```

- The `-Drewrite.activeRecipes` parameter explicitly turns on recipes by name.

**Migration Assistant** is focused on migrating projects between major versions of **Darwin Spring Boot Framework**.
For minor or patch migrations, you can just upgrade the Darwin Parent version in your *pom.xml*.

### To migrate to the latest version of Darwin Spring Boot

#### Migrate from 4.x or higher

To upgrade an application to the latest version of **Darwin Spring Boot (6.X.Y-RELEASE)**
from a previous version: either 4.X or 5.X,
use the recipe [<span class="red">**DarwinMigration**</span>](recipes.md#recipe_upgrade_to_darwin_latest)

!!! info

    To be able to upgrade to the latest version of Darwin Spring Boot,
    your app needs to be using any Darwin Spring Boot 4.X.Y at least,
    so it is necessary to upgrade first to Darwin Spring Boot 4.X using the recipe **DarwinMigration\_4**
    just like it is explained [here](#to-migrate-to-darwin-spring-boot-4-x)

<!tag:pluginConfig>

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate
```

<!end:pluginConfig>

- Migrate to the latest version of **Darwin Spring Boot Framework** (versions available [here](../../versions.md)).
- The recipe automatically executes the style to avoid that when five or more imports of the same package are updated in a class,
  the imports are automatically grouped with an asterisk.

!!! note

    To see complete Darwin/Spring migration guides [enter here](../../current/MIGRATION-DETAILS.md).

#### Migrate from older versions

To upgrade an application to the latest version of **Darwin Spring Boot (6.X.Y-RELEASE)** from a previous version of 4.X,
use the recipe [<span class="red">**DarwinMigration**</span>](recipes.md#recipe_upgrade_to_darwin_latest) and [<span class="red">**DarwinMigration\_4**</span>](recipes.md#recipe_upgrade_to_darwin_4_x)

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate \
 -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.DarwinMigration, com.santander.darwin.migrationassistant.DarwinMigration_4
```

- Migrate to the latest version of **Darwin Spring Boot Framework** (versions available [here](../../versions.md)).
- Migrate to version 4.X of **Darwin Spring Boot Framework** (versions available [here](../../versions.md)).
- The recipe automatically executes the style to avoid that when five or more imports of the same package are updated in a class,
  the imports are automatically grouped with an asterisk.

!!! note

    To see complete Darwin/Spring migration guides [enter here](../../current/MIGRATION-DETAILS.md).

### To migrate Santander Spring Boot Framework

To upgrade an application to version 1.X of Santander Framework you have to execute the next command:

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.UpgradeToSantanderFramework
```

!!! note

    To make the migration successfully, the minimum version used of **Darwin Spring Boot** must be `6.3.0`.

!!! tip

    This migration guide is valid for migrating both Darwin Spring Boot Microservices and Darwin Spring Boot Libraries.

### To migrate to older versions

#### To migrate to Darwin Spring Boot 4.X<span id="to-migrate-to-darwin-spring-boot-4-x"></span>

To upgrade an application to **Darwin Spring Boot (4.X.Y-RELEASE)** from any previous version, use the recipe [<span class="red">**DarwinMigration\_4**</span>](recipes.md#recipe_upgrade_to_darwin_4_x)

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate \
 -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.DarwinMigration_4
```

- Migrate to version 4.X of **Darwin Spring Boot Framework** (versions available [here](../../versions.md)).
- The recipe automatically executes the style to avoid that when five or more imports of the same package are updated in a class,
  the imports are automatically grouped with an asterisk.

This recipe includes the automatic migration to **Spring Boot version 3.1.x**, the update of most of the deprecated properties and dependencies, and the refactoring the Java source code to the latest version of **Darwin Spring Boot**.

!!! warning

    As Darwin version 4.X is based on Spring Boot 3.1.x,
    this version requires **Java 17**.
    So if you want to migrate to Darwin version 4.X **you have to use Java 17 in your application** and your libraries have to be Java 17 compatibles.

!!! note

    To see the full Darwin/Spring migration guides [enter here](../../current/MIGRATION-DETAILS.md).

#### To migrate to Darwin Spring Boot 3.2.X

To upgrade an application to **Darwin Spring Boot 3.2.X** from any previous version, use the recipe [<span class="red">**DarwinMigration\_3\_2**</span>](recipes.md#recipe_upgrade_to_darwin_32).

```shell
mvn com.santander.darwin.plugins:migration-assistant-maven-plugin:migrate \
 -Drewrite.activeRecipes=com.santander.darwin.migrationassistant.DarwinMigration_3_2
```

- The recipe automatically executes the style to avoid that when five or more imports of the same package are updated in a class,
  the imports are automatically grouped with an asterisk.

!!! note

    This recipe includes the automatic migration to Spring Boot version 2.7.x,
    the update of deprecated properties and dependencies,
    and the refactoring the Java source code to the latest version of **Darwin Spring Boot**.

## Execute Recipes

<!tag:pluginExec>

Once the plugin is properly configured, you can use the following Maven commands to execute the activated recipes:

- **mvn rewrite:dryRun** - Generate a file "rewrite.patch" where it shows the warnings of the recipe that produce changes, but not make changes.
- **mvn rewrite:run** - Run the configured recipes and apply the changes locally.

!!! tip "Set encoding for JVM"

    In order for the maven commands **rewrite:dryRun** or **rewrite:run** to work correctly, if you are using a Java version prior to Java 18
    it is essential to set the **UTF-8** encoding for JVM using the **MAVEN\_OPTS** environment variable. `set MAVEN_OPTS=-Dfile.encoding=UTF-8`

For example:

    set MAVEN_OPTS=-Dfile.encoding=UTF-8

    mvn rewrite:dryRun

<!end:pluginExec>

## Darwin recipes

If you are interested in the details of the applied recipes you can find more information [here](recipes.md)

[^1]: OpenRewrite works by making changes to Abstract Syntax Trees (AST) representing your source code and printing the modified trees back into source code.
You can then review the changes in your code and commit.
