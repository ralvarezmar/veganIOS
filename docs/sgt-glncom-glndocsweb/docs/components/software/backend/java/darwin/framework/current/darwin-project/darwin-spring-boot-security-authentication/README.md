# Darwin Spring Boot Authentication ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Boot Security Authentication` library serves as a wrapper for the Spring Framework with the objective of providing a seamless integration between it and the applications developed in the Banco Santander. This integration
includes defining the communications with the PKM and STS services, a security web adapter with the necessary filters to force the security web adapter with the necessary filters to force authentication of the resources published in microservices,
etc.

This integration includes the definition of communications with PKM, STS or [authorization server](https://datatracker.ietf.org/doc/html/rfc6749) services to support OAuth 2.0 JWT Bearer Tokens, a security web adapter with the necessary filters to
force authentication of the resources published in the microservices and the injection of security headers to the webClient and restTemplate clients.

It is based on **Spring Security** and automatically implements the following interfaces either with Darwin's own implementations extending those provided by Spring Security or using Spring Security implementations directly:

- `OAuth2TokenValidator<Jwt>`: Validations to be performed on the JWT token

- `JwtDecoder`, `ReactiveJwtDecoder`: Decodes the JWT token and calls the OAuth2TokenValidator&lt;Jwt&gt; to do the validations.

- `Converter<Jwt, Collection<GrantedAuthority>>`, `Converter<Jwt, Flux<GrantedAuthority>>`: Create the GrantedAuthorities of the user of the claim scope or scp of the JWT token to be able to use Spring roles

- `Converter<Jwt, AbstractAuthenticationToken>`, `Converter<Jwt, Mono<AbstractAuthenticationToken>>`: Converts the JWT token into the Spring Authentication object, in our case the Darwin implementation `AuthenticationBearerToken`

- `ServerAuthenticationConverter`, `BearerTokenResolver`: Obtains the JWT token from the request

- `AuthenticationManager`, `ReactiveAuthenticationManager`: It calls the JwtDecoder to perform the validation and then calls the converter to generate the Authentication object

- `SecurityFilterChain`, `SecurityWebFilterChain`: Defines the safety chain

## Functionality

`Darwin Spring Boot` auto-configuration will detect the type of application it is running in,
autoconfiguring only those functionalities that apply to that environment.

Visit the [Darwin Flavours section](../../ABOUT.md#darwin-flavours)
to get more info about how to work the application type detection.

!!! note

    Both the supported functionality and the use of the library will be equivalent in both Web implementations (Servlet/Reactive), so it will be automatically integrated for the projects.

### NotWeb application

The library provides the following **base functionality**:

#### Interceptors

An `interceptor` is included in the **RestTemplate**, and **Webclient and WebClient.Builder** beans that inserts/propagates the authentication header in the request **if a security context exists**. In addition, if the *BKS-Token* header or the BKS
token is found in the security context, it will also be propagated to the new invocation via that header. In the **RestTemplate** an `AuthTokenInterceptor` shall be injected and in the **WebClient/WebClient.Builder** an
`AuthTokenServletFilterFunction` and an `AuthTokenReactiveFilterFunction` shall be injected.

!!! warning

    It is necessary for the project to register a `WebClient.Builder` or `WebClient` bean for the instrumentation to be applied. If the project creates an instance of `WebClient` with the keyword `new`, the instrumentation will
    **NOT** work.

#### Cache

The library is prepared to cache the responses of the **invocations to the public key service (PKM)** so that it does not have to be constantly consulted, using a **non-configurable in-memory cache**. The library uses a **non-configurable in-memory
cache** for this purpose.

In the case of **token translation service (STS) invocations**, Darwin also caches the requests, thus reducing the number of accesses to the service. To do this, it uses a **caffeine/DataGrid in-memory cache named "credentials "**, where a maximum
dwell time of 10 minutes is set.

!!! info "Important"

    To enable the STS cache, the @EnableCaching annotation must be included in the Spring-Boot class or in a configuration class.

#### Circuit Breaker and Retry

Communications with the STS and PKM shall be performed under implementations of the **CircuitBreaker** and **Retry** pattern in a manner transparent to the application. to the application. The Retry and Circuit Breaker instances of the
authentication library are:

- **PKMConnector:** Controls calls to PKM to validate the token.

- **PKMFallbackConnector:** Controls calls to PKM fallbacks in case the principals do not respond correctly.

- **STSConnector:** Controls calls to STS to convert a token.

- **STSFallbackConnector:** Controls calls to STS fallbacks in case the principals do not respond correctly.

Examples are given below for [How to configure CircuitBreaker and Retry to access PKM and STS](#how-to-configure-circuitbreaker-and-retry-to-access-pkm-and-sts).

#### SecurityContextThreadLocalAccessor

The Security context is registered through an accessor (SecurityContextThreadLocalAccessor) to be automatically propagated by the io.micrometer.context-propagation library.

#### NotWeb Security Services

Two beans with **two implementations (imperative and reactive)** of the `SecurityManagerService` interface are exposed. Both have the following functionalities:

- **BKS or JWT token authentication through the use of the public key service (PKM)**. In the **imperative** solution when authenticating a token already creates the security context, but in the **reactive** solution it will be up to the project
    [How to use the reactive security context in a NotWeb application](#how-to-use-the-reactive-security-context-in-a-notweb-application).

    !!! info "Important"

        The **interceptors of the authentication header** will still work as long as the security context exists. If **reactive implementation** is used, in addition to authentication, the reactive security context must be
        created as in the example.

- **Corporate (BKS) to JWT token conversion and vice versa**, by using the token conversion service (STS).

- **Support OAuth 2.0 JWT Bearer Tokens**, by using an authorization server.

- **Authorization of a request for a user** through the use of the Channel/Business Operational Control. This functionality prior token authentication is also included in this functionality, for more information on authorization: [Authorization
    library](../darwin-spring-boot-security-authorization/README.md).

!!! note

    The configuration for a **NotWeb Application** makes **both** implementations available to the project, so you can use the one that suits you best.

### Servlet application

In addition to the **basic functionality**, these applications have the following functions:

#### Securing Endpoint

**Securing the endpoints** of a microservice by:

- **Support OAuth 2.0 JWT Bearer Tokens**, by using an authorization server.

- **Internal JWT Bearer Tokens**, by using PKM service

- **Corporate token aka BKS**, by using PKM service

When installed and configured, it will be necessary to send a JWT or corporate token each time an endpoint is called. It also allows the possibility to exclude certain endpoints from authentication.

#### Whitelist

URLs that are added to the **white list** will have free access. If the `info` and `health` URLs of Actuator are accessed, they have been exempted by default in the authentication filter, so there is no need to add them to the endpoint whitelist.
Access is free both for endpoints ( `/actuator/health/**` and `/actuator/info`) that are exposed on the same port as the application and when a different port is set for Actuator management.

#### Interceptors

Only the `AuthTokenInterceptor` in **RestTemplate** and the `AuthTokenServletFilterFunction` in **WebClient/WebClient.Builder** shall be injected, so that: when from a microservice with the security library configured you want to **invoke another
one within the same or another application**, automatically (unless the endpoint of the origin microservice is configured in the white-list or a path to the STS to convert the BKS token has not been defined) the **interceptors** mentioned above
shall include the original JWT token or the converted BKS token in the headers of the new request. In addition, if the *BKS-Token* header or the BKS token is found in the security context, it shall also be propagated to the new invocation via that
header.

#### TokenService

A Bean of the `TokenService<String, Token>` interface is provided, which allows to get the JWT or BKS token at any point in the application and to verify a given Token.

#### Extract JWT Token claims to DarwinContext

If the microservice **is called with a JWT token** it will look for some claims to update the DarwinContext:

- `channel_tp` claim -> DarwinInfo.`channel`
- `cid_tp` claim -> DarwinInfo.`appInit`
- `client_id` claim -> DarwinContext.`JWTClientId`
- `coreUserId` claim -> DarwinContext.`coreUserId`

These values will have more priority than its respective headers (_X-Santander-Channel_ and _app-init_).

#### Enable Security Content Policy

The library allows developers to enable the Content Security Policy (CSP) in the application.
The CSP is a security standard that helps prevent cross-site scripting (XSS), clickjacking, and other code injection
attacks resulting from execution of malicious.
The default policy is "default-src 'self'", you can customize it by setting the `policy-directives` property.
To enable CSP, the following configuration must be added to the application.yml:

```yaml
darwin:
  security:
    content-security-policy:
      enabled: true
      policy-directives: "default-src 'self'"
```

### Reactive Application

#### Securing Endpoint

Same functionality as in `Servlet` applications is exposed.

#### Whitelist

The same functionality as in `Servlet` applications is exposed.

#### Interceptors

Only the `AuthTokenReactiveFilterFunction` in **WebClient/WebClient.Builder** shall be injected to propagate the original JWT token or the converted BKS when from a microservice with the configured security library you want to **invoke another one
within the same or another application**. In addition, if the *BKS-Token* header or the BKS token is found in the security context, it will also be propagated to the new invocation via that header.

#### TokenService

A bean of the `TokenService<Mono<String>, Mono<Token>>` interface will be exposed in this case to obtain the JWT or BKS token at any point in the application and to verify a given Token.

#### Extract JWT Token claims to DarwinContext

If the microservice **is called with a JWT token** it will look for some claims to update the DarwinContext:

- `channel_tp` claim -> DarwinInfo.`channel`
- `cid_tp` claim -> DarwinInfo.`appInit`
- `client_id` claim -> DarwinContext.`JWTClientId`
- `coreUserId` claim -> DarwinContext.`coreUserId`

These values will have more priority than its respective headers (_X-Santander-Channel_ and _app-init_).

#### Enable Security Content Policy

The same functionality as in `Servlet` applications is exposed.

## Installation and configuration

To make use of the library all we have to do is add the library starter as a Maven dependency in the project.

    <dependency>
     <groupId>com.santander.darwin</groupId>
     <artifactId>darwin-spring-boot-starter-authentication</artifactId>
    </dependency>

!!! info "Important"

    The library uses WebClient in communications with PKM or STS, so adding the dependency with its starter **will always include the `spring-boot-starter-webflux`** package.

If we only include the library starter in a `Spring Boot` application, the configuration that can be loaded will be the `NotWeb` one, to load the configuration corresponding to the other [Functionality](#functionality) you must add the dependencies
reflected in the following table:

| Application Type            | Desired configuration | Dependencies                                                                                                                                                                                                                                                     |
|-----------------------------|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WebApplicationType.NONE     | NotWeb                | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-authentication</strong></li></ul>                                                                                                                                                                |
| WebApplicationType.SERVLET  | Servlet               | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-authentication</strong></li><li>org.springframework.boot:<strong>spring-boot-starter-web</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul> |
| WebApplicationType.REACTIVE | Reactive              | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-authentication</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul>                                                                           |

!!! info "Important"

    Although you can add the dependencies and application type manually, the Darwin Archetypes has been redesigned to include all possible
    configurations. redesigned to include all possible configurations, so we strongly recommend using it to avoid errors. In case of migration of architecture versions check the [migration guides](../../MIGRATION.md).

<!tag:properties>

### Configuration

| Name                                                      | Default value      | Required | Description                                                                                                                                                                | Supported values | Environment                                |
|-----------------------------------------------------------|--------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|--------------------------------------------|
| darwin.security.enabled                                   | true               | No       | Indicates whether to initialise the authentication library or not.                                                                                                         | Boolean          | <ul><li>All</li></ul>                      |
| darwin.security.white-list                                | N/A                | No       | List of routes, in AntPath format, that do not require authentication.                                                                                                     | List             | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.auth-query-parameter                      | token              | No       | Sets the name of the parameter in which the authentication token can arrive.                                                                                               | String           | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.audience                                  | N/A                | No       | If this parameter is informed, at least one recipients of the list must be contained in the JwtClaimNames.AUD field of the token for this token to be correctly validated. | String           | <ul><li>All</li></ul>                      |
| darwin.security.issuer                                    | N/A                | No       | Issuer of the token. Corresponds to the claim "iss" of the JWT token. If this value is not null, only tokens from a given issuer will be accepted.                         | String           | <ul><li>All</li></ul>                      |
| darwin.security.bks.enabled                               | true               | No       | Enables BKS token support. BKS Token is only supported if it is using <strong>PKM server</strong> to validate tokens.                                                      | Boolean          | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.content-security-policy.enabled           | false              | No       | Enables the Content Security Policy (CSP) in the application.                                                                                                              | Boolean          | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.content-security-policy.policy-directives | default-src 'self' | No       | The Content Security Policy (CSP) policy directives.                                                                                                                       | String           | <ul><li>Servlet</li><li>Reactive</li></ul> |

#### STS Connector

| Name                                                             | Default value | Required | Description                                                                                                                                                                                                                                                    | Supported values | Environment           |
|------------------------------------------------------------------|---------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|
| darwin.security.connectors.sts-connector.sts-endpoint            | N/A           | No       | Path to the token conversion service (STS). It is only necessary if the microservice needs to convert BKS tokens to JWT or vice versa. Up to two routes can be defined in case of failure of the first one.                                                    | List             | <ul><li>All</li></ul> |
| darwin.security.connectors.sts-connector.connect-timeout         | 1000          | No       | Sets the time in milliseconds to wait before dropping the connection. A value of 0 indicates an infinite timeout.                                                                                                                                              | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.sts-connector.pending-acquire-timeout | 1000          | No       | Sets the timeout time in milliseconds used when requesting a connection from the connection manager using the underlying HttpClient object. A value of 0 indicates an infinite timeout.                                                                        | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.sts-connector.read-timeout            | 1000          | No       | Sets the socket read timeout for the underlying HttpClient object. A value of 0 indicates an infinite timeout.                                                                                                                                                 | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.sts-connector.max-life-time           | 60000         | No       | Sets the maximum persistence lifetime of connections. No value keeps the connection alive.                                                                                                                                                                     | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.sts-connector.wiretap                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:1 logging.level.reactor.netty.http.client=DEBUG | Boolean          | <ul><li>All</li></ul> |

#### PKM Connector

| Name                                                             | Default value | Required | Description                                                                                                                                                                                                                                                                              | Supported values | Environment           |
|------------------------------------------------------------------|---------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|
| darwin.security.connectors.pkm-connector.pkm-endpoint            | N/A           | No       | Path to the public key service. Up to two routes can be defined in case of failure of the first one.                                                                                                                                                                                     | List             | <ul><li>All</li></ul> |
| darwin.security.connectors.pkm-connector.connect-timeout         | 1000          | No       | Sets the time in milliseconds to wait before dropping the connection. A value of 0 indicates an infinite timeout.                                                                                                                                                                        | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.pkm-connector.pending-acquire-timeout | 1000          | No       | Sets the timeout in milliseconds used when requesting a connection from the connection manager using the underlying HttpClient object. used when requesting a connection from the connection manager using the underlying HttpClient object. A value of 0 indicates an infinite timeout. | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.pkm-connector.read-timeout            | 1000          | No       | Sets the socket read timeout for the underlying HttpClient object. A value of 0 indicates an infinite timeout.                                                                                                                                                                           | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.pkm-connector.max-life-time           | 60000         | No       | Sets the maximum persistence lifetime of connections. No value keeps the connection alive.                                                                                                                                                                                               | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.pkm-connector.wiretap                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG: <code>logging.level.reactor.netty.http.client=DEBUG</code>               | Boolean          | <ul><li>All</li></ul> |

#### Authorization Server

!!! warning

    You can only define either a **PKM connector** or an **authorization server**. If you define both the application will return an error at startup.

| Name                                                                              | Default value | Required | Description                                                                                                                                                                                                                                                                              | Supported values | Environment           |
|-----------------------------------------------------------------------------------|---------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|
| spring.security.oauth2.resourceserver.jwt.jwk-set-uri                             | N/A           | No       | Authorization Server JWK URI.                                                                                                                                                                                                                                                            | String           | <ul><li>All</li></ul> |
| spring.security.oauth2.resourceserver.jwt.issuer-uri                              | N/A           | No       | Issuer of the token. Corresponds to the claim "iss" of the JWT token. If this value is not null, only tokens from a given issuer will be accepted. If the parameter darwin.security.issuer is defined then it has precedence                                                             | String           | <ul><li>All</li></ul> |
| darwin.security.connectors.authorization-server-connector.connect-timeout         | 1000          | No       | Sets the time in milliseconds to wait before dropping the connection. A value of 0 indicates an infinite timeout.                                                                                                                                                                        | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.authorization-server-connector.pending-acquire-timeout | 1000          | No       | Sets the timeout in milliseconds used when requesting a connection from the connection manager using the underlying HttpClient object. used when requesting a connection from the connection manager using the underlying HttpClient object. A value of 0 indicates an infinite timeout. | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.authorization-server-connector.read-timeout            | 1000          | No       | Sets the socket read timeout for the underlying HttpClient object. A value of 0 indicates an infinite timeout.                                                                                                                                                                           | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.authorization-server-connector.max-life-time           | 60000         | No       | Sets the maximum persistence lifetime of connections. No value keeps the connection alive.                                                                                                                                                                                               | Number           | <ul><li>All</li></ul> |
| darwin.security.connectors.authorization-server-connector.wiretap                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG: <code>logging.level.reactor.netty.http.client=DEBUG</code>               | Boolean          | <ul><li>All</li></ul> |

<!end:properties>

### Basic configuration

The only property that we **must** set for any type of application is the Public Key Manager (PKM) path or authorization server JWK Uri. The PKM path will be used to obtain the public key against which to validate tokens.

This property can be configured directly in the `application.yml`, but in order to have an **environment dependent configuration**, we recommend using variables defined in the `application.yml`. we recommend using variables defined in the
`application-{environment}.properties` generated for each environment, so that the configuration file is unique.

#### Using PKM to validate authentication tokens

##### application.yml

    darwin:
      security:
        connectors:
          pkm-connector:
            pkm-endpoint:
              - ${env.connectors.pkm-connector.pkm-endpoint}

##### application-XXX.properties

    env.connectors.pkm-connector.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey

#### Using Authorization Server JWK URI to validate authentication tokens

##### application.yml

    spring:
      security:
        oauth2:
          resourceserver:
            jwt:
              jwk-set-uri: ${env.connectors.resourceserver.jwk-endpoint}

##### application-XXX.properties

    env.connectors.resourceserver.jwk-endpoint: https://authorization-server/jwks.json

### Complete configuration

Applications can always configure the STS to be used as well if we are using PKM authentication **application.yml**:

    darwin:
      security:
        connectors:
          pkm-connector:
            pkm-endpoint:
              - ${env.connectors.pkm-connector.pkm-endpoint} # Define pkm-endpoint or jwk-set-uri but not both
          sts-connector:
            sts-endpoint:                   # STS URL for token conversion
              - ${env.connectors.sts-connector.sts-endpoint}
        issuer: issuer                     # Issuer accepted by application
        audience:
          - http://dummy.audience       # Audience accepted by application

    spring:
      cache:                            # STS "credentials" cache configuration
        type: caffeine
        cache-names: credentials
        caffeine:
          spec: expireAfterWrite=10m
      security:
        oauth2:
          resourceserver:
            jwt:
              jwk-set-uri: ${env.connectors.resourceserver.jwk-endpoint} # Define pkm-endpoint or jwk-set-uri but not both
              issuer-uri: issuer     # Issuer accepted by application. This parameter is also accepted but darwin.security.issuer has precedence

And **application-XXX.properties**

    env.connectors.pkm-connector.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
    env.connectors.sts-connector.sts-endpoint: https://srvnuarintra.santander.dev.corp/sts

In addition, the following configuration to customize WebClients can also be added **application.yml**:

    darwin:
      security:
        sts-retries: 4            # Customize number of retries in the STS call
        connectors:
            sts-connector:         # Customise STS call time-outs
              connect-timeout: 1000
              pending-acquire-timeout: 1000
              read-timeout: 1000
              max-life-time: 50000
            pkm-connector:         # Customise PKM call time-outs
              connect-timeout: 1000
              pending-acquire-timeout: 1000
              read-timeout: 1000
              max-life-time: 50000

Or in case of using authorization server authentication, **application.yml**.

    darwin:
      security:
        connectors:
            authorization-server-connector:         # Customise authorization server call time-outs
              connect-timeout: 1000
              pending-acquire-timeout: 1000
              read-timeout: 1000
              max-life-time: 50000

#### Web Applications

For **Web applications** (`Servlet` or `Reactive`), in addition to the above configuration, you can configure properties focused on this type of application:

    darwin:
      security:
        white-list:
          - /controller/hello         # EMicroservice endpoints excluded from validation
          - (...)
        auth-query-parameter: param   # Name of the parameter for authentication token

### Configuration Headers propagation

To configure authentication propagation headers you can use the following example

    darwin:
        core:
            headers:
              enabled: true # Enable/disable propagation headers
              exclude:
                - endpoint: "https://some.api"
                  common: true
                  logging: true
                  security: false
                - endpoint: "https://another.api"
                  common: true
                  logging: true
                  security: true

!!! info "Important"

    When we call to *"https://some.api/\*"* we do not exclude the authentication headears to the propagation.

!!! info "Important"

    When we call to *"https://another.api"* we will exclude the authentication headers to the propagation.

For more information about the Propagation Headers visit [more information](../darwin-spring-boot-core/README.md#propagation-headers)

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## Exposed API

| Name                                                                                                                                              | Type                   | Description                                                                                                                                                                                                                                                                                                                                                                                                                                            | Application Type                          |
|---------------------------------------------------------------------------------------------------------------------------------------------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| [SecurityManagerService&lt;Authentication,Token>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/service/SecurityManagerService.html)                    | SecurityManagerService | Service exposing the mandatory implementation of the main functions of the security libraries.                                                                                                                                                                                                                                                                                                                                                         | <ul><li>NotWeb</li></ul>                  |
| [SecurityManagerService&lt;Mono&lt;Authentication>, Mono&lt;Token>>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/service/SecurityManagerService.html) | SecurityManagerService | Service exposing the reactive implementation of the main functions of the libraries security libraries.                                                                                                                                                                                                                                                                                                                                                | <ul><li>NotWeb</li></ul>                  |
| [TokenService&lt;String, Token>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/service/TokenService.html)                                               | TokenService           | Service that allows to obtain tokens of type BKS or JWT at any point of the non-reactive application and verify a given Token. To obtain tokens it may use STS Service to convert a token found of different type.                                                                                                                                                                                                                                     | <ul><li>NotWeb</li><li>Servlet</li></ul>  |
| [TokenService&lt;Mono&lt;String>, Mono&lt;Token>>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/service/TokenService.html)                             | TokenService           | Service that allows to obtain tokens of type BKS or JWT at any point of the reactive application and verify a given Token. To obtain tokens it may use STS Service to convert a token found of different type.                                                                                                                                                                                                                                         | <ul><li>NotWeb</li><li>Reactive</li></ul> |
| [AuthenticationBearerToken](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/AuthenticationBearerToken.html)                                               | Authentication         | Implementation of the Spring Authentication interface to represent authentication and authorisation with token. In addition to the interface methods, methods for retrieving the various tokens it contains and the issuer are included.                                                                                                                                                                                                               | <ul><li>All</li></ul>                     |
| [Token](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authentication/token/Token.html)                                                                                 | Interface              | Interface that the object to be stored in the reactive security context by the library must comply with. It has methods to retrieve the type of token it stores and its value. In addition, this interface has a getJwtToken() method that in the case that the token is JWT, returns an object org.springframework.security.oauth2.jwt.Jwt. This last object has all the claims accessible through the getClaimAS...(String/Map/Integer....) methods. | <ul><li>All</li></ul>                     |

## Extending the authentication module

This module has been developed with extensibility in mind. It allows applications to implement certain bean lets to extend the functionality.

### Validations performed on JWT tokens

By default, Darwin validates the timestamps of JWT tokens and optionally the issuers and audiences (configurable by parameters). If we want to customize we can define a bean of type `OAuth2TokenValidator<Jwt>` in our application.

Example of customization of JWT token validation. Validate only tokens with the claim sub equals to "uid:n222225". **Reactive and Servlet example**:

    @Bean
    OAuth2TokenValidator<Jwt> validator() {
        List<OAuth2TokenValidator<Jwt>> validators = new ArrayList();

        // Example. Only validate tokens with "sub": "uid:n222225"
        validators.add(new JwtClaimValidator<String>(JwtClaimNames.SUB,
                (sub) -> "uid:n222225".equals(sub)));

        // Always validate timestamp without clockSkew
        validators.add(new JwtTimestampValidator(Duration.ZERO));

        return new DelegatingOAuth2TokenValidator(validators);
    }

### JWT token validators

Darwin adds a `ReactiveJwtDecoder` or `JwtDecoder` bean depending on the type of application (reactive or servlet). This bean validates tokens against an **authorization server** or a **PKM service**, depending on how it is configured.

This **decoder** can be customized by the application.

Example of a decoder that validate a token against a fixed public key

**Example of ReactiveJwtDecoder customization. Reactive application.**

    @Bean
    ReactiveJwtDecoder decoder(OAuth2TokenValidator<Jwt> validator) throws NoSuchAlgorithmException, InvalidKeySpecException {
        var key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo/IrYlNBF5Fs5vMg9VCBumQdotFXrjNiDjE8xaLv3OsD98Sl2p/xLvAq6HX6E9cjz6wSKgv5jGHKvsFcZkFI5BfN/8lYZl+8f/66YxDiauOkVlueG4EESegFqwMlYCNPBbNcAWnvZydnHMr7uwp2cxrhqgo605BCeTGeM9A9rj+edQm6gs2iUqllxDtW/R8odBC+qo7VsFZtam802yVRj0jVAL+rw8MAa4v9wwW856x2Px93oF88FBvh3MAi47OdJ+K7+RyaaT9a6WSPoqcSWSuFRhDqKScwCAs0rzH7HTP0I1gpjbMXNOulMIGnRPsgE7nNQV/kWbIn6RYhsRHHwwIDAQAB";
        RSAPublicKey publicKey = (RSAPublicKey) KeyFactory.getInstance("RSA")
                .generatePublic(new X509EncodedKeySpec(Base64Utils.decodeFromString(key)));

        // Example that validate only against one fixed public key
        var decoder =  NimbusReactiveJwtDecoder.withPublicKey(publicKey)
                .signatureAlgorithm(SignatureAlgorithm.RS256).build();

        // Inject Darwin validator (or application customize validator)
        decoder.setJwtValidator(validator);

        return decoder;
    }

JwtDecoder customization example. **Servlet application**

    @Bean
    JwtDecoder decoder(OAuth2TokenValidator<Jwt> validator) throws NoSuchAlgorithmException, InvalidKeySpecException {
        var key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo/IrYlNBF5Fs5vMg9VCBumQdotFXrjNiDjE8xaLv3OsD98Sl2p/xLvAq6HX6E9cjz6wSKgv5jGHKvsFcZkFI5BfN/8lYZl+8f/66YxDiauOkVlueG4EESegFqwMlYCNPBbNcAWnvZydnHMr7uwp2cxrhqgo605BCeTGeM9A9rj+edQm6gs2iUqllxDtW/R8odBC+qo7VsFZtam802yVRj0jVAL+rw8MAa4v9wwW856x2Px93oF88FBvh3MAi47OdJ+K7+RyaaT9a6WSPoqcSWSuFRhDqKScwCAs0rzH7HTP0I1gpjbMXNOulMIGnRPsgE7nNQV/kWbIn6RYhsRHHwwIDAQAB";
        RSAPublicKey publicKey = (RSAPublicKey) KeyFactory.getInstance("RSA")
                .generatePublic(new X509EncodedKeySpec(Base64Utils.decodeFromString(key)));

        // Example that validate only against one fixed public key
        var decoder =  NimbusJwtDecoder.withPublicKey(publicKey)
                .signatureAlgorithm(SignatureAlgorithm.RS256).build();

        // Inject Darwin validator (or application customize validator)
        decoder.setJwtValidator(validator);

        return decoder;
    }

### Generation of roles from JWT token

Darwin adds the `Converter<Jwt, Collection<GrantedAuthority>>` darwinJwtToGrandAuthoritiesConverter or `Converter<Jwt, Flux<GrantedAuthority>>` darwinReactiveJwtToGrandAuthoritiesConverter object. These objects are responsible for create the user's
GrantedAuthorities in the `Authenticated` object. By default it creates them from the **scp** or **scope** claims of the JWT token.

This object can be customized by the application.

!!! warning

    It is important to use exactly the name darwinJwtToGrandAuthoritiesConverter or darwinReactiveJwtToGrandAuthoritiesConverter, because these beans are injected by name.

Example of customization so that all users have as default role the role USER

For **Reactive application**:

    @Bean
    Converter<Jwt, Flux<GrantedAuthority>> darwinReactiveJwtToGrandAuthoritiesConverter() {
        return new Converter<Jwt, Flux<GrantedAuthority>>() {
            @Override
            public Flux<GrantedAuthority> convert(Jwt source) {
                return Flux.fromStream(Stream.of(new SimpleGrantedAuthority("ROLE_USER")));
            }
        };
    }

For **Servlet application**:

    @Bean
    Converter<Jwt, Collection<GrantedAuthority>> darwinJwtToGrandAuthoritiesConverter() {
        return new Converter<Jwt, Collection<GrantedAuthority>>() {
            @Override
            public Collection<GrantedAuthority> convert(Jwt source) {
                return List.of(new SimpleGrantedAuthority("ROLE_USER"));
            }
        };
    }

### Obtaining the JWT token from the request

The interfaces `ServerAuthenticationConverter` and `BearerTokenResolver` get the JWT token from the request. These objects can be customized.

Attached is an example that gets the token from the `MyAuthentications` header.

For **Reactive application**:

    @Bean
    ServerAuthenticationConverter darwinBearerConverter(AuthenticationProperties authenticationProperties) {
        var bearerTokenConverter = new ServerBearerTokenAuthenticationConverter();
        bearerTokenConverter.setBearerTokenHeaderName("MyAuthorization");
        return bearerTokenConverter;
    }

For **Servlet application**:

    @Bean
    @ConditionalOnMissingBean
    BearerTokenResolver darwinBearerTokenResolver() {
        var bearerTokenResolver =  new DefaultBearerTokenResolver();
        bearerTokenResolver.setBearerTokenHeaderName("MyAuthorization");
        return bearerTokenResolver;
    }

### JWT Token Generation

`Converter<Jwt, AbstractAuthenticationToken>`, `Converter<Jwt, Mono<AbstractAuthenticationToken>>`: Converts the JWT token into the Spring Authentication object, in our case the Darwin implementation `AuthenticationBearerToken`.

!!! warning

    We can return any object that extends `AbstractAuthenticationToken`, but if we do not return an object of type `AuthenticationBearerToken` the authentication, authorization and event modules will not work correctly.

!!! warning

    It is important to use exactly the name darwinJwtToAuthenticationConverter or darwinReactiveJwtToAuthenticationConverter, because these beans are injected by name.

Let's make an example so that users have the USER role as default role.

For **Reactive application**:

    @Bean
    Converter<Jwt, Mono<AbstractAuthenticationToken>> darwinReactiveJwtToAuthenticationConverter() {
        return new Converter<Jwt, Mono<AbstractAuthenticationToken>>() {
            @Override
            public Mono<AbstractAuthenticationToken> convert(Jwt source) {
                return Mono.fromCallable(() -> DefaultToken.builder().createJwt(source).build()).
                        map(token -> new AuthenticationBearerToken(token, token, List.of(new SimpleGrantedAuthority("ROLE_USER"))));
            }
        };
    }

For **Servlet application**:

    @Bean
    Converter<Jwt, AbstractAuthenticationToken> darwinJwtToAuthenticationConverter() {
        return new Converter<Jwt, AbstractAuthenticationToken>() {
            @Override
            public AbstractAuthenticationToken convert(Jwt source) {
                var token = DefaultToken.builder().createJwt(source).build();
                return new AuthenticationBearerToken(token, token, List.of(new SimpleGrantedAuthority("ROLE_USER")));
            }
        };
    }

### Customization of the authorization chain

With the name darwinAuthorizationConfiguration a bean of type DarwinHttpSecurityCustomizer or DarwinReactiveHttpSecurityCustomizer is injected that allows changing the authorization configuration to perform a customized authorization.

!!! warning

    It is important to use exactly the name darwinAuthorizationConfiguration, because these beans are injected by name.

The default configuration is:

For **Reactive application**:

```java
@Bean
@ConditionalOnMissingBean(name = "darwinAuthorizationConfiguration")
DarwinReactiveHttpSecurityCustomizer darwinAuthorizationConfiguration() {
    // All requests must be authenticated and install authentication filter
    // If endpoint ends in info or health allow it
    return (ServerHttpSecurity http) -> http.authorizeExchange(auth -> auth.anyExchange().authenticated());
}
```

For **Servlet application**:

```java
@Bean
@ConditionalOnMissingBean(name = "darwinAuthorizationConfiguration")
DarwinHttpSecurityCustomizer darwinAuthorizationConfiguration() {
    return (HttpSecurity http) -> http.authorizeHttpRequests(authMan -> authMan.anyRequest().authenticated());
}
```

We are going to make an example to customize the user access role to different endpoints and configure the authorization error endpoint. To do this we would have to add to the application configuration:

For **Reactive application**:

```java
@Bean
DarwinReactiveHttpSecurityCustomizer darwinAuthorizationConfiguration() {
    return http -> {
        http.authorizeExchange(authorize -> authorize
                    .pathMatchers("/application-reactive/hello").permitAll()
                    .pathMatchers("/application-reactive/hello2").hasRole("ADMIN")
                    .pathMatchers("/application-reactive/hello3").hasRole("USER")
                    .anyExchange().denyAll()
            );
    };
}
```

For **Servlet application**:

```java
@Bean
DarwinHttpSecurityCustomizer darwinAuthorizationConfiguration() {
    return http -> {
          http.authorizeHttpRequests(authorize -> authorize
              .requestMatchers("/application-servlet/hello").permitAll()
              .requestMatchers("/application-servlet/hello2").hasRole("ADMIN")
              .requestMatchers("/application-servlet/hello3").hasRole("USER")
              .anyRequest().denyAll()
            );
    };
}
```

## Library use cases

The following are use cases, together with examples of how to use the library.

### How to use security services in NotWeb applications

To use the security services, we will only have to inject it in our application by making reference to the types we are going to work with (depending on the desired implementation):

    @Autowired
    private SecurityManagerService<Authentication, Token> securityManagerService;

    @Autowired
    private SecurityManagerService<Mono<Authentication>, Mono<Token>> reactiveSecurityManagerService;

Now, with these Beans we can:

- **Validate/Authenticate a Token**

    Examples:

        String token = "TokenStringValue";
        Authentication resultToken = securityManagerService.authenticate(token); // (1)

        if (resultToken != null && resultToken.isAuthenticated()){
            AuthenticationBearerToken authToken = (AuthenticationBearerToken) resultToken;  // (2)

            Token.TokenType tipo = authToken.getAuthenticationToken().getTokenType();   // (3)
        }

        Mono<Token.TokenType> authToken;

        authToken = Mono.just("TokenStringValue")
                            .flatmap(stringToken ->
                                reactiveSecurityManagerService.authenticate(stringToken))  // (1)
                            .filter(Authentication::isAuthenticated)
                            .cast(AuthenticationBearerToken.class)                  // (2)
                            .map(authToken ->
                                authToken.getAuthenticationToken().getTokenType()); // (3)

    1. Authenticate the token and collect it to check the result.

    2. If it is not null and it is authenticated, we convert it to the type defined by Darwin: `AuthenticationBearerToken`.

    3. Now we can access the authenticated token, the authorisation token, use its methods, and so on.

- **Converting a token**

    Examples:

        String jwtToken = "JWTTokenStringValue";
        Token bksToken = securityManagerService.convert(jwtToken);

        Mono<Token> bksToken = Mono.just("JWTTokenStringValue")
                                .flatmap(stringToken -> reactiveSecurityManagerService.convert(stringToken));

- [Authorising access to a service with a token](../darwin-spring-boot-security-authorization/README.md#exclusive-notweb-authorization-services)

### How to use the reactive security context in a NotWeb application

For this type of application, the security context must be filled in the subscription to the stream that will need it. To do this, we must authenticate and use the result in a new stream at a later stage. Here is an example of how to do this:

    Mono<T> result = Mono.just("TokenStringValue")
                            .flatmap(stringToken ->
                                securityManagerService.authenticate(stringToken))  // (1)
                            .filter(Authentication::isAuthenticated)
                            .flatMap(authToken->
                                workWithSecurityContext()                   // (3)
                                .contextWrite(ReactiveSecurityContextHolder
                                    .withAuthentication(authToken))         // (2)
                            );

1. We authenticate with the token we have.

2. In the subscription to the new stream, we create the security context with the `Authentication` returned in the previous step.

3. When this method is executed, the security context is already loaded correctly.

Now the ***workWithSecurityContext()*** method can retrieve the `Authentication` from the reactive security context to fulfil its function:

    public static Mono<T> workWithSecurityContext(){
        return ReactiveSecurityContextHolder.getContext()
                    .map(SecurityContext::getAuthentication)
                    (...);
    }

### How to get the userId from the security context

#### Non-reactive environments

To get the user from security context in a non-reactive environment:

    …
    Authentication auth = SecurityContextHolder.getContext().getAuthentication(); // (1)
    String userId = auth == null ? null : auth.getName(); // (2)
    …

1. Obtain `SecurityContext` y from this, the `Authentication` instance.

2. If the returned object isn't `null`, get user with `getName()` method.

#### Reactive environments

The way to recover the user from the security context in a reactive environment is:

    …
    Mono<String> userId = ReactiveSecurityContextHolder
                                        .getContext() // (1)
                                        .map(SecurityContext::getAuthentication) // (2)
                                        .map(Authentication::getName); // (3)
    …

1. The context of type `SecurityContext` is retrieved.

2. If the context contains an object of type `Authentication`, it returns it. Otherwise, `null` is returned.

3. An attempt is made to retrieve the value of the user ID by calling the `getName()` method. If it does not exist, `null` is returned.

### How to get tokens in the application

Two implementations of the `TokenService` interface have been created, which will help to obtain the JWT or BKS at any point of the application. Depending on the information found in the contexts, they may use the **Santander Bank Token Conversion
Service (STS)**.

!!! tip "Caution"

    To use the token conversion service (STS) it is necessary to define at least one path to an STS in the property **darwin.security.connectors.sts-connector.sts-endpoint**.

In `Non-Reactive` environments, code example:

     @Autowired
     private TokenService<String, Token> tokenService;

     public String someMethod() {

        // Get BKS token or convert JWT if necessary
        String bksToken = tokenService.getBKSToken();

        // Get JWT token or convert BKS if necessary
        String jwtToken = tokenService.getJWTToken();
     }

In `Reactive` environments, code example:

    @Autowired
    private TokenService<Mono<String>, Mono<Token>> tokenService;

    public String someMethod() {

        // Get BKS token or convert JWT if necessary
        Mono<String> bksToken = tokenService.getBKSToken();

        // Get JWT token or convert BKS if necessary
        Mono<String> jwtToken = tokenService.getJWTToken();
     }

For **NotWeb Applications**: these classes will only be able to return the expected token if one of them (JWT or BKS) is in the security context.

For **Web Applications**: both classes ensure that, whenever we are in an **authenticated request**, we will be able to receive **the used token**. If we have set an **STS endpoint**, we can get **both tokens** without having to worry about anything
else.

!!! note

    In Web application we can also get the BKS token from **BKS-Token** header, but this value cannot be used to convert and obtain the JWT token.

However, if when invoking either of them they are not available or we haven't defined the path to any STS (**darwin.security.connectors.sts-connector.sts-endpoint**) and you need to convert the one you have, a null or MonoEmpty will be returned. An
exception will only be thrown if there is a problem converting the token.

### How to propagate the JWT token

When another microservice has to be called and needs a JWT token, the received token has to be propagated. To do this, the authentication library installs an interceptor in the exposed REST clients, both for RestTemplate and WebClient. This
interceptor propagates the token in the standard 'Authorization' header.

To use this functionality just inject the REST client instance as shown in the following examples.

For RestTemplate:

    ...
    @Autowired
    @DarwinQualifier
    private RestTemplate restTemplate;
    ...

Somewhere in the code another microservice is called, e.g. a POST request:

    ...
    ResponseEntity<String> re = restTemplate.postForEntity("http://server/url", null, String.class);
    ...

For WebClient:

    ...
    @Autowired
    private WebClient webClient;
    ...

For WebClient Builder:

    ...
    @Autowired
    private WebClient.Builder webClientBuilder;
    ...
    ...
    WebClient webClient = webClientBuilder.baseUrl("http://server")
                                          .build();
    ...

Somewhere in the code another microservice is called, e.g. a POST request:

    ...
    String result = webClient.post()
                             .uri("/url")
                             .retrieve()
                             .bodyToMono(String.class);
    ...

For both RestTemplate and WebClient, REST requests will include the JWT token received in the original request if the original request had authentication. If a BKS token was received, the interceptor will convert it to JWT by invoking the Token
Conversion Service (STS).

!!! warning

    If a BKS token needs to be converted to JWT, at least one path must be defined in the **sts-endpoint** property. Failure to do so will result in the header not being propagated and the request will return a *401 Forbidden* if
    it needed to authenticate.

### Alternative methods to retrieve the token

The token value can be retrieved using the getCredentials() method.

#### Retrieving the JWT token in a non-reactive application

For a `NotWeb` or `Servlet` environment after retrieving the `Authentication` object from the security context, the getCredentials() method returns the value of the JWT token with which it was generated. The following example can be used as a
reference:

    ...
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String jwtToken = (String) auth.getCredentials();
    ...

!!! info "Important"

    If the token with which it was generated is BKS, it will be necessary to define the STS in order to convert it.

#### Retrieving the token in a Reactive application

For a `Reactive` environment after retrieving the `Authentication` object from the reactive security context, the method getCredentials() method returns the value of the token with which it was generated, i.e. it could be either a BKS token or a
JWT. The following example can be used as a reference:

    ...
    Mono<String> token = ReactiveSecurityContextHolder
                                        .getContext() // (1)
                                        .map(SecurityContext::getAuthentication) // (2)
                                        .map(Authentication::getCredentials) // (3)
                                        .cast(String.class); // (4)
    ...

1. The security context `SecurityContext` is retrieved.

2. If the context contains an object of type `Authentication`, it returns it. Otherwise, `null` is returned.

3. An attempt is made to retrieve the value of the token by invoking the `getCredentials()` method. If it does not exist, `null` is returned.

4. The `getCredentials()` method returns an object of type `Object`. We change the type to `String`.

### How to disable the library

If you need to disable the library, preventing the installation of Darwin's own configuration, you need to set the following property to `false`:

    darwin:
      security:
        enabled: false

!!! note

    If this property is not set by default its value is 'true' so the library is enabled and self-installed.

It is important to note that disabling Darwin security **does not imply disabling security altogether** since from that moment on, spring security is auto-configured by default.

To completely disable both Darwin and Spring security, in addition to disabling Darwin security as explained above, you must exclude Spring security by default. as explained above, certain configuration classes must be excluded to prevent their
instantiation. This can be achieved in a `Servlet` application:

    ...
    @Configuration
    @EnableAutoConfiguration(exclude = { SecurityAutoConfiguration.class,
                        UserDetailsServiceAutoConfiguration.class,
                        ManagementWebSecurityAutoConfiguration.class })
    public class AppConfig {
    ...
    }
    ...

And for a `Reactive` application:

    ...
    @Configuration
    @EnableAutoConfiguration(exclude = { ReactiveSecurityAutoConfiguration.class,
                        ReactiveUserDetailsServiceAutoConfiguration.class,
                        ReactiveManagementWebSecurityAutoConfiguration.class })
    public class AppConfig {
    ...
    }
    ...

### How to configure CircuitBreaker and Retry to access PKM and STS

For any environment in which PKM and STS are used, the Resilience4j CircuitBreaker and Retry are enabled, in case you want to configure it, the following information has to be taken into account.

The retry and circuit breaker instances configurable in the authentication library are:

- **PKMConnector:** Controls the call to the PKM to access the public encryption key.

- **STSConnector:** Controls the call to the STS to access the token conversion system.

- **PKMFallbackConnector:** Controls the call to the PKM fallback, whose path shall be obtained as the second value in the list giving value to the `darwin.security.connectors.pkm-connector.pkm-endpoint` property.

- **STSFallbackConnector:** Controls the call to the STS fallback, whose path shall be obtained as the second value in the list giving value to the `darwin.security.connectors.sts-connector.sts-endpoint` property.

#### CircuitBreaker

The basic CircuitBreaker properties and their default values are as follows:

- **minimumNumberOfCalls:** The size of the buffer ring when the circuit is closed. The failure rate will not be calculated until this minimum number of calls is registered. The default value is ***100***.

- **permittedNumberOfCallsInHalfOpenState:** The size of the buffer ring when the circuit is half open. This ring is used when the circuit breaker transitions from open to half open to assess the health of the circuit. Failure to exceed the fault
    rate after this number of calls will result in the circuit being closed. The default value is ***10***.

- **waitDurationInOpenState:** The time the circuit breaker must wait before transitioning from open to half open. The default value is ***60*** \[s\].

- **failureRateThreshold:** The failure rate threshold in percent, at which the circuit breaker will open the circuit and start shorting calls. The default value is ***50***.

- \* \* recordFailurePredicate \* The predicate class that evaluates which exceptions should be used to open the circuit. By default the loop will be opened with exceptions corresponding to a HTTP 5xx status of the called server.

If we want to change this configuration the properties must be configured as follows:

    resilience4j.circuitbreaker:
      instances:
        PKMConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 10
          waitDurationInOpenState: 60
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        PKMFallbackConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 10
          waitDurationInOpenState: 60
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        STSConnector:
          minimumNumberOfCalls: 2
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        STSFallbackConnector:
          minimumNumberOfCalls: 2
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 50
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate

!!! note

    For more information about the operation or additional parameters of this CircuitBreaker, please refer to the product documentation: [Resilience4j CircuitBreaker](https://resilience4j.readme.io/docs/circuitbreaker).

#### Retry

The basic Retry properties and their default values are as follows:

- **retryExceptionPredicate:** The predicate class that evaluates which exceptions to retry and which not to retry. By default, exceptions corresponding to a HTTP 5xx status of the called server will be retried.

- **maxAttempts:** The maximum number of retries. By default there will be 3 retries.

- **waitDuration:** A fixed timeout between retries. Default ***500*** \[ms\].

If we want to change these values the properties must be configured as follows:

    resilience4j.retry:
      instances:
        PKMConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        PKMFallbackConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        STSConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        STSFallbackConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500

!!! note

    For more information about the operation or additional parameters of this Retry, please refer to the product documentation: [Resilience4j Retry](https://resilience4j.readme.io/docs/retry).

### How to configure Darwin Authentication WebClient's timeouts

Darwin uses preconfigured WebClients to call PKM and STS services. You can customise them via configuration properties. For example:

    darwin:
      security:
        connectors:
          sts-connector: # Customise STS call timeouts
            connect-timeout: 1000
            pending-acquire-timeout: 1000
            read-timeout: 1000
            max-life-time: 50000
          pkm-connector: # Customise PKM call timeouts
            connect-timeout: 1000
            pending-acquire-timeout: 1000
            read-timeout: 1000
            max-life-time: 50000

### How to add the authentication token as a URL parameter

The library has the ability to perform request authentication by retrieving the token as a URL parameter.

To make an authenticated request containing the token as a URL parameter, use similar code as in the following examples.

For ResTemplate:

    String token_value = "asdfghjklñ";
    ResponseEntity<String> entity = new TestRestTemplate().getForEntity(
                    "http://server:port/endpoint?token=" + token_value,
                    String.class);

An example with WebClient:

    String token_value = "asdfghjklñ";
    String result = webClient.post()
                             .uri("/url?token=" + token_value)
                             .retrieve()
                             .bodyToMono(String.class);

The parameter name is configurable via the `darwin.security.auth-query-parameter` property. In case it is not configured, the library will take the default name (`token`) for the parameter.

## Migration from NUAR to Darwin

Due to the changes made to the logging library, a small migration guide is included for this library only. [Migration guide](../../MIGRATION.md).
