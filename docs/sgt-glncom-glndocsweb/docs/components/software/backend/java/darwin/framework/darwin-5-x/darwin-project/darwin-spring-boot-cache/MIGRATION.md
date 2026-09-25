# Darwin-spring-boot-cache Migration guides

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
