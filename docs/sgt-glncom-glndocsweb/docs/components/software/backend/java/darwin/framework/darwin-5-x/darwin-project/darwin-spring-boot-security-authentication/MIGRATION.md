# Darwin-spring-boot-security-authentication Migration guides

## Version 5.7.1

<!tag:571>

- Change claim name to get appInit from authentication token from `cid` to `cid_tp`.

<!end:571>

## Version 5.0.0

<!tag:500>

- We have changed the parameterization of the `DefaultToken` class, now it is `DefaultToken<T extends Token.TokenType>` instead of `DefaultToken<T extends Token.TokenType, V extends Serializable>`.
We have removed it because the second parameter was not needed. If you are using it, please remove the second parameter so that it compiles correctly.

<!end:500>

## Version 3.2.0-RELEASE

<!tag:320>

- From now on it is necessary to add the cache dependency if you want to use the functionality to cache the authentication tokens.

<!end:320>

## Version 3.1.0-RELEASE

<!tag:310>

- In reactive microservices before 3.1.x version, if a bean of type `SecurityWebFilterChain` was defined, it would substitute the `SecurityWebFilterChain` defined by Darwin. Now it would be necessary that the bean also has the name
    `darwinSecurityWebFilterChain` to substitute.

<!end:310>

## Version 3.0.0-RELEASE

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

In this version there are several changes in packages and classes:

- **We have unified Darwin Security Authentication libraries** into `darwin-spring-boot-security-authentication`, so `darwin-spring-boot-security-authentication-common` has been deleted.

- **We have unified the core of Darwin Authentication library using only Reactive classes and implementations**. To get this target **most of the Servlet classes used for STS, PKM or validation have been deleted** in favor of Reactive classes and
    implementations, in some cases adapted to non-Reactive environments using `ReactorUtils` methods. Also, during this process we deleted some unused classes.

### Deleted classes

These are all the classes that have been deleted and don't have a corresponding one in this version:

- AuthenticationServletSTSAutoConfig

- BKSTokenProperties

- CannotProvideKeyException

- CircuitBreaker(JWT/BKS)Authentication

- DarwinAuthenticationToken

- DarwinAuthenticationTokenCustomizer

- GenerateSessionResponse

- (JWT/BKS)FallbackAuthentication

- RemoteKeyProviderProperties

- SessionException

- SessionRequest

- SignatureException

- STSConversionException

- TokenAuthenticationService

- TokenValidatorFactory

### Moved/Renamed classes

These classes have been moved from Authentication-common directly to Authentication library:

- AuthenticationProperties

- TokenAuthenticationValidator

- TokenAuthenticationValidatorImpl

These classes have been moved from Authentication-common directly to a different package in Authentication library:

| Old                                                                                  | New                                                                                          |
|--------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| es.santander.darwin.security.**credentials.Token**                                   | com.santander.darwin.security.**authentication.token.Token**                                 |
| es.santander.darwin.security.**credentials.bks.credential.BKSValidatableCredential** | com.santander.darwin.security.**authentication.token.BKSValidatableCredential** (DEPRECATED) |
| es.santander.darwin.security.**credentials.bks.credential.BKSToken**                 | com.santander.darwin.security.**authentication.token.BKSToken** (DEPRECATED)                 |
| es.santander.darwin.security.**credentials.jwt.util.JWTTokenUtil**                   | com.santander.darwin.security.**authentication.token.util.JWTTokenUtil**                     |

These are the classes that have been just moved or renamed in this version:

