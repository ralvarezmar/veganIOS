# What is Darwin? ![5.8.2](https://img.shields.io/badge/5.8.2-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

![Technologies](images/Technologies.png)

## What is Darwin?

When facing the development of an application, it is quite common to spend a significant amount of time in implementing different `cross-cutting` aspects to the application, such as, configuration externalization, `logging`, authentication, cache,
etc. In a monolithic architecture this task could take days or weeks and almost always in a context where the application development would take months or even years and would be considered an insignificant investment. However, this thesis cannot be
applied in microservice-based architectures. Microservice-based applications are made up of tens or hundreds of them, where some will require days of development or even weeks, so the effort to develop cross-cutting aspects for each microservice
seems impracticable.

In response to this need, the `Darwin Spring Boot Framework` provides a set of components, designed for microservice-based architectures, implemented with `java` and which respond to the `cross-cutting` aspects required by the organization. `Darwin`
is based on the `Spring Boot` open source `framework`, one of the most widely used frameworks for Java microservices development.

## Darwin is a framework

As commented, Darwin is considered a `framework`, but why not a simple set of libraries? Unlike a library, Darwin provides:

- A set of software artifacts, such as libraries, guidelines, standards, methodologies, etc.

- It provides mechanisms that allow solving different kinds of problems.

- It is extensible through code written by applications.

- Provides ease of development, configuration and deployment.

## Darwin Flavours

`Darwin` is a living `framework`, in constant evolution, and therefore it is nourished by the most advanced market technologies;
in this sense, it has undergone an important transformation, providing it with a modular and flexible structure, which
enables its use in different areas according to the needs of the application.

