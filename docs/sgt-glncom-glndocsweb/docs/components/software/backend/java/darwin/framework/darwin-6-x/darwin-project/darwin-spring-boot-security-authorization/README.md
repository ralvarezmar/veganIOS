# Darwin Spring Boot Authorization ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Security Authorization` library, through the authorization filter and the use of the different existing Operational Controls, is in charge of determining whether a user, operating on his own behalf or on that of a client, can
execute a certain operation.

The authorization filter will not allow access if it cannot obtain the data required for validation. Therefore, they must be informed in order to apply operational control. These are:

- **Client**: optional, code identifier and type of person.

- **Contract**: optional, if the operation is associated with a contract, it is necessary to obtain the contract code.

Two areas of operational control are distinguished:

- **Channel Operational Control**: performs the validations related to the status of the contract in the channel for the user and customer.

- **Business Operational Control**: performs the validations related to the type of intervention of the client regarding the contract to which the operation to be executed applies.

!!! info "Important"

    Authorization module only implements the requirements of the operational security of Spain and Portugal. It doesn't cover other regions or business.

## Technical solution

The authorization filter currently allows the validation of the access to a protected resource through the use of traditional Darwin operational security or through Multi-entity operational security.

Both authorization processes are functionally very similar. However, the Multi-entity logic has been optimized to reduce the number of queries to the Operational Control service and the token validations before and after the service call have been
improved. The authorization logic of each mode is detailed in the following diagrams:

### Traditional Darwin Logic

![Darwin Logic](../../images/logicaAuthorization.png)

### Multi-entity logic of the Authorization filter

![Multi-entity logic](../../images/logicaAuthorizationMultientity.png)

The **non-reported claims** in the JOC token that will result in calls to the Operational Control service (after pre-validation) or in error 403 (after post-validation) are the following depending on the scope:

- **CHANNEL**

    - channel

    - operativeControlChannel

- **BUSINESS**

    - channel

    - operativeControlContract (at least with one entry in the dictionary)

    - clientCode y clientType (optional, but if they are informed, they must both come)

- **BOTH** (all of the above)

JOC token example (with all claims complete)

    eyJraWQiOiJsY3NhbmpvY2dlbmtleWNlcnQxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJ1aWQ6eDAyMTA5NiIsImlhdCI6MTYyMDY4MTc5NiwibmJmIjoxNjIwNjgxNzk2LCJleHAiOjI2MjA2ODE3OTYsImlzcyI6IkxDU2FuSk9DR2VuIiwianRpIjoiOTNhNWIzNmMtNTA4Ni00ZDJmLWIyNGYtYmZjNmJkYTI1ODZlIiwiY2hhbm5lbCI6IkNJQyIsIm9wZXJhdGl2ZUNvbnRyb2xDaGFubmVsIjoiTyIsImNsaWVudENvZGUiOiI5ODc2NTQzMjEiLCJjbGllbnRUeXBlIjoiSiIsIm9wZXJhdGl2ZUNvbnRyb2xDb250cmFjdCI6eyI5OTk5LTAwMDAtOTk5LTAwMDAwMDAiOiJDIn19.hKA0PMsZvMTfrm45zaAT6mnCu8lj93uwWMu9moD_aourlkAx2Rb_gHkjkw2c45jYvSbMqBWSS8Q4eaHnRDJ-W_OiqXHFFhg8YLlHEptqd46081zto_8qvDY3U8nktiKQ4kVOBxO2EEUUDLwPyT7D4nYZWPQ1ATeG-9Wn5vHLPHtdLeIxzvhvVyOuhPrAKAKRxORThkWrbgm2yjJhYCQCaDdj0oy6Zl7Ex76hnR3S_nv054fvFM6Afjuc8XjsQk2EAr8T2v_-E7hX1Eon6ymDA_RphYbt0EPBuExLJCisallxhs84gOnliR1QQJiXvNzuSPfGU7vdO3K8GMpKAqfEcg

    HEADER
    {
      "kid": "lcsanjocgenkeycert1",
      "typ": "JWT",
      "alg": "RS256"
    }
    PAYLOAD
    {
      "sub": "uid:x021096",
      "iat": 1620681796,
      "nbf": 1620681796,
      "exp": 2620681796,
      "iss": "LCSanJOCGen",
      "jti": "93a5b36c-5086-4d2f-b24f-bfc6bda2586e",
      "channel": "OFI",
      "operativeControlChannel": "O",
      "clientCode": "987654321",
      "clientType": "J",
      "operativeControlContract": {
        "9999-0000-999-0000000": "C"
        "1234-1234-123-1234567": "O"
      }
    }
    SIGNATURE
    (RSASHA256...)

### Solution integration

The authorization filter, through the Darwin and Multi-entity operational security services, will or will not allow access to a certain resource.

Each application must define the following attributes for each of the methods that are protected by the authorization filter:

- **Scope**: it will indicate if it implements channel logic, business logic or both.

- **Type of operation**: consultative or operational.

- **Contract Y/N**: it will indicate whether the operation is associated with a contract or not.

- **Client Y/N**: it will indicate if the operation deals with a client resource.

In the case of web applications, to avoid carrying out the validations in all the components, the operational control information will be included in a token that will be transmitted in the calls between them through the header
**X-Control-Operativo** when the Darwin operational security has been applied, and the header **X-Santander-OC** when the Multientity operational security has been applied. Additionally, in both cases, the header **X-Santander-Channel** will be
transmitted, indicating the input channel on which the execution started.

Example of interaction between microservices and Darwin operational control services

![Darwin technical solution](../../images/authorizationSolTec.png)

Interaction example between microservices and Multi-entity operational control services

![Multi-entity technical solution](../../images/authorizationSolTecMultientity.png)

## Functionalities

`Darwin Spring Boot` auto-configuration will detect the type of application it is running in,
autoconfiguring only those functionalities that apply to that environment.

