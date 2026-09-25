# Health Check

## Spring Boot Actuator

In Arsenal Integration applications, we use the Spring Boot Actuator library to
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
  server:
    port: 9001
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

Once the actuator have been configured, our service will already provide a series
of endpoints with information, metrics and data on the health of the microservice
instance. Which in our example will expose the endpoints on port 9001 and ip
127.0.0.1, that is, using a port that is not the same one on which our microservice
responds for requests.

It is very common to see the health data displayed on the same port that our
microservice responds to, and this is not necessarily a bad practice, but in the
actuator case, we can expose using a different port using the
**management.server.port** configuration, this implies running a second instance
of a server instead of registering a servlet in the same instance where our
microservice is running. The use of this other port brings us advantages
because, in case of "congestion" of the application port or it denies
microservices for any reason, we can still obtain the microservice's health
data, something that would not be possible if we exposed the health data on the
same door.

Along with the technique of segregating the output and microservice endpoints
into different ports, we also have the possibility of segregating them by
network using the **management.server.address** configuration. This segregation
can be a sensible choice for deployments, as in addition to not exposing health
data to consumers in the same operating context, we can segregate networks and
ensure that our business traffic does not compete with metrics and monitoring
traffic.

### Endpoints

By default, the actuator uses the pre-configured base path as **/actuator**,
however, for a team need or any other reason it may be necessary to change this
endpoint, this can be done using the configuration options as below:

``` { .yaml .copy }
management:
  endpoints:
    web:
      base-path: /saude
```

> ***Observations***: Unless the port used for the health check has been
configured to expose the endpoints using a different HTTP port, the
configuration option **management.endpoints.web.base-path** is relative to
the **server.servlet.context-path**. If **{{ management.server.port}}** is
set (as in our example), **management.endpoints.web.base-path** is relative
to **management.server.servlet.context-path**, and this is a point of
attention to avoid that an error occurs because we try to expose endpoints
with the same base-path in the same context when using the same port to
expose the service and health check endpoints.

#### Endpoint /actuator/info

The **/actuator/info** endpoint provides us with more general information about
our microservice, such as uptime in milliseconds and in a readable way, the
version of Apache Camel, its status and the name of the microservice for
example.

To view the information about the microservice instance, we just need to make a
GET request to <http://localhost:9001/actuator/info>, and we will get the return
as shown below:

``` { .json .copy }
{
    "camel.name":"CamelHealthCheck",
    "camel.version":"2.24.1",
    "camel.uptime":"3 minutes",
    "camel.uptimeMillis":209340,
    "camel.status":"Started"
}
```

#### Endpoint /actuator/health

The **/actuator/health** endpoint, on the other hand, provides us with detailed
information about the health and health of the microservice instance, such as
the health data of each running component, data on database connections, data on
storage quotas.

Spring Boot Actuator has several predefined health indicators like
**DataSourceHealthIndicator**, **DiskSpaceHealthIndicator**,
**MongoHealthIndicator**, **RedisHealthIndicator**, **CassandraHealthIndicator**
etc. It uses these health indicators as part of the health check process.

For example, in our microservice we use **Redis**, so the
**RedisHealthIndicator** will be used as part of the health check. If it were
the case that we use **MongoDB**, the **MongoHealthIndicator** will be used as
part of the health check, and so on.

To view detailed information about the microservice instance, we just need to
make a GET request to <http://localhost:9001/actuator/health>, and we will get
the return as shown below:

``` { .json .copy }
{
    "status":"UP",
    "details":{
        "camel":{
            "status":"UP",
            "details":{
                "name":"CamelHealthCheck",
                "version":"2.24.1",
                "uptime":"34.807 seconds",
                "uptimeMillis":34807,
                "status":"Started"
            }
        },
        "diskSpace":{
            "status":"UP",
            "details":{
                "total":479903834112,"free":209075040256,"threshold":10485760
            }
        }
    }
}
```

