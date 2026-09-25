# Photon Quarkus Archunit

With a focus on improving  the quality of the delivery processes of  the software parts that make up  the Santander Gluon Tecnologia ecosystem,  a
verification process (simple, automatic and extensible) for the consistency of code/structure of built projects will be adopted as an integral  part of the
DevOps pipeline in Java.

For this purpose, we will use the **ArchUnit** framework, a free tool to check the architecture of Java codes, providing a check for structural dependencies
(packages, classes, annotations, etc...). In addition, it is also possible to analyze adopted conventions and taxonomies, inheritance and composition,
among other assertions.

ArchUnit manages to `abstract` all the power of the **API Reflections**, in addition to extrapolating the expected capabilities of tools like **AspectJ, Checkstyle
ou FindBugs**.

## Architecture Strategy

Ensuring that during the testing phase - when running Junit, the pipeline is able to ensure that the Archunit review + reviews are performed. This prevents
any developer from breaking the rules by removing classes before this time, which would circumvent the secure process.

### ***New Capacity:*** Photon Quarkus Version Check Engine

Each ArchUnit rule can be activated according to N versions of Photon Quarkus Framework.

*Examples:*

1. XXX rule will only be validated in projects with Photon Quarkus version 1.2.0
2. YYY rule will only be validated in projects with Photon Quarkus version 1.2.0, 1.3.6 and 1.4.0

### ***New Capacity:*** Layer scan Engine

Each ArchUnit rule can be activated according to identified layers.

*Example:*

1. Rules that work in the persistence layer will only be validated if the project has access to the database
2. Rules that act on the persistence layer will only be validated if the project has access to a database with Postgres, MongoDB, etc

## Relation Photon Quarkus x ArchUnit Rules

The list below assigns an identifier number to each ArchUnit rule, so that it is possible to validate if it is validated in the DevSecOps pipeline according to
the Photon Quarkus Framework version:

1.Classes residing in the package **..resource** must contain **Resource** in the name

> View violation message

```text
[ERROR] Failures:
[ERROR] ControllerArchCoreTest.testShouldBeNamedController:50 Architecture Violation [Priority:
MEDIUM] - Rule 'classes that reside in a package '..resource' and not are anonymous should have simple
name containing 'Resource'' was violated (1 times):
simple name of com.santander.gluon.jab.resource.AppPhotonQuarkusCont does not contain 'Resource' in
(AppPhotonQuarkusCont.java:0)
```

2.Classes residing in the package ..service.impl must contain Service in the name and have Impl in the suffix.
> View violation message

```text
[ERROR] Failures:
[ERROR] ServiceArchCoreTest.testServicesImplShouldBeNamedServiceImpl:84 Architecture Violation
[Priority: MEDIUM] - Rule 'classes that reside in a package '..service.impl' and not are anonymous
should have simple name containing 'Service' and should have simple name containing 'Impl'' was violated
(1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.service.impl.
AppPhotonQuarkusServiceImp does not contain 'Impl' in
```

---
3.Classes residing in the ..service package must contain Service in the name
> View violation message

```text
[ERROR] Failures:
[ERROR] ServiceArchCoreTest.testServicesShouldBeNamedService:56 Architecture Violation [Priority:
MEDIUM] - Rule 'classes that reside in a package '..service' and not are anonymous should have simple
name containing 'Service'' was violated (1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.service.AppPhotonQuarkusSer does not
contain 'Service' in (AppPhotonQuarkusSer.java:0)
```

---
4.Classes residing in the package ..config must contain Config in the name
> View violation message

```text
[ERROR] Failures:
[ERROR] ConfigArchCoreTest.testShouldBeNamedConfig:55 Architecture Violation [Priority: MEDIUM] - Rule
'classes that reside in a package '..config' and not are anonymous should have simple name containing
'Config'' was violated (1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.config.DatabaseConf does not contain
'Config' in (DatabaseConf.java:0)
```

---
5.Classes residing in the package ..dto must contain DTO in the name
> View violation message

```text
[ERROR] Failures:
[ERROR] ModelDTOArchCoreTest.testShouldBeNamedDTO:53 Architecture Violation [Priority: MEDIUM] - Rule
'classes that reside in a package '..dto' and not are anonymous should have simple name containing
'DTO'' was violated (2 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.model.dto.AppPhotonQuarkusRequestDT
does not contain 'DTO' in (AppPhotonQuarkusRequestDT.java:0)
```

---
6.Classes residing in the ..service.impl package should only access classes that are outside of package ..resource
> View violation message

```text
[ERROR] Failed to execute goal com.santander.gluon.photonQuarkus:archunit-maven-plugin:1.0.0:arch-test
(default) on project demo-full-archunit-rules: ArchUnit Maven plugin reported architecture failures
listed below :Rule Violated com.santander.gluon.photonQuarkus.archunit.core.rules.service.
ServicePermittedAnnotationRule
[ERROR] java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside
in a package '..service.impl' and not are anonymous should only access classes that reside outside of
package '..resource'' was violated (1 times):
[ERROR] Method <com.santander.gluon.service.impl.PhotonQuarkusServiceImpl.getSingle(java.lang.Integer)>
calls method <com.santander.gluon.resource.photonQuarkusResource.getSingle(java.lang.Integer)> in
(PhotonQuarkusServiceImpl.java:30)
```

