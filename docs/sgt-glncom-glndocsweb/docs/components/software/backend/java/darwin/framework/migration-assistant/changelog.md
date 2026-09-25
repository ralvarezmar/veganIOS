# Change Log ![6.4.0](https://img.shields.io/badge/6.4.0-FF073D)

## v6.4.2

- Correct some inaccuracies in the `com.santander.darwin.migrationassistant.UpgradeToSantanderFramework` recipe.
- Update docker image to 1.8.0.RELEASE.
- Update dependency `OpenRewrite bom` to 3.15.0.
- Update dependency `OpenRewrite maven plugin` to 6.19.0.
- Update dependency `flatten-maven-plugin` to 1.7.3.
- Update dependency `maven-surefire-plugin` to 3.5.4.
- Update dependency `maven-failsafe-plugin` to 3.5.4.
- Update dependency `maven-compiler-plugin` to 3.14.1.
- Update dependency `assertj-core` to 3.27.6.
- Update dependency `spring-framework` to 6.2.11.

## v6.4.1

- Remove incorrect info trace `Executing configured active recipes`
- Update docker image to 1.7.9.RELEASE.
- Update dependency `OpenRewrite bom` to 3.14.0.
- Update dependency `OpenRewrite maven plugin` to 6.17.0.

## v6.4.0

- Added new recipe `com.santander.darwin.migrationassistant.UpgradeToSantanderFramework` to upgrade to Santander Spring Boot Framework.
- Update docker image to 1.7.8.RELEASE.

## v6.3.0

- Update docker image to 1.7.6.RELEASE.
- Update dependency `OpenRewrite bom` to 3.12.1.
- Update dependency `OpenRewrite maven plugin` to 6.15.0.
- Update dependency `slf4j` to 2.0.17.
- Update dependency `logback` to 1.5.18.
- Update dependency `spring-javaformat-maven-plugin` to 0.0.47.
- Update dependency `maven-surefire-plugin` to 3.5.3.
- Update dependency `maven-failsafe-plugin` to 3.5.3.
- Update dependency `jacoco` to 0.8.13.
- Update dependency `maven-compiler-plugin` to 3.14.0.
- Update dependency `flatten-maven-plugin` to 1.7.2.
- Update dependency `maven-clean-plugin` to 3.5.0.
- Update dependency `junit-jupiter` to 5.13.4.
- Update dependency `junit-platform-launcher` to 1.13.4.
- Update dependency `commons-io` to 2.20.0.
- Update dependency `snakeyaml` to 2.4.
- Update dependency `spring-framework` to 6.2.9.

## v6.2.5

- Update docker image to 1.7.3.RELEASE.

## v6.2.4

- Update docker image to 1.7.2.RELEASE.
- Update dependency `OpenRewrite bom` to 3.11.1.
- Update dependency `OpenRewrite maven plugin` to 6.13.0.

## v6.2.3

- Update docker image to 1.4.6.RELEASE.

## v6.2.2

- Update docker image to 1.4.4.RELEASE.
- Update dependency `OpenRewrite bom` to 3.4.0.
- Update dependency `OpenRewrite maven plugin` to 6.3.0.
- Update dependency `junit-jupiter` to 5.12.1
- Update dependency `junit-platform-launcher` to 1.12.1

## v6.2.1

- Update docker image to 1.4.2.RELEASE.

## v6.2.0

- The recipe `com.santander.darwin.migrationassistant.DarwinMigration` now migrate to Darwin 6.X and added a new recipe to migrate to Darwin 5.X `com.santander.darwin.migrationassistant.DarwinMigration_5`.
- Update docker image to 1.4.1-RELEASE.
- Enable properties `darwin.core.webclient.customize-beans` and `darwin.core.resttemplate.customize-beans`  when migrating to Darwin 6.x to ensure backward compatibility with HTTP clients.
- Remove test that check if a bean with name `swaggerConfig` exists in the context. It was removed in Darwin 6.x.
- Update dependency `OpenRewrite bom` to 3.2.0.
- Update dependency `OpenRewrite maven plugin` to 6.1.0.

