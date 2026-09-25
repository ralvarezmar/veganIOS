# Change Log

## Version 6.3.0

<!tag:630>

### 🐞 Bug Fixes

- Fix some issues in the test classes and configurations when archetype generated an `notweb` application.

<!end:630>

## Version 6.2.0

<!tag:620>

### 🐞 Bug Fixes

- Update packagesToScan OpenAPI configuration to use the proper package reference for the rest controllers inside the hexagonal architecture.

<!end:620>

## Version 6.1.2

<!tag:612>

### 🐞 Bug Fixes

- Added a HelloWorld example to the generated project when its created with the property 'api-first'.

<!end:612>

## Version 6.0.0

<!tag:600>

- Changed structure of generated project to use hexagonal architecture. Please refer to the archetype documentation to learn more about this architectural pattern.
- Removed line that verify bean `swaggerConfig` in `SwaggerConfigTest` class.
- Simplify the `pom.xml` in native mode. Remove limitation related to [Spring Boot Issue 36997](https://github.com/spring-projects/spring-boot/issues/36997).
- Added new parameters for partenon plugin in archetypes.
- Set `darwin.cache.caffeine.allow-null-values` to `false` by default in the microservice archetype.
- Removed `spring-context-indexer` dependency.

<!end:600>

## Version 5.6.0

<!tag:560>

- Fixed an issue where compilation of archetype would fail when the property `description` included a double quote.
- Fixed an issue creating the database archetypes in which the execution was failing when `database-client=false` and `database-client-type` value was different
from `oracle`, `postgresql`, or `undefined`.

<!end:560>

## Version 5.5.0

<!tag:550>

- Fixed documentation where the project structure was not being correctly defined in the readme.md.

<!end:550>

## Version 5.4.0

<!tag:540>

- Add property `server.max-http-request-header-size: 128KB` by default in servlet and reactive microservices.

<!end:540>

## Version 5.3.1

<!tag:531>

- Add property `darwin.core.headers.gluon-clientid-propagation` with value `true` for Gluon microservices.
- Updated documentation to keep using 'maven-archetype-plugin:3.2.1' generation

<!end:531>

## Version 5.2.1

<!tag:521>

- Remove password variable from configuration properties to avoid Fortify error.
- Added `ApplicationTestRun` class to launch application in local from tests scope in API First microservices.
- Solve issue using Spring Boot tests slice annotation (i.e: @DataJpaTest, @MockMvcTest, etc) in API First microservices.
- Don't return an error in case of request servlet native microservice with webservice client.
- Don't create Dockerfile for Gluon microservices. The dockerfile is going to be created by the Gluon CI/CD pipeline.
- Just create `PartenonRuntimeHints` class in Partenon native archetype.
- Disable in native mode test that use `@WithMockUser`. There is an issue in Spring Security.
- Fix `HelloControllerTest` in reactive mode. Select the correct application name.
- Fix sonar issues with `TBQQLService` in reactive mode.
- Add `PartenonRuntimeHintsTest` to increase coverage.
- Rename `CacheConfiguration` by `ApplicationConfiguration` and use it to register hints.

<!end:521>

## Version 5.2.0

<!tag:520>

- Added new native archetype allowing to create microservices with AOT active by default and compatible with native compilation.
- Fix error in `TBQQLControllerITTest`, now use the correct artifact id.
- New param database-client to add the database client configured in `database-client-type` or not (fix an issue creating a Darwin microservice using Gluon).
- Batch archetype: removed redundant CacheConfiguration class and moved EnableCaching annotation to Application class.
- Moved `application-local.properties` to test scope to avoid the presence of test code in the production scope and to avoid triggering fortify errors.
- In case of reactive and database client are both selected, instead of returning an error, now it will do nothing.

<!end:520>

## Version 5.1.0

<!tag:510>

- Add new oracle and postgresql archetypes that integrate the use of Databases with automatic code generation using DDL.,
- Add to partenon archetype the Gluon Partenon plugin to generate Partenon services in an automatic way.
- Add new property `darwin.cache.caffeine.async` for automatic creation of Caffeine caches in asynchronous mode to
simplify use of Cache annotations in reactive microservices.
- Fix error to log args when a notweb application is started without parameters.
- Add new option to batch archetype mode that makes use of the Darwin Batch Integration library.
Add also new parameters `batch-integration` and `batch-integration-version` for its creation and configuration.

<!end:510>

## Version 5.0.1

<!tag:501>

- Fix default Swagger headers. Change `X-ClientId` for `x-santander-client-id` if it is a gluon microservice.
- Add securityScheme component to default _openapi.yaml_ generated.

<!end:501>

## Version 5.0.0

<!tag:500>

- Add `darwin.logging.console-log-format` on application-local.properties and set it to `HUMAN_READABLE` by default in microservice archetype.

<!end:500>

## Version 4.3.3-RELEASE

<!tag:433>

- Fix Swagger headers of Gluon archetype
- Solve minor sonar issues in microservice archetype

<!end:433>

## Version 4.3.2-RELEASE

<!tag:432>

- Add Gluon Error Model customization examples for Gluon applications.

<!end:432>

## Version 4.3.0-RELEASE

<!tag:430>

- Add base folder for java sources and cache java class configuration to API First microservice.

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- All boolean parameters of Darwin Archetype Microservices now accepts "true/false" or "Y/N"
- Add mandatory job-name field for batch project.
- Add job name and archetype version trace to batch project.
- Disable darwin security by default in local environment for batch applications.
- Adds **api-spec-url** param to indicate OpenAPI definition file for APIFirst approach.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:410>

- Remove needless plugins: javadoc, source and site from microservice archetype and add spring-context-indexer to improve start time.
- Change errors from en_US and es_ES to en and us, to use en in en_UK and es in es_AR for example.

<!end:410>

## Version 4.0.2-RELEASE

<!tag:402>

- **component-name** field doesn't have value limitations for Gluon applications.

<!end:402>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

    - The creation of jobs and steps are updated to Spring Batch 5. Creation is no longer done with Job and Step Builder Factories.

- Removed @EnabledBatchProcessing annotation since the Spring Boot configuration autoconfigures all. Support for this annotation will be removed in the next version.

- Remove java 11 mode in archetype.

- Add dependency `springdoc-openapi-starter-webmvc-ui` to enable swagger-ui.

- Updated links in README's to GLUON repositories.

- Added API First option to microservice archetype.

- Fixed missing files for -Devents-component option.

<!end:400>

## 3.2.8-RELEASE Version

<!tag:328>

- **component-name** field doesn't have value limitations for Gluon applications.

<!end:328>

## 3.2.7-RELEASE Version

<!tag:327>

- New gluon parameter to create a Gluon based microservice:

    - Configure Gluon error format.

    - Require gluonlog properties: -Dgluonlog-company, -Dgluonlog-component-name, -Dgluonlog-component-id, -Dgluonlog-component-type, -Dgluonlog-app-id.

<!end:327>

## 3.2.5-RELEASE Version

<!tag:325>

- Deleted `jdbc-initialize-schema` property in batch archetype. Forced `snakeyaml` version to 1.33 when in batch mode.

<!end:325>

## 3.2.4-RELEASE Version

<!tag:324>

- Fixed graphql archetype for reactive microservices.

- Defined @OperativeControl SDL to graphql microservices that use authorization.

<!end:324>

## 3.2.3-RELEASE Version

<!tag:323>

- Now the -Dconfig-client param can be enabled without specifying 'Y' or 'N'.

<!end:323>

## 3.2.1-RELEASE Version

<!tag:321>

- Add file catalog.properties with optional catalog information.

<!end:321>

## 3.2.0-RELEASE Version

<!tag:320>

- New configuration in the batch archetype with local profile.

- New Global Log Format.

- Include always darwin-spring-boot-starter-core dependency.

- Adding support for Java 17.

- New ***logging-kafka*** property to enable/disable Darwin Logging with Kafka appenders (enabled by default).

- Fix: remove *sample-data.csv* file when isn't necessary.

- New ***cache-type*** property to select the cache to use (Caffeine, Infinispan or both)

- **Remove Spring Cloud Config Client configuration** for all generated applications

- Create **new "batch" *webAppType*** (remove *batch-component*), omnichannel library only by parameter, set caffeine as default cache and **remove Sagacity from archetype**.

- Fix sonar issues of generated projects.

<!end:320>

## 3.1.3-RELEASE Version

<!tag:313>

- Fix error. Solve the problem with sample-data.csv file not being deleted if the project were different from a batch project.

<!end:313>

## 3.1.2-RELEASE Version

<!tag:312>

- Fix error. Solve problem with resources not delete if the folder when execute the archetype contains a `.`.

<!end:312>

## 3.1.1-RELEASE Version

<!tag:311>

- Fix error. Delete files ExampleSagaControllerTest & ApplicationAutoConfigTest if app doesn't use sagacity or batch.

<!end:311>

## Version 3.1.0-RELEASE

<!tag:310>

- Change archetype test names to follow name convention in Sonar rule java:S3577.

- Include support to **Darwin GraphQL** module (*-Dgraphql*) and a basic example.

- New ***atlasClassification*** parameter to enable/disable ATLAS configuration and restrictions

- Configure `ISO-8859-1` as encoding to properties file in generated projects.

- Reduce the number of traces generated by setting the Application class trace level to INFO, and WARN the default trace level.

- Add the configuration for secure connection to a schema registry.

<!end:310>

## 3.0.4-RELEASE Version

<!tag:304>

- Fix ExampleSagaControllerTests path to delete if app doesn't use sagacity.

<!end:304>

## 3.0.0-RELEASE Version

<!tag:300>

- Translate microservice archetype to english.

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Added support for the Sagacity library.

- Mvnw script is fixed.

- The default lombok.config file is added, to avoid incorrect calculation of test coverage by using Lombok annotations.

- **Reduce NotWeb application modes**: now there is a unique NotWeb mode which **always include HttpClients** (RestTemplate/WebClient):

    - **spring-webflux**, **reactor-netty** and **httpclient** now are transient dependencies.

- The optional java-version parameter is removed from the archetype. Now, there is only one Java version available, version 11.

- `/${artifactid}` endpoint is added to the controller and `/hello` path field is added in the *sayHello* method.

- The bootstrap context initialization of property sources has been deprecated. Removed bootstrap.yml from archetype, and it has been adapted to the new Spring Boot Config Data
    API.

- Change field message by shortMessage in error properties files.

- Fix wrong "message" property level in errors\_en\_US.properties files.

- Modified the archetype to allow the acronym to start with a number.

<!end:300>

## 2.11.0-RELEASE Version

<!tag:2110>

- Feat: Now, a property is added to disable the configuration client corresponding to spring cloud config.

<!end:2110>

## 2.10.1-RELEASE Version

<!tag:2101>

- Fix: Added missing imports at archetype.

<!end:2101>

## 2.10.0-RELEASE Version

<!tag:2100>

- Include `server.shutdown` property with **graceful** value in the *application.yml* from generated web application.

    - Set graceful timeout (*spring.lifecycle.timeout-per-shutdown-phase*) to 2 minutes

- Fixed bug relating to .gitignore.From now on, .gitignore is properly located in the microservice just created.
  Furthermore, some errors have been corrected in the README file of the generated project.

- Remove the error properties for NotWeb apps.

- Config Swagger, added all default architecture headers and added *@schema* annotation to ErrorModelGateway

- Change the java version to java 11 if not the java version is specified in the create microservice archetype command.Updated instructions in README

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

- *Resource Bundle 'errors'* folder is added.The documentation is updated indicating the possibility of customizing the error messages based on the header language.

- Integration with the new library **darwin-spring-boot-events**.

<!end:290>

## 2.8.0-RELEASE Version

<!tag:280>

- From now on, we can use the new Spring Actuator liveness and readiness endpoints.

- New darwin-spring-boot-partenon module starter is added. Now, we will use it, instead of the original partenon-spring-boot-starter library. Also we will use our properties.

- A README file and a CHANGELOG file are added to the project generated by the archetype

- The configuration to use the proxy variables is added to the microservices archetype application.yml file

- The whitelist property for the actuator/health and actuator/info endpoints is removed from the properties file. A more specific description of the properties is added in the generated project README.

- The spring.security.filter and spring.security.user filters are removed. The microservices archetype README is updated with the change.

- Deprecated method setGroup is changed to group.

- The optional java-version parameter is added to the archetype.

- Rename ErrorModel class to ErrorModelDarwin.

<!end:280>

## 2.7.0-RELEASE Version

<!tag:270>

- Springdoc OpenAPI tags are added.

- The possibility of using token authentication with Swagger OpenApi has been added.

- A bug whereby Web tests were also created for NotWeb applications fixed..

- @NoProductiveProfile annotation removed from SwaggerConfig class

- The microservices archetype is adapted to the GoCloud initiative including the following changes:

    - The appKey and logging properties are renamed (not in the framework but in the archetype) to the equivalents defined by GoCloud.

    - The groupId, artifactId, and description are modified to be automatically generated from other parameters.

    - The Darwin Authentication, Cache and Omnichannel libraries, dependencies for the Spring Http clients and the Spring Configuration Service client are included in all projects.

    - All necessary validations are included in the *archetype-post-generate.groovy* script.

    - The archetype becomes usable only in *Batch* mode.

<!end:270>

## 2.6.2-RELEASE Version

<!tag:262>

- The archetype is modified to pass the Sonar validation rules.

- Swagger 2 usage is changed to Springdoc OpenAPI.
  The new configuration is added to the archetype so that,when creating a new application,
  the API's documentation generator is fully operational.
  Only applies to web environments.

- The `maven-replacer-plugin` version is removed, and a bug where the plugin configuration was not compatible with the new\` darwin-spring-boot-dependencies\` configuration is fixed.

<!end:262>

## 2.6.0-RELEASE Version

<!tag:260>

- Modify the archetype application.yml file so that the /actuator/info endpoint is added to the white-list.

- Set the **order of the SwaggerConfig to 105** in order to avoid conflicts with the TokenConfigurerAdapter

- Dependency with `darwin-spring-boot-starter-logging` and logging properties are **always** included

- Archetype adaptation to be able to generate the skeleton for the different **"applications flavors"**: notweb, notwebWithHttpClient, webServlet and webReactive.

    - Third-party dependencies (Spring, reactor, etc.) that are **not necessary in a NotWeb application are conditioned**.

    - Dependencies with `darwin-spring-boot-starter-authentication` and\` darwin-spring-boot-starter-omnichannel\` are included **as long as it is a web application (of any type)**.

    - The default properties generation **that are exclusively for a web application** is conditioned.

    - For a NotWeb application, the **package with the sample controller is removed**.

    - An **example implementation of CommandLineRunner** is added for a NotWeb application.

- All indicators used in the */health* endpoint of **Actuator** are disabled by default

- The **common services URLs** in the application-local.properties are updated

- `spring-boot-starter-actuator` dependency is always included.

- `darwin-spring-boot-starter-cache` dependency is no more mandatory. Now it will be asked for or included if it is a **Web application** `(Servlet / Reactive)` or Authentication is used.

<!end:260>

## 2.5.0-RELEASE Version

<!tag:250>

- We fixed the bug that the SwaggerConfig generated when the archetype was reactive and the package did not have the default value

- `darwin.security.sts-endpoint` property is removed from the auto-generated application.yml file.

- The possibility of including the Darwin Metrics component and the Railroad Switch library has been added.

- Project groupId that is generated with this archetype, can only have lowercase letters and dots (^\[a-z \\\]+$).

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- `spring.profiles.active` property removed from application.yml (still kept in bootstrap.yml).

- The Operational Control urls have been updated to be the Gateway ones.

- `darwin.logging.log-level` property default values, moved to\` logging.level\` in the application.yml

<!end:243>

## 2.4.1-RELEASE Version

<!tag:241>

- Local default configuration values included for the Partenon library, in order to avoid errors when starting the microservice

<!end:241>

## 2.4.0-RELEASE Version

<!tag:240>

- An option is added in order to ask for the Partenon connector inclusion and to include the component when generating the microservice

<!end:240>

## 2.3.1-RELEASE Version

<!tag:231>

- The logging-paasproject parameter is removed because now the logging library sets the default value.

<!end:231>

## 2.3.0-RELEASE Version

<!tag:230>

- Options have been added to distinguish between generating a reactive or non-reactive microservice.

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- Added option to ask for the inclusion of the new authorization starter.

- Default configuration files added following Darwin configuration policies

<!end:220>

## 2.1.3-RELEASE Version

<!tag:213>

- Added .gitignore file to be generated by default when archetype is used.

- Added option to ask for the WebClient and to include the appropriate component when generating the microservice.

<!end:213>

## 2.0.2-RELEASE Version

<!tag:202>

- Variable `spring.security.filter.order` name fixed. Variable name changed with version 2 of spring-boot. Previously it was `spring.security.filter-order`

- SwaggerConfig class bug that appeared when the authentication library was not incorporated into the archetype creation, fixed.

<!end:202>

## 2.0.1-RELEASE Version

<!tag:201>

- Control by profile is added to the class SwaggerConfig to prevent load in the environment PRO

- A security exception is added to Swagger URLs

- The necessary configuration is added in order to prevent the configuration server state from propagating in the 'health' actuator

- The complete actuator 'health' status is disabled by default (except for the authorized requests).

<!end:201>

## 2.0.0-RELEASE Version

<!tag:200>

- From now on, the dependencies are now the starters and the exception library disappears.

<!end:200>
