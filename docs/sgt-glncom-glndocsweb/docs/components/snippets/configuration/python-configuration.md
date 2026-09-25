### Branches
<!--Start Gitflow Branches-->
Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)
- The integration branch (development/develop by default)

This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.
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
- **Continuous Deployment files**: Configuration with the infrastructure identifiers and values of deployment. There is a file by environment (cert, pre, pro).
- **helm configuration**: Configuration with the values to deploy the image.
<!--End Configuration Files-->

#### Properties
<!--Start Common Properties-->

The location of the properties.env is:

``` bash
📂.gluon
┗ 📂ci
  ┗ 📜properties.env
```

=== "Properties.env configuration file"

    ```properties
      # Python parameters
      PYTHON_BUILD_COMMAND="pip install pipenv==2023.12.1 --no-cache-dir && pipenv install && pipenv install --dev && pipenv requirements > requirements.txt && pipenv run python -m pytest -v && pipenv --rm"

      CONTAINER_BUILD_ARGUMENTS="--build-arg ARTIFACT_PATH=${ARTIFACT_PATH} --build-arg CONFIG_PATH=${CONFIG_PATH}"

      # Sonar parameters
      SONAR_ID="SONAR_GLUON_COMMUNITY"
      SONAR_PROJECT_KEY="sny-process-sgtpyfastapi01"

      # Fortify parameters
      FORTIFY_PROJECT="sny-process-sgtpyfastapi01"
    ```

For getting more information about this file,
please refer to [Continuous Integration file documentation](../../../application/ci-cd/cd/cd-rm/cd-workflow/ci-envs-configuration.md).

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    For example

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"
    
    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

??? info "All the properties"

    See common properties [here](../../../application/ci-cd/common-project-properties.md){:target="_blank"}

<!--End Common Properties-->

#### Dockerfile
<!--Start Dockerfile-->

This file allows us to build the image with the microservice in the Build stage of the CI/CD pipeline. It is created automatically.

<!--End Dockerfile-->

#### Continuous Deployment files
<!--Start Deployment-->
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

<!--End Deployment-->

### Secrets Configuration
<!--Start Github Secrets-->

There are three types of secrets in Github.com:

- **Organization secrets**: Secrets that can be used by all repositories in the organization.
- **Repository secrets**: Secrets that can be used only by the repository.
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup GitHub Secrets"

    Secrets are set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

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

<!--End Github Secrets-->

#### Helm Configuration
<!--Start Helm Configuration-->

You must have the next files in the `.gluon/cd` folder of your project with the following structure:

``` bash
📂.gluon
┣ 📂cd
┃ ┣ 📂cert
┃ ┃ ┗ 📜values-cert.yml
┃ ┣ 📂pre
┃ ┃ ┗ 📜values-pre.yml
┃ ┣ 📂pro
┃ ┃ ┗ 📜values-pro.yml
┗ ┗ 📜values.yaml
```

Description of the files:

- **values.yaml**: Helm values file with the default values to deploy the microservice.
- **values-cert.yaml**: Helm values file with the values to deploy the microservice in the CERT environment.
- **values-pre.yaml**: Helm values file with the values to deploy the microservice in the PRE environment.
- **values-pro.yaml**: Helm values file with the values to deploy the microservice in the PRO environment.

Examples of values files:

=== "values.yaml"