---
7.Classes residing in the ..utils package must have Utils as a suffix in the name
> View violation message

```text
[ERROR] Failures:
[ERROR] UtilsArchCoreTest.testUtilsShouldBeNamedUtils:48 Architecture Violation [Priority: MEDIUM] -
Rule 'classes that reside in a package '..utils' and not are anonymous should have simple name ending
with 'Utils'' was violated (1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.utils.Commons does not end with
'Utils' in (Commons.java:0)
```

---
8.Classes residing in the ..enums package must have Enum as a suffix in the name
> View violation message

```text
[ERROR] Failures:
[ERROR] EnumsArchCoreTest.testShouldUsedReservedWordEnum:76 Architecture Violation [Priority: MEDIUM]
- Rule 'classes that reside in a package '..enums' and not are anonymous should only be declared with
the reserved word 'enum'' was violated (1 times):
Enum was not declared with the reserved word 'enum'!
```

---
9.Classes residing in the ..dto package must not access classes inside of package ..resource
> View violation message

```text
ERROR] Failures:
[ERROR] ModelDTOArchCoreTest.testShouldNotDependsAnyController:83 Architecture Violation [Priority:
MEDIUM] - Rule 'classes that reside in a package '..dto' and not are anonymous should only access
classes that reside outside of package '..resource' was violated (1 times):
Method <com.santander.gluon.my_PhotonQuarkus_archunit_validate.model.dto.AppPhotonQuarkusRequestDTO.
callController()> calls method <com.santander.gluon.my_PhotonQuarkus_archunit_validate.controller.
AppPhotonQuarkusController.getById(long)> in (AppPhotonQuarkusRequestDTO.java:30)
```

---
10.Classes residing in the ..repository package must have the word "Repository" as a suffix in the name
> View violation message

```text
[ERROR] RepositoryArchCoreTest.testClassInPackageRepositoryShouldNamedRepository:49 Architecture
Violation [Priority: MEDIUM] - Rule 'classes that reside in a package '..repository' and not are
anonymous should have simple name ending with 'Repository'' was violated (1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.repository.AppPhotonQuarkusRepo does
not end with 'Repository' in (AppPhotonQuarkusRepo.java:0)
```

---
11.Classes residing in the ..enums package must be Enums declared with the reserved word enum
> View violation message

```text
[ERROR] Failures:
[ERROR] EnumsArchCoreTest.testShouldUsedReservedWordEnum:76 Architecture Violation [Priority: MEDIUM]
- Rule 'classes that reside in a package '..enums' and not are anonymous should only be declared with
the reserved word 'enum'' was violated (1 times):
Enum was not declared with the reserved word 'enum'!
```

---
12.Checks if the project is using recent versions of the Photon Quarkus framework
> View violation message

```text
[ERROR] Failures:
[ERROR] FrameworkArchCoreTest.testLatestPhotonQuarkusVersionValid:53 Should be latest Quarkus Version Valid
```

---
13.Classes residing in the package ..repository.impl must contain Repository in the name and have Impl in the suffix
> View violation message

```text
[ERROR] Failures:
[ERROR] ServiceArchCoreTest.testRepositoryImplShouldBeNamedRepositoryImpl:84 Architecture Violation
[Priority: MEDIUM] - Rule 'classes that reside in a package '..repository.impl' and not are anonymous
should have simple name containing 'Repository' and should have simple name containing 'Impl'' was
violated (1 times):
simple name of com.santander.gluon.my_PhotonQuarkus_archunit_validate.repository.impl.
AppPhotonQuarkusRepositoryImp does not contain 'Impl' in
```

---
14.Rule that checks if the project is Photon Quarkus or no
> View violation message

```text
When project doesn't have a parent
[ERROR] Failures:
[ERROR] java.lang.NullPointerException: Cannot invoke "org.apache.maven.model.Parent.getArtifactId()"
because the return value of "org.apache.maven.model.Model.getParent()" is null
When project has a parent but is not PhotonQuarkus

[ERROR] Failures:
[ERROR] java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes should only
be follow the PhotonQuarkus architecture' was violated (65 times):
```

|                  | PhotonQuarkus <br/>1.0.0                                 |  |  |
|------------------|----------------------------------------------------------|--|--|
| **ArchRule #01** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #02** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #03** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #04** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #05** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #05** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #06** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #07** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #08** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #09** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #10** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #11** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #12** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #13** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |
| **ArchRule #14** | ![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png) |      |      |

### ***Subtitle***

![archUnitSuccesRule.png](../assets/images/archUnitFaiRule.png) = Not validated on the pipeline

![archUnitSuccesRule.png](../assets/images/archUnitSuccesRule.png)= Validated on the pipeline
