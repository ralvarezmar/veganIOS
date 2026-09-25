# Photon Quarkus Relation Database Archetype

This space aims to present and assist the process of creating Gluon Photon Quarkus LightWeight Imperative ORM projects from our Archetype.
following this guide, you will have a ready environment to develop Photon Quarkus standard applications.

## Prerequisites

* JDK
* Maven

## Generate a project using Archetype

Let's use all these capabilities to generate a "tutorial" project based on Photon Quarkus:

To perform local tests, you can understand how Photon Quarkus works by creating a project through Archetype using maven.

1. Generate a project using a terminal with Maven, using the following command:

   !!! tip "Attention!"

        For tests and consequently making this documentation, we use JDK 17, Maven 3.8.6.

    ```shell
    mvn archetype:generate \
    -DarchetypeVersion=[PHOTON-VERSION] \
    -DarchetypeGroupId=com.santander.photon \
    -DarchetypeArtifactId=photon-quarkus-archetype-orm \
    -DgroupId=com.santander.[your-domain] \
    -DartifactId=[your-application-name] \
    -Dversion=0.0.1-SNAPSHOT
    ```

2. You should receive something like the following lines in your terminal after running the above command:

  ```text
    [INFO] Scanning for projects...
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
    [INFO] Using property: Entity = PhotonQuarkus
    [INFO] Using property: Database = postgresql
    [INFO] Using property: version = 0.0.1-SNAPSHOT
    [INFO] Using property: gitignore = .gitignore
    [INFO] Using property: Authorization = OpenId
    [INFO] Using property: archetype = ####415253454E414C####
    [INFO] Using property: groupId = com.santander.[your-domain]
    [INFO] Using property: artifactId = [your-application-name]
    [INFO] Using property: package = com.santander.[your-domain]
    Confirm properties configuration:
    Entity: PhotonQuarkus
    Database: postgresql
    version: 0.0.1-SNAPSHOT
    gitignore: .gitignore
    Authorization: OpenId
    archetype: ####415253454E414C####  
    groupId: com.santander.[your-domain]
    artifactId: [your-application-name]
    package: com.santander.[your-domain]
    Y: : Y
    [INFO] Using following parameters for creating project from Archetype: photon-quarkus-archetype-orm:1.0.0-SNAPSHOT
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: com.santander.[your-domain]
    [INFO] Parameter: artifactId, Value: [your-application-name]
    [INFO] Parameter: version, Value: 0.0.1-SNAPSHOT
    [INFO] Parameter: package, Value: com.santander.[your-domain]
    [INFO] Parameter: packageInPathFormat, Value: com/santander/[your-domain]
    [INFO] Parameter: Authorization, Value: OpenId
    [INFO] Parameter: Entity, Value: PhotonQuarkus
    [INFO] Parameter: archetype, Value: ####415253454E414C####
    [INFO] Parameter: package, Value: com.santander.[your-domain]
    [INFO] Parameter: gitignore, Value: .gitignore
    [INFO] Parameter: groupId, Value: com.santander.[your-domain]
    [INFO] Parameter: Database, Value: postgresql
    [INFO] Parameter: artifactId, Value: [your-application-name]
    [INFO] Parameter: version, Value: 0.0.1-SNAPSHOT
    [INFO] Executing META-INF/archetype-post-generate.groovy post-generation script
    [INFO] Project created from Archetype in dir: C:\Users\nYYYYYY\workspace\[your-application-name]
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time:  01:10 min
    [INFO] Finished at: 2024-07-01T12:30:04+02:00
    [INFO] ------------------------------------------------------------------------
  ```

## Using a Gluon Photon  Object Relational Mapping archetype locally

With the above steps executed, you will have a project with all the needs to compile and install locally.
To run the application, you must use the following command:

``` { .sh .copy }
mvn install
```

The application will compile, test and install, you should have something like this:

