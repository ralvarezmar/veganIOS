# Photon Telemetry

We can define a telemetry as an ability to measure something. And measuring something on distributed systems is more difficult than on monolithic systems.

In order to have useful and reliable measurements in this type of ecosystem, we need an observability framework capable of generating, collecting and exporting data for analysis and measurement of software performance and behavior.

The photon-quarkus-telemetry provides the ability to compose spans in a simple and addressed way for tools like Dynatrace and Logstash, abstracting the complexity of developing a solution that implements the OpenTelemetry standard from scratch.

## How to use

1. Add dependency on your pom.xml file

    ``` { .xml .copy }
    <dependency>
        <groupId>com.santander.photon</groupId>
        <artifactId>photon-quarkus-telemetry</artifactId>
    </dependency>
    ```

2. Configuration in **application.properties**:

    ``` { .txt .copy }
    arsenal.photon.config.log.transform-event-base64=false
    arsenal.photon.config.log.enabled-logstash-ingestion=true

    arsenal.photon.config.log.syslog-host=localhost
    arsenal.photon.config.log.syslog-port=5014
    arsenal.photon.config.log.tec-syslog-port=5014
    arsenal.photon.config.log.neg-syslog-port=5014
    arsenal.photon.config.log.audit-syslog-port=5014

    arsenal.photon.config.log.brand.parameter=Banco Santander
    arsenal.photon.config.log.producer=arsenal-photon-orm-otel
    arsenal.photon.config.log.source=com.santander.telemetry
    arsenal.photon.config.log.context-name=arsenal-photon-orm-otel
    ```

    | Property                   | Description                                      |
    |----------------------------|--------------------------------------------------|
    | transform-event-base64     | convert event to base64 in the logstash pipeline |
    | enabled-logstash-ingestion | enabled/disabled logstash ingestion              |
    | syslog-host                | host of logstash                                 |
    | syslog-port                | port of logstash                                 |
    | parameter                  | universal flag                                   |
    | producer                   | app name                                         |
    | source                     | app package name                                 |
    | context                    | app name or context                              |

3. Kubernetes environment variables - env.conf files for each execution environment

    ``` { .txt .copy }
    LOGSTASH_HOST=logstashinstance.svc.cluster.local
    TEC_LOGLEVEL=INFO
    NEG_LOGLEVEL=INFO
    AUDIT_LOGLEVEL=INFO
    ```

    !!! warning

        Don't use local profiles to execute your app in kubernetes environment.

4. Inject the log generator service

    ``` { .java .copy }
    @Inject
    private SimpleLoggingService simpleLog;
    ```

