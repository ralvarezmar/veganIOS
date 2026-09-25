# Version 2

!!! note
    Please note that this documentation refers to the version 2 of the tool.

**Darwin Front CLI** is a tool offered from architecture to start a new development, since it provides a series of archetypes, based on the needs of the project.

You can use the tool yourself to create a `scaffolding` of your application,
but it is also the tool used by the devops themselves to perform a project `onboarding`, and directly offer the archetype in a Github repository already configured, based on your needs.

## Install

The CLI is hosted in Nexus, so in order to install it you must have NPM configured correctly. Make sure that the NPM registry points to Nexus correctly. This step can be done in two ways:

- Via the command line:

```bash
npm config set registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
npm config set strict-ssl false
```

- Manually. Go to the .npmrc file, which is located in `C:\Users<YOUR-USER>`. In case this file does not exist, you must create it and add the lines shown below. If it does exist, add them if it does not already have them:

```bash
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
strict-ssl=false
```

Install globally [Yeoman](http://yeoman.io/) (version 4) and the latest release of our CLI tool for the front-end. You will need a [NodeJs](https://nodejs.org/) >= 12 and [npm](https://www.npmjs.com/).

```bash
npm install -g yo@4
npm install -g @darwin/generator-front
```

Generate a new project with the following command and follow the steps:

```bash
yo @darwin/front
```

This tool accepts a multitude of parameters. If you need information about them:

```bash
yo @darwin/front --help
```

## How to use it?

You must use the tool in a clean directory, which does not already belong to another project and contains a `package.json` file or a `node_modules` directory

```bash
yo @darwin/front #Without parameters the tool will start asking interactive questions
```

!!! warning
    The **interactive mode** of the tool **is not supported** by the **Git Bash** console. Use a similar console to CMD or PowerShell instead for this mode.

Parameters are passed in key/value format. The key must begin with a double hyphen (`--`). The way to separate the key from its value will be the equal character (`=`) or a blank space:

`--key=value`
`--key value`

If parameters are included, they will no longer be queried from the CLI:

```bash
yo @darwin/front --appName foo --frameworkVendor=angular12
```

Including the --useDefault parameter will avoid asking the user for mandatory parameters that have been omitted, taking their default value.

```bash
yo @darwin/front --useDefault --appName=foo --frameworkVendor angular12
```

The CLI checks at startup if we are using the latest version available, if for some reason you want to ignore this, you can use the `--noUpdate` flag.

```bash
yo @darwin/front --noUpdate
```

### Generate a new SPA application project

All possible parameters to generate a library with Angular12

```bash
yo @darwin/front --useDefault --projectType=lib --frameworkVendor=angular12 --projectKey=KEY --libPgStyleLanguage=css --libScope=my-scope --libModule=my-darwin-lib --libPrefix=lib
```

### Generate a new library project

Usual parameters to generate a library with Angular 13

```bash
yo @darwin/front --useDefault --projectType=lib --frameworkVendor=angular13 --projectKey=KEY --libPgStyleLanguage=css --libScope=my-scope --libModule=my-darwin-lib --libPrefix=lib
```

## Node and Angular Versions

This version of CLI tool is able to generate the following archetypes

<table markdown="1">
  <tr>
    <th>SPA</th>
    <td>Angular 12</td>
    <td>Angular 11</td>
    <td>Angular 8</td>
  </tr>
  <tr>
    <th>Library</th>
    <td>Angular 12</td>
    <td>Angular 11</td>
    <td>Angular 8</td>
  </tr>
</table>

Depending on the specific version of the Angular framework selected, you will need a specific Node version to ensure their right work.

The table below will help you with the Node version you will need.

| Angular Version Darwin Archetype | Node Version    |
|----------------------------------|-----------------|
| **Angular 12**                   | `>=12.11.1 <15` |
| **Angular 11**                   | `>=12.11.1 <15` |
| **Angular 8**                    | `>=10.9.0 <15`  |

> [!NOTE]
> Please, note Angular 8 and 11 with NodeJs 14 may have some warning when the unit test are run.

### Parameters

| Parameter                | Description                                                                                                                                                                                       | Default value         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `--projectType`          | Project type to be generated: (spa, lib)                                                                                                                                                          | spa                   |
| `--frameworkVendor`      | Framework with which the archetype will be generated: (angular12, angular11, angular8)                                                                                                            | angular12             |
| `--projectKey`           | Key or acronym assigned to the project.                                                                                                                                                           | KEY                   |
| `--appStyleLanguage`     | Type of style language. Only for SPA: (css, scss)                                                                                                                                                 | css                   |
| `--appName`              | Application name. Only for SPA.                                                                                                                                                                   | my-darwin-project     |
| `--appPrefix`            | Prefix to be applied in the component selectors. Only for SPA.                                                                                                                                    | app                   |
| `--appModulesToInclude`  | Darwin modules to be added. Only for SPA: (logger)<br><br>**Note:** This property will be taken into account only if `--frameworkVendor=angular8`                                                 |                       |
| `--libPgStyleLanguage`   | Type of style language in the playground. Only for LIB: (css, scss)                                                                                                                               | css                   |
| `--libScope`             | Name of the library scope.<br><br>Refers to a set of libraries which are independent packages and normally located in the same repository.<br><br>Only for LIB: (@my-scope/my-darwin-module)      | my-scope              |
| `--libName`              | **Deprecated!** Use --libModule instead                                                                                                                                                           | my-darwin-module      |
| `--libModule`            | Name of the library module. Only for LIB: (@my-scope/my-darwin-module)                                                                                                                            | my-darwin-module      |
| `--libPrefix`            | Prefix to be applied in the selectors of the library components. Only for LIB.                                                                                                                    | lib                   |
| `--securityMode`         | Security module: How to get the token for the first time. Only for SPA: (url, cookie, post, param)<br><br>**Note:** This property will only be taken into account if `--frameworkVendor=angular8` | url                   |
| `--securityQueryParam`   | Security module: Parameter name from which the token will be collected. Only for SPA.                                                                                                             | token                 |
| `--securityReminderTime` | Security module: ms before session expiration and trigger SESSION_ABOUT_TO_EXPIRE event. Only for SPA.                                                                                            | 30000                 |
| `--paasProjectName`      | Logger module: Value for the property: paasProjectName. Only for SPA.                                                                                                                             | paasProjectName_value |
| `--paasAppName`          | Logger module: Value for the property: paasAppName. Only for SPA.                                                                                                                                 | paasAppName_value     |
| `--loggerApplication`    | Logger module: Value for the property: application. Only for SPA.                                                                                                                                  | application_value     |
| `--loggerSubApplication` | Logger module: Value for the property: subapplication. Only for SPA.                                                                                                                               | 12345678              |
| `--loggerSystem`         | Logger module: Value for the property: system. Only for SPA.                                                                                                                                      | system_value          |
| `--loggerSubSystem`      | Logger Module: Value for the property: subSystem. Only for SPA.                                                                                                                                   | subSystem_value       |

The following properties are treated as flags and do not require specifying their value.

| Flag            | Description                                                                                                                                                    |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--useDefault`  | Avoid prompting the user by using default options for parameters not received.                                                                                 |
| `--gitInit`     | Initializes a Git repository in the project.                                                                                                                   |
| `--npmInstall`  | Automatically installs project dependencies.                                                                                                                   |
| `--noUpdate`    | Ignore the check to make sure you are using the latest version of the generator.                                                                               |
| `--skip-eslint` | It does not configure the project linter.<br>**Note:** *This parameter will only be taken into account if* `--frameworkVendor is equal to angular12 or higher` |

## Nomenclature

The `appName`, `libScope` and `libModule` properties must comply with the following guidelines:

Start with an alphabetic character (a-z).

Contain only alphanumeric characters or hyphens.

When a hyphen is added, the following character must be an alphabetic character (a-z).

After the installation process has finished, the `package.json` name will have the following value due to cataloging requirements:

In SPA archetype - `<projectKey>-<appName>`

In lib archetype - `@<projectKey>-<libScope>/<libModule>`
