# `MicrofrontNavigation`

Type that can be used for the event [externalNavigate](../microfrontdirective.md#externalnavigate) in order to navigate through microfronts with some extra logic.

``` ts
export type MicrofrontNavigation = {
  /** Id of the desired technical group to navigate || route to navigate */
  to: MicrofrontNavigationTarget;
  /** Query params that will be included in the redirection and could be retrieved in the destination */
  queryParams?: Map<string, string>;
  /** Information that can be passed to the mcf navigated through @Inputs */
  props?: { [key: string]: unknown; };
  /** Any extra data that the ShellRedirection could contain for any purpose */
  data?: any;
};
```

Should be used when a microfront wants to navigate to another microfront passing queryParams, props, or with logic of returning later to itself or to another microfront.

## Example usages

### When micro A wants to go to micro B passing query params

Example:

``` ts
const payload: Map<string, string> = new Map();
payload.set('mifitMode', 'client');
const microfrontNavigation: MicrofrontNavigation = {
  to: {
    target: 'f-ng-00000000-pg-microfront-b'
  },
  queryParams: payload
};
this.externalNavigate.emit(microfrontNavigation);
```

### When micro A wants to go to micro B passing props

``` ts
const props = {
  returnTo: 'check-routes',
  myFirstProp: true,
  mySecondProp: false
};

const microfrontNavigation: MicrofrontNavigation = {
  to: {
    target: 'f-ng-00000000-pg-microfront-b'
  },
  props: props
};
this.externalNavigate.emit(microfrontNavigation);
```

### When from micro A want to go to micro B passing a return to

``` ts
const microfrontNavigation: MicrofrontNavigation = {
  to: {
    target: 'f-ng-00000000-pg-microfront-b',
    returnTo: {
      target: 'f-ng-00000000-pg-microfront'
    }
  }
};
this.externalNavigate.emit(microfrontNavigation);
```
