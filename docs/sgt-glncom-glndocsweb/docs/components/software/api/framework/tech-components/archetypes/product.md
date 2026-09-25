The archetype for API Product can handle different API Managers (currently, on Apigee OPDK and IBM API Connect v10) and allows to deploy Products and Plans, according to the capabilities of the API Manager.

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
 ┃ ┣ ┣ ┗ 📜values.yml
 ┃ ┣ ┗ 📜values.yml
 ┗ 📜README.md
```

Description of the files:

|**File/Folder**|**Editable**|**Description**|
|-----------|--------|-----------|
|**.github/workflows**|no|Folder with the component workflows|
|**.gluon/cd/{{environment}}**|yes|Folder with the name of the environment, which contains the cd.yml file where the infrastructure/s where the API Product will be deployed is configured. Its name ({{environment}}) must match the name of the "name" property of the oam-application-definition.yml file of the Gluon Application Model component of the application|
|**.gluon/cd/{{environment}}/cd.yml**|yes|File where the infrastructure where it will be deployed is indicated and the properties file that applies to that infrastructure|
|**src/properties/{{environment}}**|yes|Folder that contains the API configuration file/s for that environment. Its name must match the corresponding folder of the .gluon/cd folder|
|**src/properties/{{environment}}/values.yml**|yes|Configuration file that allows the creation of specific plans for that specific environment {{environment}}|
|**src/properties/values.yml**|yes|Main configuration file of the API Product, for the configuration of the APIs it includes and the plans.|

As explained in the previous table, the archetype generates a file hierarchy that allows defining plans that specifically apply to a specific environment or that apply to all environments.

In this hierarchy, the value of the most specific file will always be obtained, so the order to obtain the properties is:

1. src/properties/{{environment}}/values.yml
2. src/properties/values.yml

## Archetype Configuration

### api-product-config.yml

> !IMPORTANT: The use of this file in the repository is deprecated. If added manually, it will be ignored.

This file contains the configuration entered by the user during the creation of the component.

```yaml
api_product:
    name: api-product-community
    title: Community Product
    summary: API Product example for documentation
