# `MountpathService`

## Description

Service used to retrieve the mount path configured.

``` ts
export abstract class MountPathService {
  public abstract readonly mountPath$: Observable<string>;
}
```

## Properties

| Property | Description |
|---|---|
| `abstract readonly mountPath$: Observable<string>` | Observable that will retrieve the mountPath detected. |

## Usage notes

In the component that extends from `MicrofrontDirective`, this class should be passed through the `super` constructor.

``` ts
export class AppComponent extends MicrofrontDirective implements OnInit, OnDestroy {
  ...
  
  constructor(
    private readonly _mountPathService: MountPathService,
    private readonly _securityLiteService: SecurityLiteService
  ) {
    super(_mountPathService, _securityLiteService);
  }
```

### Example

``` ts
private async _initAppComponent(): Promise<void> {
  await this._securityLiteService.initialize();
  // mountPath is available after is set
  this._mountPathService.mountPath$.subscribe(
    (mountPath: string) => console.log(`mountPath: ${mountPath}`)
  );
}
```
