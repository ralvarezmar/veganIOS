# What's New in @afe/http-interceptors version 2.x.x

With its new version **2.x.x** released, **Encryption** now supports **Angular 8 and 10**.

## Prerequisites

- Be using ***1.x.x*** version of ***@afe/http-interceptors***.

## What's New

### Add middleware property

Currently the configuration passed in the ***forRoot*** method of the ***TracingInterceptorModule***, following the ***TracingInterceptorConfig*** interface, has the ***tracingFn*** property that expects to receive a function.

However, the ***tracingFn*** property has been deprecated, and the implementation is now through the ***middleware*** property, which expects to receive a class.

```diff
import { Injector, Injectable } from '@angular/core';
import { of } from 'rxjs';

- import { TracingInterceptorConfig } from '@afe/http-interceptors';
+ import { TracingInterceptorConfig, TracingMiddleware } from '@afe/http-interceptors';

- export function tracingFn(injector: Injector) {
-    return of({
-        // código omitido
-    });
- }

+ @Injectable({ providedIn: 'root' })
+ class TracingMiddlewareClass implements TracingMiddleware {
+    public handle(): Observable<unknown> {
+        return of({
+            // código omitido
+        });
+    }
+ }

const tracingInterceptorConfig: TracingInterceptorConfig = {
-   tracingFn: tracingFn
+   middleware: TracingMiddlewareClass
};
```

> Because of the new configuration form, the property ***tracingFn*** was deprecated.
