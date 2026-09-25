# Key-Value Database

NoSQL (non SQL reference), is the term used to describe non-relational
databases. NoSQL databases, unlike traditional databases such as: Oracle, MySQL,
SQL Server and others, are not necessarily of the same type, as each one adopts
one or more data models. These data models can be document, key and value,
columnar or graph.

As well as the data models to solve each type of problem, NoSQL databases, in
general, have differences compared to relational databases. To begin with, we
can say that NoSQL databases do not have a schema, that is, they are not
represented in the same way that conventional databases are represented, through
data normalization through tables, columns and rows.

Another difference is the way we scale NoSQL databases, where the larger the
cluster, the greater the performance, making it easier to scale horizontally,
unlike relational databases which are easier to scale vertically, adding more
resources to a machine, such as memory and CPU. These are just a few differences
between NoSQL and relational databases.

## Settings

### Dependency

The dependency indicated below, which includes the configuration classes for
Redis and Spring, must be included in the application's pom.xml.

``` { .xml .copy }
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### Yaml configuration

After including the dependency in your project, it is necessary to configure
properties related to the type of cache, host and port that your redis is
installed on.

``` { .json .copy }
cache:
    type: redis
  redis:
    host: localhost
    port: 6379
```

### Lettuce

Lettuce is a client that makes it easy to build Redis connections and
configurations. One of the great highlights for Lettuce is that it provides a
natural interface for performing asynchronous requests from the Redis database
server and for creating flows.

#### Configuring Redis with Lettuce and Spring

``` { .java .copy }
@Configuration
@EnableRedisRepositories
class AppConfig {
  @Bean
  public LettuceConnectionFactory redisConnectionFactory() {
    return new LettuceConnectionFactory(new RedisStandaloneConfiguration("server", 6379));
  }
  @Bean
  public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
    RedisTemplate<String, Object> template = new RedisTemplate<>();
    template.setConnectionFactory(redisConnectionFactory());
    return template;
  }
}
```

#### Configuration for writing to the master instance and reading from the replica with Lettuce

The Redis master/replica configuration allows data to be securely stored on more
nodes. It also allows, using Lettuce, to read data from replicas while writes
are performed on the master instance, enabling better performance and more cache
resiliency. The read/write strategy to be used can be defined through the
LettuceClientConfiguration, as indicated in the following example:

``` { .java .copy }
@Configuration
class WriteToMasterReadFromReplicaConfiguration {
  @Bean
  public LettuceConnectionFactory redisConnectionFactory() {
    LettuceClientConfiguration clientConfig = LettuceClientConfiguration.builder()
      .readFrom(SLAVE_PREFERRED)
      .build();
    RedisStandaloneConfiguration serverConfig = new RedisStandaloneConfiguration("server", 6379);
    return new LettuceConnectionFactory(serverConfig, clientConfig);
  }
}
```

#### Sentinel

Redis Sentinel monitors master/slave instances and orchestrates failures.
Lettuce can connect to Sentinel, use it to learn the current address of the
master, and then return a connection to it. For that, there is a different
RedisURI and we connect the RedisClient to it:

``` { .java .copy }
RedisURI redisUri = RedisURI.Builder
  .sentinel("sentinelhost1", "clustername")
  .withSentinel("sentinelhost2").build();
RedisClient client = new RedisClient(redisUri);
RedisConnection<String, String> connection = client.connect();
```

#### Data modeling with Redis

The modeling of a NoSql database is based on three annotations, with the purpose
of defining which collection the object belongs to, an id to search and the
attributes that this key can obtain as a response, being an object or more
complex data structures, like lists.

The @RedisHash annotation creates a collection referring to the object, inside
parentheses it will be necessary to inform the key of this collection. There is
also the @Id, this other annotation composes the key together with the name
informed in the @RedisHash annotation. There is yet another annotation, the
@Indexed that marks the value of the properties to be included in a secondary
index, internally the Redis SET command is used for storage, so the value will
be part of the key created by the index.

``` { .java .copy }
@RedisHash("people")
public class Person {
  @Id String id;
  String firstname;
  String lastname;
  Address address;
}
```

### Redis Repository Patterns

Spring offers a development resource using other data interfaces, it is the
CrudRepository. It will be necessary to create an interface respecting the
package standards, that is, it will be created inside the project's repository
package. Utilizing the concept of inheritance your interface will extend this
capability of Spring-Data with redis.

``` { .java .copy }
public interface PersonRepository extends CrudRepository<Person, String> {
    Map<Object, Object> findAllPerson();
    void add(Person person);
    void delete(String id);
    Person findPerson(String id);
}
```

#### Repository Implementation

The repository implementation class must use the RedisTemplate defined in the
AppConfig configuration class. HashOperations should be used, a standard that
Spring Data Redis offers. If the project does not contain the package referring
to the implementation of the repository, a package with the following pattern
must be created: __br.com.santander.(acronym).(application
name).repository.impl__

``` { .java .copy }
@Repository
public class PersonRepositoryImpl implements PersonRepository {
    private static final String KEY = "Person";
    private RedisTemplate<String, Object> redisTemplate;
    private HashOperations hashOperations;
    @Autowired
    public RedisRepositoryImpl(RedisTemplate<String, Object> redisTemplate){
        this.redisTemplate = redisTemplate;
    }
    @PostConstruct
    private void init(){
        hashOperations = redisTemplate.opsForHash();
    }
    public void add(final Person person) {
        hashOperations.put(KEY, person);
    }
    public void delete(final String id) {
        hashOperations.delete(KEY, id);
    }
    public Person findPerson(final Long id){
        return (Person) hashOperations.get(KEY, id);
    }
    public Map<Object, Object> findAllPerson(){
        return hashOperations.entries(KEY);
    }
}
```

#### Read and Write with Redis

There are multiple ways to work with data with Redis. the most used forms are:
Hash, List, Set, Value and ZSet. There are still other types of data that are:
Geo, used for location, and HyperLogLog, used for logging.

##### HashOperation

Performs Redis-specific operations by working on a hash.

``` { .java .copy }
HashOperations hashOperations = redisTemplate.opsForHash();
```

##### ListOperation

It is used for list-specific operations with Redis.

``` { .java .copy }
ListOperations<String, Person> listOps = redisTemplate.opsForList();
```

##### SetOperation

Changes the behavior of the desired data.

``` { .java .copy }
SetOperations<String, Person> setOps = redisTemplate.opsForSet();
```

##### ValueOperation

Returns single value operations only.

``` { .java .copy }
ValueOperations<String,Person> valueOps = redisTemplate.opsForValue();
```

##### ZsetOperation

Returns operations performed on zset values (also known as sorted or indexed
sets).

``` { .java .copy }
ZSetOperations<String, Person> valueOps = redisTemplate.opsForZSet();
```

### Comments

#### Redis cache limits

Although Redis is very fast, it still has no limits for storing any amount of
data on a 64-bit system. It can only store 3GB of data on a 32-bit system. More
available memory can result in a higher hit rate, but this tends to stop when
too much memory is taken up by Redis. When the cache size reaches the memory
limit, the old data is removed to replace the new one.

### References

[Spring Data
Redis](https://docs.spring.io/spring-data/data-redis/docs/current/reference/html/#requirements)

[Redis Commands](https://redis.io/commands/)
