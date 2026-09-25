---
title: Darwin SPA/Shell Journey
---

## Introduction

The purpose of this documentation is to provide a **step-by-step guide** on how to create, build, analyze and deploy an SPA based on  **Darwin** framework within the GLUON platform.

This guide will allow you to understand how to build and deploy our web application through a CI/CD process but not how to develop it.
For more information about the development of a Darwin Microfront, please refer to the [Darwin SPA Archetype documentation](framework/ng-darwin/first-steps/ngdarwin-spa.md) or [Darwin Shell Archetype documentation](framework/microfrontend-architecture/archetypes/shell.md).

{!
   include-markdown "../../../../snippets/overview/front-overview.md"
   start="<!--Start Deploy target-->"
   end="<!--End Deploy target-->"
!}

## Setup your local environment

{!
   include-markdown "../../../../snippets/setup/npm-setup.md"
!}

## Create Component

### Gluon Portal

First you have to [**onboard your application.**](../../../../../application/application-management/index.md)
Once you have your application created, you can start creating your component.

To create a component, follow the steps described in [**Component Management**](../../../../../application/component-management/create-component.md), searching for the component to be created.

You have to select the type of component you want to create, in this case you are going to create a **Darwin SPA**.

![Create Component](images/create-darwin-spa-0.png)

