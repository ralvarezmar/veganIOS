# Unit Test

## Tools used

Arsenal provides the __gln-back-arsenal-backend-lib-test__ library which provides all the necessary dependencies for building unit tests in Arsenal Cloud Native applications.
The library includes the JUnit 5 framework for building unit tests and the Mockito framework for creating mockups.

## Project setup

In the application's pom.xml file, the dependency for Arsenal's __gln-back-arsenal-backend-test-starter__ must be included, as shown in the following example:

``` { .xml .copy }
<dependencies>
    <dependency>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-backend-test-starter</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## Creating Unit Tests

To create a unit test that uses JUnit and Mockito, just create a class annotated with @ExtendWith and also annotate its methods (the tests themselves) with @Test, as in the example below:

``` { .java .copy }
@ExtendWith(MockitoExtension.class)
public class CustomerServiceTest {
    @Test
    public void should_throwException_when_ageLessThan18Years() {}
}
```

!!! tip "Don't forget to follow the already defined Naming Standards for naming test classes and methods!"

## What should be tested?

In short, you should write tests for critical or complex parts of the application, especially those with implemented business rules.
The main purpose of unit testing is to ensure that the logic implemented in the application is correct and that the code written has not caused another part of the application to stop working correctly.

A good example of a class that needs unit testing is the application's Service class, as they are the place where the business rules are implemented. Classes like Controllers, Handlers, Configuration and DTOs typically don't have business rules.
Writing the test cases.

A test usually consists of 3 parts:

1. Preparation: create everything necessary to execute the method that will be tested (eg instantiate objects or mock responses);

2. Execution: make a call to the method that will be tested;

3. Verification: check whether the method's return or behavior is as expected.
In the example below, we have the CheckingAccountServiceImpl class that has a method to perform a deposit operation.

    ``` { .java .copy }
    @Service
    public class CheckingAccountServiceImpl implements CheckingAccountService {
        @Autowired
        private CheckingAccountRepository checkingAccountRepository;

        @Transactional
        @Override
        public CheckingAccount deposit(long ownerId, long amount) {
            CheckingAccount account = checkingAccountRepository.findByOwnerId(ownerId);
            existsAndOperable(account);
            account.deposit(amount);
            return checkingAccountRepository.save(account);
        }
    }
    ```

In the above `deposit()` method, a deposit into an account is only made if the customer has an account and if it is active, otherwise exceptions are thrown.
Let's create a test to verify the scenario where a deposit is made successfully, demonstrating the 3 parts of the test mentioned above:

``` { .java .copy }
public class CheckingAccountServiceTest {
    // 1. Preparation: let's use a mock of the Repository class
    @Mock
    CheckingAccountRepository repository;

    // 1. Preparation: Service instance that will be used for the test
    @InjectMocks
    CheckingAccountServiceImpl service;

    // 1. Preparation: other classes needed to simulate the desired scenario
    CheckingAccount checkingAccount;
    AccountOwner accountOwner;

    @BeforeEach
    public void setUp() {
        // 1. Preparation: instantiating the necessary objects
        accountOwner = new AccountOwner(2, "45638956678", "Fulano");
        checkingAccount = new CheckingAccount(accountOwner, CheckingAccount.generateNumbering());
    }

