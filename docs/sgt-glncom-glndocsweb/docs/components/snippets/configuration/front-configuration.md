### Branches
<!--Start Gitflow Branches-->
Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)
- The integration branch (development/develop by default)

This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.
<!--End Gitflow Branches-->

### Configuration Files
<!--Start Configuration Files-->
- **properties.env**: Properties with the CI configuration
- **Dockerfile**: Configuration to build the image
- **Continuous Deployment files**: Configuration with the infrastructure identifiers and values of deployment. There is a file by environment (cert, pre, pro).
- **Helm Configuration files**: Configuration with the values to deploy the image.
<!--End Configuration Files-->

#### Properties

<!--Start Location Properties-->
The location of the properties.env is:

``` bash
📂.gluon
┗ 📂ci
  ┗ 📜properties.env
```
<!--End Location Properties-->

<!--Start Common Properties-->

On `.gluon/ci/properties.env` file you'll be able to customize different topics like the way you install or build your software.
There are many different variables, these are the most relevant for a npm repo:

| **Variable** | **Required** | **Description** | **Default values** |
| ---                               | ---   | --- |---          |
| NPM_RUN_INSTALL_COMMAND           | false | Configure it to change the way you install your dependencies on the CI/CD workflows | `npm install`   |
| NPM_RUN_BUILD_COMMAND             | false | Configure it to change the way you build your project on the CI/CD workflows | `npm run build` |
| NPM_APPLICATION_DIST_DIRECTORY    | false | Lets the workflow know in which directory is your distribution | `dist`          |
| NPM_CONFIGURATION_DIST_DIRECTORY  | false | Lets the workflow know in which directory is your nginx configuration | `conf.d`        |
| NPM_SONAR_PROPERTIES              | false | Configure it to change the way sonar behaves, but take into account you can not exclude your code!! | `-Dsonar.sources=src -Dsonar.tests=. -Dsonar.test.inclusions=**/*.spec.ts,**/*.test.ts,**/*.test.tsx -Dsonar.javascript.coveragePlugin=lcov -Dsonar.javascript.lcov.reportPath=coverage/**/lcov.info -Dsonar.typescript.lcov.reportPaths=coverage/**/lcov.info -DtestExecutionReportPaths=test-result/ut_report.xml,ut_report.xml` |
| NPM_APPLICATION_GROUP             | true  | It MUST be configured to publish the artifact to the artifact repository, even if it is not intended to be deployed to S3 at this time | `santander-group-gluon-test`   |

??? info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    For example:

    SONAR_PROJECT_KEY="san-demo-mycomponent"

    FORTIFY_PROJECT="san-demo-mycomponent"

<!--End Common Properties-->

#### Dockerfile

<!--Start Dockerfile-->
This file allow us to build the image in the *Build* stage of the CI/CD pipeline.

One example for Dockerfile is:

```dockerfile title="Dockerfile Proposal" linenums="1"
FROM registry.global.ccc.srvb.bo.paas.cloudcenter.corp/produban/nginx-1-25-ubi8:1.2.1.RELEASE

# NOTE: DO *NOT* EDIT THIS FILE.  IT IS MANAGED BY ALM DEVOPS TEAM.

ARG ARTIFACT_PATH
ARG CONFIG_PATH

USER root

RUN echo $CONFIG_PATH
RUN echo $ARTIFACT_PATH

ADD $ARTIFACT_PATH /tmp/app.zip
ADD $CONFIG_PATH /tmp/conf.zip

RUN unzip -o /tmp/app.zip  -d /usr/share/nginx/html/
RUN unzip -o /tmp/conf.zip -d /tmp/ && cd /tmp/nginx/ && cp -r * /etc/nginx/conf.d/

RUN mkdir -p /opt/app

RUN chown 999 -R /opt/app
RUN chown 999 -R /tmp
RUN chown 999 -R /usr/share/nginx/html
RUN chown 999 -R /etc/nginx/conf.d
RUN chown 999 -R /var/log
RUN chown 999 -R /opt

RUN chmod -R 776 /opt
RUN chmod -R 775 /etc/nginx/conf.d
RUN chmod -R 775 /tmp/nginx

USER 999

ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]
```
<!--End Dockerfile-->

