# Gluon API policies framework

Gluon has accepted the following policies for Apigee, AWS and IBM API Connect v10. The deployment archetype framework includes some policies for each API Manager.

**It is mandatory that before deploying an API, the policies are installed in the API Manager because otherwise the deployment or execution will fail.**

Policy repositories are being migrated to Security team repositories. Consideration should be given to the information contained in the current repositories, where instructions on how to access the new versions are shown.

## V1.6.6

### 1. Apigee list of Gluon policies

Policies included in the deployment archetype

- gln-cors
- gln-verify-client-id
- gln-authorization-validation
- gln-jwsid-validate
- gln-jwsid-generate
- gln-cosac
- gln-error-control
- gln-set-app-name-header
- gln-whitelist
- gln-blacklist
- gln-sca-operative-signature
- gln-rate-limit
- gln-burst-limit
- gln-json-message-validation
- gln-obfuscation
- gln-set-target
- gln-schema-validation-request
- gln-schema-validation-response

The complete list of the Apigee policies table:

|Gluon policy|Versions|Type of policy|Description|Repositories|
|------------|--------|------|-----------|------------|
|gln-set-target|1.0.0|API management policy|This JavaScript will be used with assign message policy in the target endpoints of the API proxies|It is a policy includes in the deployment archetype|
|gln-jwsid-generate| 2.4.0| Security policy | Generate a JWSId token based in these [requirements](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Identity-%26-SAA-JWT-claims(1).aspx).| [gln-jwsid-generate](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-generate-jwsid)|
|gln-authorization-validation|1.0.1|Security policy| It validates the access token against an external Oauth Server (SOS) or decrypto/verify JWE token. CheckScope policy included.|[gln-authorization-validation](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-authorization-validation/tree/1.0.1)|
| gln-jwsid-validate | 1.5.0| Security policy | Validate a JWSId token against a public key within of the gateway|[gln-jwsid-validate](https://github.com/santander-group-shared-assets/gln-apis-apigee-validate-jwsid)|
| gln-cosac | 2.0.1| Security policy |This Shared Flow executes a Channel Operation Control using data received in the request|[gln-cosac](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-cosac-control/tree/2.0.1)|
|gln-whitelist| 1.0.1|Security policy|In order to control wanted connections from certain API consumers, an IP control policy that belongs to a whitelist is established.|[gln-whitelist](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-whitelist/tree/1.0.1)|
|gln-blacklist| 1.0.1|Security policy|In order to control unwanted connections from certain API consumers, an IP control policy that belongs to a blacklist is established.|[gln-blacklist](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-blacklist/tree/1.0.1)|
|gln-cors| 2.0.2 |API management policy| Cross-Origin Resource Sharing (CORS) is a mechanism that uses additional HTTP headers to allow a user agent (en-US) to get permission to access selected resources from a server, on a different origin (domain) to which it belongs.| [gln-cors](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-cors/tree/2.0.2) |
|gln-set-app-name-header| 1.0.0|API management policy|Set a header needed to Arsenal framework.|[gln-set-app-name-header](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-set-appname-header/tree/1.0.0)|
|gln-rate-limit| 1.0.0 |API management policy| APIGEE policy, apply quota stablish in product to the API| [gln-rate-limit](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-rate-limit/tree/1.0.0) |
|gln-burst-limit| 1.0.0 |API management policy| APIGEE policy, apply total quota stablish in API| [gln-burst-limit](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-burst-limit/tree/1.0.0) |
|gln-verify-client-id| 1.0.3|Security policy|Validate subscription with client id.|[gln-verify-client-id](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-verify-clientId/tree/1.0.3)|
|gln-error-control| 1.1.0|API management policy|Stablish error format to Santander standard.|[gln-error-control](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-error-control/tree/1.0.1)|
|gln-obfuscation| 2.0.0|API management policy|This policy provides the necessary mechanisms to hide sensitive information found within certain fields.|[gln-obfuscation](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-obfuscation/tree/1.0.0)|
|gln-sca-operational-signature | 1.0.2|Security policy|In order to control unwanted connections from certain API consumers, an IP control policy that belongs to a blacklist is established.|[gln-sca-operational-signature](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-sca-operational-signature/tree/1.0.2)|
|gln-json-message-validation | 2.0.0 |API management policy|Use the Parse policy to control the parsing of an input document.|[gln-json-message-validation](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-json-validation/tree/2.0.0)|
|gln-schema-validation-request | 1.0.0 |API management policy|Validate request input schema against api definition.|It is a policy includes in the deployment archetype|
|gln-schema-validation-response | 1.0.0 |API management policy|Validate response schema against api definition.|It is a policy includes in the deployment archetype|

### Infrastructure security global policies

|Gluon policy|Versions|Type of policy|Description|Repositories|
|------------|--------|------|-----------|------------|
|SQL Injection & NoSQL Injection| 1.0.0|Security policy|Establish the necessary controls to prevent SQL & No SQL Injection attacks.|[SQL Injection & NoSQL Injection](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-sql-injection-nosql-injection/tree/1.0.0)|
|OS Command Injection| 1.0.0|Security policy|Establish the necessary controls to prevent OS Command Injection attacks.|[OS Command Injection](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-sql-injection-nosql-injection-os-command-injection/tree/1.0.0)|
|LDAP Injection| 1.0.0|Security policy|Establish the necessary controls to prevent LDAP Injection attacks.|[LDAP Injection](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-sql-injection-nosql-injection-ldap-injection/tree/1.0.0)|
|OS Command Injection & LDAP Injection| 1.0.0|Security policy|Establish the necessary controls to prevent OS Command Injection attacks & LDAP Injection attacks.|[OS Command Injection & LDAP Injection](https://github.com/santander-group-shared-assets/gln-apis-apigee-policies-sql-injection-nosql-injection-ldap-injection-os-command-injection/tree/1.0.0)|

About type of policies:

- **`API Management`**: policies used to make functionalities work according to the group's standards.
- **`Security policies`**: policies to guarantee the security defined by Cybersecurity.

  :link: API security policies documentation [here](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/API-Security-Policies.aspx)

### 2. IBM API Connect v10 policies

> NOTE: At the moment, these policies were agreed with Santander SCIB, HQ and Totta (they are migrating from v5 to v10) in order to align all policies.

Policies included in the deployment archetype

- cors
- gln-jwsid-validate
- gln-jwsid-generate
- gln-cosac
- gln-whitelist
- gln-blacklist
- gln-sca-operative-signature
- gln-json-message-validation
- gln-obfuscation
- invoke
- validate

The complete list of the IBM policies table:

|Gluon policy|Versions|Type of policy|Description|Repositories|
|------------|--------|------|-----------|------------|
| gln-obfuscation | 2.0.0|API management policy|This policy provides the necessary mechanisms to hide sensitive information found within certain fields.|[gln-obfuscation](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-obfuscation/tree/2.0.0)|
| gln-sca-operational-signature | 1.1.1|Security policy|In order to control unwanted connections from certain API consumers, an IP control policy that belongs to a blacklist is established.|[gln-sca-operational-signature](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-sca-operational-signature/tree/1.1.1)|
|parse| 2.0.0 |API management policy|Use the Parse policy to control the parsing of an input document.|It is a policy includes in the deployment archetype [parse](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=policies-parse)|
|invoke| 2.3.0|API management policy|Apply the Invoke policy to call another service from within your assembly.|It is a policy includes in the deployment archetype [invoke](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=policies-invoke)|
|gln-whitelist| 1.0.1|Security policy|In order to control wanted connections from certain API consumers, an IP control policy that belongs to a whitelist is established.|[gln-whitelist](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-whitelist/tree/1.0.1)|
|gln-blacklist| 1.0.1|Security policy|In order to control unwanted connections from certain API consumers, an IP control policy that belongs to a blacklist is established.|[gln-blacklist](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-blacklist/tree/1.0.1)|
|CORS| 1.0.0|API management policy|Cross-Origin Resource Sharing (CORS) is a mechanism that uses additional HTTP headers to allow a user agent (en-US) to get permission to access selected resources from a server, on a different origin (domain) to which it belongs.|It is a policy includes in the deployment archetype|
| gln-jwsid-generate | 2.3.0| Security policy | Generate a JWSId token based in Cybersecurity [requirements](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Identity-%26-SAA-JWT-claims(1).aspx).|[gln-jwsid-generate](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-generate-jwsid/tree/2.3.0)|
| gln-jwsid-validate | 2.0.0|Security policy | Validate a JWSId token |[gln-jwsid-validate](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-validate-jwsid/tree/2.0.0)|
| gln-cosac | 2.0.1| Security policy | This policy executes a Channel Operation Control using data received in the request based in Cybersecurity [requirements](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Channel-operational-security.aspx).|[gln-cosac](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-cosac-control/tree/2.0.1)|
|validate| 2.0.0 |API management policy|Validate request body against schema definition.|It is a policy includes in the deployment archetype [validate](https://www.ibm.com/docs/en/api-connect/10.0.5.x_lts?topic=policies-validate-datapower-api-gateway)|

### Infrastructure security global policies

|Gluon policy|Versions|Type of policy|Description|Repositories|
|------------|--------|------|-----------|------------|
|SQL Injection & NoSQL Injection| 1.0.0|Security policy|Establish the necessary controls to prevent SQL Injection & NoSQL Injection attacks.|[SQL Injection & NoSQL Injection](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-sql-injection-nosql-injection/tree/1.0.0)|
|OS Command Injection| 1.0.0|Security policy|Establish the necessary controls to prevent OS Command Injection attacks.|[OS Command Injection](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-sql-injection-nosql-injection-os-command-injection/tree/1.0.0)|
|LDAP Injection| 1.0.0|Security policy|Establish the necessary controls to prevent LDAP Injection attacks.|[LDAP Injection](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-sql-injection-nosql-injection-ldap-injection/tree/1.0.0)|
|OS Command Injection & LDAP Injection| 1.0.0|Security policy|Establish the necessary controls to prevent OS Command Injection & LDAP Injection attacks.|[OS Command Injection & LDAP Injection](https://github.com/santander-group-shared-assets/gln-apis-ibm-policies-sql-injection-nosql-injection-ldap-injection-os-command-injection/tree/1.0.0)|

About type of policies:

- **`API Management`**: policies used to make functionalities work according to the group's standards.
- **`Security policies`**: policies to guarantee the security defined by Cybersecurity.<br>:link: API security policies documentation [here](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/API-Security-Policies.aspx)

### 3. AWS list of Gluon policies

#### Integration

- **Integration types**:
  - vpc-link
  - lambda:
    - aws
    - aws_proxy

#### Authorizer

- **Authorizer types**:
  - lambda
