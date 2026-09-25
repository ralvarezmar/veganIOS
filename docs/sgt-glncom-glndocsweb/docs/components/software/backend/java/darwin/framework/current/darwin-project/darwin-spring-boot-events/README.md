# Darwin Spring Boot Events ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Events` library provides the necessary functionality to generate and/or consume events from `Kafka` topics.

The event format is based on an extension of the [CloudEvents](https://cloudevents.io/) specification, which allows us to describe events in a common, accessible and portable way.

!!! info "Important"

    This library is intended to automate its use in environments with `Brokers Kafka` through `Spring Kafka`. This library is not intended for use on systems other than `Spring Kafka`, such as `Spring Cloud Stream`. If you have
    any questions, please open a ticket to architecture support.

## Events Functionality

!!! info "Important"

    If you need information about the `darwin-spring-boot-business-events` library, please refer to the [Business Events](../darwin-spring-boot-business-events/README.md) documentation.

A `Builder` named `DarwinCloudEventBuilder` is provided to generate `DarwinCloudEvent` events. The `DarwinCloudEvent` type events will be events formed from a composition of the original `CloudEventBuilder` plus a `CloudEventExtension` named
`DarwinExtension` which allows us to inject `Darwin` own parameters, therefore the `DarwinCloudEvent` type events will be compatible with the `CloudEvent` specification.

The library supports three event formats:

- `JSON`

    - This format allows generating events expressed in `JSON` format.

- `AVRO`

    - The `Avro` format allows generating events expressed according to the `Avro 1.9.1` specification.

- `CUSTOM`

    - The `custom` allow to customize events type through configuration. By default the library will configure the String serializer/deserializer for the Kafka Clients.

!!! info "Important"

    The format that the library automatically sets up will be `Avro`, being this the default event format that all projects must follow.

In case of choosing the `Json` event format, `CloudEvent` supports **two models for transferring events to Kafka messages**:

- **Structured**: In this model both the event metadata and the event content (`data` field) are placed inside the `Kafka` message.

- **Binary**: In this model the event metadata is mapped to `Headers Kafka` and the event content (`data` field) is mapped to the `Kafka` message.

!!! info "Important"

    The format that the library automatically sets up will be binary, being this the mandatory transfer mode that all projects must follow.

An object of type `CloudEvent` is decomposed into a set of `Kafka Headers + Body` that are sent to the topic. The following describes the information that is sent/retrieved when a `DarwinCloudEvent` message is sent/received.

- **Headers**

| Header                | Type           | Required  | Origen.[^1] | Description                                                                                                                                                                                                 | Example                                                                                     |
|-----------------------|----------------|-----------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| ce_id                 | String         | Mandatory | CloudEvent  | Event identifier. Producers must ensure that `source + id` are unique for each distinct event. Consumers may assume that identical `source + id` are duplicates. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#id) | "7a0dc520-c870-4193c8"                                                                      |
| ce_source             | URI            | Mandatory | CloudEvent  | Identifies the producer or source that generated the event. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#source-1)                                                                                                | "san/adn360/customer-microservice"                                                          |
| ce_specversion        | String         | Mandatory | CloudEvent  | Version of the CloudEvents specification. The only supported version will be v1.0. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#specversion)                                                                      | "1.0"                                                                                       |
| ce_type               | String         | Mandatory | CloudEvent  | Attribute containing the value describing the type of event related to the original occurrence. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#type)                                                                | "com.santander.customer.create"                                                             |
| ce_time               | OffsetDateTime | Mandatory | CloudEvent  | Date of the event creation. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#time)                                                                                                                                    | "2020-08-04'T'12:45:00Z"                                                                    |
| content-type          | String         | Optional  | CloudEvent  | Message content type (value of the `data` field). [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#datacontenttype)                                                                                                   | "application/json;charset=utf-8" for `Json events` and "application/avro" for `Avro events` |
| ce_subject            | String         | Optional  | CloudEvent  | Attribute describing the subject of the event in the context of an event producer (identified by the `source` field). [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#subject)                                       | "/account/1234"                                                                             |
| ce_dataschema         | URI            | Optional  | CloudEvent  | Identifies the schema to which the `data (body)` is attached. [More information.](https://github.com/cloudevents/spec/blob/v1.0/spec.md#subject)                                                                                               | "http://schemas.gs.corp/accounts"                                                           |
| ce_channel            | String         | Optional  | Darwin      | Identifies the channel through which the user interacts.                                                                                                                                                    | "INT"                                                                                       |
| ce_sessionid          | String         | Optional  | Darwin      | Identifies the user's session in the application.                                                                                                                                                           | "7fddae8e-8977-11e0-bc11-003048c3b1f2"                                                      |
| ce_acceptlanguage     | String         | Optional  | Darwin      | Information about internationalization.                                                                                                                                                                     | "es_ES"                                                                                     |
| ce_entity             | Integer        | Optional  | Darwin      | International bank identifier (BIC, code 8, ISO 9632).                                                                                                                                                      | "0049"                                                                                      |
| ce_authorization      | String         | Optional  | Darwin      | Authentication token associated with the user.                                                                                                                                                              | "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vd…​"                                                       |
| ce_operationalcontrol | String         | Optional  | Darwin      | Token with the operational control validation data.                                                                                                                                                         | "gYSBwZXJzZZlcmFuY2Ugbm5hbCBwbGV2Yg…​"                                                      |

- **Body**

| Body/Payload | Required | Origen.    | Description                                                                                                                                                                                                 | Example                     |
|--------------|----------|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------|
| data         | Optional | CloudEvent | The payload of the message. There is no restriction on the type of information in this attribute. It will be encoded in a format according to the value specified by the `content-type` header, if present. | "{ ...application data...}" |

To create a `DarwinCloudEvent` from the `Builder` we can use the specific methods for each attribute, use the `Darwin` contexts or even some of them will be automatically filled with default values. The following table shows how each of the
`DarwinCloudEvent` fields are populated:

| Header                | Initialization of the attribute                                                                                                                                                                                                                                                                                                                                                                                                                       |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| content-type          | It is initialized by `CloudEventBuilder.v1().withDataContentType("value")`. If a value is assigned it must follow the specification [RFC2046](https://tools.ietf.org/html/rfc2046). If not initialized it will be automatically populated based on the "data" field. If the "data" field is of type `PojoCloudEventData` or `BytesCloudEventData` the value will be `application/json;charset=utf-8`, otherwise the value will be `application/avro`. |
| ce_id                 | It is initialized by `CloudEventBuilder.v1().withId("value")`. It does not apply a default value, since being a mandatory field it must always be initialized.                                                                                                                                                                                                                                                                                        |
| ce_source             | It is initialized by `CloudEventBuilder.v1().withSource(uri_value)`. It does not apply a default value, since being a mandatory field it must always be initialized.                                                                                                                                                                                                                                                                                  |
| ce_specversion        | This field is always auto-configured with the value "1.0" so there is no need to initialize it.                                                                                                                                                                                                                                                                                                                                                       |
| ce_type               | It is initialized by `CloudEventBuilder.v1().withType("value")`. It does not apply a default value, since being a mandatory field it must always be initialized.                                                                                                                                                                                                                                                                                      |
| ce_time               | It is initialized by `CloudEventBuilder.v1().withTime(now)`. In case it is not `set`, it is automatically initialized with `OffsetDateTime.now()`.                                                                                                                                                                                                                                                                                                    |
| ce_subject            | It is initialized by `CloudEventBuilder.v1().withSubject("value")`. If not initialized, the default value will be `null`.                                                                                                                                                                                                                                                                                                                             |
| ce_dataschema         | It is initialized by `CloudEventBuilder.v1().withDataSchema(uri_value)`. If not initialized, the default value will be `null`.                                                                                                                                                                                                                                                                                                                        |
| ce_channel            | It can be initialized in two ways, through `DarwinCloudEventBuilder().withChannel("value")` or automatically from the information stored in the `DarwinInfo` object located in `DarwinContext`; for the latter to work it is necessary to have `set` the context through `` DarwinCloudEventBuilder().withDarwinInfo(darwinInfo). In case of not initializing it, the default value will be `null ``.                                                 |
| ce_sessionid          | It can be initialized in two ways, by `DarwinCloudEventBuilder().withSessionId("value")` or automatically from the information stored in the `DarwinInfo` object located in `DarwinContext`; for the latter to work it is necessary to have `set` the context by `DarwinCloudEventBuilder().withDarwinInfo(darwinInfo)`. If not initialized, the default value will be `null`.                                                                        |
| ce_acceptlanguage     | It can be initialized in two ways, by `DarwinCloudEventBuilder().withAcceptLanguage("value")` or automatically from the information stored in the `DarwinInfo` object located in `DarwinContext`; for the latter to work it is necessary to have `set` the context by `DarwinCloudEventBuilder().withDarwinInfo(darwinInfo)`. It does not apply a default value, since being a mandatory field it must always be initialized.                         |
| ce_entity             | It can be initialized in two ways, by `DarwinCloudEventBuilder().withEntity(value)` or automatically from the information stored in the `DarwinInfo` object located in `DarwinContext`; for the latter to work it is necessary to have `set` the context by `DarwinCloudEventBuilder().withDarwinInfo(darwinInfo)`. It does not apply a default value, since being a mandatory field it must always be initialized.                                   |
| ce_authorization      | It can be initialized in two ways, by `DarwinCloudEventBuilder().withAuthorization("value")` or automatically from the information stored in the `Authentication` object located in the security context; for the latter to work it is necessary to have `set` the context by `DarwinCloudEventBuilder().withAuthentication(authentication)`. If not initialized, the default value will be `null`.                                                   |
| ce_operationalcontrol | It can be initialized in two ways, by `DarwinCloudEventBuilder().withOperationalControl("value")` or automatically from the information stored in the `Authentication` object located in the security context; for the latter to work it is necessary to have `set` the context by `DarwinCloudEventBuilder().withAuthentication(authentication)`. If not initialized, the default value will be `null`.                                              |

### Auto configurations

The event library will automatically set up all its functionalities for any execution environment of a `Spring boot` application, being those defined in
[WebApplicationType](https://docs.spring.io/spring-boot/docs/3.5.7/api/org/springframework/boot/WebApplicationType.html): `NONE`, `SERVLET` and `REACTIVE`.

!!! note

    Although the library will run correctly in any environment, special care should be taken when selecting the application type. It will most commonly be used in `NotWeb` type applications, i.e. applications that start up,
    connect to a `Broker` and send or receive messages. This does not exclude the possibility of using it in `Servlet` or `Reactive` type applications where it is necessary to attend requests via `Http` in addition to emitting or receiving messages from
    the `Broker`.

The library autoconfigures the following elements:

- The `CloudEvent` extension named `DarwinExtension` is registered.

- The `Kafka Producer` is configured with the following properties:

    - The **Confluent\`s** `MonitoringProducerInterceptor` is also included (if it's loaded in classpath) to send messages production information to a Confluent Kafka topic and exploit it using Control Center.

        !!! note

            This class is included in `io.confluent:monitoring-interceptors` dependency.

    - Json format:

        - The `CloudEvents` class is configured to generate events in binary format.

        - Class `CloudEventSerializer` is configured as `Serializer Class` by default for messages.

    - Avro format:

        - The `CloudEventAvroSerializer` class is configured as the default `Serializer Class` for messages.

    - Custom format:

        - The default values of **spring.kafka.producer** will be used for event serialization. By default, it applies the `org.apache.kafka.common.serialization.StringSerializer` value to the key and the value serializer but both of them can be
            customised via the `spring.kafka.producer.key-serializer` and `spring.kafka.producer.value-serializer` properties.

- `Kafka Consumer` is configured with the following properties:

    - An `ErrorHandlingDeserializer` is added by default to handle deserialization errors when receiving an event. The deserializers (CloudEventDeserializer and CloudEventAvroDeserializer) will be configured as deserializers to delegate event
        processing without serialization error.

    - The **Confluent\`s** `MonitoringConsumerInterceptor` is also included (if it's loaded in classpath) to send messages consumption information to a Confluent Kafka topic and exploit it using Control Center.

        !!! note

            This class is included in `io.confluent:monitoring-interceptors` dependency.

    - Json format:

        - The `CloudEventDeserializer` class is set as `Deserializer Class` by default for messages.

    - Avro format:.

        - The `CloudEventAvroDeserializer` class is configured as `Deserializer Class` by default for messages.

        - Property "***specific.avro.reader***" is set to **True** if wasn't configured in "spring.kafka.consumer.properties".

    - Custom format:

        - The default values of **spring.kafka.consumer** will be used for event serialization. By default, it applies the `org.apache.kafka.common.serialization.StringSerializer` value to the key and the value serializer but both of them can be
            customised via the `spring.kafka.consumer.key-deserializer` and `spring.kafka.consumer.value-deserializer` properties.

- A **health check is configured for Kafka** based on connection status.

### Resilience Modes

Currently, the library supports two resiliency modes: delivered guarantee and realtime.

#### Delivery guarantee mode with SLA: 99.95%

This mode applies to all domains/applications whose need is delivery guarantee and whose delivery time is not critical.

The producer must wait until the message is in all replicas and the consumer must execute the acknowledgement after making sure that the message has been processed correctly.

Here we must ensure that the message is sent to Kafka and retrieved for the consumers, this is when the most extreme resilience must be configured.

    darwin:
      events:
        resilienceMode: deliveredguarantee

With `deliveredguarantee` mode the following default configuration will be set:

    acks =  all
    retries =  1
    delivery.timeout.ms = 60000
    enable.auto.commit = false
    max.block.ms = 60000
    batch.size = 32768
    linger.ms = 5
    buffer.memory = 67108864
    max.in.flight.requests.per.connection = 1
    compression = gzip
    enable.idempotent = true

#### NRT/Delivery time mode with SLA: 99%

This mode applies to NRT, but may also be applicable for real-time scenarios, where delivery time is mandatory, but the delivery guarantee is not critical, because there is a reconciliation process or the message is not part of a transactional flow.

Minimal resilience is always required, but focusing on delivery time, the commitment at the Consumer will be automatic and the ACK at the Producer will be 1.

    darwin:
      events:
        resilienceMode: realtime

With `realtime` mode the following default configuration will be set:

    acks =  1
    retries =  3
    delivery.timeout.ms = 60000
    enable.auto.commit = true
    max.block.ms = 60000
    batch.size = 16384
    linger.ms = 0
    buffer.memory = 33554432
    max.in.flight.requests.per.connection = 5
    compression = none
    enable.idempotent = false

In both modes the settings can be modified. Unmodified properties will use their default value according to the resilience mode.

Below is an example of how to modify the properties: retries, batch.size and delivery.timeout.ms, of **kafka producer** with **realTime** resilience mode enabled:

    darwin:
      events:
        resilienceMode: realTime

    spring:
      kafka:
        producer:
          retries: 5
          batch-size: 50
          properties:
            delivery:
              timeout:
                ms: 3000

### Protection against deserialization errors

By default, Darwin offers protection against poison pill scenarios. A poison pill can be a corrupted event or an event that produces a deserialization error.

These types of events cause the consumer kafka in charge of receiving them to try to process them again and again giving error without passing to the next one until the Kafka message retention policy is fulfilled. That is, the service is stopped.

Darwin will use an ErrorHandlingDeserializer to detect this type of events and consume them so that the service is maintained passing to the next event.

To disable this capability just configure the property:

    darwin.events.deserialization-protection-enabled: false

#### Error event handling

The default behavior in case of this type of error is to trace the error including the exception produced.

In case you want to customize this behavior it is necessary to create a bean of type SeekToCurrentErrorHandler, for example to send the event to a dead letter topic.

Below is an example that creates a CloudEvents event from a non-CloudEvents event, and sends it to a dead letter topic including in the content the original exception.

    @Bean
    public SeekToCurrentErrorHandler errorHandler(KafkaTemplate<String, CloudEvent> template) {
        return new SeekToCurrentErrorHandler((cr, e) -> {
            CloudEvent event = DarwinCloudEvent.builder()
                    .withBaseCloudEvent(CloudEventBuilder.v1()
                            .withId("1")
                            .withSource(URI.create("http://localhost/source"))
                            .withType("mock.test")
                            .withSubject("mock.subject")
                            .withDataSchema(URI.create("http://localhost/schema"))
                            .withTime(OffsetDateTime.now())
                            .withData(e.toString().getBytes())
                            .withDataContentType("application/json;charset=utf-8")
                            .build()
                    )
                    .withChannel("channel")
                    .withEntity(1234)
                    .withAcceptLanguage("es_ES")
                    .build();
            template.send(TEST_TOPIC + ".DLT", event);
        } );
    }

#### Deserialization errors and listeners in Batch mode

In case of using a Kafka listener in batch mode. It should be noted that the default behavior is that events that produced an error will be delivered to the listener as null.

For example:

    @KafkaListener(topics = "${app.topic}", groupId = "${app.groupid}", containerFactory = "kafkaListenerBatchContainerFactory")
    public void listenCloudEvents(@Payload List<CloudEvent> events, @Header(KafkaHeaders.RECEIVED_TOPIC) List<String> topic) {
       ...
    }

In this listener the delivered event collection will contain 'null' values in case any event could not be deserialized.

To customize this behavior, in this case instead of creating a bean of type SeekToCurrentErrorHandler we can customize the function that uses the ErrorHandlingDeserializer to process the events with error.

To do this we will have to create a class that implements a function in which given a FailedDeserializationInfo (which is the error information that ErrorHandlingDeserializer constructs) an event is generated that can be delivered to the listener.

The following example creates a CloudEvent from a FailedDeserializationInfo, so that the batch listener can have information of the events with error.

    public class NoCloudEventProvider implements Function<FailedDeserializationInfo, CloudEvent> {
            @Override
            public CloudEvent apply(FailedDeserializationInfo info) {
                CloudEvent event = DarwinCloudEvent.builder()
                        .withBaseCloudEvent(CloudEventBuilder.v1()
                                .withId("1")
                                .withSource(URI.create("http://localhost/source"))
                                .withType("mock.test")
                                .withSubject("mock.subject")
                                .withDataSchema(URI.create("http://localhost/schema"))
                                .withTime(OffsetDateTime.now())
                                .withData(info.toString().getBytes())
                                .withDataContentType("application/json;charset=utf-8")
                                .build()
                        )
                        .withChannel("channel")
                        .withEntity(1234)
                        .withAcceptLanguage("es_ES")
                        .build();
                return event;
            }
    }

It is also necessary to apply the following configuration property:

    spring:
      kafka:
        consumer:
          properties:
            spring.deserializer.value.function: com.sample.NoCloudEventProvider

For more details on batch consumption you can refer to the [spring-kafka documentation on batch listeners](https://docs.spring.io/spring-kafka/docs/3.3.10/reference/html/#batch-listeners).

### Health Checks Kafka

The event module auto-configures a `HealthIndicator` that allows to configure the [`Kubernetes probes`](https://docs.spring.io/spring-boot/docs/3.5.7/reference/html/actuator.html#production-ready-kubernetes-probes) depending on the connectivity with
Kafka.

This indicator makes use of [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/3.5.7/reference/html/actuator.html#production-ready) to add a new component under the health endpoint `http://localhost:8080/actuator/health/kafka`, whose
response will be something like:

    {
      "status": "UP",
      "details": {
        "clusterId": "6qLo82xvQuqTGDnGoYjlsw",
        "brokerId": "1",
        "nodes": 1
      }
    }

!!! note

    The above output is shown with the component details by enabling the `management.endpoint.health.show-details: "always"` property. Projects do not need to set this property except in very specific cases, as the status value
    should be sufficient.

Based on the recommendations published in [Health Check microservices java](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/23879254505/Health+Check+microservices+java), the urls that microservices should configure will be
`/actuator/health/readiness` and `/actuator/health/liveness`. These urls generate the `health check` status from the components defined in the `readiness` and `liveness` groups and by default, they do not take into account external systems such as a
`kafka` cluster, since they are based on the [events that Spring Boot launches](https://docs.spring.io/spring-boot/docs/3.5.7/reference/html/#production-ready-kubernetes-probes-lifecycle) during the life cycle of the application, therefore, it is
important that the projects perform the configuration correctly.

As an example, with the default configuration of `Spring Boot Actuator` and the event module (kafka's `HealthIndicator` enabled by default), when invoking the `health global` via the `http://localhost:8080/actuator/health` endpoint, we could have
the following component state:

    {
      "status": "DOWN",
      "components": {
        "diskSpace": {
          "status": "UP"
        },
        "kafka": {
          "status": "DOWN"
        },
        "livenessState": {
          "status": "UP"
        },
        "ping": {
          "status": "UP"
        },
        "readinessState": {
          "status": "UP"
        }
      },
      "groups": [
        "liveness",
        "readiness"
      ]
    }

That is, the `global health` tells us that the state of the application is `DOWN,` but the invocation to the `http://localhost:8080/actuator/health/readiness` endpoint, will indicate that the application is `UP` because it does not take into account
the `health check` of kafka.

    {
      "status": "UP",
      "components": {
        "readinessState": {
          "status": "UP"
        }
      }
    }

Therefore, we must establish a configuration that responds to our use case so that the endpoint `http://localhost:8080/actuator/health/readiness`, returns the status depending on the components that we consider appropriate. To return the state based
on `readinessState + Health Kafka`, the following configuration must be established:

    management:
      endpoint:
        health:
          group:
            readiness:
              include: "readinessState,kafka"

With this configuration, the invocation to the `http://localhost:8080/actuator/health/readiness` endpoint will return state based on both components:

    {
      "status": "DOWN",
      "components": {
        "kafka": {
          "status": "DOWN"
        },
        "readinessState": {
          "status": "UP"
        }
      }
    }

!!! info "Important"

    The kafka Health Check could also be used in `liveness` tests in case the project wants to force restarts in case of connectivity failures with the Kafka Cluster. To configure it, the same configuration should be applied but
    on the `livenessState` group.

### Automatic generation of Darwin Session and security context for received events

The library allows the automatic generation of the Darwin Session and security context for received events.
Darwin uses the request headers to generate the Darwin Session and security context.
It's only for non-reactive listeners.

This feature is enabled by default.
To disable this feature, set the property `darwin.events.context-creation.enabled` to `false`.

!!! note

    This feature it is necessary to tracing received events in batch mode.

### Observability

!!! note

    All observability features are in the `darwin-spring-boot-logging` library. Please refer to the `darwin-spring-boot-logging` documentation for more information.

## Installation and configuration

To add the library in any project you will have to include the `starter` in your `pom.xml` file. **Darwin Spring Boot Events**:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-events</artifactId>
    </dependency>

It is not necessary to include the `darwin-spring-boot-starter-events` dependency to use `darwin-spring-boot-starter-business-events` or the other way around.

!!! note

    We have separated the events functionality into two starters to limit the number of dependencies that are added to projects

### Configuration

<!tag:properties>

#### General properties (`darwin-spring-boot-starter-events`)

The properties in the attached table only apply if the `darwin-spring-boot-starter-events` starter has been added to the application.

| Name                                             | Default value | Required | Description                                                                                                                                                  | Supported values                    |
|--------------------------------------------------|---------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| darwin.events.enabled                            | true          | No       | Allows to disable the library autoconfiguration.                                                                                                             | Boolean                             |
| darwin.events.format                             | AVRO          | Yes      | Allows to indicate the event format of CloudEvent.                                                                                                           | AVRO and/or JSON                    |
| darwin.events.deserialization-protection-enabled | true          | No       | Enables and disables protection against deserialization errors.                                                                                              | Boolean                             |
| darwin.events.resilience-mode                    | false         | No       | Enables to set the resilience mode.                                                                                                                          | `deliveredguarantee` or `realtime`. |
| darwin.events.context-creation.enabled           | true          | No       | Enables and disables the automatic generation of the Darwin Session and security context for received events.                                                | Boolean                             |
| management.health.kafka.enabled                  | true          | No       | Enables and disables Kafka `healthchecks`.                                                                                                                   | Boolean                             |
| management.health.kafka.response-timeout         | 1000          | No       | Value in milliseconds that defines the connection timeout with kafka from which connectivity error is considered and therefore `readiness=DOWN` is returned. | Number                              |

<!end:properties>

### Darwin Events properties configuration

The following is an example configuration to disable the event library configuration.

    darwin:
      events:
        enabled: false

To configure the event format as JSON, or with a CUSTOM type, we use the following configuration.

- JSON

<!-- -->

    darwin:
      events:
        format: JSON

- CUSTOM

<!-- -->

    darwin:
      events:
        format: CUSTOM

!!! info "Important"

    If `darwin.events.format` is **custom**, By default the kafka producer will configure the value-serializer property set to `org.apache.kafka.common.serialization.StringSerializer` and the kafka consumer will have its
    value-deserializer property set to `org.apache.kafka.common.serialization .StringDeserializer`.

!!! note

    You can see how to use it in [this section](#how-to-define-a-custom-events-format).

Kafka Spring exposes the `authorizationExceptionRetryInterval` property to set a time interval for message fetching retries when an `AuthorizationException` is raised from the `KafkaConsumer`. By default, Spring does not assign any value to this
property. Darwin sets an initial value of 60 seconds. In case it is necessary to set a custom time interval (seconds) for the `authorizationExceptionRetryInterval` property, the following configuration will be used:

    spring:
      kafka:
        consumer:
          properties:
            auth-exception-retry-interval: 30

To disable the automatic generation of activity traces associated with the consumption and sending of messages, set the `darwin.logging.activity.enabled` property to `false`.

    darwin:
      logging:
        activity:
          enabled: false

!!! note

    For more information, see the [configuration](../darwin-spring-boot-logging/README.md#configuration) section of the `Logging` module.

To disable autoconfiguration of kafka `healthchecks`, set the `management.health.kafka.enabled` property to `false`.

    management:
      health:
        kafka:
          enabled: false

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

```xml
<dependency>
    <groupId>com.santander.darwin</groupId>
    <artifactId>darwin-spring-boot-starter-business-events</artifactId>
</dependency>
```

### Support for third party libraries

Added native compilation support for 3rd party libraries used in the Darwin framework.

!!! warning

    This support is limited to the functionality used in Darwin tests, projects using these dependencies may need to add more hints for proper operation.

The functionality covered is:

- Brave, tracing kafka consumers and productors
- Confluent, related to avro and cloudevent support

## Exposed API

| Name                                                                                                                                                                                                                                 | Type                            | Description                                                                                                 | Application Type                         |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------------|------------------------------------------|
| [DarwinCloudEvent](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/DarwinCloudEvent.html)                                  | DarwinCloudEvent                | Exposes a Builder that allows us to create events of type DarwinCloudEvent.                                 | <ul><li>All</li></ul>                    |
| [DarwinExtension](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/extension/DarwinExtension.html)                          | Extension                       | Extension of CloudEvent for attributes specific to Darwin and which are not part of the standard CloudEvent | <ul><li>All</li></ul>                    |
| [CloudEventAvroSerializer](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/serializers/CloudEventAvroSerializer.html)      | Serializer&lt;CloudEvent&gt;    | Serializer that allows to serialize CloudEvent events in Avro format.                                       | <ul><li>All</li></ul>                    |
| [CloudEventAvroDeserializer](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/serializers/CloudEventAvroDeserializer.html)  | Serializer&lt;CloudEvent&gt;    | Deserializer that allows to deserialize CloudEvent events in Avro format.                                   | <ul><li>All</li></ul>                    |
| [AvroCloudEventData](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/data/AvroCloudEventData.html)                         | CloudEventData                  | Class that allows encapsulating Avro types as CloudEventData.                                               | <ul><li>All</li></ul>                    |
| [ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html)                   | ReactiveContextUtil             | Bean that allows to work with Darwin context and security context over a reactive stream in a simple way.   | <ul><li>Reactive</li></ul>               |
| [ReactiveKafkaConsumerFactory](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveKafkaConsumerFactory.html) | ConsumerFactory                 | Factory that allows the creation of reactive Kafka consumers with the default Darwin configuration.         | <ul><li>All</li></ul>                    |
| [ReactiveKafkaProducerFactory](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveKafkaProducerFactory.html) | ProducerFactory                 | Factory that allows the creation of reactive Kafka producers with Darwin's default configuration.           | <ul><li>All</li></ul>                    |
| [KafkaHealthIndicator](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/actuate/KafkaHealthIndicator.html)                  | HealthIndicator                 | Class that defines the Health strategy for Kafka brokers.                                                   | <ul><li>All</li></ul>                    |

## Use cases

### How to send a DarwinCloudEvent to a Kafka topic

#### JSON format

To send a `DarwinCloudEvent` to a Kafka topic in `Json` format you don't have to do anything special, since the library autoconfigures everything necessary, mainly the binary mode of transmission of `CloudEvents` and the class in charge of
serializing the message values. The latter is important, since if we modify the `valueSerializer` property belonging to the `Kafka Producer` the instrumentation will stop working. The rest of the `Kafka` properties can be customized by the project
according to its needs.

!!! info "Important"

    [Spring Kafka](https://docs.spring.io/spring-kafka/docs/3.3.10/reference/html) provides several options to generate or consume messages, all of them valid together with `CloudEvent`, so here we will put a basic example based
    on `KafkaTemplate` but the project could choose other alternatives.

!!! info "Important"

    [Kafka Reactor](https://projectreactor.io/docs/kafka/release/reference/) provides what is needed to generate or consume messages in a reactive way, all of them valid together with `CloudEvent`. Here is an example based on
    `KafkaSender`.

!!! info "Important"

    The library enables `Avro` mode by default, so if you want to work in `Json` mode it is necessary to define the `darwin.events.format=JSON` property.

##### Sending a byte array

Next we show two examples of microservices, one for `Servlet` environments and others for `Reactive` environments, that when starting up deposit a message in a topic with name `mytopic`. In this example the "data" field will be an array of bytes:

###### Non-reactive environments

    @SpringBootApplication
    @Slf4j
    public class KafkaApplicationCloudEvent {

        private static final String DATA = "[\n" +
                "   {\n" +
                "      \"id\":1,\n" +
                "      \"name\":\"Leanne Graham\"\n" +
                "    }\n" +
                "]";

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                .web(WebApplicationType.NONE)
                .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaTemplate<Long, CloudEvent> template) { (2)
            DarwinContext darwinContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .locale(new Locale("he"))
                                              .build();
            darwinContext.setDarwinInfo(darwinInfo);
            DarwinContextHolder.setCurrentContext(darwinContext); (3)
            CloudEvent cloudEvent = DarwinCloudEvent.builder() (4)
                            .withBaseCloudEvent(
                                CloudEventBuilder.v1()
                                     .withId("1")
                                     .withSource(URI.create("http://localhost/source"))
                                     .withType("mock.type")
                                     .withData(DATA.getBytes()) (5)
                                     .build()
                            )
                            .withDarwinInfo(DarwinContextHolder.getCurrentContext().getDarwinInfo())
                            .build();
            return args -> {
                template.send("mytopic", cloudEvent); (6)
            };
        }
    }

1. Because this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `Bean KafkaTemplate` provided by `Spring Kafka`. This `Bean` allows us to send messages to a `Kafka` topic.

3. We create a `DarwinContext` object and initialize the context.

4. We create the `CloudEvent` type event that we want to send to the topic.

5. The `data` (payload) field will be an `array of bytes`. This implies that `CloudEvent` (automatically) creates a `CloudEventData` of type `BytesCloudEventData` that encapsulates the information.

6. We send the event to the topic with name `mytopic`.

###### Reactive environments

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        private static final String DATA = "[\n" +
                "   {\n" +
                "      \"id\":1,\n" +
                "      \"name\":\"Leanne Graham\"\n" +
                "    }\n" +
                "]";

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaSender<Long, CloudEvent> kafkaSender, (2)
                                        ReactiveContextUtil contextUtil) {

            DarwinContext darwinContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .locale(new Locale("he"))
                                              .build();
            darwinContext.setDarwinInfo(darwinInfo); (3)

            return args -> {
                kafkaSender.send(
                    ReactiveContextUtil.getMonoContext()
                        .flatMap(function(
                            (DarwinContext dContext, SecurityContext securityContext) ->
                                Mono.just(1).map(i -> {
                                    DarwinInfo dInfo = dContext.getDarwinInfo();
                                    CloudEvent cloudEvent = DarwinCloudEvent.builder() (4)
                                        .withBaseCloudEvent(
                                            CloudEventBuilder.v1()
                                                 .withId("1")
                                                 .withSource(URI.create("http://localhost/source"))
                                                 .withType("mock.type")
                                                 .withData(DATA.getBytes()) (5)
                                                 .build()
                                        )
                                        .withDarwinInfo(dInfo)
                                        .build();
                                    return SenderRecord.create(
                                            new ProducerRecord<>("mytopic", i, cloudEvent), (6)
                                            i
                                    );
                                })
                        )).contextWrite(
                            context ->
                                ReactiveContextUtil.create(context, darwinContext, null) (7)
                        )
                ).subscribe(); (8)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            KafkaSender<Integer, CloudEvent> createSender(
                    ReactiveKafkaProducerFactory kafkaProducerFactory
            ) {
                Map<String, Object> propsSender = new HashMap<>();
                propsSender.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                propsSender.put(ProducerConfig.CLIENT_ID_CONFIG, "producerId");
                SenderOptions<Integer, CloudEvent> optsReceiver =
                                        SenderOptions.create(propsSender);
                return KafkaSender.create(kafkaProducerFactory, options);
            }

        }
    }

1. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `Bean kafkaSender` provided by `Darwin`. This `Bean` allows us to send messages to a `Kafka` topic by using reactive streams.

3. We create a `DarwinContext` object.

4. We generate a ***record*** which contains the `CloudEvent` type event we want to send to the topic.

5. The `data` (payload) field will be an `array of bytes`. This implies that `CloudEvent` (automatically) creates a `CloudEventData` of type `BytesCloudEventData` that encapsulates the information.

6. We send the event to the topic with name `mytopic`.

7. We subscribe the Reactor context for the generation of the DarwinContext and the SecurityContext. This creation should always be done manually to ensure that these will be available for initialization in the *upstream*.

8. We subscribe the reactive stream generated from the KafkaSender to launch the execution.

!!! info "Important"

    Reactive contexts must be initialized via the *contextWrite(…​)* operator and this must be used at the end of the reactive stream to make them available in the *upstream* once the subscription is made. For more information on
    how to use the operator, refer to the API of [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-).

##### Sending a POJO

`CloudEvents` gives us the possibility to work directly with `POJOs` for this we have to create an object of type `PojoCloudEventData`. Below is an example where an object of type `User` is sent (the code will be the same as above, only the relevant
parts are shown):

###### Non-reactive environments

    import lombok.Data;
    import io.cloudevents.core.data.PojoCloudEventData;
    ...

    @Data
    class User { (1)
        private String userName;
        private String firstName;
        private String lastName;
        private Integer age;
    }

    public class KafkaApplicationCloudEvent {

        @Bean (2)
        public ApplicationRunner runner(KafkaTemplate<Long, CloudEvent> template,
                                        ObjectMapper objectMapper) {  (3)
            ...
            User user = new User(); (4)
            user.setUserName("myself");
            user.setAge(1);
            CloudEvent cloudEvent = DarwinCloudEvent.builder()
                .withBaseCloudEvent(
                    CloudEventBuilder.v1()
                        .withId("1")
                        .withSource(URI.create("http://localhost/source"))
                        .withType("mock.type")
                        .withData(
                             PojoCloudEventData.wrap(user, objectMapper::writeValueAsBytes) (5)
                        )
                        .build()
                )
                .withDarwinInfo(DarwinContextHolder.getCurrentContext().getDarwinInfo())
                .build();
            ...
            };
        }
    }

1. We create a class that represents a `JOB` to send to a `Kafka` topic.

2. Because this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

3. We inject an `ObjectMapper` in order to serialize the `POJO` into a byte stream.

4. We create and initialize the `User` object.

5. We create a `PojoCloudEventData` that encapsulates the `User` object.

###### Reactive environments

    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import lombok.Data;
    import io.cloudevents.core.data.PojoCloudEventData;

    @Data
    class User { (1)
        private String userName;
        private String firstName;
        private String lastName;
        private Integer age;
    }

    public class KafkaApplicationCloudEvent {

        @Bean (2)
        public ApplicationRunner runner(KafkaSender<Long, CloudEvent> kafkaSender,
                                        ObjectMapper objectMapper, (3)
                                        ReactiveContextUtil contextUtil) {
            return args -> {

                User user = new User(); (4)
                user.setUserName("myself");
                user.setAge(1);

                PojoCloudEventData<User> pojo =
                        PojoCloudEventData.wrap(user, objectMapper::writeValueAsBytes); (5)

                kafkaSender.send(
                    ReactiveContextUtil.getMonoContext()
                        .flatMap(function(
                            (DarwinContext dContext, SecurityContext securityContext) ->
                                Mono.just(1).map(i -> {
                                    DarwinInfo dInfo = dContext.getDarwinInfo();
                                    CloudEvent cloudEvent = DarwinCloudEvent.builder()
                                        .withBaseCloudEvent(
                                            CloudEventBuilder.v1()
                                                 .withId("1")
                                                 .withSource(URI.create("http://localhost/source"))
                                                 .withType("mock.type")
                                                 .withData(pojo)
                                                 .build()
                                        )
                                        .withDarwinInfo(dInfo)
                                        .build();
                                     return SenderRecord.create(
                                            new ProducerRecord<>("mytopic", i, cloudEvent),
                                            i
                                    );
                                })
                        )).contextWrite(
                            context ->
                                ReactiveContextUtil.create(context, darwinContext, null)
                        )
                ).subscribe();
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            KafkaSender<Integer, CloudEvent> createSender(
                    ReactiveKafkaProducerFactory kafkaProducerFactory
            ) {
                Map<String, Object> propsSender = new HashMap<>();
                propsSender.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                propsSender.put(ProducerConfig.CLIENT_ID_CONFIG, "producerId");
                SenderOptions<Integer, CloudEvent> optsReceiver =
                                        SenderOptions.create(propsSender);
                return KafkaSender.create(kafkaProducerFactory, options);
            }

        }
    }

1. We create a class that represents a `JOB` to send to a `Kafka` topic.

2. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

3. We inject an `ObjectMapper` in order to serialize the `POJO` into a byte stream.

4. We create and initialize the `User` object.

5. We create a `PojoCloudEventData` that encapsulates the `User` object.

!!! info "Important"

    Reactive contexts must be initialized via the *contextWrite(…​)* operator and this must be used at the end of the reactive stream so that they are available in the *upstream* once the subscription is made. For more information
    on how to use the operator, refer to the [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-) API.

#### Avro Format

To send a `DarwinCloudEvent` to a kafka topic in `Avro` format we will require the use of an [`Avro Schema`](https://avro.apache.org/docs/1.11.1/specification) associated to the information to be sent, this will imply the execution of a series of
steps that in `Json` mode were not necessary. As in the `Json` format, the library autoconfigures everything necessary, mainly the classes in charge of serializing and deserializing the messages. The latter is important, because if we modify the
`valueSerializer` property belonging to the `Kafka Producer` the instrumentation will stop working (the same for the deserializer). The rest of `Kafka` properties can be customized by the project according to its needs.

!!! info "Important"

    [Spring Kafka](https://docs.spring.io/spring-kafka/docs/3.3.10/reference/html) provides several options to generate or consume messages, all of them valid together with `CloudEvent`, so here we will put a basic example based
    on `KafkaTemplate` but the project could choose other alternatives.

!!! info "Important"

    [Kafka Reactor](https://projectreactor.io/docs/kafka/release/reference/) provides what is needed to generate or consume messages in a reactive way, all of them valid together with `CloudEvent`. Here is an example based on
    `KafkaSender`.

Avro\` schemas are defined using `JSON` files. They consist of primitive types (null, boolean, int, long, float, double, bytes, and string) and complex types (record, enum, array, map, union, and fixed). These schemas are stored in files with
extension ".avsc".

As an example we are going to create a schema that represents a user so we will need a file with name "user.avsc" and the following content:

    {"namespace": "example.avro",
     "type": "record",
     "name": "User",
     "fields": [
         {"name": "name", "type": "string"},
         {"name": "favorite_number",  "type": ["int", "null"]},
         {"name": "favorite_color", "type": ["string", "null"]}
     ]
    }

The previous schema will represent the structure of the object we want to send to Kafka. Next we will make use of a maven plugin that allows us to generate java classes that represent the defined schema. The architecture provides a default
configuration for this plugin, this configuration can be modified by the projects according to their needs.

!!! info "Important"

    The Darwin archetype will include the plugin in the pom.xml of the project automatically otherwise it is necessary to add it, since Darwin only provides the default configuration of the plugin.

    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.avro</groupId>
                <artifactId>avro-maven-plugin</artifactId>
                <version>${avro-maven-plugin.version}</version>
                <executions>
                    <execution>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>schema</goal>
                        </goals>
                        <configuration>
                            <sourceDirectory>${project.basedir}/src/main/resources/avro/</sourceDirectory>
                            <outputDirectory>${project.build.directory}/generated/avro</outputDirectory>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </pluginManagement>

If we execute the plugin, it will generate a class "User.java" in the package "example.avro" that will represent the object to send to Kafka and that we can include in the "data" field of a `CloudEvent` event.

    λ mvn generate-sources

Next we finish the example by showing how to send the `Avro` message via `CloudEvent`.

##### Non-reactive environments

    import example.avro.User;
    import com.santander.darwin.events.data.AvroCloudEventData;
    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import io.cloudevents.core.v1.CloudEventV1;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaTemplate<Long, CloudEvent> template) { (2)
            DarwinContext darwinContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .locale(new Locale("he"))
                                              .build();
            darwinContext.setDarwinInfo(darwinInfo);
            DarwinContextHolder.setCurrentContext(darwinContext); (3)

            User user = User.newBuilder() (4)
                 .setName("Charlie")
                 .setFavoriteColor("blue")
                 .setFavoriteNumber(null)
                 .build();

            CloudEvent cloudEvent = DarwinCloudEvent.builder() (5)
                .withBaseCloudEvent(
                        CloudEventBuilder.v1()
                                 .withId("1")
                                 .withSource(URI.create("http://localhost/source"))
                                 .withType("mock.type")
                                 .withData(AvroCloudEventData.wrap(user)) (6)
                                 .build()
                )
                .withDarwinInfo(DarwinContextHolder.getCurrentContext().getDarwinInfo())
                .build();
            return args -> {
                template.send("mytopic", cloudEvent); (7)
            };
        }
    }

1. Because this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `Bean KafkaTemplate` provided by `Spring Kafka`. This `Bean` allows us to send messages to a `Kafka` topic.

3. We create a `DarwinContext` object and initialize the context.

4. We create and initialize the `User` object. This class is the one that was automatically generated from the `user.avsc` avro schema.

5. We create the `CloudEvent` type event that we want to send to the topic.

6. The `data` (payload) field will be an object of type `AvroCloudEventData` that encapsulates the `User` object.

7. We send the event to the topic named `mytopic`.

##### Reactive environments

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaSender<Long, CloudEvent> kafkaSender, (2)
                                        ReactiveContextUtil contextUtil) {

            DarwinContext darwinContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .locale(new Locale("he"))
                                              .build();
            darwinContext.setDarwinInfo(darwinInfo); (3)

            User user = User.newBuilder() (4)
                 .setName("Charlie")
                 .setFavoriteColor("blue")
                 .setFavoriteNumber(null)
                 .build();

            return args -> {
                kafkaSender.send(
                    ReactiveContextUtil.getMonoContext()
                        .flatMap(function(
                            (DarwinContext dContext, SecurityContext securityContext) ->
                                Mono.just(1).map(i -> {
                                    DarwinInfo dInfo = dContext.getDarwinInfo();
                                    CloudEvent cloudEvent = DarwinCloudEvent.builder() (5)
                                        .withBaseCloudEvent(
                                            CloudEventBuilder.v1()
                                                 .withId("1")
                                                 .withSource(URI.create("http://localhost/source"))
                                                 .withType("mock.type")
                                                 .withData(AvroCloudEventData.wrap(user)) (6)
                                                 .build()
                                        )
                                        .withDarwinInfo(dInfo)
                                        .build();
                                    return SenderRecord.create(
                                            new ProducerRecord<>("mytopic", i, cloudEvent), (7)
                                            i
                                    );
                                })
                        )).contextWrite(
                            context ->
                                ReactiveContextUtil.create(context, darwinContext, null) (8)
                        )
                ).subscribe(); (9)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            KafkaSender<Integer, CloudEvent> createSender(
                    ReactiveKafkaProducerFactory kafkaProducerFactory
            ) {
                Map<String, Object> propsSender = new HashMap<>();
                propsSender.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                propsSender.put(ProducerConfig.CLIENT_ID_CONFIG, "producerId");
                SenderOptions<Integer, CloudEvent> optsReceiver =
                                        SenderOptions.create(propsSender);
                return KafkaSender.create(kafkaProducerFactory, options);
            }

        }
    }

1. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `Bean KafkaSender` provided by `Darwin`. This `Bean` allows us to send messages to a `Kafka` topic.

3. We create a `DarwinContext` object.

4. We create and initialize the `User` object. This class is the one that was automatically generated from the `user.avsc` avro schema.

5. We create the `CloudEvent` type event that we want to send to the topic.

6. The `data` (payload) field will be an object of type `AvroCloudEventData` that encapsulates the `User` object.

7. We send the event to the topic named `mytopic`.

8. We subscribe the Reactor context for the generation of the DarwinContext and the SecurityContext. This creation should always be done manually to ensure that these will be available for initialization in the *upstream*.

9. We subscribe the reactive stream generated from the KafkaSender to launch the execution.

!!! info "Important"

    Reactive contexts must be initialized via the *contextWrite(…​)* operator and this must be used at the end of the reactive stream to make them available in the *upstream* once the subscription is made. For more information on
    how to use the operator, refer to the [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-) API.

### How to receive a DarwinCloudEvent from a Kafka topic

As in sending, receiving and processing messages of type `DarwinCloudEvent` from a Kafka topic does not require any special configuration, since the library autoconfigures everything necessary, mainly the class in charge of deserializing the message
values. The latter is important because if we modify the `valueDeserializer` property that it belongs to the `Kafka Consumer`, the instrumentation will stop working. The rest of the `Kafka` properties can be customized by the project based on its
needs.

!!! info "Important"

    [Spring Kafka](https://docs.spring.io/spring-kafka/docs/3.3.10/reference/html) provides several options to generate or consume messages, all of them valid together with `CloudEvent`, so here we will put a basic example, but
    the project could choose other alternatives.

!!! info "Important"

    [Kafka Reactor](https://projectreactor.io/docs/kafka/release/reference/) provides the necessary to generate or consume messages in a reactive way, both valid together with `CloudEvent`.

Below we show two examples of microservices, one for non-reactive environments and the other for reactive environments, which on startup connects to a topic named `mytopic` and receives messages of type `CloudEvent`:

#### JSON format

In order to receive a message in JSON format, the library configures a deserializer for reading events with a JSON structure:

##### Non-reactive environments

Here a couple of examples based on `KafkaListener` annotation:

First, a data event of String type is consumed.

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationAvroCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @KafkaListener(topics = "mytopic") (1)
        public void listen(@Payload CloudEvent event, (2)
                           @Headers MessageHeaders messageHeaders
                          ) {

            // Extract CloudEvent data
            CloudEventData cloudEventData = event.getData(); (3)

            // Convert the event data to bytes
            byte[] dataBytes = cloudEventData.toBytes(); (4)

            // Convert the bytes array to String
            String message = new String(dataBytes); (5)
            log.info("Received message = '{}'", message);

            // Reading the message headers
            messageHeaders.keySet().forEach(key -> {
                Object value = messageHeaders.get(key);
                log.info("Message header {} : {}", key, value); (6)
            });
        }
    }

1. By means of the `@KafkaListener` annotation, we indicate that the `listen` method will process messages of the `mytopic` topic.

2. We indicate that the messages to be processed will be of type `CloudEvent`.

3. Extract the data contained inside the event

4. Transform the Cloud Event data to bytes

5. Finally, we expect the data to be of type `String`. Convert the bytes array to String object.

6. Additionally, we display the `Kafka Headers` by console.

Another example is to consume a data event containing a Pojo.

    import org.springframework.beans.factory.annotation.Autowired;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationAvroCloudEvent {

        @Autowired
        private ObjectMapper objectMapper; (1)

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @KafkaListener(topics = "mytopic") (2)
        public void listen(@Payload CloudEvent event, (3)
                           @Headers MessageHeaders messageHeaders
                          ) {
            // Transform the event data to the Pojo Cloud Event data
            PojoCloudEventData<User> pojoData = CloudEventUtils.mapData( (4)
                    event,
                    PojoCloudEventDataMapper.from(this.objectMapper, User.class) (5)
            );

            // Extract the pojo
            User user = pojoData.getValue(); (6)
            log.info("User received = '{}'", user);

            // Reading the message headers
            messageHeaders.keySet().forEach(key -> {
                Object value = messageHeaders.get(key);
                log.info("Message header {} : {}", key, value); (7)
            });
        }
    }

    @Data
    @AllArgsConstructor
    public static class User {

        private String name;

        private int idAccount;
    }

1. Inject the ObjectMapper instance in order to make the transformations.

2. By means of the `@KafkaListener` annotation, we indicate that the `listen` method will process messages of the `mytopic` topic.

3. We indicate that the messages to be processed will be of type `CloudEvent`.

4. Use the CloudEventUtils class for mapping the data.

5. Use a mapper for transforming the Cloud event to a Pojo Cloud Event data

6. Finally, extract the User object from the Cloud Event data

7. Additionally, we display the `Kafka Headers` by console.

##### Reactive environments

Here is an example based on `kafkaReceiver`:

As the first example, a data event of String type is consumed.

    import io.cloudevents.CloudEvent;
    import org.apache.kafka.common.header.Headers;
    import org.springframework.context.annotation.Configuration;
    import reactor.kafka.receiver.KafkaReceiver;
    import reactor.kafka.receiver.ReceiverRecord;
    import java.nio.charset.StandardCharsets;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaReceiver<Long, CloudEvent> kafkaReceiver) { (2)
            return args -> {
                kafkaReceiver.receive()
                    .doOnNext((ReceiverRecord<Long, CloudEvent> record) -> {
                        // Read the Cloud Event from the record
                        CloudEvent event = record.value();

                        // Extract the CloudEvent data
                        CloudEventData cloudEventData = event.getData(); (3)

                        // Convert the event data to bytes
                        byte[] dataBytes = cloudEventData.toBytes(); (4)

                        // Convert the bytes array to String
                        String message = new String(dataBytes); (5)
                        log.info("Received message =' {}'", message);

                        // Reading the message headers
                        Headers headers = record.headers();
                        headers.forEach(header -> {
                            String value = new String(header.value(), StandardCharsets.UTF_8);
                            log.info("Message header {} : {}", header.key(), value); (6)
                        });
                    })
                    .subscribe(); (7)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            @Bean
            KafkaReceiver<Integer, CloudEvent> createReceiver(
                    ReactiveKafkaConsumerFactory kafkaConsumerFactory
            ) {
                Map<String, Object> propsReceiver = new HashMap<>();
                propsReceiver.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                ReceiverOptions<Integer, CloudEvent> optsReceiver =
                                        ReceiverOptions.create(propsReceiver);
                ReceiverOptions<Integer, CloudEvent> options =
                                        optsReceiver.subscription(Collections.singleton("mytopic"));
                return KafkaReceiver.create(kafkaConsumerFactory, options);
            }

        }
    }

1. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `KafkaReceiver` bean. This reactive consumer has been configured to consume messages from the `mytopic` topic.

3. Extract the data contained inside the event

4. Transform the Cloud Event data to bytes

5. Finally, we expect the data to be of type `String`. Convert the bytes array to String object.

6. Additionally, we display the `Kafka Headers` by console.

7. We subscribe the reactive stream generated from the KafkaReceiver to launch the execution.

The last example shows how to consume a data event containing a Pojo.

    import io.cloudevents.CloudEvent;
    import org.apache.kafka.common.header.Headers;
    import org.springframework.context.annotation.Configuration;
    import reactor.kafka.receiver.KafkaReceiver;
    import reactor.kafka.receiver.ReceiverRecord;
    import java.nio.charset.StandardCharsets;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        @Autowired
        private ObjectMapper objectMapper; (1)

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (2)
        public ApplicationRunner runner(KafkaReceiver<Long, CloudEvent> kafkaReceiver) { (3)
            return args -> {
                kafkaReceiver.receive()
                    .doOnNext((ReceiverRecord<Long, CloudEvent> record) -> {
                        // Read the Cloud Event from the record
                        CloudEvent event = record.value();

                        // Transform the event data to the Pojo Cloud Event data
                        PojoCloudEventData<User> pojoData = CloudEventUtils.mapData( (4)
                                event,
                                PojoCloudEventDataMapper.from(this.objectMapper, User.class) (5)
                        );

                        // Extract the pojo
                        User user = pojoData.getValue(); (6)
                        log.info("User received = '{}'", user);

                        // Reading the message headers
                        Headers headers = record.headers();
                        headers.forEach(header -> {
                            String value = new String(header.value(), StandardCharsets.UTF_8);
                            log.info("Message header {} : {}", header.key(), value); (7)
                        });
                    })
                    .subscribe(); (8)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            @Bean
            KafkaReceiver<Integer, CloudEvent> createReceiver(
                    ReactiveKafkaConsumerFactory kafkaConsumerFactory
            ) {
                Map<String, Object> propsReceiver = new HashMap<>();
                propsReceiver.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                ReceiverOptions<Integer, CloudEvent> optsReceiver =
                                        ReceiverOptions.create(propsReceiver);
                ReceiverOptions<Integer, CloudEvent> options =
                                        optsReceiver.subscription(Collections.singleton("mytopic"));
                return KafkaReceiver.create(kafkaConsumerFactory, options);
            }

        }
    }

    @Data
    @AllArgsConstructor
    public static class User {

        private String name;

        private int idAccount;
    }

1. Inject the ObjectMapper instance in order to make the transformations.

2. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

3. We inject the `KafkaReceiver` bean. This reactive consumer has been configured to consume messages from the `mytopic` topic.

4. Use the CloudEventUtils class for mapping the data.

5. Use a mapper for transforming the Cloud event to a Pojo Cloud Event data

6. Finally, extract the User object from the Cloud Event data

7. Additionally, we display the `Kafka Headers` by console.

8. We subscribe the reactive stream generated from the KafkaReceiver to launch the execution.

This is the simplest example for event consumption making use of a reactive consumer. There will be times when it might be required, for example, after receiving a certain event from a topic, to make use of an HTTP client for invoking an external
service, being necessary to have the initialized contexts for the correct operation of the instrumentation.

In these cases, [Initializing reactive contexts from events](#initializing-reactive-contexts-from-events) that allow the creation of the reactive contexts and their initialization, obtaining the necessary values from the headers informed in the
events. The initialization of contexts in reactive environments always has to be done manually. For non-reactive environments, the creation of contexts occurs automatically.

#### AVRO format

In order to receive a message in AVRO format, the library configures a deserializer for reading events with a AVRO schema:

Avro schemas are defined using `JSON` files. They consist of primitive types (null, boolean, int, long, float, double, bytes, and string) and complex types (record, enum, array, map, union, and fixed). These schemas are stored in files with
extension ".avsc".

As an example we are going to create a schema that represents a user so we will need a file with name "user.avsc" and the following content:

    {"namespace": "example.avro",
     "type": "record",
     "name": "User",
     "fields": [
         {"name": "name", "type": "string"},
         {"name": "favorite_number",  "type": ["int", "null"]},
         {"name": "favorite_color", "type": ["string", "null"]}
     ]
    }

The previous schema will represent the structure of the object we want to receive from Kafka. Next we will make use of a maven plugin that allows us to generate java classes that represent the defined schema. The architecture provides a default
configuration for this plugin, this configuration can be modified by the projects according to their needs.

!!! info "Important"

    The Darwin archetype will include the plugin in the pom.xml of the project automatically otherwise it is necessary to add it, since Darwin only provides the default configuration of the plugin.

    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.avro</groupId>
                <artifactId>avro-maven-plugin</artifactId>
                <version>${avro-maven-plugin.version}</version>
                <executions>
                    <execution>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>schema</goal>
                        </goals>
                        <configuration>
                            <sourceDirectory>${project.basedir}/src/main/resources/avro/</sourceDirectory>
                            <outputDirectory>${project.build.directory}/generated/avro</outputDirectory>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </pluginManagement>

If we execute the plugin, it will generate a class "User.java" in the package "example.avro" that will represent the object to receive to Kafka and that we can include in the "data" field of a `CloudEvent` event.

    λ mvn generate-sources

Next we finish the example by showing how to receive the `Avro` message via `CloudEvent`.

##### Non-reactive environments

Here is an example based on `KafkaListener` annotation:

    import generated.avro.User;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationAvroCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @KafkaListener(topics = "mytopic") (1)
        public void listen(@Payload CloudEvent event, (2)
                           @Headers MessageHeaders messageHeaders
                          ) {

            // Parsing the Cloud Event data to AVRO format
            AvroCloudEventData<User> data = (AvroCloudEventData<User>) event.getData(); (3)

            // Extract the pojo
            User user = data.getValue(); (4)
            log.info("User = '{}'", user);

            // Reading the message headers
            messageHeaders.keySet().forEach(key -> {
                Object value = messageHeaders.get(key);
                log.info("Message header {} : {}", key, value); (5)
            });
        }
    }

1. By means of the `@KafkaListener` annotation, we indicate that the `listen` method will process messages of the `mytopic` topic.

2. We indicate that the messages to be processed will be of type `CloudEvent`.

3. Cast the Cloud Event data to Avro Cloud Event data.

4. Extract the pojo from the Avro Cloud Event data

5. Additionally, we display the `Kafka Headers` by console.

##### Reactive environments

Here is an example based on `kafkaReceiver`:

    import io.cloudevents.CloudEvent;
    import org.apache.kafka.common.header.Headers;
    import org.springframework.context.annotation.Configuration;
    import reactor.kafka.receiver.KafkaReceiver;import reactor.kafka.receiver.ReceiverRecord;
    import java.nio.charset.StandardCharsets;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaReceiver<Long, CloudEvent> kafkaReceiver) { (2)
            return args -> {
                kafkaReceiver.receive()
                    .doOnNext((ReceiverRecord<Long, CloudEvent> record) -> {
                        // Read the Cloud Event from the record
                        CloudEvent event = record.value();

                        // Parsing the Cloud Event data to AVRO format
                        AvroCloudEventData<User> data = (AvroCloudEventData<User>) event.getData(); (3)

                        // Extract the pojo
                        User user = data.getValue(); (4)
                        log.info("User = '{}'", user);

                        // Reading the message headers
                        Headers headers = record.headers();
                        headers.forEach(header -> {
                            String value = new String(header.value(), StandardCharsets.UTF_8);
                            log.info("Message header {} : {}", header.key(), value); (5)
                        });
                    })
                    .subscribe(); (6)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            @Bean
            KafkaReceiver<Integer, CloudEvent> createReceiver(
                    ReactiveKafkaConsumerFactory kafkaConsumerFactory
            ) {
                Map<String, Object> propsReceiver = new HashMap<>();
                propsReceiver.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                ReceiverOptions<Integer, CloudEvent> optsReceiver =
                                        ReceiverOptions.create(propsReceiver);
                ReceiverOptions<Integer, CloudEvent> options =
                                        optsReceiver.subscription(Collections.singleton("mytopic"));
                return KafkaReceiver.create(kafkaConsumerFactory, options);
            }

        }
    }

1. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `KafkaReceiver` bean. This reactive consumer has been configured to consume messages from the `mytopic` topic.

3. Cast the Cloud Event data to Avro Cloud Event data.

4. Extract the pojo from the Avro Cloud Event data

5. Additionally, we display the `Kafka Headers` by console.

6. We subscribe the reactive stream generated from the KafkaReceiver to launch the execution.

This is the simplest example for event consumption making use of a reactive consumer. There will be times when it might be required, for example, after receiving a certain event from a topic, to make use of an HTTP client for invoking an external
service, being necessary to have the initialized contexts for the correct operation of the instrumentation.

In these cases, [Initializing reactive contexts from events](#initializing-reactive-contexts-from-events) that allow the creation of the reactive contexts and their initialization, obtaining the necessary values from the headers informed in the
events. The initialization of contexts in reactive environments always has to be done manually. For non-reactive environments, the creation of contexts occurs automatically.

### How to define a Custom events format

We must add the property:

    darwin:
        events:
            format: custom

By default, the events generated and consumed by kafka are of type string. However, this type is configurable as long as they implement the Serializable interface. Both the producer and the consumer can be customized through properties.

- Kafka Producer

<!-- -->

    spring:
        kafka:
            producer:
                key-serializer: org.apache.kafka.common.serialization.StringSerialize
                value-serializer: org.apache.kafka.common.serialization.IntegerSerializer

- kafka Consumer

<!-- -->

    spring:
        kafka:
            consumer:
                key-deserializer: org.apache.kafka.common.serialization.StringDeserialize
                value-deserializer: org.apache.kafka.common.serialization.IntegerDeserializer

To use the custom kafka producer, it would be injected a kafkaTemplate with its `<K, V>` corresponding to the one configured in the properties:

    @Component
    public class CustomKafkaClients {

        @Autowired
        KafkaTemplate<String, Integer> template;

        public void sendEvent(String topic, String key, Integer event) {
            template.send(topic, key, event);
        }
    }

Finally, we have the `@KafkaListener` annotation to add to a method that will process the messages sent to the defined topics:

    @slf4j
    public static class Listener {

        private Integer received;

        private MessageHeaders messageHeaders;

        private String key;

        @KafkaListener(topics = "TOPIC_SAMPLE")
        void listen(@Payload Integer event, @Headers MessageHeaders messageHeaders) {
            log.info("Event: " + event);
        }

    }

### How to transform CloudEvent into DarwinCloudEvent

The `CloudEvent` interface will give us access to all the attributes of the standard specification but to access Darwin's own attributes we will need to make use of the `DarwinCloudEvent` type, for example to retrieve the value of the entity,
channel, etc.

For this we have two alternatives, the first one is based on the `getExtension` method provided by the `CloudEvent` specification:

    CloudEvent event = ...; (1)
    String channel = event.getExtension(DarwinExtension.CHANNEL); (2)
    Integer entity = event.getExtension(DarwinExtension.ENTITY);
    (...)

1. We start from an event of type `CloudEvent` created from somewhere, either the application or retrieved from a topic.

2. Using the `getExtension` method and `DarwinExtension.XXX` constants we retrieve the `Darwin` eigenvalues.

The second one is based on the transformation of the event to an `POJO` of type `DarwinExtension`:

    CloudEvent event = ...; (1)
    DarwinExtension darwinExtension = ExtensionProvider.getInstance().parseExtension(DarwinExtension.class, event); (2)

    String channel = darwinExtension.getChannel(); (3)
    Integer entity = darwinExtension.getEntity();
    (...)

1. We start from an event of type `CloudEvent` created from somewhere, either the application or retrieved from a topic.

2. We transform the event from type `CloudEvent` to type `DarwinExtension`.

3. Using the methods provided by `DarwinExtension` we retrieve the `Darwin` own values.

!!! note

    The default settings set in the factory may be overwritten through the properties defined for the creation of the `SenderOptions` instance.

### How to create a reactive event consumer with Kafka Reactor

To consume messages stored in a Kafka topic using a reactive consumer you will make use of Reactor's *KafkaReceiver*. To create an instance of the *KafkaReceiver* that contains the configuration defined through the properties, it is necessary to
generate it from the `ReactiveKafkaConsumerFactory`. This factory contains the default properties set according to the defined configuration. For example, in case the event format is JSON type, the factory instance will have the CloudEvent message
deserialization components for JSON loaded. The `ReactiveKafkaConsumerFactory` instance will be exposed as a Spring `bean` and will need to be injected as a dependency.

    @Configuration(proxyBeanMethods = false)
    public class KafkaConfiguration {

        @Bean
        KafkaReceiver<Integer, CloudEvent> createReceiver(
                ReactiveKafkaConsumerFactory kafkaConsumerFactory) {
            Map<String, Object> propsReceiver = new HashMap<>();
            propsReceiver.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "https://kafkaHost:9093");

            // ...rest of the necessary configurations...

            ReceiverOptions<Integer, CloudEvent> optsReceiver =
                                            ReceiverOptions.create(propsReceiver);
            ReceiverOptions<Integer, CloudEvent> options =
                                            optsReceiver.subscription(Collections.singleton("topic"));
            return KafkaReceiver.create(kafkaConsumerFactory, options);
        }

    }

!!! note

    The default settings set in the factory can be overwritten through the properties defined for the creation of the `ReceiverOptions` instance.

### How to create a reactive event producer with Kafka Reactor

To publish messages in a Kafka topic using a reactive producer you will make use of Reactor's *KafkaSender*. To create an instance of the *KafkaSender* containing the configuration defined through the properties, it is necessary to generate it from
the `ReactiveKafkaProducerFactoryTest`. This factory contains the default properties set according to the defined configuration. For example, in case the event format is of type AVRO, the factory instance will have the CloudEvent message
serialization components of type AVRO loaded. The `ReactiveKafkaProducerFactoryTest` instance will be exposed as a Spring `bean` and will need to be injected as a dependency.

    @Configuration(proxyBeanMethods = false)
    public class KafkaConfiguration {

        @Bean
        KafkaSender<Integer, CloudEvent> createSender(
                ReactiveKafkaProducerFactory kafkaProducerFactory) {
            Map<String, Object> propsSender = new HashMap<>();
            propsSender.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "https://kafkaHost:9093");

            // ...rest of the necessary configurations...

            SenderOptions<Integer, CloudEvent> optsSender = SenderOptions.create(propsSender);
            return KafkaSender.create(kafkaProducerFactory, optsSender);
        }

    }

### How to create DarwinCloudEvents

#### Creating DarwinCloudEvent without contexts

If we do not have a `Darwin` or security context, we can create a `DarwinCloudEvent` object from the methods provided by the `Builder` itself.

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import java.net.URI;
    import java.time.OffsetDateTime;

    public class DarwinCloudEventGenerator {

        public CloudEvent getDarwinCloudEvent() {
            return DarwinCloudEvent.builder()
                                .withBaseCloudEvent(
                                       CloudEventBuilder.v1()
                                            .withId("id")
                                            .withSource(URI.create("http://localhost/source"))
                                            .withType("type")
                                            .withSubject("subject")
                                            .withDataSchema(URI.create("http://localhost/schema"))
                                            .withTime(OffsetDateTime.now())
                                            .withData("{}".getBytes())
                                            .build()
                                )
                                .withChannel("channel")
                                .withEntity(1234)
                                .withAcceptLanguage("es_ES")
                                .withSessionId("abcd")
                                .withAuthorization("fooToken")
                                .withOperationalControl("barToken")
                                .build();
            }
    }

#### Creating DarwinCloudEvent with contexts

If we have a `Darwin` or security context, we can create a `DarwinCloudEvent` object from them through the `Builder`.

##### How to retrieve contexts

In both reactive and non-reactive environments, contexts will be accessible:

###### Non-reactive environments

    import com.santander.darwin.core.context.DarwinContext;
    import com.santander.darwin.core.context.DarwinInfo;
    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import com.santander.darwin.common.context.DarwinContextHolder;
    import java.net.URI;
    import java.time.OffsetDateTime;
    import org.springframework.security.core.Authentication;
    import org.springframework.security.core.context.SecurityContextHolder;

    public class ClassicDarwinCloudEvent {

        public CloudEvent getDarwinCloudEvent() {
            DarwinInfo darwinInfo = DarwinContextHolder.getCurrentContext().getDarwinInfo();
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            return DarwinCloudEvent.builder()
                        .withBaseCloudEvent(
                            CloudEventBuilder.v1()
                                .withId("id")
                                .withSource(URI.create("http://localhost/source"))
                                .withType("type")
                                .withSubject("subject")
                                .withDataSchema(URI.create("http://localhost/schema"))
                                .withTime(OffsetDateTime.now())
                                .withData("{}".getBytes())
                                .build()
                            )
                            .withDarwinInfo(darwinInfo)
                            .withAuthentication(authentication)
                            .build();
        }
    }

###### Reactive environments

To facilitate access to the Darwin context and the security context in reactive environments, and to have both in the business logic, the
[ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html) class exposes two static methods that extract them,
one for reactive *streams* of type `Mono` (***getMonoContext()***) and another one for type `Flux` (***getFluxContext()***).
If at the time of retrieving the contexts, they have not been created, they will be initialized to empty and will have a
local scope to the function, and any modification made on them will not be available in the *downstream*.

In this example it is assumed that the contexts have already been created and are available in the reactive *downstream*:

###### Mono type reactive stream

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import com.santander.darwin.core.context.DarwinContext;
    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import org.springframework.security.core.context.SecurityContext;
    import reactor.core.publisher.Mono;

    import static reactor.function.TupleUtils.function;

    public class ReactiveDarwinCloudEvent {

        ReactiveContextUtil contextUtil;

        public ReactiveDarwinCloudEvent(ReactiveContextUtil contextUtil) {
            this.contextUtil = contextUtil;
        }

        public Mono<CloudEvent> getMonoDarwinCloudEvent() {
            return
                ReactiveContextUtil.getMonoContext() (1)
                    .map(function(
                        (DarwinContext darwinContext, SecurityContext securityContext) ->
                            DarwinCloudEvent.builder()
                                .withBaseCloudEvent(CloudEventBuilder.v1()
                                    .withId("id")
                                    .withSource(URI.create("http://localhost/source"))
                                    .withType("type")
                                    .withSubject("subject")
                                    .withDataSchema(URI.create("http://localhost/schema"))
                                    .withTime(OffsetDateTime.now())
                                    .withData("{}".getBytes())
                                    .build()
                                )
                                .withDarwinInfo(darwinContext.getDarwinInfo())
                                .withAuthentication(securityContext.getAuthentication())
                                .build()
                        )
                    );
        }

    }

1. Contexts are retrieved for a reactive ***stream*** of type `Mono`.

###### Flux type reactive stream

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import com.santander.darwin.core.context.DarwinContext;
    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import org.springframework.security.core.context.SecurityContext;
    import reactor.core.publisher.Mono;

    import static reactor.function.TupleUtils.function;

    public class ReactiveDarwinCloudEvent {

        ReactiveContextUtil contextUtil;

        public ReactiveDarwinCloudEvent(ReactiveContextUtil contextUtil) {
            this.contextUtil = contextUtil;
        }

        public Flux<CloudEvent> getFluxDarwinCloudEvent() {
            return
                ReactiveContextUtil.getFluxContext() (1)
                    .map(function(
                        (DarwinContext darwinContext, SecurityContext securityContext) ->
                            DarwinCloudEvent.builder()
                                .withBaseCloudEvent(CloudEventBuilder.v1()
                                    .withId("id")
                                    .withSource(URI.create("http://localhost/source"))
                                    .withType("type")
                                    .withSubject("subject")
                                    .withDataSchema(URI.create("http://localhost/schema"))
                                    .withTime(OffsetDateTime.now())
                                    .withData("{}".getBytes())
                                    .build()
                                )
                                .withDarwinInfo(darwinContext.getDarwinInfo())
                                .withAuthentication(securityContext.getAuthentication())
                                .build()
                        )
                    );
        }
    }

1. Contexts are retrieved for a ***stream*** reagent of type `Flux`.

##### Context creation

Depending on the environment we are in, contexts may or may not be filled in. If the above code is executed in a `Web` type application and within the context of a request, the contexts will be initialized with the information coming from the `Http`
request. Otherwise, (such as a `Non-Web` type application), we can always create them manually with the information we need.

###### Non-reactive environments

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.core.context.DarwinContext;
    import com.santander.darwin.core.context.DarwinContextHolder;
    import com.santander.darwin.core.context.DarwinInfo;
    import com.santander.darwin.events.DarwinCloudEvent;
    import java.net.URI;
    import java.time.OffsetDateTime;
    import org.springframework.security.core.context.SecurityContextHolder;

    public class ClassicDarwinCloudEvent {

        public CloudEvent getDarwinCloudEvent() {

            DarwinContext darwinContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .sessionId("abcd")
                                              .locale(Locale.forLanguageTag("es-ES"))
                                              .build();
            darwinContext.setDarwinInfo(darwinInfo);
            DarwinContextHolder.setCurrentContext(darwinContext);

            Token authToken = DefaultToken.builder.createJwt("valid.jwt.token").build();
            Token authorizationToken = AuthorizationToken.builder.creatJwt("valid.ocJwt.token").build();
            AuthenticationBearerToken authentication = new Authentication(authToken, null);
            SecurityContextHolder.getContext()
                .setAuthentication(authentication.mutateWithAuthorization(authorizationToken));

            return DarwinCloudEvent.builder()
                   .withBaseCloudEvent(
                       CloudEventBuilder.v1()
                            .withId("id")
                            .withSource(URI.create("http://localhost/source"))
                            .withType("type")
                            .withSubject("subject")
                            .withDataSchema(URI.create("http://localhost/schema"))
                            .withTime(OffsetDateTime.now())
                            .withData("{}".getBytes())
                            .build()
                      )
                   .withDarwinInfo(DarwinContextHolder.getCurrentContext().getDarwinInfo())
                   .withAuthentication(SecurityContextHolder.getContext().getAuthentication())
                   .build();
            }
    }

###### Reactive Environments

The [ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html)
class exposes two methods for the creation of reactive contexts.
These methods will be used through the ***contextWrite()***
operator of Reactor which allows the creation of contexts at the time the subscription is made.
This allows them to be available in the *upstream*.

##### How to create empty contexts

The first one allows the creation of empty contexts, i.e. they are initialized without values. This method makes sense to use if the contexts are going to be accessed and modified somewhere in the *upstream*. Once the values have been updated, they
will be available in the *downstream*. An example would be:

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import com.santander.darwin.core.context.DarwinContext;;
    import com.santander.darwin.core.context.DarwinInfo;
    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import org.springframework.security.core.context.SecurityContext;
    import com.santander.darwin.security.authentication.token.Token;
    import com.santander.darwin.security.authorization.domain.AuthorizationToken;
    import reactor.core.publisher.Mono;

    import static reactor.function.TupleUtils.function;

    public class ReactiveDarwinCloudEvent {

        ReactiveContextUtil contextUtil;

        public ReactiveDarwinCloudEvent(ReactiveContextUtil contextUtil) {
            this.contextUtil = contextUtil;
        }

        public Mono<CloudEvent> getDarwinCloudEvent() {

            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .sessionId("abcd")
                                              .locale(Locale.forLanguageTag("es-ES"))
                                              .build();

            List<GrantedAuthority> noAuthorities = AuthorityUtils.NO_AUTHORITIES;
            Token authToken = DefaultToken.builder().createBksOrJwtToken("foo").build();
            AuthenticationBearerToken authentication
                        = new AuthenticationBearerToken(authToken, authToken, noAuthorities);
            AuthorizationToken ocAuth = AuthorizationToken.builder().createJwt("ocToken").build();
            authentication = authentication.mutateWithAuthorization(ocAuth);

            return
                ReactiveContextUtil.getMonoContext()
                    .map(function(
                        (DarwinContext darwinContext, SecurityContext securityContext) -> {

                            // Updating Darwin Context
                            darwinContext.setDarwinInfo(darwinInfo);
                            // Updating Security Context
                            securityContext.setAuthentication(authentication);

                            return DarwinCloudEvent.builder()
                               .withBaseCloudEvent(CloudEventBuilder.v1()
                                    .withId("id")
                                    .withSource(URI.create("http://localhost/source"))
                                    .withType("type")
                                    .withSubject("subject")
                                    .withDataSchema(URI.create("http://localhost/schema"))
                                    .withTime(OffsetDateTime.now())
                                    .withData("{}".getBytes())
                                    .build()
                              )
                           .withDarwinInfo(darwinContext.getDarwinInfo())
                           .withAuthentication(securityContext.getAuthentication())
                           .build();
                        }
                    )).contextWrite(ReactiveContextUtil::create);
        }
    }

!!! info "Important"

    Reactive contexts must be initialized via the *contextWrite(…​)* operator and this must be used at the end of the reactive stream so that they are available in the *upstream* once the subscription is made. For more information
    on how to use the operator, see the API of [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-).

##### How to create contexts with initial values

The second one allows to create the contexts with a default value. The darwin context will be reported as an instance containing the desired values. For the security context only an `Authentication` object can be provided and initialized:

    import io.cloudevents.CloudEvent;
    import io.cloudevents.core.builder.CloudEventBuilder;
    import com.santander.darwin.events.DarwinCloudEvent;
    import com.santander.darwin.core.context.DarwinContext;
    import com.santander.darwin.core.context.DarwinInfo;
    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import org.springframework.security.core.context.SecurityContext;
    import com.santander.darwin.security.authentication.token.Token;
    import com.santander.darwin.security.authorization.domain.AuthorizationToken;
    import reactor.core.publisher.Mono;

    import static reactor.function.TupleUtils.function;

    public class ReactiveDarwinCloudEvent {

        ReactiveContextUtil contextUtil;

        public ReactiveDarwinCloudEvent(ReactiveContextUtil contextUtil) {
            this.contextUtil = contextUtil;
        }

        public Mono<CloudEvent> getDarwinCloudEvent() {

            DarwinContext dContext = DarwinContext.builder().build();
            DarwinInfo darwinInfo = DarwinInfo.builder()
                                              .channel("channel")
                                              .entity("1234")
                                              .sessionId("abcd")
                                              .locale(Locale.forLanguageTag("es-ES"))
                                              .build();
            dContext.setDarwinInfo(darwinInfo);

            List<GrantedAuthority> noAuthorities = AuthorityUtils.NO_AUTHORITIES;
            Token authToken = DefaultToken.builder().createBksOrJwtToken("foo").build();
            AuthenticationBearerToken authentication
                        = new AuthenticationBearerToken(authToken, authToken, noAuthorities);
            AuthorizationToken ocAuth = AuthorizationToken.builder().createJwt("ocToken").build();
            authentication = authentication.mutateWithAuthorization(ocAuth);

            return
                ReactiveContextUtil.getMonoContext()
                    .map(function(
                        (DarwinContext darwinContext, SecurityContext securityContext) ->
                            DarwinCloudEvent.builder()
                               .withBaseCloudEvent(CloudEventBuilder.v1()
                                    .withId("id")
                                    .withSource(URI.create("http://localhost/source"))
                                    .withType("type")
                                    .withSubject("subject")
                                    .withDataSchema(URI.create("http://localhost/schema"))
                                    .withTime(OffsetDateTime.now())
                                    .withData("{}".getBytes())
                                    .build()
                              )
                           .withDarwinInfo(darwinContext.getDarwinInfo())
                           .withAuthentication(securityContext.getAuthentication())
                           .build()
                    )).contextWrite(context ->
                            ReactiveContextUtil.create(context, dContext, authentication)
                    );
        }
    }

!!! note

    To simplify the creation of the reactive contexts, both the security context and the Darwin context, use is made of the
    [ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html) utility class. This allows to subscribe the Reactor
    context in a simple way and make it available to the reactive *upstream*.

!!! info "Important"

    Reactive contexts must be initialized via the *contextWrite(…​)* operator and this must be used at the end of the reactive stream so that they are available to the *upstream* once the subscription is made. For more information
    on how to use the operator, consult the API of [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-)

##### Initializing reactive contexts from events

To facilitate the initialization of the contexts from the information contained in the messages, the
[ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html) class exposes a method that is responsible for
populating the Darwin context and the security context from the headers reported in the events. The ***fillContext()*** method decomposes each of the messages and extracts the headers needed to populate each of the required fields. In case the
messages do not have the required information, the contexts will be initialized without any value (empty).

Here is an example of a consumer that receives messages of a certain topic and periodically invokes an external service. In order to make use of the instrumentation and propagate the HTTP headers, the contexts are populated with the data reported in
the event headers:

    import com.santander.darwin.core.config.CoreProperties;
    import com.santander.darwin.events.reactive.ReactiveContextUtil;
    import io.cloudevents.CloudEvent;
    import org.apache.kafka.common.header.Headers;
    import org.springframework.web.reactive.function.client.WebClient;
    import reactor.kafka.receiver.KafkaReceiver;
    import java.nio.charset.StandardCharsets;

    @Slf4j
    @SpringBootApplication
    public class KafkaApplicationCloudEvent {

        public static void main(String[] args) {
            new SpringApplicationBuilder(KafkaApplicationCloudEvent.class)
                    .web(WebApplicationType.NONE)
                    .run(args);
        }

        @Bean (1)
        public ApplicationRunner runner(KafkaReceiver<Long, CloudEvent> kafkaReceiver, (2)
                                        ReactiveContextUtil contextUtil, (3)
                                        WebClient.Builder webClientBuilder) {

            String hostPort = "http://localhost:" + 8080;
            WebClient webClient = webClientBuilder.baseUrl(hostPort).build(); (4)

            return args -> {
                kafkaReceiver.receive()
                    .transformDeferred(contextUtil::fillContext) (5)
                    .map(record -> {
                        CloudEvent event = record.value(); (6)
                        String message = new String(event.getData().toBytes(),
                                                            StandardCharsets.UTF_8);
                        log.info("Received message='{}'", message);
                        Headers headers = record.headers();
                        headers.forEach(header -> {
                            String value = new String(header.value(), StandardCharsets.UTF_8);
                            log.info("{}: {}", header.key(), value);
                        });
                        return event;
                    })
                    .flatMap(event -> {
                        String message = new String(event.getData().toBytes(),
                                                            StandardCharsets.UTF_8);
                        return webClient.post().uri("/send") (7)
                                .bodyValue(message)
                                .exchange()
                                .thenReturn(record);
                        }
                    )
                    .contextWrite(ReactiveContextUtil::create) (8)
                    .subscribe(); (9)
            };
        }

        @Configuration(proxyBeanMethods = false)
        static class KafkaConfiguration {

            @Bean
            KafkaReceiver<Integer, CloudEvent> createReceiver(
                    ReactiveKafkaConsumerFactory kafkaConsumerFactory
            ) {
                Map<String, Object> propsReceiver = new HashMap<>();
                propsReceiver.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "http://kafkaHost:9092");
                ReceiverOptions<Integer, CloudEvent> optsReceiver =
                                        ReceiverOptions.create(propsReceiver);
                ReceiverOptions<Integer, CloudEvent> options =
                                        optsReceiver.subscription(Collections.singleton("mytopic"));
                return KafkaReceiver.create(kafkaConsumerFactory, options);
            }

        }
    }

1. Since this is a `not web` application, we make use of a bean of type *ApplicationRunner* to execute the business logic.

2. We inject the `Bean KafkaReceiver` which provides the configuration.

3. We inject the `Bean ReactiveContextUtil` that provides the Darwin configuration. This allows easy creation and initialization of Darwin and Security reactive contexts.

4. The HTTP client is configured to perform invocations to an external service.

5. The ***fillContext*** method of the [ReactiveContextUtil](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/events/reactive/ReactiveContextUtil.html) class is used
    to initialize the context fields, extracting all the necessary information from the messages and their headers.

6. The CloudEvent object is extracted from the received event and mapped to the reactive stream.

7. A request is made to an external service. Since the contexts exist and are populated with the values extracted from the incoming event headers, the client instrumentation can propagate that information as HTTP headers.

8. We subscribe to the Reactor context for the generation of the DarwinContext and the SecurityContext. This creation should always be done manually to ensure that these will be available for initialization in the *upstream*.

9. We subscribe the reactive stream generated from the KafkaReceiver to launch the execution.

!!! note

    The `fillContext(…​)` method processes the reactive *stream* to read the messages and add the necessary information to the context. Once this process is finished, it returns the same *stream* it received, unmodified. To add
    this processing to the *stream*, we will rely on Reactor's `transformDeferred()` operator. For more information on its use, consult the API of
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#transformDeferred-java.util.function.Function-) or
    [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#transformDeferred-java.util.function.Function-), depending on the applicable case.

!!! info "Important"

    The reactive contexts must be initialized by means of the *contextWrite()* operator and this must be used at the end of the reactive stream so that they are available in the *upstream* once the subscription is made. For more
    information on how to use the operator, refer to the [Mono](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html#contextWrite-java.util.function.Function-) and
    [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#contextWrite-java.util.function.Function-) API.

### How to connect to Kafka using Kerberos

If you need to connect to Kafka using Kerberos please refer to the
[Kafka security guide](https://github.com/santander-group-shared-assets/gln-back-darwin-java-samples/tree/develop/kafka/security)
