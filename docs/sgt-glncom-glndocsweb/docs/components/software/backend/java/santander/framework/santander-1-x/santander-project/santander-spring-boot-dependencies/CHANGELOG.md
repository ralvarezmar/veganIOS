# Change Log

## Version 1.2.1

<!tag:121>

### 🐞 Bug Fixes

- Remove references to external maven repositories. Just use user local configured repositories. That include remove the maven profile `spring-milestone`.

### 🔨 Dependency Upgrades

- Upgrade `spring-boot` to 3.5.6.
- Upgrade `blockhound` to 1.0.13.
- Upgrade `springdoc-openapi` to 2.8.13.
- Upgrade `swagger-annotations` to 2.2.36.
- Upgrade `infinispan` to 15.0.19.Final-redhat-00001.
- Upgrade plugin `openapi-generator-maven-plugin` to 7.15.0.
- Remove dependency `netty` version 4.1.124.Final. Solve vulnerability **CVE-2025-58056**.
- Upgrade plugin `flatten-maven-plugin` to 1.7.2.
- Upgrade plugin `maven-surefire-report-plugin` to 3.5.4.

<!end:121>

## Version 1.1.0

<!tag:110>

### 🔨 Dependency Upgrades

- Upgrade `spring-boot` to 3.5.4.
- Upgrade `spring-cloud` to 2025.0.0.
- Upgrade `apache-camel` to 4.8.8.
- Upgrade `confluent` to 7.9.2.
- Upgrade `commons-io` to 2.20.0.
- Upgrade `commons-text` to 1.14.0.
- Upgrade `infinispan` to 15.0.16.Final-redhat-00001.
- Upgrade `swagger-annotations` to 2.2.34.
- Upgrade `bouncycastle.bcprov-jdk18on` to 1.81.
- Upgrade `mds-dualrun-lib` to 1.3.7.
- Upgrade `logback` to 1.5.18.
- Upgrade `spring-framework` to 6.2.10. Solve vulnerability **CVE-2025-41242**.
- Upgrade `tomcat` to 10.1.44. Solve vulnerability **CVE-2025-48989**.
- Manage dependency `netty` version 4.1.124.Final. Solve vulnerability **CVE-2025-55163**.
- Removed `kafka.version` version. Managed by *Spring Boot*.
- Removed `sshd` version. Managed by *Spring Cloud*.
- Removed `avro` version. Managed by *Confluent*.
- Upgrade plugin `flatten-maven-plugin` to 1.7.1.
- Upgrade plugin `maven-site-plugin` to 3.21.0.
- Upgrade plugin `maven-surefire-plugin` to 3.5.3.
- Upgrade plugin `openapi-generator-maven-plugin` to 7.14.0.
- Upgrade plugin `spring-javaformat-maven-plugin` to 0.0.47.

<!end:110>

## Version 1.0.1

<!tag:101>

### 🔨 Dependency Upgrades

- Manage dependency `tomcat` version 10.1.43. Solve vulnerability **CVE-2025-52520**.

<!end:101>

## Version 1.0.0

<!tag:100>

### ⭐ New Features

- Initial version. Based on Darwin Spring Boot version 6.2.1.

### 🔨 Dependency Upgrades

- Upgrade `partenon-maven-plugin` to 3.0.0.
- Manage dependency `santander.java.library` version 1.0.0.
- Manage dependency `kafka-clients` version 3.9.1. Solve vulnerability **CVE-2025-27817**.
- Manage dependency `spring-framework` version 6.2.8. Solve vulnerability **CVE-2025-41234**.

<!end:100>
