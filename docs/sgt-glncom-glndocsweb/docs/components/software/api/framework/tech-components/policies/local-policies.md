# Local policies configuration

For the use of local policies through the api deployment 2.0 component, it is necessary to generate a configuration file.

This configuration file is used to define properties, policies, and security in an API environment. Below is a description of how this file is generated.

## Repository Requirements

To make it work, it is necessary to have a repository within the organization where the policy configuration file will be uploaded.

The repository must follow this naming convention:  
`api-deployment-{entity short name}-security-local-policies`

### Requesting Repository Creation

To request the creation of the repository, a support ticket must be created in Gluon with the following description:  
**Creation of the repository for managing API local policies for the entity {entity}**

Once the ticket is processed, the repository will be created, and privileges will be assigned to the Local Head of APIs as follows:

- The following teams corresponding to the Local Head of APIs groups:
  - `GR_ALMNXTGN_{entity short name}-PCT-APIH_CTM`: Maintain permissions.
  - `GR_ALMNXTGN_{entity short name}-PCT-APID_CTM`: Write permissions.

### Uploading the Configuration File

Once the repository is created, the configuration file must be uploaded following this naming convention:  
`api-deployment-{entity short name}-security-local-policies`

Below is an explanation of how to generate the file.

## Create configuration file

### Configuration Parameters

General configuration parameters that apply to the nodes of the policies file

- **Properties**: Values that will be loaded in the properties section of the API, the user must indicate key:value
- **security**: Indicates the security scheme associated with a deployment profile. The property on which the values will be loaded in the output is securitySchemes
- **base-policies**: List of allowed deployment profiles for the api-deployment, contains the profile name and the mandatory policies associated with the profile. Example:
authorization-code-cosac: [gln-jwsid-generate, gln-cosac, gln-invoke]
- **version**: Current version of the local archetype
- **policies**: List of all available policies

### Version

The version of the file is specified in the first line:

```yaml
version: 1.1.8
```

### Properties

Properties that are created in the APIs with the specified key-value. Depending on the technology, the properties are created differently:

**IBM**: Properties are created as API properties, available during API execution.
**APIGEE**: Properties are created within the AM_Global policy (Assign Message), available during API execution.

The properties are divided into three sections: protected, default, and custom.

- **protected**: Protected data that the user cannot modify.
- **default**: Default data that the user can modify in the values.yml files.
- **custom**: Data that the user can or must modify, loaded in values.yml depending on the configuration of the optional parameter.

Example:

```yaml
properties:
  protected: # api-config.yml
    private-key-id: <%= priv-key %> # Mandatory
    kid: <%= kid %>
    jwe-private-key-id: fromCiId
  default: # api-config.yml
    exp: 60 #default
    nbf-delay: 3 #default
    introspection: true
  custom:
    aud: APIAudience
    api-client-id: APIClientId
```

### Base policies

List of allowed deployment profiles for the api-deployment, contains the profile name and the mandatory policies associated with the profile.

```yaml
base-policies:
  test-client-credentials: [test-apigee-jwt-generate]
  test-jwt: [test-apigee-mutual-tls, test-apigee-jwt-generate]
```

### Exposure

The exposure of the profiles defined in base-policies

```yaml
exposure:
  client: [test-client-credentials]
  core: [test-jwt]
```

### Policies

Specific policies are defined in the policies section. Each policy has various properties such as optional, priority, level, type, default, protected, and custom.

- **protected**: Protected data that the user cannot modify.
- **default**: Default data that the user can modify in the values.yml files.
- **custom**: Data that the user can or must modify in the values.yml files.
- **priority**: Sets the execution order of the policy. If two or more policies have the same priority value, they will be executed in no specific order, after the policies with higher priority values have been executed.
- **level**: Indicates the application level of the policy, based on this value the policy will be introduced in a specific part of the assembly. Allowed values
    - **api**: Applies the configuration at the first level.
    - **operation**: Applies the configuration at the operation level.
