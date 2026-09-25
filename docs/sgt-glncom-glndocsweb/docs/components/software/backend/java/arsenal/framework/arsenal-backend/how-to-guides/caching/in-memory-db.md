# Arsenal In-Memory DB

## What is an In-Memory Database?

An in-memory database stores data in the main memory (RAM) rather than on disk storage. This allows for faster data access and
manipulation, making it ideal for caching and session management. In-memory databases are known for their high performance and low latency.

## Good Practices

- The in-memory database should not cause the application to crash. If the in-memory database is unavailable, the application should continue to run.
- It should not be used as a primary data store but rather for caching and storing short-lived information for quick access.
- Use mechanisms to manage the health and availability of the in-memory database.
- For resilience, consider using a master-slave model where data is stored in the master and read from the slaves. If the master fails, a slave can take over.

## Library Purpose

The overall goal of this library is to provide an easy and secure way to interact with an in-memory database in an Arsenal application, abstracting the low-level details of connection and operations.

## Problem Statement

Direct interaction with in-memory databases can be complex and error-prone. This library was created to simplify this interaction by providing a high-level API that abstracts away many of the low-level details.

## Proposed Solution

The proposed solution is a library that facilitates interaction with an in-memory database in a Spring Boot application (Arsenal/Darwin). The library is made up of two main classes: **InMemoryDBConfig** and **InMemoryDBService**.

- **InMemoryDBConfig**: Responsible for configuring the connection to the in-memory database. It reads the settings from the `application.yml` file and creates a connection factory and a template for data operations.
- **InMemoryDBService**: Provides a high-level API for interacting with the in-memory database. It uses the template to perform CRUD operations and check whether a key exists and is expired. Additionally, it provides methods for updating the
value of a key with or without an expiration time.

## Requirements

- Java 17
- Maven
- Spring Data

## Implementation

### Dependency

By default, our starter is already embedded in the new Arsenal3 and Gluon projects. But if you are interested in inserting it into an individual project, you can do so by inserting the starter dependency:

```xml
<dependency>
  <groupId>com.santander.ars</groupId>
  <artifactId>gln-back-arsenal-backend-lib-in-memory-db-connector</artifactId>
</dependency>
```

### How to Configure

Connection settings such as host, port, and pool settings are read from the `application.yml` file.

```yaml
arsenal:
  in-memory:
    enabled: ${IN_MEMORY_ENABLE:true}
    server-type: ${IN_MEMORY_SERVER_TYPE:standalone}
    sentinel-master: ${IN_MEMORY_MASTER:}
    host: ${IN_MEMORY_HOST:standalone.host}
    port: ${IN_MEMORY_PORT:6379}
    pass: ${IN_MEMORY_PASS:/path/to/secret/password}
    user: ${IN_MEMORY_USER:/path/to/secret/user}
    lettuce:
      pool:
        max-active: ${IN_MEMORY_MAX_ACTIVE:100}
        max-idle: ${IN_MEMORY_MAX_IDLE:2}
        min-idle: ${IN_MEMORY_MIN_IDLE:1}
        set-test-on-borrow: ${IN_MEMORY_TEST_BORROW:true}
        set-test-on-return: ${IN_MEMORY_TEST_RETURN:true}
        set-test-while-idle: ${IN_MEMORY_TEST_WHILE_IDLE:true}
      client:
        options:
          command-timeout: ${IN_MEMORY_COMMAND_TIMEOUT:1000}
          shutdown-timeout: ${IN_MEMORY_SHUTDOWN_TIMEOUT:1000}
          disconnected-behavior: ${IN_MEMORY_DISCONNECTED_BEHAVIOR:REJECT_COMMANDS}
          auto-reconnect: ${IN_MEMORY_AUTO_RECONNECT:true}
          use-ssl: ${IN_MEMORY_USE_SSL:false}
        resources:
          io-thread-pool-size: ${IN_MEMORY_IO_THREAD_POOL_SIZE:4}
          computation-thread-pool-size: ${IN_MEMORY_COMPUTATION_THREAD_POOL_SIZE:4}
```

## Example Usage of the InMemoryDBService

This is a simple example of using `InMemoryDBService` in a Spring Boot application. It demonstrates how to create, update, get, and delete key-value pairs in the in-memory database. Note that this example is for demonstration purposes only and
should not be used in an official project.

