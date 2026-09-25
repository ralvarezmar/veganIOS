# Saga orchestration with Arsenal Integration

## When to use Saga in Camel?

The Saga EIP provides a way to define a series of related actions in a Camel
route that should be either completed successfully (all of them) or
not-executed/compensated. Sagas implementations are able to coordinate
distributed services communicating using any transport towards a globally
consistent outcome.

## Implementing the Saga orchestration

### Application 1: declaring the saga participants

The implementation example is based on [rest integration](./rest-integration.md).

There's no need to include new dependencies. Use **.saga()** dsl to start the
definition of a synchronous and sequential saga, then define the routes to be
orchestrated. This EIP(Enterprise Integration Pattern) is implemented in
camel-core libraries.

The Saga EIP requires that a service implementing the interface
*org.apache.camel.saga.CamelSagaService* is added to the CamelContext. In this
example, *InMemorySagaService* will be used. This can be add in the same route
that declares the saga orchestration. Only one SagaService per CamelContext / application.

```{.java .copy title='CreateOrderRoute.java'}

@Component
public class CreateOrderRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {

      InMemorySagaService sagaService = new InMemorySagaService();
      sagaService.setMaxRetryAttempts(0);

      this.getContext().addService(sagaService);

      ...1
```

After that, create a route that will orchestrated you saga, below we created a
saga orchestration with 2 other routes.

```{.java .copy title='CreateOrderRoute.java'}
      ...1

      from("direct:create-order")
          .routeId("order-create-saga")
          .setProperty("order", body())
          .saga()
              .timeout(5000, TimeUnit.MILLISECONDS)
              .to("direct:create-order-backend")
              .to("direct:create-debit-backend")
          .end();

      ...2
```

And here's an example of a route that is orchestrated by the saga,
in this example, we are calling a http backend

```{.java .copy title='CreateOrderRoute.java'}

      ...2

      from("direct:create-order-backend")
          .routeId("create-order-backend")
          .saga()
              .propagation(SagaPropagation.MANDATORY)
              .option("order", simple("${exchangeProperty.order}"))
              .compensation("direct:cancel-order-topic")
              .doTry()
                  .process(new TransformOrderRequest())
                  .removeHeaders("CamelHttp*")
                  .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.POST.toString()))
                  .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
                  .setHeader(Exchange.HTTP_PATH, simple("/backend/api/order"))
                  .marshal().json(JsonLibrary.Gson)
                  .to("{{backend.order.url}}")
                  .unmarshal().json(JsonLibrary.Gson, Order.class)
                  .process(new TransformOrderResponse())
              .doCatch(Exception.class)
                  .throwException(Exception.class, "Backend order error")
              .end();
```

This route calls a backend component and if it fails, a **compensation** will be
called to handle the error. It is recommended to handle the error and propagate
the error message furthermore. Compensation can be defined using
**.compensation()** and **.option()** can be used to store properties that will
be used in the compensation flow.

Is recommended that the compensation action occurs in asynchronous way.
This become the process more resilient. Decreases the load and the complexity
of actual application and adds persistence mechanisms related to compensation
with Apache Kafka broker.

In order to do the compensation, canceling the order and refunding the debt,
in an asynchronous way, instead of do a http request to the same backend,
that create the order/debit, lets only publish a message in a Kafka topic
and another application will be responsible to consume the message in this topic
and will handle the compensation actions.

For each compensation action is recommended create a specific topic in
Kafka broker. This way the complexity of consumer is reduced and the actions
need are segregated.

To publish a message in a topic is necessary to include the Kafka component to
the application dependencies, configure the kafka broker host e use
the camel dsl with kafka component to set the topic name.

#### Step 01: Add dependency

```{ .xml .copy title="pom.xml" }
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-kafka-starter</artifactId> # (1)
</dependency>
```

1. The version is managed by `camel-spring-boot-bom` declared at
`<dependencyManagement>` section.

#### Step 02: Configure kafka host

``` { .yaml .copy title="application.yml" }
camel:
  component:
    kafka:
      brokers: localhost:29092
```

!!! note

    This configuration is at component level. So all the endpoints "kafka:" will point to this broker. To override this configure at endpoint use the parameter brokers. Example: `.to("kafka:topicName?brokers=kafka-instance1:29092,kafka-instance2:29092")`.

Here's an example of the compensation route defined in this saga that publish
in a kafka topic to be consumed by another application that
will be created later in this how to.
The message sent to the topic is based in value defined in **.option()** dsl.
It's value is primary saved in exchange property when *.option()* dsl is used
and move to message *header* when the compensation is triggered.

