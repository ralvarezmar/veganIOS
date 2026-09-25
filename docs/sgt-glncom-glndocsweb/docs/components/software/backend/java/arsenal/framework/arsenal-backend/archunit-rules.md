# ArchUnit rules for Arsenal Backend {!include-markdown '../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}

{!include-markdown '../snippets/versions.md' start='<!tag:back-current>' end='<!end:back-current>'!}

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
through the gln-back-arsenal-backend-archunit-plugin-v2 plugin and also in the
pipeline when the architectural workflow is executed:

1. Classes residing in the ..controller package must contain Controller in the
   name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ControllerClassNameRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..controller' and are top level classes should have simple name containing 'Controller'' was violated (1 times):
   Class <com.santander.gln.app.controller.AppArsenal> does not have simple name containing 'Controller' in (AppArsenal.java:0)
   ```

2. Classes residing in the package ..service.impl must contain Service in the
   name and have Impl in the suffix

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ContainsServiceImplRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service.impl' and are top level classes should have simple name containing 'Service' and should have simple name containing 'Impl'' was violated (2 times):
   Class <com.santander.gln.app.service.impl.AppArsenalServic> does not have simple name containing 'Impl' in (AppArsenalServic.java:0)
   Class <com.santander.gln.app.service.impl.AppArsenalServic> does not have simple name containing 'Service' in (AppArsenalServic.java:0)
   ```

3. Classes residing in the ..service package must contain Service in the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ServiceRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service' and are top level classes should have simple name containing 'Service'' was violated (1 times):
   Class <com.santander.gln.app.service.AppArsenalServ> does not have simple name containing 'Service' in (AppArsenalServ.java:0)
   ```

4. Classes residing in the package ..config must contain Config in the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ConfigRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..config' and are top level classes should have simple name containing 'Config'' was violated (1 times):
   Class <com.santander.gln.infra.config.DatabaseConf> does not have simple name containing 'Config' in (DatabaseConf.java:0)
   ```

5. Classes residing in the package ..handler.exception must contain Exception in
   the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ExceptionClassNameRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..handler.exception' and are top level classes should have simple name containing 'Exception'' was violated (1 times):
   Class <com.santander.gln.app.handler.exception.AppArsenal> does not have simple name containing 'Exception' in (AppArsenal.java:0)
   ```

6. Classes residing in the package ..dto must contain DTO in the name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.DTORule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..dto' and are top level classes should have simple name ending with 'DTO'' was violated (1 times):
   Class <com.santander.gln.app.dto.AppArsenal> does not have simple name ending with 'DTO' in (AppArsenal.java:0)
   ```

7. Classes residing in the ..service.impl package should only access classes
   that are outside of package ..resource

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ServicePermittedAnnotationRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service.impl' should not access classes that reside in a package '..resource'' was violated (1 times):
   Class <com.santander.gln.app.service.impl.AppArsenalService> accesses class <com.santander.gln.app.resource.AppArsenalResource> in (AppArsenalService.java:0)
   ```

8. Classes residing in the ..utils package must have Utils as a suffix in the
   name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.UtilsRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..utils' and are top level classes should have simple name ending with 'Utils'' was violated (1 times):
   Class <com.santander.gln.app.utils.AppArsenal> does not have simple name ending with 'Utils' in (AppArsenal.java:0)
   ```

9. Classes residing in the ..enums package must have Enum as a suffix in the
   name

   ``` bash
   ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.EnumRule
   java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..enums' and are top level classes should have simple name ending with 'Enum'' was violated (1 times):
   Class <com.santander.gln.app.enums.AppArsenal> does not have simple name ending with 'Enum' in (AppArsenal.java:0)
   ```

10. Classes residing in the ..dto package must not access classes inside of
    package ..resource

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.DTOPermittedAnnotationRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..dto' should not access classes that reside in a package '..resource'' was violated (1 times):
    Class <com.santander.gln.app.dto.AppArsenalDTO> accesses class <com.santander.gln.app.resource.AppArsenalResource> in (AppArsenal.java:0)
    ```

11. Attributes that are declared in classes that reside in the ..model package
    must be private

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ModelRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'attributes that are declared in classes that reside in the '..model' package must be private' was violated (1 times):
    Field <com.santander.gln.app.model.AppArsenal> does not have modifier 'private' in (AppArsenal.java:0)
    ```