5. Log using log service by creating an Event and assigning a type

    The **com.santander.ars.extension.events.Event** class has the following attributes:

    ``` { .java .copy}
    package com.santander.ars.extension.events;

    import com.fasterxml.jackson.annotation.JsonInclude;
    import lombok.Data;
    import lombok.NoArgsConstructor;
    import lombok.experimental.Accessors;

    @Data
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @NoArgsConstructor
    public class Event {

        /** Log id */
        String id;

        /** Log event date and time */
        String eventTime;

        /** Sigla */
        String sigla;

        /** Application name */
        String application;

        /** Business journey name */
        String journey;

        /** Business sub-journey name */
        String subJourney;

        /** Sigla of application's consumer channel */
        String channel;

        /** Product name */
        String product;

        /** Altair transaction name */
        String transaction;

        /** Server host name */
        String hostname;

        /** Artifactid */
        String producer;

        /** Groupid */
        String source;

        /** Log specification version */
        String specversion = "1.0.0";

        /** Log type */
        String type;

        /** Log format */
        String dataContentType = "application/json";

        /** Correlation id */
        String correlationId;

        /** Span name to aggregate log */
        String span;

        /** Return code */
        String returnCode;

        /** Custom data */
        EventData<?> data;
    }
    ```

    Example of different types of log:

    ``` { .java .copy }
    // technical log
    Event tecEvent =
    new Event()
        .setApplication("myPhotonApp")
        .setChannel("Mobile")
        .setJourney("Test")
        .setSpan("spanName");
    simpleLog.logEvent(EventType.TEC, tecEvent);

    // default log
    Event auditEvent =
    new Event()
        .setApplication("myPhotonApp")
        .setChannel("Mobile")
        .setJourney("Test")
        .span("spanName")
    simpleLog.logEvent(EventType.AUDIT, auditEvent);

    // business log
    POJO pojo = new POJO();
    pojo.setCustomFieldOne("Retorno OK");
    pojo.setCustomFieldTwo("Operacao realizada com sucesso");
    EventData<POJO> data = new EventData<POJO>();
    data.setData(pojo);  

    Event negEvent =
        new Event()
            .setApplication("myPhotonApp")
            .setChannel("Mobile")
            .setJourney("Test")
            .setProduct("Lib")
            .setData(data)
            .setSpan("spanName");
    simpleLog.logEvent(EventType.NEG, negEvent);
    ```

    Note that in business logs, the setData() method of the Event class takes any type. As this type is customized
    by the developer, we were not able to automatically apply the taxonomy pattern required by Dynatrace.

    This is just an illustration for working with complex types. It is necessary to follow the nomenclature standard
    established by the team that maintains DynaTrace. Today, the default is to have the prefix "key-st_" in each field.

    In Java, we cannot use the space character (-) to name fields, so in this case we recommend using an
    implementation of java.util.Map:

    ``` { .java .copy }
    Map<String, String> map = new HashMap<>();
    map.put("key-st_firstValue", "Anything value");
    ```

    For types provided by the library, there is already a built-in mechanism that adjusts the field names. Now for custom types, the developer must perform this convention adjustment.

## Test locally

It's required to have logstash docker image available to test the application locally.

1. Create a **logstash.yml** file inside a folder with the following content:

    ``` { .txt .copy }
    http.host: 0.0.0.0
    ```

2. Create a **logstash.conf** file and a **logshipper.conf** inside a folder with the following contents:

    logstash.conf

    ``` { .txt .copy }
    ########## POC ###########
    ```

    logshipper.conf

    ``` { .txt .copy }
    input {
        tcp {
            port => 5014
            type => syslog
            #codec => json
        }
        udp {
            port => 5014
            type => syslog
            codec => json {
            target => "[event]"
            }
        }
        udp {
            port => 5015
            type => syslog
            codec => json {
            target => "[event]"
            }
        }
        udp {
            port => 5016
            type => syslog
            codec => json {
            target => "[event]"
            }
        }
        udp {
            port => 5017
            type => syslog
            codec => json {
            target => "[event]"
            }
        }
    }
    filter {
        ruby {
            init => "require 'base64'"
            code => 'event.set("decoded", Base64.decode64(event.get("[event][base64]")))'
        }
        json {
            source => "[decoded]"
            target => "[event][doc]"
            add_tag => [ "foo" ]
        }
    }
    output {
        stdout { codec => rubydebug }
    }
    ```

