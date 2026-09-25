# OAM Snippet

## Infrastructure
<!--Start Infrastructure 2.0-->
The company
used to create the components must have been provided the [Gluon Open Application Model](../../../../application/ci-cd/cd/cd-rm/index.md).
The deployment model uses the [`oam-application-definition.yaml`](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/oam-example.md) file
to manage infrastructure and registries in a standardized way across different platforms.

### OAM Configuration

To deploy a Gluon Component, the parameters of the target infrastructure must be configured in the **Gluon Application Model** component of the technical application,
[**configuring the data**](./oam-configuration.md) necessary depending on the type of Kubernetes Cluster used.

### Configure environments

By default, the component is created with the folders cert, pre, and pro, which cover the most common use case.
Each of these folders corresponds to an environment in which
you want to deploy the Gluon Component.
If, for example, you want to deploy in two production environments called pre-pro and back-pro,
the folder structure that should be created in the
cd folder is dev, pre, pre-pro, and back-pro, each with the `cd.yml` file where the infrastructure to be deployed must be configured.

For it to work correctly,
the name of the folder must exactly match the name of the "name" property (in the example shown below,
it would be the cert value) of the oam-application-definition.yml file of the Gluon Application Model component.

So, to define a deployment environments,
it is necessary to describe the `name` and `type` fields:

- `name`: The name of the environment. Each Application could give a different name to the environments. It must be
  unique in the oam file.
- `type`: The type of the environment. The values allowed are `certification`, `preproduction`, and `production`.

Below is an example of the configuration of a certification environment, called cert, where one infrastructure have been configured to deploy for
Amazon Elastic-Kubernetes Service Cluster. Many properties have been omitted for this example, but for it to work correctly, the rest of the
mandatory data must be configured.

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI00000000001
        properties:
          type: KUBERNETES
          apiServer: https://12345asdfg67890hjkl.sk1.eu-west-1.eks.amazonaws.com
          namespace: gluon-back-java
          credentialUserId: AWS_ACCESS_KEY_ID
          credentialPassId: AWS_SECRET_ACCESS_KEY_ID
          provider: eks
          cloud: aws
          account: 123456789012
          role: AccountAutomationNonPro
          region: eu-west-1
          clusterName: sgtd1aireksgluondeksd111
          artifact-store: CI000000000002
          (...)

      - id: CI000000000002
        type: ARTIFACT-STORE
        properties:
          type: ecr
          registry: 12345asdfg67890hjkl.dkr.ecr.eu-west-1.amazonaws.com
          project-path: project-anme
          usernameId: AWS_ACCESS_KEY_ID
          passwordId: AWS_SECRET_ACCESS_KEY_ID
          role: AccountAutomationNonPro
          snapshots: true
          (...)
```

!!! info "Cluster Authentication"

    There are three ways to authenticate against a Cluster:
    
      - **credentialsId**: Use property credentialsId setting the name of the github secret storing the token. **This is the recommended method**.
      - **credentialUserId** / **credentialPassId**: Use properties credentialsUserId/credentialsPassId placing there github secret names with username and password to use to authenticate with server.
      - Verify that the user have the necessary permissions to deploy in the cluster and in the artifact store.
      - **Using Hashicorp Vault**: The system will automatically search in the Hashicorp Vault for the deployment secret

The next step is to configure the `cd.yml` file,
where you can set up the infrastructures where the Gluon Microservice will be deployed for that environment.
For each one, the following properties must be configured:

| **Property**       | **Description**                                                             | **Example**                    |
|--------------------|-----------------------------------------------------------------------------|--------------------------------|
| ci_id              | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000097                  |
| configurationFiles | Path to the Helm configuration file in that environment                     | .gluon/cd/cert/values-cert.yml |

Following the previous example from the oam-application-definition.yml file, the content of the `cd.yml` file to deploy on Amazon Elastic-Kubernetes Service (EKS)
and the container images on Amazon Elastic Container Registry (ECR) would be as follows:

``` yaml title="cd.yml"
- ci_id: CI00000000001
  configurationFiles:
  - .gluon/cd/cert/values-cert.yaml
  - .gluon/cd/values.yaml
