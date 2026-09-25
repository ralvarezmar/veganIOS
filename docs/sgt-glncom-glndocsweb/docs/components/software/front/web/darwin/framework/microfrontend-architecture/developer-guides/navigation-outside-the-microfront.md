# Navigation outside the Microfront

## Introduction

!!! note
    Important terminology:  
    **Microfront**: the component which extends from the [`MicrofrontDirective`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md)  
    **Microfront wrapper**: the component which extends from the [`MicrofrontContainerDirective`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md).

Currently, navigation across Microfronts is facilitated through the [`externalNavigate`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md/#externalnavigate) event. This event enables navigation in a similar way to how it is handled in Angular. But in the context of working with multiple Microfronts and incorporating information from other Microfronts to accommodate complex use cases, this regular navigation may not support all the functionalities needed in such scenarios. <!-- markdownlint-disable MD013 -->

To this complex scenarios can be accomplished a [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md) type has been developed. It can be used as a parameter to emit the [`externalNavigate`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md/#externalnavigate) event.
This type includes the necessary features to implement this new approach to navigation.

## `NavigationConfigMap` set up

In order to use some functionalities such as navigating through the projectId the Shell has to contain the [`NavigationConfigMap`](../ng-darwin-wmf/v20/api-reference/types/navigationconfigmap-navigationconfig.md).
The library exports a static method of the [`MicrofrontContainerDirective`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md) called [`setNavigationConfigMap`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md/#static-setnavigationconfigmap). This method receives an object with the [`NavigationConfigMap`](../ng-darwin-wmf/v20/api-reference/types/navigationconfigmap-navigationconfig.md). This object could be retrieved by an `appInitializer`.

Example:

``` ts
// AppConfigService implementation in Shell
/**
 * Loads the json config
 *
 * @returns The suscription of the json object
 */
loadAppConfig(): Promise<void | Object> {
  return firstValueFrom(this._http.get('./assets/navigationConfigMap.json'))
    .then( json => json && MicrofrontContainerDirective.setNavigationMap(json as NavigationConfigMap));
}
```

This configuration is required in order to take advantage of the feature of using a projectId as a destination when a [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md) is performed.

### How to perform navigation between Microfronts

[`externalNavigate`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md/#externalnavigate) is an event that accepts a `string` or a [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md).
This `string` can be or the route assigned to the Microfront from the Shell, or, the project identifier that later can be processed using the [`NavigationConfigMap`](../ng-darwin-wmf/v20/api-reference/types/navigationconfigmap-navigationconfig.md).
On the other side, `MicrofrontNavigation` allows to specify what Microfront are we going to, plus the `entryPoint` and brings the option to attach information.

## Usage

### Microfront A wants to navigate to Microfront B with path

``` ts
// Microfront A implementation
externalNavigate.emit('urlToMicrofrontB')
```

``` ts
// Routing of the shell implementation
{
  path: 'urlToMicrofrontB',
  children: [
    { path: '**', component: MicrofrontB }
  ]
}
```

With this, we navigate to the route of the Microfront B wrapper that will load the Microfront B.

### Microfront A wants to navigate to Microfront B with project identifier

``` ts
// Microfront A implementation
externalNavigate.emit('f-ng-00000000-microfront-b')
```

``` json
// Shell NavigationConfigMap
{
  // OTHER MICROFRONTS,
  "f-ng-00000000-microfront-b": {
    "root": "urlToMicrofrontB",
    "entryPoints": {
      "1": "first-child",
      "2": "second-child"
    }
  }
}
```

``` ts
// Routing of the shell implementation
{
  path: 'urlToMicrofrontB',
  children: [
    { path: '**', component: MicrofrontB }
  ]
}
```

Using this code we are able to navigate to the route of the Microfront B wrapper which will load the Microfront B, because we specify the projectIdentifier (root property of **f-ng-00000000-microfront-b** in the Shell [`NavigationConfigMap`](../ng-darwin-wmf/v20/api-reference/types/navigationconfigmap-navigationconfig.md)) in the [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md), that will be translated into the final route.

### Microfront A wants to navigate to Microfront B passing query params

In the Microfront A, we are going to create a `Map<string,string>` to store all the information we want to send, after that, we create an object of type [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md),
that is the one that allows us to specify where are we navigating and also attach the map. The _**to**_ is a [`MicrofrontNavigationTarget`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigationtarget.md).

``` ts
/* Goes to Microfront B passing query params */
public goToMicrofrontB(): void {
    // Object that contains all the information about the redirection. In this case,
    // in to we indicate where are we going, showing that the path in this case is the
    // project identifier of the microB, and we want to enter through an specific entryPoint
    // called laboratory external. Finally, the next property is queryParam where we attach
    // the code const microfrontNavigation:
    MicrofrontNavigation = {
        to: { target: 'f-ng-00000000-microfront-b', entryPoint: 'laboratoryExternal' },
        queryParams: {
          'mifitMode': 'client'
        }
    };
    this.externalNavigate.emit(microfrontNavigation);
}
```

Now in Microfront B wrapper, or inside the Microfront B ([`MicrofrontDirective`](../ng-darwin-wmf/v20/api-reference/microfrontdirective.md)), we can retrieve the params through `activatedRoute.queryParams`.

``` ts
// This code could be in the Shell implementation (MicrofrontContainerDirective)
// or in the Microfront navigated
ngOnInit(): void {
    this._activatedRoute.queryParams.subscribe((params) => {
        this.receivedParam = params['mifitMode'];
    });
}
```

#### Working example

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=86fdbf8d-16b1-41c7-a871-935eddb37f93&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="microfront-a-wants-to-navigate-to-microfront-b-passing-query-params.mp4"></iframe>

### Microfront A wants to navigate to Microfront B passing props

In Microfront A, we create an object of with the information we want to send to Microfront B, after that, we attach it to our [`MicrofrontNavigation`](../ng-darwin-wmf/v20/api-reference/types/microfrontnavigation.md) in the property `props`:

``` ts
/* Navigate to Microfront B passing props */
public goToMicrofrontBPassingProps(): void {
    // Object with the props are going to be sent
    const props = {
        returnTo: 'check-routes',
        myFirstProp: true,
        mySecondProp: false
    };
    // Object containing the destination of the navigation and the props are attached
    const microfrontNavigation: MicrofrontNavigation= {
        to: { target: 'f-ng-00000000-microfront-b' },
        props,
    };
    this.externalNavigate.emit(microfrontNavigation);
}
```

The navigation is done to Microfront B. After that, in the Microfront B wrapper, we can declare a type for the object with props (no required) and using the method of the directive [`getMicrofrontNavigationProps()`](../ng-darwin-wmf/v20/api-reference/microfrontcontainerdirective.md#getmicrofrontnavigationpropst), we can retrieve them:

``` ts
// Microfront B wrapper
returnTo: MicrofrontNavigationTarget | undefined;
myFirstProp: boolean | undefined;
mySecondProp: boolean | undefined;

constructor() {
  super();
  // The method getRedirectionProps of MicrofrontContainerDirective can be used
  // to retrieve the props, now, with the Shell implementation containing the
  // props, it can be passed by @Input
  const myProps: MyProps | undefined = this.getMicrofrontNavigationProps<MyProps>();
  if (myProps) {
    this.returnTo = myProps.returnTo;
    this.myFirstProp = myProps.myFirstProp;
    this.mySecondProp = myProps.mySecondProp;
  }
}
```

Now that we have the `props` stored in variables in the wrapper, we can pass them to the Microfront B through inputs.

```html
@if (isLoaded()) {
<f-ng-00000000-pg-microfront-b
  #microfrontRef
  (breadcrumb)="changeBreadcrumb($event)"
  (externalNavigate)="navigate($event)"
  [mountPath]="mountPath"
  [returnTo]="returnTo"
  [myFirstProp]="myFirstProp"
  [mySecondProp]="mySecondProp">
</f-ng-00000000-pg-microfront-b>
}
```

And then also in the Microfront B:

``` ts
@Input() myFirstProp!: boolean;
@Input() mySecondProp!: boolean;
@Input() returnTo: MicrofrontNavigationTarget | undefined;
```

This Inputs are gonna be filled with the props.

#### Working example

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=88d147c7-7d1a-4ee5-8334-bb7848a102fb&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="microfront-a-wants-to-navigate-to-microfront-b-passing-props.mp4"></iframe>

### Microfront A wants to navigate to Microfront B sending that Microfront B should return to him

There may be cases where we want to navigate to another Microfront B and send the necessary information in order to return back after Microfront B has finished his logic.

In Microfront A, we start the navigation creating a `MicrofrontNavigation` with the property `returnTo` that specifies that the return is the Microfront A itself.

``` ts
/* Goes to Microfront B passing return to to Microfront A */
public navigateToMicroB(): void {
  // Due to the fact that the Microfront A wants to go to Microfront B, but it wants to indicate
  // the Microfront b ends, we attach the property "returnTo" containing
  // the project identifier of the Microfront A and the entryPoint if desired
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-microfront-b',
      returnTo: {
        target: 'f-ng-00000000-microfront'
      }
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```

After that, in Microfront B, we have the `returnTo` information in the `@Input returnTo` which will be used when Microfront B has finished his logic and wants to return back without really knowing who called him.

``` ts
/* Finish the logic of the component and returns back */
public finishLogic(): void {
  // Other logic
  this.externalNavigate.emit(returnTo.target);
}
```

Now the Shell is again in Microfront A.

#### Working example

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=5b42becf-34c9-41f4-b858-9eef951ad370&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="microfront-a-wants-to-navigate-to-microfront-b-sending-that-microfront-b-should-return-to-him.mp4"></iframe>

### Complex navigation: Microfront A → Microfront B → Microfront C → Microfront A

There may be cases where we want to navigate to another Microfront B and send the relevant information about the place which we should return to. In this case, we are going to cover the scenario where Microfront A navigates to Microfront B, saying that Microfront B should return to Microfront A, but instead of returning directly, it navigates to Microfront C while carrying the previous information about the `returnTo`, so when Microfront C uses that information, it ends up in Microfront A.

In Microfront A, we start the navigation creating a `MicrofrontNavigation` with the property `returnTo` that specifies that the return is the Microfront A itself.

``` ts
/* Goes to Microfront B passing return to to Microfront A */
public startFirstFlow(): void {
  // Due to the fact that the Microfront A wants to go to Microfront B, but it wants to indicate
  // the Microfront b ends, we attach the property "returnTo" containing
  // the project identifier of the Microfront A and the entryPoint if desired
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-microfront-b',
      returnTo: { target: 'f-ng-00000000-microfront' }
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```

After that, in Microfront B, we have the `returnTo` information in the `@Input returnTo` which will be used when Microfront B uses the MicrofrontNavigation to navigate to Microfront C. So what we are doing is attaching in the `returnTo` property the information received.

``` ts
/* Does a redirection to Microfront c passing returnTo */
public keepTheFlow(): void {
  // In Microfront B, instead of returning directly, Microfront b navigates to Microfront C
  // but sending the information of where he should return to received from
  // Microfront A, so the returnTo is reused
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-microfront-c',
      returnTo: this.returnTo
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```

Now we in Microfront C, we have completed the use case going to new Microfronts, and now the application should return to Microfont A. To do so, the `returnTo` can be used as the `target` in the `MicrofrontNavigation`.

``` ts
/* Method to return where the returnTo says */
public goBack(): void {
  // In Microfront C, we check if the return to was received, and we used it as a
  // direction to navigate, which moves the navigation to Microfront A
  if (this.returnTo) {
    const microfrontNavigation: MicrofrontNavigation = { target: this.returnTo };
    this.externalNavigate.emit(microfrontNavigation);
  }
}
```

#### Working example

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=ab08c081-df20-463b-b1a9-f3431066845b&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="complex-navigation-microfront-a-microfront-b-microfront-c-microfront-a.mp4"></iframe>

### Complex navigation: Microfront A → Microfront B → Microfront C → Microfront B → Microfront A

For the beginning we are gonna use the same example in the code of Microfront A.

``` ts
/* Goes to Microfront B passing return to to Microfront A */
public inicioSegundoFlujo(): void {
  // Due to the fact that the Microfront A wants to go to Microfront B, but it wants to indicate
  // the Microfront b ends, we attach the property "returnTo" containing
  // the project identifier of the Microfront A and the entryPoint if desired
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-microfront-b',
      returnTo: { target: 'f-ng-00000000-microfront' }
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```

Then, in the Microfront B, instead of passing the `returnTo` directly in the property, we are going to create an envelop allowing us to create `returnTo` nested. The first `returnTo` that should be addressed is to Microfront B, and then to Microfront A (carried from the first redirection).

``` ts
/* Does a redirection to Microfront c passing return to and also that it has to return to Microfront b */
public keepTheSecondFlow(): void {
  // In Microfront B, instead of returning directly, Microfront b navigates to Microfront C
  // but Microfront B sends that the returnTo should go to Microfront B, and later
  // thanks to the nesting, to the returnTo that was already received
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-microfront-c',
      returnTo: {
        target: 'f-ng-00000000-microfront-b',
        returnTo: this.returnTo
      }
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```

In Microfront C, we use the same code as before, we only receive the `returnTo`, and execute the redirection which, in this case, will bring us back to Microfront B:

``` ts
/* Method to return where the returnTo says */
public goBack(): void {
  // In Microfront C, we check if the returnTo was received, and we use it as a
  // destination to navigate to, which moves the navigation to Microfront B and passing
  // the first returnTo
  if (this.returnTo) {
    const microfrontNavigation: MicrofrontNavigation = { to: this.returnTo };
    this.externalNavigate.emit(microfrontNavigation);
    }
  }
```

Now that the first `returnTo` has been finished, the `returnTo` has been passed is the next one. In this case, the first one that was passed was returned to Microfront A. We execute another `externalNavigate` using as value the `returnTo.target`:

``` html
<!-- Microfront B received the first returnTo, containing the destination for Microfront A -->
<button (click)="externalNavigate.emit(returnTo.target)">Return</button>
```

#### Working example

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=96fd2b8e-3d48-4a58-9c21-3e6f06d93d2e&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="complex-navigation-microfront-a-microfront-b-microfront-c-microfront-b-microfront-a.mp4"></iframe>
