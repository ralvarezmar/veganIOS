# DARWIN MIGRATION DETAILS ![5.8.2](https://img.shields.io/badge/5.8.2-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Migration details general information

This is a detailed list of the changes that need to be applied when upgrading from older versions to higher versions. If you need more information about how to
migrate between versions, we highly recommend to read this [Migration Guide.](MIGRATION.md)

## MIGRATION GUIDE FROM DARWIN 5.7.1

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:571>' end='<!end:571>' !}

## MIGRATION GUIDE FROM DARWIN 5.4.x TO DARWIN 5.5.X

### Module: darwin-dependencies

{! include-markdown './darwin-project/darwin-spring-boot-dependencies/MIGRATION.md' start='<!tag:550>' end='<!end:550>' !}

### Module: darwin-archetypes

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-library/MIGRATION.md' start='<!tag:550>' end='<!end:550>' !}

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:550>' end='<!end:550>' !}

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-function/MIGRATION.md' start='<!tag:550>' end='<!end:550>' !}

## MIGRATION GUIDE FROM DARWIN 5.2.x TO DARWIN 5.3.X

### Module: darwin-archetypes

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-library/MIGRATION.md' start='<!tag:531>' end='<!end:531>' !}

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:531>' end='<!end:531>' !}

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:531>' end='<!end:531>' !}

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:530>' end='<!end:530>' !}

## MIGRATION GUIDE FROM DARWIN 5.0.x TO DARWIN 5.1.X

### Module: darwin-spring-boot-cache

{! include-markdown './darwin-project/darwin-spring-boot-cache/MIGRATION.md' start='<!tag:510>' end='<!end:510>' !}

## MIGRATION GUIDE FROM DARWIN 4.1.X TO DARWIN 5.0.X

### Change in the formatting of the Version

**Starting with Darwin version 5.0.0, the version nomenclature changes to 5.0.0 instead of 5.0.0-RELEASE.
If you update the version by hand in the pom.xml take this change into account.**

### Update Dockerfile launcher class

Darwin 5.0.0 upgrades to Spring Boot 3.2.x, and **the class that we were using in Dockerfile to build the image (`JarLauncher`)
was moved to other package**. Dockerfile entrypoint must be replaced with this:

``
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS_EXT} org.springframework.boot.loader.launch.JarLauncher $JAVA_PARAMETERS ${@}"]
``

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:500>' end='<!end:500>' !}

### Module: darwin-spring-boot-dependencies

{! include-markdown './darwin-project/darwin-spring-boot-dependencies/MIGRATION.md' start='<!tag:500>' end='<!end:500>' !}

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:500>' end='<!end:500>' !}

### Module: darwin-spring-boot-batch

{! include-markdown './darwin-project/darwin-spring-boot-batch/MIGRATION.md' start='<!tag:500>' end='<!end:500>' !}

## MIGRATION GUIDE FROM DARWIN 4.0.X TO DARWIN 4.1.X

### Module: darwin-spring-boot-extended-error

