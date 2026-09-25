# Application crashing or freezing

## Contextualization

This issue can occur when MFEs use AFE encryption modules. Where when trying to encrypt or decrypt some data, the application and the browser itself freeze.

This is because the cryptography library works with a single instance. And when an MFE injects a new instance, the library can't identify which one to use.

## Architecture Orientation

MFE modules cannot import crypto-specific modules such as 'DLECC' and 'DLDH'. But they should switch to the 'Inherited' module, where the instance of the cryptographic libraries are shared with the application.

So, just remove the import from the current module:

```diff
-import { DLECCEncryptionModule } from '@afe/encryption/dlecc';
-import { encryptionConfig } from './config/encryption.config';

@NgModule({
  imports: [
-   DLECCEncryptionModule.forRoot(encryptionConfig),
  ],
})
export class ElementModule { }
```

And proceed to import the 'Inherited' module:

```diff
+import { InheritedEncryptionModule } from '@afe/encryption/inherited';

@NgModule({
  imports: [
+   InheritedEncryptionModule,
  ],
})
export class ElementModule { }
```

For more details, follow the guide at: [How to encrypt and decrypt data on MFEs](../../development-guides/mfe/angular-elements/index.md).
