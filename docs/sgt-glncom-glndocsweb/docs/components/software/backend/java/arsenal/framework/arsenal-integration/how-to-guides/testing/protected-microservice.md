# Testing protected microservices by spring security

## Step 1: Create a new SecurityFilterChain bean

Create a new class in test source directory(Ex.: src/test/java) with the code below:

``` { .java .copy linenums="1"}
@TestConfiguration
@EnableWebSecurity
@Order(1)
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{

        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(
                        authorize ->
                                authorize
                                        .requestMatchers(antMatcher(HttpMethod.GET, "/user_management/v1/users/**")).hasAuthority("SCOPE_gdd")
                                        .anyRequest().permitAll()
                );

        return http.build();
    }
}
```

## Step 2: Create a new OAuth2AuthorizedClientManager and ClientRegistration bean

``` { .java .copy linenums="1"}
@TestConfiguration
@Order(1)
public class SecurityWebClientConfig {

    @MockBean
    ClientRegistrationRepository clientRegistrationRepository;

    @MockBean
    OAuth2AuthorizedClientRepository authorizedClientRepository;

    @Bean
    public OAuth2AuthorizedClientManager authorizedClientManager(){
        return new DefaultOAuth2AuthorizedClientManager(clientRegistrationRepository, authorizedClientRepository);
    }

    @Bean
    public ClientRegistration clientRegistration() {
        return ClientRegistration
                .withRegistrationId("registrationIdTest")
                .authorizationGrantType(new AuthorizationGrantType("grantTypeTest"))
                .build();
    }
}
```

## Step 3: Create a new RouteTest

``` { .java .copy linenums="1" hl_lines="15 16 18 25 26 28"}
@SpringBootTest(classes =
        {IntegrationApplication.class},
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        useMainMethod = SpringBootTest.UseMainMethod.WHEN_AVAILABLE
)
@AutoConfigureObservability
public class SecurityProtectRouteTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testGetActuatorSuccess() {

        ResponseEntity<Map> health = restTemplate
                .getForEntity("/user_management/v1/api/actuator", Map.class);

        Assertions.assertEquals(HttpStatus.OK, health.getStatusCode());

    }

    @Test
    public void testGetProtected() {

        ResponseEntity<Map> users = restTemplate
                .getForEntity("/user_management/v1/users", Map.class);

        Assertions.assertEquals(HttpStatus.FORBIDDEN, users.getStatusCode());

    }

}
```

**Line 15, 16, 18**: Tests a request that is on the allowed list.<br>
**Line 25, 26, 28**: Tests a request that is on the blocked list.

### Demo project

A demo project is available at the link: [gln-back-arsenal-integration-security](https://github.com/santander-group-gluon/gln-back-java-internal-poc/tree/main/gln-back-arsenal-integration-security)
