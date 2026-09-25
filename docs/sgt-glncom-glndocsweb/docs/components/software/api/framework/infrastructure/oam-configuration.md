# OAM Configuration

For each technology, we must configure the infrastructure data specific to that technology. The provided information will be used during the deployment of the APIs and Products.
The configuration properties can vary based on the exposure in which the API is published (Client or Core).

The infrastructure data will be configured in the Gluon Application Model component created in the application where APIs and Products are going to be deployed.
Each of the infrastructure configurations included in the component has a unique identifier (ci_id) for each configured environment.

> **IMPORTANT:** The absence or incorrect configuration of the infrastructure parameters can cause deployment or execution errors of the APIs.

### Infrastructure data for IBM deployment

Infrastructure properties table:

| Parameter | Description | Example | Mandatory |
|-----------|-------------|---------|---------|
| type | Name of the technology, IBM or APIGEE | IBM | YES |
| company | Name of the company | scib | YES |
| exposure | Two possible values, intranet or internet  | intranet | YES |
| security-type | Two possible values, client or core  | client | YES |
| mode | Two possible values, live or sandbox  | live | YES |
| manager-url | URL API Manager, used for deploy APIs  | <https://api-dev.ibm.net>  | YES |
| kid |  ID of the public key that will be set in "kid" token header | scibintranet | YES |
| private-key-id | ID of the key that will be used for signing the JWT token | scibintranet-key | YES |
| sca-iss | The issuer of the token. The value is a string with the issuer | santander | NO |
| sca-token-type | Two possible values, jwe or jws  | intranet | NO |
| manager-subscription-user | User for subscription used in the API Manager  | MANAGER_SUSCRIPTION_USER_DEV | YES |
| manager-subscription-password | Id github secret reference password for subscription used in the API Manager  | MANAGER_SUSCRIPTION_PASS_DEV | YES |
| organization | API Manager organization to deploy APIs  | cib | YES |
| catalog | API Manager catalog to deploy APIs | intranet | YES |
| space | Two possible values, true or false  | true | YES |
| service | Datapower gateway service name to deploy APIs   | intranet-client | YES |
| realm | API Manager realm to log with the deployment/subscription users | provider/apim | YES |
| clientId-toolkit | id github secret contains client Id for API Connect toolkit  | CLIENT_ID_TOOLKIT_DEV | YES |
| client-secret-toolkit | Id github secret contains client secret for API Connect toolkit  | CLIENT_SECRET_TOOLKIT_DEV| YES |
| producer-org-id | Producer organization id. Identified in the API Manager  | 17243bb37-812734935 | Deprecated. Replaced by the field organization |
| catalog-id | Catalog identifier. Identified in the API Manager  | 17243bb37-812734935 | Deprecated. Replaced by the field catalog |
| catalog-original-id | Catalog original identifier  | 17243bb37-812734935 | Deprecated. Replaced by the field identity-provider |
| identity-provider| Identity provider data from API Connect catalog  | cib-user-registry | YES |
| gateway-service-url | Service URL to consume API  | <https://intranet-client-santander.corp/> | YES |
| oauth-url-management | URL to manage SOS operations  | <https://sos-url> | Only for client |
| oauth-user | Github secret contains user to login in oauth server  | OAUTH_USER_DEV | Only for client |
| oauth-type | Type of oauth server, SOS  | sos | Only for client |
| oauth-pass | ID of the github secret contains oauth password | OAUTH_PASS_DEV | Only for client |
| authorization-url | Oauth server authorization url | <https://oauth-sos-authorization-url> | Only for client |
| token-url | Oauth server token url  | <https://oauth-sos-token-url> | Only for client |
| introspect-url | Oauth server introspect url  | <https://oauth-sos-introspect-url> | Only for client |
| x-ibm-oauth-provider | Name of oauth provider created in api manager  | sos-oauth-provider | Only for client |
| credentialUserId | ID of the github secret contains api connect user| APICONNECT_USER_DEV | YES |
| credentialPassId | ID of the github secret contains api connect password | APICONNECT_PASS_DEV | YES |
| consumer-org-owner-user-name | User name used when consumer organization of technical application is created in ibm | user | YES |
| consumer-org-owner-first-name | First name used when consumer organization of technical application is created in ibm | name | YES |
| consumer-org-owner-last-name | Last name used when consumer organization of technical application is created in ibm  | lastname | YES |
| consumer-org-owner-email | Email used when consumer organization of technical application is created in ibm  | <account@example.com> | YES |
| iss-enforced | Enforces the use of the iss property from OAM. If the `iss` property is set in the API, it will be ignored. | true | NO |
| iss | Sets the value for the iss API property. | testiss | NO |
| ibm-consumer-api| Indicates if IBM consumer API is enabled | true | NO |
| ibm-consumer-api-url| URL for IBM consumer API | <https://api-consumer-test.sgtech.dev.corp> | NO |
| clientId-toolkit-consumer| ID of the github secret contains client ID for API Connect toolkit consumer | CLIENT_TOOLKIT_CONSUMER | NO |
| client-secret-toolkit-consumer| ID of the github secret contains client secret for API Connect toolkit consumer | SECRET_TOOLKIT_CONSUMER | NO |
| ibm-drafts | Indicates if IBM API/product drafts are created in API Connect| true | NO |
| x-santander-client-id | Indicates if x-santander-client-id header should be used as apikey instead of X-IBM-Client-Id| true | NO |

