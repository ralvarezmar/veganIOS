# Darwin Java Helm Chart ![3.4.0](https://img.shields.io/badge/3.4.0-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

Helm Chart to manage Java service deployments on OpenShift.

This Helm Chart was tested with

```bash
❯ helm version
version.BuildInfo{Version:"v3.7.2", GitCommit:"663a896f4a815053445eec4153677ddc24a0a361", GitTreeState:"clean", GoVersion:"go1.16.10"}
```

and OpenShift:

```bash
❯ oc version
Client Version: 4.6.46
Kubernetes Version: v1.19.0+4c3480d
```

Main References:

- [Helm - The package manager for Kubernetes](https://helm.sh/)
- [Helm - Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/)
- [Helm Version Support Policy](https://helm.sh/docs/topics/version_skew/)
- [Helm Commands](https://helm.sh/docs/helm/)
- [Darwin Java Spring Boot](./current/index.md)

## Deploying Java Services

Install or Upgrade java service with this Helm Chart:

```bash
❯ helm upgrade --install --history-max 2 micro-demo --set image.registry=registry.sgt.pre.weu.azure.paas.cloudcenter.corp --set image.repository=gln-microservices/darwin-spring-boot-test-micro-servlet-java17 --set image.tag=4.0.0-1-SNAPSHOT --set darwin.region=weu1.az --set darwin.configType=cm --set darwin.technologyVersion=11 --set darwin.version=3.2.0 --set darwin.gitRepo=https://github.com/santander-group-shared-assets/gln-back-darwin-java-spring-boot .
```

With the following result

```bash
Release "micro-demo" does not exist. Installing it now.
NAME: micro-demo
LAST DEPLOYED: Thu Nov 10 11:39:22 2022
NAMESPACE: sanes-darwin-pre
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
micro-demo configured successfully by darwin-javase-chart Helm Chart.

Darwin Javase Enabled!!

To learn more about the release, try:

  $ helm status micro-demo
  $ helm get all micro-demo
```

### Kubernetes Configmaps related

From the configuration added with the [values parameters](#helm-chart-valuesparameters), the deployment will expect to find some Kubernetes configmaps in the namespace.

!!! info "Kubernetes Configmap Gluon Journey"

    You can create a configmap in your namespace following [this Gluon Journey](../../../../../configuration/kubernetes/configmaps-rm.md).

#### Microservice environment-dependent configuration

If [`darwin.configType`](#darwin-parameters) has **cm** or **cm-secret** values (or is not configured, defaults cm-secret) the deployment will configure and look for a **configmap** named `cm-[micro-chart-deployed-name]`
to complete the microservice's configuration properties (typically _application-{env}.properties_ files).

!!! tip "Microservice's deployed name"

    To match the configmap name you need to know the fullname of your deployed microservice. Usually it will be {releaseName}-micro-java if _fullnameOverride_ is not configured.
    For example, [from this deployment](#deploying-java-services) the expected configmaps will be **cm-micro-demo-micro-java**.

#### Internationalization properties

If [`darwin.i18n.enabled`](#darwin-parameters) is **true** (false by default) the deployment will configure and look for a **configmap** named `i18n-[micro-chart-deployed-name]` to read properties used for message internationalization in the microservice.

??? tip "Microservice's deployed name"

    To match the configmap name you need to know the fullname of your deployed microservice. Usually it will be {releaseName}-micro-java if _fullnameOverride_ is not configured.
    For example, [from this deployment](#deploying-java-services) the expected configmaps will be **i18n-micro-demo-micro-java**.

By default, it's expected to contains properties for **errors' i18n customization**, so the files deployed in the configmap must be named "_errors\_{locale}.properties_".
If other files "_prefix\_{locale}.properties_" are deployed instead, you have to configure here the property `darwin.i18n.prefix` with the prefix used.

### Override deployed service name

The `service.overrideServiceName` property allows you to override the service name deployed in the Kubernetes cluster. This property is useful when you need to deploy a service with a different name than the default value in the Helm chart.

You can set the property when installing/upgrading the helm chart like this:

```bash
helm upgrade --install micro-demo --set service.overrideServiceName=overriding-service-name .
```

As a result of this there will be a service named "overriding-service-name" instead of "micro-demo-micro-java".

## Uninstall Chart

```bash
helm uninstall micro-demo
release "micro-demo" uninstalled
```

## Template Darwin Javase Chart

Render chart templates locally and display the output.

> **IMPORTANT**: Any values that would normally be looked up or retrieved in-cluster will be faked locally. Additionally, none of the server-side testing of chart validity (e.g. whether an API is supported) is done.

```bash
helm template micro-demo --debug --set image.registry=registry.global.ccc.srvb.can.paas.cloudcenter.corp --set image.repository=san-narq-ref-san/micro-demo --set image.tag=1.0.2-SNAPSHOT --set darwin.region=bo2 --set darwin.configType=configserver --set darwin.gitRepo=http://xxx --set darwin.technologyVersion=11 --set darwin.version=3.2.0 .
```

## Looking for possible issues

The Helm lint command runs a series of tests to verify that the chart is well-formed.

"If the linter encounters things that will cause the chart to fail installation, it will emit [ERROR] messages. If it encounters issues that break with convention or recommendation, it will emit [WARNING] messages."

> **Tip**: Some arrays and dictionaries are commented out in the values.yaml file and for this reason we need to use --set to set the values needed to execute the lint command successfully.

```bash
helm lint --debug --set image.registry=registry.global.ccc.srvb.can.paas.cloudcenter.corp --set image.repository=san-narq-ref-san/micro-demo --set image.tag=1.0.2-SNAPSHOT --set darwin.region=bo2 --set darwin.configType=configserver --set darwin.gitRepo=http://xxx --set darwin.technologyVersion=11 --set darwin.version=3.2.0 .
```

Output:

```console
==> Linting .

1 chart(s) linted, 0 chart(s) failed
```

## Packaging Darwin Javase Chart

Package a chart directory into a chart archive

```bash
helm package . --version <version> --destination <path>
```

## Manage a chart's dependency

Manage the dependencies of a chart.

Helm charts store their dependencies in 'charts/'. For chart developers, it is often easier to manage dependencies in 'Chart.yaml' which declares all dependencies.

```bash
helm dependency update .
```

## Helm Chart Values/parameters

### Mandatory parameters

| Name                       | Description                                                                                                                              | Value |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-------|
| `darwin.version`           | Darwin Framework Version. eg values `"3.0.1-RELEASE"`                                                                                    | `""`  |
| `darwin.gitRepo`           | Git repository with the source code of the microservice, eg `"https://github.com/santander-group-gluon-test/san-rbfs-dwspbtstmcsrv.git"` | `""`  |
| `darwin.technologyVersion` | JRE version of the image. Possible values `{11,17,21,"native"}`                                                                          | `""`  |
| `image.registry`           | Path to images registry, eg: registry.global.ccc.srvb.can.paas.cloudcenter.corp                 | `""`      |
| `image.repository`         | Path to image                                                                                   | `""`      |
| `image.tag`                | Image tag                                                                                       | `""`      |

### Image parameters

| Name               | Description                                                                                     | Value     |
|--------------------|-------------------------------------------------------------------------------------------------|-----------|
| `image.registry`   | Path to images registry, eg: registry.global.ccc.srvb.can.paas.cloudcenter.corp                 | `""`      |
| `image.repository` | Path to image                                                                                   | `""`      |
| `image.tag`        | Image tag                                                                                       | `""`      |
| `image.digest`     | image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `"1.0.0"` |

### Deployment parameters

| Name                                          | Description                                                                                                                                                                                | Value                 |
|-----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `nameOverride`                                | String to partially override common.names.fullname template (will maintain the release name)                                                                                               | `""`                  |
| `fullnameOverride`                            | String to fully override common.names.fullname template                                                                                                                                    | `""`                  |
| `active`                                      | Indicates if service is online or offline                                                                                                                                                  | `{"online,"offline"}` |
| `commonLabels`                                | Labels to add to all deployed objects                                                                                                                                                      | `{}`                  |
| `commonAnnotations`                           | Annotations to add to all deployed objects                                                                                                                                                 | `{}`                  |
| `podLabels`                                   | Additional pod labels                                                                                                                                                                      | `{}`                  |
| `podAnnotations`                              | Additional pod annotations                                                                                                                                                                 | `{}`                  |
| `replicaCount`                                | Configure replica count                                                                                                                                                                    | `1`                   |
| `lifecycle`                                   | Override default container hooks. The default value is:  `{lifecycle: {preStop: {exec: {command: [sleep 120]}}}}`                                                                          | `{}`                  |
| `podSecurityContext.enabled`                  | Enable pods' Security Context                                                                                                                                                              | `false`               |
| `containerSecurityContext.enabled`            | Enable containers' Security Context                                                                                                                                                        | `false`               |
| `resources.limits`                            | Define Resource limits                                                                                                                                                                     | `{}`                  |
| `resources.limits.memory`                     | Define memory limit                                                                                                                                                                        | `2G`                  |
| `resources.limits.cpu`                        | Define cpu limit                                                                                                                                                                           | `1000m`               |
| `resources.requests`                          | Define Resource requests                                                                                                                                                                   | `{}`                  |
| `resources.requests.memory`                   | Define memory request                                                                                                                                                                      | `1G`                  |
| `resources.requests.cpu`                      | Define cpu request                                                                                                                                                                         | `200m`                |
| `containerPorts.http`                         | Port HTTP to expose at container level                                                                                                                                                     | `8080`                |
| `containerPorts.https`                        | Port HTTPS to expose at container level                                                                                                                                                    | `8443`                |
| `managementPorts.http`                        | Port HTTP to expose at management level for livenessProbe and readinessProbe                                                                                                               | `8080`                |
| `managementPorts.https`                       | Port HTTPS to expose at management level for livenessProbe and readinessProbe                                                                                                              | `8443`                |
| `extraContainerPorts`                         | Array of additional container ports for the container                                                                                                                                      | `{}`                  |
| `livenessProbe.enabled`                       | Enable livenessProbe                                                                                                                                                                       | `true`                |
| `livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                                                                                                    | `200`                 |
| `livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                                                                                           | `10`                  |
| `livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                                                                                          | `1`                   |
| `livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                                                                                        | `3`                   |
| `livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                                                                                        | `1`                   |
| `readinessProbe.enabled`                      | Enable readinessProbe                                                                                                                                                                      | `true`                |
| `readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                                                                                                   | `15`                  |
| `readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                                                                                          | `10`                  |
| `readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                                                                                         | `1`                   |
| `readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                                                                                       | `3`                   |
| `readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                                                                                       | `1`                   |
| `terminationGracePeriodSeconds`               | Seconds the pod needs to gracefully terminate                                                                                                                                              | `"300"`               |
| `customLivenessProbe`                         | Override default liveness probe                                                                                                                                                            | `{}`                  |
| `customReadinessProbe`                        | Override default readiness probe                                                                                                                                                           | `{}`                  |
| `extraEnvVars`                                | Extra environment variables to be set on Node container. It overrides any environment variables specified in the container image.                                                          | `[]`                  |
| `extraEnvVarsCM`                              | Name of existing ConfigMap containing extra environment variables. It creates a "envFrom.configMapRef" attribute. It overrides any environment variables specified in the container image. | `""`                  |
| `extraEnvVarsSecret`                          | Name of existing Secret containing extra environment variables. It creates a "envFrom.secretRef" attribute. It overrides any environment variables specified in the container image.       | `""`                  |
| `extraVolumes`                                | Optionally specify extra list of additional volume for the container(s).                                                                                                                   | `[]`                  |
| `extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the container(s).                                                                                                             | `[]`                  |
| `initContainers`                              | Add additional init containers to the pods                                                                                                                                                 | `{}`                  |
| `updateStrategy.type`                         | Deployment update strategy                                                                                                                                                                 | `RollingUpdate`       |
| `updateStrategy.rollingUpdate`                | Deployment rolling update configuration parameters                                                                                                                                         | `{}`                  |
| `podNodeSelector.enabled`                     | Enable the use of Node Selector capability: [Kubernetes NodeSelector Doc](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)                           | `false`               |
| `podNodeSelector.{label}`                     | Configure the labels (key: value) you want the target node to have. Kubernetes only schedules the Pod onto nodes that have all the labels you specify.                                     | `{}`                  |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account. [Kubernetes doc](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)                      | `true`                |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                                     | `"default"`           |

### HorizontalPodAutoscaler parameters

| Name                           | Description                                                                                       | Value   |
|--------------------------------|---------------------------------------------------------------------------------------------------|---------|
| `autoscaling.hpa.enabled`      | Enable HPA for pods. [Kubernetes doc](https://kubernetes.io/docs/concepts/workloads/autoscaling/) | `false` |
| `autoscaling.hpa.minReplicas`  | Minimum number of replicas.                                                                       | `""`    |
| `autoscaling.hpa.maxReplicas`  | Maximum number of replicas.                                                                       | `""`    |
| `autoscaling.hpa.targetCPU`    | Target CPU utilization percentage.                                                                | `""`    |
| `autoscaling.hpa.targetMemory` | Target Memory utilization percentage.                                                             | `""`    |

### PodDisruptionBudget parameters

| Name                  | Description                                                                                                                                    | Value   |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `pdb.create`          | Enable/disable a Pod Disruption Budget creation. [Kubernetes doc](https://kubernetes.io/docs/tasks/run-application/configure-pdb)              | `false` |
| `pdb.minAvailable`    | Minimum number/percentage of pods that should remain scheduled.                                                                                | `""`    |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty. | `""`    |

### Traffic exposure parameters

| Name                          | Description                            | Value       |
|-------------------------------|----------------------------------------|-------------|
| `service.type`                | Kubernetes Service type                | `ClusterIP` |
| `service.ports.http`          | http port                              | `8080`      |
| `service.ports.https`         | https port                             | `8443`      |
| `service.targetPort.http`     | targetPort http port                   | `8080`      |
| `service.targetPort.https`    | targetPort https port                  | `8443`      |
| `service.annotations`         | Additional annotations for the service | `{}`        |
| `service.overrideServiceName` | Override the service name              | `""`        |

### Init Container SSL (cert-store-generation)

| Name                     | Description                                                                                     | Value                                                |
|--------------------------|-------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `ssl.enabled`            | Enable init container cert-store-generation that generate the truststore and keystore           | `false`                                              |
| `ssl.image.registry`     | Init container cert-store-generation registry name                                              | `registry.global.ccc.srvb.can.paas.cloudcenter.corp` |
| `ssl.image.repository`   | Init container cert-store-generation repository name                                            | `produban/init-certs-container`                      |
| `ssl.image.tag`          | Init container cert-store-generation tag name                                                   | `1.0.8.RELEASE`                                      |
| `ssl.image.pullPolicy`   | Init container cert-store-generation image pull policy                                          | `IfNotPresent`                                       |
| `ssl.resources.limits`   | Init container resource limits                                                                  | `{}`                                                 |
| `ssl.resources.requests` | Init container resource requests                                                                | `{}`                                                 |
| `ssl.keystorePassword`   | Password for the keystore to create. If no value is specified, a random password is generated   | `""`                                                 |
| `ssl.truststorePassword` | Password for the truststore to create. If no value is specified, a random password is generated | `""`                                                 |

### Darwin parameters

| Name                                               | Description                                                                                                                          | Value                                                                                                    |
|----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `darwin`                                           | Darwin Framework parameters                                                                                                          |                                                                                                          |
| `darwin.version`                                   | Darwin Framework Version. eg values `"3.0.1-RELEASE"`                                                                                | `""`                                                                                                     |
| `darwin.gitRepo`                                   | Git repository with the source code of the microservice, eg `"https://github.com/santander-group-gluon-test/san-rbfs-dwspbtstmcsrv"` | `""`                                                                                                     |
| `darwin.technologyVersion`                         | JRE version of the image. Possible values `{11,17,21,"native"}`                                                                      | `""`                                                                                                     |
| `darwin.region`                                    | Cluster identifier. Possible values `{"","bo1","bo2","weu1.az","weu2.az"}`                                                           | `""`                                                                                                     |
| `darwin.suffix`                                    | Suffix to blue green deployments. Possible values `{"","-b","-g}`                                                                    | `""`                                                                                                     |
| `darwin.configtype`                                | Define the external configuration source. Possible values `{"cm,"secret", "cm-secret","configserver", "none"}`                                 | `cm-secret` |
| `darwin.config`                                    | Define config service specific settings                                                                                              | `{}`                 |
| `darwin.config.overrideConfigMapName`              | Allows to overwrite the name of the ConfigMap that contains the configuration.                                                       | `""`                 |
| `darwin.config.overrideSecretName`                 | Allows to overwrite the name of the Secret that contains the configuration.                                                          | `""`                 |
| `darwin.logging_level_root`                        | Root Logging Level                                                                                                                   | `"INFO"`                                                                                                 |
| `darwin.tz`                                        | TimeZone for the running containers                                                                                                  | `"Europe/Madrid"`                                                                                        |
| `darwin.i18n.enabled`                              | Allow customizing the internationalization files.                                                                                    | `false`                                                                                        |
| `darwin.i18n.path`                                 | Container path to mount internationalization files.                                                                                  | `"/etc/i18n"`                                                                                            |
| `darwin.i18n.prefix`                               | Define the internationalization files prefix (_prefix\_{locale}.properties_).                                                        | `"errors"`                                                                                               |
| `darwin.i18n.overrideConfigMapName`                | Allows to overwrite the name of the ConfigMap that contains the i18n files.                                                          |     `""`        |
| `darwin.spring.profiles`                           | Profiles, eg values `{dev,pre,pro}`                                                                                                  | `"dev"`                                                                                                  |
| `darwin.spring.cloud_config.failfast`              | Spring Cloud configuration fail fast                                                                                                 | `true`                                                                                                   |
| `darwin.spring.cloud_config.uri_http`              | URI for configuration service backend                                                                                                | `http://configuration-service${darwin.suffix}:8080`                                                      |
| `darwin.spring.cloud_config.uri_https`             | HTPS URI for configuration service backend                                                                                           | `https://configuration-service${darwin.suffix}.${PROJECT_NAME}.svc.cluster.local:8443`                   |
| `darwin.spring.cloud_config.username`              | Username for connecting to Git repository. Only needed if the profile basic-auth is used                                             | `""`                                                                                                     |
| `darwin.spring.cloud_config.password`              | Password for connecting to Git repository. Only needed if the profile basic-auth is used                                             | `""`                                                                                                     |
| `darwin.spring.cloud_config.retry`                 | Configuration Service retry parameters                                                                                               | `{}`                                                                                                     |
| `darwin.spring.cloud_config.retry.initialInterval` | Initial interval to wait before retry to connect (ms).                                                                               | `3000`                                                                                                   |
| `darwin.spring.cloud_config.retry.maxInterval`     | The maximum time to try to connect before give up (ms).                                                                              | `6000`                                                                                                   |
| `darwin.spring.cloud_config.retry.maxAttempts`     | Maximum  attempts to connect before give up.                                                                                         | `10`                                                                                                     |
| `darwin.java.opts_ext`                             | Java options                                                                                                                         | `"-Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8 -XX:MaxRAMPercentage=60.0 -XX:+UseG1GC"` |
| `darwin.java.parameters`                           | Java parameters                                                                                                                      | `""`                                                                                                     |

## Upgrading

All notable changes to this project will be documented in this file.

### To 3.4.0

- Allow changing the service account that executes the pod using the **serviceAccountName** properties.
- Add a HorizontalPodAutoscaler using the **autoscaling.hpa** properties.
- Add a PodDisruptionBudget using the **pdb** properties.

### To 3.3.0

- Added the **managementPorts** properties in case it is necessary to define a port for liveness and readiness probes at management level different from the container level.

### To 3.2.0

- The **darwin.configType** property has a new **none** option for projects that do not use any ConfigMap or Configuration Service
- The **service.overrideServiceName** is a new property to override deployed service name.
- The **darwin.config.overrideConfigMapName** is a new property to allow to overwrite the name of the ConfigMap that contains the configuration.
- The **darwin.config.overrideSecretName** is a new property to allow to overwrite the name of the Secret that contains the configuration.
- The **darwin.i18n.overrideConfigMapName** is a new property to allow to overwrite the name of the ConfigMap that contains the i18n files.
- Added validation to mandatory parameters: **image.registry, image.repository, image.tag**
- Fix **darwin.gitRepo** validation to show correct error message when doesn't exist.

### To 3.1.1

- Don't add internal files to chart.

### To 3.1.0

- Add documentation about Kubernetes Configmaps related to the microservice deployed.
- New property **podNodeSelector** that allows devOps to define node affinity. This property is disabled by default.

### To 3.0.1

- New property **darwin.i18n.prefix** that allows developers to Define the internationalization files prefix.
- Adding two new technology versions supported: Java 21, and Java Native image.

### To 3.0.0

- New properties **darwin.i18n.enabled** and **darwin.i18n.path** that allow developers to enable the internationalization features.
- Updating init-certs-container tag image to 1.0.8.RELEASE version.

### To 2.0.0

- Fix `.Values.extraContainerPorts`this attribute has a bad indentation.
- Fix `.Values.lifecycles`this attribute has not a correct name, now it has the correct name `.Values.lifecycle`.
- We move the mandatory parameters values validation to the first line of `deployment.yml`. Before, it has been located in the `notes.txt` and the validations executes at the end of the renderization.
  Now the validation executes before renderization in order to show the validation errors first.

### To 1.5.0

- Update default values for deployment:
  - _resources.requests.memory_: 500M
  - Added to _java.opts_ext_: -XX:ActiveProcessorCount=2 and -XX:+UseParallelGC

### To 1.4.2

- Fix a bug where the secret was not mounted correctly when selecting **darwin.configType=secret** or **darwin.configType=cm-secret** and change name by secretName.

### To 1.4.1

- Fix a bug where the secret was not mounted correctly when selecting **darwin.configType=secret** or **darwin.configType=cm-secret**.

### To 1.4.0

- Migration from DeploymentConfig to Deployment.
  - NOTE: From this major release onwards this helm chart will deploy microservices via **Deployment** instead of **DeploymentConfig** so **ReplicaSet** will be created instead of **ReplicationController**.
    If you upgrade an application that has previously been deployed with previous versions of this helm chart, helm will automatically upgrade, i.e. it will remove the existing **DeploymentConfig** and **ReplicationController** resources and create
    the equivalent **Deployment** and **ReplicationSet**.
    If you are using this helm chart for the first time on an already deployed application, you will have to delete the resources before running this helm chart.
- Rename chart from **darwin-javase-chart** to **micro-java**.
- Remove Istio integration.
- Fix indentation issues for: **extraEnvVars**, **extraVolumeMounts** and **extraVolumes**.

### To 1.3.0

- All reusable helm chart functions are removed in order to use the new 'common' library that provides all the functionality common to Darwin charts.
- The property **version** has been renamed to **darwin.technologyVersion**.
- Now, it is mandatory to define a value for the properties: **darwin.version**, **darwin.gitRepo** and **darwin.technologyVersion**. These values are propagated to the following deployment labels:
  - **santander.com/technology-version** from **darwin.technologyVersion** value.
  - **santander.com/git-host**, **santander.com/git-org** and **santander.com/git-repo** from **darwin.gitRepo** value.
  - **santander.com/darwin-version** from **darwin.version** value.
- The **name** property is removed from the **values.yaml** file because it is redundant. Now:
  - The name of the kubernetes resources will be created from the **common.names.fullname**.
  - The name of the container will be **.Release.Name**.
  - The environment variable APP_NAME shall have a value of **.Release.Name**.
- New property **podSecurityContext** that allows to indicate a security context for the pod.
- The **securityContext** property is renamed to **containerSecurityContext**.
- Now the lifecycle hooks can be customized using **lifecycle** property.
- The property **lifecycle.terminationGracePeriodSeconds** has been renamed to **terminationGracePeriodSeconds**.
- Minor bugs.

### To 1.2.0

- A new **ssl mode** is added. This enables automatically generates and injects a keystore and truststore with the certificates in order to have intracluster https communications.
  The generation of these stores is done by means of an init-container created for this purpose. In addition, it configures the healthchecks and port of the service to 8443.
- The **labels** property is renamed to **commonLabels**.
- The **annotations** property is renamed to **commonAnnotations**.
- The property **darwin.configserver** has been renamed to **darwin.configType**. Now instead of a boolean it can take four values "configserver","cm", "secret" and "cm-secret".
- New **service.annotations** property to be able to add annotations to the service.
- New property **image.registry** to indicate the registry where the image should be searched for.
- New property **image.digest** to select an image by the digest instead of by the tag.
- New **containerPorts** property that allows to indicate the http or https port associated to the microservice container and service.
- New **extraContainerPorts** property to be able to add other ports to the container.
- New properties **livenessProbe.enabled** and **readinessProbe.enabled** to enable/disable liveness/readiness probes.
- New properties **customLivenessProbe** and **customReadinessProbe** to override the default liveness/readiness probes that
  are invocations to the /actuator/health/readiness and /actuator/health/liveness endpoints on the http/https port.endpoints on the http/https port.
- New **initContainers** property for add additional init containers to the Controller pods
- Now the **service.port** and **service.targetPort** properties allow defining the port of the service for the http and https protocols.
- The **darwin.spring.cloud_config.uri** property has been renamed to **darwin.spring.cloud_config.uri_http**. New attribute **darwin.spring.cloud_config.uri_https** to define the url to a secure config server.
- The **istio** property has been renamed to **istio.enabled**.

### To 1.1.0

- New attribute **extraVolumes**. specify extra list of additional volume for the container(s). [doc](https://kubernetes.io/docs/concepts/storage/volumes/)
- New attribute **extraVolumeMounts**. specify an extra list of additional volumeMounts for the container(s). [doc](https://kubernetes.io/docs/concepts/storage/volumes/)
- New attribute **extraEnvVarsSecret**. It allows developers to create a **"envFrom.secretRef"** attribute [doc](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
- New attribute **extraEnvVarsCM**. It allows developers to create a **"envFrom.configMapRef"** attribute. It overrides any environment variables specified in the container image.
- New attribute **extraEnvVars**. It allows us to add extra environment variables to be set on Node container
- These new attributes override any environment variables specified in the container image.

### To 1.0.0

- Deploy java services on Kubernetes
- Allow Configuration based on Spring Cloud Config or ConfigMap
- Include Istio annotations
