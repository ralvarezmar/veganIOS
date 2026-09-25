# How to troubleshoot "afeDlbSdk.init is not a function"

Some applications may encounter the **afeDlbSdk.init is not a function** error due to the incompatibility between the **@afe/encryption modules (DLECC and DLDH)** with the corresponding versions of **@afe/dlb-sdk**.

## Contextualization

This error occurs due to the version mismatch of the security script installed by the [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) and the configured [@afe/encryption](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257378534&src=sidebar).

> **Note**
>
> Projects using **V.1** and **V.2** versions of **@afe/dlb-sdk**, must consume the ***DLECC*** module. Projects using the latest version of **@afe/dlb-sdk**, **V.3**, should consume the ***DLDH*** module.

## Solution

To solve this problem, first check which encryption module your project is using.

Once that's done, look at [confluence](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) which version of **@afe/dlb-sdk** your application will actually use.

If necessary, contact the Security Solutions team to identify the most correct version based on your project needs.

> **❗ Attention:**
>
> Version 1.x.x is not recommended due to **security vulnerabilities**.

If your project is configuring an encryption module that is incompatible with the **@afe/dlb-sdk version**, change the configuration file of the main module and import the module that will be used by your project.

Passing the required configuration to the ***forRoot*** method.

In the example below, we configure the ***DLECC***, exemplifying an application that consumes the **2.x.x** version of the ***@afe/dlb-sdk*** library.

``` TS
import { DLECCEncryptionModule } from '@afe/encryption/dlecc';

@NgModule({
    imports: [
        DLECCEncryptionModule.forRoot(encryptionConfig),
    ],
})
export class AppModule { }
```

If the scenario in the previous example was consuming version **3.x.x** of the ***@afe/dlb-sdk*** library, the configuration of the main module would be through the ***DLDH***:

``` TS
import { DLDHEncryptionModule } from '@afe/encryption/dldh';

@NgModule({
    imports: [
        DLDHEncryptionModule.forRoot(encryptionConfig),
    ],
})
export class AppModule { }
```
