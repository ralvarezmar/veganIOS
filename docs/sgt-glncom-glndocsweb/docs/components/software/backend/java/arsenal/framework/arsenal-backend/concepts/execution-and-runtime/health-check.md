# Health Check

It is good practice, and often a business requirement, to monitor applications
and services to ensure they are available and functioning correctly.

It may happen that a service instance is unable to handle requests, but is still
running, for example: it may have run out of database connections. When this
occurs, a monitoring system must generate an alert so that an operator can
investigate what is happening. Also, the load balancer should no longer forward
requests to the offending service instance.

The mechanism used for this is called a health check, or verification of the
"health" of the application. OpenShift already has a mechanism to health check
applications, alert and restart when necessary. But for this to work, he needs
the application itself to provide a service (usually at /health address) that
returns the state of the application at that moment.

## Spring Boot Actuator

In Arsenal Cloud Native applications, we use the Spring Boot Actuator library to
expose the health check capability. The Actuator already has native
implementations to check the health of the application regarding the connection
to the database, connection to queues, available disk space, among others.

## References

[Spring Boot
Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html)

[How to implement healthcheck](../../how-to-guides/execution-and-runtime/health-check.md)
