# DLECC Encryption Module

> **Caution**: Use [***DLDHEncryptionModule***](./dldh-encryption-module.md) for version ***10.x*** of the encryption component of the "Security Solutions" team.

Module responsible for acting together with the part [***@afe/dlb-sdk***](../../../dlb-sdk.md) in version ***v1*** and ***v2***, in which they have compatibility with the encryption component in versions ***6.x*** and ***8.x*** respectively.

## Encryption API

The ***DLECCEncryptionModule*** is compatible with the Cryptographic Security API (***cryptographic-security***) of the "Security Solutions" team for consumption of the resource ***/key/public/js***.

If the project needs to use the service without the ***JS*** at the end, use the [***DLDHEncryptionModule***](./dldh-encryption-module.md) module.

> For more information, see the documentation on [***Key Exchange***](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves).
>
> **Note**
>
> It may be that the backend that the application will consume is not on the latest encryption version for compliance and latest requirements by the security team.
> If this is the scenario, please contact the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642) team.

## Prerequisite

- Installation of the structuring [***@afe/dlb-sdk***](../../../dlb-sdk.md) in the version according to the encryption component of the security team in which the project needs to use.
- Version ***v2*** for compatibility with ***8.x***.
- Version ***v1*** for compatibility with ***6.x***.

## Configuration

Create the config folder in your project (configuration pattern adopted by the Frontend Architecture) and add the dlecc-encryption.config.ts file, exporting a configuration variable of type ***DLECCEncryptionConfig***, containing the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **url**|***string*** | Key Exchange Service Address (Cryptographic Context) |
| **systemCode** | string***| System Acronym (Application) |

``` TS
//config/dlecc-encryption.config.ts
import { DLECCEncryptionConfig } from '@afe/encryption/dlecc';

export const dleccEncryptionConfig: DLECCEncryptionConfig = {
    url: '/hub-url/cryptographic-security/<VERSION-API>/key/public/js?gw-app-key=<YOUR-APP-KEY>',
    systemCode: '<YOUR-SYSTEM-CODE>',
};
```

> **Attention:**
>
- The variable `<VERSION-API>` should be replaced by the version of the Cryptographic Security API pertinent to the key exchange.
- [Check it out](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves). In which the consumer application must have permission, if it has not yet performed the procedure.

> It is necessary to request permission from consumption next to the [Service Hub](https://confluence.santanderbr.corp/display/PADROESARQINT/Suporte).
>
> - The variable `<YOUR-APP-KEY>` should be replaced by the application ID (key).
> - The variable `<YOUR-SYSTEM-CODE>` should be replaced by the system acronym.
> - The reference ***/hub-url*** is an **alias** pertinent to **proxy configuration**, which must be configured to carry out the application requests in the local environment and also in some environment, according to [documentation on Proxy configurations](../../../../../development-guides/local-environment/proxy.md).

Import the exported object and pass it as a parameter in the ***forRoot*** method of the ***DLECCEncryptionModule*** in the main module of the application.

``` TS
//app.module.ts
import { DLECCEncryptionModule } from '@afe/encryption';
import { dleccEncryptionConfig } from './config/dlecc-encryption.config';

@NgModule({
    imports: [
        DLECCEncryptionModule.forRoot(dleccEncryptionConfig),
    ],
})
export class AppModule { }
```

## Implementation

For examples of using the designer features, follow the documentation for [how to use the ***EncryptionService***](../how-to-use-encryption-service.md).
