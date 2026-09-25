# Darwin-spring-boot-cache Migration guides

## Version 6.0.0

<!tag:600>

As we informed in version 5.1.0, we have reimplemented the `DarwinCacheMono` class to use the new `retrieve` method from Spring Boot 3.1.0.

Therefore, the `CacheReader` and `CacheWriter` classes have been removed in this version, and the visibility of the `DarwinCacheMonoImpl` class has been modified, making it no longer usable.

If you were using the `DarwinCacheMonoImpl` class, you can:

- Please implement your own class that implements the `DarwinCacheMono` interface.
- Remember that the implementation of the `DarwinCacheMono` interface provided by the Darwin cache work with Caffeine and Infinispan if the async mode is activated. This is done automatically by the Darwin cache.

<!end:600>

## Version 5.1.0

<!tag:510>

We are using *CacheReader* and *CacheWriter* to allow use cache in a reactive way using *DarwinCacheMono* class.

The current implementation of *DarwinCacheMono* is based on *CacheMono* class from *reactor-core* library.
This class has been marked as *deprecated* in version 3.4.0 and will be removed in 3.6.0.

Since Spring Boot 3.1.0 Spring Cache abstraction has an async method *retrieve* that allows retrieving a value from
the cache asynchronously.

We are going to reimplement *DarwinCacheMono* implementation to use this new method in Spring Boot Darwin 6.0.0.

This is why *CacheReader* and *CacheWriter* have been marked as *deprecated* and will be removed in version 6.0.0.

<!end:510>

## Version 3.2.0-RELEASE

<!tag:320>

- Interface DarwinCacheMono moved to core module:

| Old                                                | New                                             |
|----------------------------------------------------|-------------------------------------------------|
| com.santander.darwin.cache.service.DarwinCacheMono | com.santander.darwin.core.cache.DarwinCacheMono |

- Deleted method empty in DarwinCacheMonoImpl. Use DarwinCacheMonoEmptyImpl public constructor instead.

<!end:320>