## v6.1.0

- Upgrade Darwin version in Chart values.yaml for migration to latest version
- Fix exception processing Jenkinsfile file
- Update dependency `OpenRewrite bom` to 3.0.2.
- Update dependency `OpenRewrite maven plugin` to 6.0.4.
- Update dependency `maven-clean-plugin` to 3.4.0.
- Update dependency `maven-source-plugin` to 3.3.1.

## v6.0.0

- Updated dockerfile image version to 1.2.30.RELEASE in UpgradeDockerFileGluonMs recipe
- New module `migration-assistant-maven-plugin` to manage versions automatically and migrate to Darwin latest version
  from the command line.
- Fix Java 11 migration recipe from Darwin 3 migration.
- Document new limitation when migrating to Batch 5 due to changes in rewrite plugin
- Feat: Added two recipes, one to create Dockerfiles in case they do not exist and another one to update them to latest version in case is a Gluon project
- Migrate to SpringBoot 3.3 with DarwinMigration recipe
- Don't include `darwin.core.reactor.context-propagation: AUTO` when migrating to Darwin 4 if Sleuth's property wasn't configured
- Update dependencies and plugins:
  - **OpenRewrite Recipes** → 2.21.0
  - **OpenRewrite maven plugin** → 5.42.2
  - **kotlin** → 2.0.21
  - **slf4j-api** → 2.0.16
  - **guava** → 33.3.1-jre
  - **lombok** → 1.18.34
  - **commons-io** → 2.17.0
  - **snakeyaml** → 2.3
  - **spring-javaformat-maven-plugin** → 0.0.43
  - **maven-compiler-plugin** → 3.13.0
  - **flatten-maven-plugin** → 1.6.0
  - Remove **logback-classic**
  - Remove **maven-project-info-reports-plugin**

## v5.1.0

- Fix: Partenon dependencies were not correctly migrated with DarwinMigration\_4
- Feat: Added recipe to migrate to Java 21
- Fix: Upgrade to last 5.x.x available version instead of 5.0.0
- Fix: Increase connection timeouts to the nexus repository to avoid timeouts errors

## v5.0.0

- Feat: DarwinMigration recipe now only migrates from Darwin 4.X to Darwin 5.X and created new recipe to migrate from any previous version to Darwin 4.X
- Fix: automatic context-propagation property is only added to *application.y\*ml* files instead that all yaml files. This only apply to migrations to Darwin 4
- Fix: Only *application\*.y\*ml* files' properties are expanded to avoid using "dot syntax shortcut" instead that all
  yaml files. This only apply to migrations up to Darwin 4
- Remove recipe that adds darwin-spring-boot-legacy dependency as it’s deprecated.
- Fix: Added a check to avoid possible null pointers with Enums when migrating using GlobalChangesToDarwin32 recipe
- Feat: Adding recipes for not supported managed dependencies that were removed from Darwin 4.x to 5.x
- Feat: Added recipe to migrate Dockerfile entrypoint and base image version
- Update dependencies and plugins:
    - **OpenRewrite Recipes** → 2.8.1
    - **OpenRewrite maven plugin** → 5.26.0
    - **Kotlin** → 1.9.23
    - **slf4j-api** → 2.0.12
    - **Lombok** → 1.18.32
    - **commons.io** → 2.15.1
    - **junit-jupiter** → 5.10.2
    - **junit-platform-launcher** → 1.10.2
    - **spring-javaformat-maven-plugin** → 0.0.41
    - **jacoco** → 0.8.12
    - **asciidoctor-maven-plugin** → 2.2.6
    - **maven-surefire-plugin** → 3.2.5
    - **Maven It Extension** → 0.13.1
    - **Maven Failsafe Plugin** → 3.2.5

## v4.1.0