???+ warning

    All tags defined in the “*oam-application-definition.yml*” file must have a value assigned to them. Its value cannot be an empty string.

Infrastructure properties example:

``` yaml
properties:
  type: IBM
  company: scib
  exposure: intranet
  security-type: client
  mode: live
  manager-url: https://api-dev.ibm.net
  credentialUserId: APICONNECT_USER_DEV
  credentialPassId: APICONNECT_USER_DEV_PASS
  kid: apimscib-intranet
  private-key-id: scibintranet-key
  sca-iss: santander
  sca-token-type: intranet
  manager-subscription-user: MANAGER_SUSCRIPTION_USER_DEV
  manager-subscription-password: MANAGER_SUSCRIPTION_PASS_DEV
  organization: cib
  catalog: intranet
  space: true
  service: intranet-client
  realm: provider/apim
  clientId-toolkit: CLIENT_ID_TOOLKIT_DEV
  client-secret-toolkit: CLIENT_SECRET_TOOLKIT_DEV
  producer-org-id: 17243bb37-812734935
  catalog-id: 17243bb37-812734935
  catalog-original-id: 17243bb37-812734935
  identity-provider: cib-user-registry
  gateway-service-url: https://intranet-client-santander.corp/
  oauth-url-management: https://sos-url
  oauth-user: OAUTH_USER_DEV
  oauth-type: sos
  oauth-pass: OAUTH_PASS_DEV
  authorization-url: https://oauth-sos-authorization-url
  token-url: https://oauth-sos-token-url
  introspect-url: https://oauth-sos-introspect-url
  x-ibm-oauth-provider: sos-oauth-provider
  consumer-org-owner-user-name: test
  consumer-org-owner-first-name: test
  consumer-org-owner-last-name: test
  consumer-org-owner-email: test@test.com
  iss-enforced: true
  iss: testiss
  ibm-consumer-api: true
  ibm-consumer-api-url: https://api-consumer-test.sgtech.dev.corp
  clientId-toolkit-consumer: CLIENT_TOOLKIT_CONSUMER
  client-secret-toolkit-consumer: SECRET_TOOLKIT_CONSUMER
  ibm-drafts: true
  x-santander-client-id: true
```

To use the Consumer API, it is necessary to configure the following four parameters:

- `ibm-consumer-api`
- `ibm-consumer-api-url`
- `clientId-toolkit-consumer`
- `client-secret-toolkit-consumer`

If the property `ibm-consumer-api` is set to `true`, the following requests will be executed through the Consumer API, while the rest will continue to use the Provider API:

- Flow: createSubscription
    - Retrieve consumer organization
    - Create consumer application
    - Create subscription

> **IMPORTANT:** If the space parameter is configured with true value, during the API product deployment it will be checked if there is a space with the name of the technical application.<br>
> If the space does not exist it will be created by applying the gateway service and oauth configuration indicated in the ci id.<br>
> If the space exists and the gateway service or oauth provider specified in the ci id is not configured, the corresponding configuration will be added in the space.<br>

