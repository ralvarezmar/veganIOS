The archetype for APIs deployment can handle different API Managers (currently, on Apigee OPDK and IBM API Connect v10) and allows to deploy APIs defined using the OpenAPI 3 specification.

## Deployment Archetype Repository

The deployment repository for certified APIs is based on an archetype. This archetype is invoked from a pipeline with the inputs of the API uploaded to the Gluon Marketplace,
the security profile and the technology of the API Managers in which the API will be deployed.

During this repository creation process, the necessary data from the selected API is obtained, such as operations, methods, schemas, etc., needed to generate the main files of the deployment repository.

## Structure

The archetype generates a repository with the following structure:

``` bash

📦repository
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon
 ┃ ┣ 📂cd
 ┃ ┣ ┣ 📂{{environment}}
 ┃ ┣ ┣ ┗ 📜cd.yml
 ┣ 📂src
 ┃ ┣ 📂properties
 ┃ ┣ ┣ 📂{{environment}}
 ┃ ┣ ┣ ┗ 📜values-{{gateway-technology}}.yml
 ┃ ┣ ┣ 📜values-{{gateway-technology}}.yml
 ┃ ┣ ┗ 📜values.yml
 ┗ 📜README.md
```

Description of the files:

|File/Folder|Editable|Description|
|-----------|--------|-----------|
|.github/workflows|no|Folder with the component workflows|
|.gluon/cd/{{environment}}|yes|Folder with the name of the environment, which contains the cd.yml file where the infrastructure/s where the API will be deployed is configured. Its name ({{environment}}) must match the name of the "name" property of the oam-application-definition.yml file of the Gluon Application Model component of the application|
|.gluon/cd/{{environment}}/cd.yml|yes|File where the infrastructure where it will be deployed is indicated and the properties file that applies to that infrastructure|
|src/properties/{{environment}}|yes|Folder that contains the API configuration file/s for that environment. Its name must match the corresponding folder of the .gluon/cd folder|
|src/properties/{{environment}}/values-{{gateway-technology}}.yml|yes|API configuration file for that specific technology ({{gateway-technology}}) and for that specific environment {{environment}}|
|src/properties/values-{{gateway-technology}}.yml|yes|API configuration file for that specific technology ({{gateway-technology}}). The properties configured in this file apply to all environments of that technology, unless they have been overwritten in the file src/properties/{{environment}}/values-{{gateway-technology}}.yml|
|src/properties/values.yml|yes|The properties configured in this file apply to all environments and all technologies, unless they have been overwritten in the files src/properties/values-{{gateway-technology}} or src/properties/{{environment}}/values-{{gateway-technology}}.yml|

As explained in the previous table, the archetype generates a file hierarchy that allows defining properties that specifically apply to the deployment of an API in a specific environment and technology,
or that apply to all environments and all technologies.

In this hierarchy, the value of the most specific file will always be obtained, so the order to obtain the properties is:

1. src/properties/{{environment}}/values-{{gateway-technology}}.yml
2. src/properties/values-{{gateway-technology}}.yml
3. src/properties/values.yml

## Archetype Configuration

### Global API configuration file for a technology (api-config-{{gateway-technology}}.yml)

> IMPORTANT: This file **should not be modified**

This is a global file that contains the information needed by the workflow to deploy the API. It consists of the following structure:

- **Properties**: Values that will be loaded in the properties section of the API, the user must indicate key:value
- **security schemes**: Indicates the security scheme associated with a deployment profile, this configuration does not contain the "optional" generate parameter,
the configuration is always loaded in the corresponding file (custom -> values, protected | default -> api-config).
The property on which the values will be loaded in the output is securitySchemes
- **base-policies**: List of allowed deployment profiles for the api-deployment, contains the profile name and the mandatory policies associated with the profile. Example:
authorization-code-cosac: [gln-jwsid-generate, gln-cosac, gln-invoke]
- **version**: Current version of the archetype
- **policies**: List of all available policies

IBM policies file example