- **optional**: Indicates the obligation to apply the policy, there are 4 possible values:
    - **true**: Optional policies are not inserted in the values.yml files, but their protected and default values are inserted within the api config.
    - **false**: Mandatory policies are always inserted.
    - **base**: It is mandatory if it is on the base-policies list, both in values and in api-config.

```yaml
policies:
  test-apigee-set-appian-header:
    optional: true
    priority: 30
    level: api
    type: request
    default:
    protected:
      version: 1.0.0
      title: test-apigee-set-appian-header
    custom:
      test-special-policy.configuration: USER CONFIGURATION JSON FORMAT
```

It is mandatory to always introduce the name and title of the custom policy as protected parameters.

```yaml
  gln-jwsid-validate:
    optional: base # Only specific security profile
    priority: 50
    level: operation
    protected:
      title: gln-jwsid-validate
      version: 1.4.1
    default:
    custom:
    type: request
```

#### Know the priority of global policies

When using a local profile, in addition to local policies, global policies are also available as optional policies.
If global policies are to be used in conjunction with local policies, it is important to set the priority of the local policies knowing the priority of the global policies.
This way, it can be controlled whether the global or local policy is executed first.

For example, if the local policy jwt-generate has priority 51, and the policy gln-jwsid-validate with priority 50 is used, it means that after the gln-jwsid-validate policy, the local policy jwt-generate will be executed.

##### IBM global policies priority

| Policy Name                    | Level     | Priority |
|--------------------------------|-----------|----------|
| gln-blacklist                  | api       | 10       |
| gln-whitelist                  | api       | 10       |
| cors                           | api       | 20       |
| parse                          | operation | 30       |
| validate                       | operation | 40       |
| gln-jwsid-validate             | operation | 50       |
| gln-sca-operational-signature  | operation | 60       |
| gln-jwsid-generate             | operation | 70       |
| gln-cosac                      | operation | 80       |
| invoke                         | operation | 100      |
| gln-obfuscation                | operation | 110      |

##### APIGEE global policies priority

| Policy Name                         | Level       | Priority |
|-------------------------------------|-------------|-----------|
| gln-verify-client-id                | api         | 10        |
| gln-burst-limit                     | api         | 20        |
| gln-blacklist                       | api         | 30        |
| gln-whitelist                       | api         | 30        |
| gln-set-app-name-header             | api         | 30        |
| gln-authorization-validation        | operation   | 50        |
| gln-jwsid-validate                  | operation   | 50        |
| gln-rate-limit                      | operation   | 60        |
| gln-sca-operational-signature       | operation   | 70        |
| gln-schema-validation-request       | operation   | 70        |
| gln-json-message-validation         | operation   | 70        |
| gln-jwsid-generate                  | operation   | 80        |
| gln-cosac                           | operation   | 90        |
| gln-set-target                      | operation   | 100       |
| gln-schema-validation-response      | operation   | 110       |
| gln-obfuscation                     | operation   | 120       |
| gln-cors                            | api         | 130       |
| gln-error-control                   | api         | 150       |

#### Add configuration properties in local policies

It is possible to add configuration properties in local policies, there are two supported formats:

- Policy properties
- JSON object with policy properties

##### Policy properties

To define the configurable properties of the custom policy, it is necessary to add each of the properties within custom properties.

Example, file local-policies:

```yaml
  test-apigee-jwt-generate:
    optional: base
    priority: 130
    level: api
    protected:
      title: test-apigee-jwt-generate
      version: 1.0.0
    default:
    custom:
      customer-value: USER CONFIGURATION
      contract-value: USER CONFIGURATION
    type: request
```

During the API deployment, the defined properties can be configured in the values-apigee.yml file.

Example, file values:

```yaml
policies:
  test-apigee-jwt-generate:
    customer-value: value1
    contract-value: value2
```

The value of this properties can be obtained during the execution of the policy with:

IBM

