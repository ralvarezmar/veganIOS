# Query Parameters Definition

### **API Standard**

1. Santander APIs MUST follow the HTTP Query Parameters guidelines defined in this document.  
2. Use the reserved query parameters that start with an underscore instead of custom query parameters, as explained in this document. e.g use *_fields*  instead of *filter*,  *_limit* instead of *size* etc
3. URI query parameter SHOULD NOT be used to transfer metadata about the message and its content, use headers instead
4. SHOULD NOT put sensitive information (like a password) in query parameters. Pass sensitive information as HEADER instead.

### **Guidelines**

`/customers?name=value1&age=value2` : query params appear at the end of the request URI after a question mark (?) separated by ampersands (&).

**Example** : `GET /customers?name=John` used to target customers with name `John`
While these parameters are encrypted over TLS, they can be seen as plain-text in unsafe places like server access logs, bookmarks or referrer headers transmitted to other sites.

The following query parameters are **reserved for specific purpose** and Santander APIs MUST use the same query parameters as defined in this document, if they need to support the specific functionality.

a) **Data filters on entities**

| **QueryString** | **Description** |
| --- | --- |
| **\_fields** | It makes it possible to select fields of the entity to recover.<br>The fields will be separated by the character ",".<br>This mechanism can be used with HATEOAS.<br>Example: *GET /accounts/{account\_id}?\_fields=status, balance* |
| **\_fields!** | It makes it possible to exclude fields of the entity to recover.<br>The fields excluded will be separated by the character ",".<br>Example: *GET /accounts/{account\_id}?\_fields!=status, balance* |
| **\_expand** | Entities can have sub-entities as attributes.<br>With this field, when requesting the data, it makes it possible to obtain additional information on these sub-entities.<br> It allows consumer select what business objects information wants to be expanded.<br>Sub-entities will be separated by the character ",".<br>Example: *GET /accounts/{account\_id}?\_expand=movements*<br>NOTE: For reasons of complexity, it is only valid with first-level sub-entities. |
| **\_noDescription** | These parameters should be optional, it must be reported with the value "S".<br>The field will be used when the operation must return the data as codes instead of translated descriptions. |
| **\_sort** | Makes it possible to sort the results obtained, ascending "+" or descending "-" by the criteria defined by the API Designer.<br>Example: *GET /customers/{customer\_id}?\_sort=+last\_name*. Fields will be separated by the character ",".<br>NOTE: For reasons of complexity, it is only valid for entities. |

b) **Pagination**

| **QueryString** | **Description** |
| --- | --- |
| **\_offset** | The field contains the **first record to be returned in the response**.<br>This field will not be reported in the first pagination query, and will be reported through HATEOAS in the following. In most instances, the consumer will not be required to generate this field as it will be reported at HATEOAS level. |
| **\_limit** | This field is a numerical value, it indicates the **value of items that should be informed per page**.<br>This value does not need to be reported so in that case, the implementation of the API returns the number of items by default. |

***Example***. In this case, the server will return the cards from the cardId= 3 to cardId=12:

```json
GET https://hostname/v1/cards?_offset=3&_limit=10
```

To check the available structures to include pagination in responses, [click here](../patterns/pagination.md).

c) **Queries**

| **QueryString** | **Description** |
| --- | --- |
| **\_query** | This parameter is optional.<br>It will be included only on the list of data entities (e.g.: /customers?\_query="…").<br>In the case of second-level entities, it can only be applied when the first-level entity is identified.<br> All possible logical operators permitted are AND, OR or NOT must be documented. |
