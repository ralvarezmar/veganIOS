# Connectors

**Tagging** is able to connect to various tagging platforms through connectors (e.g. DynaTrace, GTM), whether they are already integrated into the part or created in the application itself.

## Prerequisites

- Installing [@afe/tagging](../index.md)

## Connectors

Connector | Description
--------- | --------------------------
[GTM Connector](./gtm-connector.md) | It allows you to send events executed on the page, thus making it easier for Google Tag Manager to capture them.
[Dynatrace Connector](./dynatrace-connector.md) | Allows you to send events to the [Dynatrace Santander](https://dynatraceweb.dcbr01.corp/) dashboard

## Configuration

The ***forRoot()*** method of TaggingModule takes as a parameter a property called **config**, which has a connectors attribute that expects an `Array<TaggingConnector><Type>` where each item must be a class that implements the TaggingConnector interface.

``` TS
//tagging.config.ts
import { TaggingRootConfig } from '@afe/tagging';
import { TaggingCustomConnector } from './example-connector.config';

export const taggingConfig: TaggingRootConfig = {
    connectors: [
        TaggingCustomConnector,
    ],
};
```

``` TS
//app.module.ts
import { NgModule } from '@angular/core';
import { TaggingModule } from '@afe/tagging';
import { taggingConfig } from '<caminho-do-arquivo-de-configuração>/tagging.config';

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
    ],
})
```

## Methods

Methods | Parameters | Description
--------- | ---------- | --------------------------
tag: ***void*** | event: ***TaggingEventType*** | Performs tagging on the platform to which this connector communicates

### Implementation

#### Custom Connector

``` TS
//example-connector.config.ts

import { Injectable } from '@angular/core';
import { TaggingConnector } from '@afe/tagging';

/**
 *  Connector of Custom Mock Tagging that emites events in the window
 */
@Injectable({
    providedIn: 'root',
})
export class TaggingCustomConnector implements TaggingConnector {

    public tag(event: unknown): void {
        const customConnevent = new CustomEvent('CustomConnector', {
            detail: event,
        });
        dispatchEvent(customConnevent);
    }

}
```

If you execute the ***tag(event)*** of ***TaggingService*** it's executed the method ***tag(event)*** at each connector.

> Important: the connector must necessarily be an Injectable, either using the ***provideIn*** attribute as in the example above or being provided in some application module.
