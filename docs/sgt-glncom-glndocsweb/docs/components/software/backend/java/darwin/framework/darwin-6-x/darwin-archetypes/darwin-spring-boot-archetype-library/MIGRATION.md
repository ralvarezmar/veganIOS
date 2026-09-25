# Darwin-spring-boot-archetype-library Migration guides

## Version 6.0.0

<!tag:600>

- Removed line that verify bean  `helloWorldAutoConfig` in `HelloWorldAutoConfigTest` class. In Spring 3.4 the configuration class bean name changed.
  In this case the bean `helloWorldAutoConfig` is called `${package}.HelloWorldAutoConfig`, to avoid issues we remove the test.

<!end:600>

## Version 5.5.0

<!tag:550>

- Plugin `maven-archetype-plugin:3.3.1` is now compatible with previous Velocity versions. However, its use is recommended with a specific version `mvn org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate` instead of `mvn archetype:generate`.

<!end:550>

## Version 5.3.1

<!tag:531>

- Plugin `maven-archetype-plugin:3.3.0` now uses Velocity 2.3 instead of 1.7, causing incompatibility errors. For this reason, please use `mvn org.apache.maven.plugins:maven-archetype-plugin:3.2.1:generate` instead of `mvn archetype:generate`.

<!end:531>
