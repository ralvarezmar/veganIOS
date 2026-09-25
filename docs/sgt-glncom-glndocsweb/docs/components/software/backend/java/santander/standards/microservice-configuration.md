# Microservice configuration

## Santander Spring Boot microservices

The Java microservices load their configuration at boot-up, once they are started they do not need to access the configuration service or the environment variables again, so changes to them will not be automatically collected.

The configuration properties are automatically loaded by Spring Boot.

The configuration policy for these artifacts is described below.

### Local environment

#### /src/test/resources/config/application-local.properties

This file will set the environment-dependent properties, paths, users, password.

Properties shall begin with env

```yaml
env.pkm-endpoint: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey
env.sts-endpoint: https://srvnuarintra.santander.dev.corp/sts
env.logging-server:
```

!!! Note

    You could start a Santander Spring Boot microservice from test scope using the provided `ApplicationTestRun` class.

#### /src/main/resources/config/application.yml

This file will contain the application configuration without including properties that depend on the environment, everything that changes by environment should be in the application-ENV.properties file. The environment is defined by property **spring.application.profiles.active**.

Properties requiring an environment-dependent value shall be defined in the following format **prop=${env.var-environment-dependent}**

Some rules when setting up this file are as follows:

- The architecture properties will have the root of santander. E.g. santander.logging.
- The application properties will have the root app. E.g. app.prop1
- Properties whose value contains an internal path to another microservice must add a suffix to the service name. Example app.serviciox=<http://serviciox${SANTANDER_SUFFIX}:8080>
- For compound property names, the character "-" shall be used to separate each word. E.g. pkm-endpoint.

```yaml
santander:
    app-key: orbis_key
    logging:
        system: atlas_system
        subsystem: atlas_subsystem
        application: atlas_app
        subapplication: atlas_sub_app
        paas-app-version: "@project.version@"
    kafka:
        server: ${env.logging-server}
    security:
        pkm-endpoint:
        - ${env.pkm-endpoint}
        sts-endpoint:
        - ${env.sts-endpoint}
app:
    cod-producto: 1212
    ruta-cuentas: http://cuentas${SANTANDER_SUFFIX}:8080
```

### Cloud environment

application-ENVIRONMENT.properties

Once the environment-dependent properties contained in *application-local.properties* have been deployed on the Platform
as a Service (Paas), they must be replaced by those corresponding to the environment
where DEV (certification) - TEST/PRE (pre-production) - PRO is being executed.

This will be done by creating a file called application-ENVIRONMENT.properties (e.g. application-dev.properties)
containing the environment-dependent properties of the application.
This file will be placed in a ConfigMap
using [Gluon ConfigMap Kubernetes component](../../../../../configuration/kubernetes/configmaps-rm.md)
