# Darwin Front CLI

!!! note
    **Please note that this documentation refers to the version 8 of the tool.**

## Darwin Front CLI. The Archetype Generator

**Darwin Front CLI** is a tool offered from architecture team to start a new development, since it provides a series of archetypes, based on the needs of the project.

You can use the tool yourself to create a scaffolding of your application, but it is also the tool used by the devops themselves to perform a project onboarding, and directly offer the archetype in a Github repository already configured, based on your needs. <!-- markdownlint-disable MD013 -->

## Prerequisites

### Node

Darwin Front CLI requires Node (`^20.19.0 || ^22.12.0 || ^24.0.0`) to run itself. But depending on the archetype you want to generate, you will need one or another Node version to run the archetype.
Please take a look at this [table](#node-and-angular-version) to check you have the right Node version installed.

To check your version, run `node -v` in a terminal or console.

### NPM

Darwin applications depend on Angular, Angular CLI and Darwin's own libraries available as npm packages. In order to download and install all the necessary packages you must have npm installed.

To check your version, run `npm -v` in a terminal or console.

#### Angular CLI note

In order to avoid getting the wrong angular version using this generator, **you need to uninstall any global Angular CLI version** you have:

``` bash
npm -g uninstall @angular/cli
```

After the project is generated, if you want to use the Angular CLI you can work with the local instance after the dependencies are installed.

## Install

The CLI is hosted in Nexus, so in order to install it you must have NPM configured correctly. Make sure that the NPM registry points to Nexus correctly. This step can be done in two ways:

- Via the command line:

  ``` bash
  npm config set registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
  npm config set strict-ssl false
  ```

- Manually:

  Go to the `.npmrc` file, which is located in `C:\Users<YOUR-USER>`. In case this file does not exist, you must create it and add the lines shown below. If it does exist, add them if it does not already have them.

  ``` bash
  registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
  strict-ssl=false
  ```

Install globally [Yeoman](http://yeoman.io/) (version 5 compatible) and the latest release of our CLI tool for the frontend.

``` bash
npm install -g yo@5
npm install -g @darwin/generator-front
```

Generate a new project with the following command and follow the steps:

``` bash
yo @darwin/front
```

This tool accepts a multitude of parameters. If you need information about them:

```bash
yo @darwin/front --help
```

## How to use it?

### Run the tool from a Command Line Interface (CLI)

You must use the tool in a clean directory, which does not already belong to another project and contains a `package.json` file or a `node_modules` directory.

```bash
yo @darwin/front #Without parameters the tool will start asking interactive questions.
```

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=df47b7e7-006d-4d15-89ca-24bd76df62d6" width="100%" height="360" frameborder="0" scrolling="no" allowfullscreen title="darwin_cli_v7"></iframe>

Parameters are passed in _key/value_ format. The _key_ must begin with a double hyphen (`--`). The way to separate the _key_ from its _value_ will be the equal character (`=`) or a blank space:

``` bash
--key=value
--key value
```

If parameters are included, they will no longer be queried from the CLI:

``` bash
yo @darwin/front --appName foo --frameworkVendor=angular18
```

Including the `--useDefault` parameter will avoid asking the user for mandatory parameters that have been omitted, taking their default value.

``` bash
yo @darwin/front --useDefault --appName=foo --frameworkVendor angular20
```

The CLI checks at startup if we are using the latest version available, if for some reason you want to ignore this, you can use the `--noUpdate` flag.

``` bash
yo @darwin/front --noUpdate
```

### Darwin projects

#### Generate a Darwin SPA

Usual parameters to generate a Darwin SPA with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=darwin --projectType=spa --frameworkVendor=angular20 --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --securityQueryParam=token --securityReminderTime=30000 --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

#### Generate a Microfront

Usual parameters to generate a Darwin Microfront with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=darwin --projectType=mcf --frameworkVendor=angular20 --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --securityQueryParam=token --securityReminderTime=30000 --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

#### Generate a Darwin Shell

Usual parameters to generate a Darwin Shell with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=darwin --projectType=shell --frameworkVendor=angular20 --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --securityQueryParam=token --securityReminderTime=30000 --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

### Gluon projects

#### Generate a Gluon SPA

Usual parameters to generate a Gluon SPA with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=gluon --projectType=spa --frameworkVendor=angular20 --company=gln --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

#### Generate a Gluon Microfront

Usual parameters to generate a Gluon Microfront with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=gluon --projectType=mcf --frameworkVendor=angular20 --company=gln --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

#### Generate a Gluon Shell

Usual parameters to generate a Gluon Shell with Angular 20:

``` bash
yo @darwin/front --useDefault --architecture=gluon --projectType=shell --frameworkVendor=angular20 --company=gln --projectKey=key --appStyleLanguage=css --appName=myproject --appPrefix=app --paasProjectName=paasProjectName_value --paasAppName=paasAppName_value --application=application_value --subApplication=00000000 --system=system_value --subSystem=subSystem_value
```

### Run the tool from Node

!!! warning
    This generator will not work if `Yeoman Environment` is used to invoke it.

The right way to invoke the generator is through a NodeJs [`subprocess`](https://nodejs.org/api/child_process.html) and the `npx` syntax, which will allow us to launch in a subprocess a temporary installation of `yeoman` and this generator, as well as its execution:

``` js
const { spawn } = require('child_process');

spawn('npx -p yo -p @darwin/generator-front yo @darwin/front',
  [
    '--projectType', 'spa',
    '--appName', 'my-app',
    '--useDefault'
  ], {
  shell: true,
  stdio: 'inherit'
});
```

### Parameters

| Parameter                | Description                                                                                                                                                                                                          | Default value           |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `--architecture`         | The architecture to be used. <br><br>Values:`darwin`, `gluon`                                                                                                                                                        | `darwin`                |
| `--projectType`          | Project type to be generated.<br><br>Values:`spa`, `shell`, `mcf`                                                                                                                                                    | `spa`                   |
| `--frameworkVendor`      | Framework with which the archetype will be generated.<br><br>Values: `angular20`, `angular18`<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                            | `angular20`             |
| `--projectKey`           | Key or acronym assigned to the project.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                                  | `KEY`                   |
| `--company`              | Company name.<br><br>Applicable to: `gluon spa`,`gluon shell`, `gluon mcf`                                                                                                                                           | `gln`                   |
| `--appStyleLanguage`     | Type of style language.<br><br>Values: `css`, `scss`<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                     | `css`                   |
| `--appName`              | Application name.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                                                        | `myproject`             |
| `--appPrefix`            | Prefix to be applied in the component selectors.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                         | `app`                   |
| `--securityQueryParam`   | Security module: Parameter name from which the token will be collected.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                  | `token`                 |
| `--securityReminderTime` | Security module: ms before session expiration and trigger SESSION_ABOUT_TO_EXPIRE event.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                 | `30000`                 |
| `--paasProjectName`      | Logger module: Value for the property: paasProjectName.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                  | `paasProjectName_value` |
| `--paasAppName`          | Logger module: Value for the property: paasAppName.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                      | `paasAppName_value`     |
| `--loggerApplication`    | Logger module: Value for the property: application.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                      | `application_value`     |
| `--loggerSubApplication` | Logger module: Value for the property: subapplication.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                   | `12345678`              |
| `--loggerSystem`         | Logger module: Value for the property: system.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                           | `system_value`          |
| `--loggerSubSystem`      | Logger Module: Value for the property: subSystem.<br><br>Applicable to: `spa`, `shell`, `mcf`                                                                                                                        | `subSystem_value`       |

The following properties are treated as _flags_ and do not require specifying their value.

| Flag            | Description                                                                      |
|-----------------|----------------------------------------------------------------------------------|
| `--useDefault`  | Avoid prompting the user by using default options for parameters not received.   |
| `--gitInit`     | Initializes a Git repository in the project.                                     |
| `--npmInstall`  | Automatically installs project dependencies.                                     |
| `--noUpdate`    | Ignore the check to make sure you are using the latest version of the generator. |
| `--skip-eslint` | It does not configure the project linter.                                        |

## Node and Angular Version

This version of CLI tool is able to generate the following archetypes

|                                 | **Angular 20** | **Angular 18** |
|---------------------------------|:--------------:|:--------------:|
| **SPA** (Darwin Classic)        | X              | X              |
| **SPA** (Gluon)                 | X              | X              |
| **Shell** (Darwin Classic)      | X              | X              |
| **Shell** (Gluon)               | X              | X              |
| **Microfront** (Darwin Classic) | X              | X              |
| **Microfront** (Gluon)          | X              | X              |

Depending on the specific version of the Angular framework selected, you will need a specific Node version to ensure their right work.

The table below will help you with the Node version you will need.

| Angular Version Darwin Archetype | Node Version                      |
|----------------------------------|-----------------------------------|
| **Angular 20**                   | `^20.19.0 || ^22.12.0 || ^24.0.0` |
| **Angular 18**                   | `^18.19.1 || ^20.11.1 || ^22.0.0` |

## Nomenclature

The `appName` property must comply with the following guidelines:

- Start with an alphabetic character (a-z).
- Contain only alphanumeric characters or hyphens.
- When a hyphen is added, the following character must be an alphabetic character (a-z).

The `company` must comply with:

- To be an alphabetic character (a-z).
- To be three letters length.

After the installation process has finished, the `name` property of `package.json` file will have the following value due to cataloging requirements:

- Darwin SPA archetype - `<projectKey>-<appName>`
- Darwin Shell archetype - `<projectKey>-<appName>`
- Darwin Microfront archetype - `<projectKey>-<appName>`
- Gluon SPA archetype - `<company>-<projectKey>-<appName>`
- Gluon Shell archetype - `<company>-<projectKey>-<appName>`
- Gluon Microfront archetype - `<company>-<projectKey>-<appName>`

## Templates (only for contributors)

This info is only intended to the contributors of the tool.

All archetypes use Angular CLI to generate their files, and on top of these we use templates to extend/overwrite their functionality.

### Templates directories

All files in `templates` can continue to have `Yeoman` style variables. Example: `<%= frameworkVendor %>`.

| Directory            | Description                                                                                                                                                                                                                                                                                                                                                                                                              |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `templates/copy`     | These files will be copied directly, keeping the same directory structure and name. <br> If there are files in the same position previously created with Angular CLI, they will be overwritten. <br> In the case of some files such as `.css` and `.scss`, only one of the 2 will be copied depending on the parameter chosen from the CLI.                                                                              |
| `templates/partials` | This directory contains only `.json` files, with the same directory structure and name as those previously generated by Angular CLI. <br> The properties of the files will be merged into one, if there is a repeated property, it will be overwritten by the value in the files located here. <br> Your directories can use variables starting the name with $. <br> *Example:* `templates/copy/$libScope/package.json` |
