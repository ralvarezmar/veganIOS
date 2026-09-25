# Darwin Spring Boot GraphQL ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot GraphQL` module provides support for Darwin applications built on **[Spring GraphQL](https://docs.spring.io/spring-graphql/docs/1.4.3/reference/html) and [GraphQL Java](https://www.graphql-java.com/)**. Includes Darwin
Context support, Darwin GraphQl error format, etc.

## Functionality

[Spring GraphQL](https://docs.spring.io/spring-graphql/docs/1.4.3/reference/html) integrates the [GraphQL Java](https://www.graphql-java.com/) library in a Spring Boot application including functionalities like: exposing the **GraphQl service as an
endpoint**, create and configure **mappings to resolve GraphQl operations** using annotations, etc.

!!! note

    You can find examples of Spring GraphQL functionalities in the [GraphQL project of Darwin Samples](https://github.com/santander-group-shared-assets/gln-back-darwin-java-samples/tree/develop/graphql).

The `Darwin Spring Boot GraphQL` module extends the Spring GraphQL library providing support for Servlet/Reactive Darwin applications with these functionalities:

- Ensures **DarwinContext access through ThreadLocal in GraphQL DataFetchers** when the execution thread is not the same that Spring MVC handler thread. This is only needed for Servlet applications.

- Resolve any exception thrown during the GraphQL execution following the configured ErrorModel format if it implements `GraphQLErrorModel` interface.

!!! info "Important"

    Any error thrown out of the Spring GraphQL execution (before DispatcherServlet handling) is going to be resolved with the default Darwin error management.

- Configure an InMemory cache to store parsed queries and improve execution time.

- Through `Authorization` library, the operative security can be applied by each GraphQL operation defined in the [Schema](https://www.graphql-java.com/documentation/schema).
  In order to do that, the library offers a set of [SDL Directives](https://www.graphql-java.com/documentation/sdl-directives) for marking each of them setting up the validation rules in order to pass the operative control.
  All the information about how to use `@OperativeControl` directive can be found in this [guide](../darwin-spring-boot-security-authorization/README.md#how-to-use-operativecontrol-directive-on-graphql-schema).

## Installation and configuration

To add the library to any project, include the maven dependency of its starter in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-graphql</artifactId>
    </dependency>

!!! tip "Caution"

    If your application comes from a **previous Darwin Spring Framework version**, you'll have to configure these lines in your **pom.xml** to include your GraphQL external fields in compile-time.

        <build>
            <resources>
                <resource>
                    <directory>${project.basedir}/src/main/resources</directory>
                    <filtering>true</filtering>
                    <includes>                        
                        <include>**/*.graphqls</include>
                        <include>**/*.graphql</include>
                    </includes>
                </resource>
            </resources>
        </build>

    1. If this *resource* block already exists you'll find more *include* tags here.

### Configuration

<!tag:properties>

| Name                              | Default value | Mand. | Description                                                                         | Supported values |
|-----------------------------------|---------------|-------|-------------------------------------------------------------------------------------|------------------|
| darwin.graphql.exceptions.enabled | true          | No    | Boolean to enable/disable GraphQL errors resolution with the configured ErrorModel. | boolean          |
| darwin.graphql.query-cache-size   | 100           | No    | Max number of queries to store in pre-parsed query cache.                           | short            |

<!end:properties>

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## Exposed API

| Name                                                                                                                                                                                                | Type      | Description                                                              | Application Type             |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------------------------------|------------------------------|
| [GraphQLErrorModel](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/exceptions/dto/GraphQLErrorModel.html) | Interface | Interface to be implemented by ErrorModel POJOs to support GraphQLError. | <ul><li><p>All</p></li></ul> |

## Spring GraphQl over HTTP

A GraphQL request with Spring GraphQL can finish with the following HTTP status codes:

- `200`: **all Spring GraphQl executions are going to return a 200 status code**.

- `401`: the GraphQl endpoint was secured but there isn't a valid Authentication token in the request.

- `403`: the authenticated user doesn't have permission to call to GraphQl endpoint.

- `404`: the request was made to an endpoint that doesn't exist.

- `405`: the request was a GET request, only POST request are valid for Spring GraphQl. This doesn't include a response body.

!!! info "Important"

    Only the responses with status code 200 from a GraphQL server will have a body with [GraphQl response format](https://spec.graphql.org/October2021//#sec-Response-Format), containing info according to the execution result: a
    ***data*** field if there is data retrieved and/or ***errors*** field if there was any error during execution. For any other status code, the response body will be resolved by [Darwin REST error
    management](../darwin-spring-boot-core/README.md#exception-handling) (not GraphQL response format).

!!! note

    The [GraphQL](https://spec.graphql.org/October2021/) and [GraphQL over HTTP](https://github.com/graphql/graphql-over-http/blob/main/spec/GraphQLOverHTTP.md) specifications are still evolving at this time, so **Spring
    GraphQL** continue adopting them.

## GraphQL error response format

According to **GraphQL specification**, GraphQL responses from an execution with errors must follow an [error response format](https://spec.graphql.org/October2021/#sec-Errors):

    {
      "errors": [
        {
          "message": "String", (1)
          "locations": [{ "line": "Integer", "column":  "Integer"}], (2)
          "path": [], (3)
          "extensions": {} (4)
        }
      ]
    }

1. Description of the error

2. If the error can be associated to a point of the requested document, it should contain the coordinates of the syntax element involved.

3. If the error can be associated to a particular GraphQl field, it must contain the path from the GraphQl response starting at the root to that field.

4. An additional map to include additional information.

!!! info "Important"

    This format will be received only when the GraphQL operation is executed and return an HTTP status code 200 with errors.

Darwin GraphQL includes a resolver that allows to **set the *message* and *extensions* fields based on the ErrorModel configured in the application** if this implements the `GraphQLErrorModel` interface. The [ErrorModel
customization](../darwin-spring-boot-core/README.md#customize-error-model-fields) will be also executed before getting the info from ErrorModel for GraphQL error.

!!! note

    *Locations* and *path* fields are set automatically by the Darwin resolver.

!!! tip "Caution"

    Disabling [Darwin Core Exception Management](../darwin-spring-boot-core/README.md#darwin-exception-types) also disables this Darwin GraphQL resolver.

### Darwin GraphQLErrorModel

[Support](../darwin-spring-boot-core/README.md#darwin-error-model) GraphQL error responses in addition to regular REST responses following this relation between both formats:

    {
      "errors": [
        {
          "message": "shortMessage",
          "locations": [{ "line": "Integer", "column":  "Integer"}],
          "path": [],
          "extensions": {
            "httpMessage": "errorName",
            "httpCode": "status",
            "moreInformation" : "shortMessage",
            "classification": "DataFetchingException" (1)
          }
        }
      ]
    }

1. This field is included automatically by Spring GraphQL.

### ExtendedError GraphQLErrorModel

[Support](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/darwin-project/darwin-spring-boot-extended-error/)
GraphQL error responses in addition to regular REST responses following this relation between both formats:

    {
      "errors": [
        {
          "message": "description",
          "locations": [{ "line": "Integer", "column":  "Integer"}],
          "path": [],
          "extensions": {
            "httpMessage": "description",
            "httpCode": "code",
            "moreInformation": "description",
            "classification": "DataFetchingException" (1)
          }
        }
      ]
    }

1. This field is included automatically by Spring GraphQL.

## Use cases

You can find use cases including the main Spring GraphQl features (simple Spring GraphQl app, pagination, batch processing, QueryDSL) in the [Darwin Samples
project](https://github.com/santander-group-shared-assets/gln-back-darwin-java-samples/tree/develop/graphql).

### Adapt an ErrorModel for GraphQl error responses

An [ErrorModel configured for Darwin Spring Boot Framework](../darwin-spring-boot-core/README.md#replace-darwin-error-model) can be adapted easily to be used for GraphQl error responses. If this is the configured model:

    @JsonDeserialize(builder = ErrorModelExampleBuilder.class)
    @Builder
    public class ErrorModelExample {

        private int code;

        private String error;
    }

    @JsonPOJOBuilder(withPrefix = "")
    public class ErrorModelExampleBuilder implements ErrorModelBuilder<ErrorModelExample> {

        @Override
        public ErrorModelExample buildErrorModel(String appName, Map<String, Object> errorModelAttributes) {
            ...
        }
    }

We just need to implement the `GraphQLErrorModel` interface and its methods to obtain a ***message*** and ***extensions*** for GraphQl error response:

    @JsonDeserialize(builder = ErrorModelExampleBuilder.class)
    @Builder
    public class ErrorModelExample implements GraphQLErrorModel {

        private int code;

        private String error;

        @Override
        @NonNull
        public String getGraphQlMessage() {
            return this.error;
        }

        @Override
        public Map<String, Object> getExtensions() {
            return Collections.singletonMap("code", this.code);
        }

    }
    ...

The "errors" field from a GraphQl response with errors will follow this model:

    {
      "errors": [
        {
          "message": "error", (1)
          "locations": [{ "line": "Integer", "column":  "Integer"}],
          "path": [],
          "extensions": {
            "code": 132, (2)
            "classification": "DataFetchingException" (3)
          }
        }
      ]
    }

1. Value of "error" field from ErrorModel

2. Value of "code" field from ErrorModel

3. This field is included automatically by Spring GraphQL.
