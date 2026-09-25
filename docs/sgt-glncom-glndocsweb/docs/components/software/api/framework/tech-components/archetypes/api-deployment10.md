>IMPORTANT: This archetype is deprecated, it is recommended that the creation of new API Deployment components is done with the [**API Deployment 2.0 component.**](../../../../../../architecture/tech-stack/snippets/apis/apis.md).

The archetype for APIs deployment can handle different API Managers (currently, on Apigee OPDK and IBM API Connect v10) and allows to deploy APIs defined using the OpenAPI 3 specification.

### Deployment Archetype Repository

The deployment repository for certified APIs is based on an archetype. This archetype is invoked from a pipeline with the inputs of the API uploaded to the Gluon Marketplace.

### Usage

This process creates a new project with the following structure, which it is generated completely (Apigee, IBM) regardless of the technology in which the API is going to be deployed.

    └─── src
    |    ├── apigee-opdk-europe
    │         └── config
    │               └── env
    │                   ├── env.json
    │               └── org
    │                   ├── apiProducts.json
    │                   ├── rolePerm.json
    │               └── template
    │                   └── apiproxy
    │                        └── policies
    │                            ├── set of gluon Europe policies
    │                        └── proxies
    │                            ├── default.xml
    │                        └── targets
    │                            ├── main.xml
    │                        ├── template.xml
    │                   └── config
    │                        └── env
    │                            └── intranet
    │                                ├── kvms.json
    │                            └── internet
    │                                ├── kvms.json
    │                        └── org
    │                            ├── apiProducts.json
    │                            ├── rolePerm.json
    │                   └── target
    │                   ├── config.fmpp
    │         ├── pom.xml
    |    ├── apigee-opdk-brazil
    │         └── config
    │               └── template
    │                   └── apiproxy
    │                        └── policies
    │                            ├── set of gluon Brazil policies
    │                        └── proxies
    │                            ├── default.xml
    │                        └── targets
    │                            ├── main.xml
    │                        ├── template.xml
    │                   └── config
    │                        └── env
    │                            └── dev
    │                                ├── kvms.json
    │                                ├── targetServers.json
    │                        └── org
    │                            ├── apiProducts.json
    │                            ├── rolePerm.json
    │                   └── target
    │                   └── config.fmpp
    │         ├── pom.xml
    |    ├── ibm-v10
    │         └── config
    │               └── apis-config-service
    │                   ├── dev.yaml
    │                   ├── pre.yaml
    │                   ├── pro.yaml
    │                   ├── properties.yaml
    ├── resources
    │    └── documents
    │         └── marketplace
    │         └── technical
    ├──apigee-properties
    │    └── cert
    |         └── environment
    │               ├── kvms.json
    │    └── pre
    |         └── environment
    │               ├── kvms.json
    │    └── pro
    |         └── environment
    │               ├── kvms.json
    ├── assembly
    │    └── apiconnect.xml
    │    └── apigee-eu.xml
    ├── api-spec.json
    ├── pom.xml
    ├── deployment-apiconnect.yaml*
    ├── deployment-apigee.yaml*

> *These files are not generated in the archetype, they are included afterwards in the scaffolding process.

The `apigee-opdk-europe` folder contains the template to generate the API proxy bundle with Europe policies, API Product and KVM artifacts needed to consume the API in Apigee.

The `apigee-opdk-brazil` folder contains the template to generate the API proxy bundle with Brazil policies (use case for canales santander), API Product, targetServers and KVM artifacts needed to consume the API in Apigee.

The `ibm-v10` folder contains the files needed to deploy the API, API Product and config file template to consume the API in IBM.

The `api-spec.json` file contains the variables needed in order to the pipeline can have some variables to inform to marketplace that the API was deployed and build the API with some values.

``` json

{
    "api-spec": "https://github.com/${ORG}/${repo}/blob/${ref}/${path}",
    "api-spec-raw": "https://raw.githubusercontent.com/${ORG}/${repo}/${ref}/${path}",
    "org": "${ORG}",
    "repo": "${repo}",
    "path": "${path}",
    "ref": "${ref}",
    "X-Santander-Country": "${country}",
    "asset": {
        "id": "${asset-id}",
        "version": "${asset-version}"
    }
}

```

Description of these fields:

| Parameter | Description | Example |
|-----------|-------------|---------|
| api-spec | URL complete of the github repository where the API definition is stored | <https://github.com/santander-group-shared-assets/gln-def-healthcheck-gluon/blob/2.0.8/src/api-specification.yml> |
| api-spec-raw | Raw URL complete of the github repository where the API definition is stored | <https://raw.githubusercontent.com/santander-group-shared-assets/gln-def-healthcheck-gluon/2.0.8/src/api-specification.yml> |
| org | GitHub organization of the API definition repository | santander-group-shared-assets |
| repo | Name of API definition repository | gln-def-healthcheck-gluon |
| path | Path of the yaml file in the API definition repository | src/api-specification.yml |
| ref | Branch of the API definition repository | 2.0.8 |
| asset-id | Id of the asset of the API in marketplace | 83 |
| asset-version | Version of the asset of the API in the marketplace | 309 |
| X-Santander-Country | Deprecated| ES |

The `deployment-apimanager` files (deployment-apigee.yaml and deployment-apiconnect.yaml) will be included in the scaffolding and they contains the values to deploy the API in Apigee or IBM API Connect.

> **IMPORTANT:**  Apigee deployment process in Brazil and Europe is the same, but the policies deployed in each environment are not the same. Please check before the [policy information](../policies/policies10.md).

### Files needed to be configured

See in the [deployment flow](../../lifecycle/apideployment.md) the files to be configured.

### Pre-requirements in pipelines before to deploy

- Open Firewall rules between ALM Instance and IP addresses of the infrastructure in which are running your APIs.
- Onboarding in Apigee organization where your APIs are deployed.
- Users for API Manager and Gateways (datapower).

More information with all pre-requirements needed [here](../../infrastructure/pre-requirements.md).

### High level process to deploy an API on Apigee OPDK

#### Generate bundle of API Proxy

A folder "specs" will be added in the step to build the bundle of the API Proxy, the yaml definition is temporary because it is not included in the deployment repository. A gihub action will be  download and remove the API yaml file.
Pipeline generates an API Proxy bundle from templates in the structure folder of Apigee.

#### Deploy a proxy on Apigee OPDK

To deploy API Proxy, API Product, KVM and target servers in Apigee the pipeline runs a command to deploy these components.

### High level process to deploy an API on IBM API Connect v10

#### Steps to deploy an API

- Check the files for the deployment
- OpenAPI convert. Configure the security policies, agnostic security, X-IBM-configuration that they will be included in the API to deploy on IBM.
- Check if space exists where the API will be deployed.
- Create API Product with the API associated.
- Deploy API and API Product using the CLI commands for IBM API Connect v10.
- Upload the properties files for the API on the Gateways (Datapower) using curl commands.