{! include-markdown './darwin-project/darwin-spring-boot-extended-error/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

### Module: darwin-spring-boot-omnichannel

{! include-markdown './darwin-project/darwin-spring-boot-omnichannel/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:410>' end='<!end:410>' !}

## MIGRATION GUIDE FROM DARWIN 4.0.X TO DARWIN 4.0.2

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:402>' end='<!end:402>' !}

## MIGRATION GUIDE FROM DARWIN 3.2.X TO DARWIN 4.0.X

### Spring Boot 3.1

We have upgraded the base version of Spring Boot 2.7 to Spring Boot 3.1. To review more details of the implications you can consult [Migration Guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide).

#### Migrate Sleuth context propagation in reactive applications

Spring Cloud Sleuth features have been integrated into Micrometer libraries using the "Observation" concept.

- Property `spring.sleuth.reactor.instrumentation-type` **is no longer operational**, we've created `darwin.core.reactor.context-propagation` to configure context propagation instrumentation. Previously, "AUTO" mode was default behaviour, but now
  default is "LIMITED" (manual) mode.

- `DarwinReactorContextConfiguration` **is deprecated**, it's replaced by DarwinContextAccessor (autoConfigured, not necessary to include).

- `LoggerReactiveContext` methods have been **deprecated**, and we recommend stop using these "*logOnXXXX*" to log in reactive applications with manual instrumentation. Also, these static methods have been **removed**:

    - *public static &lt;T&gt; Mono&lt;T&gt; tracedMono(ContextView contextView, Supplier&lt;Mono&lt;T&gt;&gt; supplier)*

    - *public static &lt;T&gt; Flux&lt;T&gt; tracedFlux(ContextView contextView, Supplier&lt;Flux&lt;T&gt;&gt; supplier)*

**Manual (LIMITED) instrumentation** must be implemented now using `tap` or `handle` methods from **Reactor** to update ThreadLocals with Reactor Context info before write logs:

    public Mono<String> updateAndLog(Mono<String> stringMono) {
        stringMono
            .map(/*Update with something*/)
            .tap(() -> new DefaultSignalListener<>() {
                @Override
                public void doOnNext(String string) {
                    log.info("This is the right place to log")
                }
            });
    }

Also, if you are using a Reactor stream within an imperative (Servlet) application you have to use `contextCapture()` operator at to propagate upstream the ThreadLocals information to Reactor Context:

    public Mono<String> updateAndLog(String hello) {
        Mono.just(hello)
            .map(/*Update with something*/)
            .tap(() -> new DefaultSignalListener<>() {
                @Override
                public void doOnNext(String string) {
                    log.info("This is the right place to log")
                }
            })
            .contextCapture();
    }

For more information about context propagation with Reactor and Micrometer we recommend this [article](https://spring.io/blog/2023/03/30/context-propagation-with-project-reactor-3-unified-bridging-between-reactive). And you can also find
documentation about \[reactor context propagation in Core\] and about manual tracing in Logging.

### SpringDoc-openapi 2.0

This dependency is used to document the Rest APIs. The details of the changes involved in this update can be found at [Migration Guide](https://springdoc.org//v2/#migrating-from-springdoc-v1). The upgrade to version 2.0 entails at least the
following changes:

#### Update dependencies

If it is a servlet application, you have to substitute in the pom.xml

    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-ui</artifactId>
    </dependency>

by

    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    </dependency>

In the case of a reactive application

    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-webflux-ui</artifactId>
    </dependency>

by

    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webflux-ui</artifactId>
    </dependency>

#### Modifications in the java source

- Change the package where the `GroupedOpenApi` class is located to `org.springdoc.core.models`.

- The `OpenApiCustomiser` class is renamed to `OpenApiCustomizer`.

- The `getOpenApiCustomisers` method of the `GroupedOpenApi` class is now named `getOpenApiCustomizers`.

### Migrate Java base version

From this version, according to Spring Boot 3.X requirements, **Java version 17 is required as Base version**. In addition to run with JVM 17, also **all third-party libraries should be compatible with Java 17**.

Upgrading to Java 17 involves **changing the domain from javax to jakarta**. In case the library imports the dependency `javax.servlet:javax.servlet-api` it should be changed to `jakarta.servlet:jakarta.servlet-api`.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

### Module: darwin-spring-boot-batch

{! include-markdown './darwin-project/darwin-spring-boot-batch/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:400>' end='<!end:400>' !}

## MIGRATION GUIDE FOR DARWIN 3.2.3

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:323>' end='<!end:323>' !}

## MIGRATION GUIDE FROM DARWIN 3.1.X TO DARWIN 3.2.X

These are the required changes per module to migrate from 3.1.X versions to 3.2.X versions.

### Sagacity

From Darwin version 3.2 onwards, Sagacity will no longer be supported.

### Openshift Templates

Openshift Templates for deploying in the PaaS have been **deprecated** in favour of Helm Charts.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-cache

{! include-markdown './darwin-project/darwin-spring-boot-cache/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-graphql

{! include-markdown './darwin-project/darwin-spring-boot-graphql/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-archetype-microservice

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

### Module: darwin-spring-boot-archetype-function

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-function/MIGRATION.md' start='<!tag:320>' end='<!end:320>' !}

## MIGRATION GUIDE FROM DARWIN 3.0.X TO DARWIN 3.1.X

These are the required changes per module to migrate from 3.0.X versions to 3.1.X versions.

### Module: darwin-spring-boot-dependencies

- In this release we have configured `com.h2database:h2` artifact to use **2.1.210 version** to avoid some [vulnerabilities](https://mvnrepository.com/artifact/com.h2database/h2/1.4.200) found in the version managed by Spring (1.4.200). Check this
  [migration guide](https://www.h2database.com/html/migration-to-v2.html) before upgrading to keep running properly.

- We have also upgraded `io.confluent:kafka-avro-serializer` to version **7.0.1** to be aligned with the Confluent cluster version. If you were using any older confluent dependency we recommend you to upgrade to avoid dependency conflicts.

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:310>' end='<!end:310>' !}

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:310>' end='<!end:310>' !}

### Module: darwin-spring-boot-events

{! include-markdown './darwin-project/darwin-spring-boot-events/MIGRATION.md' start='<!tag:310>' end='<!end:310>' !}

### Module: darwin-spring-boot-archetype-microservice

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:310>' end='<!end:310>' !}

## MIGRATION GUIDE FOR DARWIN 3.0.3

### All modules

Because of upgrading the Spring Boot version in order to solve the vulnerability CVE-2022-22965, the following changes should be done in order to preserve the behavior of previous versions:

1. The static `HttpClient.create()` generator has changed its implementation. With the new version, it creates an instance of the `HttpClient` without a default `ConnectionProvider`.
   If it were necessary to use a `ConnectionProvider`, it would be mandatory to provide it in the `HttpClient` creation:

- Until now, HttpClient implementation created a `ConnectionProvider` by default with a size pool equal to 500.

      HttpClient = HttpClient.create();

- With the new version, `HttpClient` implementation doesn't provide a `ConnectionProvider` by default. In order to maintain the configuration used so far, it is necessary to create one, setting the pool size to 500,
  and pass it as input argument when the `HttpClient` is created.

        ConnectionProvider connectionProvider =
        ConnectionProvider.builder("connectionProvider").maxConnections("500").build();
        HttpClient = HttpClient.create(connectionProvider);

## MIGRATION GUIDE FROM DARWIN 2.11.X TO DARWIN 3.0.X

These are the required changes per module to migrate from 2.11.X versions to 3.0.X versions.

### All modules

1. Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

### Module: darwin-spring-boot-common (removed)

*The `darwin-spring-boot-common` library has been removed*, these are the required changes:

#### Removed classes

These unused classes have been removed:

1. All from `clientprofile`, `data` and `security.auth` packages.
2. `DarwinContextImpl` from *context* package. _DarwinContext now follows Builder pattern._
3. `SoapParams` from *ws* package.

#### Removed dependencies

1. Hystrix dependencies removed
2. The version of the springfox-swagger2 dependency is no longer set by the Darwin in favour of springdoc-openapi

#### Packages/classes refactoring

These *packages* have been moved from `darwin-spring-boot-common` or removed completely:

| Old                                               | New                                       |
|---------------------------------------------------|-------------------------------------------|
| es.santander.darwin.*common.annotation*           | com.santander.darwin.*core.annotation*    |
| es.santander.darwin.*common.authorization* (1)    | com.santander.darwin.*core.authorization* |
| es.santander.darwin.*common.client.clientprofile* | [red]#package removed#                    |
| es.santander.darwin.*common.conditions*           | com.santander.darwin.*core.conditions*    |
| es.santander.darwin.*common.config*               | com.santander.darwin.*core.config*        |
| es.santander.darwin.*common.constants*            | com.santander.darwin.*core.constants*     |
| es.santander.darwin.*common.context* (2)          | com.santander.darwin.*core.context*       |
| es.santander.darwin.*common.client.data*          | [red]#package removed#                    |
| es.santander.darwin.*common.exceptions*           | com.santander.darwin.*core.exceptions*    |
| es.santander.darwin.*common.http*                 | com.santander.darwin.*logging.filter*     |
| es.santander.darwin.*common.omnichannel*          | com.santander.darwin.*core.omnichannel*   |
| es.santander.darwin.*common.security.auth*        | [red]#package removed#                    |
| es.santander.darwin.*common.support*              | com.santander.darwin.*core.support*       |
| es.santander.darwin.*common.ws.bean*              | com.santander.darwin.*ws.config.bean*     |
| es.santander.darwin.*common.ws*                   | com.santander.darwin.*ws*                 |

1. Some classes from this package (Client, Contract and Contrato) have been moved to a special destination. These *classes* have been moved from `darwin-spring-boot-common`:

   | Old                                                 | New                                                                                        |  
       |-----------------------------------------------------|--------------------------------------------------------------------------------------------|  
   | es.santander.darwin.*common.authorization.Client*   | com.santander.darwin.*security.authorization.domain.request.MultiEntityCORequest.Client*   |
   | es.santander.darwin.*common.authorization.Contract* | com.santander.darwin.*security.authorization.domain.request.MultiEntityCORequest.Contract* |
   | es.santander.darwin.*common.authorization.Contrato* | com.santander.darwin.*security.authorization.domain.request.CONRequest.Contrato*           |

2. The *DarwinContextImpl* class has been removed. Now the Builder pattern must be used in order to make use of *DarwinContext*.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-omnichannel

{! include-markdown './darwin-project/darwin-spring-boot-omnichannel/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-sagacity

{! include-markdown './legacy-doc/darwin-sagacity/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-security-authorization

{! include-markdown './darwin-project/darwin-spring-boot-security-authorization/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

### Module: darwin-spring-boot-test

{! include-markdown './darwin-project/darwin-spring-boot-test/MIGRATION.md' start='<!tag:300>' end='<!end:300>' !}

## MIGRATION GUIDE FROM DARWIN 2.9.X TO DARWIN 2.11.X

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:2110>' end='<!end:2110>' !}

## MIGRATION GUIDE FROM DARWIN 2.8.X TO DARWIN 2.9.X

These are the required changes per module to migrate from 2.8.X versions to 2.9.X versions.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:290>' end='<!end:290>' !}

### Module: darwin-spring-boot-logging

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:290>' end='<!end:290>' !}

### Module: darwin-spring-boot-omnichannel

{! include-markdown './darwin-project/darwin-spring-boot-omnichannel/MIGRATION.md' start='<!tag:290>' end='<!end:290>' !}

## MIGRATION GUIDE FROM DARWIN 2.7.X TO DARWIN 2.8.X

These are the required changes per module to migrate from 2.7.X versions to 2.8.X versions.

### Module: darwin-spring-boot-archetype-microservice

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:280>' end='<!end:280>' !}

## MIGRATION GUIDE FROM DARWIN 2.6.X TO DARWIN 2.7.X

These are the required changes per module to migrate from 2.6.X versions to 2.7.X versions.

### Module: darwin-spring-boot-archetype-microservice

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:270>' end='<!end:270>' !}

## MIGRATION GUIDE FROM DARWIN 2.5.X TO DARWIN 2.6.X

These are the required changes per module to migrate from 2.5.X versions to 2.6.X versions.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:260>' end='<!end:260>' !}

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:260>' end='<!end:260>' !}

### Module: darwin-spring-boot-security-authorization

{! include-markdown './darwin-project/darwin-spring-boot-security-authorization/MIGRATION.md' start='<!tag:260>' end='<!end:260>' !}

## MIGRATION GUIDE FROM DARWIN 2.4.X TO DARWIN 2.5.X

These are the required changes per module to migrate from 2.4.X versions to 2.5.X versions.

### Module: darwin-spring-boot-security-authentication

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:250>' end='<!end:250>' !}

## MIGRATION GUIDE FROM DARWIN 2.3.X TO DARWIN 2.4.X

These are the required changes per module to migrate from 2.3.X versions to 2.4.X versions.

### Module: darwin-spring-boot-core

{! include-markdown './darwin-project/darwin-spring-boot-core/MIGRATION.md' start='<!tag:240>' end='<!end:240>' !}

### Module: darwin-spring-boot-webservice

{! include-markdown './darwin-project/darwin-spring-boot-webservice/MIGRATION.md' start='<!tag:240>' end='<!end:240>' !}

## MIGRATION GUIDE FROM NUAR 1.X TO DARWIN 2.3.X

### General Steps

1. Modify the starter parent santander-spring-boot-starter-parent as it follows:

        <parent>
          <groupId>es.santander.darwin</groupId>
          <artifactId>darwin-spring-boot-starter-parent</artifactId>
          <version>2.3.3-RELEASE</version>
        </parent>

2. Rename all Nuar dependencies groupId to `es.santander.darwin`, and rename the artifactId as it is described in the table below:

   | Old                                                   | New                                                    |
       |-------------------------------------------------------|--------------------------------------------------------|
   | santander-spring-boot-dependencies                    | darwin-spring-boot-dependencies                        |
   | santander-spring-boot-starter-parent                  | darwin-spring-boot-starter-parent                      |
   | common-library                                        | darwin-spring-boot-common                              |
   | santander-nuar-core                                   | darwin-spring-boot-core                                |
   | santander-nuar-security-authentication-common-library | darwin-spring-boot-starter-authentication              |
   | santander-nuar-security-authentication-library        | darwin-spring-boot-starter-authentication              |
   | santander-nuar-omnichannel-library                    | darwin-spring-boot-starter-omnichannel                 |
   | logging-component                                     | darwin-spring-boot-starter-logging                     |
   | exceptions-library                                    | *Disappear, now integrated in darwin-spring-boot-core* |
   | interceptors-library                                  | darwin-spring-boot-starter-webservice                  |

3. Rename all imports starting with `es.santander.nuar.util` to `es.santander.darwin`

4. All the dependencies must be modified to point to the new package, just like the import, renaming from `es.santander.nuar.util` to `es.santander.darwin`,

5. Keep in mind that the following classes have been renamed or moved from one package to another:

   | Old                                                                               | New                                                                         |
       |-----------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
   | es.santander.nuar.util.common.context.NuarContext                                 | es.santander.darwin.common.context.DarwinContext                            |
   | es.santander.nuar.util.common.exceptions.GenericNuarException                     | es.santander.darwin.common.exceptions.GenericDarwinException                |
   | es.santander.nuar.async.NuarAsyncProperties                                       | es.santander.darwin.async.DarwinAsyncProperties                             |
   | es.santander.nuar.async.NuarRejectedExecutionHandler                              | es.santander.darwin.async.DarwinRejectedExecutionHandler                    |
   | es.santander.nuar.async.NuarTaskDecorator                                         | es.santander.darwin.async.DarwinTaskDecorator                               |
   | es.santander.nuar.async.DefaultNuarAsyncConfigurer                                | es.santander.darwin.async.DefaultDarwinAsyncConfigurer                      |
   | es.santander.nuar.core.hystrix.NuarConcurrencyStrategy                            | es.santander.darwin.core.hystrix.DarwinConcurrencyStrategy                  |
   | es.santander.nuar.core.hystrix.NuarHystrixConfig                                  | es.santander.darwin.core.hystrix.DarwinHystrixConfig                        |
   | es.santander.nuar.util.exceptions.controller.GlobalNuarExceptionHandlerController | es.santander.darwin.exceptions.controller.DarwinExceptionHandlerController  |
   | es.santander.nuar.util.exceptions.exception.BadRequestNuarException               | es.santander.darwin.exceptions.exception.BadRequestDarwinException          |
   | es.santander.nuar.util.exceptions.exception.ConflictNuarException                 | es.santander.darwin.exceptions.exception.ConflictDarwinException            |
   | es.santander.nuar.util.exceptions.exception.ForbiddenNuarException                | es.santander.darwin.exceptions.exception.ForbiddenDarwinException           |
   | es.santander.nuar.util.exceptions.exception.HttpBaseNuarException                 | es.santander.darwin.exceptions.exception.HttpBaseDarwinException            |
   | es.santander.nuar.util.exceptions.exception.InternalServerErrorNuarException      | es.santander.darwin.exceptions.exception.InternalServerErrorDarwinException |
   | es.santander.nuar.util.exceptions.exception.NotFoundNuarException                 | es.santander.darwin.exceptions.exception.NotFoundDarwinException            |
   | es.santander.nuar.util.exceptions.exception.UnauthorizedNuarException             | es.santander.darwin.exceptions.exception.UnauthorizedDarwinException        |

6. In darwin-spring-boot-starter-parent, an exclusion must be added for spring-boot-logging in spring-boot-starter dependency:

         <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
            <version>2.1.8.RELEASE</version>
            <scope>compile</scope>
            <exclusions>
                <exclusion>
                    <artifactId>log4j-to-slf4j</artifactId>
                    <groupId>org.apache.logging.log4j</groupId>
                </exclusion>
                <exclusion>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-starter-logging</artifactId>
                </exclusion>
            </exclusions>
        </dependency>

7. The properties required the following changes:

    - Nuar properties must be renamed from `es.santander.nuar` to `darwin`

    - Properties have been restructured. Every property starts from `darwin` instead of `es.santander.nuar` or `es.santander.nuar.util`

    - The appKey property hangs directly from `darwin.app-key`

    - From now on, the technical packages are defined as keys inside of `darwin.logging.logLevel`, indicating as value to each other the wished log level, using INFO as default value.

    - In the table below we can see the correspondence between the old names and the new names, as well as the references that disappear:

      | Old                                                          | New                                                        |
             |--------------------------------------------------------------|------------------------------------------------------------|
      | es.santander.nuar.async.await-termination-seconds            | darwin.core.async.await-termination-seconds                |
      | es.santander.nuar.async.core-pool-size                       | darwin.core.async.core-pool-size                           |
      | es.santander.nuar.async.enabled                              | darwin.core.async.enabled                                  |
      | es.santander.nuar.async.keepAliveSeconds                     | darwin.core.async.keep-alive-seconds                       |
      | es.santander.nuar.async.max-pool-size                        | darwin.core.async.max-pool-size                            |
      | es.santander.nuar.async.queue-capacity                       | darwin.core.async.queue-capacity                           |
      | es.santander.nuar.async.threadNamePrefix                     | darwin.core.async.thread-name-prefix                       |
      | es.santander.nuar.&#8203;connectTimeout                      | darwin.core.restTemplate.&#8203;connect-timeout            |
      | es.santander.nuar.&#8203;readTimeout                         | darwin.core.restTemplate.&#8203;read-timeout               |
      | es.santander.nuar.&#8203;connectionRequestTimeout            | darwin.core.restTemplate.&#8203;connection-request-timeout |
      | es.santander.nuar.logging.active                             | *Disappear*                                                |
      | es.santander.nuar.logging.activity                           | darwin.logging.activity.enabled                            |
      | es.santander.nuar.logging.appKey                             | darwin.app-key                                             |
      | es.santander.nuar.logging.application                        | darwin.logging.application                                 |
      | es.santander.nuar.logging.artifactVersion                    | darwin.logging.artifactVersion                             |
      | es.santander.nuar.logging.environment                        | darwin.logging.environment                                 |
      | es.santander.nuar.logging.functional.active                  | *Disappear*                                                |
      | es.santander.nuar.logging.functional.loggedEndpoints         | darwin.logging.functional.logged-endpoints                 |
      | es.santander.nuar.logging.kafka.properties                   | darwin.logging.kafka.properties                            |
      | es.santander.nuar.logging.kafka.server                       | darwin.logging.kafka.server                                |
      | es.santander.nuar.logging.kafka.topic.activity               | darwin.logging.kafka.topic.activity                        |
      | es.santander.nuar.logging.kafka.topic.functional             | darwin.logging.kafka.topic.functional                      |
      | es.santander.nuar.logging.kafka.topic.security               | darwin.logging.kafka.topic.security                        |
      | es.santander.nuar.logging.kafka.topic.technical              | darwin.logging.kafka.topic.technical                       |
      | es.santander.nuar.logging.kafka.uniqueTopic                  | darwin.logging.kafka.uniqueTopic                           |
      | es.santander.nuar.logging.logLevel.activity                  | *Disappear*                                                |
      | es.santander.nuar.logging.logLevel.frontend                  | *Disappear*                                                |
      | es.santander.nuar.logging.logLevel.functional                | *Disappear*                                                |
      | es.santander.nuar.logging.logLevel.root                      | darwin.logging.log-level.root                              |
      | es.santander.nuar.logging.logLevel.security                  | *Disappear*                                                |
      | es.santander.nuar.logging.logLevel.technical                 | darwin.logging.log-level.&lt;packagesLogLevel&gt;          |
      | es.santander.nuar.logging.paasAppVersion                     | darwin.logging.paas-app-version                            |
      | es.santander.nuar.logging.paasproject                        | darwin.logging.paasproject                                 |
      | es.santander.nuar.logging.pattern.activity                   | *Disappear*                                                |
      | es.santander.nuar.logging.pattern.console                    | *Disappear*                                                |
      | es.santander.nuar.logging.pattern.frontend                   | *Disappear*                                                |
      | es.santander.nuar.logging.pattern.functional                 | *Disappear*                                                |
      | es.santander.nuar.logging.pattern.security                   | *Disappear*                                                |
      | es.santander.nuar.logging.pattern.technical                  | *Disappear*                                                |
      | es.santander.nuar.logging.root.logLevel                      | *Disappear*                                                |
      | es.santander.nuar.logging.subapplication                     | darwin.logging.subapplication                              |
      | es.santander.nuar.logging.subapplicationVersion              | *Disappear*                                                |
      | es.santander.nuar.logging.subsystem                          | darwin.logging.subsystem                                   |
      | es.santander.nuar.logging.system                             | darwin.logging.system                                      |
      | es.santander.nuar.logging.technical.package                  | *Disappear*                                                |
      | es.santander.nuar.logging.technical.packagesLogLevel         | *Disappear*                                                |
      | es.santander.nuar.logging.technical.logLevel                 | *Disappear*                                                |
      | es.santander.nuar.logging.timeStampFormat                    | *Disappear*                                                |
      | es.santander.nuar.logging.timeStampPattern                   | *Disappear*                                                |
      | es.santander.nuar.util.omnichannel.externalChannelMap        | darwin.omnichannel.externalChannelMap                      |
      | es.santander.nuar.util.omnichannel.header                    | darwin.omnichannel.header                                  |
      | es.santander.nuar.util.omnichannel.parameter                 | darwin.omnichannel.parameter                               |
      | es.santander.nuar.util.omnichannel.security.filter-order     | darwin.omnichannel.security.filter-order                   |
      | es.santander.nuar.util.remote.ws.security.type               | darwin.webservices.security-types                          |
      | es.santander.nuar.util.remote.ws.security.type.mode          | darwin.webservices.security-types.mode                     |
      | es.santander.nuar.util.remote.ws.security.type.name          | darwin.webservices.security-types.name                     |
      | es.santander.nuar.util.remote.ws.security.type.password      | darwin.webservices.security-types.password                 |
      | es.santander.nuar.util.remote.ws.security.type.user          | darwin.webservices.security-types.user                     |
      | es.santander.nuar.util.restTemplate.connectionRequestTimeout | darwin.security.resttemplate.connection-request-timeout    |
      | es.santander.nuar.util.restTemplate.connectTimeout           | darwin.security.resttemplate.connect-timeout               |
      | es.santander.nuar.util.restTemplate.readTimeout              | darwin.security.resttemplate.read-timeout                  |
      | es.santander.nuar.util.security.audience                     | darwin.security.audience                                   |
      | es.santander.nuar.util.security.authQueryParameter           | darwin.security.auth-query-parameter                       |
      | es.santander.nuar.util.security.enabled                      | darwin.security.enabled                                    |
      | es.santander.nuar.util.security.issuer                       | darwin.security.issuer                                     |
      | es.santander.nuar.util.security.omnichannel                  | darwin.security.omnichannel                                |
      | es.santander.nuar.util.security.remoteKeyServerURL           | darwin.security.pkm-endpoint                               |
      | es.santander.nuar.util.security.remoteSTSURI                 | darwin.security.sts-endpoint                               |
      | es.santander.nuar.util.security.STSRetries                   | darwin.security.STS-retries                                |
      | es.santander.nuar.util.security.whiteList                    | darwin.security.white-list                                 |

8. The RestTemplate object that the architecture supplies is renamed as `darwinRestTemplate`.

9. The ObjectMapper object that the architecture supplies is renamed as `darwinObjectMapper`.

10. If the interceptor library is used (now webservice), it is necessary to pay special attention with the properties that refer to the security interceptor since they currently belong to `es.santander.nuar` and it becomes `darwin.webservice`

11. The Spring Boot dependencies that belong to Netflix have changed their name, for example `spring-cloud-starter-hystrix` is now named `spring-cloud-starter-netflix-hystrix`

12. Spring Boot provides a dependency which can help quite a bit with transition from Spring Boot 1 to 2, it should be included so that when compiling and / or executing, it generates traces with the properties to be changed:

        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-properties-migrator</artifactId>
                <scope>runtime</scope>
            </dependency>
        </dependencies>

13. In [Spring Boot 2.0 Migration guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide) we can find a complete migration guide to Spring Boot 2.0

14. SantanderUserDetails class has been renamed to DarwinUserDetails and now, its methods return an Optional when it is possible for the return object to be null.

### Authentication module details

Due to the amount of changes that affect the authentication library, some of them are further detailed below.

{! include-markdown './darwin-project/darwin-spring-boot-security-authentication/MIGRATION.md' start='<!tag:2x0>' end='<!end:2x0>' !}

### Logging module details

Due to the amount of changes that affect the logging library, some of them are further detailed below.

{! include-markdown './darwin-project/darwin-spring-boot-logging/MIGRATION.md' start='<!tag:2x0>' end='<!end:2x0>' !}

## NUAR to DARWIN archetype migration guide

{! include-markdown './darwin-archetypes/darwin-spring-boot-archetype-microservice/MIGRATION.md' start='<!tag:nuartodarwin>' end='<!end:nuartodarwin>' !}
