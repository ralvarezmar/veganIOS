# JWT Propagation in Photon Applications

This guide explains how to propagate JWTs between services in a Photon application.

## Introduction

Photon applications are composed of multiple services that communicate with each other.
In this scenario, it is common to use JWTs to authenticate and authorize requests between services.
When a service receives a request, it needs to validate the JWT and propagate it to downstream services to ensure that the request is authorized.

## Propagating JWTs

To propagate a JWT between services, you need first to add the `quarkus-oidc-token-propagation-reactive` extension to your application.

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-oidc-token-propagation-reactive</artifactId>
</dependency>
```

After adding the dependency, the extension is automatically activated.

The `quarkus-oidc-token-propagation-reactive` extension propagates the JWT from the incoming request to the outgoing request.

## How to use

To propagate the JWT, you need to add the `AccessTokenRequestReactiveFilter` class to the interface that makes the request to the downstream service.

```java
import io.quarkus.oidc.token.propagation.reactive.AccessTokenRequestReactiveFilter;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.eclipse.microprofile.rest.client.annotation.RegisterProvider;

@Path("/")
@RegisterRestClient
@RegisterProvider(AccessTokenRequestReactiveFilter.class)
public interface DownstreamServiceClient {
    // Add the methods to make the requests to the downstream service
}
```

The `AccessTokenRequestReactiveFilter` class propagates the JWT from the incoming request to the outgoing request.

## Conclusion

This guide explained how to propagate JWTs between services in a Photon application.