#### Continuous Deployment files
<!--Start CD-->
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
    - .gluon/cd/values.yaml
    - .gluon/cd/{environment}/values.yaml
# Kubernetes cluster in Azure
- ci_id: CI00000000002
  configuration_files:
    - .gluon/cd/values.yaml
    - .gluon/cd/{environment}/values.yaml
```

[See the full list of examples of how to set up your deployment infrastructure here](../../software/backend/snippets/oam-configuration.md)

For getting more information about how-to-configure the deployment environment files,
please refer to the [Continuous Deployment file documentation](../../../application/ci-cd/cd/cd-rm/cd-workflow/cd-envs-configuration.md).

For getting to know how to configure the `Gluon Open Application Model` repository,
the following documentation is available [here](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)

<!--End CD-->

### Helm Configuration
<!--Start Helm Chart-->

You'll have a **.gluon/cd** folder with the following structure:

``` bash
📂.gluon
 ┗ 📂cd
   ┣ 📂cert
   | ┗ 📜values.yml
   ┣ 📂pre
   | ┗ 📜values.yml
   ┗ 📂pro
   | ┗ 📜values.yml
   ┗ 📜values.yaml
```

Description of the files:

- **.gluon/cd/values.yaml**: Helm values file with the default values to deploy the image (It will be the base for all the environments)
- **.gluon/cd/cert/values.yaml**: Helm values file with the values to deploy the image in the DEV environment
- **.gluon/cd/pre/values.yaml**: Helm values file with the values to deploy the image in the PRE environment
- **.gluon/cd/pro/values.yaml**: Helm values file with the values to deploy the image in the PRO environment

Examples of values files:

=== ".gluon/cd/cert/values.yaml"

    ```yaml linenums="1"
    image:
      tag: "development"
      pullPolicy: Always
    ```

=== "values.yaml"

    ```yaml linenums="1"
    # Default values for darwin angular chart.
    # This is a YAML-formatted file.
    # Declare variables to be passed into your templates.

    ## @section Common parameters

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

    ## @section Expose parameters

    ## @param expose.type Type of service to expose application, "Route" or "Ingress". "Route" is only available for OpenShift
    ## @param expose.termination Only for "Route" type. Termination type for the route, "edge", "passthrough", and "re-encryption termination".
    expose:
      type: "Route"
      termination: edge

    ## Only for "Ingress" type. Ingress configuration
    ## Configuration for Ingress resource
    ## @param ingress.className The name of the IngressClass to use for the Ingress resource
    ## @param ingress.hosts List of hosts for the Ingress resource
    ## @param ingress.hosts.host Hostname to use for accessing the service
    ## @param ingress.hosts.paths List of paths to use for this host
    ## @param ingress.hosts.paths.path Path to use for the Ingress resource
    ## @param ingress.hosts.paths.pathType Type of the path (e.g., Prefix, Exact, ImplementationSpecific)
    ## @param ingress.port Port to expose on the Ingress resource
    ## @param ingress.annotations Annotations to add to the Ingress resource
    ## @param ingress.tls Configuration for Ingress TLS
    ## @param ingress.tls.secretName Name of the secret to use for the Ingress TLS
    ## @param ingress.tls.hosts List of hosts to use for the Ingress TLS
    ingress:
      className: "nginx"
      hosts:
        - host: chart-example.local
          paths:
            - path: /
              pathType: Prefix
            ## Uncomment the following line to use a relative path with a regular expression. Replace '/relative-path(/|$)(.*)' with your relative path.
            # - path: /relative-path(/|$)(.*)
            #   pathType: ImplementationSpecific
      port: 8080
      tls: []
      ## Uncomment the following lines to enable TLS. Make sure to replace 'chart-example.local' with your host names and 'chart-example-tls' with your TLS secret name.
      # tls:
      #   - hosts:
      #       - chart-example.local
      #     secretName: chart-example-tls

      ## Uncomment the following line to redirect requests if the path is not / and use regex
      # annotations:
      #   nginx.ingress.kubernetes.io/rewrite-target: /$2

    ## @section Angular Application parameters

    ## Darwin Angular Application image version
    ## @param image.registry darwin angular application image registry
    ## @param image.repository darwin angular application image name
    ## @param image.tag darwin angular application image tag
    ## @param image.digest darwin angular application image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
    ##
    image:
      registry: ""
      repository: ""
      tag: ""
      digest: ""
      ## @param image.pullPolicy darwin angular application image pull policy
      ## Specify a imagePullPolicy
      ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
      ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
      ##
      pullPolicy: IfNotPresent

    ## @param replicaCount Number of replicas of the angular application Pod
    ##
    replicaCount: 1

    ## darwin containers resource requests and limits
    ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
    ## @param resources.limits [object] The resources limits for the gateway container
    ## @param resources.requests [object] The requested resources for the gateway container
    ##
    resources:
      ## Example:
      ## limits:
      ##    cpu: 500m
      ##    memory: 1Gi
      ##
      limits:
        memory: 1G
        cpu: 750m
      requests:
        memory: 512M
        cpu: 100m

    ## Configures Port to expose at container level
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
    extraContainerPorts:
      - containerPort: 8081
        protocol: TCP

    ## @param lifecycle [object] Override default angular container hooks
    ## If you do not set this property, the default hook is:  `{lifecycle: {preStop: {exec: {command: [sleep 120]}}}}`
    ##
    lifecycle: {}

    ## @param terminationGracePeriodSeconds In seconds, time the given to the pod needs to terminate gracefully
    ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
    ##
    terminationGracePeriodSeconds: 300

    ## Angular pods' Security Context
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
    ## @param podSecurityContext.enabled Enable security context for the pods
    ## @param podSecurityContext.fsGroup Set angular pod's Security Context fsGroup
    ## e.g:
    ##   podSecurityContext:
    ##     enabled: true
    ##     fsGroup: 1001
    ##
    podSecurityContext:
      enabled: false

    ## Angular pods' Node Selector
    ## ref: Assign Pods to Nodes
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

    ## Angular containers' Security Context
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
    ## @param containerSecurityContext.enabled Enable angular containers' Security Context
    ## @param containerSecurityContext.runAsUser Set angular containers' Security Context runAsUser
    ## @param containerSecurityContext.runAsNonRoot Set angular containers' Security Context runAsNonRoot
    ## @param containerSecurityContext.allowPrivilegeEscalation Force the child process to be run as nonprivilege
    ## e.g:
    ##   containerSecurityContext:
    ##     enabled: true
    ##     runAsUser: 1001
    ##     runAsNonRoot: true
    ##     allowPrivilegeEscalation: false
    ##
    containerSecurityContext:
      enabled: false

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

    ## Configure extra options for liveness probe
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
    ## @param livenessProbe.enabled Enable livenessProbe by default /health
    ## @param livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
    ## @param livenessProbe.periodSeconds Period seconds for livenessProbe
    ## @param livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
    ## @param livenessProbe.failureThreshold Failure threshold for livenessProbe
    ## @param livenessProbe.successThreshold Success threshold for livenessProbe
    ##
    livenessProbe:
      enabled: true
      initialDelaySeconds: 60
      timeoutSeconds: 1
      periodSeconds: 30
      successThreshold: 1
      failureThreshold: 3

    ## @param customLivenessProbe [object] Override default liveness probe
    ##
    customLivenessProbe: {}

    ## Configure extra options for readiness probe
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes
    ## @param readinessProbe.enabled Enable readinessProbe, by default /health
    ## @param readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
    ## @param readinessProbe.periodSeconds Period seconds for readinessProbe
    ## @param readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
    ## @param readinessProbe.failureThreshold Failure threshold for readinessProbe
    ## @param readinessProbe.successThreshold Success threshold for readinessProbe
    readinessProbe:
      enabled: true
      initialDelaySeconds: 10
      timeoutSeconds: 1
      periodSeconds: 30
      successThreshold: 1
      failureThreshold: 3

    ## @param customReadinessProbe [object] Override default readiness probe
    ##
    customReadinessProbe: {}

    ## @param extraEnvVars Extra environment variables to be set on Node container
    ## For example:
    ##  - name: BEARER_AUTH
    ##    value: "true"
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
    ## For example:
    ## - name: data
    ##   persistentVolumeClaim:
    ##      claimName: test-volumes
    ##
    extraVolumes: []

    ## @param extraVolumeMounts Optionally specify extra list of additional volumeMounts for the container(s)
    ## For example:
    ## - mountPath: /opt/test
    ##   name: data
    ##
    extraVolumeMounts: []

    ## @section service configuration
    ##
    service:
      type: ClusterIP
      ## @param service.ports.http.port Service HTTP port
      ## @param service.ports.https.port Service HTTPS port
      ## @param service.ports.http.name Service HTTP name. Default value http
      ## @param service.ports.https.name Service HTTPS name. Default value https
      ##
      ports:
        http:
          port: 8080
        https:
          port: 8443
      targetPort:
        http: 8080
        https: 8443
      ## @param service.annotations [object] Additional annotations for the service of the gateway
      ##
      annotations: {}

    ## @section server TLS configuration

    ## TLS configuration
    ##
    ssl:
      ## @param ssl.enabled Enables the application in SSL mode
      ##
      enabled: false

    ## @section Darwin configuration

    ## Darwin Framework parameters
    ##:
    darwin:
      ## @param darwin.version. Darwin Framework Version.
      ## Examples values: `angular13`, `angular15`.
      version: "angular15"
      ## @param darwin.gitRepo. Git repository with the source code of the application
      ## Example value: `https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/poc-certificates.git`
      gitRepo: "https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/poc-certificates.git"
      ## @param darwin.technologyVersion. Nginx version of the image.
      ## Examples values: `nginx-ubi8-1-20`
      technologyVersion: "nginx-ubi8-1-20"
      ## @param darwin.region. Cluster identifier.
      ## Possible values: ""`, `bo1`, `bo2`, `weu1.az` or `weu2.az`
      region: ""
      ## @param darwin.suffix. Suffix to blue green deployments.
      ## Possible values: `""`, `-b` or `-g`
      suffix: ""
      tz: Europe/Madrid
      ## @param darwin.configType Allows to set the configuration from ConfigMap or Configuration Service
      ## It indicates the location from which the configuration is retrieved.
      ## Four possible values are allowed:
      ##  - "cm" creates a Kubernetes ConfigMap with the name cm-{app_name}. It will be mounted.
      ##  - "secret" creates a Kubernetes Secret with the name secret-{app_name}. It will be mounted.
      ##  - "cm-secret" creates a Kubernetes ConfigMap with name cm-{app_name} and a Kubernetes Secret with name secret-{app_name}. They will be mounted.
      ##  - "configserver" to use Spring Cloud Configuration Server.
      ##  - "none" to not create a Kubernetes ConfigMap nor a Kubernetes Secret.
      ##
      configType: cm
    ```

??? note "All Helm Configuration parameters"

    |**Parameter**|**Description**|
    |---     |---        |
    | darwin.version | Framework version of our image: `angular15`, `react`  |
    | darwin.gitRepo | Url of the repository in GitHub: `https://github.com/sanes-darwin-poc/poc-certificates.git` |
    | darwin.technologyVersion | nginx version: `nginx-ubi8-1-20` |
    | darwin.region | Region where we are going to deploy the image: ""`, `bo1`, `bo2`, `weu1.az` or `weu2.az` |
    | darwin.suffix | Suffix for blue/green deployments: `""`, `-b` or `-g` |
    | darwin.tz | Region where we are going to deploy our image: Europe/Madrid |
    | darwin.configType | We must configure the use of configmap, for this it will be necessary to indicate "cm" |

In case you follow the new Release management strategy, you'll have a new cd.yml file in each environment folder.

- **.gluon/cd/cert/cd.yml**: Matrix with the values.yaml location for each CERT intrastructure
- **.gluon/cd/pre/cd.yml**: Matrix with the values.yaml location for each PRE intrastructure
- **.gluon/cd/pro/cd.yml**: Matrix with the values.yaml location for each PRO intrastructure

<!--End Helm Chart-->

### Secrets Configuration
<!--Start Github Secrets-->

There are three types of secrets in Github.com

- **Organization secrets**: Secrets that can be used by all repositories in the organization
- **Repository secrets**: Secrets that can be used only by the repository
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup Github Secrets"

    Secrets can be set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

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