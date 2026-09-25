# **Gluon Application Model (OAM) Configuration**

This is an example of a README Doc of a component has been created using the template "Gluon Application Model" "1.0.0" with
the Gluon Application Component Template.

For more information on how to use this component, please refer to
the [Gluon Application Component](https://gluon.gs.corp/community/docs/latest/develop/component/catalog/app-component/){:target="_blank"}

## **Folder Structure**

The component has the following folder structure:

```plaintext
|- 📂 .github
|     |- 📂 workflows                      # Contains the workflows responsible for the lifecycle of an Application type component.
|     |  |- 📄 quality.yml                 # Quality workflow. Responsible for validating the sanitization of the Definition file of the application.
|  |  |  |- 📄 staging.yml                 # Staging workflow. This workflow is triggered by a push on the main branch and creates a new tag with the version defined in the OAM application model file or recreates the tag if it already exists.
|  |  |  |- 📄 release.yml                 # Release workflow. Creates a new release for the Gluon Application component.
|  |  |  |- 📄 dast.yml                    # DAST workflow. Workflow dispatched to run DAST scan on the Gluon Application component.
|  |- 📂 .gluon                            # Contains the files handle the Gluon Application Component.
|  |  |- 📂 security                       # Contains the files handle the DAST security properties for the Gluon Application Component.
|  |  |  |- 📄 dast.yml                    # DAST configuration file. Contains the configuration for the DAST scan.
|  |- 📄 README.md                         # Documentation of the Application Template. File automatically generated with the execution of the scaffolding.
|  |- 📄 oam-application-definition.yml    # Definition file of the OAM application associated with the Gluon application. It will allow us to define the structure of environment trails, as well as the infrastructure of the application.
```

## **Usage and instructions**

Please note, this repository is a mirror of the 'Application Component Template' card in the Gluon Portal.

Define your Open Application model associated with the Gluon application
in (Example) [oam-application-definition.yml](oam-example.md){:target="_blank"} file.

### :rocket: **Quick Start**

1. Clone the repository.
2. Modify the files as needed. The main file to be modified is the [`oam-application-definition.yml`](oam-example.md){:target="_blank"} file. This file
   contains the definition of the OAM application associated with the Gluon application.
3. Push the changes to the repository.
4. Create a New Release in the repository.

## **Gluon Open Application Model (OAM)**

The Open Application Model (OAM) is a specification for defining applications that can be deployed and managed in a
standardized way across different platforms. In this project, we are going based on OAM to define the structure of our
application and its trails and environments for the Gluon Applications.

### **Gluon OAM Application Definition**

The main file for defining our OAM application is [`oam-application-definition.yml`](oam-example.md){:target="_blank"}.

This file contains the definition of the OAM application associated with the Gluon application. It allows us to define
the structure of environment trails, as well as the infrastructure of the application.

#### **Environments**

An environment is a set of infrastructure resources that are used to deploy an application. Each environment has a
`name`, `type`, and `infrastructures`.

- `name`: The name of the environment. Each Application could give a different name to the environments. It's must be
  unique in the oam file.
- `type`: The type of the environment. The values allowed are `certification`, `preproduction`, and `production`.
- `infrastructures`: The infrastructure IDs associated with the documentation in the CMDB tool and the properties of the
  infrastructure. Each element defined in the `infrastructures` is mapped with an item in the CMDB tool. Each infrastructure
  has an `id` and `properties` set as key value.

#### **Trails**

A trail is a sequence of environments that an application passes through during its deployment. Remember that each trail
must be sorted by the deployment rightly sequence.

In the `trails` section, we define the deployment trails for our application. Each trail has:

- `name`: It's the name of the trail. It must be unique in the oam file.
- `environments`: The environments that the application passes through during its deployment. Each environment has:
  - `name`: Must be existed in the `environments` section.
  - `order` The `order` is the sequence of the environment in the deployment trail.

> For this first version we're going only to define the environments and the trails for the production environment.

#### **Components**

In this section, the application components are defined. Each component has a
`name`, a `version`, and a list of dependencies. The complete list of components
and their interrelations forms the full picture of the application's version.

- `name`: The name of the component.
- `version`: The version of the component. It must exist in GitHub as a tag.
- `needs`: The dependencies of the component. Each dependency has:
  - `name`: The name of the dependency as defined in the component list in this
  same section.

This list of components is used during the deployment of an application release
to orchestrate the deployment order of the components. If a component has
dependencies, those dependencies are deployed before the component itself. By
also defining the version of the component in this list, the deployment
orchestration process will not redeploy the component if it has already been
deployed in the environment.

### **Modifying the Gluon OAM Application Definition**

To modify the Gluon OAM application definition:

1. Clone the repository.
2. Open the [`oam-application-definition.yml`](oam-example.md){:target="_blank"} file.
3. Make the necessary modifications.
4. Push the changes to the repository.

In this file you can define the structure of the environment trails, as well as the infrastructure of the application.

The following is only an example of how to define the environment trails and the infrastructure of the application, you
can modify it according to your needs.

:exclamation: <u>**Please note that the infrastructure ID and the registry ID must be different in any case and never coincide. There should also be no duplicates in the OAM for any of the IDs, making them a unique and unambiguous key.**</u>

Examples of OAM:

=== "application.yaml"

```yaml
## Define your environment information
kind: application
version: v1
metadata:
  name: {{application.name}}              # Application Name
  version: {{application.version}}        # Version of the Application. It must be unique and exist in GitHub as a tag
#############################################################################################################################
# Define your environment information                                                                                       #
# See Documentation for more information https://gluon.gs.corp/community/docs/latest/develop/component/release-management/  #
#                                                                                                                           #
# environments:                                                                                                             #
#   - name: AKS_CERTIFICATION      # B.e the certification Name                                                             #                                                  #
#     type: certification          # Environment Type values Allowed are certification, preproduction, production           #
#     infrastructures:                                                                                                      #
#       - id: CI00000000004.       # List Infrastructure IDs associated with the documentation in the CMDB tool             #
#         properties:              # Infrastructure Properties. Depends on the type of infrastructure. Set key values for   #
#                                  # the properties.                                                                        #
#           name: ibm-intranet-client-gluon-apic-scib                                                                       #
#           type: API_IBM_CONNECT                                                                                           #
#############################################################################################################################

## Remove the sample values and replace them with your environment information
environments:
  - name: pro-shadow
    type: production
    infrastructures:
      - id: CI00000000008
        properties:
          type: KUBERNETES
          apiServer: https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443
          namespace: gluon-zt
          registry: registry.global.ccc.srvb.can.paas.cloudcenter.corp
  - name: live
    type: production
    infrastructures:
      - id: CI00000000009
        properties:
          type: KUBERNETES
          apiServer: https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443
          namespace: gluon-zt
          registry: registry.global.ccc.srvb.can.paas.cloudcenter.corp

################################################################################################################
# Define the Deployment trails production for your application                                                  #
# trails:                                                                                                      #
#   - name: deploy-on-all-pro-environments                                                                     #
#     environments:                                                                                            #
#       - name: pro-shadow                                                                                     #
#         order: 1                                                                                             #
#       - name: live                                                                                           #
#         order: 2                                                                                             #
#   - name: deploy-on-shadow                                                                                   #
#     environment:                                                                                             #
#       - name: pro-shadow                                                                                     #
#         order: 1                                                                                             #
################################################################################################################
## Remove the sample values and replace them with your trails information
trails:
  - name: deploy-on-all-pro-environments
    environments:
      - name: pro-shadow
        order: 1
      - name: live
        order: 2

  - name: deploy-on-shadow
    environments:
      - name: pro-shadow
        order: 1
  - name: deploy-on-live
    environments:
      - name: live
        order: 1
```

## **More Info**

- [OAM Parameters](gluon-application-model-oam-params.md){:target="_blank"}
- [OAM Example](oam-example.md){:target="_blank"}
