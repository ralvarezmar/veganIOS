# Darwin Spring Boot Cache ![5.8.2](https://img.shields.io/badge/5.8.2-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

Library in charge of managing the DARWIN-based microservices cache. It currently has support for Caffeine and Data Grid.

## Features

- It incorporates error handling that prevents applications from failing because of cache errors.

- Allows you to define values for the connection and data retrieval timeouts from the Data Grid cache.

- Configure the Red Hat Data Grid cache uses without the need to add code or include additional libraries.

- It includes a service to be able to cache objects in reactive applications.

- It allows caching both in a local cache with Caffeine and in a distributed cache using Data Grid simultaneously and automatically.

## Installation and configuration

To use this library, depending on the type of cache (**Caffeine** or **Data Grid**) that we want to use, we will have to include as dependency one starter or another.

If we want to use the **Caffeine** cache, we must add:

### Caffeine dependency

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-cache-caffeine</artifactId>
    </dependency>

and in case we want to use the **Data Grid** cache, we will have to add:

### Data Grid dependency

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-cache-infinispan</artifactId>
    </dependency>

!!! warning

    If you want to use both caches, you must import both starters, as the old starter that loads both caches will be **deprecated** in future releases.

### Configuration

<!tag:properties>

| Name                                                                                     | Default Value                                                   | Mandatory | Description                                                                                                                                                                                | Supported Values                         |
|------------------------------------------------------------------------------------------|-----------------------------------------------------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|
| darwin.cache.automatic-mode.enabled                                                      | false                                                           | No        | Allows a microservice to simultaneously cache both locally with *Caffeine* and in a distributed *Data Grid*                                                                                | Boolean                                  |
| darwin.cache.automatic-mode.cache-type-by-priority                                       | [INFINISPAN,CAFFEINE]                                           | No        | Indicates in which order the automatic cache will search the cache. For example, with the default values [INFINISPAN,CAFFEINE] it goes first to INFINISPAN (Datagrid) and then to CAFFEINE | List&lt;CacheType&gt;                    |
| darwin.cache.automatic-mode.cache-name-by-type                                           | null                                                            | No        | By default the automatic cache prompts cache managers to check which cache names they contain. Using this map, you can indicate which cache names will be looked for in each cache type    | Map&lt;CacheType, List&lt;String&gt;&gt; |
| darwin.cache.circuitbreaker.enabled                                                      | true                                                            | No        | Add a Circuit Breaker to cache calls                                                                                                                                                       | Boolean                                  |
| darwin.cache.infinispan.use-auth                                                         | true                                                            | No        | Indicates whether to use authentication on the connection. In the case that it is disabled, the actuator will not be able to be used with the cache statistics                             | Boolean                                  |
| darwin.cache.infinispan.auth-username                                                    | null                                                            | No        | Cache connection user                                                                                                                                                                      | String                                   |
| darwin.cache.infinispan.auth-password                                                    | null                                                            | No        | Password for cache connection user                                                                                                                                                         | String                                   |
| darwin.cache.infinispan.auth-realm [see](README.md#authentication-mechanisms)            | ApplicationRealm                                                | No        | Application realm against which we authenticate                                                                                                                                            | String                                   |
| darwin.cache.infinispan.auth-server-name [see](README.md#authentication-mechanisms)      | jdg-server                                                      | No        | Server name against which we authenticate                                                                                                                                                  | String                                   |
| darwin.cache.infinispan.sasl-mechanism [see](README.md#authentication-mechanisms)        | DIGEST-MD5                                                      | No        | Algorithm used for authentication verification                                                                                                                                             | String                                   |
| darwin.cache.infinispan.read-timeout                                                     | 200                                                             | No        |                                                                                                                                                                                            | Long                                     |
| darwin.cache.infinispan.write-timeout                                                    | 200                                                             | No        |                                                                                                                                                                                            | Long                                     |
| darwin.cache.caffeine.async [see](README.md#darwincachemono-with-automatic-mode-enabled) | false                                                           | No        | Allows Caffeine caches to be created in asynchronous mode by default. Necessary for the use of cache annotations in reactive mode with Caffeine                                            | Boolean                                  |
| infinispan.remote.enabled                                                                | true                                                            | No        | Enable remote cache                                                                                                                                                                        | Boolean                                  |
| infinispan.remote.server-list                                                            | null                                                            | No        | A list of remote servers in the form: host1[:port][;host2[:port]]...                                                                                                                       | String                                   |
| infinispan.remote.protocol-version [see](README.md#protocol)                             | 2.9                                                             | No        | Version of client protocol (hot rod)                                                                                                                                                       | String                                   |
| infinispan.remote.marshaller [see](README.md#marshalling)                                | org.infinispan.jboss.marshalling.commons.GenericJBossMarshaller | No        | Marshalling                                                                                                                                                                                | String                                   |
| infinispan.remote.java-serial-allowlist [see](README.md#marshalling)                     | null                                                            | No        | Add classes to the serialization allow list to use Java Serialization. You can specify a comma-separated list of fully qualified class names or a regular expression to match classes      | List                                     |
| infinispan.remote.reactive [see](README.md#darwincachemono-with-automatic-mode-enabled)  | false                                                           | No        | Add support to use Datagrid caches in reactive mode. Necessary to use cache annotations in reactive microservices                                                                          | Boolean                                  |

<!end:properties>

### Basic configuration for Data Grid

!!! note

    If the Data Grid cluster has been named datagrid-app in Open Shift (default name) then *server\_name* will be *datagrid-app-hotrod*. The default *port* is *11222*

!!! warning

    Both the **user** and the Data Grid access **key** should always be in the **environment-dependent configuration** and not inside the application.yml file that goes inside the microservice.

!!! warning

    The **infinispan.remote.socket-timeout**, **infinispan.remote.connect-timeout** and **infinispan.remote.max-retries** properties that were documented in previous versions, it is strongly recommended that they not be modified
    and the default value be kept as the default value.

        spring:
        cache:
          type: infinispan
        session:
          store-type: none
        
        infinispan:
        remote:
          server-list: <server_name:port>
        
        darwin:
        cache:
          infinispan:
            auth-username: u001
            auth-password: pass001

### Basic configuration for Caffeine

    spring:
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      session:
        store-type: none

### Complete configuration for Data Grid

    spring:
      cache:
        type: infinispan

    infinispan:
      remote:
        server-list: <server_name:port>

    darwin:
      cache:
        infinispan:
          read-timeout: 200
          write-timeout: 200
          use-auth: true
          auth-username: u001
          auth-password: pass001

### Basic configuration for Automatic Mode. Use Caffeine and Data Grid at once

    spring:
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      session:
        store-type: none

    infinispan:
      remote:
        server-list: <server_name:port>

    darwin:
      cache:
        automatic-mode:
          enabled: true
        infinispan:
          auth-username: u001
          auth-password: pass001

### Complete configuration for Automatic Mode. Use Caffeine and Data Grid at once

    spring:
      cache:
        type: caffeine
        caffeine:
          spec: expireAfterWrite=10m
      session:
        store-type: none

    infinispan:
      remote:
        server-list: <server_name:port>

    darwin:
      cache:
        automatic-mode:
          enabled: true
          cache-type-by-priority:
            - INFINISPAN
            - CAFFEINE
          cache-name-by-type:
            INFINISPAN:
              - "cache1InInfinispan"
              - "cache2InInfinispan"
            CAFFEINE:
              - "cache1InCaffeine"
        infinispan:
          auth-username: u001
          auth-password: pass001

### Migrating applications to Data Grid 8

For backward compatibility, the configuration is established to connect with DataGrid 7.3.x. For Data Grid 8.3.x the following are the different configurations that *must* be established.

#### Marshalling

Marshalling capabilities are significantly refactored in Data Grid 8 to isolate internal objects and user objects.

JBoss Marshalling is a serialization-based marshalling library and was the default marshaller in previous Data Grid versions.
So, for backwards compatibility, the *Darwin framework sets this Java serialization marshaller as the default*.

!!! note

    Data Grid provides Marshaller implementations that you can use instead of JBoss. By default, Data Grid 8 uses the **ProtoStream** API to marshall data. You can also configure Data Grid to use custom marshaller
    implementations. For further more information read [Configuring Marshaller](https://infinispan.org/docs/stable/titles/spring_boot/starter.html#spring-boot-serialization_remote)

!!! warning

    JBoss Marshalling uses deep reflection, which requires explicit authorization in Java 17. It is necessary to add the command/s **-add-opens** as indicated at [Strong Encapsulation in the JDK
    ](https://docs.oracle.com/en/java/javase/17/migrate/migrating-jdk-8-later-jdk-releases.html#GUID-12F945EB-71D6-46AF-8C3D-D354FD0B1781). You can use another serializer such as `org.infinispan.commons.marshall.JavaSerializationMarshaller` or
    `org.infinispan.commons.marshall.ProtoStreamMarshaller` to avoid having to configure this.

If you want to use `JavaSerializationMarshaller` an example configuration is shown below:

    infinispan:
      remote:
        java-serial-allowlist: com.santander.darwin.authentication.*
        marshaller: org.infinispan.commons.marshall.JavaSerializationMarshaller

#### Authentication mechanisms

To maintain compatibility with DataGrid 7.x versions, the `darwin.cache.infinispan.auth-realm`, `darwin.cache.infinispan.auth-server-name` and `darwin.cache.infinispan.sasl-mechanism` properties are set to the values shown in this table.

| JDG   | Realm            | Server Name | SASL authentication mechanism |
|-------|------------------|-------------|-------------------------------|
| 8.3.x | default          | infinispan  | SCRAM-SHA-512                 |
| 7.x   | ApplicationRealm | jdg-server  | DIGEST-MD5                    |

To authenticate against Data Grid 8.3, you must set the properties according to the following configuration:

    darwin:
      cache:
        infinispan:
          auth-realm: default
          auth-server-name: infinispan
          sasl-mechanism: SCRAM-SHA-512

[For more information, see Infinispan documentation](https://infinispan.org/docs/13.0.x/titles/upgrading/upgrading.html)

#### Connecting pre-3.1.x versions to RHDG 8.3.x

When the Darwin version used includes Infinispan `9.4.24.Final-redhat-00002`, there are a few things to be aware of:

##### Protocol

By default, in these versions the value is *2.5*, but it is recommended to set it to **2.9**. See [Protocol](#protocol), [Configuration](#configuration).

##### Configuring the Deserialization Whitelist

Note that, in that versions, JBoss Marshaller was the default for Infinispan.
If you want to deserialize objects for other Java class instances, you must configure a deserialization whitelist.
Add the following system properties to the JVM at start up:

    (1)
    - Dinfinispan.deserialization.whitelist.regexps=your.class.*
    - Dinfinispan.deserialization.whitelist.classes=your.class.ExampleClass,another.ExampleClass

1. Both system properties are optional. You can specify a combination of both properties or specify either property by itself.

##### Authentication mechanisms

The *SASL authentication mechanism* by default is **DIGEST-MD5**.
But you need to set *Realm* as **default** and *Server Name* as **infinispan**,
these values are used to connect to Data Grid 8.3, see [Configuration](#configuration).

    darwin:
      cache:
        infinispan:
          auth-realm: default
          auth-server-name: infinispan
          sasl-mechanism: DIGEST-MD5 (1)

1. At that versions it is not necessary to set this property, the default value is `DIGEST-MD5`. It is only mentioned in this migration scenario for illustrative purposes.

### How to set up CircuitBreaker for the Cache

To disable the cache circuitbreaker, you would add the following property to the configuration:

    darwin:
      cache:
        circuitbreaker:
          enabled: false

This property defaults to **true**.

!!! warning

    Only work with DataGrid cache.

#### CircuitBreaker

The basic CircuitBreaker properties and their default values are as follows:

- **minimumNumberOfCalls:** The size of the buffer ring when the circuit is closed. The failure rate will not be calculated until this minimum number of calls is registered. The default value is ***100***.

- **permittedNumberOfCallsInHalfOpenState:** The size of the buffer ring when the circuit is half open. This ring is used when the circuit breaker transitions from open to half open to assess the health of the circuit. Failure to exceed the fault
    rate after this number of calls will result in the circuit being closed. The default value is ***10***.

- **waitDurationInOpenState:** The time the circuit breaker must wait before transitioning from open to half open. The default value is ***60*** \[s\].

- **failureRateThreshold:** The failure rate threshold in percent, at which the circuit breaker will open the circuit and start shorting calls. The default value is ***50***.

- **recordFailurePredicate:** The predicate class that evaluates which exceptions should be used to open the circuit. By default, the loop will be opened with exceptions corresponding to an HTTP 5xx status of the called server.

If we want to change this configuration, the properties must be configured as follows:

    resilience4j.circuitbreaker:
      instances:
        cache:
          minimumNumberOfCalls: 2
          permittedNumberOfCallsInHalfOpenState: 5
          waitDurationInOpenState: 350
          failureRateThreshold: 50

!!! note

    For more information about the operation or additional parameters of this CircuitBreaker, please refer to the product documentation: [Resilience4j CircuitBreaker](https://resilience4j.readme.io/docs/circuitbreaker).

## Native compilation support

This library can be used on micros that are compiled to a native image with graalvm native.
If you want to use `darwin-spring-boot-starter-cache-infinispan` in native mode, you also have to add the next dependencies:

```xml
<dependency>
    <groupId>org.infinispan</groupId>
    <artifactId>infinispan-core-graalvm</artifactId>
</dependency>
<dependency>
    <groupId>org.infinispan</groupId>
    <artifactId>infinispan-client-hotrod-graalvm</artifactId>
    <version>${infinispan.version}</version>
</dependency>
```

### Support for third party libraries

This library includes tentative support for the *Infinispan* client.

!!! warning

    This support is limited to the functionality used in Darwin tests, projects using these dependencies may need to add more hints for proper operation.

## Exposed API

| Name                                                               | Type    | Description                                                                                                                                                                                                                        | Exposed methods                                                                                                                                                               |
|--------------------------------------------------------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [DarwinCacheMono](#how-to-use-the-cache-in-a-reactive-application) | Service | This service contains useful methods to be able to cache Mono objects in reactive applications. In the case that the application does not have a cache, a dummy service is instantiated in a transparent way for the application a | <ul><li>cache(String nameTableCache, String key, Mono&lt;T&gt; value) get a value from main cache (spring.cache.type) if the value does not exist then it caches it</li></ul> |

## Library use cases

### How to activate the cache

To make use of the cache, you must place the @EnableCaching annotation in the application configuration class (for example, in the class where the @SpringBootApplication annotation is marked) and use the Spring annotations that the spring-cache
module supports

!!! warning

    Using native cache methods directly is discouraged. The cache should always be accessed through the Spring annotations.

### How to use the cache

To use the cache, we recommend the use of Spring annotations. These would be the annotations that *Spring* offers us:

| Name         | Description                                                      |
|--------------|------------------------------------------------------------------|
| @Cacheable   | Triggers cache population.                                       |
| @CacheEvict  | Triggers cache eviction.                                         |
| @CachePut    | Updates the cache without interfering with the method execution. |
| @Caching     | Regroups multiple cache operations to be applied on a method.    |
| @CacheConfig | Shares some common cache-related settings at class-level.        |

More information on how to use these annotations can be found in [cache-annotations](https://docs.spring.io/spring-framework/docs/6.1.20/reference/html/integration.html#cache-annotations)

For example, to cache the value returned by the *cacheableTest* method with the *key*, you would use the *@Cacheable* annotation as shown in the example below:

    @Cacheable(value = "test")
    public CacheObject cacheableTest(String key) {
        ...
    }

!!! note

    In the case that the cache is of the *infinispan* type, it is necessary that the objects to be cached, both key and value, implement the *Serializable* interface.

### Cache configuration

#### Red Hat Data Grid

Caches are configured directly in Red Hat Data Grid. [More information](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16759429988/Red%2BHat%2BData%2BGrid%2BConfiguraci%2Bn)

#### Caffeine

##### Setting the same features for all caches

Caches can be created on startup by setting the *spring.cache.cache-names property* and can be customized by a cache spec defined by *spring.cache.caffeine.spec*

More information on [Spring Boot - Caffeine](https://docs.spring.io/spring-boot/docs/3.3.12/reference/html/io.html#io.caching.provider.caffeine) and more detailed property specifications in
[CaffeineSpec](https://www.javadoc.io/doc/com.github.ben-manes.caffeine/caffeine/3.1.8/com/github/benmanes/caffeine/cache/CaffeineSpec.html)

###### Example

    spring:
      cache:
        caffeine:
          spec: "maximumSize=500,expireAfterAccess=600s"

!!! note

    If the *spring.cache.cache-names* property is not defined then Caffeine will work in **dynamic mode** (if the requested cache does not exist, it is created). In case the *spring.cache.cache-names* property is defined, the
    indicated caches will be created and if a cache that does not exist is requested, the *IllegalArgumentException* exception will be returned.

    In this example if a cache other than cache1 or cache2 is requested an *IllegalArgumentException* exception will be returned

      spring.cache.cache-names=cache1,cache2

##### Setting different features for each cache

Since Spring version 5.2.8 you can set features for each cache, but you have to do it by code.

You have to define a bean of type *CacheManagerCustomizer* and in it register the cache with the desired features. The documentation of the features can be seen in
[Caffeine](https://www.javadoc.io/doc/com.github.ben-manes.caffeine/caffeine/3.1.8/com/github/benmanes/caffeine/cache/Caffeine.html).

!!! note

    In the case of defining the cache properties in both ways: globally and cache-specific, the applied configuration will be cache-specific.

**Example configuration. We configure the "cacheName" cache with a maximum number of elements of 10,000 and an expiration time of 10 minutes.**

    /**
     * Example cache customization for Caffeine
     */
    @Bean
    @ConditionalOnProperty(value = "spring.cache.type", havingValue = "caffeine")
    CacheManagerCustomizer<CaffeineCacheManager> exampleCacheCustomization() {
        return cacheManager -> cacheManager.registerCustomCache("cacheName",
                Caffeine.newBuilder()
                        .expireAfterWrite(10, TimeUnit.MINUTES)
                        .maximumSize(10000)
                        .build());
    }

### How to use Automatic Mode. Use Caffeine and Data Grid at once

The automatic mode allows you to use several cache managers at the same time. To use it, the *darwin.cache.automatic-mode.enabled* property must be enabled.

When this mode is enabled, by default, a cache manager is automatically created for **Data Grid** and another one for **Caffeine**, provided they are in the dependencies.

!!! note

    For both cache managers to be in the dependencies it is necessary to load both cache starters: **darwin-spring-boot-starter-cache-caffeine**, **darwin-spring-boot-starter-cache-infinispan**

The default configuration sets the **darwin.cache.automatic-mode.cache-type-by-priority** property to **\[INFINISPAN, CAFFEINE\]**. With this configuration the operation is as follows: In the first request to the cache, the microservice will ask
Data Grid for the list of caches it contains and from there, if the cache name is defined in Data Grid it will use that one, and if not, it will use the following cache defined, in this case, Caffeine.

| Type       | Description                                                                                                                                                          |
|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| INFINISPAN | Distributed cache Red Hat Data Grid                                                                                                                                  |
| CAFFEINE   | Local cache Caffeine                                                                                                                                                 |
| NONE       | Fake cache. Really don't cache anything. *Automatic-cache* don't load this cache manager it's necessary load it manually                                             |
| SIMPLE     | Simple Local cache implementation. *Automatic-cache* don't load this cache manager it's necessary load it manually                                                   |
| GENERIC    | This cache manager is designed to programmatically configure the caches it supports. *Automatic-cache* don't load this cache manager it's necessary load it manually |

Supported cache types

#### Manually set the caches managed by each cache manager

For each cache type, you can decide whether the name of the caches to be managed is obtained from the cache manager itself (default behavior) or configured manually using the **darwin.cache.automatic-mode.cache-name-by-type.\[CACHE-TYPE\]**
property.

For example, this can be useful to avoid using a cache that is already defined in **Infinispan** and force the **Caffeine** cache to be used. If the **cache1** cache exists in **Infinispan,** and we do not want to use it, it would be enough to define
the cache list manually in the property **darwin.cache.automatic-mode.cache-name-by-type.INFINISPAN** and not to indicate the **cache1** cache.

#### Using caches in dynamic mode

A cache manager in **dynamic** mode, in case it is asked for a cache it does not have, creates it instead of returning an error.

The automatic mode gets the caches from the cache manager itself or from the configuration.
However, in case a cache has not been resolved,
the last cache manager defined in **darwin.cache.automatic-mode.cache-type-by-priority**, by default **Caffeine**,
is prompted to return the wanted cache.
And if this manager is compatible with the dynamic creation mode,
it will create one cache automatically instead of returning a not found exception.

##### How to set the dynamic mode for Caffeine

In **Data Grid** are defined the caches: **test1** and **test2**.

In the microservice the property *spring.cache.cache-names* has not been defined, we are in dynamic mode.

If the **test1** or **test2** cache is requested, a **Data Grid** cache will be returned, any other cache requested will be a local cache of type **Caffeine**.

In **Data Grid** are defined the caches: **test1** and **test2**.

In the microservice the property *spring.cache.cache-names* with value **test3,test4** is defined.

If **test1** or **test2** cache is requested, a Data Grid cache will be returned if **test3** or **test4** is requested,
a **Caffeine** cache will be returned
any other cache requested will return an exception of type ***IllegalArgumentException***.

### How to use DARWIN error handling

In Spring, the default configuration is as described below: If the cache fails at a startup, the application will not be started. Also, if the cache fails to perform an operation, an exception will be returned and the operation will not be
performed.

We have created a specific handler that makes the microservice start up without a cache,
even if the cache is not available when starting the microservice.
Also, in case the cache fails while an operation is being performed, it will be executed even
though the cache is down.

This handler is loaded by default. The architecture allows including another customized by the project if necessary.

### How to use the cache in a reactive application

Since Darwin 5.0.x you can use cache annotations in reactive microservices. This is the way we
we recommend to use the cache. However, you can also use the `DarwinCacheMono` bean provided by Darwin.

If we are using **Caffeine**, it is necessary that the caches created are of the asynchronous type. By default, the
caches are created of synchronous type. That is why we have added the following property `darwin.cache.caffeine.async'.
This property allows Caffeine caches to be created in asynchronous mode by default.

If we are using **Datagrid**, it is necessary to set to `true` the property `infinispan.remote.reactive` in order to
get reactive support with **Datagrid**.

The darwinCacheMono service is available for use. Example of its use:

    @Autowired
    private DarwinCacheMono darwinCacheMono;
    ...
    darwinCacheMono.cache("cacheName","cacheKey", monoObjectToBeCached)

In case that the cache has not been activated or it is of "none" type, the service will remain available, but it will
work simply by returning the object to be cached, without doing anything else.

#### DarwinCacheMono with automatic mode enabled

If the automatic mode is active, DarwinCacheMono in the first call to the *cache* method will get from Data Grid the list of caches it has defined. From there, if the *cacheName* exists in Data Grid it will be cached in Spring and otherwise it will
be cached in Caffeine.
