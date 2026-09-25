## API Release definition (api-release-definition.yml)

This workflow is executed when release is published ->
on: release: types: published

### Requirements

* Inputs: runner

The GitHub runner must have:

* Tools: yq, jq and curl.
* Connectivity to the different tools

### Secrets

* elastic-token: ${{ secrets.ELASTICSEARCH_API_KEY_PRO }}

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

* `Get the API version:` This action get the version field, defined as
  info.version, from the yaml file, this yaml name must to be defined in
  the properties.env.
  
  Example: APIPROXY_YAMLFILE=Operation_Limits_v2_dev_2.0.2_OK_SPECTRAL.yaml

* `Publish version to marketplace` This action use a couple of curls commands
   one of them, the first, receive an ID to pass it in the second one.
   With this ID from the first, set a version in the second one.
  `Send data to Elastic` This action sends the response os publish-version and
   the repository and environment data to elasticsearch.

<!--

**NOTE:**

* See [here](./../../maven/project-secrets.md){:target="_blank"}
-->

### Environment variables

The workflow have multiples environment variables that it needs to use or reuse
at different steps. These environment variables are: TECHNOLOGY, REPO,
REPO_BRANCH, MARKETPLACE_ENDPOINT, MARKETPLACE_BIAN_ENDPOINT, MARKETPLACE_VERSION, MARKETPLACE_ASSET,
MARKETPLACE_STAGE and MARKETPLACE_ACTOR.
<!--
See [here](./../../maven/environment-variables.md){:target="_blank"} for
more information.
-->

### Workflow

[Apis release definition workflow link](https://github.com/santander-group-shared-assets/gln-workflows/blob/main/.github/workflows/api-release-definition.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
