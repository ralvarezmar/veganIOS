# Implementing Unit Tests

Initially, we need to include the test libraries dependencies in the **pom.xml**
file.

``` { .xml .copy }
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-test-spring-junit5</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <scope>test</scope>
</dependency>
```

To test a Camel Spring Boot application, annotate your test classes with
**@CamelSpringBootTest**. This brings Camel Spring Test support to the
application, so you can write tests using Spring Boot testing conventions.

With the **@SpringBootTest** annotation, Spring Boot provides a convenient way
to initialize a Camel context **(CamelContext)** to be used in testing.

The **@MockEndpointsAndSkip** annotation enables mock routes, not forwarding the
message to the real endpoint.

!!! warning

        Camel activates the mock of all routes by default, you must inform
        the routes that will be mocked as a parameter in the annotation
        `@MockEndpointsAndSkip`

``` { .java .copy }
package br.com.santander.camel.demotest.router;

// some imports

@CamelSpringBootTest
@SpringBootTest(classes = { IntegrationApplication.class },
                webEnvironment = WebEnvironment.DEFINED_PORT)
@MockEndpointsAndSkip("direct:hello")
public class CamelRouterTest {

// some methods

}
```

To get the CamelContext or ProducerTemplate, you can inject them into the class
in the normal Spring way, using @Autowired.

In the case of the ProducerTemplate, instead of @Autowired, you can annotate it
with @Produce and then define which default endpoint it will access.

The ProducerTemplate interface lets you send messages to endpoints in many
different ways, making it easy to work with Camel Endpoint instances from Java
code.

It can be configured with a default endpoint if you want to send a lot of
messages to the same endpoint; or you can specify an endpoint or uri as the
first parameter.

You can also use Camel Spring test annotations to configure tests declaratively.
This example uses the @MockEndpoints annotation to automatically mock endpoint.

``` { .java .copy }
@Autowired
CamelContext camelContext;

// define mock endpoint according defined uri
@EndpointInject(uri = "mock:direct:hello")
private MockEndpoint mockEndpoint;

// define a producer to send message to a route according defined uri
@Produce(uri = "direct:start")
private ProducerTemplate producerTemplate;
```

In JUnit, test methods are identified with the @Test annotation.

The @DirtiesContext annotation indicates that the CamelContext, routes, and mock
endpoints will be reset between test methods.

In the example below, we have a test scenario of consumption of an endpoint,
this scenario serves to simulate, for example, the return of a microservice.

We are configuring the mock route to return the **mock-response** text, then we
are sending any message to the default endpoint **direct:start** (configured by
the @Produce annotation)

Then we create an assertion that will make the comparison with the expected
result.

``` { .java .copy }
@DirtiesContext
@Test
public void testRouteWithAnMockResponse() throws Exception {

    // set mock return body
    mockEndpoint.returnReplyBody(new ConstantExpression("mock-response"));

    // send message to test endpoint
    String response = (String) producerTemplate.requestBody("");

    // check response
    assertEquals("mock-response", response);
}
```

Testing in a distributed and/or asynchronous processing environment is
notoriously difficult. MockEndpoints work very well with the Camel Testing
Framework to simplify unit and integration testing when using Enterprise
Integration Patterns and the wide variety of Camel components.

The Mock component provides a powerful declarative testing mechanism, which is
similar to jMock in that it allows conditions to be created on any MockEndpoint
before testing begins. Then the test runs, which typically triggers messages to
one or more endpoints, and finally the conditions can be validated in a test
case to ensure the system works as expected.

This allows you to test various things like:

* If the correct number of messages are received on each endpoint.
* If the correct payload is received, in the right order.

In the following example, we will change the testing strategy, we will use the mock
to validate the message that the endpoint is receiving, this is very useful for
messaging scenarios, where we need to validate the message sent to a queue.

Below, we are configuring a condition regarding the message that will reach the
mock, in this case, the **mock-response** message, then we are sending the same
message to the default endpoint **direct:start** (configured by the @Produce
annotation)

Then we create two validations, one will count the messages received, in this
case, a single message, and the other verifies that all the conditions created at
the beginning of the test have been met.

``` { .java .copy }
@DirtiesContext
@Test
public void testMockEndpointWithARequest() throws Exception {

    // set message that will arrive in the mock endpoint
    mockEndpoint.expectedBodiesReceived("mock-request");

    // send message to endpoint
    producerTemplate.sendBody("mock-request");

    // verify if all assertions is satisfied
    mockEndpoint.assertIsSatisfied();

    // check the number of messages delivered/received
    MockEndpoint.expectsMessageCount(1, mockEndpoint);
}
```

To run the tests, use the maven command below:

``` { .bash .copy }
mvn test
```
