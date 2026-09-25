# HTTP Headers

### **API Standard**

1. Header names are RECOMMENDED to be in lower **kebab-case** and to start with a letter.
2. *x-santander-client-id* MUST NOT appear as an apiKey security definition.

### **Guidelines**

[HTTP 2.0](../std-rfcs.md#rfc-9113) considers that header naming is case-insensitive also and **the recommendation is to use the lowercase (eventually lower-case) notation**.

| **Header name** | **Description** | **Example** |
| --- | --- | ---|
| **accept-language:** | The consumer request the list of languages by order of preference. | ES |
| **content-language:** | Language in which the message is sent. | ES|
| **if-none-match:** | Obtains the cached GET resources provided that the Etag data has not changed. Response code 428 | . |
| **if-match:** | Used for requests for resource modification. This field allows you to make changes only if no other change has been made by another customer during execution.. Response code 428 | . |
| **x-santander-device:** | Device information permitted by operation for data query. Makes it possible to apply an experience base to optimize the data collection. | . |
| **accept:** |  The consumer request the data format of the response by order of preference. | application/json |
| **content-type:** | Format content of the payload. | application/json |
| **x-ibm-client-id:** | The consumer application identifier. | 2a1fcc83-0ca7-45c4-a0f9-e0e0c96565f0 |
| **x-santander-client-id:** **(`Mandatory`)** | The consumer application identifier for APIs with no inheritance of IBM. **x-santander-client-id  `MUST NOT` be defined in an API Key security definition**. API security required is OAuth 2.0 or JWT depending on the use case. | 2a1fcc83-0ca7-45c4-a0f9-e0e0c96565f0 |
| **range** | The consumer request for a particular range of bytes in the API Request | . |
| **content-range** | In the server response, indicates where in a full body message a partial message belongs | . |
| **x-ratelimit-limit** | Response header that indicates the maximum number of API requests that can be made within a certain time period. | 100 |
| **x-ratelimit-remaining** | Response header that contains the remaining requests quota in the current window. | 99 |
| **x-ratelimit-reset** | Response header that contains the time remaining in the current window, specified in seconds. | 2016-10-12T11: 05:10Z |

#### **Traceability headers**

**It is `MANDATORY` to follow the** [tracing and log correlation standards](https://confluence.alm.europe.cloudcenter.corp/x/fVJUCQ).
See [Observability](./observability.md) section for further details.

The Santander Group has adopted two [traceability specifications](https://confluence.alm.europe.cloudcenter.corp/x/eVNUCQ) in its Observability standards:

**a) X-B3 for log-based traceability and log correlation** (log stream).

| **Header name** | **Description** | **Example** |
| --- | --- | ---|
| **x-b3-traceid** | The TraceId is 64 or 128-bit in length and indicates the overall ID of the trace. Every span in a trace shares this ID. Encoded as 32 or 16 lower-hex characters. | 463ac35c9f6413ad48485a3953bb6124 |
| **x-b3-parentspanid** | The ParentSpanId is 64-bit in length and indicates the position of the parent operation in the trace tree. When the span is the root of the trace tree, there is no ParentSpanId. Encoded as 16 lower-hex characters | 0020000000000001 |
| **x-b3-spanid** | The SpanId is 64-bit in length and indicates the position of the current operation in the trace tree. The value should not be interpreted: it may or may not be derived from the value of the TraceId. Encoded as 16 lower-hex characters | a2fb4a1d1a96d312 |
| **x-b3-sampled**| When the Sampled flag is either not specified or set to 1, the span will be reported to the tracing system. Once Sampled is set to 0 or 1, the same value should be consistently sent downstream. | 1 |

**b) W3C Trace Context for the APM interoperability and telemetry** (Monitoring & APM stream).

| **Header name** | **Description** | **Example** |
| --- | --- | ---|
| **traceparent** | Position of the incoming request in its trace graph in a portable, fixed-length format. Represents the incoming request in a tracing system in a common format, understood by all vendors. | 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01 |
| **tracestate** | Extends traceparent with vendor-specific data represented by a set of name/value pairs. Includes the parent in a potentially vendor-specific format | congo=t61rcWkgMzE |
