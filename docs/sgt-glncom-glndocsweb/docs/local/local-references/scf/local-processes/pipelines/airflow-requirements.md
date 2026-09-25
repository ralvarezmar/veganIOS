---
title: SCF AirFlow Requirements Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForApacheAirflowRequirements` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about to use these component templates can be found in the following documentations: [(SCF) Airflow Requirements](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/mwaa-requirements/).

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../../support/credentials/data.md).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) Airflow Requirements`.

![Create Component](images/airflow-requirements/create-component.png)

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository migration

When scaffolding is executed, the repository will have this structure in the `development`branch, which must be respected for the workflow to work correctly:

```bash
📦
 ┣ 📂envs
 ┃ ┣ 📜properties.env
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜airflow-requirements-cd.yml
 ┃ ┃ ┣ 📜airflow-requirements-ci.yml
 ┃ ┃ ┣ 📜airflow-requirements-quality.yml
 ┃ ┃ ┣ 📜airflow-requirements-rc.yml
 ┃ ┃ ┣ 📜airflow-requirements-security.yml
 ┃ ┃ ┗ 📜update-component-workflow.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📜requirements.txt
 ┣ 📜deployment.yml
 ┣ 📜VERSION
 ┗ 📜README.md
```

You must take the source code of your component to the source repository in the `development`branch and pay attention to the following adaptations:

### properties.env

In this file, the variable **PYTHON_VERSION** must be set to the version of the python to use.

![Version](images/airflow-requirements/properties.png)

The python version depends on the Apache Airflow version used in the workflow. Example: in case the apache airflow 2.5.1 used, the value of the **PYTHON_VERSION** variable must be set to **3.10.11**.

Available Python versions:

- 3.10.11
- 3.11.5
- 3.9.18

### version.json → VERSION

The version of the `version.json` file located in the root folder is now set in the `VERSION` file, also located in the root folder.

![Version](images/airflow-requirements/version.png)

???+ info "SNAPSHOT Note"

    It is important that in Gluon, the suffix “-SNAPSHOT“ must not be added manually, it will be added automatically during workflow execution.

### Deployment.yaml → deployment.yml

The content of the original `deployment.yaml`file is reduced.

![Deployment](images/airflow-requirements/deployment.png)

### src/requirements.txt → requirements.txt

The content of the original `requirements.txt`file is reduced.

![Requirements](images/airflow-requirements/requirements.png)

### Secrets Configuration

The deployments doesn't require setting any credentials as secrets in your repository as authentication is done using roles.

To enable the deployment, environment variables must be set, in this case, the AWS account id, to do so, go to `Settings > Code and automation > Environments` select the environment (certification, preproduction and production),
and add the following variable, `AWS_ACCOUNT_ID`, at “Environment variables“ section.

![Secrets](images/airflow-requirements/secrets.png)
