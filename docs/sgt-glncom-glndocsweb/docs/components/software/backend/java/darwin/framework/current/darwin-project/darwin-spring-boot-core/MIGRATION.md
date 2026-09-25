# Darwin-spring-boot-core Migration guides

## Version 6.3.0

<!tag:630>

- One of the behaviors that has changed is the configuration of follow redirect when building a `WebClient` using the
  `WebClient.Builder` provided by the architecture.
  To keep the same behavior as before, you need to set the following property:

```properties
spring.http.reactiveclient.redirects=dont-follow
```

- The implementation of `darwin.core.http-clients.apache-http-client.read-timeout` has been changed.
  Before, it was used `setResponseTimeout`, now we are using `setSoTimeout`.
  We did this change to align with the behavior of Spring Boot implementation of `spring.http.client.read-timeout` property.

- Method `ConnectionsUtils::setUpNettyHttpClient` has been deprecated and will be removed in the future.
  If you were using this method, it is recommended to use the method `ConnectionsUtils::nettyHttpClientCustomizer` instead.

<!end:630>

## Version 6.0.0

<!tag:600>

- A `RestTemplate` is no longer created by default and `WebClient` beans are not modified to add Darwin interceptors.
  Now it is recommended to always use the corresponding builder (`RestClient.Builder`, `WebClient.Builder`, or `RestTemplateBuilder`) to create web clients with Darwin interceptors.
  If you want to maintain the behavior of previous versions, then you must set the following properties to true: `darwin.core.webclient.customize-beans` and `darwin.core.resttemplate.customize-beans`.
- `CopyContextFilterFunction` has been deprecated and are no longer used by
  the framework. If you were using this classes, it is recommended not to do so and to remove their use.
  The reason it have been removed is that the contexts are already being propagated correctly, and it is not
  necessary to do it manually. Please check the core library documentation for more information.
- Method `DarwinContext::getCurrentContext(boolean)` has been deprecated and will be removed in the future.
  If you were using this method, it is recommended to use `DarwinContextHolder::getCurrentContext()`,
  `DarwinContextHolder::getCurrentContextOrThrow()` or `DarwinContext::getCurrentContextIfPresent()` instead.
- Methods `ConnectionsUtils::configureWebClientBuilder` and `ConnectionsUtils::buildApacheHttpClientFactory` have been deprecated and will be removed in the future.
  If you were using these methods, it is recommended to use the methods `ConnectionsUtils::fromNettyClientProperties`,
  `ConnectionsUtils::setUpNettyHttpClient`, `ConnectionsUtils::buildNettyConnectionProvider`,
  `ConnectionsUtils::setUpApacheConnectionManager` or `ConnectionsUtils::setUpApacheHttpClient` instead.
