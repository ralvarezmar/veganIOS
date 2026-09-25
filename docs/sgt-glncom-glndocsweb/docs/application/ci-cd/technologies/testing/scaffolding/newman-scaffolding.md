# Newman scaffolding workflow

## Integration (newman-scaffolding.yml)

This workflow is executed when a new repository is created from a template
repository that contains a call to this workflow.

### Requirements

{!
   include-markdown "**/ci-cd/technologies/snippets/requirements.md"
   start="<!--maven-scaff-start-->"
   end="<!--maven-scaff-end-->"
!}

**NOTE:**

* See [here](../../../organization-secrets.md){:target="_blank"} to
  set the necessary organization secrets.

### Workflow

[Newman scaffolding workflow link](https://github.com/santander-group-shared-assets/gln-testing-newman-template/blob/init-branch/.github/workflows/newman-scaffolding.yml)

### How to use newman-scaffolding-template

#### Create Repository

Create a repository you must select in the field `Repository template`
the template `santander-group-shared-assets/gln-testing-newman-template`.

#### Repository Description

A branch `init-branch` is created in the repository with the following content:

  1. The file `.github/CODEOWNERS`
  2. The rest of the files and directories are created using the archetype
  from the repository `santander-group-shared-assets/gln-testing-newman-template`.

An pull request is created in the repository from the branch `init-branch`
to `main` branch.
