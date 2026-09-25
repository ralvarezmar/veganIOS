# AWS Elastic Load Balancer

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- **(only for authenticate-cognito listeners)** AWS Cognito components:
    - aws_cognito_user_pool
    - aws_cognito_user_pool_client
    - aws_cognito_user_pool_domain
- **(only for authenticate-oidc listeners)** OpenID Connect components:
    - authorization_endpoint
    - client_id
    - client_secret
    - issuer
    - token_endpoint
    - user_info_endpoint
- **(only to store LB logging)** AWS S3 bucket
- **(only for HTTPS or TLS listeners)** SSL Certificate imported into AWS Certificate Manager
- AWS VPC that includes the following components:
    - At least 2 Subnets in two different availability zones to attach to the Load Balancer.
    - **(only for Public Load Balancer)** VPC needs an internet gateway.
    - **(only for Application Load Balancer)** At least 1 security group attached to VPC where it will be deployed.

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_applb = {
  "01_default" = {
    name = "glnd1airarctn0gene001"

    tags = {
      product     = "Gluon AWS ELB"
      environment = "dev"
      project     = "Gluon"
    }

    internal                   = true
    enable_deletion_protection = false

    security_groups = ["sg-092caab4924ff50ec"]
    subnets         = ["subnet-0ff491af8c938973c", "subnet-009a52f7ca3ec38dc"]

    target_groups = {
      tg00 = {
        name     = "elbt00"
        vpc_id   = "vpc-0aed71ddbb5fdd57f"
        port     = 443
        protocol = "HTTPS"
      }
    }

    listeners = {
      l00 = {
        name = "elbt00"
        default_action = {
          forward = {
            target_group_key = "tg00"
          }
        }
        port            = 443
        protocol        = "HTTPS"
        certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/2e9fcc04-c0ac-40e5-b3a3-2ad17ba456bf"
      }
    }
  }

  "02_complete" = {
    name = "glnd1airarctn0gene002"

    tags = {
      product     = "Gluon AWS ELB"
      environment = "dev"
      project     = "Gluon"
    }

    internal = true

    security_groups = ["sg-092caab4924ff50ec"]
    subnets         = ["subnet-0ff491af8c938973c", "subnet-009a52f7ca3ec38dc", "subnet-03f29cd6b872f13bd"]

    lb_timeouts = {
      create = "10m"
      delete = "10m"
      update = "10m"
    }
    enable_deletion_protection = false

    ip_address_type            = "dualstack"
    idle_timeout               = 120
    drop_invalid_header_fields = false
    preserve_host_header       = true
    enable_http2               = true
    desync_mitigation_mode     = "strictest"

    access_logs = {
      enabled = true
      bucket  = "glnd1airas3envgene002"
      prefix  = "access_logs"
    }


    target_groups = {
      instance = {
        name     = "elbt01-instance"
        vpc_id   = "vpc-0aed71ddbb5fdd57f"
        port     = 80
        protocol = "HTTP"

        protocol_version                  = "HTTP1"
        target_type                       = "instance"
        deregistration_delay              = 10
        slow_start                        = 30
        load_balancing_algorithm_type     = "round_robin"
        load_balancing_cross_zone_enabled = true

        health_check = {
          matcher = "200"
          path    = "/status"

          enabled             = true
          protocol            = "HTTP"
          port                = "traffic-port"
          interval            = 15
          healthy_threshold   = 3
          unhealthy_threshold = 2
          timeout             = 10
        }

        stickiness = {
          enabled         = true
          cookie_duration = 3600
          type            = "lb_cookie"
        }

        targets = {
          t0 = {
            arn  = "i-04075c11bf20f4341"
            port = 80
          }
        }
      }

      ip = {
        name     = "elbt01-ip"
        vpc_id   = "vpc-0aed71ddbb5fdd57f"
        port     = 80
        protocol = "HTTP"

        protocol_version                  = "HTTP2"
        target_type                       = "ip"
        ip_address_type                   = "ipv6"
        deregistration_delay              = 15
        load_balancing_algorithm_type     = "least_outstanding_requests"
        load_balancing_cross_zone_enabled = false

        health_check = {
          matcher = "200,202"
          path    = "/health"

          enabled             = true
          protocol            = "HTTP"
          port                = "80"
          interval            = 30
          healthy_threshold   = 5
          unhealthy_threshold = 3
          timeout             = 5
        }

        stickiness = {
          enabled         = false
          type            = "app_cookie"
          cookie_duration = 10
          cookie_name     = "cookieexample"
        }

        targets = {
          t0 = {
            arn               = "2a05:d018:894:9400:5769:dfa2:a3b:8ae2"
            port              = 80
            availability_zone = "eu-west-1a"
          }
        }
      }

      lambda = {
        name = "elbt01-lambda"

        target_type                        = "lambda"
        lambda_multi_value_headers_enabled = true

        health_check = {
          matcher = "200-299"
          path    = "/"

          enabled             = true
          interval            = 60
          healthy_threshold   = 3
          unhealthy_threshold = 3
          timeout             = 25
        }

        targets = {
          t0 = {
            arn = "arn:aws:lambda:eu-west-1:<aws_account_id>:function:glnd1airlamelbenvgene000"
          }
        }
      }
    }


    listeners = {
      http_80 = {
        name     = "http-80"
        protocol = "HTTP"
        port     = 80

        default_action = {
          redirect = {
            path        = "/#{path}"
            host        = "#{host}"
            port        = "443"
            protocol    = "HTTPS"
            query       = "#{query}&redirect=true"
            status_code = "HTTP_301"
          }
        }

        tags = {
          extra_tag = "example"
        }
      }

      http_8080 = {
        name     = "http-8080"
        protocol = "HTTP"
        port     = 8080

        default_action = {
          forward = {
            forward_stickiness_duration = 20
            target_groups = [
              {
                target_group_key    = "instance"
                target_group_weight = 70
              },
              {
                target_group_key    = "lambda"
                target_group_weight = 30
              }
            ]
          }
        }
      }

      http_8081 = {
        name     = "http-8081"
        protocol = "HTTP"
        port     = 8081

        default_action = {
          fixed-response = {
            content_type = "text/plain"
            message_body = "not found"
            status_code  = "404"
          }
        }
      }

      https_443 = {
        name            = "https-443"
        protocol        = "HTTPS"
        port            = 443
        certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/2e9fcc04-c0ac-40e5-b3a3-2ad17ba456bf"
        ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

        default_action = {
          authenticate-cognito = {
            user_pool_arn       = "arn:aws:cognito-idp:eu-west-1:<aws_account_id>:userpool/eu-west-1_b09IsIkyF"
            user_pool_client_id = "7c27a1nfh9a83hkj5n5kra3i92"
            user_pool_domain    = "glnd1aircogelbenvgene000"

            authentication_request_extra_params = {}
            on_unauthenticated_request          = "allow"
            scope                               = "openid"
            session_cookie_name                 = "AWSELBAuthSessionCookie"
            session_timeout                     = 604800

            order = 1
          }

          forward = {
            target_group_key = "lambda"
            order            = 2
          }
        }
      }

      https_4443 = {
        name            = "https-4443"
        protocol        = "HTTPS"
        port            = 4443
        certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/2e9fcc04-c0ac-40e5-b3a3-2ad17ba456bf"
        ssl_policy      = "ELBSecurityPolicy-FS-1-2-2019-08"

        default_action = {
          authenticate-oidc = {
            authorization_endpoint = "https://example.com/authorization_endpoint"
            client_id              = "client_id"
            client_secret          = "client_secret"
            issuer                 = "https://example.com"
            token_endpoint         = "https://example.com/token_endpoint"
            user_info_endpoint     = "https://example.com/user_info_endpoint"

            authentication_request_extra_params = {}
            on_unauthenticated_request          = "authenticate"
            scope                               = "example"
            session_cookie_name                 = "examplecookie"
            session_timeout                     = 3600

            order = 1
          }

          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            path        = "/#{path}"
            host        = "#{host}"
            query       = "#{query}"

            order = 2
          }
        }
      }
    }

    extra_ssl_certs = {
      cert001 = {
        https_listener_index = "https_443"
        certificate_arn      = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/2e9fcc04-c0ac-40e5-b3a3-2ad17ba456bf"
      }
    }

    rules = {
      https_443_fixed_200 = {
        listener_key = "https_443"
        priority     = 1

        actions = {
          fixed-response = {
            status_code  = 200
            content_type = "application/json"
            message_body = "{\"msg\":\"hello\"}"
          }
        }

        conditions = {
          http_request_method = {
            values = ["GET", "HEAD"]
          }
          path_pattern = {
            values = ["/hello-svc"]
          }
        }

        tags = {
          extra_tag = "example"
        }
      }

      https_443_forward = {
        listener_key = "https_443"
        priority     = 2

        actions = {
          forward = {
            target_group_key = "lambda"
          }
        }

        conditions = {
          host_header = {
            values = ["fixedresp.com"]
          }
        }
      }

      http_80_redirect = {
        listener_key = "http_80"

        actions = {
          redirect = {
            path        = "/#{path}"
            host        = "#{host}"
            port        = "4443"
            protocol    = "HTTPS"
            query       = "#{query}"
            status_code = "HTTP_301"
          }
        }

        conditions = {
          http_header = {
            h1 = {
              http_header_name = "Content-Type"
              values           = ["application/json", "text/plain"]
            }
            # Max 1 http_header due to a bug in provider: https://github.com/hashicorp/terraform-provider-aws/issues/28040
            # h2 = {
            #   http_header_name = "X-Forwarded-For"
            #   values           = ["192.168.1.*"]
            # }
          }
        }
      }

      https_443_cognito_alt = {
        listener_key = "https_443"
        priority     = 3

        actions = {
          authenticate-cognito = {
            user_pool_arn       = "arn:aws:cognito-idp:eu-west-1:<aws_account_id>:userpool/eu-west-1_b09IsIkyF"
            user_pool_client_id = "7c27a1nfh9a83hkj5n5kra3i92"
            user_pool_domain    = "glnd1aircogelbenvgene000"

            authentication_request_extra_params = {}
            on_unauthenticated_request          = "deny"
            scope                               = "openid"
            session_cookie_name                 = "AWSELBAuthSessionCookie"
            session_timeout                     = 604800

            order = 1
          }

          forward = {
            target_group_key = "ip"
            order            = 2
          }
        }

        conditions = {
          query_string = {
            q1 = {
              value = "plus"
            }
            q2 = {
              key   = "product_categ"
              value = "deposit"
            }
          }
        }
      }

      https_4443_oidc_alt = {
        listener_key = "https_4443"

        actions = {
          authenticate-oidc = {
            authorization_endpoint = "https://example.org/authorization_endpoint"
            client_id              = "client_id"
            client_secret          = "client_secret"
            issuer                 = "https://example.org"
            token_endpoint         = "https://example.org/token_endpoint"
            user_info_endpoint     = "https://example.org/user_info_endpoint"

            authentication_request_extra_params = {}
            on_unauthenticated_request          = "authenticate"
            scope                               = "example"
            session_cookie_name                 = "examplecookie"
            session_timeout                     = 3600

            order = 1
          }

          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            path        = "/#{path}"
            host        = "#{host}"
            query       = "#{query}"

            order = 2
          }
        }

        conditions = {
          source_ip = {
            values = ["10.0.0.0/16", "100.64.0.0/16", "170.35.0.0/16"]
          }
        }
      }
    }

    autoscaling_groups = {
      glnd1airasgelbenvgene000 = {
        target_group_key = "instance"
      }
    }
  }
}

