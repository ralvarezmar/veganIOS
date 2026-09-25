# Configmap scaffolding workflow

## Integration (configmap-scaffolding.yml)

This workflow is executed when a new repository is created from a template
repository that contains a call to this workflow.

### Requirements

The GitHub runner must have:

* Maven with required version for the archetype `action-configmaps-archetype`.
* JDK with required version for the archetype `action-configmaps-archetype`.
* Tools: gh
* Connectivity to nexus
* Github App installed in the destination
  organization with read access to metadata; read and write access to actions,
  administration, code, repository projects, workflows and pull request
  permissions.

**NOTE:**

* See [here](../../../organization-secrets.md){:target="_blank"} to
  set the necessary organization secrets.

### Workflow

[Configmap pro scaffolding workflow link](https://github.com/santander-group-shared-assets/gln-configmap-template-pro/blob/init-branch/.github/workflows/configmap-scaffolding.yml)

[Configmap pre scaffolding workflow link](https://github.com/santander-group-shared-assets/gln-configmap-template-pre/blob/init-branch/.github/workflows/configmap-scaffolding.yml)

[Configmap cert scaffolding workflow link](https://github.com/santander-group-shared-assets/gln-configmap-template-cert/blob/init-branch/.github/workflows/configmap-scaffolding.yml)

### How to use gln-configmap-template-env (env=`pro`, `pre` or `cert`)

#### Create Repository

Create a repository you must select in the field `Repository template`
the template `santander-group-shared-assets/gln-configmap-template-env`.
The templates can then be used:
    1. `santander-group-shared-assets/gln-configmap-template-pro`
    2. `santander-group-shared-assets/gln-configmap-template-pre`
    3. `santander-group-shared-assets/gln-configmap-template-cert`

The template you should use depends on the environment where you run it.

#### Repository Description

A branch `init-branch` is created in the repository with the following content:

  1. The file `.github/CODEOWNERS`
  2. The file `envs/properties.env`
  3. The workflows in `.github/workflows`:
      * configmap-cd-workflow.yml
  4. The rest of the files and directories are created using the archetype
  from the repository `action-configmaps-archetype`.

An pull request is created in the repository from the branch `init-branch`
to `main` branch.

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