```java
import com.santander.ars.inmemorydbconnector.service.InMemoryDBOperationException;
import com.santander.ars.inmemorydbconnector.service.InMemoryDBService;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * WARNING: This is a simple example for demonstration purposes only.
 * Do not use this code in an official project.
 */

@RestController
@RequestMapping("/inmemoryexample")
public class InMemoryController {

    private final InMemoryDBService inMemoryDBService;
    private long timeout = 2000L;

    public InMemoryController(InMemoryDBService inMemoryDBService) {
        this.inMemoryDBService = inMemoryDBService;
    }

    @PostMapping("/create")
    public ResponseEntity<String> create(@RequestParam String key, @RequestParam Object value) {
        try {
            boolean result = inMemoryDBService.create(key, value, timeout, TimeUnit.MILLISECONDS);
            return ResponseEntity.ok(result ? "Created" : "Key already exists");
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @PutMapping("/update")
    public ResponseEntity<String> update(@RequestParam String key, @RequestParam Object value) {
        try {
            boolean result = inMemoryDBService.update(key, value, timeout, TimeUnit.MILLISECONDS);
            return ResponseEntity.ok(result ? "Updated" : "Failed to update");
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @PutMapping("/expireKey")
    public ResponseEntity<String> expireKey(@RequestParam String key, @RequestParam long timeout, @RequestParam TimeUnit unit) {
        try {
            boolean result = inMemoryDBService.expireKey(key, timeout, unit);
            return ResponseEntity.ok(result ? "Key expired" : "Failed to expire key");
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @PutMapping("/updateIfExpired")
    public ResponseEntity<String> updateIfExpired(@RequestParam String key, @RequestParam Object value) {
        try {
            boolean result = inMemoryDBService.updateIfExpired(key, value);
            return ResponseEntity.ok(result ? "Updated if expired" : "Key not expired");
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @GetMapping("/get")
    public ResponseEntity<Object> get(@RequestParam String key) {
        try {
            Optional<Object> result = inMemoryDBService.get(key);
            return result.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.status(404).body("Key not found"));
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> delete(@RequestParam String key) {
        try {
            boolean result = inMemoryDBService.delete(key);
            return ResponseEntity.ok(result ? "Deleted" : "Key not found");
        } catch (InMemoryDBOperationException e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }
}
```

## Step-by-Step Guide to Configure the Library

1. **Add Dependency in `pom.xml`**:
   Add the library dependency to your `pom.xml` file.

   ```xml
   <dependency>
     <groupId>com.santander.ars</groupId>
     <artifactId>gln-back-arsenal-backend-lib-in-memory-db-connector</artifactId>
   </dependency>
   ```

2. **Configure `application.yml`**:
   Configure the connection properties in the `application.yml` file.

   ```yaml
   arsenal:
     in-memory:
       enabled: ${IN_MEMORY_ENABLE:true}
       server-type: ${IN_MEMORY_SERVER_TYPE:standalone}
       sentinel-master: ${IN_MEMORY_MASTER:}
       host: ${IN_MEMORY_HOST:standalone.host}
       port: ${IN_MEMORY_PORT:6379}
       pass: ${IN_MEMORY_PASS:/path/to/secret/password}
       user: ${IN_MEMORY_USER:/path/to/secret/user}
       lettuce:
         pool:
           max-active: ${IN_MEMORY_MAX_ACTIVE:100}
           max-idle: ${IN_MEMORY_MAX_IDLE:2}
           min-idle: ${IN_MEMORY_MIN_IDLE:1}
           set-test-on-borrow: ${IN_MEMORY_TEST_BORROW:true}
           set-test-on-return: ${IN_MEMORY_TEST_RETURN:true}
           set-test-while-idle: ${IN_MEMORY_TEST_WHILE_IDLE:true}
         client:
           options:
             command-timeout: ${IN_MEMORY_COMMAND_TIMEOUT:1000}
             shutdown-timeout: ${IN_MEMORY_SHUTDOWN_TIMEOUT:1000}
             disconnected-behavior: ${IN_MEMORY_DISCONNECTED_BEHAVIOR:REJECT_COMMANDS}
             auto-reconnect: ${IN_MEMORY_AUTO_RECONNECT:true}
             use-ssl: ${IN_MEMORY_USE_SSL:false}
           resources:
             io-thread-pool-size: ${IN_MEMORY_IO_THREAD_POOL_SIZE:4}
             computation-thread-pool-size: ${IN_MEMORY_COMPUTATION_THREAD_POOL_SIZE:4}
   ```