3. Run logstash image as follows:

    ``` { .txt .copy }
    docker run --rm -it -v path-to-logstash-and-logshipper-conf-folder/:/usr/share/logstash/pipeline/ -v path-to-logstash-yaml-folder/logstash.yml:/usr/share/logstash/config/logstash.yml  -p 127.0.0.1:5014:5014/udp  logstash:7.17.5
    ```

    The output should be similar to:

    ``` { .bash .copy }
    ...
    [2024-10-01T20:42:35,989][INFO ][logstash.runner          ] Starting Logstash {"logstash.version"=>"7.17.5", "jruby.version"=>"jruby 9.2.20.1 (2.5.8) 2021-11-30 2a2962fbd1 OpenJDK 64-Bit Server VM 11.0.15+10 on 11.0.15+10 +indy +jit [linux-aarch64]"}
    [2024-10-01T20:42:35,989][INFO ][logstash.runner          ] JVM bootstrap flags: [-Xms1g, -Xmx1g, -XX:+UseConcMarkSweepGC, -XX:CMSInitiatingOccupancyFraction=75, -XX:+UseCMSInitiatingOccupancyOnly, -Djava.awt.headless=true, -Dfile.encoding=UTF-8, -Djdk.io.File.enableADS=true, -Djruby.compile.invokedynamic=true, -Djruby.jit.threshold=0, -Djruby.regexp.interruptible=true, -XX:+HeapDumpOnOutOfMemoryError, -Djava.security.egd=file:/dev/urandom, -Dlog4j2.isThreadContextMapInheritable=true, -Dls.cgroup.cpuacct.path.override=/, -Dls.cgroup.cpu.path.override=/]
    [2024-10-01T20:42:35,997][INFO ][logstash.settings        ] Creating directory {:setting=>"path.queue", :path=>"/usr/share/logstash/data/queue"}
    [2024-10-01T20:42:36,000][INFO ][logstash.settings        ] Creating directory {:setting=>"path.dead_letter_queue", :path=>"/usr/share/logstash/data/dead_letter_queue"}
    [2024-10-01T20:42:36,093][INFO ][logstash.agent           ] No persistent UUID file found. Generating new UUID {:uuid=>"3ee1fa92-1ce7-481c-807f-be1fee3ec729", :path=>"/usr/share/logstash/data/uuid"}
    [2024-10-01T20:42:36,419][INFO ][logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600, :ssl_enabled=>false}
    ...
    [2024-10-01T20:42:37,871][INFO ][logstash.inputs.udp      ][main][92a9111e35b70d76a9b5c3896d59de9e91fe4ee43188aa6a9b37be56fd9be7cf] Starting UDP listener {:address=>"0.0.0.0:5015"}
    [2024-10-01T20:42:37,873][INFO ][logstash.inputs.udp      ][main][d5cddc294cb4534d085cdb7aca1d3faa8e20ec3113795ff93dafc2f2a26d6b83] Starting UDP listener {:address=>"0.0.0.0:5017"}
    [2024-10-01T20:42:37,874][INFO ][logstash.inputs.udp      ][main][eedf7be1f93a9d1da443487307d656ee6dba627f833564874e0c97b1b5f5e34c] Starting UDP listener {:address=>"0.0.0.0:5016"}
    [2024-10-01T20:42:37,910][INFO ][logstash.inputs.udp      ][main][eedf7be1f93a9d1da443487307d656ee6dba627f833564874e0c97b1b5f5e34c] UDP listener started {:address=>"0.0.0.0:5016", :receive_buffer_bytes=>"106496", :queue_size=>"2000"}
    [2024-10-01T20:42:37,913][INFO ][logstash.inputs.udp      ][main][8ec4e37fa6bf9c096ba335f3958ad16803851f5770330a83f184a139fbbaf4de] Starting UDP listener {:address=>"0.0.0.0:5014"}
    [2024-10-01T20:42:37,916][INFO ][logstash.inputs.udp      ][main][8ec4e37fa6bf9c096ba335f3958ad16803851f5770330a83f184a139fbbaf4de] UDP listener started {:address=>"0.0.0.0:5014", :receive_buffer_bytes=>"106496", :queue_size=>"2000"}
    [2024-10-01T20:42:37,919][INFO ][logstash.inputs.udp      ][main][92a9111e35b70d76a9b5c3896d59de9e91fe4ee43188aa6a9b37be56fd9be7cf] UDP listener started {:address=>"0.0.0.0:5015", :receive_buffer_bytes=>"106496", :queue_size=>"2000"}
    [2024-10-01T20:42:37,920][INFO ][logstash.inputs.udp      ][main][d5cddc294cb4534d085cdb7aca1d3faa8e20ec3113795ff93dafc2f2a26d6b83] UDP listener started {:address=>"0.0.0.0:5017", :receive_buffer_bytes=>"106496", :queue_size=>"2000"}
    [2024-10-01T20:42:37,926][INFO ][logstash.agent           ] Pipelines running {:count=>1, :running_pipelines=>[:main], :non_running_pipelines=>[]}
    ```

    !!! warning

        Don't use local profiles to execute your app in kubernetes environment.

        Telemetry only works on different local profiles.

