# How to update to Angular 18

This session will show you how to upgrade a project to **Angular 18**:

## Prerequisites

Before proceeding, ensure that your project:

- [ ] Is using **Angular 16**;
- [ ] Has committed all files;

## Table of Contents

- [Create an update branch](#create-an-update-branch).
- [NodeJS update](#nodejs-update)
- [Install AFE CLI v18](#install-afe-cli-v18)
- [Project update](#project-update)
- [After the update](#after-the-update)
- [Troubleshooting](#troubleshooting)

## Create an update branch

Create a custom **branch** to start the update process:

```bash
git checkout -b feature/update-angular-18
```

## NodeJS update

Install version **18.19** of Node.js using the **NVS** tool.

> We recommend using NVS to switch between different versions of **Node.js**.
>
> If you don't have the tool installed on your machine, follow the tutorial on **how to set up NVS**.

```bash
nvs add 18.19
```

Select version 18.19 with the command:

```bash
nvs use 18.19
```

Verify that the Node.js version has been successfully changed:

```bash
node -v
```

> The Node.js version should be displayed as 18.19.

## Install AFE CLI v18

The entire process of updating Angular and AFE packages is done through AFE CLI.

To install version **18** of **AFE CLI**, run the command below:

```bash
npm install -g @afe/cli@18
```

The NPM registry used to install AFE CLI should be:

```bash
http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all2
```

You can apply the registry by:

- Modifying the .npmrc file within the project being migrated.
- Using the command below to configure the registry globally:

```bash
npm config set registry http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all2/
```

Or using the command below to install AFE CLI with the configured registry:

```bash
npm install -g @afe/cli@18 --registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all2/
```

## Project update

Run the command below inside the project directory:

```bash
afe update
```

> The afe update command is responsible for updating the project to the latest version of Angular.

After running the command above, 3 options will be presented:

- **Library**: a library that is used by other projects.
- **Element**: an application that is exposed as an Angular Element and used as a Micro Front-End in other projects.
- **Application**: an application that can load Micro Front-Ends or simply be a Single Page Application (SPA).

The options above represent the types of projects that can currently be migrated.

Choose carefully the option that best suits the project you are migrating. This step is essential for the successful migration!

After selection, the migration will begin. During the process, AFE CLI will display messages informing what is being done.

## After the update

After running the command, verify that the project's build and tests are working well.

```bash
npm run build
```

```bash
npm run test
```

If everything is working correctly, **commit** the changes made.

```bash
git add . && git commit -m "feat: update project to Angular 18"
```

If any issues occur during the update, refer to the [Troubleshooting](#troubleshooting) section.

## Update to Standalone API (Optional)

Starting from version **15**, Angular introduced the new **Standalone API**.

To update the project to this new API, run the command below:

```bash
npx ng generate @angular/core:standalone
```

Whenever the command above is executed, three options will be presented for you to select. See below what each of them means:

- **Convert all components, directives and pipes to standalone**: Converts all components, directives, and pipes to Standalone API.
- **Remove unnecessary NgModule classes**: Removes unnecessary NgModule classes.
- **Bootstrap the project using standalone APIs**: Bootstraps the project using the Standalone API.
  
Select one at a time and verify that the project's build and tests are working correctly.

```bash
npm run build
```

```bash
npm run test
```

If everything is working correctly, commit the changes made.

    ```bash
    git add . && git commit -m "feat: update project to Standalone API"
    ```

> If everything is working correctly, commit the changes made.

## Update to new Control Flow Syntax (Optional)

Starting from version **17**, Angular introduced a new syntax for **Control Flow**.

To update the project to the new syntax, run the command below:

```bash
npx ng generate @angular/core:control-flow
```

Install a version of **prettier** compatible with the new syntax:

```bash
npm install --save-dev prettier@^3.3.1
```

Verify that the project's build and tests are working correctly.

    ```bash
    npm run build
    ```

    ```bash
    npm run test
    ```

    If everything is working correctly, commit the changes made.

    ```bash
    git add . && git commit -m "feat: update project to Control Flow Syntax"
    ```

## Troubleshooting

### Project dependency update

Usually, manual dependency changes are necessary in update processes like this. To better understand how Front-End Architecture (AFE) can assist with potential difficulties, refer to our [update policy](../../versioning/update-policy.md).

### Support

Visit our [knowledge base](../../../knowledge-base/obsolescence/index.md) to check if the issue you are facing has already been mapped and resolved.