```javascript
context.get("local.parameter.customer-value");
context.get("local.parameter.contract-value");

```

APIGEE

```javascript
context.getVariable('customer-value');
context.getVariable('contract-value');
```

##### JSON object with policy properties

It is possible to generate a JSON that the policy can read during the execution of the API.
To do this, it is necessary to define the properties differently depending on the technology:

**IBM**:

Set a property called "configuration" and add the JSON properties inside in yml format.

Example file local-policies:

```yaml
policies:
  test-ibm-set-appian-header:
    optional: true
    priority: 30
    level: api
    type: request
    default:
    protected:
      version: 1.0.0
      title: test-apigee-set-appian-header
    custom:
      configuration: USER CONFIGURATION
```

Example, file values:

```yaml
policies:
  test-ibm-set-appian-header:
    configuration:
      customer-value: value1
      contract-value: value2
        inside-contract-value: value3
```

The policy property 'configuration' will have the following value during execution:

```json

            {
              "customer-value": "value1",
              "contract-value": "value2",
                {
                "inside-contract-value": "value3"
              }
            }

```

The value of this property can be obtained during the execution of the policy with:

```javascript
context.get("local.parameter.configuration");
```

**APIGEE**:

To generate the value of the policy property in JSON format, it is necessary to set the parameter name with this nomenclature: {parameterName}.configuration

Example file local-policies

```yaml
policies:
  test-apigee-set-appian-header:
    optional: true
    priority: 30
    level: api
    type: request
    default:
    protected:
      version: 1.0.0
      title: test-apigee-set-appian-header
    custom:
      appian.configuration: USER CONFIGURATION JSON FORMAT
```

Example, file values:

```yaml
policies:
  test-apigee-set-appian-header:
    appian.configuration:
      customer-value: value1
      contract-value: value2
        inside-contract-value: value3
```

The policy property 'appian.configuration' will have the following value during execution:

```json
            {
              "customer-value": "value1",
              "contract-value": "value2",
                {
                "inside-contract-value": "value3"
              }
            }

```

The value of this property can be obtained during the execution of the policy with:

```javascript
context.getVariable('appian.configuration');
```

### Security Configuration

Establish the available security sets for the profiles defined in `base-policies`.

Mandatory: All security definitions must contain the security scheme applied to the API and the client ID definition.

Allowed OAuth2 grant types:

- `clientCredentials`
- `authorizationCode`
- `implicit`

#### Example of client Security

```yaml
security:
  test-client-credentials:   # Name of profile defined in base-policies associated to this security scheme
    global:                  # Mandatory
      protected: # Mandatory
        AuthorizationCode:   # Name of the security profile
          description: Uk client credentials   # description of the security profile
          flows: # mandatory in oauth 2
            authorizationCode: # name of the grant type
              authorizationUrl: <%= authorization-url %> # apply if grant type is authorization code
              scopes: {}  # Mandatory for client profiles. Indicate that type of security needs scopes
              tokenUrl: <%= token-url %>  # Set tokenUrl for security profile. Obtain token url from OAM with this configuration
          type: oauth2 # apply only if oauth2
        X-Santander-Client-Id:  # Name of the client id header
          protected: # mandatory
            description: >- # mandatory
             This is the value of the client identifier issued to the client during
             the application registration process.
            in: header #mandatory
            name: X-Santander-Client-Id #mandatory
            type: apiKey #mandatory
      default:
      custom:
        scopes: {} # mandatory in client exposure
        x-client-auto-approve-scopes: {} # mandatory in client exposure
    operation:
      custom:
        scopes: {} # mandatory in client exposure
        x-client-auto-approve-scopes: {} # mandatory in client exposure
      default:
      protected:
```

Start by naming the profile under the `security` section. In this example, it is `test-client-credentials`.

Protected Properties:

- **AuthorizationCode**: Define the security profile name and provide a description.
- **Flows**: Specify the grant type (`authorizationCode`), authorization URL, scopes, and token URL.
- **Type**: Set the type to `oauth2` if applicable.
- **X-Santander-Client-Id**: Define the client ID header with a description, location (`in: header`), name, and type (`apiKey`).

