# Kubernetes deployment examples for OAM Configuration

For each technology, we must configure the infrastructure data specific to that technology.
The provided information will be used during the deployment of the backend components.
The configuration properties can vary based on the infrastructure in which the component is published.

The infrastructure data will be configured in the Gluon Application Model component created in the application where components are going to be deployed.
Each of the infrastructure configurations included in the component has a unique identifier (ci_id) for each configured environment.

> **IMPORTANT:** The absence or incorrect configuration of the infrastructure parameters can cause deployment or execution errors of the components.

## **Deployment Infrastructures**

### Infrastructure data for Azure Kubernetes Service cluster

Infrastructure properties table:

| Key                    | Description                                                                            | Example                                                |
|------------------------|----------------------------------------------------------------------------------------|--------------------------------------------------------|
| `type`                 | Deployment platform type                                                               | KUBERNETES                                             |
| `apiServer`            | Kubernetes API server URL                                                              | <https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443> |
| `namespace`            | Kubernetes namespace                                                                   | app360-cert                                            |
| `credentialUserId`     | User ID for authentication                                                             | AKS_USER                                               |
| `credentialPassId`     | Password ID for authentication                                                         | AKS_PASSWORD                                           |
| `provider`             | Deployment platform provider                                                           | aks                                                    |
| `cloud`                | Cloud service provider                                                                 | azure                                                  |
| `account`              | Account in the cloud service provider                                                  | 0000000e-000c-00fd-a0bf-0000000c000d                   |
| `clusterName`          | Kubernetes cluster name                                                                | cibd1weuaksdevopscrit003                               |
| `tenant`               | Azure tenant ID                                                                        | 00000a00-0d0d-44ac-00e0-f0ab0cd000db                   |
| `resourceGroup`        | Azure resource group                                                                   | cibd0weursgdevopscrit000                               |
| `deployStrategy`       | Deployment strategy                                                                    | none                                                   |
| `application`          | Application name                                                                       | application-name-cluster                               |
| `valuesFile`           | Additional list of values file to apply when deploying the chart.                      | values-cert.yaml                                       |
| `chartPath`            | Relative path inside the repo where chart files are located.                           | './.gluon/cd'                                          |
| `chartUnzip`           | Optional boolean flag to tell gluon system to unzip chart tgz before making use of it. | true                                                   |
| `credentialsFromVault` | If credentials are obtained from a vault, by default: false                            | false                                                  |
| `artifact-store`       | Artifact store identifier                                                              | CI00000000001                                          |

Infrastructure properties example:

``` yaml
properties:
  type: KUBERNETES
  apiServer: https://cibaks-ea0de0a0.hcp.westeurope.azmk8s.io:444
  namespace: project-cert
  credentialUserId: AKS_USER
  credentialPassId: AKS_PASSWORD
  provider: aks
  cloud: azure
  account: 0000000e-000c-00fd-a0bf-0000000c000d
  clusterName: cibd1weuaksdevopscrit003
  tenant: 00000a00-0d0d-44ac-00e0-f0ab0cd000db
  resourceGroup: cibd0weursgdevopscrit000
  deployStrategy: none
  application: application-name-cluster
  chartPath: ./.gluon/cd
  chartUnzip: true
  valuesFile: values-{env}.yaml
  credentialsFromVault: false
  artifact-store: CI00000000001
```

### Infrastructure data for Amazon Elastic-Kubernetes Service cluster

Infrastructure properties table:

