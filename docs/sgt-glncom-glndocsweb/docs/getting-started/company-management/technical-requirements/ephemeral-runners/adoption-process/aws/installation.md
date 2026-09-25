---
Title: AWS Installation
---

## Introduction

Description of the process about how to deploy hosted runners at AWS. It comprehends two main parts: ARC runner scaler controller and runner scale set.

- ARC Runner Scaler Controller: This component manages the escalation of the runners, driving Runner Scale Set.
- Runner Scaler Set: This component is the responsible of create the runners and manage it under the instructions of ARC runner scaler controller.

### Cluster and nodes requirements

The team deploying ephemeral runners have two options. One option is to deploy these runners in a dedicated cluster. The second option is, if the team wants to deploy it on a shared cluster, they must make use of node groups in the cluster.

It is highly recommended to use node selector parameter in the templates or values files when using a shared cluster to avoid resource consumption interference between apps and ephemeral runners.

To use the caches, the eks cluster must have the efs driver running. If you want to use the runners without caches, you must disable the caches in the runners that use them, explained in [Administration and Maintenance Scaler Set - Values.](./administration-and-maintenance.md/)

## Scale Set Controller

#### Pre-requisites

1. ECR for gha-runner-scale-set-controller image
2. EKS Namespace for the controller
3. Authentication credentials with GitHub App Permissions:
    1. Metadata: Read-only
    2. Self-hosted runners: Read and write
4. Working credentials for EKS

### Installation

Below these are the steps to install Scale Set Controller

#### Uploading the image of the Scale Set Controller to ECR

To make the image available across the AWS cluster we need to store it in ECR.

##### Gluon Platform

Create the repository environment secrets for dev, pre, pro environments:

```yaml
AWS_ACCESS_KEY_ID - AWS Access Key ID credential
AWS_SECRET_ACCESS_KEY - AWS Access Secret Key credential
AWS_ACCOUNT_ID - AWS Account ID of the ECR
AWS_REGION - Region where the account is in
AWS_ROLE_NAME - Role to assume to work with the ECR
```

With these secrets created in the repository environments, we use the workflow on .github/workflows/controller-image.yaml

##### Others

Check with the local team on how to upload the necessary image from `ghcr.io/actions/gha-runner-scale-set-controller:0.9.3` to their ECR.

#### Secret creation

1. Create a local file with the GitHub App private key (for example: private.key) to avoid issues when reading a multiline private key from environment variables or from the command line in one single command.

2. ```console

    kubectl create secret generic pre-defined-secret \
         --namespace=arc-ORG1-ENV \
         --from-literal=github_app_id=123456 \
         --from-literal=github_app_installation_id=654321 \
         --from-file=github_app_private_key=private.key```

#### Proxy Certificates

To allow communication between AWS and internal network, we need to create a configmap with the Umbrella's Proxy certificate.
Using kubectl:

1. Create local file for the umbrella.crt and paste the content of the certificate.
2. launch the command and point to the certificate file:
``` kubectl create configmap umbrella.crt --namespace=arc-controller-namespace --from-file=ca.crt=./umbrella.crt ```

#### Modifying values.yaml

Modify the values.yaml file for the current installation. More information about customization [HERE](./customization-and-scaling.md)

##### Gluon Platform

[https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set-controller/values.yaml](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set-controller/values.yaml)

##### Original values.yaml

[https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set-controller/values.yaml](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set-controller/values.yaml)

#### Installing the chart using Helm

``` helm upgrade --install arc-controller --namespace arc-controller-namespace -f ./inventory/gha-runner-scale-set-controller/values.yaml oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller --version 0.9.3 ```

It might give a TSL error in which case, for testing and troubleshooting we can add the argument `--insecure-skip-tls-verify` at the end of the previous installation command.

## Runner Scaler Set

#### Pre-requisites

1. ECR for runner images
2. EKS Namespace for the controller
3. Authentication credentials with GitHub App Permissions:
      1. Metadata: Read-only
      2. Self-hosted runners: Read and write
4. Working credentials for EKS

### Installation

Below these are the steps to install Scaler Set

#### Upload the runner to the ECR

1. Gluon Platform - Nothing to do, already automated

2. Others - They should know.

#### Upload the runner images to the ECR

To make the runner images available across the AWS cluster we need to store it in ECR.

##### Gluon Platform

We don't need to add any image to any ECR as the creation of the runners images uploads the images to our ECRs.

##### Others

Check the available images we create and use in the [Image Governance Documentation](../../image-governance.md).

#### Secret Creation

1. Create a local file with the GitHub App private key (for example: private.key) to avoid issues when reading a multiline private key from environment variables or from the command line in one single command.

2. ```console

    kubectl create secret generic pre-defined-secret \
        --namespace=arc-ORG1-ENV \
        --from-literal=github_app_id=123456 \
        --from-literal=github_app_installation_id=654321 \
        --from-file=github_app_private_key=private.key```

#### Proxy Certificates

To allow communication between AWS and internal network, we need to create a configmap with the Umbrella's Proxy certificate.
Using kubectl:

1. Create local file for the umbrella.crt and paste the content of the certificate.
2. launch the command and point to the certificate file:
``` kubectl create configmap umbrella.crt --namespace=arc-controller-namespace --from-file=ca.crt=./umbrella.crt ```

#### Modify the values.yaml file for the current installation

##### Gluon Platform

[https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set/values.yaml](https://github.com/santander-group-gluon/gln-plat-arc-aws-deployment/blob/main/inventory/gha-runner-scale-set/values.yaml)

##### Original values.yaml

[https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml)

#### Installing the chart

```helm upgrade --install arc-ORG1-ENV --namespace arc-ORG1-ENV -f ./inventory/gha-runner-scale-set/values.yaml oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set --version 0.9.3```

It is important to note that the scale-set is composed of two pods:

1. The `scale-set-listener` which is a slave controller that works only for the deployed runner and is the one to communicate with the controller pod and that scales the runner when needed.

    **This pod is created in the controller namespace.**

2. The `runner` deployed scaled to the desiret min/max numbers.

### Other sections in AWS adoption process

<div class="cards row-2" markdown>

- #### AWS Customization and Scaling

    ---
    Customize and Scale your runners in AWS

    [:rocket: AWS Customization/Scaling](./customization-and-scaling.md/)

- #### AWS ephemeral runners administration and maintenance

    ---
    AWS ephemeral runners administration and maintenance

    [:question: Administration and Maintenance](./administration-and-maintenance.md/)

</div>
