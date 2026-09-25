# Microservices Authorization Configuration

This documentation focuses on authorization configuration. For more details about authentication configuration,
check the [microservice authentication configuration](./authentication-configuration.md)

## JWT Scope Verification

To restrict route access by specific JWT scopes, modify the security configuration class to check
scope claim from received JWT. For example, to only allow access when JWT has scope "gdd":

``` { .java .copy hl_lines="12 14 16 18" }
@Configuration
@EnableWebSecurity(debug = false)
public class SecurityConfig {
    @Bean
    @ConditionalOnMissingBean
    public SecurityFilterChain filterChain(HttpSecurity http)
            throws Exception {

        http.authorizeHttpRequests(
            authorize -> authorize
                    .requestMatchers(HttpMethod.POST, "/api/v1/apparsenal")
                    .hasAuthority("SCOPE_gdd")
                    .requestMatchers(HttpMethod.GET, "/api/v1/apparsenal/**")
                    .hasAuthority("SCOPE_gdd")
                    .requestMatchers(HttpMethod.PUT, "/api/v1/apparsenal/*")
                    .hasAuthority("SCOPE_gdd")
                    .requestMatchers(HttpMethod.DELETE, "/api/v1/apparsenal/*")
                    .hasAuthority("SCOPE_gdd")

                        ....

                    .anyRequest().authenticated()
                )

                ....

        return http.build();
    }
}
```

## JWT Audience Validation

The required aud fields can be configured by setting the property
**spring.security.oauth2.resourceserver.jwt.audiences**. Multiple audiences
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

    A sample arsenal backend application with configured JWT audience validation can be found
    [here](https://github.com/santander-group-shared-assets/gln-back-arsenal-backend-spring-samples/tree/main/jwt-audience).
