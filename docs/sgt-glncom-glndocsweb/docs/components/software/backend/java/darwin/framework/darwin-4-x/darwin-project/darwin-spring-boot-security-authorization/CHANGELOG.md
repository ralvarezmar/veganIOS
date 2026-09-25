# Change Log

## Version 4.3.0-RELEASE

<!tag:430>

- Fix a bug that was initializing *clientId* and *contractId* as "null" String.

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- Fixed documentation typo of header 'X-Control-Operativo'.
- Amend pom.xml to verify module in native mode.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:411>

- Change the level from `ERROR` to `WARN` of the trace that it is logged when the authorization method list property is empty.

<!end:411>

<!tag:410>

- Fix issue related to validate white authorization list when X-Forwarded-prefix is informed.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.2.4-RELEASE Version

<!tag:324>

- Fixed error description when omnichannel is required but is not found.

<!end:324>

## 3.2.0-RELEASE Version

<!tag:320>

- Now Darwin Core can enable/disable the propagation headers.

- Optimize dependencies and check omnichannel dependency in Spain case.

- To improve traceability, the HttpClient wiretap can now be enabled from config.

- The traditional Darwin operational security has been marked as deprecated for the following release. It is recommended to use the Multi-entity operational security process.

<!end:320>

## 3.1.3-RELEASE Version

<!tag:313>

- Remove patch for error solved in spring-cloud 2021.0.4

<!end:313>

## 3.1.2-RELEASE Version

<!tag:312>

- Added new field "cardId" in AuthorizationData model

- Adding a new authorization manual mode: Portugal manual authorization.

    - Modify configuration to include a new Portugal Manual Authorization configuration.

    - Property *darwin.security.authorization.manual.mode* has multiple values (SPAIN and PORTUGAL).

    - New **bolaseg endpoint property**.

    - Fix AuthorizationBaseAutoConfig' ConditionalOn OmniChanelAutoConfig bean.

    - Add a new connector for calling Portugal operative control service.

    - Implementing the Portugal Authorization service in order to offer an API for validating operative security.

<!end:312>

## 3.1.0-RELEASE Version

<!tag:310>

- Change AuthorizationToken and AuthorizationTokenVerifier implementation because upgrade nimbus dependency

- Fix some test that have been broken by change in core pom.xml

- Add support for using authorization server instead of PKM for validate tokens

- Added support for operative control on GraphQL applications through schema directives

    - Adding a new directive on field: @OperativeControl.

    - Adding two new directives on arguments: @ClientId and @ContractId.

    - Adding a new directive on field: @AuthorizationWhiteList.

    - Implementing an operative Control directive wiring for using the OperativeControlFacade in order to apply the operative security.

    - Implementing an Input Parameter directive wiring in order to read the values of ClientId parameter and the ContractId parameter.

    - Controlling the use of @AuthorizationWhiteList directive on fields in order to skip the operative security for the operations.

    - Adding RequestContextHolder management in Authorization scheduler hook in order to copy the context when a thread change happens.

    - Improving Authorization scheduler hook configuration in order to create and destroy properly the instrumentation.

- Adding the `darwin.security.authorization.manual.mode` property in order to expose the authorization service component for applying the operative security manually and to disable the annotation instrumentation in web applications.

- Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

<!end:310>

## 3.0.3-RELEASE Version

<!tag:303>

- The way of creating a HttpClient has changed with the new version of reactor-netty. In order to maintain the back compatibility, HttpClient MaxConnections property is set to 500 (default values is calculated according to the number processor).

<!end:303>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- `OC Connectors` beans marked with **@ConditionalOnMissingBean** so they can be overridden.

- Authorization POJOs (Client, Contract and Contrato) **moved from Common library**.

- Update NotWebWithHttpClient references to `NotWeb`.

- Update the metadata files with all defined properties and those that have been deprecated.

- Rename KEY\_PROVIDER\_ERROR constant to `PKM_SERVICE_ERROR` and update value.

- New `AbstractOCProcessorImpl` class containing common *fillInChannel()* method for both Servlet/Server implementations.

- Using HttpClient instead of TcpClient in order to create connectors of the WebClient.

- Remove unnecessary WebClient.Builder clones.

- Performing warm-up for Authorization HttpClient.

- Replace OC Resilience4j annotations with Resilence4j API.

- Use AuthenticationBearerToken and Token objects from SecurityContext in Servlet applications

    - Rename *updateAuthenticationParameters()* from OCProcessor to ***updateAuthentication()***

- Using new API of Reactor.

    - Using Mono.defer(supplier) into SwitchIfEmpty operator when a Mono.error(throwable) is defined. The target of this use is to avoid creating the exception during assembly time.

    - Deleting use of doOnError(error) operator and onErrorResume(error) operator to throw new exceptions. OnErrorMap is used instead.

    - Using new Reactor Context API to access and to write the security Context

    - Using new mapNotNull(function) operator to simplify streams.

