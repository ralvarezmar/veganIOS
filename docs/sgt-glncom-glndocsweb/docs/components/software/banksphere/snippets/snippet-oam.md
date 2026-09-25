# OAM Snippet

## Infrastructure
<!--Start Infrastructure-->
The company
used to create the components must have been provided the [Gluon Open Application Model](../../../../application/ci-cd/cd/cd-rm/index.md).
The deployment model uses the [`oam-application-definition.yaml`](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/oam-example.md) file
to manage infrastructure and registries in a standardized way across different platforms.

### OAM Configuration

To deploy a Gluon Banksphere assembly product, the parameters of the target infrastructure must be configured in the **Gluon Application Model** component of the technical application,
[**configuring the data**](./oam-configuration.md) necessary depending on the type of Kubernetes Cluster used.

### Configure environments

By default, the component is created with the folder cert which cover the most common use case (Banskphere laboratories only deploy on certification environment).

???+ warning "Important"

    Although only certification environment is necessary to deploy the Banksphere image, OAM Quality Assurance workflow fails if no preproduction and production environments are configured in the oam-application-definition.yml file of the Gluon Application Model component.
    So it is mandatory to configure a preproduction and a production environments with a dummy infraestructure on each.

For it to work correctly,
the name of the folder must exactly match the name of the "name" property (in the example shown below,
it would be the cert value) of the oam-application-definition.yml file of the Gluon Application Model component.

So, to define a deployment environments,
it is necessary to describe the `name` and `type` fields:

- `name`: The name of the environment. Each Application could give a different name to the environments. It must be
  unique in the oam file.
- `type`: The type of the environment. The values allowed are `certification`, `preproduction`, and `production`.

Below is an example of the configuration of a certification environment, called cert, where one infrastructure have been configured to deploy for
RedHat Openshift Cluster. Many properties have been omitted for this example, but for it to work correctly, the rest of the
mandatory data must be configured.

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI00000000001
        properties:
          type: KUBERNETES
          artifact-store: CI000000000002
          (...)

      - id: CI000000000002
        type: ARTIFACT-STORE
        properties:
          type: harbor
          registry: registry.global.ccc.srvb.can.paas.cloudcenter.corp
          project-path: bks-apps-common
          usernameId: BKS_HARBOR_CERT_USERNAME
          passwordId: BKS_HARBOR_CERT_PASSWORD
          snapshots: true
          (...)
```

The next step is to configure the `cd.yml` file,
where you can set up the infrastructures where the Gluon Banksphere assembly product will be deployed for that environment.
For each one, the following properties must be configured:

| Property | Description | Example |
|--|--|--|
| ci_id | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000097 |
| configurationFiles | Path to the Helm configuration file in that environment | .gluon/cd/values.yml |

Following the previous example from the oam-application-definition.yml file, the content of the `cd.yml` file to deploy on RedHat Openshift Cluster
and the container images on Harbor would be as follows:

``` yaml title="cd.yml"
- ci_id: CI00000000001
  configurationFiles:
  - .gluon/cd/values.yaml
```

> **Important considerations**:
>
> - The workflow will deploy on all infrastructures that are included in the cd.yml file of the environment in which it is going to be executed.
> - The infrastructures included in the cd.yml file must be registered in the environment in the oam-application-definition.yml file.
> - These values indicate where the Banksphere assembly product will be deployed. They do not depend on **GLUON**. They are specific to the application to be deployed.

For getting to know how to configure the `Gluon Open Application Model` repository associated with the company where the component is generated, the following documentation is available:

- [How to configure the Gluon Open Application Model (OAM)](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)
- [All the parameters available by type of infrastructure component](../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)
- [Kubernetes deployment examples for OAM Configuration](./oam-configuration.md)

<!--End Infrastructure-->
