## Apis Pull Request

This workflow is executed when is called for another workflow.

### Requirements

* Inputs: runner, deploy-version, deployment-yaml-name, config-version, deploy-type,
deployment-environment, api-product-name, api-product-version, api-spec-file-name

The Deploy type must have:

* apigee
* apiconnect

The Deploy Environment must have:

* cert
* pre
* cert/pre
* pre/pro
* cert/pre/pro

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

* `Resolve Artifact:`. Build the complete URL based on 'version.txt' file and api
   name to download artifact from Nexus.

* `Deploying Apigee in "deployment-environment":` Deploys the apigee artifact
   to the environment selected by the `deployment-environment` variable.

* `Deploying Apiconnect in  "deployment-environment":` Deploys the
   apiconnect artifact to the environment selected by
   the `deployment-environment` variable.  

* `Send Data to Ilal  "deployment-environment":` This action
   Send the data collected in the workflow to form
   the body of the product creation to ILAL

* `Running tests PRE:` Execution of Functional Test with Gluon Testing framework after
  that the deployment PRE was successful. The test environment where the tests
  are executed is 'PRE'.
  If the github project has an environment named `testing-PRE`
  and **required reviewers** configured is configured, the job
  stops until a user approves it.

  Send data to elasticsearch related to the deployment.

### Environment variables

The workflow have multiples environment variables that it needs to use or reuse
at different steps.

{!
   include-markdown "../project-properties.md"
!}

### Workflow

[Api CD Deployment workflow link](https://github.com/santander-group-shared-assets/gln-workflows/blob/main/.github/workflows/api-cd-deployment.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
