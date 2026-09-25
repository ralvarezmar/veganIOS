# Application crash when using encryption service

## Contextualization

This issue can occur when encryption keys are reused on the front-end instead of performing the key exchange correctly each time the user accesses the application.

## Reason

When an application reuses an encryption key, instead of exchanging keys each time the user accesses the application, the `@afe/dlb-sdk` library is unable to perform decryption or encryption.

This approach can cause an internal error within the '@afe/dlb-sdk' library, thus causing the application to crash.

## Solution

Whenever the user accesses the application, it is necessary to carry out the **authentication** process and also perform the **key exchange**.

This approach allows the '@afe/dlb-sdk' library to always work with an **up-to-date** encryption public key.
