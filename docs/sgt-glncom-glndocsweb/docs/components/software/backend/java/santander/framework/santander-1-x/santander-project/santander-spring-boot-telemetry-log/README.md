# Santander Spring Boot Telemetry Log ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The **Santander Spring Boot Telemetry Log** library simplifies monitoring and structured log generation in Spring Boot, enabling telemetry events, external system integration, URL exclusions, and sensitive data masking.

## Features

The library offers the following features:

- Creation of telemetry events with different types (Business, Technical, etc.).
- Sending events to external systems using specialized services.
- Configuration of URL exclusions to avoid logging certain requests.
- Masking sensitive data in logs using specific annotations.
- Integration with Logstash for structured log delivery.

!!! warning

      This library does not support reactive mode.

## Configuration

Add the dependency to your project:

```xml
<dependency>
    <groupId>com.santander.framework.springboot</groupId>
    <artifactId>santander-spring-boot-starter-telemetry-log</artifactId>
</dependency>
```

The library uses configurable properties in the `application.yml` file. Below are the main properties and their descriptions:

```yaml
santander:
  telemetry:
    log:
      context-name: string
      enable-sysout: boolean
      enable-json-log: boolean
      enable-json-message-log: boolean
      syslog-host: string
      syslog-port: int
      audit-syslog-port: int
      neg-syslog-port: int
      tec-syslog-port: int
      transform-event-base64: boolean
      syslog-facility: int
      syslog-protocol: string
      producer: string
      source: string
      brand:
        parameter: string
```

- `context-name`: Application context name, used to identify the origin of logs.  
  **Default value**: `@project.artifactId@`.

- `enable-sysout`: Enables or disables console log output.  
  **Default value**: `false`.

- `enable-json-log`: Defines whether log-back should use JSON functionality.  
  **Default value**: `false`.

- `enable-json-message-log`: Defines whether the message response should be in text/json format.  
  **Default value**: `false`.

- `syslog-host`: Syslog server host where logs will be sent.  
  **Default value**: `localhost`.

- `syslog-port`: Default port for sending logs to Syslog.  
  **Default value**: `5017`.

- `audit-syslog-port`: Specific port for audit logs.  
  **Default value**: `5014`.

- `neg-syslog-port`: Specific port for business logs.  
  **Default value**: `5015`.

- `tec-syslog-port`: Specific port for technical logs.  
  **Default value**: `5016`.

- `transform-event-base64`: Defines whether the `event.base64` and `event.original` fields should be sent to Logstash.  
  **Default value**: `false`.

- `syslog-facility`: Defines the Syslog facility, used to categorize logs.  
  **Default value**: `USER`.

- `syslog-protocol`: Protocol used for sending to Syslog (e.g., UDP).  
  **Default value**: `UDP`.

- `producer`: Event producer name, used to identify the origin of logs.  
  **Default value**: `LoggingService`.

- `source`: Event source, usually the package or class that generated the log.  
  **Default value**: Not specified.

- `brand.parameter`: Brand parameter associated with the event, used to identify the related entity or brand.  
  **Default value**: Not specified.

## Native compilation support

This module is not compatible with the native compilation.

## Use cases

### Event Creation

The library allows the creation of events of different types. Below are examples of how to instantiate events:

#### Event Creation

```java
import com.santander.framework.springboot.telemetry.domain.model.Event;
import com.santander.framework.springboot.telemetry.domain.model.EventData;

Event event = new Event()
    // Mandatory properties
    .setId("12345") // Unique identifier for the log event (Mandatory)
    .setEventTime("2025-06-04T10:00:00Z") // Date and time of the log event (Mandatory)

    // Optional properties
    .setSigla("SIG") // System acronym
    .setApplication("MyApplication") // Application name
    .setJourney("BusinessFlow") // Business journey
    .setSubJourney("SubFlow") // Sub-business journey
    .setChannel("Web") // Acronym of the application consumer channel
    .setProduct("ProductName") // Product name
    .setTransaction("TX123") // Mainframe / Altair transaction used
    .setHostname("server01") // Server name where the application is running
    .setProducer("LoggingService") // Application identifier (artifactid)
    .setSource("com.santander.app") // Application package identifier (groupid)
    .setSpecversion("1.0.0") // Log specification version
    .setType("BusinessEvent") // Log type
    .setDataContentType("application/json") // Log message format
    .setCorrelationId("abc123") // ID for correlation between layers composing the orchestration
    .setSpan("span123") // OpenTelemetry span name aggregating multiple logs
    .setReturnCode("200") // Application return code
    .setData(new EventData<>("CustomData")); // Custom application data
```

> All information sent to Logstash must necessarily be encapsulated and represented by an instance of `com.santander.framework.springboot.telemetry.domain.model.Event`.

The event is always related to a type, such as:

- `EventType.TEC`: For technical logs
- `EventType.NEG`: For business logs
- `EventType.AUDIT`: For audit logs
- `EventType.SYSOUT`: For system logs

### How to Send an Event

Created events can be sent using the services available in the library. Below is an example of sending:

#### Example of Sending Events

```java
import com.santander.framework.springboot.telemetry.service.SimpleLoggingService;
import com.santander.framework.springboot.telemetry.domain.model.Event;
import com.santander.framework.springboot.telemetry.utils.EventType;

@Component
public class MyClass {

  @Autowired
  private final SimpleLoggingService simpleLoggingService;
  
  public void log() {
    Event event = new Event()
      .setId("12345")
      .setEventTime("2025-06-04T10:00:00Z")
      .setJourney("Test")
      .span("spanTest");
  
    simpleLoggingService.logEvent(EventType.TEC, event);
  }
}
```
