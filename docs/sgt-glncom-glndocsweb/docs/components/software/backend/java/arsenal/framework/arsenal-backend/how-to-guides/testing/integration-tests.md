# Integration Tests

## Required dependencies

Arsenal provides the __gln-back-arsenal-backend-test-starter__ library that provides all the necessary dependencies for building integrated tests in Arsenal Cloud Native applications.
The Test Arsenal library includes the JUnit 5 framework for building integrated tests and the Mockito framework for creating mocks.

``` { .xml .copy }
<dependency>
   <groupId>com.santander.ars</groupId>
   <artifactId>gln-back-arsenal-backend-test-starter</artifactId>
   <type>pom</type>
   <scope>test</scope>
</dependency>
```

## Implementation

For the integrated tests, it is necessary to add the application context to the Spring test context. For this, we use the __@SpringBootTest__ annotation.

This annotation looks for the application's configuration class and uses it to create an application context, with all the beans needed for testing.
This annotation is used for all types of application integration testing, for the entire application path (from the request to persisting the data in the database) or just for one layer of the application.

``` { .java .copy }
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.*;

...

@ExtendWith(SpringExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class ApplicationIntegratedTest {

    @Autowired
    MockMvc mockMvc;
    @Autowired
    CustomerRepository repository;
    @Autowired
    CustomerMapper mapper = Mappers.getMapper(CustomerMapper.class);
    @Autowired
    ObjectMapper objectMapper;

    @Test
    public void should_createCustomer_when_sendCustomerRequestDTO() throws Exception {
        mockMvc.perform(post("/api/v2/customers")
            .contentType(MediaType.APPLICATION_JSON_UTF8)
            .content(objectMapper.writeValueAsString(mapper.customerToCustomerRequestDTO(customer))))
            .andExpect(status().isCreated());

        Customer customerSave = repository.findCustomerByName("Maria da Silva");
        assertAll(
            () -> assertThat(customerSave.getId(), is(equalTo(1L))),
            () -> assertThat(customerSave.getCpf(), is(equalTo("32259952070")))
        );
    }
}
```

In the example above we have a class and an integrated test for the complete path of the application. In this class we use the __@ExtendWith(SpringExtension.class)__ annotation, which uses the `SpringExtension` class to run the built-in tests.

The __@AutoConfigureMockMvc__ annotation configures a MockMvc class to make calls to the application's API, without having to start an application server, and the __@ActiveProfiles("test")__ that indicates the `application-test.yml`
that contains the configurations for the execution of the tests. In the test, we use `MockMvc` to make a __POST__ request to the controller and the response status is validated and then we check if the value was persisted in the database as expected.

## Testing an application slice

The __@SpringBootTest__ annotation, by uploading the entire application context, can make the execution of tests very slow. To alleviate this, we can create integrated tests just for a slice of the application,
such as tests for the web layer of the application, the controllers, using the __@WebMvcTest__ annotation or tests for the persistence layer with the __@DataJpaTest__ annotation.

These annotations will only upload in the context of the application the beans that are needed to test the layer and everything else must be mocked.

## Test for Controller layer with @WebMvcTest

The __@WebMvcTest__ annotation adds to the application context only the beans needed to test the web layer, the controllers, of the application. Everything else that is needed for the controller to work must be mocked.

``` { .java .copy }
@ExtendWith(SpringExtension.class)
@WebMvcTest(controllers = CustomerControllerV2.class)
@ActiveProfiles("test")
public class CustomerControllerV2IntegratedTest {

    @Autowired
    MockMvc mockMvc;
    @Autowired
    ObjectMapper objectMapper;
    @MockBean
    CustomerServiceV2 service;
    @MockBean
    CustomerMapper mapper;

    @Test
    public void should_reponse200_when_sendValidCustomer() throws Exception {
        MvcResult result =
            mockMvc
                .perform( post("/api/v2/customers")
                .contentType(MediaType.APPLICATION_JSON_UTF8)
                .content(objectMapper.writeValueAsString(customerRequest)))
                .andExpect(request().asyncStarted())
                .andReturn();

        mockMvc
            .perform(asyncDispatch(result))
            .andExpect(status().isCreated());
    }
}
```

In the example, we have a test that will make a request to the controller and check the HTTP Status of the response. We use __@WebMvcTest__ with the controllers parameter to restrict the application's test context to `CustomerControllerV2`,
if we don't pass the controllers parameter, Spring Boot will include all controllers in the application context.

## Test for the Persistence layer with @DataJpaTest

The __@DataJpaTest__ annotation contains settings that allow the use of Spring Data JPA Repositories without having to upload the entire application context and configures an embedded database to be used in memory during tests.
To configure the embedded database, we use the @AutoConfigureTestDatabase annotation, passing an Enum of type `EmbeddedDataConnection` in the connection property.

In the example we configured the H2 database, for other options like Derby and HSQL check the Spring documentation.

``` { .java .copy }
@DataJpaTest
@AutoConfigureTestDatabase(connection = EmbeddedDatabaseConnection.H2)
@ActiveProfiles("test")
public class CustomerRepositoryIntegratedTest {

    @Autowired
    CustomerRepository repository;
    Customer customer;
    Address address;

    @BeforeEach
    public void init() {
        address =  new Address("Rua Alexandre Dumas", 2051, "Chácara Santo Antônio", "04735400", "São Paulo", "SP");
        customer =  new Customer("32259952070", "Maria da Silva", address, "11999998888", LocalDate.of(1993, 4, 22));
    }

    @Test
    public void should_saveCustomer_when_callMethodSave() {
        Customer customerSaved = repository.save(customer);
        assertAll(
            () -> assertThat(customerSaved.getId(), is(equalTo(1L))),
            () -> assertThat(customerSaved.getName(), is(equalTo("Maria da Silva")))
        );
    }
}
```

To use a database other than the EmbeddedDatabaseConnection, pass an Enum of type Replace to the replace property to define the types of datasources that will be replaced. For example,
the Replace.NONE option, which does not replace the application's datasource, for other options check the Spring documentation.

This option is valid in cases where you need to test native queries that do not work with in-memory databases.

## Infrastructure for integrated tests

For some situations to implement the integrated tests, an infrastructure is required. For example, when testing database persistence it may be necessary to have an in-memory database, such as h2, to run the tests.

When adding h2 to run the built-in persistence tests, you must place the dependency on pom.xml in test scope.

``` { .xml .copy }
<dependency>
   <groupId>com.h2database</groupId>
   <artifactId>h2</artifactId>
   <version>${h2.version}</version>
   <scope>test</scope>
</dependency>
```

In addition to the dependency for the in-memory database, you must create an application-test.yml file in src/test/resources with the settings for the database, as done for the production code.
