# Troubleshooting - Java

**_1._**

``` { .console .copy }
java.lang.IllegalStateException: Logback configuration error detected:

ERROR in ch.qos.logback.classic.joran.action.ContextNameAction - Failed to rename
context [arsenal-lib-log] as [your-service-here-xxx] java.lang.IllegalStateException:

Context has been already given a name at org.springframework.boot.logging.logback.LogbackLoggingSystem.loadConfiguration(LogbackLoggingSystem.java:169)
```

- Cloud native applications only have "local" and "default" profiles. So do
not execute the application using profiles "dev", "hml", "prod" etc

- Property **_arsenal.library.core.api.log.context-name_** shouldn't be defined.

**_2._**

``` { .console .copy }
[INFO] Running ControllerArchTest

[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0,
Time elapsed: 0.004s - in ControllerArchTest

[INFO]

[INFO] Results:

[INFO]

[ERROR] Failures:

[ERROR] ConfigArchCoreTest.testShouldNotUseDriverManagerDataSource:79
Architecture Violation [Priority: MEDIUM] - Rule 'classes that reside in a
package '..config' and not are anonymous and are annotated with @Configuration
should use Hikari pool connection' was violated (1 times):
DatabaseConfig should use Hikari pool or default Spring pool!

[ERROR] UtilsArchCoreTest.testUtilsShouldBeNamedUtils:45 Architecture
Violation [Priority: MEDIUM] - Rule 'classes that reside in a package
'..utils' and not are anonymous should have simple name ending with 'Utils''
was violated (3 times): simple name of com.santander.xxx.remote.utils.Builders
does not end with 'Utils' in (Builders.java:0)
```

- ArchUnit classes are being added to the application during the test stage
of the pipeline for architectural tests.
Check the [ArchUnit Documentation](../testing/arch-tests.md) for more information.

**_3._**

``` { .console .copy }
Error creating bean with name 'messageSource' defined in com.santander.ars.error.config.ArsenalErrorHandlingConfig:

Bean instantiation via factory method failed; nested exception is
org.springframework.beans.BeanInstantiationException:
Failed to instantiate [org.springframework.context.support.ReloadableResourceBundleMessageSource]:

Factory method 'messageSource' threw exception; nested exception is
java.lang.IllegalArgumentException: Basename must not be empty
```

- This error indicates that values of some properties haven't been identified.
Probably they are missing, duplicated or indented incorrectly. In this case,
property 'messageSource' wasn't found and should be declared in the YML:

``` { .yaml .copy }
# Propriedades da aplicação Spring
spring:
messages:
    basename:messages
```

**_4._**

``` { .console .copy }
{"timestamp":"2020-06-03T15:03:28.914+0000","level":"WARN","thread":"main","xxx":{},"logger":"org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext","message":"

Exception encountered during context initialization -
cancelling refresh attempt: org.springframework.beans.factory.BeanDefinitionStoreException:

Failed to process import candidates for configuration class [com.santander.xxx.treasurer.digital.resources.TreasurerDigitalResourcesApplication];

nested exception is java.lang.IllegalStateException: Error processing condition
on org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration$DifferentManagementContextConfiguration",

"context":"treasurer.digital.resources"}
{"timestamp":"2020-06-03T15:03:28.976+0000","level":"ERROR","thread":"main",
"mdc":{},"logger":"org.springframework.boot.SpringApplication",
"message":"Application run failed","context":"treasurer.digital.resources",
"exception":"java.lang.IllegalArgumentException:
Could not resolve placeholder 'PORT' in value \"${PORT}\" at

... 50 more

java.lang.IllegalStateException: Error processing condition on
org.springframework.boot.actuate.autoconfigure.web.server.ManagementContextAutoConfiguration$DifferentManagementContextConfiguration
at org.springframework.boot.autoconfigure.condition.SpringBootCondition
.matches(SpringBootCondition.java:59) at org.springframework.context.
annotation.ConditionEvaluator.shouldSkip(ConditionEvaluator.java:108)
at org.springframework.context.annotation.ConfigurationClassParser
.processConfigurationClas... \n"}
```

- _Could not resolve placeholder 'PORT' in value \"${PORT}\"_ indicates that
the **PORT** property is missing from the application.yml or env.conf  

**_5._**

``` { .console .copy }
[ERROR] /var/lib/docker/home/docker/workspace/XXX/ARSENAL/PIPELINE-XXX-XXX-SOMETHING/
19/git/src/test/java/br/com/santander/xxx/model/dto/SomeClass.java:[3,40]
package com.tngtech.archunit.base does not exist
```

- The **Arsenal ArchUnit** dependency is missing from the project and
should be added in the **pom.xml**:

``` { .xml .copy }
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-backend-test-starter</artifactId>
    <scope>test</scope>
</dependency>
```

If the problem persists, check if the **ArchUnit** dependency was excluded from
the project.

**_6._**

``` { .console .copy }
[ERROR] /Users/yourUser/eclipse-workspace/arsenal_X/src/test/java/br/com/santander/
ars/arsenal_archunit/core/rest/client/RateLimiterArchCondition.java:[24,30] type
com.tngtech.archunit.core.domain.JavaAnnotation does not take parameters

[ERROR] /Users/yourUser/eclipse-workspace/arsenal_X/src/test/java/br/com/santander/
ars/arsenal_archunit/core/rest/client/TimeLimiterArchCondition.java:[24,30] type
com.tngtech.archunit.core.domain.JavaAnnotation does not take parameters

[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:
3.1:testCompile (default-testCompile) on project arsenal_130: Compilation failure:
Compilation failure:

[ERROR] /Users/yourUser/eclipse-workspace/arsenal_X/src/test/java/br/com/santander/
ars/arsenal_archunit/core/rules/ConfigRule.java:[56,13] cannot find symbol

[ERROR]   symbol:   method areTopLevelClasses()

[ERROR]   location: interface com.tngtech.archunit.lang.syntax.elements.ClassesThat<com.tngtech.archunit.lang.syntax.elements.GivenClassesConjunction>

[ERROR] /Users/yourUser/eclipse-workspace/arsenal_X/src/test/java/br/com/santander/
ars/arsenal_archunit/core/rules/ExceptionRule.java:[56,9] cannot find symbol

[ERROR]   symbol:   method areTopLevelClasses()

[ERROR]   location: interface com.tngtech.archunit.lang.syntax.elements.ClassesThat<com.tngtech.archunit.lang.syntax.elements.GivenClassesConjunction>
```

- Probably the application is using an old version of Arsenal framework and hence
an old version of ArchUnit. Update the Arsenal version should solve the problem.

!!! info
    Although not recommend, it's possible to only update the **ArchUnit**
    version in pom.xml.
