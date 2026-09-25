# Implementation REST Integration

## Minimal dependencies in pom.xml

``` { .xml .copy }
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-spring-boot-starter</artifactId>
 </dependency>

<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-openapi-java-starter</artifactId>
</dependency>

<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-servlet-starter</artifactId>
</dependency>

<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-http-starter</artifactId>
</dependency>

<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-jackson-starter</artifactId>
</dependency>
```

When the backend has an openapi contract, it is possible to generate the
equivalent java code, this facilitates the transformations made in Camel routes.

We use the plugin below to generate the contract, the plugin documentation can
be found at [Openapi Generator Maven
Plugin](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator-maven-plugin)

``` { .xml .copy }
<plugin>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-openapi-maven-plugin</artifactId>
    <executions>
        <execution>
            <phase>generate-sources</phase>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <skip>true</skip>
                <fileSwaggerYamlJsonLocation>${openapi-contract-path}</fileSwaggerYamlJsonLocation>
                <rootPackageClass>${groupId}</rootPackageClass>
                <outputGeneratedClasses>${project.build.sourceDirectory}</outputGeneratedClasses>
                <outputGeneratedTestClasses>${project.build.testSourceDirectory}
                </outputGeneratedTestClasses>
                <isGluon>${isGluon}</isGluon>
                <skipOverwrite>true</skipOverwrite>
            </configuration>
        </execution>
    </executions>
</plugin>
<plugin>
    <groupId>org.openapitools</groupId>
    <artifactId>openapi-generator-maven-plugin</artifactId>
    <version>${openapi-generator-maven-plugin.version}</version>
    <executions>
        <execution>
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <inputSpec>${openapi-contract-path}</inputSpec>
                <generatorName>spring</generatorName>
                <modelPackage>${groupId}.model.dto</modelPackage>
                <generateModels>true</generateModels>
                <generateSupportingFiles>false</generateSupportingFiles>
                <generateModelTests>false</generateModelTests>
                <generateModelDocumentation>false</generateModelDocumentation>
                <generateApis>false</generateApis>
                <generateApiTests>false</generateApiTests>
                <generateApiDocumentation>false</generateApiDocumentation>
                <configOptions>
                    <dateLibrary>java8</dateLibrary>
                    <useBeanValidation>false</useBeanValidation>
                    <openApiNullable>false</openApiNullable>
                    <useJakartaEe>true</useJakartaEe>
                </configOptions>
            </configuration>
        </execution>
    </executions>
</plugin>
```

The generated classes use by default the package declared in **modelPackage**.

!!! warning

    The **generateSupportingFiles** and **generateApis** parameters must
    not be changed or removed, as they create java client implementations, Camel
    only needs the model classes that represent the contract entities (swagger
    definitions).

The openapi contract file must be located in the path specified by the inputSpec
attribute, having its code generated in the path specified in the output
attribute in the folder specified in sourceFolder.

    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   └── resources
        │       ├── application.yml
        │       ├── openapi
        │           ├── user-contract.yaml

!!! tip

    In a contract first strategy, where the contract already exists exposed
    by camel in openapi format, it is possible to use the plugin to generate the
    java classes of the contract.

!!! warning

    By default, contract classes are generated at compile time (/target)
    and are not stored in the source code repository, if there is a need to
    manually change them (format adjustments, inclusion of annotations), this
    strategy, changing the class generation location and disabling the plugin.

For GET calls, before actually calling the backend, we need to prepare the
message, as a good practice we remove all headers that start with CamelHttp so
that the HTTP component does not use them in the new call.

The Exchange.HTTP_METHOD and Exchange.HTTP_PATH headers must be informed and
must have the desired http operation and the path of the service to be called,
respectively.

In the case of GET, the body of the message must be empty.

GET call example

``` { .java .copy }
from("direct:get-backend")
    .routeId("order-get-backend")
    .doTry()

        .removeHeaders("CamelHttp*")
        .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.GET.toString()))
        .setHeader(Exchange.HTTP_PATH, simple("/backend/api/order/${header.id}"))
        .setBody(constant(""))
        .to("{{backend.order.url}}?socketTimeout={{integration.timeout.backend}}")
        .unmarshal().json(JsonLibrary.Gson, Order.class)

        .process(new TransformGetResponse())

        .removeHeaders("*")
        .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
        .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.OK.value()))

        .endDoTry()
    .doCatch(SocketTimeoutException.class)
        .process(new ProcessTimeoutException())
    .doCatch(Exception.class)
        .process(new ProcessException())
    .endDoTry();
```

After returning from the backend, we must convert the response to the java class
equivalent to the contract (unmarshal).

We transform the backend contract to the camel response contract through a
process.

As a good practice, before returning to the consumer we remove unnecessary
headers and assign the expected Content Type and Http Response Code.