| Old                                                                                                                 | New                                                                                                   |
|---------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| es.santander.darwin.security.authentication.config.**AuthenticationReactiveSTSAutoConfig**                          | com.santander.darwin.security.authentication.config.**AuthenticationSTSAutoConfig**                   |
| es.santander.darwin.security.authentication.interceptor.**JWTInterceptor**                                          | com.santander.darwin.security.authentication.interceptor.**AuthTokenInterceptor**                     |
| es.santander.darwin.security.authentication.interceptor.**JWTFilterFunction**                                       | com.santander.darwin.security.authentication.interceptor.**AuthTokenFilterFunction**                  |
| es.santander.darwin.security.authentication.interceptor.**JWTServletFilterFunction**                                | com.santander.darwin.security.authentication.interceptor.**AuthTokenServletFilterFunction**           |
| es.santander.darwin.security.authentication.interceptor.**JWTReactiveFilterFunction**                               | com.santander.darwin.security.authentication.interceptor.**AuthTokenReactiveFilterFunction**          |
| es.santander.darwin.security.authentication.**reactive.decorator.ServerWebExchangeDecoratorImpl**                   | com.santander.darwin.security.authentication.**decorator.ServerWebExchangeDecoratorImpl**             |
| es.santander.darwin.security.authentication.**reactive.error.AuthenticationError**                                  | com.santander.darwin.security.authentication.**filter.reactive.AuthenticationError**                  |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.AuthenticationBearerToken**            | com.santander.darwin.security.authentication.**AuthenticationBearerToken**                            |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.AuthenticationReactiveManager**        | com.santander.darwin.security.authentication.**filter.reactive.AuthenticationReactiveManager**        |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.DefaultToken**                         | com.santander.darwin.security.authentication.**token.DefaultToken**                                   |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.ReactiveAuthenticationConverter**      | com.santander.darwin.security.authentication.**filter.reactive.ReactiveAuthenticationConverter**      |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.ReactiveAuthenticationSuccessHandler** | com.santander.darwin.security.authentication.**filter.reactive.ReactiveAuthenticationSuccessHandler** |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.UnauthorizedGatewayEntryPoint**        | com.santander.darwin.security.authentication.**filter.reactive.UnauthorizedGatewayEntryPoint**        |
| es.santander.darwin.security.authentication.**reactive.filter.authentication.UnauthorizedMicroserviceEntryPoint**   | com.santander.darwin.security.authentication.**filter.reactive.UnauthorizedMicroserviceEntryPoint**   |
| es.santander.darwin.security.authentication.service.**SecurityService**                                             | com.santander.darwin.security.authentication.service.**SecurityManagerService**                       |
| es.santander.darwin.security.authentication.service.**SecurityServiceImpl**                                         | com.santander.darwin.security.authentication.service.**SecurityManagerServiceImpl**                   |
| es.santander.darwin.security.authentication.service.**SecurityServiceReactiveImpl**                                 | com.santander.darwin.security.authentication.service.**SecurityManagerServiceReactiveImpl**           |

### Unify Servlet/Reactive STS classes

We have unified the classes related to STS service using only the Reactive implementation, so the following changes are made:

- **Removed Servlet STS classes** (AbstractCircuitBreakerSTS, CircuitBreakerSTS, CircuitBreakerSTSFallback and CacheableTokenProvider) in favor of reactive STSConnector implementation.

- **Refactor and update STSConnector implementation**: `STSConnector` now is a reactive interface with methods to call STS and STSFallback services. It's implemented with **AbstractSTSConnector** and `DefaultSTSConnector`. Now there are two
    methods to call STS:

    - *convertJWT*: to convert a JWT Token to BKS.

    - *convertBKS*: to convert a BKS Token to JWT.

- **Moved the Reactive STS connector classes**: es.santander.darwin.security.authentication.**reactive.provider** → com.santander.darwin.security.authentication.**connector.sts**.

- **Refactor TokenProvider**: TokenProvider now is the `STSService` parametrized interface and RemoteTokenProvider is `STSServiceImpl` with a unique method to convert and cache a token conversion. These are located in `authentication.service`
    package

- **TokenConverter and SecurityManagerServiceImpl** now are using a `STSService` object instead of a **CacheableTokenProvider** to convert tokens.

