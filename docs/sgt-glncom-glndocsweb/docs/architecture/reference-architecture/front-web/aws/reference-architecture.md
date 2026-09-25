
# AWS Microfront Reference Architecture

!!! warning "Important"
    As a **Reference Architecture**, this documentation provides **general patterns and recommendations** that should be tailored and customized to meet the specific requirements of each use case.

!!! tip "Attention"
    This guide explains how to deploy a microfrontend application to AWS S3.
    For a more detailed solution of deploy, exposure and consume, refer to the following resources: [AWS CloudFront](./cloudfront/index.md), [AWS API Gateway](./api-gateway/index.md) and [S3 Bucket](./s3-bucket.md).

## Overview

Microfrontends architectures are a way to break down a large frontend application into smaller, more manageable pieces.
Each piece, or microfrontend, is developed and deployed independently, allowing teams to work on different parts of the application without interfering with each other.
This approach can improve development speed, scalability, and maintainability of frontend applications.

!!! note "Important"
    Imperva/Akamai acts as a Content Delivery Network (CDN) to cache and serve the static assets of the application. Also it provides security features like Web Application Firewall (WAF) and DDoS protection.

The following diagram shows deployment topology for microfrontend applications.

![Page-2](../../assets/diagrams/deployment-topology-mfe-aws.drawio)

???+ note
    You do not need to enable static website hosting on the bucket, as this is only for public website endpoints. Requests to the bucket will be going through a private REST API instead.

