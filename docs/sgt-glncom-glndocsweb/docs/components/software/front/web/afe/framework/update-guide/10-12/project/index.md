# How to update a project

This session aims to help developers upgrade their projects from Angular version 10 to Angular 12.

## Prerequisites

Before proceeding with the reading, make sure that your project:

- [ ] It's in Angular version 10;
- [ ] Owns all your ***committed files***;

### Install ***node*** on version ***14.21.1***

Angular requires at least ***14.21.1*** version of ***Node*** to update the project.

We advise you to use ***NVS*** to switch between different versions of [Node.js](https://nodejs.org/). If you don't have the tool installed on your machine, follow the [how to set up NVS tutorial](../.././../getting-started/setup/nvs/index.md).

Once done, run the command below to install the minimum version:

```bash
nvs add 14.21.1
```

And finally, change it to the installed version:

```bash
nvs use 14.21.1
```

### Install the CLI globally

The architecture CLI abstracts the entire process of updating an application through the 'update' command, but to do so, we must install the following packages globally:

```bash
npm i @angular/cli@^10 -g
```

## Update your project

Once the **prerequisites** and the **local environment configured**, proceed to **update**, according to the **project type**:

| Type of project | Description |
| --------------- | --------- |
| [Single Page Application (SPA)](./spa.md)| a common Angular application to be deployed to environments. |
| [Library](./library.md) | a library to be published on ***artifactory***; |
| [Angular Element (MFE)](./element.md) | a self-contained application that uses the concept of **Micro Front End**. |
