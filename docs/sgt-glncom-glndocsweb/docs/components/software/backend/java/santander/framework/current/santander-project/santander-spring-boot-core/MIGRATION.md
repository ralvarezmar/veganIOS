# santander-spring-boot-core Migration guides

## Version 1.1.0

<!tag:110>

- One of the behaviors that has changed is the configuration of follow redirect when building a `WebClient` using the
  `WebClient.Builder` provided by the architecture.
  To keep the same behavior as before, you need to set the following property:

```properties
spring.http.reactiveclient.redirects=dont-follow
```

- The implementation of `santander.core.http-clients.apache-http-client.read-timeout` has been changed.
  Before, it was used `setResponseTimeout`, now we are using `setSoTimeout`.
  We did this change to align with the behavior of Spring Boot implementation of `spring.http.client.read-timeout` property.

- Method `ConnectionsUtils::setUpNettyHttpClient` has been deprecated and will be removed in the future.
  If you were using this method, it is recommended to use the method `ConnectionsUtils::nettyHttpClientCustomizer` instead.

<!end:110>
