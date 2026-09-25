# GTM Connector

The GTM Connector allows you to send events that run on the page, making it easier for Google Tag Manager to capture them.

## Prerequisites

- Installing [@afe/tagging](../../index.md)

### GTM (Google Tag Manager) Configuration

To use the GTM connector, you need to import the **index.html*script**** below into your application's ***script*** inside the `<head>` tag, replacing **GTM-XXXXXX** with the tag manager code.

``` HTML
<!-- index.html -->

<html lang="pt-br">
<head>
  <!-- Código omitido -->

  <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-XXXXXX');</script>
    <!-- End Google Tag Manager -->
</head>
<body>
  <app-root></app-root>
</body>
</html>
```

### Content Security Policy (CSP) Configuration

**Content Security Policy** is a header that aims to prevent the user from entering an external resource from a domain other than the application domain, preventing [XSS](https://jira.santanderbr.corp/browse/ARQFECCBR-1920) attacks.

In order for us to import the ***script*** from **Google Tag Manager** without running into this policy, we need to perform the following configuration:

Add the addresses that are requested by GTM in the existing CSP headers in the ***conf.d/app.conf*** file:

Url | Resource
--------- | ------------
***<https://www.google-analytics.com>***, ***<https://www.google.com>***, ***<https://www.google.com.br>***, ***<https://stats.g.double-click.net>*** | **img-src**
***<https://www.google-analytics.com>***, ***<https://www.googletagmanager.com>*** | **script-src**

The example below should be added to the headers already configured in your ***app.conf***.

``` BASH
# conf.d/app.conf

# Configuração do location obtida por variável de ambiente
location ${NGINX_APP_LOCATION} {
    # Código omitido

    location ~* ^.+.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|json|svg)$ {
        # Código omitido
        add_header "X-Content-Security-Policy" "script-src 'self' blob: https://www.google-analytics.com https://www.googletagmanager.com; img-src 'self' blob: https://www.google.com https://www.google.com.br https://www.google-analytics.com https://stats.g.double-click.net data:;";
        add_header "Content-Security-Policy" "script-src 'self' blob: https://www.google-analytics.com https://www.googletagmanager.com 'unsafe-inline' 'unsafe-eval'; img-src 'self' blob: https://www.google.com https://www.google.com.br https://www.google-analytics.com https://stats.g.double-click.net data:;";
    }
}
```

> For more information about CSP, please see our documentation on [Content Security Policy]. /.. /.. /.. /Tutorials/Practices%20of%20Security/content-security-policy.md).

## Usage

### Configuration

In the **connectors** property of the ***TaggingModule*** module configuration object, import the ***TaggingGtmConnector*** from the ***@afe/tagging*** package.

> See more at [Connectors](../connectors/index.md)

``` TS
import { TaggingConfig } from '@afe/tagging';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';

export const taggingConfig: TaggingConfig = {
    connectors: [
        TaggingGtmConnector,
    ],
};
```

And configure the ***TaggingModule*** in the main module of your application:

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

### Methods

Method | Parameters | Description
--------- | ------------ | -----------
**tag()**: ***void*** | event: ***unknown*** | Sends the event to the global data layer
**sendCustomData()**: ***void*** | event: ***Object*** | Sends extra, customized data to the global data layer
**isDataLayerAvailable()**: ***boolean*** | ***N/A*** | checks if the ***dataLayer*** object is available in the window

> The call of the ***tag*** method should not be made directly by this class, but by calling the ***tag*** method of the ***TaggingService*** class

### Implementation

#### Sending application information to the dataLayer

Google Analytics expects some information about the application as soon as it starts, such as hostname and environment type. To send this information before the application runs.

We recommend creating a provider in the application's ***app.module.ts*** by sending the necessary data with the ***sendCustomData()*** method of the ***TaggingGtmConnector***.

