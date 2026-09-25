---
title: (SCF) NodeJs Microservice
---

This base component template serves as a comprehensive guide for building and deploying Node.js microservices within the Gluon portal.
It streamlines the entire process, providing a clear and efficient pathway from development to deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the Node.js workflow for their microservices.
This includes guidance on setting up the project, configuring essential files, managing dependencies, and deploying the microservice.

The deployment process involves building a Docker image of the Node.js application, uploading the image to a container registry such as Harbor or AWS ECR, and deploying the image using Helm on Kubernetes platforms like EKS or OCP.
This guide separates the responsibilities of Continuous Integration (CI) and Continuous Deployment (CD) between Gluon and SCF.
While it is a brownfield project, we leverage Gluon's SonarQube, Sysdig, and Fortify for code quality and security analysis, rather than using our own tools directly.

Whether you are starting from scratch or integrating Node.js into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development and deployment process.
By following this guide, users can ensure their Node.js applications are properly built, the Docker images are uploaded to the appropriate container registry, and the microservices are deployed using Helm on EKS or OCP.

## Prerequisites

### AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC, which must be specified in the [awsRoleName](#deploymentyaml) parameter of the `deployment.yml` file.  
Note that this template is cataloged as a `Microservice components > Brownfield`, detailed information to make the request can be found [here](../support/credentials/brownfield.md).

### Supported Versions

The following dotnet versions are supported for building and deploying microservices using this template:

