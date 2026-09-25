# Tagging (Angular 18)

## Prerequisites

- There are no Prerequisites.

## Installing

``` BASH
npm install @afe/tagging@^18 --save
```

## Configuration

To configure the ***@afe/tagging*** just import it in the application main module.
The ***forRoot*** method receives an object of type ***TaggingConfig***, which has the following properties:

| Property | Description |
| ----------- | --------- |
| **connectors**: ***`Array<Type<TaggingConnector>>`*** | They have the tagging logic for some platform of the platforms available via the ***tag*** method. See more in [Connectors](./connectors/index.md) |
| **middlewares**: ***`Array<Type<TaggingMiddleware>>`*** (***optional***) | They execute a logic of treatment of the event sent to the platforms through ***handle*** method. See more in [Middlewares](./middlewares.md); |

``` TS
//tagging.config.ts
import { TaggingRootConfig } from '@afe/tagging';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';

export const taggingConfig: TaggingRootConfig = {
    connectors: [
      TaggingGtmConnector,
    ]
};
```

> To use the library, it is necessary to configure at least one [connector](./connectors/index.md), where ***TaggingGtmConnector***, was used as an example.

``` TS
//app.module.ts
import { NgModule } from '@angular/core';
import { TaggingModule } from '@afe/tagging';
import { taggingConfig } from 'config/tagging.config';

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
    ],
})
```

## Implementation

Once the initial configuration is done, just use the method available for use, as shown in the following example:

``` TS
//example.component.ts
import { Component } from '@angular/core';
import { TaggingService, TaggingInteractionEvent, TaggingEvent, TaggingEventEnum, TaggingActionEnum } from '@afe/tagging';

export class CustomTaggingEvent extends TaggingInteractionEvent {
    public data: unknown;
}

@Component({
    templateUrl: ***
        <button (click)="onClick()">Tag</button>
    ***,
})
export class ExampleComponent implements OnInit {
    constructor(
        private taggingService: TaggingService
    ) { }

    public ngOnInit(): void {

        const event: TaggingInteractionEvent = {
            event: TaggingEventEnum.PAGE_VIEW,
            action: TaggingActionEnum.VIZUALIZATION,
            element: 'div',
            isDirectInteraction: false,
            page: '/home',
            title: 'initialPage',
        };
        this.taggingService.tag(event);
    }

    public onClick(): void {
        const event: CustomTaggingEvent = {
            event: TaggingEventEnum.PAGE_VIEW,
            action: TaggingActionEnum.CLICK,
            element: 'button',
            isDirectInteraction: true,
            page: '/purchase',
            title: 'purchaseApp',
            data: {
                customData: 'exemplo'
            }
        };
    }
}
```
