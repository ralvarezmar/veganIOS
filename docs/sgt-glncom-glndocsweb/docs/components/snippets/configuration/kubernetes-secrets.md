
<!--Start Github Secrets-->

There are three types of secrets in Github.com:

- **Organization secrets**: Secrets that can be used by all repositories in the organization.
- **Repository secrets**: Secrets that can be used only by the repository.
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup Github Secrets"

    Nowadays only the *devops* team  of the entity has permissions to create the secrets in the organization.
    If you need to create a secret, please contact with the *devops* team. If you have doubts what users belongs to *devops* team, please contact with your entity Gluon Champion.

#### Deploy Secrets

Those credentials are referenced in the **deployment.yaml** file and defined at **environment secrets level**, so we have to create the secrets in each environment (CERT,PRE and PRO).

- credentialsId
- credentialUserId
- credentialPassId
- kubeconfigFile

???+ info "How to add Secrets"
    [**How to add Secrets**](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions)
<!--End Github Secrets-->

<!--Start Deployment Infra Github Secrets-->

There are three types of secrets in Github.com:

- **Organization secrets**: Secrets that can be used by all repositories in the organization.
- **Repository secrets**: Secrets that can be used only by the repository.
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup Github Secrets"

    Nowadays only the *devops* team  of the entity has permissions to create the secrets in the organization.
    If you need to create a secret, please contact with the *devops* team. If you have doubts what users belongs to *devops* team, please contact with your entity Gluon Champion.

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

For getting more information about the authentication keys,
please refer to [Parameters available by type of infrastructure component](../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)

???+ info "How to add Secrets"
[**How to add Secrets**](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions)
<!--End Deployment Infra Github Secrets-->