# Change Log

## Version 6.2.0

<!tag:620>

### ⭐ New Features

- Add `OBD` and `PUB` channels to omnichannel library.

<!end:620>

## Version 6.1.1

<!tag:611>

### 🐞 Bug Fixes

- Avoid unnecessary http headers validations in omnichannel module filters.

<!end:611>

## Version 6.0.3

<!tag:603>

### 🐞 Bug Fixes

- Ignore unknown properties in the contact point header. That allows receive `navigator` field

<!end:603>

## Version 5.2.0

<!tag:520>

- Document third party libraries with tentative support for native compilation.

<!end:520>

## Version 4.3.2-RELEASE

<!tag:432>

- Fix a bug with Reactive Omnichannel interceptor that was added twice when a WebClient bean was created
  from a Spring WebClient.Builder bean.

<!end:432>

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.
- Add compilation hints support for native image.
- Change configuration class to support for native image.
- Also using claim "channel_tp" from token to get channel.
- Fix RestTemplate/WebClient BeanPostProcessor creation to avoid creating CoreProperties early.
- Unify the Darwin Interceptors creation to improve the performance.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:410>

- Now User-Agent parsing is optional in Omnichannel.
  - "nl.basjes.parse.useragent:yauaa" dependency is now **optional**.
  - ContactPoint is not populated with User-Agent info by default.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- Add Yauaa dependency.

<!end:400>

## 3.2.2-RELEASE Version

<!tag:322>

- Move ContactPointUtils from core module and initialize early to avoid delays in first request

<!end:322>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize dependencies.

- Now Darwin Core can enable/disable the propagation headers.

<!end:320>

## 3.1.0-RELEASE Version

<!tag:310>

- Adding new fields in activity pattern and technical pattern.

    - Solving a bug using `contactPoint` BaggageField with manual instrumentation of Sleuth. Now, in the reactive filter, the TraceContext is retrieved from Reactor Context and it is used for updating the BaggageField.

- Avoid creating ContactPoint twice with Async Servlet requests

<!end:310>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Delete deprecated methods.

    - The deprecated "**getContactPoint**" method of *DarwinUserDetails* has been removed.

    - Deleted deprecate functionality to get ContactPoint object from *RequestContextHolder*.

    - The deprecated *ContactPointHelper* class has been removed.

- Update the metadata files with all defined properties and those that have been deprecated.

- Reduce NotWeb configuration modes:

    - **Remove RestTemplate/WebClient's ConditionalOnClass** from configuration.

    - **Remove httpClient dependency** and **move spring-webflux to transient (non-optional) dependencies**.

- Fixed bug that causes Yauaa module load multiple times.

- Dependencies and plugins upgrade:

    - Simplifying configuration. Instead of using `BeanFactory` to obtain ***OmniChannelProperties***, now it is injected as a dependency of the configuration.

- Remove unused dependency: `darwin-spring-boot-logging`. Use `io.zipkin.brave:brave` dependency instead of `darwin-spring-boot-logging`

- Replace deprecated StringUtils#isEmpty() method with !StringUtils#hasLength()

- Translation of the README.adoc file from Spanish to English.

- Remove in all parts of the FW the property allow-bean-definition-overriding

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor for tests.

<!end:300>

## 2.11.4-RELEASE Version

<!tag:2114>

- Fixed bug that causes **ContactPoint object from RequestContextHolder** not being completely filled.

<!end:2114>

## 2.11.2-RELEASE Version

<!tag:2112>

- Fixed bug that causes Yauaa module load multiple times.

<!end:2112>

## 2.11.0-RELEASE Version

<!tag:2110>

- RCA channel added as default configuration. RCA entry added to initialdata.json

- The `Contact-Point` header now is filling and propagated at this module.

<!end:2110>

## 2.9.0-RELEASE Version

<!tag:290>

- Now, projects can modify the initial channel load using the new darwinchannels.json file.

- We added support to define the properties of the new channels with CamelCase and KebabCase notation.

- The `OmniChannelReactiveFilterFunction` and `OmniChannelConfigBeanPostProcessor` classes have been removed as this functionality now is part of the **darwin-spring-boot-core** module.

- New functionality has been added to make it possible to configure channels by entity.

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

<!end:290>

## 2.8.0-RELEASE Version

<!tag:280>

- **ExternalChannelConfig** class visibility will no longer be public.

<!end:280>

## 2.6.0-RELEASE Version

<!tag:260>

- The different library functionalities have been made conditional depending on the application type. This allows the efficient use of not-web applications.

<!end:260>

## 2.3.3-RELEASE Version

<!tag:233>

- The 'physicalChannel' code associated with the 'PLR' channel has been modified. Now it has the value of '0060'.

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- Fixed a bug whereby channels were not allowed to be overwritten.

- A bug in WebFilter chain (OmniChannelReactiveFilter) whereby the existence of the DarwinContext in the reactive context was not checked for its modification, has been fixed.

<!end:232>

## 2.3.0-RELEASE Version

<!tag:230>

- The DarwinContextHolder has been added in order to save the channel information in it in parallel to the RequestContextHolder (for now).

- As of this release, it will no longer be necessary to mark the WebClient and WebClient.Builder beans with the @DarwinQualifier annotation. At application startup, all WebClient and WebClient.Builder beans type will be detected, and the
    OmniChannelFilterFunction interceptor will be injected. This will be the default behavior, and you can disable it through the darwin.core.webclient.enabled = false property.

- The ContactPointHelper class has been deprecated.

<!end:230>

## 2.2.0-RELEASE Version

<!tag:220>

- The bug whereby OmniChannelFilterFunction was not being injected in @Darwin WebClient.Builder, has been fixed.

<!end:220>

## 2.1.0-RELEASE Version

<!tag:210>

- A filterFunction bean type (OmniChannelFilterFunction) has been created to be automatically included in the requests made with Darwin's WebClient bean.

<!end:210>
