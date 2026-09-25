# Darwin Spring Boot WebService ![4.3.3-RELEASE](https://img.shields.io/badge/4.3.3-RELEASE-FF073D)

![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Darwin Spring Boot WebService` library was created to facilitate the sending of SOAP requests to Web Services, providing mechanisms to:

- Propagate security in the request.

- Selecting the Web Service endpoint based on the channel information.

- Creation of the SOAP request based on a java object with JAXB.

## Functionality

The library will autoconfigure only those functionalities that apply to the environment in which the application is located. To define the execution environment of a `Spring Boot` application we will make use of the values defined in
[WebApplicationType](https://docs.spring.io/spring-boot/docs/3.1.12/api/org/springframework/boot/WebApplicationType.html), being able to define it by means of a property or in code:

- To make use of the property:

<!-- -->

    spring.main.web-application-type=NONE # REACTIVE, SERVLET

- To do this through code we will make use of the `SpringApplicationBuilder` class:

<!-- -->

    @SpringBootApplication
    public class Application {
        public static void main(String[] args) {
            new SpringApplicationBuilder(Application.class)
                    .web(WebApplicationType.NONE) // .REACTIVE, .SERVLET
                    .run(args);
        }
    }

If the application type is not defined when using this library, `Spring Boot` will select the environment according to the following:

- If `starter spring-web` is found it will boot in `SERVLET` mode.

- Otherwise, it will boot in `REACTIVE` mode.

!!! info "Important"

    The library always incorporates the `starter spring-webflux` from the `starter Darwin Spring Boot Authentication`, so the default application will be **WebApplicationType.REACTIVE**.

The application types that the library is able to detect are:

- ***NotWeb***: The application does not run as a web application and therefore should not start an `embedded web server`. but it detects the presence of the `restTemplate` and `webClient` dependency so they are auto-configured with the `Darwin`
    interceptors.

- ***Servlet***: The application runs as a `Servlet` based web application and therefore should start an `embedded web server`, by default `Tomcat`.

- ***Reactive***: The application runs as a reactive web application based on `WebFlux` and therefore should start an `embedded web server`, by default `Netty`.

For these possible environments the library can be configured according to the following scheme:

- ***NotWeb***: reactive and non-reactive components[^1].

- ***Servlet***: non-reactive components.

- ***Reactive***: reactive components.

### NotWeb applications

A **NotWeb application** will have the beans and therefore all the functionality of both environments so that the project can use the one that suits it best, this implies that it will have at its disposal both the `EndpointSelector` and the
`WebServiceHelper` of `Servlet` applications and the `WebServiceHelper` of `Reactive` applications.

### Servlet applications

#### Interceptors

A bean with name `interceptorsBean` and type `Map<String, ClientInterceptor>` is exposed with interceptors that allow the insertion of a `wsse:Security soap:Header` in the request to a `Web Service`. in the request to a `Web Service`. The
interceptors are created by the library itself, for use by developers. They are the following:

- `BankSphereTokenInterceptor`: Interceptor in charge of injecting a `BKS` token in the request to the `Web Service`.

- Wss4jSecurityInterceptor: Interceptor in charge of injecting a `UsernameToken` in the request to the `Web Service`.

#### Endpoint selection

Exposes a bean with name `webEndpointSelectorService` and type `WebEndPointSelectorService` that allows to select the **endpoint of the Web Service according to the channel** it is in from a `ResourcesBean` configured in the application properties.

### Reactive Applications

#### WebService Helper

Exposes a bean with name `darwinWSRequestHelper` and type `DarwinWSRequestHelper`, the functions of which are:

- Generate a SOAP message from a Java object created with JAXB and inject the `wsse:Security soap:Header` so that it can be used in a `WebClient`.

- Retrieve the endpoint that has been configured for a client and channel in the application properties, to be used in the `WebClient`.

## Installation and configuration

To add the library to any project you will need to include the maven dependency in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-webservice</artifactId>
    </dependency>

!!! info "Important"

    Note that in order to use the `BinarySecurityToken` tokens, the application must have the authentication library as a dependency, therefore `Darwin Starter Webservice` automatically imports the
    `Darwin Starter Authentication`.

| Application Type            | Environment | Dependencies                                                                                                                                                                                                                                                 |
|-----------------------------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| WebApplicationType.NONE     | NotWeb      | <ul><li>com.santander.darwin:darwin-spring-boot-starter-webservice</li></ul>                                                                                                                                                                                 |
| WebApplicationType.SERVLET  | Servlet     | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-webservice</strong></li><li>org.springframework.boot:<strong>spring-boot-starter-web</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul> |
| WebApplicationType.REACTIVE | Reactive    | <ul><li>com.santander.darwin:<strong>darwin-spring-boot-starter-webservice</strong></li><li>org.springframework.boot:<strong>spring-boot-actuator-autoconfigure</strong></li></ul>                                                                           |

### Non-reactive configuration

<!tag:properties-servlet>

| Name                                                                      | Default value | Required                     | Description                                                                                                                                                                                        | Type                                                          |
|---------------------------------------------------------------------------|---------------|------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| darwin.webservices.security-types                                         | N/A           | Yes                          | Types of security to be applied throughout SOAP clients                                                                                                                                            | List                                                          |
| darwin.webservices.security-types(i).name                                 | N/A           | Yes                          | Value that is mapped against the attribute "darwin.webservices.security-types.mode" attribute so that each client knows which one to use.                                                          | String                                                        |
| darwin.webservices.security-types(i).mode                                 | N/A           | Yes                          | BinarySecurityToken to authenticate using corporate token and UsernameToken to authenticate by username/password. Any other value will be interpreted as not putting security headers in the call. | <ul><li>Binary SecurityToken</li><li>Username Token</li></ul> |
| darwin.webservices.security-types(i).user                                 | N/A           | Only if mode = UsernameToken | UserId if mode is UsernameToken.                                                                                                                                                                   | String                                                        |
| darwin.webservices.security-types(i).password                             | N/A           | Only if mode = UsernameToken | Password if mode is UsernameToken.                                                                                                                                                                 | String                                                        |
| CLIENT_PROFILES_PATH                                                      | N/A           | No                           | Map with potential customers to be used to retrieve the endpoint per channel.                                                                                                                      | Map                                                           |
| CLIENT_PROFILES_PATH.{client}.security.name                               | N/A           | No                           | Name of the security for the client. Historically it had to match the name of the security type, but this is no longer required.                                                                   | String                                                        |
| CLIENT_PROFILES_PATH.{client}.resources.default-endpoint                  | N/A           | No                           | Default endpoint to be requested from the client if no other is obtained via the channel.                                                                                                          | String                                                        |
| CLIENT_PROFILES_PATH.{client}.resources.marco-channels                    | N/A           | No                           | Map with the endpoints associated with a channel that are defined in this are defined in this profile.                                                                                             | Map                                                           |
| CLIENT_PROFILES_PATH.{client}.resources.marco-channels.{channel}.endpoint | N/A           | No                           | Endpoint to be requested if the channel retrieved from the context or specified matches with {channel}.                                                                                            | String                                                        |

<!end:properties-servlet>

!!! note

    In property names, `(i)` is used to represent the members of a List or Set. And `{}` for elements of a map.

    The string CLIENT\_PROFILES\_PATH represents the path to the property file where the project has set the client configurations (the same path shall be used in the configuration class: [use
    case](#using-webendpointselectorservice)).

#### Basic configuration servlet

With the configuration defined below, only one interceptor will be available that will insert a security header to all SOAP requests based on the corporate token (type BKS) or UsernameToken.

    darwin:
      webservices:
        security-types:
           - name: corporateToken
             mode: BinarySecurityToken

    darwin:
      webservices:
        security-types:
           - name: userNameA
             mode: UsernameToken
             user: "11535750P"
             password: "14725836"

#### Full configuration servlet

In the following example, several types of security headers are defined for both types of security. Subsequently, a series of clients are defined, indicating which type of security they will use by means of their "name" parameter and the different
endpoints to which the request will be made, depending on the channel or not (this configuration is optional).

    darwin:
      webservices:
        security-types:
           - name: corporateToken
             mode: BinarySecurityToken
           - name: userNameA
             mode: UsernameToken
             user: ${myFirstUserName}
             password: ${myFirstUserPass}
           - name: userNameB
             mode: UsernameToken
             user: ${mySecondUserName}
             password: ${mySecondUserPass}
           - name: anyName1
             mode: noSecurity
        client1:
          resources:
            defaultEndpoint: "http://soap_end_point"
            marcoChannels:
              INT:
                endpoint: "http://soap_int_end_point"
              OFI:
                endpoint: "http://soap_ofi_end_point"
        client2:
          security:
            name: corporate
          resources:
            default-endpoint: "http://soap_end_point"
        client3:
          security:
            name: username
          resources:
            default-endpoint: "http://soap_end_point"
        client4:
          resources:
            default-endpoint: "http://soap_end_point"

!!! note

    In this example the CLIENT\_PROFILES\_PATH has been defined as `darwin.webservices`.

### Reactive configuration

<!tag:properties-reactive>

| Name                                                          | Default value | Required                           | Description                                                                                                                                                                                    | Type                                                          |
|---------------------------------------------------------------|---------------|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| darwin.webservices.security-types                             | N/A           | No                                 | Types of security to be applied throughout SOAP clients.                                                                                                                                       | List                                                          |
| darwin.webservices.security-types(i).name                     | N/A           | Only if security-types is defined  | Identifier to be used when this type of security is to be used.                                                                                                                                | String                                                        |
| darwin.webservices.security-types(i).mode                     | N/A           | Only if security-types are defined | BinarySecurityToken to authenticate using corporate token and UsernameToken to authenticate by user/password. Any other value will be interpreted as not putting security headers in the call. | <ul><li>Binary SecurityToken</li><li>Username Token</li></ul> |
| darwin.webservices.security-types(i).user                     | N/A           | Only if mode = UsernameToken       | UserId if mode is UsernameToken.                                                                                                                                                               | String                                                        |
| darwin.webservices.security-types(i).password                 | N/A           | Only if mode = UsernameToken       | Password if mode is UsernameToken.                                                                                                                                                             | String                                                        |
| darwin.webservices.client-profiles                            | N/A           | No                                 | Set of possible client profiles to be used to choose the URL of the WebService according to the channel.                                                                                       | Set                                                           |
| darwin.webservices.client-profiles(i).name                    | N/A           | Only if client-profiles            | Client profile identifier is defined.                                                                                                                                                          | String                                                        |
| darwin.webservices.client-profiles(i).defaultEndpoint         | N/A           | Only if client-profiles is defined | The default endpoint to be requested from if no other endpoint is fetched via the channel.                                                                                                     | String                                                        |
| darwin.webservices.client-profiles(i).marcoChannels           | N/A           | No                                 | Map with the channel (key) and endpoint (value) pairs that are defined in this profile.                                                                                                        | Map                                                           |
| darwin.webservices.client-profiles(i).marcoChannels.{channel} | N/A           | No                                 | Endpoint to be returned if the channel retrieved from the context matches {channel}.                                                                                                           | String                                                        |

<!end:properties-reactive>

!!! note

    Property names use `(i)` to represent members of a List or Set, `{}` for elements of a map.

!!! info "Important"

    As reflected, the configuration of the reactive implementation is "not mandatory", i.e. it can be left unconfigured and the library would still offer minimal functionality: it can be left unconfigured and the library would
    still offer minimal functionality. That is:

    - If `security-types` are not configured, the XML object will be returned in a SOAP message but no security headers will be injected.

    - If `client-profiles` are not configured, an empty string will be returned when the endpoint is requested.

#### Basic configuration reactive

With the configurations defined below, there would be only one type of security to use: corporateToken (BinarySecurityToken) or userNameA (UsernameToken).

    darwin:
      webservices:
        security-types:
           - name: corporateToken
             mode: BinarySecurityToken

    darwin:
      webservices:
        security-types:
           - name: userNameA
             mode: UsernameToken
             user: "11535750P"
             password: "14725836"

#### Full configuration reactive

With this configuration, in addition to being able to choose the type of security header to be inserted, it will be possible to choose the client profile with the endpoints to be used depending on the channel.

    darwin:
      webservices:
        security-types:
          - name: corporateToken
            mode: BinarySecurityToken
          - name: userNameA
            mode: UsernameToken
            user: "11535750P"
            password: "14725836"
          - name: userNameB
            mode: UsernameToken
            user: "55122241G"
            password: "14725836"
        client-profiles:
          - name: client1
            defaultEndpoint: "http://soap_end_point"
            marco-channels:
              INT: "http://soap_int_end_point"
              OFI: "http://soap_ofi_end_point"
          - name: client2
            defaultEndpoint: "http://soap_end_point"
            marco-channels:
              INT: "http://soap_int_end_point"
          - name: client3
            defaultEndpoint: "http://soap_end_point"

## Native compilation support

This library cannot be used on micros that are compiled to a native image with graalvm native. We are not able to execute in native mode next library:

- spring-ws

## Exposed API

| Name                                                                                                                                                                                                         | Type                                                                                                                                                               | Description                                                                                                                                                                                                     | Application Type                          |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| interceptorsBean                                                                                                                                                                                             | @Bean Map<String, [ClientInterceptor](https://docs.spring.io/spring-ws/docs/current/api/org/springframework/ws/client/support/interceptor/ClientInterceptor.html)> | Dictionary with the appropriate interceptor for the different security types defined in "darwin.webservices.security-types"                                                                                     | <ul><li>NotWeb</li><li>Servlet</li></ul>  |
| [WebEndPointSelectorService](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/ws/service/WebEndPointSelectorService.html) | @Bean                                                                                                                                                              | Service to get the endpoint of the Webservice according to the channel                                                                                                                                          | <ul><li>NotWeb</li><li>Servlet</li></ul>  |
| [DarwinWSRequestHelper](https://gluon.dev.corp/microservices/docs/darwin-spring-boot/4.3.3-RELEASE/apidocs/com/santander/darwin/ws/helper/DarwinWSRequestHelper.html)            | @Bean                                                                                                                                                              | Helper class for creating SOAP requests in WebClient with encapsulated objects and being able to select the encapsulated objects and to be able to select the target endpoint according to the current channel. | <ul><li>NotWeb</li><li>Reactive</li></ul> |

## Library use cases and advanced configuration

Below is an example of a Java class, `SoapObject`, whose instances will serve as payload (WebService input parameter) in the request of the examples:

    @Data
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = { "username", "data" })
    @XmlRootElement(namespace = com.santander.darwin.test.micro.service.ws.SoapObject.NAMESPACE_URI, name = "soapObject")
    public class SoapObject {

       public static final String NAMESPACE_URI = "http://darwin/security-web-service";

       @XmlElement(required = true)
       protected String username;

       @XmlElement(required = true)
       protected String data;

    }

### Web Service invocations in Servlet applications

#### Use of the library interceptors

For this example, it is assumed that the YML presents the [Basic Configuration](#basic-configuration-servlet) token-based configuration defined above. This means that the `interceptorsBean` will be a map of a single key-value pair, with an
interceptor including the header with the currently available `BKS` token.

The following Java class shows an example of use in a controller.

    @RestController
    @Slf4j
    @RequestMapping("/webservice")
    public class WebserviceController {

       @Value("${darwin.security.test.webservice-request-url}")
       private String endpointWS;

        Map<String, ClientInterceptor> interceptorsBean;

        public WebserviceController (Map<String, ClientInterceptor> interceptorsBean) {
            this.interceptorsBean = interceptorsBean;
        }

        @RequestMapping(value = "/soapsecurityrequest", method = RequestMethod.POST)
       public SoapObject addSoapSecurityHeaderToSoapRequest() throws Exception {
          WebServiceTemplate template = new WebServiceTemplate();

          // Create and configure marshaller
          Jaxb2Marshaller customMarshaller = new Jaxb2Marshaller();
          customMarshaller.setPackagesToScan(ClassUtils.getPackageName(SoapObject.class));
          customMarshaller.afterPropertiesSet();

          // Configure WebServiceTemplate
          template.setMarshaller(customMarshaller);
          template.setUnmarshaller(customMarshaller);
          template.setDefaultUri(endpointWS);
          // Get interceptor for "corporateToken" securityType and configure
          ClientInterceptor[] interceptors = { interceptorsBean.get("corporateToken") };
          template.setInterceptors(interceptors);

          SoapObject soapObject = createSoapObject();

          return (SoapObject) template.marshalSendAndReceive(soapObject);
       }
     }

1. A marshaller is generated based on the classes to be encoded in XML for the application (SoapObject.class).

2. The WebServiceTemplate is configured with the marshaller and the endpoint defined by the application itself.

3. The interceptor for the `SecurityType` "corporateToken" is obtained and set.

4. A SoapObject payload is generated (we abstract the implementation of the *createSoapObject()*) method).

5. A call is made to the `marshallSendAndReceive(payload)` method, which is in charge of making the request.

!!! note

    The `setInterceptors()` method expects an array of `ClientInterceptor` even if only one interceptor is defined.

With this implementation, the request will carry a header of the following type:

    <soapenv:Header>
        <wsse:Security soapenv:actor="http://www.isban.es/soap/actor/wssecurityUserPass" soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
           <wsse:BinarySecurityToken>[TOKEN-BKS]</wsse:BinarySecurityToken>
        </wsse:Security>
    </soapenv:Header>

#### Using WebEndpointSelectorService

It is possible to define the WebService endpoint according to the channel and client used using the WebEndpointSelectorService bean.

For example, it is assumed that the configuration file contains the [Full configuration servlet](#full-configuration-servlet) previously exposed and that you want to use only "client1". For this case it is necessary to define a configuration class
that collects the information from the `ResourcesBean` class:

    @ConfigurationProperties(prefix = "darwin.webservices.client1")
    @Data
    public class ClientProfileResourcesConfig {
        private ResourcesBean resources;
    }

With this configuration, an example controller could be as follows:

    @RestController
    @RequestMapping("/webservice")
    public class WebserviceController {

        private Map<String, ClientInterceptor> interceptorsBean;
        private WebEndPointSelectorService selector;
        private ClientProfileResourcesConfig clientProfile;

        public WebserviceController (Map<String, ClientInterceptor> interceptorsBean,
                            WebEndPointSelectorService selector, ClientProfileResourcesConfig clientProfile) {
            this.interceptorsBean = interceptorsBean;
            this.selector = selector;
            this.clientProfile = clientProfile;
        }

        @RequestMapping(value = "withendpoint", method = RequestMethod.POST)
       public SoapObject securityWithCustomEndpoint() throws Exception {
          WebServiceTemplate template = new WebServiceTemplate();

          // Create and configure marshaller
          Jaxb2Marshaller customMarshaller = new Jaxb2Marshaller();
          customMarshaller.setPackagesToScan(ClassUtils.getPackageName(SoapObject.class));
          customMarshaller.afterPropertiesSet();

          // Configure WebServiceTemplate
          template.setMarshaller(customMarshaller);
          template.setUnmarshaller(customMarshaller);

          // Get ResourcesBean from selected clientId and configure endpoint
          ResourcesBean resources = clientProfile.getResources();
          template.setDefaultUri(selector.getEndPoint(resources));

          // Get interceptor for "corporateToken" securityType and configure
          ClientInterceptor[] interceptors = {
                  interceptorsBean.get("userNameA")};
          template.setInterceptors(interceptors);

          SoapObject soapObject = new SoapObject();

          return (SoapObject) template.marshalSendAndReceive(soapObject);
       }
     }

Added to the steps of the previous case:

1. The ResourceBean defined in the properties for the configured client, in this case "client1", is collected.

2. The `WebEndPointSelectorService` class is used for the selection of the endpoint corresponding to the previous ResourceBean.

As in this case reference is made to the configuration of "client1"
and, assuming that the channel retrieved from the context is "INT",
a request shall be made to the endpoint `http://soap_int_end_point` in which a header of the type "INT" shall
be inserted:

    <soapenv:Header>
        <wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
         <wsse:UsernameToken>
         <wsse:Username>myFirstUserName</wsse:Username>
         <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">myFirstUserPass</wsse:Password>
         </wsse:UsernameToken>
       </wsse:Security>
      </soapenv:Header>

We can also have several client profiles configured, and choose in execution which one we want to use.

For this, it will be necessary to define other configuration classes different from the previous case: a POJO class with all the client information and another one that collects the client map of the properties:

    @Data
    @ConfigurationProperties(prefix = "darwin.webservices")
    public class ClientProfileProperties {
       private HashMap<String, ClientProfile> clientsProfiles;
    }

    @Data
    public class ClientProfile {
       private Security security;

       private ResourcesBean resources;
    }

If you want to define the name of the security type in the client for later use, you will also have to define the `Security` class:

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public class Security {
        private String name;
    }

Now, if for example we retrieve the client we want to use from the parameters in our controller's request, the class would look like this:

    @RestController
    @RequestMapping("/webservice")
    public class WebserviceController {

        private Map<String, ClientInterceptor> interceptorsBean;
        private WebEndPointSelectorService selector;
        private ClientProfileProperties clientProfiles;

        public WebserviceController (Map<String, ClientInterceptor> interceptorsBean,
                            WebEndPointSelectorService selector, ClientProfileProperties clientProfiles) {
            this.interceptorsBean = interceptorsBean;
            this.selector = selector;
            this.clientProfiles = clientProfiles;
        }

        @RequestMapping(value = "withendpoint", method = RequestMethod.POST)
       public SoapObject securityWithCustomEndpoint(@RequestParam String clientId) throws Exception {
          WebServiceTemplate template = new WebServiceTemplate();

          // Create and configure marshaller...

          // Configure WebServiceTemplate...

          // Get ResourcesBean from selected clientId and configure endpoint
          ResourcesBean resources = clientProfiles.getClientsProfiles().get(clientId).getResources();
          template.setDefaultUri(selector.getEndPoint(resources));

          // Get interceptor for "corporateToken" securityType and configure...

          SoapObject soapObject = new SoapObject();

          return (SoapObject) template.marshalSendAndReceive(soapObject);
       }
     }

### Web Service invocations in Reactive applications

To use the `WebService` library via `WebClient` (instead of `WebServiceTemplate`), a self-configured `DarwinWSRequestHelper` class bean is available.

You just need to use the appropriate method according to the information for the `WebClient` that you want it to provide:

- Define the body of the request: you must provide as attributes the XML object you want to encode as the body of the SOAP request, along with the security type you want to use to inject the security headers.

- Define the body and url of the request: in addition to the above, the name of the selected client must be added.

For these examples we define a `WsResponse` class that simulates the `webServices` responses:

    @Data
    @NoArgsConstructor
    public class WsResponse {

        private String user;

        private String result;

    }

#### Defining the request body in a WebClient

If you only want to generate the `SOAP` message, setting the endpoint to which the request is to be made and starting from the token-based [Basic Configuration](#basic-configuration-reactive) token-based, this would be an example of a microservice
calling a `WebService`:

    @RestController
    @RequestMapping("/webservice")
    public class WebserviceReactiveController {

        private final String WS_BASE_URL = "http://WsHostname:WsPort/webservice";

        private DarwinWSRequestHelper darwinWSRequestHelper;

        private WebClient.Builder webClientBuilder;

        public void WebserviceReactiveController(DarwinWSRequestHelper darwinWSRequestHelper,
                                                    WebClient.Builder webClientBuilder){
            this.darwinWSRequestHelper = darwinWSRequestHelper;
            this.webClientBuilder = webClientBuilder;
        }

        @PostMapping(value = "/getResponse")
        public Mono<WsResponse> getResponse() {
            // Create SoapObject for WebService
            SoapObject soapObject = createSoapObject();

            String securityType = "corporateToken";

            return darwinWSRequestHelper.encodeInput(soapObject, securityType)
                    .flatMap(data ->
                        webClientBuilder.baseUrl(WS_BASE_URL).build()
                                        .method(HttpMethod.POST).uri("/soap")
                                        .headers(h -> h.setContentType(MediaType.TEXT_XML))
                                        .body(BodyInserters.fromValue(data))
                                        .retrieve()
                                        .bodyToMono(WsResponse.class));
        }
    }

!!! info "Important"

    The SOAP message is generated as a text string in XML format, so you have to indicate in the headers that the content is of type `MediaType.TEXT_XML`.

Assuming that a `SoapObject` object is generated in the *createSoapObject()* method and that this microservice has been called with the following values in the headers:

- Authorization: \[TOKEN-BKS\].

The encodeInput() method shall return in a *Mono&lt;String&gt;* the `SOAP` message with the *soapObject* object encoded as `SOAPBody` and the security header corresponding to the type `corporateToken` (BinarySecurityToken):

    <soapenv:Header>
        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
           <wsse:BinarySecurityToken>[TOKEN-BKS]</wsse:BinarySecurityToken>
       </wsse:Security>
      </soapenv:Header>

However, if the security type "userNameA" (UsernameToken) had been configured, the following would be injected:

    <soapenv:Header>
        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
         <wsse:UsernameToken>
            <wsse:Username>11535750P</wsse:Username>
            <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">14725836</wsse:Password>
         </wsse:UsernameToken>
       </wsse:Security>
      </soapenv:Header>

#### Defining the request body and URL in a WebClient

If, in addition to generating the body of the request, you want to use an endpoint configured according to the client and the channel, and starting from the [Full configuration reactive](#full-configuration-reactive), this would be an example of a
microservice that invokes a WebService:

    @RestController
    @RequestMapping("/webservice")
    public class WebserviceReactiveController {

        private DarwinWSRequestHelper darwinWSRequestHelper;

        private WebClient.Builder webClientBuilder;

        public void WebserviceReactiveController(DarwinWSRequestHelper darwinWSRequestHelper,
                                                    WebClient.Builder webClientBuilder){
            this.darwinWSRequestHelper = darwinWSRequestHelper;
            this.webClientBuilder = webClientBuilder;
        }

        @PostMapping(value = "/getResponse")
        public Mono<WsResponse> getResponse() {
            // Create SoapObject for WebService
            SoapObject soapObject = createSoapObject();

            String securityType = "corporateToken";

            String clientId ="client1";

            return darwinWSRequestHelper
                        .encodeInputWithEndpoint(soapObject, securityType, clientId)
                        .flatMap(tuple -> webClientBuilder.build()
                                            .method(HttpMethod.POST)
                                            .uri(tuple.getT2())
                                            .headers(h -> h.setContentType(MediaType.TEXT_XML))
                                            .body(BodyInserters.fromValue(tuple.getT1()))
                                            .retrieve()
                                            .bodyToMono(WsResponse.class));
        }
    }

This microservice, in addition to defining the payload and the security type, defines the client identifier to be used to retrieve the URLs according to the channel.

Assuming that this microservice has been called with the following values in the headers:

- X-Santander-Channel: INT

- Authorization: \[BKS-TOKEN\].

The encodeInputWithEndpoint() method returns a *Mono&lt;Tuple2&lt;String,String&gt;&gt;* , where the first string of the tuple (*getT1()*) corresponds to the same SOAP message returned in the previous case, and the second string (*getT2()*) to the
URL obtained from the configuration : `http://soap_int_end_point`.

However, if the client "client3" had been chosen, the default configured URL would be returned, as it does not have a value for the INT channel: `http://soap_end_point`.

### Web Service invocations in NotWeb applications

#### Non-reactive environments

When dealing with a `NotWeb` application we have the same functionality as in [Servlet](#web-service-invocations-in-servlet-applications) applications, i.e. interceptors and WebEndpointSelectorService; however, in case we want to use a
`BankSphereTokenInterceptor` interceptor, before invoking the Web Service we will have to use the **non-reactive implementation** of the `SecurityManagerService` defined in the
[Authentication library](../darwin-spring-boot-security-authentication/README.md#tokenservice).

This is because this interceptor retrieves the authentication token from the security context or request headers. In a **Web application** there is a filter that populates the security context when authenticating the incoming request, but in
**non-Web applications** this function is covered by the `SecurityManagerService`.

The following rewrites the example [Use of the library interceptors](#use-of-the-library-interceptors) for a `NotWeb` application:

    import com.santander.darwin.security.authentication.service.SecurityManagerService;
    import org.springframework.stereotype.Service;

    @Service
    public class WebserviceCaller {

        @Value("${darwin.security.test.webservice-request-url}")
        private String endpointWS;

        Map<String, ClientInterceptor> interceptorsBean;
        SecurityManagerService<Authentication, Token> securityManagerService;

        public WebserviceCaller (Map<String, ClientInterceptor> interceptorsBean,
                                    SecurityManagerService<Authentication, Token> securityManagerService) { //(1)
            this.interceptorsBean = interceptorsBean;
            this.securityManagerService = securityManagerService;
        }

       public SoapObject addSoapSecurityHeaderToSoapRequest(String stringToken) throws Exception {
          WebServiceTemplate template = new WebServiceTemplate();

          // Create and configure marshaller
          Jaxb2Marshaller customMarshaller = new Jaxb2Marshaller();
          customMarshaller.setPackagesToScan(ClassUtils.getPackageName(SoapObject.class));
          customMarshaller.afterPropertiesSet();

          // Configure WebServiceTemplate
          template.setMarshaller(customMarshaller);
          template.setUnmarshaller(customMarshaller);
          template.setDefaultUri(endpointWS);
          // Get interceptor for "corporateToken" securityType and configure
          ClientInterceptor[] interceptors = { interceptorsBean.get("corporateToken") }; //(2)
          template.setInterceptors(interceptors);

          SoapObject soapObject = createSoapObject();

          // Authenticate and fill SecurityContext
          securityManagerService.authenticate(stringToken); //(3)

          return (SoapObject) template.marshalSendAndReceive(soapObject); //(4)
       }
     }

1. We inject into our service constructor the **non-reactive implementation** of the `SecurityManagerService`.

2. As we are going to use the interceptor for `corporateToken`, we must authenticate a token.

3. We use the ***authenticate*** method of the security service to authenticate the token passed as a parameter and create the security context.

4. When the caller uses the interceptor to enter the token in the request header, it will find it in the security context.

#### Reactive environments

When dealing with a `NotWeb` application we have the same functionality as in [Reactive](#web-service-invocations-in-reactive-applications) (DarwinWSRequestHelper); however, in case we want to use a tokenised security header, before invoking the Web
Service we will have to use the **reactive implementation** of the `SecurityManagerService` defined in the [Authentication library](../darwin-spring-boot-security-authentication/README.md#tokenservice).

This is because the helper class retrieves the authentication token from the security context or request headers. In a **Web application** there is a filter that populates the security context when authenticating the incoming request, but in
**non-Web applications** this function is covered by the `SecurityManagerService`.

The following rewrites the example [Defining the request body and URL in a WebClient](#defining-the-request-body-and-url-in-a-webclient) for a `NotWeb` application:

    @Service
    public class WebserviceReactiveCaller {

        private final String WS_BASE_URL = "http://WsHostname:WsPort/webservice";

        private DarwinWSRequestHelper darwinWSRequestHelper;

        private WebClient.Builder webClientBuilder;

        private SecurityManagerService<Mono<Authentication>, Mono<Token>> securityManagerService;

        public void WebserviceReactiveCaller(DarwinWSRequestHelper darwinWSRequestHelper,
                                                    WebClient.Builder webClientBuilder,
                                SecurityManagerService<Mono<Authentication>, Mono<Token>> securityManagerService){ //(1)
            this.darwinWSRequestHelper = darwinWSRequestHelper;
            this.webClientBuilder = webClientBuilder;
            this.securityManagerService = securityManagerService;
        }

        public Mono<WsResponse> getResponse(String stringToken) {
            // Create SoapObject for WebService
            SoapObject soapObject = createSoapObject();

            String securityType = "corporateToken";

            Mono<Authentication> authResult = securityManagerService.authenticate(stringToken);    // (2)

            return authResult.flatMap(
                        authToken ->
                            darwinWSRequestHelper.encodeInput(soapObject, securityType)     // (4)
                                        .flatMap(data ->
                                            webClientBuilder.baseUrl(WS_BASE_URL).build()   // (5)
                                                    .method(HttpMethod.POST).uri("/soap")
                                                    .headers(h ->
                                                        h.setContentType(MediaType.TEXT_XML))
                                                    .body(BodyInserters.fromValue(data))
                                                    .retrieve()
                                                    .bodyToMono(WsResponse.class)
                                        )
                                        .contextWrite(ReactiveSecurityContextHolder
                                                        .withAuthentication(authToken)) // (3)
            );
        }
    }

1. We inject into the constructor of our service the **reactive implementation** of the `SecurityManagerService`.

2. As we are going to use the header for `corporateToken`, we must authenticate a token. We use the ***authenticate*** method of the security service to authenticate the token passed as parameter.

3. From the authentication result we create a new stream in which a security context exists with this authentication from the subscription.

4. We create the content of the request to the `Web Service` as in the other cases. Specifying a token-based security type will retrieve it directly from the security context.

5. Finally, we can make use of the `WebClient` also as in the previous cases.

[^1]: If we run a NotWeb application, the components corresponding to both implementations will be loaded
