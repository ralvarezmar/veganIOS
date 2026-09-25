# Open API Specification 3 - OAS3

The OpenAPI Specification 3 (Open Api Specification - OAS) replaces the popular
Swagger specification by defining a standard interface as a contract for
machine/human readable interface files for describing, producing, consuming and
visualizing RESTful services regardless of platform or language. programming,
with as little implementation as possible.

This methodology is useful for clearly describing the structure and features of
the API before the coding phase. Its format allows you to build:

* Available endpoints (“/api/v1/apparsenal”) and their operations (POST, DELETE
  “/api/v1/apparsenal/{id}”, GET “/api/v1/apparsenal/{id}”, PUT “/api
  /v1/apparsenal/{id}”);
* Input and output operation parameters for each operation;
* Authentication methods;
* Contact information, license, terms of use;

:information_source: ***See [Contract First](./contract-first.md)***

## OpenAPI document template

``` { .yaml .copy}
openapi: 3.0.1
info:
  title: Santander F1rst Contract
  description: 'This is a sample Santander AppArsenal server.'
  termsOfService: http://swagger.io/terms/
  contact:
    email:
    name:
  license:
    name: Santander F1rst
  version: 1.0.0
tags:
  - name: AppArsenal
    description: AppArsenal
paths:
  /api/v1/apparsenal:
    get:
      tags:
        - AppArsenal
      summary: Get list of records by Page
      description: Get AppArsenal by Page
      operationId: getPageable
      parameters:
        - name: page
          in: query
          description: Page
          required: false
          schema:
            type: integer
            format: int32
            default: 0
        - name: size
          in: query
          description: Page Size
          required: false
          schema:
            type: integer
            format: int32
            default: 10
      responses:
        200:
          description: successful operation
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/AppArsenalResponseDTO'
      x-spring-paginated: true
    post:
      tags:
        - AppArsenal
      summary: Create AppArsenal
      description: Create AppArsenal functionality
```

> :information_source: Technical literature on OpenAPI Specification:
> <https://swagger.io/specification/>

## Motivations

**Agility**: Given the formal description of the API using a definition
language, your consumers can start building their clients or even testing them.
The development of contracts increases the independence of teams and allows end
consumers to quickly understand the features proposed by the API, reducing the
time required for them to integrate and the learning curve during integration
with its interface.

**Productivity**: All development teams can be productive in parallel. The
development of a user interface (UI), for example, is no longer blocked, as the
team already knows how the contract is exposed.

**Code Generator**: the automatic code generation from the OpenAPI Generator is
capable of automatically generating code, documentation and configurations with
the OpenAPI specification (2.0 and 3.0) following its contract described in our
openapi.yml file.

## Basic Definitions

| Resource          | Description                                                                                                            |
|-------------------|------------------------------------------------------------------------------------------------------------------------|
| OpenAPI Document  | API descriptor document.                                                                                               |
| Path Templating   | Template expressions for marking sections in the document.                                                             |
| Media Types       | Defines File Specification Compatible Resources [(RFC6838)](https://www.rfc-editor.org/rfc/rfc6838)                    |
| HTTP Status Codes | HTTP Executions Status Indicators [(IANA)](https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml) |

## Specification

* Versions
  * The versioning of RESTFul APIs follows the [SEMVER (Semantic
    Version)](https://semver.org/spec/v2.0.0.html) specification, defining the
    version number based on the MAJOR, MINOR and PATH model.
* Format
  * The document must be a JSON object, and can be represented in JSON or YAML
    format.
* Document Structure
  * The document can be single or split into multiple files. As long as your
    references are linked following the [json schema](https://json-schema.org/).
* Data Types
  * Data types must be represented by formats supported by the
    [Draft-Wright-Json-Schema](https://datatracker.ietf.org/doc/html/draft-wright-json-schema-00#section-4.2)
    standard. To represent complex models, the object must meet the
    [schema-object](https://swagger.io/specification/#schema-object)
    specification
* Rich Text Formatting
  * Content rendering is successfully performed following the
    [MarkDown](https://spec.commonmark.org/0.27/) formatting model.
* Relative References in URLs
  * URL/URI resolution must follow that specified in the community standard [URI
    Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986#section-4.2)
* Schema
  * Guides in the creation of objects of all supported types (Information,
    Contact, Server, Path, Request/Response, Link, Header, Tag, XML, Security,
    etc...)
* Specification Extensions
  * Describes how additional files can be used to extend the original
    capabilities of the OpenAPI Specification
* Security Filtering
  * Additional layer of access control over documentation.
