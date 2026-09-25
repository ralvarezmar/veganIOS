# How to use local cache

Spring Boot provides support for several local cache libraries. In Arsenal Cloud
Native
applications, the **Ehcache** library should be used due to its maturity, ease of
use and performance.

**_1. Configuration_**

Add the following dependencies in the **_pom.xml_**:

``` { .xml .copy }
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>

<dependency>
    <groupId>org.ehcache</groupId>
    <artifactId>ehcache</artifactId>
    <version>3.10.8</version>
</dependency>

<dependency>
    <groupId>javax.cache</groupId>
    <artifactId>cache-api</artifactId>
    <version>1.1.1</version>
</dependency>
```

Then create a configuration class to create and set cache parameters. The class
need to be annotated with **@EnableCaching**. Here's an example of the creation
and configuration of a cache named **_branchAddress_**:

``` { .java .copy }
@Configuration
@EnableCaching
public class CacheConfig {
  @Bean
  public CacheManager EhcacheManager() {

    CacheConfiguration<Long, String> cachecConfig = CacheConfigurationBuilder
            .newCacheConfigurationBuilder(
                Long.class,
                String.class,
                ResourcePoolsBuilder.newResourcePoolsBuilder().heap(2, MemoryUnit.MB).build())
            .withExpiry(ExpiryPolicy.NO_EXPIRY)
            .build();

    CachingProvider cachingProvider = Caching.getCachingProvider();
    CacheManager cacheManager = cachingProvider.getCacheManager();

    javax.cache.configuration.Configuration<Long, String> configuration =
        Eh107Configuration.fromEhcacheCacheConfiguration(cachecConfig);

    cacheManager.createCache("branchAddress", configuration);

    return cacheManager;
  }
}
```

**_2. Write and read data in the cache_**

To write and read data from the cache, the **@CacheConfig** and **@Cacheable** annotations should be used as in the example below. The **@CacheConfig** annotation is used at the class
level and configures which CacheManager should be used. The **@Cacheable** annotation is used on the methods, the **_value_** attribute indicates the cache name, and the _key_ attribute indicates which argument(s) of the method
should be used as the key for the records.

**Example:**

``` { .java .copy }
public class BranchProviderImpl {

    @Autowired
    private BranchRepository branchRepository;

    @Cacheable(value = "branchAddress", key = "#branchNumber")
    public String getBranchAddress(String branchNumber) {
        String branchAddress = branchRepository.findByBranchNumber(branchNumber);
        return branchAddress;
    }
}
```

In this example, we have a method that queries the address of a branch by its number.
Each time the method is called, a query will first be made in the cache using the
branch number as the key. If the record is found, it is returned directly from the
cache and there's no need to query the database. If the record doesn't yet exist
in the cache, the method is executed normally but its return value will be added
to the cache automatically, becoming available in the next query.

The **@CacheConfig** annotation above indicates that the class in question must use
the CacheManager that controls the local cache to insert and query the data. This
configuration is extremely important when your application is working simultaneously
with local cache and distributed cache, otherwise you could be storing data in the
wrong cache!

## References

1. [Spring Cache Abstraction](https://docs.spring.io/spring-framework/docs/current/reference/html/integration.html#cache)
2. [Ehcache](https://www.ehcache.org/documentation/3.10/)