- Fix: ClassCastException in RemoveExtensionClass.
- Fix: renamed 'untilSourceIsGreaterOrEqualTo' to 'onlyIfSourceIsLowerThan'
  in AddDependency.
- Fix: Migrating from 3.2.X or higher will no longer add the following
  dependencies:
    - darwin-spring-boot-starter-logging
    - darwin-spring-boot-starter-cache
    - json-smart
    - slf4j-api
    - commons-lang3
    - commons-io
- Fix: Remove needless fileMatcher in some actions.
- Fix: We have successfully migrated the spring.sleuth.sampler.rate property
  to management.tracing.sampling.rate.
- Add limitation to migrate `JUnitPlatform` runner to JUnit5
- Upgrade dependencies and plugins
    - **OpenRewrite Recipes** → 2.5.1
    - **OpenRewrite maven plugin** → 5.14.0
    - **slf4j** → 2.0.9
    - **Kotlin** → 1.9.21
    - **Logback-Classic** → 1.4.13
    - **Guava** → 32.1.3-jre
    - **SnakeYaml** → 2.2
    - **Lombok** → 1.18.30
    - \*commons-io → 2.15.0
    - **SpringBeans** → 5.2.25.RELEASE
    - **JUnit Jupiter** → 5.10.1
    - **JUnit Platform Launcher** → 3.24.2
    - **AssertJ Core** → 3.24.2
    - **Maven Failsafe Plugin** → 3.1.2
    - **Maven Compiler Plugin** → 3.11.0
    - **Maven Project Info Reports Plugin** → 3.4.5
    - **Flatten Maven Plugin** → 1.5.0
    - **Jacoco Plugin** → 0.8.11
    - **MavenSureFire Plugin** → 3.2.2
    - **Maven Scm Publish Plugin** → 3.2.1
    - **Spring Java Format Plugin** → 0.0.40

## v4.0.0

- Fix bug in ReplaceAnnotationAttributes recipe.
- Enable running integrated tests with JVM 17.
- Fix bug in RenameAnnotationAttributes recipe.
- Fix recipes to migrate extended-error module.
- Update to rewrite 2.0.1 & rewrite maven 5.2.2.
- New recipes to **migrate to Darwin 3.2.x** and to **latest 4.x**.
    - New recipe to update Sleuth instrumentation properties to Darwin 4.x
    - Add recipes to update openapi dependencies to Darwin 4.x.
    - Add recipes to migrate Batch applications to Darwin 4.x (Spring Batch 5)
    - Add @AutoConfigureObservability annotation on classes with @SpringBootTest annotation.
    - Replace DarwinTaskDecorator because no longer exists in Darwin 4.x .
    - Remove all springfox dependencies to migrate to OpenApi-3.

## v3.3.2

- Optimization of configuration recipes to apply only to application files.
- Add recipe to migrate to RHDG 8.3.

## v3.3.1

- Fixed "IndexOutOfBoundsException" exception in RenameAttributeAttributeAnnotation
  recipe.
- Fixed "ClassCastException" exception in UpgradeSagacityJava recipe when the
  constructor has a primitive type parameter.
- Create a new property catalog file if it does not exist in the project root
  folder when migrating to version 3.2.x or higher.

## v3.3.0

- Added new functionality to perform an automated migration to Java 17.
- Added new functionality to migrate to the latest version of Darwin.
- Add a new recipe to migrate to version 3.1.x of the Darwin Spring Framework.
- Update FAQs (How to run MA with java 17) in the documentation.
- Update Known limitations in the documentation.
- Update OpenRewrite plug-in to version 4.37.0.

## v3.2.0

- Fixed problem when refactoring FW library packages.
- Update the ***"DarwinMigration"*** recipe to always migrate to the latest
  version of the Darwin Spring Framework.
- Add a new recipe to migrate to version 3.0.x of the Darwin Spring Framework.

## v3.1.0

- Add a default ConnectionProvider to the HttpClient instance, if not defined.
- Update to last version of OpenRewrite.
- Fixed the problem that existed when migrating to the new version of Sagacity
  with the spring-cloud dependency.