```text
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] ----------------< com.santander.gluom:photon-orm-demo >-----------------
[INFO] Building photon-orm-demo 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] Generator 'jaxrs-spec' is considered stable.
[INFO] Environment variable JAVA_POST_PROCESS_FILE not defined so the Java code
[INFO] NOTE: To enable file post-processing, 'enablePostProcessFile' must be set
[INFO] Invoker Package Name, originally not set, is now derived from api package
[INFO] Processing operation getPage
[INFO] Processing operation create
[INFO] Processing operation getSingle
[INFO] Processing operation update
[INFO] Processing operation delete
[INFO] 'host' (OAS 2.0) or 'servers' (OAS 3.0) not defined in the spec. Default
[INFO] 'host' (OAS 2.0) or 'servers' (OAS 3.0) not defined in the spec. Default
[INFO] 'host' (OAS 2.0) or 'servers' (OAS 3.0) not defined in the spec. Default
[INFO] writing file C:\Users\nYYYYYY\workspace\photon-orm-demo\target\gene
[INFO] 'host' (OAS 2.0) or 'servers' (OAS 3.0) not defined in the spec. Default
[INFO] writing file C:\Users\nYYYYYY\workspace\photon-orm-demo\target\gene
[INFO] Skipping generation of Webhooks.
[INFO] 'host' (OAS 2.0) or 'servers' (OAS 3.0) not defined in the spec. Default
[INFO] Skipping generation of supporting files.
################################################################################
# Thanks for using OpenAPI Generator.                                          #
# Please consider donation to help us maintain this project ?                 #
# https://opencollective.com/openapi_generator/donate                          #
################################################################################
...
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.santander.gluon.PhotonQuarkusOpenIdEndpointTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 4.812 s -- in  com.santander.gluon.PhotonQuarkusOpenIdEndpointTest
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO]
...
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  14.796 s
[INFO] Finished at: 2024-07-01T12:36:12+02:00
[INFO] ------------------------------------------------------------------------
```

## Generate Open API Sources and Update Folders

Since our application uses Open API to manage some model and api classes, you first need to generate these classes that will be generated within the application's target directory. You can do this, using this maven command:

``` { .sh .copy }
mvn generate-sources
```

## Execute Project Photon Using the Quarkus Plugin

With the above steps executed, you will have a project with all the needs to compile and start. If you want to run the application locally using the default testcontainers that will start with your project, first you need to have your local
docker up and run the command:

``` { .sh .copy }
mvn compile quarkus:dev
```

The dependent images in your configuration pom.xml file, will be downloaded locally in your docker and will start new containers in docker.

If you have a local container already up in your docker, you can point it into your application.properties like:

``` { .xml .copy }
quarkus.datasource.jdbc.url=jdbc:otel:postgresql://localhost/quarkus_test
```

If you don't have docker, then the pom.xml should be configured according to your dependencies' local instances configuration.

The application will start, and you should have something like this:

```text
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
2024-07-05 13:54:07,592 WARN  [io.qua.config] (Quarkus Main Thread) Unrecognized configuration key "quarkus.otel.exporter.otlp.traces.endpoint" was provided; it will be ignored; verify that the dependency extension for this configuration is set or that you did not make a typo
2024-07-05 13:54:07,592 WARN  [io.qua.config] (Quarkus Main Thread) Unrecognized configuration key "quarkus.datasource.kind" was provided; it will be ignored; verify that the dependency extension for this configuration is set or that you did not make a typo
Hibernate:
    drop table if exists photonquarkus cascade
Hibernate:
    create table photonquarkus (
        id integer not null,
        description varchar(40),
        name varchar(40),
        primary key (id)
    )
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (1,'Geracao Digital 1')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (2,'First Gate')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (3,'Big Data')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (4,'Praca Hub Central')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (5,'Praca Hibrida')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (6,'Estacionamento Hibrido')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (7,'Geracao Digital 2')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (8,'Sede')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (9,'Data Center Campinas')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (10,'Estacao 33')
Hibernate: INSERT INTO PhotonQuarkus(id, name) VALUES (11,'Estacao 34')
2024-07-05 13:54:12,188 INFO  [io.quarkus] (Quarkus Main Thread) photon-orm-demo 0.0.1-SNAPSHOT on JVM (powered by Quarkus 3.2.12.Final) started in 10.880s. Listening on: http://localhost:8891
2024-07-05 13:54:12,192 INFO  [io.quarkus] (Quarkus Main Thread) Profile dev activated. Live Coding activated.
2024-07-05 13:54:12,193 INFO  [io.quarkus] (Quarkus Main Thread) Installed features: [agroal, cdi, hibernate-orm, hibernate-validator, jdbc-h2, narayana-jta, oidc, oidc-client, oidc-client-reactive-filter, oidc-token-propagation-reactive, rest-client-reactive, resteasy-reactive, resteasy-reactive-jackson, security, smallrye-context-propagation, smallrye-fault-tolerance, smallrye-health, smallrye-openapi, swagger-ui, vertx]
```
