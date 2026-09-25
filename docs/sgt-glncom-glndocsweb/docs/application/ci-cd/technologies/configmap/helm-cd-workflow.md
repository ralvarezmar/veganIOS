# Devops workflows

## Configmap workflow (helm-cd-workflow.yml)

This workflow provides a way to automate the creation of configmap on a cluster.
This workflow is executed when called from a template.

### Requirements

The GitHub runner must have:

* Helm installed and configured by default in the system variables.
* Tools: asdf, jq, yq, curl, unzip
* Connectivity to the different tools

### Inputs

This flow has the following input parameters:

| Input                  | Required  | Description                                                                                | Default |
|------------------------|-----------|--------------------------------------------------------------------------------------------|---------|
| `environmentCode`      | **true**  | Environment where the secrets will be created (cert, pre or pro).                          | '' |
| `deployment-yaml-name` | **false** | Name of yaml file that includes the deployment configuration for one or more environments. | `deployment.yaml` |
| `runner`               | **false** | Runner to use on workflow run.                                                             | `alm-nextgen-runner` |

### Jobs

All the jobs described (except `Setup environment variables` and
 `Setup deployment environment rules`) clones the project
 repository when starts the execution and reads the properties from
 `configuration project`, the repository itself and resources necessaries to
 the proper workflow execution.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Setup deployment environment rules:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined above.
  Generate a json file with all properties (param=value).

* `Deployment regions matrix:` This job generates a json matrix with one or
  more regions of the environment according to `CERT_DEPLOYMENT`,
  `PRE_DEPLOYMENT` and `PRO_DEPLOYMENT` properties and from deployment file.
  Then set this json as output for the next job that used the matrix to do
  multiple deployments base on the number of regions.

  See the `Deployment file` section of the Readme.md of each deployment action
  that is supported by [`alm-deployment-manager-action`](https://github.com/santander-group-shared-assets/gln-alm-deployment-manager-action#readme)
  for the format of the deployment file.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--deployment-start-->"
   end="<!--deployment-end-->"
!}

* `Deploy:` This job is made up of the following steps:
  * `Checkout repository`: Just checkout the repository.
  * `Execute entity-validator action`: Validate the destination entity that the
   user sets in the project. It searches in a white list file that it match.
  * `Deploying in region xxx with Helm`: Deploy the secrets in the indicated cluster.

### Configmap files

Inside our repo intended for configmap creation, to create the configmap in the
 cluster indicated in the deployment files,
 we simply have to create the desired files within the config directory and the
 workflow will create these files in the deployed configmap.

Here we can see a typical example of a java application configuration:

```text
├── README.md
└── config
    ├── application.yml
    ├── application-dev.yml
    ├── application-pre.yml
    └── application-pro.yml
```

**NOTE:**

* See [here](./../maven/project-properties.md){:target="_blank"}
  to set the necessary project properties.
* See [here](./../maven/project-secrets.md){:target="_blank"}
  to set the necessary project secrets.
* See [here](../../organization-properties.md){:target="_blank"}
  to set the necessary organization properties.
* See [here](../../organization-secrets.md){:target="_blank"}
  to set the necessary organization secrets.
