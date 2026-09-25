# Prerequisites

In this step, we will address the necessary prerequisites for implementing coexistence.

## Non-functional

- Understanding the [coexistence architecture](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257388217&src=contextnavpagetreemode)
- Understanding the [coexistence login](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=442480400)

## Functional

It is necessary to request access to the resource that performs the coexistence login between ***Zup*** and ***Apigee***

(`auth_convivencia/<API_VERSION>/token`), through the [API Consumption Form](https://confluence.santanderbr.corp/display/PADROESARQINT/Suporte), where `<API_VERSION>` is the latest version of the API.

> **⚠️ Note**
>
> To know the latest version of the resource to be consumed, you should consult the documentation on [coexistence login](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=442480400).

From `version 2` of the [coexistence login](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=442480400), `APIs with -leg` used in version 1 are no longer necessary and should not be used.

If the channel has access to the authenticator methods and key exchange resource, they can be used.

> **⚠️ Note**
>
> The ***SSO*** ***API*** instead of having ***-leg***, just changed the version. See more information in the documentation [Coexistence Authenticator Methods](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=270206149)

## Project update to Angular 10 or 12

This coexistence tutorial does not support versions lower than Angular 10.
Therefore, the channel that intends to implement coexistence must [update its project](../../../update-guide/index.md) to the latest version of Angular, according to the [bank's homologated versions](../../../update-guide/versioning/index.md).

## Installation

### ***@afe/authentication***

This is the new library responsible for application authentication. At the moment, it only has the implementation of coexistence authentication. The command below will install the latest version in your project:

```bash
npm install @afe/authentication@^1 @afe/event-handler@^1 --save
```

> **⚠️ Note**
>
> The new versions of the libraries below include necessary changes for coexistence between ***Zup*** and ***Apigee***, so update the dependency if your project is using it.
>
> **Note**: there were no changes in the configurations of the mentioned pieces.

### ***@afe/http-interceptors***

To meet the new version of the coexistence login, it is necessary to update the ***@afe/http-interceptors*** library, as per the command below:

```bash
npm install @afe/http-interceptors@^3 --save
```

### Authentication in ZUP

Authentication (or implementation of the **authenticator method**, according to certain bank terminologies) is a **mandatory step** for any application that wants to consume resources and APIs developed within Santander.

This authentication will create a Zup session, so that we can then log in to ***Apigee***.