#### Example of core Security

```yaml
  jwsid:
    global:
      protected:
        JWSID:  # Name of profile defined in base-policies associated to this security scheme
          type: http
          description: JWT security definition
          scheme: bearer
          bearerFormat: JWT
          x-ibm-bearer-validation-method: none
        X-IBM-Client-Id:  # mandatory
          description: >-
            This is the value of the client identifier issued to the client during
            the application registration process.
          in: header
          name: X-IBM-Client-Id
          type: apiKey
      default:
      custom:
    operation:
      custom:
      default:
      protected:
```

Start by naming the profile under the security section. In this example, it is `jwsid`.

Protected Properties:

- **JWSID**: Define the security profile name and provide a description.
  - **type**: Set to `http`.
  - **description**: Provide a description of the JWT security definition.
  - **scheme**: Set to `bearer`.
  - **bearerFormat**: Set to `JWT`.
  - **x-ibm-bearer-validation-method**: Set to `none`.
- **X-IBM-Client-Id**: Define the client ID header with a description, location (`in: header`), name, and type (`apiKey`).

### File example

```yaml
version: 1.1.8
properties:
  protected: # api-config.yml
    private-key-id: <%= priv-key %> # Mandatory
    kid: <%= kid %>
    jwe-private-key-id: fromCiId
  default: # api-config.yml
    exp: 60 #default
    nbf-delay: 3 #default
    introspection: true
  custom:
    aud: APIAudience
    api-client-id: APIClientId
base-policies:
  test-client-credentials: [test-apigee-jwt-generate]
  test-jwt: [test-apigee-mutual-tls, test-apigee-jwt-generate]
exposure:
  client: [test-client-credentials]
  core: [test-jwt]
policies:
  test-apigee-set-appian-header:
    optional: true
    priority: 30
    level: api
    type: request
    default:
    protected:
      version: 1.0.0
      title: test-apigee-set-appian-header
    custom:
      test-special-policy.configuration: USER CONFIGURATION JSON FORMAT
  test-apigee-mutual-tls:
    optional: base
    priority: 50
    level: api
    type: response
    default:
    protected:
      version: 1.0.0
      title: test-apigee-mutual-tls
    custom:
  test-apigee-get-jwks:
    optional: true
    priority: 20
    level: operation
    type: request
    default:
    protected:
      version: 1.0.0
      title: test-apigee-get-jwks
      introspect-url: <%= introspect-url %>
  test-apigee-jwt-generate:
    optional: base
    priority: 130
    level: operation
    protected:
      title: test-apigee-jwt-generate
      version: 1.0.0
    default:
    custom:
      test-custom-target-url: https://service-host
    type: request
security:
  test-client-credentials:
    global:
      protected:
        AuthorizationCode:
          description: Uk client credentials
          flows:
            authorizationCode:
              authorizationUrl: <%= authorization-url %>
              scopes: {} # values.yaml total scopes
              tokenUrl: <%= token-url %>
          type: oauth2
        X-Santander-Client-Id:
          protected:
            description: >-
             This is the value of the client identifier issued to the client during
             the application registration process.
            in: header
            name: X-Santander-Client-Id
            type: apiKey
      default:
      custom:
        scopes: {}
        x-client-auto-approve-scopes: {}
    operation:
      custom:
        scopes: {}
        x-client-auto-approve-scopes: {}
      default:
      protected:
  test-jwt:
    global:
      protected:
        JWSID:
          type: http
          description: UK JWT
          scheme: bearer
          bearerFormat: JWT
        X-Santander-Client-Id:
          protected:
            description: >-
             This is the value of the client identifier issued to the client during
             the application registration process.
            in: header
            name: X-Santander-Client-Id
            type: apiKey
      default:
      custom:
    operation:
      custom:
      default:
      protected:
```
