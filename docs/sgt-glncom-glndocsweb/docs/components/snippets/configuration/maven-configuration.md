### Branches
<!--Start Gitflow Branches-->

#### Git Flow

In this case, Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)
- The integration branch (development/develop by default)

We need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.
<!--End Gitflow Branches-->
<!--Start TBD Branches-->

#### Trunk Based Development

Here, Gluon works with only one branch that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)

With trunk-based development, we will merge feature branches with Pull Requests directly into the main branch.
<!--End TBD Branches-->

### Configuration Files
<!--Start Configuration Files-->
- **properties.env**: Properties with the CI/CD configuration
- **Dockerfile**: Configuration to build the image
- **multiregistry.json**: registry configuration and credentials to upload the image.
- **deployment.yaml**: Configuration to deploy the image
- **helm configuration**: Configuration with the values to deploy the image.
<!--End Configuration Files-->

<!--Start Configuration Files 2.0-->
- **properties.env**: Properties with the CI configuration
- **Dockerfile**: Configuration to build the image
- **Continuous Deployment files**: Configuration with the infrastructure identifiers and values of deployment. There is a file by environment (cert, pre, pro).
- **Helm Configuration files**: Configuration with the values to deploy the image.
<!--End Configuration Files 2.0-->
#### Properties
<!--Start Common Properties-->

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

| **Variable**        | **Required** | **Description** | **Example value**               |
|---------------------|--------------|-----------------|---------------------------------|
| **SONAR_PROJECT_KEY** | true         | Project key in Sonar | sgt-gluonad-probemicroframework |
| **FORTIFY_PROJECT** | true         | Project name in Fortify | sgt-gluonad-probemicroframework |
| **JAVA_VERSION** | true         | Java version to use | adoptopenjdk-17.0.8+7 |
| **ARTIFACT_NATIVE_COMPILATION** | false        | Artifact native compilation | false |

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name. 
    To avoid possible errors, the **properties.env** file is generated with the necessary values for the variables **SONAR_PROJECT_KEY** and **FORTIFY_PROJECT**.
    
    Example values:

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"

    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

??? info "All the properties"

    {!
       include-markdown "**/application/ci-cd/**/maven/snippets/project-properties.md"
    !}
<!--End Common Properties-->
#### Dockerfile
<!--Start Dockerfile-->

This file allows us to build the image with the microservice in the *Build* stage of the CI/CD pipeline.
It is created automatically.

<!--End Dockerfile-->
#### Multiregistry
<!--Start Multiregistry-->
{!
   include-markdown "**/ci-cd/technologies/snippets/multiregistryjson.md"
!}
<!--End Multiregistry-->
#### Deployment
<!--Start Deployment-->
This file contains the deployment configuration to the different environments

In each environment (cert, pre, pro), we can deploy in as many regions as we
need. For that purpose, it will only be necessary to add the environment
configuration as indicated in the following examples.

Each deployment environment corresponds to a github project level environment:

| **Deployment environment** | **Github project environment** |
|----------------------------|--------------------------------|
| cert                       | certification                  |
| pre                        | preproduction                  |
| pro                        | production                     |

All the properties for deployment are:

