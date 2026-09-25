## API Snapshot (Pre-Release) deployment (api-release-deployment.yml)

This workflow is executed when manual or push in 'main' or 'hotfix' branches ->
on:
  workflow_dispatch:
  push:
    branches:
      - main
      - hotfix/*

### Requirements

* Inputs: runner

The GitHub runner must have:

* Tools: ansible,yq, jq and curl.
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

* `Apigee artifact upload/Apiconnect artifact upload:` These jobs are executed
  depending on the manager platform where we want to deploy the API, orchestrated
  by the environment variable API_PLATFORM. The main functionalities are: Get the
  specification file from the definition repository, generate the artifact and
  upload it to the nexus repository.

* `Calling cd workflow` This job calls the CD workflow in order
  to perform the deployment indicated by the SNAPSHOT_DEPLOYMENT
  environment variable. More details [here](./api-cd-deployment.md)

* `Prepare tag and draft release` This job creates tag with the version
  contained in version.txt, and then associates a Draft Release to
  created tag.

### Environment variables

The workflow have multiples environment variables that it needs to use or reuse
at different steps.

{!
   include-markdown "../project-properties.md"
!}

### Workflow

[Apis snapshot deployment workflow link](https://github.com/santander-group-shared-assets/gln-workflows/blob/main/.github/workflows/api-snapshot-deployment.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode)
