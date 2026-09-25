# Organization Properties

<!--description-start-->

Below are the properties that the user needs to set in the GitHub organization.
These properties are necessary for the execution of some jobs.

<!--description-end-->

## Deployment properties

<!--deployment-start-->

| Property             | Required | Description                            |
|----------------------|----------|----------------------------------------|
| DEPLOYMENT_YAML      | true     | File with the deployment configuration |
| IMAGE_DEPLOY_TYPE    | true     | Default deployment type configured for image workflows. See the types supported by the action 'https://github.com/santander-group-shared-assets/gln-alm-deployment-manager-action' |
| CERT_DEPLOYMENT      | true     | Default environment name to be deployed in Certification |
| PRE_DEPLOYMENT       | true     | Default environment name to be deployed in Preproduction |
| PRO_DEPLOYMENT       | true     | Default environment name to be deployed in Production |
| SNAPSHOT_DEPLOYMENT_ENV   | true     | Environment to deploy in snapshot workflow, 'cert' by default |
| RELEASE_DEPLOYMENT_ENV    | true     | Environment to deploy in snapshot workflow, 'pre/pro' by default |

<!--deployment-end-->

## Elastic properties

<!--elastic-start-->

| Property              | Required | Description           |
|-----------------------|----------|-----------------------|
| ELASTICSEARCH_API_URL | true     | Elasticsearch api url |
| ELASTICSEARCH_ALIAS   | true     | Elastic Search index  |
| ELASTICSEARCH_TYPE    | true     | Elasticsearch type    |

<!--elastic-end-->

## Fortify properties

<!--fortify-start-->

| Property                  | Required | Description                        |
|---------------------------|----------|------------------------------------|
| FORTIFY_SSC_URL           | true     | Url to connect to Fortify SSC      |
| FORTIFY_SC_CONTROLLER_URL | true     | Url to connect to Fortify SC       |
| FORTIFY_TIMEOUT           | true     | Timeout by default used in Fortify |

<!--fortify-end-->

## Sonatype properties

<!--sonatype-start-->

| Property             | Required   | Description                        |
|----------------------|------------|------------------------------------|
| SONATYPE_URL         | true      | Url to connect to Sonatype          |
| SONATYPE_INTEGRATION_URL | true  | Url to connect to Sonatype service - Sonatype and Fortify |
| SONATYPE_JAVA_VERSION    | true  | Java jdk version used by sonatype analysis |

<!--sonatype-end-->

## Maven properties

<!--maven-start-->

| Property                   | Required | Description                   |
|----------------------------|----------|-------------------------------|
| JAVA_VERSION               | true     | Java version used by default |
| MAVEN_VERSION              | true     | Maven version used by default |
| MAVEN_BUILD_GOAL           | true     | Maven goal used by default in build job |
| MAVEN_DEPLOY_ARGS          | true     | Maven goal args used by default in deploy stage |
| MAVEN_SERVER_ID            | true     | Maven server id used by default |

<!--maven-end-->

## Sonar properties

<!--sonar-start-->

| Property        | Required | Description                      |
|-----------------|----------|----------------------------------|
| SONAR_INSTANCES | true     | List of valid sonar instances    |
| SONAR_TIMEOUT   | true     | Timeout by default used in Sonar |

<!--sonar-end-->

## Helm properties

<!--helm-start-->

| Property             | Required   | Description            |
|----------------------|------------|------------------------|
| HELM_PACKAGE         | true       | Indicates whether the workflow has to package a local helm chart and push to registry |

<!--helm-end-->

## API properties

<!--api-start-->

| Property                       | Required | Description                                 |
|--------------------------------|----------|---------------------------------------------|
| NEXUS_APIGEE_GROUPID           | true     | Nexus group id for Apigee artefacts         |
| NEXUS_APICONNECT_GROUPID       | true     | Nexus group id for Apiconnect artefacts     |
| APICONNECT_DEPLOY_CONFIG_PATH  | true     | Apiconnect deploy configuration files path  |
| APICONNECT_CONFIG_SERVICE_PATH | true     | Apiconnect service configuration files path |
| ILAL_URL_DEV                   | true     | DEV ILAL URL                                |
| STS_URL_DEV                    | true     | DEV STS URL                                 |
| ILAL_URL_PRE                   | true     | PRE ILAL URL                                |
| STS_URL_PRE                    | true     | PRE STS URL                                 |
| ILAL_URL_PRO                   | true     | PRO ILAL URL                                |
| STS_URL_PRO                    | true     | PRO STS URL                                 |

<!--api-end-->

## Others properties

<!--other-start-->

| Property             | Required      | Description                                 |
|----------------------|---------------|---------------------------------------------|
| ENV_PROFILE          | true          | File name of properties of user project     |
| INTEGRATION_BRANCH   | true          | Integration branch name                     |
| ASDF_JAVA11          | true          | Java jdk11 version used by default in asdf |
| ASDF_NODE12          | true          | Node12 version used by default in asdf     |
| DEFAULT_PROXY_SERVER | true          | Server used by default                      |
| DEFAULT_PROXY_PORT   | true          | Proxy port used by default                  |
| MARKETPLACE_ENDPOINT | true          | Gluon Marketplace Endpoint                  |
| MARKETPLACE_BIAN_ENDPOINT | true     | Gluon Marketplace Bian Endpoint             |

<!--other-end-->

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--notapie-start-->"
   end="<!--notapie-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-int-start-->"
   end="<!--setupenvironment-int-end-->"
!}