The response contains details of the microservice's health as well as its
components, as shown in the following table:

| Element                    | Type   | Description                                                                                                                                             |
|----------------------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| status                     | String | Overall status of the microservice based on the statuses of all components.                                                                             |
| details                    | Object | Microservice component health details. This attribute is controlled by the management.endpoint.health.show-details setting in our application.yml file. |
| details.COMPONENTE.status  | String | Status of the component in question.                                                                                                                    |
| details.COMPONENTE.details | Object | Component-specific health details, varying structure by component                                                                                       |

The microservice components can have their health data obtained individually
since we can make a request to the /actuator/health/COMPONENT_NAME endpoint with
a return as shown below:

``` { .json .copy }
{
    "status":"UP",
    "details":{
        "name":"CamelHealthCheck",
        "version":"2.24.1",
        "uptime":"32 minutes",
        "uptimeMillis":1975397,
        "status":"Started"
    }
}
```

``` { .json .copy }
{
    "status":"UP",
    "details":{
        "total":479903834112,
        "free":209069670400,
        "threshold":10485760
    }
}
```

The return of these endpoints are the same objects that make up the health of
the microservice as a whole, and that are sent in response to the endpoint call
**/actuator/health**. This response contains details of the microservice
component's health as shown in the following table:

| Element | Type   | Description                                                                 |
|---------|--------|-----------------------------------------------------------------------------|
| status  | String | Overall status of the microservice based on the statuses of all components. |
| details | Object | Microservice component health details.                                      |

These endpoints are valid for all components that our service has, allowing an
extremely detailed health check to be carried out if well implemented by the
development teams.

### Configuring existing endpoints

By default, all actuator endpoints are exposed via JMX, and only health check
and information endpoints are exposed via HTTP. These restrictions can be
circumvented by performing some configurations to expose all endpoints or even
those that interest us.

To expose all endpoints, we can use the
management.endpoints.web.exposure.include configuration, which receives a string
or a list of endpoints to be exposed via HTTP, as shown in the example below:

``` { .yaml .copy }
...
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: '*'
```

``` { .yaml .copy }
...
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health, info, metrics, prometheus
```

For a complete listing of available endpoints check documentation available at
<https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-endpoints>

### Adding new endpoints

Some teams may need to create a custom health indicator, either because it is a
unique implementation, or because the microservice consumes some legacy
technology for which there is no **HealthCheckIndicator** implemented. For that,
we just need to implement the **HealthIndicator** interface or extend the
**AbstractHealthIndicator** class.

``` { .java .copy }
...
@Component
public class AltairHealthIndicator extends AbstractHealthIndicator {
    @Override
    protected void doHealthCheck(Health.Builder builder) throws Exception {
        // TODO implement some check
        boolean running = true;
        if (running) {
            builder.up()
                    .withDetail("aea", "Running ok");
        } else {
            builder.up()
                    .withDetail("aea", "Failed to...");
        }
    }
}
```

## Health check in the orchestration of micro-micro-microservices

Container orchestration platforms like Openshift, Rancher and their peers that
run on top of Kubernetes can (and should) make use of endpoint health checks to
determine when it is necessary to take down an unhealthy pod or container.

In OpenShift for example we have several options to detect and handle unhealthy
containers. Kuberbetes periodically performs diagnostics on a running container
using **probes**. There are different types of **probes**, each with a different
purpose.

The most common way is to make an HTTP call to an endpoint to determine its
health based on its return and HTTP response code.

Therefore, an implementation of health check endpoints is not only useful for
reporting the microservice status to other microservices, load balancers and
service registry, but also plays an important role in the orchestration phase of
the microservices, as these endpoints can be used to determine the maintenance
or destruction of a pod or container.

## References

1. Microservice architecture
2. Spring Boot Actuator Web API Documentation -
   <https://docs.spring.io/spring-boot/docs/2.0.x/actuator-api/html/#health>
3. <https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-monitoring>