```yaml
version: 1.0.0
base-policies:
  authorization-code-cosac: [gln-jwsid-generate, gln-cosac, invoke]
  authorization-code: [gln-jwsid-generate, invoke]
  jwsid: [gln-jwsid-validate, gln-jwsid-generate, invoke]
exposure:
  client: [authorization-code, authorization-code-cosac]
  core: [jwsid]
properties:
  protected: # api-config.yml
    kid: <%= kid %>
    private-key-id: <%= private-key-id %>
  default: # api-config.yml
    exp: 60 #default
    nbf-delay: 3 #default
    sca-iss: <%= sca-iss %>
    sca-token-origin: <%= sca-token-origin %>
    sca-token-type: <%= sca-token-type %>
  custom:
    aud: APIAudience
    api-client-id: APIClientId
policies:
  gln-blacklist:
    optional: true
    level: api
    default:
    protected:
      version: 1.0.1
      title: gln-blacklist
    custom:
      configuration: {}
  gln-whitelist:
    optional: true
    level: api
    default:
    protected:
      version: 1.0.1
      title: gln-whitelist
    custom:
      configuration: {}
  cors:
    optional: true
    level: api
    default:
    protected:
    custom:
      enabled: true
      policy:
        - allow-credentials: true
          allow-origin:
            - test
            - test2
  parse:
    # required: [post|put|patch] Only if schema is associated with operation
    optional: conditional
    level: operation
    default:
      parse-settings-reference:
        parse-settings:
          document_type: json
          max_number_length: 128   # Pending security default values
          max_doc_size: 4194304
          max_nesting_depth: 512
          max_name_length: 256
          max_value_length: 8192
    protected:
      version: 2.0.0
      title: parse
    custom:
  validate:
    # required: [post|put|patch] Only if schema is associated with operation and if parse is also defined
    optional: true
    level: operation
    default:
      validate-against: definition
      compile-settings:
        strict: true
    protected:
      version: 2.0.0
      title: validate
    custom:
      definition: {}
  gln-jwsid-validate:
    optional: base # Only specific security profile
    level: operation
    default:
    protected:
      title: gln-jwsid-validate
      version: 2.0.0
    custom:
  gln-sca-operative-signature:
    optional: true
    level: operation
    default:
    protected:
      version: 1.0.1
      title: gln-sca-operative-signature
  gln-jwsid-generate:
    optional: base # Only specific security profile
    level: operation
    default:
      user: user
    protected:
      title: gln-jwsid-generate
      version: 2.2.0
    custom:
  gln-cosac:
    optional: base # Only specific security profile
    level: operation
    default:
    protected:
      title: gln-cosac
      version: 2.0.1
    custom:
      configuration: {}
  invoke:
    optional: base
    level: operation
    default:
      backend-type: detect
      header-control:
        type: blocklist
        values: []
      parameter-control:
        type: allowlist
        values: []
      http-version: HTTP/1.1
      timeout: 60
      verb: keep
      chunked-uploads: true
      persistent-connection: true
      cache-response: protocol
      cache-ttl: 900
      stop-on-error: []
      graphql-send-type: detect
      websocket-upgrade: false
    protected:
      title: invoke
      version:  2.3.0
    custom:
      target-url: https://service-host$(request.path)$(request.search)
  gln-obfuscation:
    optional: true
    level: operation
    protected:
      version: 2.0.0
      title: gln-obfuscation
    default:
    custom:
      configuration: {}
security:
  authorization-code-cosac:
    global:
      protected:
        AuthorizationCode:
          description: OAuth Grant type Authorization Code
          flows:
            authorizationCode:
              authorizationUrl: <%= authorization-url %>
              scopes: {} # values.yaml total scopes
              tokenUrl: <%= token-url %>
          type: oauth2
          x-ibm-oauth-provider: <%= x-ibm-oauth-provider %>
        X-IBM-Client-Id:
          description: >-
            This is the value of the client identifier issued to the client during
            the application registration process.
          in: header
          name: X-IBM-Client-Id
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
  authorization-code:
    global:
      protected:
        AuthorizationCode:
          description: OAuth Grant type Authorization Code
          flows:
            authorizationCode:
              authorizationUrl: <%= authorization-url %>
              scopes: {} # values.yaml total scopes
              tokenUrl: <%= token-url %>
          type: oauth2
          x-ibm-oauth-provider: <%= x-ibm-oauth-provider %>
        X-IBM-Client-Id:
          description: >-
            This is the value of the client identifier issued to the client during
            the application registration process.
          in: header
          name: X-IBM-Client-Id
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
  jwt-profile:
    global:
      protected:
        JWTProfile:
          description: OAuth Grant type Authorization Code
          flows:
            implicit:
              authorizationUrl: <%= authorization-url %>
              scopes: {} # values.yaml total scopes
          type: oauth2
          x-ibm-oauth-provider: <%= x-ibm-oauth-provider %>
        X-IBM-Client-Id:
          description: >-
            This is the value of the client identifier issued to the client during
            the application registration process.
          in: header
          name: X-IBM-Client-Id
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
  jwsid:
    global:
      protected:
        JWSID:
          type: http
          description: JWT security definition
          scheme: bearer
          bearerFormat: JWT
          x-ibm-bearer-validation-method: none
        X-IBM-Client-Id:
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

#### Configuration Parameters

General configuration parameters that apply to the nodes of the policies file

- **protected**: Protected data that the user cannot modify.
- **default**: Default data that the user can modify in the values.yml files.
- **custom**: Data that the user can or must modify, loaded in values.yml depending on the configuration of the optional parameter.
- **level**: Indicates the application level of the policy, based on this value the policy will be introduced in a specific part of the assembly. Allowed values
    - **api**: Applies the configuration at the first level.
    - **operation**: Applies the configuration at the operation level.
- **optional**: Indicates the obligation to apply the policy, there are 4 possible values:
    - **true**: Optional policies are not inserted in the values.yml files, but their protected and default values are inserted within the api config.
    - **false**: Mandatory policies are always inserted, both in values and in api config.
    - **conditional**: Specific application condition that applies to a policy.
    - **base**: It is mandatory if it is on the base-policies list, both in values and in api-config.

##### Special Conditions

Applicable cases when the value of the optional parameter is conditional.

###### Parse Policy

This policy must be included in the assembly in operations that have an associated schema of the requestBody type in the input api-specification

### Files values-{{technology}}.yml

Contains the information loaded from the archetype based on the general configuration parameters, after its generation this file is manipulated by the user.

Existing nodes in the file:

- **properties**: It is loaded empty so that the user configures their API properties if required
- **securitySchemes**: Contains the custom parameters generated through the policies file, the configurations categorized as global will be loaded at the first level.
- **policies**: Contains the API level policies, only non-optional policies will be loaded.
- **operations**: Contains all the operations/verbs that the selected API definition contains to create the component:
    - **securitySchemes**: The security configurations categorized as operation in the policies file are included in each operation.
    - **policies**: The policy configurations categorized at the operation level in the policies file are included in each operation.

Example of the file src/properties/{{environment}}/values-{{gateway-technology}}.yml for IBM API Connect:

```yaml
properties:
  aud: testCore
  api-client-id: 123444test
