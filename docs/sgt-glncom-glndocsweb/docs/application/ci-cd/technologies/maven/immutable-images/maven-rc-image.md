# Devops workflows

## Release Candidate (maven-rc-image.yml)

This workflow is executed when the following branches are pushed:

* main
* master

### Requirements

{!
   include-markdown "**/ci-cd/technologies/snippets/requirements.md"
   start="<!--maven-start-->"
   end="<!--maven-end-->"
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

* `Preparing release candidate:` Update version pom in the branch (main or
master). Get next RC version. Get last commit in the branch.

* `Maven build & Sonar scan:` Executes the default commands of MAVEN_BUILD_GOAL variable.
  If you want overwrite the maven command you can configure in
  `properties.env`.

  The `Sonar analysis` is executed to validate the quality gates according to
  the defined properties.

{!
   include-markdown "**/ci-cd/technologies/maven/snippets/project-properties.md"
   start="<!--build-sonar-start-->"
   end="<!--build-sonar-end-->"
!}  

  Send data to elasticsearch related with Sonar analysis.

* `Create release candidate tag:` Creates a new tag for RC.

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
  [The Sonatype SCA workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/develop/.github/workflows/README_sca-sonatype.md)
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

* `Send information to Elasticsearch:` Send data to elasticsearch related with
  SAST and SCA analysis.

* `Container build and push:` It takes the version from pom.xml job as
  image version and sets the environment variable `TAG_VERSION` with
  this value.

  Afterthat, it generates the application and the distribution
  of the configuration. See properties [here](./../project-properties.md#common-properties){:target="_blank"}.
  To continue, it builds the container image based on `Dockerfile` located in the
  project and make a push to one or several harbor registries definided
  in the [`multiregistry.yaml`](https://github.com/santander-group-shared-assets/gln-alm-push-scan-multiregistry-action#readme)
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
  file. The chart version is `TAG_VERSION`.

* `Create draft release:` Creates a new draft release and select
  the check `Set as a pre-release` tag for RC. Output with ::notice::
  of draft release number id.

* `Deploying:` Deployment to the environment according to
  `RELEASE_DEPLOYMENT_ENV` by default, property with the possibility
  of multi-region deployment. If we want only deploy in PRE environment
  according to `PRE_DEPLOYMENT`, we  must set the IS_RELEASE with the
  value `false`. The default value of IS_RELEASE is `true`.
  Could be pre, pre/pro and should be added this parameter in properties.env
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

[Release Candidate workflow link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/main/maven/immutable-images/maven-rc-image.yml)
