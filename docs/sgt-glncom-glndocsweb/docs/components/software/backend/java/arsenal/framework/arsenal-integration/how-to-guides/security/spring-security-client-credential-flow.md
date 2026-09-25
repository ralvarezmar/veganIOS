# Obtaining a JWT Token Using Client Credential Flow in a Non-Web Spring Application

This guide will show you how to obtain a JWT token using the client credential
flow in a non-web Spring application using Spring Security.

## Prerequisites

* Spring Boot version 3
* Spring Security version 6
* Java 17

### Step 1: Add the oauth2-resource-server dependency

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

The version is managed by spring-boot-dependencies.

### Step 2: Configure OAuth2 Client in application.yml

Configure the OAuth2 client provider and registration.

``` { .yaml .copy }
spring:
  security:
    oauth2:
      client:
        provider:
          myprovider:
            token-uri: ${TOKEN_URI}
        registration:
          myclient:
            client-id: ${CLIENT_ID}
            client-secret: ${CLIENT_SECRET}
            authorization-grant-type: client_credentials
```

### Step 3: Create Configuration Class

Create a configuration class to set up the OAuth2 client manager and WebClient.

``` { .java .copy }
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.AuthorizedClientServiceOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProvider;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientProviderBuilder;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.reactive.function.client.ServletOAuth2AuthorizedClientExchangeFilterFunction;
import org.springframework.web.reactive.function.client.WebClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Configuration
public class OAuth2ClientConfig {

    private static final Logger logger = LoggerFactory.getLogger(OAuth2ClientConfig.class);

    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        return new InMemoryClientRegistrationRepository(clientRegistration());
    }

    @Bean
    public ClientRegistration clientRegistration() {
        return ClientRegistration.withRegistrationId("myclient")
                .tokenUri(System.getenv("TOKEN_URI"))
                .clientId(System.getenv("CLIENT_ID"))
                .clientSecret(System.getenv("CLIENT_SECRET"))
                .authorizationGrantType(new AuthorizationGrantType("client_credentials"))
                .build();
    }

    @Bean
    public OAuth2AuthorizedClientManager authorizedClientManager(
            ClientRegistrationRepository clientRegistrationRepository,
            OAuth2AuthorizedClientService authorizedClientService) {

        OAuth2AuthorizedClientProvider authorizedClientProvider =
                OAuth2AuthorizedClientProviderBuilder.builder()
                        .clientCredentials()
                        .build();

        AuthorizedClientServiceOAuth2AuthorizedClientManager authorizedClientManager =
                new AuthorizedClientServiceOAuth2AuthorizedClientManager(
                        clientRegistrationRepository, authorizedClientService);

        authorizedClientManager.setAuthorizedClientProvider(authorizedClientProvider);

        return authorizedClientManager;
    }

    @Bean
    public WebClient webClient(OAuth2AuthorizedClientManager authorizedClientManager) {
        ServletOAuth2AuthorizedClientExchangeFilterFunction oauth2 =
                new ServletOAuth2AuthorizedClientExchangeFilterFunction(authorizedClientManager);

        return WebClient.builder()
                .apply(oauth2.oauth2Configuration())
                .build();
    }
}
```

### Step 4: Obtain JWT Token

Create a service to obtain the JWT token.

``` { .java .copy }
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.OAuth2AuthorizeRequest;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class TokenService {

    private static final Logger logger = LoggerFactory.getLogger(TokenService.class);

    @Autowired
    private OAuth2AuthorizedClientManager authorizedClientManager;

    public String getToken() {
        try {
            OAuth2AuthorizeRequest authorizeRequest = OAuth2AuthorizeRequest.withClientRegistrationId("myclient")
                    .principal("client")
                    .build();

            OAuth2AuthorizedClient authorizedClient = this.authorizedClientManager.authorize(authorizeRequest);

            if (authorizedClient != null) {
                return authorizedClient.getAccessToken().getTokenValue();
            } else {
                throw new IllegalStateException("Failed to obtain access token");
            }
        } catch (Exception e) {
            logger.error("Error obtaining access token", e);
            throw new IllegalStateException("Failed to obtain access token", e);
        }
    }
}
```

### Step 5: Use the Token in Camel Route

Create a Camel route to use the JWT token.

``` { .java .copy }
import org.apache.camel.builder.RouteBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class MyCamelRoute extends RouteBuilder {

    @Autowired
    private TokenService tokenService;

    @Override
    public void configure() throws Exception {
        String token = tokenService.getToken();

        from("timer:foo?period=60000")
            .setHeader("Authorization", constant("Bearer " + token))
            .to("https://example.com/api")
            .log("Response: ${body}");
    }
}
```

### Step 6: Run the Application

Run the application to obtain the JWT token.

```bash
mvn spring-boot:run
```

## Summary

This guide demonstrates how to configure a non-web Spring application with
Apache Camel to obtain a JWT token using the client credential flow with Spring
Security. The key steps include adding dependencies, configuring the OAuth2
client, creating a configuration class, obtaining the JWT token, and using the
token in a Camel route.