4. Run the application and check the result after executing the logging event code.
The event should be shown on terminal.

    ``` { .bash .copy }
    {
        "@version" => "1",
            "tags" => [
            [0] "foo"
        ],
            "type" => "syslog",
            "host" => "172.17.0.1",
        "@timestamp" => 2024-10-01T20:37:45.618Z,
        "decoded" => "{\"id\":\"547bfcce-8367-4cb1-b94b-00829ffe6f0b\",\"eventTime\":\"2024-10-01T17:37:45.500-0300\",\"application\":\"myPhotonApp\",\"journey\":\"Test\",\"producer\":\"arsenal-photon-orm-otel\",\"source\":\"com.santander.telemetry\",\"specversion\":\"1.0.0\",\"dataContentType\":\"application/json\",\"span\":\"spanName\",\"data\":{\"detail\":{\"2\":\"two\",\"1\":\"one\"}}}",
            "event" => {
                                "tags" => [
                [0] "NEG"
            ],
                    "syslogFacility" => "USER",
                "enableJsonMessageLog" => "false",
                        "thread_name" => "executor-thread-1",
                            "level" => "INFO",
                "transformEventBase64" => "false",
                                "doc" => {
                    "application" => "myPhotonApp",
                        "data" => {
                    "detail" => {
                        "1" => "one",
                        "2" => "two"
                    }
                },
                        "span" => "spanName",
                        "journey" => "Test",
                        "source" => "com.santander.telemetry",
                    "eventTime" => "2024-10-01T17:37:45.500-0300",
                    "producer" => "arsenal-photon-orm-otel",
                            "id" => "547bfcce-8367-4cb1-b94b-00829ffe6f0b",
                    "specversion" => "1.0.0",
                "dataContentType" => "application/json"
            },
                    "enableJsonLog" => "true",
                        "enableSysout" => "false",
                        "stackSize" => "2048",
            "enabledLogstashIngestion" => "true",
                            "@version" => "1",
                            "appName" => "@project.artifactId@",
                        "logger_name" => "com.santander.ars.extension.service.SimpleLoggingServiceImpl",
                        "@timestamp" => "2024-10-01T17:37:45.535-03:00",
                            "base64" => "eyJpZCI6IjU0N2JmY2NlLTgzNjctNGNiMS1iOTRiLTAwODI5ZmZlNmYwYiIsImV2ZW50VGltZSI6IjIwMjQtMTAtMDFUMTc6Mzc6NDUuNTAwLTAzMDAiLCJhcHBsaWNhdGlvbiI6Im15UGhvdG9uQXBwIiwiam91cm5leSI6IlRlc3QiLCJwcm9kdWNlciI6ImFyc2VuYWwtcGhvdG9uLW9ybS1vdGVsIiwic291cmNlIjoiY29tLnNhbnRhbmRlci50ZWxlbWV0cnkiLCJzcGVjdmVyc2lvbiI6IjEuMC4wIiwiZGF0YUNvbnRlbnRUeXBlIjoiYXBwbGljYXRpb24vanNvbiIsInNwYW4iOiJzcGFuTmFtZSIsImRhdGEiOnsiZGV0YWlsIjp7IjIiOiJ0d28iLCIxIjoib25lIn19fQ==",
                        "level_value" => 20000,
                    "syslogProtocol" => "UDP",
                        "stackDepth" => "30"
        }
    }
    ```
