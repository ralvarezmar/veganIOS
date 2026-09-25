# Version Control for APIs

### **API Standard**

1. The major version of APIs MUST be included in the URL, with an assumed major version of 1 for APIs implemented without a version in the URL
2. The API version specified within the OpenAPI Specification MUST be a numerical field.

### **Guidelines**

  ``` url
   https://api.santander.com/v2/accounts/{account_id}/balances
   \___________________________/\____________________________/
                |                         |
            server URL                  endpoint path
  ```

- API version MUST be defined in as part of the `servers` URL of open API specification and not on the individual endpoints
- Ensure that the internal version defined in API definition matches with the major version defined in the url.
- Any API which doesn't have version in its URI is assumed to be its first major version. i.e. it is not mandatory to include v1 in the URI if it is the APIs first major version.
- API paths MUST NOT include versioning. Versions should instead be in the server URL.
- Server URLs MUST NOT contain multiple API versions. Mixing multiple global API versions into a single description document can lead to confusion
- The server URL SHOULD contain a major version only represented as `v{number}`
- API version in the API specification(info:version) MUST follow the following notation **V.R.F (Version.Release.Fix)**
    - Version (in url):
        - Indicate a major change in the API version identifier.  
        - It is an incompatible with the previous version.
    - Release (internal versioning):
        - This version extends new functionalities from previous.
        - It is compatible with the previous version.
    - Fix (internal versioning):
        - Indicate a correction change in the API version identifier.
        - It is compatible with the previous version.

### Versioning types

#### Backwards compatible changes

|Change|Example|API Version|Product (Plan) version|
|------|-------|-----------|----------------------|
|Add new operations|Add a new GET operation on a resource.|YES, release|YES, release|
|Add optional input parameters to requests on existing resources.|A new filtering parameter in a GET on a collection of resources|YES, release|YES, release|
|Modify or replace input parameters from mandatory to optional.|When creating a resource, a property of such a resource that was previously mandatory and made optional.|YES, release|YES, release|
|Add new properties in a resource that the server returns.|Add ed a new field age to a resource Person that previously was composed by DNI and name.|YES, release|YES, release|
|A bug is detected in the API|The return value is not correct for the requested parameter|YES, fix|YES, fix|
|Add, delete, or perform a Plan change on a Product| Product throttling increases |NO| YES, fix|

#### Not Backwards Compatible Changes

|Change|Example|API Version|Product (Plan) version|
|------|-------|-----------|----------------------|
|An API is added or removed|-|YES, version|YES, version|
|Add new required input parameters.|To register a resource you must send a new field required in the body of the request.|YES, version|YES, version|
|Modify a parameter in existing operations (verbs about resources). Also, applicable to the removal of parameters.|When you query a resource, a field is no longer returned. Another example: a field that was previously a string of characters, is now numeric.|YES, version|YES, version|
|Modify input parameters from optional to required.|When creating a Person resource, the age field, which was previously optional, is now mandatory.|YES, version|YES, version|
|Add different responses in existing operations.|now the creation of a resource can return a response code 412.|YES, version|YES, version|
|Delete operations or actions on a resource| We removed the operation consult age about a resource Person|YES, version|YES, version|

### API Version and API Product management guide

|Change|Example|
|------|-------|
|A new major version of the API| <li>Products that include the API to a major version (myProduct v1.0.0-> myProduct v2.0.0) must be **versioned** and MUST include the new version of the API (myAPI v3.1.0) in this new version of the Product.</li><li>The old version of the APIs and Versioned Products MUST be **archived** within a reasonable time.</li><li>You should always **notify** those interested that the previous version will be removed and should migrate to the new version.</li>|
|A new minor version of the API|<li>You MUST **version** the Products that include the API to a major version (myProduct v1.0.0-> myProduct v1.1.0) and include the new version of the API (myAPI v1.2.0) in this new version of the Product.</li><li>The old version of the APIs and Versioned Products MUST be **archived** within a reasonable time.</li><li>You SHOULD always **notify** those interested that the previous version will be removed and should migrate to the new version.|
|Simultaneously publishing different versions of an API|<li>Both can exist on the same portal without any problem: It will be known which version to invoke depending on the application subscription that calls the API.</li><li>You MUST version the Products that include the API to a major version (myProduct v1.0.0-> myProduct v1.1.0) and include the new version of the API (myAPI v1.2.0) in this new version of the Product. </li><li>Different versions of the products will be published simultaneously.</li>|
|Simultaneously publishing different versions of a Product|<li>Both can exist on the same portal without any problem: It will be known which version to invoke depending on the subscription of the application that calls the Product.</li><li>The oldest version of the Product must be **deprecated**.</li><li>You can also choose to **migrate** your existing clients from one version to another if that makes sense for your use case. </li><li>You SHOULD always **notify** those interested that the previous version will be removed and should migrate to the new version.|
|Add or modify a Plan|<li>The Product SHOULD be versioned at the Fix indicator level (myProduct v1.0.1-> myProduct v1.0.2).</li><li>Existing customers subscribed to the Product Plan should be **migrated** to the new Plan if that makes sense for your use case.</li><li>You should always **notify** those interested that the previous version will be removed and should migrate to the new version.</li>

### API Versioning examples

#### Valid Example

``` yaml
openapi: 3.0.1
info:
  title: Accounts API
  version: 2.1.2
servers:
  - url: https://api.santander.com/v2/accounts
paths:
  /{account_id}/balances:
```

#### Invalid Example - One API version per document

This example incorrectly includes multiple versions.

``` yaml
servers:
  - url: https://api.santander.com/v1/accounts
  - url: https://api.santander.com/v2/accounts
paths:
  /{account_id}/balances:
```

#### Invalid Example - No path versioning

The path incorrectly contains a version

```yaml
paths:
  /v1/accounts/{account_id}/balances:
  /accounts/v1/:
```

#### Invalid Example - Only major API version

Version 2.5 is considered a minor version

```yaml
servers:
  - url: https://api.santander.com/v2.5/accounts
```
