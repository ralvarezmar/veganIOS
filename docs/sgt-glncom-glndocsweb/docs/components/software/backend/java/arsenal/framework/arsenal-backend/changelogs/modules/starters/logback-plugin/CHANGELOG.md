# Changelog

All notable changes to project `gln-back-arsenal-backend-logback-plugin` will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [3.10.0]

<!tag:3100>

### Deprecated

- Deprecated this library due to vulnerability in jersey-shaded:0.9.1 that has wrapped
jackson-databind:2.10.1 (jersey-shaded-0.9.1.jar/META-INF/maven/com.fasterxml.jackson.core/jackson-databind/pom.xml:12) and has 5 vulnerabilities.
Jersey is a transitive dependency from com.hortonworks.registries.schema-registry-serdes:0.9.1

<!end:3100>

## [3.9.4] - 2024-02-28

<!tag:394>

### Updated

- nimbus-jose-jwt version 9.37.3 to solve vulnerability CVE-2023-52428

<!end:394>
