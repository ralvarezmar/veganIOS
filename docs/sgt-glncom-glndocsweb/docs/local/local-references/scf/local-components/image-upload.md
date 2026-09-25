---
title: (SCF) Image Upload
---

## Introduction

This documentation provides a comprehensive guide for the Image Upload component.
This component is designed to upload Docker images to an ECR (Elastic Container Registry in AWS) or Harbor without deploying them.

In this guide, users will find detailed instructions, best practices, and examples to effectively utilize the Image Upload component.
This includes guidance on setting up the component, configuring essential files, managing dependencies, and performing the image upload process from a Dockerfile.

Whether you are starting from scratch or integrating the Image Upload component into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient image upload process to your chosen registry.

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC, which must be specified in the [awsRoleName](#multiregistry) parameter of the `multiregistry.json` file.
Note that this template is cataloged as a `Non Microservice components > ECR Components`, detailed information to make the request can be found [here](../support/credentials/ecr.md).

## Create Component

### Gluon Portal

{!
   include-markdown "./snippets/create-component-gluon.md"
   start="<!--Start creation-->"
   end="<!--End creation-->"
!}

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
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜image-upload.yml
 ┃ ┃ ┣ 📜release.yml
 ┃ ┃ ┣ 📜update-component-workflow.yml
 ┃ ┃ ┗ 📜version-validation.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜properties.env
 ┣ 📜Dockerfile
 ┣ 📜multiregistry.json
 ┗ 📜VERSION
```

## Component Configuration

This section provides an overview of the necessary configurations for integrating the Gluon component into your project. It covers the required branches and essential configuration files to ensure smooth CI/CD processes.

### Configuration Files

This base component template works with some configuration files that may need some modifications:

* `properties.env`: Properties with the CI/CD configuration.
* `Dockerfile`: Configuration to build the image.
* `multiregistry.json`: registry configuration and credentials to upload the image.
* `VERSION`: Version configuration file.

#### Properties

=== "Default"

    ```properties
      DOCKER_BUILD_ARGUMENTS=''
      IMAGE_DEPLOY_TYPE="helm"
      HELM_PACKAGE="false"
    ```

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

=== "Properties.env"

    | **Variable**        | **Required** | **Description** | **Example value**               |
    |---------------------|--------------|-----------------|---------------------------------|
    | **DOCKER_BUILD_ARGUMENTS** | false        | Docker arguments for Docker Build | "" |

#### Dockerfile

This file allow us to build the image with the microservice in the *Build* stage of the CI/CD pipeline.

One example for Dockerfile is:

```dockerfile title="Dockerfile Proposal" linenums="1"
FROM ...

# Copy the published application into the container with this command:
WORKDIR /artifact/path
COPY . .

# Add your Dockerfile instructions below
```

#### Multiregistry

The JSON snippet below illustrates a simple multi-registry configuration.

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
        "awsRoleName": "",
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
        "awsRoleName": "",
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
        "awsRoleName": "",
        "awsRegion":   "",
        "awsAccount": "",
        "kms": ""
      }
    ]
  }
]
```

In this configuration:

* `registry-type` refers to the type of registry, being `ecr` or `harbor`.
* `awsRegion` to deploy to when `registry-type` is set to `ecr`.
* `repository` denotes the Docker image in the registry.
* `awsAccount` ID if wen `registry-type` is set to `ecr`.
* `kms` refers tot he kms key.
* `awsRoleName` is the name of the role used to interact with AWS.
* `harbor_host` needs to be defined when `registry-type` is set to `harbor`.

This configuration is essential when managing and deploying Docker images across different registries. It ensures each Docker image is correctly authenticated, deployed, and scanned.
Please note that the usernameId and passwordId should be registered as secrets in your repository and be valid credentials for deploying in the registries.

???+ warning "Credentials and Secrets for Harbor"

      Make sure the parameters `HARBOR_USERNAME` and `HARBOR_PASSWORD` are registered as secrets in your repository when registry-type is set to harbor.
      Note that no credentials are needed for AWS ECR image upload.

#### VERSION File

The `VERSION` file is a simple text file that contains the version of the project. This file is used to track the current version of the project in a straightforward manner.

**Example of a `VERSION` file:**

```txt
1.0.0-SNAPSHOT
```

**Customizing the `VERSION` file:**
Users using this template may need to update the version string to match their project's specifics. The version string should follow semantic versioning conventions, such as `MAJOR.MINOR.PATCH` (e.g., `1.0.0`).

If users already have a `VERSION` file, they can update the version string as needed to reflect the current state of their project.

### Secrets Configuration

*Only* if the image is uploaded to a *Harbor* registry instead of AWS ECR a HARBOR_USERNAME and HARBOR_PASSWORD must be as secrets:

To do so, go to Settings > Security > Secrets and variables > Actions and add the following secrets at “Repository secrets” level.
![Add Harbor Secrets](./images/node/harbor-password.png)

## Application Lifecycle Management: How to build and upload your image

{!
   include-markdown "./snippets/image-upload-git-flow-lifecycle.md"
   start="<!--Start Flow-->"
   end="<!--End Flow-->"
!}

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