???+ note "Compliance with IFA Security Policies"
    This deployment topology follows the security policies of Santander Bank. Please refer to the following document for more information: [AWS-002-B-GWLB-Endpoints: Internet Facing Applications (IFAs)](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/AWS-002-B-GWLB-Endpoints-%26-IFAs.aspx?web=1#4-architectural-design-distributed-ifa-model)

???+ note "Same region for API and S3 bucket"
    The S3 bucket and the Api Gateway should be in the same region.

### Corporate Firewall (WAF)

**Corporate WAF**: Imperva or Akamai are used to protect the application from common web application security:

* Layer 7 Attack Protection: Defends against web application-specific threats, such as
SQL injection and XSS.
* Anti-DDoS Protection: Maintains availability of online services by blocking malicious
traffic during DDoS attacks.
* Threat Intelligence Protection: Identifies and blocks known attack sources, such as
malicious IP addresses and phishing URLs, botnets.

**AWS WAF and Firewall Manager**: AWS Firewall Manager is a security management service that allows you to centrally configure and manage firewall rules across your accounts and applications in AWS Organization (Pending approval).

Remember, security is a multi-layered approach and these strategies are part of a larger security plan.

### AWS Cloudfront CDN

The cloudfront Security policy is in progress [SP-010 - AWS S3 Cloudfront exposure](https://santandernet.sharepoint.com/:w:/r/sites/SantanderPlatforms/_layouts/15/Doc.aspx?sourcedoc=%7BAD4CE9D6-234B-4ACC-90F9-D9C9F2BE9B92%7D&file=SP-010%20-%20AWS%20S3%20Cloudfront%20exposure.docx&action=default&mobileredirect=true)
Once this policy is approved, the Cloudfront CDN will be used to cache and serve the static assets of Internet-facing applications.

In the case of Intranet applications, the Cloudfront CDN could be used by restricting access to the corporate network, but this pattern is not approved yet nor implemented.

## AWS Api Gateway REST API as an Amazon S3 proxy resource

An API Gateway REST API is made up of resources and methods. A resource is a logical entity that an app can access through a resource path. A method
corresponds to a REST API request that is submitted by the user of your API and the response returned to the user.

AWS reference docs: <br/>
    - [Use a proxy resource to streamline API setup](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-request.html#api-gateway-proxy-resource) <br/>
    - [Set up a proxy integration with a proxy resource](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html?icmpid=apigateway_console_help)

We will implement a REST API for a specific functional domain, providing resources and methods that will serve as a proxy for its microfrontend component.
The API Gateway will be utilized to route requests to the designated S3 bucket according to the URL path.

This will allow us in the future to have a microfront catalog of components and versions that can be served by each functional domain.
<!-- markdownlint-disable-next-line MD013 -->
??? example "Example of a REST API for a microfrontend component in S3"

```JSON
{
    "openapi" : "3.0.1",
    "info" : {
        "title" : "Brost30",
        "description" : "Your first API with Amazon API Gateway.",
        "version" : "2024-08-07T10:28:25Z"
    },
    "servers" : [ {
        "url" : "https://intra-cli-api.op-paas-cs-pos.aws.eu-west-1.sgtech.gs.corp/basePath",
        "variables" : {
        "basePath" : {
            "default" : "rost"
        }
        },
        "x-amazon-apigateway-endpoint-configuration" : {
        "disableExecuteApiEndpoint" : true,
        "vpcEndpointIds" : [ "vpce-01f422b2b8af44004" ]
        }
    } ],
    "paths" : {
        "/{paasproxy+}" : {
        "get" : {
            "parameters" : [ {
            "name" : "Content-Type",
            "in" : "header",
            "schema" : {
                "type" : "string"
            }
            }, {
            "name" : "paasproxy",
            "in" : "path",
            "required" : true,
            "schema" : {
                "type" : "string"
            }
            }, {
            "name" : "Content-Disposition",
            "in" : "header",
            "schema" : {
                "type" : "string"
            }
            } ],
            "responses" : {
            "400" : {
                "description" : "400 response",
                "content" : { }
            },
            "200" : {
                "description" : "200 response",
                "headers" : {
                "X-Frame-Options" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Cache-Control" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Access-Control-Allow-Origin" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "X-Content-Type-Options" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Content-Length" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Timestamp" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Content-Type" : {
                    "schema" : {
                    "type" : "string"
                    }
                }
                },
                "content" : {
                "application/json" : {
                    "schema" : {
                    "$ref" : "#/components/schemas/Empty"
                    }
                }
                }
            }
            },
            "x-amazon-apigateway-integration" : {
            "credentials" : "arn:aws:iam::533267329486:role/APIGatewayToS3ReadOnly",
            "httpMethod" : "GET",
            "uri" : "arn:aws:apigateway:eu-west-1:s3:path/glnpaasbucket/rost/{paasproxy}",
            "responses" : {
                "default" : {
                "statusCode" : "200",
                "responseParameters" : {
                    "method.response.header.Cache-Control" : "'max-age=31536000, immutable'",
                    "method.response.header.X-Frame-Options" : "'DENY'",
                    "method.response.header.Content-Type" : "integration.response.header.Content-Type",
                    "method.response.header.Content-Length" : "integration.response.header.Content-Length",
                    "method.response.header.X-Content-Type-Options" : "'nosniff'",
                    "method.response.header.Access-Control-Allow-Origin" : "'*'",
                    "method.response.header.Timestamp" : "integration.response.header.Date"
                }
                }
            },
            "requestParameters" : {
                "integration.request.header.Content-Disposition" : "method.request.header.Content-Disposition",
                "integration.request.path.paasproxy" : "method.request.path.paasproxy",
                "integration.request.header.Content-Type" : "method.request.header.Content-Type"
            },
            "requestTemplates" : {
                "application/json" : "
                    #set($proxy = $input.params('paasproxy'))
                    \r\n#set($path = $proxy)
                    \r\n
                    \r\n#if($path.equals('shell2101/0.0.0/en-US'))
                    \r\n  #set($path = \"${path}/index.html\")
                    \r\n  #set($debugInfo = \"$debugInfo Appended index.html: $path\\n\")
                    \r\n#end
                    \r\n
                    \r\n#set($context.requestOverride.path.paasproxy = $path)
                    \r\n{
                    \r\n  \"modifiedPath\": \"$path\",
                    \r\n  \"debugInfo\": \"$debugInfo\"
                    \r\n}"
            },
            "passthroughBehavior" : "when_no_templates",
            "cacheNamespace" : "n0mc5j",
            "cacheKeyParameters" : [ "method.request.path.paasproxy" ],
            "type" : "aws"
            }
        },
        "options" : {
            "parameters" : [ {
            "name" : "paasproxy",
            "in" : "path",
            "required" : true,
            "schema" : {
                "type" : "string"
            }
            } ],
            "responses" : {
            "200" : {
                "description" : "200 response",
                "headers" : {
                "Access-Control-Allow-Origin" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Access-Control-Allow-Methods" : {
                    "schema" : {
                    "type" : "string"
                    }
                },
                "Access-Control-Allow-Headers" : {
                    "schema" : {
                    "type" : "string"
                    }
                }
                },
                "content" : {
                "application/json" : {
                    "schema" : {
                    "$ref" : "#/components/schemas/Empty"
                    }
                }
                }
            }
            },
            "x-amazon-apigateway-integration" : {
            "responses" : {
                "default" : {
                "statusCode" : "200",
                "responseParameters" : {
                    "method.response.header.Access-Control-Allow-Methods" : "'GET,OPTIONS'",
                    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
                    "method.response.header.Access-Control-Allow-Origin" : "'*'"
                }
                }
            },
            "requestTemplates" : {
                "application/json" : "{\"statusCode\": 200}"
            },
            "passthroughBehavior" : "never",
            "cacheNamespace" : "bkwhvj",
            "cacheKeyParameters" : [ "method.request.path.paasproxy" ],
            "type" : "mock"
            }
        }
        }
    },
    "components" : {
        "schemas" : {
        "Empty" : {
            "type" : "object"
        }
        }
    },
    "x-amazon-apigateway-policy" : {
        "Version" : "2012-10-17",
        "Statement" : [ {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "execute-api:Invoke",
        "Resource" : "arn:aws:execute-api:eu-west-1:533267329486:b90e5uf1ye/*/*/*",
        "Condition" : {
            "StringEquals" : {
            "aws:sourceVpce" : "vpce-01f422b2b8af44004"
            }
        }
        } ]
    }
}
```

### Custom Domain Names

Custom domain names can be used to provide a more user-friendly URL for the API Gateway endpoint.

1. Create a Custom Domain Name in API Gateway.<br/>
2. Create an API Mapping to the Specific Stage of your api.<br/>
    It is possible to map the custom domain name to a specific stage of the APIs in the API Gateway. In this way, you can have different microfrontends components
    served by the same custom domain, each microfrontend component could map to a different stage (v1, v2, etc).
3. Choose a Base Path Mapping to the Specific Stage.<br/>
    At this point you could choose a functional base path for each of the microfronts components mapped to their stages (this functional base path is recommended for
    the application Shell component), this will allow you to have a more user-friendly URL. This configuration is independent of the S3 bucket path of the requested resource.

## Bucket Naming convention

It's a must that **all Buckets are created as private**. The bucket name should be unique across all AWS S3 buckets. Also, the bucket
name should be in lowercase and should not contain any special characters except for `-` and `.`. The bucket name should be between 3 and 63 characters
long.

As a best practice, the bucket name should be the same as the FQDN of the domain where the application will be served.

Internet FQDN naming pattern: `https://<environment>?-<functional-domain>.<company-fqdn>.<country>`

Intranet FQDN naming pattern: `https://<functional-domain>.<company-fqdn>-<environment>?.corp`

???+ note "Bucket naming flexibility"
    The bucket naming convention is flexible and can be adjusted to meet the specific needs of your organization. For example to migrate an existing
    application to AWS, the target bucket name can be configured in the API proxy resource on creation.

## Folder structure

The folder structure of the S3 bucket should be organized in a way that makes it easy to manage and deploy the microfrontend applications. The following folder structure is recommended:

:fontawesome-solid-folder-open: **acronym-application**<br>
---- :fontawesome-solid-folder-open: **short-name-component**<br>
-------- :fontawesome-solid-folder-open: **version**

## URL Domain names and Security headers configuration

### Naming convention

???+ note "URI mapping naming conventionx for IFAs"
    `https://<environment>?.<functional-domain>.<parent-domain>.<country>/<base-path>?/<acronym-application>/<short-name-component>/<component-version>/<language-code>?`

    - **environment**: The environment where the bucket is deployed (dev, pre, pro)
    - **functional-domain**: The functional domain of the application/component
    - **parent-domain**: The parent domain of the company
    - **country**: The country (TLD) where the bucket is deployed
    - **base-path**: (Optional) The base path of the custom domain name mapping.
    - **acronym-application**: The acronym of the application (Optional if base-path is used for the application's acronym name)
    - **short-name-component**: The short name of the component that belongs to the application
    - **component-version**: The version of the component
    - **language-code**: (Optional) The language code of the component

    example: **`https://dev.cards.santander.us/app1/shell/v1/en`**

For private FQDN the most common pattern is `https://<functional-domain>.<company-fqdn>-<environment>?.corp`

???+ info "User-friendly URLs"
    The URL naming convention is flexible and can be adjusted to meet the specific needs of your organization. In the case of Shell urls (the ones that are
    seen by the user in their browsers address bar) you can use a more user-friendly URL pattern and configure the api resource to change the path. Also it
    is possible to use a custom domain name base path mapping to provide a more user-friendly URL.

### Content Security Policy and Cross-Origin Resource Sharing

CORS (Cross-Origin Resource Sharing) could be handled at S3 bucket policies, API Gateway and corporate firewall levels, depending on your specific needs.

In the case you want to handle CORS dynamically, you can use the `Access-Control-Allow-Origin` header value based on the Origin request header in the
API Gateway response. The logic to set this response header can be implemented in the API Gateway Lambda function, but it will affect performance and adds
complexity to the deployment.

For no simple requests an OPTIONS preflight request is sent to the API Gateway, this method should be implemented in the API Gateway.

### Routing rules

Corporate firewall could be use for implementing route traffic logic, it depends on your specific use case. Also, the API Gateway could be used for routing traffic to different S3 buckets.

#### A/B Testing

Corporate firewall can be effectively used for A/B testing in a microfrontend architecture.

In this setup, S3 is used to host different versions of your microfrontend application. Each version is stored under a different folders (ex. v1) within the same bucket and component structure.

Routing can be based on various factors such as cookies, query strings, or headers, allowing you to split your user base for A/B testing.

The next section will provide more information on how to implement A/B testing in a microfrontend architecture.

## Resource Replication

Amazon S3 Cross-Region Replication (CRR) is an automatic, asynchronous mechanism that replicates newly uploaded objects
across two S3 buckets in different AWS regions. This feature enhances data availability and redundancy by ensuring that
your data is stored in geographically diverse locations.

CRR is useful for disaster recovery, as it allows you to quickly switch to serving data from a different region if your
primary region experiences an outage. It also improves latency by serving users from a region that's geographically closer to them.

Please note that usage of CRR incurs additional costs for data transfer and storage in the destination region.

## Caching

Akamia or Imperva CDN is used to cache and serve the static assets of the application. The CDN caches the assets at edge locations. In the case of Intranet exposure, the Api Gateway could be used to cache the responses.

## Continuous Deployment

In the context of microfrontends, continuous deployment refers to the process of automatically deploying changes to the corresponding
bucket of the component created or updated, this deployment process should be automated and triggered by a CI/CD pipeline.
The native cloud technology stack (aws CLI) must be favored for the deployment.

## Brownfield Migration

This architecture is flexible for Brownfield migration scenarios. The existing application can be migrated to AWS S3 but if for example we want to maintain
the existing URL structure or migrate server side logic, this must be implemented depending on the specific requirements of the application, it probably
will require a custom implementation.
