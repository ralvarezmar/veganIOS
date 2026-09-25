# **OAM Params Needed by Deployments and Registries Infrastructure**

## **Deployment Infrastructures**

#### **IBM**

| Key                            | Description                                                | Example                                                                 |
| -----------------------------  | -----------------------------------------------------------| ----------------------------------------------------------------------- |
| `type`                         | API platform type                                          | IBM                                                                     |
| `credentialUserId`             | User ID for authentication                                 | APICONNECT_USER_DEV                                                     |
| `credentialPassId`             | Password ID for authentication                             | APICONNECT_USER_DEV_PASS                                                |
| `company`                      | Company name                                               | scib                                                                    |
| `exposure`                     | API exposure type                                          | intranet                                                                |
| `security-type`                | Security type used                                         | core                                                                    |
| `mode`                         | Operation mode                                             | live                                                                    |
| `manager-url`                  | API manager URL                                            | api-manager.scib.dev.corp                                               |
| `kid`                          | Key identifier                                             | apimscib-intranet                                                       |
| `private-key-id`               | Private key ID                                             | apimscib-intranet                                                       |
| `sca-iss`                      | SCA issuer                                                 | ''                                                                      |
| `sca-token_in`                 | SCA token input                                            | ''                                                                      |
| `sca-token-type`               | SCA token type                                             | ''                                                                      |
| `manager-subscription-user`    | Manager subscription user                                  | ''                                                                      |
| `manager-subscription-password`| Manager subscription password                              | ''                                                                      |
| `oauth-url-management`         | OAuth management URL                                       | ''                                                                      |
| `oauth-user`                   | OAuth user                                                 | ''                                                                      |
| `oauth-pass`                   | OAuth password                                             | ''                                                                      |
| `oauth-type`                   | OAuth type                                                 | ''                                                                      |
| `authorization-url`            | Authorization URL                                          | <https://$(auth-security-url)>                                          |
| `token-url`                    | Token URL                                                  | <https://$(token-security-url)>                                         |
| `organization`                 | Organization                                               | scib                                                                    |
| `catalog`                      | Catalog                                                    | gluon-apic                                                              |
| `space`                        | Space                                                      | true                                                                    |
| `service`                      | Service                                                    | intranet-core                                                           |
| `x-ibm-oauth-provider`         | IBM OAuth provider                                         | gluon-test-provider                                                     |
| `realm`                        | Realm                                                      | provider/ldap-apim                                                      |
| `clientId-toolkit`             | Client ID for toolkit                                      | ''                                                                      |
| `client-secret-toolkit`        | Client secret for toolkit                                  | ''                                                                      |
| `producer-org-id`              | Producer organization ID                                   | f3b29b70-b6d4-482b-a723-5cf4c762cb30                                    |
| `catalog-id`                   | Catalog ID                                                 | 95239486-3c62-47f1-b420-4ad0add9253b                                    |
| `catalog-original-id`          | Original catalog ID                                        | ''                                                                      |
| `identity-provider`            | Identity provider                                          | ''                                                                      |
| `gateway-service-url`          | Gateway service URL                                        | <https://test>                                                          |

#### **APIGEE**

| Key                                         | Description                                   | Example                                                                 |
| ----------------------------------------    | ----------------------------------------------| ----------------------------------------------------------------------- |
| `type`                                      | Type of API platform                          | APIGEE                                                                  |
| `credentialUserId`                          | User ID for authentication                    | APIGEE_USER_DEV                                                         |
| `credentialPassId`                          | Password ID for authentication                | APIGEE_USER_DEV_PASS                                                    |
| `company`                                   | Company name                                  | scib                                                                    |
| `exposure`                                  | Type of API exposure                          | intranet                                                                |
| `security-type`                             | Type of security used                         | client                                                                  |
| `mode`                                      | Operation mode                                | live                                                                    |
| `manager-url`                               | API manager URL                               | <https://api-management.sgtech.dev.corp>                                |
| `kid`                                       | Key identifier                                | apimscib-intranet                                                       |
| `private-key-id`                            | Private key ID                                | apimscib-intranet                                                       |
| `jwe-private-key-id`                        | Private key ID for JWE                        | ''                                                                      |
| `sca-iss`                                   | Issuer for SCA                                | ''                                                                      |
| `sca-token-origin`                          | SCA token origin                              | ''                                                                      |
| `sca-token-type`                            | SCA token type                                | ''                                                                      |
| `manager-subscription-user`                 | User for manager subscription                 | ''                                                                      |
| `manager-subscription-password`             | Password for manager subscription             | ''                                                                      |
| `organization`                              | Organization                                  | desarrollo                                                              |
| `execution-environment`                     | Execution environment                         | intranet                                                                |
| `virtual-host`                              | Virtual host                                  | default                                                                 |
| `virtual-host-url`                          | Virtual host URL                              | <http://url12345>                                                       |
| `company-developer-administrator-email`     | Company developer administrator email         | <santander.developer.svc@gruposantander.com>                            |
| `company-developer-administrator-firstName` | Company developer administrator first name    | Santander Developer                                                     |
| `company-developer-administrator-lastName`  | Company developer administrator last name     | Service Account                                                         |
| `oauth-url-management`                      | OAuth management URL                          | ''                                                                      |
| `oauth-user`                                | OAuth user                                    | ''                                                                      |
| `oauth-pass`                                | OAuth password                                | ''                                                                      |
| `oauth-type`                                | OAuth type                                    | SOS                                                                     |
| `authorization-url`                         | Authorization URL                             | <https://$(auth-security-url)>                                          |
| `token-url`                                 | Token URL                                     | <https://$(token-security-url)>                                         |
| `introspect-url`                            | Description                                   | Example                                                                 |