### Infrastructure data for apigee deployment

Infrastructure properties table:

| Parameter | Description | Example | Mandatory |
|-----------|-------------|---------|---------|
| type | Name of the technology, IBM or APIGEE | apigee | YES |
| company | Name of the company | scib | YES |
| exposure | Two possible values, intranet or internet  | intranet | YES |
| security-type | Two possible values, client or core  | core | YES |
| mode | Two possible values, live or sandbox  | live | YES |
| manager-url | URL API Manager, used for deploy APIs  | <https://api-dev.ibm.net>  | YES |
| credentialUserId | Github secret contains user for apigee | APIGEE_USER_DEV | YES |
| credentialPassId | Github secret contains password for APIGEE | APIGEE_PASS_DEV | YES |
| kid |  ID of the public key that will be set in "kid" token header | intranetkid | YES |
| private-key-id | ID of the key that will be used for signing the JWT token | intranetkey | YES |
| jwe-private-key-id | ID of the key that will be used for signing the JWE token | intranet | NO |
| sca-iss | The issuer of the token. The value is a string with the issuer | santander | NO |
| sca-token-type | Two possible values, JWE or JWS  | JWE | NO |
| manager-subscription-user | Github secret reference user for subscription used in the API Manager  | MANAGER_SUSCRIPTION_USER_DEV | YES |
| manager-subscription-password | Github secret reference password for subscription used in the API Manager  | MANAGER_SUSCRIPTION_PASS_DEV | YES |
| organization | API Manager organization to deploy APIs  | intranet | YES |
| execution-environment | Environment name from apigee | intranet | YES |
| virtual-host | Virtual host | default | YES |
| virtual-host-url | Virtual host URL | <http://consume-api> | YES |
| company-developer-administrator-email | Email used when company of technical application is created in apigee | <santander.developer.svc@gruposantander.com> | YES |
| company-developer-administrator-firstName | First name used when company of technical application is created in apigee | Santander Developer | YES |
| company-developer-administrator-lastName | Last name used when company of technical application is created in apigee | Service Account | YES |
| oauth-url-management | URL to manage SOS operations  | <https://sos-url> | Only for client |
| oauth-user | Github secret contains user to login in oauth server  | OAUTH_USER_DEV | Only for client |
| oauth-type | Type of oauth server, SOS or keycloak  | sos | Only for client |
| oauth-pass | ID of the github secret contains oauth password | OAUTH_PASS_DEV | Only for client |
| authorization-url | Oauth server authorization url | <https://cibsos.dev.corp> | Only for client |
| token-url | Oauth server token url  | <https://cibsos-token.dev.corp> | Only for client |
| introspect-url | Oauth server introspect url  | <https://introspect> | Only for client |

Infrastructure properties example:

``` yaml
properties:
  type: apigee
  company: scib
  exposure: intranet
  security-type: core
  mode: live
  manager-url: https://api-dev.ibm.net
  credentialUserId: APIGEE_USER_DEV
  credentialPassId: APIGEE_PASS_DEV
  kid: intranetkid
  private-key-id: intranetkey
  jwe-private-key-id: intranet
  sca-iss: santander
  sca-token-type: JWE
  manager-subscription-user: MANAGER_SUSCRIPTION_USER_DEV
  manager-subscription-password: MANAGER_SUSCRIPTION_PASS_DEV
  organization: intranet
  execution-environment: intranet
  virtual-host: default
  virtual-host-url: http://consume-api
  company-developer-administrator-email: santander.developer.svc@gruposantander.com
  company-developer-administrator-firstName: Santander Developer
  company-developer-administrator-lastName: Service Account
  oauth-url-management: https://sos-url
  oauth-user: OAUTH_USER_DEV
  oauth-type: sos
  oauth-pass: OAUTH_PASS_DEV
  authorization-url: https://cibsos.dev.corp
  token-url: https://cibsos-token.dev.corp
  introspect-url: https://introspect
```

### Infrastructure data for AWS deployment

Infrastructure properties table:

