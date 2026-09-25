# Python Helm Chart

Base Helm Chart to use as dependency in Darwin Python microservices.

<!-- TOC -->

- [Python Helm Chart](#python-helm-chart)
  - [How to install or upgrade Chart](#how-to-install-or-upgrade-chart)
    - [Important information for successful deployment](#important-information-for-successful-deployment)
  - [Uninstall Chart](#uninstall-chart)
  - [Render Chart templates locally](#render-chart-templates-locally)
  - [Looking for possible issues](#looking-for-possible-issues)
  - [Packaging Darwin Python Chart](#packaging-darwin-python-chart)
  - [Mandatory Parameters](#mandatory-parameters)
  - [Image parameters](#image-parameters)
  - [Deployment parameters](#deployment-parameters)
  - [Darwin parameters](#darwin-parameters)
  - [Traffic exposure parameters](#traffic-exposure-parameters)
  - [Changelog](#changelog)
    - [To 2.4.0](#to-240)
    - [To 2.3.0](#to-230)
    - [To 2.2.0](#to-220)
    - [To 2.1.1](#to-211)
    - [To 2.1.0](#to-210)
    - [To 2.0.0](#to-200)
    - [To 1.0.0](#to-100)

<!-- /TOC -->
<!-- /TOC -->
This Helm Chart was tested with

```bash
❯ helm version
version.BuildInfo{
  Version:"v3.13.2",
  GitCommit:"2a2fb3b98829f1e0be6fb18af2f6599e0f4e8243",
  GitTreeState:"clean",
  GoVersion:"go1.20.10"
}
```

and OpenShift:

```bash
❯ oc version
oc v3.11.0+0cbc58b
kubernetes v1.11.0+d4cacc0
```

Main References:

- [Helm - The package manager for Kubernetes](https://helm.sh/)
- [Helm - Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/)
- [Helm Version Support Policy](https://helm.sh/docs/topics/version_skew/)
- [Helm Commands](https://helm.sh/docs/helm/)
- [Darwin - Python Framework](https://github.alm.europe.cloudcenter.corp/sanes-darwin/sanes-darwin-python)

## How to install or upgrade Chart

```sh
helm upgrade --install --atomic --wait --history-max 2 darwin-python --set name=python-fw --set image.registry=registry.global.ccc.srvb.bo.paas.cloudcenter.corp --set image.repository=san-narq-ref/python-fw --set image.tag=3.0.0 --set darwin.technologyVersion=39 --set darwin.version=3.2.0 --set darwin.gitRepo=https://github.com/santander-group-gluon/gln-back-darwin-python-s-flask .
```

Example of a successful deployment:

```bash
NAME: darwin-python
LAST DEPLOYED: Wed Nov 29 16:36:15 2023
NAMESPACE: san-darwin-dev
STATUS: deployed
REVISION: 1
TEST SUITE: None
USER-SUPPLIED VALUES:
darwin:
  gitRepo: https://github.com/santander-group-gluon/gln-back-darwin-python-s-flask
  technologyVersion: 39
  version: 3.2.0
image:
  registry: registry.global.ccc.srvb.bo.paas.cloudcenter.corp
  repository: san-narq-ref/python-fw
  tag: 3.0.0
name: python-fw
```

> To consult more about the parameters, [review this section](#mandatory-parameters)

### Important information for successful deployment

Based on your desired configuration for the Python application, specified in `darwin.configType` field in *values.yaml*, you have to make sure that you have previously created a ConfigMap or Secret.
Both ConfigMap and Secret should be created in the same namespace where application is being deployed and should contain environment variables with the same name as the following example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cm-helm-python-darwin-python-chart
data:
  DARWIN_TEST_VALUE: YWRtaW4=
  DARWIN_TEST_VALUE2: MWYyZDFlMmU2N2Rm
```

If the value `fullNameOverride` is set in the values root, the name of the ConfigMap or Secret will be just `cm-[fullNameOverride]` / `secret-[fullNameOverride]`. If this value is not set:

> The ConfigMap should follow the naming scheme below:

```bash
cm-[releaseName]-[chartName]
```

> The Secret should follow the naming scheme below:

```bash
secret-[releaseName]-[chartName]
```

>For example, if we run `helm install testname` the release name would be *testname*
while the chart name is specified in the field *name* of the file *Chart.yaml* and in our case it's
> *darwin-python*, hence if we were to use *cm* mode then we should create a ConfigMap named *cm-testname-darwin-python*. The same rule applies to Secret with the only difference being the prefix.
>If the releaseName contains or is equal to the chartName, the config map or secret name will be just cm-[releaseName] / secret-[releaseName]. So if we run `helm install darwin-python .`, the resource should be named *cm-darwin-python*.
> Anyway you can check the object name before installing by executing a dry run or a template.

## Uninstall Chart

```bash
❯ helm uninstall darwin-python
release "darwin-python" uninstalled
```

## Render Chart templates locally

Render chart templates locally and display the output.

> **IMPORTANT**: Any values that would normally be looked up or retrieved in-cluster will be faked locally. Additionally, none of the server-side testing of chart validity (e.g. whether an API is supported) is done.
> **Tip**:  Some arrays and dictionaries are commented out in the values.yaml file and for this reason we need to use --set to set the values needed to execute the template command successfully.

Below, you can see the mandatory parameters needed.This chart needs values for mandatory variables:

- image.registry: Path to images registry.
- image.repository: Darwin Python image to deploy.
- image.tag: Darwin Python image tag.
- darwin.technologyVersion: Python version used.

```bash
❯ helm template chart-python --set name=python --set image.registry=an-registry --set image.repository=an-image --set image.tag=1.0.0 --set darwin.technologyVersion=39  --set darwin.gitRepo=https://github.com/santander-group-gluon/gln-back-darwin-python-s-flask --debug .
```

## Looking for possible issues

The Helm lint command runs a series of tests to verify that the chart is well-formed.

"If the linter encounters things that will cause the chart to fail installation, it will emit [ERROR] messages. If it encounters issues that break with convention or recommendation, it will emit [WARNING] messages."

> **Tip**: Some arrays and dictionaries are commented out in the values.yaml file and for this reason we need to use --set to set the values needed to execute the lint command successfully.

This chart needs values for mandatory variables:

- image.registry: Path to images registry.
- image.repository: Darwin Python image to deploy.
- image.tag: Darwin Python image tag.
- darwin.technologyVersion: Python version used.

```bash
helm lint --set name=python-chart --set image.registry=an-registry --set image.repository=an-image --set image.tag=1.0.0 --set darwin.technologyVersion=39 --set darwin.gitRepo=https://github.com/santander-group-gluon/gln-back-darwin-python-s-flask --debug .
```

With the output:

```bash
==> Linting .

1 chart(s) linted, 0 chart(s) failed
```

## Packaging Darwin Python Chart

Package a chart directory into a chart archive

```bash
❯ helm package . --version <version> --destination <path>
```

## Mandatory Parameters

These parameters have to be defined in the values.yaml of the Helm Chart that uses this.

| Name                 | Description                                                                                     | Value                          |
| -------------------- | ------------------------------------------------------------------------------------------------| -------------------------------|
| `image.registry`     | Path to images registry, eg: registry.global.ccc.srvb.bo.paas.cloudcenter.corp                  | `""`                           |
| `image.repository`   | Path to image                                                                                   | `""`                           |
| `image.tag`          | Image tag                                                                                       | `""`                           |
| `darwin.technologyVersion`| Python version used ```39, 310, 311```                                                      | `""`                           |

## Image parameters

| Name                     | Description                                                                                     | Value                       |
|--------------------------|-------------------------------------------------------------------------------------------------|-----------------------------|
| `image.registry`         | Path to images registry, eg: registry.global.ccc.srvb.bo.paas.cloudcenter.corp                  | `""`                        |
| `image.repository`       | Path to image                                                                                   | `""`                        |
| `image.tag`              | Image tag                                                                                       | `""`                        |
| `image.digest`           | image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `"1.0.0"`                   |
| `image.pullPolicy`       | image pull policy                                                                               | `IfNotPresent`              |

## Deployment parameters

| Name                                 | Description                                                                                                                                                                                | Value                 |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| `nameOverride`                       | String to partially override common.names.fullname template (will maintain the release name)                                                                                               | `""`                  |
| `fullnameOverride`                   | String to fully override common.names.fullname template                                                                                                                                    | `""`                  |
| `active`                             | Indicates if service is online or offline                                                                                                                                                  | `{"online,"offline"}` |
| `commonLabels`                       | Labels to add to all deployed objects                                                                                                                                                      | `{}`                  |
| `commonAnnotations`                  | Annotations to add to all deployed objects                                                                                                                                                 | `{}`                  |
| `podLabels`                          | Additional pod labels                                                                                                                                                                      | `{}`                  |
| `podAnnotations`                     | Additional pod annotations                                                                                                                                                                 | `{}`                  |
| `replicaCount`                       | Configure replica count                                                                                                                                                                    | `1`                   |
| `lifecycle`                          | Override default container hooks. The default value is:  `{lifecycle: {preStop: {exec: {command: [sleep 120]}}}}`                                                                          | `{}`                  |
| `podSecurityContext.enabled`         | Enable pods' Security Context                                                                                                                                                              | `false`               |
| `podNodeSelector.enabled`            | Enable pods' Node Selector                                                                                                                                                              | `false`               |
| `containerSecurityContext.enabled`   | Enable containers' Security Context                                                                                                                                                        | `false`               |
| `resources.limits`                   | Define Resource limits                                                                                                                                                                     | `{}`                  |
| `resources.limits.memory`            | Define memory limit                                                                                                                                                                        | `2G`                  |
| `resources.limits.cpu`               | Define cpu limit                                                                                                                                                                           | `1000m`               |
| `resources.requests`                 | Define Resource requests                                                                                                                                                                   | `{}`                  |
| `resources.requests.memory`          | Define memory request                                                                                                                                                                      | `1G`                  |
| `resources.requests.cpu`             | Define cpu request                                                                                                                                                                         | `200m`                |
| `containerPorts.http`                | Port HTTP to expose at container level                                                                                                                                                     | `8080`                |
| `containerPorts.https`               | Port HTTPS to expose at container level                                                                                                                                                    | `8443`                |
| `extraContainerPorts`                | Array of additional container ports for the container                                                                                                                                      | `{}`                  |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                                                                                                       | `true`                |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                                                                    | `200`                 |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                                                                           | `10`                  |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                                                                          | `1`                   |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                                                                        | `3`                   |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                                                                        | `1`                   |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                                                                                                      | `true`                |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                                   | `15`                  |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                                          | `10`                  |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                                         | `1`                   |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                                       | `3`                   |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                                       | `1`                   |
| `terminationGracePeriodSeconds`      | Seconds the pod needs to gracefully terminate                                                                                                                                              | `"300"`               |
| `customLivenessProbe`                | Override default liveness probe                                                                                                                                                            | `{}`                  |
| `customReadinessProbe`               | Override default readiness probe                                                                                                                                                           | `{}`                  |
| `extraEnvVars`                       | Extra environment variables to be set on Node container. It overrides any environment variables specified in the container image.                                                          | `[]`                  |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra environment variables. It creates a "envFrom.configMapRef" attribute. It overrides any environment variables specified in the container image. | `""`                  |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra environment variables. It creates a "envFrom.secretRef" attribute. It overrides any environment variables specified in the container image.       | `""`                  |
| `extraVolumes`                       | Optionally specify extra list of additional volume for the container(s).                                                                                                                   | `[]`                  |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the container(s).                                                                                                             | `[]`                  |
| `initContainers`                     | Add additional init containers to the pods                                                                                                                                                 | `{}`                  |
| `updateStrategy.type`                | Deployment update strategy                                                                                                                                                                 | `RollingUpdate`       |
| `updateStrategy.rollingUpdate`       | Deployment rolling update configuration parameters                                                                                                                                         | `{}`                  |

## Darwin parameters

| Name                                       | Description                                              | Value                |
|--------------------------------------------|----------------------------------------------------------|----------------------|
| `darwin`                                   | Darwin Framework parameters                              |                      |
| `darwin.version`                           | Darwin Framework Version. eg values `"3.1.1"`  | `""`  |
| `darwin.gitRepo`                           | Git repository with the source code of the microservice, eg `"https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/poc-certificates.git"` | `""`  |
| `darwin.technologyVersion`                 | Python version of the image. Possible values `{39, 310, 311}` | `""`  |
| `darwin.region`                            | Cluster identifier. Possible values `{"","bo1","bo2","weu1.az","weu2.az"}`      | `""`  |
| `darwin.suffix`                            | Suffix to blue green deployments                         |   `{"","-b","-g}`    |
| `darwin.logging_level_root`                | Root Logging Level                                       | `"INFO"`             |
| `darwin.tz`                                | TimeZone for the running containers                      | `"Europe/Madrid"`    |
| `darwin.config`                            | Define config service specific settings                  | `{}`                 |
| `darwin.config.type`                              | Use to configure the configmaps and secrets. Possible values `{"cm,"secret", "cm-secret", "none"}` | `cm-secret` |
| `darwin.config.overrideConfigMapName`      | Allows to overwrite the name of the ConfigMap that contains the configuration. | `""`                 |
| `darwin.config.overrideSecretName`         | Allows to overwrite the name of the Secret that contains the configuration. | `""`                 |
| `darwin.python`                            | Define Python framework specific settings                  | `{}`                 |
| `darwin.python.env`                        | Profiles, eg values {dev,pre,pro}                        |      `DEV`           |
| `darwin.python.cloud_config.enable`        |                                                          |      `true`          |
| `darwin.python.cloud_config.failfast`      | Spring Cloud configuration fail fast                     |      `true`          |
| `darwin.python.cloud_config.uri`           | Configuration service                                    | `http://configuration-service:8080`   |
| `darwin.python.cloud_config.retry.initialInterval`|Initial interval to wait before retry to connect (ms). |        `3000`        |
| `darwin.python.cloud_config.retry.maxInterval`    |The maximum time to try to connect before give up (ms).|       `6000`         |
| `darwin.python.cloud_config.retry.maxAttempts`    | Maximum attempts to connect before give up.       |       `10`           |
| `darwin.python.security.pkm.uri`                  | Values for security module                        |     `https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/` |
| `darwin.python.logger.kafka.host`                 | Values for logger module                            |     `kafkadarwin.santander.dev.corp:9092` |
| `darwin.i18n`                                     | Internationalization feature for the application. |     `{}`           |
| `darwin.i18n.enabled`                             | Enable or disable the Internationalization feature. |     `false`        |
| `darwin.i18n.path`                                | Allows to change the path of the i18n files. |     `/etc/i18n/locales`        |
| `darwin.i18n.overwriteConfigMapName`               | Allows to overwrite the name of the ConfigMap that contains the i18n files. |     `""`        |

## Traffic exposure parameters

| Name                        | Description                           | Value        |
| --------------------------- | --------------------------------------|--------------|
| `service`                   | Define service parameters             |    `{}`      |
| `service.type`             | Kubernetes Service type                | `ClusterIP` |
| `service.ports.http`       | http port                              | `8080`      |
| `service.ports.https`      | https port                             | `8443`      |
| `service.targetPort.http`  | targetPort http port                   | `8080`      |
| `service.targetPort.https` | targetPort https port                  | `8443`      |
| `service.annotations`      | Additional annotations for the service | `{}`        |
| `overrideServiceName`      | Override the service name              | `""`        |

## Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html)

### To 2.4.0

- We fix volumeMounts and volumes indentation.
- We update the .helmignore file.
- We update the the common library dependency to a new version and a new repository.
- We add the **service.overrideServiceName** property to allow to override the service name.
- We remove the **darwin.configType** property and add the **darwin.config.type** property to allow to configure the configmaps and secrets. Possible values are: **cm**, **secret**, **cm-secret** and **none**. We maintain the backward compatibility.
- We add the **darwin.config.overrideConfigMapName** property to allow to overwrite the name of the ConfigMap that contains the configuration.
- We add the **darwin.config.overrideSecretName** property to allow to overwrite the name of the Secret that contains the configuration.
- We add the **darwin.i18n** property to allow to configure the Internationalization feature for the application.
- We add the **darwin.i18n.enabled** property to enable or disable the Internationalization feature.
- We add the **darwin.i18n.path** property to allow to change the path of the i18n files.
- We add the **darwin.i18n.overwriteConfigMapName** property to allow to overwrite the name of the ConfigMap that contains the i18n files.

### To 2.3.0

- New property **podNodeSelector** that allows to indicate a node selector for the pod. This property is disabled by default. [doc](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)

### To 2.2.0

- We removed the **kubeVersion** property from the **Chart.yaml** file.

### To 2.1.1

- Fix issue with the **extraEnvVarsSecret** property that was not working properly.

### To 2.1.0

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
- Migration from DeploymentConfig to Deployment.
  - NOTE: From this major release onwards this helm chart will deploy microservices via **Deployment** instead of **DeploymentConfig** so **ReplicaSet** will be created instead of **ReplicationController**.
  If you upgrade an application that has previously been deployed with previous versions of this helm chart,
  helm will automatically upgrade, i.e. it will remove the existing **DeploymentConfig** and **ReplicationController**
  resources and create the equivalent **Deployment** and **ReplicationSet**.
  If you are using this helm chart for the first time on an already deployed application, you will have to delete the resources before running this helm chart.
- Rename chart from **darwin-python-chart** to **micro-python**.
- Remove Istio integration.
- Fix indentation issues for: **extraEnvVars**, **extraVolumeMounts** and **extraVolumes**.
- Now the **service.port** and **service.targetPort** properties allow to define the port of the service for the http and https protocols.
- Minor bugs.

### To 2.0.0

- New **service.annotations** property to be able to add annotations to the service.
- The labels property is renamed to commonLabels.
- The annotations property is renamed to commonAnnotations.
- New attribute **extraVolumes**. specify extra list of additional volumeMounts for the container(s). [doc](https://kubernetes.io/docs/concepts/storage/volumes/)
- New attribute **extraVolumeMounts**. specify extra list of additional volumeMounts for the container(s). [doc](https://kubernetes.io/docs/concepts/storage/volumes/)
- New attribute **extraEnvVarsSecret**. It allow us to create a **"envFrom.configMapRef"** attribute [doc](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
- These new attributes overwrites any environment variables specified in the container image.
- New attribute **extraEnvVars**. It allow us to add extra environment variables to be set on Node container
- New attribute **extraEnvVars**. It allow us to add extra environment variables to be set on Node container
- New property image.registry to indicate the registry where the image should be searched for.
- New property image.digest to select an image by the digest instead of by the tag.
- New extraContainerPorts property to be able to add other ports to the container.
- New properties livenessProbe.enabled and readinessProbe.enabled to enable/disable liveness/readiness probes.
- New properties customLivenessProbe and customReadinessProbe to override the default liveness/readiness probes that are invocations to the /actuator/health/readiness and /actuator/health/liveness endpoints on the http/https port.
- New initContainers property for add additional init containers to the Controller pods.
- Allow Configuration based on Spring Cloud Config or ConfigMap.

### To 1.0.0

- First version of template. It includes template configuration for:
  - Istio
  - Darwin Configuration
    - Security
    - Logs
    - Cloud Configuration service
  - Configmaps
  - Image
  - Lifecycle
  - Security context
  - Resources
  - Deployment Strategy
  - Liveness Probe
  - Readiness Probe
  - Blue/Green Deployment
- Allows to enable or disable Spring Cloud Configuration
