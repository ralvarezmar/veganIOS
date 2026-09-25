# Encryption Module

> **Warning:**
>
> This module will be discontinued in the future.
> Instead use the [DLDHEncryptionModule](./dldh-encryption-module.md) for version 10.x or [DLECCEncryptionModule](./dlecc-encryption-module.md) for version 6.x or 8.x of the encryption component of the "Security Solutions" team.

Module responsible for acting together with the part ***@afe/dlb-sdk*** in version ***v1*** and ***v2*** (which is installed together with the configuration step during the questions asked by the part).

In which they are compatible with the encryption component in versions ***6.x*** and ***8.x*** respectively.

> For more information, see the library documentation [***@afe/dlb-sdk***](../../../dlb-sdk.md).

## Encryption API

The ***EncryptionModule*** maintains the need for coexistence for the obsolete versions of the Cryptographic Security API (***cryptographic-security***) of the "Security Solutions" team for consumption of the resource ***/key/public/js***.

Serving as a use for an application that uses outdated versions of the API and consumes services from a backend also outdated with versions of the component.

If the application needs to use the service without the ***JS*** at the end, use the [***DLDHEncryptionModule***](./dldh-encryption-module.md) module.

> For more information, see the documentation on [***Key Exchange***](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves).
> **Note**
>
> It may be that the backend that the application will consume is not on the latest version of encryption for compliance and latest requirements by the security team.
> If this is the scenario, please contact the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642) team.

## Prerequisite

Globally install the Angular CLI according to the version of ***@angular/cli*** in your project.

> **Note**
>
> * The library supports Angular versions ***8*** and ***10*** of it.
> * The `<VERSION>` variable should be replaced with the ***major*** version of the Angular compatible with the part.

```bash title='Terminal'
npm install -g @angular/cli@^<VERSION>
```

## Configuration

After answering the questions in the installation process, the settings will be performed automatically in the project.

The ***encryption.config.ts*** file will be automatically created in the ***config*** folder (configuration pattern adopted by the Frontend Architecture), exporting a configuration variable that will be used in the structuring module.

The exported variable includes ***EncryptionConfig***, with the following properties as a typing interface:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **url** | ***string*** | Key Exchange Service Address (Cryptographic Context) |
| **systemCode** | ***string***| System Acronym (Application) |
| **storage** | ***StorageConfig*** | Configuration key to set the storage location and custom name of the tickets for the crypto session that was opened |

> **Note:**
>
> The variables `<VERSION-API>`, `<YOUR-APP-KEY>`, `<YOUR-SYSTEM-CODE>`, `<YOUR-CUSTOM-SERVER-PUBLIC-KEY>`, `<YOUR-CUSTOM-TICKET>` in the sample code below must conform to the answers to the questions asked during the installation step.

``` TS
//config/encryption.config.ts
import { EncryptionConfig, Storages } from '@afe/encryption';

export const encryptionConfig: EncryptionConfig = {
    url: '/hub-url/cryptographic-security/<VERSION-API>/key/public/js?gw-app-key=<YOUR-APP-KEY>',
    systemCode: '<YOUR-SYSTEM-CODE>',
    storage: {
        keys: {
            serverPublicKey: '<YOUR-CUSTOM-SERVER-PUBLIC-KEY>',
            ticket: '<YOUR-CUSTOM-TICKET>'
        },
        type: Storages.MemoryStorage
    }
};
```

> If no custom information has been registered, by default, the ***storage*** property will have the ***type*** key with the value of **MemoryStorage** and the values of the ***keys*** property keys such as **serverPublicKey** and **ticket**.

The EncryptionModule will be added to the main module of the AppModule, and the forRoot method will be parameterized by the variable exported from the configuration file mentioned earlier.

``` TS
//app.module.ts
import { EncryptionModule } from '@afe/encryption';
import { encryptionConfig } from './config/encryption.config';

@NgModule({
    imports: [
        EncryptionModule.forRoot(encryptionConfig),
    ],
})
export class AppModule { }
```

### ***Storage Customization***

If you need to change the **name of the keys** or the **storage location** in the browser to store the data of the encryption session.

It is possible to modify the ***storage***, which implements the ***StorageConfig*** interface, with two properties to be defined:

| Property | Type | Description |
| ------------ | ---- | --------- |
| **keys** | ***StorageKeys*** | Object That Defines the Names for Storing Open Encryption Context Tickets |
| **type** | ***Storages*** | type of browser storage that will be used to store the ***keys*** |

#### Property ***keys***

Contains two definition keys for assigning a custom name to the cryptographic context tickets.

| Property | Description |
| ----- | --------- |
| **Ticket** | Name of the key that will be stored in the browser's storage to store the cryptographic context ticket |
| **serverPublicKey** | Name of the key that will be stored in the browser's storage to store the public key of the cryptographic context |

#### Property ***type***

It contains three possible options to set the type of storage of the browser to save the tickets.

| Property | Description |
| ----- | --------- |
| **MemoryStorage** | Data is lost every time the page is reloaded |
| **SessionStorage** | Data is lost when closing the browser |
| **LocalStorage** | Data is never lost |

## Implementation

For examples of using the designer features, follow the documentation for [how to use the ***EncryptionService***](../how-to-use-encryption-service.md).
