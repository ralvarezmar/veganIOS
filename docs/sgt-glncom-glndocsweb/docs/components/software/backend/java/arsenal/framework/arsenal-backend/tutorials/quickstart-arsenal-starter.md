# QuickStart Arsenal Starter {!include-markdown '../../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}

{!include-markdown '../../snippets/versions.md' start='<!tag:back-current>' end='<!end:back-current>'!}

This white paper demonstrates how to use archetype to create a new Arsenal
Starter.

## What is a Spring Starter

Spring in its documentation entitles a starter containing only the necessary
dependencies for the functionality, with no other functions (Reference), but we
have the possibility to use the same autoconfiguration mechanism for
functionalities that we want to be imported and “autoconfigured” for several of
our applications, for example, a client-http, utils, etc, just adding the
dependency in the project.

## How To Get Arsenal Starter?

!!! warning "Archetype Usage"

    New applications should be created using Gluon Portal. Projects generated
    by only the archetype lacks essential SDLC files and configurations and
    should be used only for tests

* Open your command terminal (PowerShell, Terminal or Shell)

* Run the command below:

`Windows (PowerShell):`

```bash
mvn archetype:generate `
"-DarchetypeGroupId=com.santander.ars" `
"-DarchetypeArtifactId=gln-back-arsenal-backend-archetype-starter" `
"-DarchetypeVersion={!include-markdown '../../snippets/versions.md' start='<!tag:back-version>' end='<!end:back-version>'!}" `
"-DgroupId=com.santander" `
"-DartifactId=arsenal-starter-demo" `
"-Dversion=0.1.0-SNAPSHOT"
```

`Linux or MacOS:`

```bash
mvn archetype:generate \
-DarchetypeGroupId=com.santander.ars \
-DarchetypeArtifactId=gln-back-arsenal-backend-archetype-starter \
-DarchetypeVersion={!include-markdown '../../snippets/versions.md' start='<!tag:back-version>' end='<!end:back-version>'!} \
-DgroupId=com.santander \
-DartifactId=arsenal-starter-demo \
-Dversion=0.1.0-SNAPSHOT
```

!!! tip "RELEASE keyword"

    Use RELEASE keyword to always get the latest released version of the archetype

!!! tip "Variables that you need to change"

    1. *groupId:* identifier of your application domain group
    2. *artifactId:* application artifact identifier
    3. *version:* artifact version

    Do not change **DarchetypeGroupId**, **DarchetypeArtifactId** and **DarchetypeVersion** fields

* Access the root of the created project (in this case, arsenal-starter-demo):

  `cd arsenal-starter-demo/`

## How to install and use the Starter?

* Use maven (3.9 or above) to automatically install your starter and be able to use it in other
  projects.

```bash
mvn install
```

## Main Components of the Starter

By following the previous steps for generating a starter, a demo starter using
spring 3.1 is generated, with some example classes that you should adjust
according to your needs. Here we will talk about the main components that were generated.

### DemoAutoConfiguration

The main class, where we create and configure the Beans, is the
DemoAutoConfiguration class. In it, we can manage all the Beans that we want to
start along with the application

```java
import com.santander.ars.demo.Demo;
import com.santander.ars.demo.DemoProperties;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//TODO For demonstration purpose, change according to you needs
@Configuration
@ConditionalOnClass(Demo.class)
@EnableConfigurationProperties(DemoConfig.class)
public class DemoAutoConfiguration {

  @Bean
  @ConditionalOnMissingBean
  public Demo demo(DemoConfig demoConfig) {
    DemoProperties demoProperties = new DemoProperties();

    demoProperties.setName(demoConfig.getName());

    return new Demo(demoProperties);
  }
}
```

> * ***@Configuration***: is a class-level annotation indicating that an object
    is a source of bean definitions. @Configuration classes declare beans
    through @Bean annotated methods. Calls to @Bean methods on @Configuration
    classes can also be used to define inter-bean dependencies.
> * ***@ConditionalOnClass***: Allows configuration to be included based on the
    presence or absence of specific classes. See more [Developing
    auto-configuration and using
    conditions](https://docs.spring.io/spring-boot/docs/1.2.5.RELEASE/reference/html/boot-features-developing-auto-configuration.html)
> * ***@EnableConfigurationProperties***: It enables support for
    @ConfigurationProperties annotated classes in our application. With the
    @ConfigurationProperties annotation, Spring boot provides a convenient way
    to access such parameters from within the application code.
> * ***@ConditionalOnMissingBean***: Allow configurations to be included based
    on the presence or absence of specific beans. See more [Developing
    auto-configuration and using
    conditions](https://docs.spring.io/spring-boot/docs/1.2.5.RELEASE/reference/html/boot-features-developing-auto-configuration.html)
> * ***DemoConfig***: Starter Class responsible for having the settings found in
    the application yaml.
> * ***DemoProperties***: Class that is in a demo Core Lib, with the purpose of
    decoupling the responsibilities, and leaving AutoConfiguration with only the
    bean configuration part, and the rest in this Core Lib.
> * ***Demo***: Class that is in a core demo lib, which is the Bean that will be
    configured by AutoConfiguration, with the purpose, again, of sharing
    responsibilities.

### org.springframework.boot.autoconfigure.AutoConfiguration.imports

When Spring Boot starts up, it looks for a file named
org.springframework.boot.autoconfigure.AutoConfiguration.imports in the
classpath. This file is located in the src/resources/META-INF/spring/ directory.
It is in this file that we indicate all the AutoConfiguration classes that were
created and configured. In our example we only have the DemoAutoConfiguration
class, but if there were more, just skip a line and add the rest

```bash
${package}.DemoAutoConfiguration
${package}.OtherAutoConfiguration
```
