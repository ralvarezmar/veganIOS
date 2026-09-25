# `MicrofrontContainerDirective`

## Description

This directive will be used in a microfront wrapper in the Shell, working together with the MicrofrontDirective (the one that the main Microfront component needs to extend from).

It is in charge of helping to load the remote JavaScript file generated in the Microfront, as well as solving common issues such as routing.

## Properties

| Name | Type | Description |
|---|---|---|
| `microfrontTechnicalGrouping` | `string` | Abstract. Key corresponding to the microfront technical grouping. Example: `microfrontTechnicalGrouping = 'f-ng-12345678-pg-microfront'` |
| `mountPath` | `string` | Abstract. Microfront mounting path. Example: Url: `http://localhost:4200/route-a/microfront` `mountPath = 'route-a/microfront'` |
| `baseRemoteMfe` | `string` (optional) | Path where the microfront is deployed. Example: `http://localhost:8001` or `http://localhost:8001/rost/my-microfront` |
| `microfrontRef` | `viewChild.required<ElementRef>('microfrontRef')` | Required. It is the Microfront html element reference using Angular's viewChild API. It is essential to add the reference in the template. Example: `<microfront-tag #microfrontRef>` |
| `isLoaded` | `signal<boolean>` | Default value: `signal(false)`. Indicates if the microfront is loaded. |
| `localeId` | `string` | Protected. i18n identifier. The directive will use the Shell LOCALE_ID to load the microfront with the correct language. It can be overwritten if necessary when the Shell is not using the standard Angular internationalization. |
| `navigationConfigMap` | [`NavigationConfigMap`](types/navigationconfigmap-navigationconfig.md) | Static Optional. Information related to the navigation of the projects involved. The information of every project can be obtained by the project id |

## Methods

### `loadRemoteError()`

``` ts
abstract loadRemoteError(error: unknown): any
```

Method to be invoked when the microfront could not be obtained.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `error` | `unknown` | Error that is dispatched when loading the microfront is not possible |

#### Returns

`any`

### `ngOnInit()`

``` ts
async ngOnInit(): Promise<void>
```

`ngOnInit` Angular lifecycle hook.

Method of initialization of `MicrofrontContainerDirective`.

First of all, it will attempt to get the manifest file in order to know the version of the microfront to be loaded. The format of the request will be done with the following format:

- If `baseRemoteMfe` is provided: `<baseRemoteMfe>/manifest.json?<timestamp>`
- Otherwise: `<microfrontTechnicalGrouping>/manifest.json?<timestamp>`

The `microfrontTechnicalGrouping` is the one specified as a property.

If there is any issue getting this manifest, the following error will be thrown:

``` text
Fail to fetch the microfront manifest data.
```

If the manifest file is successfully retrieved, it will attempt to load the Microfront as a module using the technical grouping and version.
In case of an error, the [`loadRemoteError()`](microfrontcontainerdirective.md#loadremoteerror) method will be triggered.

If the microfront was successfully loaded, the value of the [`isLoaded`](#properties) signal will be set to `true`.

#### Returns

`Promise<void>` - An empty promise when microfront initialization is done.

### `navigate()`

``` ts
public navigate(event: Event): void
```

Captures the `externalNavigate` event of the microfront to navigate from the Shell to other Microfront or the Shell itself.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `event` | `Event` | Event with path or [MicrofrontNavigation](types/microfrontnavigation.md) into detail |

### `getMicrofrontNavigationProps<T>()`

``` ts
public getMicrofrontNavigationProps<T>(): T | undefined
```

Gets all the props of type `MicrofrontNavigation`.

#### Returns

`T | undefined` - The navigation props.

### `normalizeLocale()`

``` ts
protected normalizeLocale(localeId: string): string
```

Method that normalizes the locale when the i18n identifier is not the standard. It can be overwritten if necessary.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `localeId` | `string` | Shell i18n identifier. It may not be standardized |

#### Returns

`string` - Standardized i18n identifier

#### Example

``` ts
protected override normalizeLocale(locale: string): string {
  switch (locale) {
    case 'es-MX': // When the shell is in spanish from Mexico, the spanish microfront with no location is loaded
      return 'es';
    default:
      return locale;
  }
}
```

### `static setNavigationConfigMap()`

``` ts
static setNavigationConfigMap(navigationConfigMap: NavigationConfigMap): void
```

It receives the object with the information and makes a map from it in order for all the instances of MicrofrontContainerDirective to be able to use it.

#### Parameters

| Name | Type | Description |
|---|---|---|
| `navigationConfigMap` | [`NavigationConfigMap`](types/navigationconfigmap-navigationconfig.md) | Object to parse that will be used by the Shell in order to do navigations directed to other Microfronts |

## Usage notes

### Typescript

``` ts
export interface MyProps {
  returnTo: MicrofrontNavigationTarget | undefined;
  myFirstProp: boolean;
  mySecondProp: boolean;
}

export class ExampleComponent extends MicrofrontContainerDirective {
  constructor() {
    super();

    // GetNavigationProps will return the object passed in the MicrofrontNavigation
    // Example:
    /*
      {
        returnTo: 'check-routes',
        myFirstProp: true,
        mySecondProp: false
      }
    */
    const myProps: MyProps | undefined = this.getMicrofrontNavigationProps<MyProps>();
    if (myProps) {
      this.returnTo = myProps.returnTo;
      this.myFirstProp = myProps.myFirstProp;
      this.mySecondProp = myProps.mySecondProp;
    }
  }

  microfrontTechnicalGrouping = 'f-ng-12345678-pg-microfront';
  mountPath = '/microfront-path';

  loadRemoteError(error) {
     ...
  }

  override async ngOnInit(): Promise<void> {
    await super.ngOnInit();
    ...
  }
}
```

### HTML

``` html
@if (isLoaded()) {
  <microfront-tag
    #microfrontRef
    [mountPath]="mountPath">
  </microfront-tag>
}
```
