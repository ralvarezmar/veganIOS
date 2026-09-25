# Use it in Vanilla Javascript

`@santander/state` is a vanilla library that provides a **simple way to deal with context data in an application using Promises**.

## Pre-requisites

- **Understanding of the fundamentals**: Full understanding of the [fundamentals](./index.md) of the `@santander/state` library.

## Installation

First, install the library with the command above:

```bash
npm install @santander/state --save
```

## Configuration

### Configuring the root application

To configure the root application or shell, creates an instance of the `WorkspaceManager` and pass it to the `RootContextHandler` to manage the global state.

```typescript
import { RootContextHandler } from '@santander/state/internal';
import { WorkspaceManager } from '@santander/state';

const workspaceManager = new WorkspaceManager(); // your whole root application must use only one instance of the workspace manager
const rootContextHandler = new RootContextHandler(workspaceManager);
```

### Configuring the child application

To configure the child application or  micro front-end, creates an instance of the `ChildContextHandler` and pass it a `childId` that will identify the child application.

```typescript
import { ChildContextHandler } from '@santander/state/internal';

const childContextHandler = new ChildContextHandler('child-application-id');
```

## Usage

This session will show you how to use the `@santander/state` library to manage the context data in your application.

The examples are majority with the `RootContextHandler` classes, but you can replace with  `ChildContextHandler` as well.

### Managing global context data

The global context data can be shared between different parts in the application, simply defining the `shareable` property. Once the data is shareable, it can be accessed from any part of the application that has `forChild` configuration.

> If no flag `shareable` is set, the data will be internal and only available for the root application.

#### Creating or updating a global value

To set or update a value in the global state, you can use the `updateGlobalValue` method, passing the `key` and the `value` that you want to **create or update**.

As third parameter, you can set the `shareable` to `true` to make the value available to others contexts. If the context data didn't exist, it will be created.

```typescript
import { RootContextHandler } from '@santander/state/internal';
import { WorkspaceManager } from '@santander/state';

const workspaceManager = new WorkspaceManager(); // your whole root application must use only one instance of the workspace manager
const rootContextHandler = new RootContextHandler(workspaceManager);

rootContextHandler.updateGlobalValue({
  key: 'gluon',
  value: 'the best platform ever!',
  shareable: true
});
```

#### Getting a global value

To obtain a value in the global state, you can use the `getGlobalValue` method that returns a `Promise` or the `getGlobalValueAsObservable` that returns a `Observable` with the expected value.

In the context of `root` application, the default strategy, if none is passed, is to first retrieve internal data. If does not exist, the shared data will be returned.

> To learn about strategies to retrieve data, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { RootContextHandler } from '@santander/state/internal';
import { WorkspaceManager, ContextDataStrategy } from '@santander/state';

const childContextHandler = new ChildContextHandler('child-application-id'); // you can use both `ChildContextHandler` or `RootContextHandler` to retrieve the value. This example uses the `ChildContextHandler`.

async function getValue() {
  const value = await childContextHandler.getGlobalValue<string>({
    key: 'gluon',
    fallbackValue: 'Not found context data',
    contextDataStrategy: ContextDataStrategy.SHARED_ONLY
  });

  console.log(value); // the best platform ever!
}

getValue();
```

#### Getting multiples global values

To obtain multiples values, you can use the `getGlobalValues` method that returns a `Array<Promise>` with the expected values.

In the context of `root` application, the default strategy, if none is passed, is to first retrieve internal data. If does not exist, the shared data will be returned.

> To learn about strategies to retrieve data, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { RootContextHandler } from '@santander/state/internal';
import { WorkspaceManager, ContextDataStrategy } from '@santander/state';

const workspaceManager = new WorkspaceManager(); // your whole root application must use only one instance of the workspace manager

const rootContextHandler = new RootContextHandler(workspaceManager); // you can use both `ChildContextHandler` or `RootContextHandler` to retrieve the value. This example uses the `RootContextHandler`.

async function getGlobalValues() {
    const [valueOne, valueTwo] = await rootContextHandler.getGlobalValues<string>([
      {
        key: 'globalKeyOne',
        fallbackValue: 'Not Found',
        contextDataStrategy: ContextDataStrategy.INTERNAL_FIRST
      },
      {
        key: 'globalKeyTwo',
        fallbackValue: 'Not Found',
        contextDataStrategy: ContextDataStrategy.SHARED_ONLY
      };
    ]);

    console.log(valueOne, valueTwo); // valueOne, valueTwo
  }
}

getGlobalValues();
```

### Managing workspace context data

Workspaces are isolated contexts to manage its own state that will not be accessible from another workspace, but can be shared within its own context, by setting the `shareable` flag.

Workspaces can be created based in a user, a customer, a channel, or any other context that you need to isolate the data.

#### Registering a workspace

In order to create an isolated state to handle context data, you need to **register a workspace**, by calling the `register()` method from the `WorkspaceManagerService`, that receives as parameter:

