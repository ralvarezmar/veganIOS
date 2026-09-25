# Content Negotiation

Some use cases may require to handle different data formats. This section details the the way of defining the content negotiation in the APIs.

### **Guidelines**

a)Request/response MIME type SHOULD be defined at operation layer to clarify consumers the Content type and the structure of each operation.

b) File extension MUST NOT be included in URI.

c) The header parameters standardized to manage the data format are:

  1. **accept**

  2. **content-type**

d) IANA governs the set of registered Media Types (data format) and provides links to the published specifications of each type [RFC-6838](../std-rfcs.md#rfc-6838). All MIME types defined must be included in the [IANA standard](https://www.iana.org/assignments/media-types/media-types.xhtml)(Mandatory)

Here are some examples:

| **Media Type** | **Description** |
| --- | --- |
| **text/plain** | Text without format, without a structure of specific content. |
| **text/html** | Content formatted to HTML. |
| **image/jpeg** | Standardized image compression format. |
| **application/xml** | Structured content through XML. |
| **application/javascript** | Source code written in the JavaScript programming language. |
| **applicaction/json** | Text-based content of JavaScript Object Notation (JSON). |
| **applicaction/hal+json** | Text-based content of JavaScript Object Notation (JSON) with HATEOAS |

e) OAS 3.0 introduced several changes in the way the body of a request and a response can be defined. Body and formdata parameters have been removed and replaced with requestBody.
RequestBody structure is more flexible and lets define different media types, such as JSON, XML, form data, plain text, and others, and use different schemas for each media types defined.

### **Content Language**

The standardized header parameters to manage the data language are **accept-language** and **content-language**.

Language Code formation :

- Language Code (2 alphanumeric positions according to [ISO 639-1](../std-rfcs.md#iso-639-1)) + Country\_Code (2 alphanumeric positions according to [ISO 3166-1](../std-rfcs.md#iso-3166-1))
- Example: en-GB
