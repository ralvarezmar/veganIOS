# Change Log

## Version 5.4.0

<!tag:540>

- Don't set infinispan protocolo version to 2.9. Allow client to select default version.
- Fix issue using `SCRAM-SHA-512` protocol to authenticate in Datagrid in native mode.

<!end:540>

## Version 5.2.0

<!tag:520>

- Add support to reactive mode for Datagrid caches.
- Document third party libraries with tentative support for native compilation.

<!end:520>

## Version 5.1.0

<!tag:510>

- Enhanced documentation for native compilation support
- Add new property `darwin.cache.caffeine.async` for automatic creation of Caffeine caches in asynchronous mode to
simplify use of Cache annotations in reactive microservices.
- Deprecated *CacheReader* and *CacheWriter*.  

<!end:510>

## Version 5.0.0

<!tag:500>

- Fix the creation of the BaseConfig bean to prevent it from being created prematurely..

<!end:500>

## Version 4.3.2-RELEASE

<!tag:432>

- Fix AutomaticModeCacheResolver by adding a synchronizedMap for the safe use of multiple concurrent thread.

<!end:432>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.

<!end:420>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- Update `infinispan-spring-boot-starter-remote` dependency to last version supported by RedHat.

<!end:400>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize authentication dependencies.

- Optimize dependencies:

    - `spring-context-support` now is a transient dependency.

    - `infinispan-jboss-marshalling` now isn't a transient dependency.

- Generalize Circuit Breaker.

- Generalize dual cache to automatic cache.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Update Java client to RHDG 8.3 version.

- A Circuit Breaker is added to DataGrid cache calls to avoid unnecessary remote cache calls:

- Change the way we manage Circuit Breaker and Retry objects to avoid issue creating these objects.

- The default configuration of 10 connection retries to Datagrid is set again (instead of none as it is now), and the information related to the technical timeouts and the configuration of the number of retries is eliminated since it is
    recommended to keep the default ones.

<!end:310>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Update the metadata files with all defined properties and those that have been deprecated.

- Change deprecated methods.

    - Use !StringUtils.hasLength() instead of StringUtils.isEmpty()

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor.

    - Removing the use of deprecated elastic() function from Schedulers class. Now, boundedElastic() function is used instead.

<!end:300>

## 2.11.0-RELEASE Version

<!tag:2110>

- Added compatibility with version 8.x of RHDG.

- Automatic cache mode. Allows a microservice to cache simultaneously both local (Caffeine) and distributed (Data Grid).

- Add to readme how to configure different properties per cache in Caffeine.

<!end:2110>

## 2.9.0-RELEASE Version

<!tag:290>

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

- Configuration ProxyBeanMethod set to 'false' in DarwinCacheAutoConfiguration class and DarwinCacheDefaultAutoConfiguration class.

<!end:290>

## 2.3.3-RELEASE Version

<!tag:233>

- Beans used for cache metrics will not be loaded if infinispan is used. They have been removed because in case of a connection failure with the cache they prevent the application from starting.

- In order to avoid read or write locks, DarwinCacheMono bean has been modified.

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- Infinispan client updated to version 9.4.15.Final-redhat-00001

- The use of login user has been enabled by default. The darwin.cache.infinispan.use-auth parameter has true as value.

<!end:232>

## 2.3.0-RELEASE Version

<!tag:230>

- Include a new service to be able to cache Mono objects in reactive web applications

<!end:230>

## 2.1.2-RELEASE Version

<!tag:212>

- SpringRemoteCacheManager bean override bug is fixed.

- Dependency on the Spring test starter removed.

- CacheMetrics bean loading excluded. (incompatible with JDG 7.1)

- Error handler has been modified to include the complete error trace.

- use-auth parameter equivalent to the one defined by error use\_auth, added.

<!end:212>

## 2.0.2-RELEASE Version

<!tag:202>

- Default timeouts updated.

- Retries number set to 0 by default.

- Custom error handler is included by default.

- Custom cache resolver is included by default.

- Test have been reviewed and improved

- Control included in the `CachingConfigurerNoFatalErrors` class to prevent it from loading when there is no `CacheManager` available.

<!end:202>

## 2.0.1-RELEASE Version

<!tag:201>

- Cache library has been created

- Infinispan library version updated to 8.5.3.Final-redhat-00002

- Fault-tolerant error handler added

- Read and write timeouts included

<!end:201>
