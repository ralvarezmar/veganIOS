# Call a microservice protected by Jwt

For cases where it is necessary to call a microservice that requires authentication and authorization by jwt scope, there are different ways to do this.

## Case 1: Propagate Authorization header using Spring WebClient

If a token is received and it is necessary to send it in a request to another microservice, it is possible to propagate it as follows:

``` { .java .copy linenums="1" hl_lines="4" }
@Bean
WebClient webClient(WebClient.Builder builder) {
    return builder
            .filter(new ServletBearerExchangeFilterFunction())
            .build();
}
```

Just add to WebClient the filter `ServletBearerExchangeFilterFunction` from package `org.springframework.security.oauth2.server.resource.web.reactive.function.client` and the Authorization header will be propagate in downstream calls using WebClient.

To configure the service to receive a token and authenticate it, follow [Testing protected microservice](./authentication-configuration.md)

## Expected result - Case 1

The endpoint called by WebClient instance will receive the Authorization header with the same value that the application received.

## Case 2: Generate a new access token using a different client credentials

### Step 1: Add the oauth2-client dependency

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

The version is managed by spring-boot-dependencies.

### Step 2: Configure oauth2 client provider and registration at application.yml

``` { .xml .copy linenums="1" hl_lines="6 9" }

spring:
  security:
    oauth2:
      client:
        provider:
          rhsso:
            token-uri: ${RHSSO_HOST}/auth/realms/${RHSSO_REALM}/protocol/openid-connect/token
        registration:
          rhsso:
            client-id: ${RHSSO_CLIENT_ID}
            client-secret: ${RHSSO_CLIENT_SECRET}
            authorization-grant-type: client_credentials
```

??? example "Variable values example"

    ``` { .yaml .copy }
    RHSSO_HOST: https://login.azure.paas.santanderbr.dev.corp
    RHSSO_REALM: corp
    RHSSO_CLIENT_ID: poc_seguranca_camel
    RHSSO_CLIENT_SECRET: 4e219129-9df5-48e0-95f1-d0da181b9e00
    ```

**Lines 6 and 9:** this is just a name to provider and registration. Change to the name that most suits for your project.

### Step 3: Create objects to use this configuration

Create a config class with the code below.

!!! warning
    There are 2 ways to configure the authorizedClientManager bean method, so you need to follow step 3.1 or 3.2 according to your project's needs.

``` { .java .copy linenums="1" hl_lines="9 18 25 43 50" }
@Configuration
public class SecurityWebClientConfig {

    @Autowired
    OAuth2ClientProperties oAuth2ClientProperties;

    @Bean
    @ConditionalOnMissingBean
    public OAuth2AuthorizedClientManager authorizedClientManager(
            ClientRegistrationRepository clientRegistrationRepository,
            OAuth2AuthorizedClientRepository authorizedClientRepository) {

            // THIS METHOD WILL BE IMPLEMENTED IN THE NEXT STEP
    }

    @Bean
    @ConditionalOnMissingBean
    public ClientRegistrationRepository clientRegistrationRepository(
            ClientRegistration clientRegistration) {
        return new InMemoryClientRegistrationRepository(clientRegistration);
    }

    @Bean
    @ConditionalOnMissingBean
    public ClientRegistration clientRegistration() {

        Registration registration = oAuth2ClientProperties.getRegistration().get("rhsso");
        Provider provider = oAuth2ClientProperties.getProvider().get("rhsso");

        return ClientRegistration.withRegistrationId("arsenal")
                .tokenUri(provider.getTokenUri())
                .clientId(registration.getClientId())
                .clientSecret(registration.getClientSecret())
                .authorizationGrantType(
                    new AuthorizationGrantType(
                        registration.getAuthorizationGrantType())
                )
                .build();
    }

    @Bean
    public OAuth2AuthorizedClientService auth2AuthorizedClientService(
            ClientRegistrationRepository clientRegistrationRepository) {

        return new InMemoryOAuth2AuthorizedClientService(clientRegistrationRepository);
    }

    @Bean(name = "clientCredential")
    public WebClient webClientClientCredentials(
            OAuth2AuthorizedClientManager authorizedClientManager,
            WebClient.Builder builder) {

        ServletOAuth2AuthorizedClientExchangeFilterFunction oauth2 =
                new ServletOAuth2AuthorizedClientExchangeFilterFunction(
                                                authorizedClientManager);

        oauth2.setDefaultClientRegistrationId("arsenal");

        return builder
                .apply(oauth2.oauth2Configuration())
                .build();
    }
}

```