#### **AKS**

| Key               | Description                                                             | Example                                                                 |
| ----------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `type`                                      | Deployment platform type                      | KUBERNETES                                                              |
| `apiServer`                                 | Kubernetes API server URL                     | <https://cibaks-ea2de9a7.hcp.westeurope.azmk8s.io:443>                  |
| `namespace`                                 | Kubernetes namespace                          | app360-cert                                                             |
| `credentialUserId`                          | User ID for authentication                    | AKS_USER                                                                |
| `credentialPassId`                          | Password ID for authentication                | AKS_PASSWORD                                                            |
| `provider`                                  | Deployment platform provider                  | aks                                                                     |
| `cloud`                                     | Cloud service provider                        | azure                                                                   |
| `account`                                   | Account in the cloud service provider         | 0345214e-311c-42fd-a0bf-1725071c896d                                    |
| `clusterName`                               | Kubernetes cluster name                       | cibd1weuaksdevopscrit003                                                |
| `tenant`                                    | Azure tenant ID                               | 35595a02-4d6d-44ac-99e1-f9ab4cd872db                                    |
| `resourceGroup`                             | Azure resource group                          | cibd1weursgdevopscrit001                                                |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `application`                               | Application name                              | application-name-cluster                                                |

| `artifact-store`                            | Artifact store identifier                     | CI00000001001                                                           |

#### **EKS**

| Key                   | Description                                                         | Example                                                                 |
| --------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `type`                | Deployment platform type                                            | KUBERNETES                                                              |
| `apiServer`           | Kubernetes API server URL                                           | <https://D8C306CE581B492A3D3B1366C5B614.sk1.eu-west-1.eks.amazonaws.com>|
| `namespace`           | Kubernetes namespace                                                | app360-dev                                                              |
| `credentialUserId`    | User ID for authentication                                          | GLUON_AWS_ACCESS_KEY_ID                                                 |
| `credentialPassId`    | Password ID for authentication                                      | GLUON_AWS_SECRET_ACCESS_KEY_ID                                          |
| `provider`            | Deployment platform provider                                        | eks                                                                     |
| `cloud`               | Cloud service provider                                              | aws                                                                     |
| `account`             | Account in the cloud service provider                               | 665313331585                                                            |
| `role`                | Role in the cloud service provider                                  | AccountAutomationNonPro                                                 |
| `region`              | Cloud service provider region                                       | eu-west-1                                                               |
| `clusterName`         | Kubernetes cluster name                                             | sgtd1aireksgluondeksd001                                                |
| `deployStrategy`      | Deployment strategy                                                 | none                                                                    |
| `application`         | Application name                                                    | application-name-cluster                                                |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `artifact-store`      | Artifact store  identifier                                          | CI00000002001                                                           |

#### **OC**

| Key                    | Description                                                        | Example                                                                 |
| -------------          | ------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| `type`                 | Deployment platform type                                             | KUBERNETES                                                              |
| `apiServer`            | Kubernetes API server URL                                          | <https://api.ccc01alm.ccc.pre.cn1.paas.cloudcenter.corp:6443>           |
| `namespace`            | Kubernetes namespace                                               | app360-cert-pre                                                         |
| `credentialsId`        | Authentication credentials identifier                              | APP360_CERT_PRE_TOKEN                                                   |
| `deployStrategy`       | Deployment strategy                                                | none                                                                    |
| `application`          | Application or cluster name                                        | application-name-cluster                                                |
| `credentialsFromVault` | If credentials are obtained from a vault, by default: false        | false                                                                   |
| `artifact-store`       | Artifact store identifier                                          | CI000000030013                                                          |