    @Test
    public void should_deposit_when_accountExistsAnIsActive() {
        // 1. Preparation: Configuring Repository mock behavior
        when(repository.findByOwnerId(ID_ACCOUNT_OWNER)).thenReturn(checkingAccount);
        when(repository.save(checkingAccount)).thenReturn(checkingAccount);

        // 2. Execution: call to the Service's "deposit" method
        CheckingAccount account = service.deposit(ID_ACCOUNT_OWNER, 30);

        // 3. Verification: we deposit 30 reais, we check if the account balance matches this amount
        assertEquals(30, account.getBalance());
    }
}
```

In the example above, we first prepared the test scenario by mocking the responses that would be given by the Repository (see Mockito section below).
Then, an execution of the `deposit()` method is performed, and finally a check on the account balance to see if the amount passed was deposited.

To verify the test results, we use static JUnit methods called asserts. In the example above, `assertEquals(ExpectedValue, TestResult)` was used to check whether the test result is equal to the expected value.
We can use other asserts to check different conditions like `assertNotNull`, `assertFalse`, among others. Consult the official JUnit documentation for the complete list.
Another option is to use Hamcrest matchers like assertThat to write checks in a more declarative way.

!!! warning "When writing unit tests for a class that has dependency on other components (such as Repository), remember that what must be tested are the business rules implemented in the method, not whether the Repository is actually writing to the database.
In a unit test we don't even need to have a real database as these dependencies must be mocked!"

## Mockito

Mockito is a framework for creating mock objects. Mocks are "simulated" objects, that is, they have the same methods as the original objects, but only simulate their behavior when executed.

Mocks are especially useful in unit tests to simulate the dependencies needed by the class being tested. In the above example, the Service class needs a Repository to interact with the database.
As we are concerned with testing only the Service class, we use a mock of the Repository class and instruct it to simulate the behavior that the original object would have.
That way, we can run the unit tests without depending on anything in the environment (for example a database)!

### How to create mockups?

To create a mock we use the @Mock annotation on the object to be mocked. Next, we need to indicate that the object that will be tested needs to use mocked versions of its dependencies, and not the version that has the original implementation.
This procedure is done using the @InjectMocks annotation on the object that will be tested, as in the example below:

``` { .java .copy }
public class CheckingAccountServiceTest {
    // object to be mocked
    @Mock
    CheckingAccountRepository repository;

    // object to be tested
    @InjectMocks
    CheckingAccountServiceImpl service;
}
```

A mock doesn't do exactly anything, before using them it is necessary to configure the behavior they will have when their methods are called. This process is done through Mockito's `when()` and `thenReturn()` methods.

These methods allow us to write an expression of the type `when("method to be simulated").thenReturn("what should be returned")`, which in practice is to "tell" Mock "when this method is called then return this object as a result".

At the end of the test, we can also use Mockito's `verify()` method to verify if the tested object has interacted with the mock. For example, we can check whether the Service class actually called the Repository's `save()` method.

Mockito has several other methods besides the ones mentioned here, check the official documentation to learn more.

## Hamcrest

Hamcrest is a framework that allows us to create verification rules (asserts) in a more declarative way. They can be combined with JUnit's `assertThat()` method to create more readable and easy to understand assertions.

In the example below, we can easily understand that the code is making sure that the code returned by the `getCode()` method `is equal to "44140948756"`:

```java
assertThat(responseDto.getCode(), is(equalTo("44140948756")));
```

The `is()` and `equalTo()` methods are called matchers. Hamcrest supports several other matchers besides these, see the official documentation for more details.

!!! tip "It is perfectly possible to write the assertions using only JUnit, the use of Hamcrest is optional."

## Test coverage

Test coverage is a software metric that measures (in percentage) how much of the source code is executed when we run tests. In other words, it is a metric that indicates the percentage of source code that is covered by a test.

In general, the greater the coverage, the better. On the other hand, remember that it doesn't make sense to create unit tests for all classes of the application, so it doesn't make sense to strive for coverage close to 100%.

### Checking your code coverage

To verify the test coverage of the code, we used the JaCoCo (Java Code Coverage) tool. JaCoCo can be integrated with Maven, so that when we run our application's tests, a coverage report is automatically generated in the `/target/jacoco.exec` folder.
This report is already read today by quality tools used at Santander such as SonarQube.

To use __JaCoCo__, simply declare the following plugin in the application's pom.xml file:
pom.xml

``` { .xml .copy }
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <executions>
        <execution>
            <id>default-prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>default-report</id>
            <phase>prepare-package</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```
