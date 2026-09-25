# Context Handler Update

By the end of this session, you will have updated the ***@afe/context-handler*** to a **version compatible with Angular 10 and 8**.

## Prerequisites

- Have the ***2.x.x*** version of ***@afe/context-handler*** installed in your project;
- Commit the project files before starting the update process.

## Run the Update Command

Through the command below, you will install the new version of the structuring,

```bash
ng update @afe/context-handler@^3 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the `--allow-dirty` parameter in the update command.

## Update the Configuration Interfaces

### Change the configuration interface of the ***forRoot()*** method

In previous versions, the configuration interface ***ContextConfig*** was used in the ***forRoot()*** method to configure the ***ContextHandlerModule***.

And now, due to the internal standardizations of the architecture, the configuration interface ***ContextHandlerConfig*** must be used.

To complete this step, simply change the typing of the existing constant to ***ContextHandlerConfig*** and add it to the imports of the ***@afe/context-handler***.

```diff
- import { ContextConfig } from '@afe/context-handler';
+ import { ContextHandlerConfig } from '@afe/context-handler';

- export const contextHandlerConfig: ContextConfig = {
+ export const contextHandlerConfig: ContextHandlerConfig = {
    // código omitido
};
```

### Change the configuration interface of the ***forChild()*** method

Change the typing of the existing constant to ***ContextHandlerChildConfig*** and add it to the *imports* of the ***@afe/context-handler*** package.

```diff
- import { LeanContextConfig } from '@afe/context-handler';
+ import { ContextHandlerChildConfig } from '@afe/context-handler';

- export const contextHandlerChildConfig: LeanContextConfig = {
+ export const contextHandlerChildConfig: ContextHandlerChildConfig = {
    // código omitido
};
```

### Configure the new ***workspaceNameResolver*** property of ***ContextHandlerConfig***

The process of using ***@afe/workspace-manager*** to retrieve the current ***workspace*** when dealing with ***workspace*** contexts is no longer done transparently, requiring you to configure a new property called ***workspaceNameResolver***.

Create a ***workspace-name-resolver.service.ts*** file in the [***config***](../../../../development-guides/best-practices/development/config-files.md) of your project.

Then create a class called ***WorkspaceNameResolverService*** that will implement the ***resolve*** method that expects to receive the name of the current ***workspace***.

Information that can be retrieved through the ***currentWorkspaceState*** method of the ***WorkspaceService*** belonging to the ***@afe/workspace-manager*** package, as shown in the following example:

```javascript
import { Injectable } from '@angular/core';
import { WorkspaceNameResolver } from '@afe/context-handler';
import { WorkspaceService } from '@afe/workspace-manager';

@Injectable({ providedIn: 'root' })
export class WorkspaceNameResolverService implements WorkspaceNameResolver {

    constructor(private workspaceService: WorkspaceService) { }

    public resolve(): string {
      return this.workspaceService.currentWorkspaceStateName();
    }
}
```

And finally, configure the ***workspaceNameResolver***, setting the value to ***WorkspaceNameResolverService***.

```javascript
import { ContextHandlerConfig } from '@afe/context-handler';
import { WorkspaceNameResolverService } from './workspace-name-resolver.service';

export const contextHandlerConfig: ContextHandlerConfig = {
    // configuração omitida
    workspaceNameResolver: WorkspaceNameResolverService,
};
```

## Change the ***middlewares*** property to ***middlewaresFns*** of ***ContextHandlerConfig***

In previous versions, the configuration of middleware was done through a `Array<Middleware>`.

In the new version, this configuration has been redesigned to use a ***Injectable*** class model instead of functions that receive a ***Injector***, now receiving an `Array<Type<Middleware>>`.

Rename the *middlewares*** property to ***middlewaresFns*** and the ***Middleware*** and ***MiddlewareParams*** interfaces to ***MiddlewareFn*** and ***MiddlewareFnParams***, respectively.

```diff
import { Middleware, MiddlewareParams } from '@afe/context-handler';

function functionMiddleware(params: MiddlewareParams) {
   // implementação omitida
}

const CONTEXT_MIDDLEWARE: Array<Middleware> = [
    functionMiddleware,
];

export const contextHandlerConfig: ContextHandlerConfig = {
    // configuração omitida
-    middlewares: CONTEXT_MIDDLEWARE
+    middlewaresFn: CONTEXT_MIDDLEWARE_FN
};
```

## Remove references to ***ContextHandlerService***

The ***ContextHandlerService*** class was used to handle both ***session*** and ***workspace*** ***contexts***, however, it has been spun off into two new classes: ***SessionContextService*** and ***WorkspaceContextService***.

To complete this step, consider which of the scenarios your project fits into:

- If you are using **outside** of a ***workspace***, you should switch to ***SessionContextService***
- If you are using **within** a ***workspace***, you should switch to ***WorkspaceContextService***

Before

```diff
import { ContextHandlerService } from '@afe/context-handler';
import { OnInit, Component } from '@angular/core';

@Component()
export class ExemploComponent implements OnInit {

    constructor(private contextHandlerService: ContextHandlerService) { }

    public ngOnInit(): void {
-        this.contextHandlerService.updateValue({ key: 'sessionContext', value: 'usoSession' }).subscribe();
-        this.contextHandlerService.updateValue({ key: 'workspaceContext', value: 'usoWorkspace' }).subscribe();

+        this.sessionContextService.updateValue({ key: 'sessionContext', value: 'usoSession' }).subscribe();
+        this.workspaceContextService.updateValue({ key: 'workspaceContext', value: 'usoWorkspace' }).subscribe();
    }
}
```

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/context-handler*** 😎
