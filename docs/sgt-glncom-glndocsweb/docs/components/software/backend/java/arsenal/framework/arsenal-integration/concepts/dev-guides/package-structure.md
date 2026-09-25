# Package Structure

Projects built on the Integration Architecture 3.0 template must follow a
standardized package/folder structure, which in turn has a structural foundation
based on [Arsenal Backend](../../../arsenal-backend/concepts/dev-guides/packages-structure.md)

Adopting this structure allows:

* better organization of classes, facilitating teamwork
* greater clarity about what is the role of each class within the application

In general terms, Integration Architecture 3.0 projects must follow the
structure below:

``` { bash }
com
  └──santander
     └──acronym
        └──integration
           └──acronym
               └──caml
                   └──project-name
                       ├──builder
                       │   └──request
                       ├──config
                       ├──processor
                       ├──route
```

## Purpose of Packages

Each package declared above will house classes and components that have the same
responsibility.

### Package builder

Classes that represent builders for realizing constructor classes and abstract
utilization Factory.

### Package builder.request

Classes whose purpose is to create the Factory for mapping and instantiating
Request objects for SOAP calls, among others.

### Package config

Application component configuration classes, typically annotated as
@Configuration.

### Package processor

Classes that implement Apache Camel
[Processor](https://camel.apache.org/processor.html) for implementing EIP
standards.

### Package route

Classes that extend Apache Camel's
[RouteBuilder](https://camel.apache.org/routebuilder.html) to implement and
orchestrate application routes using EIP standards.

## Do I need all these packages?

No! You can and should delete packages that don't make sense for your
application. For example: if your integration application does not use SOAP, it
would not need builder.request.

!!! tip

        Don't forget: you can remove packages that you won't use, but you should
        always create them according to the pattern above! If there is a need to
        expand the packages to use Domain resources, the guidelines of the [Arsenal
        Backend Application Structure](../../../arsenal-backend/concepts/dev-guides/packages-structure.md) standards
        must be followed.
