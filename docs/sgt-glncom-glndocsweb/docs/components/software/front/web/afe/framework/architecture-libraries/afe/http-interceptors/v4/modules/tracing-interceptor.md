# Tracing Interceptor

The Module is responsible for sending technical information (API, error, latency, etc.) or functional information (user, hardware, etc.) to the tracing endpoint within a certain time interval.

## Prerequisites

- Installation of [@afe/http-interceptors](../index.md)

## Configuration

To use the Tracing interceptor, simply import it into the main module of the application.

The ***forRoot*** method of the ***TracingInterceptorModule*** module receives as a parameter a configuration object of type ***TracingInterceptorConfig***, having the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **httpInterval** |***number*** | Time interval, in milliseconds, between each payload being sent to the tracing endpoint |
| **tracingEndpoint** |***string*** | URL of the endpoint used to send the tracing payload |
| **urlsToAudit** |***`Array<string>`*** | urls that will be audited and sent to the tracing endpoint |
| **urlsToIgnore** |***`Array<string>`*** | urls that will be ignored by tracing |
| [deprecated] **tracingFn** |***Function***| function used to compose the payload object that will be sent to the tracing endpoint |

### Placeholders

The module also provides a set of placeholders that can be used during payload rendering using the tracingFn. When the payload is sent, the placeholders will be replaced with values related to the request response.

There are two types of placeholders: ***tracingResponsePlaceholder*** and ***tracingEncryptedResponsePlaceholder*** (for encrypted data).

| Placeholder | Description |
| --------- | ------ |
| ***HttpVerb*** | Request method (Example: GET, HEAD, POST, OPTIONS, DELETE, etc) |
| ***HttpStatusCode*** | HTTP Status Code (Example: 200, 401, 404, 503, etc.) |
| ***HttpStatusMessage*** | HTTP Status Message |
| ***Duration*** | Duration of the request |
| ***Url*** | Requested URL |
| ***Id*** | Application-generated ID |
| ***IsOK*** | Verifies that the request was successful |

### Configuration Example

To audit a service that is running on [local](http://localhost:8020/users) to the ***tracing*** endpoint [local](http://localhost:8020/logstash) in an application, you must perform the following configuration:

Create the ***tracing-interceptor.config.ts*** file in a ***config*** folder (configuration pattern adopted by the Front-end Architecture) and export a configuration variable that will be used to configure the module.

``` TS
//tracing-interceptor.config.ts
import { Injectable } from '@angular/core';
import { of, Observable } from 'rxjs';

import { tracingResponsePlaceholder, tracingEncryptedResponsePlaceholder, TracingInterceptorConfig, TracingMiddleware } from '@afe/http-interceptors/tracing';

@Injectable({ providedIn: 'root' })
class ExampleTracingMiddleware implements TracingMiddleware {

    constructor(private readonly middlewareManagerService: MiddlewareManagerService) { }

    public handle(): Observable<unknown> {
        return of({
            url: tracingResponsePlaceholder.url,
            requestId: tracingResponsePlaceholder.id,
            httpVerb: tracingResponsePlaceholder.httpVerb,
            requestDuration: tracingResponsePlaceholder.duration,
            statusCode: tracingResponsePlaceholder.httpStatusCode,
            encryptedURL: tracingEncryptedResponsePlaceholder.url,
            httpMessage: tracingResponsePlaceholder.httpStatusMessage,
            httpEncryptedMessage: tracingEncryptedResponsePlaceholder.httpStatusMessage,
            appContext: {
                useClass: true,
                currentMiddleware: 'class',
            },
        });
    }
}

export const tracingInterceptorConfig: TracingInterceptorConfig = {
    httpInterval: 6000,
    tracingEndpoint: 'http://localhost:8020/logstash',
    urlsToAudit: [ 'http://localhost:8020/users' ],
    urlsToIgnore: [],
    middleware: ExampleTracingMiddleware,
};
```

Import the exported variable and pass it as a parameter to the module's ***forRoot*** method.

``` TS
//app.module.ts
// Demais importações omitidas
import { TracingInterceptorModule } from '@afe/http-interceptors/tracing';
import { tracingInterceptorConfig } from '<caminho-do-arquivo-de-configuração>/tracing-interceptor.config';

@NgModule({
    imports: [
        TracingInterceptorModule.forRoot(tracingInterceptorConfig)
    ],
})
export class AppModule { }
```

> The ***tracingEndpoint*** used is dynamic, that is, it must be created by the team responsible for the project.

## Implementation

The configuration and import of the module is enough for the necessary interception to occur for the requests made by Angular's ***HTTPClient*** .
