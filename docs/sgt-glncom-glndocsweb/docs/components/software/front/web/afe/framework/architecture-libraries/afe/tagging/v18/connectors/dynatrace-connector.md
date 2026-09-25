# Dynatrace Connector

The **Dynatrace Connector** allows you to send events to the [Dynatrace Santander](https://dynatraceweb.dcbr01.corp/) dashboard

## Prerequisites

- Installing [@afe/tagging](../index.md)

## Configuration

### Implementation of the Dtrum API script for development

In order to use this connector, the Dtrum API that contains methods that connect to the Dynatrace platform must be available in the *window*. At deployment time, a reference to this script is injected into the application's ***index.html*** file.

However, at development time it is necessary to include it manually, preferably in a place that is not part of the *build* to be part of the generated *package*.

To do this, create the following file ***assets/scripts/dtrum.js*** (NOTE: both the path and the file name are an example/suggestion)

> **The contents of the file must be obtained from the team responsible for Dynatrace.**

With the file created and its contents defined, you will need to configure in the ***angular.json*** to include the ***script reference***, only at run time, in the ***index.html*** of the application.

To do this, we'll create a local build configuration to consume external scripts while running serve.

Inside the ***configurations*** property in ***build*** assign to the local property an object with the **scripts** property, which receives a string list containing the path to the ***.js*** files used in the project along with the ***dtrum.js*** file.

Finally, configure the ***browserTarget*** in ***options*** within the ***serve*** property to call the local configuration created, as shown in the example below:

> The variable `<name-of-project>` refers to the respective value of your project.

``` JSON
{
    "projects": {
        "<name-of-project>": {
            "architect": {
                "build": {
                    "builder": "@angular-devkit/build-angular:browser",
                    "options": {
                        "scripts": [
                            "src/assets/scripts/bootstrap.js",
                            "src/assets/scripts/utils.js",
                        ]
                    },
                    "configurations": {
                        "local": {
                            "scripts": [
                                "src/assets/scripts/utils.js",
                                "src/assets/scripts/dtrum.js",
                                "src/assets/scripts/bootstrap.js",
                            ]
                        }
                    }
                },
                "serve": {
                    "options": {
                        "browserTarget": "<nome-do-projeto>:build:local"
                    }
                }
            }
        }
    }
}
```

## Configuration Example

Create a file named ***tagging.config.ts*** and export a constant called ***taggingConfig*** that implements the ***TaggingConfig*** configuration interface.

In the ***connectors*** property, add the ***TaggingDynatraceConnector*** item from the ***@afe/tagging/dynatrace-connector*** package.

In the **connectors** property of the ***TaggingModule*** module configuration, add the ***TaggingDynatraceConnector***.

``` TS
//tagging.config.ts
import { TaggingConfig } from '@afe/tagging';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';

export const taggingConfig: TaggingConfig = {
  connectors: [
    TaggingDynatraceConnector,
  ],
};
```

> For more information, see the documentation on [connectors](./index.md).

In the main module of the application, Import the exported configuration variable and pass it as a parameter of the ***forRoor*** method of the ***TaggingModule***.

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

Methods available via the ***TaggingDynatraceConnector*** class

Method | Parameters | Description
--------- | ------------ | -----------
**tag()**: ***void*** | event:? | Register the event on the [Dynatrace Santander](https://dynatraceweb.dcbr01.corp/) platform
**identifyUser()**: ***void*** | userIdentification: ***string*** | Performs user identification in the active session
**actionName()**: ***void***|actionName: ***string***, actionId?: ***number*** | Sets the **actionName** of an event before it is sent to the Dynatrace platform
**sendSessionProperties()**: ***void***| javaLong?: SessionPropertyMap\<number>, date?: SessionPropertyMap\<Date>, shortString?: SessionPropertyMap`<string>`, javaDouble?: SessionPropertyMap\<number> | Sends supplemental data to be added to the current user's session
**endSession()**: ***void***| ***N/A*** | Sends a signal to the Dynatrace platform to end the current session
**isDynatraceAvailable()**: ***boolean*** | ***N/A*** | Checks if the ***dtrum*** object is available in the window

> The call of the ***tag*** method should not be made directly by this class, but through the ***tag*** method of the ***TaggingService*** class

### Implementation

#### Sending an event to Dynatrace

The ****tag*** method of the ***TaggingDynatraceConnector*** expects to receive an object that follows the ***TaggingDynatraceEvent*** interface by calling the ***tag*** method of the ***TaggingServive*** class.

The TaggingDynatraceEvent interface has the following attributes:

|Property|Type|Description|
|-|-|-|
***event***|***string***|Name of the action to be registered
***action***|***string***|What action was performed (e.g. click, scroll, touch and keypress)|
***properties***|***Object***|Optional object containing properties to add to the action record. See more at [Adding properties to an action]
***startTime***|***number***|Optional time in milliseconds that the event started. If it is not set, the event creation timestamp|
***stopTime***|***number***|Optional time in milliseconds that the event ended. If it is not defined, the timestamp of sending the event to the platform

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingService } from '@afe/tagging';
import { TaggingDynatraceEvent } from '@afe/tagging/dynatrace-connector';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event: TaggingDynatraceEvent = {
            event: 'Teste Dynatrace',
            action: TaggingActionEnum.VIZUALIZATION,
        };
        this.taggingService.tag(event);
    }
}
```

Since the typing of the ***tag*** method of the ***TaggingService*** class is open (***unknown***), to ensure that the Dynatrace connector receives the event while respecting the ***TaggingDynatraceEvent*** interface.

It is possible to create a ***middleware*** that returns an `Observable<TaggingDynatraceEvent>` and configure it in the ***middlewares*** property of ***TaggingConfig***.

``` TS
//tagging-dynatrace-middleware.ts
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TaggingMiddleware } from '@afe/tagging';
import { TaggingDynatraceEvent } from '@afe/tagging/dynatrace-connector';