```

### values.yml

Configuration file of the API Product that allows the configuration of the APIs and their plans.

It is composed of the following sections and properties:

| **Parameter** | **Description** | **Example** | **Mandatory** |
|---------------|-----------------|-------------|---------------|
| **version**| Version of the product to be deployed | 1.0.0 | YES |
| **apis** | List of APIs available in the product, **at least one API must be configured**. It should be composed of the API repository and the version, separated by : | santander-group-gluon-test/sgt-glnapis-testdeploy01:2.0.0 | YES |
| **plans** | List of API plans. For Apigee and AWS, as it only supports one plan per product, if several plans are introduced only the first one will be generated | N/A | No, they can be introduced in the specific files of the environment |

Each plan consists of the following properties:

| **Parameter** | **Description** | **Example** | **Mandatory** | **Technology** |
|-----------|-------------|---------|---------|---------|
| **name** | Plan name | plan-gold | YES | All |
| **title** | Plan title to be displayed in the API Manager | Plan Gold | YES | All |
| **quota** | Contains the quota configuration for the consumption of the APIs contained in the product | quota | NO | APIGEE |
| **limit** | Call limit that applies to the APIs contained in the product | limit: 1000 | NO | APIGEE |
| **interval** | Period in which the limit defined in the quota applies | interval: 1 | NO | APIGEE |
| **timeUnit** | Time unit in which the interval defined in the quota applies. **Allowed values:** minute, hour, day, month | timeUnit: hour | NO | APIGEE |
| **rate-limits** | Contains the rate-limits configuration for the consumption of the APIs contained in the plan. | rate-limits | NO | IBM API Connect |
| **rate-limits title** | Rate-limit title | Default rate-limit | NO | IBM API Connect  |
| **value** | Call limit that applies to the APIs contained in the plan. **Allowed values:** second, minute, hour, day | value: 1000/1hour | NO | IBM API Connect  |
| **hard-limit** | Applies the strict limit on the rate-limit configuration. Possible values: "true" or "false". **An error will be returned if the rate-limit is exceeded only if this parameter has a "true" value**  | hard-limit: true | NO | IBM API Connect  |
| **burst-limits** | Contains the burst-limits configuration for the consumption of the APIs contained in the plan. | burst-limits | NO | IBM API Connect  |
| **burst-limits title** | Burst-limit title | Default burst-limit | NO | IBM API Connect  |
| **value** | Call limit that applies to the APIs contained in the plan. **Allowed values:** second, minute | value: 10/1second| NO| IBM API Connect  |
| **quota-aws** | Contains the quota configuration for the consumption of the APIs contained in the product | quota-aws | NO | AWS |
| **limit** | Call limit that applies to the APIs contained in the product | limit: 24000 | NO | AWS |
| **timeUnit** | Time unit in which the interval defined in the quota applies. **Allowed values:** DAY, WEEK, MONTH | timeUnit: month | NO | AWS |
| **rate-limits-aws** | Contains the rate-limits configuration for the consumption of the APIs contained in the plan | rate-limits-aws: 20 | NO | AWS |
| **burst-limits-aws** | Contains the burst-limits configuration for the consumption of the APIs contained in the plan | burst-limits-aws: 40 | NO | AWS  |

Below is an example of a values.yml file that defines multiple plans for different API management platforms (APIGEE, AWS, IBM):

```yaml
api_product:
  version: 1.0.0
  apis:
    - santander-group-gluon-test/sgt-glnapis-testdeploy01:2.1.2
    - santander-group-gluon-test/sgt-glnapis-testdeploy02:3.5.0
  plans:
    - name: plan-gold
      title: Plan Gold
      quota: # Apigee: 1000 requests per hour
        limit: 1000
        interval: 1
        timeUnit: hour
      quota-aws: # AWS: 24,000 requests per month (~1000/hour * 24h * 30d)
        limit: 24000
        timeUnit: month
      rate-limits-aws: 20    # AWS: 20 sustained req/s
      burst-limits-aws: 40   # AWS: burst of 40 req/s
      rate-limits:           # IBM: limits per hour
        Default rate-limit:
          value: 1000/1hour
          hard-limit: false
        Premium rate-limit:
          value: 2000/1hour
          hard-limit: false
        Super Economy rate-limit:
          value: 4000/1hour
          hard-limit: false
      burst-limits:          # IBM: bursts per 3 seconds
        Default burst-limit:
          value: 60/3second
        Premium burst-limit:
          value: 120/3second
        Super Economy burst-limit:
          value: 240/3second
      apiResources:
        santander-group-gluon-test/sgt-glnapis-testdeploy01:2.1.2:
          /:
            - post

    - name: plan-silver
      title: Plan Silver
      rate-limits:
        Default rate-limit:
          value: 500/1hour
          hard-limit: true
        Economy rate-limit:
          value: 1000/1hour
          hard-limit: true
        Super Economy rate-limit:
          value: 2000/1hour
          hard-limit: true
      burst-limits:
        Default burst-limit:
          value: 30/3second
        Economy burst-limit:
          value: 60/3second
        Super Economy burst-limit:
          value: 120/3second

    - name: plan-bronze
      title: Plan Bronze
      rate-limits:
        Default rate-limit:
          value: 200/1hour
          hard-limit: true
        Economy rate-limit:
          value: 400/1hour
          hard-limit: true
        Super Economy rate-limit:
          value: 800/1hour
          hard-limit: true
      burst-limits:
        Default burst-limit:
          value: 12/3second
        Economy burst-limit:
          value: 24/3second
        Super Economy burst-limit:
          value: 48/3second
      apiResources:
        santander-group-gluon-test/sgt-glnapis-testdeploy01:2.1.2:
          /:
            - post
        santander-group-gluon-test/sgt-glnapis-testdeploy02:3.5.0:
          /{account_id}/holds:
            - get
