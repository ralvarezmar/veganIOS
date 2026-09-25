# Implementation

To perform tagging, you need to inject ***TaggingService*** as a dependency into your component or service and call the ***tag()***.

``` TS
import { TaggingService } from '@afe/tagging';

@Component()
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
      this.taggingService.tag({
        // objeto com as propriedades que serão enviados para o GTM
      });
    }
}
```

Listed below are several ways to send events to GTM.

## Sending ***pageviews*** to the ***dataLayer***

When a page is viewed by the user, without interaction with any element present on the screen, the Google Tag Manager expects this event to be of type ***pageView***.

We can use ***TaggingEventEnum*** which already provides us with the values ***PAGE_VIEW*** and ***INTERACTION*** at the time of tagging the event to inform the type of event that is being sent.

``` TS
import { Component, OnInit } from '@angular/core';
import { TaggingService, TaggingEventEnum } from '@afe/tagging';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event: TaggingEvent = {
            event: TaggingEventEnum.PAGE_VIEW,
            page: document.location.pathname // recupera a rota da aplicação
            title: 'Página Inicial',
        }

        this.taggingService.tag(event);
    }
}
```

## Sending ***events*** to the ***dataLayer***

When an interaction occurs on the part of the user (whether directly or not), the ***Google Tag Manager*** expects this event to be of type ***INTERACTION***

Such an event can contain the following properties:

Property | Type | Description
----------- | ---- | ----------
**event** | ***string*** | Type of event that was triggered. The default value is ***pageviewGA***;
**page** - ***optional*** | ***string*** | Route of the application that was accessed. It can be retrieved via the javascript property ***document.location.pathname*** ;
**title** - ***optional*** | ***string*** | Title of the page accessed.
**action** | ***string***| Action taken by the user. (e.g. ***click***, ***visualization***, ***selection***, ***scroll***, ***touch*** and ***keypress***)
**event_name** | ***string***| Name of the conversion event according to the channel's journey. For more information, go to [conversion events](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=728485634#GA4RetaggingEventosdeConvers%C3%A3oNeg%C3%B3cio-topo)
**category** - ***optional*** | ***string*** | Identifies the overall category of the event
**label** - ***optional*** | ***string*** | Identifies the element that the user interacted with
**nonInteraction** - ***optional*** | ***Boolean*** | Indicates whether the user interaction was directly with the **customDimensions** - ***optional*** | ***Object*** | Extra information regarding the event to be sent to the GTM platform. It's a **wildcard** field to add any type of data that the channel deems relevant.