#### Step 03: Implement the compensation route to publish at kafka topic

```{.java .copy title='CreateOrderCompensationRoute.java'}
from("direct:cancel-order-topic").routeId("cancel-order-topic-routeId")
    .setHeader(KafkaConstants.KEY, simple("order-${header.order.getId}"))
    .setBody(simple("${header.order}"))
    .to("kafka:compensation-step01-order")
.end();
```

### Application 2: Kafka topic consumer and compensation action implementation

Now with the message publish in a kafka topic lets create a application that
consumes this topic and execute the actions need to undo the operation.

#### Step 01: Create a new application

Follow the current process to create a new application at Gluon Marketplace.

To accomplish this "how to" will be executed the maven command `archetype:generate`
from arsenal-integration-rest-archetype without an OpenAPI Contract.

```{.shell .copy title='mvn archetype:generate'}
mvn archetype:generate \
    -DarchetypeGroupId=com.santander.ars \
    -DarchetypeArtifactId=gln-back-integration-rest-archetype \
    -DarchetypeVersion=RELEASE \
    -DgroupId=com.santander \
    -DartifactId=arsenal-integration-demo-saga-compensation-async-consumer \
    -Dversion=0.1.0-SNAPSHOT  \
    -DisGluon=true \
    -DApiYaml=NoApiYaml
```

#### Step 02: Remove unnecessary properties, dependencies and plugins

1. property: openapi-contract-path
2. dependencies: camel-openapi-java-starter, camel-http-starter, ...
3. plugins: gln-back-arsenal-integration-openapi-maven-plugin,
openapi-generator-maven-plugin, ...

#### Step 03: Add kafka dependency

```{ .xml .copy title="pom.xml" }
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-kafka-starter</artifactId> # (1)
</dependency>
```

1. The version is managed by `camel-spring-boot-bom` declared at
`<dependencyManagement>` section.

#### Step 04: Configure kafka host

``` { .yaml .copy title="application.yml" }
camel:
  component:
    kafka:
      brokers: localhost:29092
```

#### Step 05: Configure parameters to the compensation: kafka topics and backend to undo the operation

``` { .yaml .copy title="application.yml" }
compensation:
  order:
    broker:
      topic: compensation-step01-order
      group: kafkaGroup
      maxPollRecords: 5000
      dlq: compensation-step01-order-error-dlq
    backend:
      url: http:localhost:9090
      timeout: 2000
    retry:
      delay: 200
```

#### Step 06: Implement the route to consume the kafka topic

```{.java .copy title='ConsumerCompensationRoute.java' linenums="1"}
from("kafka:{{compensation.order.broker.topic}}"
    + "?groupId={{compensation.order.broker.group}}"
    + "&maxPollRecords={{compensation.order.broker.maxPollRecords}}"
    + "&consumersCount=1")
    .routeId("consumer-compensation-step01-order-routeId")
    .to("direct:proceed-compensation-step01-order")
.end();
```

#### Step 07: Implement the route with the actions needed to undo the operation

``` {.java .copy title='CancelCreateOrderRoute.java' linenums="1"}
onException(Exception.class)
    .maximumRedeliveries(3)
    .redeliveryDelay("{{compensation.order.retry.delay}}")
    .to("kafka:{{compensation.order.broker.dlq}}");

from("direct:proceed-compensation-step01-order")
    .routeId("proceed-compensation-step01-order-routeId")
    .unmarshal().json(OrderReq.class)
    .process(new TransformCancelOrderRequest())
    .removeHeaders("CamelHttp*")
    .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.POST.toString()))
    .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
    .setHeader(Exchange.HTTP_PATH, simple("/backend/api/order/cancel"))
    .marshal().json(JsonLibrary.Gson)
    .to("{{compensation.order.backend.url}}")
    .log("Canceled Order !!!!!")
.end();
```

After consumes the JSON message at the compensation topic from step01-order
it's parsed to OrderReq that its values is used to fill the Order object needed
to call the backend.
To any exception(**line 1**) occurred during route an retry is executed
for until 3 times(**line 2**) from the step/code line that throw the error.
For example: if the backend request(**line 15**) return an timeout exception,
another try is executed after the delay of 200ms (**line 3**).
And after the first call and 3 retries was not able to complete the compensation
the message body used to do the request is sent to kafka topic (**line 4**)
`compensation-step01-order-error-dlq` to be handled in another time.

The full example implementation for application 1(arsenal-integration-saga-demo)
and application 2(arsenal-integration-kafka-demo) are available at <https://github.com/santander-group-gluon/gln-back-java-internal-poc>.
