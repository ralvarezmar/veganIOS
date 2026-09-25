# Data sharing between base and element

To share context data between the main application (BASE) in an Angular Element, we will use the AFE architecture library ***@afe/context-handler***.

## Configuration

The context-handler must have two different configurations, one in the main module of the application and one in the angular element that is loaded by the main application.

### Installation

```bash
npm install @afe/context-handler@^3.2.0
```

### BASE Main Module

In the example below, the main module of the application is `app.module`

``` TS
//app.module.ts
import { contextHandlerConfig } from './config/context-handler.config';

import { ContextHandlerModule, SessionContextService, WorkspaceContextService } from '@afe/context-handler';


@NgModule({
    imports: [
        ContextHandlerModule.forRoot(contextHandlerConfig),
    ],
})
export class AppModule {}

```

In the example below, the Context Handler configuration file is `config/context-handler.config.ts`

``` TS
export const contextHandlerConfig: ContextHandlerConfig = {
    contextName: 'base',
    contextSessionKeys: ['SESSION_CONTEXT'],
    contextWorkspaceKeys: ['WORKSPACE_CONTEXT'],
};
```

### Module of the loaded element

In the example below, the main module of the Element is `'element.module.ts`.

``` TS
import { InheritedContextHandlerModule } from '@afe/context-handler/inherited';

@NgModule({
    imports: [
        InheritedContextHandlerModule.forRoot({ enableExperimentalEvents: true }),
    ],
})
export class AppModule {}
```

## Implementation

The implementation of the context-handler with Angular Elements is described in the following documentation: [AFE | Context-Handler](https://confluence.santanderbr.corp/display/AFE/3.x.x+%7C+Context+Handler)
