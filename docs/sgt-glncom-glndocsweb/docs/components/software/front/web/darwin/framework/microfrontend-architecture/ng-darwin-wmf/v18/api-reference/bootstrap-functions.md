# Bootstrap Functions

## Description

These functions are responsible for bootstrapping Shell and Microfront applications in the Darwin WMF architecture. They handle the proper initialization of Angular applications with support for Webpack Module Federation and custom elements.

## Functions

### `bootstrapShell()`

```ts
async function bootstrapShell(
  component: Type<any>,
  options?: ApplicationConfig | undefined
): Promise<ApplicationRef>
```

Function that bootstraps a Standalone Shell application.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `component` | `Type<any>` | Root Component. Example: `App` |
| `options` | `ApplicationConfig` (optional) | Config of the Component. Example: `appConfig` |

#### Returns

`Promise<ApplicationRef>` - A promise that returns an ApplicationRef instance once resolved.

#### Usage Example

```ts
import { bootstrapShell } from '@ng-darwin-wmf/microfront';
import { App } from './app/app';
import { appConfig } from './app/app.config';

bootstrapShell(App, appConfig)
  .catch(err => console.error(err));
```

### `bootstrapMFE()`

```ts
async function bootstrapMFE(
  tagName: string,
  component: Type<any>,
  options: ApplicationConfig = { providers: [] }
): Promise<ApplicationRef>
```

Function that bootstraps a Standalone Microfront (MFE) application.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `tagName` | `string` | Tag name of the MFE. It will be used to define the WebComponent |
| `component` | `Type<any>` | Root Component. Example: `App` |
| `options` | `ApplicationConfig` | Config of the component. Example: `appConfig` |

#### Returns

`Promise<ApplicationRef>` - A promise that returns an ApplicationRef instance once resolved.

#### Usage Example

```ts
import { bootstrapMFE } from '@ng-darwin-wmf/microfront';
import { App } from './app/app';
import { appConfig } from './app/app.config';

bootstrapMFE('my-microfront-tag', App, appConfig)
  .catch(err => console.error(err));
```

### `bootstrapMFENonStandalone()`

```ts
async function bootstrapMFENonStandalone<M>(
  module: Type<M>,
  compilerOptions?: (CompilerOptions & BootstrapOptions) | Array<CompilerOptions & BootstrapOptions>
): Promise<NgModuleRef<M>>
```

Function that bootstraps a MFE non-standalone (module-based) application.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `module` | `Type<M>` | Module to bootstrap |
| `compilerOptions` | `(CompilerOptions & BootstrapOptions) \| Array<CompilerOptions & BootstrapOptions>` (optional) | Compiler options of Angular |

#### Returns

`Promise<NgModuleRef<M>>` - A promise that returns a NgModuleRef instance once resolved.

#### Usage Example

```ts
import { bootstrapMFENonStandalone } from '@ng-darwin-wmf/microfront';
import { AppModule } from './app/app.module';

bootstrapMFENonStandalone(AppModule)
  .catch(err => console.error(err));
```