```typescript
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
    declarations: [
        ...
    ],
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

#### Sending ***pageviews*** to the dataLayer

When a page is viewed by the user, without interaction with any element present on the screen, ***GTM*** identifies this event as an event of type ***pageview*** and expects to receive an object that follows the interface of type ***TaggingEvent***.

The TaggingEvent interface has the following attributes:

Property | Type | Description
----------- | ---- | ---------
**event** | ***string*** | Type of event that was triggered. The default value is ***pageviewGA***;
**page** - ***optional*** | ***string*** | Route of the application that was accessed. It can be retrieved via the javascript property ***document.location.pathname*** ;
**title** - ***optional*** | ***string*** | Title of the page accessed.

```typescript
import { Component, OnInit } from '@angular/core';
import { TaggingService, TaggingEventEnum } from '@afe/tagging';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event = {
            event: TaggingEventEnum.PAGE_VIEW,
            page: '/gtm',
            title: 'tagging-gtm',
        }

        this.taggingService.tag(event);
    }
}
```

#### Sending ***events*** to the dataLayer

When an interaction occurs on the part of the user (whether direct or not), ***GTM*** captures this event as being of type ***eventGA***, which can contain the following properties:

Property | Type | Description
----------- | ---- | ----------
**event** | ***string*** | Type of event that was triggered. The default value is ***pageviewGA***;
**page** - ***optional*** | ***string*** | Route of the application that was accessed. It can be retrieved via the javascript property
***document.location.pathname*** ; **title** - ***optional*** | ***string*** | Title of the page accessed.
**action** | ***string***| Action taken by the user. (e.g. ***click***, ***visualization***, ***selection***, ***scroll***,
***touch*** and ***keypress***)
**category** - ***optional*** | ***string*** | Identifies the overall category of the event
**label** - ***optional*** | ***string*** | Identifies the element that the user interacted with
**nonInteraction** - ***optional*** | ***Boolean*** | Indicates whether the user interaction was directly with the
**customDimensions** - ***optional*** | ***Object*** | Extra information regarding the event to be sent to the GTM platform

The ***customDimensions*** property is a **wildcard** field for adding any type of data that the channel deems relevant.

Some examples of properties to be sent by this object are:

Property | Type | Description
----------- | ---- | ----------
**category** | ***string*** | Post Category
**action** | ***string*** | action performed by the user
**label**| ***string*** | identifier of the element that had interaction
**postId** | ***string***| Unique identifier per post **storiesId**
**originalPostId** | ***string*** | Identifier of the post assigned by the system
**postKeywords** | ***string*** | keywords related to the post (must be concatenated with ":" if there is more than one)
**commentMessage** | ***string*** | Comment made on the post

> The data sent inside the ***customDimensions*** object can be changed depending on the type of event that was interacted with (e.g. **post**, **stories**, etc). For more information on when and which to use, go to the [GTM documentation](https://confluence.santanderbr.corp/display/TAGSBR/Tagueamento+NOW)

```typescript
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

Since the typing of the ***tag*** method of the ***TaggingService*** class is open (***unknown***), to ensure that the GTM connector receives the event while respecting the ***TaggingGtmActionEvent*** interface.

It is possible to create a ***middleware*** that returns an `Observable<TaggingGtmActionEvent>` and configure it in the ***middleware*** property of ***TaggingConfig***.

```typescript
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TaggingMiddleware } from '@afe/tagging';
import { TaggingGtmActionEvent } from '@afe/tagging/gtm-connector';

export interface CustomEvent extends TaggingGtmActionEvent {}

/**
 * Middleware para configurar o evento de forma a atender a interface ***TaggingGtmActionEvent***
 */
@Injectable({
    providedIn: 'root',
})
export class TaggingGtmMiddleware implements TaggingMiddleware {
    public handle(originalEvent: CustomEvent): Observable<TaggingGtmActionEvent> {

        let handledEvent: TaggingGtmActionEvent = {
            ...originalEvent,
            nonInteraction: typeof(originalEvent.nonInteraction) === 'undefined' ? !originalEvent.isDirectInteraction  : originalEvent.nonInteraction,
            label: !originalEvent.label  ? originalEvent.element : originalEvent.label,
            action: originalEvent.action === TaggingActionEnum.CLICK ? 'clicou' : originalEvent.action
        };

        return of(handledEvent);
    }
}
```

> We use the **spread operator**, because we want to send the entire event to the connectors, adding or changing only the properties that will be defined later by the middleware.

#### Sending ***customData*** to the dataLayer

The **Custom Data** is an object that contains all the information about products, users, and/or business needs that are present on the page.

