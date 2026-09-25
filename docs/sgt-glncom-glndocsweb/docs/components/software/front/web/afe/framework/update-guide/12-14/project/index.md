# How to update a project

This session aims to help developers upgrade projects from **Angular version 12 to 14**.

## Prerequisites

Before continuing reading, make sure your project:

- [ ] It is in **version 12** of Angular;
- [ ] Has all your ***committed*** files;

### Install ***node*** in version ***14.21.1***

Angular requires at least ***Node*** version ***14.21.1*** to update the project.

We advise using ***NVS*** to switch between different versions of [Node.js](https://nodejs.org/).

If you don't have the tool installed on your machine, follow the tutorial [how to configure NVS](../../../getting-started/setup/nvs/index.md).

Once this is done, run the command below to install the minimum version:

```bash
nvs add 14.21.1
```

And finally, change to the installed version:

```bash
nvs use 14.21.1
```

### Install the CLI globally

The architecture's CLI abstracts the entire process of updating an application through the `update` command, but to do so, we must install the following packages globally:

```bash
npm i @angular/cli@^12 -g
```

## Update your project

Once the **prerequisites** and the **configured local environment** have been met, proceed to **update**, depending on the **type of project**:

| Project type | Description |
| --------------- | --------- |
| [Single Page Application (SPA)](./spa.md) | a common Angular application to be deployed in environments. |
| [Angular Element (MFE)](./element.md) | a self-contained application that uses the concept of **Micro Front End**. |