| Parameter | Description | Example | Mandatory |
|-----------|-------------|---------|-----------|
| type | Name of the technology, IBM or APIGEE | AWS_API_GATEWAY | YES |
| company | Name of the company | gluon-paas | YES |
| exposure | Two possible values, intranet or internet | intranet | YES |
| security-type | Two possible values, client or core | client | YES |
| mode | Two possible values, live or sandbox | live | YES |
| oauth-url-management | URL to manage SOS operations | <https://example.corp> | Only for client |
| oauth-user | Secret contains user to login in oauth server | SOS_USER_DEV_GRAVITY | Only for client |
| oauth-pass | ID of the secret contains oauth password | SOS_USER_DEV_PASS_GRAVITY | Only for client |
| oauth-type | Type of oauth server, SOS or keycloak | SOS | Only for client |
| authorization-url | Oauth server authorization url | <https://example.com/oauth2/authorize> | Only for client |
| token-url | Oauth server token url | <https://example.com/oauth2/token> | Only for client |
| introspect-url | Oauth server introspect url | <https://example.com/oauth2/introspect> | Only for client |
| aws-access-key-id-subscription | AWS access key ID for subscription | AWS_ACCESSKEY_DEV_GLUONPAAS | YES |
| aws-secret-access-key-subscription | AWS secret access key for subscription | AWS_SECRET_DEV_GLUONPAAS | YES |
| aws-role-id-subscription | AWS role ID for subscription | exampleRoleId | YES |
| aws-access-key-id | AWS access key ID | AWS_ACCESSKEY_DEV_GLUONPAAS | YES |
| aws-secret-access-key | AWS secret access key | AWS_SECRET_DEV_GLUONPAAS | YES |
| vpc-link-id | VPC link ID | 123rtyu | NO |
| vpc-endpoint-ids | VPC endpoint IDs | vpce-123345 | NO |
| aws-account-id | AWS account ID | 123456 | YES |
| aws-region | AWS region | eu-west-1 | YES |
| domain-name | Domain name | intra-cli-api.gs.corp | YES |
| domain-url | Domain URL | intra-cli-api.gs.corp | YES |
| aws-role-id | AWS role ID | exampleRoleId | YES |
| kid | ID of the public key that will be set in "kid" token header | intranetPubKid | YES |
| ifa-apigw-tag | Internet facing assets tag, valid value: true. [More information](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/DP-NET-00X%20-%20Internet-Facing-Assets%20APIGW.aspx)| true | NO |
| kms-s3bucket | Indicates if KMS is used for the S3 bucket. This parameter can be used without kms-s3bucket-id. | true | NO |
| kms-s3bucket-id | ID of the KMS S3 bucket. This parameter cannot be used without kms-s3bucket. | 1234kmsid | NO |
| authorizer-enforced | Establishes the requirement to configure an authorizer for all API operations. | true | NO |

Infrastructure properties example:

``` yaml
properties:
  type: AWS_API_GATEWAY
  company: gluon-paas
  exposure: intranet
  security-type: client
  mode: live
  oauth-url-management: 'https://example.corp'
  oauth-user: SOS_USER_DEV_GRAVITY
  oauth-pass: SOS_USER_DEV_PASS_GRAVITY
  oauth-type: SOS
  authorization-url: https://example.com/oauth2/authorize
  token-url: https://example.com/oauth2/token
  introspect-url: https://example.com/oauth2/introspect
  aws-access-key-id-subscription: AWS_ACCESSKEY_DEV_GLUONPAAS
  aws-secret-access-key-subscription: AWS_SECRET_DEV_GLUONPAAS
  aws-role-id-subscription: exampleRoleId
  aws-access-key-id: AWS_ACCESSKEY_DEV_GLUONPAAS
  aws-secret-access-key: AWS_SECRET_DEV_GLUONPAAS
  vpc-link-id: 123rtyu
  vpc-endpoint-ids: vpce-123345
  aws-account-id: '123456'
  aws-region: eu-west-1
  domain-name: intra-cli-api.gs.corp
  domain-url: intra-cli-api.gs.corp
  aws-role-id: exampleRoleId
  ifa-apigw-tag: true
  kid: intranetPubKid
  kms-s3bucket: true
  kms-s3bucket-id: 12345
  authorizer-enforced: true
```