```yaml linenums="1"
# Default values for darwin micro-python chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

## Active
active: online

##########################
# Labels and Annotations #
##########################

## @param commonLabels [object] Labels to add to all deployed objects
##
commonLabels: {}
## @param commonAnnotations [object] Annotations to add to all deployed objects
##
commonAnnotations: {}
## @param podLabels [object] Extra labels for the micro service pods
## Ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
##
podLabels: {}
## @param podAnnotations [object] Annotations for the micro service pods
## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
##
podAnnotations: {}

## Darwin Micro Service image version
## @param image.registry darwin micro image registry
## @param image.repository darwin micro image name
## @param image.tag darwin micro image tag
## @param image.digest darwin micro image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
##
image:
  registry:
  repository:
  tag:
  digest: ""
  ## @param image.pullPolicy darwin micro image pull policy
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  pullPolicy: IfNotPresent

## @param replicaCount Number of replicas of the micro service pod
##
replicaCount: 1

## @param lifecycle [object] Override default micro service container hooks
## If you do not set this property, the default hook is:  `{lifecycle: {preStop: {exec: {command: [sleep 120]}}}}`
##
lifecycle: {}

## @param terminationGracePeriodSeconds In seconds, time the given to the pod needs to terminate gracefully
## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
##
terminationGracePeriodSeconds: 300

## Darwin Micro Service pods' Security Context
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
## @param podSecurityContext.enabled Enable security context for the pods
## @param podSecurityContext.fsGroup Set Darwin Micro Service pod's Security Context fsGroup
## e.g:
##   podSecurityContext:
##     enabled: true
##     fsGroup: 1001
##
podSecurityContext:
  enabled: false

## Darwin Micro Service containers' Security Context
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
## @param containerSecurityContext.enabled Enable Darwin Micro Service containers' Security Context
## @param containerSecurityContext.runAsUser Set Darwin Micro Service containers' Security Context runAsUser
## @param containerSecurityContext.runAsNonRoot Set Darwin Micro Service containers' Security Context runAsNonRoot
## @param containerSecurityContext.allowPrivilegeEscalation Force the child process to be run as nonprivilege
## e.g:
##   containerSecurityContext:
##     enabled: true
##     runAsUser: 1001
##     runAsNonRoot: true
##     allowPrivilegeEscalation: false
##
containerSecurityContext:
  enabled: false.

## @param podNodeSelector.enabled Enable node selection for the pods
## @param podNodeSelector.{labelName1} Node label name1 and value1
## @param podNodeSelector.{labelName2} Node label name2 and value2
## e.g:
##   podNodeSelector:
##     enabled: true
##     label1: value1
##     label2: value2
##     label3: value3
##
podNodeSelector:
  enabled: false

#########
# Port #
#########
## Configures the ports microservice listens on
## @param containerPorts.http Sets http port inside container
## @param containerPorts.https Sets https port inside container
##
containerPorts:
  http: 8080
  https: 8443

## @param extraContainerPorts Array of additional container ports for the container
## e.g:
## extraContainerPorts:
##   - name: grpc
##     containerPort: 4317
##
extraContainerPorts: []


#############
# Resources #
#############
resources:
  limits:
    memory: 1G
    cpu: 500m
  requests:
    memory: 512M
    cpu: 100m

## @param updateStrategy.rollingUpdate deployment rolling update configuration parameters
## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
## Note: Set to Recreate if you use persistent volume that cannot be mounted by more than one pods to make sure the pods is destroyed first.
## E.g:
## updateStrategy:
##  type: RollingUpdate
##  rollingUpdate:
##    maxSurge: 25%
##    maxUnavailable: 25%
##
updateStrategy:
  type: RollingUpdate
  rollingUpdate: {}

##################
# Liveness Probe #
##################
livenessProbe:
  enabled: true
  httpGet:
    path: /health
  initialDelaySeconds: 30
  timeoutSeconds: 1
  periodSeconds: 10
  successThreshold: 1
  failureThreshold: 3

###################
# Readiness Probe #
###################
readinessProbe:
  enabled: true
  httpGet:
    path: /health
  initialDelaySeconds: 10
  timeoutSeconds: 1
  periodSeconds: 10
  successThreshold: 1
  failureThreshold: 3

## @param controller.initContainers Add additional init containers to the Controller pods
initContainers: []

######################
# Service parameters #
######################
service:
  ## @param service.type Kubernetes service type
  type: ClusterIP
  ## @param service.overrideServiceName Override the default service name
  overrideServiceName:
  ## @param service.ports.http Service HTTP port
  ## @param service.ports.https Service HTTPS port
  ##
  ports:
    http: 8080
    https: 8443
  targetPort:
    http: 8080
    https: 8443
  ## @param service.annotations [object] Additional annotations for the service of the micro
  ##
  annotations: {}

#########################
# Environment variables #
#########################

## @param extraEnvVars Extra environment variables to be set on Node container
## For example:
##  - name: BEARER_AUTH
##    value: true
##  - name: DARWIN_CM_KEY
##    valueFrom:
##      configMapKeyRef:
##        name: "cm4"
##        key: LOGGING_ROOT_LEVEL
##        optional: false
##  - name: DARWIN_SECRET_KEY
##    valueFrom:
##      secretKeyRef:
##        name: "datagrid-app"
##        key: "application-password"
##        optional: false
##
extraEnvVars: []

## @param extraEnvVarsCM Name of existing ConfigMap containing extra environment variables
##
extraEnvVarsCM:

## @param extraEnvVarsSecret Name of existing Secret containing extra environment variables
##
extraEnvVarsSecret:

## @section Volumes ##

## @param extraVolumes Optionally specify extra list of additional volume for the container(s)
extraVolumes: []

## @param extraVolumeMounts Optionally specify extra list of additional volumeMounts for the container(s)
extraVolumeMounts: []

## TLS configuration
##
ssl:
  ## @param ssl.enabled Enable init container that generate the truststore and keystore
  ##
  enabled: false

########################
# Darwin configuration #
########################
darwin:
  ## @param darwin.version. Darwin Framework Version.
  ## Examples values: `4.0.1`, `3.1.0`
  version:
  ## @param darwin.gitRepo. Git repository with the source code of the microservice.
  ## Example value: `https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/poc-certificates.git`
  gitRepo:
  ## @param darwin.technologyVersion. Python version of the image.
  ## Possible values: `39`, `310`, `311`
  technologyVersion:
  ## @param darwin.region. Cluster identifier.
  ## Possible values: `""`, `bo1`, `bo2`, `weu1.az` or `weu2.az`
  region: ""
  ## @param darwin.sufix. Suffix to blue green deployments.
  ## Possible values: `""`, `-b` or `-g`  
  suffix: ""
  logging_level_root: INFO
  tz: Europe/Madrid
  ## Configuration
  ##
  ## @param darwin.config Allows to customize the configuration files.
  config:
    ## @param darwin.configType Allows to set the configuration from ConfigMap or Configuration Service
    ## It indicates the location from which the configuration is retrieved.
    ## Four possible values are allowed:
    ##  - "cm" links a Kubernetes ConfigMap with the name cm-{app_name}. It will be mounted.
    ##  - "secret" links a Kubernetes Secret with the name secret-{app_name}. It will be mounted.
    ##  - "cm-secret" links a Kubernetes ConfigMap with name cm-{app_name} and a Kubernetes Secret with name secret-{app_name}. They will be mounted.
    ##  - "none" does not link any Kubernetes ConfigMap or Secret.
    type: none
    ## @param darwin.configuration.overrideCmName Override the default ConfigMap name
    overrideConfigMapName:
    ## @param darwin.configuration.overrideSecretName Override the default Secret name
    overrideSecretName:
  ## Internationalization
  ##
  ## @param darwin.i18n Allows to customize the internationalization files.
  i18n:
    ## @param i18n.enabled Allow customizing the internationalization files.
    ##
    enabled: false
    ## @param i18n.path Define the path to store the literal and internationalization files, if is filled.
    ## If it is not filled, the default path is '/etc/i18n/locales'.
    path:
    ## @param i18n.overrideConfigMapName Allows to override the name of the configuration Map that contains the files with the translations.
    ## if it is not filled, the default name is i18n-{app_name}.
    overrideConfigMapName:
  python:
    env: DEV
    cloud_config:
      enable: true
      failfast: true
      # Values to connect with Configuration Service
      uri: http://configuration-service:8080
      retry:
        initialInterval : 3000
        maxInterval : 6000
        maxAttempts : 10
    # Values for security module
    security:
      pkm:
        uri: https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/
    # Values for logger module
    logger:
      kafka:
        host: "sanlcckfbrd0008.santander.dev.corp:9094,sanlcckfbrd0009.santander.dev.corp:9094,sanlcckfbrd0010.santander.dev.corp:9094,sanlcckfbrd0011.santander.dev.corp:9094"
```

