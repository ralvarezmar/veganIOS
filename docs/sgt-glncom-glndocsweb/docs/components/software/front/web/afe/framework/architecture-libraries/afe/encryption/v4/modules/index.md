# Modules

The library modules include compatibilities according to the version of the encryption component that the project needs.

So that each module works with a certain version of the structuring ***@afe/dlb-sdk***, which loads and encapsulates the ***script*** functionalities of the security team's encryption component.

> **Note**
>
> The module responsible for working together with the @afe/dlb-sdk part in version 3.x.x, in which it is compatible with the encryption component in version 10.x, is the module [DLDH Encryption Module](./dldh-encryption-module.md).
>
> The module responsible for working together with the @afe/dlb-sdk part in version 1.x.x and 2.x.x, in which they have compatibility with the encryption component in versions 6.x and 8.x respectively is the module [DLECC Encryption Module](./dlecc-encryption-module.md).
>
> If you are accessing this documentation to implement the part from scratch, please use the DLDH Encryption Module, as it is the module that complies with the latest requirements set forth by the [Security Solutions](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666642).

For deployment and configuration, refer to the documentation for the respective module:

| Module | Encryption API (feature in services hub) |
|-|-|
| [***DLDHEncryptionModule***](./dldh-encryption-module.md) | For consumption of the ***cryptographic-security/`<version>`/key/public*** |
| [***DLECCEncryptionModule***](./dlecc-encryption-module.md) | For consumption of the ***cryptographic-security/`<version>`/key/public/js*** service |
| [***EncryptionModule***](./encryption-module.md) | For consumption of the ***cryptographic-security/`<version>`/key/public/js*** service |

> For more information on which resource (service) the application should consume, see the [***Key Exchange***](https://confluence.santanderbr.corp/display/SOLSEG/Troca+de+Chaves).
>
> The variable `<version>` mentioned in the URL refers to the version of the **Cryptographic Security** API pertinent to the key exchange.