Visit the [Darwin Flavours section](../../ABOUT.md#darwin-flavours)
to get more info about how to work the application type detection.

The library will autoconfigure only those functionalities that apply to the environment in which the application is located.

!!! note

    Both the supported functionality and the use of the library will be equivalent in both Web implementations (Servlet/Reactive), so it will be integrated automatically for projects.

!!! info "Important"

    The authorization process that makes use of Multi-entity operational security is only available for web-type applications, both `REACTIVE` and `SERVLET`.

### NotWeb Application

The library has the following **basic functionalities**:

#### Authorization Parameters

Parameters have been defined with which to define the authorization required for an operation. These parameters are:

- **Scope**: defines whether the operation must be validated against the Channel Operational Control or the Business Operational Control. An enumeration has been created that contains the two possible values: `Scope.CHANNEL` and `Scope.BUSINESS`.

- **OperationType**: defines whether the operation to validate is of an operational or consultative type. An enumeration has also been created with the two possible values: `OperationType.OPERATIVE` and `OperationType.CONSULTIVE`.

- **Client**: defines if the client value should also be checked in the operation (true or false).

- **Contract**: if the **BUSINESS scope** has been defined, it will be used to define if the contract value should be checked in the operation (true or false).

Later on, the existing [Authorization rules](#authorization-rules) are defined based on the values of these parameters.

#### Interceptors

An `interceptor` is included in the **RestTemplate** beans, and **Webclient and WebClient.Builder** that inserts/propagates the header with the Operational Control token in the request **if it exists in the security context**. In the
**RestTemplate** an `OCInterceptor` will be injected and in the **WebClient/WebClient.Builder** an `OCServletFilterFunction` and an `OCReactiveFilterFunction` will be injected.

!!! warning

    It is necessary for the project to register a bean of type `WebClient.Builder` or `WebClient` for the instrumentation to be applied. If the project instantiates a `WebClient` with the keyword `new`, the instrumentation will
    **NOT** work.

#### WebClient bean properties

`Spring Boot` provides by default a `Bean` of type `WebClient.Builder`, which Darwin pre-configures for the application. By default, the settings that apply to the Timeouts associated with the connection, and the properties associated with the
connection pool, are globally defined in the properties `darwin.core.webclient.` But there is the possibility of customizing them only for the Operational Control, defining the values in the properties `darwin.security.authorization.webclient.`

#### Cache

REST calls to Control Operations are cached if the application has a cache enabled and configured.

In this way, the response in authorization validations is streamlined, avoiding repeating a REST call twice with the same input parameters as long as we have a valid token.

The authorization library uses different **cachenames** depending on the operational control that is invoked.

For Darwin operational security services, you have the following **cachenames**:

- channelOperativeControl

- businessOperativeControl

For Multi-entity operational security services, the following **cachenames** are available:

- globalMultiEntityOperativeControl

It is important to configure such caches in the cache service that the application uses.

!!! info "Important"

    The authorization process that makes use of Multi-entity operational security is only available for web-type applications, both `REACTIVE` and\` SERVLET\`.

#### Circuit Breaker and Retry

The library makes use of Resilience4j for the implementation of Retry and CircuitBreaker when accessing Operational Control.

By default, it will try to call each Control Operative 3 times in case of an exception response produced by an error in the server (Http Status 5XX), both for the main routes of the service and in the routes defined as fallback. In case of not
getting a different response to a server error (Http Status 5XX), it will return an UNAUTHORIZED.

The Retry and Circuit Breaker instances in the authorization library are:

- **COConnector:** Controls calls to Darwin Operational Control to obtain the authorization token.

- **COFallbackConnector:** Control calls to Darwin Operational Control fallbacks in case the main ones do not respond correctly.

- **MultiEntityCOConnector:** Controls calls to Multientity Operational Control to obtain the authorization token.

- **MultiEntityCOFallbackConnector:** It controls the calls to the fallbacks of the Multi-entity Operational Control in case the main ones do not respond correctly.

- **BolaSegPortugalConnector**: Control calls to Portugal operative control service in order to validate contracts and cards.

Examples are included below for [customize these implementations](#how-to-set-up-the-circuitbreaker-and-retry).

!!! info "Important"

    The authorization process that makes use of Multi-entity operational security is only available for web-type applications, both `REACTIVE` and `SERVLET`.

#### Exclusive NotWeb authorization services

In a ***EXCLUSIVE*** way for `NotWeb` applications, two beans are exposed with two kind of implementations (non-reactive and reactive) of the `AuthorizationService` interface: `AuthorizationService<Mono<Authentication>> reactiveAuthorizationService`
and `AuthorizationService<Authentication> servletAuthorizationService`. These component expose the following functionality depending on the country where the application is running:

By default, Spain Authorization services will exposed by the configuration. If some application need to use the Authorization services for applying operative security another country, it will be necessary to configure the
`darwin.security.authorization.manual.mode`.

- Spain: Allows to execute operative security for Spain applications authorising the access of the user associated to the existing token **in the security context** to the operation defined by the authorization parameters.

!!! warning

    This functionality requires a validated token in the security context, therefore it is integrated into the [Security services](../darwin-spring-boot-security-authentication/README.md#tokenservice), and
    it will be **MANDATORY** to be used from those services.

- Portugal: Allows to execute operative security for Portugal applications passing contracts validation, cards validation, or both validations.

!!! warning

    For cards validations, it is necessary to have a security token in the Security Context. In order to do that, Darwin offers a [Security
    services](../darwin-spring-boot-security-authentication/README.md#tokenservice) that they can be used in order to validate a security token and to store it in the Security Context. For BolaSeg services, it should use the
    `authentication` method only.

In order to expose Portugal Authorization services, it is necessary to use the following configuration:

    darwin:
      security:
        authorization:
          manual:
            mode: PORTUGAL

#### Channel white-list

The authorization filter has a white list that allows you to disable operational security for a specific channel. To do this, it is as simple as defining the name of the channel in the list. Optionally, next to the channel, the scope parameter can
be specified, with two possible values: COC and CON. Thanks to this parameter, instead of completely disabling operational security, it will allow disabling only the operational control of a security scope (Channel Operational Control or Business
Operational Control).

The channel whitelist will behave as follows:

- The list defines **only** the channel name or the channel name together with the parameter SCOPE = COC, CON:

    1. Operational security is completely disabled for a certain channel. This implies that neither the operational security of the Channel nor that of the Business will be applied, allowing **always** access to the function protected by
        operational control.

- The name of the channel is defined in the list together with the SCOPE = CON parameter:

    1. For methods protected with a channel scope (@OperativeControl(scope = Scope.CHANNEL)), channel operational security applies to it.

    2. For methods protected with a business scope (@OperativeControl(scope = Scope.BUSINESS)), only channel operational security is applied, bypassing business operational security.

- The name of the channel is defined in the list together with the SCOPE = COC parameter:

    1. For methods protected with a channel scope (@OperativeControl(scope = Scope.CHANNEL)), operational security is ignored by allowing access to secure logic.

    2. For the methods protected with a business scope (@OperativeControl(scope = Scope.BUSINESS)), only the operational security of Business is applied, ignoring the operational security of the channel

If the operation is of the CONSULTATIVE or OPERATIONAL type, it does not influence the behavior of the channel whitelist. The HTTP verb used to make the request will not be relevant either (GET, POST, PUT, DELETE, etc)

For this, the following properties will be used. As an example, we have the following list:

    darwin:
      security:
        authorization:
          channel-whitelist:
            - channel: INT
            - channel: RML
              scope: COC, CON
            - channel: CIC
              scope:
                - COC
                - CON
            - channel: EMP
              scope: COC
            - channel: OFI
              scope: CON

A configuration like the one described above would lead to the following behavior:

1. For the CIC channel, the RML channel, or the INT channel, no operational control of any kind will be applied (neither channel nor business), so any request made against an endpoint with operational security activated, should return a message
    with status 200 (OK).

2. For the EMP channel, operational control of the Channel will not be applied, but operational control of the Business will be applied. This implies that for endpoints where only Channel operational security is applied, the response message should
    always have a status of 200 (OK). For endpoints where, by definition, the operational security of the Channel and the operational security of the Business would have to be applied, for the EMP channel, only the operational security of the
    Business would be applied. The response messages may be of any type (status 200 and 403) since the operational security of the Business may invalidate any information that is not correct.

3. For the OFI channel, the operational control of the Business will not be applied, but the operational control of the Channel will be applied. This implies that for endpoints where only the operational security of Canal is applied, the response
    message may be of any type (status 200 and 403) since the operational security of Canal may invalidate any information that is not correct. For endpoints where, by definition, the operational security of the Channel and the operational security
    of the Business would have to be applied, for the OFI channel, only the operational security of the Channel will be applied. The response messages may be of any type (status 200 and 403) since the operational security of the Canal may invalidate
    any information that is not correct, but in the event that an error message is obtained, these may never be related to the customer's contract. They should only be errors associated with the channel or client id.

### Web Applications (Servlet and Reactive)

In Web applications, to the previously documented base functionality, the following are added:

#### Annotations

By using the ***@OperativeControl*** annotation in the methods of a controller class, it is validated if the requested operation is allowed. Along with this, other annotations are defined with which the information on the [authorization
parameters](#authorization-parameters) will be collected.

If the operation is not allowed, the library throws an HttpStatus 403 error indicating in the detailedMessage field the exact reason for the denial of authorization.

Later we will explain all the [use cases](#how-to-use-the-authorization-library-in-web-applications) of these annotations.

!!! warning

     Please be advised that @OperativeControl annotation is not available in @Async mode and using it in such conditions may cause errors.

#### Whitelist

By default, the authorization library excepts all routes that are configured in the whitelist by the authentication library. In addition, it provides its own whitelist where routes are added to except them to which the operational control will not
be applied, but where the validation of their authenticity will be necessary.

For this, the following properties will be used.

    darwin:
      security:
        white-list:
          - /admin/health
        authorization:
          authorized-whitelist:
            - /requestMappingWihoutAnnotation
            - /getWihoutAnnotationInWhiteList
            - /requestMappingWihoutAnnotationInWhiteList
            - /requestMappingWihoutAnnotationPathInWhiteList

#### Interceptors

- For a `Servlet` application, only the `OCInterceptor` will be included in the **RestTemplate** and the `OCServletFilterFunction` in **WebClient/WebClient.Builder**.

- For a `Reactive` application only the `OCReactiveFilterfunction` will be included in **WebClient/WebClient.Builder**.

#### Authorization service

For web applications (Servlet or Reactive) where it is not possible to use the `@OperativeControl` annotation because, for example, the REST controllers are pre-defined and not to be able to modify for annotating them, it is possible to enable
manual mode and to expose the Authorization service in order to apply manually the operative security. This service can be injected into any component in order to configure and execute security validation in any place where it is necessary.

!!! info "Important"

    Activating the manual mode will disable the use of `@OperativeControl` directive SDL for GraphQl applications.

For learning more about this feature, reads the following section: [How to use manual mode](#how-to-use-manual-mode)

#### Portugal Authorization service

For web applications (Servlet or Reactive) that they are going to be executed on Portugal business, it is possible to enable manual mode and to expose the Authorization service API in order to apply manually the operative security. This service can
be injected into any component in order to configure and execute security validation in any place where it is necessary.

!!! warning

    The Authorization service for Portugal business is only valid for individual and company channels.

This service only will be configured and exposed if the BolaSeg endpoint is configured, and the manual mode is enabled and set to PORTUGAL mode in the properties file:

application.yml

    darwin:
      security:
        authorization:
          manual:
            enabled: true
            mode: PORTUGAL
          remote:
            bolaseg: ${env.bolaseg-endpoint}

BolaSeg service implements [AuthorizationService](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/AuthorizationService.html) interface and allows
different kind of validations in function of the authorization data provided. The service can validate contracts and card numbers:

- **For validating a contract id**, it is necessary to inform the ***customer id*** associated to the contract and the ***contract id*** itself.

**Creating a AuthorizationData for validating a contract.**

    AuthorizationData data = AuthorizationData.builder().contractId("0001").clientId("0002").build();
    authorizationService.authorize(data);

- **For validating a card id**, it is necessary to inform the ***customer id*** associated to the card number, and the ***card number*** itself. In addition, it is mandatory to use an ***user id*** validated in order to execute **card id**
    validation using the `BolaSer service`. ***User id*** will be managed by **Darwin** authentication instrumentation, and it won't be necessary to do anything, automatically `Authorization` header is read from the request and the token and its
    information will be available in the security context. For calling to `BolaSeg service`, security information will be propagated automatically as well.

**Creating a AuthorizationData for validating a card number.**

    AuthorizationData data = AuthorizationData.builder().cardId("0001").clientId("0002").build();
    authorizationService.authorize(data);

For learning more about this feature, reads the following section: [How to use manual mode](#how-to-use-manual-mode)

### GraphQL Applications (Servlet and Reactive)

In GraphQL applications, both `Servlet` and `Reactive` flavours, this library offers a set of [Directives SDL](https://www.graphql-java.com/documentation/sdl-directives) for marking GraphQL operation in the
[Schema](https://www.graphql-java.com/documentation/schema). Thank them to these annotations, the `Authorization` module provides the same functionality to GraphQL Applications than Rest applications.

#### Operative control SDL Directive

GraphQL SDL directives allows to annotate SDL elements in order to apply a custom logic in a declarative manner. In order to apply the operative security on GraphQL operations, the library have a set of authorization SDL Directives and SDL Elements:

    enum SCOPE { BUSINESS CHANNEL } (1)
    enum TYPE { OPERATIVE CONSULTIVE } (2)
    directive @OperativeControl(scope : SCOPE, type :TYPE, client: Boolean, contract: Boolean ) on FIELD_DEFINITION (3)
    directive @AuthorizationWhiteList on FIELD_DEFINITION (4)
    directive @ClientId on ARGUMENT_DEFINITION (5)
    directive @ContractId on ARGUMENT_DEFINITION (6)

1. **SCOPE** enum to define allowed values in the operative control scope.

2. **TYPE** enum to define allowed values in the operative control type.

3. Operative control directive in order to mark GraphQL operations (Queries and Mutations) for applying the security.

4. This directive allows to skip the operative security for a operation.

5. Directive in order to mark client id input parameter in the GraphQL operation.

6. Directive in order to mark contract id input parameter in the GraphQL operation.

The process of authorization for GraphQL applications applies exactly [the same rules](#authorization-rules) as in Rest applications using the @OperativeControl annotation on RestController components. This allows to use the
`darwin.security.authorization.method-list` property in order to choose between [Darwin authorization](#darwin-operative-security) and [Multi-entity authorization](#multi-entity-operational-security) processes. Thus, both `X-Control-Operativo` and
`X-Santander-OC` headers are read from the request depending on the authorization process chosen. Also, as in Rest applications, all the GraphQL operations have to be annotated with ´@OperativeControl´ directive, otherwise the application will fail
at start-time. It is possible to skip the operative security using the `@AuthorizationWhiteList` directive on GraphQL operations. For GraphQL application, the use of `darwin.security.authorization.authorization-white-list` property have no effects.
On the other hand, [Channel white-list](#channel-white-list) can be used in order to skip the operative security for a channel.

Finally, Keep in mind that @OperativeControl directive only can be used for Query and Mutation operation types. Darwin GraphQL doesn't support `subscription` type yet.

In order to learn how to use the `@OperativeControl` directive, reads the following section: [**How to use @OperativeControl directive on GraphQL Schema**](#how-to-use-operativecontrol-directive-on-graphql-schema)

## Installation and configuration

To use the library, all we have to do is add the library's starter as a Maven dependency in the project:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-authorization</artifactId>
    </dependency>

!!! info "Important"

    This library depends on the Authentication library, so by including this starter we will also be adding the `darwin-spring-boot-starter-authentication`.

When `darwin.security.authorization.manual.enabled` is **false** or `darwin.security.authorization.manual.mode` is **SPAIN**: it is mandatory to add the omnichannel starter. If it is required and no such dependency is found, the following exception
will be thrown ins start up app:

    Caused by: GenericDarwinException(errorName=OMNICHANNEL_NOT_FOUND, internalCode=1003, shortMessage=darwin-spring-boot-starter-omnichannel is missing, detailedMessage=Omnichannel is mandatory if authorization.mode is SPAIN or authorization.manual is not enabled, mapExtendedMessage={})

| Application Type            | Desired configuration | Dependencies                                                                                                                                                                                                                                                    |
|-----------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WebApplicationType.NONE     | NotWeb                | <ul><li>com.santander.darwin:darwin-spring-boot-starter-authorization</li></ul>                                                                                                                                                                                 |
| WebApplicationType.SERVLET  | Servlet               | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-authorization</strong></li><li>org.springframework.boot:<strong>spring-boot-starter-web</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul> |
| WebApplicationType.REACTIVE | Reactive              | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-authorization</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul>                                                                           |

!!! info "Important"

    Although you can add the application type and dependencies manually, the Darwin Archetypes has been redesigned to include all possible
    configurations, so we highly recommend using it for avoid errors. In case of migration of architecture versions, check the [migration guides](../../MIGRATION.md).

### Configuration

<!tag:properties>

| Name                                                                   | Default value | Oblig. | Description                                                                                                                                                                                                                                                                                                                                                                                  | Admitted values                          | Environment                                |
|------------------------------------------------------------------------|---------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|--------------------------------------------|
| darwin.security.authorization.remote.coc                               | N/A           | Yes    | Path to Darwin Channel Authorization Token Service.                                                                                                                                                                                                                                                                                                                                          | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization.remote.con                               | N/A           | Yes    | Darwin Business Authorization Token Service Path.                                                                                                                                                                                                                                                                                                                                            | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization.remote.bolaseg                           | N/A           | Yes    | Portugal Authorization service path                                                                                                                                                                                                                                                                                                                                                          | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization.remote.co-multi-entity                   | N/A           | No     | Path to the authorization token service for multientity contract.                                                                                                                                                                                                                                                                                                                            | String                                   | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.authorization.remote.coc-fallback-endpoint             | N/A           | No     | Alternate path for channel authorization token service.                                                                                                                                                                                                                                                                                                                                      | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization. remote.con-fallback-endpoint            | N/A           | No     | Alternate path for business authorization token service.                                                                                                                                                                                                                                                                                                                                     | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization.remote.co-multi-entity-fallback-endpoint | N/A           | No     | Alternative path for the authorization token service for multientity contract.                                                                                                                                                                                                                                                                                                               | String                                   | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.authorization.authorized-whitelist                     | N/A           | No     | List of routes, in AntPath format, that do not require authorization but do require authentication.                                                                                                                                                                                                                                                                                          | List                                     | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.authorization.channel-whitelist                        | N/A           | No     | List of channels where you want to partially or completely disable operational safety.                                                                                                                                                                                                                                                                                                       | List                                     | <ul><li>All</li></ul>                      |
| darwin.security.authorization.methods-list                             | N/A           | No     | List of authorization processes that must be used. The order in which they are defined establishes the priority of execution, the first one appearing in the list being the one with the highest priority. In case the list is empty, the Darwin authorization process will be loaded by default. Values allowed by the list currently: darwinOperativeControl, multiEntityOperativeControl. | List                                     | <ul><li>Servlet</li><li>Reactive</li></ul> |
| darwin.security.authorization.remote.bolaseg                           | N/A           | Yes    | Bolaseg Authorization Service Path.                                                                                                                                                                                                                                                                                                                                                          | String                                   | <ul><li>All</li></ul>                      |
| darwin.security.authorization.manual.enabled                           | False         | No     | Activates manual mode disabling the use of the aspect for Rest controllers and exposing Authorization services in order to apply manually the operative security                                                                                                                                                                                                                             | Boolean                                  | <ul><li>All</li></ul>                      |
| darwin.security.authorization.manual.mode                              | SPAIN         | No     | Configure the service which you expect to be authorized                                                                                                                                                                                                                                                                                                                                      | <ul><li>SPAIN</li><li>PORTUGAL</li></ul> | <ul><li>All</li></ul>                      |

<!end:properties>

!!! info "Important"

    Additionally, the [Authentication library](../darwin-spring-boot-security-authentication/README.md) must be configured. In the event that the `darwin.security.enable=false` variable is configured, the
    configuration of both libraries would be disabled.

!!! warning

    Any of the authorization processes that are configured establish the obligation to define the properties that contain the routes of the services of their corresponding operational controls.

#### WebClient bean properties

As for NotWeb applications, in the case of Servlet and Reactive applications `Darwin` allows customizing for operational control the Timeout associated with the connection, and the properties associated with the connection pool, they are globally
defined in the `darwin.core properties.webclient.` But there is the possibility of customizing them only for the Operational Control, through the values defined in the properties `darwin.security.authorization.webclient.` In the case of not wanting
to customize these values, those defined in `darwin.core.webclient.` will be taken by default.

<!tag:properties-webclient>

| Name                                                            | Default value | Required | Description                                                                                                                                                                                                                                                         | Supported values |
|-----------------------------------------------------------------|---------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| darwin.security.authorization.webclient.enabled                 | true          | No       | Allows disabling the autoconfiguration that Darwin performs on WebClient.Builder and WebClient (Injection of interceptors (app-key, security, logging, omnichannel and authorization), configuration of pools and connection timeouts).                             | Boolean          |
| darwin.security.authorization.webclient.connect-timeout         | 5000          | No       | Defines the timeout (in milliseconds) to wait until a connection is established.                                                                                                                                                                                    | Number           |
| darwin.security.authorization.webclient.read-timeout            | 5000          | No       | Defines the timeout (in milliseconds) to wait to get data through the established connection.                                                                                                                                                                       | Number           |
| darwin.security.authorization.webclient.write-timeout           | 5000          | No       | Defines the timeout (in milliseconds) to wait when writing data over the established connection.                                                                                                                                                                    | Number           |
| darwin.security.authorization.webclient.max-connections         | 500           | No       | Sets the maximum number of connections open simultaneously for a WebClient.Builder, this is achieved by modifying the size of the connection pool associated with said WebClient.Builder.                                                                           | Number           |
| darwin.security.authorization.webclient.pending-acquire-timeout | 45000         | No       | Defines the timeout (in milliseconds) to wait when requesting a connection from the connection pool managed by a WebClient.Builder.                                                                                                                                 | Number           |
| darwin.security.authorization.webclient.max-life-time           | 60000         | No       | Defines the maximum time (in milliseconds) after which the connection will be closed in the connection pool.                                                                                                                                                        | Number           |
| darwin.security.authorization.webclient.wiretap                 | false         | No       | Enable the wiretap to each request and response will be logged in full detail. To logging with Netty HttpClient also we have to set the log level of Netty's client package reactor.netty.http.client to DEBUG:[^3] `logging.level.reactor.netty.http.client=DEBUG` | Boolean          |

<!end:properties-webclient>

### Basic configuration

Currently, Darwin provides two modes for configuring the operative security for web applications.

The recommended configuration of the authorization module establishes the use of the MultiEntity operational security. In order to do that, it is mandatory to configure the following properties: the MultiEntity Operational Control (CO-MULTI-ENTITY)
endpoint and the value "multiEntityOperativeControl" in the Authorization process list. The basic configuration would be as follows:

application.yml

    darwin:
      security:
        authorization:
          methods-list:
            - multiEntityOperativeControl
          remote:
            co-multi-entity: ${env.co-multientity-endpoint}

application-XXX.properties

    env.co-multientity-endpoint: https://srvnuarintra.santander.dev.corp/cop/operative-security

As an alternative, the use of Darwin's traditional operational security is available, but this mode is marked as **deprecated** and it will be remove in a future version. For configuring it, it is necessary to set **mandatory** these two
properties: the Channel Operational Control (COC) and Contract (CON) routes.

application.yml

    darwin:
      security:
        authorization:
          remote:
            coc: ${env.coc-endpoint}
            con: ${env.con-endpoint}

application-XXX.properties

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract

These properties can be configured directly in the `application.yml`, but to have an **environment-dependent configuration** it is recommended to use variables defined in the `application-{environment}. Properties` generated for each environment, so
that the configuration file is unique.

!!! info "Important"

    Attention, the traditional Darwin operational security process will be deprecated in the next release. **It is recommended to use the Multi-entity operational security process**.

### Complete configuration

In addition to the previous configurations, the alternative routes to the Channel Operational Control (COC Fallback) and Business (CON Fallback) can be established.

    darwin:
      security:
        authorization:
          remote:
            coc: ${env.coc-endpoint}
            con: ${env.con-endpoint}
            coc-fallback-endpoint: ${env.coc-endpointFallback}
            con-fallback-endpoint: ${env.con-endpointFallback}

application-XXX.properties

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract
    env.coc-endpointFallback: https://srvnuarintra.santander.dev.alternative.corp/cop/opesec/channel
    env.con-endpointFallback: https://srvnuarintra.santander.dev.alternative.corp/cop/opesec/contract

In the case of using Multientity operational security, alternative routes can be configured for the operational control of the Channel (Multientity COC Fallback) and Business (Multientity CON Fallback):

    darwin:
      security:
        authorization:
          methods-list:
            - multiEntityOperativeControl
          remote:
            co-multi-entity: ${env.co-multientity-endpoint}
            co-multi-entity-fallback-endpoint: ${env.co-multientity-endpoint-fallback}

application-XXX.properties

    env.co-multientity-endpoint: https://srvnuarintra.santander.dev.corp/cop/operative-security
    env.co-multientity-endpoint-fallback: https://operative-control-sgt-common-dev.appls.cans.paas.cloudcenter.corp/operative-control/operative-security

On the other hand, for the case in which it is necessary to activate the use of both operational safeguards, both the Darwin operational control and the Multientity, an example of configuration would be the following:

application.yml

    darwin:
      security:
        authorization:
          methods-list:
            - darwinOperativeControl
            - multiEntityOperativeControl
          remote:
            coc: ${env.coc-endpoint}
            con: ${env.con-endpoint}
            co-multi-entity: ${env.co-multientity-endpoint}

application-XXX.properties

    env.coc-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/channel
    env.con-endpoint: https://srvnuarintra.santander.dev.corp/cop/opesec/contract
    env.co-multientity-endpoint: https://srvnuarintra.santander.dev.corp/cop/operative-security

This configuration defines the use of both authorization processes (**darwinOperativeControl**, **darwinOperativeControl**) and sets the Darwin authorization process as the main authorization method, since it is the first one defined in the method
list authorization.

Finally, only for Web applications (`Servlet / Reactive`), the list of routes that do not require authorization can also be configured (it does not exclude authentication).

    darwin:
      security:
        authorization:
          remote:
            coc: ${env.coc-endpoint}
            con: ${env.con-endpoint}
            coc-fallback-endpoint: ${env.coc-endpointFallback}
            con-fallback-endpoint: ${env.con-endpointFallback}
          authorized-whitelist:
           - /hello/**
           - /health/**

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

    When we call to *"https://some.api/\*"* we do not exclude the authentication headers to the propagation.

!!! info "Important"

    When we call to *"https://another.api"* we will exclude the authentication headers to the propagation.

For more information about the Propagation Headers visit [more information](../darwin-spring-boot-core/README.md#propagation-headers)

### The Portugal configuration

The Portugal configuration of the authorization module establishes the use of authorization control over contracts and cards for Portugal. The properties that must be configured are the BolaSeg service route and the Authorization manual mode.

These properties can be configured directly in the `application.yml`, but in order to have an environment-dependent configuration it is recommended to use variables defined in the `application-{environment}`. Properties generated for each
environment, so that the configuration file is unique:

application.yml

    darwin:
      security:
        authorization:
          remote:
            bolaseg: ${env.bolaseg-endpoint}
          manual:
            mode: PORTUGAL

application-XXX.properties

    env.bolaseg-endpoint: https://ms-bolaseg.totta.dev.corp/bolaseg/authorization

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## API Exposed

| Name                                                                                                                            | Type                                                                                                              | description                                                                                                                                                                                                          | Application type                          |
|---------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| [AuthorizationService&lt;Authentication>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/AuthorizationService.html)                         | Bean                                                                                                              | Service that exposes the imperative implementation of the authorization library                                                                                                                                      | <ul><li>All</li></ul>                     |
| [AuthorizationService&lt;Mono&lt;Authentication>>](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/AuthorizationService.html)                | Bean                                                                                                              | Service that exposes the reactive implementation of the authorization library                                                                                                                                        | <ul><li>All</li></ul>                     |
| [AuthorizationData](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/AuthorizationData.html)                                                  | Builder                                                                                                           | Builder class to build the operation to be authorized with the NotWeb services                                                                                                                                       | <ul><li>NotWeb</li></ul>                  |
| [Scope](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/types/Scope.html)                                                                    | Enum                                                                                                              | Enum with the possible values to define in the Scope of the operation                                                                                                                                                | <ul><li>All</li></ul>                     |
| [OperationType](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/core/authorization/types/OperationType.html)                                                    | Enum                                                                                                              | Enum with the possible values to define for the type of operation                                                                                                                                                    | <ul><li>All</li></ul>                     |
| [RequestOperativeControlDataAccessor](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authorization/accessor/RequestOperativeControlDataAccessor.html) | [OperativeControlDataAccessor](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authorization/accessor/OperativeControlDataAccessor.html) | Service to recover the contract and the client of the request                                                                                                                                                        | <ul><li>NotWeb</li><li>Reactive</li></ul> |
| [OCServletFilterFunction](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authorization/interceptor/OCServletFilterFunction.html)                      | Filter                                                                                                            | Authorization Filter for WebClient in Spring-MVC. The purpose of this class is to include the header 'X-Control-Operativo' with the JWT token of Operational Control in all requests made from the microservice.     | <ul><li>NotWeb</li><li>Servlet</li></ul>  |
| [OCReactiveFilterFunction](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authorization/interceptor/OCReactiveFilterFunction.html)                    | Filter                                                                                                            | Authorization Filter for WebClient in Spring-WebFlux. The purpose of this class is to include the header 'X-Control-Operativo' with the JWT token of Operational Control in all requests made from the microservice. | <ul><li>NotWeb</li><li>Reactive</li></ul> |
| [OCInterceptor](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/6.3.4/apidocs/com/santander/darwin/security/authorization/interceptor/OCInterceptor.html)                                          | Interceptor RestTemplate                                                                                          | The purpose of this class is to include the header 'X-Control-Operativo' with the JWT token of Operational Control in all requests made from the microservice.                                                       | <ul><li>NotWeb</li><li>Servlet</li></ul>  |

## Authorization Rules

Depending on the operational security mode configured, the logic of the authorization rules will be as follows based on
the parameters established in the *@OperativeControl* annotation:

### Darwin Operative Security

In general, in the event of a prior operational control token (propagated by a previous service under the traditional Darwin model),
it is collected from the *X-Control-Operativo* header and the following validations are performed:

1. Validation of the integrity of your signature as well as its expiration date (claim *exp*).

2. Validation of the strict coincidence between the value of the framework channel (reported in the header *X-Santander-Channel*) and the value of its claim *channel*.

Then, depending on the **scope** parameterized, the following rules will be followed:

- **Scope CHANNEL**

    For the operations that have to be validated against the **Channel Operational Control**, the following rules are defined:

    - **OperationType CONSULTIVE**: It will call the Channel Control Operative and validate ok all those results with consultation or operation permission.

    - **OperationType OPERATIVE**: It will call the Channel Control Operative and validate ok all those results with operation permission.

    - **client=true**: It will call the Channel Control Operation and will validate all those results with the permissions
        described by the type of operation and will verify that the request client is the same as the one received from
        the Control Operation for the non-face-to-face channels.

- **Scope BUSINESS**

    For the operations that have to be validated against the **Business Operational Control** , the following rules are defined:

    - **OperationType CONSULTIVE**: It will call the Business Control Operation (contract) if the contract
        validations is not false, and it will validate all those results with permission for consultation or operation.

    - **OperationType OPERATIVE**: It will call the Business Control Operational (contract) if the contract
        validations is not false, and it will validate all those results with operation permission.

    - **client=true and contract=true**: It will call the Business Control Operation (contract), validate all those results
        with the permissions described by the type of operation and check that the client and request contract is the same as the
        one received from the Control Operation for non-face-to-face channels.
        In the case of face-to-face channels, customer validation will not be performed.

    - **client=false and contract=true** It will call the Business Control Operation and will validate all those results
        with the permissions described by the type of operation and check that the contract is the same as the one received.

    - **contract=false** It will only call the Channel Control Operation and it will validate all those results with the permissions
        described by the type of operation, checking the client if its validation is true and the framework channel is not
        present. It will not make the call to the Business Control Operation.

### Multi-entity Operational Security

In general, in the event of a prior operational control token (hereinafter, JOC, propagated by a previous service under the Multientity model), it is collected from the header *X-Santander-OC* and the following validations are carried out:

For more details about the JOC token, see the section [Technical solution: Multi-entity logic of the Authorization filter](#technical-solution)

1. Validation of the integrity of your signature as well as its expiration date (claim *exp*).

2. Validation of the strict match between the value of the framework channel (reported in the header *X-Santander-Channel*) and the value of its claim *channel*.

Then, depending on the parameterized **scope**, this rules will be followed:

- **Scope CHANNEL**

    For the operations that have to be validated against the **Channel Operational Control**, the following rules are defined:

    If a previous JOC token is reported, it is validated that the *operativeControlChannel* claim is reported. Otherwise (if we do not have a previous JOC token or the claim is not initialized), the **Operative channel control** will be called with
    the previous JOC token (if available), to obtain the updated JOC token, or a new one (in case you don't have a previous one).

    - **OperationType CONSULTIVE**: It is validated that the claim *operativeControlChannel* of the JOC token contains the value **O** (Operative) or **C** (Consultive).

    - **OperationType OPERATIVE**: It is validated that the claim *operativeControlChannel* of the JOC token contains the value **O** (Operative).

    - The **contract** and **client** parameters will not be taken into account to apply Channel Operational Control logic, so the value they contain in their parameterization will be irrelevant (it is recommended to omit them).

- **Scope BUSINESS**

    For the operations that have to be validated against the **Business Operational Control**, the following rules are defined:

    If a previous JOC token is informed, it is validated that the claim *operativeControlContract* is informed and contains an entry for the value of the parameterized **@ContractId**. The claims are also validated. It validates that the claims
    *clientType* and *clientCode* are informed and coincide with the value of **@ClientId**, if it is parameterized (optional). Otherwise, (if there isn't a previous JOC token or the claims are not initialized), the **Business Control Operation**
    will be called with the previous JOC token (if available), to obtain the updated JOC token, or a new one (in case there isn't a previous one).

    - **OperationType CONSULTIVE**: It is validated that the claim *operativeControlContract* of the JOC token contains the value **O** (Operative) or **C** (Consultive) for the input corresponding to the value of the parameterized
        **@ContractId**.

    - **OperationType OPERATIVE**: It is validated that the claim *operativeControlContract* of the JOC token contains the value **O** (Operative) for the input corresponding to the value of the parameterized **@ContractId**.

    - **contract=true**: Required to pass the Business Operational Control logic.

    - **contract=false**: The validation of the Business Operational Control logic is not performed (it does not make sense in Multi-entity mode when Scope BUSINESS is selected).

    - The **client** parameter will not be taken into account to apply Business Operational Control logic, so the value it contains in its parameterization will be irrelevant (it is recommended to omit it).

In Multi-entity mode with **Scope BUSINESS**, depending on the filters in the [Channel white-list](#channel-white-list) for the current frame channel, the following circumstances may occur:

1. If the Channel Operational Control (COC) **IS IN WHITELIST**, only the **Business Operational Control** logic will be validated:

2. If the Channel Operational Control (COC) **IS NOT IN WHITELIST**, the **Channel Operational Control** logic will be validated and then the **Business Operational Control**, in that order. The **Channel and Business Control Operations** to obtain
    the JOC token informed with the claims of both controls will be resolved through a single call to the Operational Control service.

3. If the Business Operational Control (CON) **IS IN WHITELIST** and the Channel Operational Control (COC) **IS NOT IN WHITELIST**, the execution of the operational security of the Business will not be prevented individually, therefore both
    operational security checks will be executed.

Regardless of the scope selected, if both Channel Operational Controls (COC) and Business Operational Controls (CON) **ARE IN WHITELIST**, operational security will not apply and access to the function protected by operational control will be
allowed.

## Library use cases

### How to use the authorization library in NotWeb applications

It is **MANDATORY** to use the authorization services through the method exposed by the security services of the Authentication library, since they incorporate all the necessary chain of operations. Therefore, to use them we will only have to inject
the bean of the `SecurityManagerService` that we want in our application, referring to the types with which we are going to work (according to the desired implementation):

    @Autowired
    private SecurityManagerService<Authentication> securityManagerService;

    @Autowired
    private SecurityManagerService<Mono<Authentication>> reactiveSecurityManagerService;

These services will only be enabled for **NotWeb** environments, since in the library's Web solutions annotations are used in the controller classes to retrieve the authorization parameters and validate the operation. To cover this functionality in
this environment, the `AuthorizationData` class is provided so that the user can define them manually. The class is implemented with the **Builder** pattern thus making it immutable:

    @Builder
    @Data
    public class AuthorizationData {

        private Scope scope;

        private OperationType operationType;

        private String contractId;

        private String clientId;

        private String channel;

        private boolean client;

        private boolean contract;

    }

An use example of these services in their corresponding environments to authorize an operation would be the following: *Non-reactive*

    String stringToken = "TokenStringValue";    //(1)

    AuthorizationData authorizationData = AuthorizationData.builder().scope(Scope.CHANNEL)
        .operationType(OperationType.CONSULTIVE).client(false).channel("INT").build();  //(2)

    Authentication resultToken = securityManagerService.authorize(stringToken, authorizationData); // (3)

    if (resultToken != null && resultToken.isAuthenticated()){
        AuthenticationBearerToken authToken = (AuthenticationBearerToken) resultToken;  // (4)

        if (authToken.getAuthorizationToken != null){
        Token.TokenType tipo = authToken.getAuthorizationToken().getTokenType();   // (5)
        }
    }

Example of *Reactive* code:

    String stringToken = "TokenStringValue";    //(1)

    AuthorizationData authorizationData = AuthorizationData.builder().scope(Scope.CHANNEL)
        .operationType(OperationType.CONSULTIVE).client(false).channel("INT").build();  //(2)

    Mono<Token.TokenType> tipo;

    tipo = Mono.just(stringToken)
                        .flatmap(stringToken ->
                            reactiveSecurityManagerService.authorize(stringToken, authorizationData)) // (3)
                        .filter(Authentication::isAuthenticated)
                        .cast(AuthenticationBearerToken.class)                  // (4)
                        .map(authToken ->
                            authToken.getAuthorizationToken().getTokenType()); // (5)

1. Token with which to authenticate and that will be used to call Operational Control.

2. We create the rules to authorize an **query** operation on the **Channel Operational Control without checking the client** on the **internal channel**.

3. We use the **Security Service** to authorize the operation and collect the resulting `Authentication`.

4. If it is not null and is authenticated, we cast it to the type defined by Darwin `AuthenticationBearerToken` to access its content.

5. If it contains the authorization token, the operation will be authorized and we will be able to access its content.

### How to use the authorization library in Web applications

The library is in charge of validating Rest requests, therefore, to use it, the methods contained within a @RestController class must be noted, for example:

!!! info "Important"

    The library's mode of use is the same for both `Reactive` applications and `Servlet` applications.

        import ClientId;
        import ContractId;
        import OperativeControl;
        import OperationType;
        import Scope;
        import ...;
    
        @RestController
        @Slf4j
        public class SampleController {
    
            @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)
            @GetMapping("/getWihtAnnotation")
            public void getWihtAnnotation(@RequestParam @ClientId String param1, @RequestParam String paramExtra, @RequestParam @ContractId String param2) {
                log.debug("inside @GetMapping getWihoutAnnotation");
            }
    
            @OperativeControl(scope = Scope.BUSINESS, type = OperationType.OPERATIVE, contract = false)
            @RequestMapping(value = "/requestMappingPostWihtAnnotationOperative", method = RequestMethod.POST)
            public Mono<Void> postRequestMappingWihtAnnotationOperativeMethod(@RequestBody Input input) {
                log.debug("inside @PostMapping requestMappingPostWihtAnnotation @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)");
            }
    
        }

The @OperativeControl annotation is required for any method within a controller class. The use of annotation is the same for both `Reactive` applications and for `Servlet` applications. Its settings are as follows:

- **scope**: Identifies whether channel or business operational control is to be applied to the endpoint. By default its value is Business.

- **type**: Indicates whether the operation is consultative or operational. By default its value is Operational.

- **client**: Indicates if the operation is applied to a customer resource and therefore this parameter should be validated. By default its value is true.

- **contract**: Indicates if the operation is applicable to a contract and therefore this parameter must be validated. By default its value is true. Applies only to operations with business scope.

- **dataAccessor**: By default, the library implements its own **OperativeControlDataAccessor** in charge of retrieving the client and contract information from the parameters noted with @ClientId and @ContractId. The developer is free to make his
    own implementation of this interface, indicating in this parameter the name of the Bean to retrieve.

!!! warning

     Please be advised that @OperativeControl annotation is not available in @Async mode and using it in such conditions may cause errors.

#### Orchestrate the use of two Operational Securities (Darwin and Multientity)

The authorization module can be configured to make use of two authorization processes at the same time.

In order to validate access to a resource protected by the operational security of Darwin or Multientity in the same application, both authorization methods must be defined in the configuration by using the property
`darwin.security.authorization.methods-list`.

    darwin:
      security:
        authorization:
          methods-list:
            - multiEntityOperativeControl
            - darwinOperativeControl

Also, this configuration takes as its main authorization process the first method that is defined in the list. If the previous configuration of the property ***methods-list*** is taken into account, the value of the first entry in the list would be
taken as the main authorization method, that is, the Multientity operational security would be used.

Once the authorization methods have been defined and their priorities established, the behavior of the authorization filter would be as follows:

- The authorization method that is established as a priority is the one in charge of validating access to all requests that either do not have an operational control header, or that have the operational control header that contains the
    authorization token that can process. That is, for example, if the main authorization method is the process that makes use of Multi-entity operational security, it will validate the access of requests that do not have any operational control
    header, neither `X-Control-Operativo` nor `X-Santander-OC`, or requests that have the heading `X-Santander-OC`.

- The authorization method that is considered secondary will be able to validate the access of those requests that have the operational control header that contains the authorization token that it can process. That is, for example, if the
    secondary authorization method is the process that makes use of Darwin's operational security, it will only validate requests that have the `X-Control-Operativo` header.

!!! info "Important"

    The simultaneous use of two operational safeguards is only available for web applications.

!!! note

    For more information on the use of properties and settings, see the cases in the [complete configuration](#complete-configuration) section

#### Query Params

By default, in the Get and POST verbs, the authorization library retrieves the customer and contract values through the parameters annotated with @ClientId and @ContractId, for example:

    @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)
    @GetMapping("/getWihtAnnotation")
    public void getWihtAnnotation(@RequestParam @ClientId String param1, @RequestParam String paramExtra, @RequestParam @ContractId String param2) {
            log.debug("inside @GetMapping getWihoutAnnotation");
        }

Use example:

    curl -X GET --header "X-Santander-Channel: INT" 'http://127.0.0.1:8080/getWihtAnnotation?param1=F123456789&paramExtra=other&param2=0049000100100000001'

The header 'X-Santander-Channel' refers to the frame channel and is mandatory if you want to receive a successful response.

#### Body Params

By default, in the verbs POST, PUT, PATCH and DELETE; the authorization library retrieves the client and contract values through a microservice's own POJO that contains attributes annotated with @ClientId and @ContractId. Also, said POJO must be
annotated with @Data from Lombok library for autogeneration of accessor methods. An example of the POJO would be:

    @Data
    public class Input {

        private String id;

        @ContractId
        private String contract;

        @ClientId
        private String client;
    }

This POJO must be the body required in the controller method, for example:

    @OperativeControl(scope = Scope.BUSINESS, type = OperationType.OPERATIVE, contract = false)
    @RequestMapping(value = "/requestMappingPostWihtAnnotationOperative", method = RequestMethod.POST)
    public void postRequestMappingWihtAnnotationOperativeMethod(@RequestBody Input input) {
       log.debug("inside requestMappingPostWihtAnnotation scope = Scope.CHANNEL, type = OperationType.OPERATIVE");
    }

Use example:

    curl --request POST 'http://localhost:8080/requestMappingPostWihtAnnotationOperative' \
    --header 'X-Santander-Channel: INT' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "client": "12345",
        "id": "1433477",
        "contract": "1"
    }'

!!! note

    In the case of a POST request, the `contractId` and `clientId` are first obtained from the request parameters. 
    If they are not found, they are obtained from the body. In the case of duplicates, the values from the request parameters will be used, and a warning will be logged.

#### Annotations at class level

The scope of the operation can be defined at the class level, so that when we define it in the header of a class, it will apply its value throughout all the methods contained within that class, for example:

    @RestController
    @RequestMapping("/annot")
    @OperativeControl(scope = Scope.CHANNEL)
    @Slf4j
    public class HierachicalTestController {

        @OperativeControl(type = OperationType.CONSULTIVE)
        @RequestMapping(value = "/requestMappingPostWihtAnnotation", method = RequestMethod.POST)
        public void postRequestMappingWihtAnnotationMethod(@RequestBody Input input) {
            log.debug(input.toString());
            log.debug(input.getId());
            log.debug("inside @PostMapping requestMappingPostWihtAnnotation @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)");
        }
    }

The postRequestMappingWihtAnnotationMethod controller will respond to a POST call to "http://localhost:8080/annot/requestMappingPostWihtAnnotation" where the scope will be 'CHANNEL', the type of operation 'CONSULTIVE' and the client and contract
validations are true for being its value by default (although in this case the validation by contract would not be done as it is not a Business scope).

!!! note

    the annotation placed at the class level, only the scope attribute will be taken into account, the rest of the attributes will be taken into account at the method level. If the scope is defined at the class level and at the
    method level, the value defined at the class level will prevail.

#### Data Accessor

It is the service in charge of recovering the client and contract values that arrive as a parameter or in the body of the request. The library offers the OperativeControlDataAccessor interface that each developer can implement with their own logic
to retrieve the values of these parameters.

The method to implement would be:

    public OperativeControlDataInfo getData(ProceedingJoinPoint joinPoint, Object input) throws IllegalAccessException;

- **joinPoint**: Objeto org.aspectj.lang.ProceedingJoinPoint With all the information contained in that cut-off point.

- **input**: For verbs the that are not Get. It is the POJO that enters the body of the request where it must contain the attributes annotated with **@ClientId** and **@ContractId**.

#### Supported verbs

The @OperativeControl annotation supports the methods headed with Spring annotations **@RequestMapping** , **@GetMapping** , **@PostMapping**, **@PatchMapping** , **@PutMapping** and **@DeleteMapping** .

### How to propagate authorization token

It is possible that from the application that is being implemented it is necessary to call via REST a microservice that also implements authorization and therefore validates whether the request is allowed or not.

For this, it will be ensured that two parameters must be propagated in the request headers. The first parameter represents the channel on which you are operating. The second parameter represents an operational control token. As there is the
possibility of using two different operational controls to validate a request, there is a different header for each operational control token:

- **X-Santander-Channel:** Contains the request channel frame (INT, OFI, etc).

- **X-Control-Operativo:** When Darwin operational security validates access to a protected resource, if the operation is allowed, a Jwt token is provided to be used in subsequent and successive requests in order to speed up call performance.
    Said token, if it has one, must be contained within this header.

- **X-Santander-OC:** When the validations have been carried out with the Multientidad operational security, in case the filter allows access, a Joc token will be provided to be used in subsequent and successive requests so that call performance
    is streamlined. Said token, if it has one, must be contained within this header.

Example with Darwin operational security:

    curl --request POST 'http://localhost:8080/requestMappingPostWihtAnnotationOperative' \
    --header 'X-Santander-Channel: INT' \
    --header 'X-Control-Operativo: TkVHT0NJTy...' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "client": "12345",
        "id": "1433477",
        "contract": "1"
    }'

Example with multi-entity operational security:

    curl --request POST 'http://localhost:8080/requestMappingPostWihtAnnotationOperative' \
    --header 'X-Santander-Channel: INT' \
    --header 'X-Santander-OC: TkVHT0NJTy...' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "client": "12345",
        "id": "1433477",
        "contract": "1"
    }'

In `Servlet` environments, there are two possibilities:

RestTemplate usage:

The "**santander-spring-boot-core**" library provides a RestTemplate Bean **darwinRestTemplate** , to which is added the omnichannel interceptors and authorization to propagate these headers. So by injecting said RestTemplate there will be no need
to put the headers manually in the java classes.

!!! info "Important"

    The use of RestTemplate will be deprecated in future versions.

Example:

    @RestController
    @Slf4j
    public class TestController {

        private RestTemplate restTemplate;

        public TestController(@DarwinQualifier RestTemplate darwinRestTemplate)    {
            this.restTemplate = darwinRestTemplate;
        }

         @RequestMapping(path = "/requestMappingConsultiveChannelWithAnnotationPropagation",
                method = RequestMethod.GET)
        @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)
        public void requestMappingConsultiveBusinessWithAnnotationPropagation(@RequestParam @ClientId String param1, @RequestParam String extraParam, @RequestParam @ContractId String param2)     {
            log.debug("inside @RequestMapping requestMappingConsultiveChannelWithAnnotationPropagation");
            restTemplate.getForObject("http://localhost:8080/requestMappingConsultiveChannelWithAnnotationPropagationReceiver?param1=F12345&extraParam=other&param2=00491771312910006146", String.class);
        }

WebClient usage:

The "**spring-webflux**" library provides a WebClient.Builder Bean, to which all the "Servlet" interceptors are added to propagate the necessary headers. So by injecting said WebClient.Builder, there will be no need to put the headers manually in
the java classes.

    @RestController
    @Slf4j
    public class TestController {

        private WebClientBuilder webClientBuilder;

        public TestController(WebClientBuilder webClientBuilder)    {
            this.webClientBuilder = webClientBuilder.baseUrl("http://localhost:8080").build();
        }

        @RequestMapping(path = "/reactive/requestMappingConsultiveChannelWithAnnotationPropagation",
        method = RequestMethod.GET)
        @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)
        public void requestMappingConsultiveChannelWithAnnotationPropagation(
        @RequestParam(required = false) @ClientId String param1, @RequestParam String paramExtra,
        @RequestParam(required = false) @ContractId String param2) {
        log.debug("inside @RequestMapping requestMappingConsultiveChannelWithAnnotationPropagation");

                String result = this.webClient.get().uri("/reactive/requestMappingConsultiveChannelWithAnnotationPropagationReceiver?param1="
                        + param1 + "&paramExtra=other&param2=" + param2).retrieve().bodyToMono(String.class).block();
        }
    }

In `Reactive` environments, an example would be:

The "**spring-webflux**" library provides a WebClient.Builder Bean, to which all the "Reactive" interceptors are added to propagate the necessary headers. So by injecting said WebClient.Builder, there will be no need to put the headers manually in
the java classes.

    @RestController
    @Slf4j
    public class TestController {

        private WebClientBuilder webClientBuilder;

        public TestController(WebClientBuilder webClientBuilder)    {
            this.webClientBuilder = webClientBuilder.baseUrl("http://localhost:8080").build();
        }

    @RequestMapping(path = "/reactive/requestMappingConsultiveChannelWithAnnotationPropagation",
    method = RequestMethod.GET)
    @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE)
    public Mono<String> requestMappingConsultiveChannelWithAnnotationPropagation(
    @RequestParam(required = false) @ClientId String param1, @RequestParam String paramExtra,
    @RequestParam(required = false) @ContractId String param2) {
    log.debug("inside @RequestMapping requestMappingConsultiveChannelWithAnnotationPropagation");

            return this.webClient.get().uri("/reactive/requestMappingConsultiveChannelWithAnnotationPropagationReceiver?param1="
                    + param1 + "&paramExtra=other&param2=" + param2).retrieve().bodyToMono(String.class);
        }
    }

The previous examples use the different HTTP clients available in the DARWIN framework to make a REST call to another method that may be contained in another microservice that will also validate whether the requested operation is authorized or not.

As it can be observed, the headers have not been written manually in the code when doing the Get, but since the initial request has already processed an authorization validation, any of the HTTP Clients of the architecture will automatically
propagate the resulting token on the following requests of the first validation; which may or may not have also received a token in the 'X-Control-Operativo' header.

If the first request is for channel scope and the next one is for business, even if the second receives a channel-type Jwt token, it will request the corresponding permissions from the Business Operational Control and will replace the previous token
with one with a greater scope and will use this in the following nested calls if there are any.

In Multi-entity mode, the X-Santander-OC header will always propagate between services of the same chain of execution and towards the Operational Control service, for its initial generation or for updating with new claims (regeneration and
re-signature, keeping the previous claims and adding new)

### How to set up the CircuitBreaker and Retry

The configurable Retry and Circuit Breaker instances in the authorization library are:

- **COConnector:** Controls calls to Darwin Operational Control to obtain the authorization token.

- **COFallbackConnector:** Control calls to Darwin Operational Control fallbacks in case the main ones do not respond correctly.

- **MultiEntityCOConnector:** Controls calls to Multi-entity Operational Control to obtain the authorization token.

- **MultiEntityCOFallbackConnector:** It controls the calls to the fallbacks of the Multi-entity Operational Control in case the main ones do not respond correctly.

- **BolaSegPortugalConnector**: Control calls to Portugal operative control service in order to validate contracts and cards..

#### CircuitBreaker

The basic properties of the CircuitBreaker and their default values are as follows:

- **minimumNumberOfCalls:** The size of the buffer ring when the loop is closed. The failure rate will not be calculated until this minimum number of calls are registered. The default value is ***100***.

- **permittedNumberOfCallsInHalfOpenState:** The size of the buffer ring when the circuit is half open. This ring is used when the circuit breaker transitions from open to half open to evaluate the health of the circuit. If the failure rate is not
    exceeded, once this number of calls have been made, the circuit will be closed. The default value is ***10***.

- **waitDurationInOpenState:** The time that the circuit breaker must wait before transitioning from open to half open. The default value is ***60*** \[s\].

- **failureRateThreshold:** The threshold of the failure rate in percentage, after which the circuit breaker will open the circuit and begin to short-circuit calls. The default value is ***50***.

- **recordFailurePredicate** The predicate class that evaluates which exceptions should be used to open the circuit. By default, the circuit will be opened with the exceptions that correspond to an HTTP 5xx status of the server that is called.

If you want to change the default configuration for Circuit Breaker, you must modify the following parameters:

    resilience4j.circuitbreaker:
      instances:
        COConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 40
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        COFallbackConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 40
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        MultiEntityCOConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 40
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        MultiEntityCOFallbackConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 40
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
        BolaSegPortugalConnector:
          minimumNumberOfCalls: 100
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 100000
          failureRateThreshold: 40
          recordFailurePredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate

!!! note

    For more information about the operation or additional parameters of CircuitBreaker, we can consult the product documentation at: [Resilience4j CircuitBreaker](https://resilience4j.readme.io/docs/circuitbreaker)

#### Retry

Similarly, the default settings for Retry (number of retries and the delay time between them) are:

- **retryExceptionPredicate:** The predicate class that evaluates which exceptions should and should not be retried. By default, exceptions that correspond to an HTTP 5xx status of the called server will be retried.

- **maxAttempts:** The maximum number of retries. By default, there will be 3 retries.

- **waitDuration:** A fixed wait time between retries. By default, ***500*** \[ms\].

If you want to change the default configuration for Retry, you must modify the following parameters:

    resilience4j.retry:
      instances:
        COConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        COFallbackConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        MultiEntityCOConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        MultiEntityCOFallbackConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500
        BolaSegPortugalConnector:
          retryExceptionPredicate: com.santander.darwin.core.resilience4j.Is5xxPredicate
          maxAttempts: 3
          waitDuration: 500

!!! note

    For more information about the operation or additional parameters of Retry, we can consult the product documentation at: [Resilience4j Retry](https://resilience4j.readme.io/docs/retry)

### How updates the security context with a new Authorization token

To update the security context with a new Authorization token, the first thing to do is to retrieve the authentication object from the security context and mutate this object with the new token. Finally we add the updated authentication object with
the new token back to the context.

#### Non-reactive environments

In non-reactive environments, the following example can be used as a reference:

    AuthorizationToken token = AuthorizationToken.builder().createJwt("token").build();

    AuthenticationBearerToken authentication = (AuthenticationBearerToken) SecurityContextHolder.getContext().getAuthentication();

    SecurityContextHolder.getContext().setAuthentication(authentication.mutateWithAuthorization(token));

!!! note

    If you wish to create a token of type AuthorizationJocToken the process is exactly the same

#### Reactive environments

In a reactive environment, the following example can be used as a reference:

    AuthorizationToken token = AuthorizationToken.builder().createJwt("token").build();

    ReactiveSecurityContextHolder.getContext()
            .flatMap((SecurityContext securityContext) ->
                Mono.justOrEmpty(securityContext.getAuthentication())
                    .cast(AuthenticationBearerToken.class)
                    .map((AuthenticationBearerToken authToken) -> authToken.mutateWithAuthorization(token))
                    .doOnNext((securityContext::setAuthentication)
            ));

!!! note

    If you wish to create a token of type AuthorizationJocToken the process is exactly the same

### How to use @OperativeControl directive on GraphQL Schema

Darwin Authorization provides the following directives in order to cover all the features offered:

#### @OperativeControl directive

With the `@OperativeControl` directive must be marked all the operation that it is mandatory to pass the operative security. It can only be used on operation fields: Queries and Mutations. ***Subscriptions are not supported***.

This directive has four parameters:

- **scope**: Indicates that kind of operational control must be applied: ***BUSINESS*** or ***CHANNEL***.

- **type**: Indicates that kind of operation: ***CONSULTIVE*** or ***OPERATIVE***.

- **client**: Indicates that client validations has to be applied for input parameters.

- **contract**: Indicates that contract validations has to be applied for input parameters.

!!! info "Important"

    For more information about the `@OperativeControl` directive parameters, reads the following section: [Authorization rules](#authorization-rules)

#### @AuthorizationWhiteList directive

There can be operations where it is not necessary to apply the operative security. Using the `@AuthorizationWhiteList` directive, the security validation can be skipped. ``IMPORTANT: The `darwin.security.authorization.authorization-white-list`
property have no effects in GraphQL applications.

#### @ClientId

`@ClientId` is a directive created in order to be used on input parameters field operations. Its target is marked the input argument which corresponds to the client id. This is necessary because, for certain access levels, the operative control
logic has to validate it.

!!! info "Important"

    The input parameter marked with `@ClientId` has to be of **String** type

#### @ContractId

`@ContractId` is a directive created in order to be used on input parameters field operations. Its target is marked the input argument which corresponds to the contract id. This is necessary because, for certain access levels, the operative control
logic has to validate it.

!!! info "Important"

    The input parameter marked with `@ContractId` has to be of **String** type

#### Working on Schema

In order to use operative control directive and the rest of authorization directives and SDL elements for applying the operative security on Queries and Mutations, the first thing to do is adding the definition of the SDL directives and SDL elements
to the top of the GraphQL Schema:

    enum SCOPE { BUSINESS CHANNEL }
    enum TYPE { OPERATIVE CONSULTIVE }
    directive @OperativeControl(scope : SCOPE, type :TYPE, client: Boolean, contract: Boolean ) on FIELD_DEFINITION
    directive @AuthorizationWhiteList on FIELD_DEFINITION
    directive @ClientId on ARGUMENT_DEFINITION
    directive @ContractId on ARGUMENT_DEFINITION

The definition of this elements allow to use them for marking the GraphQL operations and configuring the distinct levels of operative security for the operations.

For example, in some GraphQL Schema, there can be different kind of operations: Query and Mutations. `@OperativeControl` directive and `@AuthorizationWhiteList` directive can only be used on operations:

    enum SCOPE { BUSINESS CHANNEL }
    enum TYPE { OPERATIVE CONSULTIVE }
    directive @OperativeControl(scope : SCOPE, type :TYPE, client: Boolean, contract: Boolean ) on FIELD_DEFINITION
    directive @AuthorizationWhiteList on FIELD_DEFINITION
    directive @ClientId on ARGUMENT_DEFINITION
    directive @ContractId on ARGUMENT_DEFINITION

    type Query {
        accounts: [String]! @OperativeControl
    }

    type Mutation {
        addAccount(id: String!): String! @AuthorizationWhiteList
    }

In this Schema, there are two operations defined: a query marked by `@OperativeControl` with the default values, and a mutations marked by `@AuthorizationWhiteList` for which operative security is not applied. The first one has to pass the operative
security before retrieving the query data, and the second one will skip the operative control and will directly return the data.

On the other hand, when the operations involve querying business data and it is necessary to validate the client and/or the contract data in order to pass the operative security, the `@ClientId` and `@Contractid` directives have to be used in order
to mark the different input parameters:

    enum SCOPE { BUSINESS CHANNEL }
    enum TYPE { OPERATIVE CONSULTIVE }
    directive @OperativeControl(scope : SCOPE, type :TYPE, client: Boolean, contract: Boolean ) on FIELD_DEFINITION
    directive @AuthorizationWhiteList on FIELD_DEFINITION
    directive @ClientId on ARGUMENT_DEFINITION
    directive @ContractId on ARGUMENT_DEFINITION

    type Mutation {
        updateAccount(id: String! @ClientId, contract: String! @ContractId): String! @OperativeControl(scope : BUSINESS, type: OPERATIVE, client: true, contract: true)
    }

`@ClientId` directive is used for marking *id* as client id input parameter. `@ContractId` directive is used for marking *contract* as contract id input parameter. The ***updateAccount*** operation is marked by
`@OperativeControl(scope : BUSINESS, type: OPERATIVE, client: true, contract: true)` defining it as business operative operation with client and contract validation flags enabled. Thus, in this example, the operation has to pass both Channel
operative control and Business operative control and theirs validations.

!!! info "Important"

    Input parameters marked by either `@ClientId` or `@ContractId` have to be of String type.

### How to use manual mode

When it is not possible to use the `@OperativeControl` annotation for annotating REST controllers in web applications or the necessary validations have to be performed in a manual way, it exists the possibility to activate the manual mode and to
expose the Authorization services in order to apply manually the operative security.

To do that, first the `darwin.security.authorization.manual.mode` property has to be defined in the configuration file:

    darwin:
      security:
        authorization:
          manual:
            enabled: true

!!! info "Important"

    Activating the manual mode will disable the use of `@OperativeControl` directive SDL for GraphQl applications.

This disables the authorization web configuration and it will avoid to load the annotation instrumentation. In addition, it won't be already mandatory to use the `@OperativeControl` annotation in order to annotate REST controllers.

Keeps in mind that the authorization process needs that the authentication is applied previously. As this feature is thought about applications web, the authentication web filter is executed by each request, filling the security context with the
authentication object. This will be read by Authorization process in order to apply the operative security. In addition, the authorization service reads the Darwin context from the execution context for getting the necessary information.

Now, it is possible to inject the authorization service in any class in order to apply the operative security manually, for example, in the service component invoked by the rest controller. Once `AuthorizationData` object is parametrized and
configured depending on the type of operative control to be applied, the ***authorize*** method will be invoked passing it the authorization data. This method returns the result of the validation if the security process ends successfully. In case of
error, it will return an exception explaining the reason of the error.

!!! note

    `AuthorizationService` class is a public interface that its target is to allows to create custom authorization services depending on the necessity of the business or the country where the application is running.
    `AuthorizationData` would have to be customized in order to comply with the new requirements.

#### Manual mode for Spain applications

In order to enable the manual mode for applications that they are going to server for Spain business, it is necessary to use the following parametrization for configuring the properties:

    darwin:
      security:
        authorization:
          manual:
            enabled: true
            mode: SPAIN

Previously to invoke to the ***authorize*** method, the `AuthorizationData` object must be parametrized properly for applying operative security based in Spain validations.

!!! info "Important"

    `AuthorizationData` object can be configured and parametrized following this rules: [Authorization rules](#authorization-rules). In addition, the meaning of each parameter is available at: [Authorization
    parameters](#authorization-parameters).

For **reactive applications**, it would be as simple as:

    import com.santander.darwin.core.authorization.AuthorizationData;
    import com.santander.darwin.core.authorization.AuthorizationService;
    import com.santander.darwin.core.authorization.types.OperationType;
    import com.santander.darwin.core.authorization.types.Scope;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;
    import reactor.core.publisher.Mono;

    @Service
    public class HelloService {

        @Autowired
        AuthorizationService<Mono<Authentication>> authorizationService; (1)

        public Mono<String> sayHello() {
            var authorizationData = AuthorizationData.builder() (2)
                            .client(false)
                            .contract(false)
                            .operationType(OperationType.CONSULTIVE)
                            .scope(Scope.CHANNEL).build();
            return Mono.justOrEmpty(authorizationData)
                    .flatMap(authorizationService::authorize) (3)
                    .thenReturn("hello");
        }

        public Mono<String> sayGoodbye() {
            var authorizationData = AuthorizationData.builder()
                            .client(true)
                            .contract(false)
                            .operationType(OperationType.CONSULTIVE)
                            .scope(Scope.CHANNEL).build();
            return Mono.justOrEmpty(authorizationData)
                    .flatMap(authorizationService::authorize)
                    .thenReturn("Goodbye");
        }
    }

1. Injects the `AuthorizationService` in the Service component.

2. Creates the `AuthorizationData` in order to define the kind of operative security to be applied to that method.

3. Invokes the ***authorize*** function to apply the security validation.

and for **Servlet applications**:

    import com.santander.darwin.core.authorization.AuthorizationData;
    import com.santander.darwin.core.authorization.AuthorizationService;
    import com.santander.darwin.core.authorization.types.OperationType;
    import com.santander.darwin.core.authorization.types.Scope;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    @Service
    public class HelloService {

        @Autowired
        AuthorizationService<Authentication> authorizationService; (1)

        public String sayHello() {
            var authorizationData = AuthorizationData.builder() (2)
                    .client(false)
                    .contract(false)
                    .operationType(OperationType.CONSULTIVE)
                    .scope(Scope.CHANNEL).build();
            authorizationService.authorize(authorizationData); (3)
            return "hello";
        }

        public String sayGoodbye() {
            var authorizationData = AuthorizationData.builder()
                    .client(true)
                    .contract(false)
                    .operationType(OperationType.CONSULTIVE)
                    .scope(Scope.CHANNEL).build();
            authorizationService.authorize(authorizationData);
            return "goodbye";
        }
    }

1. Injects the `AuthorizationService` in the Service component.

2. Creates the `AuthorizationData` in order to define the kind of operative security to be applied to that method.

3. Invokes the ***authorize*** function to apply the security validation.

#### Manual mode for Portugal applications

In order to enable the manual mode for applications that they are going to server for Portugal business, it is necessary to use the following parametrization for configuring the properties:

    darwin:
      security:
        authorization:
          manual:
            enabled: true
            mode: PORTUGAL
          remote:
            bolaseg: ${env.bolaseg-endpoint}

Previously to invoke to the ***authorize*** method, the `AuthorizationData` object must be parametrized properly for applying operative security based in Portugal validations.

The `AuthorizationData` has three fields that they are mandatory to inform in order to apply security validations. The rest of the fields don't have any effect for the validations available in this mode.

For **reactive applications**, it would be as simple as:

    import com.santander.darwin.core.authorization.AuthorizationData;
    import com.santander.darwin.core.authorization.AuthorizationService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.security.core.Authentication;
    import org.springframework.stereotype.Service;
    import reactor.core.publisher.Mono;

    @Service
    public class PortugalService {

        @Autowired
        AuthorizationService<Mono<Authentication>> reactiveAuthorizationService; (1)

        public Mono<String> validatingContractId() {
            var authorizationData = AuthorizationData.builder() (2)
                            .clientId("0001") // Customer id
                            .contractId("0002") // Contract id
                            .buidl();

            return this.reactiveAuthorizationService.authorize(authorizationData) (3)
                    .map(ignored -> "OK")
                    .switchIfEmpty(Mono.error(IllegalStateException::new));
        }

        public Mono<String> validatingCardNumber() {
            var authorizationData = AuthorizationData.builder()
                            .clientId("0001") // Customer id
                            .cardId("0003") // Card number
                            .buidl();
            return this.reactiveAuthorizationService.authorize(authorizationData)
                    .map(ignored -> "OK")
                    .switchIfEmpty(Mono.error(IllegalStateException::new));
        }
    }

1. Injects the `reactiveAuthorizationService` in the Service component.

2. Creates the `AuthorizationData` in order to define the kind of operative security to be applied to that method.

3. Invokes the ***authorize*** function to apply the security validation.

and for **Servlet applications**:

    import com.santander.darwin.core.authorization.AuthorizationData;
    import com.santander.darwin.core.authorization.AuthorizationService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.security.core.Authentication;
    import org.springframework.stereotype.Service;

    import java.util.Objects;

    @Service
    public class PortugalService {

        @Autowired
        AuthorizationService<Authentication> servletAuthorizationService; (1)

        public String validatingContractId() {
            var authorizationData = AuthorizationData.builder() (2)
                            .clientId("0001") // Customer id
                            .contractId("0002") // Contract id
                            .buidl();
            if (Objects.isNull(this.servletAuthorizationService.authorize(authorizationData))) { (3)
                return "OK";
            }
            else {
                throw new IllegalStateException();
            }
        }

        public String validatingCardNumber() {
            var authorizationData = AuthorizationData.builder()
                            .clientId("0001") // Customer id
                            .cardId("0003") // Card number
                            .buidl();
            if (Objects.isNull(this.servletAuthorizationService.authorize(authorizationData))) { (3)
                return "OK";
            }
            else {
                throw new IllegalStateException();
            }
        }
    }

1. Injects the `servletAuthorizationService` in the Service component.

2. Creates the `AuthorizationData` in order to define the kind of operative security to be applied to that method.

3. Invokes the ***authorize*** function to apply the security validation.
