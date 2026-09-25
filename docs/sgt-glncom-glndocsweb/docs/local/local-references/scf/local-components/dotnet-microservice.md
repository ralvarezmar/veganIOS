---
title: (SCF) .NET Microservice
---

This base component template serves as a comprehensive guide for building and deploying .NET microservices within the Gluon portal.
It streamlines the entire process, providing a clear and efficient pathway from development to deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the .NET workflow for their microservices.
This includes guidance on setting up the project, configuring essential files, managing dependencies, and deploying the microservice.

While it is a brownfield project, we leverage Gluon's SonarQube, Sysdig, and Fortify for code quality and security analysis, rather than using our own tools directly.

Whether you are starting from scratch or integrating .NET into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development and deployment process for .NET microservices.
By following this guide, users can ensure their .NET microservices are properly built, analyzed for quality and security, and deployed efficiently within the Gluon portal.

## Prerequisites

### AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC, which must be specified in the [awsRoleName](#deploymentyaml) parameter of the `deployment.yml` file.  
Note that this template is cataloged as a `Microservice components > Brownfield`, detailed information to make the request can be found [here](../support/credentials/brownfield.md).

### Supported Versions

The following dotnet versions are supported for building and deploying microservices using this template:

- 6.0.313
- 6.0.314
- 6.0.315
- 6.0.316
- 6.0.317
- 6.0.318
- 6.0.319
- 6.0.320
- 6.0.321
- 6.0.400
- 6.0.401
- 6.0.402
- 6.0.403
- 6.0.404
- 6.0.405
- 6.0.406
- 6.0.407
- 6.0.408
- 6.0.410
- 6.0.411
- 6.0.412
- 6.0.413
- 6.0.414
- 6.0.415
- 6.0.416
- 6.0.417
- 6.0.418
- 6.0.419
- 6.0.420
- 6.0.421
- 6.0.422
- 6.0.423
- 6.0.424
- 6.0.425
- 6.0.427
- **6.0.428**
- 7.0.100
- 7.0.101
- 7.0.102
- 7.0.103
- 7.0.104
- 7.0.105
- 7.0.107
- 7.0.108
- 7.0.109
- 7.0.110
- 7.0.111
- 7.0.112
- 7.0.113
- 7.0.114
- 7.0.115
- 7.0.116
- 7.0.117
- 7.0.118
- 7.0.119
- 7.0.120
- 7.0.200
- 7.0.201
- 7.0.202
- 7.0.203
- 7.0.302
- 7.0.304
- 7.0.305
- 7.0.306
- 7.0.307
- 7.0.308
- 7.0.309
- 7.0.310
- 7.0.311
- 7.0.312
- 7.0.313
- 7.0.314
- 7.0.315
- 7.0.316
- 7.0.317
- 7.0.400
- 7.0.401
- 7.0.402
- 7.0.403
- 7.0.404
- 7.0.405
- 7.0.406
- 7.0.407
- 7.0.408
- 7.0.409
- **7.0.410**
- 8.0.100
- 8.0.101
- 8.0.102
- 8.0.103
- 8.0.104
- 8.0.105
- 8.0.106
- 8.0.107
- 8.0.108
- 8.0.110
- 8.0.111
- 8.0.112
- 8.0.113
- 8.0.114
- 8.0.115
- 8.0.116
- 8.0.117
- 8.0.200
- 8.0.201
- 8.0.202
- 8.0.203
- 8.0.204
- 8.0.205
- 8.0.206
- 8.0.300
- 8.0.301
- 8.0.302
- 8.0.303
- 8.0.304
- 8.0.306
- 8.0.307
- 8.0.308
- 8.0.309
- 8.0.310
- 8.0.311
- 8.0.312
- 8.0.313
- 8.0.314
- 8.0.400
- 8.0.401
- 8.0.402
- 8.0.403
- 8.0.404
- 8.0.405
- 8.0.406
- 8.0.407
- 8.0.408
- 8.0.409
- 8.0.410
- **8.0.411**
- 9.0.100
- 9.0.101
- 9.0.102
- 9.0.103
- 9.0.104
- 9.0.105
- 9.0.106
- 9.0.107
- 9.0.200
- 9.0.201
- 9.0.202
- 9.0.203
- 9.0.204
- 9.0.205
- 9.0.300
- **9.0.301**

Ensure that your development environment matches one of these supported versions to guarantee compatibility with the template and associated tools.

When creating the component, you will be prompted to select the major version, and the repository will be initialized with the latest available release corresponding to the selected version
**If you need a different version, you can always set the DOTNET_VERSION in the properties.env file**.

Ensure that your development environment matches one of these supported versions to guarantee compatibility with the template and associated tools.

## Create Component

### Gluon Portal

To begin, you must onboard your application. This involves setting up your application within the system. Once your application is successfully created and onboarded, you can proceed to create your component.

To create a component, follow these detailed steps:

1. **Select the Component Type**:
    First, you need to choose the type of component you wish to create. In this case, select `(SCF) .NET Microservice`.

    ![Create  Component](./images/dotnet/dotnet-create-component.png)

