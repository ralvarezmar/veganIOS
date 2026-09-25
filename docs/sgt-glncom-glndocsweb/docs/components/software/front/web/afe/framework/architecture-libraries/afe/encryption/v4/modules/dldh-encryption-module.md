# DLDH Encryption Module

Module responsible for acting together with the part [***@afe/dlb-sdk***](../../../dlb-sdk.md) in version ***3***, where it supports the encryption component in version ***10.x***.

## Encryption API

The ***DLDHEncryptionModule*** supports the Cryptographic Security API (***cryptographic-security***) of the [Security Solutions](https://confluence.santanderbr.corp/display/SOLSEG) team for consuming the ***/key/public*** resource.

> For more information, see the documentation on [***Key Exchange***](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves).
>
> **Note**
>
> It may be that the backend that the application will consume is not on the latest version of encryption for compliance and latest requirements by the security team.
> If this is the scenario, please contact the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642) team.

## Prerequisite

- Installing [***@afe/encryption***](../index.md)
- Installing [***@afe/dlb-sdk***](../../../dlb-sdk.md) in version ***3***.

## Configuration

Create the config folder in your project (configuration pattern adopted by the Frontend Architecture) and add the dldh-encryption.config.ts file, exporting a configuration variable of type DLDHEncryptionConfig, which contains the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **url**|***string*** | Key Exchange Service Address (Cryptographic Context) |
| **systemCode** | ***string***| System Acronym (Application) |

> **Attention:**
>

- The variable `<VERSION-API>` should be replaced by the version of the Cryptographic Security API pertinent to the key exchange.
- [Check it out](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves). In which the consumer application must have permission, if it has not yet performed the procedure.

> It is necessary to request permission from consumption next to the [Service Hub](https://confluence.santanderbr.corp/display/PADROESARQINT/Suporte).
>
> - The variable `<YOUR-APP-KEY>` should be replaced by the application ID (key).
> - The variable `<YOUR-SYSTEM-CODE>` should be replaced by the system acronym.
> - The reference ***/hub-url*** is an **alias** pertinent to **proxy configuration**, which must be configured to carry out the application requests in the local environment and also in some environment, according to [documentation on Proxy configurations](../../../../../development-guides/local-environment/proxy.md).

``` TS
//config/dldh-encryption.config.ts
import { DLDHEncryptionConfig } from '@afe/encryption/dldh';

export const dldhEncryptionConfig: DLDHEncryptionConfig = {
    url: '/hub-url/cryptographic-security/<VERSION-API>/key/public?gw-app-key=<YOUR-APP-KEY>',
    systemCode: '<YOUR-SYSTEM-CODE>',
};
```

Import the exported object and pass it as a parameter in the ***forRoot*** method of the ***DLDHEncryptionModule*** in the main module of the application.

``` TS
//app.module.ts
import { DLDHEncryptionModule } from '@afe/encryption';
import { dldhEncryptionConfig } from './config/dldh-encryption.config';

@NgModule({
    imports: [
        DLDHEncryptionModule.forRoot(dldhEncryptionConfig),
    ],
})
export class AppModule { }
```

## Implementation

For examples of using the designer features, follow the documentation for [how to use the ***EncryptionService***](../how-to-use-encryption-service.md)