- Add NoStarImports style to prevent imports of the same package from being
  grouped as \*.
- Fixed update to wiremock dependency.
- Fixed an issue when migrating to JUnit5 and testing that no exception is
  expected (assertDoesNotThrow).
- Updated documentation with all known limitations for this version.

## v3.0.0

- Added functionality to automate the migration of Java code from a NUAR or
  earlier Darwin version to the latest Darwin version.
- Fixed issue where updating the POM file removed some of the comments from
  the original POM has been corrected.
- Fixed issue where the version was being added to the dependencies in pom.xml
  unnecessarily.
- Updated documentation with all known limitations for this version.

## v2.1.2

- Bugfix: Duplicated dependencies when running twice in a row.
- The `cache.infinispan.use-auth` property is `false` by default if migrating
  from a Darwin version earlier than 2.11.0.
- Added Boolean param in ChangeRegExPropertyKey recipe to normalizer or not
  the prefix property.
- Fixed issue where adding mandatory properties to property files.

## v2.1.1

- Change the error property of message to shortMessage.
- The Kafka communication protocol is set by default to "PLAINTEXT" if coming
  from a Darwin version lower than 2.11.0.
- Updated documentation to clarify problems with maven configuration, and
  other bugs.
- Document how to set the UTF-8 encoding to avoid problems when migrating
  configuration files.
- Update the JDBC dependency groupId **"com.oracle.ojdbc"** to
  **"com.oracle.database.jdbc"**.
- Remove the JUnit Vintage Engine dependency as it was removed in Spring Boot
  2.4.
- Add the **Darwin Spring Boot Legacy library** by default to provide backward
  compatibility with previous versions.
- Solve issue regarding yaml with composes keys.
- Normalize only certain defined properties to KebabCase.
- Solve issue regarding partenon properties.

## v2.1.0

- Added ability to detect can property names in standard **"Camel Case"**,
  **"Kebab Case"** and **"Underscore notation"** syntax when deleting or
  updating properties.
- Solve issue with Merge recipe.
- Improved integrated tests for better identification of the cause of the
  error.
- New recipe MoveKey, with it we solve the bugs when moving yaml property
  keys.
- Solve issues moving group of properties.
- Fixed a bug with KebabCase in Yaml files.
- Migration to Spring Boot 2.5 and properties to Darwin 3.0.x.
- Migration dependencies to Darwin 3.0.x.
- Solve issues deleting group of properties.
- Update the minimum configuration recommendation settings.xml.

## v2.0.1

- Update to the latest versions of Darwin Spring Boot 2.11.3.

## v2.0.0

- The Darwin migration assistant module is integrated for use with the
  OpenRewrite plugin.
- Added recipes for upgrade to Spring Boot 2.3 from a previous 1.x version,
  upgrade deprecated NUAR properties to Darwin 2.11.x, upgrade/remove
  deprecated NUAR dependencies to Darwin 2.11.x, and include all mandatory
  Darwin & non-Darwin dependencies.
- Added recipes for upgrade to Spring Boot 2.3 from a previous 2.x version,
  upgrade deprecated Darwin 2.x properties to Darwin 2.11.x, add all mandatory
  Darwin 2.11.x properties, add all mandatory Darwin 2.11.x dependencies,
  upgrade/remove deprecated Darwin 2.x dependencies and include mandatory
  non-Darwin dependencies.
- Documented as migrate to JUnit 5 from JUnit 4 with OpenRewrite’s
  **SpringBoot2JUnit4to5Migration** recipe.
- Documented as migrate to Java 11 from Java 8 with OpenRewrite’s
  **Java8toJava11** recipe.
- Added integrated tests.

## v1.0.0

- Added functionality to analyse application properties and print a report.
- Added functionality to temporarily migrate properties at runtime.
- Add migration guide for migrating to Darwin Spring Boot version 2.11.
