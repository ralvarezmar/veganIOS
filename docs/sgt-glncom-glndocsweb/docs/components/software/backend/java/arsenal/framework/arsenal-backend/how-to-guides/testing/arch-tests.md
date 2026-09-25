# Architectural Tests

## List of ArchUnit rules for Arsenal projects

The relationship below assigns an identifier number to each ArchUnit rule, so that it is possible to validate whether it is validated in the DevSecOps pipeline according to the Arsenal Framework version:

* Classes residing in the __..controller__ package must contain __Controller__ in the name:

    `[ERROR]   ControllerArchCoreTest.testShouldBeNamedController:50 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..controller' and not are anonymous should have simple name containing
    'Controller'' was violated (1 times): simple name of com.santander.jab.controller.AppArsenalCont does not contain 'Controller' in (AppArsenalCont.java:0)`

* Classes residing in the __..service.impl__ package must contain __Service__ in the name and have Impl in the suffix:

    `[ERROR]   ServiceArchCoreTest.testServicesImplShouldBeNamedServiceImpl:84 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service.impl' and not are anonymous should have simple name containing
    'Service' and should have simple name containing 'Impl'' was violated (1 times): simple name of com.santander.ars.my_arsenal_archunit_validate.service.impl.AppArsenalServiceImp does not contain 'Impl' in`

* Classes residing in the __..service__ package must contain __Service__ in the name:

    `[ERROR]   ServiceArchCoreTest.testServicesShouldBeNamedService:56 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service' and not are anonymous should have simple name containing
    'Service'' was violated (1 times): simple name of com.santander.ars.my_arsenal_archunit_validate.service.AppArsenalSer does not contain 'Service' in (AppArsenalSer.java:0)`

* Classes residing in the __..config__ package must contain __Config__ in the name:

    `[ERROR]   ConfigArchCoreTest.testShouldBeNamedConfig:55 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..config' and not are anonymous should have simple name containing 'Config'' was violated (1 times):
    simple name of com.santander.ars.my_arsenal_archunit_validate.config.DatabaseConf does not contain 'Config' in (DatabaseConf.java:0)`

* Classes residing in the __..dto__ package must contain __DTO__ in the name:

    `[ERROR]   ModelDTOArchCoreTest.testShouldBeNamedDTO:53 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..dto' and not are anonymous should have simple name containing 'DTO'' was violated (2 times):
    simple name of com.santander.ars.my_arsenal_archunit_validate.model.dto.AppArsenalRequestDT does not contain 'DTO' in (AppArsenalRequestDT.java:0)`

* Classes residing in the __..service.impl__ package must not access classes annotated with __@RestController__ and __@Controller__:

    `[ERROR]   ServiceArchCoreTest.testServiceShouldNotDependsAnyController:114 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..service.impl' and not are anonymous should only access classes that are not
    annotated with @RestController and should only access classes that are not annotated with @Controller' was violated (1 times):
    Method <com.santander.ars.my_arsenal_archunit_validate.service.impl.AppArsenalServiceImpl.getById(java.lang.Long)> calls method <com.santander.ars.my_arsenal_archunit_validate.controller.AppArsenalController.delete(long)> in (AppArsenalServiceImpl.java:34)`

* Classes residing in the __..utils__ package must have __Utils__ suffixed to the name:

    `[ERROR]   UtilsArchCoreTest.testUtilsShouldBeNamedUtils:48 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..utils' and not are anonymous should have simple name ending with 'Utils'' was violated (1 times):
    simple name of com.santander.ars.my_arsenal_archunit_validate.utils.Commons does not end with 'Utils' in (Commons.java:0)`

* Classes residing in the __..enums__ package must have __Enum__ suffixed to the name:

    `[ERROR]   EnumsArchCoreTest.testShouldUsedReservedWordEnum:76 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..enums' and not are anonymous should only be declared with the reserved word 'enum''
    was violated (1 times): Enum was not declared with the reserved word 'enum'!`

* Classes residing in the __..dto__ package must not access classes annotated with __@RestController__ and __@Controller__:

    `[ERROR]   ModelDTOArchCoreTest.testShouldNotDependsAnyController:83 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..dto' and not are anonymous should only access classes that are not annotated with
    @RestController and should only access classes that are not annotated with @Controller' was violated (1 times):
    Method <com.santander.ars.my_arsenal_archunit_validate.model.dto.AppArsenalRequestDTO.callController()> calls method <com.santander.ars.my_arsenal_archunit_validate.controller.AppArsenalController.getById(long)> in (AppArsenalRequestDTO.java:30)`

