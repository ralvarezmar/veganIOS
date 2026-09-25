# Authorization Manager (Angular 16)

## Prerequisites

- Installation of [***@afe/http-interceptors***](../../http-interceptors/v4/index.md)

## Configuration

To configure ***@afe/authorization-manager*** simply import it into the main module of the application. The ***forRoot*** method receives an object of type ***AuthorizationManagerConfig*** that has the following properties:

| Property | Description |
| ----------- | --------- |
| **connectors** | Used to implement permission fetching through [connectors](./connectors/index.md). |
| **keyMappingConfig** <span class="afe-badge badge--warning">optional</span> | Used to perform a ***from-to*** of permission keys |
| **encryptionResolver** <span class="afe-badge badge--warning">optional</span> | Used to provide a class with a 'decrypt' method that will be responsible for decrypting sensitive data. If no value is passed, the ***EncryptionService*** class of ***@afe/encryption***, will be used. |

In the ***connectors*** property, it is mandatory to **configure at least one connector** and **call the initialization method** of ***PermissionService*** to initiate permissions.

> To learn more about each connector, go to the section on [connectors](./connectors/index.md).

### Configuration Example

The example below is adapted for scenarios where the project uses a custom encryption class, other than **@afe/encryption**. In this sense.

It is necessary to create a class that implements the interface ***IEncryptionResolver*** and pass it as a parameter to the ***forRoot*** method of the ***AuthorizationManagerModule***.

``` TS
//app.module.ts
import { AuthorizationManagerModule} from '@afe/authorization-manager';

import { Connector, KeyMappingConfig } from '@afe/authorization-manager';
import { mbsConnector } from '@afe/authorization-manager/mbs-connector';

import { EncryptionService } from '@afe/encryption';
import { AuthorizationManagerConfig, IEncryptionResolver } from '@afe/authorization-manager';

const connectorsConfig = connectorsFn(): Array<Connector> {
    return [
        mbsConnector({
            appCode: '<YOUR_SYSTEM_CODE>',
            appKey: '<YOUR_APP_KEY>',
        }),
    ];
}

const keyMappingConfig: KeyMappingConfig = {
    default: {
        ['PRINCIPAL-DEFAULT']: 'PRINCIPAL'
    },
    leanAcordo: {
        ['PRINCIPAL-LEAN']: 'PRINCIPAL'
    }
};

@Injectable({
     providedIn: 'root'
})
export class CustomEncryptionService implements IEncryptionResolver {
  public decrypt(value: string): string {
      // implementação da interface que retorna o valor do método de descriptografia customizado
      return this.descriptografar(value);
  }
*
  public descriptografar(value: string): string {
      // lógica do método de descriptografia customizado
  }
}

@NgModule({
    imports: [
        ...
        AuthorizationManagerModule.forRoot({
            connectors: connectorsConfig,
            keyMappingConfig,
            encryptionResolver: CustomEncryptionService
        }),
        ...
    ],
})
```

> The values `<YOUR_SYSTEM_CODE>` and `<YOUR_APP_KEY>` should be replaced with the respective values of your project.

## Implementation

- Go to the session on [connectors](./connectors/index.md) to proceed with the implementation.