- The `STSResponse` class has been moved from RemoteTokenProvider to **STSConnector**.

### New TokenService interface to replace TokenConverter

Now we are using a `TokenService` interface and their implementations instead of (Reactive)TokenConverter, these classes are located in `authentication.service` package. The following changes are made:

- **Use TokenService for bean injection**:

    - TokenService&lt;String&gt; instead of TokenConverter.

    - TokenService&lt;Mono&lt;String&gt;&gt; instead of ReactiveTokenConverter.

- **Change signature and removed methods from old TokenConverter class**:

    - *getCorpTokenFromHeaders()* → `REMOVED`

    - *@NonNull getCorpToken()* → ***@Nullable getBKSToken()***

    - *getCorpTokenAndSaveIt()* → `REMOVED`

    - *getCorpTokenFromSecurityContext()* → `REMOVED`

    - *@NonNull getJwtToken()* → ***@Nullable getJWTTOken()***

    - *getJwtTokenAndSaveIt()* → `REMOVED`

    - *Optional&lt;String&gt; getJwtTokenFromSecurityContext()* → `REMOVED`

- **Removed methods from old ReactiveTokenConverter class**:

    - *getBKSCorpFromSecurityContextOrHeaderToken()* → `REMOVED`

    - *getBKSTokenFromHeaders()* → `REMOVED`

### Unify Servlet/Reactive PKM connector (provider)

We have unified the classes related to PKM service using only the Reactive implementation, so the following changes are made:

- **Removed Servlet KeyProvider classes** (KeyProvider, RemoteKeyProvider, KeyResponse and RemoteKeyProviderProperties) in favor of reactive PKMConnector implementation.

- **Moved the Reactive PKM connector classes**: es.santander.darwin.security.authentication.**reactive.provider** → com.santander.darwin.security.authentication.**connector.pkm**.

- **Refactor and update PKMConnector implementation**: PKMConnector now is a reactive interface with a method to call PKM service, implemented in `DefaultPKMConnector`. Now the method to call PKM is *getKeyFromPKM*

- **Refactor reactive KeyProvider**: now KeyProvider interface in `PKMService` and RemoteKeyProvider is `PKMServiceImpl`.

    - Removed *getKeyPair* and *getPrivateKey* methods from PKMService.

    - Classes moved to `authentication.service` package.

- Removed `CannotProvideKeyException` class and `KeyProviderEnabled` condition.

- The KeyResponse class has been moved from RemoteKeyProvider to **PKMConnector** as `PKMResponse`.

### Unify Servlet/Reactive verifier

Now we are using (JWT/BKS)Verifier for both validation processes:

- Removed Servlet `(JWT/BKS)TokenVerifier`.

    - The *parse* method from JWTTokenVerifier has been moved to JWTVerifier and marked as Deprecated.

- Now `(JWT/BKS)Verifier` implement a TokenVerifier interface which returns a Token object. Rename their main method from *check* to ***verify***.

- Classes moved to `authentication.verifier` package.

- Removed `SignatureException`.

### Unify Authentication/Token objects for Servlet/Reactive applications

**Now we are using AuthenticationBearerToken and Token implementation** in both Servlet/Reactive applications. Use `AuthenticationBearerToken` and `Token` classes instead of `DarwinAuthenticationToken` and `AuthenticationParameters`
(DarwinUserDetails). Now we only save in the SecurityContext the authentication token (JWT or BKS) and authorization token (OCJwt or JOC) received in the request.

### Refactor PKM and STS WebClient properties

Previously there were common WebClient properties for PKM and STS (called "resttemplate" properties by mistake). Now each connector has their own properties, also PKM and STS endpoints have been moved.

These are the required changes:

