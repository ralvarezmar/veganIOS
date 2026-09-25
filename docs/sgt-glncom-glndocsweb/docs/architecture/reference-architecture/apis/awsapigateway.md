# AWS API Gateway

## Introduction

### What is AWS API Gateway?

Amazon API Gateway is an **AWS Service** for creating, publishing, maintaining, monitoring, and securing REST APIs.
API developers can create APIs that access AWS or other web services, as well as data stored in the **AWS Cloud**.
As an API Gateway developer, you can create APIs for use in your own client applications.
Or you can make your APIs available to third-party app developers.

![AWS API Gateway How it works](../assets/images/aws-apigw-how-it-works.png){: .image-popup align="center" style="width:80%"}

AWS API Gateway handles all the tasks involved in accepting and processing API calls, including traffic management, CORS support, authorization and access control, throttling, monitoring, and API version management.

For further information please review the following product links:

- [AWS API Gateway](https://aws.amazon.com/api-gateway/)
- [DOCS about AWS API GATEWAY](https://docs.aws.amazon.com/apigateway/index.html)
- [DOCS about Quotes and Limits](https://docs.aws.amazon.com/apigateway/latest/developerguide/limits.html)

### API types in AWS API Gateway

#### API Gateway Websocket API

Out of our scope. Currently there are no use cases related to websockets.
A collection of WebSocket routes and route keys that are integrated with backend HTTP endpoints, Lambda functions, or other AWS services.
You can deploy this collection in one or more stages. API methods are invoked through frontend WebSocket connections that you can associate with a registered custom domain name.

#### API Gateway HTTP API

HTTP APIs are designed with minimal features so that they can be offered at a lower price. REST APIs support more features than HTTP APIs.

#### API Gateway REST API

REST APIs will be used because the following main features are needed, and they are only provided by REST APIs: API keys, per-client throttling, request validation, AWS WAF integration, or private API endpoints.
This is going to be the type of API we are going to focus on and it fits all our needs.

For further information about choosing between REST APIs and HTTP APIs please review the following product link:

- [AWS REST APIs vs HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html)

### API Endpoints type

An API endpoint type refers to the hostname of the API.
A hostname for an API in API Gateway that is deployed to a specific Region.
The hostname is of the form `{api-id}.execute-api.{region}.amazonaws.com`.
The following types of API endpoints are supported:

#### Edge-optimized API endpoint

It provides a public API with low latency and high throughput globally and routes requests to the nearest CloudFront Point of Presence (POP), which could help in cases where your clients are geographically distributed.
It is the default endpoint type for API Gateway REST APIs. Edge-optimized APIs capitalize the names of HTTP headers (for example, Cookie).
CloudFront sorts HTTP cookies in natural order by cookie name before forwarding the request to your origin.
Any custom domain name used for an edge-optimized API applies across all regions.

#### Regional API endpoint

A regional API endpoint is intended for clients in the same region.
When an API is intended to serve a small number of clients with high demands, a regional API reduces connection overhead.
For a regional API, any custom domain name used is specific to the region where the API is deployed. If a regional API is deployed in multiple regions, it can have the same custom domain name in all regions.
Regional API endpoints pass all header names through as-is.

#### Private API endpoint

It is an API endpoint that can only be accessed from an Amazon Virtual Private Cloud (VPC) using an interface VPC endpoint, which is an endpoint network interface (ENI) created in a VPC.

### Custom domains

Custom Domains refers to the ability to use our own domain names to access the services offered through AWS, rather than using the default domain names that AWS provides.

With AWS Custom domains DNS records can be fully managed for the domains, enabling to make advanced configurations and redirects as needed.

In this architecture, only regional custom domains have been considered. "Private custom domains" are offered by AWS since November 24, after this architecture was published, so this option is out of the scope and should not be used.
They do not cover all the Santander group requirements in terms of exposition for multiple API consumers.

## Deployment Topology

### Key points

- Every API exposed in AWS must be REST APIS (as configured in AWS) whatever use case they are used for.
- Any account which exposes APIs must provide all the AWS services in all the expositions to be used.
- Gluon & CIP platform will provide a lambda authorizer and a Policy Enforcement Point (PEP), to ensure all the security controls required are performed to every call (signature, COSAC, Oauth...).
Anyway, entities can reuse their own lambda authorizers and PEPs if they have different requirements.
- Common Security Model relies on the use of OAuth and Access Tokens (AT). In case of high transaction volume, the model contemplates the use of non-opaque (AT). Other use cases could prioritize the use of opaque AT with introspection.

### Environments Architecture

Custom Domains will be used for the different exposures and associated to the three use cases (Internet, Intranet and Core).
Each environment will be inside a separate AWS account, where the custom domains for each environment will be deployed. They will have different DNS:

![APIendpoints](../assets/images/aws-apigw-custom-domains.drawio)

#### Intranet Client

This use case shows APIs exposed to front applications inside GSNET. They must use private endpoint types.

![Aws APIGW - Intranet-client](../assets/images/aws-apigateway-internet-intranet-flow-0-8-0-Aws-APIGW-Intranet-client.png){: .image-popup align="center" style="width:80%"}

!!! warning "Disclaimer"
    This diagram has been drawn taking into account all the possible pieces involved. Depending on the use case there are blocks than can be removed.

#### Intranet Core

This use case shows APIs consumption from microservices in different domains (inside or outside AWS). They must use private endpoint types.

![Aws APIGW - Intranet-core](../assets/images/aws-apigateway-internet-intranet-flow-0-8-0-Aws-APIGW-Intranet-core.png){: .image-popup align="center" style="width:80%"}

!!! warning "Disclaimer"
    This diagram has been drawn taking into account all the possible pieces involved. Depending on the use case there are blocks than can be removed.

#### Internet Client

This use case shows APIs exposed to Internet. They can use either public Edge-Optimized or Regional endpoint type, although Regional is recommended due to the reasons explained [above](#regional-api-endpoint).

This use case has been designed based in the [public cloud IFA pattern](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/DP-NET-00X%20-%20Internet-Facing-Assets%20APIGW.aspx).

![AWS APIGW - Internet-client](../assets/images/aws-apigateway-internet-intranet-flow-0-8-0-Aws-APIGW-Internet-client.png){: .image-popup align="center" style="width:80%"}

!!! warning "Disclaimer"
    This diagram has been drawn taking into account all the possible pieces involved. Depending on the use case there are blocks than can be removed.

## API Deployment

This chapter provides an example to guide a developer through the process:

#### Infrastructure Prerequirements

##### Intranet Client

- NLB configured with a DNS for the Intranet Client (The NLB must expose a TLS listener in GSNET.)
- Target Group configured in the NLB to allow traffic to VPC Endpoint Interface related to the custom domain.
- Certificates configured in the Cert Manager for the Intranet Client DNS exposed in the NLB.
- Regional custom domain configured in the AWS Api Gateway Service for the intranet client use case.
- S3 bucket available and configured to store API config files (in case of using CIP container or CIP-provided lambda authorizer).
- In case of using a lambda authorizer:
    - Lambda Authorizer (CIP-provided or locally provided) deployed for the Intranet Client Use Case.
    - Connectivity to the Oauth Server for the Lambda Authorizer, when introspection required.
- Depending on the integration type:
    - VPC Link
        - NLB available for routing to the EKS cluster.
        - VPC Link configured in API Gateway pointing to the NLB which routes over the EKS clusters.
        - Certificate configured in the NLB to allow https connection between the API Gateway and the NLB.
        - Depending on the PEP used:
            - Pod for PEP (Policy Enforcement Point), with a Gluon Gateway Container and a CIP container in sidecar configuration (or CIP embedded as libraries in Gluon Gateway).
            - Local PEP deployed in EKS.
    - AWS service
        - Integration lambda available.

##### Intranet Core

- NLB configured with a DNS for the Intranet Core (The NLB must expose a TLS listener in GSNET.)
- Target Group configured in the NLB to allow traffic to VPC Endpoint Interface related to the custom domain.
- Certificates configured in the Cert Manager for the Intranet Core DNS exposed in the NLB.
- Regional custom domain configured in the AWS Api Gateway Service for the intranet client use case.
- S3 bucket available and configured to store API config files (in case of using CIP container or CIP-provided lambda authorizer).
- In case of using a lambda authorizer:
    - Lambda Authorizer (CIP-provided or locally provided) deployed for the Intranet Core Use Case.
- Depending on the integration type:
    - VPC Link
        - NLB available for routing to the EKS cluster.
        - VPC Link configured in API Gateway pointing to the NLB which routes over the EKS clusters.
        - Certificate configured in the NLB to allow https connection between the API Gateway and the NLB.
        - Depending on the PEP used:
            - Pod for PEP (Policy Enforcement Point), with a Gluon Gateway Container and a CIP container in sidecar configuration (or CIP embedded as libraries in Gluon Gateway).
            - Local PEP deployed in EKS.
    - AWS service
        - Integration lambda available.

##### Internet Client

- AWS WAF available to only allow traffic from Akamai.
- Certificates configured in the Cert Manager for the Internet Client DNS.
- Regional custom domain configured in the AWS Api Gateway Service for the internet client use case.
- S3 service Available and with the Internet Client bucket configured.
- In case of using a lambda authorizer:
    - Lambda Authorizer available for the Internet Client Use Case (if needed).
    - Connectivity to the Oauth Server for the Lambda Authorizer in the Lambda authorizer is used.
- NLB available for routing traffic from the AWS Api Gateway to the Gluon Gateway inside the EKS.
- Depending on the integration type:
    - VPC Link
        - VPC Link to the NLB which balances over the EKS clusters.
        - Certificate configured in the NLB to allow https connection between the API Gateway and the NLB.
    - AWS service
        - Integration lambda available with connection to the NLB.
- Depending on the PEP used.
    - Pod for PEP (Policy Enforcement Point), with a Gluon Gateway Container and a CIP container in sidecar configuration, or embedded as libraries.
    - Custom PEP available.

#### High level view

![High level view](../assets/images/aws-deployment-steps-pep.png)<br>

#### Models

##### With lambda authorizer and CIP container

![API Flow](../assets/images/aws-api-flow-LA.png)<br>

|Architecture blocks|Capabilities|
|-------------------|------------|
|1- API Gateway|<li>API Exposition</li><li>Subscription management</li><li>Quotas</li>  |
|2- Lambda authorizer|<li>Token validation (Oauth, JWE, ...)</li><li>JWSId generation</li>|
|3- Gluon Gateway| <li>Routing</li><li>PEP</li><li>Traceability headers management</li><li>Errors management</li>|
|4- CIP container| <li>JWSId validation</li><li>Signature check</li><li>COSAC</li><li>JWSId generation</li>|
|5- Business microservice|<li>JWSId validation</li>|

##### Without lambda authorizer and CIP container

![API Flow](../assets/images/aws-api-flow-WLA.png)<br>

|Architecture blocks|Capabilities|
|-------------------|------------|
|1- API Gateway|<li>API Exposition</li><li>Subscription management</li><li>Quotas</li>  |
|2- Gluon Gateway| <li>Routing</li><li>PEP</li><li>Traceability headers management</li><li>Errors management</li>|
|3- CIP container| <li>Token validation (Oauth, JWE, ...)</li><li>Signature check</li><li>COSAC</li><li>JWSId generation</li>|
|4- Business microservice|<li>JWSId validation</li>|

##### Gluon Gateway + CIP policies as libraries

![API Flow](../assets/images/aws-api-flow-WLAC.png)<br>

|Architecture blocks|Capabilities|
|-------------------|------------|
|1- API Gateway|<li>API Exposition</li><li>Subscription management</li><li>Quotas</li>  |
|2- Gluon Gateway| <li>Token Validation(Oauth, JWE, ...)</li><li>Routing</li><li>PEP</li><li>Traceability headers management</li><li>Errors management</li><li>Signature check</li><li>COSAC</li><li>JWSId generation</li>|
|3- Business microservice|<li>JWSId validation</li>|

#### Gluon Gateway as PEP capabilities

Gluon Gateway as PEP requires the following capabilities, executing them according to this list:

- Gluon Gateway must know CIP URL at the moment of the pod start. It will be available in the Gluon Gateway configmap.
- Traceability headers Management (W3C & X-B3): Darwin or Sepia filter can be reused.
- CIP request filter:
    - Step 1: Gluon Gateway calls to the CIP with the same request received from AWS API Gateway (including all its headers).

        Example request:

        ```bash
        curl --location --request GET 'http://localhost:8090/accounts/1234' \
        --header 'x-api-key: fcxqdpiih1' \
        --header 'x-api-id: m18p647hik' \
        --header 'x-api-path: /accounts/{accountId}' \
        --header 'Authorization: Bearer eyJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0' \
        --header 'Content-Type: application/json' \
        --data '{
            "typeCode": "01",
            "reasonCode": "M01",
            "contract": {
                "contractId": "86498537498537454",
                "date": "2023-01-21"
            },
            "client": {
                "customerId": "g8lkb-nfd84-of46mf",
                "customerType": "00"
            }
        }'
        ```

    - Step 2: CIP response evaluation
        - Status code 200 OK with a valid JWS-ID: Gluon Gateway calls to the microservice endpoint configured in the configmap following the rules detailed in step 3.
        - Status codes 5xx: If the status code is included in the Standards (500, 502, 503, 504), the request is rejected with the same code. If it is not included in the standards, the status code returned will be 500 Internal Server Error.
        - Status code different than 200 OK or 5xx and/or JWS-ID not received: request is rejected with a 401 Unauthorized.
    - Step 3: Map the authorization token received in the response body to the header Authorization. This header must have the following format: "Bearer + 'JWSId Token'".

        Response example:

        ```bash
        < HTTP/1.1 200
        < Vary: Origin
        < Vary: Access-Control-Request-Method
        < Vary: Access-Control-Request-Headers
        < Content-Length: 798
        < Date: Wed, 09 Oct 2024 11:15:17 GMT
        <
        eyJraWQiOiJidXNpbmVzcy1rZXkiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI4OTQyMjIzIiwiY2hhbm5lbF90cCI6Ik1PQklMRSIsIm5iZiI6MTcyODQ3MjUxNywic2NvcGUiOiJjYXJkcy5yZWFkIiwic2VjQ3R4IjoieydjcGYnOidDUEZOdW1iZXInLCdwZW51bXBlcic6J3BlbnVtcGVyIG51bW
        Jlcid9IiwiY2xpZW50X2lkIjoiZmN4cWRwaWloMSIsImp0aSI6ImY0MWJiODg1LTk2N2QtNDdjYi1iYWVmLTQ4ODE4YzE4NWIxYyIsImlzcyI6IkNJUF9QT0xJQ0lFU19JU1MiLCJpYXQiOjE3Mjg0NzI1MTcsImF1ZCI6ImJ1c3NpbmVzc0F1ZGllbmNlIiwiZXhwIjoxNzI4NDc0MzE3fQ.ZeL-SLwIX083FRENvfRQ_1
        CnCH0RFyVNtu7BI1Y6qmPRm0LSpyrYrN-UQMN0q-21OVzR1upukZdL6RHPmH7rjFdVDJfTqZtjecnF1ETdFJ0oszK4dz8d8lm-BJuHUPry_PnKOmqyEUD4YyAMVlr2mt8OUnu5SxdTjWvjy2BwPfNXUKykmaoZz3_rI8vao9pOgMTP4cTvHzlXbeQwoydQmy0g0zZm9bPpu2fzRZ1zrhTBtDSH8L0sFvN_fzBGbJL1JhvCx
        RLYrelKr17lElWYQHIUAARcpSLhCHTH664y7FE_pZLoBxziK4kkAvgRojYLv_iUzsghYiDJOG6PIIAczw* Connection #0 to host localhost left intact
        ```

- *Remove headers filter (optional)*: Prevents custom headers generated in AWS API Gateway from being sent to the business microservice (x-api-method, x-api-path, ...).
- Backend call: Gluon Gateway executes the request to the microservice. This requires that the microservice URL must be included in Gluon Gateway configmap when the microservice is deployed.
- Logging: Darwin or Sepia filter can be reused.
- Error Management: Darwin filter can be reused.
- Healthcheck: Darwin or Sepia filter can be reused<br>

![aws-api-gateway-cip-filter-capabilities](../assets/images/aws-api-gateway-pep-filter-capabilities.png)<br>

#### Deployment Steps for a New Api

##### Prerequirements

The following information is required to execute an API deployment:

- API exposition (custom domain): Internet-Client, Intranet-Client, Intranet-Core....
- Authorization point: (lambda authorizer provided by CIP, local lambda authorizer, no lambda authorizer)
- Integration point:  VPC link (PEP provided by Gluon or local PEP), AWS service..

##### Intranet Use cases

> The following commands have been executed using AWS cloudshell.

1. **Create REST API in AWS API Gateway from an OpenAPI 3 file**: Here is an example of the OpenAPI file used for this deployment guide [api-example-ufm7om51v0.yml](../assets/images/api-example-ufm7om51v0.yml).

    - **Import OpenAPI**: It is important to note that the OpenAPI file must be compliance with all the restrictions documented by AWS in the following link: [OpenAPI Restrictions](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-known-issues.html)

    For intranet-client use case it's required to configure an endpoint **PRIVATE**. Endpoint configuration can be **EDGE, REGIONAL, PRIVATE**. In case of internet exposures, the endpoint configuration should be **REGIONAL**.

    ```bash
    aws apigateway import-rest-api --fail-on-warnings --parameters endpointConfigurationTypes=PRIVATE --body fileb://api-example-ufm7om51v0.yml
    ```

    ```json
    # Response
    {
    "id": "ufm7om51v0",
    "name": "Customer Position API",
    "description": "Provides information about contracts and balances of a customer. It also includes endpoints to allow sorting the sequence of each product family in the list.",
    "createdDate": "2024-10-07T09:48:51+00:00",
    "version": "1.2.0",
    "apiKeySource": "HEADER",
    "endpointConfiguration": {
        "types": [
            "PRIVATE"
        ]
    },
    "disableExecuteApiEndpoint": false,
    "rootResourceId": "08960zjp68"
    }
    ```

    IMPORTANT: Now save the `id` from the response (e.g., `ufm7om51v0`).

    Make sure to handle errors that may arise during the import, such as formatting problems in the OpenAPI file.

2. **Associate the proper VPC endpoint to the API according to the use case and custom domain used**:

    ```bash
    aws apigateway update-rest-api --rest-api-id ufm7om51v0 --patch-operations op=add,path=/endpointConfiguration/vpcEndpointIds,value=vpce-01f422b2b8af44004
    ```

    ```json
    {
        "id": "ufm7om51v0",
        "name": "Customer Position API",
        "description": "Provides information about contracts and balances of a customer. It also includes     endpoints to allow sorting the sequence of each product family in the list.",
        "createdDate": "2024-10-07T09:48:51+00:00",
        "version": "1.2.0",
        "apiKeySource": "HEADER",
        "endpointConfiguration": {
            "types": [
                "PRIVATE"
            ],
            "vpcEndpointIds": [
                "vpce-01f422b2b8af44004"
            ]
        },
        "tags": {},
        "disableExecuteApiEndpoint": false,
        "rootResourceId": "08960zjp68"
    }
    ```

3. **Resource policy that allows access to the API through the VPC endpoint**:

    ```sh
      aws apigateway update-rest-api --region eu-west-1 --rest-api-id ufm7om51v0 --patch-operations 'op=replace,path=/policy,value="{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"execute-api:Invoke\",\"Resource\":\"arn:aws:execute-api:eu-west-1:533267329486:ufm7om51v0/*/*/*\",\"Condition\":{\"StringEquals\":{\"aws:sourceVpce\":\"vpce-01f422b2b8af44004\"}}}]}"'
    ```

    ```json
        {
            "id": "ufm7om51v0",
            "name": "Customer Position API",
            "description": "Provides information about contracts and balances of a customer. It also includes endpoints to allow sorting the sequence of each product family in the list.",
            "createdDate": "2024-10-07T09:48:51+00:00",
            "version": "1.2.0",
            "apiKeySource": "HEADER",
            "endpointConfiguration": {
                "types": [
                    "PRIVATE"
                ],
                "vpcEndpointIds": [
                    "vpce-01f422b2b8af44004"
                ]
            },
            "policy": "{\\\"Version\\\":\\\"2012-10-17\\\",\\\"Statement\\\":[{\\\"Effect\\\":\\\"Allow\\\",\\\"Principal\\\":\\\"*\\\",\\\"Action\\\":\\\"execute-api:Invoke\\\",\\\"Resource\\\":\\\"arn:aws:execute-api:eu-west-1:533267329486:ufm7om51v0\\/*\\/*\\/*\\\",\\\"Condition\\\":{\\\"StringEquals\\\":{\\\"aws:sourceVpce\\\":\\\"vpce-01f422b2b8af44004\\\"}}}]}",
            "tags": {},
            "disableExecuteApiEndpoint": false,
            "rootResourceId": "08960zjp68"
        }
    ```

4. **Disable the API default endpoint**: To disable the default endpoint for an API, you can use the following command:

    ```bash
    aws apigateway update-rest-api --rest-api-id ufm7om51v0 --patch-operations op=replace,path=/disableExecuteApiEndpoint,value=true
    ```

    This command will update the API configuration and set the `disableExecuteApiEndpoint` property to `true`. After executing this command, the default endpoint for the API will be disabled.

    Here is the updated API configuration:

    ```json
    {
        "id": "ufm7om51v0",
        "name": "Customer Position API",
        "description": "Provides information about contracts and balances of a customer. It also includes endpoints to allow sorting the sequence of each product family in the list.",
        "createdDate": "2024-10-07T09:48:51+00:00",
        "version": "1.2.0",
        "apiKeySource": "HEADER",
        "endpointConfiguration": {
            "types": [
                "PRIVATE"
            ],
            "vpcEndpointIds": [
                "vpce-01f422b2b8af44004"
            ]
        },
        "tags": {},
        "disableExecuteApiEndpoint": true,
        "rootResourceId": "08960zjp68"
    }
    ```

5. **Configure API Key as required for all methods in the API**: To ensure secure access to your API, it is recommended to configure the API Key as required for all methods.
  First step. Get all resources from the API.
  
    ```sh
    aws apigateway get-resources --rest-api-id ufm7om51v0
    ```
  
    Response should be as follows:
  
    ```json
    {
        "items": [
            {
                "id": "08960zjp68",
                "path": "/",
                "resourceMethods": {
                    "GET": {}
                }
            }
        ]
    }
    ```
  
    Second step. Update the method to require an API key, based on the resourceid obtained in the first step.
  
    ```bash
    aws apigateway update-method --rest-api-id ufm7om51v0 --resource-id 08960zjp68 --http-method GET --patch-operations op=replace,path=/apiKeyRequired,value='true'
    ```
  
    Response should be as follows:
  
    ```json
    {
        "httpMethod": "GET",
        "authorizationType": "NONE",
        "apiKeyRequired": true,
        "operationName": "getCustomerPosition",
        "requestParameters": {
            "method.request.header.accept": false,
            "method.request.header.accept-language": false,
            "method.request.header.content-type": false,
            "method.request.header.device-information": false,
            "method.request.querystring.activeOnly": true,
            "method.request.querystring.customer_id": false,
            "method.request.querystring.operation": false,
            "method.request.querystring.product_family": false,
            "method.request.querystring.profile_id": false
        },
        "methodResponses": {
            "200": {
                "statusCode": "200",
                "responseModels": {
                    "application/json": "GetGlobalPositionResponse"
                }
            },
            "204": {
                "statusCode": "204"
            },
            "400": {
                "statusCode": "400",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "401": {
                "statusCode": "401",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "403": {
                "statusCode": "403",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "404": {
                "statusCode": "404",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "415": {
                "statusCode": "415",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "500": {
                "statusCode": "500",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "503": {
                "statusCode": "503",
                "responseModels": {
                    "application/json": "Errors"
                }
            },
            "504": {
                "statusCode": "504",
                "responseModels": {
                    "application/json": "Errors"
                }
            }
        }
    }
    ```
  
6. **Authorization config**: In this step, depending on the authorization model selected, a Lambda Authorizer will be configured if necessary for all the methods of the API.

    The first step is create an authorizer reference from an [existing lambda](https://docs.aws.amazon.com/apigateway/latest/developerguide/configure-api-gateway-lambda-authorization.html#configure-api-gateway-lambda-authorization-cli).

    ```sh
      aws apigateway create-authorizer  --rest-api-id ufm7om51v0 --name intracli-lambdaAuthorizer --type REQUEST --authorizer-uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:533267329486:function:intra-cli-authorizer:2/invocations --identity-source method.request.header.Authorization
    ```

    ```json
    {
    "id": "zwxgwt",
    "name": "intracli-lambdaAuthorizer",
    "type": "REQUEST",
    "authType": "custom",
    "authorizerUri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:533267329486:function:intra-cli-authorizer/invocations",
    "identitySource": "method.request.header.Authorization"
    }
    ```

    The second step is the creation of the trigger that allows the API to invoke the lambda authorizer:

    ```sh
       aws lambda add-permission \
          --function-name arn:aws:lambda:eu-west-1:533267329486:function:intra-cli-authorizer:2 \
          --statement-id ufm7om51v0-authorizer \
          --action lambda:InvokeFunction \
          --principal apigateway.amazonaws.com \
          --source-arn arn:aws:execute-api:eu-west-1:533267329486:fd4x9euwx1/authorizers/zwxgwt
    ```

    ```json
     {
     "Statement": "{\"Sid\":\"ufm7om51v0-authorizer\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"arn:aws:lambda:eu-west-1:533267329486:function:intra-cli-authorizer:2\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"arn:aws:execute-api:eu-west-1:533267329486:ufm7om51v0/authorizers/zwxgwt\"}}}"
     }
    ```

    The third step is link the method to the authorizer recently created.

    ```bash
    aws apigateway update-method --rest-api-id ufm7om51v0 --resource-id 08960zjp68 --http-method GET  --patch-operations op="replace",path="/authorizationType",value="CUSTOM" op="replace",path="/authorizerId",value="zwxgwt"
    ```

    An example of the response is available [here](../assets/images/update-authorizer-method-response.txt).

7. **Enable CORS** In this step, CORS will be enabled to all methods in a resource.

    - First of all, it is necessary to create the OPTIONS method.

    ```bash
    aws apigateway put-method \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method OPTIONS \
    --authorization-type "NONE"
    ```

    Response:

    ```json
    {
    "httpMethod": "OPTIONS",
    "authorizationType": "NONE",
    "apiKeyRequired": false
    }
    ```

    - Once the OPTIONS method has been created, its integration has to be set, using a mock.

    ```bash
    aws apigateway put-integration \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method OPTIONS \
    --type MOCK \
    --request-templates '{"application/json":"{\"statusCode\": 200}"}'
    ```

    Response:

    ```json
    {
    "type": "MOCK",
    "requestTemplates": {
        "application/json": "{\"statusCode\": 200}"
    },
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "cacheNamespace": "08960zjp68",
    "cacheKeyParameters": []
    }
    ```

    - The next step is to set the OPTIONS method response setting CORS headers.

    ```bash
    apigateway put-method-response \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Origin":true,"method.response.header.Access-Control-Allow-Methods":true,"method.response.header.Access-Control-Allow-Headers":true}'
    ```

    Response:

    ```json
    {
    "statusCode": "200",
    "responseParameters": {
        "method.response.header.Access-Control-Allow-Headers": true,
        "method.response.header.Access-Control-Allow-Methods": true,
        "method.response.header.Access-Control-Allow-Origin": true
    }
    }
    ```

    - Finally, the integration response can be generated including the CORS headers. This headers can be customized depending on the CORS restrictions previously defined depending on securirty use cases.

    ```bash
    aws apigateway put-integration-response \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Origin": "'"'"'*'"'"'","method.response.header.Access-Control-Allow-Methods": "'"'"'GET,POST,OPTIONS'"'"'","method.response.header.Access-Control-Allow-Headers": "'"'"'Content-Type,Authorization'"'"'"}'
    ```

    Response:

    ```json
    {
    "statusCode": "200",
    "responseParameters": {
        "method.response.header.Access-Control-Allow-Headers": "'Content-Type,Authorization'",
        "method.response.header.Access-Control-Allow-Methods": "'GET,POST,OPTIONS'",
        "method.response.header.Access-Control-Allow-Origin": "'*'"
    }
    }
    ```

8. **Integration config**: In this step, depending on the integration model selected, a VPC link integration or a AWS service integration will be configured.

    - In this particular example VPC Link will be configured as the integration type to all the methods of the API. It must be repeated per operation in the API.

    > connection-id value is the id of the VPC link that has been created before deploying an API.

    ```sh
    aws apigateway put-integration --rest-api-id ufm7om51v0 --resource-id 08960zjp68 --uri 'https://eks-nlb-310604bd0d3a71f3.elb.eu-west-1.amazonaws.com/customer-position' --http-method GET --type HTTP --integration-http-method GET --connection-type VPC_LINK --connection-id 1ecwvd
    ```

    Response:

    ```json
    {
        "type": "HTTP",
        "httpMethod": "GET",
        "uri": "https://eks-nlb-310604bd0d3a71f3.elb.eu-west-1.amazonaws.com/customer-position",
        "connectionType": "VPC_LINK",
        "connectionId": "1ecwvd",
        "passthroughBehavior": "WHEN_NO_MATCH",
        "timeoutInMillis": 29000,
        "cacheNamespace": "08960zjp68",
        "cacheKeyParameters": []
    }
    ```

    - To map request headers in an integration request as the JWSId token from the lambda authorizer or any other header needed in the CIP container, the following command needs to be executed.

    ```bash
    aws apigateway update-integration \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method GET \
    --patch-operations op=add,path=/requestParameters/integration.request.header.Authorization,value='context.authorizer.authorization' \
    op=add,path=/requestParameters/integration.request.header.x-api-method,value='context.httpMethod' \
    op=add,path=/requestParameters/integration.request.header.x-api-path,value='context.resourcePath' \
    op=add,path=/requestParameters/integration.request.header.x-custom-domain,value='context.domainName'
    ```

    ```json
    {
    "type": "HTTP",
    "httpMethod": "GET",
    "uri": "https://eks-nlb-310604bd0d3a71f3.elb.eu-west-1.amazonaws.com/customer-position",
    "connectionType": "VPC_LINK",
    "connectionId": "1ecwvd",
    "requestParameters": {
        "integration.request.header.Authorization": "context.authorizer.authorization",
        "integration.request.header.x-api-method": "context.httpMethod",
        "integration.request.header.x-api-path": "context.resourcePath",
        "integration.request.header.x-custom-domain": "context.domainName"
    },
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "cacheNamespace": "08960zjp68",
    "cacheKeyParameters": []
    }
    ```

    - In the case that there are path parameters and/or query parameters it its needed to update the integration request (this must be done for each resource & method)

    ```bash
    aws apigateway update-integration \
    --rest-api-id ufm7om51v0 \
    --resource-id 08960zjp68 \
    --http-method GET \
    --patch-operations \
    op=add,path=/requestParameters/integration.request.querystring.customQueryParam,value='method.request.querystring.customQueryParam' \
    op=add,path=/requestParameters/integration.request.path.customPathParam,value='method.request.path.customPathParam'
    ```

    ```json
    {
    "type": "HTTP",
    "httpMethod": "GET",
    "uri": "https://eks-nlb-310604bd0d3a71f3.elb.eu-west-1.amazonaws.com/customer-position",
    "connectionType": "VPC_LINK",
    "connectionId": "1ecwvd",
    "requestParameters": {
        "integration.request.header.Authorization": "context.authorizer.authorization",
        "integration.request.header.x-api-method": "context.httpMethod",
        "integration.request.header.x-api-path": "context.resourcePath",
        "integration.request.header.x-custom-domain": "context.domainName",
        "integration.request.path.customPathParam": "method.request.path.customPathParam",
        "integration.request.querystring.customQueryParam": "method.request.querystring.customQueryParam"
    },
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "cacheNamespace": "08960zjp68",
    "cacheKeyParameters": [],
    "integrationResponses": {
        "200": {
            "statusCode": "200",
            "responseTemplates": {
                "application/json": null
            }
        }
    }
    }
    ```

    !!! warning "Disclaimer"
        The previous commands implement the case when the lambda returns a token (e.g CIP lambda authorizer), and it is mandatory to map the new JWSId token in the Authorization header.
        If the use case does not need to map any new generated tokens, use the previous command (aws apigateway put-integration) using the parameter (--type HTTP_PROXY).

    - In case of not having an homologated certificate, an autosigned certificate can be used as follows to skip the certificate validation.

    ```bash
    aws apigateway update-integration --rest-api-id ufm7om51v0 --resource-id 08960zjp68 --http-method GET --patch-operations "op='replace',path='/tlsConfig/insecureSkipVerification',value=true"
    ```

    Response:

    ```json
    {
        "type": "HTTP_PROXY",
        "httpMethod": "GET",
        "uri": "https://eks-nlb-310604bd0d3a71f3.elb.eu-west-1.amazonaws.com/customer-position",
        "connectionType": "VPC_LINK",
        "connectionId": "1ecwvd",
        "passthroughBehavior": "WHEN_NO_MATCH",
        "timeoutInMillis": 29000,
        "cacheNamespace": "08960zjp68",
        "cacheKeyParameters": [],
        "tlsConfig": {
            "insecureSkipVerification": true
        }
    }
    ```

    - If the integration request target is a lambda, it has to be done via AWS Service.

    !!! warning "Disclaimer"
        This example sends the same request AWS API Gateway receives (AWS_PROXY). Depending on the custom use case, it may be necessary to make some additional mappings to build the complete request the lambda function expects.

    ```bash
    aws apigateway put-integration --rest-api-id ufm7om51v0 --resource-id 08960zjp68 --http-method POST --type AWS_PROXY --integration-http-method POST --uri 'arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:533267329486:function:intranet-client-businessMock-java-tf/invocations'
    ```

    ```json
    {
    "type": "AWS_PROXY",
    "httpMethod": "POST",
    "uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:533267329486:function:intranet-client-businessMock-java-tf/invocations",
    "passthroughBehavior": "WHEN_NO_MATCH",
    "timeoutInMillis": 29000,
    "cacheNamespace": "08960zjp68",
    "cacheKeyParameters": []
    }
    ```

9. **Generate an API client id to identify it when calling to other systems (backend, APIs,...)**

    Depending on the use case it will be necessary to autogenerate the API client id, or use one previously generated by other system.

    - Autogenerate a client id.

    ```bash
    aws apigateway create-api-key \
    --name "api-key-dummy" \
    --description "APIkey example" \
    --enabled
    ```

    Response:

    ```json
    {
    "id": "sv98gssyw9",
    "value": "Is8s7NtWp617sSfSQIinbuJcsxSY6MN22xkTE4q3",
    "name": "api-key-dummy",
    "description": "APIkey example",
    "enabled": true,
    "createdDate": "2024-10-22T08:55:38+00:00",
    "lastUpdatedDate": "2024-10-22T08:55:38+00:00",
    "stageKeys": []
    }
    ```

    - Generate a client id using a value previously generated.

    ```bash
    aws apigateway create-api-key \
    --name "api-key-custom" \
    --description "API client id" \
    --value "b082efbc-a8a1-4590-853a-66d02676c951" \
    --enabled \
    ```

    Response:

    ```json
    {
    "id": "dj36wawy9l",
    "value": "b082efbc-a8a1-4590-853a-66d02676c951",
    "name": "api-key-custom",
    "description": "API client id",
    "enabled": true,
    "createdDate": "2024-10-22T08:58:19+00:00",
    "lastUpdatedDate": "2024-10-22T08:58:19+00:00",
    "stageKeys": []
    }
    ```

    - Once the API client id has been generated, it will be included later in step 12 as a stage variable.

10. **Upload the API configuration file (client use cases)**

    If the API is for a core exposition, this step must be skipped (the required values for core use cases will be added in step 12 in a different way).
    The command is similar to the following:

    ```sh
    aws s3 cp ./ufm7om51v0.yml s3://intranet-client-api-bucket/ufm7om51v0.yml
    ```

    Response:

    ```sh
     upload: ./ufm7om51v0.yml to s3://intranet-client-api-bucket/ufm7om51v0.yml
    ```

    The file uploaded can be viewed here: [ufm7om51v0.yml](../assets/images/ufm7om51v0.yml)

11. **API deployment**

       ```sh
        aws apigateway create-deployment \
        --region eu-west-1 \
        --rest-api-id ufm7om51v0 \
        --stage-name prod \
        --description 'Deploy to production'
        # Response
        {
            "id": "kktwox",
            "description": "Deploy to production",
            "createdDate": "2024-10-07T14:35:51+00:00"
        }
       ```

12. **Stage update with API configuration values**

    The most common API configuration values will be configured as stage variables as follows:

       ```sh
        aws apigateway update-stage \
        --rest-api-id ufm7om51v0 \
        --stage-name stageName \
        --patch-operations '[{"op": "replace", "path": "/variables/ufm7om51v0_aud", "value": "custpos"}, {"op": "replace", "path": "/variables/ufm7om51v0_claims", "value": "claim1, claim 2"}, {"op": "replace", "path": "/variables/ufm7om51v0_client_id", "value": "b082efbc-a8a1-4590-853a-66d02676c951"}, {"op": "replace", "path": "/variables/ufm7om51v0_kid", "value": "kid_value"}]'

        # Response:
        {
            "deploymentId": "kktwox",
            "stageName": "CIAWSGLUONPASSCLIDEV-ufm7om51v0",
            "cacheClusterEnabled": false,
            "cacheClusterStatus": "NOT_AVAILABLE",
            "methodSettings": {
                "*/*": {
                    "metricsEnabled": false,
                    "loggingLevel": "INFO",
                    "dataTraceEnabled": true,
                    "throttlingBurstLimit": 5000,
                    "throttlingRateLimit": 10000.0,
                    "cachingEnabled": false,
                    "cacheTtlInSeconds": 300,
                    "cacheDataEncrypted": false,
                    "requireAuthorizationForCacheControl": true,
                    "unauthorizedCacheControlHeaderStrategy": "SUCCEED_WITH_RESPONSE_HEADER"
            }
        },
        "variables": {
        "ufm7om51v0_aud": "custpos",
        "ufm7om51v0_claims": "claim1, claim 2",
        "ufm7om51v0_client_id": "b082efbc-a8a1-4590-853a-66d02676c951",
        "ufm7om51v0_kid": "kid_value"
        },
        "tracingEnabled": false,
        "createdDate": "2024-10-07T14:35:51+00:00",
        "lastUpdatedDate": "2024-10-07T14:55:51+00:00"

       ```

13. **Add route base mapping**:

       ```sh
        aws apigateway create-base-path-mapping --domain-name 'intra-cli-api.op-paas-cs-pos.aws.eu-west-1.sgtech.gs.corp' --rest-api-id 'ufm7om51v0' --stage 'prod' --base-path 'customer-position'
        # Response:
        {
            "basePath": "customer-position",
            "restApiId": "ufm7om51v0",
            "stage": "prod"
        }
       ```

14. **Create Usage Plan**

    ```sh
    aws apigateway create-usage-plan --name "FreeUsagePlan" --description "Basic Plan with month queries limit" --quota limit=10000,period=MONTH --throttle rateLimit=50,burstLimit=200 --api-stages apiId=ufm7om51v0,stage=prod
    ```

    Response:

    ```json
    {
        "id": "tg8e31",
        "name": "FreeUsagePlan",
        "description": "Basic Plan with month queries limit",
        "apiStages": [
            {
                "apiId": "ufm7om51v0",
                "stage": "prod"
            }
        ],
        "throttle": {
            "burstLimit": 200,
            "rateLimit": 50.0
        },
        "quota": {
            "limit": 10000,
            "offset": 0,
            "period": "MONTH"
        }
    }
    ```

##### Internet Use cases

Most of the deployment procedure is the same as for intranet, however depending on the architecture used, some differences must be taken into account:

- **Operational Paas Architecture**: If the architecture used is as explained in this page, the gateway is exposed directly to internet, so 2 steps of the previous deployment guide must be skipped and one step is slightly different:

    - Step 2 and 3 must be skipped as no vpc endpoint is in front of the API Gateway.

    - In step 12, the stage variable "scp_tag" with the value "ifa_apigw" must be included in addition to the rest variables already described, following the pattern defined by Cyber team: [DP-NET-007 - Internet Facing Assets HTTPS Pattern](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/DP-NET-00X%20-%20Internet-Facing-Assets%20APIGW.aspx):

       ```sh
        aws apigateway update-stage \
        --rest-api-id ufm7om51v0 \
        --stage-name stageName \
        --patch-operations '[{"op": "replace", "path": "/variables/ufm7om51v0_aud", "value": "custpos"}, {"op": "replace", "path": "/variables/ufm7om51v0_claims", "value": "claim1, claim 2"}, {"op": "replace", "path": "/variables/ufm7om51v0_client_id", "value": "b082efbc-a8a1-4590-853a-66d02676c951"}, {"op": "replace", "path": "/variables/ufm7om51v0_kid", "value": "kid_value"}, {"op": "replace", "path": "/variables/scp_tag", "value": "ifa_apigw"}]'

        # Response:
        {
            "deploymentId": "kktwox",
            "stageName": "CIAWSGLUONPASSCLIDEV-ufm7om51v0",
            "cacheClusterEnabled": false,
            "cacheClusterStatus": "NOT_AVAILABLE",
            "methodSettings": {
                "*/*": {
                    "metricsEnabled": false,
                    "loggingLevel": "INFO",
                    "dataTraceEnabled": true,
                    "throttlingBurstLimit": 5000,
                    "throttlingRateLimit": 10000.0,
                    "cachingEnabled": false,
                    "cacheTtlInSeconds": 300,
                    "cacheDataEncrypted": false,
                    "requireAuthorizationForCacheControl": true,
                    "unauthorizedCacheControlHeaderStrategy": "SUCCEED_WITH_RESPONSE_HEADER"
            }
        },
        "variables": {
        "ufm7om51v0_aud": "custpos",
        "ufm7om51v0_claims": "claim1, claim 2",
        "ufm7om51v0_client_id": "b082efbc-a8a1-4590-853a-66d02676c951",
        "ufm7om51v0_kid": "kid_value"
        "scp_tag": "ifa_apigw"
        },
        "tracingEnabled": false,
        "createdDate": "2024-10-07T14:35:51+00:00",
        "lastUpdatedDate": "2024-10-08T14:56:51+00:00"

       ```

- **Previous architecture**: If the API is exposed through the North firewall, the deployment process is exactly the same than defined for intranet (client).

## API Lifecycle

### Introduction

The following diagram shows the possible lifecycle states for a Product version, and the Product management operations that move a Product version from one lifecycle state to another.
For example, the Retire operation moves a Product version from the Published to the Retired state.

![Page-1](../assets/images/aws-apigateway-lifecycle-0-0-1.drawio){: .image-popup align="center" style="width:80%"}<br>

#### Oauth Server

<div class="cards row-auto" markdown>
  The Oauth Server used for this guide is SOS. [Official Documentation SOS Link](https://san-sgt-basic.atlassian.net/wiki/spaces/ARCHSEC/pages/447843035/Security+OAuth+Server.+S.O.S.)
</div>

### Credential Management

#### Client

- Depending on the case, the creation of a new client id, and optionally, a client secret, will be required.
In the case of public clients, it is not necessary to generate the client secret. First, it is created on the OAuth server, and later it is ingested into the manager.

#### Example Credential Management Client (not public clients)

Following the previous example, we are going to create an AWS API Key with the custom value we have obtained from the OAuth Server.

To this custom API Key we are going to add a tag where we are going to store the value "channel_tp" in order to identify its channel.
This way we are going to identify the application.
Later this tag will be used for the security policies.

```bash
#Only for Client (Generate Client ID in Oauth Server)
curl --location --request POST 'https://SOSHost/manager/oauth/clients' \
--header 'Authorization: Basic QWRtaadfafadfafafaJBX1NDSUI6MTM0TUNnZSE=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "accessTokenValiditySeconds": "3600",
    "refreshTokenValiditySeconds": 3600,
    "authorizedGrantTypes": ["client_credentials"]
}'

#Example Response
{
    "clientId": "9e6f899e-0c8f-4a75-887d-f02599bd6426",
    "clientSecret": "pQa*qSpzcxH1ac>6E)oG:6&1EUQau6"
}

#Generate API Key using key generated from Oauth Server)
aws apigateway create-api-key \
    --name "app-name_APIKey" \
    --description "APIKey for channel_tp" \
    --value "9e6f899e-0c8f-4a75-887d-f02599bd6426" \
    --enabled \
    --tags "channel_tp=mobile"

#Example Response
{
    "id": "j0mygqi19d",
    "value": "9e6f899e-0c8f-4a75-887d-f02599bd6426",
    "name": "app-name_APIKey",
    "description": "APIKey for channel_tp",
    "enabled": true,
    "createdDate": "2024-08-09T08:59:38+00:00",
    "lastUpdatedDate": "2024-08-09T08:59:38+00:00",
    "stageKeys": [],
    "tags": {
        "channel_tp": "mobile"
    }
}
```

#### Core

- In the core case, it is only necessary to create a Client Id + secret, and those created in the Api Connect manager can be used directly.

#### Example Credential Management Core

In the Core case, we are going to tell AWS to generate an API Key for us.

```bash
#Generate API Key from AWS
aws apigateway create-api-key \
    --name "app-name_Core_APIKey" \
    --description "APIKey for core" \
    --enabled

#Example Response
{
    "id": "ead5ai82b2",
    "value": "ksIdjY7Xgi4Dta5FKI3vG1MYuBSzvfxz1Ahft9n6",
    "name": "app-name_Core_APIKey",
    "enabled": true,
    "createdDate": "2024-08-09T09:30:19+00:00",
    "lastUpdatedDate": "2024-08-09T09:30:19+00:00",
    "stageKeys": []
}

```

### Subscription

#### Client

- Associates the API Key with a Usage Plan using the API Key id and the Usage Plan generated earlier.
<a name="scope"></a>
- Registration of scopes in OAuth server

#### Example

```bash
#Associates the API Key with a Usage Plan
aws apigateway create-usage-plan-key \
    --usage-plan-id 5xcmw8 \
    --key-id j0mygqi19d \
    --key-type API_KEY

#Example Response
{
    "id": "j0mygqi19d",
    "type": "API_KEY",
    "value": "9e6f899e-0c8f-4a75-887d-f02599bd6426",
    "name": "app-name_APIKey"
}

```

```bash
# Registration in Oauth Server
#https://SOSHost/manager/oauth/clients/{client-id}/scopes
curl --location --request POST 'https://SOSHost/manager/oauth/clients/test-operational-paas-client-id/scopes' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic YWRtaW5fX3Rlc3Q6YWRtaW4=' \
--data '{"scope": ["read"],"authorizedGrantTypes": ["authorization_code"],"autoApproveScopes": ["read"]}'

# Example response
{
    "clientId": "test-paas-client-credentials-id",
    "scope": [
        "accounts.read",
        "read"
    ],
    "grantsAssignedToScopes": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "autoApproved": true
        }
    ],
    "scopesDetails": [
        {
            "scope": "accounts.read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        },
        {
            "scope": "read",
            "grants": [
                "client_credentials"
            ],
            "clientAuthentication": "client_secret_basic",
            "autoApproved": true
        }
    ],
    "authorizedGrantTypes": [
        "client_credentials"
    ],
    "registeredRedirectUris": [],
    "autoApproveScopes": [
        "accounts.read",
        "read"
    ],
    "accessTokenValiditySeconds": 2592000,
    "additionalInformation": "Additional information for client credentials id",
    "clientAuthorities": [],
    "refreshTokenValiditySeconds": 2000,
    "client_type": "confidential"
}

```

#### Core

- Associates the API Key with a Usage Plan using the API Key id and the Usage Plan generated earlier.

```bash
#Associates the API Key with a Usage Plan
aws apigateway create-usage-plan-key \
    --usage-plan-id 5xcmw8 \
    --key-id ead5ai82b2 \
    --key-type API_KEY

#Example Response
{
    "id": "ead5ai82b2",
    "type": "API_KEY",
    "value": "ksIdjY7Xgi4Dta5FKI3vG1MYuBSzvfxz1Ahft9n6",
    "name": "app-name_Core_APIKey"


```

### Deprecating

There is no native deprecated capability in AWS API Gateway. A possible solution could be **to add a Status tag to the Usage Plan**, so it can be checked whether it is active or deprecated.

This way, when a subscription to an Usage Plan is created by someone, the Status tag of the requested Usage Plan can be retrieved previously and the API's status can be communicated to the users.
If it is found as Deprecated, the subscription must be denied and a message about this must be returned.

Tags could even be used to inform the user of the new Use Plan that replaces the deprecated Use Plan.

#### Adding Tags to a Usage Plan

```bash
#Adding status Active tag to Usage Plan
aws apigateway tag-resource \
    --resource-arn arn:aws:apigateway:eu-west-1::/usageplans/rmvw2d \
    --tags Status=Active

#Adding status Deprecated tag to Usage Plan
aws apigateway tag-resource \
    --resource-arn arn:aws:apigateway:eu-west-1::/usageplans/rmvw2d \
    --tags Status=Deprecated

```

#### Viewing Tags on a Usage Plan

```bash
#To check the tags that are assigned to a usage plan
aws apigateway get-tags \
    --resource-arn arn:aws:apigateway:eu-west-1::/usageplans/rmvw2d

# Example Response Active
{
    "tags": {
        "Status": "Active"
    }
}

# Example Response Deprecated
{
    "tags": {
        "Status": "Deprecated"
    }
}

```

### Retiring

- Theoretically, the scopes should be removed. But until there is a thesis that scopes are not shared by APIs, it is a complex operation that is not recommended to be done.
- This process is the same for Client and Core

**Steps:**

**1. Check that there are no subscriptions in the Usage Plan**
![retiring-1](../assets/images/aws-apigateway-suscription-retiring-0-0-1.drawio){: .image-popup align="center" style="width:95%"}

```bash
#List of API keys from the current stage's usage plan generated earlier
aws apigateway get-usage-plan-keys \
    --usage-plan-id 5xcmw8

#Example Response
{
    "items": []
}
```

**2. Removing Stage from Usage Plan**
![retiring-2](../assets/images/aws-apigateway-suscription-retiring-0-0-1.drawio){: .image-popup align="center" style="width:95%"}  

We can now remove the Stage.

```bash
#Remove stage
aws apigateway delete-stage \
    --rest-api-id zfqr38kyng \
    --stage-name prod

#Example Response
# delete-stage command will not return any response if the delete is successful.
```

**3. Remove Usage Plan**
![retiring-3](../assets/images/aws-apigateway-suscription-retiring-0-0-1.drawio){: .image-popup align="center" style="width:95%"}  

We can now remove the Usage Plan.

```bash
#Remove Usage Plan
aws apigateway delete-usage-plan \
    --usage-plan-id 5xcmw8

#Example Response
# delete-usage-plan command will not return any response if the delete is successful.
```

At this point the APIs are no longer servicing calls, but they still exist: in AWS API Gateway they are not exposed but they are in the list, in Draft state.
If you want to remove them from Drafts, you can safety remove the API using the next command:

```bash
#Remove draft API
aws apigateway delete-rest-api \
    --rest-api-id zfqr38kyng

#Example Response
# delete-rest-api command will not return any response if the delete is successful.
```

### Subscription Migration

#### Client

- Before migrating: At least, the plan must have the same operations as the original plan, for each API in the plan, and with at least the same rate limit.
In other words, a release or a fix. Backward compatible versioning. Previously, new scopes must be checked.

- We assume that there is a Usage Plan that exposes APIs, **API A v1.0.0** and **API B v1.0.0** that several consumers are already using. We have new versions of the APIs, <span style="color:blue">**API A v1.1.0**</span> y
<span style="color:blue">**API B v1.0.1**</span> which we want to migrate all consumers to. We assume that a Usage Plan and a Stage have already been created for the new versions of these APIs:

![usage-1](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}  

**Steps:**

**1. Associate API Keys to new Usage Plan**
![usage-2](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}  

To do this, we need to find out which are the consumers of the current APIs. For this purpose, we will obtain the list of API keys from the current stage's Usage Plan generated earlier.

```bash
#List of API keys from the current stage's usage plan generated earlier
aws apigateway get-usage-plan-keys \
    --usage-plan-id 5xcmw8 \
    --query 'items[].{ID:id, Name:name}' \
    --output text

#Example Response
ead5ai82b2      app-name_Core_APIKey
j0mygqi19d      app-name_APIKey
```

Once we have this list, we will register them in the stage of the Usage Plan where the new APIs are located.

```bash
#Associate API keys from the current stage's to the new Usage Plan of the new API's
#first API key
aws apigateway create-usage-plan-key \
    --usage-plan-id rmvw2d \
    --key-id ead5ai82b2 \
    --key-type API_KEY

#Example Response
{
    "id": "ead5ai82b2",
    "type": "API_KEY",
    "value": "ksIdjY7Xgi4Dta5FKI3vG1MYuBSzvfxz1Ahft9n6",
    "name": "app-name_Core_APIKey"
}

#second API key
aws apigateway create-usage-plan-key \
    --usage-plan-id rmvw2d \
    --key-id j0mygqi19d \
    --key-type API_KEY

#Example Response
{
    "id": "pjmd316ql5",
    "type": "API_KEY",
    "value": "9e6f899e-0c8f-4a75-887d-f02599bd6426",
    "name": "app-name_APIKey"
}
```

In the case of Client, if we have **new scopes**, as it could be the case of <span style="color:blue">**API A v1.1.0**</span>.
Being a release, the API may have a new resource, and therefore, a new **scope**.
In this case we need to register this new scope in the OAuth server before this step, as explained in [Registering new scopes in the OAuth server](#scope).

**2. Removing API Keys from old Usage Plan**
![usage-3](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}

The next step is to remove the API Keys from the previous Usage Plan.

```bash
#Remove API keys from the old stage's of the old Usage Plan of the old API's
#first API key
aws apigateway delete-usage-plan-key \
    --usage-plan-id 5xcmw8 \
    --key-id ead5ai82b2

#Example Response
# delete-usage-plan-key command will not return any response if the delete is successful.


#second API key
aws apigateway delete-usage-plan-key \
    --usage-plan-id 5xcmw8 \
    --key-id j0mygqi19d \
    --key-type API_KEY

#Example Response
# delete-usage-plan-key command will not return any response if the delete is successful.
```

**3. Removing Stage from old Usage Plan**
![usage-4](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}  

We can now remove the old Stage.

```bash
#Remove old stage's of the old API's
aws apigateway delete-stage \
    --rest-api-id zfqr38kyng \
    --stage-name prod

#Example Response
# delete-stage command will not return any response if the delete is successful.
```

**4. Remove old Usage Plan**
![usage-5](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}  

We can now remove the old Usage Plan.

```bash
#Remove old Usage Plan
aws apigateway delete-usage-plan \
    --usage-plan-id 5xcmw8

#Example Response
# delete-usage-plan command will not return any response if the delete is successful.
```

**5. Optional Deactivating Old APIs**
![usage-6](../assets/images/aws-apigateway-suscription-migration-1-0-0.drawio){: .image-popup align="center" style="width:95%"}

In this optional step, the API cannot receive any more calls.
We can safety remove the API using the next command:

```bash
#Remove old API
aws apigateway delete-rest-api \
    --rest-api-id zfqr38kyng

#Example Response
# delete-rest-api command will not return any response if the delete is successful.
```

### Versioning

The design guide containing all possible versioning use cases is available [here](../../guides/apis/apiversioning.md).
