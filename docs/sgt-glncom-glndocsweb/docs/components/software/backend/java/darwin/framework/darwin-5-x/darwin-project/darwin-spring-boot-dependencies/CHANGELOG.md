# Change Log

## Version 5.8.2

<!tag:582>

### 🔨 Dependency Upgrades

- Upgrade `spring-boot` to 3.3.12.
- Upgrade `yauaa` to 7.31.0.
- Upgrade `commons-text` to 1.13.0.
- Upgrade `bcprov-jdk18on` 1.80.0.
- Upgrade plugin `openapi-generator-maven-plugin` to 7.13.0.
- Upgrade plugin `maven-archetype-plugin` to 3.4.0.

<!end:582>

## Version 5.8.1

<!tag:581>

### 🔨 Dependency Upgrades

- Upgrade `spring-boot` to 3.3.11.
- Upgrade `infinispan` to 15.0.14.Final-redhat-00002.
- Upgrade `partenon trxOp spring-boot` to 2.1.46.
- Upgrade `partenon sat spring-boot` to 2.0.39.
- Upgrade `mds-dualrun-lib` to 1.3.2.
- Upgrade `micrometer-context-propagation` to 1.1.3.
- Upgrade plugin `jacoco-maven-plugin` to 0.8.13.
- Upgrade plugin `maven-surefire-report-plugin` to 3.5.3.

<!end:581>

## Version 5.7.4

<!tag:574>

### 🔨 Dependency Upgrades

- Upgrade `spring-boot` to 3.3.10. Solve vulnerability **CVE-2025-22228**.
- Upgrade `yauaa` to 7.30.0.
- Removed `spring-framework` version. Managed by *Spring Boot*.
- Upgrade plugin `flatten-maven-plugin` to 1.7.0.
- Upgrade plugin `openapi-generator-maven-plugin` to 7.12.0.
- Upgrade plugin `maven-project-info-reports-plugin` to 3.9.0.

<!end:574>

## Version 5.7.3

<!tag:573>