#### 3.1: Generate new access token using authorization received by HTTP request

This section provides a bean method to add on configuration above, and it's used to when there is an authorization header in the HTTP request.

To generate a new access token using client credentials and manage client authorization, you should use a DefaultOAuth2AuthorizedClientManager. Add the following bean on the configuration from step 3:

``` { .java .copy linenums="1" hl_lines="6" }
@Configuration
public class SecurityWebClientConfig {

    @Bean
    @ConditionalOnMissingBean
    public OAuth2AuthorizedClientManager authorizedClientManager(
            ClientRegistrationRepository clientRegistrationRepository,
            OAuth2AuthorizedClientRepository authorizedClientRepository) {

        OAuth2AuthorizedClientProvider authorizedClientProvider =
            OAuth2AuthorizedClientProviderBuilder
                .builder()
                .clientCredentials(
                    (builder) -> builder
                                .clockSkew(Duration.ofSeconds(10))
                                .build()
                )
                .build();

        DefaultOAuth2AuthorizedClientManager authorizedClientManager =
                new DefaultOAuth2AuthorizedClientManager(
                    clientRegistrationRepository, authorizedClientRepository);

        authorizedClientManager
            .setAuthorizedClientProvider(authorizedClientProvider);

        return authorizedClientManager;
    }

    // ...other methods
}

```

The OAuth2AuthorizedClientManager is responsible for managing the authorization (or re-authorization) of an OAuth 2.0 Client, in collaboration with one or more OAuth2AuthorizedClientProvider(s).

Ignore step 3.2 if this configuration fits your use case.

#### Step 3.2: Generate new access token when there is no web context

Use this configuration if the application operates outside an HTTP context, meaning it cannot access authentication details like the Authorization header.

This setup uses AuthorizedClientServiceOAuth2AuthorizedClientManager, which relies on OAuth2AuthorizedClientService to handle OAuth 2.0 client credentials.

``` { .java .copy linenums="1" hl_lines="6" }
@Configuration
public class SecurityWebClientConfig {

    @Bean
    @ConditionalOnMissingBean
    public OAuth2AuthorizedClientManager authorizedClientManager(
            ClientRegistrationRepository clientRegistrationRepository,
            OAuth2AuthorizedClientRepository authorizedClientRepository) {

        OAuth2AuthorizedClientProvider authorizedClientProvider =
            OAuth2AuthorizedClientProviderBuilder
                .builder()
                .clientCredentials(
                    (builder) -> builder
                                .clockSkew(Duration.ofSeconds(10))
                                .build()
                )
                .build();

        AuthorizedClientService0Auth2AuthonizedClientManager authorizedClientManager =
            new AuthorizedClientService0Auth2AuthorizedClientManager(
                clientRegistrationRepository, authorizedClientService);

        authorizedClientManager
            .setAuthonizedClientProvider(authorizedClientProvider);

        return authorizedClientManager;
    }

    // ...other methods
}

```

!!! note
    Key differences between 3.1 and 3.2:

    3.1 uses DefaultOAuth2AuthorizedClientManager, which is typically used within an HTTP context where the app can access the authentication details.
    
    3.2 uses AuthorizedClientServiceOAuth2AuthorizedClientManager, which is designed for cases where authentication details aren't available through the HTTP context.

## Expected result - Case 2

Doing a external call using WebClient(clientCredential - line 50) a new access token will be generated using the client credentials set at application.yaml or application.properties. So, the Authorization Header that the application receives
is different from the Authorization header that the endpoint called will receive.

See also: [Testing protected microservice](../testing/protected-microservice.md)
