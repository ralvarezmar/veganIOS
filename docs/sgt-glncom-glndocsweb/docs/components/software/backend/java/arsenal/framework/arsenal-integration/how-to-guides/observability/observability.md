# Observability

All requests received by microservice are supposed to have B3 and W3C headers
below:

## B3 headers

* X-B3-TraceId
* X-B3-SpanId
* X-B3-ParentSpanId
* X-B3-Sampled

## W3C headers

* traceparent
* tracestate

Check [Observability
Documentation](../../../../../../../../../application/observability-insights/observability/obs-foundations/tracing/index.md)
for more details.

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
* Maven
* App Arsenal Integration

## Dependency

Declare dependency in pom.xml file:

```{ .xml .copy }
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-observability-starter</artifactId>
</dependency>
```

Micrometer framework was used for tracing and observability. The
micrometer-tracing-bom dependency (at least version 1.1.1) need to be included
in the pom before all other dependency managaments to avoid bugs from previous
tracing libraries versions.

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

``` { .java .copy }
company: lorem # Santander company whose component is generating the logs.
componentName: lorem # Name of the component that generates the log.
componentId: lorem # Identifier of the component that generates the log.
componentType: lorem # The type of the Gluon component (e.g., microservice, API...)
appName: lorem # The technical application name
appId: lorem # Identifier of the application of the component that generates the log.
```

### Unit tests

To be able to execute unit tests, the annotation @AutoConfigureObservability is
needed at the class level of all test classes.

``` { .java .copy }
import org.springframework.boot.test.autoconfigure.actuate.observability.AutoConfigureObservability;

@AutoConfigureObservability
public class ApplicationTest {}
```

## Logs

### Activity Log

Activity logs are automatically generated for servlet and camel
requests/responses, and for altair sending/receiving. Examples:

* Servlet

    ``` {.json .copy title="request"}
    {
        "timestamp": "2023-06-19T18:45:54,541Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "SERVER - Filter - Request ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "d4621a66df8b4050",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": {
            "threadName": "http-nio-8080-exec-2"
        },
        "inputTimeStamp": "2023-06-19T18:45:54.534Z",
        "method": "GET",
        "url": "/party/v1/parties/123",
        "returnCode": "",
        "logType": "activity"
    }
    ```

    ``` {.json .copy title="response"}
    {
        "timestamp": "2023-06-19T18:45:54,702Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "SERVER - Filter- Response ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "d4621a66df8b4050",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": {
            "threadName": "http-nio-8080-exec-2"
        },
        "inputTimeStamp": "2023-06-19T18:45:54.534Z",
        "method": "GET",
        "url": "/party/v1/parties/123",
        "returnCode": "200",
        "logType": "activity"
    }
    ```

* Camel

    ``` {.json .copy title="request"}
    {
        "timestamp": "2023-06-19T18:45:54,584Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "Camel Http Request ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "d4621a66df8b4050",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": "",
        "inputTimeStamp": "2023-06-19T18:45:54.584Z",
        "method": "GET",
        "url": "/parties/123",
        "returnCode": "",
        "logType": "activity"
    }
    ```

    ``` {.json .copy title="response"}
    {
        "timestamp": "2023-06-19T18:45:54,690Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "Camel Http Response ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "d4621a66df8b4050",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": "",
        "inputTimeStamp": "2023-06-19T18:45:54.689Z",
        "method": "GET",
        "url": "/parties/123",
        "returnCode": "200",
        "logType": "activity"
    }
    ```

* Altair

    ``` {.json .copy title="request"}
    {
        "timestamp": "2023-06-19T19:38:05,364Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "Altair Send Activity ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "002a28466bfbe263",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": {
            "appname": "BHS",
            "transaction": "PE47",
            "psFormat": "PsFormatEnum.PS7"
        },
        "inputTimeStamp": "2023-06-19T19:38:05.359Z",
        "method": "SEND",
        "url": "",
        "returnCode": "",
        "logType": "activity"
    }
    ```

    ``` {.json .copy title="response"}
    {
        "timestamp": "2023-06-19T19:38:06,563Z",
        "company": "",
        "componentName": "gln-back-arsenal-global-observability-starter",
        "componentId": "arsenal-observability-id",
        "componentType": "arsenal-lib",
        "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
        "appId": "",
        "environment": "",
        "logLevel": "INFO",
        "log": "Altair Receive Activity ",
        "error": "false",
        "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
        "spanId": "002a28466bfbe263",
        "parentSpanId": "e457b5a2e4d86bd1",
        "trace_id": "0af7651916cd43dd8448eb211c80319c",
        "span_id": "",
        "parent_id": "b7ad6b7169203331",
        "tracestate": "congo=t61rcWkgMzE",
        "isGluon": "true",
        "customLog": {
            "appname": "BHS",
            "transaction": "PE47",
            "psFormat": "PsFormatEnum.PS7"
        },
        "inputTimeStamp": "2023-06-19T19:38:06.563Z",
        "method": "RECEIVE",
        "url": "",
        "returnCode": "@1",
        "logType": "activity"
    }
    ```

