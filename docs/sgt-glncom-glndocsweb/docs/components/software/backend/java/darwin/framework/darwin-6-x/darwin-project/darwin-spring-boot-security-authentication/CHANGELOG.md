# Change Log

## 6.2.0 Version

<!tag:621>

### 📔 Documentation

- Fixed error in authentication documentacion related to *Customization of the authorization chain*.

<!end:621>

## 6.2.0 Version

<!tag:620>

### ⭐ New Features

- Added `coreUserId` claim extraction from JWT tokens to DarwinContext.

<!end:620>

## 5.7.1 Version

<!tag:571>

- Change claim name to get appInit from authentication token from `cid` to `cid_tp`.

<!end:571>

## 5.7.0 Version

<!tag:570>

- Added new properties to configure content security policy.

<!end:570>

## 5.4.0 Version

<!tag:540>

- Fixed a problem in which the propagation of BKS token could trigger an error in @Async methods for servlet applications by including BKS_TOKEN in Darwin Context if it is present in the request.

<!end:540>

## 5.3.0 Version

<!tag:530>

- Support the use of `cid` JWT token claim as App-Init in application context.
- Save `client_id` JWT token claim in application context.

<!end:530>

## 5.0.0 Version

<!tag:500>

- Remove unnecessary cast to AuthenticationBearerToken in AuthTokenReactiveFilterFunction and TokenServiceReactiveImpl classes.
- We have changed the parameterization of the `DefaultToken` class, now it is `DefaultToken<T extends Token.TokenType>` instead of `DefaultToken<T extends Token.TokenType, V extends Serializable>`.
- Validate authentication properties without use Spring bean `configurationPropertiesValidator`.
- Fix RestTemplate/WebClient BeanPostProcessor creation to avoid creating CoreProperties early
- Unify the Darwin Interceptors creation to improve the performance.

<!end:500>

## Version 4.3.2-RELEASE

<!tag:432>

- Fix a bug with Authentication interceptors that were added twice when a WebClient bean was created
from a Spring WebClient.Builder bean.

<!end:432>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Fixed Error test caused by ClassCastException, when Try to cast into AuthenticationBearerToken
- Necessary changes to allow channel from Jwt token to be use in logging module.

<!end:420>

## Version 4.1.1-RELEASE

<!tag:411>

- Retrieve channel from Jwt token (if it exists).

<!end:411>

## Version 4.1.0-RELEASE

<!tag:410>

- Enabled Authentication tests with AOT process errors.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- `SecurityContextThreadLocalAccessor` is registered in `io.micrometer.context-propagation` to progress security context.

- Add authenticationEntryPoint to ServerHttpSecurity in `DarwinReactiveHttpSecurityCustomizer` Bean.

<!end:400>

## 3.2.6-RELEASE Version

<!tag:326>

- Fix error when `darwin.core.headers.enabled` is false and we are using `darwin-spring-boot-starter-authentication`

<!end:326>

## 3.2.0-RELEASE Version

<!tag:320>

- Specify String as token value in default Token implementation.

- To improve traceability, the HttpClient wiretap can now be enabled from config.

- Using permitAll() instead of ignoring() approach.

- Improve `darwin.security.audience` description.

- Now Darwin Core can enable/disable the propagation headers.

<!end:320>

## 3.1.4-RELEASE Version

<!tag:314>

- Fix: Remove `ErrorPageSecurityFilter` bean creation as workaround to allow dispatch error page
  when using **HttpServletResponse.*sendError*** with 401 and 403 Http status codes.

<!end:314>

## 3.1.0-RELEASE Version

<!tag:310>

- Solve issue when audience properties is empty

- Using Spring Security classes in authentication to improve extensibility.

- Improve documentation about extensibility

- Add support for using authorization server
  instead of PKM for validate tokens

- Support for Spring Roles with GrantedAuthorities

- Give access to all claims of JWT token with new method getJwtToken in Token

- Internal implementation changes:

    - Deleting EmbeddedNetty configuration class from the AbstractBaseWebClientTest class and all its dependencies.

    - Remove Gateway authentication support

    - Remove use of es.santander.darwin.contracts dependency

    - Remove use of logging baggage for servlet

    - Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

<!end:310>

## 3.0.3-RELEASE Version

<!tag:303>

