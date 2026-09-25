
# **Maven Applications Immutables**

## **1. Introduction**

The purpose of this documentation is you to have a step-by-step guide on how
the integration of Maven applications can be orchestrated in ALMNextGen,
so that you can build and deploy each of our Maven components through a
CI/CD process.

## **2. What I need to start?**

First of all you have to create a repository from GitHub template project.
There are different project templates that brings you the possibility of
creation an empty workflow ready to work, you can learn more about this
in the [Onboarding documentation](../../../../component-management/create-component.md){:target="_blank"}

## **3. Repository Configuration**

Before being able to orchestrate the cycle in Gluon, it will be
necessary to make several configurations

### **3.1 Branches**

Gluon works with two branches that will need to be incorporated
into our project:

- The main branch (**main** or **master** by default)
- The integration branch (**development/develop** by default)

Additionally, we will be able to work with the **Feature/** branch in which
Sonar/Fortify jobs will not be executed by default, unless we configure it
in the **properties.env file** (QG_ENABLED parameter)

### **3.2 Structure of project in GIT**

In order to use the continuous integration circuit of the Gluon it is necessary
that our project is mavenized.

Additionally, to orchestrate the entire CI / CD cycle it will be necessary to
add the following files to the root of our GIT repository

- **Properties file**:  It will be necessary to add a root folder called
**envs** in our repository where we will include a file called properties.env
- **Deployment.yaml**: This file contains the deployment configuration to
the different environments
- **Dockerfile**: This file contains all the commands a user could call on
the command line to assemble an image
- **Workflows**: It will be necessary to add a root folder called **.github**
in our repository where we will include a maven workflows
- **multiregistry.json**: File with the configuration of the
registry&credentials where we are going to upload the container image.

#### **3.2.1 Properties file**

{!
   include-markdown "../snippets/project-properties.md"
!}

#### **3.2.2 Deployment.yaml**

This file contains the deployment configuration to the different environments

In each environment (cert, pre, pro), we can deploy in as many regions as we
need. For that purpose, it will only be necessary to add the environment
configuration as indicated in the following examples.

Each deployment environment corresponds to a github project level environment:

|**Deployment environment**|**Github project environment**|
|---     |---        |
| cert   | certification |
| pre    | preproduction |
| pro    | production |

By default the deployment is configured to deploy using Openshift (OSE3).

You can choose the deploy type with the parameter IMAGE_DEPLOY_TYPE='ose3/helm'
in the properties.env

#### **3.2.2.1 Deployment.yaml (ose3 deployment)**

!!! note

    IMPORTANT: We can only configure Openshift templates that manage deployment
    type objects to deploy, all templates that manage deploy config type
    objects will not work.

OSE3 parameters

|**Variable**|**Description**|**Example value**|
|---     |---        |---          |
|**ose3Region**|PaaS region URI |'registry.global.ccc.srvb.can.paas.cloudcenter.corp'|
|**ose3Project**|PaaS project name|'c3-alm-immutable-test/maven-micro-alonextgen'|
|**ose3Application**|Application name |'deployment.yaml'|
|**ose3Template**|OSE3 Template name|'javase-immutable-image-deployment'|
|**ose3TokenCredentialId**|Deployment configuration for PRE environment|'pre_test'|
|**ose3TemplateParams**|Deployment configuration for PRE environment|'pre_test'|

Example:
=== "deployment.yaml"

    ```yaml
    # Sonar parameters
    environments:
    - name: cert
        regions:
        - name: cert1-deploymentconfig
            type: ose3Devops
            properties:
            destination_entity: 'SGT'
            ose3Region: 'https://api.ocp.ccc.srvb.cn1.paas.cloudcenter.corp:8443'
            ose3Project: 'almmc-tests-pro'
            ose3TokenCredentialId: 'ALMMC_TESTS_PRO_TOKEN'
            ose3Template:
                name: 'javase-immutable-image-deployment'
                process: true
            ose3Application: 'maven-darwin-poc'
            ose3TemplateParams:
                APP_NAME: 'maven-darwin-poc'
                DOCKER_IMAGE: 'registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3-alm-immutable-test/maven-darwin-poc:${TAG_VERSION}'
                IMAGE_TAG: '${TAG_VERSION}'
                JAVA_OPTS_EXT: 'opt1'
            ose3Params:
                IMAGE_TAG: '${TAG_VERSION}'
                APP_VERSION: 'v1'
                JAVA_OPTS_EXT_NO_TEMP: 'optext'

    - name: pre
        regions:
        - name: pre1
            type: ose3Devops
            properties:
            destination_entity: 'SGT'
            ose3Region: 'https://api.ocp.ccc.srvb.cn1.paas.cloudcenter.corp:8443'
            ose3Project: 'almmc-tests-pro'
            ose3TokenCredentialId: 'ALMMC_TESTS_PRO_TOKEN'
            ose3Template:
                name: 'javase-immutable-image-deployment'
                process: true
            ose3Application: 'maven-darwin-poc'
            ose3TemplateParams:
                APP_NAME: 'maven-darwin-poc'
                DOCKER_IMAGE: 'registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3-alm-immutable-test/maven-darwin-poc:${TAG_VERSION}'
                IMAGE_TAG: '${TAG_VERSION}'
                REPLICAS_NUM: 1
            ose3Params:
                IMAGE_TAG: '${TAG_VERSION}'
                APP_VERSION: 'v1'

    - name: pro
        regions:
        - name: pro_ok
            type: ose3Devops
            properties:
            destination_entity: 'SGT'
            ose3Region: 'https://api.ocp.ccc.srvb.cn1.paas.cloudcenter.corp:8443'
            ose3Project: 'almmc-tests-pro'
            ose3TokenCredentialId: 'ALMMC_TESTS_PRO_TOKEN'
            ose3Template:
                name: 'javase-immutable-image-deployment'
                process: true
            ose3Application: 'maven-darwin-poc'
            ose3TemplateParams:
                APP_NAME: 'maven-darwin-poc'
                DOCKER_IMAGE: 'registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3-alm-immutable-test/maven-darwin-poc:${TAG_VERSION}'
                IMAGE_TAG: '${TAG_VERSION}'
                REPLICAS_NUM: 1
            ose3Params:
                IMAGE_TAG: '${TAG_VERSION}'
                APP_VERSION: 'v1'

    ```

#### **3.2.2.2 Deployment.yaml (Helm deployment)**

Helm parameters:

|**Variable**|**Required**|**Description**|**Example value**|
|---     |---  |---  |---          |
|**apiServer**| true | Region destination api server url to interact with cluster | <https://api.ocp01.tot.dev.weu1.azure.paas.cloudcenter.corp:6443> |
|**namespace**| true | Cluster namespace where the action will perform the deployment | 'sgt-almmc-tests-v4-dev' |
|**credentialsId**| true | Token to authenticate with cluster. If this value is provided then username/password or kubeconfigFile are not needed | 'CRED_TOKEN' |
|**credentialUserId**| true | Username to auth against the cluster to obtain a valid session |Mapped to a secret 'CRED_USERNAME' |
|**credentialPassId**| true | Password for the auth user provided in credentialUserId. When username/password are provided credentialsId or kubeconfigFile not needed | Mapped to a secret 'CRED_PWD' |
|**kubeconfigFile**| true | Secret with Kubecfg content to use for authenticating with cluster | Mapped to a secret 'CRED_KUBECONFIG' |
|**deployStrategy**| false | Deploy strategy to apply in this region. Valid values are `none` or  `bluegreen` | none |
|**application**| true | Name of the application that will be created inside the cluster | 'alm-darwin-hello-world-1-dev' |
|**repo**| true | Hostname and port of the registry where the action should download chart from | 'registry.global.ccc.srvb.can.paas.cloudcenter.corp' |
|**repoType**| false | Repo ("artifactory" or "harbor") used from make download of chart, if not passed harbor is default | 'harbor' |
|**project**| true | Project inside registry where the action should retrieve the chart | 'c3-alm-immutable-test' |
|**chart**| true | Chart name to use to deploy | 'nextgen-darwin-hello-world-1-dev' |
|**version**| true | Version of the chart to use for deployment or, if the chart is being build, a placeholder referenced in environment properties in repo configuration. | '1.0.0' |
|**parameters**| false | Additial list of values to set via helm command line interface with --set option. This list will be a key: value object list as shown in the examples that will be transform to a --set key=value... command line option for helm command | |
|**valuesFile**| false | Additional list of values file to apply when deploying the chart. The path is relative to the chart location folder inside the repo |  [] |
|**script**| false | Script to use with helm. By default it's helm upgrade --install --atomic --wait but the action allows users to customize it. With this command users can add extra options to helm command. Action will keep track of duplicates giving more priority to the ones provided by user in command. | 'helm upgrade --install --atomic --wait --debug' |
|**chartPath**| false | Relative path inside the repo where chart files are located, by default workspace folder. This will be used to locate the values files to apply and make the replacements | 'helmvalues' |
|**chartUnzip**| false | Optional boolean flag to tell gluon system to unzip chart tgz before making use of it. This is useful when the chart works with external filesystem files or folders, like configmaps creation chart. | false |

Example:
=== "deployment.yaml"

    ```yaml
        environments:
        - name: cert
            regions:
            - name: dev1
                properties:
                  apiServer: https://api.ccc01alm.ccc.pre.cn1.paas.cloudcenter.corp:6443
                  namespace: sgt-almmc-tests-v4-dev
                  credentialsId: CRED_TOKEN
                  deployStrategy: none
                  repoType: harbor
                  repo: registry.global.ccc.srvb.can.paas.cloudcenter.corp
                  project: c3-alm-immutable-test
                  version: 1.0.0
                  chart: nextgen-darwin-hello-world-1-dev
                  chartUnzip: false
                  script: helm upgrade --install --atomic --wait --debug
                  application: alm-darwin-hello-world-1-dev
                  chartPath: helmvalues
                  parameters:
                    - fullpathtokeyinvalues: newvalue
                  valuesFile:
                    - globalvalues.yaml
                    - values-cert.yaml

    ```
In the above example if the `HELM_PACKAGE` property is set to false, the system will attempt to download a chart named `nextgen-darwin-hello-world-1-dev` with version `1.0.0` stored in the project `c3-alm-immutable-test` of the registry `registry.global.ccc.srvb.can.paas.cloudcenter.corp`.

As a real example, we are developing a darwin based java microservice and we want to deploy it using an existing helm chart already built and distributed by the same darwin architecture team.

First thing is to locate the chart, in this case the configuration should be (assuming the same registry as previous example is used) like this:

  - repo: registry.global.ccc.srvb.can.paas.cloudcenter.corp
  - project: sanes-darwin-san
  - chart: micro-java
  - version: 1.4.0

This will be the most common way of use to deploy a microservice.

Now we configure a folder to store the needed values files. So we set a value to the property `chartPath`, in this example well use a folder named `chartvalues` placed in the root folder of the repository.

To do this we configure the following property of each region (note that is possible to use a custom path for each region).

  - chartPath: ./chartvalues

From here we'll need to retrieve the values template for the chart and configure it with our application requirements following the chart documentation.

The recommendation here is to use a values with common values for all regions and a custom values to adapt needed values for a region and reference them under the `valuesFile` property of each region, assigning the list of required values for each environment.

This can be done by using parameters but this parameters are more intended to be used for unique values replacements.

This configuration will result in having a global `values.yaml` file and a set of files for each environment, like `values-cert.yaml`, `values-pre.yaml` and `values-pro.yaml`.

Global values file will have the full template configured and the custom `values-${env}.yaml` will only include the subsets of values that change between environments.

To illustrate this, assume we have a chart where we configure a profile to set as an environment property in a deployment resource to init a java spring based microservice.

Then we'll need to override this value for each environment, so well need to override the value associated with the profile to configure for each region `values-${env}.yaml` file.

Those values will be mixed in the order they are defined in the valuesFile property list, giving more priority to the latest ones. When a block is included in more than one values file the latest applied one will preveal.

From the configuration in the deployment.yaml example the `valuesFile` property will be translated into `-f globalvalues.yaml -f values-cert.yaml`.

So helm allows us to deploy the same image, using the same chart to create and configure cluster resources, and apply custom configurations for each region, allowing to distribute the software to other business.

#### **3.2.3 Dockerfile**

First of all we have to create Dockerfile in the root of the project, the
structure may be like this one:
=== "dockerfile"
    ```yaml
        FROM registry.global.ccc.srvb.can.paas.cloudcenter.corp/produban/javase:latest
        USER 20000
        ADD target/*.jar /usr/share/app/app.jar
        ENTRYPOINT ["java", "-jar", "/usr/share/app/app.jar"]

    ```

#### **3.2.4 Multiregistry.json**

{!
   include-markdown "**/ci-cd/technologies/snippets/multiregistryjson.md"