- `WebClientConfigProperties` has been deprecated and will be removed in the future. If you were using this class, it is recommended to use `CoreProperties.NettyClientProperties` instead.
- In case you are using the properties `darwin.core.rest-template` and `darwin.core.rest-client` at the same time, the `darwin.core.rest-client` will be ignored and use the `darwin.core.rest-template` for RestClients configuration.
- `DarwinContext::getCustomizeActivityLog` and `DarwinContext.DarwinContextBuilder::customizeActivityLog` methods have been deprecated
  and will be removed in the future.
  If you were using this method, it is recommended to use `io.micrometer.tracing.Baggage` instead.
  You could find more information about how to use baggage in [Spring Boot documentation](https://docs.spring.io/spring-boot/reference/actuator/tracing.html#actuator.micrometer-tracing.baggage).
- The default context propagation strategy for non-web applications has been changed to `MODE_THREADLOCAL` instead of `MODE_GLOBAL`.
  If you want to maintain the behavior of previous versions, then you must set the following property to `MODE_GLOBAL`: `darwin.context.strategy`.

<!end:600>

## Version 5.3.1

<!tag:531>

- Fix property name `darwin.core.headers.include-api-client-id` introduced in Darwin 5.3.0 to `darwin.core.headers.gluon-clientid-propagation` to match the actual feature of the property.

<!end:531>

## Version 5.3.0

<!tag:530>

- The DarwinContext interceptors/filterFunctions have changed their constructors to **expect a boolean parameter that indicates
if API ClientId headers must be sent or not**, instead of "xclientCompatibility" property (wasn't used).

<!end:530>

## Version 5.0.0

<!tag:500>

- `DarwinErrorAttributes::getErrorAttributes` in case there in no error attributes it response a empty Map instead of a `null` value.
- The `ConnectionsUtils::createHttpClient` method is no longer public. You could use directly the `buildWebClient` or `withDefaultProperties` methods instead. However, `ConnectionsUtils` is considered as internal class and subject to API changes.
**We strongly recommend not to use it**.
- `DarwinContext` no longer implement Serializable. We have removed the Serializable implementation because, although DarwinContext was marked as such, its content was not, so it could not be serialized.
- We have changed the asynchronous thread pool configuration which was set to "Discard" and was using `DarwinRejectedExecutionHandler` to
  the default "AbortPolicy" that will make the executor to reject a task if this is saturated.
- **`CoreProperties.RestTemplate` class has been deprecated** and will be removed, use `CoreProperties.ApacheHttpClientProperties` instead.
- **`ConnectionsUtils` methods have been deprecated** and will be removed, use `ConnectionsUtils::configureWebClientBuilder` instead.

<!end:500>

## Version 4.1.0-RELEASE

<!tag:410>

- By requirements, we have changed the type of the `code` field in the `Gluon` error format, from `Integer` to `String`.
  This change could have some kind of impact on applications when that field is processed as Integer.
  So, if it is necessary to keep the previous format, `EXTENDED_ERROR` error format can be used instead.

<!end:410>

## Version 4.0.2-RELEASE

<!tag:402>

- Change the behaviour of the error literals. Previously, if the channel and entity were reported, only the error literal with the channel and entity were searched. Now, in case it does not find it, it looks for it without the channel and entity.

<!end:402>

## Version 4.0.0-RELEASE

<!tag:400>

- If you are using `DarwinTaskDecorator` you have to replace it by one of the next one:

    - The bean of type `TaskDecorator taskDecorator` that is available for you use it.

    - It is equivalent an object created as

            ContextSnapshotFactory contextSanpshotFactory = ContextSnapshotFactory.builder().build();
            TaskDecorator taskDecorator = runnable -> contextSanpshotFactory.captureAll().wrap(runnable);

<!end:400>

## Version 3.2.0-RELEASE

<!tag:320>

- We removed the access to these dependencies using Darwin Core: **org.slf4j:slf4j-api, net.minidev:json-smart, org.apache.commons:commons-lang3 and commons-io:commons-io**. If you were using any of them now you have to include them directly in
    your pom file.

- **Now Darwin Core doesn't load its configuration automatically**, to continue having the same behaviour as before now you have to replace Darwin Core dependency with Darwin Starter Core dependency: **com.santander.darwin:darwin-spring-boot-core
    → `com.santander.darwin:darwin-spring-boot-starter-core`**

- We advise against using @DarwinQualifier on ObjectMapper injection. It's better to use Spring Boot ObjectMapper.

<!end:320>

## Version 3.0.0-RELEASE

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Now the Darwin Core library always include these transient dependencies: `org.springframework:spring-webflux`, `io.projectreactor.netty:reactor-netty` and `org.apache.httpcomponents:httpclient`.

- From now on, the `message` field from Darwin error model is replace by `shortMessage` at errors.properties file. (e.g my\_custom\_exception.shortMessage=Peticion mal formada).

- From now on, the `errorName` from *HttpMessageNotReadableException* → `httpmessage_not_readable_exception`, is replace by `http_message_not_readable_exception`.

- Removed `isReactive` bean. Bean `webApplicationType` has been created to indicate the type of application.

- **Removed *createEmptyContext()*** method from DarwinContextHolderStrategy implementations.

- The way of configuring the connector for the WebClient has changed. Now, instead of using an instance of `TcpClient` to add timeouts and to configure the pool of connections, `HttpClient` class is used in the same way. For more information,
    looking up the following [section](README.md#resttemplate-and-webclient-configuration).

- The GenericUtils class has been renamed to Utils.

- `ReactiveDarwinContextHolder` has suffered changes and now the DarwinContext class is stored as `Object` inside Reactor Context instead of `Mono<DarwinContext>`. In order to access and to modify the value of the DarwinContext, there several
    methods to work with it:

    - ***ReactiveDarwinContextHolder.withDarwinContext(DarwinContext)*** return a reactor `Context` instance containing the `DarwinContext` passed as parameter.

    - ***ReactiveDarwinContextHolder.getContext()*** returns the DarwinContext as `Mono<DarwinContext>`. In the absence of DarwinContext, a Mono empty will be emitted.

    - ***ReactiveDarwinContextHolder.getContext(ContextView)*** returns the DarwinContext as `Object` from `ContextView` instance. In the absence of DarwinContext, null values will be returned.

- Removed unused `DarwinExceptionCode` enum.

- Removed unused `hystrix` package.

- Removed unused `CoreHystrixAutoConfig` class from the **config** package.

### Spring Boot Config Data Migration Guide

With the upgrade to the new version of Spring Boot, it is necessary to adapt the config files in order to take advantage of the new improvements provided in it. There are three changes that they have to be considered: the way that the
application.yaml and application.properties are loaded and processed has been updated, the way of loading external configuration has been simplified, and the use of Bootstrap files (bootstrap.yml, bootstrap.properties) has been removed. Together
with these changes, new features and constrains are provided in order to offer an enhanced config file processing.

#### Legacy mode

If an application is not ready to use the new Spring Boot Config API, a legacy mode exists. To activate the ***legacy mode***, it is necessary to add `spring.config.use-legacy-processing=true` in the configuration. The easiest way to do this is to
add it to the application.properties or application.yaml.

    spring:
      config:
        use-legacy-processing: true

In addition, Darwin provides a library to help projects maintain backward compatibility and make the task of updating the framework version easier. Darwin Sprint Boot Legacy can be added as dependency as follows:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-legacy</artifactId>
        <version>${version}</version>
    </dependency>

This module activates the legacy mode by using the `spring.config.use-legacy-processing=true` property and migrates the Darwin deprecated properties to the new ones. For more information about Darwin Sprint Boot Legacy, the documentation is
available [here](https://gluon.dev.corp/microservices/docs/darwin-spring-boot-legacy).

#### How to migrate bootstrap files

With new version of Spring Boot, the bootstrap files, both the bootstrap.yaml and bootstrap.properties, has been deprecated and all the properties defined in these files have to be moved to application.yaml or application.properties. Hence,
bootstrap files will never be processed further and must be removed from the configuration.

An example of a bootstrap.yaml could be:

    darwin:
      region: boae
      suffix:
    spring:
      application:
        name: darwin-events
      cloud:
        config:
          uri: http://configuration-service${darwin.suffix}:8080/
          fail-fast: false

These properties simply has to be placed in the application.yaml or application.properties. Once finished the migration, the bootstrap file have be removed.

#### How to use the new features

Spring Boot team has worked hard in order to improve and simplify the config file processing. They are introduced a new
set of features and constraints that they have to be considered before migrating the file configuration.

First thing to examine, the `spring.profiles.active` property can still be used to activate specific profiles but only in
non-profile-specific document, i.e. it can never be used in application-&lt;profile&gt; files.

For example, it can be added to an application.properties o application.yaml:

    some.message=hello world!
    spring.profiles.active=local

When a multi-document YAML is used, an important constraint added is that the `spring.profiles.active` property should
no longer be used in combination with `spring.config.activate.on-profile`.

!!! tip "Important"

    A multi-document YAML is a yaml file where it exists different configuration separated by dashes (`---`).
    Each configuration is taken as a different file and the max priority order is assigned to lower properties
    in the file, i.e. the properties values lower will overwrite higher properties values.

For example, this will fail:

    some:
      message: hello world!
    - --
    spring:
      profiles:
        active: local
      config:
        activate:
          on-profile: dev
    some:
      message: hello earth!

The proper way to do that is:

    some:
      message: hello world!
    spring:
      profiles:
        active: local
    - --
    spring:
      config:
        activate:
          on-profile: dev
    some:
      message: hello earth!

If the `spring.profiles` property is used, for example, in a multi-document YAML files, it should be migrated to
`spring.config.activate.on-profile`.

Before Darwin Spring Boot 3.0, it was possible to have something like this:

    spring:
      profiles: "mysql"
      datasource:
        url: "jdbc:mysql://localhost/test"
        username: "dbuser"
        password: "dbpass"
    - --
    spring:
      profiles: "rabbitmq"
      rabbitmq:
        host: "localhost"
        port: 5672
        username: "admin"
        password: "secret"

Now with the new version, it is necessary to use the `spring.config.activate.on-profile` property:

    spring:
      config:
        activate:
          on-profile: "mysql"
      datasource:
        url: "jdbc:mysql://localhost/test"
        username: "dbuser"
        password: "dbpass"
    - --
    spring:
      config:
        activate:
          on-profile: "rabbitmq"
      rabbitmq:
        host: "localhost"
        port: 5672
        username: "admin"
        password: "secret"

Likewise, `spring.profiles.include` property can still be used, but only in non profile-specific documents, i.e. application.yaml or application.properties. For example:

    spring:
      config:
        activate:
          on-profile: "dev"
      profiles:
        include: "devlocal,devcloud"

The new version of Spring Boot has introduced a new way to import configuration data via the `spring.config.import` property. This is now the default way to bind to Config Server. In addition, it is mandatory, so it will no longer fail silently if
the property does not exist. If it isn't necessary to define a location or this doesn't exist, the prefix `optional:` should be used.

    spring.application.name=darwin-app
    spring.config.import=local.properties

Keep in mind that it can be used together with `spring.config.activate.on-profile` in order to load different configurations in function of the profile:

    spring:
      config:
        activate:
          on-profile: pre
        import: pre.properties
    - --
    spring:
      config:
        activate:
          on-profile: prod
        import: prod.properties

!!! info "Important"

    Imports can be considered as additional documents inserted just below the document that declares them. They follow the same top-down ordering as regular multi-document files: ***An import will only be imported once, i.e. once
    processed the first appearance of the `spring.config.import`, no further appearances of the property will be read***. Keep in mind that if the `spring.config.import` property is defined in a non-profile-specific document (**application.yml** as
    default configuration) and its value is overwritten in a specific-profile document (for example, **application-dev.yml**), the value used in order to import the configuration source, will be the first found, i.e. the value set in the default
    configuration document (**application.yml**). The rest of the appearances will be skipped, the values defined in the profile-specific documents (**application-dev.yaml**) will be bypassed.

In order to connect to config server to use the following property in an application.properties or application.yaml:

    spring.config.import=optional:configserver:http://myhost:8888

The old properties to configure the different services are still supported but need to be moved from bootstrap.yaml or bootstrap.properties to application.properties or application.yml.

For example, the old way to define a config server in order to load configuration could be the following bootstrap.yaml:

    spring:
      application:
        name: darwin-app
      cloud:
        config:
          uri: http://configuration-service:8080
          fail-fast: false

Now, with the new API, these properties have to be moved to an application.yaml. The simplest way to migrate that is:

    spring:
      application:
        name: darwin-app
      config:
        import: optional:configserver:http://configuration-service:8080

or even:

    spring:
      application:
        name: darwin-app
      config:
        import: "optional:configserver:"
      cloud:
        config:
          uri: http://configuration-service:8080/

Removing the `optional:` prefix will cause the Config Client to fail if it is unable to connect to Config Server. This is similar to set `spring.cloud.config.fail-fast=true`.

!!! info "Important"

    For more information, the `Spring Boot Config Data Migration` [guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-Config-Data-Migration-Guide) is available.

!!! info "Important"

    For more information about how to configure a config server, the `Spring Cloud Config Client` [guide](https://docs.spring.io/spring-cloud-config/reference/4.3/#_spring_cloud_config_client) is available.

!!! info "Important"

    In addition, the [Config file processing in Spring Boot](https://spring.io/blog/2020/08/14/config-file-processing-in-spring-boot-2-4) article is available in the Spring Blog.

#### Migration example

An example migration from Darwin Spring Boot 2.11.X to Darwin Spring Boot 3.0.

Some application have the following combination of bootstrap.yaml and application.yaml configuration. This application uses the old version of Spring Boot and the Bootstrap context is activated. It is mandatory to apply all the necessary
modification because, after the migration, Bootstrap context will be removed and the new Spring Boot Config API should be used.

The application have these configuration files:

bootstrap.yaml

    darwin:
      region: bo1
      suffix: es
    spring:
      application:
        name: darwin-app
      profiles:
        active: local
      cloud:
        config:
          uri: http://configuration-service:8080/
          fail-fast: false

application.yaml

    darwin:
      app-key: darwin-app
      logging:
        system: system
        subsystem: sub-system-code
        application: functional-application-code
        subapplication: functional-sub-application-code
        paas-app-version: "@project.version@"
        kafka:
          server: ${env.logging-server}
      security:
        pkm-endpoint:
          - ${env.pkm-endpoint}
    spring:
      session:
        store-type: none
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m

The first step to migrate the configuration is to take the bootstrap.yaml content to application.yaml:

To set the default profile, it is necessary to convert the application.yaml in a multi-document YAML using the `---`. Over the dashes, the default profile is used when another profile is not configured. Under the dashes, the configuration by default
is set, not associated to any profile.

!!! info "Important"

    A multi-document YAML is a yaml file where it exists different configuration separated by dashes (`---`). Each configuration is taken as a different file and the max priority order is assigned to lower properties in the file,
    i.e. the properties values lower will overwrite higher properties values.

The rest of the properties have to be put in their places carefully:

- darwin.region=bo1

- darwin.suffix=es

- spring.application.name=darwin-app

- spring.cloud.config.uri=`http://configuration-service:8080/`

- spring.cloud.config.fail-fast=false

Now, the application would have an only configuration file, ***bootstrap.yaml* can be deleted**:

    darwin:
      region: bo1
      suffix: es
      app-key: darwin-app
      logging:
        system: system
        subsystem: sub-system-code
        application: functional-application-code
        subapplication: functional-sub-application-code
        paas-app-version: "@project.version@"
        kafka:
          server: ${env.logging-server}
      security:
        connectors:
          pkm-connector:
            pkm-endpoint:
              - ${env.pkm-endpoint}
    spring:
      application:
        name: darwin-app
      profiles:
        active: local
      session:
        store-type: none
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      cloud:
        config:
          uri: http://configuration-service:8080/
          fail-fast: false

The following step is to add the mandatory `spring.config.import` property and to simplify the config server configuration using `optional:` parameter. This allows to remove the `spring.cloud.config.fail-fast=false`.

This is the result of the migration:

    spring.profiles.active: local
    - --
    darwin:
      region: bo1
      suffix: es
      app-key: darwin-app
      logging:
        system: system
        subsystem: sub-system-code
        application: functional-application-code
        subapplication: functional-sub-application-code
        paas-app-version: "@project.version@"
        kafka:
          server: ${env.logging-server}
      security:
        connectors:
          pkm-connector:
            pkm-endpoint:
              - ${env.pkm-endpoint}
    spring:
      application:
        name: ${artifactId}
      profiles:
        active: local
      session:
        store-type: none
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      config:
        import: "optional:configserver:"
      cloud:
        config:
          uri: http://configuration-service:8080/

Alternatively, the ***application.yaml*** could be created as a multi-document YAML, defining the profile by default in its document. In the first section, the profile would be defined, and separated by three dashes (`---`), in the second part, it
would be the default configuration.

    spring.profiles.active: local
    - --
    darwin:
      region: bo1
      suffix: es
      app-key: darwin-app
      logging:
        system: system
        subsystem: sub-system-code
        application: functional-application-code
        subapplication: functional-sub-application-code
        paas-app-version: "@project.version@"
        kafka:
          server: ${env.logging-server}
      security:
        connectors:
          pkm-connector:
            pkm-endpoint:
              - ${env.pkm-endpoint}
    spring:
      application:
        name: ${artifactId}
      session:
        store-type: none
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      config:
        import: "optional:configserver:"
      cloud:
        config:
          uri: http://configuration-service:8080/

!!! info "Important"

    Once finished the migration, make sure that the bootstrap.yaml file has been deleted.

<!end:300>

## Version 2.9.0-RELEASE

<!tag:290>

- From now on, the property `darwin.app-key` is mandatory and can not be null. Every project must introduce a value for this property. (Important also for **Darwin Spring Boot Logging** module)

- If you were using `BaseDarwinException` now you have to use `GenericDarwinException` instead, and the class `HttpBaseDarwinException` now is placed in **es.santander.darwin.common.exceptions** package.

- The property `darwin.leancore.error-format` has been removed, now if you want to use the LeanCore error model you have to include the **Darwin Spring Boot LeanCore library** dependency: `es.santander.darwin:darwin-spring-boot-leancore`

<!end:290>

## Version 2.6.0-RELEASE

<!tag:260>

- Due to the separation of the web competences of this library, the applications that were loading it directly (**we recommend not to do this, but to use one of the starters**) may have to import the following dependencies explicitly:

    - `org.springframework:spring-webflux`

    - `io.projectreactor.netty:reactor-netty`

    - `org.apache.httpcomponents:httpclient`

    - `org.springframework.boot:spring-boot-actuator-autoconfigure`

    - `io.micrometer:micrometer-core`

<!end:260>
  
## Version 2.4.0-RELEASE

<!tag:240>

- The exception package has been moved from `es.santander.darwin.exceptions.exception` to `es.santander.darwin.core.exceptions`.

- DarwinTaskDecorator class has been moved from package `es.santander.darwin.async` to `es.santander.darwin.core.async`.

<!end:240>