- The way of creating a HttpClient has changed with the new version of reactor-netty.
  To maintain the back compatibility, HttpClient MaxConnections property is set to 500
  (default values is calculated according to the number processor).

<!end:303>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- **Reduce NotWeb configurations to one which includes HttpClients**:

    - Replace NotWebWithHttpClient references with `NotWeb`.

    - Remove `org.apache.httpcomponents:httpclient` dependency from **Darwin Authentication library**
      and **Darwin Starter Authentication** (now is a transient dependency).

- **Unify authentication libraries** (remove `darwin-spring-boot-authentication-common` library).

- **Unify Servlet/Reactive token conversion with STS** using only reactive implementations

    - **Remove Servlet STS connection classes**.

    - **Unify and refactor reactive STSConnector** classes to: `STSConnector` interface and **AbstractSTSConnector** and `DefaultSTSConnector` class implementations placed in `authentication.connector.sts` package.

    - **STSResponse** class moved as inner class of STSConnector.

    - Refactor **(Remote)TokenProvider** classes to `STSService(Impl)` with a unique "convertToken" method and move them to `authentication.service` package.

    - **Remove AuthenticationServletSTSAutoConfig** and rename AuthenticationReactiveSTSAutoConfig to `AuthenticationSTSAutoConfig`.

    - **Replace STS Resilience4j annotations with Resilience4j API**

- **Unify Servlet/Reactive PKM** connection using only reactive implementations

    - **Remove Servlet KeyProvider classes.**

    - **Unify and refactor reactive PKMConnector** classes to: `PKMConnector` interface and `DefaultPKMConnector` class implementations placed in `authentication.connector.pkm` package.

    - Refactor **(Remote)KeyProvider** to `PKMService(Impl)` with a unique "getPublicKey" method and move them to `authentication.service` package.

    - **Remove `KeyProviderEnabled` condition and `CannotProvideKeyException`.**

    - Move and rename **KeyResponse** from RemoteKeyProvider to `PKMResponse` as inner class in PKMConnector.

    - **Replace PKM Resilience4j annotations with Resilience4j API**

    - **Add "Accept" header with application/json** value to PKM WebClient.

- **Unify Servlet/Reactive verification classes** using only reactive implementations

    - **Remove servlet `(JWT/BKS)TokenVerifier` classes**.

    - **Create `TokenVerifier` interface**, implemented by reactive (JWT/BKS)Verifier classes.

        - Rename their main method to ***verify***

    - Remove `SignatureException`.

    - Mark `BKSValidatableCredential` and `BKSToken` as **Deprecated**.

- **Rename SecurityService** (and implementations) to `SecurityManagerService`

- **Refactor TokenConverter classes to new `TokenService` implementations** to obtain and verify Tokens

    - New `TokenService` interface with methods to obtain and verify Tokens.

    - Refactor **(Reactive)TokenConverter** and their methods to `TokenService(Reactive)Impl`, now they implement only two methods to obtain tokens: *getBKSToken()* and *getJWTToken()*.

    - **Implement verification method in `AbstractTokenServiceVerifier`** using (JWT/BKS)Verifier classes.

        - Use TokenService to verify Tokens instead of TokenVerifiers in **AuthenticationReactiveManager**, **TokenAuthenticationValidatorImpl** and **SecurityManagerService** implementations.

    - **Create TokenService parametrized beans** for bean injection.

    - Now, getBKSToken() method from TokenServiceReactiveImpl (old ReactiveTokenConverter) works like Servlet implementation: first check SecurityContext, else check headers and finally convert.

- **Unify `AuthenticationBearerToken` and `Token` uses for Servlet/Reactive applications**

    - Remove previous Servlet Authentication classes: `DarwinUserDetails`, `AuthenticationParameters`, `TokenCallerInfo`, `DarwinAuthenticationToken` and `DarwinAuthenticationTokenCustomizer`.

    - `TokenVerifier` implementations now returns Token objects with the verified token.

    - Remove *get(JWT/BKS)TokenAndSaveIt()* methods from **TokenServiceImpl**.

    - Update `TokenAuthenticationValidatorImpl`, `SecurityManagerServiceImpl` and `TokenServiceImpl` to work with AuthBearerToken and Token within the SecurityContext.

    - **Remove Authentication objects customization** in Servlet applications.

