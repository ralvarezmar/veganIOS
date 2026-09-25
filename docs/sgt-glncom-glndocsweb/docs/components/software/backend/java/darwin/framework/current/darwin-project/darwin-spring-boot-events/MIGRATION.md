# Darwin-spring-boot-events Migration guides

## 6.0.0 Version

<!tag:600>

- The `darwin-spring-boot-events` don't depend on `darwin-spring-boot-starter-logging` and `darwin-spring-boot-starter-authentication` anymore.
  If you are using `darwin-spring-boot-starter-logging` or `darwin-spring-boot-starter-authentication` you will need to include it as a dependency.
- The events activity log has been simplify. Before you had two activity logs by event (**received** and **processed**).
  Now you will have just one activity log by received event (**received**).
- In Gluon tracing mode (the default mode), client and server spans are joined into a single span, similar to how HTTP request tracing is handled.
  If you want to avoid reuse span, you could disable this feature by setting the property `darwin.logging.observability.join-span` to `false`.
- Class `InterceptorProducer` has been removed. This was an internal public class used to write the activity log.
  Now, this is done automatically using `ActivityLogObservationHandler`.
- Methods `addInterceptorProperties`, `addCommonInterceptorProperties`, and `extractTraceHeaders` have been removed from the class `InterceptorUtils`.
  These methods were for internal use. Properties are not used anymore, and trace headers are extracted automatically by the `brave` library.

<!end:600>

## Version 3.1.0-RELEASE

<!tag:310>

- In this release we have included the "***specific.avro.reader***" property in the Kafka consumers with **true** value (default false). If you need to disable this feature, you can configure this property from properties file under:
    ***spring.kafka.consumer.properties***.

<!end:310>
