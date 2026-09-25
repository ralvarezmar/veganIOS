# Retry Interceptor

Module responsible for intercepting calls made with Angular's ***HttpClient*** that have returned a certain error and making the call again for a number of times defined by the application.

## Prerequisites

- Installation of [@afe/http-interceptors](../index.md)

## Configuration

To use ***@afe/http-interceptors/retry*** simply import it into the main module of the application.

The ***forRoot*** method of the ***RetryInterceptorModule*** module receives as a parameter a configuration object of type ***RetryInterceptorConfig***, having the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **urlsToIntercept** | ***`Array<string>`*** | urls that will be intercepted to add and update the integration headers with Services Hub |
| **urlsToIgnore** | ***`Array<string>`*** | urls that will be ignored when updating integration headers with Services Hub |
| **errorsToIntercept** | ***`Array<string>`*** | codes, messages, or message snippets returned by the service that will be retried |
| **retries** | ***number***| Maximum number of times the retry will be done |

**For example**: to redo the call of a HUB service that ends up returning a certain error configured by the application, the following configuration must be performed:

Create the ***retry-interceptor.config.ts*** file in a ***config*** folder (configuration pattern adopted by the Front-end Architecture) and export a configuration variable to be used in the structuring module.

``` TS
//retry-interceptor.config.ts
import { RetryInterceptorConfig } from '@afe/http-interceptors/retry';

export const retryInterceptorConfig: RetryInterceptorConfig = {
    urlsToIntercept: [
        '/hub-url',
        '<sua-url-a-ser-interceptada>',
    ],
    urlsToIgnore: [],
    errorsToIntercept: [
        'HUB009',
        'Timeout',
    ],
    retries: 5,
};
```

Import the exported variable and pass it as a parameter to the module's ***forRoot*** method.

```ts
// Demais importações omitidas
import { RetryInterceptorModule } from '@afe/http-interceptors/retry';
import { retryInterceptorConfig } from '<caminho-do-arquivo-de-configuração>/retry-interceptor.config';

@NgModule({
    imports: [
        RetryInterceptorModule.forRoot(retryInterceptorConfig),
    ],
})
export class AppModule { }
```

> The reference variable in the /hub-url structuring configuration example is an alias pertinent to [proxy](../../../../../development-guides/local-environment/proxy.md) that must be configured to make application requests in the local environment.

## Implementation

The configuration and import of the module is enough for the necessary interception to occur for the requests made by Angular's ***HTTPClient***.
