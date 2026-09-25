# How to update the project

This session aims to help developers upgrade their projects from Angular version 8 to Angular 10.

## Prerequisites

Before proceeding with the reading, make sure that your project:

- [ ] It's in version 8 of Angular;
- [ ] Owns all your ***committed files***;

### Check the ***defaultProject*** property on ***angular.json***

Open your ***angular.json*** and search for the ***defaultProject***. If it doesn't exist, set it at the end of the file, using the first key inside the ***projects*** property as the value:

```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "afe-portal": {
      // Código omitido
    }
  }
}
```

This value represents the default project name of the repository.

The end of the file should look like this:

```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "afe-portal": {
      // Código omitido
    }
  },
  "defaultProject": "afe-portal"
}
```

### Fix packages with ***latest*** or ***\**** in ***package.json***

Open the project's ***package.json*** and through ***Ctrl + F***, search for the words ***latest*** or `\`.

If any results are found, open the terminal and run the command 'npm i <YOUR_PACKAGE>@latest', replacing '<YOUR_PACKAGE>' with the found package, to install the most current version of it.

### Remove duplicate dependencies in ***package.json***

Look for packages declared in both ***dependencies***, ***devDependencies*** and analyze which one it fits best. Remembering that:

- ***dependencies***: required for the application to run (e.g. ***@angular/core***, ***@afe/encryption***)
- ***devDependencies***: assist in the development of the application (Ex: ***codelyzer***, ***eslint***, ***@afe/cli***)

### Replace packages installed via ***.tgz***

Check if there is any package installed via ***.tgz***, and if found, install it via 'npm i' so that it can be downloaded directly from F1rst's ***artifactory***.

As an example, notice how the dependency was declared:

```json
{
  "dependencies": {
    "@afe/encryption": "afe-encryption-3.1.0.tgz",
   }
}
```

In this case, you must run the command 'npm i @afe/encryption@3.1.0' to install the version used in the project.

The result is:

```json
{
  "dependencies": {
    "@afe/encryption": "3.1.0",
  }
}
```

### Temporarily change the ***name*** property of ***package.json***

If the name property of ***package.json*** is different from the ***defaultProject*** property set in ***angular.json***, replicate the value of ***defaultProject*** to the ***name*** key present in ***package.json***, like this:

```json
{
  "name": "afe-portal" // substitua o valor pelo projeto padrão contido no repositório da sua aplicação
}
```

> **Warning!**
>
> After upgrading to Angular 10, this value should revert to the original.

### Install ***node*** in version ***16***

Angular requires a minimum of the ***16.13*** version of ***Node*** to update the project.

We advise you to use ***NVS*** to switch between different versions of [Node.js](https://nodejs.org/). If you don't have the tool installed on your machine, follow the [how to set up NVS tutorial](./../../../getting-started/setup/nvs/index.md).

Once that's done, run the command below to install the latest Major 16 version of Node:

```bash
nvs add 16
```

And finally, change to this latest version (16x) installed:

```bash
nvs use 16
```

> The use of NODE 16 now loads NPM in version 7+, which has some differences from version 6. Where what used to register 'warn' for conflicting dependencies.
>
> Now returns 'error', which results in the process of 'installing' the project exception of dependencies with conflicts that the repository has.
>
> Ideally, conflicting dependencies should be corrected, but because it is a different scope of the migration process, an alternative can be used if the problem described occurs.
>
> - Use the '--legacy-peer-deps' parameter next to 'install' to tell NPM to perform the process as it was done before the move from version 6 to 7.
>
> For more information, please visit the [npm (v7) - strict-peer-dep documentation](https://docs.npmjs.com/cli/v7/commands/npm-install#strict-peer-deps).

### Install the CLI globally

The architecture CLI abstracts the entire process of updating an application through the 'update' command, but to do so, we must install the following packages globally:

```bash
npm i @afe/cli@^3 typescript@^4 @angular/cli@^8 -g
```

## Update your project

Once the **prerequisites** and the **local environment configured**, proceed to **update**, according to the **project type**:

| Type of project | Description |
| --------------------- | ------------------------------- |
| [SPA Application](./spa.md) | a common Angular application to be deployed to environments. |
| [Library](./library.md) | a library to be published on ***artifactory***; |
| [Element](./element.md) | a self-contained application that uses the concept of **Micro Front End**. |