```

> !IMPORTANT - Considerations:
>
> - The workflow will deploy on all infrastructures that are included in the cd.yml file of the environment in which it is going to be executed.
> - The infrastructures included in the cd.yml file must be registered in the environment in the oam-application-definition.yml file.
> - These values indicate where the microservice will be deployed. They do not depend on **GLUON**. They are specific to the application to be deployed.

For getting
to know
how to configure the `Gluon Open Application Model` repository
associated with the company where the component is generated,
the following documentation is available:

- [How to configure the Gluon Open Application Model (OAM)](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)
- [All the parameters available by type of infrastructure component](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)
- [Kubernetes deployment examples for OAM Configuration](./oam-configuration.md)

<!--End Infrastructure 2.0-->

<!--Start Infrastructure Registry 2.0-->
The company used to create the components must have been provided the [Gluon Open Application Model](../../../../application/ci-cd/cd/cd-rm/index.md).
The deployment model uses the [`oam-application-definition.yaml`](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/oam-example.md) file
to manage infrastructure and registries in a standardized way across different platforms.

### OAM Configuration

To upload an image to a registry the parameters of the target infrastructure must be configured in the **Gluon Application Model** component of the technical application.
See the Registries Infrastructures [**here**](./oam-configuration.md) for more information on how to configure the access to registries.

### Configure environments

By default, the component is created with the folders cert, pre, and pro, which cover the most common use case.
Each of these folders corresponds to an environment in which
you want to upload your image.
If, for example, you want to upload in two production environments called pre-pro and back-pro,
the folder structure that should be created in the
cd folder is dev, pre, pre-pro, and back-pro, each with the `cd.yml` file where the infrastructure to be deployed must be configured.

For it to work correctly,
the name of the folder must exactly match the name of the "name" property (in the example shown below,
it would be the cert value) of the oam-application-definition.yml file of the Gluon Application Model component.

So, to define a deployment environments,
it is necessary to describe the `name` and `type` fields:

- `name`: The name of the environment. Each Application could give a different name to the environments. It must be
  unique in the oam file.
- `type`: The type of the environment. The values allowed are `certification`, `preproduction`, and `production`.

Below is an example of the configuration of a certification environment deployment , called cert, where we have some registries configured. In our cd.yml
we need to point to CI000000000001 to use the artifact store CI000000000002.

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI000000000001
        type: KUBERNETES
        properties:
          type: KUBERNETES
          apiServer: someendpoint
          namespace: app360-cert-pre
          application: somename
          chartPath: somePath
          parameters: "{ parameter1: value1, parameter2: value2 }"
          valuesFile: "[ values-cert-oc-harbor.yaml ]"
          credentialsFromVault: true
          authType: token
          artifact-store: CI000000000002

      - id: CI000000000002
        type: ARTIFACT-STORE
        properties:
          type: ECR
          registry: 12345asdfg67890hjkl.dkr.ecr.eu-west-1.amazonaws.com
          project-path: project-anme
          usernameId: AWS_ACCESS_KEY_ID
          passwordId: AWS_SECRET_ACCESS_KEY_ID
          role: AccountAutomationNonPro
          snapshots: true
          (...)
```

The next step is to configure the `cd.yml` file,
where you can set up the infrastructures where the images will be uploaded for that environment.
For each one, the following property must be configured:

| **Property**       | **Description**                                                                          | **Example**                    |
|--------------------|------------------------------------------------------------------------------------------|--------------------------------|
| ci_id              | Identifier of the infrastructure of deployment( Kubernetes for example) in the oam config| CI00000000001                  |

The cd file should contain something like this:

``` yaml title="cd.yml"
- ci_id: CI00000000001
```

> !IMPORTANT - Considerations:
>
> - The workflow will upload on all infrastructures that are included in the cd.yml file of the environment in which it is going to be executed.
> - The infrastructures included in the cd.yml file must be registered in the environment in the oam-application-definition.yml file.
> - These values indicate where the image will be uploaded. They do not depend on **GLUON**. They are specific to the application to be deployed.

For getting
to know
how to configure the `Gluon Open Application Model` repository
associated with the company where the component is generated,
the following documentation is available:

- [How to configure the Gluon Open Application Model (OAM)](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)
- [All the parameters available by type of infrastructure component](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)
- [Kubernetes deployment examples for OAM Configuration](./oam-configuration.md)

<!--End Infrastructure Registry 2.0-->
