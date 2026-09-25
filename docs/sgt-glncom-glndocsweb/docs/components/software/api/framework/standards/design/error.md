# Response Error Structure

### **API Standard**

APIs MUST use the standardized error structure defined in the Terms Dictionary.

### **Guidelines**

a) The error message is only meant to be used for HTTP status codes 4xx and 5xx

b) As mentioned in general guidelines section, the API MUST NOT return Santander internal codes in API responses.

c) The definition of the error structure can be found in the Terms Dictionary

d) An error response MUST NOT include any of the following information that may leak sensitive information:

  - Internal code
  - File path
  - Stack trace
  - Internal system/server name

#### Error Message

This is a sample error message that follows the schema outlined in the Terms dictionary.

```json
{
  "errors": [
    {
      "code": "ERR001",
      "message": "Input data invalid",
      "level": "ERROR",
      "description": "Zip code is longer than expected"
    }
  ]
}
```

| Field       | Type      | Description                  | Example     |
| ----------  | ----------| ---------------------------- | -------------- |
| code        | string    | Unique alphanumeric human readable error code.<br> Each entity should have its own error catalogation list to map the different errors | ERR001 |
| message     | string    | Brief summary of the reported issue    | Invalid Action |
| level       | string    | Level of the reported issue    | See the table below |
| description | string    | Detailed description of the reported issue   |  Input fieldname should be a string  |

Severity levels are: (Recommended)

| **Level** | **Usage** |
| --- | --- |
| ERROR | Error events that might still allow the application to continue running. |
| FATAL | Very severe error events that will presumably lead the application to abort. |
| INFO | Informational messages that highlight the progress of the application at coarse-grained level. |
| WARNING | Potentially harmful situations. |

#### Invalid Example

Error Response returning an internal code

```json
HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{
  "errors": [
    {
      "code": "SNTDR-STRUCTURAL-1234",
      "message": "Internal server error",
      "level": "ERROR",
      "description": "An unexpected error in the Structural systems. Please try again later."
    }
  ]
}
```
