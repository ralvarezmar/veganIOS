# Apache Camel Integration ![1.0.0](https://img.shields.io/badge/1.0.0-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Introduction

This guide explains how to integrate the Santander Spring Boot framework with Apache Camel using the `ProducerTemplate` for routing and processing messages.
The `ProducerTemplate` is a powerful utility provided by Apache Camel that allows developers to send messages to Camel routes programmatically.

As a prerequisite for reading this document, the developer should know:

- Java.
- Spring Boot 3.X.
- Apache Camel 4.x.
- Maven.

### Apache Camel

Apache Camel is an open-source integration framework that provides a standardized, domain-specific language (DSL) for defining routing and mediation rules.
It allows developers to integrate various systems and applications using Enterprise Integration Patterns (EIPs).
Camel supports a wide range of protocols and data formats, enabling seamless communication between disparate systems.

Key Features of Apache Camel:

- Supports over 300 components for integration with various technologies (e.g., HTTP, JMS, FTP, etc.).
- Implements Enterprise Integration Patterns for robust and scalable integration solutions.
- Provides a flexible and extensible architecture for custom integrations.
- Uses a Java DSL for defining routes.

### Framework Santander Spring Boot Spring

The Santander Spring Boot Spring framework includes a set of libraries with cross functionalities that complement Spring and are necessary for microservices to comply with the Santander Spring Boot architecture guidelines.

### Implementation Steps

#### Prerequisites

Before proceeding, ensure you have the following:

- **Java Development Kit (JDK):** 17.
- **Apache Camel Dependencies:** Add the required dependencies to your Maven `pom.xml` file:

``` xml
<!-- Apache Camel dependencies -->
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-spring-boot-starter</artifactId>
</dependency>
```

``` xml
<!-- Apache Camel Test Dependency -->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-test-junit5</artifactId>
    <scope>test</scope>
</dependency>
```

#### Step 1: Define a Camel Route

Create a Camel route using the RouteBuilder class. This route will process incoming messages and perform transformations.

``` java
import org.apache.camel.builder.RouteBuilder;

public class CamelHelloWorldRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        from("direct:mainRoute")
            .routeId("MainRoute")
            .removeHeaders("*")
            .transform(body().append(" Hello, World!"))
            .end();
    }
}
```

The provided code defines a simple Apache Camel route using the RouteBuilder class. Apache Camel is an integration framework that allows developers to define routing and mediation rules for processing messages between systems.
The CamelHelloWorldRouteBuilder class extends RouteBuilder, which is a base class for creating custom routes in Camel.

Within the configure method, the route is defined using Camel's domain-specific language (DSL). The route starts with the from method, which specifies the input endpoint for the route.
In this case, the endpoint is direct:mainRoute, a direct component that allows synchronous message passing within Camel. The routeId method assigns a unique identifier, "MainRoute," to the route for easier debugging and management.

The route then performs two operations on incoming messages. First, it removes all headers from the message using the removeHeaders("*") method. This ensures that the message is stripped of any metadata, leaving only the body for further processing.
Next, the transform method modifies the message body by appending the string " Hello, World!" to its existing content. The body() function retrieves the current message body, and the append method adds the specified text.
Finally, the end method marks the end of the route definition.

This route is a simple example of how Camel can be used to process and transform messages. It demonstrates key concepts such as defining endpoints, manipulating message headers, and transforming message content using Camel's DSL.
The route is designed to be reusable and can be invoked programmatically using Camel's ProducerTemplate or other components.

#### Step 2: Implement the Adapter Class

Create an adapter class that uses ProducerTemplate to send messages to the Camel route.

``` java
import org.apache.camel.ProducerTemplate;

public class CamelHelloWorldAdapter implements CamelHelloWorldOutputPort {

    private final ProducerTemplate producerTemplate;

    public CamelHelloWorldAdapter(ProducerTemplate producerTemplate) {
        this.producerTemplate = producerTemplate;
    }

    @Override
    public String sayHello() {

        String message = producerTemplate.requestBody(
                "direct:mainRoute",
                "Hello, Camel!",
                String.class);

        return message;
    }
}
```

