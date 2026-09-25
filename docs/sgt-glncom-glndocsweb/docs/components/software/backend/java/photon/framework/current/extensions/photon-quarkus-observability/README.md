# Photon Quarkus Observability

Photon Quarkus Observability is an extension created to meet Gluon observability requirements.
The purpose of the extension is to add traceability to logs and propagate it along requests' lifecycle.
It offers different configurations to meet different logging needs like json/non-json logging, sending
logs to kafka topics and to console, and w3c and b3 modes.
For more details about Gluon observability, check [Gluon Observability Documentation](../../../../../../../../../application/observability-insights/observability/obs-foundations/logs/gluonlog-v100/index.md).

## How to use

### Import extension dependency

``` { .xml .copy }
<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-observability</artifactId>
</dependency>
```

### Log configuration

According to Gluon Observability requirements, logs should be sent to kafka topic in json format or consumed by
an agent from the console. It's possible to use this extension to configure logging to kafka topic and enable
logging on console at the same time. In addition it's possible to configure the extension to generate technical logs
in non json format (human readable format).

| parameter                    | default | description           |
|------------------------------|---------|-----------------------|
| photon.logging.json-log-mode | true    | generate technical log in json  |
| photon.logging.kafka.console-enabled | false | show technical log in json format in console |
| photon.logging.kafka.enabled | true    | generate and send log to kafka |
| photon.logging.kafka.servers | - | kafka server address |
| photon.logging.kafka.topic | -  | default topic when multitopic is disabled or not set for all log types |
| photon.logging.kafka.multi-topic.enabled | false | multitopic mode  |
| photon.logging.kafka.multi-topic.activity-topic | - | activity log topic  |
| photon.logging.kafka.multi-topic.functional-topic | - | functional log topic  |
| photon.logging.kafka.multi-topic.technical-topic | - | technical log topic  |
| photon.logging.kafka.multi-topic.security-topic | - | security log topic  |
| photon.logging.kafka.properties | - | additional kafka properties map  |
| photon.logging.kafka.keystore.location | - | keystore location  |
| photon.logging.kafka.keystore.password | - | keystore password |
| photon.logging.kafka.truststore.location | - | truststore location  |
| photon.logging.kafka.truststore.password | - | truststore password  |
| photon.logging.kafka.properties.security.protocol          | SSL     | Security protocol communications                            |
| photon.logging.kafka.properties.sasl.kerberos.service.name | -       | Kerberos Service name                                       |
| photon.logging.kafka.properties.sasl.mechanism             | -       | SASL Authentication mechanism                               |
| photon.logging.kafka.properties.sasl.jaas.config           | -       | Java Authentication and Authorization service configuration |
| quarkus.otel.propagators | tracecontext,baggage |  propagator, can be (single or multiple): b3, b3multi, tracecontext, baggage |

Example configuration:

``` { .txt .copy }
photon.logging.kafka.servers=localhost:9092
photon.logging.kafka.topic=log
photon.logging.kafka.enabled=true
photon.logging.json-log-mode=true
photon.logging.kafka.console-enabled=true

# configure specific log type topics
photon.logging.kafka.multi-topic.activity-topic=activity
photon.logging.kafka.multi-topic.security-topic=security

# configure kerberos
photon.logging.kafka.properties.security.protocol=SASL_SSL
photon.logging.kafka.properties.sasl.kerberos.service.name=kafka

# kafka plain
photon.logging.kafka.properties.sasl.mechanism=PLAIN
photon.logging.kafka.properties.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="XXXX" password="YYYY";

# kafka gssapi
photon.logging.kafka.properties.sasl.mechanism=GSSAPI
photon.logging.kafka.properties.sasl.jaas.config=com.sun.security.auth.module.Krb5LoginModule required useKeyTab=true doNotPrompt=true renewTicket=true storeKey=true serviceName=kafka keyTab="src/main/resources/kafka/user_dev.keytab" principal="USER@REALM" useTicketCache=false client=true;
```

!!! note

    It's necessary to add the JVM argument: -Djava.security.krb5.conf=path-to-conf/krb5.conf when using gssapi

### Log types

As stated in Gluon Observability documentation, there are four types of logs: activity, security,
functional and technical.

#### Activity log

Activity log will be generated automatically when the microservice receive a HTTP request.

#### Security log

Security log will be generated automatically when Quarkus security is used and there is an
authentication/authorization flow. The security logs show the result of the authentication/authorization process.

#### Functional log

Functional log is used to trace the input and output of the interactions to consume this business data and to tap into it.
It can be generated by using *com.santander.photon.observability.logger.FunctionalLogger* interface.
It exposes a **log** method that receive *com.santander.photon.observability.model.BusinessLog* as argument and
generate a functional log.

Example usage:

``` { .java .copy }
public class PhotonResource implements PhotonApi {

    @Inject
    FunctionalLogger functionalLogger;

    public Response getSingle(Integer id) {
        BusinessLog businessLog = BusinessLog
                                    .builder()
                                    .input("input").output("\"output\"").customField(Map.of("key", "value"))
                                    .build();
        functionalLogger.log(businessLog);
    }
}
```

!!! note

    output field should be contained between quotes when the value is plain text to generate a valid json.
    Ex: "\"value\""

#### Technical log

Technical log is used to trace application behaviour that is not business related.
It can be generated by using *com.santander.photon.observability.logger.TechnicalLogger* interface, which
offers a **log** method that receives **message** and **log level** arguments, and also
**info**, **warn**, **debug**, **trace** and **error** methods that receive a **message** argument.

Example usage:

``` { .java .copy }
public class PhotonResource implements PhotonApi {

    @Inject
    TechnicalLogger technicalLogger;

    public Response getSingle(Integer id) {
        technicalLogger.log("technical log to check something", TechnicalLogger.LogLevel.ERROR);

        technicalLogger.info("info log to check something");

        technicalLogger.warn("warn log to check something");
    }
}
```
