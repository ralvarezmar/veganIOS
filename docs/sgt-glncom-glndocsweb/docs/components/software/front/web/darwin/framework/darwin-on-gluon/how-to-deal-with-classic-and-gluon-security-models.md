# How to deal with Classic and Gluon security models

Gluon proposes a new Security Model that is based on the [OAuth 2.0](https://oauth.net/2/) protocol. This new model is more secure and more flexible than the previous one.
However, it is not compatible with the previous model. This means that if you want to migrate from the previous model to the new one, you will have to change your code.

## What is the difference between the two models?

The main difference between the two models is that the previous model was based on the BKS/Corporative tokens (using the classic [Darwin Security library](https://automatic-doodle-rew2y31.pages.github.io/modules/_ng-darwin_security.html){:target="_blank"}),
while the new one is based on the [OAuth 2.0](https://oauth.net/2/) protocol (using [SCM library](../../../core/security/index.md))

## How to migrate from the previous model to the new one?

The migration from the previous model to the new one is not automatic. You will have to change your code so we encourage you to read the following guides:

- [How to transform a Darwin Classic SPA into a Darwin Gluon SPA](how-to-transform-a-darwin-classic-spa-into-a-darwin-gluon-spa.md)
- [How to transform a Darwin Classic Shell into a Darwin Gluon Shell](how-to-transform-a-darwin-classic-shell-into-a-darwin-gluon-shell.md)
- [How to transform a Darwin Classic Microfront into a Darwin Gluon Microfront](how-to-transform-a-darwin-classic-mfe-into-a-darwin-gluon-mfe.md)

## How to deal with the two models at the same time?

### Introduction

In Gluon, the new security model is based on Oauth2.0. This means that the Darwin Classic approach of using a corporative token to access the API is no longer the standard.
On the other hand, the new security model provides a mechanism to obtain the corporative token and handle its lifecycle to ensure backguard compatibility.

In this document, we will explain how to obtain a corporative token in the new security model.

### Prerequisites

You should have your project configured with the new Security model provided by Gluon. If you don't have it, please follow the steps in [this guide](how-to-transform-a-darwin-classic-spa-into-a-darwin-gluon-spa.md#5-install-and-configure-the-security-context-manager-scm-module).

### How to acquire a Corporative token and initialize the Classic Darwin security service

To obtain a corporative token, you'll need to send an HTTP GET request to the corresponding `SCC` endpoint. SCC provides an endpoint capable of transforming an access token into a corporative one:
`https://sccnuar.santander.dev.corp/***/utils/tokens/bks`.
Please, refer to your security architect in order to obtain the correct URL for your project and environment.

Once you have the URL, you can use the following code to obtain the corporative token:

```typescript
const token = await firstValueFrom(
  this.httpClient.get<string>('https://sccnuar.santander.dev.corp/***/utils/tokens/bks')
);
this.securityService.initializeFromNonStructuralToken(token);
```

!!! note
    In this snippet, you can see that the Angular `HttpClient` is used to send the request to the `SCC` endpoint. The `SCC` endpoint will need the `access token` in the `authorization` header.
    The `SCM` is the responsible piece for acquiring and injecting the access tokens into any request in the Angular Shell scope, so the `SCM` should be configured and initiated properly previously.
    Take a look at this [guide](how-to-transform-a-darwin-classic-spa-into-a-darwin-gluon-spa.md#5-install-and-configure-the-security-context-manager-scm-module) to learn how to do it.

    As a good practice, you can create a component behind an Angular route and protect it with the `OAuthGuard` provided by the `@santander/security-angular` module. Take a look at this other [guide](how-to-transform-a-darwin-classic-spa-into-a-darwin-gluon-spa.md#6-configure-the-scm-guard-to-secure-your-routes) to learn how to do it.

### How to configure what token should be injected in the requests

Once you have obtained a corporative token and initialized the Darwin Security with it (by calling the `securityService.initializeFromNonStructuralToken()`) both security architectures (Darwin and SCM) are properly configured with their respective tokens.

The next step is to configure both architectures to ensure the correct token is used for each endpoint.

If you are interested in how both security architectures work, you can read the following tip:

!!! note

    By default, **Darwin Security** initiates an Angular interceptor capable of intercepting any Angular request and injecting the corporative token in the `Authorization` header.

    By default, the **SCM** will always have the final decision for injecting the access token in every request because it overwrites the default Angular `HttpBackend`.

    This way, when both architectures work together, the Darwin interceptor will always inject the corporative token but SCM will always overwrite it with the access token.

In order to decide which endpoints should be secured with the corporative token and which ones should be secured with the access token,
the `SCM` provides a mechanism to configure a white list of protected resources that will be used to decide which token should be injected into each request.
You can take a look at this [guide](../../../core/security/authentication/oauth/use-it-in-angular.md#configuration) to learn how to configure it using the `protectedResources` property.

If no `protectedResources` property is configured, the SCM will always inject the access token in every request.
As you want to inject the corporative token just for some requests, you'll need to configure it with the endpoints that should be secured with the access tokens.

This way, the SCM will inject the access token in every request except the ones configured in the `protectedResources` property and will do nothing for the rest.
As those other requests were previously decorated from the Darwin security interceptor with the corporative token, you'll be able to deal with different security scenarios.

### Next steps

Right now, the Darwin team is working on a new version of the Darwin Security module that will provide a new initialization method that will be able to
handle the whole process of obtaining the corporative token and initializing the Darwin Security with it in a transparent way:

- Will make the request to `SCC` endpoint.
- Will initiate the Darwin security with the corporative token.

Stay tuned to know when this capability is finally released. In the meantime, you can use the approach explained in this document.