!}

### **3.3 Secrets in github repository**

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

#### **3.3.1 Registry Secrets**

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--registry-start-->"
   end="<!--registry-end-->"
!}

#### **3.3.2 Deployment Secrets**

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--deployment-start-->"
   end="<!--deployment-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--helm-deployment-start-->"
   end="<!--helm-deployment-end-->"
!}

## **4. How to use the project CI workflows?**

Once you have created the empty repository from a template, you will
have several workflows ready to use, the first workflow that we going
to use is the Maven CI Image workflow.

### **4.1 Pushing changes to feature branch, using Maven CI Image**

This workflow is triggered/activated when a change is made/pushed in
feature/development/develop or fix branches.
When this workflow is triggered it runs the Maven CI Image workflow
only running a Maven build, you can choose if you want to run the
Build Sonar, Fortify or Dependency Check (SCA) in the execution, in that case
you have to set the QG_ENABLED = HIGH / NONE, by default at this point
the workflow does not run the Build Sonar, Fortify or Dependency Check (SCA)
and does not deploy the image.

#### **4.1.1 Maven CI Image Workflow**

[MAVEN CI WORKFLOW](./maven-ci-image.md){:target="_blank"}

### **4.2 Creating a pull request from feature to development**

The Maven Security and Maven Quality Gate workflows are triggered when
a pull request is created to development/develop or main/master destination
branches, at this point Fortify and Dependency Check (SCA) are executed.

