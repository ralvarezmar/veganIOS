# `MicrofrontContainerDirective`

## Description

This directive will be used in a microfront wrapper in the Shell, working together with the MicrofrontDirective (the one that the main Microfront component needs to extend from).

It is in charge of helping to load the remote JavaScript file generated in the Microfront, as well as solving common issues such as routing.

## Properties

| Name | Description |
|---|---|
| `microfrontTechnicalGrouping`: `string` | Abstract. Key corresponding to the microfront technical grouping. Example: `microfrontTechnicalGrouping = 'f-ng-12345678-pg-microfront'` |
| `mountPath`: `string` | Abstract. Microfront mounting path. Example: Url: `http://localhost:4200/route-a/microfront` `mountPath = 'route-a/microfront'` |
| `microfrontRef`: `ElementRef` | Optional. It is the Microfront html element reference (`@ViewChild` of Angular API). It is essential to add the reference in the template. Example: `<microfront-tag #microfrontRef>` |
| `isLoaded`: `boolean` | Default value: `false`. Indicates if the microfront is loaded. |
| `navigationConfigMap`: [`NavigationConfigMap`](types/navigationconfigmap-navigationconfig.md) | Static Optional. Information related to the navigation of the projects involved. The information of every project can be obtained by the project id |

## Methods

### `loadRemoteError()`

``` ts
abstract loadRemoteError(error: unknown): any
```

Method to be invoked when the microfront could not be obtained.

#### Parameters

| Name | Description |
|---|---|
| `error`: `uknown` | Error that is dispatched when loading the microfront is not possible |

#### Returns

`any`

### `ngOnInit()`

``` ts
override async ngOnInit(): Promise<void>
```

`ngOnInit` Angular lifecycle hook.

Method of initialization of `MicrofrontContainerDirective`.

First of all, it will attempt to get the manifest file in order to know the version of the microfront to be loaded. The format of the request will be done with the following format:

`<microfrontTechnicalGrouping>/manifest.json?<timestamp>`

The `microfrontTechnicalGrouping` is the one specified as a property.

If there is any error getting this manifest, the following standard manifest will be served:

``` json
{
  santander: { version: <timestamp> }
}
```

Then, it will try to load the microfront as a module using the technical grouping and the version. In case of any error, the [`loadRemoteError()`](microfrontcontainerdirective.md#loadremoteerror) method will be invoked.

If the microfront was successfully loaded, the [isLoaded](#properties) property will be set to `true`.

#### Returns

`Promise<void>:` An empty promise when microfront initialization is done.

### `ngOnDestroy()`

``` ts
override ngOnDestroy(): void
```

`ngOnDestroy` Angular lifecycle hook.

It will reset the data necessary in the security instance to avoid issues in the case that the microfront is loaded more than once.

### `navigate()`

``` ts
public navigate(event: Event)
```

Captures the `externalNavigate` event of the microfront to navigate from the Shell to other Microfront or the Shell itself.

#### Parameters

| Name | Description |
|---|---|
| `event`: `Event` | Event with path or [MicrofrontNavigation](types/microfrontnavigation.md) into detail |

### cleanProps()

``` ts
public cleanProps(path: string)
```

It cleans the data assigned to the current ActivatedRoute that was passed by props.

#### Parameters

| Name | Description |
|---|---|
| `path`: `string` | Path of the Microfront where the props are assigned |

### `getMicrofrontNavigationProps<T>()`

``` ts
public getMicrofrontNavigationProps<T>(): T | undefined
```

Gets all the props of type `MicrofrontNavigation`.

#### Returns

The navigation props.

### `static setNavigationConfigMap()`

``` ts
static setNavigationConfigMap(navigationConfigMap: NavigationConfigMap): void
```

It receives the object with the information and makes a map from it in order for all the instances of MicrofrontContainerDirective to be able to use it.

#### Parameters

| Name | Description |
|---|---|
| `navigationConfigMap`: [`NavigationConfigMap`](types/navigationconfigmap-navigationconfig.md) | Object to parse that will be used by the Shell in order to do navigations directed to other Microfronts |

## Usage notes

### Typescript

``` ts
export interface MyProps {
  returnTo: MicrofrontNavigation | undefined;
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
        myFirstProp: true
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

  ngOnDestroy(): void {
    super.ngOnDestroy();
    ...
  }
}
```

### HTML

``` html
<microfront-tag
  #microfrontRef
  *ngIf="isLoaded"
  [mountPath]="mountPath">
</microfront-tag>
```
