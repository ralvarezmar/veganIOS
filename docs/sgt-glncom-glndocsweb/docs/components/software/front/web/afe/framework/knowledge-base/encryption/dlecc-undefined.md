# How to troubleshoot "DLECC is not defined"

Some applications may encounter the following error when attempting to perform key exchange, right after configuring the architecture's cryptographic piece:

## Contextualization

This failure is due to the version mismatch of the security script installed by the [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) and the configured [@afe/encryption](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257378534&src=sidebar).

Before an application can use the encryption feature, it must have configured one of the [@afe/encryption](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257378534&src=sidebar) submodules together with a compatible version of [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231).

For ***DLECC***, you should use **v1** or **v2** and in the case of ***DLDH***, **v3** of the library containing the security script.

## Solution

Install version **2** of ***@afe/dlb-sdk*** in your application, using the command:

```bash
npm i @afe/dlb-sdk@^2
```

And perform a joint analysis with a backend developer to identify which [DLB version](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666770) is being used by the API backend.

It will be necessary to equalize the versions on both the front-end and the back-end. Otherwise, the project may run into the [Malformed UTF-8](malformed-utf8.md) error.

> If you experience the error "***Malformed UTF-8***" after this change, follow the documentation on [how to troubleshoot "Malformed UTF-8"](./malformed-utf8.md).
