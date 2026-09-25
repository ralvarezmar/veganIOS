# Darwin Recipes

## Recipe for upgrade to the latest version of Darwin<span id="recipe_upgrade_to_darwin_latest"></span>

This recipe allows you to upgrade to the latest version of **Darwin Spring Boot 6.x** from any prior version of **Darwin Spring Boot 5.x**.

!!! note

    The latest version of the **Darwin Spring Boot** is available [here](../../versions.md).

### Definition

#### Recipe List

- Migration to Darwin Spring Boot 6.x from Darwin Spring Boot 5.x.
- Upgrade Spring Boot dependencies to Spring Boot 3.5.
- [Upgrade to Spring Boot 3.4](https://docs.openrewrite.org/recipes/java/spring/boot3/upgradespringboot_3_4-community-edition).
- Upgrade Darwin dependencies to Darwin 6.x
- Migrate Darwin Java sourcecode to Darwin 6.x

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration
    displayName: Migrate Darwin Spring Boot to 6.x from 5.x
    description: Migrate Darwin Spring Boot to 6.x from 5.x
    recipeList:
      - com.santander.darwin.migrationassistant.UpgradeDarwinPropertiesTo_6
      - com.santander.darwin.migrationassistant.UpgradeSpringBoot_3_4
      - com.santander.darwin.migrationassistant.UpgradeSpringBoot_3_5
      - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_6
      - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_6

## Recipe for upgrade to the latest version of Darwin<span id="recipe_upgrade_to_darwin_5_x"></span>

This recipe allows you to upgrade to the latest version of **Darwin Spring Boot 5.x** from any prior version of **Darwin Spring Boot 4.x**.

!!! note

    The latest version of the **Darwin Spring Boot** is available [here](../../versions.md).

### Definition

#### Recipe List

- Migration to Darwin Spring Boot 5.x from Darwin Spring Boot 4.x.
- [Upgrade to Spring Boot 3.3](https://docs.openrewrite.org/recipes/java/spring/boot3/upgradespringboot_3_3).
- Upgrade Darwin dependencies to Darwin 5.x
- Migrate Darwin Java sourcecode to Darwin 5.x

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration
    displayName: Migrate Darwin Spring Boot to 5.x from 4.x
    description: 'Migrate Darwin Spring Boot to 5.x from 4.x.'
    recipeList:
      - org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_3
      - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_5
      - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_5

## Recipe for upgrade to Darwin 4.x<span id="recipe_upgrade_to_darwin_4_x"></span>

This recipe allows you to upgrade to the latest version of **Darwin Spring Boot 4.x** from any prior version; it also performs an automatic migration to **Spring Boot** version 3.1.x.

### Definition

#### Recipe List

- [Migration to Darwin Spring Boot 3.2.x](#recipe_upgrade_to_darwin_32) from any prior.
- Upgrade to Darwin Spring Boot 4.x
  - [Upgrade to Spring Boot 3.1 from any prior 2.x version](https://docs.openrewrite.org/recipes/java/spring/boot3/upgradespringboot_3_1).
  - [Migrate Spring Batch4 to 5](https://docs.openrewrite.org/recipes/java/spring/batch/springbatch4to5migration).
  - Migrate Sleuth properties to Darwin 4.X
  - Upgrade Darwin dependencies to Darwin 4.x
  - Migrate Darwin Java sourcecode to Darwin 4.x

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration
    displayName: Migrate Darwin Spring Boot to latest from previous version
    description: 'Migrate Darwin Spring Boot to latest from previous version.'
    recipeList:
    - com.santander.darwin.migrationassistant.DarwinMigration_3_2
    - com.santander.darwin.migrationassistant.UpgradeDarwin_4
        - org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_1
        - com.santander.darwin.migrationassistant.MigrateSleuthInstToDarwin_4
        - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_4
        - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_4

## Recipe to upgrade to Darwin 3.2.x<span id="recipe_upgrade_to_darwin_32"></span>

This recipe allows you to upgrade to the latest version of **Darwin Spring Boot 3.2.x** from any prior version; it also performs an automatic migration to **Spring Boot** version 2.7.x.

### Definition

#### Recipe List

- [Upgrade to Darwin Spring Boot 3.1.x](#recipe_upgrade_to_darwin_31)
- Upgrade to Darwin Spring Boot 3.2.x
  - [Upgrade to Spring Boot 2.7 from any prior 2.x version](https://docs.openrewrite.org/recipes/java/spring/boot2/upgradespringboot_2_7).
  - Migrate dependencies to Darwin 3.2.x from any prior version.
  - Migrate java file to Darwin 3.2.x from any prior version.
- Upgrade to the latest version of Darwin Spring Boot

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration_3_2
    displayName: Migrate Darwin Spring Boot to 3.2.x from previous version
    description: 'Migrate Darwin Spring Boot to 3.2.x from previous version.'
    recipeList:
    - com.santander.darwin.migrationassistant.DarwinMigration_3_1
    - com.santander.darwin.migrationassistant.UpgradeDarwin_3_2
        - org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_7
        - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_3_2
        - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_3_2
    - com.santander.darwin.migrationassistant.UpgradeDarwinToLatest

## Recipe to upgrade to Darwin 3.1.x<span id="recipe_upgrade_to_darwin_31"></span>

This recipe allows you to upgrade to Darwin 3.1.x from any prior version.

### Definition

#### Recipe List

- [Upgrade to Darwin Spring Boot 3.0.x](#recipe_upgrade_to_darwin_30)
- Upgrade to Darwin Spring Boot 3.1.x
  - Migrate dependencies to Darwin 3.1.x from any prior version.

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration_3_1
    displayName: Migrate Darwin Spring Boot to 3.1.x from a previous version
    description: 'Migrate Darwin Spring Boot to 3.1.x from a previous version.'
    recipeList:
    - com.santander.darwin.migrationassistant.DarwinMigration_3_0
    - com.santander.darwin.migrationassistant.UpgradeDarwin_3_1
        - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_3_1

## Recipe to upgrade to Darwin 3.0.x<span id="recipe_upgrade_to_darwin_30"></span>

This recipe allows you to upgrade to Darwin 3.0.x from any prior version; it also performs an automatic migration to **Spring Boot** version 2.6.x.

### Definition

#### Recipe List

- [Upgrade to Darwin Spring Boot 2.11.x](#recipe_upgrade_to_darwin_211)
- Upgrade to Darwin Spring Boot 3.0.x
  - [Upgrade to Spring Boot 2.6 from any prior 2.x version](https://docs.openrewrite.org/recipes/java/spring/boot2/upgradespringboot_2_6)
  - Migrate the configuration to Darwin 3.0.x from any prior version.
  - Migrate dependencies to Darwin 3.0.x from any prior version.
  - Migrate java file to Darwin 3.0.x from any prior version.

Spring Boot 2.6 migration includes migration to **Junit 5**. For more information, see [OpenRewrite’s JUnit Jupiter migration guide](https://docs.openrewrite.org/recipes/java/spring/boot2/springboot2junit4to5migration) for Spring Boot 2.x projects.

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration_3_0
    displayName: Migrate Darwin Spring Boot to 3.0.x from a previous version
    description: 'Migrate Darwin Spring Boot to 3.0.x from a previous version.'
    recipeList:
    - com.santander.darwin.migrationassistant.DarwinMigration_2_11
    - com.santander.darwin.migrationassistant.UpgradeDarwin_3_0
        - org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_6
        - com.santander.darwin.migrationassistant.UpgradeDarwinPropertiesTo_3_0
        - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_3_0
        - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_3_0

## Recipe to upgrade to Darwin 2.11.x<span id="recipe_upgrade_to_darwin_211"></span>

This recipe allows you to upgrade to Darwin 2.11.x from any prior version; it also performs an automatic migration to **Spring Boot** version 2.3.x.

### Definition

#### Recipe List

- [Upgrade to Spring Boot 2.0 from prior 1.x version.](https://docs.openrewrite.org/recipes/java/spring/boot2/upgradespringboot_2_0)
- [Replaces any references to the deprecated EnvironmentTestUtils with TestPropertyValues and the appropriate functionality](https://docs.openrewrite.org/recipes/java/spring/boot2/replacedeprecatedenvironmenttestutils). **Deprecated in 2.0.x.**
- Migrate the configuration to Darwin 2.11.x from any prior NUAR version.
- Migrate dependencies to Darwin 2.11.x from any prior NUAR version.
- Migrate java file to Darwin 2.11.x from any prior NUAR version.
- Upgrade Darwin to 2.11.x from any prior 2.x version:
  - [Upgrade to Spring Boot 2.3 from any prior 2.x version](https://docs.openrewrite.org/recipes/java/spring/boot2/upgradespringboot_2_3).
  - [Spring can infer an autowired constructor when there is a single constructor on the bean. This recipe removes unneeded @Autowired annotations on constructors](https://docs.openrewrite.org/recipes/java/spring/noautowiredonconstructor).
  - [Migrate multi-condition @ConditionalOnBean annotations to AnyNestedCondition](https://docs.openrewrite.org/recipes/java/spring/boot2/conditionalonbeananynestedcondition).
  - [Migrate RestTemplateBuilder#requestFactory calls to use a Supplier](https://docs.openrewrite.org/recipes/java/spring/boot2/resttemplatebuilderrequestfactory). **Deprecated in 2.1.x.**
  - Migrate the configuration to Darwin 2.11.x from any prior version.
  - Migrate dependencies to Darwin 2.11.x from any prior version.
  - Migrate java file to Darwin 2.11.x from any prior version.

#### Yaml Recipe List

    type: specs.openrewrite.org/v1beta/recipe
    name: com.santander.darwin.migrationassistant.DarwinMigration_2_11
    displayName: Migrate Darwin Spring Boot to 2.11.x from a previous version
    description: 'Migrate Darwin Spring Boot to 2.11.x from a previous version.'
    recipeList:
    - org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_0
    - org.openrewrite.java.spring.boot2.ReplaceDeprecatedEnvironmentTestUtils
    - com.santander.darwin.migrationassistant.UpgradeNuarPropertiesToDarwin
    - com.santander.darwin.migrationassistant.UpgradeNuarDependenciesToDarwin
    - com.santander.darwin.migrationassistant.UpgradeNuarJavaToDarwin
    - com.santander.darwin.migrationassistant.UpgradeDarwin_2_11
        - org.openrewrite.java.spring.boot2.UpgradeSpringBoot_2_3
        - org.openrewrite.java.spring.NoAutowiredOnConstructor
        - org.openrewrite.java.spring.boot2.ConditionalOnBeanAnyNestedCondition
        - org.openrewrite.java.spring.boot2.RestTemplateBuilderRequestFactory
        - com.santander.darwin.migrationassistant.UpgradeDarwinPropertiesTo_2_11
        - com.santander.darwin.migrationassistant.UpgradeDarwinDependenciesTo_2_11
        - com.santander.darwin.migrationassistant.UpgradeDarwinJavaTo_2_11
