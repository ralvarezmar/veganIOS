# `MountPathService`

## Description

Service used to retrieve the mount path configured.

To subscribe to the mount path changes, use `mountPath$`. If a subscription is done after any mount path was emitted, the last value will be provided.

``` ts
@Injectable({
  providedIn: 'root'
})
export abstract class MountPathService {
  public abstract readonly mountPath$: Observable<string>;
}
```

## Properties

| Property | Description |
|---|---|
| `abstract readonly mountPath$: Observable<string>` | Observable that will retrieve the mountPath detected. |

## Usage notes

In the component that extends from `MicrofrontDirective`:

``` ts
export class App extends MicrofrontDirective {
  private _mountPathService = inject(MountPathService);
}
```

### Example

``` ts
private async _initApp(): Promise<void> {
  await this._securityLiteService.initialize();
  // mountPath is available after is set

  this._mountPathService.mountPath$.subscribe(
    (mountPath: string) => console.log(`mountPath: ${mountPath}`)
  );
}
```