- 4.0.0
- 4.1.0
- 4.1.1
- 4.1.2
- 4.2.0
- 4.2.1
- 4.2.2
- 4.2.3
- 4.2.4
- 4.2.5
- 4.2.6
- 4.3.0
- 4.3.1
- 4.3.2
- 4.4.0
- 4.4.1
- 4.4.2
- 4.4.3
- 4.4.4
- 4.4.5
- 4.4.6
- 4.4.7
- 4.5.0
- 4.6.0
- 4.6.1
- 4.6.2
- 4.7.0
- 4.7.1
- 4.7.2
- 4.7.3
- 4.8.0
- 4.8.1
- 4.8.2
- 4.8.3
- 4.8.4
- 4.8.5
- 4.8.6
- 4.8.7
- 4.9.0
- 4.9.1
- 5.0.0
- 5.1.0
- 5.1.1
- 5.2.0
- 5.3.0
- 5.4.0
- 5.4.1
- 5.5.0
- 5.6.0
- 5.7.0
- 5.7.1
- 5.8.0
- 5.9.0
- 5.9.1
- 5.10.0
- 5.10.1
- 5.11.0
- 5.11.1
- 5.12.0
- 6.0.0
- 6.1.0
- 6.2.0
- 6.2.1
- 6.2.2
- 6.3.0
- 6.3.1
- 6.4.0
- 6.5.0
- 6.6.0
- 6.7.0
- 6.8.0
- 6.8.1
- 6.9.0
- 6.9.1
- 6.9.2
- 6.9.3
- 6.9.4
- 6.9.5
- 6.10.0
- 6.10.1
- 6.10.2
- 6.10.3
- 6.11.0
- 6.11.1
- 6.11.2
- 6.11.3
- 6.11.4
- 6.11.5
- 6.12.0
- 6.12.1
- 6.12.2
- 6.12.3
- 6.13.0
- 6.13.1
- 6.14.0
- 6.14.1
- 6.14.2
- 6.14.3
- 6.14.4
- 6.15.0
- 6.15.1
- 6.16.0
- 6.17.0
- 6.17.1
- 7.0.0
- 7.1.0
- 7.2.0
- 7.2.1
- 7.3.0
- 7.4.0
- 7.5.0
- 7.6.0
- 7.7.0
- 7.7.1
- 7.7.2
- 7.7.3
- 7.7.4
- 7.8.0
- 7.9.0
- 7.10.0
- 7.10.1
- 8.0.0
- 8.1.0
- 8.1.1
- 8.1.2
- 8.1.3
- 8.1.4
- 8.2.0
- 8.2.1
- 8.3.0
- 8.4.0
- 8.5.0
- 8.6.0
- 8.7.0
- 8.8.0
- 8.8.1
- 8.9.0
- 8.9.1
- 8.9.2
- 8.9.3
- 8.9.4
- 8.10.0
- 8.11.0
- 8.11.1
- 8.11.2
- 8.11.3
- 8.11.4
- 8.12.0
- 8.13.0
- 8.14.0
- 8.14.1
- 8.15.0
- 8.15.1
- 8.16.0
- 8.16.1
- 8.16.2
- 8.17.0
- 9.0.0
- 9.1.0
- 9.2.0
- 9.2.1
- 9.3.0
- 9.4.0
- 9.5.0
- 9.6.0
- 9.6.1
- 9.7.0
- 9.7.1
- 9.8.0
- 9.9.0
- 9.10.0
- 9.10.1
- 9.11.0
- 9.11.1
- 9.11.2
- 10.0.0
- 10.1.0
- 10.2.0
- 10.2.1
- 10.3.0
- 10.4.0
- 10.4.1
- 10.5.0
- 10.6.0
- 10.7.0
- 10.8.0
- 10.9.0
- 10.10.0
- 10.11.0
- 10.12.0
- 10.13.0
- 10.14.0
- 10.14.1
- 10.14.2
- 10.15.0
- 10.15.1
- 10.15.2
- 10.15.3
- 10.16.0
- 10.16.1
- 10.16.2
- 10.16.3
- 10.17.0
- 10.18.0
- 10.18.1
- 10.19.0
- 10.20.0
- 10.20.1
- 10.21.0
- 10.22.0
- 10.22.1
- 10.23.0
- 10.23.1
- 10.23.2
- 10.23.3
- 10.24.0
- **10.24.1**
- 11.0.0
- 11.1.0
- 11.2.0
- 11.3.0
- 11.4.0
- 11.5.0
- 11.6.0
- 11.7.0
- 11.8.0
- 11.9.0
- 11.10.0
- 11.10.1
- 11.11.0
- 11.12.0
- 11.13.0
- 11.14.0
- 11.15.0
- 12.0.0
- 12.1.0
- 12.2.0
- 12.3.0
- 12.3.1
- 12.4.0
- 12.5.0
- 12.6.0
- 12.7.0
- 12.8.0
- 12.8.1
- 12.9.0
- 12.9.1
- 12.10.0
- 12.11.0
- 12.11.1
- 12.12.0
- 12.13.0
- 12.13.1
- 12.14.0
- 12.14.1
- 12.15.0
- 12.16.0
- 12.16.1
- 12.16.2
- 12.16.3
- 12.17.0
- 12.18.0
- 12.18.1
- 12.18.2
- 12.18.3
- 12.18.4
- 12.19.0
- 12.19.1
- 12.20.0
- 12.20.1
- 12.20.2
- 12.21.0
- 12.22.0
- 12.22.1
- 12.22.2
- 12.22.3
- 12.22.4
- 12.22.5
- 12.22.6
- 12.22.7
- 12.22.8
- 12.22.9
- 12.22.10
- 12.22.11
- **12.22.12**
- 13.0.0
- 13.0.1
- 13.1.0
- 13.2.0
- 13.3.0
- 13.4.0
- 13.5.0
- 13.6.0
- 13.7.0
- 13.8.0
- 13.9.0
- 13.10.0
- 13.10.1
- 13.11.0
- 13.12.0
- 13.13.0
- 13.14.0
- 14.0.0
- 14.1.0
- 14.2.0
- 14.3.0
- 14.4.0
- 14.5.0
- 14.6.0
- 14.7.0
- 14.8.0
- 14.9.0
- 14.10.0
- 14.10.1
- 14.11.0
- 14.12.0
- 14.13.0
- 14.13.1
- 14.14.0
- 14.15.0
- 14.15.1
- 14.15.2
- 14.15.3
- 14.15.4
- 14.15.5
- 14.16.0
- 14.16.1
- 14.17.0
- 14.17.1
- 14.17.2
- 14.17.3
- 14.17.4
- 14.17.5
- 14.17.6
- 14.18.0
- 14.18.1
- 14.18.2
- 14.18.3
- 14.19.0
- 14.19.1
- 14.19.2
- 14.19.3
- 14.20.0
- 14.20.1
- 14.21.0
- 14.21.1
- 14.21.2
- **14.21.3**
- 15.0.0
- 15.0.1
- 15.1.0
- 15.2.0
- 15.2.1
- 15.3.0
- 15.4.0
- 15.5.0
- 15.5.1
- 15.6.0
- 15.7.0
- 15.8.0
- 15.9.0
- 15.10.0
- 15.11.0
- 15.12.0
- 15.13.0
- 15.14.0
- 16.0.0
- 16.1.0
- 16.2.0
- 16.3.0
- 16.4.0
- 16.4.1
- 16.4.2
- 16.5.0
- 16.6.0
- 16.6.1
- 16.6.2
- 16.7.0
- 16.8.0
- 16.9.0
- 16.9.1
- 16.10.0
- 16.11.0
- 16.11.1
- 16.12.0
- 16.13.0
- 16.13.1
- 16.13.2
- 16.14.0
- 16.14.1
- 16.14.2
- 16.15.0
- 16.15.1
- 16.16.0
- 16.17.0
- 16.17.1
- 16.18.0
- 16.18.1
- 16.19.0
- 16.19.1
- 16.20.0
- 16.20.1
- **16.20.2**
- 17.0.0
- 17.0.1
- 17.1.0
- 17.2.0
- 17.3.0
- 17.3.1
- 17.4.0
- 17.5.0
- 17.6.0
- 17.7.0
- 17.7.1
- 17.7.2
- 17.8.0
- 17.9.0
- 17.9.1
- 18.0.0
- 18.1.0
- 18.2.0
- 18.3.0
- 18.4.0
- 18.5.0
- 18.6.0
- 18.7.0
- 18.8.0
- 18.9.0
- 18.9.1
- 18.10.0
- 18.11.0
- 18.12.0
- 18.12.1
- 18.13.0
- 18.14.0
- 18.14.1
- 18.14.2
- 18.15.0
- 18.16.0
- 18.16.1
- 18.17.0
- 18.17.1
- 18.18.0
- 18.18.1
- 18.18.2
- 18.19.0
- 18.19.1
- 18.20.0
- 18.20.1
- 18.20.2
- 18.20.3
- 18.20.4
- 18.20.5
- 18.20.6
- 18.20.7
- **18.20.8**
- 19.0.0
- 19.0.1
- 19.1.0
- 19.2.0
- 19.3.0
- 19.4.0
- 19.5.0
- 19.6.0
- 19.6.1
- 19.7.0
- 19.8.0
- 19.8.1
- 19.9.0
- 20.0.0
- 20.1.0
- 20.2.0
- 20.3.0
- 20.3.1
- 20.4.0
- 20.5.0
- 20.5.1
- 20.6.0
- 20.6.1
- 20.7.0
- 20.8.0
- 20.8.1
- 20.9.0
- 20.10.0
- 20.11.0
- 20.11.1
- 20.12.0
- 20.12.1
- 20.12.2
- 20.13.0
- 20.13.1
- 20.14.0
- 20.15.0
- 20.15.1
- 20.16.0
- 20.17.0
- 20.18.0
- 20.18.1
- 20.18.2
- 20.18.3
- 20.19.0
- 20.19.1
- 20.19.2
- **20.19.3**
- 21.0.0
- 21.1.0
- 21.2.0
- 21.3.0
- 21.4.0
- 21.5.0
- 21.6.0
- 21.6.1
- 21.6.2
- 21.7.0
- 21.7.1
- 21.7.2
- 21.7.3
- 22.0.0
- 22.1.0
- 22.2.0
- 22.3.0
- 22.4.0
- 22.4.1
- 22.5.0
- 22.5.1
- 22.6.0
- 22.7.0
- 22.8.0
- 22.9.0
- 22.10.0
- 22.11.0
- 22.12.0
- 22.13.0
- 22.13.1
- 22.14.0
- 22.15.0
- 22.15.1
- **22.16.0**
- 23.0.0
- 23.1.0
- 23.2.0
- 23.3.0
- 23.4.0
- 23.5.0
- 23.6.0
- 23.6.1
- 23.7.0
- 23.8.0
- 23.9.0
- 23.10.0
- 23.11.0
- 23.11.1
- 24.0.0
- 24.0.1
- 24.0.2
- 24.1.0
- **24.2.0**

