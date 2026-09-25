# API Reference

## Workspace Manager Service

The `WorkspaceManager` class is responsible for managing workspaces. It provides methods to register, unregister, retrieve, and activate workspaces.

### Methods

#### register

```typescript
register(seed: string, activate = true): string
```

This method is used to register a new workspace. It takes a seed string and an optional activate boolean as parameters. If activate is true or if this is the first workspace, it will be set as the active workspace.

```typescript
const workspaceManager = new WorkspaceManager();
const workspaceId = workspaceManager.register('mySeed', true);
```

#### unregister

```typescript
unregister(workspaceId: string): void
```

This method is used to unregister a workspace. It takes a workspaceId as a parameter. If the workspace to be unregistered is the active workspace, it will set the first workspace in the list as the active workspace.

```typescript
workspaceManager.unregister(workspaceId);
```

#### get

```typescript
get(workspaceId: string): Workspace | undefined
```

This method is used to get a reference to a workspace. It takes a workspaceId as a parameter and returns a reference to the workspace or undefined if not found.

```typescript
const workspace = workspaceManager.get(workspaceId);
```

#### getBySeed

```typescript
getBySeed(seed: string): Workspace | undefined
```

This method is used to get a reference to a workspace by its seed. It takes a seed as a parameter and returns a reference to the workspace or undefined if not found.

```typescript
const workspace = workspaceManager.getBySeed('mySeed');
```

#### getActive

```typescript
getActive(): Workspace | undefined
```

This method is used to get a reference to the active workspace. It returns a reference to the active workspace or undefined if not found.

```typescript
const activeWorkspace = workspaceManager.getActive();
```

#### setActive

```typescript
setActive(workspaceId: string): void
```

This method is used to activate a workspace. It takes a workspaceId as a parameter. It will deactivate all other workspaces and throw an error if the workspace does not exist.

```typescript
workspaceManager.setActive(workspaceId);
```

#### getAll

```typescript
getAll(): Array<Workspace>
```

This method is used to get a list of all workspace references. It returns an array of all workspace references.

```typescript
const allWorkspaces = workspaceManager.getAll();
```

#### on

```typescript
on(event: WORKSPACE_EVENTS.EVENTS, callback: (workspace: Workspace) => void): void
```

This method is used to register a callback function that will be invoked when a specific event, defined in `WORKSPACE_EVENTS.EVENTS`, occurs in the workspace.

The `event` parameter is the specific event you want to listen for. The `callback` parameter is the function that will be called when the event occurs. This function receives a `Workspace` object as its argument.

Here's an example of how to use the `on` method:

```typescript
workspaceManager.on(WORKSPACE_EVENTS.EVENTS.WORKSPACE_ADDED, (workspace) => {
  console.log(`A new workspace was added: ${workspace.name}`);
});
```

In this example, the `on` method is used to register a callback that logs a message every time a new workspace is added.

### ENUM

#### WORKSPACE_EVENTS

```typescript
  export namespace WORKSPACE_EVENTS {
    export type EVENTS = typeof REGISTER | typeof UNREGISTER | typeof ACTIVE_CHANGE;
    export const REGISTER = 'WORKSPACE__REGISTER';
    export const UNREGISTER = 'WORKSPACE__UNREGISTER';
    export const ACTIVE_CHANGE = 'WORKSPACE__ACTIVE_CHANGE';
  }
```

## Context Handler Service

The `ContextHandlerService` class extends the `RootContextHandler` and implements the `ContextHandlerService`. It is responsible for managing the global and workspace-specific context.

### Methods

#### getGlobalValue

This method retrieves a global value from the state manager.

```typescript
async getGlobalValue<T = unknown>(options: GetData<T>): Promise<T | undefined>
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
const globalValue = await rootContextHandler.getGlobalValue({ key: 'globalKey' });
```

#### getGlobalValueAsObservable

```typescript
getGlobalValueAsObservable<T = unknown>(options: GetData<T>): Observable<T | undefined>
```

This method is used to get a global value as an observable. It takes an options object of type `GetData<T>` as a parameter and returns an observable of the value or undefined.

```typescript
const options = { key: 'myKey' };
const observable = ContextHandlerService.getGlobalValueAsObservable(options);
observable.subscribe(value => console.log(value));
```