3. **Create a Class to Use the Cache**:
   Create a service class to interact with the cache.

   ```java
   import org.springframework.stereotype.Service;
   import java.util.Optional;
   import java.util.concurrent.TimeUnit;

   @Service
   public class CacheService {

     private final InMemoryDBService inMemoryDBService;

     public CacheService(InMemoryDBService inMemoryDBService) {
       this.inMemoryDBService = inMemoryDBService;
     }

     public void createCacheEntry(String key, Object value) {
       inMemoryDBService.create(key, value, 10, TimeUnit.MINUTES);
     }

     public Optional<Object> getCacheEntry(String key) {
       return inMemoryDBService.get(key);
     }

     public void updateCacheEntry(String key, Object value) {
       inMemoryDBService.update(key, value);
     }

     public void deleteCacheEntry(String key) {
       inMemoryDBService.delete(key);
     }
   }
   ```

4. **Disable the Cache**:
   To disable the cache, set the `enabled` property to `false` in the `application.yml`.

   ```yaml
   spring:
     autoconfigure:
       exclude:
         - org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration
         - org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration

   arsenal:
     in-memory:
       enabled: false
   ```

Here is a detailed application.yml configuration for the InMemoryDBConfig class:

The `application.yml` file is used to configure the connection to the in-memory database. The configuration settings include the server type, host, port, authentication credentials, and connection pool settings. The `InMemoryDBConfig` class reads
these settings from the `application.yml` file and creates a connection factory and template for data operations. The following is a detailed explanation of the configuration settings of all the types of in-memory databases (standalone,
sentinel, and cluster) supported by the `InMemoryDBConfig` class.:

**Standalone**: This is the simplest configuration, where you have only one instance running. All read and write operations are done on this single instance. While it's simple to set up and manage, this configuration doesn't offer high availability
or scalability.

```yml
arsenal:
  in-memory:
    enabled: ${IN_MEMORY_ENABLE:true}
    server-type: ${IN_MEMORY_SERVER_TYPE:standalone}
    sentinel-master: ${IN_MEMORY_MASTER:}
    host: ${IN_MEMORY_HOST:standalone.host}
    port: ${IN_MEMORY_PORT:6379}
    pass: ${IN_MEMORY_PASS:/path/to/secret/password}
    user: ${IN_MEMORY_USER:/path/to/secret/user}
    lettuce:
      pool:
        max-active: ${IN_MEMORY_MAX_ACTIVE:100}
        max-idle: ${IN_MEMORY_MAX_IDLE:2}
        min-idle: ${IN_MEMORY_MIN_IDLE:1}
        set-test-on-borrow: ${IN_MEMORY_TEST_BORROW:true}
        set-test-on-return: ${IN_MEMORY_TEST_RETURN:true}
        set-test-while-idle: ${IN_MEMORY_TEST_WHILE_IDLE:true}
      client:
        options:
          command-timeout: ${IN_MEMORY_COMMAND_TIMEOUT:1000}
          shutdown-timeout: ${IN_MEMORY_SHUTDOWN_TIMEOUT:1000}
          disconnected-behavior: ${IN_MEMORY_DISCONNECTED_BEHAVIOR:REJECT_COMMANDS}
          auto-reconnect: ${IN_MEMORY_AUTO_RECONNECT:true}
          use-ssl: ${IN_MEMORY_USE_SSL:false}
        resources:
          io-thread-pool-size: ${IN_MEMORY_IO_THREAD_POOL_SIZE:4}
          computation-thread-pool-size: ${IN_MEMORY_COMPUTATION_THREAD_POOL_SIZE:4}
```

**Sentinel**: Sentinel is a configuration that offers high availability. It uses a monitoring system that keeps track of your instances. If an instance fails, Sentinel can automatically switch to a backup instance. Sentinel also provides other features
like notifications when an instance is down and automatic configuration services for its clients.