|**Variable**|**Required**|**Description**|**Example value**|
|---     |---  |---  |---          |
|**provider**| false | Type of provider to deploy to. Possible values: `openshift` or `eks`. The default value is `openshift` | 'openshift' |
|**providerParams**| false | Extra parameters inside cluster informed to perform the deployment, these parameters can be used inside this block 'awsAccount', 'awsRoleArn', 'awsRegion', 'clusterName', see the example. | |
|**awsAccount**| false | Parameter inside 'providerParams'. Account ID of cloud provider, used only for cloud deployment. | '1111111111' |
|**awsRoleArn**| false | Parameter inside 'providerParams'. Type of role in cloud provider to authenticate, used only for cloud deployment | 'role-arn'  |
|**awsRegion**| false | Parameter inside 'providerParams'. Region in which the deployment will be made in cloud provider, used only for cloud deployment | 'region-1' |
|**clusterName**| false | Parameter inside 'providerParams'. Name of the cluster that will be deployed in cloud provider, used only for cloud deployment | 'clustername001'  |
|**apiServer**| true | Region destination api server url to interact with cluster | '<https://api.ocp01.tot.dev.weu1.azure.paas.cloudcenter.corp:6443>' |
|**namespace**| true | Cluster namespace where the action will perform the deployment | 'sgt-almmc-tests-v4-dev' |
|**registry**| true | Registry where images are going to be uploaded | 'registry.global.ccc.srvb.bo.paas.cloudcenter.corp' |
|**credentialsId**| true | Token to authenticate with cluster. If this value is provided then username/password or kubeconfigFile are not needed | 'CRED_TOKEN' |
|**credentialUserId**| true | Username to auth against the cluster to obtain a valid session |Mapped to a secret| 'CRED_USERNAME' |
|**credentialPassId**| true | Password for the auth user provided in credentialUserId. When username/password are provided credentialsId or kubeconfigFile not needed | Mapped to a secret | 'CRED_PWD' |
|**kubeconfigFile**| true | Secret with Kubecfg content to use for authenticating with cluster | Mapped to a secret | 'CRED_KUBECONFIG' |
|**deployStrategy**| false | Deploy strategy to apply in this region. Valid values are `none` or `bluegreen`. More information about [blue & green deployment](../../software/backend/commons/blue-green-development.md). **Blue & green deployment is currently only available if deployed on infrastructure in Spain** | none |
|**application**| true | Name of the application that will be created inside the cluster | 'alm-micro-hello-world-1-dev' |
|**repo**| true | Hostname and port of the registry where the action should download chart from | 'registry.global.ccc.srvb.can.paas.cloudcenter.corp' |
|**repoType**| false | Repo ("artifactory" or "harbor") used from make download of chart, if not passed harbor is default | 'harbor' |
|**project**| true | Project inside registry where the action should retrieve the chart | 'c3-alm-immutable-test' |
|**chart**| true | Chart name to use to deploy | 'nextgen-micro-hello-world-1-dev' |
|**version**| true | Version of the chart to use for deployment or, if the chart is being build, a placeholder referenced in environment properties in repo configuration. | '1.0.0' |
|**parameters**| false | Additial list of values to set via helm command line interface with --set option. This list will be a key: value object list as shown in the examples that will be transform to a --set key=value... command line option for helm command | |
|**valuesFile**| false | Additional list of values file to apply when deploying the chart. The path is relative to the chart location folder inside the repo |  [] |
|**script**| false | Script to use with helm. By default it's helm upgrade --install --atomic --wait but the action allows users to customize it. With this command users can add extra options to helm command. Action will keep track of duplicates giving more priority to the ones provided by user in command. | 'helm upgrade --install --atomic --wait --debug' |
|**chartPath**| false | Relative path inside the repo where chart files are located, by default workspace folder. This will be used to locate the values files to apply and make the replacements | 'helmvalues' |
|**chartUnzip**| false | Optional boolean flag to tell gluon system to unzip chart tgz before making use of it. This is useful when the chart works with external filesystem files or folders, like configmaps creation chart. | false |

???+ warning "Blue & Green deployment"

    This functionality is currently only available if deployed on infrastructure in Spain.

    More information about [blue & green deployment](../../software/backend/commons/blue-green-development.md)

<!--End Deployment-->

#### Continuous Deployment files
<!--Start Deployment 2.0-->
In that set of files,
we are going
to define the necessary infrastructure references
so that the helm chart can deploy the configmap correctly in the configured environment.
The Continuous Deployment file (`cd.yml`) must
contain the target deployment configuration that we want to use for deploying the component.
For each environment (cert, pre, pro),
we have a folder with the `cd.yml` file, and there,
we can define several infrastructures to deploy in as many regions as we
need.
Remember that `cd.yml` files are empty,
and the developer is responsible for filling them with the necessary deployment information.

``` bash
📂.gluon
┣ 📂cd
┃ ┣ 📂cert
┃ ┃ ┣ 📜cd.yml
┃ ┣ 📂pre
┃ ┃ ┣ 📜cd.yml
┃ ┣ 📂pro
┃ ┃ ┗ 📜cd.yml
```

For that purpose,
it will only be necessary to add the `ci_id` identifiers
defined by environment type in the `oam-application-definition.yml` file inside **Gluon Open Application Model repository**
associated with the company of the component.
Keep in mind that **`ci_id` must be the same as we have in OAM the config file**.
The `configuration_files` key allows
setting the `values` chart files that they are necessary to be able
to deploy in the infrastructures to which they refer.

| **Property**       | **Description**                                                             | **Example**                    |
|--------------------|-----------------------------------------------------------------------------|--------------------------------|
| ci_id              | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000097                  |
| configurationFiles | Path to the Helm configuration file in that environment                     | .gluon/cd/cert/values-cert.yml |

