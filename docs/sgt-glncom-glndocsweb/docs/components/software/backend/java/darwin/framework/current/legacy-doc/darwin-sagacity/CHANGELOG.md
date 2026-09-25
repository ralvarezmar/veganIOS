# Change Log

## 3.1.0-RELEASE Version

<!tag:310>

- Now we use in Darwin Sagacity Starter the OracleJDBC managed by Spring: `com.oracle.database.jdbc:ojdbc:21.3.0.0`

<!end:310>

## 3.0.0-RELEASE Version

<!tag:300>

- We release *darwin-spring-boot-sagacity* library *first version*.
  This module incorporates the Sagacity library that allows distributed transactionality using the Saga algorithm.
- Dependencies and plugins upgrade:
  - With the new version of Spring Boot 2.6.0, Circular References are prohibited by default. `sagacity-fwk-starter` module has a Circular reference because of using an older Spring Boot version as version base.
    It is necessary to use an `EnvironmentPostProcessor` to allow Circular References setting `spring.main.allow-circular-references` property to *_true_*.
  - The Last version of Spring Boot uses a new version of Oracle ojdbc8 dependency. For Sagacity is necessary to use a specific version. Up to Sagacity updates theirs dependencies, it is necessary to force 19.3.0.0 version of `com.oracle.ojdbc.ojdbc8`.

<!end:300>
