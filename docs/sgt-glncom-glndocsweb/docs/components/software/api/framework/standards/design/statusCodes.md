# HTTP Status Codes

### **API Standard**

1. HTTP response status code MUST be used to communicate the information about the result of the attempt to understand and satisfy the request
2. Santander APIs MUST follow the HTTP Status Code guidelines defined in this document.  

### **Guidelines**

The first digit of the Status-Code defines the class of response. The last two digits do not have any categorization role. There are 5 values for the first digit:

- `1xx`: Informational - Request received, continuing process.
- `2xx`: Success - The action was successfully received, understood, and accepted
- `3xx`: Redirection - Further action must be taken in order to complete the request
- `4xx`: Client Error - The request contains bad syntax or cannot be fulfilled
- `5xx`: Server Error - The server failed to fulfill an apparently valid request.

The status code ```Report tag``` information is defined as follows:

- **Mandatory**: The status code must be documented in the API definition.
- **Optional**: The status code will be documented in the API definition, If the use case applies.
- **Forbidden**: The status code mustn't be documented in the API definition (because it is a platform error response that must be documented at platform level or because the status code is N/A)

The status codes make sense to be documented at a Platform level or at the API definition yaml level:

- API Documentation: The status code must be documented in the API yaml
- Platform Documentation: The status code must be documented at a Platform level. This status codes can be returned by the API also, but depending on the platform the API is running may return this information.

a) The response of operations MUST conform the HTTP / 1.1 specification defined [RFC-9110](../std-rfcs.md#rfc-9110). This specification is complemented by the HTTP / 1.1 codes that are collected at [IANA](http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml)

#### 1xx: Informational

b) 1xx: Informational: Request received, continuing process.

| **Code** | **Description** | **Report** | **Use Cases** |
| --- | --- | --- | --- |
| **100** | Continue | Optional (yaml) | The 100 (Continue) status code indicates that the initial part of a request has been received and has not yet been rejected by the server.<br> The server intends to send a final response after the request has been fully received and acted upon.<br>Example:<br>POST /videos HTTP/1.1 <br>Content-Type: video/mp4 <br>Content-Length: \<size\><br>Expect: 100-continue<br>Response: \_If videos larger than the upload size are accepted, they will return "100 – Continue".<br>If the field "Expect" reported by the client is invalid, it will return an error "417 Expectation Failed".<br>If you do not accept videos of the size requested by the client, an HTTP error will be returned, in this case"413 Payload Too Large". |
| **101** | Switching Protocols | Optional (yaml) | The 101 (Switching Protocols) status code indicates that the server understands and is willing to comply with the client's request, via the Upgrade header field.<br>Example:<br>GET /hello.txt HTTP/1.1 <br>Connection: upgrade<br>Upgrade: HTTP/2.0, HTTPS/1.3, IRC/6.9, RTA/x11<br>Response: It will return a code 101 if the update is possible with the new protocol to use:<br>HTTP/1.1 101 Switching Protocols<br> Connection: upgrade<br>Upgrade: HTTP/2.0<br>In case the client does not report the "Upgrade" header, the server will return an error "426 Upgrade Required".<br>In the event that the server rejects the update, the Header upgrade will be ignored by returning the corresponding response from the server (2XX, 3XX, 4XX o 5XX). |

#### 2xx: Success

c) 2xx: Success: The action was successfully received, understood, and accepted.

