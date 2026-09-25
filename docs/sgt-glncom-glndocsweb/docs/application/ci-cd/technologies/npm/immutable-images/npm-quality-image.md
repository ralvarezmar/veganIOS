# Devops workflows

## Quality gate (npm-quality-image.yml)

This workflow is executed when a pull request is created to merge
a change to these target branches:

* development
* develop
* master
* main

### Requirements

{!
   include-markdown "**/ci-cd/technologies/snippets/requirements.md"
   start="<!--npm-start-->"
   end="<!--npm-end-->"
!}

### Jobs

All the jobs described clones the project repository when starts the execution
and reads the properties from `Setup environment variables` job output, the
repository itself and resources necessaries to the proper workflow execution.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Npm build & SonarQube:` Executes the default commands `npm install` and
  `npm run build`. The audit and test steps are disabled if the
  NPM_RUN_AUDIT_COMMAND and NPM_RUN_TEST_COMMAND properties aren't configured.
  Therefore, if you want overwrite the npm commands you can configure in
  `properties.env`.

{!
   include-markdown "**/ci-cd/technologies/npm/project-properties.md"
   start="<!--build-start-->"
   end="<!--build-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/npm/project-properties.md"
   start="<!--sonarnpm-start-->"
   end="<!--sonarnpm-end-->"
!}

### Workflow

[Quality workflow link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/main/npm/immutable-images/npm-quality-image.yml)