> The data sent inside the ***customDimensions*** object can be changed depending on the type of event that was interacted with (e.g. **post**, **stories**, etc). For more information on when and which to use, go to the [GTM documentation](https://confluence.santanderbr.corp/display/TAGSBR/Tagueamento+NOW)

``` TS
import { Component, OnInit } from '@angular/core';
import { TaggingService, TaggingEventEnum } from '@afe/tagging';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event = {
            event: TaggingEventEnum.INTERACTION,
            customDimensions: {
                category: 'now:timeline:post',
                postId: 12,
                originalPostId: 12,
                postKeywords: ['post', 'gtm']
            },
            page: '/gtm',
            title: 'tagging-gtm',
            category: 'conectores',
            action: TaggingActionEnum.CLICK,
            label: 'modal:botao:(enviar)',
            nonInteraction: false
        }

        this.taggingService.tag(event);
    }
}
```

## Sending GA4 events to the ***dataLayer***

To send a media event and work with Google Analytics 4 events, we must set the 'isMediaEvent' property to 'true'. Once this property is enabled, any information that is added to the object will be sent to the DataLayer without any changes.

``` TS
import { Component, OnInit } from '@angular/core';
import { TaggingService, TaggingEventEnum } from '@afe/tagging';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event = {
            event: TaggingEventEnum.INTERACTION,
            page: '/gtm',
            isMediaEvent: true,
            event_name: 'cvs_consorcio',
            banner_id: 23563,

        }

        this.taggingService.tag(event);
    }
}
```

## Sending ***customData*** to ***dataLayer***

The **Custom Data** is an object that contains information about products, users, and/or business needs that are present on the page.

To send it, it is necessary to call the ***sendCustomData()*** method of ***TaggingGtmConnector***, passing a ***object*** as a parameter.

``` TS
import { Component, OnInit } from '@angular/core';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingGtmConnector: TaggingGtmConnector) { }

    public ngOnInit(): void {
        const customData = {
            user: {
                logged: true,
                id: 'ABCDE12345',
                type: 'PF',
                primarySegment : 'Van Gogh',
                secondarySegment: 'OT',
                saude: 'positivo'
            },
            page: {
                customURL: '/hotsite/step1',
                internalCampaign: 'banner-promocao-cartoes-home-portal',
                category: 'portal'
            },
            product: {
                brand: 'santander',
                category: 'capitalizacao',
            }
        };

        this.taggingGtmConnector.sendCustomData(customData);
    }
}
```

## Sending ***errors*** to the ***dataLayer***

When an event is triggered due to an error in the interface or application, it is possible to send it to the GTM platform, passing the ***isError*** parameter as ***true*** in the object to be sent to the connectors.

``` TS
import { Component, OnInit } from '@angular/core';
import { TaggingService, TaggingGtmConnector, TaggingEventEnum } from '@afe/tagging';
import { HttpClient } from '@angular/http'

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {
    constructor(
        private httpClient: HttpClient,
        private taggingService: TaggingService,
        private taggingGtmConnector: TaggingGtmConnector
    ) { }

    public ngOnInit(): void {
        this.httpClient.get(urlConfig.urlSSO)
        .subscribe(
            (response) => {
                this.taggingGtmConnector.sendCustomData({...response});
            },
            (err) => {
                this.taggingService.tag({
                    page: '/',
                    title: 'tagging-gtm',
                    event: TaggingEventEnum.PAGE_VIEW,
                    isError: true
                });

                return throwError(err);
            }
        );
    }
}
```

## Sending application information to the ***dataLayer***

Google Analytics expects some information about the application as soon as it starts, such as hostname and environment type. To send this information as soon as the application is run.

We recommend creating a provider in the application's ***app.module.ts*** by sending the necessary data with the ***sendCustomData()*** method of the ***TaggingGtmConnector***.

``` TS
import { TaggingModule } from '@afe/tagging';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';
import { APP_INITIALIZER, NgModule } from '@angular/core';

export function appInitilizerGtm(taggingGtmConnector: TaggingGtmConnector): Function {
    return () => {
        taggingGtmConnector.sendCustomData({
            page: {
                domain: document.location.hostname,
                homolog: true
            }
        });
    };
}

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
        ...
    ],
    providers: [
        {
            provide: APP_INITIALIZER,
            useFactory: appInitilizerGtm,
            deps: [TaggingGtmConnector],
            multi: true
        },
    ],
    ...
})
export class AppModule { }

```

> For more information, dig deeper into the [InjectionToken APP_INITIALIZER](https://angular.io/api/core/APP_INITIALIZER) documentation

## Creating Middleware to Add Specific Properties

GTM follows a **pre-defined** interface of data that will be sent to the ***dataLayer*** and some properties are platform-specific.

Some of them already exist in the event, but with different names, such as ***nonInteraction*** and ***label***, which have their equivalents in the ***isDirectInteraction*** and ***element***, respectively.

Therefore, it is possible to create a **middleware** to check for the existence of these properties and add them to the event that will be sent to the connectors.

To ensure that the GTM connector receives the event following its TaggingGtmActionEvent interface, you can create middleware that returns an `Observable<TaggingGtmActionEvent>`

``` TS
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TaggingMiddleware } from '@afe/tagging';
import { TaggingGtmActionEvent } from '@afe/tagging/gtm-connector';

export interface CustomEvent extends TaggingGtmActionEvent {}

/**
 * Middleware to configure the event to meet the ***TaggingGtmActionEvent*** interface
 */
@Injectable({
    providedIn: 'root',
})
export class TaggingGtmMiddleware implements TaggingMiddleware {
    public handle(originalEvent: CustomEvent): Observable<TaggingGtmActionEvent> {

        let handledEvent: TaggingGtmActionEvent = {
            ...originalEvent, // spread operator para enviar todas as propriedades do evento
            nonInteraction: typeof(originalEvent.nonInteraction) === 'undefined' ? !originalEvent.isDirectInteraction  : originalEvent.nonInteraction,
            label: !originalEvent.label  ? originalEvent.element : originalEvent.label,
            action: originalEvent.action === TaggingActionEnum.CLICK ? 'clicou' : originalEvent.action
        };

        return of(handledEvent);
    }
}
```

And configure in the configuration file from tagging library.

``` TS
//tagging.middleware.ts
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TaggingMiddleware } from '@afe/tagging';
import { TaggingGtmActionEvent } from '@afe/tagging/gtm-connector';

export interface CustomEvent extends TaggingGtmActionEvent {}

/**
 * Middleware to configure the event to meet the ***TaggingGtmActionEvent*** interface
 */
@Injectable({
    providedIn: 'root',
})
export class TaggingGtmMiddleware implements TaggingMiddleware {
    public handle(originalEvent: CustomEvent): Observable<TaggingGtmActionEvent> {

        // tipa o evento como sendo TaggingGtmActionEvent
        let handledEvent: TaggingGtmActionEvent = {
            ...originalEvent
        };

        // verifica se a propriedade nonInteraction não está definida no evento
        if( typeof(handledEvent.nonInteraction) === 'undefined' ){
            // atribui o valor da negação de isDirectInteraction a propriedade nonInteraction
            handledEvent.nonInteraction = !handledEvent.isDirectInteraction;
        }

        // verifica se a propriedade label não existe no evento
        if( !handledEvent.label ){
            // atribui o valor da propriedade element a propriedade label
            handledEvent.label = handledEvent.element;
        }

        // retorna o evento tratado
        return of(handledEvent);
    }
}
```