| **Code** | **Description** | **Report** | **Use Cases** |
| --- | --- | --- | --- |
| **200** | **OK** | Optional (yaml) | The 200 (OK) status code indicates that the request has succeeded.<br>GET. -\> HTTP Code 200 by default<br>POST/PUT/PATCH -\> To update the resource, data is returned in body from the server.<br>DELETE -\> To delete resource, data is returned in body from the server. |
| **201** | **Created** | Optional (yaml) | The 201 (Created) status code indicates that the request has been fulfilled and has resulted in one or more new resources being created.<br> POST/PUT -\> When a new resource is successfully created. |
| **202** | **Accepted** | Optional (yaml) | The 202 (Accepted) status code indicates that the request has been accepted for processing, but the processing has not been completed.<br>Usually when a "DELETE" is requested but the action has not been performed immediately by the server. Primarily used **in asynchronous usecases** |
| **203** | Not-Authoritative Information | Optional (yaml) | The 203 (Non-Authoritative Information) status code indicates that the request was successful but the enclosed payload has been modified from that of the origin server's 200 (OK) response by a transforming proxy.<br>It is used when the data sent in the request can be altered as a subset of data from a third party. |
| **204** | **No Content** | Optional (yaml) | The 204 (No Content) status code indicates that the server has successfully fulfilled the request and that there is no additional content to send in the response payload body.<br>GET -\> Case of 200, but it must be used when no return entity or data is returned in the operation.<br>POST -\> When a resource is modified and it is not returned at the output.<br> Or when, in the event handler when the resource exists but it does not need to be returned (Validation Event Manager).<br>PUT/PATCH -\> When a resource is modified and it is not returned at the output.<br> DELETE -\> As the case of 200, but it must be used when no return entity is returned in the operation.<br>```NOTE: It is RECOMMENDED to use this code in operations of type DELETE.``` |
| **205** | Reset Content | **Forbidden** | The 205 (Reset Content) status code indicates that the server has fulfilled the request and desires that the user agent reset the "document view", which caused the request to be sent, to its original state as received from the origin server. |
| **206** | Partial Content | Optional (yaml) | The 206 (Partial Content) status code indicates that the server is successfully fulfilling a range request for the target resource by transferring one or more parts of the selected representation that correspond to the satisfied ranges found in the request's Range header field.<br>It must be used when the "Content-Range" header field is reported. |

#### 3xx: Redirection

d) 3xx: Redirection: Further action must be taken in order to complete the request.

| **Code** | **Description** | **Report** | **Use Cases** |
| --- | --- | --- | --- |
| **300** | Multiple Choices | **Forbidden** | The 300 (Multiple Choices) status code indicates that the target resource has more than one representationNo documentation.<br> The HATEOAS API Management strategy allows you to meet these needs by offering different options to the consumer with business resource data. |
| **301** | Moved Permanently | **Forbidden** | The 301 (Moved Permanently) status code indicates that the target resource has been assigned a new permanent URI and any future references to this resource ought to use one of the enclosed URIs.<br>No documentation.<br> The API Management strategy offers a comprehensive governance of the APIs, managing their consumption through subscriptions. |
| **302** | Found | **Forbidden**<br>(It is permitted in OAuth authorization code grant) (yaml) | The 302 (Found) status code indicates that the target resource resides temporarily under a different URI.<br>No documentation.<br> The API Management strategy offers a comprehensive governance of the APIs, managing their consumption through subscriptions. |
| **303** | See Other | **Forbidden** | The 303 (See Other) status code indicates that the server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request.<br> No documentation.<br> The HATEOAS API Management strategy allows you to meet these needs by offering different options to the consumer with business resource data. |
| **304** | Not Modified | Optional (Platform) | The 304 (Not Modified) status code indicates that a conditional GET or HEAD request has been received and would have resulted in a 200 (OK) response if it were not for the fact that the condition evaluated to false.<br> In other words, there is no need for the server to transfer a representation of the target resource because the request indicates that the client, which made the request conditional, already has a valid representation; the server is therefore redirecting the client to make use of that stored representation as if it were the payload of a 200 (OK) response.<br>This code must be documented in the case of using header fields used to cache the information. |
| **307** | Temporary Redirect | **Forbidden** | The 307 (Temporary Redirect) status code indicates that the target resource resides temporarily under a different URI and the user agent MUST NOT change the request method if it performs an automatic redirection to that URI.<br>No documentation.<br> The API Management strategy offers a comprehensive governance of the APIs, managing their consumption through subscriptions. |

#### 4xx: Client Error

e) 4xx: Client Error: The request contains bad syntax or cannot be fulfilled.