#### **ANSIBLE**

| Key                    | Description                                                        | Example                                                                 |
| -------------          | ------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| `type`                 | Deployment platform type                                              | ANSIBLE                                                              |
| `inventoryGit`         | Git inventory project (organization/project). If not defined, the inventory must be in the workspace  | organization-inventory/github-inventory-project          |
| `inventoryGitBranch`   | Git inventory project version. If git inventory project is defined. By default 'main'  | v1.0.0       |
| `inventory`            | Name of the inventory file to use. By default 'host' | inventory-test |
| `limit`                | Subset of machines from inventory  | linux |
| `tag`                  | If you have a large playbook, it may be useful to run only specific parts of it instead of running the entire playbook |  tag1 |
| `ansibleGalaxy`        | If true, it will install required ansible-galaxy roles defined in requirements | false |
| `requirements`         | File define ansible roles. By default requirements.yml | requirements.yml |
| `disableMitogen`       | If true disables mitogen plugin, if false (by default) or not defined the environment var ANSIBLE_STRATEGY_PLUGINS is added with the mitogen plugin path, mitogen is active by default | false |
| `mitogenStrategy`      | If defined, overrides default ANSIBLE_STRATEGY environment variable. By default mitogen_linear | mitogen_linear |
| `mitogenVersion`       | If defined, overrides default MITOGEN_ANSIBLE_VERSION environment variable | 0.3.3 |
| `ansibleCredentialUser`     | Action Secret´s Name. The secret is an user to connect to linux machine | ANSIBLE_CREDENTIAL_USER |
| `ansibleCredentialPassword` | Action Secret´s Name. The secret is a password ansibleCredentialUser's user | ANSIBLE_CREDENTIAL_PASSWORD |
| `ansibleCredentialSSH`      | Action Secret´s Name. The secret is a ssh key ansibleCredentialUser's user | ANSIBLE_CREDENTIAL_SSH |
| `winrmCredentialUser`       | Action Secret´s Name. The secret is a windows user to connect to windows machine by winrm | WINRM_CREDENTIAL_USER |
| `winrmCredentialPassword`   | Action Secret´s Name. The secret is a windows password winrmCredentialUser's user | WINRM_CREDENTIAL_PASSWORD |
| `ansibleVaultCredentialId`  | Action Secret´s Name. The secret is a password or key for vaults | ANSIBLE_VAULT_CREDENTIAL_ID |

#### **Event Deployment**

| Key         | Description | Example | Mandatory |
|-------------|-------------|---------|-----------|
| `type` | Name of the technology of the event cluster. Currently supported values: CONFLUENT-ON-PREMISE | CONFLUENT-ON-PREMISE | YES |
| `brokers` | Brokers where the event will be deployed, between commas | server1:port,server2:port | YES |
| `securityProtocol` | Type of security used in the cluster authorization. Currently supported values: SASL_SSL | SASL_SSL | YES |
| `authorizationType` | Type of authorization to the cluster. Possible types: USER, KERBEROS | KERBEROS | YES |
| `brokerUserId` | Name of the credential used for the broker user | BROKER_USER | YES |
| `brokerPasswordId` | Name of the credential used for the broker password | BROKER_PASSWORD | YES |
| `brokerKeytabId` | Name of the credential used for the encoded-64 keytab file content | BROKER_KEYTAB | Only if authorizationType = KERBEROS |
| `brokerPrincipalId` | Name of the credential used for the principal value | BROKER_PRINCIPAL | Only if authorizationType = KERBEROS |
| `brokerKerberosFileId` | Name of the credential used for the encoded-64 kerberos config file | BROKER_KERBEROS | Only if authorizationType = KERBEROS |
| `schemaRegistryUserId` | Name of the credential used for login user in Schema Registry | SCHEMA_USER | Only if useSchemaRegistry = true |
| `schemaRegistryPasswordId` | Name of the credential used for login password in Schema Registry | SCHEMA_PASSWORD | Only if useSchemaRegistry = true |
| `brokerType` | Indicates if the cluster is company-based or application-based. Possible values: COMPANY, APPLICATION | COMPANY | YES |

