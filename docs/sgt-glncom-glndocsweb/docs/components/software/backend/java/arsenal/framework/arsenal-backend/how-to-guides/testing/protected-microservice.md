# Testing protected microservices by spring security

## Step 1: Create a new SecurityFilterChain bean

Create a new class in test source directory(Ex.: src/test/java) with the code below:

``` { .java .copy linenums="1" hl_lines="9 10 11 12"}
@TestConfiguration
@Order(1)
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{

    http
      .csrf(csrf -> csrf.disable())
      .authorizeHttpRequests(
        authorize -> authorize.anyRequest().permitAll()
      );

    return http.build();
  }
}
```

**Line 2**: @Order annotation with a low number has the intention to create this SecurityFilterChain bean before the one in main source directory(Ex.: src/main/java)

**Line 9**: Disable csrf (Cross-Site Request Forgery). More info access [CSRF](https://docs.spring.io/spring-security/reference/features/exploits/csrf.html#csrf-protection)

**Line 11**: Allow any request that the application receives.

Then add **SecurityConfig.class** to **@SpringBootTest** annotation classes parameter.

Example:

``` { .java .copy }
@SpringBootTest(
    classes = {ArsenalApplication.class, SecurityConfig.class},
    webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
```

### Expected result

Any request during executing tests will not required authorization. Not producing http response code 401.
The existing BDD testing distributed with the archetype, `RunCucumberTest.java`, will succeed even not sending a Authorization header.

### Another example using Junit test

``` { .java .copy }
@SpringBootTest
@AutoConfigureMockMvc
public class UnitTest2 {

  @Autowired private MockMvc mockMvc;

  @Autowired ObjectMapper objectMapper;
  
  @Test
  public void createTest() throws Exception {

    AppArsenalRequestDTO newSample = new AppArsenalRequestDTO();
    newSample.setOtherInfo("Unit test for POST");

    mockMvc
      .perform(
          post("/api/v1/apparsenal")
              .contentType(MediaType.APPLICATION_JSON)
              .content(objectMapper.writeValueAsString(newSample)))
      .andExpect(status().is2xxSuccessful());
  }
}
```

!!! info
    In some IDE the SecurityConfig class at src/test/java can present a error because it is already defined at src/main/java.
    Remember that as prerequisite to use this approach the property **spring.main.allow-bean-definition-overriding** must be **false**.

### Alternative approach

Create a class with another name.

``` { .java .copy }
@TestConfiguration
@Order(1)
public class SecurityConfigTestEnvironment {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

    http
      .csrf().disable()
      .authorizeHttpRequests(
          authorize -> authorize.anyRequest().permitAll()
      );

    return http.build();
  }
}
```

But include in each class test the annotation @Import

``` { .java .copy title="JUnit test" linenums="1" hl_lines="3"}
@SpringBootTest
@AutoConfigureMockMvc
@Import(SecurityConfigTestEnvironment.class)
public class UnitTest {

  @Autowired private MockMvc mockMvc;

  @Autowired ObjectMapper objectMapper;

  @Test
  public void createTest() throws Exception {

    AppArsenalRequestDTO newSample = new AppArsenalRequestDTO();
    newSample.setOtherInfo("Unit test for POST");

    mockMvc
      .perform(
          post("/api/v1/apparsenal")
              .contentType(MediaType.APPLICATION_JSON)
              .content(objectMapper.writeValueAsString(newSample)))
      .andExpect(status().is2xxSuccessful());

  }
}
```
