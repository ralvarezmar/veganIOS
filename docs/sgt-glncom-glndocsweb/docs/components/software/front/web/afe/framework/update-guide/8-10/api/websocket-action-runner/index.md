# WebSocket Action Runner Update

By the end of this session, you will have upgraded ***@afe/websocket-action-runner*** to a **version compatible with Angular 10 and 8**.

## Prerequisites

- Have the ***2.x.x*** version of ***@afe/websocket-action-runner*** installed and configured in the project;
- Commit the project files before starting the update process.

## Run the Update Command

Through the command below, you will install the new version of the structuring:

```bash
ng update @afe/websocket-action-runner@^3 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the '--allow-dirty' parameter in the update command.

## Update the Configuration Interface

### Change the name of the configuration interface to ***WebSocketActionRunnerConfig***

Change the constant typing to ***WebsocketActionRunnerConfig*** and add it in the package imports ***@afe/websocket-action-runner***.

```diff
- import { Config } from '@afe/websocket-action-runner';
+ import { WebsocketActionRunnerConfig } from '@afe/websocket-action-runner';

- export const websocketActionRunnerConfig: Config = {
+ export const websocketActionRunnerConfig: WebsocketActionRunnerConfig = {
    // código omitido
};
```

### Change the ***actions*** property to ***actionsFns***

The configuration of ***actions*** had its implementation rethought to use a ***Injectable*** class model instead of a ***key-value*** object, where the key was named after the ***action*** and the value was given a function.

Rename the ***actions*** property to ***actionFns*** and the ***Actions*** interface to ***ActionFns***.

```diff
import { functionActionOne, functionActionTwo } from './actions';
- import { Config, Actions } from '@afe/websocket-action-runner';
+ import { WebsocketActionRunnerConfig, ActionsFn } from '@afe/websocket-action-runner';

- const actionsConfig: Actions = { functionActionOne, functionActionTwo };
+ const actionsConfig: ActionFns = { functionActionOne, functionActionTwo };


export const websocketActionRunnerTwoConfig: Config = {
    actions: actionsConfig
};
```

### Change the ***additionalCallbackList*** property to ***additionalCallbackFnList***

The configuration of ***additionalCallbackList*** has had its implementation rethought to use a ***Injectable*** class model instead of an interface that expects functions to receive a ***Injector*** and to maintain its implementation.

It is necessary to change the name of the property and the interface.

Rename the ***additionalCallbackList*** property to ***additionalCallbackFnList*** and the ***CallbackList*** interface to ***CallbackFnList***.

```diff
- import { Config, CallbackList } from '@afe/websocket-action-runner';
+ import { WebsocketActionRunnerConfig, CallbackFnList } from '@afe/websocket-action-runner';
import { onClose, onError, onMessage, onOpen } from './callback-list';

- const additionalCallbackListConfig: CallbackList = {
+ const additionalCallbackListConfig: CallbackFnList = {
    onOpen, onMessage, onError, onClose,
};

- export const websocketActionRunnerTwoConfig: Config = {
+ export const websocketActionRunnerTwoConfig: WebsocketActionRunnerConfig = {

-    additionalCallbackList: additionalCallbackListConfig
+    additionalCallbackFnList: additionalCallbackListConfig
};
```

### Change the typing of the parameters used by ***additionalCallbackFnList***

### Change the typing of the first parameter of the ***onOpen*** method

Renames the interface passed as the first parameter in the ***onOpen*** method from ***ServiceResponse*** to ***WebSocketEvent***.

```diff
import { Injector } from '@angular/core';
- import { ServiceResponse } from '@afe/websocket-action-runner';
+ import { WebSocketEvent } from '@afe/websocket-action-runner';

- function onOpen(response: ServiceResponse, injector: Injector): void {
+ function onOpen(event: WebSocketEvent, injector: Injector): void {
}
```

### Change the typing of the first parameter of the ***onError*** method

Rename the interface passed as the first parameter in the ***onError*** method from ***Event*** to ***WebSocketEvent***.

```diff
import { Injector } from '@angular/core';
- import { Event } from '@afe/websocket-action-runner';
+ import { WebSocketEvent } from '@afe/websocket-action-runner';

- function onError(event: Event, injector: Injector): void {
+ function onError(event: WebSocketEvent, injector: Injector): void {
}
```

### Change the typing of the first parameter of the ***onClose method***

Rename the interface passed as the first parameter in the ***onClose*** method from ***CloseEvent*** to ***WebSocketEvent***.

```diff
import { Injector } from '@angular/core';
-import { CloseEvent } from '@afe/websocket-action-runner';
+import { WebSocketEvent } from '@afe/websocket-action-runner';

- export function onClose(event: CloseEvent, injector: Injector): void {
+ export function onClose(event: WebSocketEvent, injector: Injector): void {
}
```

### Replace the ***send()*** method with ***sendActionMessage()***

In previous versions, the ***send*** method was used to send messages, but it was **deprecated** and has now been **removed**. Instead, use the ***sendActionMessage()*** method of the ***WebSocketActionRunnerService** class.

```diff
import { Component } from '@angular/core';
- import { WebSocketActionRunnerService } from '@afe/websocket-action-runner';
+ import { WebSocketActionRunnerService, ActionMessage } from '@afe/websocket-action-runner';

@Component()
export class ExampleComponent {
    constructor(private wsActionRunnerService: WebSocketActionRunnerService) { }

-    public sendMessage(message: string, connectionName: string): void {
-        this.wsActionRunnerService.send(message, connectionName);
    }

+    public sendMessage(message: ActionMessage, connectionName: string): void {
+        this.wsActionRunnerService.sendActionMessage(message, connectionName);
    }
}
```

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/websocket-action-runner***😎
