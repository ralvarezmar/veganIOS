## CD (npm-cd-image.yml)

This workflow is executed manually.

### Requirements

The GitHub runner must have:

* Helm installed and configured by default in the system variables.
* Tools: asdf, jq, yq, curl, unzip
* Connectivity to the different tools

### Inputs

This workflow has several input parameters to indicate the version
to deploy if it is different from the one configured in the pom.xml.

| Input                  | Required  | Description                            | Default |
|------------------------|-----------|----------------------------------------|---------|
| `runner`               | **true**  | Required runner to use on workflow run | ''      |
| `deploy-version`       | **false** |Image version to deploy. By default the version of the pom.xml is obtained. | Version from the pom.xml |
| `deployment-yaml-name` | **false** | Name of yaml file that includes the deployment configuration for one or more environments. | `deployment.yaml` |
| `config-version`       | **false** | Version of properties and deployment.yaml file to use in the deployment. | Repository branch |
| `deploy-environment`   | **true**  | Deploy environment chosen by user in workflow dispatch | '' |
| `deploy-type`          | **false** | Deployment type. See the types supported by the action `https://github.com/santander-group-shared-assets/gln-alm-deployment-manager-action` | 'ose3' |
| `draft-id`             | **false** | Draft identity to create release from release candidate and deployment-environment "pre/pro", "cert/pre/pro" | '' |
| `branch-strategy`      | **false** | Branch strategy to use, could be: gitflow, trunk-based | 'gitflow' |
| `itsm-task`            | **false** | ITSM task to validate in deploy | '' |

### Properties file

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--deployment-start-->"
   end="<!--deployment-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--zero-touch-start-->"
   end="<!--zero-touch-end-->"
!}

### Jobs

All the jobs described (except `Show inputs`) clones the project repository
when starts the execution and reads the properties from
`configuration project`, the repository itself and resources necessaries to
the proper workflow execution.

* `Show inputs:` It displays in the log and creates an annotation with the
values of the input parameters entered by the user.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).
  
* `Resolve version:` It takes the `deploy-version` input parameter or the
`version` from pom.xml as version to deploy.

* `Deployment regions matrix:` This job generates a json matrix with one or
  more regions of the environment according to `CERT_DEPLOYMENT`,
  `PRE_DEPLOYMENT` and `PRO_DEPLOYMENT` properties and from deployment file.
  Then set this json as output for the next job that used the matrix to do
  multiple deployments base on the number of regions.

  See the `Deployment file` section of the Readme.md of each deployment action
  that is supported by [`alm-deployment-manager-action`](https://github.com/santander-group-shared-assets/gln-alm-deployment-manager-action#readme)
  for the format of the deployment file.

* `Getting deploy environment:` This job generates an output 'version-pro'
   which means if pom version match with release, RC or SNAPSHOT. With this
   next deploy job will deploy if rules of different environments match with it.

* `Deploy cert in n regions:` Deployment to the environment according to
 `CERT_DEPLOYMENT` property with possibility of multi-region deployment.
 Validate the destiny entity.
  Deploy the application according to the type of deployment indicated by the
  `IMAGE_DEPLOY_TYPE`.
  If the github project has an environment named `certification`
  and **required reviewers** configured is configured, the job
  stops until a user approves it.  

  Send data to elasticsearch related to the deployment.

* `Deploy pre in n regions:` Deployment to the environment according to
 `PRE_DEPLOYMENT` property with possibility of multi-region deployment.
 Validate the destiny entity.
  Deploy the application according to the type of deployment indicated by the
  `IMAGE_DEPLOY_TYPE`.
  If the github project has an environment named `preproduction`
  and **required reviewers** configured is configured, the job
  stops until a user approves it.

  Send data to elasticsearch related to the deployment.

* `Generate tag and release:` Creates a new tag for RL and create a new release
  version from draft release generated in npm-release-image workflow. It takes
  draft-it input from npm-release-image workflow to create the new release
  from draft release.

* `Retag Container Image`:Retag the version of the image associated with the
  Release Candidate to the new version of the Release.
  Associates the latest version to the Release version.

  If IMAGE_DEPLOY_TYPE property is helm then execute the command to package the
  Helm chart according to the defined properties here. Afterthat, the
  Helm package is pushed to one or several harbor registries definided in
  the multiregistry.yaml file. The chart version is TAG_VERSION.

* `Deploy pro in n regions:` Deployment to the environment according to
 `PRO_DEPLOYMENT` property with possibility of multi-region deployment.
 Validate the destiny entity.
  Deploy the application according to the type of deployment indicated by the
  `IMAGE_DEPLOY_TYPE`.
  If the github project has an environment named `production`
  and **required reviewers** configured is configured, the job
  stops until a user approves it.

  Send data to elasticsearch related to the deployment.

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

[CD workflow link](https://github.com/santander-group-shared-assets/gln-user-reusable-workflows/blob/development/npm/immutable-images/npm-cd-image.yml)
