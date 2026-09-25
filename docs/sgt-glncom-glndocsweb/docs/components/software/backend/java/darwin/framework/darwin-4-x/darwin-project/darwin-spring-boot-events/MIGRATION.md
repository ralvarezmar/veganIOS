# Darwin-spring-boot-events Migration guides

## Version 3.1.0-RELEASE

<!tag:310>

- In this release we have included the "***specific.avro.reader***" property in the Kafka consumers with **true** value (default false). If you need to disable this feature, you can configure this property from properties file under:
    ***spring.kafka.consumer.properties***.

<!end:310>