#### **4.2.1 Maven Security Workflow**

Here is the Maven Security workflow details:
[MAVEN SECURITY WORKFLOW](./maven-security-image.md){:target="_blank"}

#### **4.2.2 Maven Quality Workflow**

Here is the Maven Quality workflow details:
[MAVEN QUALITY WORKFLOW](maven-quality-image.md){:target="_blank"}

### **4.3 Creating a Pull request from development to main branch**

When you create a pull request from development/develop branch to
the main/master branch, it launches the Maven Security,
Maven Quality and Version Validation workflows.

#### **4.3.1 Maven Security Workflow**

Here is the Maven Security workflow details:
[MAVEN SECURITY WORKFLOW](./maven-security-image.md){:target="_blank"}

#### **4.3.2 Maven Quality Workflow**

Here is the Maven Quality workflow details:
[MAVEN QUALITY WORKFLOW](./maven-quality-image.md){:target="_blank"}

#### **4.3.3 Maven Version Validation**

Here is the Version Validation workflow details:
[VERSION VALIDATION](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

### **4.4  Merging the pull request into development branch**

When the PR pass all the security checks and someone approve de PR the
maven-ci-workflow is triggered and executed in development branch,
at this point, the workflow runs the build and and then executes
the Maven CD Image workflow to deloy the image in the development environment.

#### **4.4.1 Maven CI Image Workflow**

[MAVEN CI WORKFLOW](./maven-ci-image.md){:target="_blank"}
This workflow calls the CD workflow:
[MAVEN CD WORKFLOW](./maven-cd-image.md){:target="_blank"}

### **4.5  Merging the pull request into main branch, using CD Image**

When the PR pass all the security checks and someone approve that
PR the Maven RC Image workflow is triggered and executed in main branch.
When the Maven RC Image workflow is well executed it launches
Maven CD Image workflow for the purpose of deploy in pre, generates
the release in the project and deploy the release in production environment.

#### **4.5.1 Maven RC Image Workflow**

[MAVEN RC WORKFLOW](./maven-rc-image.md){:target="_blank"}
This workflow calls the CD workflow:
[MAVEN CD WORKFLOW](./maven-cd-image.md){:target="_blank"}
