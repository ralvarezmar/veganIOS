# What's New in @afe/websocket-action-runner 3.x.x

With its new version ***3.x.x*** released, Websocket Action Runner now supports Angular 8 and 10.

## Prerequisites

- Be using the ***3.x.x*** version of ***@afe/websocket-action-runner***

## What's New

### Implement ***actions*** as `<Type>Array` of classes of type ***Action***

The implementation of the ***actions*** configuration has been rethought to use a ***Injectable*** class model instead of functions that receive a ***Injector***.

In previous versions, the ***actions*** property of the ***Config*** configuration interface, passed in the ***forRoot*** method, received a ***Object*** where each property had as key the name of a ***action*** and as value a function to be executed.

Now, the property receives an ***Array*** of ***Type*** of classes of type ***Action*** that can be provisioned (***Injectable***) following an interface in order to force the implementation of one or more methods:

| Methods | Parameters | Description |
| - | - | - |
| Handle: ***void*** | message: ***ActionMessage*** | Executes the ***action*** callback. |
| resolveName: ***string*** | ***N/A*** | resolves the name of the ***action*** for that instance. |

```ts
import { Injectable } from '@angular/core';
import { Action, ActionMessage, WebsocketActionRunnerConfig } from '@afe/websocket-action-runner';

@Injectable({ providedIn: 'root'})
export class ClassAction implements Action {
    public handle(message: ActionMessage): void {
        // implementação do callback da action...
    }

    public resolveName(): string {
      return 'customActionName';
    }
}

export const websocketActionRunnerConfig: WebsocketActionRunnerConfig = {
    // demais propriedades omitidas
    actions: [
        ClassAction
    ],
};
```

### Implementation of ***additionalCallbackList*** as `Array<Types>` of classes of type ***CallBackList***

The configuration of ***additionalCallbackList*** has had its implementation rethought to use a ***Injectable*** class template instead of an interface that has functions that receive a ***Injector***.

In previous versions, the configuration passed in the ***forRoot method***, following the ***Config*** interface, had the ***additionalCallbackList*** property that received a ***Object*** containing the implementation of 4 predefined functions:

***onOpen***, ***onMessage***, ***onError*** and ***onClose*** that receive as the last parameter a ***Injector***.

Now, the property receives a ***Array*** of ***Type*** of classes of type ***CallBackList*** that can be provisioned (***Injectable***) following an interface in order to enforce the implementation of the following methods:

| Methods | Parameters | Description |
| - | - | - |
| onOpen: ***void*** | n/a*** | Executes callback logic when opening connection |
| onMessage: ***void*** | response: ***ServiceResponse*** | Executes callback logic when receiving a message |
| onError: ***void*** | event: ***Event*** | Executes callback logic when an error occurs |
| onClose: ***void*** | event: ***CloseEvent*** | Executes callback logic when terminating the connection |

```ts
import { CallBackList, ServiceResponse, WebsocketActionRunnerConfig } from '@afe/websocket-action-runner';
import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root'})
export class ClassCallBackList implements CallBackList {
    onOpen(): void {
      // implementation of necessary logic (callback) ...
    }
    onMessage(response: ServiceResponse): void {
      // implementation of necessary logic (callback) ...
    }
    onError(event: Event): void {
      // implementation of necessary logic (callback) ...
    }
    onClose(event: CloseEvent): void {
      // implementation of necessary logic (callback) ...
    }
}
```
