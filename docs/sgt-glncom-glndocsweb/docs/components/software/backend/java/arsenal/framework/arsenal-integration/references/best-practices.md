# Best Practices

In order to write better code using Apache camel, we have listed some good
practices for using camel components to be followed.

## Using ".toD()"

".toD" is the camel component used to create dynamic
[Endpoints](https://camel.apache.org/manual/latest/endpoint.html) and should
only be used when there is a need to create dynamic Endpoints.

When using the HTTP component, the best option to streamline the Path and Query
params is to use the headers that Camel provides for this function
(Exchange.HTTP_PATH and Exchange.HTTP_QUERY)

## Using the HTTP component

To make HTTP calls using camel, use the
[HTTP](https://camel.apache.org/components/latest/http-component.html)
component.

## Using Path and Query param dynamic

To perform HTTP requests with dynamic path and query params, you must use the
respective headers in the camel route Exchange.HTTP_PATH and
Exchange.HTTP_QUERY.

### Example

``` { .java .copy }
.setHeader(Exchange.HTTP_PATH, simple("/${header.id}"))
.setHeader(Exchange.HTTP_QUERY, simple("name=${header.name}" +
                                       "&surname=${header.surname}"))
```

And for the Query parameters of the configuration of the HTTP component, it
continues to be used in the URI.

### HTTP component settings

```{.java .copy}
.to("http://localhost:8080?bridgeEndpoint=true")
```

## Using camel's parent created by Integration Architecture 2.0

For a better functioning of Apache camel with the other components of the
database, it is necessary to use the [Pom
parent](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html)
created by the Integration Architecture 2.0.

To create a project with the proper dependency you can follow the steps in the
Dev Guides.

## Use of Apache Camel version same as parent

If there is a need to add new Apache Camel dependencies to your project, use the same
version that the parent dependency is using.

```{.xml .copy}
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-rabbitmq</artifactId>
    <version>${apache-camel.version}</version>
</dependency>
```

## Too much use of custom processors with inner classes (lambda)

Aiming at a better reading, understanding of the code and unit tests, we should
not always use customized in-line/inner class processors, transformation rules
are normally carried out within the processors.

## Error handling

Apache Camel has several ways of handling errors, you can find more information
on [this page](../how-to-guides/integration/error-handling.md), but you should always handle the exceptions that can be thrown by
your routes.

## Unmarshall without target class

When performing the unmarshall, you must pass the class to which the message
will be converted.

## Unmarshall with target class

```{.java .copy}
.unmarshal().json(JsonLibrary.Jackson, Customer.class)
```

## RestDSL without Swagger builders

When we code exposure routes we should always also document our API using
swagger.

## Only configure one "restConfiguration" per project

For the display of services to work correctly, you must use "restConfiguration"
as explained here, but apache camel + spring boot only supports a single
configuration per project, if there is more than one, only the route that is
valid will be considered valid. started first.

## Using hardcoded urls

To allow dynamic urls, we can use a property in application.yml and
retrieve the value using @Value from spring itself.

```{.json .copy}
api:
    customer:
        url: http://localhost:8080/
```

And to retrieve the value from application.yml:

```{.java .copy}
@Value("${api.customer.url}")
private String customerUrl;
```