To send it, it is necessary to call the ***sendCustomData*** method of ***TaggingGtmConnector***, passing a ***object*** as a parameter.

```typescript
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

#### Sending ***errors*** to the dataLayer

When an event is triggered due to an error in the interface or application, it is possible to send it to the GTM platform, passing the ***isError*** parameter as ***true*** in the object to be sent to the connectors.

```typescript
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
        .pipe(
            flatMap((response) => {
                this.taggingGtmConnector.sendCustomData({
                    ...response // envio dos dados do usuário logado
                });
                return this.encryptionService.changeKeys();
            }),
            catchError( (err) => {
                this.taggingService.tag({
                    page: '/',
                    title: 'tagging-gtm',
                    event: TaggingEventEnum.PAGE_VIEW,
                    isError: true
                });

                return throwError(err);
            })
        )
        .subscribe(() => {
            this.encryptionIsInitialized = this.encryptionService.isInitialized();
        });
    }
}
```

#### Creating Middleware to Add Specific Properties

GTM follows a **pre-defined** interface of data that will be sent to the dataLayer and some properties are platform-specific.

Some of them already exist in the event, but with different names, such as ***nonInteraction*** and ***label***, which have their equivalents in the ***isDirectInteraction*** and ***element***, respectively.

Therefore, it is possible to create a **middleware** to check for the existence of these properties and add them to the event that will be sent to the connectors.

``` TS
//tagging.middleware.ts
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TaggingMiddleware } from '@afe/tagging';
import { TaggingGtmActionEvent } from '@afe/tagging/gtm-connector';

export interface CustomEvent extends TaggingGtmActionEvent {}

/**
 * Middleware para configurar o evento de forma a atender a interface ***TaggingGtmActionEvent***
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

> See more in [Middleware](../middlewares.md)

### Good practices

The **Google Tag Manager** follows its own taxonomy for the nomenclature of events to be sent to the platform.

It is necessary during development to carry out the proper treatment of this data in the ***middleware*** so that it correctly reaches the GTM connector or sends the event already with the specified conventions.

Some of these conventions are listed below:

#### Name of events

The names of the events to be sent (***pageview***, ***event***) are handled by the connector itself, which is in charge of making this abstraction and sending the data with the correct convention, so you just have to make sure that:

- **error** events are sent with the ***isError*** property as **true**, from this they will be renamed to ***errorGA***;
- **interaction** events must have the ***action*** property set, this way it will be reset to ***eventGA***;
- If none of these conditions are met, the connector treats the event as a **pageView** event and converts to ***pageviewGA***;

#### ***actions*** interface

The ***actions*** of the event must be described with an action in the past tense (e.g. **click**, **filled**, etc)

```typescript
this.taggingService.tag({
    page: '/gtm',
    title: 'tagging-gtm',
    event: TaggingEventEnum.INTERACTION,
    action: 'clicou'
});
```

> Events of type ***onClick*** have the value of the action as ***clicked***, while ***onBlur*** receive as the value ***filled***.

#### Event data in minuscule

Another business rule in the GTM taxonomy is to send all information about the event in the format **lowercase** and with the words **separated by hyphen** instead of spaces.

```typescript
this.taggingService.tag({
    page: '/gtm',
    title: 'tagging-gtm',
    category: 'afe:tagging-gtm-connector',
    event: TaggingEventEnum.INTERACTION,
    action: 'clicou',
    isDirectInteraction: true,
    element: ***button:logar***,
});
```

#### Collection Maps

The information that will be **filled in** is passed by the **Data Insights** team through the **collection maps**.

A **functionality** map that describes the **flows** and **actions**, so that the person responsible for developing it can carry out the implementation.

Some examples of implementation in the most diverse channels are available in the confluence of the GTM team itself.

> See examples in [collection maps](https://confluence.santanderbr.corp/display/TAGSBR/Mapas+de+Coleta)

#### Validating data via ***window.dataLayer***

It is recommended to validate the information that is being added to the global data layer to be sure that the events will reach the platform correctly.

To perform the validation locally, simply open your browser's developer tool and in the **console** tab type ***window.dataLayer*** to access the array of objects that will be sent to GTM.
