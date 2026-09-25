# Organization Secrets

<!--description-start-->

Below are the secrets that the user needs to set in the GitHub organization.
These secrets are necessary for the execution of some jobs.

<!--description-end-->

## Elastic secrets

<!--elastic-start-->

| Secret id                    | Description                                       |
|------------------------------|---------------------------------------------------|
| ELASTICSEARCH_API_KEY_PRO    | Elasticsearch key for access to ElasticSearch     |

<!--elastic-end-->

## Fortify secrets

<!--fortify-start-->

| Secret id                     | Description                                          |
|-------------------------------|------------------------------------------------------|
| FORTIFY_CLIENT_AUTH_TOKEN_PRO | Token to connect to the Fortify controller           |
| FORTIFY_USER | Fortify user (only in specific organization credentials file)         |
| FORTIFY_PASSWORD | Fortify password (only in specific organization credentials file) |

<!--fortify-end-->

## Sonatype secrets

<!--sonatype-start-->

| Property    | Description                         |
|-------------|-------------------------------------|
| SONATYPE_USER         | Sonatype USER (only in specific organization credentials file) |
| SONATYPE_PASSWORD     | Sonatype PASSWORD (only in specific organization credentials file) |

<!--sonatype-end-->

## Setup environment variables secrets

<!--setupenvironment-start-->

<!--setupenvironment-int-start-->

| Secret id                    | Description                                           | Example                       |
|------------------------------|-------------------------------------------------------|-------------------------------|
| CONFIG_FILE_NAME             | Name of the properties file to load                   | 'sgt-config-pro.env'          |
| CONFIG_FILE_PATH             | Path of the properties file to load                   | 'resources/envs'              |
| CONFIG_REPOSITORY            | Confi repository with the propertues file             | 'organization/config-project' |
| CONFIG_REPOSITORY_VERSION    | Tag or branch of the repository of the properties file | 'vx.x.x'                      |

<!--setupenvironment-int-end-->

<!--setupenvironment-end-->

## Sonar secrets

<!--sonar-start-->

| Secret id                                                                          |
|------------------------------------------------------------------------------------|
| Tokens defined in the `SONAR_INSTANCES` properties of the `Configuraction Project`, using the SONAR_GLUON_COMMUNITY_PRO_TOKEN |

<!--sonar-end-->

## GitHub App secrets

<!--github-start-->

| Secret id               | Description                        |
|-------------------------|------------------------------------|
| APPLICATION_ID          | GitHub App installation identifier |
| APPLICATION_PRIVATE_KEY | GitHub App private key             |

<!--github-end-->

## Api secrets

<!--api-start-->

| Secret id                       | Type       | Description                             |
|---------------------------------|------------|-----------------------------------------|
| STS_CLIENTID_DEV                | Apiconnect | DEV STS client ID                       |
| STS_CLIENTSECRET_DEV            | Apiconnect | DEV STS client secret                   |
| STS_CLIENTID_PRE                | Apiconnect | PRE STS client ID                       |
| STS_CLIENTSECRET_PRE            | Apiconnect | PRE STS client secret                   |
| STS_CLIENTID_PRO                | Apiconnect | PRO STS client ID                       |
| STS_CLIENTSECRET_PRO            | Apiconnect | PRO STS client secret                   |
| ILAL_SANTCLIENTID_DEV           | Apiconnect | DEV ILAL client ID                      |
| ILAL_SANTCLIENTID_PRE           | Apiconnect | PRE ILAL client ID                      |
| ILAL_SANTCLIENTID_PRO           | Apiconnect | PRO ILAL client ID                      |

<!--api-end-->

<!--notapie-start-->

**NOTE:**

* The values of these properties can be seen in the `configuration project`
  configured according to the secrets defined here.

<!--notapie-end-->
