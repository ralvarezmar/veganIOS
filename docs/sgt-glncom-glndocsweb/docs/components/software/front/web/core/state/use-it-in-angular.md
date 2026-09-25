# Use state in Angular

`@santander/state-angular` is a Angular wrapper library that provides a **simple way to deal with context data in an application using Observables**.

## Pre-requisites

- **Understanding of the fundamentals**: Full understanding of the [fundamentals](./index.md) of the `@santander/state` library.

## Installation

First, install the library with the command above:

```bash
npm install @santander/state-angular --save
```

## Configuration

### Configuring the Root Application

To configure your application to use the `@santander/state-angular` library, you need to import the providers from `StateModule` in your `app.config.ts` and call the `forRoot` method.

```typescript
import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { StateModule } from '@santander/state-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(StateModule.forRoot()),
    // ... other providers
  ],
};
```

### Configuring the Child Application

If you want to use the `@santander/state-angular` in a **module** or a **micro front-end**, you can import the providers from `StateModule` and call the `forChild` method.

```typescript
import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { StateModule } from '@santander/state-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(StateModule.forChild({ childId: 'global-positions' })),
    // ... other providers
  ],
};
```

> It receives as parameter a unique identifier of the Microfront

## Usage

Once the `StateModule` is imported, you can use the `ContextHandlerService` to start managing the state of your application.

### Managing global context data

The global context data can be shared between different parts in the application, simply defining the `shareable` property. Once the data is shareable, it can be accessed from any part of the application that has `forChild` configuration.

> If no flag `shareable` is set, the data will be internal and only available for the root application.

#### Creating or updating a global value

To set or update a value in the global state, you can use the `updateGlobalValue` method, passing the `key` and the `value` that you want to **create or update**.

As third parameter, you can set the `shareable` to `true` to make the value available to others contexts. If the context data didn't exist, it will be created.

```typescript
import { ContextHandlerService } from '@santander/state-angular';

@Component({
  // omitted
})
export class SetGlobalValue {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  onInit() {
    this.contextHandlerService.updateGlobalValue({
      key: 'gluon',
      value: 'the best platform ever!',
      shareable: true
    })
  }
}
```

#### Getting a global value

To obtain a value in the global state, you can use the `getGlobalValue` method that returns a `Promise` or the `getGlobalValueAsObservable` that returns a `Observable` with the expected value.

In the context of `root` application, the default strategy, if none is passed, is to first retrieve internal data. If does not exist, the shared data will be returned.

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { ContextHandlerService, ContextDataStrategy } from '@santander/state-angular';

@Component({
  // omitted
})
export class GetGlobalValue {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  onInit() {
    this.contextHandlerService.getGlobalValueAsObservable<string>({
      key: 'gluon',
      fallbackValue: 'Not found shared global data',
      contextDataStrategy: ContextDataStrategy.SHARED_ONLY,
    })
    .subscribe((value) => {
      console.log(value); // the best platform ever!
    });
  }
}
```

> You can also use `async/await` by calling the `getGlobalValue` method that will return a `Promise` with the expected values. To learn more, see [Promise-based implementation](./use-it-in-vanilla.md).

#### Getting multiples global values

To obtain multiples values, you can use the `getGlobalValues` method that returns a `Array<Promise>` with the expected values.

In the context of `root` application, the default strategy, if none is passed, is to first retrieve internal data. If does not exist, the shared data will be returned.

> To learn about strategies to retrieve data, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { ContextHandlerService } from '@santander/state-angular';
import { ContextDataStrategy } from '@santander/state';

@Component({
  // omitted
})
export class GetGlobalValues {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  getGlobalValuesAsObservable() {
    this.contextHandlerService.getGlobalValuesAsObservable<string>([
      {
        key: 'globalKeyOne',
        fallbackValue: 'Not Found',
        contextDataStrategy: ContextDataStrategy.SHARED_ONLY
      },
      {
        key: 'globalKeyTwo',
        fallbackValue: 'Not Found',
        contextDataStrategy: ContextDataStrategy.SHARED_ONLY
      },
    ])
    .subscribe((newValue) => {
      console.log(newValue); // ['valueOne', 'valueTwo']
    });
  }
}
```

> You can also use `async/await` by calling the `getGlobalValues` method that will return a `Promise` with the expected values.

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
import { Component } from "@angular/core";
import { WorkspaceManagerService } from "@santander/state-angular";

@Component({
  // omitted
})
export class RegisterWorkspace {
  constructor(private readonly workspaceManagerService: WorkspaceManagerService) {}
  
  public create(): void {
    this.workspaceManagerService.register('client-one', true);
  }
}
```

If you try to access a data from a workspace that is not registered, you will receive the `WorkspaceNotRegisteredError` error.

> **Note**: You can only have one active workspace at a time. If you try to register a new workspace with the `activated` parameter set to `true`, the previous active workspace will be deactivated.

#### Creating or updating a workspace value

To set or update a value in a workspace context, you can use the `updateWorkspaceValue` method, passing the `key` and the `value` that you want to **create or update**.

You can also pass a third parameter called `shareable` to make the value available to others contexts. If the context data didn't exist, it will be created.

```typescript
import { ContextHandlerService } from '@santander/state-angular';