| Key                    | Description                                                                            | Example                                                                    |
|------------------------|----------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `type`                 | Deployment platform type                                                               | KUBERNETES                                                                 |
| `apiServer`            | Kubernetes API server URL                                                              | <https://00000000000000000000000000000000.sk1.eu-west-1.eks.amazonaws.com> |
| `namespace`            | Kubernetes namespace                                                                   | project-name-dev                                                           |
| `credentialUserId`     | User ID for authentication                                                             | AWS_ACCESS_KEY_ID                                                          |
| `credentialPassId`     | Password ID for authentication                                                         | AWS_SECRET_ACCESS_KEY_ID                                                   |
| `provider`             | Deployment platform provider                                                           | eks                                                                        |
| `cloud`                | Cloud service provider                                                                 | aws                                                                        |
| `account`              | Account in the cloud service provider                                                  | 000000000000                                                               |
| `role`                 | Role in the cloud service provider                                                     | AccountAutomationNonPro                                                    |
| `region`               | Cloud service provider region                                                          | eu-west-1                                                                  |
| `clusterName`          | Kubernetes cluster name                                                                | sgtd1aireksgluondeksd000                                                   |
| `deployStrategy`       | Deployment strategy                                                                    | none                                                                       |
| `application`          | Application name                                                                       | application-name-cluster                                                   |
| `valuesFile`           | Additional list of values file to apply when deploying the chart.                      | values-cert.yaml                                                           |
| `chartPath`            | Relative path inside the repo where chart files are located.                           | './.gluon/cd'                                                              |
| `chartUnzip`           | Optional boolean flag to tell gluon system to unzip chart tgz before making use of it. | true                                                                       |
| `credentialsFromVault` | If credentials are obtained from a vault, by default: false                            | false                                                                      |
| `artifact-store`       | Artifact store  identifier                                                             | CI00000000001                                                              |

Infrastructure properties example:

``` yaml
properties:
  type: KUBERNETES
  apiServer: https://00000000000000000000000000000000.sk1.eu-west-1.eks.amazonaws.com
  namespace: project-name-dev
  credentialUserId: AWS_ACCESS_KEY_ID
  credentialPassId: AWS_SECRET_ACCESS_KEY_ID
  provider: eks
  cloud: aws
  account: 000000000000
  role: AccountAutomationNonPro
  region: eu-west-1
  clusterName: sgtd1aireksgluondeksd000
  deployStrategy: none
  application: application-name-cluster
  chartPath: ./.gluon/cd
  chartUnzip: true
  valuesFile: values-{env}.yaml
  credentialsFromVault: false
  artifact-store: CI00000000001
```

### Infrastructure data for RedHat Openshift Cluster

Infrastructure properties table:

| Key                    | Description                                                                            | Example                                                       |
|------------------------|----------------------------------------------------------------------------------------|---------------------------------------------------------------|
| `type`                 | Artifact storage type                                                                  | KUBERNETES                                                    |
| `apiServer`            | Kubernetes API server URL                                                              | <https://api.ccc00alm.ccc.pre.cn0.paas.cloudcenter.corp:6443> |
| `namespace`            | Kubernetes namespace                                                                   | app360-cert-pre                                               |
| `credentialsId`        | Authentication credentials identifier                                                  | APP360_CERT_PRE_TOKEN                                         |
| `deployStrategy`       | Deployment strategy                                                                    | none                                                          |
| `application`          | Application name                                                                       | application-name-cluster                                      |
| `valuesFile`           | Additional list of values file to apply when deploying the chart.                      | values-cert.yaml                                              |
| `chartPath`            | Relative path inside the repo where chart files are located.                           | './.gluon/cd'                                                 |
| `chartUnzip`           | Optional boolean flag to tell gluon system to unzip chart tgz before making use of it. | true                                                          |
| `credentialsFromVault` | If credentials are obtained from a vault, by default: false                            | false                                                         |
| `artifact-store`       | Artifact store identifier                                                              | CI00000000001                                                 |

Infrastructure properties example:

``` yaml
properties:
  type: KUBERNETES
  apiServer: https://api.ccc00alm.ccc.pre.cn0.paas.cloudcenter.corp:6443
  namespace: project-cert-pre
  credentialsId: CERT_PRE_TOKEN
  deployStrategy: none
  application: application-name-cluster
  chartUnzip: true
  chartPath: ./.gluon/cd
  valuesFile: values-{env}.yaml
  credentialsFromVault: false
  artifact-store: CI00000000001
```

## **Registries Infrastructures**

#### Infrastructure store for **Harbor** registries

Artifact store properties table:

