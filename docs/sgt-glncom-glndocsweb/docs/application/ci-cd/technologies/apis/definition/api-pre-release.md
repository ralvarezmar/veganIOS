## API Pre-release definition (api-pre-release-definition.yml)

This workflow is executed when the following branches are pushed:

* main
* master
* hotfix/*

### Requirements

* Inputs: runner

The GitHub runner must have:

* Tools: yq and curl.
* Connectivity to the different tools

### Secrets

* app-id: ${{ secrets.APPLICATION_ID }}
* private-key: ${{ secrets.APPLICATION_PRIVATE_KEY }}
* elastic-token: ${{ secrets.ELASTICSEARCH_API_KEY_PRO }}

### Jobs

All the jobs described clones the project repository when starts the execution
and reads the properties from `configuration project`, the repository itself
and resources necessaries to the proper workflow execution.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Create release & tag:` Creates a new draft release and select
  the check `Set as a pre-release` with the version. Also create the tag
  with the version.

* `Publish version to marketplace:`It publishes a new version in
   marketplace. The job consists of two previous jobs, "setup-env-vars"
   and "create-release-tag", which are defined as dependencies with the
   needs keyword. The curl command is used to send a PATCH request to the API
   of the marketplace to publish the new version. The endpoint, version, asset,
   and actor are passed as environment variables.
  `Send information to Elasticsearch:` Send data to elasticsearch related with
  SAST analysis.

**NOTE:**

* See [here](../project-properties.md){:target="_blank"}
  to set the necessary project properties.
* See [here](../project-secrets.md){:target="_blank"} to
  set the necessary project secrets.
* See [here](../../../organization-properties.md){:target="_blank"}
  to set the necessary organization properties.
* See [here](../../../organization-secrets.md){:target="_blank"} to
  set the necessary organization secrets.

### Workflow

[APIS pre-release definition link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/main/apis/api-pre-release-definition.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