@Component({
  // omitted
})
export class updateWorkspaceValue {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  updateWorkspaceValue() {
    this.contextHandlerService.updateWorkspaceValue({
      key: 'gluon',
      value: 'the best platform ever!',
      shareable: false
    })
  }
}
```

#### Getting a workspace value

To obtain a value in a workspace context, you can use the `getWorkspaceValueAsObservable` that returns a `Observable` with the expected value.

> If you need to get only the shared value or only internal data from the workspace, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { ContextHandlerService, ContextDataStrategy } from '@santander/state-angular';

@Component({
  // omitted
})
export class GetWorkspaceValue {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  getWorkspaceValueAsObservable() {
    this.contextHandlerService.getWorkspaceValueAsObservable<string>({
      key: 'gluon',
      fallbackValue: 'Not found internal workspace data',
      contextDataStrategy: ContextDataStrategy.INTERNAL_ONLY
    })
    .subscribe((value) => {
      console.log(value); // the best platform ever!
    });
  }
}
```

> You can also use `async/await` by calling the `getWorkspaceValue` method that will return a `Promise` with the expected values.

#### Getting multiples workspace values

To obtain multiples values from a workspace, you can use the `getWorkspaceValuesAsObservable` that returns a `Array<Observable>` with the expected values.

> If you need to get only the shared value or only internal data from the workspace, see the section [strategies for retrieve context data](./index.md#context-data-strategy).

You can also set a `fallbackValue` to be returned if the context data didn't exist.

```typescript
import { ContextHandlerService } from '@santander/state-angular';
import { ContextDataStrategy } from '@santander/state';

@Component({
  // omitted
})
export class GetWorkspaceValues {
  constructor(private readonly contextHandlerService: ContextHandlerService) {}

  public getWorkspaceValuesAsObservable() {
    this.contextHandlerService.getWorkspaceValuesAsObservable<string>([
      {
        key: 'workspaceKeyOne',
        fallbackValue: 'Not found in workspace',
        contextDataStrategy: ContextDataStrategy.INTERNAL_FIRST
      },
      {
        key: 'workspaceKeyTwo',
        fallbackValue: 'Not found in workspace',
        contextDataStrategy: ContextDataStrategy.INTERNAL_FIRST
      },
    ])
    .subscribe((newValue) => {
      console.log(newValue); // ['valueOne', 'valueTwo']
    });
  }
}
```

> You can also use `async/await` by calling the `getWorkspaceValues` method that will return a `Promise` with the expected values.

### Changing the active workspace

To change the workspace that will be used as reference to get the context data, you can call the `setActive` method from the `WorkspaceManagerService` passing the `seed` of the workspace that you want to activate.

```typescript
import { Component } from "@angular/core";
import { WorkspaceManagerService } from "@santander/state-angular";

@Component({
  // omitted
})
export class UnregisterWorkspace {
  constructor(private readonly workspaceManagerService: WorkspaceManagerService) {}
  
  public registerWorkspaces(): void {
    this.workspaceManagerService.register('client-2', false); // the workspace will not be activated by setting the second param as `false`
    this.workspaceManagerService.register('client-1', true); // the workspace `client-1` will be activated by setting the second param as `true`
  }

  public setActiveWorkspace(): void {
    this.workspaceManagerService.setActive('client-2');  // will change the active workspace to `client-2`
  }
}
```

### Listen to the active workspace change

To listen when the active workspace change, you can call `on` method from the `WorkspaceManagerService`.

```typescript
  this.workspaceManagerService.on('WORKSPACE__ACTIVE_CHANGE', (e) => {
    console.log(e.seed);
  });
```

### Refresh a key value on active workspace change

If you want to refresh a specific key value when the active workspace changes, you can do so within the callback function of the `on` method. Here's an example:

```typescript
  this.workspaceManagerService.on('WORKSPACE__ACTIVE_CHANGE', (e) => {
    this.activeWorkspace = e.seed;

    this.contextHandlerService
      .getWorkspaceValueAsObservable({ key: '__MY_KEY__' })
      .pipe(first())
      .subscribe((r) => {
        this.value = r;
      });
  });
```

### Unregister a workspace

If you no longer needs a workspace, you can deactivate it calling the `unregister()` method from the `WorkspaceManagerService`. This method receives as parameter the `seed` of the workspace that was used to register in the first place.

```typescript
import { Component } from "@angular/core";
import { WorkspaceManagerService } from "@santander/state-angular";

@Component({
  // omitted
})
export class UnregisterWorkspace {
  constructor(private readonly workspaceManagerService: WorkspaceManagerService) {}
  
  public unregisterWorkspace(): void {
    this.workspaceManagerService.unregister('client-1');
  }
}
```