Ensure that your development environment matches one of these supported versions to guarantee compatibility with the template and associated tools.

When creating the component, you will be prompted to select the major version, and the repository will be initialized with the latest available release corresponding to the selected version.
**If you need a different version, you can always set the NODE_VERSION in the properties.env file**.

Ensure that your development environment matches one of these supported versions to guarantee compatibility with the template and associated tools.

## Create Component

### Gluon Portal

To begin, you must onboard your application. This involves setting up your application within the system. Once your application is successfully created and onboarded, you can proceed to create your component.

To create a component, follow these detailed steps:

1. **Select the Component Type**:
    First, you need to choose the type of component you wish to create. In this case, select `(SCF) NodeJS Microservice`.

    ![Create  Component](./images/node/node-create-component.png)

2. **Fill in Component Details**:
    Next, you will be prompted to fill in the necessary details for your component. This includes:
    - **Name**: Provide a unique and descriptive name for your component.
    - **Short Name**: Short names can only contain capital letters and digits.
    - **Description**: Write a detailed description that explains the purpose and functionality of the component.
    - **Branch Strategy**: Choose a branch strategy for your component's repository. The recommended branch strategy for this template is `git flow`, which helps in managing the development workflow efficiently.
    - **NodeJs Version**: Specify the major version, and the repository will be initialized with the latest available release corresponding to the selected version.
    If you need a different version, you can always set the NODE_VERSION in the properties.env file.
    - **Contact Information**: Provide the contact information for the person responsible for the component. Include the name and email address.

    ![Complete creation of the component](./images/node/node-create-component-cont.png)

