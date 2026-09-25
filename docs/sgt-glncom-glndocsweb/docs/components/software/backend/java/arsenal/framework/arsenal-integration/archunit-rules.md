# ArchUnit rules for Arsenal Integration

## Architectural testing on the DevOps pipeline

With a focus on increasing the quality of the delivery processes of the software
pieces that make up the Santander Brasil Tecnologia ecosystem, a verification
process (simple, automatic and extensible) of code/structure consistency of
built projects will be adopted as an integral part of the DevOps process, in
Java.

For this purpose, we will use the [ArchUnit](https://www.archunit.org/)
framework, a free tool to check the architecture of Java codes, providing a
check of structural dependencies (packages, classes, annotations, etc...).
Furthermore, it is also possible to analyze adopted conventions and taxonomies,
inheritance and composition, among other assertions.

ArchUnit manages to "abstract" all the power of the [Reflections
API](https://docs.oracle.com/javase/tutorial/reflect/index.html), in addition to
extrapolating the capabilities expected from tools like
[AspectJ](https://eclipse.org/aspectj/),
[Checkstyle](https://checkstyle.sourceforge.io/) or
[FindBugs](http://findbugs.sourceforge.net/).

## Arsenal x ArchUnit Rules

The list below shows the rules currently existing in the ArchUnit Arsenal
plugin. The execution of the rules occurs locally in the project generated
through the gln-back-arsenal-integration-archunit-plugin-v2 plugin and also in the
pipeline when the architectural workflow is executed:

1. Classes residing in the package ..config must contain Config in the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ShouldBeNamedConfigRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..config' and are top level classes should have simple name containing 'Config'' was violated (1 times):
   Class <com.santander.gln.infra.config.DatabaseConf> does not have simple name containing 'Config' in (DatabaseConf.java:0)
   ```

2. Checks if is using DriverManagerDataSource as a database access source

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.DriverManagerDataSourceRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Not use DriverManagerDataSource' was violated (1 times):
    Class <com.santander.gln.infra.config.DatabaseConfig> DriverManagerDataSource cannot be used as a database access source in (DatabaseConfig.java:0)
    ```

3. Checks if the class implements a new CamelContextConfiguration

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.CxfCustomConfigurationClassRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'The class should implement a new CamelContextConfiguration' was violated (1 times):
    Class <com.santander.gln.infra.config.CamelConfig>Inside the class that extends SetupCustomize must contain a return of a new instance of the CamelContextConfiguration class in (CamelConfig.java:0)
    ```

4. Checks if cxf variables exist in yaml

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.CxfCustomConfigurationRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'The cxf variables must exist in yaml' was violated (1 times):
    Class <com.santander.gln.infra.config.CxfConfig> The cxf variables must exist in yaml in (CxfConfig.java:0)
    ```

5. Classes must have defined a timeout for the connection

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.CxfTimeoutRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Classes must have defined a timeout for the connection' was violated (1 times):
    Class <com.santander.gln.routes.ArsenalRouteBuilder> The class ArsenalRouteBuilder must have defined a method setCxfConfigurer on the CxfEndpoint object (ArsenalRouteBuilder.java:0)
    ```

6. Check if classes respect microservices atomicity rule

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.AtomicityRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes should respect microservices atomicity rule' was violated (1 times):
   Class <com.santander.gln.routes.ArsenalRouteBuilder> the application should have maximum of 20 endpoints in (ArsenalRouteBuilder.java:0)
   ```

7. Classes using org.apache.camel.builder.RouteBuilder should reside in the package ..routes

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.FindRouteBuilderClassesRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes using org.apache.camel.builder.RouteBuilder should reside in the package '..routes'' was violated (1 times):
   Class <com.santander.gln.infra.config.CamelConfig> does not reside in the package '..routes' in (CamelConfig.java:0)
   ```

8. Classes residing in the package ..routes must contain RouteBuilder in the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ShouldBeNamedRouteBuilderRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..routes' and are top level classes should have simple name containing 'RouteBuilder'' was violated (1 times):
   Class <com.santander.gln.routes.CamelConfig> does not have simple name containing 'RouteBuilder' in (CamelConfig.java:0)
   ```

9. Classes residing in the ..utils package must have Utils as a suffix in the
   name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.UtilsRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..utils' and are top level classes should have simple name ending with 'Utils'' was violated (1 times):
   Class <com.santander.gln.app.utils.AppArsenal> does not have simple name ending with 'Utils' in (AppArsenal.java:0)
   ```

10. Check if Altair Connector is using the minimum version permitted

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.FWDependenciesRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'EmbeddedMainframe should be using the minimum version permitted' was violated (1 times):
    Update the Arsenal Integration framework version to at least 4.13.4 to use the Altair Connector component!
    ```
