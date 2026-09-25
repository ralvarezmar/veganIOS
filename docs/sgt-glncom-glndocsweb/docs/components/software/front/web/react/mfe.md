---
title: React Microfront Journey
---

## Introduction

The purpose of this documentation is to provide a **step-by-step guide** on how to create, build, analyze and deploy a microfront based on **React** framework within the GLUON platform.

This guide will allow you to understand how to build and deploy our web application through a CI/CD process but not how to develop it.
For more information about React on Gluon, please refer to the [React documentation](./framework/index.md).

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

You have to select the type of component you want to create, in this case you are going to create a **React Microfront**.

![Create Component](images/create-react-microfront-0.png)

???+ remember

    To follow the naming convention visit [Repository Naming Convention](../../../../../application/component-management/create-component.md#repository-naming-convention).

{!
   include-markdown "../../../../snippets/setup/front-setup.md"
   start="<!--Start Branch Strategy-->"
   end="<!--End Branch Strategy-->"
!}

Once the component is created we can see under the application that there is a new repository created with the name of the component, Sonar project and Fortify project.

![Component](images/create-react-microfront-2.png)

We have the following links in:

| Item | Link | Role Permission |
| --- | --- | --- |
| GitHub Repository | Link to the repository created in GitHub | Developer (RW) /Technical Lead (Maintain) [All roles explained](https://docs.github.com/es/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization) |
| Sonar Project | Link to the Sonar project created | All Users (Read) |
| Fortify Project | Link to the Fortify project created | All Users (Read) |

### React Microfront Template

#### Branches

{!
   include-markdown "../../../../snippets/setup/branch-setup-for-front.md"
!}

#### Structure

The generated React Microfront has a structure similar to the following (Depending the parameters you have previously configured):

=== "React Vite Microfront Example"

    ``` bash
    📂.github
     ┣ 📂workflows
     | ┣ 📜bluegreen-swith-workflow.yml
     | ┣ 📜cd.yml
     | ┣ 📜ci-gfw.yml
     | ┣ 📜quality.yml
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
    📂nginx
     ┣ 📜common-headers.conf
     ┣ 📜default.conf
     ┣ 📜gzip.conf
     ┗ 📜proxy-cache.conf
    📂public
     ┣ 📜favicon.ico
     ┣ 📜index.html
     ┣ 📜logo192.png
     ┣ 📜logo512.png
     ┣ 📜manifest.json
     ┗ 📜robots.txt
    📂src
     ┣ 📂assets
     | ┗ 📜react.svg
     ┣ 📜App.css
     ┣ 📜App.test.tsx
     ┣ 📜App.tsx
     ┣ 📜index.css
     ┣ 📜main.tsx
     ┣ 📜setupTests.ts
     ┗ 📜vite-env.d.ts
    📜.gitignore
    📜.tool-version
    📜Dockerfile
    📜README.adoc
    📜eslint.config.js
    📜index.html
    📜package.json
    📜tsconfig.app.json
    📜tsconfig.json
    📜tsconfig.node.json
    📜vite.config.ts
    ```

## Local Running

??? abstract "Cloning your repository"

    ### Cloning your repository

    Once we have the device properly configured, the first step is to clone the project locally.

    To do so, visit [**How to clone de project**](../../../../../application/component-management/create-component.md#cloning-a-repository).

??? abstract "Run your microfront"
    ### Running the microfront

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

=== "React Microfront Vite Example"

    ```properties
    # Npm parameters

    NODE_VERSION='18.20.2'
    NPM_CONFIGURATION_DIST_DIRECTORY='nginx/'
    NPM_RUN_INSTALL_COMMAND='npm i pnpm@9 -g && pnpm install'
    NPM_RUN_BUILD_COMMAND='pnpm build'
    NPM_RUN_TEST_COMMAND='pnpm coverage'

    # Sonar parameters
    SONAR_PROJECT_KEY='mex-rost-c314832drtmfev'

    # Fortify parameters
    FORTIFY_PROJECT='mex-rost-c314832drtmfev'

    # Deploy parameters
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
   start="<!--Start Intro-->"
   end="<!--End Intro-->"
!}

{!
   include-markdown "../../../../snippets/lifecycle/gitflow-for-front.md"
   start="<!--Start Description-->"
   end="<!--End Description-->"
!}

## Fix/Release Flow

{!
   include-markdown "../../../../snippets/lifecycle/fix-release-flow.md"
!}
