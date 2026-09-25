# Spring Cloud Stream Configuration

## Binder Abstraction

Spring Cloud Stream provides Binder implementations for some brokers like Kafka and Rabbit MQ. The Binder
Abstraction makes the Spring Cloud Stream application flexible in how it connects to middleware by changing
the configuration.

```java
spring.cloud.stream:
  function:
    definition: processor
  source: processor
  defaultBinder: kafka1
  binders:
    kafka1:
      type: kafka
      environment:
        spring:
          kafka:
            bootstrap-servers: localhost:9092
  instanceCount: 1
  instanceIndex: 0
  bindingRetryInterval: 0
```

To configure input/output channels:

```java
spring.cloud.stream:
  function:
    definition: processor
  source: processor
```

## Publish

Components created from the configuration will be accessed by the arsenal application through the
StreamBridge class, which helps to connect external system that is not a binder to spring cloud
stream, and will be used to send messages to brokers. For more details, check this [link](https://docs.spring.io/spring-cloud-stream/docs/3.2.4/reference/html/spring-cloud-stream.html#_sending_arbitrary_data_to_an_output_e_g_foreign_event_driven_sources).

The parameter **bindingName** of StreamBridge's **send** method is the value of the property
**spring.cloud.stream.function.definition** (in this case, *processor*) with the suffix **"-in-0"**.

```java
@Autowired private StreamBridge streamBridge;

private void send(CardMessageDTO messageDTO) {
    LOGGER.info("Event publish: {}", messageDTO);

    Message<CardMessageDTO> message =
        MessageBuilder.withPayload(messageDTO)
            .setHeaderIfAbsent(
                CardEventDescriptor.EVENTO_ID, CardEventDescriptor.PROCESS_EVENT.getDescricao())
            .build();

    streamBridge.send("processor-in-0", message);
}
```

## Subscribe

Components created based on interface Consumer will be used to message processing, the name of
the bean (in this case, *processor*) is the value of the properties **spring.cloud.stream.function.definition** and **spring.cloud.stream.source**.

```java
@Configuration
public class CardSubscribeListener {

  private static final Logger LOGGER = LoggerFactory.getLogger(CardSubscribeListener.class);

  @Inject private CardProcessEventService processEventService;

  @Bean
  public Consumer<Message<CardMessageDTO>> processor() {
    return msg -> {
      final CardMessageDTO messageDTO = msg.getPayload();

      LOGGER.info("1 - partition {} received.", msg);

      try {
        processEventService.process(messageDTO.getOtherInfo(), messageDTO.getPartition());
      } catch (Throwable th) {
        LOGGER.error("1.e - partition {} error: " + th.getMessage(), msg.getPayload());
        throw th;
      }
    };
  }
}
```

## References

[Spring Cloud Stream Main Concepts](https://docs.spring.io/spring-cloud-stream/docs/3.2.4/reference/html/spring-cloud-stream.html#_main_concepts)