For POST calls, before the actual backend call, we need to prepare the message,
transforming the content to the target contract, as a good practice we remove
all headers that start with CamelHttp so that the HTTP component does not use
them in the new call.

The headers Exchange.HTTP_METHOD, Exchange.CONTENT_TYPE and Exchange.HTTP_PATH
must be informed and must have, respectively, the desired http operation, the
type of message to be sent and the path of the service to be called.

We must convert the message containing the java class to JSON (marshal)

POST call example

``` { .java .copy }
    from("direct:create-backend")
        .routeId("order-create-backend")
        .doTry()
            .process(new TransformCreateRequest())

            .removeHeaders("CamelHttp*")
            .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.POST.toString()))
            .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
            .setHeader(Exchange.HTTP_PATH, simple("/backend/api/order"))
            .marshal().json(JsonLibrary.Gson)
            .to("{{backend.order.url}}?socketTimeout={{integration.timeout.backend}}")
            .unmarshal().json(JsonLibrary.Gson, Order.class)

            .process(new TransformCreateResponse())

            .removeHeaders("*")
            .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
            .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.OK.value()))

            .endDoTry()
        .doCatch(SocketTimeoutException.class)
            .process(new ProcessTimeoutException())
        .doCatch(Exception.class)
            .process(new ProcessException())
        .endDoTry();
```

After returning from the backend, we must convert the response to the java class
equivalent to the contract (unmarshal).

We transform the backend contract to the camel response contract through a
process.

As a good practice, before returning to the consumer we remove unnecessary
headers and assign the expected Content Type and Http Response Code.

## Application parameters

Dynamic parameters must be declared in the **application.yml** file and can be
accessed through the {{ }} directive

Eg: .to("{{backend.order.url}}?socketTimeout={{integration.timeout.backend}}")

``` { .yaml .copy }
backend:
    order:
        url: http:localhost:9090

integration:
    timeout:
        backend: 2000
```

## Transformation

When the contracts exposed in the camel and in the backend are different, we
need to transform the messages, this is done by obtaining the current message
(body and headers), creating a new message and carrying out the necessary
transfer of information.

!!! tip

    If we want to store a message for future use, in an orchestration for
    example, we must use the property attribute of the exchange

Example transformation from Camel Request to Backend Request

``` { .java .copy }
public class TransformCreateRequest implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {
        OrderDTO orderDTO = exchange.getMessage().getBody(OrderDTO.class);
        Order order = new Order();

        order.setId(orderDTO.getId());
        order.setName(orderDTO.getName());

        exchange.getMessage().setBody(order);
    }
}
```

Example of transforming Backend Response to Camel Response

``` { .java .copy }
public class TransformCreateResponse implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {
        Order order = exchange.getMessage().getBody(Order.class);
        OrderDTO orderDTO = new OrderDTO();

        orderDTO.setId(order.getId());
        orderDTO.setName(order.getName());

        exchange.getMessage().setBody(orderDTO);
    }
}
```

## Error Handling

Similar to traditional Java exception handling, Camel's DSL has methods for
error handling, doTry and doCatch play this role.

``` { .java .copy }
    from("direct:create-backend")
        .routeId("order-create-backend")
        .doTry()
            ...
            .endDoTry()
        .doCatch(SocketTimeoutException.class)
            ...
        .doCatch(Exception.class)
            ...
        .endDoTry();
```

To handle the exception, just include a processor in doCatch and handle the
specific exception.

!!! tip

    The exception is stored in an exchange property and can be obtained
    through the constant Exchange.EXCEPTION_CAUGHT

Example of an exception handling processor

``` { .java .copy }
public class ProcessException implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {
        Exception e = exchange.getProperty(Exchange.EXCEPTION_CAUGHT, Exception.class);
        exchange.getMessage().setBody(e.getMessage());
        exchange.getMessage().setHeader(Exchange.CONTENT_TYPE, MediaType.TEXT_PLAIN_VALUE);
        exchange.getMessage().setHeader(Exchange.HTTP_RESPONSE_CODE, HttpStatus.INTERNAL_SERVER_ERROR.value());
    }
}
```

The backend of the example was simulated using SOAP UI, the
REST-Backend-Mock-soapui-project.xml project file is found in the root of the
source code.

!!! INFO

      All the information describe in this document can be generated using the archetype. Follow: [Arsenal Integration Rest Archetype](../../tutorials/archetype-rest.md)

## References

1. [HTTP
   component](https://camel.apache.org/components/4.0.x/http-component.html){:target="_blank"}
2. [Timeout](../execution-and-runtime/timeout.md)
3. [Transformation](transformation.md)
4. [Openapi Generator Maven
   Plugin](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator-maven-plugin){:target="_blank"}
