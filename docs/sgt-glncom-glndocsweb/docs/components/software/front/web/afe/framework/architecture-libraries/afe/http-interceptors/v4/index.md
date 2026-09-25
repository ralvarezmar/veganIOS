# HTTP Interceptors (Angular 16)

## Installing

To configure the lib automatically in your project, run the following command:

``` BASH
ng add @afe/http-interceptors@^4
```

The following questions will be asked in order to be able to configure the modules:

``` BASH
What the application app-key?
```

You must inform the ***app-key*** used to consume resources though **Service Hub**. E.g `<YOUR-APP-KEY>` informed at the installation prompt***

``` BASH
What kind of authentication will be used? › - Use arrow-keys. Return to submit.
❯  Single Sign-On (SSO)
   User and password
```

You must choose the **type of authentication** that will be implemented in the application.

> The answer to this question will be used to configure the SSO Interceptor module

``` BASH
Where do rolling tokens be stored?
❯  MemoryStorage
   LocalStorage
   SessionStorage
```

> The answer to this question will be used to configure the HubConnector Interceptor

You must choose where will be stored the **rolling tokens** to communicate to the **Service Hub**, where:

|Type|Description|
|-|-|
|***MemoryStorage***|Tokens are always lost when the page is reloaded|
|***SessionStorage***|Tokens are lost when the browser is closed|
|***LocalStorage***|Tokens never will be lost|

 ``` BASH
 What is the name for storing the "jwt" token?
 ```

You must inform what will be the identifier for the chosen ***storage*** of the ***jwt token***. Default value: **jwt**.

``` BASH
What is the name for storing the "x-uid" token?
```

You must inform what will be the identifier for the chosen ***storage*** of the ***token x-uid***. Default value: **x-uid**.

If you've chosen the SSO authentication type, you'll be asked three additional questions:

``` BASH
What is the authentication url in the development environment?
```

You must enter the **resource url** to authenticate to the **development environment**. [e.g](https://wastfcdvlbr01.bs.br.bsch/sso-v5/authenticate/internal-basic-v5)

``` BASH
What is the authentication url in the HK environment?
```

You must enter the **url of the resource** to authenticate to the **homologation environment**. [e.g](https://ssohub-hml.bs.br.bsch/sso-v5/authenticate/internal-basic-v5)

``` BASH
What is the authentication url in the production environment? (optional)
```

You must enter the resource url to authenticate to the production environment.

After answering all the questions presented, ***@afe/http-interceptors*** will be properly **configured** and will have changed the following files:

## Automated Settings

By running the ***ng add*** command, the following changes are made to the project so that it is able to take advantage of the features provided by the part:

### Configuration Files

#### Structuring Configuration

The ***hub-connector.config.ts*** file was automatically created inside the ***config*** folder to configure the [HubConnectorInterceptor](./modules/hub-connector-interceptor.md), responsible for communicating with the ***Service Hub***.

``` TS
//hub-connector.config.ts
import { HubConnectorInterceptorConfig, Storages } from '@afe/http-interceptors/hub-connector';

export const hubConnectorInterceptorConfig: HubConnectorInterceptorConfig = {
    urlsToIntercept: [
        '/hub-url',
    ],
    storage: {
        keys: {
            jwt: 'jwt' // => conforme a sua resposta no prompt da instalação
            xUid: 'x-uid' // => conforme a sua resposta no prompt da instalação
        },
        type: Storages.MemoryStorage // => conforme a sua resposta no prompt da instalação
    }
};
```

And if you selected the **authentication type** as **SSO**, the ***sso.config.ts*** file will be automatically created in the ***config*** folder (following the patterns defined by the architecture) to configure [SSOInterceptor](./modules/sso-interceptor.md).

``` TS
//sso.config.ts
import { SSOInterceptorConfig } from '@afe/http-interceptors/sso';

export const ssoInterceptorConfig: SSOInterceptorConfig = {
    urlsSSO: [
        '/hub-sso-url', // => conforme a sua resposta no prompt da instalação
    ],
};
```

Finally, it adds the ***url.config.ts url**** to the ***url*** file to make the SSO call and authenticate to the application.

> This url has the ***alias*** **hub-sso-url** which is configured by the application locally to point to the authentication endpoint entered when running the ***ng add*** command.
> In this way, it is possible to develop in the local environment without running into **CORS** problems.
> To learn more, see the documentation on [proxy](../../../../development-guides/local-environment/proxy.md)

``` TS
//url.config.ts
export const urlConfig = Object.freeze({
   urlHubSSO: '/hub-sso-url/sso-v5/authenticate/internal-basic-v5?gw-app-key=<YOUR-APP-KEY>',
});
```

#### Local Proxy

If the selected authentication type was Single-Sign On (SSO), the command adds a proxy with the name hub-sso-url to the ***proxy.conf.json*** file that redirects to the development url reported via the terminal.

> To learn more, see the documentation on [proxy](../../../../development-guides/local-environment/proxy.md)

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

For example: ***/hub-sso-url*** and ***/hub-url*** and that will be replaced during the ***deploy*** of the application by the variables created in ***env.conf***.

``` CONF
/hub-url=${HUB_HOST}
/hub-sso-url=${HUB_SSO_HOST}
```

And finally, the environment variables will be declared for the **development**, **HK** and **PRD** environments (if you have been informed via terminal).

In this way, when performing the ***deploy*** of the application, all the variables defined in the project will be replaced by their respective values, in order to point to the environment in which it is ***deployed***.

``` CONF
ENVIRONMENT=pre
PROJECT_NAME=afe
APP_NAME=teste-prod-spa
TZ=America/Sao_Paulo
no_proxy=*.corp

REPLACE_IN_FILES=true
HUB_HOST=https://esbapi.santanderbr.pre.corp
HUB_SSO_HOST=https://ssohub-hml.bs.br.bsch
```

### Core Module

And finally, the ***ng add*** command updates the main module of the application, importing and configuring the module HubConnectorInterceptorModule and SSOInterceptorModule, depending on the option chosen when selecting the type of authentication used.

``` TS
import { hubConnectorInterceptorConfig } from './config/hub-connector.config';
import { ssoInterceptorConfig } from './config/sso.config';

@NgModule({
   declarations: [
      // declaração omitida
   ],
   imports: [
      HubConnectorInterceptorModule.forRoot(hubConnectorInterceptorConfig),
      SSOInterceptorModule.forRoot(ssoInterceptorConfig),
   ]
});
```

## Implementation

After the configuration is successful, simply make a request to the SSO ***url*** added to the ***url.config.ts*** to implement authentication in your application.

``` TS
/app.component.ts
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

## Modules

- See [modules](./modules/index.md) for more features made available by the library.