| Old                                                     | New                                                                                                                                                         |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| darwin.security.resttemplate.connect-timeout            | <ul><li>darwin.security.connectors.pkm-connector.connect-timeout</li><li>darwin.security.connectors.sts-connector.connect-timeout</li></ul>                 |
| darwin.security.resttemplate.connection-request-timeout | <ul><li>darwin.security.connectors.pkm-connector.pending-acquire-timeout</li><li>darwin.security.connectors.sts-connector.pending-acquire-timeout</li></ul> |
| darwin.security.resttemplate.read-timeout               | <ul><li>darwin.security.connectors.pkm-connector.read-timeout</li><li>darwin.security.connectors.sts-connector.read-timeout</li></ul>                       |
| darwin.security.resttemplate.connection-time-to-live    | <ul><li>darwin.security.connectors.pkm-connector.max-life-time</li><li>darwin.security.connectors.sts-connector.max-life-time</li></ul>                     |
| darwin.security.pkm-endpoint                            | <ul><li>darwin.security.connectors.pkm-connector.pkm-endpoint</li></ul>                                                                                     |
| darwin.security.sts-endpoint                            | <ul><li>darwin.security.connectors.sts-connector.sts-endpoint</li></ul>                                                                                     |

### Other

- `AuthenticationReactiveManager`, `TokenAuthenticationValidatorImpl`, `SecurityManagerServiceImpl` now use TokenService for Token verification.

- **Rename interceptor classes**:

    - *JWTInterceptor* → `AuthTokenInterceptor`

    - *JWT(Servlet/Reactive)FilterFunction* → `AuthToken(Servlet/Reactive)FilterFunction`

<!end:300>

## Version 2.6-RELEASE

<!tag:260>

### Refactor Token interface

In version 2.6, the `Token` interface has been extracted from the `AuthenticationBearerToken` class and located in the package `es.santander.darwin.security.credentials`.

### Swagger Servlet security settings

In version 2.6 it will be necessary to configure the execution order of the `SwaggerConfig` class generated by the archetype, adding to the class the annotation: **@Order(105)**.

<!end:260>

## Version 2.5-RELEASE

<!tag:250>

### Changes Relating to AuthenticationParameters

Before version 2.5 the getCorpToken and getJwtToken methods of the DarwinUserDetails interface only returned the value of the security context, as of version 2.5, in case the required value is not found in the security context, they go to the
request and the STS to look for it.

<!end:250>

## Version 2.X-RELEASE

<!tag:2x0>

### Details for migration of Authentication from NUAR

#### Configuration

The main change in configuration is that the variables no longer "hang" from `es.santander.nuar` now all the configuration properties are inside `darwin`, therefore the typical authentication configuration would be as follows:

> NUAR

    es:
      santander:
        nuar:
          util:
            security:
              pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
              sts-endpoint: https://srvnuarintra.santander.dev.corp/sts

              white-List:
                - /admin/health

    management:
      context-path: /admin
      security:
        enabled: false

    security:
      filter-order: 10
      user:
        name: admin
        password: s3cr3t

> DARWIN

    darwin:
      security:
        pkm-endpoint:
          - https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
        sts-endpoint:
          - https://srvnuarintra.santander.dev.corp/sts
        white-list:
          - /admin/health


    management:
      server:
        servlet:
          context-path: /admin

    spring:
      security:
        filter-order: 10
        user:
          name: admin
          password: s3cr3t

It is important to point out that there are not only changes related to DARWIN but there are also some Spring variables that change due to the update to Spring Boot 2 Specifically, the variables related to security are now found inside `spring` and
the context-path is now defined at the servlet level. On the other hand the variable `management.security.enabled` has disappeared.

#### Changes related to TokenConverter

The TokenConverter class will now always return a token when called or throw an exception if it is unable to convert the object. In no case will it return a null object.

#### Changes Relating to AuthenticationParameters

The `getJwtToken` and `getCorpToken` methods now return an `Optional<String>` to correctly represent the fact that these methods are not capable of always ensuring that each token will be held.

<!end:2x0>
