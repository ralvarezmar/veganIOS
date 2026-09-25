# How To configure timeout with http component

The timeout configuration when Camel is the service consumer is done through the
components used for external access.

For Http calls, using the HTTP component, you must use the socketTimeout,
connectTimeout and connectionRequestTimeout options, the time is expressed in
milliseconds.

Ex:
http:localhost:8080?socketTimeout={{integration.timeout.chamada1.socket}}&connectTimeout={{integration.timeout.chamada1.connect}}&connectionRequestTimeout={{integration.timeout.chamada1.connection-request}}

The code below sets the http call timeout and handles the generated exception
(SocketTimeout) in case the timeout timeout is reached.

``` { .java .copy title="GetClientRouteBuilder.java"}
public class GetClientRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {

        from("direct:get-backend")
            .routeId("client-get-backend")
            .doTry()
                .routeId("client-get-backend")
                .removeHeaders("CamelHttp*")
                .setHeader(Exchange.HTTP_METHOD, constant("GET"))
                .setHeader(Exchange.HTTP_PATH, simple("/backend/clients/${header.id}"))
                .to("http:localhost:8080?bridgeEndpoint=true"
                        + "&socketTimeout={{integration.timeout.chamada1.socket}}"
                        + "&connectTimeout={{integration.timeout.chamada1.connect}}"
                        + "&connectionRequestTimeout={{integration.timeout.chamada1.connection-request}}")
                .unmarshal().json(JsonLibrary.Gson, ClientDTO.class)
                .setHeader(Exchange.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON_VALUE))
                .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.OK.value()))
            .doCatch(SocketTimeoutException.class)
                .process(exchange -> {
                    exchange.getMessage().setBody("");
                    exchange.getMessage().setHeader(Exchange.CONTENT_TYPE, MediaType.TEXT_PLAIN_VALUE);
                    exchange.getMessage().setHeader(Exchange.HTTP_RESPONSE_CODE, HttpStatus.REQUEST_TIMEOUT.value());
                })
            .doCatch(Exception.class)
                .process(exchange -> {
                    final Exception e = exchange.getProperty(Exchange.EXCEPTION_CAUGHT, Exception.class);
                    exchange.getMessage().setBody(e.getMessage());
                    exchange.getMessage().setHeader(Exchange.CONTENT_TYPE, MediaType.TEXT_PLAIN_VALUE);
                    exchange.getMessage().setHeader(Exchange.HTTP_RESPONSE_CODE, HttpStatus.INTERNAL_SERVER_ERROR.value());
                })
            .endDoTry();
    }
}
```

Setting the HTTP call timeout time value of the HTTP component
(integration.timeout.chamada1.socket, integration.timeout.chamada1.connect and
integration.timeout.chamada1.connection-request)

``` { .yaml .copy }
integration:
  timeout:
    chamada1:
      socket: 1000
      connect: 1000
      connection-request: 1000
```

Include the dependency below for using the timeout features in the hhtp
component, if not present.

``` { .xml .copy }
<dependency>
  <groupId>org.apache.camel.springboot</groupId>
  <artifactId>camel-http-starter</artifactId>
</dependency>
```
