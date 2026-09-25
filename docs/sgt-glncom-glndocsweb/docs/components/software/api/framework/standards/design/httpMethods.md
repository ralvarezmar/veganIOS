# HTTP Methods

### **API Standard**

The HTTP request method token is the primary source of request semantics; it indicates the **purpose** for which the client has made this request and what is expected by the client as a successful result.
Santander APIs MUST follow the HTTP Method/Verb guidelines defined in this document.

### **Guidelines**

a) The definition of the verb SHOULD be performed from the **consumer's perspective.**

b) Based on CRUD operations.

c) The main methods of action (verbs) to be used are as follows:

| **HTTP Verb** | **CRUD Operation** | **Type** | **Description** |
| --- | --- | --- | --- |
| **GET** | Read | Idempotent & Safe | Returns the current state of the resource. It **MUST NOT** contain a body in the API Request. |
| **POST** | Create | ```Unsafe``` | Create a new resource in the collection.Returns the newly created resource URL. |
| **PUT** | Update (Replace) | Idempotent | Replace the specified resource.Returns the resource URL.If resource does not exist, create it. |
| **DELETE** | Delete | Idempotent | Remove the specified resource. It **MUST NOT** contain a body in the API Request. **SHOULD** use 204 as HTTP Status Code |
| **PATCH** | Update | ```Unsafe``` | Partially update the specified resource, apply the entire set of changes automatically. Return the resource URL. On Error no changes applied. |
| **OPTIONS** | Read | Idempotent | Returns 200 OK, a list of supported methods of the specified resource in the "Allow" header field and an HTML doc with the documentation on the resource + a link to the API doc. |
| **HEAD** | Read | Idempotent & Safe | Returns the current state of a resource without a message body.  |

d) It is recommended that whenever a " **POST**" operation is defined, a " **PATCH**" operation is also defined, to allow partial modifications.
It is also RECOMMENDED to design POST and PATCH operations as idempotent. You can find the guidelines for handling idempotent operations in the [Idempotency](../patterns/idempotency.md) section of this document.

e) **Collections Archetype operations:**

  1. **GET:** Query of the resource list in the collection (may contain filters) "GET /resources".
  2. **POST:** Create a new "POST /resources" resource.
  3. Collections should **always be a plural noun.**

    > POST can only be used with GET meaning when the number of filters in the query can overload the maximum size of the URI.

f) **Documents Archetype operations:**

  1. **GET:** Find a document by id "GET /resources/{resource\_id}".
  2. **PUT:** Full update document "PUT /resources/{resource\_id}".
  3. **PATCH:** Partial update document "PATCH /resources/{resource\_id}".
  4. **DELETE:** Delete a document (Can be physical or logical) "DELETE /resources/{resource\_id}".
  5. Documents have to be **always a noun.**

g) **Stores Archetype operations:**

  1. **GET:** Query of the resource list in the store (may contain filters) "GET /resources\_store".
  2. **PUT:** Adds a new resource to a "PUT /resources\_store/{resource\_id}" store.
  3. Stores should **always be a plural noun.**

h) **Controllers Archetype operations:**

  1. **Always use POST.**
  2. **The operation should be a verb that describes the action applied to the resource** , e.g. validate, verify, calculate, simulate, etc.

i) **Idempotent Operation**

An idempotent operation implies that the state of the resource will be equal to the state returned by the **first invocation**, regardless of the number of calls made later.  
See [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110#name-idempotent-methods) for further reading.

j) **Safe Operation**

Safe methods are HTTP methods that do not modify resources. Meaning safe HTTP method MUST NOT create, update or delete resources. In addition, safe methods can be cached and prefetched without any repercussions to the resource.
Example - The following request is **incorrect** if this request actually deletes the resource : GET methods SHALL NOT produce any side effect

```url
GET https://api.santander.com/v1/customers/F9812763/delete HTTP/1.1
```

k) **Unsafe Operation**

Unsafe operations imply a certain degree of criticality in their execution (generation of new resource, alteration of existing resource etc)

l) **Cacheable Operation**

 Indicates that responses are allowed to be stored for future reuse. In general, requests to safe methods are cacheable, if it does not require a current or authoritative response from the server.

| **Method** | **Cacheable** |
| --- | --- |
| **GET** | :heavy_check_mark: Yes|
| **POST** | :warning: May, but only if specific POST endpoint is safe. <br>Hint: not supported by most caches. |
| **PUT** | :heavy_multiplication_x: No |
| **DELETE** |  :heavy_multiplication_x:    No |
| **PATCH** |  :heavy_multiplication_x:   No |
| **OPTIONS** |  :heavy_multiplication_x:    No |
| **HEAD** | :heavy_check_mark: Yes |