#### getGlobalValues

This method retrieves multiple global values from the state manager.

```typescript
getGlobalValues<T = unknown>(optionsList: Array<GetData<T>>): Promise<Array<T | undefined>>
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
const globalValues = await rootContextHandler.getGlobalValues([{ key: 'globalKey1' }, { key: 'globalKey2' }]);
```

#### getGlobalValuesAsObservable

```typescript
getGlobalValuesAsObservable<T = unknown>(optionsList: GetData<T>[]): Observable<Array<T | undefined>>
```

This method is used to get multiple global values as an observable. It takes an array of options objects of type `GetData<T>` as a parameter and returns an observable of an array of values or undefined.

```typescript
const optionsList = [{ key: 'myKey1' }, { key: 'myKey2' }];
const observable = ContextHandlerService.getGlobalValuesAsObservable(optionsList);
observable.subscribe(values => console.log(values));
```

#### updateGlobalValue

This method updates a global value in the state manager.

```typescript
updateGlobalValue<T = unknown>(dispatchData: DispatchData<T>): void
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
rootContextHandler.updateGlobalValue({ key: 'globalKey', value: 'newValue' });
```

#### getWorkspaceValue

This method retrieves a value from the state manager of the current workspace.

```typescript
getWorkspaceValue<T = unknown>(options: GetData<T>): Promise<T | undefined>
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
const workspaceValue = await rootContextHandler.getWorkspaceValue({ key: 'workspaceKey' });
```

#### getWorkspaceValueAsObservable

```typescript
 getWorkspaceValueAsObservable<T = unknown>(options: GetData<T>): Observable<T | undefined>
```

This method is used to get a workspace-specific value as an observable.
It takes an options object of type `GetData<T>` as a parameter and returns an observable of the value or undefined.
If the current workspace state manager is missing, an error will be thrown.

```typescript
const options = { key: 'myKey' };
const observable = ContextHandlerService.getWorkspaceValueAsObservable(options);
observable.subscribe(value => console.log(value));
```

#### getWorkspaceValues

This method retrieves multiple values from the state manager of the current workspace.

```typescript
getWorkspaceValues<T = unknown>(optionsList: GetData<T>[]): Promise<Array<T | undefined>>
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
const workspaceValues = await rootContextHandler.getWorkspaceValues([{ key: 'workspaceKey1' }, { key: 'workspaceKey2' }]);
```

#### getWorkspaceValuesAsObservable

```typescript
getWorkspaceValuesAsObservable<T = unknown>(optionsList: GetData<T>[]): Observable<Array<T | undefined>>
```

This method is used to get multiple workspace-specific values as an observable.
It takes an array of options objects of type `GetData<T>` as a parameter and returns an observable of an array of values or undefined.
If the current workspace state manager is missing, an error will be thrown.

```typescript
  const optionsList = [{ key: 'myKey1' }, { key: 'myKey2' }];
  const observable = ContextHandlerService.getWorkspaceValuesAsObservable(optionsList);
  observable.subscribe(values => console.log(values));
```

#### updateWorkspaceValue

This method updates a value in the state manager of the current workspace.

```typescript
updateWorkspaceValue<T = unknown>(dispatchData: DispatchData<T>): void
```

Example:

```typescript
const rootContextHandler = new RootContextHandler(workspaceManager);
rootContextHandler.updateWorkspaceValue({ key: 'workspaceKey', value: 'newValue' });
```

### Interfaces

#### GetData

```typescript
export interface GetData<T = unknown> {
  /**
   * Key of the context to retrieve
   */
  key: string;
  /**
   * Value to be returned if the context for the given key does not exist
   */
  fallbackValue?: T | undefined;

  /**
   * Set the strategy to retrieve the data
   */
  contextDataStrategy?: ContextDataStrategy;
}
```

#### ContextDataStrategy

```typescript
export enum ContextDataStrategy {
  DEFAULT =  'DEFAULT',
  INTERNAL_FIRST = 'INTERNAL_FIRST',
  SHARED_FIRST = 'SHARED_FIRST',
  INTERNAL_ONLY = 'INTERNAL_ONLY',
  SHARED_ONLY = 'SHARED_ONLY',
}
```