Infrastructure properties example:

``` yaml
properties:
  type: CONFLUENT-ON-PREMISE
  brokers: server1.santander.gs.corp:port,server2.santander.gs.corp:port
  securityProtocol: SASL_SSL
  authorizationType: KERBEROS
  brokerUserId: BROKER_USER
  brokerPasswordId: BROKER_PASSWORD
  brokerKeytabId: BROKER_KEYTAB
  brokerPrincipalId: BROKER_PRINCIPAL
  brokerKerberosFileId: BROKER_KERBEROS
  schemaRegistryUserId: SCHEMA_USER
  schemaRegistryPasswordId: SCHEMA_PASSWORD
```

### Event Subscription

| Key         | Description | Example | Mandatory |
|-------------|-------------|---------|-----------|
| `type` | Name of the technology of the event cluster. Currently supported values: CONFLUENT-ON-PREMISE | CONFLUENT-ON-PREMISE | YES |
| `server` | Server and port where the event subscription will be made | server1:port | YES |
| `brokerType` | Indicates if the cluster is company-based or application-based. Possible values: COMPANY, APPLICATION | COMPANY | YES |
| `applicationGroupId` | Name of the credential used for the group name | APPLICATION_GROUP | YES |
| `adminEventServerUserId` | Name of the credential used for the admin user name of the cluster | ADMIN_EVENT_USER | YES |
| `adminEventServerPasswordId` | Name of the credential used for the admin user password of the cluster | ADMIN_EVENT_PASSWORD | YES |

Infrastructure properties example:

``` yaml
properties:
  type: CONFLUENT-ON-PREMISE
  server: server1.santander.gs.corp:port
  brokerType: COMPANY
  authorizationType: KERBEROS
  applicationGroupId: APPLICATION_GROUP
  adminEventServerUserId: ADMIN_EVENT_USER
  adminEventServerPasswordId: ADMIN_EVENT_PASSWORD
```

### Appian

| Key                 | Description                                                                                           | Example         | Required |
|---------------------|-------------------------------------------------------------------------------------------------------|-----------------|----------|
| `type`              | Name of the technology of the event cluster                                                           | APPIAN          | Yes      |
| `username`          | Username identifier for authentication (required for user authorization)                              | APPIAN_USER     | Conditional |
| `password`          | Password identifier for authentication (required for user authorization)                              | APPIAN_PASSWORD | Conditional |
| `apiKey`            | API key identifier for authentication (required for API key authorization)                            | APPIAN_KEY      | Conditional |
| `url`               | URL of the Appian instance                                                                            | <https://santanderargentina-test.appiancloud.com/suite/> | Yes |
| `brokerType`        | Indicates if the cluster is company-based or application-based. Possible values: COMPANY, APPLICATION | APPLICATION     | Yes      |
| `authorizationType` | Authentication method to use. Valid values: `USER` (default), `APIKEY`                               | USER            | No       |

#### Authorization Types

**User Authorization (Default)**: Uses the Java-based Appian ADM Import Client with username/password authentication.

**API Key Authorization**: Uses Appian's Applications Import REST API with API key authentication. When using this method:

- `username` and `password` are not required
- An `APPIAN_KEY` secret must be configured with appropriate deployment permissions
- Requires Appian version that supports the Applications Import API endpoint

Infrastructure properties examples:

=== "User Authorization (Default)"

    ```yaml
    properties:
      type: APPIAN
      username: APPIAN_USER
      password: APPIAN_PASSWORD
      url: https://santanderargentina-test.appiancloud.com/suite/
      brokerType: APPLICATION # COMPANY / APPLICATION
      authorizationType: USER # Optional, defaults to USER if omitted
    ```

=== "API Key Authorization"

    ```yaml
    properties:
      type: APPIAN
      apiKey: APPIAN_KEY
      url: https://santanderargentina-test.appiancloud.com/suite/
      brokerType: APPLICATION # COMPANY / APPLICATION
      authorizationType: APIKEY
    ```

    **Note**: When using `APIKEY` authorization, ensure the `APPIAN_KEY` secret is configured in your repository secrets.

## **Registries Infrastructures**

#### **Harbor**

