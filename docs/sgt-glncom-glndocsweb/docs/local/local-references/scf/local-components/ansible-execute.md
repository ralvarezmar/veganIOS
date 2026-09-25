---
title: (SCF) Ansible Execute
---

This base component template is a comprehensive guide for deploying Ansible playbooks within the Gluon portal.
It streamlines the entire process, providing a clear and efficient pathway from development to deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the Ansible Execute workflow for their playbooks.
This includes guidance on setting up the project, configuring essential files, managing dependencies, and deploying the playbooks.

Whether you are starting from scratch or integrating Ansible Execute into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development process.

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

The generated repository has a structure similar to the following:

``` bash
📦
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜cd.yml
 ┃ ┃ ┣ 📜ci.yml
 ┃ ┃ ┣ 📜release.yml
 ┃ ┃ ┣ 📜update-component-workflow.yml
 ┃ ┃ ┗ 📜version-validation.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon
 ┃ ┣ 📂ci
 ┃ ┗ ┗ 📜properties.env
 ┣ 📂inventories
 ┃ ┣ 📂cert
 ┃ ┃ ┗ 📜hosts
 ┃ ┣ 📂pre
 ┃ ┃ ┗ 📜hosts
 ┃ ┣ 📂pro
 ┃ ┗ ┗ 📜hosts
 ┣ 📜ansible_setup.yml
 ┗ 📜VERSION
```

## Component Configuration

This section provides an overview of the necessary configurations for integrating the Gluon component into your project. It covers the required branches and essential configuration files to ensure smooth CI/CD processes.

### Configuration Files

This base component template works with some configuration files that may need some modifications:

- `properties.env`: Properties with the CI/CD configuration.
- `VERSION`: Version configuration file.
- `ansible_setup.yml`: Setup configuration file for Ansible.

#### Properties

=== "Default"

    ```properties
      # Ansible parameters

      PLAYBOOK_FILENAME=""
      PLAYBOOK_HAS_VAULT="false"
    ```

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

=== "Properties.env"

    | **Variable**        | **Required** | **Description** | **Example value**               |
    |---------------------|--------------|-----------------|---------------------------------|
    | **PLAYBOOK_FILENAME** | true         | Name of the Playbook to execute | '' |
    | **PLAYBOOK_HAS_VAULT** | true         | True if the playbook contains Vault | false|

#### VERSION File

The `VERSION` file is a simple text file that contains the version of the project. This file is used to track the current version of the project in a straightforward manner.

**Example of a `VERSION` file:**

```txt
1.0.0
```

**Customizing the `VERSION` file:**
Users using this template may need to update the version string to match their project's specifics. The version string should follow semantic versioning conventions, such as `MAJOR.MINOR.PATCH` (e.g., `1.0.0`).

If users already have a `VERSION` file, they can update the version string as needed to reflect the current state of their project.

#### Ansible Setup File

The `ansible_setup.yml` file is the setup configuration file for Ansible. It is recommended to place the playbook at the root of the repository. Additionally, it must be referenced in the `.gluon/ci/properties.env` file.

**Example of an `ansible_setup.yml` file:**

```yaml
# It is recommended to place the playbook at the root of the repository.
# Additionally, it must be referenced in the .gluon/ci/properties.env file.
# Example: PLAYBOOK_FILENAME="ansible_setup.yml"

# If the playbook is located in a different directory, ensure that its path is correctly defined in the .gluon/ci/properties.env file.
# Example: PLAYBOOK_FILENAME="dir1/dir2/ansible_setup.yml"
```

If the playbook is located in a different directory, ensure that its path is correctly defined in the .gluon/ci/properties.env file. Example:

```bash
PLAYBOOK_FILENAME="dir1/dir2/ansible_setup.yml"
```

### Secrets Configuration

**Vault password → GitHub Actions secret:**

In case you have Vault, in addition to setting PLAYBOOK_HAS_VAULT to “true” in the properties.env, it will be necessary to add the content of the password-file as a secret in GitHub Actions.

To do this, go to Settings > Security > Secrets and variables > Actions and add the secret ANSIBLE_VAULT_PASSWD at the “Repository secrets” level.

In case you need different passwords for the environments, you must create them in "Environment secrets" in the environments created when the component was created (certification, preproduction, and production).
To do this, go to Settings > Environments and in Environment secrets → Add environment secret.

## Application Lifecycle Management: How to build and deploy

{!
   include-markdown "./snippets/ansible-git-flow-lifecycle.md"
   start="<!--Start Flow-->"
   end="<!--End Flow-->"
!}

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
