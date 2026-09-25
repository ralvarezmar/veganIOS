## Apis Pull Request

This workflow is executed when is create or modified a pull request.

### Requirements

* Inputs: runner

The GitHub runner must have:

* Connectivity to the different tools

### Secrets

* app-id: ${{ secrets.APPLICATION_ID }}
* private-key: ${{ secrets.APPLICATION_PRIVATE_KEY }}

#### Jobs

This workflow creates the following jobs:

### Pull Request event

It executes a complete workflow with 'Setup environment variables',
'Dictionary validation' and 'OpenAPI check' jobs.

It executes a complete workflow when a pull request is created or modified.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Setup api-baas variable:` Load `api-baas` key from catalog.yml.

* `Dictionary validation:` This action check the words dictionary.
  If the value of the `api-baas` key is `true`, this job will be executed.

* `OpenAPI check:` This action uses Spectral from Stoplight to lint \
  your OpenAPI documents, or any other JSON/YAML files. The file that\
  analyzes is the declared in the `APIPROXY_YAMLFILE` environment\
  variable.

**NOTE:**

* See [here](./../../maven/project-secrets.md){:target="_blank"} to set
  the necessary secrets.

### Environment variables

The workflow have multiples environment variables that it needs to use or reuse
at different steps. These environment variables are: TECHNOLOGY,
REPO, REPO_BRANCH, ENV_PROFILE, WORKFLOWS_TOKEN,
APIS_SPECTRAL_RULES_REPOSITORY, APIS_SPECTRAL_RULES_FILE_PATH,
APIS_SPECTRAL_RULES_REF.

<!--
See [here](./../../maven/snippets/project-properties.md){:target="_blank"} for
more information.
-->

### Workflow

[Apis quality definition workflow link](https://github.com/santander-group-shared-assets/gln-workflows/blob/main/.github/workflows/api-quality-definition.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