| Key           | Description                                                               | Example                                             |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------   |
| `type`        | Artifact storage type                                                     | harbor                                              |
| `registry`    | Artifact registry URL                                                     | registry.global.ccc.srvb.bo.paas.cloudcenter.corp   |
| `project-path`| Project path in the artifact registry                                     | app360-cert                                         |
| `usernameId`  | Username identifier for authentication                                    | REGISTRY_BO_USERNAME                                |
| `passwordId`  | Password identifier for authentication                                    | REGISTRY_BO_PASSWORD                                |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `snapshots`   | If it is true it will push to registry in release wf                      | true                                                |

#### **Artifactory**

| Key           | Description                                                                 | Example                                           |
| ------------- | --------------------------------------------------------------------------- | -----------------------------------------------   |
| `type`        | Type of container registry                                                  | artifactory                                       |
| `registry`    | URL of the container registry                                               | artifactory.santanderbr.corp                      |
| `project-path`| Project path in the registry                                                | docker-snapshot/dvp                               |
| `usernameId`  | ID of the user for authentication                                           | ARTIFACTORY_USERNAME_TEST                         |
| `passwordId`  | ID of the password for authentication                                       | ARTIFACTORY_PASSWORD_TEST                         |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `snapshots`   | If it is true it will push to registry in release wf                        | true                                              |

#### **ECR**

| Key           | Description                                                                 | Example                                           |
| ------------- | --------------------------------------------------------------------------- | -----------------------------------------------   |
| `type`        | Type of container registry                                                  | ecr                                               |
| `registry`    | URL of the container registry                                               | 665313331585.dkr.ecr.eu-west-1.amazonaws.com      |
| `project-path`| Project path in the registry                                                | sgt-app360                                        |
| `usernameId`  | ID of the user for authentication                                           | GLUON_AWS_ACCESS_KEY_ID                           |
| `passwordId`  | ID of the password for authentication                                       | GLUON_AWS_SECRET_ACCESS_KEY_ID                    |
| `role`        | Role in AWS                                                                 | AccountAutomationNonPro                           |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `snapshots`   | If it is true it will push to registry in release wf                        | true                                              |

#### **ACR**

| Key           | Description                                                                 | Example                                           |
| ------------- | --------------------------------------------------------------------------- | -----------------------------------------------   |
| `type`        | Type of container registry                                                  | acr                                               |
| `registry`    | URL of the container registry                                               | sgtacrprueba.azurecr.io                           |
| `project-path`| Project path in the registry                                                | sgt-app360-cert                                   |
| `usernameId`  | ID of the user for authentication                                           | AZ_USERNAME                                       |
| `passwordId`  | ID of the password for authentication                                       | AZ_PASSWORD                                       |
| `account`     | Azure account                                                               | sgtd2glbsubgeneriglob001                          |
| `tenant`      | Azure tenant ID                                                             | 35595a02-4d6d-44ac-99e1-f9ab4cd872db              |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `snapshots`   | If it is true it will push to registry in release wf                        | true                                              |

#### **OPENSHIFT**

| Key                 | Description                                                           | Example                                          |
|---------------------|-----------------------------------------------------------------------|--------------------------------------------------|
| `type`              | Type of container registry                                            | OPENSHIFT_REGISTRY                               |
| `registry`          | URL of download image registry                                        | image-registry.openshift-image-registry.svc:5000 |
| `internal-registry` | URL of the container registry                                         | registry.dev.paas.santanderbr.dev.corp           |
| `project-path`      | Project path in the registry                                          | dvp-dev                                          |
| `usernameId`        | ID of the user for authentication                                     | OC_REGISTRY_USER_DEV                             |
| `passwordId`        | ID of the password for authentication                                 | OC_REGISTRY_PASS_DEV                             |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                            |
| `snapshots`         | If it is true it will push to registry in release wf | true           | true                                             |

#### **QUAY**

| Key           | Description                                                                 | Example                                           |
| ------------- | --------------------------------------------------------------------------- | -----------------------------------------------   |
| `type`        | Type of container registry                                                  | quay                                              |
| `registry`    | URL of the container registry                                               | registry.ar.bsch                                  |
| `project-path`| Project path in the registry                                                | gluon-adoption                                    |
| `usernameId`  | ID of the user for authentication                                           | QUAYPUSH_USER                                     |
| `passwordId`  | ID of the password for authentication                                       | QUAYPUSH_PWD                                      |
| `credentialsFromVault`| If credentials are obtained from a vault, by default: false         | false                                                                   |
| `snapshots`   | If it is true it will push to registry in release wf                        | true

## **More Info**

- [OAM Configuration](gluon-application-model-oam-config.md){:target="_blank"}
- [OAM Example](oam-example.md){:target="_blank"}