### Technical Log

Technical log is automatically generated when an *error* occurs in the
application.

Example:

``` {.json .copy }
{
"timestamp": "2023-06-16T19:15:25,416Z",
"company": "F1rst Digital Services",
"componentName": "gln-back-arsenal-global-observability-starter",
"componentId": "arsenal-observability-id",
"componentType": "arsenal-lib",
"appName": "gln-back-arsenal-integration-openapi-maven-plugin",
"appId": "appIdMock",
"environment": "local",
"logLevel": "ERROR",
"log": "AltairException: ERROR accessing queue",
"error": "true",
"traceId": "648cb4cbe34bd8d6d02bee4593db038a",
"spanId": "959f08e603286d64",
"parentSpanId": "d02bee4593db038a",
"trace_id": "0af7651916cd43dd8448eb211c80319c",
"span_id": "",
"parent_id": "00f067aa0ba902b7",
"tracestate": "vendrname1=b9c7c989f97918e1,vendrname2=b7ad6b7169203331",
"isGluon": "true",
"customLog": {
    "endpoint": "direct://altairbefore",
    "routeId": "testAltairTurboPS8-route"
},
"logType": "technical"
}
```

In case a route of Arsenal Integration generate a unhandled exception this is
capture by the default error handler of the route and generate a Technical log
error. The exception continue been throw upstream.

#### Technical Log Info

This is doing manually and must follow a few steps describe below.

##### Requirements

1. Instance of LogService. There is already a bean loaded at CamelContext with a
   `com.santander.ars.log.service.impl.LogServiceImpl` instance that is
   automatic initialized with the observability starter;
2. Object `com.santander.ars.log.model.TechnicalLog` with log attribute filled;
3. Call the method `sendTechnicalLog` from `LogService` with a `TechnicalLog`
   object as parameter.

    ``` { .java .copy title="Route example" linenums=1}

    import com.santander.ars.log.service.LogService;
    import gln.std.gluon.demo.archetype.processor.LogTechnicalInfoExampleProcessor;
    ...
    @Component
    public class AccountsGETRouteBuilder extends RouteBuilder {

    //Requirement 1
    @Autowired
    private LogService logService;

    @Override
    public void configure() throws Exception {

        from("direct:TO_AccountsGET")
        .routeId("id-AccountsGET")
        .doTry()
            .removeHeaders("CamelHttp*")
            .process(new LogTechnicalInfoExampleProcessor(logService))
            ...

    }
    ```

    ``` { .java .copy title="Processor example" linenums=1}
    package gln.std.gluon.demo.archetype.processor;

    import org.apache.camel.Exchange;
    import org.apache.camel.Processor;

    import com.santander.ars.log.model.TechnicalLog;
    import com.santander.ars.log.service.LogService;

    public class LogTechnicalInfoExampleProcessor implements Processor {

    private LogService logService;

    public LogTechnicalInfoExampleProcessor(LogService logService) {
        this.logService = logService;
    }
    @Override
    public void process(Exchange exchange) throws Exception {
        //Requirement 2
        TechnicalLog technical = new TechnicalLog();
        technical.setLog("Log Technical information example.");

        //Requirement 3
        logService.sendTechnicalLog(technical);
    }
    }
    ```

    ``` { .json .copy title="Log technical info example" }
    {
    "timestamp": "2023-06-19T18:53:27,305Z",
    "company": "F1rst Digital Services",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
    "appId": "",
    "environment": "local",
    "logLevel": "INFO",
    "log": "Log Technical information example. ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef36",
    "spanId": "e1964e6d9c56a096",
    "parentSpanId": "e457b5a2e4d86bd1",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "00f067aa0ba902b7",
    "tracestate": "vendrname1=b9c7c989f97918e1,vendrname2=b7ad6b7169203331",
    "isGluon": "true",
    "customLog": "",
    "logType": "technical"
    }
    ```

### Functional Log

To send the Functional Log, we must use the Service Log Facade.

Example of usage:

``` { .java .copy }
.process(exchange -> {
FunctionalLog functionalLog = new FunctionalLog();
functionalLog.setLog("log ....");

BusinessLog businessLog = new BusinessLog();
Map<String, String> map = new HashMap<>();
map.put("test", "123");
businessLog.setCustomField(map);
businessLog.setInput("{ \"test\": \"test1\" }");
businessLog.setOutput("{ \"test\": \"test1\" }");

functionalLog.setBusinessLog(businessLog);

logService.sendFunctionalLog(functionalLog);
})
```

