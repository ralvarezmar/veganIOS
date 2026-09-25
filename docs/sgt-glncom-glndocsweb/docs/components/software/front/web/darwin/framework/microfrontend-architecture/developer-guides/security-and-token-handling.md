# Security and Token Handling

## Introduction

A very common case use is when a Shell application and its Microfront have to work sharing and using the same token. For that case `ng-darwin` library offers certain utilities in order to handle this situation properly.

!!! note
    For more information about this process check the documentation of the [security module](https://automatic-doodle-rew2y31.pages.github.io/modules/_ng-darwin_security.html){:target="_blank"} itself.

## Shell

A Shell application is a standard SPA application that needs a token retrieved for example from a structural login.
The Darwin Security module is on charge of managing that token, keeping it updated meanwhile the session is alive and removing it when the session is over.

The Shell will need to use the `SecurityModule` and the `SecurityService` of `ng-darwin` and initialize the security.

```ts
// app.config.ts

export const appConfig: ApplicationConfig = {
  providers: [
    provideSecurity(),
  ],
};
```

```ts
// app.ts

private readonly _security = inject(SecurityService);

async ngOnInit() {
  await this.security.initialize();
}
```

If the security module has the `tkinss` property **enabled**, then **the token will be kept in the browser** _**session storage**_. The token will be automatically refreshed by the security module when necessary.

A Microfront, thanks `ng-darwin` utilities, will be able to access the same _session storage_ the Shell does, and read the saved token. This will be the way of communication the token to the Microfront.

!!! warning
    It is mandatory for the Shell application **to enable** `tkinss` property so that the token is kept and visible to the Microfront. Otherwise the Microfront will not work.

## Microfront

A Microfront application, in order to consume the token stored by the Shell, it will also need to import the security library `ng-darwin`,
but in this case it will use the module `SecurityLiteModule` and the service `SecurityLiteService` in order to initialize the security. This service will retrieve the token from the browser _session storage_ when needed.

```ts
// app.config.ts
export const appConfig: ApplicationConfig = {
  providers: [
    provideSecurityLite(),
  ],
};
```

```ts
// app.ts
private readonly _securityLite = inject(SecurityLiteService);

async ngOnInit() {
  await this._securityLite.initialize();
}
```

### The standalone mode. How to work when there is no Shell providing a token

When developing a Microfront a real Shell is not going to be available for setting the token in the browser _session storage_, so a little extra code has to be added to achieve this.

The Microfront archetype is shipped with an out of the box functionality named _Shell Lite_ out of the box.
The _Shell Lite_ is only a Shell with the minimum functionality to handle the security token and is also very useful when developing a Microfront, or even to integrate a Microfront through an iframe.

The Shell Lite mode is automatically detected and initialized when running in standalone mode:

`http://<domain>:<port>/`
