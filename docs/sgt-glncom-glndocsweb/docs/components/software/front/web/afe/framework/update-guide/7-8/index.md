# Upgrade from Angular 7 to 8

This session aims to help developers upgrade their projects from Angular version 7 to Angular version 8.

## Prerequisites

Before proceeding with the reading, make sure that your project:

- [ ] It's in **version 7** of Angular;

### Install ***node*** on version ***14. 20*** or version ***16.14***

We advise you to use ***NVS*** to switch between different versions of [Node.js](https://nodejs.org/). If you don't have the tool installed on your machine, follow the [how to set up NVS](../../getting-started/setup/nvs/index.md).

Once this is done, run one of the commands below as preferred to install the node version:

```bash
nvs add 14.20
```

or

```bash
nvs add 16.14
```

And finally, change to the installed version according to the chosen version:

```bash
nvs use 14.20
```

or

```bash
nvs use 16.14
```

### Install the CLI globally

The architecture CLI abstracts the entire process of updating an application through the 'update' command, but to do so, we must install the following packages globally:

```bash
npm i @afe/cli@^2 @angular/cli@^8 -g
```

## Update your project

Once you have met the **prerequisites** and the **local environment configured**, proceed to [how to upgrade a project to **Angular 8**](./project.md).
