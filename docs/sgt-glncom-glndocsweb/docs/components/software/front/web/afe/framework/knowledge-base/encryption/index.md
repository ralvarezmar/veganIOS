# Encryption

This session is intended to provide **information, guidance for issues encountered during the configuration and consumption of encryption in applications.**

## 🎯 Overview

Errors during encryption configuration or consumption can happen due to the following factors:

- Using a version of ***@afe/dlb-sdk*** that is incompatible with the configured encryption module;
- Incorrect configuration of the architecture's cryptography library ([@afe/encryption](../../architecture-libraries/afe/encryption/index.md);

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required to fix problems that arise during the development cycle;

### Validate that the **@afe/dlb-sdk** version matches the cryptographic module used in the project

- If the project uses the ***DLECCEncryptionModule***, the version of ***@afe/dlb-sdk*** must be ***1.x.x*** or ***2.x.x***;
- If the project uses the ***DLDHEncryptionModule***, the version of ***@afe/dlb-sdk*** must be ***3.x.x***;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Cryptography Library Configuration Issues

Documented possible solutions to this issue are:

- [How to troubleshoot "DLECC is not defined"](./dlecc-undefined.md)
- [How to troubleshoot "Cannot read property 'multiply' of null"](./multiply-of-null.md)
- [How to troubleshoot "afeDlbSdk.init is not a function"](./dlb-sdk.md)

### Problems **during consumption** of encryption

Documented possible solutions to this issue are:

- [How to troubleshoot "Malformed UTF-8"](./malformed-utf8.md)
- [How to troubleshoot "500 Internal Server Error after key exchange"](./500.md)

### Problems

**after consumption** of encryption Documented possible solutions to this issue are:

- [Application crash when using encryption service](./keys.md)
