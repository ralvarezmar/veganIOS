# Santander Spring Boot Test ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The `Santander Spring Boot Test` library provides projects with a series of "*Out Of The Box*" components and functionalities that **facilitate the design and implementation of an application's test cases**. These **extend, simulate or simplify the
normal behavior of some test components and Santander Spring Boot** under certain execution conditions: Logging in test mode, *mocks* for Common Services (PKM, STS …), etc.

## Functionality

### Console log traces

If the project includes the starter of the [Santander Spring Boot Logging Library](../santander-spring-boot-logging/README.md) among its dependencies, the following will be configured:

- The *appenders* in charge of **outputting by console the Functional and Security traces** generated in the application (with the Logging library these logs do not have output by console)

- You can reconfigure the *appender* of **technical traces by console to use the same JSON trace pattern** that is sent to Kafka (disabled by default).

!!! note

    It is possible to activate/deactivate one or more of these changes from the [configuration properties](#configuration-properties) of Test.

### Metrics in console

If the project includes the starter of [Santander Spring Boot Metrics Library](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/santander-project/santander-spring-boot-metrics/) among its dependencies,
it will be possible to configure an *appender* in charge of **outputting by console the metrics generated in the application** (with the Metrics library they have no console output).
This functionality by default is disabled, being able to enable them from the [configuration property](#configuration-properties) `santander.test.logging.metrics-console`

### `AutoConfigureLogging` annotation

If the project includes the starter of [Santander Spring Boot Logging Library](../santander-spring-boot-logging/README.md) among its dependencies, it will be possible to configure a test *appender* in order to capture and check the traces sent
through it.

This will allow us to check whether the traces are sent and have the correct and proper format. With this, we will test the log reliant components of the architecture.

To use this functionality, we include the `AutoConfigureLogging` annotation in our test class.

Also a bean of the `TestLog4j2Appender` class will be injected into the test class,with name `activityTestAppender`.
This bean will be in charge of capturing the traces sent to the `ACTIVITY` logger.

If you want to capture traces from another logger, you can create another `TestLog4j2Appender` bean and inject it into the test class.
You can create a `TestLog4j2Appender` bean with the some code like this:

```java
final LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
final Configuration config = ctx.getConfiguration();

Logger activityLogger = (Logger) LogManager.getLogger(ACTIVITY.getName());
Appender activityAppender = activityLogger.getAppenders().get("CONSOLE_ACTIVITY");

// Create appender
var activityTestAppender = TestLog4j2Appender.createTestLog4j2Appender(
        "ActivityTestAppender", activityAppender);

activityLogger.removeAppender(activityAppender);
config.addAppender(activityTestAppender);
activityLogger.addAppender(activityTestAppender);
ctx.updateLoggers();
```

### Authentication mockup

If the project includes the [Authentication Library](../santander-spring-boot-security-authentication/README.md) starter among its dependencies, **the module mockup the authentication** .
In this way **invocations and dependencies with external services are avoided during the execution of the tests**, without losing the validation and token conversion functionalities.

The mocked authentication adds the following functionality:

- Allows authentication using `Bearer MOCK.TOKEN` (code constant `TokenUtils.MOCK_JWT_TOKEN`) as an authentication header.
- Also allows you to use a default-defined key (modifiable in `santander.test.security.public-key` and `santander.test.security.private-key`)
  with the function `TokenUtils.createDefaultToken` you can create a valid JWT token.
- In case neither of the above works, it authenticates like any other microservice using the defined PKM.

It is possible to disable this mocks from the [configuration properties](#configuration-properties) of Test or all the Santander Spring Boot security from [configuration
properties](../santander-spring-boot-security-authentication/README.md#configuration) of Authentication.

!!! info "Important"

    Despite disabling test mocks or Santander Spring Boot's security, **Spring's default security will still be active**.

A `TokenUtils` Bean will be exposed that will facilitate the creation of valid JWT tokens according to the configuration of the mocks.

A default configuration has been defined that allows the project **to make use of this functionality without having to configure anything else**; however, you can modify the values you think are necessary (public/private key, issuer, token, etc.)
from [configuration properties](#configuration-properties).

!!! note

    Below are some examples to modify the configuration [of the PKM](#overriding-default-authentication-mock-values) and [of the STS](#overriding-the-default-values-of-the-sts-mock).

### Operational Control services mocks

If the project includes the starter of the [Authorization Library](../santander-spring-boot-security-authentication/README.md) among its dependencies, the *Beans* in charge of invoking Santander Spring Boot's **CO (Operational Control) services
will be replaced by other counterparts but with that mocked functionality**. In this way **invocations and dependencies with external services are avoided during the execution of the tests**, without losing the authorization functionality.

It is possible to disable these mocks from the [configuration properties](#configuration-properties) of Test, disabling Santander Spring Boot security from [configuration properties](../santander-spring-boot-security-authentication/README.md#configuration)
of Authentication or disabling the [Authentication mocks for Test](#use-of-authentication-mocks).

!!! info "Important"

    Despite disabling test mocks or Santander Spring Boot security, **Spring's default security will remain active**.

The *Bean* of `TokenUtils` will allow us to create valid JWT tokens with two (configurable) users who have different permissions. In addition, it will be the part in charge of generating the authorization tokens in response to the Operational
Control mocks, using the ***ClientId* "F123456789"** and the ***ContractId* "004900010010000001"** (not configurable).

!!! note

    The logic of the [tokens that can be generated](#operational-control-mock-tokens) from these mocks and a [example of use](#use-of-operational-control-mocks) is shown below.

#### Multi-Entity Operational Control Mock

If you have configured the **Multi-Entity Operational Control**, the *Bean* in charge of invoking this service will be replaced by one with this mocked functionality, and not those of the Santander Spring Boot Operational Control.

On this occasion, the `JocTokenUtil` class will be in charge of generating the authorization Joc tokens in response to the Operational Control mock.

!!! note

    The logic of the [tokens that can be generated](#multi-entity-tokens) from this mock, are shown later.

### CodeTables service mock

If the project includes the CodeTables Library starter among its dependencies, the *Beans* in charge of invoking the **CodeTables service will be replaced by other counterparts but with that mocked functionality**. In this way **invocations and
dependencies with external services are avoided during the execution of the tests**, being able to simulate by means of configuration the values of the code tables of these services.

It is possible to disable these mocks from the [configuration properties](#configuration-properties) of Test with the property `santander.test.code-tables.enabled`.

!!! note

    The functionality exposed for [mock the code tables service](#rules-and-setting-values-for-the-codetables-mock) is shown later.

## Installation and configuration

To add the library to any project, include the maven dependency of its starter in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.framework.springboot</groupId>
        <artifactId>santander-spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>

!!! info "Important"

    This library **should only be used under the scope of test** so as not to modify the behavior of the application when it is started completely.

### Configuration properties

<!tag:properties>

| Name                                       | Default value                     | Mand. | Description                                                                                            | Type                                  |
|--------------------------------------------|-----------------------------------|-------|--------------------------------------------------------------------------------------------------------|---------------------------------------|
| santander.test.logging.functional-console     | true                              | No    | Enable the output of the Functional log by console                                                     | boolean                               |
| santander.test.logging.security-console       | true                              | No    | Enable the Security log output by console                                                              | boolean                               |
| santander.test.logging.technical-pattern      | *CONSOLE*                         | No    | Pattern for the Technical log by console                                                               | TechnicalPattern (*CONSOLE* o *JSON*) |
| santander.test.logging.metrics-console        | false                             | No    | Enable metrics output by console                                                                       | boolean                               |
| santander.test.security.enabled               | true                              | No    | Enable the configuration of mocks for Common Services (PKM, STS, etc.)                                 | boolean                               |
| santander.test.security.private-key           | (Private key of a valid key pair) | No    | Private key to use to generate the JWT token from the TokenUtils class                                 | String                                |
| santander.test.security.public-key            | (Public key of a valid key pair)  | No    | Public key with which to validate the token generated with the TokenUtils class                        | String                                |
| santander.test.security.issuer                | santander                         | No    | *Issuer* for the *ClaimSet* of the JWT token generated with the TokenUtils class                       | String                                |
| santander.test.security.audience              | \[spain\]                         | No    | *Audience* for the *ClaimSet* of the JWT token generated with the TokenUtils class                     | Set&lt;String&gt;                     |
| santander.test.security.user.consultive       | defaultUser                       | No    | User/*Subject* for query JWT token generated with TokenUtils class                                     | String                                |
| santander.test.security.user.operative        | OperUser                          | No    | User/*Subject* for the operational JWT token generated with the TokenUtils class                       | String                                |
| santander.test.security.user.codConsultive    | F123456789                        | No    | ClientId that must be included in the parameters of a query type request with client validation        | String                                |
| santander.test.security.user.codOperative     | F123456789                        | No    | ClientId that must be included in the parameters of an operational type request with client validation | String                                |
| santander.test.security.user.contractId       | 004900010010000001                | No    | ContractId that must be included in the parameters of a request with contract validation               | String                                |
| santander.test.security.authorization.enabled | true                              | No    | Enable mock configuration for CO services                                                              | boolean                               |
| santander.test.code-tables.enabled            | true                              | No    | Enable mock configuration for CodeTables service                                                       | boolean                               |

<!end:properties>

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.

### Limitations

All functionality related to logging (log4j) is not supported.

## Beans exposed

| Name                       | Type                    | Description                                                                                                                             | application type           |
|----------------------------|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| TokenUtils                 | TokenUtils              | Provides valid tokens for common mocked services (PKM, STS, etc.)                                                                       | <ul><li>All</li></ul>      |
| JwtDecoder                 | JwtDecoder              | Provides a valid JWT decoder for the token generated with the TokenUtils class.                                                         | <ul><li>SERVLET</li></ul>  |
| ReactiveJwtDecoder         | ReactiveJwtDecoder      | Provides a valid Reactive JWT decoder for the token generated with the TokenUtils class.                                                | <ul><li>REACTIVE</li></ul> |
| MockSTSService             | STSService              | Simulates the invocation to the STS service returning the BKS token with the configured value                                           | <ul><li>All</li></ul>      |
| MockCOCConnector           | COCConnector            | Simulates the invocation of Santander Spring Boot's Channel Operational Control                                                                        | <ul><li>All</li></ul>      |
| MockCONConnector           | CONConnector            | Simulates the invocation of Santander Spring Boot's Business Operational Control                                                                       | <ul><li>All</li></ul>      |
| MockMultiEntityCOConnector | MultiEntityCOConnector  | Simulates the invocation of Multi-Entity Operational Control                                                                            | <ul><li>All</li></ul>      |
| CodeTablesConnectorMock    | CodeTablesConnectorMock | Simulates the invocation of the CodeTables service using the configured response values                                                 | <ul><li>All</li></ul>      |

## Exposed API

| Name                        | Description                                                                                                     |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------|
| @AutoConfigureLogging | Annotation to configure Santander Spring Boot logging and a test *appender* to capture the traces sent to the ACTIVITY logger  |

## Operational Control mock tokens

The Operational Control mocks follow these steps to generate various Authorization tokens according to the request and the context:

- **Scope Channel**. For operations that have to be validated against the Channel Operational Control:

    - If the security token user is the operational user configured in properties:

        - If the current channel is *OFI* or *RML*, a COC operational token is generated with this channel.

        - If it is another channel, a COC operational token is generated with channel *INT*.

    - If the security token user is NOT the configured operational user: a COC query token is generated with the current channel.

- **Scope Business**. For operations that have to be validated against the Business Operational Control:

    - If the security token user is the operational user configured in properties:

        - If the current channel is *EMP* or *RML*, an operational token of the NOC is generated with this channel.

        - If it is another channel, a CON operational token is generated with channel *INT*.

    - If the security token user is NOT the configured operational user: a NOC query token is generated with the current channel.

!!! note

    The [Santander Spring Boot Authorization rules](../santander-spring-boot-security-authorization/README.md#operative-security) must continue to be complied with according to the client parameters and the operation contract.

### Multi-Entity Tokens

The Multi-Entity Operational Control mock follows its own steps to generate the Joc Authorization tokens:

- **Scope Channel**. For operations that have Channel scope:

    - If the current channel is *OFI* or *CIC*, a COC query Joc token is generated with that channel.

    - If it is another channel, a COC operational Joc token is generated with that channel.

- **Scope Business**. For operations that have Business scope, an attempt is made to retrieve the Joc token channel if it already exists in context, otherwise the Santander Spring Boot channel will be used:

    - If the channel obtained is *OFI* or *CIC*, a Joc token to query the NOC is generated with that channel.

    - If it is another channel, an operational Joc token of the NOC is generated with that channel.

!!! note

    The [Multi-entity Authorization rules](../santander-spring-boot-security-authorization/README.md#multi-entity-operational-security) must continue to be complied with according to the client parameters and the operation
    contract.

## Rules and setting values for the CodeTables mock

The component in charge of mocking the requests to the CodeTables service is prepared to **simulate the same casuistry as the original component** through the values of the code tables with which we configure it.

The answers we can get with the original [Santander Spring Boot CodeTables service](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/codetables/service/package-summary.html) are:

- OK (200), together with the body (true/false, CodeTable or list of CodeTable).

- NOT\_FOUND (404) "code\_tables\_error", when there is no value for the requested search.

- Other errors when an exception has occurred in the CodeTables service.

To understand the logic of the mock component,
you must also take into account the model [CodeTable](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/apidocs/com/santander/framework/springboot/codetables/domain/CodeTable.html)
that uses the [Santander Spring Boot CodeTables library](https://gluon.dev.corp/microservices/docs/santander-spring-boot/1.2.1/santander-project/santander-spring-boot-codetables/):

    public class CodeTable {

        private String code;

        private Params params;

        private String value;

        private String entity;

        private String language;

        private String channel;

        public static class Params {

            private String codeParam;

            private String description;
        }
    }

Now, the responses from the CodeTables mock component are as next:

- If the configured CodeTable objects **with value for the *value*** attribute is found for the requested search → OK with the expected body (true, CodeTable or CodeTable list).

- If **no CodeTable object configured** is found for the requested search → NOT\_FOUND (404) "code\_tables\_error"

- If **a configured CodeTable object is found but without value for the *value*** attribute for the requested search → NOT\_FOUND (404) with custom error according to the request.

In this way **we can simulate both success and error situations** by the CodeTables service.

### Configuration from file

It is possible to configure the responses that the mock component of CodeTables can give from a `codeTables-test.json` file located in the ***resources*** folder of our application. For example:

    [
      {
        "code": "00",
        "value": "OTHER MOTIVES",
        "entity": "0049",
        "language": "es",
        "params": {
          "codeParam": "001",
          "description": "Tipo Retención"
        },
        "channel": "OFI"
      },
      {
        "code": "00",
        "entity": "0049",
        "language": "es",
        "params": {
          "codeParam": "001",
          "description": "Tipo Retención"
        },
        "channel": "INT"
      }
    ]

With this example file: if we look for that CodeTable from the OFI channel we can retrieve it, while if we do it from the INT channel we will obtain a 404 NOT\_FOUND with its associated exception.

### Configuration from *Bean*

It is also possible to configure the responses by creating a *Bean* in the context that can retrieve the library on startup. This *Bean* must be of **type *Set&lt;CodeTable&gt;*** and must be **annotated with @Qualifier("codeTableSet")**:

    @Configuration
    public class ConfigClass {

        @Bean
        @Qualifier("codeTableSet")
        public Set<CodeTable> codeTableSet() {
            CodeTable codeTable1 = new CodeTable("00", new Params("001", "Tipo Retención"), "OTHER MOTIVES", "0049", "es", "OFI");
            CodeTable codeTable2 = new CodeTable("00", new Params("001", "Tipo Retención"), null, "0049", "es", "INT");

            Set<CodeTable> codeTablesSet = new HashSet<>();
            codeTablesSet.add(codeTable1);
            codeTablesSet.add(codeTable2);
            return codeTablesSet;
        }

    }

Again, with this example Bean: if we look for that CodeTable from the OFI channel we can retrieve it, while if we do it from the INT channel we will get a 404 NOT\_FOUND with its associated exception.

## Use cases

### Use of the LoggingServiceConfig and the TestLog4j2Appender

In order to use properly this functionality, we will need to extend the **LoggingServiceConfig** class:

    public class LoggingTest extends LoggingServiceConfig {
    ...
    }

After that, we will use a SetUp method to configure all the logging and authentication classes we will use:

     @BeforeAll
        void create() {

            properties.setAppKey("appKey");
            properties.setApplication("application");
            properties.setPaasAppVersion("1.0.0");
            properties.setEnvironment("TEST");
            properties.setPaasProject("PaasProject");
            properties.setSubapplication("subapplication");
            properties.setSubsystem("subsystem");
            properties.setSystem("system");

            MockEnvironment environment = new MockEnvironment()
                    .withProperty("logging.level.com.santander.framework.springboot.logging.logger", "INFO");

            DefaultLoggingConfigBuilder builder = (DefaultLoggingConfigBuilder) LoggingConfig.builder(() -> false);
            builder.setEnvironment(environment);

            new LoggingConfiguration(builder, properties, environment);

            final LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
            final Configuration config = ctx.getConfiguration();

            Logger activityLogger = (Logger) LogManager.getLogger(ACTIVITY.getName());
            Appender activityAppender = activityLogger.getAppenders().get("CONSOLE_ACTIVITY");

            testAppender = TestLog4j2Appender.createTestLog4j2Appender("TestAppender", activityAppender,
                    activityLatch);

            activityLogger.removeAppender(activityAppender);
            config.addAppender(activityTestAppender);
            activityLogger.addAppender(activityTestAppender);
            ctx.updateLoggers();

            loggingService = new LoggingServiceImpl(this.tracer, properties);
        }

And finally, once we're in our test method, we just simply have to capture the traces and check their format after we've executed the logic we want to test:

    ...
    String received;
    int retries = 0;

    do {
        received = testAppender.getMessage(0);
        activityLatch.await(1, TimeUnit.SECONDS);
    }
    while (StringUtils.isEmpty(received) && retries++ < 10);
        assertTrue(received.matches(ACTIVITY_TEMPLATE));
    ...

### Use of Authentication mocks

The library includes some configured default values that allow mocking the PKM service. Therefore, just by including its starter as a dependency of the application we already have this functionality.

The most typical use of this mock is the cases of **integrated tests in which we have to make a request to a test controller with security**, avoiding having to generate a valid token with an external service or mock up the requests to the PKM. For
example:

    @SpringBootTest(...)
    public class TestWithMock {

        @Autowired
        TokenUtils tokenUtils; // (1)

        // ...

        @Test
        public void test() {
            String token = tokenUtils.createDefaultToken(1, ChronoUnit.MINUTES); // (2)

            WebTestClient webTestClient = WebTestClient.bindToServer().baseUrl("http:...")
                .defaultHeader("Authorization", "Bearer" + token).build(); // (3)

            webTestClient.get().uri("/secure-endpoint").exchange().expectStatus()...; // (4)
        }

    }

1. We inject the `TokenUtils` Bean to generate the valid token for *Mock* authentication.

2. We use the ***createDefaultToken()* method to get the token**. There are several implementations of this method, in this case we simply spend an amount of time and its units to indicate the validity time of the token (1 minute).

3. We create/configure a WebTestClient object to be able to invoke the test controller and check its result. We add to the WebTestClient the header "**Authorization**" with the text "*Bearer {token}*".

4. Finally, we make the request to the controller endpoint safely and check its result.

#### Overriding default authentication mock values

As we have said, the library incorporates a default configuration that allows us to use the PKM service mock from the first moment. However, **it is possible to override the token creation and validation** values using exposed configuration
properties.

For the validation of the token, some keys generated for Architecture are being used, but the project could use its own keys or modify the value of the Claims that make up the token (issuer, audience …​):

    santander:
      test:
        security:
          private-key: "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAILAj1ouM+HMw....."
          public-key: "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCCwI9aLjPhzMNRH6rUt....."
          issuer: testIssuer

!!! tip "Caution"

    The privateKey/publicKey property pair must always be a pair of valid unique keys, if only one of them is configured, the token validation will fail.

### Use of STS service mocks

Again, the library includes some configured default values that allow mocking the STS service. Therefore, just by including its starter as a dependency of the application we already have this functionality.

The main use of this mock is based on the use within the application of the `TokenService` (*Servlet or Reactive*) to retrieve the JWT or BKS token. Example of use in a **non-reactive application**:

    @Service
    public class AppService {

        @Autowired
        TokenService<String, Token> tokenService; // (1)

        // ...

        public Response doService() {
            String jwtToken = tokenService.getJWTToken(); // (2)

            String bksToken = tokenService.getBKSToken(); // (2)

            // DO SOMETHING (3)
        }

    }

1. We inject the Bean of the TokenService&lt;String, Token&gt; (or TokenService&lt;Mono &lt;String&gt;, Mono &lt;Token&gt;&gt; for reactive applications) in the service of our application that we need the token.

2. We recover the token that we need:

    - If we retrieve the JWT token, we will obtain the same token with which we authenticate in our application (generated with the TokenUtils class).

    - If we retrieve the BKS (corporate) token, instead of invoking the STS service, it will return the configured BKS token.

3. We continue with the execution of our service.

#### Overriding the default values of the STS mock

As we have said, the library has **configured by default a BKS token** that will be returned when we invoke the STS service to convert the JWT:

    private String bksToken = "TDAySkkzT1ZESFQxVU1JMkE0VVBNMUxRI1VOS05PV05fSVAjMTU1MzE4MjU2MTg2Ni....";

It is possible to configure another token from the `santander.test.security.bks-token` property of the library:

    santander:
      test:
        security:
          bks-token: "4TDK0ySkkzT1ZESFQxVU1JMkE0VVBNMUxRI1VOS05PV05fSVAjMTU1MzE4MjU2MTg2Ni....";

### Use of Operational Control mocks

With the default values of the library, we can make use of the Authorization functionalities with the mocks just by including the Test starter in our application.

The main use of these mocks are **integrated tests of our application in which we have to make a request to a controller with Authorization security**, in this way we avoid requests to external services during the tests.

As an example, we start from a controller with two *endpoints* to perform two operations with different permissions:

    @RestController
    @RequestMapping("/authorization")
    public class AppController {

        @Autowired
        AppService appService;

        // ...

        @OperativeControl(scope = Scope.CHANNEL, type = OperationType.CONSULTIVE, contract = false) // (1)
        @GetMapping("op1")
        public String operation1(@RequestParam @ClientId String client, @RequestParam String param1) {

            return appService.operation1(param1);
        }

        @OperativeControl(scope = Scope.BUSINESS, type = OperationType.OPERATIVE) // (2)
        @PostMapping("op2")
        public String operation2(@RequestParam @ClientId String client, @RequestParam @ContractId String contract,
                            @RequestParam String param1) {

            return appService.operation2(param1);
        }

    }

1. Validate consultation operation with the Channel Operational Control without the need to validate the contract but the client does.

2. Validate operational operation with the Business Operational Control validating both the client and the contract.

From our test we will use the `TokenUtils` class to generate the security token and pass it the expected parameters:

    @SpringBootTest(...)
    public class AppTest {

        @Autowired
        TokenUtils tokenUtils; // (1)

        // ...

        @Test
        public void operation1Test() {
            String token = tokenUtils.createDefaultToken(1, ChronoUnit.MINUTES); // (2)

            WebTestClient webTestClient = WebTestClient.bindToServer().baseUrl("http:...")
                .defaultHeader("Authorization", "Bearer" + token).build(); // (3)

            webTestClient.get().uri("/op1?client=" + tokenUtils.getCodConsultUser() + "&param1=extraParam")
                    .exchange().expectStatus()...; // (4)
        }

        @Test
        public void operation2Test() {
            String token = tokenUtils.createOperativeToken(1, ChronoUnit.MINUTES); // (2)

            WebTestClient webTestClient = WebTestClient.bindToServer().baseUrl("http:...")
                .defaultHeader("Authorization", "Bearer" + token).build(); // (3)

            webTestClient.get().uri("/op2?client=" + tokenUtils.getCodOperUser() +
                    "&contract=" + tokenUtils.getContractId() + "&param1=extraParam").exchange().expectStatus()...; // (4)
        }

    }

1. We injected the *Bean* of TokenUtils in our test.

2. We generate the token indicating the validity time, we can use two methods according to the *user* necessary for the type of operation:

    - With the method *createDefaultToken()* we generate a token with the **user with query permissions**.

    - With the method *createOperativeToken()* we generate a token with the **user with operational permissions**.

3. We create/configure a WebTestClient object to be able to invoke the test controller and check its result. We add to the WebTestClient the header "**Authorization**" with the text "*Bearer {token}*".

4. Finally, we invoke the endpoint that we want to test adding in the URL both the **necessary Authorization parameters** (*client* and *contract*) and those for the business logic (*param1*):

    - With the *getCodConsultUser()* and *getCodOperUser()* methods we obtain the client codes necessary to validate the Authorization token.

    - With the method *getContractId()* we obtain the necessary contract to validate the Authorization token.
