# Encryption Update

By the end of this session, you will have upgraded the ***@afe/encryption*** to a **version compatible with Angular 10 and 8**.

## Prerequisites

- Have ***1.x.x*** version of ***@afe/encryption*** installed in your project;
- Commit the project files before starting the update process.

## Run the Update Command

Through the command below, you will install the new version of the structuring:

```bash
ng update @afe/encryption@^2 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the '--allow-dirty' parameter in the update command.

## Install dependency ***@afe/dlb-sdk***

In previous versions of ***@afe/encryption*** the ***@afe/dlb-sdk*** package was configured as a ***dependency*** of the package and in the new Encryption version.

It becomes a ***peerDependency***. Thus, projects that already configured ***Encryption***, must install the package manually, through the following command:

```bash
npm i @afe/dlb-sdk@2 --save-dev
```

## Remove deprecated content in the previous version

In the previous version, in order to maintain compatibility with ***@afe/general-base***, some injections tokens were exported from ***forRoot()*** settings of ***EncryptionService*** for ***EncriptionModule*** to set their values.

Now that we no longer have this need, the following tokens are **NOT** exported anymore:

```ts
export { ENCRYPTION_HTTP_METHOD, ENCRYPTION_ROOT_CONFIG_TOKEN } from './lib/injection-tokens';
```

The Injection Token ***ENCRYPTION_HTTP_METHOD*** was used to maintain compatibility with ***EncriptionService*** of ***@afe/general-base***.

Where ***HubConnectorComponent*** was passed as the provider of ***HttpClient*** to be used in calls to the HUB. Since compatibility is no longer required, the token has been deleted and in its place you must use ***HttpClient*** to make requests.

Remove any references in your code to the following *injection tokens*:

- ***ENCRYPTION_HTTP_METHOD***
- ***ENCRYPTION_ROOT_CONFIG_TOKEN***

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/encryption*** 😎