```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| account_id | Default AWS account ID. | <pre>string</pre> |
| name | The name defined by the user for the resource. | <pre>string</pre> |
| region | Default AWS region. | <pre>string</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| [access_logs](#input_access_logs) | Map containing access logging configuration for load balancer. | <pre>any</pre> | {} |
| [autoscaling_groups](#input_autoscaling_groups) | A map of objects describing the Autoscaling Groups to attach to the target groups of the ELB. The key defines the name of the existing Autoscaling Group. | <pre>any</pre> | {} |
| desync_mitigation_mode | Determines how the ALB handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest. | <pre>string</pre> | null |
| drop_invalid_header_fields | Indicates whether invalid header fields are dropped in in ALB. Not supported by NLBs. | <pre>bool</pre> | null |
| enable_cross_zone_load_balancing | Indicates whether cross zone load balancing should be enabled in NLB. Not supported by ALBs. | <pre>bool</pre> | null |
| enable_deletion_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to true. | <pre>bool</pre> | true |
| enable_http2 | Indicates whether HTTP/2 is enabled in ALB. Not supported by NLBs. | <pre>bool</pre> | null |
| [extra_ssl_certs](#input_extra_ssl_certs) | A map of objects describing any extra SSL certificates to apply to the HTTPS listeners. | <pre>map(object({<br>    https_listener_index = string<br>    certificate_arn      = string<br>  }))</pre> | {} |
| idle_timeout | The time in seconds that the connection is allowed to be idle. Supported values are between 1 and 4000. | <pre>number</pre> | null |
| internal | Boolean determining if the load balancer is internal or externally facing. | <pre>bool</pre> | true |
| ip_address_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | <pre>string</pre> | "ipv4" |
| lb_timeouts | A map of timeout values when creating, deleting and updating the ALB. | <pre>map(string)</pre> | {} |
| [listeners](#input_listeners) | A map of objects describing the HTTP listeners or TCP ports for this ALB. | <pre>any</pre> | {} |
| load_balancer_type | The type of load balancer to create. Possible values are application or network. | <pre>string</pre> | "application" |
| preserve_host_header | Indicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to false. | <pre>bool</pre> | null |
| [rules](#input_rules) | A map of objects describing the rules by listener. | <pre>any</pre> | {} |
| security_groups | The security groups to attach to the load balancer. e.g. ["sg-edcd9784","sg-edcd9785"]. | <pre>list(string)</pre> | [] |
| [subnet_mapping](#input_subnet_mapping) | A list of subnet mapping objects describing subnets to attach to network load balancer. | <pre>any</pre> | [] |
| subnets | A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']. | <pre>list(string)</pre> | null |
| tags | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>any</pre> | {} |
| [target_groups](#input_target_groups) | A map of objects that represent the Target Groups. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| bucket | (Optional) The S3 bucket name to store the logs in. | <pre>string</pre> |
| enabled | (Optional) Boolean to enable / disable access\_logs. Defaults to false, unless bucket is specified. | <pre>bool</pre> |
| prefix | (Optional) The S3 bucket prefix name (or directory) where logs will be stored. An empty string (or null) implies logs will be stored in bucket root. | <pre>string</pre> |

### <a name="input_autoscaling_groups"></a> [autoscaling\_groups](#input\_autoscaling\_groups)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| target_group_key | (Required) The key of the target group defined in the target group variable map that defines the ARN of a load balancer target group to associate. | <pre>string</pre> |

### <a name="input_extra_ssl_certs"></a> [extra\_ssl\_certs](#input\_extra\_ssl\_certs)

```hcl
map(object({
    https_listener_index = string
    certificate_arn      = string
  }))
