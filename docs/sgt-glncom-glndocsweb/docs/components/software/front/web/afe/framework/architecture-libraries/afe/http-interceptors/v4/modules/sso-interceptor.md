# SSO Interceptor

Single Sign On (SSO) authentication provides users with the ability for single sign-on as it performs access control of multiple independent systems.

In this way, a user logs in with a unique ID and password to gain access to all available systems within the configured security domains.

Therefore, this module is responsible for intercepting the call made to the SSO authentication service and adding the ***withCredentials*** header to the request made to avoid ***SPNEGO***.

## Prerequisites

### Functional

- Installation of [@afe/http-interceptors](../index.md)

### Non-functional

- Read about the [SSO Authentication](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=64722237) documentation from the Security Solutions team.

## Automated Settings

By running the ****ng add*** command, the following changes are made to the project so that it is able to make calls to the SSO service, if the Single Sign-On **(SSO)** authentication type has been selected

> The configurations of this module have already been carried out from the installation of the v2 structuring of @afe/http-interceptors.

### Configuration File

The ***sso-interceptor.config.ts*** file was automatically generated in a ***config*** folder (configuration pattern adopted by the Front-end Architecture) by exporting a configuration variable to be used in the structuring module.

``` TS
//sso-interceptor.config.ts
import { SSOInterceptorConfig } from '@afe/http-interceptors/sso';

export const ssoInterceptorConfig: SSOInterceptorConfig = {
    urlsSSO: [ '<url-de-sso-pretendida>' ], // => conforme a sua resposta no prompt
};
```

The exported variable takes as a parameter a configuration object ***SSOInterceptorConfig***, which contains the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| ***urlsSSO*** | ***`Array<string>`*** | urls referring to the SSO API that will be intercepted |

### Core Module

The configuration variable created was imported and added as a parameter to the module's *forRoot*** method.

``` TS
//app.module.ts
// Demais importações omitidas
import { ssoInterceptorConfig } from './config/sso-interceptor.config';
import { SSOInterceptorModule } from '@afe/http-interceptors/sso';

@NgModule({
    imports: [
        SSOInterceptorModule.forRoot(ssoInterceptorConfig),
    ],
})
export class AppModule { }
```

Finally, it adds the ***url.config.ts url**** to the ***url*** file to make the SSO call and authenticate to the application.

> This url has the ***alias*** **hub-sso-url** which is configured by the application locally to point to the authentication endpoint entered when running the ***ng add*** command.
> In this way, it is possible to develop in the local environment without running into **CORS** problems.
> To learn more, see the documentation on [proxy](../../../../../development-guides/local-environment/proxy.md)

``` TS
//url.config.ts
export const urlConfig = Object.freeze({
   urlHubSSO: '/hub-sso-url/sso-v5/authenticate/internal-basic-v5?gw-app-key=<YOUR-APP-KEY>',
});
```

#### Local Proxy

The command adds to the ***proxy.conf.json*** file a ***proxy*** with the name ***hub-sso-url*** that redirects to the ***url*** development information via terminal.

> To learn more, see the documentation on [proxy](../../../../../development-guides/local-environment/proxy.md)

``` JSON
//proxy.conf.json
{
   "/hub-sso-url": {
    "target": "https://wastfcdvlbr01.bs.br.bsch",
    "secure": false,
    "logLevel": "debug",
    "changeOrigin": true,
    "pathRewrite": {
      "^/hub-sso-url": ""
    }
  }
}
```

#### Environment Variables

If your project is of type **SPA** or **element** and was created via **developer portal** or even ***deployed*** via conveyor, the ***replace.tokens*** file will be updated with the occurrences we created.

For example: ***/hub-sso-url*** and that will be replaced during the ***deploy*** of the application by the variables created in ***env.conf***.

``` CONF
/hub-sso-url=${HUB_SSO_HOST}
```

And finally, the environment variables will be declared for the **development**, **HK** and **production** environments (if you have been informed via terminal).

In this way, when performing the ***deploy*** of the application, all the variables defined in the project will be replaced by their respective values, in order to point to the environment in which it is ***deployed***.

``` CONF
ENVIRONMENT=pre
PROJECT_NAME=afe
APP_NAME=teste-prod-spa
TZ=America/Sao_Paulo
no_proxy=*.corp

REPLACE_IN_FILES=true
HUB_SSO_HOST=https://ssohub-hml.bs.br.bsch
```

## Implementation

After the configuration is successful, simply make a request to the SSO ***url*** added to the ***url.config.ts*** to implement authentication in your application.

``` TS
//app.component.ts
import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { urlConfig } from './config/url.config';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss']
})
export class AppComponent {
    constructor(
        private readonly httpClient: HttpClient,
    ) { }

   ngOnInit(){
      this.httpClient.get(urlConfig.urlHubSSO)
         .subscribe((data) => {
            // troca de chaves e demais implementações
         });
   }
}
```
