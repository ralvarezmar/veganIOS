# Darwin-spring-boot-cache Migration guides

## Version 3.2.0-RELEASE

<!tag:320>

- Interface DarwinCacheMono moved to core module:

| Old                                                | New                                             |
|----------------------------------------------------|-------------------------------------------------|
| com.santander.darwin.cache.service.DarwinCacheMono | com.santander.darwin.core.cache.DarwinCacheMono |

- Deleted method empty in DarwinCacheMonoImpl. Use DarwinCacheMonoEmptyImpl public constructor instead.

<!end:320>
