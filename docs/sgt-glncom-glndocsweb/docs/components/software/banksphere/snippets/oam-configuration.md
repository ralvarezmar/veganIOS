# Kubernetes deployment examples for OAM Configuration

For each technology, we must configure the infrastructure data specific to that technology.
The provided information will be used during the deployment of the Banksphere components.
The configuration properties can vary based on the infrastructure in which the component is published.

The infrastructure data will be configured in the Gluon Application Model component created in the application where components are going to be deployed.
Each of the infrastructure configurations included in the component has a unique identifier (ci_id) for each configured environment.

> **IMPORTANT:** The absence or incorrect configuration of the infrastructure parameters can cause deployment or execution errors of the components.

## **Deployment Infrastructures**

### Infrastructure data for RedHat Openshift Cluster

Infrastructure properties table:

| Key | Description | Example |
|--|--|--|
| `type` | Artifact storage type | KUBERNETES |
| `artifact-store` | Artifact store identifier | CI00000000001 |

> **IMPORTANT**: The Bankpshere certification infraestructure (apiServer, namespace and credentialsId) will be automatically configured during the certification deployment process, so any values of these properties specified in this file will be ignored.

Infrastructure properties example:

``` yaml
properties:
  type: KUBERNETES
  artifact-store: CI00000000001
```

## **Registries Infrastructures**

#### Infrastructure store for **Harbor** registries

Artifact store properties table:

| Key | Description | Example |
|--|--|--|
| `type` | Artifact storage type | harbor |
| `registry` | Artifact registry URL. For Banksphere certification Harbor registry this value must be **registry.global.ccc.srvb.can.paas.cloudcenter.corp** | registry.global.ccc.srvb.can.paas.cloudcenter.corp |
| `project-path` | Project path in the artifact registry. For Banksphere certification Harbor registry this value must be **bks-apps-common** | bks-apps-common |
| `usernameId` | Username identifier for authentication. For Banksphere certification Harbor registry this value must be **BKS_HARBOR_CERT_USERNAME** | BKS_HARBOR_CERT_USERNAME |
| `passwordId` | Password identifier for authentication. For Banksphere certification Harbor registry this value must be **BKS_HARBOR_CERT_PASSWORD** | BKS_HARBOR_CERT_PASSWORD |
| `snapshots`| If it is true it will push to registry in release workflow | true |

Infrastructure properties example:

``` yaml
properties:
  type: harbor
  registry: registry.global.ccc.srvb.can.paas.cloudcenter.corp
  project-path: bks-apps-common
  usernameId: BKS_HARBOR_CERT_USERNAME
  passwordId: BKS_HARBOR_CERT_PASSWORD
  snapshots: true
```