- BugFix for WebClient customization: now all WebClient properties can be configured without any binding with other properties.

<!end:300>

## 2.11.1-RELEASE Version

<!tag:2111>

- Now Authorization configuration loads the ApplicationType beans from Core configuration.

<!end:2111>

## 2.11.0-RELEASE Version

<!tag:2110>

- Client validation is done by evaluating the environment (face-to-face environments: INTRANET, CONTACTCENTER) associated with the channel. For face-to-face channels is not necessary to validate the client id. Before a list of face-to-face
    channels were used to assess the channel, now a list of environments is used.

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

<!end:2110>

## 2.10.4-RELEASE Version

<!tag:2104>

- Change the entire multientity control operative to be based on one endpoint using three scopes.

- Change all LeanCore references to Multientity references everywhere within the authorization module.

<!end:2104>

## 2.10.2-RELEASE Version

<!tag:2102>

- Kebab Case support for Authorization Properties.

<!end:2102>

## 2.10.0-RELEASE Version

<!tag:2100>

- Change public LeanCore references to Multientity reference in configuration classes, properties, and documentation.

- Fix misbehavior. OC Reactive interceptor must not manage exceptions thrown by the WebClient invocation.

- Fix bug. Exceptions weren't propagated properly when controller method had Flux as return type

- Fix bug. Downgrade *nimbus-jose-jwt* dependency to 8.20.

- Added maxLifeTime to WebClients.

- Added new test to test WebClients with maxLifeTime

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- The WebClient configuration has changed. AuthorizationProperties.WebClient static class has been added, and it allows overwriting default Core webclient value.

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

- Configuration property has been created in order to define which authorization processes should be loaded. Also, a configuration property has been created in order to set a priority over the available authorization processes.

- Lean Core solution integration and unit tests have been reviewed and completed for authorization.

- Lean Core authorization code has been integrated into the authorization module.

<!end:290>

## 2.7.0-RELEASE Version

<!tag:270>

- The explanation of the channel use whitelist has been expanded. The description has been clarified, and a brief definition of the technical solution has been added.

<!end:270>

## 2.6.3-RELEASE Version

<!tag:263>

- Subscription has been added by completableFuture to the authorization upstream filter logic.

<!end:263>

## 2.6.2-RELEASE Version

<!tag:262>

- Swagger endpoint management has been added to the authorization process.

<!end:262>

## 2.6.1-RELEASE Version

<!tag:261>

- The operational control will not be applied for channels white list.

<!end:261>

## 2.6.0-RELEASE Version

<!tag:260>

- The use of block in the CO connectors has been eliminated. For the CO connectors WebClients, we use the new interceptor that copies the contexts between the WebClient thread (reactor thread) and the Tomcat transport thread.

- The library configuration now depends on the application type, where it is added as a dependency. The AuthorizationAutoConfig class contains settings that are independent of the application type. The AuthorizationWebAppAutoConfig class contains
    the configuration corresponding to the web applications, both `Reactive` and `Servlet`. And the AuthorizationBaseAutoConfig class contains the configuration of non-web applications.

- The ReactiveAuthorizationService and ServletAuthorizationService classes have been created. This classes allow executing the authorization process from a not-web application.

- Scope and OperationType enumerations have been moved to the `darwin-spring-boot-common` module.

<!end:260>

## 2.5.0-RELEASE Version

<!tag:250>

- We have limited the circuit-breaker opening for CO only for 5XX errors.

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- The Operational Control endpoints, that appear in the documentation, have been updated.

- We added the use of Resilience4j for Retry and Circuit Breaker implementation in calls to Operational Control.

<!end:243>

## 2.4.0-RELEASE Version

<!tag:240>

- The scope of use of the library has been extended in order to support `Reactive` environments. The library now allows the use of its functionality both in applications developed with Spring-MVC and Spring-WebFlux.

- Location change of the AuthorizationProperties.java class within the library. It is now located within the authorization.config package.

- The OCTJwtToken class has been replaced by AuthorizationToken as a wrapper for an authorization JWT token.

<!end:240>

## 2.3.3-RELEASE Version

<!tag:233>

- Fixed an issue where exceptions thrown by the operational control service were not being handled correctly.

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- The synchronization in cache use has been deleted to make it compatible with the version of infinispan that we are using.

- The property darwin.security.enabled = true (default value) condition the configuration library.

- Now, the library makes use of webClient (instead of restTemplate) for the operational control services invocations.

<!end:232>

## 2.3.0-RELEASE Version

<!tag:230>

- Starting with this release, it will no longer be necessary to mark WebClient and WebClient.Builder bean types with the @DarwinQualifier annotation. At application startup, all WebClient and WebClient.Builder bean types will be detected, and the
    OCFilterFunction interceptor will be injected. This will be the default behavior, and you can disable it through the darwin.core.webclient.enabled = false property.

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- Authorization starter first version has been released.

<!end:220>