- **Remove unnecessary Servlet validation classes**: `TokenValidatorFactory` and `TokenAuthenticationService` (and implementations)

    - `TokenAuthenticationValidatorImpl` and `SecurityManagerServiceImpl` now implement token validation using directly **TokenService**.

    - `BKSVerifier` now expect a **Token** instance instead of an **AuthenticationBearerToken**.

- Delete deprecated properties.

    - Delete deprecated property `darwin.security.STS-retries`.

    - Update README, property removed `darwin.security.omnichannel`.

- Use "**buildErrorModel**" method instead of removed (deprecated) "**buildFromException**" in TokenAuthenticationEntryPoint.

- Update the metadata files with all defined properties and those that have been deprecated.

- **Refactor classes/packages**:

    - Remove deprecated Servlet session features.

    - Public AuthenticationBearerToken constructor.

    - **Rename BKSTokenValidator and JWTTokenValidator** to `BKSTokenVerifier` and `JWTTokenVerifier`.

- **Remove the use of `WebSecurityConfigurerAdapter`** (used in TokenConfigurerAdapter subclass) in favour of `SecurityFilterChain` bean configuration:

- Dependencies and plugins upgrade:

    - `hystrix-javanica` dependency is deleted.

    - `spring-cloud-config-client` with scope test dependency is deleted.

    - Removed bootstrap.yml from test/resources folder.

- `spring-cloud-loadbalancer` dependency is deleted.

- **Refactor STS and PKM connector's properties**.

    - PKMConnectorProperties and STSConnectorProperties extend WebClientConfigProperties class from CoreProperties instead of define their own properties

    - Expect an instance of this CoreProperties.WebClientConfigProperties class in buildCustomWebClient method instead of AuthenticationProperties.

- Use `darwin-spring-boot-cache` dependency to compile instead of `darwin-spring-boot-starter-cache`,
  it is used only in test scope and is included in `darwin-spring-boot-starter-authentication`.

- Update deprecated methods: Signal#getContext() and StingUtils.isEmpty()

- Resolve possible XSS issue in TokenAuthenticationEntryPoint

    - Use HttpStatus.UNAUTHORIZED value instead of magic number.

- **Using `HttpClient` instead of TcpClient** in order to create connectors of the WebClient.

- Remove unnecessary WebClien.Builder clones.

- Performing **warm-up for Authentication HttpClient**.

- Remove in all parts of the FW the property `allow-bean-definition-overriding`

- **Using @ConditionalOnMissingBean** in @Bean's that they could be overwritten.

- **Using new API of Reactor**.

    - Deleting use of doOnError(error) operator to throw new exceptions. OnErrorMap is used instead.

    - Using Mono.defer(supplier) into SwitchIfEmpty operator when a Mono.error(throwable) is defined. The target of this use is to avoid creating the exception during assembly time.

    - Using new getContextView() function from Signal object to access the values of the Reactor context.

    - Using new Reactor Context API to access and to write the security Context

- **Update and rename interceptor classes**:

    - *JWTInterceptor* → `AuthTokenInterceptor`

    - *JWT(Servlet/Reactive)FilterFunction* → `AuthToken(Servlet/Reactive)FilterFunction`

    - Improve **AuthTokenReactiveFilterFunction**'s reactor code.

    - Now these classes implements their own methods to get BKS token from Contexts (without calling STS) as TokenService don't expose a method for it.

- BugFix for WebClient customization: now all WebClient properties can be configured without any binding with other properties.

- Remove unused `STSConversionException`

<!end:300>

## 2.11.1-RELEASE Version

<!tag:2111>

- Integrating authorization fix for misbehavior with the OC headers propagation.

<!end:2111>

## 2.10.5-RELEASE Version

<!tag:2105>

- Added CopyContextFilterFunction to PKMConnector when it is used in Servlet applications.

<!end:2105>

## 2.10.3-RELEASE Version

<!tag:2103>

- In ReactiveAuthenticationSuccessHandler get the TraceContext of the reactive context instead of the MDC to update the userId.

<!end:2103>

## 2.10.0-RELEASE Version

<!tag:2100>

- Fix misbehavior. JWT Reactive interceptor must not manage exceptions thrown by the WebClient invocation.

- Added maxLifeTime to WebClients.

- Setting `connectionTimeToLive` RestTemplate property to 60000.

<!end:2100>

