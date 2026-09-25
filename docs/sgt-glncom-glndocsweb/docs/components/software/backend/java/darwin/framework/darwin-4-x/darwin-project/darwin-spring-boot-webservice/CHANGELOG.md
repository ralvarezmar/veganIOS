# Change Log

## Version 4.2.0-RELEASE

<!tag:420>

- Amend pom.xml to verify module in native mode.

- <!end:420>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

<!end:400>

## 3.2.0-RELEASE Version

<!tag:320>

- Optimize Logging dependencies. Exclude **spring-boot-starter-logging** dependency.

<!end:320>

## 3.0.0-RELEASE Version

<!tag:300>

- Packages refactoring from `es.santander.darwin` to `com.santander.darwin`.

- Translate to english.

- `MarcoChannelsBean`, `ResourcesBean` and `SoapConstants` moved from Common library.

- Update NotWebWithHttpClient references to `NotWeb`.

- Update the metadata files with all defined properties and those that have been deprecated.

- Update DarwinWSRequestHelper and BankSphereTokenWebInterceptor with new TokenService implementations (prev. (Reactive)TokenConverter)

- Remove in all parts of the FW the property allow-bean-definition-overriding

- Using @ConditionalOnMissingBean in @Bean's that they could be overwritten.

- Using new API of Reactor.

    - Deleting use of doOnError(error) operator and onErrorResume(error) operator to throw new exceptions. OnErrorMap is used instead.

<!end:300>

## 2.9.0-RELEASE Version

<!tag:290>

- README.adoc and changelog.md update. From now on, all references to links mentioned in documentation files, should be declared in attributes.adoc file.

<!end:290>

## 2.6.0-RELEASE Version

<!tag:260>

- Support for not-web applications: The auto-configuration is modified so that if it is a **Not-Web application**, both solutions beans (Servlet and Reactive) will be loaded.

- Servlet solution interceptors will be created only if required.

<!end:260>

## 2.5.0-RELEASE Version

<!tag:250>

- A crash has been avoided in DarwinWSRequestHelper with JAXBContext.newInstance method.

<!end:250>

## 2.4.3-RELEASE Version

<!tag:243>

- The library has been forced to be configured after the corresponding configuration of the Authentication library (although due to dependencies they already had that order)

<!end:243>

## 2.4.2-RELEASE Version

<!tag:242>

- The bug whereby prevented the injection of the WebServiceEndPointSelector has been fixed.

<!end:242>

## 2.4.0-RELEASE Version

<!tag:240>

- The first version of the WebService library for Reactive environments with WebClient has been created:

    - The root name of the library package has been refactored, now, instead of `es.santander.darwin.interceptor` it is `es.santander.darwin.ws`.

    - Two auto-configurations and properties have been defined according to the Web execution environment: Servlet or Reactive.

    - The DarwinWSRequestHelper class is defined to encode **XML objects** as SOAP messages for requests with WebClient.

    - A partially built DarwinWSRequestHelperBuilder bean has been created with the configuration defined by the project.

    - The possibility to configure different URLs for the Web Services according to the client and the channel, has been added for the projects.

- The `EndpointSelectorService` class has been renamed to `WebEndpointSelectorService`.

<!end:240>

## 2.3.3-RELEASE Version

<!tag:233>

- When starting the microservices with java 11 runtime, the jaxws-api dependency has been added to fix a bug.

<!end:233>

## 2.3.2-RELEASE Version

<!tag:232>

- The authentication starter dependency has been added.

- A problem whereby a reactive microservice does not start when incorporating the webservice library, has been fixed.

<!end:232>

## 2.2.0-RELEASE Version

<!tag:220>

- A bug related to the documentation has been fixed.

<!end:220>

## 2.1.3-RELEASE Version

<!tag:213>

- The org.apache.ws.security:wss4j dependency has been removed.

<!end:213>

## 2.0.2-RELEASE Version

<!tag:202>

- The currently existing dependency between `darwin-spring-boot-webservice` and `darwin-spring-boot-authentication` has been removed.

<!end:202>

## 2.0.0-RELEASE Version

<!tag:200>

- The project has been renamed, from now on it will be called `darwin-spring-boot-webservice`.

- The webservice library configuration variables will now hang with the prefix `darwin.webservices`.

<!end:200>
