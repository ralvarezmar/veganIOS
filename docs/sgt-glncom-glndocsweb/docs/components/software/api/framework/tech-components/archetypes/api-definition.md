## OPENAPI 3 API Definition Archetype

This is an archetype for creating a new project with a REST API based on the [OpenAPI 3 specification](https://www.openapis.org/)

### Definition Archetype Repository

Before using the archetype, Global Governance have to approve the proposal of new API and then APP360 team creates the definition repository from the archetype definition repository.

### Usage

The definition archetype has the following structure:

    ├── catalog.yml
    ├── .github
    │   ├── ISSUE_TEMPLATE
    │       ├── request-api-changes.yml
    └── src
        ├── api-specification.yml

The `catalog.yml` file contains the API catalogation. It could handle the catalog information needed for the Gluon.

When definition repository is created some values are added from the discussion template for new API proposal. Some values can be modified in this file and then Global Governance team will review before approving the definitive API.

``` bash

x-santander-catalogation:
bian-landscape-version: ${bian-landscape-version}
bian-business-area: ${bian-business-area}
bian-business-domain: ${api-domain}
bian-service-domain: ${bian-service-domain}

```

Description of these fields:

| Parameter | Description | Example |
|-----------|-------------|---------|
| bian-landscape-version | BIAN landscape version| 11 |
| bian-business-area | BIAN business area | BIAN_BUSINESS_AREA |
| bian-business-domain | BIAN business domain| MY_DOMAIN |
| bian-service-domain | BIAN service domain| BIAN_SERVICE_DOMAIN |

The `src` directory contains the source code of the API definition `api-specification.yml`.

By default, an API specification example will be in the repository like a guide. See an [example](https://github.com/santander-group-gluon/gln-apis-openapi3-archetype/blob/develop/src/main/resources/archetype-resources/src/api-specification.yml).

In this directory the new API will be fully defined and designed. Then Global Governance will review it.

The `.github` directory contains the form template that Gluon will be used for the requests of changes of the API.

### Files to  be modified by user

Once the repo has been created, the user must modify the following files and then Global Governance will review the changes:

- `catalog.yml` file:  Include the API catalogation values
- `api-specification.yml` file: Definition of the API.
