# Call a microservice protected by Jwt

For cases where it is necessary to call a microservice that requires authentication and authorization by jwt scope, there are different ways to do this.

## Propagate Authorization header using Spring and Camel

### Step 1: Import Spring Security dependencies

The outh2-resource-server has the dependency of spring security. The version is managed by spring-boot-dependencies.

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

### Step 2: Create a spring bean of type `Processor`

``` { .java .copy linenums="1" }
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.AbstractOAuth2TokenAuthenticationToken;
import org.springframework.stereotype.Component;

@Component
public class ArsenalOAuth2CamelPropagatorProcessor implements Processor {

    @Override
    public void process(Exchange exchange) throws Exception {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null) {
            if (authentication instanceof AbstractOAuth2TokenAuthenticationToken<?>) {
                final String token = ((AbstractOAuth2TokenAuthenticationToken<?>) authentication).getToken().getTokenValue();
                exchange.getIn().setHeader("Authorization", "Bearer " + token);
            }
        }

    }

}
```

### Step 2: Add the processor before the HTTP call

``` { .java .copy linenums="1" hl_lines="5"}
    from("direct:route")
        .routeId("id-route")
        .removeHeaders("*")
        .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.GET.toString()))
        .process(this.arsenalOAuth2CamelPropagatorProcessor)
        .to("http:{{host}}").stop()
        .end();
```

### Expected result

The endpoint called by camel will receive the Authorization header with the same value that the application received.

## Generate a new access token using client credentials

### Step 1: Add the oauth2-client dependency

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

The version is managed by spring-boot-dependencies.

### Step 2: Configure oauth2 client provider and registration at application.yml

``` { .yaml .copy linenums="1" hl_lines="6 9" }

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

!!! note
    If resource server jwt is configured as show in Case 1 just complement with this info above.

??? example "Variable values example"

``` { .yaml .copy }
    RHSSO_HOST: https://login.azure.paas.santanderbr.dev.corp
    RHSSO_REALM: corp
    RHSSO_CLIENT_ID: poc_seguranca_camel
    RHSSO_CLIENT_SECRET: 4e219129-9df5-48e0-95f1-d0da181b9e00
```

**Lines 6 and 9:** this is just a name to provider and registration. Change to the name that most suits for your project.

### Step 3: Create objects to use this configuration

Create a config class with the code below:

``` { .java .copy linenums="1" hl_lines="26" }

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProvider;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProviderBuilder;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizedClientRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;

import java.time.Duration;

@Configuration
public class SecurityWebClientConfig {

    @Autowired
    OAuth2ClientProperties oAuth2ClientProperties;

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

    @Bean
    @ConditionalOnMissingBean
    public ClientRegistrationRepository clientRegistrationRepository(
            ClientRegistration clientRegistration) {
        return new InMemoryClientRegistrationRepository(clientRegistration);
    }

    @Bean
    @ConditionalOnMissingBean
    public ClientRegistration clientRegistration() {

        OAuth2ClientProperties.Registration registration = oAuth2ClientProperties
                .getRegistration().get("rhsso");

        OAuth2ClientProperties.Provider provider = oAuth2ClientProperties.getProvider().get("rhsso");

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

}

```

The OAuth2AuthorizedClientManager is responsible for managing the authorization (or re-authorization) of an OAuth 2.0 Client, in collaboration with one or more OAuth2AuthorizedClientProvider(s).

### Step 4: Create a spring bean of type `Processor`

``` { .java .copy linenums="1" }
import lombok.RequiredArgsConstructor;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ArsenalOAuth2CamelProcessor implements Processor {

    private final OAuth2AuthorizedClientManager oAuth2AuthorizedClientManager;

    private final ClientRegistration clientRegistration;

    @Override
    public void process(Exchange exchange) throws Exception {

        OAuth2AuthorizeRequest authorizeRequest = OAuth2AuthorizeRequest
                .withClientRegistrationId(clientRegistration.getRegistrationId())
                .principal(SecurityContextHolder.getContext().getAuthentication())
                .build();

        OAuth2AuthorizedClient authorizedClient = this.oAuth2AuthorizedClientManager
                .authorize(authorizeRequest);

        OAuth2AccessToken accessToken = authorizedClient.getAccessToken();

        exchange.getIn().setHeader("Authorization", "Bearer " + accessToken.getTokenValue());

    }

}
```

### Step 5: Add the processor before the HTTP call

``` { .java .copy linenums="1" hl_lines="5"}
    from("direct:route")
        .routeId("id-route")
        .removeHeaders("*")
        .setHeader(Exchange.HTTP_METHOD, constant(HttpMethod.GET.toString()))
        .process(this.arsenalOAuth2CamelProcessor)
        .to("http:{{host}}").stop()
        .end();
```

### Expected result

Doing an external call using the camel route a new access token will be generated using the client credentials set at application.yaml or application.properties. So, the Authorization Header that the application receives
is different from the Authorization header that the endpoint called will receive.

See also: [Testing protected microservice](../testing/protected-microservice.md)
