# Darwin Spring Boot Omnichannel ![4.3.3-RELEASE](https://img.shields.io/badge/4.3.3-RELEASE-FF073D)

![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot Omnichannel` library allows storing and manage all the configurable properties associated to each supported channel within the Banco Santander architecture.

!!! info "Important"

    This functionality depends on receiving the channel information. The channel is obtained from the "channel_tp" claim of the authentication token, in case it is not informed it will use the `X-Santander-Channel` header. 

It also has functionality to process the user-agent header.

## Functionality

### Map of existing channels

A Bean named **channelMap** is exposed with the information of the [default defined channels](#initial-configuration) along with the user defined ones. This Bean is of type `Map<String, Map<String, ContactPoint>>>`, so its information can be
accessed as we would normally do in a map.

Below are proposed [examples](#how-to-overwrite-the-value-of-a-channel) for overwriting or adding channels.

### Http client interceptors

#### RestTemplate Interceptor

The omnichannel library installs an interceptor for `RestTemplate` that allows propagating the *ContactPoint* in the `HTTP` ***Contact-Point*** header.

- A `ClientHttpRequestInterceptor` named `OmniChannelInterceptor` is injected in charge of adding/propagating the HTTP header ***Contact-Point*** with the corresponding information:

    - application

    - device

    - operatingSystem

    - medium

    - userType

!!! tip "Caution"

    It is necessary for the project to register a `RestTemplate` type bean and stereotype it with the `@DarwinQualifier` annotation for the instrumentation to be applied.

This functionality is completely transparent to the user, if the project registers a bean of type `RestTemplate` without the `@DarwinQualifier` annotation, it is understood that you want to use your own `RestTemplate` instead of the one configured
by `Darwin` so the instrumentation will **NOT** be applied.

    ...
    @Autowired
    @DarwinQualifier
    private RestTemplate restTemplate (1)
    ...
    ...
    restTemplate.getForObject(...)
    ...

1. We inject the `RestTemplate` bean annotated with **@DarwinQualifier**.

#### WebClient Interceptor

The omni-channeling library installs a `WebClient` interceptor that allows propagating the *ContactPoint* in the `HTTP` ***Contact-Point*** header.

- The `Beans` `WebClient` and `WebClient.Builder` are configured with an `ExchangeFilterFunction` named `OmniChannelReactiveFilterFunction` and `OmniChannelServletFilterFunction`, in charge of propagating the HTTP ***Contact-Point*** header with
    the corresponding information:

    - application

    - device

    - operatingSystem

    - medium

    - userType

This functionality is completely transparent to the user if you register a bean of type `WebClient` or `WebClient.Builder`, as shown below:

    ...
    @Autowired
    private WebClient.Builder webClientBuilder; (1)
    ...
    ...
    WebClient webClient = webClientBuilder.baseUrl("http://server").build();
    webClient.get().retrieve().bodyToMono(...)
    ...

1. We inject the `WebClient.Builder` bean.

!!! tip "Caution"

    It is necessary that the project registers a bean of type `WebClient.Builder` or `WebClient` for the instrumentation to be applied. If the project creates an instance of `WebClient` with the keyword `new`, the instrumentation
    will **NOT** work.

### Servlet applications

#### HttpReader

A `HttpWebChannelReader` bean is exposed from the `HttpReader` interface to retrieve the entity, channel and contact point of the HTTP request. It first tries to retrieve it from the **headers** (default ***organization***, ***X-Santander-Channel***
and ***Contact-Point***) and, if not found, from the **parameters** of the request (default ***entity*** and ***channel***), the contact point in this case is not looked for in the parameters, the information is extracted from the `ContactPoint`
object, which is located in `DarwinContext`.

#### Omnichannel Web Filter

A `GenericFilterBean` bean is exposed to fill the `ContactPoint` of the **DarwinContext** with the information associated to the request's channel and *Contact-Point*.
The channel is obtained from the claim *channel_tp* of the authentication token, if not reported, the channel returned by `HttpWebChannelReader` will be used.

!!! info "Important"

    The default order will be OrderedFilter.REQUEST\_WRAPPER\_FILTER\_MAX\_ORDER - 15 == 0 - 15 == -15.

!!! note

    Since Darwin **2.11.4-RELEASE** and **3.0.2-RELEASE** versions are also valid the fields "**appName**" and "**os**" in Contact-Point header to fill *application* and *operatingSystem* properties of ContactPoint object.

#### User-Agent Web Filter

A `OncePerRequestFilter` bean is exposed to fill the `ContactPoint` of the **DarwinContext** with the information associated to the request's *User-Agent*.

!!! info "Important"

    The default order will be OmniChannelFilter.DEFAULT\_ORDER + 1 == -15 + 1 == -14.

### Reactive Applications

#### HttpReader

A `HttpReactiveChannelReader` bean is exposed from the `HttpReader` interface to retrieve the entity, channel and contact point of the HTTP request. It first tries to retrieve it from the **headers** (default ***organization***,
***X-Santander-Channel*** and ***Contact-Point***) and, if not found, from the **parameters** of the request (default ***entity*** and ***channel***), the contact point in this case is not looked for in the parameters, the information is extracted
from the `ContactPoint` object, which is located in `DarwinContext`.

#### Omnichannel Web Filter

A `OrderedWebFilter` Bean is exposed to populate the `ContactPoint` of the **Reactive DarwinContext** with the information associated to the request's channel and *Contact-Point*.
The channel is obtained from the claim *channel_tp* of the authentication token, if not reported, the channel returned by `HttpReactiveChannelReader` will be used.

!!! info "Important"

    The default order will be OrderedWebFilter.REQUEST\_WRAPPER\_FILTER\_MAX\_ORDER - 15 == 0 - 15 == -15.

!!! note

    Since Darwin **2.11.4-RELEASE** and **3.0.2-RELEASE** versions are also valid the fields "**appName**" and "**os**" in Contact-Point header to fill *application* and *operatingSystem* properties of ContactPoint object.

#### User-Agent Web Filter

A `OrderedWebFilter` bean is exposed to fill the `ContactPoint` of the **Reactive DarwinContext** with the information associated to the request's *User-Agent*.

!!! info "Important"

    The default order will be OmniChannelWebFilter.DEFAULT\_ORDER + 1 == -15 + 1 == -14.

## Installation and configuration

To add the library to any project you will have to include the maven dependency in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-omnichannel</artifactId>
    </dependency>

If we want to add the functionality to parse the User-Agent header and get the **device** and **operatingSystem** fields, we will have to add the following dependency:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-omnichannel-ua-parser</artifactId>
    </dependency>

!!! warning "Warning"

    The use of the **darwin-spring-boot-starter-omnichannel-ua-parser** dependency leads to a memory consumption of 100Mb, so we only recommend its use when it is essential to obtain the **device** and **operatingSystem** fields.

### Configuration

<!tag:properties>

| Name                                  | Default                          | Required | Description                                                                                                                                            | Supported                        | Environment                                              |
|---------------------------------------|----------------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|----------------------------------------------------------|
| darwin.omnichannel.header.entity      | <code>organization</code>        | No       | Name of the HTTP header for the entity                                                                                                                 | String                           | <ul><li><p>Servlet</p></li><li><p>Reactive</p></li></ul> |
| darwin.omnichannel.header.channel     | <code>X-Santander-Channel</code> | No       | Name of the HTTP header for the channel                                                                                                                | String                           | <ul><li><p>Servlet</p></li><li><p>Reactive</p></li></ul> |
| darwin.omnichannel.parameter.entity   | entity                           | No       | Parameter where the entity will be fetched if the <code>organization</code> header does not exist or is null and if it is not found in the URL         | String                           | <ul><li><p>Servlet</p></li><li><p>Reactive</p></li></ul> |
| darwin.omnichannel.parameter.channel  | channel                          | No       | Parameter where the channel will be fetched if the <code>X-Santander-Channel</code> header does not exist or is null and if it is not found in the URL | String                           | <ul><li><p>Servlet</p></li><li><p>Reactive</p></li></ul> |
| darwin.omnichannel.externalChannelMap | -                                | No       | Map to overwrite the original channel information or define new channels                                                                               | <String, <String, ContactPoint>> | <ul><li><p>All</p></li></ul>                             |
| darwin.omnichannel.filter.order       | -15                              | No       | Order in which the omnichannel filter is placed in the chain                                                                                           | Number                           | <ul><li><p>All</p></li></ul>                             |

<!end:properties>

### Initial configuration

When starting the library, an initial load is executed filling the `channelMap` with the following default configuration:

    {
      "ALL" : {
          "OFI": {
            "originChannel": "OFI",
            "marcoChannel": "OFI",
            "environment": "INTRANET",
            "logicalChannel": "0007",
            "physicalChannel": "0019",
            "commercialChannel": "RED",
            "operationalChannel": "RED"
          },
          "INT": {
            "originChannel": "INT",
            "marcoChannel": "INT",
            "environment": "INTERNET",
            "logicalChannel": "0001",
            "physicalChannel": "0022",
            "commercialChannel": "002",
            "operationalChannel": "002"
          },
          "RML": {
            "originChannel": "RML",
            "marcoChannel": "RML",
            "environment": "INTERNET",
            "logicalChannel": "0031",
            "physicalChannel": "0019",
            "commercialChannel": "BML",
            "operationalChannel": "BML"
          },
          "CIC": {
            "originChannel": "CIC",
            "marcoChannel": "CIC",
            "environment": "CONTACTCENTER",
            "logicalChannel": "0029",
            "physicalChannel": "0018",
            "commercialChannel": "020",
            "operationalChannel": "020"
          },
          "EMP": {
            "originChannel": "EMP",
            "marcoChannel": "EMP",
            "environment": "EMPRESAS",
            "logicalChannel": "0022",
            "physicalChannel": "0018",
            "commercialChannel": "014",
            "operationalChannel": "014"
          },
          "EMP_MOV": {
            "originChannel": "EMP_MOV",
            "marcoChannel": "EMP",
            "environment": "EMPRESAS",
            "logicalChannel": "0033",
            "physicalChannel": "0018",
            "commercialChannel": "014",
            "operationalChannel": "014"
          },
          "PLR": {
            "originChannel": "PLR",
            "marcoChannel": "PLR",
            "environment": "INTERNET",
            "logicalChannel": "5017",
            "physicalChannel": "0060",
            "commercialChannel": "RED",
            "operationalChannel": "RED"
          },
          "RCA": {
            "originChannel": "RCA",
            "marcoChannel": "RCA",
            "environment": "INTRANET",
            "logicalChannel": "0001",
            "physicalChannel": "0018",
            "commercialChannel": "RED",
            "operationalChannel": "RED"
         }
      }
    }

The main key represents the code of an entity, and whose value defines the channel map per entity whose input key is the `originChannel` and value are instances of `ContactPoint`, allowing us to manage the multi-entity.

For this entity map two types of main key can be defined.

- ALL → under this key the default channel map will be inserted.

- Entity → will belong to the code of an entity and will be able to hang a structure identical to the one hanging from ALL.

This initial configuration can be replaced by another one decided by the project, for that the only thing to do is to define a file named `darwinchannels.json` and place it in the `resources` section, that is to say, anywhere below
`src/main/resources`. On startup of the microservice, the `omnicanality` library will try to load the initial configuration from this file, in case it does not exist, the default configuration shown above will be loaded.

On the other hand, the `omnichannel` library will leave an INFO type trace in the application log with the initial configuration applied. The specific trace will be:

    DARWIN OmniChannel config = {ALL={OFI=ContactPoint(originChannel=OFI, marcoChannel=OFI, environment=INTRANET, logicalChannel=0, physicalChannel=0, commercialChannel=RED, operationalChannel=RED, application=null, device=null, operatingSystem=null, medium=null, userType=null), INT=ContactPoint(originChannel=INT,...  etc.

In addition, this startup information can be rewritten by the developer to add and/or modify the channels he/she deems appropriate through the `darwin.omnichannel.externalChannelMap` property. For this refer to the following
[section](#how-to-overwrite-the-value-of-a-channel).

### Complete configuration for Web applications

In case of a Web application (`Servlet/Reactive`) the following can be configured:

    darwin:
      omnichannel:
        header:
          entity: nombreCabeceraHTTP_Entity # (1)
          channel: nombreCabeceraHTTP_Channel
        parameter:
          entity: nombreParametroQueryString_Entity # (2)
          channel: nombreParametroQueryString_Channel

1. By default, if nothing is configured, the library will look for the following HTTP header to retrieve the entity and channel: ***organization*** and ***X-Santander-Channel***. If the name of the HTTP header where the entity or the channel will
    go has another name, the property must be configured.

2. If the library does not find the header or its value is null it will try to look for the entity or the channel as parameters of the URL. If nothing is configured it will look for the parameter with name: ***entity*** and ***channel***
    respectively. If you want another name for the parameter you will have to configure the property

### Configuration Headers propagation

To configure omnicahnnel propagation headers you can use the following example

    darwin:
        core:
            headers:
              enabled: true # Enable/disable propagation headers
              exclude:
                - endpoint: "https://some.api"
                  common: false
                  logging: true
                  security: true
                - endpoint: "https://another.api"
                  common: true
                  logging: true
                  security: true

!!! info "Important"

    When we call to *"https://some.api/\*"* we do not exclude the omnichannle headears to the propagation.

!!! info "Important"

    When we call to *"https://another.api"* we will exclude the omnichannle headers to the propagation.

For more information about the Propagation Headers visit [more information](../darwin-spring-boot-logging/README.md#header-propagation)

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

## Exposed API

| Name                                                                                            | Type                                                                        | Description                                                                                                                                                                 | Type Application |
|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| ChannelMap                                                                                      | `Map<String, Map<String, ContactPoint>>`                                     | Bean of a map that allows us to obtain the information associated to a certain channel of a specific entity, contained in a ContactPoint object, from the name of the same. | All              |
| N / A                                                                                           | ContactPoint                                     | Java POJO to store information associated to each channel.                                                                                                                  | All              |
| [HttpWebChannelReader](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/readers/HttpWebChannelReader.html)           | [HttpReader](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/readers/HttpReader.html)           | CAuxiliary class with which the entity and the channel can be extracted from the header or parameter of a request.                                                          | Servlet          |
| [HttpReactiveChannelReader](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/readers/HttpReactiveChannelReader.html) | [HttpReader](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/readers/HttpReader.html)           | Auxiliary class with which the entity or channel can be extracted from the header or parameter of a request.                                                                | Reactive         |
| [OmniChannelFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/filter/OmniChannelFilter.html)                  | [GenericFilterBean](https://docs.spring.io/spring-framework/docs/6.0.21/javadoc-api/org/springframework/web/filter/GenericFilterBean.html)   | OmniChannel Filter for Servlet applications.                                                                                                                                | Servlet          |
| [OmniChannelWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/filter/OmniChannelWebFilter.html)            | [WebFilter](https://docs.spring.io/spring-framework/docs/6.0.21/javadoc-api/org/springframework/web/server/WebFilter.html)                   | OmniChannel Filter for Reactive applications.                                                                                                                               | Reactive         |
| [UserAgentFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/filter/UserAgentFilter.html)                      | [GenericFilterBean](https://docs.spring.io/spring-framework/docs/6.0.21/javadoc-api/org/springframework/web/filter/OncePerRequestFilter.html) | UserAgent Filter for Servlet applications.                                                                                                                                  | Servlet          |
| [UserAgentWebFilter](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/omnichannel/filter/UserAgentWebFilter.html)                | [WebFilter](https://docs.spring.io/spring-framework/docs/6.0.21/javadoc-api/org/springframework/web/server/WebFilter.html)                   | UserAgent Filter for Reactive applications.                                                                                                                                 | Reactive         |

### ContactPoint

The information associated to each channel is managed with a `POJO ContactPoint` class. It has the following structure:

    public class ContactPoint implements Serializable {
        // Constants for originChannel
        public final static String ORIGIN_OFI           = "OFI";
        public static final String ORIGIN_RCA           = "RCA";
        public final static String ORIGIN_INT           = "INT";
        public final static String ORIGIN_RML           = "RML";
        public final static String ORIGIN_CIC           = "CIC";
        public final static String ORIGIN_EMP           = "EMP";
        public final static String ORIGIN_EMP_MOV       = "EMP_MOV";
        public final static String ORIGIN_PLR           = "PLR";

        // Constants for globalChannel
        public final static String GLOBAL_OFI           = "OFI";
        public static final String GLOBAL_RCA           = "RCA";
        public final static String GLOBAL_INT           = "INT";
        public final static String GLOBAL_RML           = "RML";
        public final static String GLOBAL_CIC           = "CIC";
        public final static String GLOBAL_EMP           = "EMP";
        public final static String GLOBAL_PLR           = "PLR";

        // Constants for environment
        public final static String ENV_INTRANET         = "INTRANET";
        public final static String ENV_INTERNET         = "INTERNET";
        public final static String ENV_EMPRESAS         = "EMPRESAS";
        public final static String ENV_CONTACTCENTER    = "CONTACTCENTER";

        // Fields
        private String originChannel;
        private String marcoChannel;
        private String environment;
        private String logicalChannel;
        private String physicalChannel;
        private String commercialChannel;
        private String operationalChannel;
        private String application;
        private String device;
        private String operatingSystem;
        private String medium;
        private String userType;
    }

## Use cases

### How to overwrite the value of a channel

You can overwrite one or more values of a channel. For example:

    darwin:
      omnichannel:
          external-channel-map:
            ALL:
                OFI:
                  marco-channel: OFI_W
                  environment: INTRANET_Z

For the already existing default channel 'OFI' the fields 'frame-channel' and 'environment' have been overwritten.

### How to add a new channel in the default entity

To add a new channel in the default entity ("ALL") just use an identifier that does not exist.

For example to create a new channel with name 'NEW\_CHANNEL':

    darwin:
      omnichannel:
        external-channel-map:
          ALL:
              NEW_CHANNEL:
                origin-channel: NEW_CHANNEL
                marco-channel: VALUE_1
                environment: VALUE_2
                logical-channel: VALUE_3
                physical-channel: VALUE_4
                commercial-channel: VALUE_5
                operational-channel: VALUE_5
                ...etc...

!!! info "Important"

    The name of any field must match exactly (case sensitive) the field in the `POJO ContactPoint`.

These are the ones defined and currently used:

    private String originChannel;
    private String marcoChannel;
    private String environment;
    private String logicalChannel;
    private String physicalChannel;
    private String commercialChannel;
    private String operationalChannel;

The originChannel field represents the `key` which in the above example is `NEW_CHANNEL`.

### How to add a new channel for a new entity

To add a new channel in a new entity just define the entity and one or more values of a channel.

For example to create a new channel in entity "0075":

    darwin:
      omnichannel:
        external-channel-map:
          "0075":
              NEW_CHANNEL:
                origin-channel: NEW_CHANNEL
                marco-channel: VALUE_1
                environment: VALUE_2
                logical-channel: VALUE_3
                physical-channel: VALUE_4
                commercial-channel: VALUE_5
                operational-channel: VALUE_5
                ...etc...

### How to retrieve the channel from the SecurityContext (Servlet applications only)

!!! info "Important"

    This functionality is exclusive for `Servlet` type applications. If the `Darwin` authentication library is used, it is also possible to retrieve the `ContactPoint` object from the security context. This example details how to
    do it:

        ...
        import org.springframework.security.core.Authentication;
        import org.springframework.security.core.context.SecurityContextHolder;
        ...
        import ContactPoint;
        import SantanderUserDetails;
        ...
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof SantanderUserDetails) {
            SantanderUserDetails santanderUD = (SantanderUserDetails) auth.getPrincipal();
            ContactPoint contactPoint = santanderUD.getContactPoint();
            if (contactPoint != null ) {
                ...
            }
        }

!!! info "Important"

    In future versions this functionality will be removed but for the moment it is kept for backward compatibility. &lt;&lt;darwin-context, The recommendation is to retrieve the `ContactPoint` from the `DarwinContext`.

### How to retrieve the channel from the DarwinContext

#### Non-reactive environments

The `DarwinContextHolder` object is initialized by the OmniChannel filter (`OmniChannelFilter`) so to retrieve the channel information you have to use code like this:

    ...
    ...
    ContactPoint contactPoint = DarwinContextHolder.getCurrentContext().getContactPoint();
    if (contactPoint != null ) {
            ...
        }
    ...

This code will obtain the `ContactPoint` object from the `DarwinContext`.

#### Reactive environments

In the case of reactive environments, the `DarwinContext` object is initialized by the `DarwinReactiveWebFilter`, so to retrieve the channel information you have to use a code like this:

    Mono<ContactPoint> contactPoint = ReactiveDarwinContextHolder.getContext() (1)
                                        .map(context -> context.getContactPoint()); (2)

1. The getContext() method returns a monkey that will emit the context.

2. Using the map method, the context is accessed and the result of the getContactPoint() method is mapped. The result is a Monkey that will emit the `ContactPoint` to which it is possible to subscribe to retrieve the channel.

### How to propagate the channel in NotWeb applications

This functionality is no longer part of this module, the equivalent example is in the [Core: Propagate headers in NotWeb applications](../darwin-spring-boot-core/README.md#header-propagation-in-notweb-applications) module.

### Contact-Point header propagation

The Omnichannel library provides the functionality to automatically intercept the `Contact-Point` header and update the *ContactPoint* object. The library installs interceptors for both `RestTemplate` and `WebClient` that allow propagating the
*ContactPoint* in the `HTTP` ***Contact-Point*** header: [WebClient interceptor](#webclient-interceptor) and [RestTemplate interceptor](#resttemplate-interceptor).

Example of the header being propagated:

    {"application": "appInit", "device": "user-Agent-device", "operatingSystem": "user-Agent-os", "medium": "medium", "userType": "userType"}

!!! info "Important"

    A Darwin microservice always propagate the `Contact-Point` header with this format.

There are 3 possible cases:

1. **the header is received from *front*.**

    When the `Contact-Point` header is received from *Front* it is with the following format, only 3 fields:

        { "appName": "dwproject11", "device": "desktop", "os": "windows"}

    These fields, received in the header, **update the *ContactPoint*** object with the received values.

    !!! note

        ***appName*** and ***os*** fields are associated to *application* and *operatingSystem* properties, and they are propagated with their regular names. For this case the fields ***medium*** and ***userType*** are not received
        in the header, they will be empty and thus propagated. If they exist in the *ContactPoint* object, then they will be added in the header with the values that exist in it.

2. **A header with 5 fields is received.**

    The fields received in the header **update the *ContactPoint*** object with the received values.

         {"application": "appInit", "device": "device", "operatingSystem": "os", "medium": "medium", "userType": "userType"}

3. **No header received**

    The *ContactPoint* object is initialized as follows:

    | Field           | Value                                                     | Default           |
    |-----------------|-----------------------------------------------------------|-------------------|
    | application     | appInit (if exists).                                      | "" (empty String) |
    | device          | Value extracted from `User-Agent` header (if exists).     | "" (empty String) |
    | operatingSystem | Value extracted from the `User-Agent` header (if exists). | "" (empty String) |
    | medium          | Value from ContactPoint object defined by the project.    | "" (empty String) |
    | userType        | Value from ContactPoint object defined by the project.    | "" (empty String) |

    !!! note

        **device** and **operatingSystem** fields are filled only if darwin-spring-boot-starter-omnichannel-ua-parser is used 

    Values of the fields

        {"application": "appInit", "device": "user-Agent-device", "operatingSystem": "user-Agent-os", "medium": "medium", "userType": "userType"}

#### Modification of the ContactPoint object

We can set the values of the 5 fields that are propagated in the `Contact-Point` header as follows.

Modify the *ContactPoint* object through the `toBuilder()` method.

    if (cp != null) {
    contactPoint.toBuilder().application("appModified")
                            .device("deviceModified").operatingSystem("osModified")
                            .medium("mediumModified").userType("userTypeModified").build();
    ...

You have to take into account how to retrieve/save the object in context, for servlet or reactive:

In servlet applications:

    ContactPoint contactPoint = DarwinContextHolder.getCurrentContext().getContactPoint();
    ...
    darwinContext.setContactPoint(contactPoint);
    }

In reactive applications:

    Mono<ContactPoint> contactPoint = ReactiveDarwinContextHolder.getContext()
                                        .map(context -> context.getContactPoint());
    ...

The result would be as follows:

    {"application": "appModified", "device": "deviceModified", "operatingSystem": "osModified", "medium": "mediumModified", (1) "userType": "userTypeModified" (1)}

1. Recall that these fields are currently not reported if the header arrives from *front*.

!!! note

    The interceptors we inject into `RestTemplate` and/or `WebClient` make use of `DarwinContext` to retrieve information from the `ContactPoint` or the header of the same name. In `Web` applications, `DarwinContext` is
    initialized thanks to `Web` filters that `Darwin` creates and initializes; however, in `NotWeb` applications we do not have such filters, so the `DarwinContext` object is not automatically initialized.

**^1**: If we run the application with `Spring Web` dependencies on a `Tomcat` servlet server, the **Servlet** type configuration will be applied and, therefore, the ***NotWeb*** type configuration

**^2**: If we run the application with the `Spring WebFlux` dependencies on a `Netty` reactive server, the configuration of type ***Reactive*** will be applied, and therefore the configuration of type ***NotWeb***.
