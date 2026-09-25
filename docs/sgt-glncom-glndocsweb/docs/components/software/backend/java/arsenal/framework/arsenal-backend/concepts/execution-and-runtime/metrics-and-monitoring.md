# Metrics and Monitoring

Actuator provides **metrics** resources that facilitate application monitoring,
collecting metrics, understanding traffic or the state of our database, becomes
trivial with this dependency.

The main benefit of this library is that we can get production-grade tools
without having to implement these features.

The actuator is primarily used to expose operational information about the
running application - health, metrics, info, dump, env, etc.

## Endpoint Metrics

The endpoint /metrics publishes information about OS, JVM, and application-level
metrics. Once activated, we get information such as memory, heap, processors,
threads, loaded classes, unloaded classes, thread pools, as well as some HTTP
metrics.

## Most relevant topics

The most relevant topics regarding metrics are: **Memory, Garbage Collector, CPU
and Request**.

### Memory

The memory-related endpoints display data regarding the amount of memory, memory
used, memory available to the JVM, and Buffered memory used by the JVM.

| Endpoint                               | Function                                           |
|----------------------------------------|----------------------------------------------------|
| /actuator/metrics/jvm.memory.used      | Returns the amount of memory used.                 |
| /actuator/metrics/jvm.memory.used      | Amount of memory the JVM is using for buffering.   |
| /actuator/metrics/jvm.memory.max       | Returns the amount of available memory.            |
| /actuator/metrics/jvm.memory.committed | Returns the amount of memory in bytes for the JVM. |

### Garbage Collector

The endpoint referring to the Garbage Collector and freeing memory.

| Endpoint                                  | Function                                                     |
|-------------------------------------------|--------------------------------------------------------------|
| /actuator/metrics/jvm.gc.memory.promoted  | Returns the amount of memory freed by the Garbage Collector. |

### CPU

Endpoints for CPU, recent usage, and available.

| Endpoint                            | Function                                      |
|-------------------------------------|-----------------------------------------------|
| /actuator/metrics/system.cpu.usage  | CPU usage.                                    |
| /actuator/metrics/system.cpu.count  | Number of processors available to the system. |
| /actuator/metrics/process.cpu.usage | Number of processors available to the JVM.    |

### Request

Displays the number of received requests and Tomcat statistics.

| Endpoint                                     | Function                            |
|----------------------------------------------|-------------------------------------|
| /actuator/metrics/http.server.requests       | Number of requests received.        |
| /actuator/metrics/tomcat.threads.config.max  | Maximum number of Tomcat threads.   |
| /actuator/metrics/tomcat.global.error        | Number of errors related to Tomcat. |
| /actuator/metrics/tomcat.threads.busy        | Number of busy Tomcat threads.      |

### Resilience

Displays the endpoints of the
[Resilience4j](https://resilience4j.readme.io/docs/getting-started-3) library,
to use these metrics access Monitoring.

| Endpoint                                                          | Function                                                                                                                                         |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| /actuator/metrics/resilience4j.circuitbreaker.state               | The status of the Circuit Breaker. Eg: closed, disabled, half_open, forced_open or open.                                                         |
| /actuator/metrics/resilience4j.circuitbreaker.calls               | Total number of disallowed calls. Ex.: ignored, failed, not_permitted, successful                                                                |
| /actuator/metrics/resilience4j.circuitbreaker.max.buffered.calls  | The maximum number of buffered calls that can be stored in the ring buffer.                                                                      |
| /actuator/metrics/resilience4j.circuitbreaker.failure.rate        | The Circuit Breaker Failure Rate.                                                                                                                |
| /actuator/metrics/resilience4j.circuitbreaker.buffered.calls      | The number of successful buffered calls stored in the ring buffer.                                                                               |
| /actuator/metrics/resilience4j.retry.calls                        | The number of failed calls after a retry attempt. E.g.,successful_without_retry, uccessful_with_retry, failed_with_retry or failed_without_retry |
| /actuator/metrics/resilience4j.ratelimiter.available.permissions  | The number of available permissions.                                                                                                             |
| /actuator/metrics/resilience4j.ratelimiter.waiting_threads        | The number of waiting threads.                                                                                                                   |

## Glossary

JVM - The Java Virtual Machine is responsible for executing programs in bytecode
format, but the JVM not only plays this role, it is actually the main structure
of the Java ecosystem, responsible for providing such cross-platform capability.
Once you install the JVM on the operating system (Windows, Linux, Mac, etc.), it
is capable of interpreting and executing the compiled program in bytecode format
on any of these OSes. The JVM executes a bytecode program, even if this bytecode
program is not necessarily written in Java.

## Referências

1. [Spring Boot Actuator
   Metrics](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-metrics.html)
