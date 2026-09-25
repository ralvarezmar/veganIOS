# How to troubleshoot "SPNEGO authentication is not supported on this client"

The problem occurs in projects that use SSO (Single Sign On) as an authenticator method in development, homologation, or production environments.

## Contextualization

When making a request to the Single Sign-On (SSO) endpoint, a dialog box opens for the user to enter their network credentials. Such browser interaction is done through a property called ***withCredentials***.

## Solution

Within the architecture, we have a module called ***SSOInterceptorModule***, which is part of the ***@afe/http-interceptors***, responsible for adding this property to the request made by the application.

In the [how to authenticate via SSO](./../../development-guides/authentication/sso-ticket/index.md) tutorial, is taught how to configure this sub-module responsible for mitigating the problem of ***SP Nego***.

Which occurs due to the lack of the property mentioned above.

However, due to inattention, some projects may end up configuring the absolute domain of the authentication endpoint in SSO, or even configuring the wrong alias.

Instead of configuring the **alias** that will be used in the application during the development phase and replaced by publishing in the environments, through the [proxy](../../development-guides/local-environment/proxy.md), to consume the services locally.

Wrong:

``` TS
import { SSOInterceptorConfig } from '@afe/http-interceptors/sso';

export const ssoInterceptorConfig: SSOInterceptorConfig = {
    urlsSSO: [
        'http://ssohub-hml.bs.br.bsch',
    ],
};
```

Correct:

``` TS
import { SSOInterceptorConfig } from '@afe/http-interceptors/sso';

export const ssoInterceptorConfig: SSOInterceptorConfig = {
    urlsSSO: [
        '/hub-sso-url',
    ],
};
```

When deploying the application to the production environment, for example, the SSOInterceptor would intercept only the approval URL.

And would not add the withCredentials property in the request to the production environment, causing the application flow to fail.

It's also important to revisit the settings for [environment variables](./../../development-guides/deployment/setup/variables/index.md).

Because if a value is not configured for the ***alias*** created in the application for the development, HK and PRD environments. This and other errors can be caused.
