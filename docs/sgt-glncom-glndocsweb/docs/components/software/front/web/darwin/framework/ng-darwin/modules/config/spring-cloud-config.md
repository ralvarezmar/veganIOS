# Spring Cloud Config

**Not recommended** for Gluon!!

One of the ways to obtain the `config.json` configuration file is through the [Spring Cloud Config](https://spring.io/projects/spring-cloud-config) service.

Following [this guide](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16500328222/Darwin+Configuration+Service+installation+guide){:target="_blank"} you can install the configuration service in the PaaS,
once this is done and to be able to establish the redirection rules in nginx towards the service, it is necessary to have declared the `CONFIG_END_POINT` environment variable with the following value:

``` TEXT
http://SERVICE_NAME:8080/APP_NAME/ENVIRONMENT/RELEASE/FILE_NAME
```

Example:

``` TEXT
http://configuration-service:8080/f-ng-12345678-dwproject/dev/master/f-ng-12345678-dwproject.json
```
