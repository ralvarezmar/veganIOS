# Package Structure

Projects built on the Arsenal Cloud Native template must follow a standardized
package/folder structure.

Adopting this structure allows:

* better organization of classes, facilitating teamwork
* greater clarity about what is the role of each class within the application

In general terms, Arsenal Cloud Native projects must follow the structure below:

``` { .bash .copy }
com
  └──santander
      └──acronym
          └──project-name
              └──app
              │    ├──mapper
              │    ├──resource
              │    └──service
              │         └──impl
              └──domain
              │    ├──entity
              │    └──usecase
              └──infra
              │    ├──config
              │    ├──dataprovider
              │    │    └──mapper
              │    ├──handler
              │    │    └──exception
              │    └──repository
              │         └──model
```

## Purpose of Packages

Each package declared above will contain classes and components that have the
same responsibility.

### Package client

Classes that represent clients for consuming external services (eg,
communicating with other microservices or with legacy applications).

### Package controller

Classes that define the application's routes and therefore the version and
address of the resources. They are annotated as @RestController and represent
the entry and exit points of the application (endpoints).

### Package candler

Classes that define error handling logic, whether they are known (see the
exception package below) or not. They are annotated with @RestControllerAdvice
and their methods with @ExceptionHandler.

### Package exception

Classes that represent application-specific errors, whether they come from a
technical or business failure.

### Package mapper

Interfaces that perform mapping between classes of models and data transfer
objects (DTOs). They are annotated with @Mapper and method signatures can be
annotated with @Mapping.

### Package model

Classes that define entities from the application's domain, which may have
business and validation rules. Typically, they are used to facilitate
persistence in a database, being annotated as @Entity.

### Package repository

Classes that follow the Repository design pattern and also use the Java
Persistence API (JPA) to persist objects (in this case models) in a database.

### Package service

Classes that actually encapsulate the application's behavior, being responsible
for invoking business rules in domain objects or even implementing their own
business rules that are not directly linked to domain objects.

### Package scheduler

Classes that define tasks that run on a scheduled or periodic basis, typically
annotated as @Scheduled.

### Package security

Classes that deal with specific security capabilities such as authentication,
authorization, and encryption.

### Package utils

Helper classes, typically annotated as @Component, and which expose routines
used repeatedly in the application, but which do not belong to any object in the
domain (eg validators, datetime format converters).

## Do I need all these packages?

No! You can and should delete packages that don't make sense for your
application. For example: if your application doesn't work with scheduled
routines, you might not need the scheduler package.

!!! tip "Do not forget:"

    You can remove packages that you won't use, but you
    should always create them according to the pattern above!