- Upgrade `spring-boot` to 3.3.9. Solve vulnerability **CVE-2024-56337**.
- Upgrade `swagger-annotations` to 2.2.28.
- Upgrade `org.owasp.dependency-check-maven` to 12.1.0.
- Upgrade `partenon trxOp spring-boot` to 2.1.45.
- Upgrade `partenon sat spring-boot` to 2.0.38.
- Upgrade `mds-dualrun-lib` to 1.2.10.
- Manage dependency `spring-framework` version 6.1.16. Solve [Spring framework issue](https://github.com/spring-projects/spring-framework/issues/34423)
- Removed `netty` version. Managed by *Spring Boot*.
- Removed `json-smart` version. Managed by *Spring Boot*.

<!end:573>

## Version 5.7.2

<!tag:572>

- Upgrade `json-smart` to 2.5.2. Solve vulnerability **CVE-2024-57699**.

<!end:572>

## Version 5.7.1

<!tag:571>

- Upgrade `netty` to 4.1.118.Final. Solve vulnerability **CVE-2025-24970**.

<!end:571>

## Version 5.7.0

<!tag:570>

- Upgrade `spring-boot` to 3.3.8
- Upgrade `spring-cloud` to 2023.0.5
- Upgrade `resilience4j` to 2.3.0
- Upgrade `org.owasp.dependency-check-maven` to 12.0.1

<!end:570>

## Version 5.6.0

<!tag:560>

- Upgrade `spring-boot` to 3.3.7
- Upgrade `spring-cloud` to 2023.0.4
- Upgrade `mapstruct` to 1.6.3
- Upgrade `org.owasp.dependency-check-maven` to 11.1.1

<!end:560>

## Version 5.5.0

<!tag:550>

- Manage plugin dependency `darwin-code-analysis-plugin` version 1.0.1
- Upgrade `spring-boot` to 3.3.6
- Upgrade `spring-cloud-deployer` to 2.9.5
- Upgrade `blockhound` to 1.0.10.RELEASE
- Upgrade `confluent` to 7.7.1
- Upgrade `micrometer` to 1.1.2
- Upgrade `commons-io` to 2.18.0
- Upgrade `swagger-annotations-jakarta` to 2.2.25
- Upgrade `bouncycastle` to 1.79
- Upgrade `maven-project-info-reports-plugin` to 3.8.0
- Upgrade `maven-surefire-plugin` to 3.5.2
- Upgrade `maven-surefire-report-plugin` to 3.5.2
- Upgrade `org.owasp.dependency-check-maven` to 11.1.0
- Upgrade `org.owasp.encoder` to 1.3.1
- Upgrade `maven-archetype-plugin` to 3.3.1
- Upgrade `wss4j-ws-security-dom` to 3.0.4
- Upgrade `yauaa` to 7.29.0
- Upgrade `openapi-generator-maven-plugin` to 7.10.0
- Removed `spring-integration-sftp`. Vulnerability **CVE-2024-41909** is solved with `spring-boot` 3.3.5
- Removed `log4j2`. Vulnerability **CVE-2024-38816** is solved with `spring-boot` 3.3.5

<!end:550>

## Version 5.4.0

<!tag:540>

- Added execution of plugin  `darwin-code-analysis-plugin` in `test` phase.
- Upgrade `spring-boot` to 3.2.11
- Upgrade `infinispan` to 15.0.8.Final-redhat-00001
- Upgrade `spring-integration-sftp` to 6.3.5
- Upgrade `maven-surefire-plugin` to 3.3.1
- Upgrade `openapi-generator-maven-plugin` to 7.9.0
- Remove `velocity.version` property because it's unused

<!end:540>

## Version 5.3.2

<!tag:532>

- Upgrade `spring-framework` to 6.1.14. Solve vulnerability **CVE-2024-38816**.
- Manage dependency `avro` version 1.11.4. Solve vulnerability **CVE-2024-47561**

<!end:532>

## Version 5.3.1

<!tag:531>

- Upgrade `spring-boot` -> 3.2.10. Solve vulnerability **CVE-2024-38816**.
- Upgrade `yauaa` -> 7.28.1
- Upgrade `maven-surefire-report-plugin` -> 3.5.0
- Upgrade `org.owasp.dependency-check-maven` -> 10.0.4

<!end:531>

## Version 5.3.0

<!tag:530>

- Upgrade `spring-boot` -> 3.2.9
- Upgrade `spring-cloud` -> 2023.0.3
- Upgrade `yauaa` -> 7.27.0
- Upgrade `maven-project-info-reports-plugin` -> 3.6.3
- Upgrade `maven-surefire-report-plugin` -> 3.3.0
- Upgrade `openapi-generator-maven-plugin` -> 7.8.0
- Upgrade `partenon trxOp spring-boot` -> 2.1.44. Solve vulnerability **sonatype-2024-3350**.
- Upgrade `partenon sat spring-boot` -> 2.0.35. Solve vulnerability **sonatype-2024-3350**.
- Upgrade `mds-dualrun-lib` -> 1.2.6.
- Manage dependency `spring-integration-sftp` version **6.3.3**. Solve vulnerability **CVE-2024-41909**.

<!end:530>

## Version 5.2.1

<!tag:521>

- Upgrade to `spring-framework` 6.1.12. Solve vulnerability **cve-2024-38809**.

<!end:521>

## Version 5.2.0

<!tag:520>

- Upgrade to `infinispan` 15.0.5.Final-redhat-00001
- Upgrade to `bcprov-jdk18on` 1.78.1. Solve vulnerabilities **CVE-2024-29857** and **sonatype-2024-0946**.

<!end:520>

## Version 5.1.0

<!tag:510>

- Updating dependencies:
  - Versions updated
    - `spring-boot` -> 3.2.8
    - `spring-doc-openapi` -> 2.6.0
    - `mds-dualrun-lib` -> 1.2.3
    - `confluent` -> 7.6.1
  - Added dependencies:
    - `darwin-batch-integration-sftp-starter` -> 1.0.1
  - Removed dependencies:
    - `commons.compress` (now managed by *confluent*)
- Updating plugins:
  - Versions updated
    - `maven-project-info-reports-plugin` -> 3.6.2
    - `org.owasp.dependency-check-maven` -> 10.0.2
    - `openapi-generator-maven-plugin` -> 7.7.0
  - Added dependencies:
    - `gln-back-arsenal-jpa-codegen-maven-plugin` -> 3.12.0
    - `partenon-maven-plugin` -> 1.0.1

<!end:510>

## Version 5.0.2

<!tag:502>

- Updating the version of dependencies and plugins:
    - Dependencies
        - `spring-boot` -> 3.2.7
    - Removed these dependencies from Darwin version management:
        - `nimbus-jose-jwt` -> 9.37.3 (now managed by spring security)
        - `bceprov-jdk18on` -> 1.78 (now managed by spring security)
    - Added dependencies to Darwin version management:
        - `kubernetes-client-bom` -> 5.12.4 (required for Darwin batch architecture compatibility)
    - Plugins
        - `maven-project-info-reports-plugin` -> 3.6.0
        - `maven-scm-publish-plugin` → 3.3.0
        - `maven-surefire-plugin` -> 3.3.0
        - `maven-surefire-report-plugin` -> 3.3.0

<!end:502>

## Version 5.0.1

<!tag:501>

- We removed these dependencies from Darwin version management:
    - `okhttp3` (now managed by *spring-boot*)
    - `kubernetes-client-bom` (now managed by *spring-cloud*)
- Updating the version of dependencies and plugins:
    - Dependencies
        - `spring-boot` -> 3.2.6
        - `spring-cloud` -> 2023.0.2
        - `blockhound` → 1.0.9.RELEASE
        - `infinispan` -> 14.0.27.Final-redhat-00002
        - `commons-io` -> 2.16.1
        - `commons-text` -> 1.12.0
        - `partenon-spring-boot-starter` -> 2.1.43
        - `partenon-sat-spring-boot-starter` -> 2.0.34
        - `mds-dualrun-lib` -> 1.2.1
    - Plugins
        - `maven-javadoc-plugin` -> 3.7.0

<!end:501>

## Version 5.0.0

<!tag:500>

- Now `commons-compress` version is managed from Darwin instead of Confluent. To solve **CVE-2024-25710**.
- We removed these dependencies from Darwin version management:
    - `kafka` (now managed by *spring-boot*)
    - `h2` (now managed by *spring-boot*)
    - `snappy` (now managed by *kafka*)
    - `jaxws-rt` (now managed by *spring-ws*)
- We removed these dependencies from Darwin version management. If you want to use them, you have to manage it directly:
    - `commons-beanutils` (last version used: 1.9.4)
    - `commons-collections4` (last version used: 4.4)
    - `guava` (last version used: 32.1.3-jre)
    - `xmlsec`(last version used: 3.0.4)
- Updating the version of dependencies and plugins,
    - Dependencies
        - `spring-cloud` -> 2023.0.1
        - `spring-framework` -> 6.1.6
        - `spring-security` -> 6.2.4
        - `resilience4j` -> 2.2.0
        - `spring-boot` -> 3.2.5
        - `partenon-spring-boot-starter` -> 2.1.42
        - `partenon-sat-spring-boot-starter` -> 2.0.33
        - `mds-dualrun-lib` -> 1.1.23
        - `commons-compress` -> 1.26.1
        - `com-lmax-disruptor` -> 4.0.0
        - `commons-text` -> 1.11.0
        - `confluent` -> 7.6.0
        - `bceprov-jdk18on` -> 1.78
        - `cloudevents` -> 3.0.0
        - `springdoc` -> 2.5.0
        - `infinispan` -> 14.0.27.Final-redhat-00001
    - Plugins
        - `org.owasp.dependency-check-maven` -> 9.1.0
- Deprecate Darwin RailRoad Switch library; References to RailRoad Switch have been removed from the Darwin framework.

<!end:500>

## Version 4.3.3-RELEASE

<!tag:433>

- Updating the version of dependencies and plugins
    - Dependencies
        - `spring-boot` -> 3.1.12
        - `spring-cloud-deployer-kubernetes` -> 2.9.3
    - Plugins
        - `org.owasp.dependency-check-maven` -> 9.2.0
        - `openapi-generator-maven-plugin` -> 7.6.0
- We removed these dependencies from Darwin version management
    - `log4j2` (now managed by *spring-boot*)

<!end:433>

## Version 4.3.2-RELEASE

<!tag:432>

- Updating the version of dependencies and plugins
    - Dependencies
        - `spring-boot` -> 3.1.11
        - `bouncycastle` -> 1.78.1
        - `yauaa` -> 7.26.1
    - Plugins
        - `jacoco-maven-plugin` -> 0.8.12
        - `openapi-generator-maven-plugin` -> 7.5.0

<!end:432>

## Version 4.3.1-RELEASE

<!tag:431>

- Updating the version of dependencies and plugins
    - Dependencies
        - `spring-boot` -> 3.1.10
        - `log4j2` -> 2.23.1
        - `confluent` -> 7.3.7
        - `micrometer-context-propagation` -> 1.1.1
        - `xmlsec` -> 3.0.4
        - `bcprov-jdk18on` -> 1.77
        - `swagger-annotations` -> 2.2.21
        - `wss4j-ws-security-dom` -> 3.0.3
        - `yauaa` -> 7.26.0
    - Plugins
        - `org.owasp.dependency-check-maven` -> 9.0.10
        - `openapi-generator-maven-plugin` -> 7.4.0
- - We removed these dependencies from Darwin version management
    - `avro` (now managed by *confluent*)
    - `sshd` (now managed by *spring-integration-sftp*)

<!end:431>

## Version 4.3.0-RELEASE

<!tag:430>

- Now `nimbus-jose-jwt` version is managed from Darwin instead of Spring Security. To solve **CVE-2023-52428**.
- Updating the version of dependencies and plugins,
    - Dependencies
        - `spring-boot` -> 3.1.9
        - `spring-cloud` -> 2022.0.5
        - `partenon-sat-spring-boot-starter` -> 2.0.33
        - `mds-dualrun-lib` -> 1.1.23
        - `partenon-spring-boot-starter` -> 2.1.42
        - `nimbus-jose-jwt` -> 9.37.3
        - `log4j2` -> 2.23.0
        - `commons.io` -> 2.15.1
        - `yauaa` -> 7.25.0
    - Plugins
        - `openapi-generator-maven-plugin` -> 7.3.0

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- Exclude `commons-logging` from `partenon-sat-spring-boot-starter` to support native compilation
- Updating the version of dependencies and plugins

    - Dependencies
        - `spring-boot` -> 3.1.8
        - `partenon-sat-spring-boot-starter` -> 2.0.32
        - `mds-dualrun-lib` -> 1.1.22
        - `spring-cloud-deployer-kubernetes` -> 2.9.2
        - `kafka` -> 3.5.2
        - `springdoc-openapi` starters -> 2.3.0
        - `swagger-annotations-jakarta` -> 2.2.20
        - `yauaa` -> 7.24.0

    - Plugins:
        - `openapi-generator-maven-plugin` -> 7.2.0
        - `dependency-check-maven` -> 9.0.9
        - `maven-surefire-plugin` -> 3.2.5
        - `maven-surefire-report-plugin` -> 3.2.5
        - `maven-javadoc-plugin` -> 3.6.3
        - `flatten-maven-plugin` -> 1.6.0

<!end:420>

## Version 4.1.1-RELEASE

<!tag:411>

- Updating the version of dependencies and plugins

    - Dependencies
        - `spring-boot` -> 3.1.6
        - `partenon-spring-boot-starter` -> 2.1.41
        - `partenon-sat-spring-boot-starter` -> 2.0.31
        - `mds-dualrun-lib` -> 1.1.21
        - `infinispan` -> 14.0.21.Final-redhat-00001
        - Removed version management of `reactor-bom`. Now it is managed directly by *spring-boot*.

    - Plugins:
        - `maven-project-info-reports-plugin` -> 3.5.0
        - `dependency-check-maven` -> 8.4.2
        - `maven-surefire-plugin` -> 3.2.2
        - `openapi-generator-maven-plugin` -> 7.1.0

<!end:411>

## Version 4.1.0-RELEASE

<!tag:410>

- Managed new `com.santander.darwin:darwin-spring-boot-starter-omnichannel-ua-parser` dependency.

- Updating the version of dependencies and plugins

    - Dependencies
        - `spring-boot` -> 3.1.5
        - `spring-cloud-deployer-kubernetes` -> 2.9.1
        - `partenon-spring-boot-starter` -> 2.1.40
        - `partenon-sat-spring-boot-starter` -> 2.0.30
        - `mds-dualrun-lib` -> 1.1.19
        - `confluent` -> 7.3.5
        - `commons-io` -> 2.15.0
        - `guava` -> 32.1.3-jre
        - `infinispan` -> 14.0.17.Final-redhat-00002
        - `context-propagation` -> 1.0.6
        - `swagger-annotations-jakarta` -> 2.2.19
        - `sshd` -> 2.9.3
        - `wss4j-ws-security-dom` -> 3.0.2
        - `yauaa` -> 7.23.0
        - `jaxws-rt` -> 4.0.2
        - `avro` -> 1.11.3
        - `xmlsec` → 3.0.3
        - `h2` → 2.2.224
        - `okhttp3` → 4.12.0
        - `reactor-bom` → 2022.0.13
        - Removed `micrometer-tracing` -> 1.1.4

    - Plugins:
        - `avro-maven-plugin` -> 1.11.13
        - `jacoco-maven-plugin` -> 0.8.11
        - `maven-javadoc-plugin` -> 3.6.2
        - `dependency-check-maven` -> 8.4.2
        - `maven-surefire-plugin` -> 3.2.2
        - `maven-surefire-report-plugin` -> 3.2.2
        - `openapi-generator-maven-plugin` -> 7.0.1

<!end:410>

## Version 4.0.1-RELEASE

<!tag:401>

- Updating the version of dependencies and plugins

    - Dependencies

        - `spring-boot` → 3.1.3

        - `spring-cloud` → 2022.0.4

        - `spring-cloud-deployer-kubernetes` → 2.8.3

        - `kubernetes-client-bom` → 5.12.4

        - `guava` → 32.1.2-jre

        - `xmlsec` → 3.0.2

        - `yauaa` → 7.22

        - `springdoc-openapi-starter-webmvc-ui` & `springdoc-openapi-starter-webflux-ui` → 2.2.0

        - `context-propagation` → 1.0.5

        - `mapstruct` → 1.5.5.Final

        - `kafka` → 3.5.1

        - `spring-kafka` → 3.0.11

    - Plugins:

        - `dependency-check-maven` → 8.4.0

        - `openapi-generator-maven-plugin` → 7.0.0

- Removed `snappy-java` dependency management.

<!end:401>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot
  3.1.2.

    - Dependencies

        - `spring boot` → 3.1.2

        - `spring cloud` → 2022.0.3

        - `infinispan` → 14.0.11.Final-redhat-00001

        - `springdoc-openapi` → 2.1.0

        - `swagger-annotations` → 2.2.14

        - `wss4j` → 3.0.0

        - `Resilience4j` → 2.1.0

        - `micrometer-context-propagation` → 1.0.4

        - `yauaa.version` → 7.20.0

        - `cloudevents` → 2.5.0

        - `bcprov-jdk18on` → 1.76

        - `railroad` → 3.0.0-RELEASE

        - `sshd.version` → 2.9.2 (downgrade)

        - `blockhound` → 1.0.8.RELEASE

        - `commons-io` → 2.13.0

        - `guava` → 32.1.1-jre

        - `swagger-annotations` → 2.2.15

        - `wss4j-ws-security-dom` → 3.0.1

        - `jaxws-rt` → 4.0.1

        - `partenon-spring-boot-starter` → 2.1.36-sb31x

        - `partenon-sat-spring-boot-starter` → 2.0.26-sb31x

        - `mds-dualrun-lib` → 1.1.14-sb31x

        - `yauaa` → 7.21.0

        - `snappy-java` → 1.1.10.3

    - Plugins

        - `org.owasp.dependency-check-maven` → 8.3.1

        - `maven-surefire-report-plugin` → 3.1.2

        - `flatten-maven-plugin` → 1.5.0

        - `asciidoctor.maven.plugin` → 2.2.4

        - `jacoco-maven-plugin` → 0.8.10

        - `maven-javadoc-plugin` → 3.5.0

        - `maven-project-info-reports-plugin` → 3.4.5

        - `maven-scm-publish-plugin` → 3.2.1

        - `maven-surefire-plugin` → 3.1.2

- Change parent to spring-boot-starter-parent to allow use native & nativeTest
  profiles.

- Added openapi generator plugin.

    - `openapi-generator-maven-plugin` → 6.6.0

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Updating the version of dependencies and plugins:

    - Dependencies:

        - `spring-boot` -> 2.7.15
        - `spring-cloud-deployer-kubernetes` -> 2.8.3
        - `spring-security` -> 5.8.6
        - `kubernetes-client-bom` -> 5.12.4
        - `blockhound` & `blockhound-junit-platform` -> 1.0.8.RELEASE
        - `cloudevents-kafka` & `cloudevents-json-jackson` -> 2.4.2
        - `mapstruct` -> 1.5.5.Final
        - `xmlsec` -> 3.0.2
        - `spring-ws` -> 3.1.6
        - `springdoc-openapi-ui` & `springdoc-openapi-webflux-ui` & `springdoc-openapi-security` -> 1.6.15
        - `swagger-annotations` -> 2.2.15
        - `wss4j-ws-security-dom` -> 3.0.1
        - `snakeyaml` -> 2.2
        - `snappy-java` -> 1.1.10.3
        - `mds-dualrun-lib` -> 1.1.13
        - `partenon-spring-boot-starter` -> 2.1.35
        - `partenon-sat-spring-boot-starter` ->2.0.24
        - `kafka` -> 3.5.1
        - `spring-kafka` -> 2.9.12

    - Plugins:

        - `asciidoctor-maven-plugin` -> 2.2.4
        - `avro-maven-plugin` -> 1.11.2
        - `jacoco-maven-plugin` -> 0.8.10
        - `maven-project-info-reports-plugin` -> 3.4.5
        - `maven-surefire-plugin` -> 3.0.0
        - `maven-surefire-report-plugin` -> 3.0.0

<!end:327>

## 3.2.6-RELEASE Version

<!tag:326>

- Updating version of dependencies and plugins

    - Dependencies

        - `sshd.version` → 2.10.0

<!end:326>

## 3.2.5-RELEASE Version

<!tag:325>

- Updating version of dependencies and plugins

    - Dependencies

        - `spring-boot` → 2.7.13

        - `spring-cloud` → 2021.0.8

        - `partenon-spring-boot-starter` → 2.1.34

        - `mds-dualrun-lib` → 1.1.11

        - `partenon-sat-spring-boot-starter` → 2.0.23

        - `guava` → 32.0.1-jre

        - `snappy-java` → 1.1.10.1

    - Plugins

        - `spring-javaformat-maven-plugin` → 0.0.39

        - `org.owasp.dependency-check-maven` → 8.3.1

<!end:325>

## 3.2.4-RELEASE Version

<!tag:324>

- Updating version of dependencies and plugins

    - Dependencies

        - `spring-boot` → 2.7.12

        - `spring-cloud` → 2021.0.7

        - `partenon-spring-boot-starter` → 2.1.32

- Add new dependencies

    - `mds-dualrun-lib` → 1.1.10

    - `partenon-sat-spring-boot-starter` → 2.0.21

<!end:324>

## 3.2.3-RELEASE Version

<!tag:323>

- Updating version of dependencies and plugins

    - Dependencies

        - `spring-boot` → 2.7.11

        - `confluent` → 7.3.3

        - `partenon-spring-boot-starter` → 2.1.31

        - `spring-cloud-deployer` → 2.8.2

        - `snakeyaml` → 2.0

        - `spring-security` → 5.8.3

        - `yauaa` → 7.18.0

        - `jaxws-rt.` → 4.0.1

        - remove managed version of `woodstox` library

<!end:323>

## 3.2.2-RELEASE Version

<!tag:322>

- Updating version of dependencies and plugins

    - Dependencies

        - `spring-boot` → 2.7.9

        - `confluent` → 7.3.2

        - `partenon-spring-boot-starter` → 2.1.30

<!end:322>

## 3.2.1-RELEASE Version

<!tag:321>

- Updating version of dependencies and plugins:

    - Dependencies

        - `spring-boot` → 2.7.8

        - `cloudevents` → 2.4.1

        - `confluent` → 7.3.1

        - `yauaa.version` → 7.11.0

        - `partenon-spring-boot-starter` →2.1.29

    - Plugins

        - `org.owasp.dependency-check-maven` → 8.0.2

        - `maven-project-info-reports-plugin` → 3.4.2

        - `maven-surefire-report-plugin.version` → 3.0.0-M8

<!end:321>

## 3.2.0-RELEASE Version

<!tag:320>

- Include dependency management for:

    - New `darwin-spring-boot-starter-core` module.

    - New `darwin-spring-boot-starter-cache-caffeine` and `darwin-spring-boot-starter-cache-infinispan`
      modules.

    - New `darwin-spring-boot-starter-logging-basic`
      and `darwin-spring-boot-starter-logging-kafka`

    - New `darwin-spring-boot-starter-cache-base` module.

- Remove Sagacity dependencies

- Updating version of dependencies and plugins:

    - Dependencies

        - `spring-boot` → 2.7.7

        - `cloudevents` → 2.4.0

        - `mapstruct` → 1.5.3.Final

        - `spring-ws` → 3.1.4

        - `springdoc-openapi` → 1.6.13

        - `springfox-swagger-ui` → 4.15.5

        - `partenon-spring-boot-starter` →2.1.27

        - `swagger-annotations` → 2.2.7

        - `wss4j-ws-security-dom` → 3.0.0

        - `yauaa.version` → 7.9.1

        - `jaxws-rt` → 4.0.0

        - `bcprov-jdk18on` → 1.72

        - `infinispan` → 13.0.10.Final-redhat-00001

        - `sshd` → 2.9.2

        - `snakeyaml` → 1.33

        - `woodstox` → 6.4.0

        - `springdoc-openapi-webflux-ui`, `springdoc-openapi-ui`, and `springdoc-openapi-security`: 1.6.14

    - Plugins

        - `avro-maven-plugin` → 1.11.1

        - `flatten-maven-plugin` → 1.3.0

        - `maven-javadoc-plugin` → 3.4.1

        - `maven-project-info-reports-plugin` → 3.4.1

        - `maven-site-plugin` → 3.12.1

        - `dependency-check-maven` → 7.4.3

<!end:320>

## 3.1.5-RELEASE Version

<!tag:315>

- Include dependency management for:

    - `org.apache.sshd` version → 2.9.2

    - `com.fasterxml.woodstox` version → 6.4.0

    - Dependencies

        - `spring boot` → 2.6.14

        - `spring-cloud` → 2021.0.5

        - `yauaa` → 7.9.1

        - `partenon-spring-boot-starter` → 2.1.29

        - `netty` → 4.1.86.Final

    - Plugins

        - `dependency-check-maven`: 6.5.3 → 7.4.3

<!end:315>

## 3.1.4-RELEASE Version

<!tag:314>

- Updating version of dependencies and plugins:

    - Dependencies

        - `spring boot` → 2.6.13

        - `yauaa` → 7.7.0

        - `commons-text` → 1.10.0

        - `partenon-spring-boot-starter` → 2.1.24

<!end:314>

## 3.1.3-RELEASE Version

<!tag:313>

- Updating version of dependencies and plugins:

    - Dependencies

        - `spring boot` → 2.6.12

        - `spring-cloud` → 2021.0.4

        - `yauaa` → 7.6.0

        - `snakeyaml` → 1.33

<!end:313>

## 3.1.2-RELEASE Version

<!tag:312>

- Updating version of dependencies and
  plugins:

    - Dependencies

        - `spring boot` → 2.6.11

        - `spring-graphql` → 1.0.1

        - `partenon-spring-boot-starter` → 2.1.23

    - Plugins

        - `spring-javaformat-maven-plugin`: 0.0.29 → 0.0.34

<!end:312>

## 3.1.0-RELEASE Version

<!tag:310>

- Include dependency management for:

    - `spring-graphql` and `spring-graphql-test` → 1.0.0

    - `com.h2database:h2` version → 2.1.210

    - `io.confluent:monitoring-interceptors` → 7.0.4

- Update dependency management for:

    - `railroadswitch` → 2.0.3-RELEASE

    - `spring cloud` → 2021.0.3

    - `kafka-avro-serializer` → 7.0.4

- Updating version of dependencies and plugins:

    - Dependencies

        - spring boot → 2.6.9

        - `cloudevents-json-jackson` and `cloudevents-kafka`: 2.2.0 → 2.3.0

        - `guava`: 31.0.1-jre → 31.1-jre

        - `Mapstruct`: 1.4.2.Final → 1.5.1.Final

        - `xmlsec`: 2.3.0 → 2.3.1

        - `spring-ws`: 3.1.2 → 3.1.3

        - `springdoc-openapi-webflux-ui`, `springdoc-openapi-ui`, and `springdoc-openapi-security`: 1.6.6 → 1.6.9

        - `swagger-annotations`: 2.1.12 → 2.2.1

        - `wss4j-ws-security-dom`: 2.4.0 → 2.4.1

        - `yauaa`: 6.4 → 6.12

        - `saga`: 4.1.1 → 4.4.0

    - Plugins

        - `asciidoctor-maven-plugin`: 2.2.1 → 2.2.2

        - `avro-maven-plugin`: 1.10.2 → 1.11.0

        - `jacoco-maven-plugin`: 0.8.7 → 0.8.8

        - `archetype-packaging` and `maven-archetype-plugin`: 3.2.0 → 3.2.1

        - `maven-javadoc-plugin`: 3.3.1 → 3.4.0

        - `maven-project-info-reports-plugin`: 3.1.2 → 3.3.0

        - `maven-site-plugin`: 3.9.1 → 3.12.0

        - `maven-surefire-plugin`: 3.0.0-M5 → 3.0.0-M7

        - `maven-surefire-report-plugin`: 3.0.0-M5 → 3.0.0-M7

        - `dependency-check-maven`: 6.5.0 → 6.5.3

    - Removed dependencies:

        - wiremock-standalone: 2.27.2

        - wiremock-jre8-standalone: 2.32.0

<!end:310>

## 3.0.6-RELEASE Version

<!tag:306>

- Include dependency management for:

    - `org.apache.sshd` version → 2.9.2

    - `com.fasterxml.woodstox` version → 6.4.0

    - Dependencies

        - `spring boot` → 2.6.14

        - `spring-cloud` → 2021.0.5

        - `yauaa` → 7.9.0

        - `partenon-spring-boot-starter` → 2.1.29

        - `netty` → 4.1.86.Final

    - Plugins

        - `dependency-check-maven`: 6.5.3 → 7.4.1

<!end:306>

## 3.0.5-RELEASE Version

<!tag:305>

- Include dependency management for:

    - `com.h2database:h2` version → 2.1.210

- Updating version of dependencies and plugins:

- Update dependency management for:

    - `railroadswitch` → 2.0.3-RELEASE

    - `kafka-avro-serializer` → 7.0.4

    - Dependencies

        - `spring boot` → 2.6.13

        - `spring-cloud` → 2021.0.4

        - `yauaa` → 7.7.0

        - `commons-text` → 1.10.0

        - `partenon-spring-boot-starter` → 2.1.24

        - `snakeyaml` → 1.33

        - `cloudevents-json-jackson` and `cloudevents-kafka`: 2.2.0 → 2.3.0

        - `guava`: 31.0.1-jre → 31.1-jre

        - `Mapstruct`: 1.4.2.Final → 1.5.1.Final

        - `xmlsec`: 2.3.0 → 2.3.1

        - `spring-ws`: 3.1.2 → 3.1.3

        - `springdoc-openapi-webflux-ui`, `springdoc-openapi-ui`, and `springdoc-openapi-security`: 1.6.6 → 1.6.9

        - `swagger-annotations`: 2.1.12 → 2.2.1

        - `wss4j-ws-security-dom`: 2.4.0 → 2.4.1

        - `saga`: 4.1.1 → 4.4.0

    - Plugins

        - `spring-javaformat-maven-plugin`: 0.0.29 → 0.0.34

        - `asciidoctor-maven-plugin`: 2.2.1 → 2.2.2

        - `avro-maven-plugin`: 1.10.2 → 1.11.0

        - `jacoco-maven-plugin`: 0.8.7 → 0.8.8

        - `archetype-packaging` and `maven-archetype-plugin`: 3.2.0 → 3.2.1

        - `maven-javadoc-plugin`: 3.3.1 → 3.4.0

        - `maven-project-info-reports-plugin`: 3.1.2 → 3.3.0

        - `maven-site-plugin`: 3.9.1 → 3.12.0

        - `maven-surefire-plugin`: 3.0.0-M5 → 3.0.0-M7

        - `maven-surefire-report-plugin`: 3.0.0-M5 → 3.0.0-M7

        - `dependency-check-maven`: 6.5.0 → 6.5.3

<!end:305>

## 3.0.4-RELEASE Version

<!tag:304>

- Updating **partenon-spring-boot-starter** to 2.1.20 to solve performance issues with BPS
  connector:

- Updating Spring Boot dependency to 2.6.8:

    - Dependencies:

        - spring boot → 2.6.8

        - spring cloud → 2021.0.2

- Updating Infinispan dependencies to last versions

    - Dependencies:

        - Infinispan spring boot starter → 2.1.10.Final-redhat-00007

        - Infinispan → 9.4.24.Final-redhat-00002

<!end:304>

## 3.0.3-RELEASE Version

<!tag:303>

- Updating Spring Boot dependency to 2.6.6 in order to solve vulnerability
  CVE-2022-22965:

    - Dependencies:

        - spring boot → 2.6.6

        - spring cloud → 2021.0.1

        - railroad switch → 2.0.2

<!end:303>

## 3.0.1-RELEASE Version

<!tag:301>

- Dependencies upgrade:

    - Dependencies:

        - spring boot → 2.6.3

        - railroad switch → 2.0.1

<!end:301>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Bump Saga Dependency to 4.1.0:

- From this version onwards, the java baseline is modified from 8 to 11, and the framework is compatible with java 11
  and java 17.

- Use *https* for nexus repository

- Dependencies and plugins upgrade:

    - Dependencies:

        - spring boot → 2.6.2

        - spring cloud → 2021.0.0

        - confluent → 6.2.0

        - commons-io → 2.11.0

        - guava → 31.0.1-jre

        - io.cloudevents → 2.2.0

        - jaxws-rt → 3.0.2

        - nimbus-jose-jwt → 8.22.1

        - org.apache.santuario.xmlsec → 2.3.0

        - org.bouncycastle.bcprov-jdk15on.version → 1.70

        - partenon → 2.1.18

        - railroad switch → 2.0.0

        - resilience4j → 1.7.0

        - springdoc-openapi → 1.6.1

        - spring-ws → 3.1.2

        - swagger-annotations → 2.1.11

        - wiremock-jr8-standalone → 2.32.0

        - wss4j.ws.security.dom → 2.4.0

        - yauaa → 6.4

    - Plugins:

        - asciidoctor-maven-plugin → 2.2.1

        - avro-maven-plugin → 1.10.2

        - git-build-hook-maven-plugin → 3.1.0

        - maven-javadoc-plugin → 3.3.1

        - maven-scm-publish-plugin → 3.1.0

        - org.owasp.dependency-check-maven → 6.5.0

        - spring-javaformat-maven-plugin → 0.0.29

<!end:300>

## 2.11.1-RELEASE Version

<!tag:2111>

- Fixed bug in Darwin Contracts's version.

<!end:2111>

## 2.11.0-RELEASE Version

<!tag:2110>

- Dependencies and plugins upgrade:

    - Dependencies:

        - Spring-Boot → 2.3.12.RELEASE

        - Spring Cloud → Hoxton.SR11

        - blockhound → 1.0.6

        - commons-io → 2.10.0

        - guava → 30.1.1-jre

        - json-sanitizer → 1.2.3

        - json-smart → 2.4.7

        - nimbus-jose-jwt → 8.22

        - org.apache.santuario.xmlsec → 2.2.2

        - bcprov-jdk15on → 1.69

        - railroadswitch → 1.5.0-RELEASE

        - spring-ws → 3.1.1

        - springdoc-openapi → 1.5.9

        - partenon → 2.1.13

        - wss4j-ws-security-dom → 2.3.2

        - swagger-annotations → 2.1.9

        - jaxws-rt → 3.0.1

        - com-lmax-disruptor → 3.4.4

        - railroadswitch → 1.5.0-RELEASE

    - Plugins:

        - jacoco-maven-plugin → 0.8.7

        - lombok-maven-plugin → 1.18.20.0

        - maven-javadoc-plugin → 3.3.0

        - maven-project-info-reports-plugin → 3.1.2

        - org.owasp.dependency-check-maven → 6.2.2

<!end:2110>

## 2.10.3-RELEASE Version

<!tag:2103>

- Dependency upgrade:

    - springdoc-openapi → 1.5.8

<!end:2103>

## 2.10.0-RELEASE Version

<!tag:2100>

- Dependencies upgrade:

    - spring-boot → 2.3.9

    - spring-cloud → Hoxton.SR10

    - partenon connector → 2.1.11

    - springdoc-openapi → 1.5.5

    - darwin-spring-contracts → 1.0.4.RELEASE

    - flatten-maven-plugin → 1.2.7

    - lombok-maven-plugin → 1.18.18.0

    - maven-surefire-plugin → 3.0.0-M5

    - maven-surefire-report-plugin → 3.0.0-M5

    - org.owasp.dependency-check-maven → 6.1.2

- Fix bug. Dependencies downgrade:

    - nimbus-jose-jwt → 8.20

- Manage **MapStruct** dependency and **lombok-mapstruct-binding** version.

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- Dependencies upgrade:

    - spring-boot → 2.3.7

    - spring-cloud → Hoxton.SR9

    - resilience4j → 1.6.1

    - railroad-switch → 1.3.0-RELEASE

    - commons-io → 2.8.0

    - guava → 30.1-jre

    - infinispan → 9.4.21.Final-redhat-00002

    - infinispan starters → 2.1.10.Final-redhat-00005

    - json-sanitizer → 1.2

    - nimbus-jose-jwt → 9.4.1

    - org.apache.santuario.xmlsec → 2.2.1

    - org.bouncycastle.bcprov-jdk15on → 1.68

    - springfox-swagger → 2.10.5

    - wss4j-ws-security-dom → 2.3.1

    - springdoc-openapi → 1.5.2

    - spring-ws → 3.0.10.RELEASE

    - partenon connector → 2.1.7

    - jaxws-rt → 3.0.0

    - wiremock-standalone → 2.27.2

    - asciidoctor.maven.plugin → 2.1.0

    - jacoco-maven-plugin → 0.8.6

    - lombok-maven-plugin → 1.18.16.0

    - maven-project-info-reports-plugin → 3.1.1

    - org.owasp.dependency-check-maven → 6.0.5

<!end:290>

## 2.8.1-RELEASE Version

<!tag:281>

- RailroadSwitch dependency update → 1.2.0-RELEASE

<!end:281>

## 2.8.0-RELEASE Version

<!tag:280>

- Dependencies update:

    - spring-boot → 2.3.4

- Dependencies update:

    - spring-boot → 2.3.3

    - spring-cloud → Hoxton.SR8

    - blockhound → 1.0.4

    - commons-collections4 → 2.7

    - commons-text → 1.9

    - json-sanitizer → 1.2.1

    - nimbus-jose-jwt → 8.20

    - xmlsec → 2.2.0

    - bcprov-jdk15on → 1.65

    - resilience4j → 1.5

    - springdoc-openapi → 1.4.6

    - wiremock → 2.27.1

    - flatten plugin → 1.2.5

    - maven archetype plugin → 3.2.0

    - maven site plugin → 3.9.1

    - Partenon SpringBoot → 2.1.0

- The dependencies with the modules **darwin-spring-boot-partenon** and **darwin-spring-boot-starter-partenon** have
  been included.

- For classes that make use of lombok annotations, we added lombok plugin use. For this compiled code, we used Javadoc
  configuration for the documentation generation. Also, the bug where javadoc links appeared with "undefined" path,is
  fixed.

<!end:280>

## 2.7.1-RELEASE Version

<!tag:271>

- Update Infinispan Bom dependency to → 9.4.19.Final-redhat-00001

- Reactor Bom added using Dysprosium-SR9 version

<!end:271>

## 2.7.0-RELEASE Version

<!tag:270>

- Version migration:

- Dependencies update:

    - Spring Boot → 2.3.1

    - Nimbus Jose Jwt → 8.17

    - BlockHound → 1.0.3

    - Guava → 29.0-jre

    - Resilience4j → 1.4.0

    - JAX-WS Runtime → 2.3.3

    - Apache XMLSec → 2.1.5

    - BouncyCastle bcprov-jdk15on → 1.65

    - Apache WSS4J → 2.2.5

    - Partenon SpringBoot Starter → 2.0.4

- Plugins update:

    - Flatten Maven Plugin → 1.2.2

    - Maven Site Plugin → 3.9.0

    - OWASP Dependency-Check → 5.3.2

    - Spring Cloud → Hoxton.SR5

    - Maven Archetype → 3.1.2

<!end:270>

## 2.6.1-RELEASE Version

<!tag:261>

- We modify the `maven-replacer-plugin` plugin in order to replace the .adoc references by their .html pages from the
  whole framework: *${project.build.directory}/site/**\*/index.html**

<!end:261>

## 2.6.0-RELEASE Version

<!tag:260>

- RailroadSwith bom is being used in the DependencyManagement section.

- Authorization block has been removed.

- Functional log error implemented by the framework.

- Resilience4j-cloud2 is included to allow resilience4j properties refresh

- We removed the code to solve an issue in the fallback of resilience4j prior to 1.2.0 versions.

- Dependencies update:

    - Spring Boot → 2.2.5

    - Spring Cloud → Hoxton.SR3

    - Nimbus Jose Jwt → 8.9

    - WireMock → 2.26.3

    - BlockHound → 1.0.2

    - Guava → 28.2-jre

    - Resilience4j → 1.3.1

    - RailroadSwitch → 1.0.3

- Plugings update:

    - flatten-maven-plugin → 1.2.1

    - maven-surefire-plugin → 3.0.0-M4

    - org.owasp.dependency-check-maven → 5.3.0

<!end:260>

## 2.4.3-RELEASE Version

<!tag:243>

- Partenon-spring-boot-starter version has been updated to 2.0.1

<!end:243>

## 2.4.0-RELEASE Version

<!tag:240>

- Spring Cloud version has been updated to Greenwich.SR3.

- BlockHound version has been updated to 1.0.0.RC1

<!end:240>

## 2.3.3-RELEASE Version

<!tag:233>

- Spring boot version has been updated to 2.1.8.RELEASE

- Guava version has been updated to Guava 28.1-jre

- Resilience4j has been updated to Resilience4j 0.17

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- Spring Cloud version has been updated to Greenwich.SR2

<!end:232>

## 2.3.0-RELEASE Version

<!tag:230>

- The spring-boot version has been updated to 2.1.6.RELEASE

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- Spring-boot version has been updated to 2.1.5.RELEASE

<!end:220>

## 2.1.4-RELEASE Version

<!tag:214>

- Spring Cloud version has been updated to Greenwich.SR1

- The org.apache.ws.security:wss4j dependency has been deleted from the dependencyManagemet section. Now it will be the
  Spring release itself that establishes the version.

<!end:214>

## 2.1.3-RELEASE Version

<!tag:213>

- Partenon connector version has been updated to 1.0.25 version

- The wss4j dependency version has been removed, because is now discontinued.

- Spring-boot version has been updated to 2.1.4.RELEASE

- Spring Framework has been updated to 5.1.6.RELEASE version

<!end:213>

## 2.1.2-RELEASE Version

<!tag:212>

- Spring-boot version has been updated to 2.1.3.RELEASE

- Spring-cloud upgrade to Greenwich.RELEASE

<!end:212>

## 2.1.1-RELEASE Version

<!tag:211>

- The spring-boot version has been updated to 2.1.2.RELEASE

- Updated Spring Framework to version 5.1.4.RELEASE

<!end:211>

## 2.1.0-RELEASE Version

<!tag:210>

- The spring-boot version has been updated to 2.1.0.RELEASE

<!end:210>

## 2.0.1-RELEASE Version

<!tag:201>

- The spring-boot version has been updated to 2.0.6.RELEASE

- Fixed a critical bug that caused build-generated artifacts to not have all dependencies included.

- Updated the infinispan client version to 8.5.3.Final-redhat-00002

<!end:201>
