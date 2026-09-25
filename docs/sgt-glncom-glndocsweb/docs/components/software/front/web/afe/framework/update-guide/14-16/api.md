# How to update the architecture structures

Below you will find the new versions of the **structures** of the architecture compatible with **version 16 of Angular**, followed by the respective commands for updating the package in your project.

First, add the following instruction to the `.npmrc` file in the **root** of the project and also in the `.ci/files/.npmrc` folder:

```diff
- registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all
+ registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all2
```

```diff
- registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all
+ registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all2
```

> **Attention!**
>
> This instruction is provisional and will be replaced soon.

And then execute **just** the command for the packages **defined** in the application's ***package.json***.

| Structuring | Update command |
| ------------ | ---------------------- |
| **@afe/http-interceptors** | `npm i @afe/http-interceptors@4` |
| **@afe/authentication** | `npm i @afe/authentication@2` |
| **@afe/encryption** | `npm i @afe/encryption@4` |
| **@afe/authorization-manager** | `npm i @afe/authorization-manager@5` |
| **@afe/tagging** | `npm i @afe/tagging@4` |
| **@afe/websocket-action-runner** | `npm i @afe/websocket-action-runner@4` |
| **@afe/context-handler** | `npm i @afe/context-handler@4` |
| **@afe/pipes** | `npm i @afe/pipes@4` |
| **@afe/elements** | `npm i @afe/elements@2` |
| **@afe/devkit-angular** | `npm i @afe/devkit-angular@2` |
| **@afe/devkit-schematics** | `npm i @afe/devkit-schematics@2` |
| **@afe/barcode-scanner** | `npm i @afe/devkit-schematics@^1.0.1` |
| **@afe/event-handler** | `npm i @afe/event-handler@^1.7.0` |
