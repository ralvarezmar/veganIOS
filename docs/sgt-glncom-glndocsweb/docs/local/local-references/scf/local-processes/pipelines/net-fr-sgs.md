---
title: SCF .NET Framework SGS Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForNETFRAMEWORKLSGS` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about yo use this component template can be found in [documentation](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/net-frameowrk-sgs/).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) .NET Framework SGS`.

![Create Component](images/net/fr-sgs-create.png)

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

The component is compatible with the following versions:

- .NET Framework 4
- .NET Framework 4.5
- .NET Framework 4.5.1
- .NET Framework 4.5.2
- .NET Framework 4.6
- .NET Framework 4.6.1
- .NET Framework 4.6.2
- .NET Framework 4.7
- .NET Framework 4.7.1
- .NET Framework 4.7.2
- .NET Framework 4.8

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository migration

When scaffolding is executed, the repository will have this structure in the `development`branch, which must be respected for the workflow to work correctly:

```bash
📂.github
 ┣ 📂workflows
 | ┣ 📜release.yml
 | ┣ 📜ci.yml
 | ┣ 📜security.yml
 | ┣ 📜quality.yml
 | ┣ 📜update-component-workflow.yml
 | ┗ 📜version-validation.yml
 ┗ 📜CODEOWNERS
📂.gluon
 ┣ 📂ci
 | ┗ 📜properties.env
📂config_sgs
 ┣ 📜sgs.conf
📜VERSION
```

You must take the source code of your component to the source repository  in the `development`branch and pay attention to the following adaptations:

### ci-config.groovy → properties.env

Information from the file `ci-config.groovy` located at the root of the repository is transferred to the configuration file `properties.env` located in the `.gluon/ci/` folder.

![Properties](images/generic/ci-config.png)

In this caso there are nothing to copy from ci-config,The key `APP_NAME` in the `ci-config.groovy` file (in which it was necessary to write the name of the .sln at the root of the repository) is deprecated.

- There is a new feature that is `PROJECT_PATH` key, which by default will take the `.sln` file from the root of the repository, but you can specify any path to the `.sln` file .
- The configuration parameters for the publication by SGS remain the same, except for PACKAGE_FORMAT and PACKAGE_PLATFORM which are no longer necessary.
- The fields `FORTIFY_PROJECT` and `SONAR_PROJECT_KEY` are automatically filled during the scaffolding process.

```yaml
# Sonar parameters
SONAR_ID="SONAR_GLUON_COMMUNITY"
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

# .NET Framework parameters
PROJECT_PATH=""

# SGS parameters
PACKAGE_PRODUCT=""
PACKAGE_VERSION=""
PACKAGE_CLIENTS=""
```

### version.json → VERSION

The version of the `version.json` file located in the repository root is passed to the `VERSION` configuration file also in the repository root.

![Version](images/generic/version-json.png)

???+ info "Note"

    It is important to note that “-SNAPSHOT” should not be added in Gluon, it is automatically added when the CI is launched in the development branch.
