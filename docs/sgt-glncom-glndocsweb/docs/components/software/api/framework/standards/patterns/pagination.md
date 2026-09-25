---
title: Pagination
---

In most use cases, APIs can return a very high number of resources in the responses. To avoid overloading both the servers and the gateways, it is necessary to implement a pagination solution.
In this section, query parameters and responses will be detailed to implement a proper pagination solution in Santander APIs.

### Pagination parameters

In [queryParams document](../design/queryParams.md) there is a section in which the allowed pagination parameters are described with some examples of its use cases.

In responses, the allowed parameters to include in the pagination are the following ones:

| **Parameter** | **Description** |
| --- | --- |
| **\_first** | **Response field in the body of the query**.<br>It will contain the HATEOAS to the first page.<br>The "\_limit" must be retained in the event that it has been reported by the user.<br>It will only be reported in the event that the first page is not being requested|
| **\_prev** |  **Response field in the body of the query**.<br>It will contain the HATEOAS to the previous page.<br>It should inform the "\_offset" of the page and keep the "\_limit" if it has been informed by the user.<br>It will only be reported in the event that the first page is not being requested and the previous page is available.|
| **\_next** | **Response field in the body of the query**.<br>It will contain the HATEOAS to the following page.<br>It should inform the "\_offset" of the page and keep the "\_limit" if it has been informed by the user.<br>It will only be reported if you are not on the last page. |
| **\_last** |  **Response field in the body of the query**.<br>It will contain the HATEOAS to the last page.<br>It should inform the "\_offset" of the page and keep the "\_limit" if it has been informed by the user.<br>It will only be reported if you are not on the last page. |
| **\_count** | This field is optional. It will be a **response field in the body of the query** that reports the number of total records that matches the made request.|

### HATEOAS

HATEOAS is an acronym that stands for 'Hypermedia as the Engine of Application State'.
It means that APIs customers would only need to interact with all the APIs system the URI reference to the most common APIs that may be consumed once the customer processes the response.

The typical parameters in the response that identify this responses are detailed in the pagination parameters section:

#### Example

```json
GET https://hostname/v1/cards?_offset=3&_limit=10

{
  "cards": [
    {
      "cardId": "123454523",
      "schemaDescription": "American Express",
      "expiration": {
        "month": "05",
        "year": "2025"
      },
      "cardholder": {
        "cardholderId": "F123456789",
      },
     "creditLimit": {
        "amount": 99.99,
        "currency": "EUR"
      }
     }
   ],
  "_links": {
    "_first": {
      "href": "https://hostname/cards"
    },
    "_prev": {
      "href": "https://hostname/cards?_offset=1&_limit=10"
    },
    "_next": {
      "href": "https://hostname/cards?_offset=13&_limit=10"
    },
    "_last": {
      "href": "https://hostname/cards?_offset=35&_limit=10"
    }
  }
```