```yml
arsenal:
  in-memory:
    enabled: ${IN_MEMORY_ENABLE:true}
    server-type: ${IN_MEMORY_SERVER_TYPE:sentinel}
    sentinel-master: ${IN_MEMORY_MASTER:MyMaster}
    host: ${IN_MEMORY_HOST:sentinel.host}
    port: ${IN_MEMORY_PORT:26385}
    pass: ${IN_MEMORY_PASS:/path/to/secret/password}
    user: ${IN_MEMORY_USER:/path/to/secret/user}
    lettuce:
      pool:
        max-active: ${IN_MEMORY_MAX_ACTIVE:100}
        max-idle: ${IN_MEMORY_MAX_IDLE:2}
        min-idle: ${IN_MEMORY_MIN_IDLE:1}
        set-test-on-borrow: ${IN_MEMORY_TEST_BORROW:true}
        set-test-on-return: ${IN_MEMORY_TEST_RETURN:true}
        set-test-while-idle: ${IN_MEMORY_TEST_WHILE_IDLE:true}
      client:
        options:
          command-timeout: ${IN_MEMORY_COMMAND_TIMEOUT:1000}
          shutdown-timeout: ${IN_MEMORY_SHUTDOWN_TIMEOUT:1000}
          disconnected-behavior: ${IN_MEMORY_DISCONNECTED_BEHAVIOR:REJECT_COMMANDS}
          auto-reconnect: ${IN_MEMORY_AUTO_RECONNECT:true}
          use-ssl: ${IN_MEMORY_USE_SSL:false}
        resources:
          io-thread-pool-size: ${IN_MEMORY_IO_THREAD_POOL_SIZE:4}
          computation-thread-pool-size: ${IN_MEMORY_COMPUTATION_THREAD_POOL_SIZE:4}
```

**Cluster**: Cluster is a configuration that offers both high availability and scalability. It allows you to distribute your data across multiple instances, which can significantly improve read and write performance. Cluster also supports data
replication, meaning your data is copied across multiple instances to prevent data loss in case of a failure.

```yml
arsenal:
  in-memory:
    enabled: ${IN_MEMORY_ENABLE:true}
    server-type: ${IN_MEMORY_SERVER_TYPE:cluster}
    sentinel-master: ${IN_MEMORY_MASTER:}
    host: ${IN_MEMORY_HOST:cluster.host}
    port: ${IN_MEMORY_PORT:6379}
    pass: ${IN_MEMORY_PASS:/path/to/secret/password}
    user: ${IN_MEMORY_USER:/path/to/secret/user}
    lettuce:
      pool:
        max-active: ${IN_MEMORY_MAX_ACTIVE:100}
        max-idle: ${IN_MEMORY_MAX_IDLE:2}
        min-idle: ${IN_MEMORY_MIN_IDLE:1}
        set-test-on-borrow: ${IN_MEMORY_TEST_BORROW:true}
        set-test-on-return: ${IN_MEMORY_TEST_RETURN:true}
        set-test-while-idle: ${IN_MEMORY_TEST_WHILE_IDLE:true}
      client:
        options:
          command-timeout: ${IN_MEMORY_COMMAND_TIMEOUT:1000}
          shutdown-timeout: ${IN_MEMORY_SHUTDOWN_TIMEOUT:1000}
          disconnected-behavior: ${IN_MEMORY_DISCONNECTED_BEHAVIOR:REJECT_COMMANDS}
          auto-reconnect: ${IN_MEMORY_AUTO_RECONNECT:true}
          use-ssl: ${IN_MEMORY_USE_SSL:true}
        resources:
          io-thread-pool-size: ${IN_MEMORY_IO_THREAD_POOL_SIZE:4}
          computation-thread-pool-size: ${IN_MEMORY_COMPUTATION_THREAD_POOL_SIZE:4}
```

In summary, the Standalone configuration is suitable for smaller applications with less stringent availability and scalability requirements. The Sentinel and Cluster configurations are more suitable for larger applications that require high availability
and the ability to handle large volumes of data.

The choice between Sentinel and Cluster:

If your application requires high availability but does not need to store large amounts of data, Sentinel may be sufficient. If your application needs to store large amounts of data and requires high availability, Cluster would be a better choice.

Here is a detailed explanation of each method of the InMemoryDBService class:

