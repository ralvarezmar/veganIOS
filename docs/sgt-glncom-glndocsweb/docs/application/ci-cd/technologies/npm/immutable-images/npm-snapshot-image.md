# Devops workflows

## Integration (npm-snapshot-image.yml)

This workflow is executed when the following branches are pushed:

* develop
* development
* feature/*
* fix/*

### Requirements

{!
   include-markdown "**/ci-cd/technologies/snippets/requirements.md"
   start="<!--npm-start-->"
   end="<!--npm-end-->"
!}

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

  Send data to elasticsearch related to the build.

  The `Sonar analysis` is executed to validate the quality gates according to
  the defined properties.

{!
   include-markdown "**/ci-cd/technologies/npm/project-properties.md"
   start="<!--sonarnpm-start-->"
   end="<!--sonarnpm-end-->"
!}

  Send data to elasticsearch related with Sonar analysis.

* `SAST` Executes the reusable [Fortify SAST workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/main/.github/workflows/README_sast-fortify.md)
  to perform a SAST scan with Fortify and validate the quality gates.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--fortify-start-->"
   end="<!--fortify-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--fortify-start-->"
   end="<!--fortify-end-->"
!}

* `SCA:` Executes the reusable
  [The OWASP Sonatype SCA workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/main/.github/workflows/README_sca-depcheck.md)
  to perform a Sonatype SCA scan and analyze third party components
  from a repository.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonatype-start-->"
   end="<!--sonatype-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--sonatype-start-->"
   end="<!--sonatype-end-->"
!}

* `Send information to Elasticsearch:` Send data to elasticsearch
  related with SAST and SCA analysis.

* `Container build and push:` It takes the feature or integration branch as
  image version and sets the environment variable `TAG_VERSION` with
  'development'.
  
  Afterthat, it generates the application and the distribution
  of the configuration. See properties.

{!
   include-markdown "**/ci-cd/technologies/npm/project-properties.md"
   start="<!--application-start-->"
   end="<!--application-end-->"
!}
  
  During this step, the environment variables `ARTIFACT_PATH` and `CONFIG_PATH`
  are generated which store the path and name of the generated zip file of the
  application and configuration. These variables can be used in the
  `CONTAINER_BUILD_ARGUMENTS` (`DOCKER_BUILD_ARGUMENTS` is deprecated) property
  to build the image, depending on the container tool used.

  To continue, it builds the container image based on `Dockerfile` located in the
  project and make a push to one or several harbor registries definided in the
  [`multiregistry.yaml`](https://github.com/santander-group-shared-assets/gln-alm-push-scan-multiregistry#readme)
  file.

  Finally, scan the image vulnerabilities in Harbor and send the data related
  to the image build to elasticsearch.

  Send data to elasticsearch related to the image.

  If `IMAGE_DEPLOY_TYPE` property is `helm` then execute the command to package
  the Helm chart according to the defined properties.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--helm-start-->"
   end="<!--helm-end-->"
!}

  Afterthat, the Helm package is pushed to one or several harbor registries
  definided in the [`multiregistry.yaml`](https://github.com/santander-group-shared-assets/gln-helm-package-push-action#readme)
  file. The chart version is the SNAPSHOT version of the application.

* `Deploying a development:` Deployment to the environment according to
 `CERT_DEPLOYMENT` by default, property with possibility of multi-region deployment.
 Could be cert, pre, cert/pre and should be added this parameter in properties.env
 Validate the destiny entity.
  Deploy the application according to the type of deployment indicated by the
  `IMAGE_DEPLOY_TYPE`.

  Send data to elasticsearch related to the deployment.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--deployment-start-->"
   end="<!--deployment-end-->"
!}

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

[Snapshot workflow link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/main/npm/immutable-images/npm-snapshot-image.yml)
