## Apis Pull Request

This workflow is executed when is create or modified a pull request.

### Requirements

* Inputs: runner

The GitHub runner must have:

* Connectivity to the different tools

### Secrets

{!
   include-markdown "../project-secrets.md"
!}

#### Jobs

This workflow creates the following jobs:

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).
  
* `Get Definition File:` Load `Definition File` from a specific
  organization, repository and branch.

* `API Validation:` Check if the asset-id and
  asset-version obtained in `Get Definition File` are valid
  calling `API Marketplace`.

* `Linter validation:` This action uses Spectral from Stoplight to lint \
  your OpenAPI documents, or any other JSON/YAML files. The file that\
  analyzes is the declared in the `APIPROXY_YAMLFILE` environment\
  variable.

* `Send data to Elastic` This action sends the response os publish-version and
  the repository and environment data to elasticsearch.

### Environment variables

The workflow have multiples environment variables that it needs to use or reuse
at different steps.

{!
   include-markdown "../project-properties.md"
!}

### Workflow

[Apis quality deployment workflow link](https://github.com/santander-group-shared-assets/gln-workflows/blob/main/.github/workflows/api-quality-deployment.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
