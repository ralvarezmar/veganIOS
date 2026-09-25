# What's New in @afe/encryption version 2.x.x

With its new version **2.x.x** released, **Encryption** now supports **Angular 8 and 10**.

## Prerequisites

- Be using ***2.x.x*** version of ***@afe/encryption***.

## What's New

### Storage Configuration

To maintain a standardization between the pieces that use Storages, the possibility to configure which ***Storage*** the library will use has been added to the ***forRoot()*** method, through the following properties:

| Property | Type | Description |
| ----------- | ---- | --------- |
| **storage** | Storages*** | defines the type of storage that will be used to store the keys (serverPublicKey and ticket). Within the object, there are two properties to set |

It is possible to configure which type of storage your application will use, containing three possibilities to choose from, they are:

| Value | Description |
| ----- | --------- |
| **MemoryStorage** | Tokens are lost every time the page is reloaded |
| **SessionStorage** | Tokens are lost when closing the browser |
| **LocalStorage** | Tokens are never lost |

> If this configuration is not done manually, the part will default to SessionStorage and the keys will be saved as ***DLECC.server-public-key*** and ***DLECC.ticket***.

```diff
import { Storages, EncryptionConfig } from '@afe/encryption';

export const encryptionConfig: EncryptionConfig = {
    url: '/hub-url/<ENCRYPTION-VERSION-URL-API>?gw-app-key=<YOUR-APP-KEY>',
    systemCode: '<SYSTEM-CODE>',
+    storage: {
+        keys: {
+            serverPublicKey: '<YOUR-KEY-NAME>',
+            ticket: '<YOUR-TICKET-NAME>'
+        },
+        type: Storages.SessionStorage
+    }
};
```
