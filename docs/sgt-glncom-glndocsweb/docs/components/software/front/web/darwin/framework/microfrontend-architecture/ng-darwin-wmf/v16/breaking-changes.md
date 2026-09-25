# Breaking Changes

The property `queryParams` of the type `MicrofrontNavigation` now instead of being a Map, is an object key and value string.

Before

```ts
export type MicrofrontNavigation = {
  to: MicrofrontNavigationTarget;
  queryParams?: Map<string, string>;
  props?: { [key: string]: unknown };
  data?: any;
};
```

After

```ts
export type MicrofrontNavigation = {
  to: MicrofrontNavigationTarget;
  queryParams?: { [key: string]: string };
  props?: { [key: string]: unknown };
  data?: any;
};
```
