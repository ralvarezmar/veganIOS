# How to upgrade a Single Page Application (SPA) to Angular 12

This session aims to guide you through the upgrade of the following projects to Angular version 12:

- **Single Page Application (SPA);**
- **Angular Element (MFE);**
- **Library.**

> **Warning**
>
> Before proceeding, make sure that you [meet the prerequisites and set up the on-premises environment](../index.md).

## Create an Update Branch

Go to the **root of the project** and create a *branch* to start the update process:

```bash
git checkout -b feature/update-angular-12
```

## Follow the steps to update your project

> **Warning**
>
> If any steps fail during the upgrade, **review the run log** and **query** our knowledge base for [**issues encountered during the Angular upgrade**](../../../knowledge-base/obsolescence/index.md).

Update your project to the latest version of Angular 10

Make sure your project has the **latest updates** made in version 10 of Angular, through the command:

```bash
ng update @angular/cli@10 @angular/core@10 --force
```

It may be that your application is already on the latest version of Angular 10, so the following message will be displayed:

```bash
The installed Angular CLI version is outdated.
Installing a temporary Angular CLI versioned 10.2.4 to perform the update.
✔ Package successfully installed.
Using package manager: 'npm'
Collecting installed dependencies...
Found 32 dependencies.
Fetching dependency metadata from registry...
Package '@angular/core' is already up to date.
Package '@angular/cli' is already up to date.
```

Otherwise, perform the following ***commit*** below:

```bash
git commit -m "feat: atualiza projeto para última versão do Angular 10"
```

And follow the next step:

Upgrade your project to Angular 11

Upgrade your project to the **intermediate version** between 10 and 12, the **Angular 11**, through the command:

```bash
ng update @angular/cli@11 @angular/core@11 --force
```

Once the update is complete, make a **commit** with the changes made:

```bash
git commit -m "feat: update project to Angular 11"
```

And run the commands: `npm run build`, `npm run test`, `npm run start` and **test your application functionally**.

> **Do not proceed to the next step** until the basic commands work **correctly**.

Update your project to Angular 12

Finally, update the framework to Angular 12.

```bash
ng update @angular/cli@12 @angular/core@12 --force
```

Once the update is complete, make a **commit** with the changes made:

```bash
git commit -m "feat: atualiza projeto para Angular 11"
```

And run the commands: `npm run build`, `npm run test`, `npm run start` and **test your application functionally**.

> **Do not proceed to the next step** until the basic commands work **correctly**.

By the end, your application should have been successfully upgraded to **Angular 12!**

We're almost there! Now there are only a few steps left =)

Update project settings

### Update the Angular CLI globally

Equalize the version of ***@angular/cli*** used globally on your machine:

```bash
npm i @angular/cli@^12 -g
```

### Configure the current version of Node

Before deploying the project to the environments, make sure to [configure Node on the conveyor belt](../../../development-guides/deployment/setup/index.md) with the most current version.

> Angular 12 should be used with Node version ***12.14.x*** or ***14.15.x***
>

And finally...

Update the dependencies used by the project

[Update the Front-End Architecture (AFE) Frameworks](../api.md) and **the external dependencies** used for the **Angular 12-compatible** versions.

**Manual changes** will also arise as a consequence of the previous processes and must be carried out by the project, as per our [update policy](./../../versioning/update-policy.md).

> If you experience any **unmapped issues** in our [knowledge base](../../../knowledge-base/obsolescence/index.md) or are experiencing **difficulties in the upgrade process**, [open a ticket to AFE support](https://afe.paas.santanderbr.pre.corp/suporte).