The provided code defines a Java class named CamelHelloWorldAdapter, which serves as an adapter for integrating with Apache Camel using the ProducerTemplate.
This class implements the CamelHelloWorldOutputPort interface, which defines the contract for the sayHello method.

The class declares a ProducerTemplate field, which is a utility provided by Apache Camel for programmatically sending messages to Camel routes.
The ProducerTemplate is injected into the class via its constructor, adhering to the principle of dependency injection.

The core functionality of the class resides in the sayHello method. This method send message to the Camel route identified by the URI direct:mainRoute.
The direct component in Camel is used for synchronous message passing within the same Camel context. The method then uses the ProducerTemplate to send a message to this route.
Specifically, it calls the requestBody method, passing the route URI (direct:mainRoute), the message body ("Hello, Camel!"), and the expected response type (String.class).
This method sends the message to the route and waits for a response, which is returned as a string.

The sayHello method encapsulates the logic for interacting with the Camel route, making it reusable and easy to test. The adapter pattern used here decouples the application logic from the specifics of the Camel framework, promoting modularity and maintainability.
This design is particularly useful in microservices architectures, where components need to interact with external systems in a standardized way.

Overall, the CamelHelloWorldAdapter class demonstrates a simple yet effective way to integrate with Apache Camel using the ProducerTemplate.
It highlights key concepts such as dependency injection, logging, and synchronous message passing, making it a valuable example for developers working with integration frameworks.

#### Step 3: Test the Integration

Write a simple test to verify the integration between Santander Framework and Apache Camel.

``` java
import org.apache.camel.CamelContext;
import org.apache.camel.ProducerTemplate;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class CamelIntegrationTest {

    @Autowired
    private ProducerTemplate producerTemplate;

    @Test
    public void testCamelRoute() {
        String response = producerTemplate.requestBody("direct:mainRoute", "Hello, Camel!", String.class);
        assertEquals("Hello, Camel! Hello, World!", response);
    }
}
```

The provided code defines a test class named CamelIntegrationTest, which is designed to verify the behavior of an Apache Camel route within a Spring Boot application using JUnit 5 and @SpringBootTest annotation.

The @SpringBootTest annotation indicates that the test should load the full application context, enabling integration testing of the application's components.
This is particularly useful for testing Apache Camel routes, as it ensures that the Camel context and other Spring-managed beans are properly initialized.

The ProducerTemplate is injected into the test class using Spring's @Autowired annotation. This template is a utility provided by Apache Camel that allows programmatic interaction with Camel routes.
By injecting it, the test can send messages to Camel routes and verify their responses.

In the test testCamelRoute method, the ProducerTemplate is used to send a message to the Camel route identified by the URI direct:mainRoute.
The requestBody method sends the message "Hello, Camel!" to the route and expects a response of type String.
The response is then compared to the expected value "Hello, Camel! Hello, World!" using JUnit's assertEquals method. If the actual response matches the expected value, the test passes; otherwise, it fails.

This test serves as a simple yet effective way to validate the functionality of the direct:mainRoute Camel route. It ensures that the route processes the input message correctly and produces the expected output.
By using integration testing, the test verifies not only the route's logic but also its interaction with other components in the application context.

### Key Points

**ProducerTemplate**: Used to send messages to Camel routes programmatically.
**Santander Framework**: Provides additional libraries and guidelines for microservice development.
**Camel Routes**: Define the integration logic using Apache Camel DSL.

### Useful Links

Here are some resources to help you learn more about Apache Camel and Santander Framework:

- [Santander Framework GitHub Repository](https://github.com/santander-group-shared-assets/gln-back-java-framework-spring-boot)
- [Santander Framework Camel Samples](https://github.com/santander-group-shared-assets/gln-back-java-framework-spring-boot-samples/tree/main/camel)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Apache Camel Documentation](https://camel.apache.org/manual/latest/)
- [Apache Camel Components](https://camel.apache.org/components/latest/)
- [Apache Camel Producer Template](https://camel.apache.org/manual/producertemplate.html)
- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/)
