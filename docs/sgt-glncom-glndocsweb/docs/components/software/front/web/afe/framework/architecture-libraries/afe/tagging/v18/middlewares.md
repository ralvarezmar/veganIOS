# Middlewares

**Tagging**, before sending the data to the platforms through the Connectors, can **perform data processing** according to the need of the application, for this we use Middleware.

## Prerequisites

- Installing [@afe/tagging](../index.md)

## Configuration

The ***forRoot()*** method of ***TaggingModule*** receives as a parameter a property called ***TaggingConfig***.

Which has an optional attribute called **middleware** that expects to receive N classes that implement the ***TaggingMiddleware*** interface, responsible for handling the data and returning it to the structuring properly handled.

```typescript
// tagging.config.ts
import { TaggingConfig } from '@afe/tagging';
import { TaggingCustomMiddleware } from './example-middleware.config';
import { TaggingCustomConnector } from './example-connector.config';

export const taggingConfig: TaggingConfig = {
    connectors: [
        TaggingCustomConnector,
    ],
    middlewares: [
        TaggingCustomMiddleware
    ],
};
```

```typescript
// app.module.ts
import { NgModule } from '@angular/core';
import { TaggingModule } from '@afe/tagging';
import { taggingConfig } from '<caminho-do-arquivo-no-projeto>/tagging.config';

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
    ],
})
```

## Methods

Method | Parameters | Description
--------- | ---------- | --------------------------
handle: `Observable<TaggingEventType>` | event: ***TaggingEventType*** | Handles the event before it is sent to the tagging platforms ## Implementation

## Implementation

```typescript
// example-middleware.config.ts

import { Injectable } from '@angular/core';
import { TaggingEventType, TaggingMiddleware } from '@afe/tagging';
import { of } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class TaggingCustomMiddleware implements TaggingMiddleware {

    public handle(event: unknown): Observable<TaggingEventType> {
        return of({
            ...event,
            timestamp: new Date().getTime()
        })
    }

}
```

When you run the ***tag(event)*** method of ***TaggingService*** the ***handle(event)*** method is executed on each middleware, returning a new event to be sent to the platforms.

> **Attention**
>
> Necessarily the middleware must be an Injectable, either using the ***provideIn*** attribute as in the example above or being provided in some application module.
