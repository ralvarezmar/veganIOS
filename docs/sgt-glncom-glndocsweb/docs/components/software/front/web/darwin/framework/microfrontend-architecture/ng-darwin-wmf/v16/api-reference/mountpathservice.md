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

In the component that extends from `MicrofrontDirective`,

``` ts
export class AppComponent extends MicrofrontDirective {
  private _mountPathService = inject(MountPathService);
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
