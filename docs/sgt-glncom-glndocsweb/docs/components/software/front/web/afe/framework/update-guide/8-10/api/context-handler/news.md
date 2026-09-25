# What's New in @afe/context-handler version 3.x.x

With its new version **3.x.x** released, the **Context Handler** now supports **Angular 8 and 10**.

## Prerequisites

- Be using the ***2.x.x*** version of ***@afe/context-handler***

## What's New

### Implementation of the ***middleware*** as `Array<Type>` of ***classes***

The implementation of the middleware configuration was rethought to use an Injectable class model, due to internal standardization of the architecture. In this way, it receives a ***Array*** of ***Type*** of classes instead of functions.

```javascript
import { Middleware, MiddlewareParams } from '@afe/context-handler';
import { Injectable, Type } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ClassMiddleware implements Middleware {
    public handle(params: MiddlewareParams<any>): Observable<unknown> {
       // implementação do middleware
    }
}

export const CONTEXT_MIDDLEWARES: Array<Type<Middleware>> = [
    ClassMiddleware,
];

export const contextHandlerConfig: ContextHandlerConfig = {
    middlewares: CONTEXT_MIDDLEWARES,
};
```