=== "values-dev.yaml"

    ```yaml linenums="1"
    # Here is an example file of how to give deployment values for a specific environment
    # It is necessary to reference this file in the deployment.yaml

    image:
      ## @param image.registry micro image registry to fill
      repository: san-narq-ref/darwin-python/sgtpyfastapi01
      tag: development
      ## @param image.pullPolicy darwin micro image pull policy
      ## Specify a imagePullPolicy
      ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
      ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
      ##
      pullPolicy: Always
    ```

=== "values-pre.yaml"

      ```yaml linenums="1"
      # Here is an example file of how to give deployment values for a specific environment
      # It is necessary to reference this file in the deployment.yaml

      image:
        ## @param image.registry micro image registry to fill
       repository: san-narq-ref/darwin-python/sgtpyfastapi01
      ## @param image.pullPolicy darwin micro image pull policy
        ## Specify a imagePullPolicy
        ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
        ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
        ##
        pullPolicy: IfNotPresent
      ```

=== "values-pro.yaml"

      ```yaml linenums="1"
      # Here is an example file of how to give deployment values for a specific environment
      # It is necessary to reference this file in the deployment.yaml

      image:
        ## @param image.registry micro image registry to fill
        repository: san-narq-ref/darwin-python/sgtpyfastapi01
        ## @param image.pullPolicy darwin micro image pull policy
        ## Specify a imagePullPolicy
        ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
        ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
        ##
        pullPolicy: IfNotPresent
      ```

