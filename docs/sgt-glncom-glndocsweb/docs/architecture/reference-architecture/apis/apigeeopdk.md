# Apigee OPDK - Openshift deployment

## Api Lifecycle Operations Guide

### Introduction

The following diagram shows the possible components to use in Api lifecycle.
It will be mainly used Organizations,Companies,Apps,Products,Keys & Api Proxies.

![Product Lifecycle](../assets/images/apigee-opdk-api-lifecycle.png)<br>

#### Use of the Management API

It is used to execute most of the lifecycle processes.
The management Api can be used with two authorization ways Basic Authentication with username & password (Described in the example) and with token.
Please review the following official documentation.[Official Documentation Apigee Link](https://docs.apigee.com/api-platform/system-administration/using-oauth2?hl=es-419#get-the-tokens)

```bash
#https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/apiproducts
curl --location --request GET 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apiproducts/' \
--header 'Authorization: ••••••' \
--data ''
# Authorization : username:password in base64

#example response

[
    "envoy-dmz-clicle",
    "envoy-intra-gpos",
    "envoy-intra-clicre",
    "envoy-intra",
    "envoy-qk-intra",
    "edgemicro-internal",
    "test-envoy-ch",
    "envoy-qk-intra-gpos",
    "test-envoy",
    "httpbin-product"
]
```

#### Oauth Server

<div class="cards row-auto" markdown>
  The Oauth Server used for this guide is SOS. [Official Documentation SOS Link](https://san-sgt-basic.atlassian.net/wiki/spaces/ARCHSEC/pages/447843035/Security+OAuth+Server.+S.O.S.)
</div>

### Credential Management

- Create company if it does not exist
- Associate  Developer App to Company (it generates credentials)

#### Client

- Depending on the case, the creation of a new client id, and optionally, a client secret, will be required.
In the case of public clients, it is not necessary to generate the client secret. First, it is created on the OAuth server, and later it is ingested into the manager.

#### Core

- In the core case, it is only necessary to create a Client Id + secret, and those created in the Apigee OPDK manager can be used directly.

#### Example Credential Management

```bash
#Create company if it does not exist
  # Example call
  #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies

curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data-raw '{
  "name": "altostrat2",
  "displayName": "Altostrat2",
  "attributes": [
    {
      "name": "ADMIN_EMAIL",
      "value": "admin@example.com"
    },
    {
      "name": "channel_tp",
      "value": "web"
    }
  ]
}'

  # Example Response

  {
    "apps": [],
    "name": "altostrat2",
    "displayName": "Altostrat2",
    "organization": "gluon-paas",
    "status": "active",
    "attributes": [
        {
            "name": "ADMIN_EMAIL",
            "value": "admin@example.com"
        },
        {
            "name": "channel_tp",
            "value": "web"
        }
    ],
    "createdAt": 1721814956301,
    "createdBy": "x407530@santanderglobaltech.com",
    "lastModifiedAt": 1721814956301,
    "lastModifiedBy": "x407530@santanderglobaltech.com"
}


# Associate  Developer App to Company

  # Example Call
   #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies/{company_name}/apps
curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat2/apps/' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data-raw '{
  "apiproducts": [
    "test-envoy"
  ],
  "attributes": [
    {
      "name": "ADMIN_EMAIL",
      "value": "admin@example.com"
    },
    {
            "name": "channel_tp",
            "value": "web"
    }
  ],
  "callbackUrl": "example.com",
  "name": "test-envoy",
  "scopes": [],
  "status": "approved"
}'

# Example Response

{
    "appId": "d13e6c23-31b8-44c9-a033-c9cb431b4fbc",
    "attributes": [
        {
            "name": "ADMIN_EMAIL",
            "value": "admin@example.com"
        },
        {
            "name": "channel_tp",
            "value": "web"
        }
    ],
    "callbackUrl": "example.com",
    "companyName": "altostrat2",
    "createdAt": 1721815114056,
    "createdBy": "x407530@santanderglobaltech.com",
    "credentials": [
        {
            "apiProducts": [],
            "attributes": [],
            "consumerKey": "l5YfPGeHFVItamcROR4dwCr6L95LKiCU",
            "consumerSecret": "GbGczkN6JpuphSz0",
            "expiresAt": -1,
            "issuedAt": 1721815114072,
            "scopes": [],
            "status": "approved"
        }
    ],
    "lastModifiedAt": 1721815114056,
    "lastModifiedBy": "x407530@santanderglobaltech.com",
    "name": "test-envoy",
    "scopes": [],
    "status": "approved"
}

```

### Subscription

#### Client

- Delete autogenerated credentials
- Associate credentials generated by SOS
- Associate Product to Developer APP
- Registration of scopes in OAuth server

#### Core

- Associate Product to Developer APP

#### Example

```bash

# Delete autogenerated credentials

 #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies/{company_name}/apps/{app_name}/keys/{consumerKey}

curl --location --request DELETE 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat2/apps/test-envoy/keys/l5YfPGeHFVItamcROR4dwCr6L95LKiCU' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
    "apiProducts": [
        "test-envoy"
    ]
}'

{
    "apiProducts": [],
    "attributes": [],
    "consumerKey": "l5YfPGeHFVItamcROR4dwCr6L95LKiCU",
    "consumerSecret": "GbGczkN6JpuphSz0",
    "expiresAt": -1,
    "issuedAt": 1721815114072,
    "scopes": [],
    "status": "revoked"
}

# Associate credentials generated by SOS


 #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies/{company_name}/apps/{app_name}/keys/{consumerKey}/create
curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat2/apps/test-envoy/keys/create' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
  "consumerKey": "consumerKey1",
  "consumerSecret": "consumerSecret1"
}'

{
    "apiProducts": [],
    "attributes": [],
    "consumerKey": "consumerKey1",
    "consumerSecret": "consumerSecret1",
    "issuedAt": 1721819198402,
    "scopes": [],
    "status": "approved"
}

# Associate Product to Developer APP Credentials (consumer Key)

  # Example
  
     #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies/{company_name}/apps/{app_name}/keys/{consumerKey}

curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat/apps/test-envoy/keys/mEbCBu0TgoxfeZsm7YGw3Eh9hTs4e8ti' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
    "apiProducts": [
        "test-envoy"
    ]
}'

# Example Response

{
    "apiProducts": [
        {
            "apiproduct": "test-envoy",
            "status": "approved"
        }
    ],
    "attributes": [],
    "consumerKey": "mEbCBu0TgoxfeZsm7YGw3Eh9hTs4e8ti",
    "consumerSecret": "nLnQI11RfHhWmHkk",
    "expiresAt": -1,
    "issuedAt": 1721052034491,
    "scopes": [],
    "status": "approved"
}



# Registration in Oauth Server
#https://SOSHost/manager/oauth/clients/{client-id}/scopes
curl --location --request POST 'https://SOSHost/manager/oauth/clients/test-operational-paas-client-id/scopes' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic YWRtaW5fX3Rlc3Q6YWRtaW4=' \
--data '{"scope": ["read"],"authorizedGrantTypes": ["authorization_code"],"autoApproveScopes": ["read"]}'

# Example response
{
    "clientId": "test-paas-client-credentials-id",
    "scope": [
        "accounts.read",
        "read"
    ],
    "grantsAssignedToScopes": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        }
    ],
    "scopesDetails": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        }
    ],
    "authorizedGrantTypes": [
        "client_credentials"
    ],
    "registeredRedirectUris": [],
    "autoApproveScopes": [
        "accounts.read",
        "read"
    ],
    "accessTokenValiditySeconds": 2592000,
    "additionalInformation": "Additional information for client credentials id",
    "clientAuthorities": [],
    "refreshTokenValiditySeconds": 2000,
    "client_type": "confidential"
}



```

### Subscription Migration

- Before migrating: At least, the plan must have the same operations as the original plan, for each API in the plan, and with at least the same rate limit.
In other words, a release or a fix. Backward compatible versioning. Previously, new scopes must be checked.

Two scenarios:

- Migration from one product to another deprecating the product

- Migration from one product to another retiring the product.

#### Example Migration from one product to another deprecating the product

```bash
# Associate new product to Developer App Key

 # Example
  
     #https://{{ apigee_manager_url }}/v1/organizations/{organization_name}/companies/{company_name}/apps/{app_name}/keys/{consumerKey}

curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat2/apps/test-envoy/keys/consumerKey1' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
    "apiProducts": [
        "test-envoy-ch1"
    ]
}'

# Example Response

{
    "apiProducts": [
        {
            "apiproduct": "test-envoy-ch",
            "status": "approved"
        },
        {
            "apiproduct": "test-envoy-ch1",
            "status": "approved"
        }
    ],
    "attributes": [],
    "consumerKey": "consumerKey1",
    "consumerSecret": "consumerSecret1",
    "expiresAt": -1,
    "issuedAt": 1721819198402,
    "scopes": [],
    "status": "approved"
}

#Deprecate product (Please review the Deprecation Section)

```

#### Example Migration from one product to another retiring the product

```bash

# Associate new product to Developer App Key
curl --location --request POST 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/companies/altostrat2/apps/test-envoy/keys/consumerKey1' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
    "apiProducts": [
        "test-envoy-ch1"
    ]
}'

# Example Response

{
    "apiProducts": [
        {
            "apiproduct": "test-envoy-ch",
            "status": "approved"
        },
        {
            "apiproduct": "test-envoy-ch1",
            "status": "approved"
        }
    ],
    "attributes": [],
    "consumerKey": "consumerKey1",
    "consumerSecret": "consumerSecret1",
    "expiresAt": -1,
    "issuedAt": 1721819198402,
    "scopes": [],
    "status": "approved"
}


#Retire product (Please review the Retiring Section)

```

### Deprecating

- API Call to the Apigee management Api to change the custom attribute status.
Apigee suggest to have a custom attribute on the product and prevent to make new subscriptions to it.
So the flow will be for a new subscription first check the product custom attribute for example status and if is is active, allow new subscriptions.[Official Documentation Apigee Product Management Link](https://docs.apigee.com/api-platform/publish/create-api-products?hl=es-419)

#### Example

```bash
#Check status Call
#https://{{ apigee_manager_url }}/v1/organizations/{{organization_name }}/apiproducts/{{ product_name }}

curl --location --request GET 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apiproducts/test-envoy' \
--header 'Authorization: ••••••'

#Check status Response
{
    "apiResources": [
        "/test",
        "/"
    ],
    "approvalType": "auto",
    "attributes": [
        {
            "name": "access",
            "value": "public"
        },
        {
            "name": "apigee-remote-service-targets",
            "value": "test-envoy-api.apps.gluon01.sgt.pro.cn2.paas.cloudcenter.corp"
        },
        {
            "name": "status",
            "value": "deprecated"
        }
    ],
    "createdAt": 1699264166943,
    "createdBy": "plataformapis@gruposantander.com",
    "description": "envoytest",
    "displayName": "test-envoy",
    "environments": [
        "intranet-interdomain"
    ],
    "lastModifiedAt": 1720781588966,
    "lastModifiedBy": "x407530@santanderglobaltech.com",
    "name": "test-envoy",
    "proxies": [
        "remote-service"
    ],
    "scopes": [
        ""
    ]
}

#Custom attribute change Call to Deprecate
  #https://{{ apigee_manager_url }}/v1/organizations/{{organization_name }}/apiproducts/{{ product_name }}
curl --location --request PUT 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apiproducts/test-envoy' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data-raw '{
    "apiResources": [
        "/test",
        "/"
    ],
    "approvalType": "auto",
    "attributes": [
        {
            "name": "access",
            "value": "public"
        },
        {
            "name": "apigee-remote-service-targets",
            "value": "test-envoy-api.apps.gluon01.sgt.pro.cn2.paas.cloudcenter.corp"
        },
        {
            "name": "status",
            "value": "deprecated"
        }
    ],
    "createdAt": 1699264166943,
    "createdBy": "plataformapis@gruposantander.com",
    "description": "envoytest",
    "displayName": "test-envoy",
    "environments": [
        "intranet-interdomain"
    ],
    "lastModifiedAt": 1720779953616,
    "lastModifiedBy": "Hugo.Aparicio@gruposantander.com",
    "name": "test-envoy",
    "proxies": [
        "remote-service"
    ],
    "scopes": [
        ""
    ]
}'

#Example response

{
    "apiResources": [
        "/test",
        "/"
    ],
    "approvalType": "auto",
    "attributes": [
        {
            "name": "access",
            "value": "public"
        },
        {
            "name": "apigee-remote-service-targets",
            "value": "test-envoy-api.apps.gluon01.sgt.pro.cn2.paas.cloudcenter.corp"
        },
        {
            "name": "status",
            "value": "deprecated"
        }
    ],
    "createdAt": 1699264166943,
    "createdBy": "plataformapis@gruposantander.com",
    "description": "envoytest",
    "displayName": "test-envoy",
    "environments": [
        "intranet-interdomain"
    ],
    "lastModifiedAt": 1720781588966,
    "lastModifiedBy": "x407530@santanderglobaltech.com",
    "name": "test-envoy",
    "proxies": [
        "remote-service"
    ],
    "scopes": [
        ""
    ]
}


```

### Retiring

#### Client

- Check that there are no subscriptions
- Theoretically, the scopes should be removed. But until there is a thesis that scopes are not shared by APIs, it is a complex operation that is not recommended to be done.
- Retiring

#### Core

- Check that there are no subscriptions
- Retiring

#### Example

```bash

# Check subscriptions (Check if the product is at least associated with an App)

#https://{{ apigee_manager_url }}/v1/organizations/{{organization_name }}/apiproducts/{{ product_name }}?query=count&entity=apps

curl --location --request GET 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apiproducts/test-envoy-developerapp?query=count&entity=apps' \
--header 'Authorization: ••••••' \
--data ''

# If the response vale is > 0 there are apps subscribed to a product
{
    "value": 1
}

#Example Call (Delete Product)
   #https://{{ apigee_manager_url }}/v1/organizations/{{organization_name }}/apiproducts/{{ product_name }}
curl --location --request DELETE 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apiproducts/test-envoy-developerapp/' \
--header 'Authorization: ••••••' \
--data ''

#Example Response

{
    "apiResources": [
        ""
    ],
    "approvalType": "auto",
    "attributes": [],
    "createdAt": 1721135699459,
    "createdBy": "Hugo.Aparicio@gruposantander.com",
    "description": "",
    "displayName": "test-envoy-developerapp",
    "environments": [],
    "lastModifiedAt": 1721137375896,
    "lastModifiedBy": "Hugo.Aparicio@gruposantander.com",
    "name": "test-envoy-developerapp",
    "proxies": [
        "No-Target"
    ],
    "scopes": [
        ""
    ]
}

#Example Call (Delete Api Proxy) (It must be undeployed first)
#https://{{ apigee_manager_url }}/v1/organizations/{{organization_name }}/apis/{{ api_name }}
curl --location --request DELETE 'https://api-management-gluon-paas-apg.sgtech.corp/v1/organizations/gluon-paas/apis/No-Target' \
--header 'Authorization: ••••••' \
--data ''

#Example Response

{
    "basepaths": [],
    "configurationVersion": {
        "majorVersion": 4,
        "minorVersion": 0
    },
    "contextInfo": "Revision null of application -NA-, in organization -NA-",
    "entityMetaDataAsProperties": {
        "bundle_type": "zip",
        "lastModifiedBy": "null",
        "createdBy": "null",
        "lastModifiedAt": "null",
        "subType": "null",
        "createdAt": "null"
    },
    "name": "No-Target",
    "policies": [],
    "proxies": [],
    "proxyEndpoints": [],
    "resourceFiles": {
        "resourceFile": []
    },
    "resources": [],
    "sharedFlows": [],
    "spec": "",
    "targetEndpoints": [],
    "targetServers": [],
    "targets": [],
    "type": "Application"
}

```