3. **Component Creation**:
    After filling in the required details, proceed to create the component. Once the component is created, you will notice that a new repository is generated under your application.
    This repository will have the name of your component and will be integrated with SonarQube for code quality analysis and Fortify for security analysis.

By following these steps, you will have successfully created a new component. This component will be ready for further development within the GitHub repository.

### Component Repository

When creating a component from scratch, a scaffolding workflow runs automatically and creates the structure of the repository with the development branch, including all configuration files and workflows.

???+ warning "Scaffolding Note"

      Sometimes the scaffolding doesn't trigger automatically, so it needs to be launched manually from the actions tab.

#### Branches

{!
   include-markdown "./snippets/branch-structure.md"
   start="<!--Start Branch Structure-->"
   end="<!--End Branch Structure-->"
!}

#### Structure

The generated microservice has a structure similar to the following:

``` bash
📦
 ┣ 📂.chart
 ┃ ┣ 📜values-dev.yaml
 ┃ ┣ 📜values-pre.yaml
 ┃ ┣ 📜values-pro.yaml
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜cd.yml
 ┃ ┃ ┣ 📜ci.yml
 ┃ ┃ ┣ 📜quality.yml
 ┃ ┃ ┣ 📜release.yml
 ┃ ┃ ┣ 📜security.yml
 ┃ ┃ ┣ 📜update-component-workflow.yml
 ┃ ┃ ┗ 📜version-validation.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon
 ┃ ┣ 📂ci
 ┃ ┗ ┗ 📜properties.env
 ┣ 📜.dockerignore
 ┣ 📜deployment.yaml
 ┣ 📜Dockerfile
 ┣ 📜multiregistry.json
 ┣ 📜package.json
 ┗ 📜README.md
```

## Component Configuration

This section provides an overview of the necessary configurations for integrating the Gluon component into your project. It covers the required branches and essential configuration files to ensure smooth CI/CD processes.

### Configuration Files

This base component template works with some configuration files that may need some modifications:

- `properties.env`: Properties with the CI/CD configuration.
- `Dockerfile`: Configuration to build the image.
- `multiregistry.json`: registry configuration and credentials to upload the image.
- `deployment.yaml`: file to define the CD deploy procsess.
- `.chart/values-(dev/pre/pro).yaml`: files to customize the Helm Chart.
- `package.json`: Node Js configuration file.

