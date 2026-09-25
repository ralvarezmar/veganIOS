# CHANGELOG

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- Updated links in README's to GLUON repositories.

<!end:400>

## 3.2.7-RELEASE Version

<!tag:327>

- Fix: -Dpackage attribute can no longer be 'com.santander.darwin'.

<!tag:327>

## Version 3.2.3-RELEASE

<!tag:323>

- Now the -Dconfig-client param can be enabled without specifying 'Y' or 'N'.

<!end:323>

## Version 3.2.0-RELEASE

<!tag:320>

- New ***omnichannel-library*** property to add Darwin OmniChannel library to the archetype.

- New Global Log Format.

- Include always darwin-spring-boot-starter-core dependency.

- Adding support for Java 17.

- **Add maven-wrapper jar and properties files** and **update mvnw** scripts

- New ***logging-kafka*** property to enable/disable Darwin Logging with Kafka appenders (enabled by default).

- New ***cache-type*** property to select the cache to use (Caffeine, Infinispan or both)

- **Remove Spring Cloud Config Client configuration** for all generated applications

<!end:320>

## Version 3.1.0-RELEASE

<!tag:310>

- Fix Error generating project from archetype due to README error definition.

- Change archetype test names to follow name convention in Sonar rule java:S3577.

- Add the configuration for secure connection to a schema registry.

<!end:310>

## Version 3.0.0-RELEASE

<!tag:300>

- Translate function archetype to english.

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- The optional java-version parameter is removed from the archetype. Now, there is only one Java version available, version 11.

- `/${artifactid}` endpoint is added to the controller and `/hello` path field is added in the *sayHello* method.

- The bootstrap context initialization of property sources has been deprecated. Removed bootstrap.yml from archetype, and it has been adapted to the new Spring Boot Config Data
    API.

- Change field message by shortMessage in error properties files

- Fix wrong "message" property level in errors\_en\_US.properties files

- Modified the archetype to allow the acronym to start with a number.

<!end:300>

## Version 2.11.0-RELEASE

<!tag:2110>

- Feat: The first version of the function archetype for Darwin is released.

<!end:2110>