export interface CustomEvent {
    customEvent: string;
    customAction: string;
    customData: { [key: string]: string };
}

/**
* Middleware para configurar o evento para atender a interface ***TaggingDynatraceEvent***
*/
@Injectable({
    providedIn: 'root',
})
export class TaggingDynatraceMiddleware implements TaggingMiddleware {

    public handle(originalEvent: CustomEvent): Observable<TaggingDynatraceEvent> {

        const handledEvent: TaggingDynatraceEvent = {
            ...originalEvent,
            event: originalEvent.customEvent,
            action: originalEvent.customAction,
        };

        if (originalEvent.customData !== undefined) {
          handledEvent.properties = originalEvent.customData
        }

        return of(handledEvent);
    }

}
```

> We use the **spread operator**, because we want to send the entire event to the connectors, adding or changing only the properties that will be defined later.
>
> For more information, see the documentation on [middleware deployment](../middlewares.md).

#### Identifying the Session User

When a user session is created on the Dynatrace platform, by default, its identification is as **anonymous** + generated ID.

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';
import { AuthService } from '../services/auth.service';
import { User } from '../models/user.model';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private authService: AuthService) { }

    public ngOnInit(): void {
        this.authService.authenticate()
            .subscribe((userData: User) => {
                this.taggingDynatraceConnector.identifyUser(user.userName);
            });
    }
}
```

In this case, the name of the session user will be whatever comes in the return of the authentication service.

#### Overriding the page load actionName

By default, the actionName of the loading event is ***loading of page [[page path]]***.

```ts
// app.module.ts
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { TaggingModule } from '@afe/tagging';
import { taggingConfig } from '<caminho-do-arquivo-de-configuração>/tagging.config';

export function appInitilizer(taggingDynatraceConnector: TaggingDynatraceConnector): Function {
    return () => {
        taggingDynatraceConnector.actionName('Custom Load ActionName');
    };
}

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
    ],
    providers: [
        {
            provide: APP_INITIALIZER,
            useFactory: appInitilizer,
            deps: [TaggingDynatraceConnector],
            multi: true,
        },
    ],
})
```

In this case, the ActionName will be ***Custom Load ActionName***.

> The ***actionName*** method call must be executed before any other action (request, ***tag*** method call).
>
> One suggestion is to run using the [*InjectionToken APP_INITIALIZER*](https://angular.io/api/core/APP_INITIALIZER) configuration

#### Overwriting the actionName of http requests

By default, the actionName of the http request event is the request URL itself.

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';
import { ExampleService } from '../services/example.service';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(
        private exampleService: ExampleService,
        private taggingDynatraceConnector: TaggingDynatraceConnector) { }

    public ngOnInit(): void {
        this.exampleService.exampleHttpRequest()
            .subscribe(() => {
                this.taggingDynatraceConnector.actionName('Custom Http Request ActionName');
            });
    }
}
```

In this case, the ActionName will be ***Custom Http Request ActionName***.

> The ***actionName*** method call should be executed immediately after the request responds.

#### Adding properties to an action

Dynatrace allows complementary data to be included in an action, through a JSON Object with key and value. To do this, the event to be sent by the Dynatrace connector must contain the ***properties*** property

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingService } from '@afe/tagging';
import { TaggingDynatraceEvent } from '@afe/tagging/dynatrace-connector';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingService: TaggingService) { }

    public ngOnInit(): void {
        const event: TaggingDynatraceEvent = {
            event: 'Teste Dynatrace',
            action: TaggingActionEnum.VIZUALIZATION,
            properties: {
                name: 'Teste Dynatrace'
            }
        };
        this.taggingService.tag(event);
    }
}
```

> All keys must be previously configured in the Application within the Dynatrace platform, otherwise they will not be registered

#### Submitting Properties to a Session

Dynatrace allows complementary data to be included in a session, through a JSON Object with key and value. It is recommended to use the third parameter, as the values are of type ***string***.

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingDynatraceConnector: TaggingDynatraceConnector) { }

    public ngOnInit(): void {
        const sessionPropertiesObj: { [key: string]: string } = {
            name: 'Teste Dynatrace'
        };
        this.taggingDynatraceConnector.sendSessionProperties(null, null, sessionPropertiesObj, null);
    }
}
```

> All keys must be previously configured in the Application within the Dynatrace platform, otherwise they will not be registered

#### Ending the user's session

A user session can be terminated in the following ways:

- Downtime of more than 30 minutes
- Close the browser window
- Execution of more than 200 *actions* (in this case a linked session will be created in the one that was closed)
- Calling the *endSession method***

```ts
import { Component, OnInit } from '@angular/core';
import { TaggingDynatraceConnector } from '@afe/tagging/dynatrace-connector';

@Component({
  selector: 'example',
})
export class ExampleComponent implements OnInit {

    constructor(private taggingDynatraceConnector: TaggingDynatraceConnector) { }

    public ngOnInit(): void {
        this.taggingDynatraceConnector.endSession();
    }
}
```

> The next **action** will be created in a different session than the previous one