Example of generated log:

``` {.json .copy }
{
    "timestamp": "2023-06-19T19:14:20,681Z",
    "company": "",
    "componentName": "gln-back-arsenal-global-observability-starter",
    "componentId": "arsenal-observability-id",
    "componentType": "arsenal-lib",
    "appName": "gln-back-arsenal-integration-openapi-maven-plugin",
    "appId": "",
    "environment": "",
    "logLevel": "INFO",
    "log": "log .... ",
    "error": "false",
    "traceId": "80f198ee56343ba864fe8b2a57d3ef17",
    "spanId": "855b05917ea976c0",
    "parentSpanId": "e457b5a2e4d86bd1",
    "trace_id": "0af7651916cd43dd8448eb211c80319c",
    "span_id": "",
    "parent_id": "b7ad6b7169203331",
    "tracestate": "congo=t61rcWkgMzE",
    "isGluon": "true",
    "customLog": "",
    "logType": "functional",
    "businessLog": {
        "input": {
            "test": "test1"
        },
        "output": {
            "test": "test1"
        },
        "test": "123"
    }
}
```

### Security Log

Security logs are generated automatically for authentication and authorization
processes.

Examples:

* authentication/authorization error

``` {.json .copy}
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

``` {.json .copy}
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

``` {.json .copy}
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

#### Using @UpdateHeader in Arsenal Integration Application

The @UpdateHeader annotation can be used in two ways within a Spring Camel
application: through a bean created and placed in the route, or through a
processor managed by Spring. Note that @UpdateHeader works only in conjunction
with the @Observed annotation from Micrometer. This is because @Observed enables
the observation of method execution, which is necessary for the dynamic values
of @UpdateHeader to be processed correctly.

##### Using @UpdateHeader with a Bean

Create a Bean with @UpdateHeader and @Observed:

``` java
package com.santander.gln.bean;

import com.santander.ars.annotation.UpdateHeader;
import com.santander.ars.custom.UpdateHeaderAction;
import io.micrometer.observation.annotation.Observed;
import org.springframework.stereotype.Component;

@Component
public class UpdateHeaderBean {

    @Observed
    @UpdateHeader(businessId = UpdateHeaderAction.CREATE, sessionId = UpdateHeaderAction.UPDATE)
    public void updateHeaders() {
        // Business logic for updating headers
    }
}
```

Configure the Route to Use the Bean:

``` java
package com.santander.gln.route;

import com.santander.gln.bean.UpdateHeaderBean;
import org.apache.camel.builder.RouteBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UsersPOSTRouteBuilder extends RouteBuilder {

    @Autowired
    private UpdateHeaderBean updateHeaderBean;

    @Override
    public void configure() throws Exception {
        from("direct:TO_UsersPOST")
                .routeId("id-UsersPOST")
                .process(exchange -> updateHeaderBean.updateHeaders())
                .log("Headers updated using bean.");
    }
}
```

##### Using @UpdateHeader with a Processor

Create a Processor with @UpdateHeader and @Observed:

``` java
package com.santander.gln.processor;

import com.santander.ars.annotation.UpdateHeader;
import com.santander.ars.custom.UpdateHeaderAction;
import io.micrometer.observation.annotation.Observed;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.springframework.stereotype.Component;

@Component
public class UpdateHeaderProcessor implements Processor {

    @Override
    @Observed
    @UpdateHeader(businessId = UpdateHeaderAction.CREATE, sessionId = UpdateHeaderAction.UPDATE)
    public void process(Exchange exchange) throws Exception {
        // Business logic for updating headers
    }
}
```

Configure the Route to Use the Processor:

``` java
package com.santander.gln.route;

import com.santander.gln.processor.UpdateHeaderProcessor;
import org.apache.camel.builder.RouteBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UsersPOSTRouteBuilder extends RouteBuilder {

    @Autowired
    private UpdateHeaderProcessor updateHeaderProcessor;

    @Override
    public void configure() throws Exception {
        from("direct:TO_UsersPOST")
                .routeId("id-UsersPOST")
                .process(updateHeaderProcessor)
                .log("Headers updated using processor.");
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

#### Summary

***Bean Approach:*** Create a bean with @UpdateHeader and @Observed, and use it
in the route. ***Processor Approach:*** Create a processor with @UpdateHeader
and @Observed, and use it in the route. The @UpdateHeader annotation requires
@Observed to function correctly, as @Observed enables the observation of method
execution, which is necessary for processing dynamic values in @UpdateHeader.