## 2.9.0-RELEASE Version

<!tag:290>

- WebClient configuration has changed. RestTemplate properties, allow overwriting default Core webclient value.

- Setting up an audience list instead of a single audience it's now allowed.

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

<!end:290>

## 2.8.2-RELEASE Version

<!tag:282>

- A fix for the cases when the `app-key` was not propagated correctly in the `PKM` calls has been applied.

<!end:282>

## 2.8.0-RELEASE Version

<!tag:280>

- The `ServletSecurityService` and `ReactiveSecurityService` classes referring to notWeb environments have been renamed to `SecurityServiceImpl` and `SecurityServiceReactiveImpl` respectively. The class use is changed to the interface
    `SecurityService` in `SecurityServiceImplTest` and `SecurityServiceReactiveImplTest` tests.

- The functionality of being able to reject JWT tokens by audience and issuer in reactive environments has been added.

<!end:280>

## 2.7.0-RELEASE Version

<!tag:270>

- Actuator endpoints have been added to the authentication filter exception list for servlet applications.

<!end:270>

## 2.6.2-RELEASE Version

<!tag:262>

- Swagger endpoint management has been added to the authentication filter.

<!end:262>

## 2.6.0-RELEASE Version

<!tag:260>

- Instead of using resilience4j-spring-boot2, `resilience4j-spring-cloud2` has been added in order to allow refreshing of resilience4j properties.

- We have moved here the `resilience4j-spring-cloud2` and `resilience4j-reactor` dependencies from Core to avoid unnecessary transitive dependencies.

- The code created to solve an issue in the fallback of previous versions of resilience4j has been deleted.

- `spring-boot-starter-actuator` dependency with **test scope** has been added in **authentication-common** in order to cover dependencies previously obtained from **darwin-spring-boot-core**.

- Support for not-web applications of the authentication-common module::

    - Direct dependencies with `spring-boot-starter-web`, `spring-beans`, `spring-context` and `spring-cloud-starter-netflix-hystrix` have been removed.

    - `reactor-netty` dependency has been marked as optional.

- Support for non-web applications of the authentication module::

    - The use of `spring-boot-starter-webflux` is **replaced** by the use of `spring-webflux` and includes `httpclient` and `reactor-netty` with runtime scope.

    - The dependency on `spring-boot-actuator-autoconfigure` is marked as **optional** as it is only needed for web applications.

    - The auto-configuration is modified in order to load the beans that allow validating a token against the PKM and converting a token with the STS **also from a not-Web application** (using a Servlet or Reactive security context):

        - The `AuthenticationServletAndBaseAutoConfig` and `AuthenticationReactiveAndBaseAutoConfig` classes have been created in order to load the beans that provide these functionalities in a not-web application or in a web application with the
            corresponding environment.

        - The **ServletSTSAutoConfiguration** and **ReactiveSTSAutoConfiguration** classes have been renamed to `AuthenticationServletSTSAutoConfig` and `AuthenticationReactiveSTSAutoConfig` respectively, in order to standardize the configuration
            classes names.

        - The **ServletAuthenticationAutoConfiguration** and **ReactiveAuthenticationAutoConfiguration** classes have been renamed to `AuthenticationServletAutoConfiguration` and `AuthenticationReactiveAutoConfiguration` respectively, in order to
            standardize the configuration classes names.

        - Defining `AuthenticationAutoConfiguration` as **single startup class** in order to load all the application environment configuration.

        - All configuration classes have been marked with `proxyBeanMethods = false`.

- New services for not-web applications:

    - The `ServletSecurityService` and `ReactiveSecurityService` classes have been created from the **SecurityService** interface, and one bean of each is exposed so that **Not-Web applications** can easily validate or convert tokens and authorize
        access to a resource.

- **@EqualsAndHashCode** annotation from `DarwinAuthenticationToken` has been modified and has been added to `AuthenticationParameters` and `DefaultToken` in order to correctly compare DarwinAuthenticationToken and AuthenticationBearerToken
    objects.

- The default position of the `WebSecurityConfigurerAdpater` (100) has been set for the `TokenConfigurerAdapter` (instead of the one we configured (2)).

<!end:260>

## 2.5.0-RELEASE Version

<!tag:250>

- The library that implements CircuitBreaker and Retry has been changed from Hystrix to Resilience4j in the call to PKM in Servlet environment