???+ remember

    To follow the naming convention visit [Repository Naming Convention](../../../../../application/component-management/create-component.md#repository-naming-convention).

The users can customize the type of Single Page Application they want to create by selecting if it will be a Shell or not, the flavour and the version of Angular. For this example we have created a Darwin SPA with the following characteristics:

{!
   include-markdown "../../../../snippets/setup/front-setup.md"
   start="<!--Start Branch Strategy-->"
   end="<!--End Branch Strategy-->"
!}

- **Flavour**: If `Gluon` is selected, the archetype will use the [Security Context Manager (SCM)](./../core/security/index.md) and [HTTP library](./../core/http/index.md).
Otherwise if `Classic` is selected, the archetype will use the [@darwin/security library](https://automatic-doodle-rew2y31.pages.github.io/modules/_ng-darwin_security.html){:target="_blank"}.
- **Angular version**: by default the latest available version will always be selected, [here](framework/ng-darwin/versions/index.md) are the current versions.
- **Is a Shell?**: true *(This means the SPA will have capabilities related to integrate Microfronts)*.

![Params](images/dw-spa-params.png)

Once the component is created we can see under the application that there is a new repository created with the name of the component, Sonar project and Fortify project.

![Component](images/create-darwin-spa-2.png)

We have the following links in:

| Item | Link | Role Permission |
| --- | --- | --- |
| GitHub Repository | Link to the repository created in GitHub | Developer (RW) /Technical Lead (Maintain) [All roles explained](https://docs.github.com/es/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization){:target="_blank"} |
| Sonar Project | Link to the Sonar project created | All Users (Read) |
| Fortify Project | Link to the Fortify project created | All Users (Read) |

### Darwin SPA Template

#### Branches

{!
   include-markdown "../../../../snippets/setup/branch-setup-for-front.md"
!}

#### Structure

The generated project has a structure similar to the following. Please note that the structure may vary depending on whether the project was generated as an SPA or as a Shell:

``` bash
📂.github
 ┣ 📂workflows
 | ┣ 📜bluegreen-swith-workflow.yml
 | ┣ 📜cd.yml
 | ┣ 📜ci-fix-gfw.yml
 | ┣ 📜ci-gfw.yml
 | ┣ 📜create-release-branch.yml
 | ┣ 📜quality.yml
 | ┣ 📜release-fix-gfw.yml
 | ┣ 📜release-gfw.yml
 | ┣ 📜security.yml
 | ┣ 📜update-component-workflow.yml
 | ┗ 📜version-validation.yml
 ┗ 📜CODEOWNERS
📂.gluon
 ┣ 📂cd
 | ┣ 📂cert
 | | ┣ 📜cd.yml
 | | ┗ 📜values.yml
 | ┣ 📂pre
 | | ┣ 📜cd.yml
 | | ┗ 📜values.yml
 | ┗ 📂pro
 | | ┣ 📜cd.yml
 | | ┗ 📜values.yml
 | ┗ 📜values.yaml
 ┗ 📂ci
   ┗ 📜properties.env
📂api
 ┗ 📂public
 | ┗ 📜config.json
 ┣ 📜api-server.js
 ┗ 📜db.json
📂nginx
 ┣ 📂local
 | ┣ 📂conf.d
 | | ┗ 📜default-shell.conf
 | ┗ 📜nginx.conf
 ┣ 📜common-headers.conf
 ┣ 📜default.conf
 ┣ 📜gzip.conf
 ┗ 📜proxy-cache.conf
📂public
 ┣ 📜favicon.ico
 ┗ 📜gluon.svg
📂src
 ┣ 📂app
 | ┣ 📂global-position
 | | ┣ 📜global-position.html
 | | ┣ 📜global-position.spec.ts
 | | ┗ 📜global-position.ts
 | ┣ 📜app.config.ts
 | ┣ 📜app.html
 | ┣ 📜app.route.ts
 | ┣ 📜app.scss
 | ┣ 📜app.spec.ts
 | ┣ 📜app.ts
 ┣ 📂assets
 | ┣ 📜.gitkeep
 | ┗ gluon.svg
 ┗ 📂environments
 | ┣ 📜environment.development.ts
 | ┗ 📜environment.ts
 ┗ 📂locale
 | ┣ 📜messages.es.xlf
 | ┗ 📜messages.xlf
 ┣ 📜bootstrap.ts
 ┣ 📜index.html
 ┣ 📜main.ts
 ┣ 📜styles.css
📜.editorconfig
📜.gitignore
📜Dockerfile
📜README.md
📜angular.json
📜eslint.config.js
📜karma.conf.js
📜package.json
📜proxy.conf.json
📜tsconfig.app.json
📜tsconfig.json
📜tsconfig.spec.json
📜webpack.config.js
```

For more information on the structure and functionality of a Darwin Shell, please refer to the [Darwin Shell Archetype documentation](framework/microfrontend-architecture/archetypes/shell.md) provided by the framework.

## Local Running

??? abstract "Cloning your repository"

    ### Cloning your repository

    Once we have the device properly configured, the first step is to clone the project locally.

    To do so, visit [**How to clone de project**](../../../../../application/component-management/create-component.md#cloning-a-repository).

??? abstract "Run your SPA/Shell"
    ### Running the SPA/Shell

    Once you have clone your repo, the next thing to do is to install your dependencies. As any other node project, you'l need to execute the following command:

    ``` text
    npm install
    ```

    When that process end and you have all your dependencies installed, you'll need to serve the application. In order to do this, just run the following command:

    ``` text
    npm start
    ```

## Kubernetes Infrastructure

{!
   include-markdown "../snippets/kubernetes-for-front.md"
!}

## AWS/S3 Infrastructure

{!
   include-markdown "../snippets/s3-for-front.md"
!}

## Component Configuration

{!
   include-markdown "../../../../snippets/configuration/front-config.md"
   start="<!--Start front config init-->"
   end="<!--End front config init-->"
!}

=== "Darwin SPA example"

    ```properties
    NODE_VERSION='22.17.1'
    NPM_CONFIGURATION_DIST_DIRECTORY='nginx/'
    NPM_RUN_TEST_COMMAND='npm test --coverage'

    DOCKER_BUILD_ARGUMENTS='--build-arg ARTIFACT_PATH=${ARTIFACT_PATH} --build-arg CONFIG_PATH=${CONFIG_PATH}'

    # NPM GROUP
    NPM_APPLICATION_GROUP=santander-group-gluon-test
    ```

{!
   include-markdown "../../../../snippets/configuration/front-config.md"
   start="<!--Start front config end-->"
   end="<!--End front config end-->"
!}

## Build and Deploy your application

{!
   include-markdown "../../../../snippets/lifecycle/gitflow-for-front.md"
!}

## Fix/Release Flow

{!
   include-markdown "../../../../snippets/lifecycle/fix-release-flow.md"
!}
