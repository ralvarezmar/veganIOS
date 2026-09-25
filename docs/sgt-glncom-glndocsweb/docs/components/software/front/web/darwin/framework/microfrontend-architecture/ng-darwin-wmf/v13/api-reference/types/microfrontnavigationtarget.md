# `MicrofrontNavigationTarget`

Type used with [MicrofrontNavigation](./microfrontnavigation.md) to indicate the path/project id of the microfront, can specify an entryPoint, or attach information of where should return the next Microfront.

``` ts
export type MicrofrontNavigationTarget = {
  /** Path/ProjectId to navigate */
  target: string;
  /** If included, it will navigate to a specific part of the project detail, if not, to the root */
  entryPoint?: string;
  /** Nested returnTo for complex cases */
  returnTo?: MicrofrontNavigationTarget;
};
```

## Example usages

Example usage (the `MicrofrontNavigation` is the `to`):

``` ts
/** Goes to micro B passing return to to micro A */
public inicioPrimerFlujo(): void {
  const microfrontNavigation: MicrofrontNavigation = {
    to: {
      target: 'f-ng-00000000-pg-microfront-b',
      entryPoint: 'laboratoryExternal',
      returnTo: {
        target: 'f-ng-00000000-pg-microfront',
        entryPoint: 'laboratoryExternal'
      }
    }
  };
  this.externalNavigate.emit(microfrontNavigation);
}
```
