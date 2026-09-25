# How to use distributed cache

Spring Boot provides support for several distributed caching solutions (providers).
In Arsenal Cloud Native applications we use **Redis** due to its maturity, ease of
use and performance.

Arsenal provides the **arsenal-lib-distributed-cache** library to abstract the use
of Redis, allowing the configuration of multiple cache regions and the time to
live (TTL) associated with them.

## Infrastructure Requirements

Each project is responsible for ordering its own distributed caching infrastructure.
As the objective here is to use Redis only for caching purposes, we recommend using
a single instance configuration and without persistence, that is, it can even run
within PaaS. **Never** use the same Redis instance for caching and persistence purposes!

!!! warning

    Arsenal's distributed cache library is configured to not interfere with the
    application's operation if Redis becomes unavailable. The library performs
    automatic reconnection and operations will be performed on the database during
    the cache unavailability period.

    It is extremely important that Redis **does not have persistence**, as it can
    generate data inconsistency, for example making your API return data that was
    cached that has already been deleted from the database.

**_1. Configuration_**

Add the following dependency in the **pom.xml** file:

``` { .xml .copy }
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-backend-lib-distributed-cache</artifactId>
</dependency>
```

Add **@EnableArsenalDistributedCache** annotation to the main class.

Then add the configuration to **application.yml**:

``` { .yaml .copy }
arsenal:
    library:
        distributed-caching:
            redis-host: localhost
            redis-port: 6379
            redis-pass: /etc/credentials/srv-redis/password
            connect-timeout: 5
            default-ttl: 600
            cache-ttl:
                customers: 300
                accounts: 120
```

Check the [distributed cache reference](../../references/distributed-cache.md)
page for more details about the parameters.

**_2. Write and read data in the cache_**

Finally, we can now manipulate data in the cache to insert, query, update and remove
records. As an example, let's use a customer registration API (CRUD), where the cache
is automatically manipulated to keep itself updated according to the reference table
below:

| HTTP Method | Annotation |                         Description                          |
|:-----------:|:----------:|:------------------------------------------------------------:|
|     GET     | @Cacheable | Gets the customer data from the database and also inserts it into the cache. On subsequent queries, it will try to get the data from the cache first.  |
| PUT | @CachePut | Updates customer data in the database and also in the cache.|
| DELETE | @CacheEvict | Removes a customer data from the database and also from the cache. |

!!! info

    Classes that will be stored in the distributed cache need to implement the
    **Serializable** interface of the **java.io** package. In Spring Boot, we
    cannot put the cache directly in the Controllers layer because the ResponseEntity
    class is not Serializable!

    To generate classes that implements Serializable interface, set the generator 
    **serializableModel** property to true. (Add <serializableModel>true</serializableModel>)

    <plugin>
        <groupId>org.openapitools</groupId>
        <artifactId>openapi-generator-maven-plugin</artifactId>
        <executions>
            <execution>
                ...
                <configuration>
                    ...
                    <configOptions>
                        ...
                        <serializableModel>true</serializableModel>
                    </configOptions>
                </configuration>
            </execution>
        </executions>
    </plugin>

**Example:**

``` { .java .copy }
@Service
@CacheConfig(cacheManager = "distributedCache")
public class CustomerProviderImpl {

    @Autowired
    private CustomerRepository customerRepository;

    @Cacheable(cacheNames = "customers", key = "#customerId")
    public CustomerResponseDTO getCustomerById(Long customerId) {
        return Customer.toDTO(customerRepository.findById(customerId).get());
    }

    @CachePut(cacheNames = "customers", key = "#customerId")
    public CustomerResponseDTO updateCustomer
    (Long customerId, CustomerRequestDTO customerRequest) {
        Customer customer = customerRepository.findById(customerId).get();
        customer.setName(customerRequest.getName());
        customerRepository.save(customer);
        return Customer.toDTO(customer);
    }

    @CacheEvict(cacheNames = "customers", key = "#customerId")
    public void deleteCustomer(Long customerId) {
        customerRepository.deleteById(customerId);
    }
}
```

The **@CacheConfig** annotation above indicates that the class in question must
use the **CacheManager** that controls the distributed cache to insert and query
the data. This configuration is extremely important when your application is working
simultaneously with distributed cache and local cache, otherwise you could be storing
data in the wrong cache!

!!! tip

    If there is an error in the connection, try to enable the **use-ssl** property
