# Observability

Observability lets us understand a system from the outside, by letting us ask
questions about that system without knowing its inner workings. Furthermore, it
allows us to easily troubleshoot and handle novel problems (i.e. “unknown
unknowns”), and helps us answer the question, “Why is this happening?”

In order to be able to ask those questions of a system, the application must be
properly instrumented. That is, the application code must emit signals such as
traces, metrics, and **logs**. An application is properly instrumented when
developers don’t need to add more instrumentation to troubleshoot an issue,
because they have all of the information they need.

## Log and Telemetry

**Telemetry** refers to data emitted from a system, about its behavior. The data
can come in the form of traces, metrics, and logs.

We can define a telemetry as an ability to measure something. And measuring
something on distributed systems is more difficult than on monolithic systems.

In order to have useful and reliable measurements in this type of ecosystem, we
need an observability framework capable of generating, collecting and exporting
data for analysis and measurement of software performance and behavior.

A **log** is a timestamped message emitted by services or other components.
Unlike traces, however, they are not necessarily associated with any particular
user request or transaction. They are found almost everywhere in software, and
have been heavily relied on in the past by both developers and operators alike
to help them understand system behavior.

    I, [2021-02-23T13:26:23.505892 #22473]  INFO -- : [6459ffe1-ea53-4044-aaa3-bf902868f730] Started GET "/" for ::1 at 2021-02-23 13:26:23 -0800

## Java library for log ingestion

The log ingestion library is built with the following technologies:

1. Java 17
2. Maven
3. Spring
4. Micrometer
5. Logback
6. AspectJ
7. Lombok
8. Jackson
9. Junit
10. Mockito

## Prerequisites

* Java 17
* Maven 3.9.x
* App Arsenal Integration 3.x.x

## Dependency

Declare dependency in pom.xml file:

``` { .xml .copy }
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-global-observability-starter</artifactId>
</dependency>
```

## Configuring App

### Configure application properties

* development mode: show logs in logback layout instead of in json

``` { .yaml .copy }
arsenal:
    logging:
        dev-mode: true
```

* console mode: show logs in the console without sending to kafka.

``` { .yaml .copy }
arsenal:
    logging:
        console-log: true
```

* kafka upload mode without mTLS configuration

``` { .yaml .copy }
arsenal:
    logging:
        console-log: false
        kafka:
            servers: localhost:9092
            topic: logs
```

* kafka upload mode with mTLS configuration

``` { .yaml .copy }
arsenal:
    logging:
        console-log: false
        kafka:
            servers: localhost:9092
            topic: logs
            keystore:
                location: /tmp/keystore
                password: xpto
            truststore:
                location: /tmp/truststore
                password: xpto
```

If **isGluon** property is **true**:

``` { .yaml .copy }
isGluon: true
```

Then it's necessary to set the following component properties:

``` { .yaml .copy }
company: lorem # Santander company whose component is generating the logs.
componentName: lorem # Name of the component that generates the log.
componentId: lorem # Identifier of the component that generates the log.
componentType: lorem # The type of the Gluon component (e.g., microservice, API...)
appName: lorem # The technical application name
appId: lorem # Identifier of the application of the component that generates the log.
```

### Unit tests

To be able to execute unit tests, the annotation `@AutoConfigureObservability`
is needed at the class level of all test classes.

``` { .java .copy }
import org.springframework.boot.test.autoconfigure.actuate.observability.AutoConfigureObservability;

@AutoConfigureObservability
public class ApplicationTest {}
```

## Logs

### Activity Log

Activity logs are automatically generated for Servlet and WebClient
requests/responses, and for Altair and Event sending/receiving.

Examples:

* Servlet

``` {.json .copy title="request"}
{
    "timestamp": "2023-06-19T17:37:14,531Z",
    "company": "company",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "",
    "logLevel": "INFO",
    "log": "SERVER - Filter - Request ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "880a46589d2b754e",
    "parentSpanId": "e457b5a2e4d86bd1",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {
        "threadName": "http-nio-8080-exec-2"
    },
    "inputTimeStamp": "2023-06-19T17:37:14.525Z",
    "method": "POST",
    "url": "/api/v1/apparsenal",
    "returnCode": "",
    "logType": "activity"
}
```

``` {.json .copy title="response"}
{
    "timestamp": "2023-06-19T17:37:14,863Z",
    "company": "company",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "",
    "logLevel": "INFO",
    "log": "SERVER - Filter- Response ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "880a46589d2b754e",
    "parentSpanId": "e457b5a2e4d86bd1",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {
        "threadName": "http-nio-8080-exec-2"
    },
    "inputTimeStamp": "2023-06-19T17:37:14.525Z",
    "method": "POST",
    "url": "/api/v1/apparsenal",
    "returnCode": "200",
    "logType": "activity"
}
```

* WebClient

``` {.json .copy title="request"}
{
    "timestamp":"2023-06-19T18:35:06,709Z",
    "company":"",
    "componentName":"gln-back-arsenal-global-observability-starter",
    "componentId":"arsenal-observability-id",
    "componentType":"arsenal-lib",
    "appName":"AppArsenal Microservice",
    "appId":"",
    "environment":"",
    "logLevel":"INFO",
    "log":"WebClient - Request ",
    "error":"false",
    "traceId":"80f198ee56343ba864fe8b2a57d3ef15",
    "spanId":"2b82af8bc9883a74",
    "parentSpanId":"e457b5a2e4d86bd1",
    "trace_id":"0af7651916cd43dd8448eb211c80319c",
    "span_id":"",
    "parent_id":"b7ad6b7169203331",
    "tracestate":"congo=t61rcWkgMzE",
    "isGluon":"true",
    "customLog":{
        "customLog":"http-nio-8082-exec-4"
    },
    "inputTimeStamp":"2023-06-19T18:35:06.656Z",
    "method":"POST",
    "url":"http://localhost:8080/api/v1/apparsenal",
    "returnCode":"",
    "logType":"activity"
}
```

``` {.json .copy title="response"}
{
    "timestamp":"2023-06-19T18:35:07,137Z",
    "company":"",
    "componentName":"gln-back-arsenal-global-observability-starter",
    "componentId":"arsenal-observability-id",
    "componentType":"arsenal-lib",
    "appName":"AppArsenal Microservice",
    "appId":"",
    "environment":"",
    "logLevel":"INFO",
    "log":"WebClient - Response ",
    "error":"false",
    "traceId":"80f198ee56343ba864fe8b2a57d3ef15",
    "spanId":"2b82af8bc9883a74",
    "parentSpanId":"5e5523f005dd72bf",
    "trace_id":"0af7651916cd43dd8448eb211c80319c",
    "span_id":"",
    "parent_id":"b7ad6b7169203331",
    "tracestate":"congo=t61rcWkgMzE",
    "isGluon":"true",
    "customLog":{
        "customLog":"http-nio-8082-exec-4"
    },
    "inputTimeStamp":"2023-06-19T18:35:06.656Z",
    "method":"POST",
    "url":"http://localhost:8080/api/v1/apparsenal",
    "returnCode":"201",
    "logType":"activity"
}
```

* Altair

``` {.json .copy title="request"}
{
    "timestamp": "2023-06-19T17:39:13,638Z",
    "company": "company",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "",
    "logLevel": "INFO",
    "log": "EmbeddedMainframe -  Configuring call ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3eff8",
    "spanId": "1ef95481653f94ea",
    "parentSpanId": "2dcb21dc08c04428",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {
        "psFormat": "PS7",
        "transaction": "PEC9",
        "requestObject": "PEM9210",
        "request-queue": "AEA.QR.REQUEST.M3.PSX",
        "response-queue": "AEA.QL.ANSWER.M3.PSX"
    },
    "inputTimeStamp": "2023-06-19T17:39:13.635Z",
    "method": "SEND",
    "url": "",
    "returnCode": "",
    "logType": "activity"
}
```

``` {.json .copy title="response"}
{
    "timestamp": "2023-06-19T17:39:14,777Z",
    "company": "company",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "",
    "logLevel": "INFO",
    "log": "EmbeddedMainframe -  Response receive ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3eff8",
    "spanId": "61967dbaed6c0b32",
    "parentSpanId": "1ef95481653f94ea",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {
        "psFormat": "PS7",
        "transaction": "PEC9",
        "responseObject": "PEM9250;PEM9250;PEM9210;"
    },
    "inputTimeStamp": "2023-06-19T17:39:14.776Z",
    "method": "RECEIVE",
    "url": "",
    "returnCode": "@1",
    "logType": "activity"
}
```

* Event

``` {.json .copy title="sending"}
{
    "timestamp":"2023-06-19T18:43:07,971Z",
    "company":"",
    "componentName":"gln-back-arsenal-global-observability-starter",
    "componentId":"arsenal-observability-id",
    "componentType":"arsenal-lib",
    "appName":"AppArsenal Microservice",
    "appId":"",
    "environment":"",
    "logLevel":"INFO",
    "log":"Message sent to broker ",
    "error":"false",
    "traceId":"80f198ee56343ba864fe8b2a57d3ef15",
    "spanId":"556a5a68c7ccbb2e",
    "parentSpanId":"7004766c73ed4d59",
    "trace_id":"0af7651916cd43dd8448eb211c80319c",
    "span_id":"",
    "parent_id":"b7ad6b7169203331",
    "tracestate":"congo=t61rcWkgMzE",
    "isGluon":"true",
    "customLog":"",
    "inputTimeStamp":"",
    "method":"",
    "url":"",
    "returnCode":"",
    "logType":"activity"
}
```

``` {.json .copy title="receiving"}
{
    "timestamp":"2023-06-19T18:43:07,966Z",
    "company":"",
    "componentName":"gln-back-arsenal-global-observability-starter",
    "componentId":"arsenal-observability-id",
    "componentType":"arsenal-lib",
    "appName":"AppArsenal Microservice",
    "appId":"",
    "environment":"",
    "logLevel":"INFO",
    "log":"Message processed from broker ",
    "error":"false",
    "traceId":"80f198ee56343ba864fe8b2a57d3ef15",
    "spanId":"11e498fd5e6ff3f8",
    "parentSpanId":"5947b186c4817dba",
    "trace_id":"0af7651916cd43dd8448eb211c80319c",
    "span_id":"",
    "parent_id":"b7ad6b7169203331",
    "tracestate":"congo=t61rcWkgMzE",
    "isGluon":"true",
    "customLog":"",
    "inputTimeStamp":"",
    "method":"",
    "url":"",
    "returnCode":"",
    "logType":"activity"
}
```

### Technical Log

Technical log is automatically generated when an *error* occurs in the
application.

Example:

``` {.json .copy }
{
    "timestamp": "2023-06-19T17:25:33,259Z",
    "company": "company",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "",
    "logLevel": "ERROR",
    "log": "Runtime Error ",
    "error": "true",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "230fe10f9bb6a682",
    "parentSpanId": "e457b5a2e4d86bd1",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": "",
    "logType": "technical"
}
```

#### Technical Log Info

This is doing manually and must follow a few steps describe below.

##### Requirements

1. Instance of LogService. There is already a bean loaded with a LogServiceImpl
   instance that is automatic configured with the observability starter;

    ``` {.java .copy }
    @Autowired
    private LogService logService;
    ```

2. Object com.santander.ars.log.model.TechnicalLog with log attribute filled;

    ``` {.java .copy }
    TechnicalLog tech = new TechnicalLog();
    tech.setLog(String.format("Successfully updated AppArsenal with ID %s", id));
    ```

3. Call the method sendTechnicalLog from LogService with a TechnicalLog object
   as parameter.

    ``` {.java .copy }
    logService.sendTechnicalLog(tech);
    ```

### Functional Log

It depends on the functional requirements. This type of log is highly dependent
on the use case. For example, a requirement might be "generate a log event every
time a payment is received, including the following data(...)".

To send the Functional Log, we must use the Service Log, which will be
responsible for this demand.

``` {.java .copy }
@Autowired
private LogService logService;
```

To use Functional Log, is necessary create a FunctionalLog and a BusinessLog.

Inside the Business, to set up the input, output and the custom, set the
BusinessLog inside the Functional and send in sendFunctionalLog for the
LogService, for example:

``` {.java .copy }
FunctionalLog functionalLog = new FunctionalLog();
functionalLog.setLog("Log example");
BusinessLog businessLog = new BusinessLog();
businessLog.setInput("input");
businessLog.setOutput("output");
businessLog.setCustomField(Map.of("key","value"));
functionalLog.setBusinessLog(businessLog);
logService.sendFunctionalLog(functionalLog);
```

Example of log generated by this code above:

``` {.json .copy }
{
"timestamp": "2023-06-19T13:30:27,686Z",
"company": "BRA",
"componentName": "gln-back-arsenal-global-observability-starter",
"componentId": "arsenal-observability-id",
"componentType": "arsenal-lib",
"appName": "AppArsenal Microservice",
"appId": "123",
"environment": "PRO",
"logLevel": "INFO",
"log": "Log example ",
"error": "false",
"traceId": "80f198ee56343ba864fe8b2a57d3ef15",
"spanId": "3e2f3af3f5ce2513",
"parentSpanId": "e457b5a2e4d86bd1",
"trace_id": "0af7651916cd43dd8448eb211c80319c",
"span_id": "98ad007a4ecOcOffc52cf6c",
"parent_id": "b7ad6b7169203331",
"tracestate": "congo=t61rcWkgMzE",
"isGluon": "true",
    "customLog" : {
        "customLog.attribute1":"value1",
        "customLog.attribute2":"value2",
        "customLog.attribute3":"value3"
    },
"logType": "functional",
"businessLog": {
    "input": {
        "value": "input"
    },
    "output": {
        "value": "output"
    },
    "key": "value"
}
}
```

### Security Log

Security logs are generated automatically for authentication and authorization
processes.

Examples:

* authentication/authorization error

``` {.json .copy }
{
    "timestamp": "2023-06-19T15:03:50,900Z",
    "company": "company-name",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "dev",
    "logLevel": "INFO",
    "log": " ",
    "error": "true",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "74d69f210b6405aa",
    "parentSpanId": "8b2cb63ee85fb452",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {},
    "logType": "security",
    "securityAttributes": {
        "failureType": "InvalidBearerTokenException",
        "authenticationRequestType": "BearerTokenAuthenticationToken",
        "resultType": "n/a"
    },
    "result": {
        "resultCode": "NOK"
    }
}
```

* authenticated

``` {.json .copy }
{
    "timestamp": "2023-06-19T15:08:29,079Z",
    "company": "company-name",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "dev",
    "logLevel": "INFO",
    "log": " ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "6172686722217103",
    "parentSpanId": "c726d1a5debfcce3",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {},
    "logType": "security",
    "securityAttributes": {
        "failureType": "n/a",
        "authenticationRequestType": "BearerTokenAuthenticationToken",
        "resultType": "JwtAuthenticationToken"
    },
    "result": {
        "resultCode": "OK"
    }
}
```

* authorized

``` {.json .copy }
{
    "timestamp": "2023-06-19T15:08:29,091Z",
    "company": "company-name",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "AppArsenal Microservice",
    "appId": "",
    "environment": "dev",
    "logLevel": "INFO",
    "log": " ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef30",
    "spanId": "6172686722217103",
    "parentSpanId": "c726d1a5debfcce3",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": {},
    "logType": "security",
    "securityAttributes": {
        "authorizationResult": "true",
        "authenticationType": "JwtAuthenticationToken"
    },
    "result": {
        "resultCode": "OK"
    }
}
```

### Annotations

#### Using @UpdateHeader in Arsenal Backend Application

The @UpdateHeader annotation can be used in a Arsenal Spring application to
dynamically update headers. Note that @UpdateHeader works only in conjunction
with the @Observed annotation from Micrometer. This is because @Observed enables
the observation of method execution, which is necessary for the dynamic values
of @UpdateHeader to be processed correctly.

#### Using @UpdateHeader

To use the @UpdateHeader annotation in conjunction with the @Observed
annotation, follow these steps:

* Annotate the Method: Use the @UpdateHeader and @Observed annotations on the
  method that requires observation.

Example

``` {.java .copy }
import com.santander.ars.annotation.UpdateHeader;
import io.micrometer.observation.annotation.Observed;
import org.springframework.stereotype.Service;

@Service
public class ExampleService {

    @UpdateHeader(businessId = UpdateHeaderAction.CREATE, sessionId = UpdateHeaderAction.CREATE)
    @Observed(name = "example.observed.method")
    public void observedMethod() {
        // Method implementation
    }
}
```

#### Usage of Each Type of UpdateHeaderAction

##### CREATE

* ***Description:*** Generates a new ID in UUID format.
* ***Usage:*** Use this type when it is necessary to create a new unique
  identifier for the header, ensuring that each request or session has a
  distinct ID.

##### SUPPRESS

* ***Description:*** Suppresses the value of the header.
* ***Usage:*** Use this type when it is necessary to remove or ignore the header
  value, preventing it from being propagated or used.

##### NONE

* ***Description:*** Does not perform any action.
* ***Usage:*** This is the default value and should be used when no modification
  to the header is desired.

> Note: To ensure that the @UpdateHeader annotation works correctly in unit tests,
> you should include a @MockBean for the relevant component. Here is an example:

``` {.java .copy}
@SpringBootTest(
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
            classes = {ArsenalApplication.class})
public class ServiceMockTest {

  @MockBean private CustomHeaderInfoBean customHeaderInfoBean;
  @Autowired private AppArsenalService appArsenalService;

  @Test
  void testCreateService() {
    // implementations ...
    Mockito.when(customHeaderInfoBean.getCustomHeaderInfo()).thenReturn(CustomHeaderInfo.builder().build());
    // implementations ...

}
```