| Key            | Description                                          | Example                                           |
|----------------|------------------------------------------------------|---------------------------------------------------|
| `type`         | Artifact storage type                                | harbor                                            |
| `registry`     | Artifact registry URL                                | registry.global.ccc.srvb.bo.paas.cloudcenter.corp |
| `project-path` | Project path in the artifact registry                | project-cert                                      |
| `usernameId`   | Username identifier for authentication               | REGISTRY_BO_USERNAME                              |
| `passwordId`   | Password identifier for authentication               | REGISTRY_BO_PASSWORD                              |
| `snapshots`    | If it is true it will push to registry in release wf | true                                              |

Infrastructure properties example:

``` yaml
properties:
  type: harbor
  registry: registry.global.ccc.srvb.bo.paas.cloudcenter.corp
  project-path: project-cert
  usernameId: REGISTRY_BO_USERNAME
  passwordId: REGISTRY_BO_PASSWORD
  snapshots: true
```

#### Infrastructure store for **Artifactory**

Artifact store properties table:

| Key            | Description                                          | Example                      |
|----------------|------------------------------------------------------|------------------------------|
| `type`         | Type of container registry                           | artifactory                  |
| `registry`     | URL of the container registry                        | artifactory.santanderbr.corp |
| `project-path` | Project path in the registry                         | docker-snapshot/dvp          |
| `usernameId`   | ID of the user for authentication                    | ARTIFACTORY_USERNAME         |
| `passwordId`   | ID of the password for authentication                | ARTIFACTORY_PASSWORD         |
| `snapshots`    | If it is true it will push to registry in release wf | true                         |

Artifact store properties example:

``` yaml
properties:
  type: artifactory
  registry: artifactory.santanderbr.corp
  project-path: docker-snapshot/dvp
  usernameId: ARTIFACTORY_USERNAME
  passwordId: ARTIFACTORY_PASSWORD
  snapshots: true
```

#### Infrastructure store for **ECR** registries

Artifact store properties table:

| Key            | Description                                          | Example                                      |
|----------------|------------------------------------------------------|----------------------------------------------|
| `type`         | Type of container registry                           | ecr                                          |
| `registry`     | URL of the container registry                        | 000000000000.dkr.ecr.eu-west-0.amazonaws.com |
| `project-path` | Project path in the registry                         | sgt-app360                                   |
| `usernameId`   | ID of the user for authentication                    | AWS_ACCESS_KEY_ID                            |
| `passwordId`   | ID of the password for authentication                | AWS_SECRET_ACCESS_KEY_ID                     |
| `role`         | Role in AWS                                          | AccountAutomationNonPro                      |
| `snapshots`    | If it is true it will push to registry in release wf | true                                         |

Artifact store properties example:

``` yaml
properties:
  type: ecr
  registry: 000000000000.dkr.ecr.eu-west-0.amazonaws.com
  project-path: project-name
  usernameId: AWS_ACCESS_KEY_ID
  passwordId: AWS_SECRET_ACCESS_KEY_ID
  role: AccountAutomationNonPro
  snapshots: true
```

#### Infrastructure store for **ACR** registries

Artifact store properties table:

| Key            | Description                                          | Example                              |
|----------------|------------------------------------------------------|--------------------------------------|
| `type`         | Type of container registry                           | acr                                  |
| `registry`     | URL of the container registry                        | sgtacrprueba.azurecr.io              |
| `project-path` | Project path in the registry                         | sgt-app360-cert                      |
| `usernameId`   | ID of the user for authentication                    | AZ_USERNAME                          |
| `passwordId`   | ID of the password for authentication                | AZ_PASSWORD                          |
| `account`      | Azure account                                        | sgtd0glbsubgeneriglob000             |
| `tenant`       | Azure tenant ID                                      | 0000a00-0d0d-44ac-00e0-f0ab0cd000db  |
| `snapshots`    | If it is true it will push to registry in release wf | true                                 |

Artifact store properties example:

``` yaml
properties:
  type: acr
  registry: sgtacrprueba.azurecr.io
  project-path: project-cert
  usernameId: AZ_USERNAME
  passwordId: AZ_PASSWORD
  account: sgtd0glbsubgeneriglob000
  tenant: 0000a00-0d0d-44ac-00e0-f0ab0cd000db
  snapshots: true
```