- The library that implements CircuitBreaker and Retry has been changed from Hystrix to Resilience4j in the call to STS in Servlet environment

- Classes with Authentication properties have been unified into a single authentication-common class

- The **sts-endpoint** property is no longer mandatory for both environments: an auto-configuration is created for each environment that configures the beans needed for the STS in case the property is used.

- The getCorpToken and getJwtToken methods of the AuthenticationParameters class now go to the STS to find the token if they don't have it and then save it in the security context. When it comes to the case of getCorpToken, we previously tried to
    get the token from the BKS-Token header. If it is not found, we go to the STS.

- We have limited the circuit-breaker opening for PKM and STS only for 5XX errors.

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- Resilience4j CircuitBreaker and Retry are added to the STS call in Reactive environments.

- Resilience4j CircuitBreaker and Retry are added to the PKM call in Reactive environments.

<!end:243>

## 2.4.1-RELEASE Version

<!tag:241>

- The HttpOmniChannelReader class now retrieves the contact-point from the Darwin context instead of the request attributes.

- Both reactive and servlet matchers are modified to let the health and info actuators pass when they are raised in a different port. When the they are in the same port they will have token security, eliminating the previous basic security they
    had.

- The condition "ConditionalOnMissingBean" is removed to create the TokenConverter.

- The log level has been changed to warning and the stackTrace has been suppressed when authentication exceptions (not due to internal errors) are thrown, the stackTrace of these is traced at debug level.

<!end:241>

## 2.3.3-RELEASE Version

<!tag:233>

- TokenConverter and ReactiveTokenConverter have been modified to return an "empty" **corporate token (BKS)** when it is not defined in the "BKS-Token" header and there is no Authentication in the security context.

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- TokenConverter and ReactiveTokenConverter have been modified to return an **JWT** "empty" token when there is no Authentication in the security context.

- The interceptors have been modified to not propagate the "Authorization" header if the JWT token is empty (there is no Authentication in the security context).

- Now, the library use webClient (instead of restTemplate) for "Servicios Comunes" invocations.

<!end:232>

## 2.3.1-RELEASE Version

<!tag:231>

- The vulnerabilities detected by Fortify tool have been fixed.

<!end:231>

## 2.3.0-RELEASE Version

<!tag:230>

- Starting with this release, it will no longer be necessary to mark beans of type WebClient and WebClient.Builder with the @DarwinQualifier annotation. At application startup, all WebClient and WebClient.Builder type beans will be detected, and
    the JWTServletFilterFunction interceptor will be injected for `Servlet` environments. Also the JWTReactiveFilterFunction interceptor for `Reactive` environments. This will be the default behavior, and you can disable it through the
    darwin.core.webclient.enabled = false property.

- The getContactPoint() method of DarwinUserDetails.java has been deprecated. From now on, the Contact Point will be obtained from the Darwin Context directly.

- The library scope has been extended to support `Reactive` environments. The library now allows the use of its functionality both in applications developed with Spring-MVC and Spring-WebFlux.

- The Token interface has been added as a wrapper for storing the authentication token within the reactive security context.

- The ReactiveTokenConverter class has been created as a service to obtain both the corporate token and the JWT token.

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- The bug where JWTFilterFunction was not being injected in @Darwin WebClient.Builder has been fixed.

<!end:220>

## 2.1.1-RELEASE Version

<!tag:211>

- We added a Builder for the DarwinAuthenticationToken class.

- We added the DarwinAuthenticationTokenCustomizer interface to be able to perform customizations by injecting beans in the DarwinAuthenticationToken construction.

- TokenAuthenticationValidatorImpl class have been modified to include the call to the DarwinAuthenticationToken customization beans.

<!end:211>

## 2.1.0-RELEASE Version

<!tag:210>

- A filter for Webclient has been created. This filter, propagates the JWT token as authorization header and the BKS token if it has been retrieved from Zuul.

- Calls made to both PKM and STS are switched to using WebClient instead of RestTemplate.

<!end:210>

## 2.0.2-RELEASE Version

<!tag:202>

- When a BKS token is requested with TokenConverter class, this will first look if it has received it through headers and if not, it will try to obtain it by converting the JWT token.

- The ability to propagate the BKS token received from Zuul has been included in the JWT interceptor.

<!end:202>
