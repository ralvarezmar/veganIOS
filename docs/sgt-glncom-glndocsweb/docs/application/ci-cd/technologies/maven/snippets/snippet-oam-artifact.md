# OAM Snippet

## Infrastructure
<!--Start Infrastructure 2.0-->
<!-- infrastructure-description-start -->
The company
used to create the components must have been provided the [Gluon Open Application Model](../../../../../application/ci-cd/cd/cd-rm/index.md).
The deployment model uses the [`oam-application-definition.yaml`](../../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/oam-example.md) file
to manage infrastructure and registries in a standardized way across different platforms.

### OAM Configuration

To deploy a Gluon artifact, the parameters of the target infrastructure must be configured in the **Gluon Application Model** component of the technical application,
[**configuring the data**](./oam-configuration-artifact.md) necessary depending on the type of infrastructure.

### Configure environments

By default, the component is created with the folders cert, pre, and pro, which cover the most common use case.
Each of these folders corresponds to an environment in which
you want to deploy the Gluon artifact.
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

Below is an example of the configuration of a certification environment, called cert, where one infrastructure have been configured to deploy for VM. Many properties have been omitted for this example, but for it to work correctly, the rest of the
mandatory data must be configured.
<!-- infrastructure-description-end -->

``` yaml title="oam-application-definition.yml"
environments:
  - name: cert
    type: certification
    infrastructures:
      - id: CI000000000001
        type: ANSIBLE
        properties:
          type: ANSIBLE
          ansibleCredentialUser: ANSIBLECREDENTIALUSER_CERT
          ansibleCredentialPassword: ANSIBLECREDENTIALPASSWORD_CERT
          inventoryGit: santander-group-gluon-test/devsecops.products.file-transfer-unix-inventory-test
          inventoryGitBranch: gluon-test-ansible
          inventory: CERT/host
          limit: CERT
          tag: 1.0.0
          disableMitogen: false
          ansibleGalaxy: false
      - id: CI000000000002
        type: ARTIFACT-STORE
        properties:
          type: ANSIBLE
          winrmCredentialUser: ANSIBLECREDENTIALWINUSER_CERT
          winrmCredentialPassword: ANSIBLECREDENTIALWINPASSWORD_CERT
          limit: HOST2
          tag: 1.0.0
          disableMitogen: false
          mitogenStrategy: mitogen_free
          mitogenVersion: 0.3.3
          ansibleGalaxy: true
          requirements: test-requirements.yml
```

!!! info "Authentication"

    There are two ways to authenticate:
    
      - **Credential to connect to linux machine by ssh (SSH or user password)**: Use property ansibleCredentialUser and ansibleCredentialPassword parameters.
      - **User-password credential to connect to windows machine by winrm**: Use properties winrmCredentialUser/winrmCredentialPassword placing there github secret names with username and password to use to authenticate with server.
  
<!-- infrastructure-cd-start -->  
The next step is to configure the `cd.yml` file,
where you can set up the infrastructures where the Gluon artifact will be deployed for that environment.
For each one, the following properties must be configured:

| **Property**       | **Description**                                                             | **Example**                    |
|--------------------|-----------------------------------------------------------------------------|--------------------------------|
| ci_id              | Identifier of the infrastructure in the oam-application-definition.yml file | CI00000000001                  |

Following the previous example from the oam-application-definition.yml file, the content of the `cd.yml` would be as follows:

``` yaml title="cd.yml"
- ci_id: CI00000000001
```

> !IMPORTANT - Considerations:
>
> - The workflow will deploy on all infrastructures that are included in the cd.yml file of the environment in which it is going to be executed.
> - The infrastructures included in the cd.yml file must be registered in the environment in the oam-application-definition.yml file.

For getting
to know
how to configure the `Gluon Open Application Model` repository
associated with the company where the component is generated,
the following documentation is available:

- [How to configure the Gluon Open Application Model (OAM)](../../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-config.md)
- [All the parameters available by type of infrastructure component](../../../../../application/ci-cd/cd/cd-rm/gluon-application-model-oam/oam-config-and-params/gluon-application-model-oam-params.md)

<!-- infrastructure-cd-end -->  
<!--End Infrastructure 2.0-->