2. **Fill in Component Details**:
    Next, you will be prompted to fill in the necessary details for your component. This includes:
    - **Name**: Provide a unique and descriptive name for your component.
    - **Short Name**: Short names can only contain capital letters and digits.
    - **Description**: Write a detailed description that explains the purpose and functionality of the component.
    - **Branch Strategy**: Choose a branch strategy for your component's repository. The recommended branch strategy for this template is `git flow`, which helps in managing the development workflow efficiently.
    - **Dotnet Version**: Specify the major version, and the repository will be initialized with the latest available release corresponding to the selected version.
    If you need a different version, you can always set the DOTNET_VERSION in the properties.env file.
    - **Contact Information**: Provide the contact information for the person responsible for the component. Include the name and email address.

    ![Complete creation of the component](./images/dotnet/dotnet-create-component-cont.png)

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
 ┣ 📜deployment.yaml
 ┣ 📜Dockerfile
 ┣ 📜multiregistry.json
 ┗ 📜VERSION
```

## Component Configuration

This section provides an overview of the necessary configurations for integrating the Gluon component into your project. It covers the required branches and essential configuration files to ensure smooth CI/CD processes.

### Configuration Files

This base component template works with some configuration files that may need some modifications:

- `properties.env`: Properties with the CI/CD configuration.
- `Dockerfile`: Configuration to build the image.
- `multiregistry.json`: registry configuration and credentials to upload the image.
- `deployment.yaml`: file to define the CD deploy procsess.
- `VERSION`: Version configuration file.

#### Properties

=== "Default"

    ```properties
      # Sonar parameters
      SONAR_ID="SONAR_GLUON_COMMUNITY"
      SONAR_PROJECT_KEY=""

      # Fortify parameters
      FORTIFY_PROJECT=""

      # .NET parameters
      DOTNET_VERSION=""
    ```

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

=== "Properties.env"

    | **Variable**        | **Required** | **Description** | **Example value**               |
    |---------------------|--------------|-----------------|---------------------------------|
    | **SONAR_PROJECT_KEY** | true         | Project key in Sonar | sgt-gluonad-probemicroframework |
    | **FORTIFY_PROJECT** | true         | Project name in Fortify | sgt-gluonad-probemicroframework |
    | **DOCKER_BUILD_ARGUMENTS** | false        | Docker arguments for Docker Build | "" |

=== "SONAR Configuration"

    | Property             | Required   | Description                         | Example |
    |----------------------|------------|-------------------------------------|---------------|
    | SONAR_ID             | false      | The name of the Sonar instance to be used. This value is unique and its value will be 'SONAR_GLUON_COMMUNITY'   | 'SONAR_GLUON_COMMUNITY' |
    | SONAR_PROJECT_KEY    | true       | Project key that's created in the sonar instance | "ccc:ccc:test-project:mvn-immutable-test" |
    | SONAR_REPORT_PATH    | false      | Location where the scanner writes the report-task.txt  | 'target/site' |
    | SONAR_MEMORY_PROPERTIES | false   | Memory properties                   | '-Xmx256m' |
    | ELASTICSEARCH_API_URL | true      | Elasticsearch api url with protocol | `https://[url]` |
    | ELASTICSEARCH_ALIAS   | true      | Elastic Search index                | 'index-x' |
    | ELASTICSEARCH_TYPE    | true      | Elasticsearch type                  | '_doc' |
    | QG_ENABLED    | false      | Enables or disables Sonar, Fortify, and Sonatype scans in CI, with 'high' for blocking, 'none' for non-blocking, and empty to skip scans.                  | 'high' |

=== "DOTNET Configuration"

    | Property             | Required   | Description                         | Example |
    |----------------------|------------|-------------------------------------|---------------|
    | **DOTNET_VERSION**   | true       | .NET version to use from [available versions](#supported-versions)                 | 9.0           |
    | **PROJECT_PATH**   | false      | Project's path (if is not set, it will look for a .sln file in the repository root)                 | dir1/my-solution.sln    |
    | **DOTNET_BUILD_ARGS**   | false       | Arguments for build command                 | '' |
    | **DOTNET_PUBLISH_ARGS**   | false       | Arguments for building command                 | '' |

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    To avoid possible errors, the **properties.env** file is generated with the necessary values for the variables **SONAR_PROJECT_KEY** and **FORTIFY_PROJECT**.

    Example values:

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"

    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

#### Dockerfile

This file allow us to build the image with the microservice in the *Build* stage of the CI/CD pipeline.

The artifact will be generated in the `ARTIFACT` directory, so the Dockerfile must copy the content of this directory to the desired location in the image.

One example for Dockerfile is:

```dockerfile title="Dockerfile Proposal" linenums="1"
FROM ...

# Copy the .NET published artifact located in ARTIFACT directory into the root of the repository in the desired location
COPY ./ARTIFACT/ ./your/application/path/

# Add your Dockerfile instructions below
```

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

#### VERSION File

The `VERSION` file is a simple text file that contains the version of the project. This file is used to track the current version of the project in a straightforward manner.

**Example of a `VERSION` file:**

```txt
1.0.0
```

**Customizing the `VERSION` file:**
Users using this template may need to update the version string to match their project's specifics. The version string should follow semantic versioning conventions, such as `MAJOR.MINOR.PATCH` (e.g., `1.0.0`).

If users already have a `VERSION` file, they can update the version string as needed to reflect the current state of their project.

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
