# Health Check

## Spring Boot Actuator

In Arsenal Cloud Native applications, we use the Spring Boot Actuator library to
expose the health check capability. The Actuator already has native implementations
to check the health of the application regarding the connection to the database,
connection to queues, available disk space, among others.

## How to use

### Actuator Configuration

The default configuration that is delivered in our archetypes allows us to check
the status of an application and its corresponding health check. The configuration
is as follows:

``` { .yaml .copy }
management:
  endpoint:
    health:
      show-details: "ALWAYS"
      probes:
        enabled: true
  health:
    livenessState:
      enabled: true
    readinessState:
      enabled: true
```

To use Actuator with the details, just add the path in your project URL:

``` { .bash .copy }
    http://localhost:8080/your-context/actuator/health
```

We got the “UP” status, with a group of currently enabled probes.
(by default, the Liveness and Readiness probes are exposed)

Hit these points:

- /actuator/health/liveness
- /actuator/health/readiness

The application does not depend on any other service to be configured, so
both endpoints return “UP” status. Now imagine that your application needs
to publish some messages to RabbitMQ and it needs a connection to do its service.
To check the corresponding status, you need to include Rabbit within your status
checking group. It will be something like this:

``` { .yaml .copy }
management:
  endpoint:
    health:
      group:
        readiness:
          include: rabbit, diskSpace
```

With this configuration, we instructed Spring to return the state of our
applications’s readiness based on a set of health indicators including
rabbit. Now when the readiness probe is being fetched, it will get check for
rabbit indicator too!

## Self Configured Indicators

Actuator has a series of self-configured indicators for different technologies.
In case your application uses a resource that is not present in
[this list](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.endpoints.health.auto-configured-health-indicators),
add a customized indicator according to the example in the next topic.

## Custom Indicators

In some situations it may be necessary to implement a manual health check.
These cases happen mainly when we use a product for which the Actuator does not
provide native support. For example, Actuator is able to check connectivity to
RabbitMQ queues, but it does not support ActiveMQ; in this case, it would be
necessary to implement a manual health checking logic.

The example below illustrates how we can implement a custom health check indicator:

``` { .java .copy }
@Component
public class CustomHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        int errorCode = check(); // method that checks the health check

        if (errorCode != 0) {
            // Verification failed, so a status will be returned "DOWN"
            return Health.down().withDetail("Error Code", errorCode).build();
        }

        // The check worked, a status will be returned "UP"
        return Health.up().build();
    }

    public int check() {
        // Here is our custom logic to run the health check
        return 0;
    }
}
```

## DB2 - Health check para mainframe

Applications that integrate with the high platform and consume DB2 base, end up
performing SQL statements for health check indicators. Spring Actuator's default
health checks if DB2/Mainframe is active through “SELECT 1 FROM SYSIBM.SYSDUMMY1”.

However, this is not recommended as it is consuming resources and connections that
could be used for real activity. Legacy services do this check through connection
pooling. This carelessness in the implementation burdens the instances too much,
as well as attacks the MIPS Reduction project: MIPS Reduction - Offload Project.

As an alternative to this, we can implement a custom Spring Health Indicator check
without the need to query the database. First, we must disable Spring Boot's default
check through the following property to be placed in the application's application.yaml:

``` { .yaml .copy }
management:
    health:
        db:
        enabled: false
```

Next, we create the class with the custom Health Indicator check:

``` { .java .copy }
@Component
public class CustomHealthCheck implements HealthIndicator {

    @Autowired
    private DataSource dataSource;

    @Override
    public Health health() {
        try {
            Connection connection = dataSource.getConnection();
            if (Objects.isNull(connection)) {
              return Health.down().build();
            } else {
              return Health.up().build();
            }
        } catch (SQLException e) {
            return Health.down().withDetail("Error Code", e.getErrorCode()).build();
        }
    }
}
```

## References

1. [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html)
