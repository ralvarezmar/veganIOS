# Microservices authentication configuration

Configure Spring Security supports to protect endpoints by using JWT OAuth 2.0 Bearer Token.

## Prerequisites

* Spring Boot version 3
* Spring Security version 6
* Java 17

## Case 1: Only validate the bearer access token receive from Authorization header

### Step 1: Import Spring Security dependencies

The outh2-resource-server has the dependency of spring security. The version is managed by spring-boot-dependencies.

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

### Step 2: Create a spring bean of type `SecurityFilterChain` and annotate the config class with `@EnableWebSecurity`

In filterChain method is configured what security mechanism is used and how to handle the operations requested to application resources.

``` { .java .copy linenums="1" hl_lines="12 13"}
import org.springframework.http.HttpMethod;
...
@Configuration
@EnableWebSecurity(debug = false)
public class SecurityConfig {
    @Bean
    @ConditionalOnMissingBean
    public SecurityFilterChain filterChain(HttpSecurity http)
        throws Exception {

       http.authorizeHttpRequests(
            authorize -> authorize

                /* Allow list */
                .requestMatchers(HttpMethod.GET, "/v3/api-docs/**")
                    .permitAll()
                .requestMatchers(HttpMethod.GET, "/swagger-ui/**")
                    .permitAll()
                .requestMatchers(HttpMethod.GET, "/actuator/**")
                    .permitAll()

                // Others
                .anyRequest().authenticated()
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

**line 12-13**: implements how is authorized the microservice resource

In this case, when the microservice receive a POST request to the resource "/api/v1/apparsenal" then is validated if the jwt access token is valid and has the scope "gdd".
Until April/2023, scope this is the only granularity available at provider common know as RHSSO.
More info about authorization access: [Configuring Authorization](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html#oauth2resourceserver-jwt-authorization).

!!! tip
    The declaration order matters. The first match is applied. So declare from most specific to most generic.

### Step 3: Configure resource server or use local public key

Add to application.yml the configuration of oauth2 resource server.

``` { .yaml .copy title="application.yml"}
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: ${RHSSO_HOST}/auth/realms/${RHSSO_REALM}/protocol/openid-connect/certs
```

??? example "Variable values example"

    ``` { .yaml .copy }
    RHSSO_HOST: https://login.azure.paas.santanderbr.dev.corp
    RHSSO_REALM: corp
    ```

The property jwk-set-uri is the minimum configuration needed to validate the jwt token. In this case the value is the RH-SSO(Red Hat Single Sign-On) from Brazil at development environment.

It's also possible to configure a public key to validate the JWT by setting
**spring.security.oauth2.resourceserver.jwt.public-key-location** in *application.yml*.
Use **file:** to reference external files (files in config server, for example)
and **classpath:** to reference files in resources folder.

Example:

``` { .yaml .copy }
spring:
    security:
        oauth2:
            resourceserver:
                jwt:
                    public-key-location: file:path-to-key/my-key.pub
```
