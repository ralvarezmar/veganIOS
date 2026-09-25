# Microservices Authorization Configuration

This documentation focuses on authorization configuration. For more details about authentication configuration,
check the [microservice authentication configuration](./authentication-configuration.md)

## Authorization

### Configure using scope

To use scopes to do authorization in your microservice you need to configure the endpoints with `.hasAuthority()` method.

``` { .java .copy linenums="1" hl_lines="17 19 21 23"}
...

@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  @ConditionalOnMissingBean
  public SecurityFilterChain filterChain(HttpSecurity http)
      throws Exception {

    http.authorizeHttpRequests(
            authorize -> authorize

                /* Block list */
                .requestMatchers(antMatcher(HttpMethod.GET, "/user_management/v1/users/**"))
                  .hasAuthority("SCOPE_gdd")
                .requestMatchers(antMatcher(HttpMethod.POST, "/user_management/v1/users"))
                  .hasAuthority("SCOPE_gdd")
                .requestMatchers(antMatcher(HttpMethod.PUT, "/user_management/v1/users/**"))
                  .hasAuthority("SCOPE_gdd")
                .requestMatchers(antMatcher(HttpMethod.DELETE, "/user_management/v1/users/**"))
                  .hasAuthority("SCOPE_gdd")

                ...
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

**lines 16-23**: implements how is authorized the microservice resource

In this case, when the microservice receive a POST request to the resource "/user_management/v1/users" then is validated if the jwt access token is valid and has the scope "gdd".
Until April/2023, scope this is the only granularity available at provider common know as RHSSO.
More info about authorization access: [Configuring Authorization](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html#oauth2resourceserver-jwt-authorization).

### Configure using audience

To use scopes to do authorization in your microservice you need to configure the property **spring.security.oauth2.resourceserver.jwt.audiences**. Multiple audiences
can be configured by listing them as in the below example:

``` { .yaml .copy }
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          audiences:
            - aud-1
            - aud-2
```

!!! note
    A sample arsenal integration application with configured JWT audience validation can be found
    [here](https://github.com/santander-group-shared-assets/gln-back-arsenal-integration-spring-samples/tree/main/jwt-audience).
