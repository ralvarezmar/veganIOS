---
title: SCF Helm Deploy Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForHelmEKS` and `pipelineForHelmOCP` in Jenkins.
Note that depending on the pipeline you come from there are key differences regarding the deployment on EKS for `pipelineForHelmEKS` or Openshift in`pipelineForHelmOCP`.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about yo use this component template can be found in [documentation](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/).

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC, which must be specified in the [awsRoleName](#deploymentyaml) parameter of the `multiregistry.json` file.
Note that this template is cataloged as a `Microservice components > Brownfield`, detailed information to make the request can be found [here](../../support/credentials/brownfield.md).

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) Helm Deploy`.

![Create Component](images/helm/create-component.png)

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository migration

When scaffolding is executed, the repository will have this structure in the `development`branch, which must be respected for the workflow to work correctly:

```bash
📂.chart
 ┣ 📜values-dev.yml
 ┣ 📜values-pre.yml
 ┣ 📜values-pro.yml
📂.github
 ┣ 📂workflows
 | ┗ 📜cd.yml
 | ┗ 📜ci.yml
 | ┗ 📜release.yml
 | ┗ 📜update-component-workflow.yml
 | ┗ 📜validate-version.yml
 ┗ 📜CODEOWNERS
📂.gluon
 ┣ 📂ci
 | ┗ 📜properties.env
📜deployment.yml
```

You must take the source code of your component to the source repository  in the `development` branch and pay attention to the following adaptations:

### Deployment.yaml

The original `deployment.yml` file is modified to adapt to the new deployment in the CD process:

![Deployment](images/helm/deployment.png)

- Configuration of the `deployment.yml`:

???+ info "Deployment"

    **awsRoleName:** When using roles a `awsRoleName` under `providerParams` needs to be defined (the name of the role is expected and not the entire ARN).
    When using roles, if the pod needs credentials to consume AWS resources, it will also be necessary to reference `serviceAccountName` in
    the values files (check the [Values section](https://san-sc-we.atlassian.net/wiki/spaces/SCFCCOE/pages/edit-v2/682524691#%3Ainfo%3A-Values.yaml-para-Helm) for more information).

**EKS** Deployment example

```yaml
environments:
  - name: cert
    regions:
      - name: dev
        properties:
          application: <app-name>
          cluster:
            apiServer: <api-server-url>
            namespace: <namespace>
            provider: eks
            providerParams:
              awsAccount: <aws account id>
              awsRoleName: <role-to-assume>
              awsRegion: eu-west-1
              clusterName: <cluster-name>
          helm:
            host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
            project: scf-devops
            version: <chart-version>
            repoType: harbor
            chart: <chart-name>
  - name: pre
  ...
```

**Openshift** OSE3 Example

```yaml
environments:
  - name: cert
    regions:
      - name: dev
        properties:
          application: <app-name>
          cluster:
            apiServer: <api-server-url>
            namespace: <namespace>
            provider: ose3
          helm:
            host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
            project: scf-devops
            version: <chart-version>
            repoType: harbor
            chart: <chart-name>
  - name: pre
  ...
```

### Values.yaml for Helm

In the file `deployment.yml`, we reference the chart that we want to use. In the following example, an excerpt from `deployment.yml` is shown where we reference the chart name and its version.

```yaml title="Deployment file excerpt referencing Helm Chart" linenums="1"
helm:
  host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
  project: # chart template project
  version: # chart template version
  repoType: harbor
  chart: # chart template name
```

This chart is configured/customized using the `values-(env).yml` files explained below:

???+ info "Values files"

    The values files are stored in the repository under the .chart directory and are used to configure the Helm Chart that is parameterized to take them into account.
    There is a values file for each environment

```bash
.chart
| values-dev.yaml
| values-pre.yaml
| values-pro.yaml
```

Below is an example of `values-dev.yaml`:

???+ info "ServiceAccount Name"

    **serviceAccountname:** If the pod needs credentials to consume AWS resources, it will be necessary to reference a `serviceAccountName`.

```yaml
image:
  repository: <image to use by the pod, ex.: 000000000000.dkr.ecr.eu-west-1.amazonaws.com/example/example>
  tag: <Image tag to use. ej.: 1.0.0-SNAPSHOT>

serviceAccountName: <*name of the serviceAccount for IRSA, if applicable>
microservice: <microservice name>
trackingCode: <tracking code>
hostName: <hostname>
secretTls: <TLS secret name to use>
namespace: <Namespace>
path: /
port: <port>
replicas: <pod replicas>

Secrets:
  - <Name of the secret to us>

configurationFiles:
  - name: <name>
    data: |-
      EXAMPLE: "example"
```

**What should be modified?**

These are the changes that have been added compared to the version being used

```yaml
serviceAccountName: <* name of the serviceAccount for IRSA, if applicable>
secretTls: <name of the secret>
namespace: <namespace within the cluster>
trackingCode: <tracking code>
```

Do the same for the `pre` and `pro` environments.

### Secrets configuration

EKS deployments don’t require setting any credentials as secrets in your repository as authentication is done using roles.
**Only in Openshift**deployment cases (if you come from `pipelineForHelmOCP`), a Token is required for each environment as GitHub Repository Secrets.

To do so, go to `Settings > Security > Secrets and variables > Actions` and add the following secrets at “Repository secrets” level.

![Secrets](images/helm/secrets.png)