* Attributes that are declared on classes residing in the __..model__ package must be private:

    `[ERROR]   ModelArchCoreTest.testFieldModelShouldBePrivate:44 Architecture Violation [Priority: MEDIUM] - Rule 'fields that are declared in classes that reside in a package '..model' should be private' was violated (1 times):
    Field <com.santander.ars.my_arsenal_archunit_validate.model.AppArsenal.id> does not have modifier PRIVATE in (AppArsenal.java:0)`

* Classes residing in the __..repository__ package must have the word __"Repository"__ suffixed to the name:

    `[ERROR]   RepositoryArchCoreTest.testClassInPackageRepositoryShouldNamedRepository:49 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..repository' and not are anonymous should have simple name ending with
    'Repository'' was violated (1 times):
    simple name of com.santander.ars.my_arsenal_archunit_validate.repository.AppArsenalRepo does not end with 'Repository' in (AppArsenalRepo.java:0)`

* Classes residing in the __..controller__ package must be annotated with __@RestController__ or __@Controller__:

    `[ERROR]   ControllerArchCoreTest.testShouldBeAnnotatedWithController:77 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..controller' and not are anonymous should be annotated with
    @RestController or should be annotated with @Controller' was violated (1 times):
    Class <com.santander.jab.controller.AppArsenalController> is not annotated with @Controller in (AppArsenalController.java:0) and Class <br.com.santander.jab.controller.AppArsenalController> is not annotated with @RestController in (AppArsenalController.java:0)`

* Classes residing in the __..enums__ package must be __Enums__ declared with the enum keyword:

    `[ERROR]   EnumsArchCoreTest.testShouldUsedReservedWordEnum:76 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..enums' and not are anonymous should only be declared with the reserved word 'enum'' was violated
    (1 times): Enum was not declared with the reserved word 'enum'!`

* Check if the connection pool used is Spring's default or Hikari's:

    `[ERROR] ConfigArchCoreTest.testShouldNotUseDriverManagerDataSource:81 Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..config' and are not anonymous and are annotated with @Configuration should use Hikari pool
    connection' was violated (1 times ):
    DatabaseConfig should use Hikari pool or default Spring pool!`

* Check if the application does not have the __Spring Actuator__ dependency exclusion statement, in the pom.xml file:

    `[ERROR]   FrameworkArchCoreTest.testApplicationShouldNotExcludeActuator:125 Should not exclude actuator dependency!`

* Check if the connection pool contains the minimum configured parameters __(maxPoolSize, minPoolSize, maxLifeTime, validationTimeout, connectionTimeout and idleTimeout)__:

    `Caused by: java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..config' and not are anonymous and are annotated with @Configuration should contain the minimum parameterization!' was
    violated (1 times): DatabaseConfig does not contain the minimum required parameterization!`

* Verifies that the implementation of the custom health check adheres to the expected minimum __(annotation, interface, method and return)__:

    `Caused by: java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..controller' or reside outside of package '..controller' and not are anonymous and are annotated with
    @Component and have simple name containing 'Health' should implement org.springframework.boot.actuate.health.HealthIndicator' was violated (1 times): Class <com.santander.jab.health.PersonalHealthIndicator>
    does not implement org.springframework.boot.actuate.health.HealthIndicator in (PersonalHealthIndicator.java:0)`

* Check if the application is in compliance with atomicity standards

    `java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..controller' and are annotated with @RestController or are annotated with @Controller and not anonymous and not nested
    should respect microservices atomicity rule, because the application should have a maximum of
    20 endpoints' was violated (1 times):Check the microservices atomicity document for further information`

* Check if DriverManagerDataSource is used as a database access source

    `java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that are annotated with @Configuration and not are anonymous should not use DriverManagerDataSource, because data base configuration must use
    either Hikari pool or default Spring pool!' was violated (1 times):
    Check the document for further: https://confluence.santanderbr.corp/pages/viewpage.action?pageId=248660502`

* Check if Resource classes must have the suffix "Resource" in their name

    `Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..resource' and have simple name ending with 'Resource' and are top level classes should be defined by Contract-First and project should
    only have controller defined by contract' was violated`

* Check if Resource classes is annotated with the @Component annotation

    `Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..resource'
    and have simple name ending with 'Resource' and are top level classes should be annotated with @Component' was violated`

* Check if Resource classes is defined by Contract-First

    `Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..resource' and have simple name ending with 'Resource' and are top level classes should be defined by
    Contract-First and project should only have controller defined by contract' was violated`
