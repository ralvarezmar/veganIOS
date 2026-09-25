---
title: SCF AWS Quicksight Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForAWSQuickSight` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about to use these component templates can be found in the following documentations: [(SCF) AWS Quicksight](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/aws-quicksight/).

## Prerequisites: AWS Credentials Request

To ensure this pipeline functions correctly, an OIDC configuration with your component repository must be requested.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../../support/credentials/data.md).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) AWS Quicksight`.

![Create Component](images/aws-quicksight/create-component.png)

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository migration

When scaffolding is executed, the repository will have this structure in the `development` branch, which must be respected for the workflow to work correctly:

```bash
📦
 ┣ 📂envs
 ┃ ┣ 📜properties.env
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜aws-quicksight-cd.yml
 ┃ ┃ ┣ 📜aws-quicksight-ci.yml
 ┃ ┃ ┣ 📜aws-quicksight-quality.yml
 ┃ ┃ ┣ 📜aws-quicksight-rc.yml
 ┃ ┃ ┗ 📜aws-quicksight-security.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂src
 ┃ ┣ 📂ANALYSIS
 ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┗ 📜analysis_0.json
 ┃ ┃ ┗ 📜analysis_1.json
 ┃ ┣ 📂DASHBOARD
 ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┗ 📜dashboard_0.json
 ┃ ┃ ┗ 📜dashboard_1.json
 ┃ ┣ 📂DATASET
 ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┗ 📜dataset_0.json
 ┃ ┃ ┗ 📜dataset_1.json
 ┃ ┣ 📂FOLDER
 ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┗ 📜1000000_folder_0.json
 ┃ ┃ ┣ 📜1000000_folder_1.json
 ┃ ┃ ┗ 📜permissions_control.json
 ┃ ┣ 📂FOLDER_MEMBER
 ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┗ 📜dataset_0_10000000.json
 ┃ ┃ ┗ 📜dataset_1_10000000.json
 ┃ ┣ 📂TEMPLATE
 ┃ ┃ ┣ 📂CERT
 ┃ ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┃ ┗ 📜template_0.json
 ┃ ┃ ┃ ┗ 📜template_1.json
 ┃ ┃ ┣ 📂PRE
 ┃ ┃ ┃ ┣ 📂DELETE
 ┃ ┃ ┃ ┃ ┗ 📜template_0.json
 ┃ ┃ ┃ ┗ 📜template_1.json
 ┃ ┃ ┗ 📂PRO
 ┃ ┃   ┣ 📂DELETE
 ┃ ┃   ┃ ┗ 📜template_0.json
 ┃ ┃   ┗ 📜template_1.json
 ┃ ┗ 📂THEME
 ┃   ┣ 📂DELETE
 ┃   ┃ ┗ 📜theme_0.json
 ┃   ┗ 📜theme_1.json
 ┣ 📜deployment.yml
 ┣ 📜VERSION
 ┗ 📜README.md
```

You must take the source code of your component to the source repository in the `development` branch and pay attention to the following adaptations:

### ci-config.groovy → properties.env

Information from the file `ci-config.groovy` located at the root of the repository is transferred to the configuration file `properties.env` located in the `.gluon/ci/` folder.

![Secrets](images/aws-quicksight/ci-config.png)

Note that this is not a 1:1 migration and that there are new fields. Below is an example of `properties.env`:

- The fields `FORTIFY_PROJECT` and `SONAR_PROJECT_KEY` are automatically filled during the scaffolding process.
- The fields `EXECUTE_CHANGES` must be filled using the value of the variable `EXECUTE` from file ci-config.groovy.

![Properties](images/aws-quicksight/properties.png)

### version.json → VERSION

The version of the `version.json` file located in the root folder is now set in the `VERSION` file, also located in the root folder.

![Version](images/aws-quicksight/version.png)

???+ info "SNAPSHOT information"

    It is important that in Gluon, the suffix “-SNAPSHOT“ must not be added manually, it will be added automatically during workflow execution.

### deployment.yml

The content of the `deployment.yaml`file is totally different.

![Deployment](images/aws-quicksight/deployment.png)

Where the value of the variables are set as Jenkins credentials:

- **ADMIN_GROUP_ID**: The admin group id.
- **AUTHOR_GROUP_ID**: The author group id.

### Secrets Configuration

The deployments doesn't require setting any credentials as secrets in your repository as authentication is done using roles.

The workflow requires the following QuickSight permission variables set to work correctly, to do so, go to `Settings > Security > Secrets and variables > Actions` and add the following variables at “Repository variables” level.

As the value of the following variables are fixed, they can be fetched in the
[(SCF) AWS QuickSight repository variables](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/aws-quicksight/#repository-variables-configuration) document.

![Secrets](images/aws-quicksight/secrets.png)

To enable the deployment, environment variables must be set, in this case, the AWS account id, to do so, go to `Settings > Code and automation > Environments`select the environment (certification, preproduction and production),
and add the following variable, `AWS_ACCOUNT_ID`, at “Environment variables“ section.

![Secrets](images/aws-quicksight/secrets-aws.png)

The value of the variables `AWS_SOURCE_ACCOUNT_ID` and `AWS_READER_ACCOUNT_ID` are the values of the Jenkins credential Id set in the original deployment.yaml file.

![Secrets](images/aws-quicksight/secrets-source.png)
