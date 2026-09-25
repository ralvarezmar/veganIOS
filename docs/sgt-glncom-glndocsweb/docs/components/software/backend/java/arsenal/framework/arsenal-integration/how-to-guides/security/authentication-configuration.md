# Microservices authentication configuration

Configure Spring Security supports to protect endpoints by using JWT OAuth 2.0 Bearer Token

## Prerequisites

* Spring Boot version 3
* Spring Security version 6
* Java 17

## Spring Security dependencies

The outh2-resource-server has the dependency of spring security. The version is managed by spring-boot-dependencies.

``` { .xml .copy title="pom.xml"}
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

## Authentication

To validate the bearer access token receive from Authorization header create a spring bean of type `SecurityFilterChain` and annotate the config class with `@EnableWebSecurity`

In filterChain method is configured what security mechanism is used and how to handle the operations requested to application resources.

``` { .java .copy linenums="1"}
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.security.web.util.matcher.AntPathRequestMatcher.antMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  @ConditionalOnMissingBean
  public SecurityFilterChain filterChain(HttpSecurity http)
      throws Exception {

    http.authorizeHttpRequests(
            authorize -> authorize
                /* Allow list */
                .requestMatchers(antMatcher(HttpMethod.GET, "/user_management/v1/api/v3/api-docs/**"))
                  .permitAll()
                .requestMatchers(antMatcher(HttpMethod.GET, "/user_management/v1/api/swagger-ui/**"))
                  .permitAll()
                .requestMatchers(antMatcher(HttpMethod.GET, "/user_management/v1/api/actuator/**"))
                  .permitAll()

                /* Block list */
                .anyRequest()
                  .authenticated()
        )
        .sessionManagement(
            session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        )
        .oauth2ResourceServer(o -> o.jwt(Customizer.withDefaults()));

    return http.build();
  }
}
```

!!! tip
    The declaration order matters. The first match is applied. So declare from most specific to most generic.

!!! warning
    You need to leave the 3 endpoints unprotected with `.permitAll()` to expose the contract and health check

### Configure how to validate the jwt

There are 2 ways to get the public key to validate the jwt signature, getting the key from anauthorization server (online) and another is pointing to a local public key (offline)

#### Getting from an authorization server

To configure an authorization server to validate the JWT, set the
**spring.security.oauth2.resourceserver.jwt.jwk-set-uri** property in *application.yaml*.

Example:

``` { .yaml .copy }
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: https://example.com/certs
```

#### Using a local public key

It's also possible to configure a public key to validate the JWT by setting
**spring.security.oauth2.resourceserver.jwt.public-key-location** in *application.yaml*.
Use **file:** to reference external files and **classpath:** to reference files in resources folder.

Example:

``` { .yaml .copy }
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          public-key-location: file:./path/to/file/my-key.pub
```

!!! tip
    Usually the public key file is obtained from an kubernetes configmap, mounting the file in the local filesystem

!!! note
    A sample arsenal backend application with configured JWT audience validation can be found
    [here](https://github.com/santander-group-shared-assets/gln-back-arsenal-integration-spring-samples/tree/main/jwt-audience).
