# Devops workflows

## Deployment (maven-rl-image-tb.yml)

This trunk-based workflow is executed when a new pre-release tag is created.

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

* `Setup environment variables:` Loads the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Run quality gate for maven`: Executes the default commands of MAVEN_BUILD_GOAL
   variable. If you want overwrite the maven command you can configure in
  `properties.env`.

  The `Sonar analysis` is executed to validate the quality gates according to
  the defined properties.

{!
   include-markdown "**/ci-cd/technologies/maven/snippets/project-properties.md"
   start="<!--build-sonar-start-->"
   end="<!--build-sonar-end-->"
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
  [The Sonatype SCA workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/develop/.github/workflows/README_sca-sonatype.md)
  to perform a Sonatype SCA scan and analyze third party components
  from a repository.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-properties.md"
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

* `Container build and push:` It takes the feature or development branch as
  image version and sets the environment variable `TAG_VERSION` with
  this value.
  Then execute the command `mvn clean package -Dmaven.test.skip=true` to build
  the application artifact.
  To continue, it builds the container image based on `Dockerfile` located in the
  project and make a push to one or several harbor registries definided in the
  [`multiregistry.yaml`](https://github.com/santander-group-shared-assets/alm-push-scan-multiregistry#readme)
  file. Note that we send the image to registries with a -RC suffix without
  change the POM file. This is intentional so we can avoid problems renaming
  it while doing the deploy in pre/pro.
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
  definided in the [`multiregistry.yaml`](https://github.com/santander-group-shared-assets/helm-package-push-action#readme)
  file. The chart version is the SNAPSHOT version of the application.

* `Deploying in pre and pro`: Deployment to the environment according to
  `RELEASE_DEPLOYMENT_ENV` by default, property with the possibility
  of multi-region deployment. If we want only deploy in PRE environment
  according to `PRE_DEPLOYMENT`, we  must set the IS_RELEASE with the
  value `false`. The default value of IS_RELEASE is `true`.
  `RELEASE_DEPLOYMENT_ENV` could be pre, pre/pro and should be added this parameter
  in properties.env
  Validate the destiny entity.
  Deploy the application according to the type of deployment indicated by the
  `IMAGE_DEPLOY_TYPE`.

  It updates the tag from pre-release to release. Then generates a new tag without
  the `-RC` suffix and pushes it to the default branch (main/master).

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

[Snapshot workflow link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/development/maven/immutable-images/maven-snapshot-image-tb.yml)

### Getting help

For questions or doubts regarding the workflows, you can open a Service Now
ticket by following the instructions [ALM Support](https://confluence.alm.europe.cloudcenter.corp/display/ALMNEXTGEN/Support?src=contextnavpagetreemode).
