# What's New in @afe/tagging version 2.x.x

With its new version **2.x.x** released, **Tagging** now supports **Angular 8 and 10**.

## Prerequisites

- Be using the ***1.x.x*** version of ***@afe/tagging***

## What's New

### Add public methods ***isDataLayerAvailable*** and ***isDynatraceAvailable***

The newly added methods are available through ***TaggingGtmConnector*** and ***TaggingDynatraceConnector***, respectively.

They were architected to bring greater resilience to the application, as they allow you to verify that the script used by the connectors is ready for use before performing actions that use it.

| Method | Description |
| ------------- | ------------- |
| isDataLayerAvailable: ***boolean*** | checks if the ***dataLayer*** object is available in the ***window*** |
| isDynatraceAvailable: ***boolean*** | Checks if the ***dtrum*** object is available in ***window*** |

```javascript
import { Component, OnInit } from '@angular/core';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {

    constructor(
        private taggingDynatraceConnector: TaggingDynatraceConnector,
        private taggingGtmConnector: TaggingGtmConnector
    ) { }

    public ngOnInit(): void {
        if( this.taggingDynatraceConnector.isDynatraceAvailable() ){
            // implementação do conector...
        }

        if( this.taggingGtmConnector..isDataLayerAvailable() ){
            // implementação do conector...
        }
    }
}
```