#### Properties

=== "Default"

    ```properties
      # Sonar parameters
      SONAR_ID="SONAR_GLUON_COMMUNITY"
      SONAR_PROJECT_KEY=""

      # Fortify parameters
      FORTIFY_PROJECT=""

      DOCKER_BUILD_ARGUMENTS=''
      IMAGE_DEPLOY_TYPE="helm"
      HELM_PACKAGE="false"
    ```

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

=== "Properties.env"

    | **Variable**        | **Required** | **Description** | **Example value**               |
    |---------------------|--------------|-----------------|---------------------------------|
    | **SONAR_PROJECT_KEY** | true         | Project key in Sonar | sgt-gluonad-probemicroframework |
    | **FORTIFY_PROJECT** | true         | Project name in Fortify | sgt-gluonad-probemicroframework |
    | **NODE_VERSION** | true         | Node version to use | 20.12.0 |
    | **DOCKER_BUILD_ARGUMENTS** | false        | Docker arguments for Docker Build | "" |

=== "SONAR Configuration"

    | Property             | Required   | Description                         | Example |
    |----------------------|------------|-------------------------------------|---------------|
    | SONAR_ID             | false      | The name of the Sonar instance to be used. This value is unique and its value will be 'SONAR_GLUON_COMMUNITY'   | 'SONAR_GLUON_COMMUNITY' |
    | SONAR_PROJECT_KEY    | true       | Project key that's created in the sonar instance | "ccc:ccc:test-project:npm-immutable-test" |
    | SONAR_REPORT_PATH    | false      | Location where the scanner writes the report-task.txt  | 'target/site' |
    | SONAR_MEMORY_PROPERTIES | false   | Memory properties                   | '-Xmx256m' |
    | ELASTICSEARCH_API_URL | true      | Elasticsearch api url with protocol | `https://[url]` |
    | ELASTICSEARCH_ALIAS   | true      | Elastic Search index                | 'index-x' |
    | ELASTICSEARCH_TYPE    | true      | Elasticsearch type                  | '_doc' |
    | QG_ENABLED    | false      | Enables or disables Sonar, Fortify, and Sonatype scans in CI, with 'high' for blocking, 'none' for non-blocking, and empty to skip scans.                  | 'high' |

