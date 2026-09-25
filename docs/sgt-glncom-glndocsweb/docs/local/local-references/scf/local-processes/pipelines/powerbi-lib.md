---
title: SCF PowerBI Library Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForPowerBILib` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about to use these component templates can be found in the following documentations: [(SCF) PowerBI Library](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/powerbi-lib/).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) PowerBI Library`.

![Create Component](images/powerbi/create-component.png)

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

You must take the source code of your component to the source repository in the `development` branch and pay attention to the following adaptations:

```bash
📦
 ┣ 📂envs
 ┃ ┣ 📜properties.env
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜powerbi-ci.yml
 ┃ ┃ ┣ 📜powerbi-quality.yml
 ┃ ┃ ┣ 📜powerbi-release.yml
 ┃ ┃ ┗ 📜powerbi-security.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂reports
 ┃ ┣ 📜.gitkeep
 ┃ ┗ 📜your_report.pbix
 ┣ 📂assembly
 ┃ ┗ 📜assembly_full.xml
 ┣ 📜deployment.json
 ┣ 📜pom.xml
 ┗ 📜README.md
```

### ci-config.groovy → properties.env

Information from the file `ci-config.groovy` located at the root of the repository is transferred to the configuration file `properties.env` located in the `.gluon/ci/` folder.

![Properties](images/generic/ci-config.png)

Note that this is not a 1:1 migration and that there are new fields. Below is an example of `properties.env`:

- The fields `FORTIFY_PROJECT` and `SONAR_PROJECT_KEY` are automatically filled during the scaffolding process.

```yaml
# Sonar parameters
SONAR_ID="SONAR_GLUON_COMMUNITY"
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

ZERO_TOUCH_ENABLE=true

# Quality parameters
QG_ENABLED="High"
```

### pom.xml → pom.xml

There are some changes in the `pom.xml`file, the **properties** block must be deleted.

![Properties](images/powerbi/pom.png)

???+ info "note

    It is important that in Gluon, the suffix “-SNAPSHOT“ must not be added manually, it will be added automatically during workflow execution.

### assembly_full.xml → assembly_full.xml

The content of the `assembly_full.xml`file is almost the same, the block fies must be deleted.

![Assembly](images/powerbi/assembly.png)