| Parameter | Type | Description |
| :-------: | :--: | :---------: |
| `seed` | `string` | Defines the name that will be used to create the workspace ID |
| `activated` | `boolean` | Sets if the workspace will be active |

An example of how to register a workspace is shown below:

```typescript
import { WorkspaceManagerService } from "@santander/state";

const workspaceManagerService = new WorkspaceManagerService(); // the instance of the workspace manager must be the same that will be used in the `RootContextHandler`

function registerWorkspace(): void {
  this.workspaceManagerService.register('client-one', true);
}

registerWorkspace();
```

If you try to access a data from a workspace that is not registered, you will receive the `WorkspaceNotRegisteredError` error.

> **Note**: You can only have one active workspace at a time. If you try to register a new workspace with the `activated` parameter set to `true`, the previous active workspace will be deactivated.

### Creating or updating a workspace value

To set or update a value in a workspace context, you can use the `updateWorkspaceValue` method, passing the `key` and the `value` that you want to **create or update**.

You can also pass a third parameter called `shareable` to make the value available to others contexts. If the context data didn't exist, it will be created.

```typescript
import { ChildContextHandler } from '@santander/state/internal';
import { WorkspaceManager, ContextDataStrategy } from '@santander/state';

const workspaceManager = new WorkspaceManager(); // your whole root application must use only one instance of the workspace manager

const childContextHandler = new ChildContextHandler('child-application-id'); // you can use both `ChildContextHandler` or `RootContextHandler` to manage the state of the child application. This example uses the `ChildContextHandler`.

async function updateWorkspaceValue() {
  await childContextHandler.updateWorkspaceValue({
    key: 'gluon',
    value: 'the best platform ever!',
    shareable: false,
}

updateWorkspaceValue();
```

#### Getting a workspace value

To obtain a value in a workspace context, you can use the `getWorkspaceValue` method that returns a `Promise` or the `getWorkspaceValueAsObservable` that returns a `Observable` with the expected value.

> If you need to get only the shared value or only internal data from the workspace, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { ChildContextHandler } from '@santander/state/internal';
import { WorkspaceManager, ContextDataStrategy } from '@santander/state';

const childContextHandler = new ChildContextHandler('child-application-id');  // you can use both `ChildContextHandler` or `RootContextHandler`

async function getWorkspaceValue() {
  const value = await childContextHandler.getWorkspaceValue<string>({
    key: 'gluon',
    fallbackValue: 'Not found internal workspace data',
    contextDataStrategy: ContextDataStrategy.INTERNAL_ONLY
  });
  
  console.log(value); // the best platform ever!
}

getWorkspaceValue();
```

### Getting multiples workspace values

To obtain multiples values from a workspace, you can use the `getWorkspaceValues` method that returns a `Array<Promise>` or the `getWorkspaceValuesAsObservable` that returns a `Array<Observable>` with the expected values.

> If you need to get only the shared value or only internal data from the workspace, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { RootContextHandler } from '@santander/state/internal';
import { WorkspaceManager, ContextDataStrategy } from '@santander/state';

const workspaceManager = new WorkspaceManager(); // your whole root application must use only one instance of the workspace manager
const rootContextHandler = new RootContextHandler(workspaceManager); // you can use both `ChildContextHandler` or `RootContextHandler`

async function getWorkspaceValues() {
  const [valueOne, valueTwo] = await rootContextHandler.getWorkspaceValues<string>([
    {
      key: 'workspaceKeyOne',
      fallbackValue: 'Not Found',
      contextDataStrategy: ContextDataStrategy.INTERNAL_FIRST
    },
    {
      key: 'workspaceKeyTwo',
      fallbackValue: 'Not Found',
      contextDataStrategy: ContextDataStrategy.SHARED_FIRST
    };
  ]);

  console.log(valueOne, valueTwo); // valueOne, valueTwo
}

getWorkspaceValues();
```

### Changing the active workspace

To change the workspace that will be used as reference to get the context data, you can call the `setActive` method from the `WorkspaceManagerService` passing the `seed` of the workspace that you want to activate.

```typescript
this.workspaceManagerService.register('client-2', false); // the workspace will not be activated by setting the second param as `false`
this.workspaceManagerService.register('client-1', true); // the workspace `client-1` will be activated by setting the second param as `true`


this.workspaceManagerService.setActive('client-2`); // will change the active workspace to `client-2`
```

### Unregister a workspace

If you no longer needs a workspace, you can deactivate it calling the `unregister()` method from the `WorkspaceManagerService`. This method receives as parameter the `seed` of the workspace that was used to register in the first place.

```typescript
import { WorkspaceManagerService } from "@santander/state";

const workspaceManagerService = new WorkspaceManagerService(); // your whole root application must use only one instance of the workspace manager

function unregisterWorkspace(): void {
  this.workspaceManagerService.unregister('client-1');
}

unregisterWorkspace();

```
