# What is Darwin? ![4.3.3-RELEASE](https://img.shields.io/badge/4.3.3-RELEASE-FF073D)

![GA](https://img.shields.io/badge/GA-C81D11)

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

## Darwin has a modular structure

`Darwin` is a living `framework`, in constant evolution and therefore it is nourished by the most advanced market technologies; in this sense, it has undergone an important transformation, providing it with a modular and flexible structure, which
enables its use in different areas according to the needs of the application.

### Servlet environments

It is the first paradigm from which the `Darwin Framework` was born, based on the `Spring MVC` technological stack, it allows building `Servlet` based microservices running on an `embedded web server` (`Tomcat` by default).

### Reactive environments

Available from version `2.3.0-RELEASE`, the `Darwin Framework` supports the new paradigm of `Reactive` and non-blocking application development based on `Reactor Project`, which enables the construction of `Spring WebFlux` based microservices
running on an `embedded reactive web server` (`Netty` by default).

In this context, Darwin components have been evolved to support the new reactive stack based on the following principles:

- Duality: `Reactive` library versions, must cover the same functionality as `Servlet` versions.

- Compatibility: Being a new technology stack, the original `API` may not always be respected, but it will be developed to be backward compatible (with respect to the `Spring MVC` versions) as far as possible.

    - For example, if a project contains the `logging starter` and starts the application with `Netty`, the reactive versions of the `Framework Darwin` will be started (transparently for the project) managing the traces in exactly the same way as
        its `Servlet` equivalent and all this without the project having to modify a single line of code.

- Easy to use: Developing on `Spring WebFlux` is a major paradigm shift and way of thinking, so `Darwin` provides utilities that facilitate the use of the various pieces of architecture in this environment.

### Standalone environments (Not Web)

Available from version `2.6.0-RELEASE`, the `Darwin Framework` allows its use in non-web environments that do not run an `embedded web server`. This, for example, enables the use of Darwin in 'Job' type applications, where the application starts,
executes a logic (being able to make use of other technologies such as `Spring Batch`, etc.) and ends by returning the result of the process.

In this context, services have been developed exclusively for this environment (authentication services, authorization, logging, etc.) and provide the `framework` with a functionality similar to that provided in its web equivalents.

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

The GraphQL module provides support for Darwin applications built on **[Spring GraphQL](https://docs.spring.io/spring-graphql/docs/1.2.6/reference/html) and [GraphQL Java](https://www.graphql-java.com/)**. Includes Darwin Context support, Darwin
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
SpringBoot](https://santandernet.sharepoint.com/sites/SEPBKSCCA/SitePages/Annexes/Documentation/Spring%20Libraries%20Documentation/Partenon%20TrxOp%20Spring%20Connector%20-%20User%20Manual/Partenon%20TrxOp%20Spring%20Connector%20-%20User%20Manual.aspx),
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

### Other libraries and components

#### [Darwin Migration Assistant](https://gluon.dev.corp/microservices/docs/darwin-migration-assistant)

The `Darwin Migration Assistant` is a module created specifically for the [OpenRewrite](https://docs.openrewrite.org) plugin, which allows source code refactoring for API migrations to the latest versions of Darwin Spring Boot from an old version of
Darwin or NUAR.

## Minimum requirements

- JDK 17+

- Spring Boot 3.1.x

- Spring Framework 6.0.x

## Migration from previous releases

Details on how to migrate from `NUAR` or previous `Darwin` releases can be found in the [migration guide](MIGRATION.md)
