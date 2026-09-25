# Darwin-spring-boot-archetype-function Migration guides

## Version 5.5.0

<!tag:550>

- Plugin `maven-archetype-plugin:3.3.1` is now compatible with previous Velocity versions. However, its use is recommended with a specific version `mvn org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate` instead of `mvn archetype:generate`.

<!end:550>

## Version 5.3.1

<!tag:531>

- Plugin `maven-archetype-plugin:3.3.0` now uses Velocity 2.3 instead of 1.7, causing incompatibility errors. For this reason, please use `mvn org.apache.maven.plugins:maven-archetype-plugin:3.2.1:generate` instead of `mvn archetype:generate`.

<!end:531>

## Version 3.2.0-RELEASE

<!tag:320>

- As of this version, `org.projectlombok:lombok` dependency will always be added.

<!end:320>
