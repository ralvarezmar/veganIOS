# Lifecycle and Common Events

## Introduction

When working with Microfronts, our directives [`MicrofrontDirective`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md) and [`MicrofrontContainerDirective`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md)
have some specific logic for the lifecycle of those components and specific events to perform some actions in order to work and achieve extra functionalities.

## MicrofrontDirective

### Lifecycle

If the class extending from [`MicrofrontDirective`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md) needs to use these hooks, these methods should be overrode and calling their super method is mandatory.

#### ngOnInit

[`ngOnInit`](https://angular.dev/api/core/OnInit){: target="_blank"} Angular lifecycle hook.

Executing this method will allow the Microfront to receive information through `@Inputs` and will initialize the Microfront navigation and also emits the mount path through the [`MountPathService`](../ng-darwin-wmf/v20/api-reference/mountpathservice.md).

Note that this function should be `async` in order to `await` the `ngOnInit` execution.

``` ts
override async ngOnInit(): Promise<void> {
  await super.ngOnInit();
  // Custom logic of the Microfront
}
```

#### ngOnDestroy

[`ngOnDestroy`](https://angular.dev/api/core/OnDestroy){: target="_blank"} Angular lifecycle hook.

Executing this method handles the de-instantiation of the security when the Microfront is destroyed.

``` ts
override ngOnDestroy(): void {
  super.ngOnDestroy();
  // Custom logic of the Microfront
}
```

### Common output events

Several communication events have been standardized at the Microfront level, which can be listened from the Shell application if necessary.

#### initialize

It will indicate when the Microfront has been initialized, by default it is recommended to use it at the end of the `ngOnInit` method.

``` ts
override async ngOnInit() {
  await super.ngOnInit();
  // Custom logic of the Microfront
  this.initialize.emit();
}
```

#### destroy

It will indicate when the Microfront instance has been destroyed or is no longer alive, by default it is recommended to use it at the end of the `ngDestroy` method.

``` ts
override async ngOnDestroy() {
  await super.ngOnDestroy();
  // Custom logic of the Microfront
  this.destroy.emit();
}
```

#### error

It should indicate when an uncontrolled error has occurred within the Microfront, so a more generic error control can be implemented at the Shell application level for example destroying the Microfront if necessary and/or resetting it.

``` ts
// Microfront implementation private _businessLogicOperation(): void {
  try {
    // Custom logic of the Microfront
  } catch(e) {
    this.error.emit(e);
  }
}
```

This event can be handled by the class that extends from [`MicrofrontContainerDirective`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md).

``` html
<!-- Shell implementation that loads the previous Microfront -->
<f-ng-00000000-pg-microfront
  (error)="handleMicrofrontError($event)">
</f-ng-00000000-pg-microfront>
```

``` ts
// Shell implementation that loads the previous Microfront
protected handleMicrofrontError(error: CustomEvent): void {
  console.log(error.detail);
  // Custom logic for handling the error
}
```

For this event we have extended documentation here: [Error Handling](error-handling.md) .

#### breadcrumb

This event will inform the Shell of the available information of the breadcrumb for its Microfront. It will have to be emitted whenever there are modifications to it.

For this event we have extended documentation here [Breadcrumbs](breadcrumbs.md) .

#### externalNavigate

This event enables the navigation through the Shell and different Microfronts allowing to pass information among them.

For this event we have extended documentation here [Navigation Outside the Microfront](navigation-outside-the-microfront.md) .

## MicrofrontContainerDirective

### Lifecycle

If the class extending from [`MicrofrontDirective`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md) needs to use these hooks, these methods should be overrode and calling their super method is mandatory.

#### ngOnInit

[`ngOnInit`](https://angular.dev/api/core/OnInit "https://angular.dev/api/core/OnInit"){: target="_blank"} Angular lifecycle hook.

Executing this method will allow the [`MicrofrontContainerDirective`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md) to load the child Microfront through the variable `microfrontTechnicalGrouping` and recovering the manifest file.
After successfully loading the microfront, the variable `isLoaded` will have the value `true`.

Note that this function should be `async` in order to `await` the super `ngOnInit` execution.

```html
<!-- Shell html implementation that loads the previous Microfront -->
@if (isLoaded()) {
  <mf-ng-00000000-darwinProject></mf-ng-00000000-darwinProject>
}
```

``` ts
export class Mcf extends MicrofrontContainerDirective {
  // Mandatory in order to load the microfront
  microfrontTechnicalGrouping = 'mf-ng-00000000-darwinProject';
  override async ngOnInit(): Promise<void> {
    await super.ngOnInit(); // Custom logic of the MicrofrontContainer after the Microfront has been loaded
  }
}
```

#### loadRemoteError

Custom lifecycle hook.

This is a custom hook that provides this directive. It is an `abstract` method that should be implemented and it will get called when the Microfront could not be loaded.
Internally, when the `ngOnInit` previously commented tries to load the Microfront and if it was not able to do it, it will execute this method, allowing the Angular component that is loading the Microfront to execute code in that case.

``` ts
export class Mcf extends MicrofrontContainerDirective {
  loadRemoteError(error: unknown): void {
    //This method gets executed when the load fails in the ngOnInit
    console.log('loadRemoteError: ', error);
    //Custom logic when the Microfront was not loaded succesfully
  }
}
```

#### ngOnDestroy

[`ngOnDestroy`](https://angular.dev/api/core/OnDestroy "https://angular.dev/api/core/OnDestroy"){: target="_blank"} Angular lifecycle hook.

Executing this method handles some de-subscription in the class due to navigation events.

``` ts
override ngOnDestroy(): void {
  super.ngOnDestroy();
  // Custom logic of the Microfront
}
```