??? note "Important Helm Configuration parameters"

|**Parameter**| **Description**                                                                        |
|---     |----------------------------------------------------------------------------------------|
| `image.repository` | Name of the project and image that we are going to deploy to Kubernetes with HELM      |
| `image.registry` | Registry from where we are going to retrieve the image for our deployment              |
| `darwin.gitRepo` | Url of the microservice repository in GitHub                                           |
| `darwin.region` | Region where we are going to deploy the microservice                                   |
| `darwin.technologyVersion` | Python version                                                                         |
| `darwin.version` | Version that we are going to deploy of our microservice                                |
| `darwin.config.type`                              | Use to configure the configmaps and secrets. Possible values `{"cm,"secret", "cm-secret", "none"}` | `cm-secret` |
| `darwin.config.overrideConfigMapName`      | Allows to overwrite the name of the ConfigMap that contains the configuration. | `""`                 |
| `darwin.config.overrideSecretName`         | Allows to overwrite the name of the Secret that contains the configuration. | `""`                 |
| `darwin.i18n`                                     | Internationalization feature for the application. |     `{}`           |
| `darwin.i18n.enabled`                             | Enable or disable the Internationalization feature. |     `false`        |
| `darwin.i18n.path`                                | Allows to change the path of the i18n files. |     `/etc/i18n/locales`        |
| `darwin.i18n.overwriteConfigMapName`               | Allows to overwrite the name of the ConfigMap that contains the i18n files. |     `""`        |

???+ warning "Chart Configuration"

    For more in-depth information, please visit the Darwin Python Helm chart repository 
    [Darwin Python Helm chart repository](https://registry.global.ccc.srvb.can.paas.cloudcenter.corp/harbor/projects/3068/helm-charts/python-chart/versions). 
    There you will find all the information about the parameters that you can configure.

##### Observability Configuration

In the `values.yaml` file, you can configure Kafka settings through environment variables specified within the `extraEnvVars` property. This functionality allows you to direct logs either to an ELK stack via Kafka or to the console.:

- **DARWIN_LOGGING_TRANSPORT**: Determines the log transport method. Set to `CONSOLE` to direct logs to the console, or `KAFKA` to send logs to Kafka. The default value is "KAFKA".
- **DARWIN_LOGGING_KAFKA_USERNAME**: Specifies the Kafka username. This is required when DARWIN_LOGGING_TRANSPORT is set to `KAFKA`.
- **DARWIN_LOGGING_KAFKA_PASSWORD**: Specifies the Kafka password. This is required when DARWIN_LOGGING_TRANSPORT is set to `KAFKA`.

```yaml
    extraEnvVars:
    - name: DARWIN_LOGGING_TRANSPORT
      value: "KAFKA"
    - name: DARWIN_LOGGING_KAFKA_USERNAME
      value: "MY_USERNAME"
    - name: DARWIN_LOGGING_KAFKA_PASSWORD
      valueFrom:
        secretKeyRef:
          name: "secret-darwin-observability"
          key: "password"
          optional: false
```

???+ warning "Kafka environment variables"

    By default, the `DARWIN_LOGGING_TRANSPORT` variable is set to `KAFKA`. If you do not set the `DARWIN_LOGGING_KAFKA_USERNAME` and `DARWIN_LOGGING_KAFKA_PASSWORD` variables, **your microservice will not be deployed**.
    Setting 'DARWIN_LOGGING_TRANSPORT' to "CONSOLE" will avoid sending the logs to Kafka and send it to the console, and no further configuration will be necessary.
    The secret must be referenced like the example above.

##### Security White List Configuration

Other environment variables can also be configured in `extraEnvVars`, such as **DARWIN_SECURITY_WHITE_LIST**.
This variable is an array of strings that specifies the microservice routes that do not require security.
Note that double quotes (") within the array must be escaped with a backslash (").

```yaml
extraEnvVars:
  - name: DARWIN_SECURITY_WHITE_LIST
    value: "[\"/my/whitelisted/endpoint\"]"
```
<!--End Helm Configuration-->