# Photon Quarkus Extensions archetype

This space aims
to present and assist the process of creating Photon Extensions from our Archetype.

Quarkus extensions enhance your application just as project dependencies do.

The role of the extensions is
to leverage Quarkus paradigms
to seamlessly integrate a library into Quarkus architecture—e.g. do more things at build time.

This is how you can use your battle-tested ecosystem and take advantage of Quarkus performance and native compilation

A Quarkus extension consists of two parts:

- The runtime module which represents the capabilities the extension developer exposes to the application’s developer (an authentication filter, an enhanced data layer API, etc).
  Runtime dependencies are the ones the users will add as their application dependencies (in Maven POMs or Gradle build scripts).
- The deployment module which is used during the augmentation phase of the build,
  it describes how to "deploy" a library following the Quarkus philosophy.
  In other words, it applies all the Quarkus optimizations to your application during the build.
  The deployment module is also where we prepare things for GraalVM’s native compilation.
  Following this guide, you will have a ready environment to develop Arsenal Photon standard applications.

## Prerequisites

- JDK
- Maven

## Generate a project using Archetype

Let's use all these capabilities to generate a "tutorial" project based on Photon:

To perform local tests,
you can understand
how Photon works by creating a project through Archetype using maven.

1. Generate a project using a terminal with Maven, using the following command:

   !!! tip "Attention!"

        For tests and consequently making this documentation, we use JDK 17, Maven 3.8.6.

    ```shell
    mvn archetype:generate \
    -DarchetypeVersion=[PHOTON-VERSION] \
    -DarchetypeGroupId=com.santander.photon \
    -DarchetypeArtifactId=photon-quarkus-archetype-extension \
    -DgroupId=com.santander.[your-domain] \
    -DartifactId=[your-application-name] \
    -Dversion=0.0.1-SNAPSHOT
    ```

2. You should receive something like the following lines in your terminal after running the above command:

    ```text
    [INFO] Scanning for projects...
    [INFO] BuildTimeEventSpy is registered.
    [INFO]
    [INFO] ------------------< org.apache.maven:standalone-pom >-------------------
    [INFO] Building Maven Stub Project (No POM) 1
    [INFO] --------------------------------[ pom ]---------------------------------
    [INFO]
    [INFO] >>> maven-archetype-plugin:3.2.1:generate (default-cli) > generate-sources @ standalone-pom >>>
    [INFO]
    [INFO] <<< maven-archetype-plugin:3.2.1:generate (default-cli) < generate-sources @ standalone-pom <<<
    [INFO]
    [INFO]
    [INFO] --- maven-archetype-plugin:3.2.1:generate (default-cli) @ standalone-pom ---
    [INFO] Using property: groupId = com.santander.gluon
    [INFO] Using property: artifactId = photon-demo-extension
    [INFO] Using property: version = 0.0.1-SNAPSHOT
    [INFO] Using property: package = com.santander.gluon
    Confirm properties configuration:
    groupId: com.santander.gluon
    artifactId: photon-demo-extension
    version: 0.0.1-SNAPSHOT
    package: com.santander.gluon
     Y: : Y
    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: photon-quarkus-archetype-extension:1.0.0-SNAPSHOT
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.gluon
    [INFO] Parameter: artifactId, Value: photon-demo-extension
    [INFO] Parameter: version, Value: 0.0.1-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.gluon
    [INFO] Parameter: packageInPathFormat, Value: com/santander/gluon
    [INFO] Parameter: package, Value: com.santander.gluon
    [INFO] Parameter: groupId, Value: com.santander.gluon
    [INFO] Parameter: artifactId, Value: photon-demo-extension
    [INFO] Parameter: version, Value: 0.0.1-SNAPSHOT
    [INFO] Parent element not overwritten in /Users/nYYYYYY/workspace/local.tests/photon/photon-demo-extension/deployment/pom.xml
    [INFO] Parent element not overwritten in /Users/nYYYYYY/workspace/local.tests/photon/photon-demo-extension/runtime/pom.xml
    [INFO] Project created from Archetype in dir: /Users/nYYYYYY/workspace/local.tests/photon/photon-demo-extension
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  01:10 min
    [INFO] Finished at: 2024-07-01T12:30:04+02:00
    [INFO] ------------------------------------------------------------------------
    ```

## Using a Photon Quarkus extension locally

With the above steps executed, you will have a project with all the needs to compile and install locally.
To run the application, you must use the following command:

```shell
mvn install
```

The application will compile, test and install, and you should have something like this:

```text
[INFO] Scanning for projects...
[INFO] BuildTimeEventSpy is registered.
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO]
[INFO] Photon Quarkus Extension Demo - Parent                             [pom]
[INFO] Photon Quarkus Extension Demo - Runtime                            [jar]
[INFO] Photon Quarkus Extension Demo - Deployment                         [jar]
[INFO]
...
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.santander.gluon.extension.demo.runtime.DemoProducerTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 4.812 s -- in com.santander.gluon.extension.demo.runtime.DemoProducerTest
[INFO] Running com.santander.gluon.extension.demo.runtime.DemoConfigTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.655 s -- in com.santander.gluon.extension.demo.runtime.DemoConfigTest
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO]
...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for Photon Quarkus Extension Demo - Parent 0.0.1-SNAPSHOT:
[INFO]
[INFO] Photon Quarkus Extension Demo - Parent ............. SUCCESS [  0.554 s]
[INFO] Photon Quarkus Extension Demo - Runtime ............ SUCCESS [  3.328 s]
[INFO] Photon Quarkus Extension Demo - Deployment ......... SUCCESS [  7.837 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  14.796 s
[INFO] Finished at: 2024-07-01T12:36:12+02:00
[INFO] ------------------------------------------------------------------------
```

To use the extension in your Photon project, you need to include de runtime dependency in your project pom.xml.

```xml
<dependencies>
        <dependency>
                <groupId>com.santander.gluon</groupId>
                <artifactId>photon-demo-extension</artifactId>
                <version>0.0.1-SNAPSHOT</version>
        </dependency>
</dependencies>
```

!!! tip "Attention!"

    Don't include photon-demo-extension-deployment or photon-demo-extension-parent in your Photon project,
    this modules are only to generate the extension.