`Darwin Spring Boot` auto-configuration will detect the type of application it is running in,
autoconfiguring only those functionalities that apply to that environment.
To define the execution environment of a `Spring Boot` application, we will use
the values defined in [WebApplicationType](https://docs.spring.io/spring-boot/docs/3.3.12/api/org/springframework/boot/WebApplicationType.html),
being able to apply it through a property or code:

- To make use of the property:

<!-- -->

    spring.main.web-application-type=NONE,REACTIVE,SERVLET

- To do it through code, we will use the `SpringApplicationBuilder` class:

<!-- -->

    @SpringBootApplication
    public class Application {
        public static void main(String[] args) {
            new SpringApplicationBuilder(Application.class)
                    .web(WebApplicationType.NONE) // .REACTIVE, .SERVLET
                    .run(args);
        }
    }

If the application type is not defined,
`Spring Boot` will automatically select the environment by auto-discovery of the project dependencies.

!!! note "Important"

    The autoconfiguration by type of application will be hierarchical, that is:
    
      - ***NotWeb***: NotWeb (base configuration)
    
      - ***Servlet***: Servlet&gt; NotWeb[^1]
    
      - ***Reactive***: Reactive&gt; NotWeb[^2]

The types of application that the auto-configuration is capable of detecting are:

### Servlet environments

It is the first paradigm from which the `Darwin Framework` was born, based on the `Spring MVC` technological stack, it allows building `Servlet` based microservices running on an `embedded web server` (`Tomcat` by default).

When the `starter spring-web` is found, it will start in `SERVLET` mode.

### Reactive environments

The `Darwin Framework` supports the paradigm of `Reactive` and non-blocking application development based on `Reactor Project`,
which enables the construction of `Spring WebFlux` based microservices
running on an `embedded reactive web server` (`Netty` by default).

When the `starter spring-webflux` is found, it will start in `REACTIVE` mode.

In this context, Darwin components have been evolved to support the new reactive stack based on the following principles:

- Duality: `Reactive` library versions, must cover the same functionality as `Servlet` versions.

- Compatibility: Being a new technology stack, the original `API` may not always be respected, but it will be developed to be backward compatible (with respect to the `Spring MVC` versions) as far as possible.

    - For example, if a project contains the `logging starter` and starts the application with `Netty`, the reactive versions of the `Framework Darwin` will be started (transparently for the project) managing the traces in exactly the same way as
        its `Servlet` equivalent and all this without the project having to modify a single line of code.

- Easy to use: Developing on `Spring WebFlux` is a major paradigm shift and way of thinking, so `Darwin` provides utilities that facilitate the use of the various pieces of architecture in this environment.

### Standalone environments (Not Web)

The `Darwin Framework` allows its use in non-web environments that do not run an `embedded web server`.
This, for example, enables the use of Darwin in 'Job' type applications, where the application starts,
executes a logic (being able to make use of other technologies such as `Spring Batch`, etc.)
and ends by returning the result of the process.

When the `starter spring-webflux` or the `starter spring-web` are not found, it will start in `NONE` mode.

In this context, services have been developed exclusively for this environment (authentication services, authorization, logging, etc.) and provide the `framework` with a functionality similar to that provided in its web equivalents.
When it detects the dependencies of `restTemplate` and `webClient` it's autoconfigured with the `Darwin` interceptors.

## Darwin components

The components provided by `Darwin` are summarized below.

### Libraries

#### [Authentication](darwin-project/darwin-spring-boot-security-authentication/README.md)

The authentication library is responsible for automatically installing the necessary filters to validate both `JWT` and `BKS` tokens, as well as providing components to access the authenticated token or convert it to the required token type.

#### [Authorization](darwin-project/darwin-spring-boot-security-authorization/README.md)

The authorization library is responsible for managing whether the user and client who request an action via `Rest` are authorized to perform it.

#### [Batch](darwin-project/darwin-spring-boot-batch/README.md)

The Batch library is in charge of providing a suitable environment for the execution of batch processes.

#### [Cache](darwin-project/darwin-spring-boot-cache/README.md)

The cache library is in charge of managing the cache in `Darwin` microservices. It currently supports `Caffeine` and/or `Data Grid`.

#### [Core](darwin-project/darwin-spring-boot-core/README.md)

Basic library within the `Darwin framework` that is in charge of initializing reusable components among the other libraries such as `JSON` mappers, invocation components such as `RestTemplate` and/or `WebClient`, etc.

#### [Events](darwin-project/darwin-spring-boot-events/README.md)

The Event library provides the necessary functionalities to be able to generate and/or consume events from `Kafka` topics based on the [CloudEvents](https://cloudevents.io/) specification, which allows us to describe events in a common, accessible
and portable way.

#### [GraphQL](darwin-project/darwin-spring-boot-graphql/README.md)

The GraphQL module provides support for Darwin applications built on **[Spring GraphQL](https://docs.spring.io/spring-graphql/docs/1.3.5/reference/html) and [GraphQL Java](https://www.graphql-java.com/)**. Includes Darwin Context support, Darwin
GraphQl error format, etc.

#### [Logging](darwin-project/darwin-spring-boot-logging/README.md)

The Logging library that allows generating traces with a specific `Json` format defined by `Darwin`, so that they can be managed from the monitoring area.

The traces are grouped into 4 types or extensions:

- Technical traces: Traces generated by developers to trace aspects of the code that they consider can provide important information in case of error.

- Activity traces: Traces generated automatically by an aspect injected into all methods covering a `REST endpoint`. These traces will be generated at the end of the method execution.

- Functional traces: Divided into two types, automatic and manual:

    - The automatic ones, as well as the activity ones, are generated in an aspect injected in `REST methods` published by the microservice. In these traces the input and output method parameters will be shown. These traces will only be shown if
        the endpoint is configured as "traceable" as explained in the configuration section.

    - Manual traces, are explicitly included by the developer himself using the `Helper` designed for this purpose.

- Security traces: generated by the security team with sensible data included in the trace using a `Helper` in a similar way to manual functional traces.

#### [Partenon](darwin-project/darwin-spring-boot-partenon/README.md)

The Partenon library extends to [Original connector Partenon
SpringBoot](https://santandernet.sharepoint.com/sites/SEPBKSCCA/SitePages/Annexes/Documentation/Spring%20Libraries%20Documentation/Partenon%20TrxOp%20Spring%20Connector%20-%20User%20Manual.aspx),
with functionalities that allow customizing the connector configuration (destination host, port, etc.) depending on the channel or to use it in reactive environments.

#### [Test](darwin-project/darwin-spring-boot-test/README.md)

The Test library provides projects with a series of `Out Of The Box` components and functionalities that facilitate the design and implementation of application test cases. They extend, simulate, or simplify the normal behavior of some test and
Darwin components under certain execution conditions: Logging in test mode, mocks for Common Services (PKM, STS…​), etc.

#### [Webservice](darwin-project/darwin-spring-boot-webservice/README.md)

The Web Service library provides interceptors used for authentication with `SOAP` web services.

### Archetypes

#### [Microservices archetype](darwin-archetypes/darwin-spring-boot-archetype-microservice/README.md)

The `Darwin` microservices archetype configures a basic microservice with the dependencies that have been specified during generation.
It uses the `darwin-spring-boot-parent` project as `parent` in order to level all dependencies versions.

### [Darwin Migration Assistant](https://gluon.dev.corp/microservices/docs/darwin-migration-assistant)

The `Darwin Migration Assistant` is a module created specifically for the [OpenRewrite](https://docs.openrewrite.org) plugin, which allows source code refactoring for API migrations to the latest versions of Darwin Spring Boot from an old version of
Darwin or NUAR.

## Appendix

Darwin Spring Boot has some features that are worth mentioning:

### Darwin Web Filters

Darwin makes use of a set of Web filters to execute cross-logic to all microservices.
The purpose of this section is to collect in a single point all the filters that Darwin can configure.

Filters for `Servlet` type `Web` applications:

| Filter                                                                                                                                      | Default order                                                           | Module                                                                   | Description                                                                       |
|---------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|--------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| [DarwinContextFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/core/filter/DarwinContextFilter.html)                                                                 | Ordered.HIGHEST_PRECEDENCE = -2147483648                                | darwin-spring-core                                                       | Filter that initializes the `DarwinInfo` object located in the `DarwinContext`    |
| [FilterChainProxy](https://docs.spring.io/spring-security/site/docs/6.3.9/api/org/springframework/security/web/FilterChainProxy.html)                                                                      | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 100 == 0 - 100 == -100 | darwin-spring-boot-security-starter-authenticacion (spring-security-web) | Filter that initializes the security module                                       |
| [OmniChannelFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/omnichannel/filter/OmniChannelFilter.html)                                                              | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 15 == 0 -15 == -15     | darwin-spring-boot-starter-omnichannel                                   | Filter that initializes the `ContactPoint` object located in `DarwinContext`      |
| [ActivityLoggingFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/filter/ActivityLoggingFilter.html)                                                          | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105   | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Filter that manages activity traces                                               |
| [CacheFunctionalLoggingFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/filter/CacheFunctionalLoggingFilter.html)                                            | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105   | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Filter that manages functional traces                                             |
| [ContactPointLoggingFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/filter/ContactPointLoggingFilter.html)                                                  | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 10 == 0 - 10 == -110   | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Get the Contact Point values contained by Darwin Context.                         |
| [UpdateContextFromTokenClaimsServletFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/security/authentication/context/UpdateContextFromTokenClaimsServletFilter.html) | Executed after `BearerTokenAuthenticationFilter` security filter.       | darwin-spring-boot-starter-security-authentication                       | Update contexts from some JWT token claims if exists.                             |
| [DarwinLoggingAuthenticationFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/filter/DarwinLoggingAuthenticationFilter.html)                                  | Executed after `ChannelUpdateServletFilter` security filter.            | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Update BaggageFields from values extracted from Authentication.                   |
| [DistributedTracesFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/filter/DistributedTracesFilter.html)                                                      | OrderedFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105   | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Update the values of the fields in the logging context for the distributed traces |

Filters for `Reactive` type `Web` applications:

| Filter                                                                                                                                        | Default order                                                                  | Module                                                                   | Description                                                                                                                                                                  |
|-----------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [DarwinContextWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/core/filter/DarwinContextWebFilter.html)                                                             | Ordered.HIGHEST_PRECEDENCE = -2147483648                                       | darwin-spring-core                                                       | Filter that initializes the `DarwinInfo` object located in the `DarwinContext` of the `Reactor` context                                                                      |
| [WebFilterChainProxy](https://docs.spring.io/spring-security/site/docs/6.3.9/api/org/springframework/security/web/server/WebFilterChainProxy.html)                                                           | WebFluxSecurityConfiguration.WEB_FILTER_CHAIN_FILTER_ORDER = 0 - 100 == -100   | darwin-spring-boot-security-starter-authenticacion (spring-security-web) | Filter that initializes the security module                                                                                                                                  |
| [OmniChannelWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/omnichannel/filter/OmniChannelWebFilter.html)                                                          | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 15 == 0 -15 == -15         | darwin-spring-boot-starter-omnichannel                                   | Filter that initializes the `ContactPoint` object located in `DarwinContext`                                                                                                 |
| [BodyRequestCacheWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/core/filter/BodyRequestCacheWebFilter.html)                                                       | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 10 == 0 - 10 == -10        | darwin-spring-core                                                       | Filter that caches the request body. This filter **by default is disabled**. It is only instantiated when **functional traces** or **automatic BusinessEvents are enabled**. |
| [ReactiveActivityLoggingWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/reactive/ReactiveActivityLoggingWebFilter.html)                                    | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105       | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Filter that manages activity traces                                                                                                                                          |
| [ReactiveCacheFunctionalLoggingWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/reactive/ReactiveCacheFunctionalLoggingWebFilter.html)                      | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105       | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Filter that manages functional traces                                                                                                                                        |
| [ReactiveContactPointWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/reactive/ReactiveContactPointWebFilter.html)                                          | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 - 10 == 0 - 10 == -110 | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Get the Contact Point values contained by Darwin Context.                                                                                                                    |
| [UpdateContextFromTokenClaimsReactiveFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/security/authentication/context/UpdateContextFromTokenClaimsReactiveFilter.html) | Executed after `BearerTokenAuthenticationFilter` security filter.              | darwin-spring-boot-starter-security-authentication                       | Update contexts from some JWT token claims if exists.                                                                                                                        |
| [DarwinReactiveLoggingAuthenticationFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/reactive/DarwinReactiveLoggingAuthenticationFilter.html)                  | Executed after `ChannelUpdateReactiveFilter` security filter.                  | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Update BaggageFields from values extracted from Authentication.                                                                                                              |
| [ReactiveDistributedTracesWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/5.8.2/apidocs/com/santander/darwin/logging/reactive/ReactiveDistributedTracesWebFilter.html)                                | OrderedWebFilter.REQUEST_WRAPPER_FILTER_MAX_ORDER - 105 == 0 - 5 == -105       | darwin-spring-boot-starter-logging-(kafka\|basic)                        | Update the values of the fields in the logging context for the distributed traces                                                                                            |

!!! info "Important"

    The project can modify the order of the filters according to its needs, but to ensure correct operation it is very important to respect the relative order of the Darwin filters.

## Minimum requirements

- JDK 17+

- Spring Boot 3.1.x

- Spring Framework 6.0.x

## Migration from previous releases

Details on how to migrate from `NUAR` or previous `Darwin` releases can be found in the [migration guide](MIGRATION.md)

[^1]: The `Servlet` configuration will inherit the `NotWeb` configuration.

[^2]: The `Reactive` configuration will inherit the `NotWeb` configuration.
