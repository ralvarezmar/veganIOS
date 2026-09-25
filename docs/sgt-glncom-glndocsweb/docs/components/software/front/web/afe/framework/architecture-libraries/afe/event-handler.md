# Event Handler

The **@afe/event-handler** is a purely javascript library that logs and fires events. Basically, the library works in the **Observer** standard, where we work with two fronts:

**Listen** that is responsible for listening to the events and the **Emitter** that is responsible for registering and sending the events.

One way to use **@afe/event-handler** is to create applications that require a **State Machine**.

## Prerequisites

- There are no prerequisites.

## Installation

``` BASH
npm install @afe/event-handler@^2 --save
```

## Available Methods

| Methods | Parameters | Description |
| -------- | ---------- | --------- |
| **`emit<T>`**: ***`Promise<T>`*** | ***event: string***, ***payload?: any***, ***cb?: Function*** | responsible for sending events |
| **listen**: ***void*** | event: ***string***, ***options: OptionsInterface***, ***cb?: Function*** | Responsible for listening to events |
| **listenAll**: ***void*** | arr: `Array<ListenAllInterface>` | makes it possible to configure the receipt of **n** instances of the ***listen*** |

## Implementation

### Emitting events with ***emit()***

``` JS
    eventHandler.emit("EVENT_NAME", {})
    .then(data => {
    })
    .catch(err => {
    });
```

### Event listening with ***listen()***

```javascript
 eventHandler.listen("EVENT_NAME", {}, (data, resolve, reject) => {
    // in case of error
    reject();

    // in case of success
    resolve();
});
```

### Event listening with ***listenAll()***

```javascript
  eventHandler.listenAll([
    {
        event: "Teste",
        options: {
            identificationResponseSchema
        },
        fn: (data, resolve, reject) => {
            // em caso de erro
            reject();

            // em caso de sucesso
            resolve();
        }
    },
    {
        event: "Teste2",
        options: {
            requestSchema: authorizationRequestSchema,
            responseSchema: authorizationResponseSchema
        },
        fn: (data, resolve, reject) => {
            // in case of error
            reject();

            // in case of success
            resolve();
        }
    }
]);
```
