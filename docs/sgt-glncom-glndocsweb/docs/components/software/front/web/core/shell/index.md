# @santander/shell

!!! warning
    The component is currently in "release candidate" version so is not recommended to use it yet in production.

## Functional overview

`@santander/shell` is a library that offers a **simple method for integrating microfrontends from various technologies**.

Simply adding the type of microfrontend and the required configuration is all that's needed to incorporate a specific microfrontend.

## SanMicrofront Component

When you include the `shell` package, a `san-microfront` Web Component is defined in order to be used to load microfronts dynamically.

Once the property config is set, the SanMicrofront component will try to load the microfront.

## Plugin Configuration

In order to use the SanMicrofront WebComponent, you need to use a related plugin, depending on the technology you are using.

### Darwin

```typescript
interface MicrofrontConfigDarwin {
  type: LoadPluginType.Darwin;
  render?: SanMicrofrontRender;

  remoteEntry: string[];
  tag: string;
}
```

### React ODS

```typescript
interface MicrofrontConfigODS {
  type: LoadPluginType.ODS;
  render?: SanMicrofrontRender;
  
  projectId: string;
  verticalId: string;
  variant: string;
  
  initializers: VerticalInitializersType;
}
```

### Render

You can customize how you want the microfront to be rendered. There are two options: DOM, SHADOW_DOM.
The render attribute must be specified in the configuration using SanMicrofrontRender type.

Example:

```typescript
config = {
    ...
    render: SanMicrofrontRender.DOM,
    ...
}

```

By default, SHADOW_DOM will be applied.

## Manage Errors

Errors will occur in the following scenarios:

- Attempting to specify a plugin that is not recognized or supported.

- Providing an incorrect or invalid configuration for the specified plugin.
