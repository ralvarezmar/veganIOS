# Integration Tests

So that a microservice can be deployed in production, with the maximum certainty
that everything is working as expected, it is necessary to go beyond unit tests.
In addition to the individual components, the interaction between these
components needs to be tested.

Integration tests are intended to test the interaction between application
components. This document will show how to implement them in the application.

## What are integration tests and where can they be applied?

These are tests that validate whether the developed components work as expected
when interacting with each other. The built-in tests are applied to the service
(service), controller and persistence (repository) layers of the microservice.

!!! tip "Attention!"

    Integrated tests do not validate business rules, this is a
    function of unit tests.

## What do Integration tests cover?

An integrated test can cover the following:

* The interaction between two or more application components;
* Application layers. For example, it might cover the interaction between the
  service layer and the persistence layer of the microservice;
* All the way through the application. Sending a request to the application and
  checking if it responded correctly and if the database was changed.

Integration testing is the process of testing the interface between two software
units or modules. It focuses on determining the correctness of the interface.
The purpose of integration testing is to expose faults in the interaction
between integrated units. Once all the modules have been unit tested,
integration testing is performed.

Integration testing is a software testing technique that focuses on verifying
the interactions and data exchange between different components or modules of a
software application. The goal of integration testing is to identify any
problems or bugs that arise when different components are combined and interact
with each other. Integration testing is typically performed after unit testing
and before system testing. It helps to identify and resolve integration issues
early in the development cycle, reducing the risk of more severe and costly
problems later on.

Integration testing can be done by picking module by module. This can be done so
that there should be a proper sequence to be followed. And also if you don’t
want to miss out on any integration scenarios then you have to follow the proper
sequence. Exposing the defects is the major focus of the integration testing and
the time of interaction between the integrated units.

## Integration test approaches

There are four types of integration testing approaches. Those approaches are the
following:

### Big-Bang Integration Testing

It is the simplest integration testing approach, where all the modules are
combined and the functionality is verified after the completion of individual
module testing. In simple words, all the modules of the system are simply put
together and tested. This approach is practicable only for very small systems.
If an error is found during the integration testing, it is very difficult to
localize the error as the error may potentially belong to any of the modules
being integrated. So, debugging errors reported during big bang integration
testing is very expensive to fix.

Big-Bang integration testing is a software testing approach in which all
components or modules of a software application are combined and tested at once.
This approach is typically used when the software components have a low degree
of interdependence or when there are constraints in the development environment
that prevent testing individual components. The goal of big-bang integration
testing is to verify the overall functionality of the system and to identify any
integration problems that arise when the components are combined. While big-bang
integration testing can be useful in some situations, it can also be a high-risk
approach, as the complexity of the system and the number of interactions between
components can make it difficult to identify and diagnose problems.

Advantages:

* It is convenient for small systems.
* Simple and straightforward approach.
* Can be completed quickly.
* Does not require a lot of planning or coordination.
* May be suitable for small systems or projects with a low degree of
  interdependence between components.

Disadvantages:

* There will be quite a lot of delay because you would have to wait for all the
  modules to be integrated.
* High-risk critical modules are not isolated and tested on priority since all
  modules are tested at once.
* Not Good for long projects.
* High risk of integration problems that are difficult to identify and diagnose.
* This can result in long and complex debugging and troubleshooting efforts.
* This can lead to system downtime and increased development costs.
* May not provide enough visibility into the interactions and data exchange
  between components.
* This can result in a lack of confidence in the system’s stability and
  reliability.
* This can lead to decreased efficiency and productivity.
* This may result in a lack of confidence in the development team.
* This can lead to system failure and decreased user satisfaction.

### Bottom-Up Integration Testing

In bottom-up testing, each module at lower levels are tested with higher modules
until all modules are tested. The primary purpose of this integration testing is
that each subsystem tests the interfaces among various modules making up the
subsystem. This integration testing uses test drivers to drive and pass
appropriate data to the lower-level modules.

Advantages:

* In bottom-up testing, no stubs are required.
* A principal advantage of this integration testing is that several disjoint
  subsystems can be tested simultaneously.
* It is easy to create the test conditions.
* Best for applications that uses bottom up design approach.
* It is Easy to observe the test results.

Disadvantages:

* Driver modules must be produced.
* In this testing, the complexity that occurs when the system is made up of a
  large number of small subsystems.
* As Far modules have been created, there is no working model can be
  represented.

### Top-Down Integration Testing

Top-down integration testing technique is used in order to simulate the
behaviour of the lower-level modules that are not yet integrated. In this
integration testing, testing takes place from top to bottom. First, high-level
modules are tested and then low-level modules and finally integrating the
low-level modules to a high level to ensure the system is working as intended.

Advantages:

* Separately debugged module.
* Few or no drivers needed.
* It is more stable and accurate at the aggregate level.
* Easier isolation of interface errors.
* In this, design defects can be found in the early stages.

Disadvantages:

* Needs many Stubs.
* Modules at lower level are tested inadequately.
* It is difficult to observe the test output.
* It is difficult to stub design.

### Mixed Integration Testing

A mixed integration testing is also called sandwiched integration testing. A
mixed integration testing follows a combination of top down and bottom-up
testing approaches. In top-down approach, testing can start only after the
top-level module have been coded and unit tested. In bottom-up approach, testing
can start only after the bottom level modules are ready. This sandwich or mixed
approach overcomes this shortcoming of the top-down and bottom-up approaches. It
is also called the hybrid integration testing. also, stubs and drivers are used
in mixed integration testing.

Advantages:

* Mixed approach is useful for very large projects having several sub projects.
* This Sandwich approach overcomes this shortcoming of the top-down and
  bottom-up approaches.
* Parallel test can be performed in top and bottom layer tests.

Disadvantages:

* For mixed integration testing, it requires very high cost because one part has
  a Top-down approach while another part has a bottom-up approach.
* This integration testing cannot be used for smaller systems with huge
  interdependence between different modules.

Applications:

__Identify the components:__ Identify the individual components of your
application that need to be integrated. This could include the frontend,
backend, database, and any third-party services.

__Create a test plan:__ Develop a test plan that outlines the scenarios and test
cases that need to be executed to validate the integration points between the
different components. This could include testing data flow, communication
protocols, and error handling.

__Set up test environment:__ Set up a test environment that mirrors the
production environment as closely as possible. This will help ensure that the
results of your integration tests are accurate and reliable.

__Execute the tests:__ Execute the tests outlined in your test plan, starting
with the most critical and complex scenarios. Be sure to log any defects or
issues that you encounter during testing.

__Analyze the results:__ Analyze the results of your integration tests to
identify any defects or issues that need to be addressed. This may involve
working with developers to fix bugs or make changes to the application
architecture.

__Repeat testing:__ Once defects have been fixed, repeat the integration testing
process to ensure that the changes have been successful and that the application
still works as expected.