| **Code** | **Description** | **Report** | **Use Cases** |
| --- | --- | --- | --- |
| **400** | **Bad Request** | Optional (yaml) | The 400 (Bad Request) status code indicates that the server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing, JSON is invalid according to the API specification).<br>This code must be documented in all operations in which it is necessary to receive data in the request.  |
| **401** | **Unauthorized** | Mandatory (yaml) | The 401 (Unauthorized) status code indicates that the request has not been applied because it lacks valid authentication credentials for the target resource.<br>This code has to be documented in all operations of the APIs that require subscription by a client. |
| **402** | Payment Required | Optional (yaml) | This code might be used as part of some form of digital cash or micropayment scheme, but that has not happened.<br>Currently this code is not to be used. |
| **403** | **Forbidden** | Mandatory (yaml) | The 403 (Forbidden) status code indicates that the server understood the request but refuses to authorize it.<br> A server that wishes to make public why the request has been forbidden can describe that reason in the response payload (if any). If you want to encapsulate and obfuscate the information returned to the user, to avoid return information which can be used to attack our systems, you can return a 404 Not Found Error.|
| **404** | **Not Found** | Mandatory (yaml) | The 404 (Not Found) status code indicates that the origin server did not find a current representation for the target resource or is not willing to disclose that one exists.<br> This code will occur in GET operations when the resource is not available, it is therefore necessary to document this return in such situations.<br> This error can be returned by APIGateways when they cannot find a route to match the URI. <br> Example 1: If you try to execute a GET <https://api.santander.com/v1/accounts/{account_id}> , where account_id = 00491655300123456700 and it does not exists in the database, so it is an invalid URI. <br> Example 2: If you try to execute a GET <https://api.santander.com/v1/accounts/{account_id}?type_code=CRRT> , where account_id = 00491655300123456700 and the account_id exists in the database but the type_code is not equal "CRRT" sent in query parameter, it is not 404 HTTP Status Code, because the main URI is valid but the criteria filter (?type_code=CRRT) results in no content to return. In this case, the correct is return the HTTP Status Code 200 or 204 depending the API's business rule. |
| **405** | **Method Not Allowed** | **Forbidden** (Platform) | The 405 (Method Not Allowed) status code indicates that the method received in the request-line is known by the origin server but not supported by the target resource.<br> This code is documented at the API Portal level, it should not be documented at the API level. e.g trying to invoke a PATCH method for an endpoint where PATCH is not a valid defined method|
| **406** | Not Acceptable | [Check table](#method-to-status-code-mapping)<br> (yaml) | The 406 (Not Acceptable) status code indicates that the target resource does not have a current representation that would be acceptable to the user agent, according to the proactive negotiation header fields received in the request, and the server is unwilling to supply a default representation.<br>It must be reported when there is no response by default, and header fields are reported to perform the content negotiation (Accept, Accept-Charset, Accept-Encoding and Accept-Language). |
| **407** | Proxy Authentication Required | **Forbidden** | Currently not used. |
| **408** | Request Timeout | **Forbidden** (Platform) | The 408 (Request Timeout) status code indicates that the server did not receive a complete request message within the time that it was prepared to wait. |
| **409** | Conflict | Optional (yaml) | The 409 (Conflict) status code indicates that the request could not be completed due to a conflict with the current state of the target resource.<br> This code is used in situations where the user might be able to resolve the conflict and resubmit the request.<br>The code can be used in PUT, PATCH or POST requests, when an attempt is made to update a document that has been modified while the user made the request.<br> For example, in SCA flow request/response type. |
| **410** | Gone | **Forbidden** (Platform) | The 410 (Gone) status code indicates that access to the target resource is no longer available at the origin server and that this condition is likely to be permanent.<br>Currently not used. |
| **411** | Length Required | Optional (yaml) | The 411 (Length Required) status code indicates that the server refuses to accept the request without a defined Content-Length.<br>This code is documented only in those operations where the "Content-Length" header field is mandatory. |
| **412** | Precondition Failed | Optional (yaml) | The 412 (Precondition Failed) status code indicates that one or more conditions given in the request header fields evaluated to false when tested on the server.<br>This code must be documented in operations that include preconditions in the header (If-match, If-None-Match, If-Modified-Since, If-Unmodified-Since, If-Range). |
| **413** | **Payload Too Large** | Optional (Platform) | The 413 (Payload Too Large) status code indicates that the server is refusing to process a request because the request payload is larger than the server is willing or able to process. |
| **414** | URI Too Long | Optional (Platform) | The 414 (URI Too Long) status code indicates that the server is refusing to service the request because the request-target is longer than the server is willing to interpret. |
| **415** | **Unsupported Media Type** | [Check table](#method-to-status-code-mapping)<br> (yaml) | The 415 (Unsupported Media Type) status code indicates that the origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource. <br>It must be reported when there is a body request (PUT, POST and PATCH) and header fields are reported to perform the content negotiation (content-type and language). |
| **416** | Range Not Satisfied | Optional (yaml) | The 416 (Range Not Satisfied) status code indicates that none of the ranges in the request's Range header field overlap the current extent of the selected resource or that the set of ranges requested has been rejected due to invalid ranges or an excessive request of small or overlapping ranges.<br>Whenever it is used in a return 206, this code must be documented in the operation.<br> That is, as long as we have informed the "Content-Range" header field. |
| **417** | Expectation Failed | Optional (yaml) | The 417 (Expectation Failed) status code indicates that the expectation given in the request's Expect header field could not be met by at least one of the inbound servers.<br>Whenever the information code 100 is reported, this code must be documented in the operation. |
| **422** | **Unprocessable Entity** | Optional (yaml) | The 422 (Unprocessable Entity) status code means the server understands the content type of the request entity (hence a 415 (Unsupported Media Type) status code is inappropriate), and the syntax of the request entity is correct (thus a 400 (Bad Request) status code is inappropriate) but was unable to process the contained instructions.<br> A 422 status code occurs when a request is well-formed, however, due to semantic errors it is unable to be processed. |
| **426** | Upgrade Required | Optional (Platform) | The 426 (Upgrade Required) status code indicates that the server refuses to perform the request using the current protocol but might be willing to do so after the client upgrades to a different protocol.<br> Whenever the information code 102 is reported, this code must be documented in the operation. |
| **428** | Precondition Required | Optional (yaml) | The 428 status code indicates that the origin server requires the request to be conditional.<br>This code must be documented in operations that include preconditions in the header (If-match, If-None-Match, If-Modified-Since, If-Unmodified-Since, If-Range), when they are mandatory. |
| **429** | **Too Many Request** | Optional (Platform) | The 429 status code indicates that the user has sent too many requests in a given amount of time ("**rate limiting**"). |
| **431** | Request Header Fields Too Large | **Forbidden** (Platform) | The 431 status code indicates that the server is unwilling to process the request because its header fields are too large.<br> The request MAY be resubmitted after reducing the size of the request header fields. |

#### 5xx: Server Error

f) 5xx: Server Error: The server failed to fulfill an apparently valid request.

| **Code** | **Description** | **Report** | **Use Cases** |
| --- | --- | --- | --- |
| **500** | **Internal Server Error** | Mandatory (yaml) | The 500 (Internal Server Error) status code indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.<br>This code should always be documented. It should be used as a general system error. |
| **501** | Not Implemented | **Forbidden** | The 501 (Not Implemented) status code indicates that the server does not support the functionality required to fulfill the request.<br> This is the appropriate response when the server does not recognize the request method and is not capable of supporting it for any resource. |
| **502** |  **Bad Gateway** | **Forbidden** (Platform) | The 502 (Bad Gateway) status code indicates that the server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfil the request. |
| **503** |**Service Unavailable** | Mandatory (Platform) | The 503 (Service Unavailable) status code indicates that the server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.<br>This code should always be documented.<br> It should be used to report the specific errors that the server suffers. |
| **504** | **Gateway Timeout** | Mandatory (Platform) | The 504 (Gateway Timeout) status code indicates that the server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.<br>This code is recommended to always be documented in all API operations and used to report timeouts that occur on the server. |
| **505** | HTTP Version Not Supported | **Forbidden** (Platform) | The 505 (HTTP Version Not Supported) status code indicates that the server does not support, or refuses to support, the major version of HTTP that was used in the request message. |

#### Method to Status Code Mapping

The next table shows the status codes that can be included in the definitions depending on the http verb used to make the request.

| Error code | Mandatory | Recommended | Optional | Forbidden |
| --- | --- | --- | --- | --- |
| 200 |  POST (controller) | GET | PUT <br>PATCH<br> DELETE | POST (creation)  |
| 201 |   | POST (creation) | PUT | DELETE<br> GET <br>PATCH<br> POST (controller) |
| 202 |   |   | DELETE <br>PUT <br>POST PATCH<br>GET | |
| 204 |   | DELETE <br>GET | POST (controller) <br>PUT <br>PATCH |  POST (creation) |
| 406\* | GET |   | POST <br>PUT <br>PATCH | DELETE |
| 409 |   |   | PUT<br> PATCH <br>POST | DELETE<br> GET |
| 415\*\* | PUT<br> PATCH <br>POST |   |   | DELETE <br>GET |
| 422 | | PUT<br>PATCH<br>POST | | |

\* ```accept, accept-language or accept-encoding``` headers are mandatory if this status code is included. <br>
\*\* ```content-type or language``` headers are mandatory if this status code is included.

#### Handling an array of objects

When an operation requires an array of objects to be processed, it can be tricky to decide which HTTP code to return in different scenarios.
There are three possible cases: all operations executed successfully, some operations executed with errors, and all operations produced errors.The solution proposed is as follows:

a) If there is at least one successful modification, a 200 code will be returned. The response will include a field for each transaction indicating whether it was successful and why.
Additionally, we can provide a HATEOAS link to check the status of each resource separately.

b) When all individual operations are incorrect, the error code corresponding to the error produced will be returned
