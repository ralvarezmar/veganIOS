# How to troubleshoot "Cannot read property 'multiply' of null"

Misconfiguration of ***@afe/encryption*** can lead to the ***ERROR TypeError: Cannot read property 'multiply' of null***:

## Contextualization

The problem occurs due to the incorrect declaration of the ***serverPublicKey*** and ***ticket*** properties in the ***EncryptionModule*** configuration file, when just passing empty ***strings***

``` TS
import { EncryptionConfig, Storages } from '@afe/encryption';

export const encryptionConfig: EncryptionConfig = {
    storage: {
        keys:
            {
                serverPublicKey: '',
                ticket: '',
            },
        type: Storages.SessionStorage
    }
};
```

> The above configuration results in the ***ERROR TypeError: Cannot read property 'multiply' of null***

## Solution

To solve the problem, just pass a valid ***string***. If you don't pass the properties manually, it defaults to the name ***serverPublicKey*** and ***ticket*** as the default.

``` TS
import { EncryptionConfig, Storages } from '@afe/encryption';

export const encryptionConfig: EncryptionConfig = {
    storage: {
        keys:
            {
                serverPublicKey: 'serverPublicKey',
                ticket: 'ticket',
            },
        type: Storages.SessionStorage
    }
};
```
