# Health Check

## Overview

When we adopt the architecture of micro microservices, one of the absolute
certainties is that at a given moment, certainly one of the instances of a
microservice will fail! This micro microservice may momentarily be unable to
respond to new requests and still be running, either because it has lost access
to a database, because it has no access to a certain queue, or because it has
exhausted its storage quota.

When this happens, the monitoring system should generate an alert, the load
balancer or the service registry should stop all requests flowing to the failing
instance, Openshift should remove the instance that is no longer healthy. With
the scenario where the failure of a micro microservice is certain, how to detect
that a running microservice instance cannot handle requests? From what point in
time and what information should be used to trigger an alert when a microservice
instance fails? How can we determine whether new requests should be sent to a
working micro microservice instance?

The best way to determine whether the microservice is healthy or not is if it
can report health data. One approach taken is to implement a health check
endpoint (eg /health) that returns health data from the micro microservice. This
endpoint should return the status of the connections of the
micro-micro-microservices with the infrastructure such as database
micro-micro-services, messaging micro-micro-services, storage
micro-micro-services, host status, disk space or even other health data relevant
to the microservice or its consumers.

Once this endpoint is exposed, we can make use of clients to carry out the
health check, use a monitoring microservice, a service registry or load
balancer, create control panels that allow us to have a view of this state, all
through calls periodically to the health endpoint of the micro microservice
instance. For all these needs, the vast majority of frameworks aimed at
micro-microservices already have functionality for obtaining and exposing this
data, in the case of Spring Boot it brings us the actuator.

## What is the actuator

Actuator is a Spring module that allows us to monitor our microservice instance,
collect metrics, understand the traffic or state of our database and other
components of our microservice in an extremely simple way, using a dependency
and a few settings.

## References

1. Microservice architecture
2. Spring Boot Actuator Web API Documentation -
   <https://docs.spring.io/spring-boot/docs/2.0.x/actuator-api/html/#health>
3. <https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-monitoring>
