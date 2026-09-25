# Payload Message Format

### **API Standard**

1. Input and output of APIs SHOULD use **JSON** by default.
2. Request and Response body notation MUST be in **lowerCamelCase**.  
3. The root element of the response MUST be an **object** and not an array.

### **Guidelines**

a) Use JSON [RFC 8259](../std-rfcs.md#rfc-8259) to represent structured (resource) data passed with HTTP requests and responses as body payload.

b) In a response body, a JSON object MUST be returned (and not e.g. an array) as a top level data structure to support future extensibility and avoid security issues.
If you define an array as the root element, pagination is limited because there isn't a common or structural section in the response to return pagination links

c) As mentioned in general guidelines section, the API MUST NOT return Santander internal codes in API responses.

d) Inline with the terms dictionary guidelines, API MUST use terms and entities defined as per the Terms Dictionary.

e) The business data SHOULD BE displayed as functional entities or sub-entities.

f) It's important to take into account the size of the body payload as it can cause issues in some Web Application Firewalls (WAFs) rules leading to rejection of requests.
Follow cybersecurity recommendation:- *send files attached as multipart/form-data and coded in base64*

g) It is RECOMMENDED to limit the maximum number of array items and length in string parameters in API request to avoid exceeding the url/body size or maximum API request limit through the API Gateway

#### Valid Example

A sample example which adheres to the published guidelines :

``` json
{
  "cardContractId": "123454523",
  "card": {
    "statement": {
      "statementId": "31700293000550610",
      "generationDateTime": "2017-07-21T17:32:28Z",
      "dueDateTime": "2017-07-21T17:32:28Z",
      "availableDateTime": "2017-07-21T17:32:28Z",
      "isMinimumPaymentPaid": true,
      "balances": [
        {
          "amount": {
            "amount": 99.99,
            "currency": "GBP"
          },
          "creditDebitIndicator": "Credit",
          "typeDescription": "Current"
        }
      ]
    }
  }
}
```

#### Rule 1 - Json properties as lowerCamelCase

Json field /property names should be defined as lowerCamelCase.

##### Invalid Example 1

Using UpperCamelCase

``` json
{
    "Data": {
        "Initiation": {
            "InstructionIdentification": "ACME412",
            "EndToEndIdentification": "FRESCO.21302.GFX.20",
            "LocalInstrument": "UK.OBIE.FPS",
            "InstructedAmount": {
                "Amount": "20.50",
                "Currency": "GBP"
            }
        }
    }
}

```

##### Invalid Example 2

Using a mix of Upper and lower cases

``` json
{
 "creditorAccount": {
    "SchemeName": "SortCodeAccountNumber",
    "Identification": "09000000050005",
    "name": "Mr A. N. Other",
    "secondaryIdentification": "0002"
  }
}
```

#### Rule 2 - Always return a JSON Object

In a response body, you must always return a JSON object and not for example an array.

##### Invalid Example

``` json
[
  {
    "limitId": "123456",
    "description": "Limit description",
    "periodicity": {
      "periodTypeCode": "3",
      "periodTypeDescription": "Day",
      "frequency": 1
    },
    "defaultAmount": {
      "amount": 300,
      "currency": "EUR"
    }
  }
]
```
