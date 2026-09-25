# HubConnector Interceptor

Module responsible for intercepting calls made with ***HttpClient*** to the Services HUB.

Its purpose is to manage the entire process of updating rolling tokens (JWT) and request headers, making it transparent to the developer.

## Prerequisites

- Installation of [@afe/http-interceptors](../index.md)

## Automated Settings

By running the ***ng add*** command, the following changes are made to the project so that it is able to take advantage of the features provided by the part:

> The configurations of this module have already been carried out from the installation of the v4 structuring of @afe/http-interceptors.

### Configuration File

The ***hub-connector-interceptor.config.ts*** file was automatically generated in a ***config*** folder (configuration pattern adopted by the Front-end Architecture) by exporting a configuration variable to be used in the structuring module.

``` TS
//hub-connector-interceptor.config.ts
import { HubConnectorConfig, Storages } from '@afe/http-interceptors/hub-connector';

export const hubConnectorInterceptorConfig: HubConnectorInterceptorConfig = {
    urlsToIntercept: [
        '/hub-url' // => conforme a sua resposta para -url-a-ser-interceptada no prompt de instalação,
    ],
    urlsToIgnore: [],
    storage: {
        keys: {
            jwt: jwt // => conforme a sua resposta no prompt de instalação para jwt,
            xUid: xuid // => conforme a sua resposta no prompt de instalação para xuid',
        },
        type: Storages.LocalStorage  // => conforme a sua resposta no prompt de instalação para storage,
    },
};
```

The exported variable takes as a parameter a configuration object ***hubConnectorInterceptorConfig***, which contains the following property:

|Property|Type|Description|
|-|-|-|
|urlsToIntercept|`Array<string>`|urls that will be intercepted to add and update the integration headers with Services Hub|
|urlsToIgnore|`Array<string>`|urls that will be ignored when updating integration headers with Services Hub|
|storage|`Object`|defines the type of storage that will be used to store the keys (jwt and xUid)|

> **Attention** The reference variable in the /hub-url structuring configuration example is an alias pertinent to [proxy](../../../../../development-guides/local-environment/proxy.md) that must be configured to make application requests in the local environment.

Within the ***storage*** object, there are two properties to set:

|Property|Type|Description|
|-|-|-|
|keys|***string***|name that will be used to identify the keys within the storage|
|type|***string***|type of storage that will be used to store the keys|

It is also possible to configure which type of storage the application will use, choosing between three options, they are:

|Type|Description|
|-|-|
|***MemoryStorage***|Tokens are lost every time the page is reloaded|
|***SessionStorage***|Tokens are lost when closing the browser|
|***LocalStorage***|Tokens are never lost|

> Tokens have an expiration time that is configured on a per-application basis with the CDG team.

### Core Module

The configuration variable created was imported and added as a parameter to the module's *forRoot*** method.

``` TS
//app.module.ts
// Demais importações omitidas
import { hubConnectorInterceptorConfig } from './config/hub-connector-interceptor.config';
import { HubConnectorInterceptorModule } from '@afe/http-interceptors/hub-connector';

@NgModule({
    imports: [
        HubConnectorInterceptorModule.forRoot(hubConnectorInterceptorConfig),
    ],
})
export class AppModule { }
```

## Implementation

The configuration and import of the module is enough for the necessary interception to occur for the requests made by Angular's ***HTTPClient***.
