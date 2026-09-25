# CLI

The @afe/cli is a command-line tool for the purpose of initializing, updating, and maintaining Angular projects according to the standard set by the front-end architecture team, speeding up the SPA application development process.

## Prerequisites

To use the architecture's CLI, you must first install [***@angular/cli***](https://v16.angular.io/cli) globally in the version approved by the architecture, using the following command:

``` BASH
npm i @angular/cli@^16 -g --registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

## Install

``` BASH
npm i @afe/cli@^4 -g --registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

> The installation will add the ***@afe/cli***, but the ***@angular/cli*** must be installed globally on your machine, according to the official [Angular installation](https://angular.io/guide/setup-local#install-the-angular-cli) documentation.

## Available Commands

The commands created in order to speed up the application development processes in the bank are:

| Command | Description |
| ------- | --------- |
|[***afe new***](./new/index.md) | **Start new projects** in the Santander environment, following the standardizations defined by AFE |
| [***afe commit***](./commit.md) | **Assist developers** in **creating standardized commits**, following the proper nomenclature for the ***release*** process |
| [***afe version***](./version/index.md) | **Facilitate the versioning process** of applications adhering to the standards established by AFE |
| [***afe update***](./update/index.md) | Automate the process of updating apps to the latest versions of Angular |
| [***afe setup***](./setup.md) | **Perform basic configurations** on the developer's machine or directly in projects |
| [***afe exec***](./exec.md) | **Run external commands to ***AFE*** and ***Angular***** in order to encapsulate processes |