securitySchemes: {}
policies: {}
operations:
  /health:
    get:
      policies:
        gln-jwsid-validate: {}
        gln-jwsid-generate: {}
        invoke:
          target-url: https://mock
      securitySchemes: {}
  /status:
    get:
      policies:
        gln-jwsid-validate: {}
        gln-jwsid-generate: {}
        invoke:
          target-url: https://mock
      securitySchemes: {}
```

### api-config-{{technology}}.yml

It contains the information loaded from the archetype based on the general configuration parameters, after its generation this file cannot be manipulated.
Existing nodes in the file:

- **version**: Version of the assembly to be generated
- **archetype-version**: Current version of the archetype
- **gateway-technology**: Technology in which the API will be deployed
- **security-profile**: Name of the deployment profile
- **base-policies**: List of available profiles and the policies they contain
- **exposure**: Contains the list of available exposures and the profiles that each exposure contains
- **properties**: Default or protected properties obtained from the policies file
- **securityschemes**: Contains the default or protected parameters generated through the policies file, the configurations categorized as global will be loaded at the first level
- **api/policies**: Contains the API level policies, only non-optional policies will be loaded
- **operations**: Contains all the operations/verbs obtained from the input api-spec
    - **securitySchemes**: The security configurations categorized as operation in the policies file will be loaded in each operation.
    - **policies**: The policy configurations categorized at the operation level in the policies file will be loaded in each operation.

Example:

```yaml
api-config:
  version: 2.0.8
  archetype-version: 1.0.4-BETA
  archetype: generator-gluon-api-deployment
  gateway-technology: ibm
  security-profile: jwsid
  asset:
    id: 83
  base-policies:
    authorization-code-cosac:
      - gln-jwsid-generate
      - gln-cosac
      - invoke
    authorization-code:
      - gln-jwsid-generate
      - invoke
    jwsid:
      - gln-jwsid-validate
      - gln-jwsid-generate
      - invoke
  exposure:
    client:
      - authorization-code
      - authorization-code-cosac
    core:
      - jwsid
  properties:
    default:
      exp: 60
      nbf-delay: 3
    protected:
      kid: <%= kid %>
      private-key-id: <%= private-key-id %>
  securitySchemes:
    JWSID:
      type: http
      description: JWT security definition
      scheme: bearer
      bearerFormat: JWT
      x-ibm-bearer-validation-method: none
    X-IBM-Client-Id:
      description: >-
        This is the value of the client identifier issued to the client during
        the application registration process.
      in: header
      name: X-IBM-Client-Id
      type: apiKey
  api:
    policies:
      gln-blacklist:
        optional: true
        level: api
        default: {}
        protected:
          version: 1.0.1
          title: gln-blacklist
      gln-whitelist:
        optional: true
        level: api
        default: {}
        protected:
          version: 1.0.1
          title: gln-whitelist
      cors:
        optional: true
        level: api
        default: {}
        protected: {}
      gln-sca-operative-signature:
        optional: true
        level: api
        default:
          sca.configuration:
            sca-iss: <%= sca-iss %>
            sca-token-origin: <%= sca-token-origin %>
            sca-token-type: <%= sca-token-type %>
        protected:
          version: 1.0.1
          title: gln-sca-operative-signature
  operations:
    /health:
      get:
        policies:
          validate:
            optional: true
            level: operation
            default:
              validate-against: definition
              compile-settings:
                strict: true
            protected:
              version: 2.0.0
              title: validate
          gln-jwsid-validate:
            optional: base
            level: operation
            default: {}
            protected:
              title: gln-jwsid-validate
              version: 1.2.2
          gln-jwsid-generate:
            optional: base
            level: operation
            default:
              user: user
            protected:
              title: gln-jwsid-generate
              version: 2.1.0
          gln-cosac:
            optional: base
            level: operation
            default: {}
            protected:
              title: gln-cosac
              version: 2.0.1
          invoke:
            optional: base
            level: operation
            default:
              backend-type: detect
              header-control:
                type: blocklist
                values: []
              parameter-control:
                type: allowlist
                values: []
              http-version: HTTP/1.1
              timeout: 60
              verb: keep
              chunked-uploads: true
              persistent-connection: true
              cache-response: protocol
              cache-ttl: 900
              stop-on-error: []
              graphql-send-type: detect
              websocket-upgrade: false
            protected:
              title: invoke
              version: 2.3.0
          gln-obfuscation:
            optional: true
            level: operation
            default: {}
            protected:
              version: 2.0.0
              title: gln-obfuscation
    /status:
      get:
        policies:
          validate:
            optional: true
            level: operation
            default:
              validate-against: definition
              compile-settings:
                strict: true
            protected:
              version: 2.0.0
              title: validate
          gln-jwsid-validate:
            optional: base
            level: operation
            default: {}
            protected:
              title: gln-jwsid-validate
              version: 1.2.2
          gln-jwsid-generate:
            optional: base
            level: operation
            default:
              user: user
            protected:
              title: gln-jwsid-generate
              version: 2.1.0
          gln-cosac:
            optional: base
            level: operation
            default: {}
            protected:
              title: gln-cosac
              version: 2.0.1
          invoke:
            optional: base
            level: operation
            default:
              backend-type: detect
              header-control:
                type: blocklist
                values: []
              parameter-control:
                type: allowlist
                values: []
              http-version: HTTP/1.1
              timeout: 60
              verb: keep
              chunked-uploads: true
              persistent-connection: true
              cache-response: protocol
              cache-ttl: 900
              stop-on-error: []
              graphql-send-type: detect
              websocket-upgrade: false
            protected:
              title: invoke
              version: 2.3.0
          gln-obfuscation:
            optional: true
            level: operation
            default: {}
            protected:
              version: 2.0.0
              title: gln-obfuscation
```

### values.yml

This file is intended for common configuration across environments. By default, it contains the version value of the API definition in the Gluon Marketplace selected to create the component.

``` yaml
asset:
  version: 309
framework:
  version: 1.3.0
```

### cd.yml

File that contains the information of the identifier of the infrastructure in which it is going to be deployed and the specific properties file that applies for that deployment.

Example cd.yml with Apigee and IBM API Connect deployments:

```yaml
- ci_id: CI00000000097
  configurationFiles:
  - src/properties/cert/values-ibm.yml

- ci_id: CI00000000098
  configurationFiles:
  - src/properties/cert/values-apigee.yml
```
