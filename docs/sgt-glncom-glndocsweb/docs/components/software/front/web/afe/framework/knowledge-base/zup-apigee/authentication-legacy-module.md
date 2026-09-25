# How to troubleshoot the error during template compile of **'AuthenticationLegacyModule'** Expression form not supported

> **❗ Information**
>
> This documentation originated from the resolution of the so-called [AFE-1805](https://jira.santanderbr.corp/browse/AFE-1805)

## Contextualization

When trying to deploy to **HK** with the intention of achieving coexistence between ***Zup*** and ***Apigee***, and after running the 'npm run build' command.

## Solution

**Remove** the '--prod' option from the 'build' command.

> **Note**
>
> Another alternative would be to **create a new configuration** with the same settings as the 'prod' configuration, but **disable** the ***aot*** and ***buildOptimizer*** options and finally use this configuration in the project's 'build' command.
>
> That way, when the project is upgraded to a newer version of Angular, you can go back to using the `prod` configuration.
