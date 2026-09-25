---
title: Open Application Model
---

??? tips "What's New"

    Starting from version __6.3.0__ of Gluon, releases are made at the application level. An application release is a
    set of components deployed together. Each component has a version and can have dependencies on other components.

    The OAM application definition file has been updated to include the `components` node. This node allows
    the definition of application component versions as specified in the application release.

## What is a Gluon Application Component?

The Gluon Application Component provides a centralized place to set up all functionalities and properties of a
Gluon technical application. Processes or configurations specific to a single component are associated with
its component. This application-type component houses configurations that do not fit at the component level
and are inherent to the Gluon application construct.

For example, the DAST type security analysis is not applied to a single component but must be executed for all
components that make up an application.

### Gluon Application Component Functionalities

The Gluon Application Component manages APM technical application-level configurations and processes. Currently,
available processes and functionalities include:

- `DAST`: Dynamic Application Security Testing
- `OAM`: Application Releases: Manage the application's releases with a Gluon Open Application model definition file.

## Comprehensive Guide to Project Structure and File Roles

This component was created from
[Gluon Component Base Template](https://github.com/santander-group-shared-assets/gln-base-component-template).

The project consists of several files and folders described below:

```text
|- 📂 .github
|  |- 📂 workflows                         # Contains workflows for publishing the Gluon Application Model in Component Manager.
|  |  |- 📄 component-template-publish.yml # Workflow that runs automatically when publishing the Gluon Application Model.
|  📄 setup.sh                             # Script orchestrating the invocation of the archetype and file management for the Gluon Application Component.
|- 📄 README.md                            # Documentation of the Gluon Application Component.
|- 📄 presentation-schema.json             # Configuration file defining the structure and layout of the form.
|- 📄 definition.yml                       # Gluon Portal template metadata related to the component name, version, description, documentation link, contact information, etc.
|- 📄 data-schema.json                     # Describes the component's data structure.
|- 📂 src                                  # Contains information about the Application Template.
|  |- 📂 .github
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

## Usage and instructions

Please note, this repository is a mirror of the 'Gluon Application Model' card in the Gluon Portal. If
modifications are required for this card, such as the addition of a field, they must be implemented here.

There are files and folders with identical names, so exercise caution to ensure you're modifying the correct structure -
whether it's the Base Component Template structure or the Component Template template structure.

### :rocket: Quick Start

1. Create a new Gluon Application Component by using the Gluon Portal.
2. Select the 'Gluon Application Model' card.
3. Fill in the required fields.
4. Click on the 'Create' button.
5. The Gluon Portal will generate a new repository with the Gluon Application Model structure.
6. Clone the repository.
7. Modify the files as needed. The main file to be modified is the `oam-application-definition.yml` file. This file
   contains the definition of the OAM application associated with the Gluon application.
8. Push the changes to the repository.

## Gluon Open Application Model (OAM)

The Open Application Model (OAM) is a specification for defining applications that can be deployed and managed in a
standardized way across different platforms. In this project, we are going based on OAM to define the structure of our
application and its trails and environments for the Gluon Applications.

### Gluon OAM Application Definition

The main file for defining our OAM application is `oam-application-definition.yml`.

This file contains the definition of the OAM application associated with the Gluon application. It allows us to define
the structure of environment trails, as well as the infrastructure of the application.

#### Environments

An environment is a set of infrastructure resources that are used to deploy an application. Each environment has a
`name`, `type`, and `infrastructures`.

- `name`: The name of the environment. Each Application could give a different name to the environments. It's must be
  unique in the oam file.
- `type`: The type of the environment. The values allowed are `certification`, `preproduction`, and `production`.
- `infrastructures`: The infrastructure IDs associated with the documentation in the CMDB tool and the properties of the
  infrastructure. Each element defined in the `infrastructures` is mapped with an item in the CMDB tool. Each infrastructure
  has an `id` and `properties` set as key value.
  
#### Trails

A trail is a sequence of environments that an application passes through during its deployment. Remember that each trail
must be sorted by the deployment rightly sequence.

In the `trails` section, we define the deployment trails for our application. Each trail has:

- `name`: It's the name of the trail. It must be unique in the oam file.
- `environments`: The environments that the application passes through during its deployment. Each environment has:
  - `name`: Must be existed in the `environments` section.
  - `order` The `order` is the sequence of the environment in the deployment trail.

#### Components

!!! Tip
    When archiving an OAM component, this component needs to be removed from the list into the OAM definition file.

The `components` node allows the definition of which component versions are delivered into an application release.

This section is composed by a list of components with the following attributes:

- `name`: The name of the component. Each application can assign a different name to its components. It must be unique
  within the OAM file. The component must be exist in Gluon and it must be associated with the application.
- `version`: The version of the component. It must be unique and exist as a tag in GitHub.
- `need`: An array of components that the current component depends on. These components must be defined in the `components` section.

Example of components section:

components:
    -   name: component-one
        version: 1.0.0
        needs: []
    -   name: component-two
        version: 1.1.0
        needs: [ component-one]
    -   name: component-three
        version: 2.1.0
        needs: [component-one, component-two]

### Modifying the Gluon OAM Application Definition

To modify the Gluon OAM application definition:

1. Clone the repository.
2. Open the `oam-application-definition.yml` file.
3. Make the necessary modifications.
4. Push the changes to the repository.

In this file you can define the structure of the environment trails, as well as the infrastructure of the application.

The following is only an example of how to define the environment trails and the infrastructure of the application, you
can modify it according to your needs.

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
# Define the Deployment trails production for you application                                                             #
# trails:                                                                                                      #
#   - name: default-env-trails                                                                                 #
#     environments:                                                                                            #
#       - name: pro-shadow                                                                                     #
#         order: 1                                                                                             #
#       - name: live                                                                                           #
#         order: 2                                                                                             #
#   - name: deploy-on-shadow                                                                                 #
#     environment:                                                                                             #
#       - name: pro-shadow                                                                                            #
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

components:
    -   name: rm-tst-configmap-tst
        version: 1.0.0
        needs: [ ]
    -   name: rm-tst-configmap-arsenal-microservice
        version: 1.0.0
        needs: [ ]
    -   name: rm-tst-configmap-darwin-microservice-02
        version: 1.0.0
        needs: [ ]
    -   name: rm-tst-configmap-arsenal-microservice-02
        version: 1.0.0
        needs: [ ]
    -   name: rm-tst-darwin-microservice
        version: 1.0.0
        needs: [ rm-tst-configmap-tst ]
    -   name: rm-tst-arsenal-microservice
        version: 1.0.0
        needs: [ rm-tst-configmap-arsenal-microservice ]
    -   name: rm-tst-darwin-microservice-02
        version: 1.0.0
        needs: [ rm-tst-configmap-darwin-microservice-02, rm-tst-darwin-microservice ]
    -   name: rm-tst-arsenal-microservice-02
        version: 1.1.1
        needs: [ rm-tst-configmap-arsenal-microservice-02, rm-tst-arsenal-microservice ]
    -   name: rm-tst-darwin-micro-frontend
        version: 1.0.0
        needs: [ rm-tst-darwin-microservice-02, rm-tst-darwin-microservice ]
    -   name: rm-tst-arsenal-micro-frontend
        version: 1.0.0
        needs: [ rm-tst-arsenal-microservice-02, rm-tst-arsenal-microservice ]

```

## DAST Configuration

Dynamic Application Security Testing (DAST) is a security testing technique that analyzes running applications for
vulnerabilities. It simulates attacks and assesses security from the outside.

The DAST configuration file will be located in the `.gluon/security` folder. The file is named `dast.yml`.

This file contains the configuration for the DAST scan:

- Certification DNS
- Preproduction DNS

## :exclamation: Key Points

- Each application in the Gluon Portal can have only one associated Gluon Application Component.
- In the initial version, the release process deploys the application only in the production environment. Future
  versions will support deployment in other environments.
- For this initial version, each component is deployed independently in the production environment and associated with
  the same application release.
- Each repository tag must have a unique version.

## Gluon Official Documentation

It's highly recommended to take a moment to read the entire documentation before starting to use this repository. By
doing so, you can stay updated with workflow rules, new features, and other relevant information.

- [Gluon Release Management](./../zero-touch/index.md)
