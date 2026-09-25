# What `@ng-darwin-wmf` is?

It is a library, which is designed to be the base to Shell and Microfront development.
From the name (_ng-darwin_) we can see that it is an Angular library, so it is written to be used along with [ng-darwin](../../ng-darwin/index.md) library.
Also, the _wmf_ part tells us that the plugin **W**ebpack **M**odule **F**ederation is used to load remotes and share dependencies.

The modules available in this library are the following:

| Module | Description |
|---|---|
| `@ng-darwin-wmf/microfront` | It exports utilities to solve common issues that comes up with the Microfronts world: routing, navigation, communication, assets, events and loading remotes. |

## What `@ng-darwin-wmf/microfront` is?

This module is exposed to be consumed through a public API (components, services, pipes…) to be able to use the features provided in the library. You can check all the pieces in the [API Reference section](./v20/index.md).

This library is used in the Shell and Microfront archetypes with a bunch of examples showing how those issues are solved.

Taking into consideration that the different pieces are designed to work together. Therefore, migrations from simple SPAs should have this in mind when using this library.

## Prerequisites

Before using this library, you need to check the requirements.

### Versions

The library versions work in accordance with the Angular versions.

| @ng-darwin-wmf/microfront | Angular | Node                               |
| ------------------------- | ------- | ---------------------------------- |
| **^20**                   | `^20`   | `^20.19.0 || ^22.12.0 || ^24.0.0`  |
| **^18**                   | `^18`   | `^18.19.1 || ^20.11.1 || ^22.0.0`  |
| **^16** (deprecated)      | `^16`   | `^16.14.0 || ^18.10.0`             |
| **^15** (deprecated)      | `^15`   | `^14.20.0 || ^16.13.0 || ^18.10.0` |
| **^13** (deprecated)      | `^13`   | `^12.20.0 || ^14.15.0 || ^16.10.0` |

To check your version, run `node -v` in a terminal or console.

### NPM

Darwin applications depend on Angular, Angular CLI and Darwin's own libraries available as npm packages. In order to download and install all the necessary packages you must have npm installed.

To check your version, run `npm -v` in a terminal or console.

### Nexus

Darwin modules are hosted in Nexus, and in order to install them you must have the NPM registry configured correctly. This can be done in two different ways:

#### By command line

To do the configuration via command line run the following commands in your terminal:

``` bash
npm config set registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/ npm config set strict-ssl false
```

#### Manually

To do the configuration manually you have to go to the .npmrc file, which is located in `C:\Users\<YOUR-USER>`. In case this file does not exist you must create it and add the lines shown below. If it does exist, add them if it does not already have them:

`registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/ strict-ssl=false`

## Install

To install the dependency in the root of the project run

`npm install @ng-darwin-wmf/microfront`
