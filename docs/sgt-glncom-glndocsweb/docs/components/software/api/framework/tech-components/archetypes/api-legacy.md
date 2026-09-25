## API Legacy Deployment Archetype

This is an Archetype for APIs Legacy deployment which has different templates for API Managers (currently, on Apigee OPDK and IBM API Connect v10).

### Legacy Deployment Archetype Repository

The deployment repository for legacy APIs is based on an archetype. This archetype is invoked from a pipeline with the inputs of the API uploaded to the Gluon Marketplace.

### Usage

This will create a new project with the following structure, which it is generated completely (Apigee OPDK, IBM Api Connect v10) regardless of the technology in which the API is going to be deployed. It has the following structure:

    ├── src
    |    ├── apigee
    │         └── config
    │              ├──apigee-properties
    │                   └── cert
    |                       └── environment
    │                           ├── kvms.json
    │                           ├── targetServers.json 
    │                   └── pre
    |                       └── environment
    │                           ├── kvms.json
    │                           ├── targetServers.json 
    │                   └── pro
    |                       └── environment
    │                           ├── kvms.json
    │                           ├── targetServers.json 
    │         └── legacy
    │               ├── apiproduct.json
    │               ├── apiproxy.zip
    │         └── README.md                   
    |    ├── ibm-v10
    │         └── config
    │               └── apis-config-service
    │                   ├── dev.yaml
    │                   ├── pre.yaml
    │                   ├── pro.yaml
    │                   ├── properties.yaml
    │         └── legacy
    │               ├── api-legacy-assembly-version.yaml
    │               ├── api-product-legacy-version.yaml
    │         └── README.md
    ├── api-spec.json*
    ├── pom.xml
    ├── deployment-apiconnect-legacy.yaml*
    ├── deployment-apigee-legacy.yaml*
    ├── README.md

> *These files are not generated in the archetype, they have to be included afterwards in the scaffolding process.

The `apigee` folder contains the files needed to deploy the Api, the API proxy bundle, API Product and KVM artifacts and/or targetservers needed to consume the API in Apigee.

The `ibm-v10` folder contains the files needed to deploy the API, API Aseembly, API Product and config files template (Dev,Pre & Pro) to consume the API in IBM.

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
| X-Santander-Country | Deprecated | ES |

The `deployment-apimanager` files (deployment-apigee-legacy.yaml and deployment-apiconnect-legacy.yaml) will be included in the scaffolding and they contains the values to deploy the API in Apigee or IBM API Connect.

> **IMPORTANT:**  Apigee deployment process in Brazil and Europe is the same, but the policies deployed in each environment are different. Please check before the [policy information](../policies/policies10.md).

### Files needed to be configured

See in the [deployment flow](../../lifecycle/apideployment.md) the files to be configured.

### Pre-requirements in pipelines before to deploy

More information with all pre-requirements needed [here](../../infrastructure/pre-requirements.md))
