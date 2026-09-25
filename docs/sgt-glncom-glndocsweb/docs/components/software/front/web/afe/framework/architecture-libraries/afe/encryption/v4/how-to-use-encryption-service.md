# How to use the ***EncryptionService***

## Prerequisites

- Installation and configuration of a [***@afe/encryption***](./index.md)

## Opening up the cryptographic context

To perform any functionality of the service, you must run the changeKeys method first.

This procedure performs the session of the encryption context with the Cryptographic Security API.

Next to the ***service hub*** for encryption needs both on the front side and in communication with some ***API*** of the backend in which the application intends to consume.

``` TS
//example.component.ts
import { EncryptionService, ChangeKeysResponse } from '@afe/encryption';

export class ExampleComponent {

    constructor(private encryptionService: EncryptionService) {}

    ngOnInit(): void {
        // fluxo de autenticação omitido
        this.encryptionService.changeKeys()
            .subscribe((encryptionKeysResponse: ChangeKeysResponse) => {
                // tratamento (caso necessário) dos dados (tickets) da sessão de criptografia aberta
            }
        );
    }
}
```

> **Attention:**
>

- The ***changeKeys*** method is a ***Observable***, so it is necessary to call ***subscribe*** to execute the feature, see [Angular Observables](https://angular.io/guide/observables#defining-observers) for more information.

- It may be that the version of the cryptographic API service in which you requested permission needs to be authenticated to open the cryptographic session.
- So it is necessary to first carry out the process through some form of authentication and only after responding to the request, call the ***changeKeys*** method.

## Public Methods

| Method | Description |
| ------ | --------- |
| ***changeKeys*** | Performs the key exchange and returns an object containing the ***public key*** and the ***ticket*** |
| ***cleanKeys*** | Performs cleanup of data pertinent to the cryptographic context in the part |
| ***isInitialized*** | Verifies that encryption has been initialized |
| ***encrypt*** | Performs the encryption of a string data and returns it encrypted |
| ***decrypt*** | Performs the decryption of a string data and returns it decrypted, the data must have originated in the ***backend***, so the method only decrypts data obtained from some base by the server |
| ***sign*** | Computes the hash of an arbitrary buffer and encrypts it |
| ***encryptHashPassword*** | Compile a hash of a password with ***salt*** and encrypt |
| ***encryptToDLB*** | Performs data encryption of type ***string*** to the ***DLB*** and returns it encrypted |
| ***encryptToMF*** | Encrypts data to the mainframe |
| ***getTicket*** | Returns the ***ticket*** generated in the key exchange |
| ***getPublicServerKey*** | Returns the ***publicServerKey*** generated in the key exchange |
| ***setTicket*** | Inserts a new ***ticket*** into the ***storage*** set to data storage |
| ***setPublicServerKey*** | Inserts a new ***publicServerKey*** into the ***storage*** set to data storage |

> **Note**:
>
> The ***setPublicServerKey*** and ***setTicket*** methods should only be used if the ***key*** and ***ticket*** are done by a **different** backend from the traditional **key exchange**.

## Implementation

### Cryptography

``` TS
//example.component.ts
import { EncryptionService } from '@afe/encryption';

export class ExampleComponent {

    constructor(
        private encryptionService: EncryptionService
    ) {}

    ngOnInit(): void {
        // autenticação e troca de chaves (changeKeys) omitidos
    }

    public encrypt(data: string): string {
        return this.encryptionService.encrypt(data);
    }
}
```

### Decryption

> **Attention**:
>
> The ***decrypt*** method will only **decrypt** data originating from the **back-end**, so to use it it is necessary to make a request to an API that returns the encrypted data.

``` TS
//example.component.ts
import { HttpClient } from "@angular/common/http";
import { EncryptionService } from '@afe/encryption';

export class ExampleComponent {

    constructor(
        private httpClient: HttpClient,
        private encryptionService: EncryptionService
    ) {}

    ngOnInit(): void {
        // autenticação e troca de chaves (changeKeys) omitidos
    }

    public decrypt(): void = {
        this.httpClient
            .get("<YOUR-API-THAT-RETURNS-ENCRYPTED-DATA>")
            .subscribe((dataEncrypted: string) => {
                const dataDecrypted = this.encryptionService.decrypt(dataEncrypted);
                // restante do código para utilização do dado descriptografado
            });
    };
}
```

### Another methods

``` TS
//example.component.ts
import { EncryptionService } from '@afe/encryption';

export class ExampleComponent {

    constructor(
        private encryptionService: EncryptionService
    ) {}

    ngOnInit(): void {
        // autenticação e troca de chaves (changeKeys) omitidos
    }

    public isInitialized(): boolean {
        return this.encryptionService.isInitialized();
    }

    public encryptHashPassword(password: string, salt: string): string {
        return this.encryptionService.encryptHashPassword(password, salt);
    }

    public encryptToDLB(data: string): string {
        return this.encryptionService.encryptToDLB(data);
    }

    public encryptToMF(data: string): string {
        return this.encryptionService.encryptToMF(data);
    }

    public sign(data: string): string {
        return this.encryptionService.sign(data);
    }

    public getPublicServerKey(): string {
        return this.encryptionService.getPublicServerKey();
    }

    public getTicket(): string {
        return this.encryptionService.getTicket();
    }

    public setPublicServerKey(newPublicKey: string): void {
        this.encryptionService.setPublicServerKey(newPublicKey);
    }

    public setTicket(newTicket: string): void {
        this.encryptionService.setTicket(newTicket);
    }

    public cleanKeys(): void {
        this.encryptionService.cleanKeys();
    }

}
```
