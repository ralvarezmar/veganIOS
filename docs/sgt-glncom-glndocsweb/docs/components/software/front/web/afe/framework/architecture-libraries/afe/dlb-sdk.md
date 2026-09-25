# DLB SDK

The ***@afe/dlb-sdk*** is nothing more than an **abstraction** around the **cryptography** library created by the **security solutions** team, developed to protect data trafficked from the client to the last layer of the application.

It is responsible for consuming the ***script*** developed in order to mitigate data interception vulnerabilities. It is worth mentioning that the ***script*** is **obfuscated**, so as not to compromise the way it was implemented.

The library works in conjunction with [***@afe/encryption***](./encryption/index.md), the piece of architecture responsible for encrypting and decrypting application data.

> For more information on the security component, please visit the [Crypto SDK DLC](https://confluence.santanderbr.corp/display/SOLSEG/DLB+Cripto+SDK+-+Criptografia+Adicional) documentation

## Compatibility

> **Attention!**
>
> The current version of the component is **v3**, but it may be that the backend that the application will consume is not on the latest version of encryption for compliance and latest requirements by the security team.
>
> if this is the scenario, please contact the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642) team.

| Library version | ***DLB*** Version |
| ---------------------- | ------------------- |
| ***v3.x*** | ***v10.x*** |
| ***v2.x*** | ***v8.x*** |
| ***v1.x*** | ***v6.x*** |

> **Note**
>
> The module responsible for working together with the @afe/dlb-sdk part in version 3.x.x, in which it is compatible with the encryption component in version 10.x, is the module [DLDH Encryption Module](./encryption/v2/modules/dldh-encryption-module.md).
>
> The module responsible for working together with the @afe/dlb-sdk part in versions 1.x.x and 2.x.x, in which they have compatibilities with the encryption component in versions 6.x and 8.x respectively is the module [DLECC Encryption Module](./encryption/v2/modules/dlecc-encryption-module.md).
>
> If you are accessing this documentation to implement the part from scratch, please use the DLDH Encryption Module, as it is the module that complies with the latest requirements set forth by the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642)team.

## Installation

``` BASH
npm install @afe/dlb-sdk@^<VERSION-PACKAGE>
```

> **Attention**
>
> - The variable `<VERSION-PACKAGE>` should be replaced with the **required version of the structuring** based on the **version of the security team's encryption component** that the application needs to use.