```

#### apiResources

Optionally, specific APIs can be configured in each of the product's plans. If no specific APIs are configured, all APIs indicated in the values.yml file will be available in the plan.

To indicate the APIs in the API resources parameter, it will be configured in the same way as in the apis section, indicating the name of the repository that contains the API and the version.

API resources can be configured in two ways:

1. Specifying the APIs that are available in a plan

    Example:

    ```yaml
    api_product:
        plans:
        - name: test-v1-plan
        title: Accounts Plan
        quota:
            limit: 10
            interval: 1
            timeUnit: minute
        rate-limits:
            Default rate-limit:
            value: 100/1hour
            hard-limit: true
        burst-limits:
            Default burst-limit:
            value: 10/1second
        apiResources:
            - santander-group-gluon-test/sgt-accounts-api:2.0.0
        plans:
        - name: test-v2-plan
        title: Payments Plan
        quota:
            limit: 10
            interval: 1
            timeUnit: minute
        rate-limits:
            Default rate-limit:
            value: 100/1hour
            hard-limit: true
        burst-limits:
            Default burst-limit:
            value: 10/1second
        apiResources:
    ```

    In the previous example, for the test-v1-plan, only the API specified in apiResources applies. In the test-v2-plan, all APIs available in the product apply.

2. Specifying the APIs, paths, and methods that are available in a plan

    Example:

    ```yaml
    api_product:
        plans:
        - name: test-v1-plan
        title: Accounts Plan
        quota:
            limit: 10
            interval: 1
            timeUnit: minute
        rate-limits:
            Default rate-limit:
            value: 100/1hour
            hard-limit: true
        burst-limits:
            Default burst-limit:
            value: 10/1second
        apiResources:
            santander-group-gluon-test/sgt-accounts-api:2.0.0
            /status:
                - GET
                - POST
                - PUT
        plans:
        - name: test-v2-plan
        title: Payments Plan
        quota:
            limit: 10
            interval: 1
            timeUnit: minute
        rate-limits:
            Default rate-limit:
            value: 100/1hour
            hard-limit: true
        burst-limits:
            Default burst-limit:
            value: 10/1second
        apiResources:
    ```

    In the previous example, for the test-v1-plan, only the /status path and the GET, POST, and PUT verbs of the API specified in apiResources apply.
    Verbs must be declared in uppercase or lowercase as defined in the api definition. In the test-v2-plan, all APIs available in the product apply.

### {{environment}}/values.yml

In this file, only the configuration for a deployment environment applies. There is a values.yml file available for each environment at the following path: src/properties/{{environment}}/values.yml

The only configuration that applies to this file is the plans/apiResources, it is possible to apply different plans for each of the environments by configuring them in the corresponding src/properties/{{environment}}/values.yml files.

> !IMPORTANT The optional configuration that is applied in the values.yml file will not be applied if the same configuration exists in the src/properties/{{environment}}/values.yml file.
For example, if the plans are configured in the src/properties/{{environment}}/values.yml folder and also in the values.yml file, the product will be deployed with the plans indicated in the src/properties/{{environment}}/values.yml file

src/properties/{{environment}}/values.yml example:

```yaml
api_product:
    plans:
    - name: test-v1-plan
      title: Accounts Plan
      quota: #Applies to Apigee
          limit: 10
          interval: 1
          timeUnit: minute
      rate-limits: #Applies to IBM
        Default rate-limit:
          value: 100/1hour
          hard-limit: true
      burst-limits: #Applies to IBM
        Default burst-limit:
          value: 10/1second
      apiResources:
        - santander-group-gluon-test/sgt-accounts-api:2.0.0
        - santander-group-gluon-test/sgt-payments-api:2.0.0
```
