# How Integrate a New Component Template with Gluon Release Management

## Introduction

The purpose of this documentation is to provide a brief guide on how to integrate a new component template with Gluon Release Management.

Release Management is a Gluon portal integration process that aims to automate the creation of releases and tasks in Servicenow ITSM,
as well as the orchestration of deployment in Github through the portal itself.

To deploy a new component in production using Gluon's Release Management service, it is necessary for this component to be aligned with
Gluon's CICD Framework.

## What´s means to be aligned with the Gluon Release Management and CICD Framework?

CICD Framework is a set of rules and best practices that must be followed by all components that are deployed in Gluon.

To be compliance with the Gluon Release Management and CICD Framework is necessary that:

All components must have a CI and CD process that is aligned with the OAM file.

    ```bash
    📦component-repository
    ┣ 📂.github
    ┃ ┗ 📂workflows
    ┃ ┃ ┗ 📜<workflows>.yml
    ┗ 📂.gluon
    ┃ ┗ 📂ci
    ┃ ┃ ┗ 📜properties.env
    ┃ ┗ 📂cd
    ┃ ┃ ┗ 📂aws-certification
    ┃ ┃ ┃ ┣ 📜cd.yml
    ┃ ┃ ┃ ┗ 📜<config-files>.yml
    ┣ 📂src
    ```

## GitHub Workflows

- Exist as workflow deployment called `cd.yaml` in the GitHub repository associated with the component.
- The cd workflow must be listening to the `workflow_dispatch` event.
- The workflow must be parametrized with the follow values:

For example:

```yaml
  on:
    workflow_dispatch:
  inputs:
    release-version:
      description: 'Release version to deploy'
      required: true
      type: string
    release-number:
      description: 'ITSM Release number to deploy'
      required: true
      type: string
    environment:
      description: 'Environment to deploy to'
      required: true
      type: string
    environment-type:
      description: 'Environment type to deploy to'
      required: true
      type: choice
      options:
        - certification
        - preproduction
        - production
```

## CI and CD files

Inside the .gluon/ folder, there are two folders ci and cd with the required configurations and parametrization to execute the CI and CD workflows for that component

These configurations have been generated with the following premises:

- A component can have multiple deployment targets (for example, a microservice can be deployed in a Kubernetes cluster, a lambda, or/and a virtual machine).
- Depending on the deployment, it may be necessary to generate different types of artifacts (for example, a java microservice can generate a JAR or a Docker image).
- The artifacts can be stored in different repositories (for example, a microservice deployed in different regions can store the artifacts in repositories that are close to the deployment nodes).

Artifact Stores

Take a look to the Artifact Stores documentation.

### CD file

#### Infrastructure

The .gluon/cd/`<environment>`/cd.yml file contains the infrastructure configuration by environment.
Where the environment is the target environment name where the component will be deployed.

There will be a folder for each environment where the component will be deployed.

```yaml
- ci_id: pre_deploy
  configuration_files:
    - .gluon/cd/values.yaml
    - .gluon/cd/aws-preproduction/values-pre-eks.yaml
```

- `ci_id`: Unique identifier of the infrastructure defined in oam-application-definition.yaml file
- `configurationFiles`: List of configuration files used for the deployment.

#### CD configuration files

CD configuration files are files with the parametrization of the deployment for a infrastructure type. Depending on the technology and nature
of the component, as well as the infrastructure, this file can change. An example could be a values.yaml file for a deployment in Kubernetes
using Helm or an apigee KVM file.

## Relations Pages

- For more information, visit the [CI CD documentation](./../ci-cd/cd/cd-rm/index.md)