The following template shows an example of the structure that the `cd.yml` file should have:

```yaml
# Kubernetes cluster in AWS
- ci_id: CI00000000001
  configuration_files:
    - .gluon/cd/values.yml
    - .gluon/cd/{environment}/values-{environment}.yml
# Kubernetes cluster in Azure
- ci_id: CI00000000002
  configuration_files:
    - .gluon/cd/values.yml
    - .gluon/cd/{environment}/values-{environment}.yml
```

[See the full list of examples of how to set up your deployment infrastructure here](../../software/backend/snippets/oam-configuration.md)

For getting more information about how-to-configure the deployment environment files,
please refer to the [Continuous Deployment file documentation](../../../application/ci-cd/cd/cd-rm/cd-workflow/cd-envs-configuration.md).

For getting
to know
how to configure the `Gluon Open Application Model` repository,
the following documentation is available [here](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)

???+ warning "Blue & Green deployment"

    This functionality is currently only available if deployed on infrastructure in Spain.

    More information about [blue & green deployment](../../software/backend/commons/blue-green-development.md)

<!--End Deployment 2.0-->

### Secrets Configuration
<!--Start Github Secrets-->

There are three types of secrets in Github.com

- **Organization secrets**: Secrets that can be used by all repositories in the organization
- **Repository secrets**: Secrets that can be used only by the repository
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup GitHub Secrets"

    Secrets are set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

#### Registry Secrets

Those credentials are referenced in the multiregistry.json file and defined at repository secrets level.

```json title="Simple multiregistry example" linenums="1" hl_lines="7 8"
[
{
    "registry-type": "harbor",
    "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
    "image":      "c3-alm-immutable-test/maven-micro-alonextgen",
    "usernameId": "REGISTRY_USERNAME",
    "passwordId": "REGISTRY_PASS"
}
]
```

#### Deploy Secrets

Those credentials are referenced in the **deployment.yaml** file and defined at **environment secrets level**, so we have to create the secrets in each environment (CERT,PRE and PRO).

- credentialsId
- credentialUserId
- credentialPassId
- kubeconfigFile

<!--End Github Secrets-->

<!--Start Github Secrets 2.0-->

<!--Start Github Secrets 2.0 - secret type no vault-->

There are three types of secrets in Github.com:

- **Organization secrets**: Secrets that can be used by all repositories in the organization.
- **Repository secrets**: Secrets that can be used only by the repository.
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

<!--End Github Secrets 2.0 - secret type no vault-->

???+ warning "Setup GitHub Secrets"

    Secrets are set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

<!--Start Github Secrets 2.0 - secrets-->
#### Deploy Secrets

Those credentials are referenced in the `Gluon Open Application Model repository` and defined at **environment secrets level**,
so we have to create the secrets in each environment (CERT, PRE and PRO).

##### Deployment Infrastructure

For accessing to the **OC** Kubernetes Cluster,
it is necessary to create authentication secrets for this key:

- credentialsId

For accessing to the **EKS** and **AKS** Kubernetes Cluster, or to the **APIGEE** and **IBM** API Managers,
it is necessary to create authentication secrets for these keys:

- credentialUserId
- credentialPassId

##### Registries Infrastructure

For accessing to the **Harbor**, **Artifactory**, **ECR**, and **ACR** Artifacts Stores,
it is necessary to create authentication secrets for these keys:

- usernameId
- passwordId

For getting more information about the authentication keys,
please refer to [Parameters available by type of infrastructure component](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)

<!--End Github Secrets 2.0 - secrets-->
<!--End Github Secrets 2.0-->

<!--Start Github Secrets Only Registry 2.0-->

There are three types of secrets in Github.com:

- **Organization secrets**: Secrets that can be used by all repositories in the organization.
- **Repository secrets**: Secrets that can be used only by the repository.
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup GitHub Secrets"

    Secrets are set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

#### Registry Secrets

Those credentials are referenced in the `Gluon Open Application Model repository` and defined at **environment secrets level**,
so we have to create the secrets in each environment (CERT, PRE and PRO).

##### Registries Infrastructure

For accessing to the **Harbor**, **Artifactory**, **ECR**, and **ACR** Artifacts Stores,
it is necessary to create authentication secrets for these keys:

- usernameId
- passwordId

For getting more information about the authentication keys,
please refer to [Parameters available by type of infrastructure component](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)

<!--End Github Secrets Only Registry 2.0-->