=== "Node Configuration"

    | **Variable**                        | **Required** | **Description**                          | **Example value**                       |
    |-------------------------------------|--------------|------------------------------------------|-----------------------------------------|
    | **NODE_VERSION**                    | true         | Node version to use from [available versions](#supported-versions)                      | 18.18.2                                 |
    | **NPM_APPLICATION_DIST_DIRECTORY**  | false         | Directory for application distribution   | app/                                    |
    | **NPM_CONFIGURATION_DIST_DIRECTORY**| false         | Directory for configuration distribution | config/                                 |
    | **NPM_RUN_INSTALL_COMMAND**         | false         | Command to install npm packages          | npm install                             |
    | **NPM_RUN_BUILD_COMMAND**           | false         | Command to build the application         | npm run build                 |
    | **NPM_RUN_TEST_COMMAND**            | false         | Command to run tests with coverage       | npm run test:coverage                   |
    | **NPM_SONAR_PROPERTIES**            | false         | Sonar properties for npm                 | -Dsonar.sources=./src,package.json -Dsonar.javascript.coveragePlugin=lcov -Dsonar.javascript.lcov.reportPath=./coverage/lcov.info -Dsonar.typescript.lcov.reportPaths=./coverage/lcov.info -Dsonar.typescript.coveragePlugin=lcov |

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    To avoid possible errors, the **properties.env** file is generated with the necessary values for the variables **SONAR_PROJECT_KEY** and **FORTIFY_PROJECT**.

    Example values:

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"

    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

#### Dockerfile

The `Dockerfile` is a critical file used to build the Docker image for the microservice during the *Build* stage of the CI/CD pipeline.
This file contains a series of instructions that specify how to assemble the Docker image, including setting up the base image, copying application files, and defining any additional commands needed to configure the container environment.

An example `Dockerfile` might look like this:

```dockerfile title="Dockerfile Proposal" linenums="1"
FROM ...

# Copy the published application into the container with this command:
WORKDIR /artifact/path
COPY . .

# Add your Dockerfile instructions below
```

#### Package.json

The `package.json` file is a crucial component of any Node.js project. It serves as the manifest file for the project, containing metadata relevant to the project such as the project name, version, description, main file, scripts, dependencies, and more.
This file allows npm (Node Package Manager) to manage the project's dependencies and scripts efficiently.

**Key Sections of `package.json`:**

 - **name**: The name of your project.
 - **version**: The current version of your project.
 - **description**: A brief description of your project.
 - **main**: The entry point of your application.
 - **scripts**: Scripts to run various tasks such as starting the server, running tests, building the project, etc.
 - **dependencies**: Packages required for the project to run.
 - **devDependencies**: Packages required for development purposes.

**Customizing `package.json`:**
Users using this template may need to update the `name`, `version`, and `description` fields to match their project's specifics.
Additionally, they might need to add or modify dependencies and scripts to suit their project's requirements.
If users already have a `package.json` file, they can merge the dependencies and scripts from the template with their existing file.

#### Multiregistry

The JSON snippet below illustrates a simple multi-registry configuration.

???+ warning "Note"

      In case of deploying to Openshift (**OSE3**), note that the registry should be set to **Harbor**.

In the case of using **Harbor** as a registry, make sure to add `harbor_host` in the file and to have the secrets `HARBOR_USERNAME` and `HARBOR_PASSWORD` configured in the repository.

Find below an example of a multiregistry file with an AWS ECR case and Harbor examples:

```json title="Simple multiregistry example" linenums="1"
[
  {
    "environment": "dev",
    "registries": [
      {
        "registry-type":"ecr|harbor",
        "harbor_host": "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "repository": "",
        "awsRegion":   "",
        "awsAccount": "",
        "kms": ""
      }
    ]
  },
  {
    "environment": "pre",
    "registries": [
      {
        "registry-type":"ecr|harbor",
        "harbor_host": "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "repository": "",
        "awsRegion":   "",
        "awsAccount": "",
        "kms": ""
      }
    ]
  },
  {
    "environment": "pro",
    "registries": [
      {
        "registry-type":"[ecr|harbor]",
        "harbor_host": "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "repository": "",
        "awsRegion":   "",
        "awsAccount": "",
        "kms": ""
      }
    ]
  }
]
```

In this configuration:

- `registry-type` refers to the type of registry, being `ecr` or `harbor`.
- `awsRegion` to deploy to when `registry-type` is set to `ecr`.
- `repository` denotes the Docker image in the registry.
- `awsAccount` ID if wen `registry-type` is set to `ecr`.
- `kms` refers tot he kms key.
- `harbor_host` needs to be defined when `registry-type` is set to `harbor`.

This configuration is essential when managing and deploying Docker images across different registries. It ensures each Docker image is correctly authenticated, deployed, and scanned.
Please note that the usernameId and passwordId should be registered as secrets in your repository and be valid credentials for deploying in the registries.

???+ warning "Credentials and Secrets for Harbor"

      Make sure the parameters `HARBOR_USERNAME` and `HARBOR_PASSWORD` are registered as secrets in your repository when registry-type is set to harbor.
      Note that no credentials are needed for AWS ECR image upload.

#### Deployment.yaml

The `deployment.yaml` file is used to define the CD deploy process for the microservice using Helm in **EKS** or **Openshift**.

`awsRoleName`: When using roles a awsRoleName under providerParams needs to be defined (the name of the role is expected and not the entire ARN).

When using roles, if the pod needs credentials to consume AWS resources, it will also be necessary to reference serviceAccountName in the values files (check the Values section for more information).

```yaml title="Simple deployment for EKS and OSE3 example" linenums="1"
environments:
  - name: cert
    regions:
      - name: dev
        properties:
          application: # application to deploy
          cluster:
            apiServer: # api server url
            namespace: # namespace to deploy
            provider: eks/ose3 # choose between EKS or Openshift Deployment type
            ose3TokenSecretName: # Deployment Token Secret Name for OSE3 (empty defaults to DEPLOYER_TOKEN_DEV)
            providerParams: # only for eks provider
              awsAccount: # aws account id
              awsRoleName: # role name
              awsRegion: # aws region
              clusterName: # cluster name
          helm:
            host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
            project: # chart template project
            version: # chart template version
            repoType: harbor
            chart: # chart template name
  - name: pre
  ...
```

???+ info "Multi Region Deployment"

    Note that multiple regions can be configured within each environment. For instance within the *cert* environment users could configure multiple regions such as *dev*, *dev2* or whatever name fits best. The same applies to other environments.

#### .chart/values-(dev/pre/pro).yaml

In the `deployment.yml` file, we reference the chart that we want to use. In the following example, an excerpt from `deployment.yml` is shown where we reference the chart helm-eks-front-chart in its version 1.0.1.

```yaml title="Deployment file excerpt referencing Helm Chart" linenums="1"
helm:
  host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
  project: # chart template project
  version: # chart template version
  repoType: harbor
  chart: # chart template name
```

This chart is configured/customized using the `values-(env).yml` files explained below:

???+ warning "Note"

      The values files are stored in the repository under the .chart directory and are used to configure the Helm Chart that is parameterized to take them into account. There is a values file for each environment:

```txt
.chart
| values-dev.yaml
| values-pre.yaml
| values-pro.yaml
```

Find below an example of values-dev.yaml:

???+ warning "Note"

      For `serviceAccountname`: If the pod needs credentials to consume AWS resources, it will be necessary to reference a serviceAccountName.

```yaml title="Values-(dev/pre/pro).yaml" linenums="1"
image:
  repository: <image to use by the pod, ex.: 000000000000.dkr.ecr.eu-west-1.amazonaws.com/example/example>
  tag: <Image tag to use. ej.: 1.0.0-SNAPSHOT>
serviceAccountName: <*name of the serviceAccount for IRSA, if applicable>
microservice: <microservice name>
trackingCode: <tracking code>
hostName: <hostname>
secretTls: <TLS secret name to use>
namespace: <Namespace>
path: /
port: <port>
replicas: <pod replicas>
Secrets:
  - <Name of the secret to us>
configurationFiles:
  - name: <name>
    data: |-
      EXAMPLE: "example"
```

???+ warning "Note"

      IRSA (IAM Roles for Service Accounts) should be used in scenarios where you would traditionally use user/password credentials to access AWS resources from within a pod. By using IRSA, you enhance security by leveraging IAM roles and policies, thus avoiding the need to hardcode sensitive credentials in your application code.

      *Warning*: Ensure you are using IRSA when configuring your AWS SDK for Amazon EKS. This is crucial for secure and efficient access management. It is essential for replacing traditional user/password methods when consuming AWS resources from within your pods.

### Secrets Configuration

EKS deployments don’t require setting any credentials as secrets in your repository as authentication is done using roles.
*Only in Openshift* deployment cases, a Token is required for each environment as GitHub Repository Secrets.

Configure all required secrets for each environment as in the following example in the [deployment.yml file](#deploymentyaml).

```yaml title="OSE3 Token secret name example" linenums="1"
environments:
  - name: cert
    regions:
      - name: dev
        properties:
          cluster:
            ose3TokenSecretName: YOUR_OSE3_SECRET_NAME
  ...
```

Make sure to have your secrets configured with the provided name.
To do so, go to Settings > Security > Secrets and variables > Actions and add the following secrets at “Repository secrets” level.

If no custom secrets are configured within the deployment.yaml file the workflow will search the following default secrets:

![Add Openshift Secrets](./images/node/openshift-token.png)

*Only* if the image is uploaded to a *Harbor* registry instead of AWS ECR a HARBOR_USERNAME and HARBOR_PASSWORD must be as secrets:

![Add Harbor Secrets](./images/node/harbor-password.png)

## Application Lifecycle Management: How to build and deploy

{!
   include-markdown "./snippets/micro-git-flow-lifecycle.md"
   start="<!--Start Flow-->"
   end="<!--End Flow-->"
!}

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