| **Method**                                                               | **Description**                                                                                         | **Returns**                                                                 |
|--------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| `create(String key, Object value)`                                       | Creates a new key-value pair with a default timeout of 600 seconds.                                     | `boolean` indicating success or failure.                                    |
| `create(String key, Object value, long timeout, TimeUnit unit)`          | Creates a new key-value pair with a specified timeout.                                                  | `boolean` indicating success or failure.                                    |
| `update(String key, Object value)`                                       | Updates the value of an existing key without changing its timeout.                                      | `boolean` indicating success or failure.                                    |
| `update(String key, Object value, long timeout, TimeUnit unit)`          | Updates the value of an existing key and sets a new timeout.                                            | `boolean` indicating success or failure.                                    |
| `updateIfExpired(String key, Object value)`                              | Updates the value of an existing key if its timeout has expired, with a default timeout of 600 seconds. | `boolean` indicating success or failure.                                    |
| `updateIfExpired(String key, Object value, long timeout, TimeUnit unit)` | Updates the value of an existing key if its timeout has expired, with a specified timeout.              | `boolean` indicating success or failure.                                    |
| `get(String key)`                                                        | Retrieves the value of a key.                                                                           | `Optional<Object>` containing the value or empty if the key does not exist. |
| `expireKey(String key, long timeout, TimeUnit unit)`                     | Sets a timeout on a key.                                                                                | `boolean` indicating success or failure.                                    |
| `delete(String key)`                                                     | Deletes a key-value pair.                                                                               | `boolean` indicating success or failure.                                    |

In summary, the `create` method is used to create a new key-value pair with an optional timeout. The `update` method is used to update the value of an existing key with an optional timeout. The `updateIfExpired` method updates the value of an existing
key only if its timeout has expired. The `get` method retrieves the value of a key. The `expireKey` method sets a timeout on a key. The `delete` method deletes a key-value pair.

Here is a detailed application.yml configuration for the InMemoryDBConfig class:

| **Field**                                            | **Description**                                                       | **Field Type** | **Default**                  |
|------------------------------------------------------|-----------------------------------------------------------------------|----------------|------------------------------|
| `enabled`                                            | Enables or disables the use of the in-memory database                 | Boolean        | false                        |
| `server-type`                                        | Type of in-memory database server (standalone, sentinel, cluster)     | String         | none                         |
| `sentinel-master`                                    | Name of the master in sentinel mode                                   | String         | mymaster                     |
| `host`                                               | Host of the in-memory database server                                 | String         | localhost                    |
| `port`                                               | Port of the in-memory database server                                 | Integer        | 6379                         |
| `pass`                                               | Path to the password file                                             | String         | (empty)                      |
| `user`                                               | Path to the user file                                                 | String         | (empty)                      |
| `lettuce.pool.max-active`                            | Maximum number of active connections in the pool                      | Integer        | 50                           |
| `lettuce.pool.max-idle`                              | Maximum number of idle connections in the pool                        | Integer        | 2                            |
| `lettuce.pool.min-idle`                              | Minimum number of idle connections in the pool                        | Integer        | 1                            |
| `lettuce.pool.set-test-on-borrow`                    | Tests the connection when borrowing from the pool                     | Boolean        | true                         |
| `lettuce.pool.set-test-on-return`                    | Tests the connection when returning to the pool                       | Boolean        | true                         |
| `lettuce.pool.set-test-while-idle`                   | Tests the connection while idle                                       | Boolean        | true                         |
| `lettuce.client.options.command-timeout`             | Command timeout in milliseconds                                       | Integer        | 1000                         |
| `lettuce.client.options.shutdown-timeout`            | Shutdown timeout in milliseconds                                      | Integer        | 1000                         |
| `lettuce.client.options.disconnected-behavior`       | Behavior when disconnected (REJECT_COMMANDS, ACCEPT_COMMANDS)         | String         | REJECT_COMMANDS              |
| `lettuce.client.options.auto-reconnect`              | Enables automatic reconnection                                        | Boolean        | true                         |
| `lettuce.client.options.use-ssl`                     | Uses SSL for connection                                               | Boolean        | true                         |
| `lettuce.resources.io-thread-pool-size`              | Size of the I/O thread pool                                           | Integer        | 4                            |
| `lettuce.resources.computation-thread-pool-size`     | Size of the computation thread pool                                   | Integer        | 4                            |

In summary, the `enabled` field is used to enable or disable the use of the in-memory database. The `server-type` field specifies the type of in-memory database server to use (standalone, sentinel, or cluster). The `host` and `port` fields
specify the host and port of the in-memory database server. The `pass` and `user` fields specify the paths to the password and
user files, respectively. The `lettuce.pool` and `lettuce.client` fields specify the connection pool and client options, respectively. The `lettuce.resources` field specifies the I/O and computation thread pool sizes.