```

| Name | Description | Type |
|------|-------------|------|
| certificate_arn | (Required) The ARN of the certificate to attach to the listener. | <pre>string</pre> |
| https_listener_index | (Required) The index (or key in var.listeners) of the listener to which to attach the certificate. | <pre>string</pre> |

### <a name="input_listeners"></a> [listeners](#input\_listeners)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| alpn_policy | (Optional) Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if protocol is TLS. Valid values are HTTP1Only, HTTP2Only, HTTP2Optional, HTTP2Preferred, and None. | <pre>string</pre> |
| certificate_arn | (Optional) ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. For adding additional SSL certificates, see the aws\_lb\_listener\_certificate resource. | <pre>string</pre> |
| default_action | (Required) Object describing default action. | <pre>object</pre> |
| default_action<br/>.authenticate-cognito | (Optional) Object describing authenticate-cognito default action. | <pre>object</pre> |
| default_action<br/>.authenticate-cognito<br/>.authentication_request_extra_params | (Optional) Query parameters to include in the redirect request to the authorization endpoint. Max: 10. | <pre>map(string)</pre> |
| default_action<br/>.authenticate-cognito<br/>.authorization_endpoint | (Required) Authorization endpoint of the IdP. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.client_id | (Required) OAuth 2.0 client identifier. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.client_secret | (Required) OAuth 2.0 client secret. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.issuer | (Required) OIDC issuer identifier of the IdP. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.on_unauthenticated_request | (Optional) Behavior if the user is not authenticated. Valid values: deny, allow and authenticate. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| default_action<br/>.authenticate-cognito<br/>.scope | (Optional) Set of user claims to be requested from the IdP. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.scope(string) | (Optional) Set of user claims to be requested from the IdP. | <pre>-</pre> |
| default_action<br/>.authenticate-cognito<br/>.session_cookie_name | (Optional) Name of the cookie used to maintain session information. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.session_timeout | (Optional) Maximum duration of the authentication session, in seconds. | <pre>number</pre> |
| default_action<br/>.authenticate-cognito<br/>.token_endpoint | (Required) Token endpoint of the IdP. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.user_info_endpoint | (Required) User info endpoint of the IdP. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.user_pool_arn | (Required) ARN of the Cognito user pool. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.user_pool_client_id | (Required) ID of the Cognito user pool client. | <pre>string</pre> |
| default_action<br/>.authenticate-cognito<br/>.user_pool_domain | (Required) Domain prefix or fully-qualified domain name of the Cognito user pool. | <pre>string</pre> |
| default_action<br/>.authenticate-oidc | (Optional) Object describing authenticate-oidc default action. | <pre>object</pre> |
| default_action<br/>.fixed-response | (Optional) Object describing fixed-response default action. | <pre>object</pre> |
| default_action<br/>.fixed-response<br/>.content_type | (Required) Content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json. | <pre>string</pre> |
| default_action<br/>.fixed-response<br/>.message_body | (Optional) Message body. | <pre>string</pre> |
| default_action<br/>.fixed-response<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| default_action<br/>.fixed-response<br/>.status_code | (Optional) HTTP response code. Valid values are 2XX, 4XX, or 5XX. | <pre>string</pre> |
| default_action<br/>.forward | (Optional) Object describing forward default action. | <pre>object</pre> |
| default_action<br/>.forward<br/>.forward_stickiness_duration | (Optional) Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days). Not valid for NLBs. | <pre>number</pre> |
| default_action<br/>.forward<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| default_action<br/>.forward<br/>.target_group_key | (Optional) Key of the Target Group to which to route traffic. Specify only if type is forward and you want to route to a single target group. To route multiple target groups, use a the target\_groups block instead. Must be a valid key in var.target\_groups variable. | <pre>string</pre> |
| default_action<br/>.forward<br/>.target_groups | (Optional) List of objects describing target groups. Not valid for NLBs. | <pre>list(object)</pre> |
| default_action<br/>.forward<br/>.target_groups<br/>.target_group_key | (Required) Key of the target group to which to route traffic. Must be a valid key in var.target\_groups variable. | <pre>string</pre> |
| default_action<br/>.forward<br/>.target_groups<br/>.target_group_weight | (Optional) Weight. The range is 0 to 999. | <pre>number</pre> |
| default_action<br/>.redirect | (Optional) Object describing redirect default action. | <pre>object</pre> |
| default_action<br/>.redirect<br/>.host | (Optional) Hostname. This component is not percent-encoded. The hostname can contain #{host}. Defaults to #{host}. | <pre>string</pre> |
| default_action<br/>.redirect<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| default_action<br/>.redirect<br/>.path | (Optional) Absolute path, starting with the leading "/". This component is not percent-encoded. The path can contain #{host}, #{path}, and #{port}. Defaults to /#{path}. | <pre>string</pre> |
| default_action<br/>.redirect<br/>.port | (Optional) Port. Specify a value from 1 to 65535 or #{port}. Defaults to #{port}. | <pre>string</pre> |
| default_action<br/>.redirect<br/>.protocol | (Optional) Protocol. Valid values are HTTP, HTTPS, or #{protocol}. Defaults to #{protocol}. | <pre>string</pre> |
| default_action<br/>.redirect<br/>.query | (Optional) Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading "?". Defaults to #{query}. | <pre>string</pre> |
| default_action<br/>.redirect<br/>.status_code | (Required) HTTP redirect code. The redirect is either permanent (HTTP\_301) or temporary (HTTP\_302). | <pre>string</pre> |
| name | (Required) Name of the listener. It must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens. | <pre>string</pre> |
| port | (Required) Port on which the load balancer is listening. Not valid for Gateway Load Balancers. | <pre>number</pre> |
| protocol | (Required) Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. For Network Load Balancers, valid values are TCP, TLS, UDP, and TCP\_UDP. Not valid to use UDP or TCP\_UDP if dual-stack mode is enabled. | <pre>string</pre> |
| ssl_policy | (Optional)  Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>map(string)</pre> |

### <a name="input_rules"></a> [rules](#input\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| actions | (Required) Object describing actions. | <pre>object</pre> |
| actions<br/>.authenticate-cognito | (Optional) Object describing authenticate-cognito default action. | <pre>object</pre> |
| actions<br/>.authenticate-cognito<br/>.authentication_request_extra_params | (Optional) Query parameters to include in the redirect request to the authorization endpoint. Max: 10. | <pre>map(string)</pre> |
| actions<br/>.authenticate-cognito<br/>.authorization_endpoint | (Required) Authorization endpoint of the IdP. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.client_id | (Required) OAuth 2.0 client identifier. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.client_secret | (Required) OAuth 2.0 client secret. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.issuer | (Required) OIDC issuer identifier of the IdP. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.on_unauthenticated_request | (Optional) Behavior if the user is not authenticated. Valid values: deny, allow and authenticate. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| actions<br/>.authenticate-cognito<br/>.scope | (Optional) Set of user claims to be requested from the IdP. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.scope(string) | (Optional) Set of user claims to be requested from the IdP. | <pre>-</pre> |
| actions<br/>.authenticate-cognito<br/>.session_cookie_name | (Optional) Name of the cookie used to maintain session information. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.session_timeout | (Optional) Maximum duration of the authentication session, in seconds. | <pre>number</pre> |
| actions<br/>.authenticate-cognito<br/>.token_endpoint | (Required) Token endpoint of the IdP. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.user_info_endpoint | (Required) User info endpoint of the IdP. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.user_pool_arn | (Required) ARN of the Cognito user pool. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.user_pool_client_id | (Required) ID of the Cognito user pool client. | <pre>string</pre> |
| actions<br/>.authenticate-cognito<br/>.user_pool_domain | (Required) Domain prefix or fully-qualified domain name of the Cognito user pool. | <pre>string</pre> |
| actions<br/>.authenticate-oidc | (Optional) Object describing authenticate-oidc default action. | <pre>object</pre> |
| actions<br/>.fixed-response | (Optional) Object describing fixed-response default action. | <pre>object</pre> |
| actions<br/>.fixed-response<br/>.content_type | (Required) Content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json. | <pre>string</pre> |
| actions<br/>.fixed-response<br/>.message_body | (Optional) Message body. | <pre>string</pre> |
| actions<br/>.fixed-response<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| actions<br/>.fixed-response<br/>.status_code | (Optional) HTTP response code. Valid values are 2XX, 4XX, or 5XX. | <pre>string</pre> |
| actions<br/>.forward | (Optional) Object describing forward default action. | <pre>object</pre> |
| actions<br/>.forward<br/>.forward_stickiness_duration | (Optional) Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days). Not valid for NLBs. | <pre>number</pre> |
| actions<br/>.forward<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| actions<br/>.forward<br/>.target_group_key | (Optional) Key of the Target Group to which to route traffic. Specify only if type is forward and you want to route to a single target group. To route multiple target groups, use a the target\_groups block instead. Must be a valid key in var.target\_groups variable. | <pre>string</pre> |
| actions<br/>.forward<br/>.target_groups | (Optional) List of objects describing target groups. Not valid for NLBs. | <pre>list(object)</pre> |
| actions<br/>.forward<br/>.target_groups<br/>.target_group_key | (Required) Key of the target group to which to route traffic. Must be a valid key in var.target\_groups variable. | <pre>string</pre> |
| actions<br/>.forward<br/>.target_groups<br/>.target_group_weight | (Optional) Weight. The range is 0 to 999. | <pre>number</pre> |
| actions<br/>.redirect | (Optional) Object describing redirect default action. | <pre>object</pre> |
| actions<br/>.redirect<br/>.host | (Optional) Hostname. This component is not percent-encoded. The hostname can contain #{host}. Defaults to #{host}. | <pre>string</pre> |
| actions<br/>.redirect<br/>.order | (Optional) Order for the action **Only for listeners**. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. | <pre>number</pre> |
| actions<br/>.redirect<br/>.path | (Optional) Absolute path, starting with the leading "/". This component is not percent-encoded. The path can contain #{host}, #{path}, and #{port}. Defaults to /#{path}. | <pre>string</pre> |
| actions<br/>.redirect<br/>.port | (Optional) Port. Specify a value from 1 to 65535 or #{port}. Defaults to #{port}. | <pre>string</pre> |
| actions<br/>.redirect<br/>.protocol | (Optional) Protocol. Valid values are HTTP, HTTPS, or #{protocol}. Defaults to #{protocol}. | <pre>string</pre> |
| actions<br/>.redirect<br/>.query | (Optional) Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading "?". Defaults to #{query}. | <pre>string</pre> |
| actions<br/>.redirect<br/>.status_code | (Required) HTTP redirect code. The redirect is either permanent (HTTP\_301) or temporary (HTTP\_302). | <pre>string</pre> |
| conditions | (Required) Object describing conditions. | <pre>object</pre> |
| conditions<br/>.host_header | (Optional) Object describing host\_header condition. | <pre>object</pre> |
| conditions<br/>.host_header<br/>.values | (Required) A list of host header patterns to match. The maximum size of each pattern is 128 characters. Comparison is case insensitive. Wildcard characters supported: * (matches 0 or more characters) and ? (matches exactly 1 character). Only one pattern needs to match for the condition to be satisfied. | <pre>list(string)</pre> |
| conditions<br/>.http_header | (Optional) Map of objects describing http\_header condition. | <pre>map(object)</pre> |
| conditions<br/>.http_header<br/>.http_header_name | (Required) Name of HTTP header to search. The maximum size is 40 characters. Comparison is case insensitive. Only RFC7240 characters are supported. Wildcards are not supported. You cannot use HTTP header condition to specify the host header, use a host-header condition instead. | <pre>string</pre> |
| conditions<br/>.http_header<br/>.values | (Required) Query string key pattern to match. List of header value patterns to match. Maximum size of each pattern is 128 characters. Comparison is case insensitive. Wildcard characters supported: * (matches 0 or more characters) and ? (matches exactly 1 character). If the same header appears multiple times in the request they will be searched in order until a match is found. Only one pattern needs to match for the condition to be satisfied. To require that all of the strings are a match, create one condition block per string. | <pre>list(string)</pre> |
| conditions<br/>.http_request_method | (Optional) Object describing http\_request\_method condition. | <pre>object</pre> |
| conditions<br/>.http_request_method<br/>.values | (Required) A list of HTTP request methods or verbs to match. Maximum size is 40 characters. Only allowed characters are A-Z, hyphen (-) and underscore (\_). Comparison is case sensitive. Wildcards are not supported. Only one needs to match for the condition to be satisfied. AWS recommends that GET and HEAD requests are routed in the same way because the response to a HEAD request may be cached. | <pre>list(string)</pre> |
| conditions<br/>.path_pattern | (Optional) Object describing path\_pattern condition. | <pre>object</pre> |
| conditions<br/>.path_pattern<br/>.values | (Required) A list of path patterns to match against the request URL. Maximum size of each pattern is 128 characters. Comparison is case sensitive. Wildcard characters supported: * (matches 0 or more characters) and ? (matches exactly 1 character). Only one pattern needs to match for the condition to be satisfied. Path pattern is compared only to the path of the URL, not to its query string. To compare against the query string, use a query\_string condition. | <pre>list(string)</pre> |
| conditions<br/>.query_string | (Optional) Map of objects describing query\_string condition. | <pre>map(object)</pre> |
| conditions<br/>.query_string<br/>.key | (Optional) Query string key pattern to match. | <pre>string</pre> |
| conditions<br/>.query_string<br/>.value | (Required) Query string value pattern to match. Maximum size of each string is 128 characters. Comparison is case insensitive. Wildcard characters supported: *(matches 0 or more characters) and ? (matches exactly 1 character). To search for a literal '*' or '?' character in a query string, escape the character with a backslash (\). Only one pair needs to match for the condition to be satisfied. | <pre>string</pre> |
| conditions<br/>.source_ip | (Optional) Object describing source\_ip condition. | <pre>object</pre> |
| conditions<br/>.source_ip<br/>.values | (Required) A list of source IP CIDR notations to match. You can use both IPv4 and IPv6 addresses. Wildcards are not supported. Condition is satisfied if the source IP address of the request matches one of the CIDR blocks. Condition is not satisfied by the addresses in the X-Forwarded-For header, use http\_header condition instead. | <pre>list(string)</pre> |
| listener_key | (Required) Key of the listener to attach the rule. Must be a valid key in var.listeners. | <pre>string</pre> |
| priority | (Optional) Key of the listener to attach the rule. Must be a valid key in var.listeners. | <pre>number</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>map(string)</pre> |

### <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| allocation_id | (Optional) The allocation ID of the Elastic IP address. | <pre>string</pre> |
| private_ipv4_address | (Optional) A private ipv4 address within the subnet to assign to the internal-facing load balancer. | <pre>string</pre> |
| subnet_id | (Required) The id of the subnet of which to attach to the load balancer. You can specify only one subnet per Availability Zone. | <pre>string</pre> |

### <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| connection_termination | (Optional) Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers. See doc for more information. See [doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#target-group-attributes) for more information. For new UDP/TCP\_UDP target groups the default is true. Otherwise, the default is false. | <pre>bool</pre> |
| deregistration_delay | (Optional) Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds. Not applicable when target\_type is lambda. | <pre>number</pre> |
| health_check | (Optional) Object describing healthcheck configuration. | <pre>object</pre> |
| health_check<br/>.enabled | (Optional) Whether health checks are enabled. Defaults to true. | <pre>bool</pre> |
| health_check<br/>.healthy_threshold | (Optional) Number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3. | <pre>number</pre> |
| health_check<br/>.interval | (Optional) Approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda. Default 30 seconds. | <pre>number</pre> |
| health_check<br/>.matcher | (Optional) (May be required) Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, "200,202" for HTTP(s) or "0,12" for GRPC) or a range of values (for example, "200-299" or "0-99"). Required for HTTP/HTTPS/GRPC ALB. Only applies to Application Load Balancers (i.e., HTTP/HTTPS/GRPC) not for Network Load Balancers (i.e., TCP). | <pre>string</pre> |
| health_check<br/>.path | (Optional) (May be required) Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS. | <pre>string</pre> |
| health_check<br/>.port | (Optional) Port to use to connect with the target. Valid values are either ports 1-65535, or traffic-port. Defaults to traffic-port. Not applicable when target\_type is lambda. | <pre>string</pre> |
| health_check<br/>.protocol | (Optional) Protocol to use to connect with the target. Defaults to HTTP. Not applicable when target\_type is lambda. | <pre>string</pre> |
| health_check<br/>.timeout | (Optional) Amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks. | <pre>number</pre> |
| health_check<br/>.unhealthy_threshold | (Optional) Number of consecutive health check failures required before considering the target unhealthy. Defaults to 3. | <pre>number</pre> |
| ip_address_type | (Optional, forces new resource) The type of IP addresses used by the target group, only supported when target type is set to ip. Possible values are ipv4 or ipv6. | <pre>string</pre> |
| lambda_multi_value_headers_enabled | (Optional) Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target\_type is lambda. Default is false. | <pre>bool</pre> |
| load_balancing_algorithm_type | (Optional) Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. Not applicable when target\_type is lambda. The value is round\_robin or least\_outstanding\_requests. The default is round\_robin. | <pre>string</pre> |
| load_balancing_cross_zone_enabled | (Optional) Indicates whether cross zone load balancing is enabled. The value is "true", "false" or "use\_load\_balancer\_configuration". The default is "use\_load\_balancer\_configuration". | <pre>bool</pre> |
| name | (Optional) Name of the target group. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. Either `name` or `name_prefix` must be set. | <pre>string</pre> |
| name_prefix | (Optional) Creates a unique name beginning with the specified prefix. Either `name` or `name_prefix` must be set. | <pre>string</pre> |
| port | (Optional) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target\_type is instance or ip. Does not apply when target\_type is lambda. | <pre>number</pre> |
| preserve_client_ip | (Optional) Whether client IP preservation is enabled. See doc for more information. | <pre>bool</pre> |
| protocol | (Optional) Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP\_UDP, TLS, or UDP. Required when target\_type is instance or ip. Does not apply when target\_type is lambda. | <pre>string</pre> |
| protocol_version | (Optional, Forces new resource) Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1. | <pre>string</pre> |
| proxy_protocol_v2 | (Optional) Whether to enable support for proxy protocol v2 on Network Load Balancers. See doc for more information. Default is false. | <pre>bool</pre> |
| slow_start | (Optional) Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds. Not applicable when target\_type is lambda. | <pre>number</pre> |
| stickiness | (Optional) Object describing stickiness configuration. | <pre>object</pre> |
| stickiness<br/>.cookie_duration | (Optional) Only used when the type is lb\_cookie. The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds). | <pre>number</pre> |
| stickiness<br/>.cookie_name | (Optional) Name of the application based cookie. AWSALB, AWSALBAPP, and AWSALBTG prefixes are reserved and cannot be used. Only needed when type is app\_cookie. | <pre>string</pre> |
| stickiness<br/>.enabled | (Optional) Boolean to enable / disable stickiness. Default is true. | <pre>bool</pre> |
| stickiness<br/>.type | (Optional) The type of sticky sessions. The only current possible values are lb\_cookie, app\_cookie for ALBs, and source\_ip for NLBs. | <pre>string</pre> |
| target_type | (Optional) Type of target that you must specify when registering targets with this target group. Valid Values: instance ip lambda alb. The default is instance. | <pre>string</pre> |
| targets | (Optional) Object describing targets configuration. | <pre>object</pre> |
| targets<br/>.arn | (Required) The ARN of resource to be attached to Target Group. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address. If the target type is lambda, specify the arn of lambda. If the target type is alb, specify the arn of alb. | <pre>string</pre> |
| targets<br/>.availability_zone | (Optional) The Availability Zone where the IP address of the target is to be registered. If the private ip address is outside of the VPC scope, this value must be set to 'all'. Defaults to null. | <pre>string</pre> |
| targets<br/>.port | (Optional) The port on which targets receive traffic. Defaults to null. | <pre>string</pre> |
| vpc_id | (Optional) Identifier of the VPC in which to create the target group. Required when target\_type is instance or ip. Does not apply when target\_type is lambda. | <pre>string</pre> |

## Output example

```hcl
aws_applb = {
  "01_default" = {
    "aws_alb_listener_arns" = {
      "listener_example01" = "arn:aws:elasticloadbalancing:eu-west-1:<aws_account_id>:listener/app/glnd1airelbtest11gene001/7586b98bac4011d9/a3a1553bfaa73346"
    }
    "aws_alb_listener_rule_arns" = {}
    "aws_alb_listener_rule_tags" = {}
    "aws_alb_listener_tags" = {
      "listener_example01" = {
        "Name" = "listener_example01"
        "product"     = "Gluon AWS ELB"
        "environment" = "dev"
        "project"     = "Gluon"
      }
    }
    "aws_lb_access_logs" = []
    "aws_lb_arn" = "arn:aws:elasticloadbalancing:eu-west-1:<aws_account_id>:loadbalancer/app/glnd1airelbtest11gene001/7586b98bac4011d9"
    "aws_lb_arn_suffix" = "app/glnd1airelbtest11gene001/7586b98bac4011d9"
    "aws_lb_dns_name" = "internal-glnd1airelbtest11gene001-29889893.eu-west-1.elb.amazonaws.com"
    "aws_lb_name" = "glnd1airelbtest11gene001"
    "aws_lb_security_groups" = [
      "sg-03634e86daa8561c6",
    ]
    "aws_lb_subnet_mapping" = [
      {
        "allocation_id" = ""
        "ipv6_address" = ""
        "outpost_id" = ""
        "private_ipv4_address" = ""
        "subnet_id" = "subnet-01b33ea0ca2c3456d"
      },
      {
        "allocation_id" = ""
        "ipv6_address" = ""
        "outpost_id" = ""
        "private_ipv4_address" = ""
        "subnet_id" = "subnet-07f039b64384ea3b3"
      },
    ]
    "aws_lb_subnets" = [
      "subnet-01b33ea0ca2c3456d",
      "subnet-07f039b64384ea3b3",
    ]
    "aws_lb_tags" = {
      "Name" = "glnd1airelbtest11gene001"
      "product"     = "Gluon AWS ELB"
      "environment" = "dev"
      "project"     = "Gluon"
    }
    "aws_lb_vpc_id" = "vpc-00166353476258712"
    "aws_lb_zone_id" = "Z32O12XQLNTSW2"
    "target_group_arn_suffixes" = {
      "tg_example01" = "targetgroup/gln-iac-terraform-aws-elb-module/87284caca178fab7"
    }
    "target_group_arns" = {
      "tg_example01" = "arn:aws:elasticloadbalancing:eu-west-1:<aws_account_id>:targetgroup/gln-iac-terraform-aws-elb-module/87284caca178fab7"
    }
    "target_group_names" = {
      "tg_example01" = "gln-iac-terraform-aws-elb-module"
    }
    "target_group_tags" = {
      "tg_example01" = {
        "Name"        = "gln-iac-terraform-aws-elb-module"
        "product"     = "Gluon AWS ELB"
        "environment" = "dev"
        "project"     = "Gluon"
      }
    }
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_applb|module.aws_applb|AWS Application Load Balancer outputs map. <br>[Map AWS Application Load Balancer Outputs](#AWS Application-Load-Balancer Outputs). |

<a name="outputs-section"></a>

<a name="AWS Application-Load-Balancer Outputs"></a>

### AWS Application Load Balancer Outputs

| Name | Description | Type |
|------|-------------|------|
| aws_alb_listener_arns | The ARN of the TCP and HTTP load Balancer listeners created. | <pre>module.aws_applb.aws_alb_listener_arns</pre> |
| aws_alb_listener_rule_arns | The ARNs of the Load Balancer listener rules created. | <pre>module.aws_applb.aws_alb_listener_rule_arns</pre> |
| aws_alb_listener_rule_tags | Tags of the Load Balancer listener rules created. | <pre>module.aws_applb.aws_alb_listener_rule_tags</pre> |
| aws_alb_listener_tags | Tags of the TCP and HTTP load Balancer listeners created. | <pre>module.aws_applb.aws_alb_listener_tags</pre> |
| aws_autoscaling_attachment | Tags of the Load Balancer listener rules created. | <pre>module.aws_applb.aws_autoscaling_attachment</pre> |
| aws_lb_access_logs | The S3 bucket where resides Load Balancer logs. | <pre>module.aws_applb.aws_lb_access_logs</pre> |
| aws_lb_arn | The ID and ARN of the load Balancer we created. | <pre>module.aws_applb.aws_lb_arn</pre> |
| aws_lb_arn_suffix | ARN suffix of our load Balancer - can be used with CloudWatch. | <pre>module.aws_applb.aws_lb_arn_suffix</pre> |
| aws_lb_dns_name | The DNS name of the load Balancer. | <pre>module.aws_applb.aws_lb_dns_name</pre> |
| aws_lb_name | Load Balancer Name. | <pre>module.aws_applb.aws_lb_name</pre> |
| aws_lb_security_groups | Security Group ids attached to Load Balancer. | <pre>module.aws_applb.aws_lb_security_groups</pre> |
| aws_lb_subnet_mapping | Subnet mapping configuration attached to Load Balancer. | <pre>module.aws_applb.aws_lb_subnet_mapping</pre> |
| aws_lb_subnets | Subnet ids attached to Load Balancer. | <pre>module.aws_applb.aws_lb_subnets</pre> |
| aws_lb_tags | Load Balancer Tags. | <pre>module.aws_applb.aws_lb_tags</pre> |
| aws_lb_vpc_id | VPC Id of the Load Balancer. | <pre>module.aws_applb.aws_lb_vpc_id</pre> |
| aws_lb_zone_id | The zone\_id of the load Balancer to assist with creating DNS records. | <pre>module.aws_applb.aws_lb_zone_id</pre> |
| target_group_arn_suffixes | ARN suffixes of our target groups - can be used with CloudWatch. | <pre>module.aws_applb.target_group_arn_suffixes</pre> |
| target_group_arns | ARNs of the target groups. Useful for passing to your Auto Scaling group. | <pre>module.aws_applb.target_group_arns</pre> |
| target_group_names | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. | <pre>module.aws_applb.target_group_names</pre> |
| target_group_tags | Tags of the target groups. | <pre>module.aws_applb.target_group_tags</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
| Error creating ELBv2 Listener | InvalidLoadBalancerAction | When configuring a rule with multiple target groups, none of them can have stickiness of type 'app_cookie' enabled. |
| Error creating ELBv2 Listener | InvalidLoadBalancerAction | Actions of type 'authenticate-cognito' are supported only on HTTPS listeners. |
| Error creating ELBv2 Listener | ValidationError | At least two subnets in two different Availability Zones must be specified. |
| Error modifying ELBv2 Listener | SSLPolicyNotFound | SSL policy 'ELBexample-2016-08' not found. See more about [describe-ssl-policies](https://docs.aws.amazon.com/es_es/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies) |
| Error creating/modifying ELBv2 Listener | ValidationError | An SSL policy cannot be specified for TCP listeners. |
| Error creating/modifying ELBv2 Listener | ValidationError | An SSL policy cannot be specified for HTTP listeners. |
| Error creating/modifying ELBv2 Listener | IncompatibleProtocols | The listener and the following target groups have incompatible protocols: <TG_arn>/TARGET-GROUP-HTTP-INSTANCE/<tg_id>. |
| Error creating LB Target Group | InvalidConfigurationRequest | Custom health check matchers are not supported for health checks for target groups with the TCP protocol. |
| Error modifying Target Group | InvalidConfigurationRequest | Health check healthy threshold and unhealthy threshold must be the same for target groups with the TCP protocol. |
| Error replacing Target Group | DuplicateTargetGroupName | It is not possible to redeploy a Target Group with different configuration (E.g. target_type) with listeners and/or rules attached when Target Group name is set through var.name. Change Target Group name variable also or use name_prefix instead. |
| Error creating ELB | ValidationError | ELB requires at least 8 free IP addresses in each subnet. Minimum IP range allowed is /27. |
| UDP/TCP_UDP Target group first deployment|If the target group has the connection_termination parameter value to 'false' the AWS API will change it to 'true' on first deploy. | To be able to change it to 'false' it must be applied a second deploy. |
