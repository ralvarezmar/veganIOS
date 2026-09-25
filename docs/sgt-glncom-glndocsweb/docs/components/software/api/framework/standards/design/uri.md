# URI Structure

### **API Standards**

1. URI MUST follow the syntax described in [RFC-3986](https://tools.ietf.org/html/rfc3986 )
    <br> *URI = protocol"://“domainName"/“resourcePath ["?“query]\[fragmentIdentifier"#"]*<br>

    ```url
        https://api.santander.com/v1/accounts/{account_id}?type_code=CRRT
        \___/  \________________/\__/\_______/\___________/\____________/
          |             |          |      |         |            |
        protocol      domain     version resource  path       query
                   environment                     params      params
    ```

2. URIs MUST be defined in **lowercase** and MUST follow the notation **snake_case**. This is applicable to Path Params, Path Segments and also Query Params. *kebab-case* notation is DEPRECATED.
3. URIs MUST NOT include any verb action and should be targeted at resources.
4. URI resources SHOULD be defined by hierarchical relationship entities e.g *\/<resource1\>/\{resource1_id}/\<resource2\>/\{resource2_id}*
5. Entities notation for collections should always be a plural noun e.g *customer**s**/{customer_id}*
6. Unique entities objects SHOULD be represented as variables between braces in path params and MUST end with an "_id" suffix. e.g {customer_id}.
7. URI Paths MUST NOT include any file extensions like json or xml
8. Verbs such as get, delete, post, patch, put MUST NOT be included in paths because this information is conveyed by the HTTP method e.g don't use /getUsers
9. Total length of characters in the URI SHOULD NOT exceed 2048 characters as it is the value commonly limited by web browsers.
10. URIs in servers.url SHOULD be defined in a relative way (not including the host, the same way as the basepath in Swagger 2) to avoid coupling the plain definition from specific implementations.

### **Guidelines**

a) It is NOT Recommended specifying paths with duplicate or trailing slashes, e.g. */customers//addresses* or */customers/*. As a consequence, you must also NOT specify or use path variables with empty string values.

b) [Versioning](versioning.md) section details the API versioning standard.

c) **base64url encoded** query params.
In some cases it is necessary to include a base64 string in a query parameter e.g when a complex structure is needed to filter in a GET operation. In such scenarios, it is recommended use **base64url** encoding as per the guidelines defined in [RFC 4648](https://datatracker.ietf.org/doc/html/rfc4648#section-5).

This encoding replaces the standard base64 characters **'+' and '/' with '-' (minus) and '_' (underscore)** respectively, to ensure that the encoded string is safe to use in URLs.

| **Base64** | **Base64url** |
| --- | --- |
| + | - (minus) |
| / | \_ (underscore) |

Yaml definition still is type:string and format:byte but the **description** of the field has to include the type of encoding to ease the consumers to use the API correctly.

d) **URI format in payload (Recommended)**

The standard definition of a URI field ( **type:string and format:uri** ) only allows to define **absolute URIs**. [http://santander.com/accounts/12345]

If the API definition requires to use a **relative URI** (/accounts/12345), the URI format SHOULD NOT be used, and a plain string has to be used.  [More info](https://swagger.io/specification/#data-types)

#### Valid Examples

!!! success "Valid Examples"
    - /customers/{customer_id}
    - /v2/accounts/{account_id}/transactions/{transaction_id}
    - /v1/loans/{loan_id}/completed_payments/{payment_id}
    - /cards/{card_id}/blocks?date_from=2022-12-10&date_to=2023-03-31
    - /contracts/{contract_id}/signature_groups?representee_id=F123456789&relation_status_code=A

#### Invalid Examples

!!! failure "Invalid Examples"
     - /v2/user.json
     - /customers**//**addresses/
     - /v1/customers/{customerId}/investmentPortfolio
     - /channel-access-agreements/{channel_access_agreement_id}/block-status
     - /v3/party-auth-v3/authentication-assessment/request/retail/{authenticationAssessmentId}/sms-otp

#### Parameter Serialization

In some use case, it can be useful to request several records at the same time, either using path or query parameters. In this situations, serialization structures can be used.
Serialization means translating data structures or object state into a format that can be transmitted and reconstructed later.

OpenAPI 3.0 supports arrays and objects in [operation parameters](https://swagger.io/docs/specification/describing-parameters/) (path, query, header, and cookie) and lets you specify how these parameters should be serialized.

Given the path /users/{id}, the path parameter id is serialized as follows:

| style | explode | [URI template](https://swagger.io/docs/specification/serialization/#uri-templates) | Primitive value id = 5 | Array id = [3, 4, 5] | Object id = {"role": "admin", "firstName": "Alex"} |
| --- | --- | --- | --- | --- | --- |
| simple \* | false \* | /users/{id} | /users/5 | /users/3,4,5 | /users/role,admin,firstName,Alex |

\* The Default serialization method if not explicitly defined is:

- style: simple
- explode: false