12. Classes residing in the ..repository package must have the word "Repository"
    as a suffix in the name

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.RepositoryRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..repository' and are top level classes should have simple name ending with 'Repository'' was violated (1 times):
    Class <com.santander.gln.app.repository.AppArsenal> does not have simple name ending with 'Repository' in (AppArsenal.java:0)
    ```

13. Classes that reside in the controller package should be annotated with
    @RestController or @Controller

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ControllerComponentRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in the package '..controller' should be annotated with '@RestController' or '@Controller'' was violated (1 times):
    Class <com.santander.gln.app.controller.AppArsenalController> does not have annotation '@RestController' or '@Controller' in (AppArsenalController.java:0)
    ```

14. Classes residing in the ..enums package must be Enums declared with the
    reserved word enum

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.IsEnumRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..enums' should be Enums declared with the reserved word 'enum'' was violated (1 times):
    Class <com.santander.gln.app.enums.AppArsenal> is not declared with the reserved word 'enum' in (AppArsenal.java:0)
    ```

15. Checks whether the connection pool used is Spring's default or Hikari's.

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.DBConnectionPoolRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Connection pool should be HikariCP' was violated (1 times):
    Class <com.santander.gln.infra.config.DatabaseConfig> does not use HikariCP as connection pool in (DatabaseConfig.java:0)
    ```

16. Validates that the application has the minimum required Hikari parameters

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.HikariConfigurationRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Connection pool should have the minimum required parameters' was violated (1 times):
    Class <com.santander.gln.infra.config.DatabaseConfig> does not have the minimum required parameters in (DatabaseConfig.java:0)
    ```

17. Checks whether the customized health check implementation is minimally
    compliant with expectations (annotation, interface, method and return)

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.HealthCheckRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Customized health check implementation should be minimally compliant with expectations' was violated (2 times):
    Class <com.santander.gln.infra.healthcheck.DatabaseHeaCheck> does not implements interface HealthIndicator and does not have simple name containing 'Health' in (DatabaseHeaCheck.java:0)
    ```

18. Check if classes residing in the package ..api respect microservices
    atomicity rule

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ExposedEndpointsRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..api' should respect microservices atomicity rule' was violated (1 times):
    Class <com.santander.gln.app.api.AppArsenalAPI> the application should have maximum of 20 endpoints in (AppArsenalAPI.java:0)
    ```

19. Checks if is using DriverManagerDataSource as a database access source

     ``` bash
     ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.DriverManagerDataSourceRule
     java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Not use DriverManagerDataSource' was violated (1 times):
     Class <com.santander.gln.infra.config.DatabaseConfig> DriverManagerDataSource cannot be used as a database access source in (DatabaseConfig.java:0)
     ```

20. Classes residing in the package ..resource must contain Resource in the name

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ResourceClassNameRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..resource' and are top level classes should have simple name ending with 'Resource'' was violated (1 times):
    Class <com.santander.gln.app.resource.AppArsenalResour> does not have simple name ending with 'Resource' in (AppArsenalResour.java:0)
    ```

21. Resource classes should be annotated with the @Component annotation

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ResourceComponentRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Resource classes should be annotated with the '@Component' annotation' was violated (1 times):
    Class <com.santander.gln.app.resource.AppArsenalResource> does not have annotation '@Component' in (AppArsenalResource.java:0)
    ```

22. Resource class should be defined by Contract-First

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.ResourceDefinedContractFirstRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'Resource class should be defined by Contract-First' was violated (1 times):
    Class <com.santander.gln.app.resource.AppArsenalResource> project should only have controller defined by contract in (AppArsenalResource.java:0)
    ```

23. Classes residing in the package ..usecase must contain UseCase in the name

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.UseCaseClassNameRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..usecase' and are top level classes should have simple name containing 'UseCase'' was violated (1 times):
    Class <com.santander.gln.app.usecase.AppArsenal> does not have simple name containing 'UseCase' in (AppArsenal.java:0)
    ```

24. Check if EmbeddedMainframe is using the minimum version permitted

    ``` bash
    ArchUnit Maven plugin reported architecture failures listed below :Rule Violated - com.santander.ars.archunit.core.rules.FWArchRule
    java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'EmbeddedMainframe should be using the minimum version permitted' was violated (1 times):
    The version of Altair starter (embeddedmainframe) supported is v3.13.9
    ```
