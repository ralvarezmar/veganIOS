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
aws_netlb = {
  "00_elb_default" {

    name = "glnd1airarctn0gene001"

    tags = {
      product     = "Gluon AWS ELB"
      environment = "dev"
      project     = "Gluon"
    }

    load_balancer_type         = "application"
    internal                   = true
    enable_deletion_protection = false

    security_groups = ["sg-050410006b439a7b1"]
    subnets         = ["subnet-0cee26cfcc83e7609", "subnet-125s55a525sa095ac"]

    target_groups = {
      tg00 = {
        name     = "elbt00"
        vpc_id   = "vpc-050fb8a9b39aa888c"
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
        certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
      }
    }
  }

  "01_elb_app_full" {

  name = "glnd1airarctn0gene002"

  tags = {
    product     = "Gluon AWS ELB"
    environment = "dev"
    project     = "Gluon"
  }

  load_balancer_type = "application"
  internal           = true

  security_groups = ["sg-050410006b439a7b1"]
  subnets         = ["subnet-0cee26cfcc83e7609", "subnet-125s55a525sa095ac"]

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
    bucket  = "glnd1airas3envgene001"
    prefix  = "access_logs"
  }


  target_groups = {
    instance = {
      name     = "elbt01-instance"
      vpc_id   = "vpc-050fb8a9b39aa888c"
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
          arn  = "i-03b18e5035c6bee9c"
          port = 80
        }
      }
    }

    ip = {
      name     = "elbt01-ip"
      vpc_id   = "vpc-050fb8a9b39aa888c"
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
          arn               = "10.32.0.132"
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
      certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
      ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

      default_action = {
        authenticate-cognito = {
          user_pool_arn       = "arn:aws:cognito-idp:eu-west-1:<aws_account_id>:userpool/eu-west-1_oVqZ0POvc"
          user_pool_client_id = "5novqt97dop5e5redfel577pot"
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
      certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
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
      certificate_arn      = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
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
          user_pool_arn       = "arn:aws:cognito-idp:eu-west-1:<aws_account_id>:userpool/eu-west-1_oVqZ0POvc"
          user_pool_client_id = "5novqt97dop5e5redfel577pot"
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

  "02_elb_net_full" {

    name = "glnd1airarctn0gene003"

    tags = {
      product     = "Gluon AWS ELB"
      environment = "dev"
      project     = "Gluon"
    }

    load_balancer_type = "network"
    internal           = true

    subnets = ["subnet-0cee26cfcc83e7609", "subnet-125s55a525sa095ac"]

    lb_timeouts = {
      create = "10m"
      delete = "10m"
      update = "10m"
    }
    enable_deletion_protection = false

    ip_address_type                  = "ipv4"
    enable_cross_zone_load_balancing = true

    access_logs = {
      enabled = true
      bucket  = "glnd1airas3envgene001"
      prefix  = "access_logs"
    }


    target_groups = {
      tg_tcp = {
        name     = "elbt02-tcp"
        vpc_id   = "vpc-050fb8a9b39aa888c"
        port     = 80
        protocol = "TCP"

        target_type            = "instance"
        deregistration_delay   = 10
        preserve_client_ip     = false
        proxy_protocol_v2      = true
        connection_termination = true

        health_check = {
          enabled             = true
          protocol            = "TCP"
          port                = "traffic-port"
          interval            = 15
          healthy_threshold   = 4
          unhealthy_threshold = 2
          timeout             = 10
        }

        stickiness = {
          enabled = true
          type    = "source_ip"
        }

        targets = {
          t0 = {
            arn  = "i-03b18e5035c6bee9c"
            port = 80
          }
        }
      }

      tg_udp = {
        name     = "elbt02-udp"
        vpc_id   = "vpc-050fb8a9b39aa888c"
        port     = 5050
        protocol = "UDP"

        target_type            = "ip"
        ip_address_type        = "ipv4"
        deregistration_delay   = 15
        preserve_client_ip     = true
        proxy_protocol_v2      = false
        connection_termination = true

        stickiness = {
          enabled = true
          type    = "source_ip"
        }

        targets = {
          t0 = {
            arn               = "2a05:d018:138f:4100:b86a:f219:2fd7:ccf6"
            port              = 5050
            availability_zone = "eu-west-1a"
          }
        }
      }
      tg_tcp_udp = {
        name     = "elbt02-tcp-udp"
        vpc_id   = "vpc-050fb8a9b39aa888c"
        port     = 6060
        protocol = "TCP_UDP"

        target_type            = "ip"
        ip_address_type        = "ipv4"
        deregistration_delay   = 10
        preserve_client_ip     = true
        proxy_protocol_v2      = false
        connection_termination = true

        health_check = {
          enabled             = true
          protocol            = "TCP"
          port                = 6060
          interval            = 15
          healthy_threshold   = 2
          unhealthy_threshold = 3
          timeout             = 5
        }

        stickiness = {
          enabled = true
          type    = "source_ip"
        }

        targets = {
          t0 = {
            arn  = "2a05:d018:138f:4100:b86a:f219:2fd7:ccf6"
            port = 6060
          }
        }
      }
    }

    listeners = {
      tcp = {
        name     = "tcp"
        protocol = "TCP"
        port     = 80

        default_action = {
          forward = {
            target_group_key = "tg_tcp"
          }
        }

        tags = {
          extra_tag = "example"
        }
      }

      udp = {
        name     = "udp"
        protocol = "UDP"
        port     = 5050

        default_action = {
          forward = {
            target_group_key = "tg_udp"
          }
        }
      }

      tcp_udp = {
        name     = "tcp-udp"
        protocol = "TCP_UDP"
        port     = 6060

        default_action = {
          forward = {
            target_group_key = "tg_tcp_udp"
          }
        }
      }

      tls = {
        name            = "tls"
        protocol        = "TLS"
        port            = 443
        certificate_arn = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
        ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
        alpn_policy     = "HTTP2Preferred"

        default_action = {
          forward = {
            target_group_key = "tg_tcp"
          }
        }
      }
    }

    extra_ssl_certs = {
      cert001 = {
        https_listener_index = "tls"
        certificate_arn      = "arn:aws:acm:eu-west-1:<aws_account_id>:certificate/4253d8f6-44c3-4ae8-bd18-dc93f04a0bb6"
      }
    }
  }

  "03_elb_subnet_mapping" {

    name = "glnd1airarctn0gene004"

    tags = {
      product     = "Gluon AWS ELB"
      environment = "dev"
      project     = "Gluon"
    }

    load_balancer_type         = "network"
    internal                   = true
    enable_deletion_protection = false

    subnet_mapping = [
      {
        subnet_id            = "subnet-0cee26cfcc83e7609"
        private_ipv4_address = "10.32.0.128"
      },
      {
        subnet_id            = "subnet-125s55a525sa095ac"
        private_ipv4_address = "10.32.1.128"
      },
      {
        subnet_id            = "subnet-0bc698447c267e55f"
        private_ipv4_address = "10.32.2.128"
      },
    ]

    target_groups = {
      tg00 = {
        name     = "elbt03"
        vpc_id   = "vpc-050fb8a9b39aa888c"
        port     = 80
        protocol = "TCP"
      }
    }

    listeners = {
      l00 = {
        name = "elbt03"
        default_action = {
          forward = {
            target_group_key = "tg00"
          }
        }
        port     = 80
        protocol = "TCP"
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
| access_logs | Map containing access logging configuration for load balancer. | <pre>any</pre> | {} |
| autoscaling_groups | A map of objects describing the Autoscaling Groups to attach to the target groups of the ELB. The key defines the name of the existing Autoscaling Group. | <pre>any</pre> | {} |
| desync_mitigation_mode | Determines how the ALB handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest. | <pre>string</pre> | null |
| drop_invalid_header_fields | Indicates whether invalid header fields are dropped in in ALB. Not supported by NLBs. | <pre>bool</pre> | null |
| enable_cross_zone_load_balancing | Indicates whether cross zone load balancing should be enabled in NLB. Not supported by ALBs. | <pre>bool</pre> | null |
| enable_deletion_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to true. | <pre>bool</pre> | true |
| enable_http2 | Indicates whether HTTP/2 is enabled in ALB. Not supported by NLBs. | <pre>bool</pre> | null |
| extra_ssl_certs | A map of objects describing any extra SSL certificates to apply to the HTTPS listeners. | <pre>map(object({<br>    https_listener_index = string<br>    certificate_arn      = string<br>  }))</pre> | {} |
| idle_timeout | The time in seconds that the connection is allowed to be idle. Supported values are between 1 and 4000. | <pre>number</pre> | null |
| internal | Boolean determining if the load balancer is internal or externally facing. | <pre>bool</pre> | true |
| ip_address_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | <pre>string</pre> | "ipv4" |
| lb_timeouts | A map of timeout values when creating, deleting and updating the ALB. | <pre>map(string)</pre> | {} |
| listeners | A map of objects describing the HTTP listeners or TCP ports for this ALB. | <pre>any</pre> | {} |
| load_balancer_type | The type of load balancer to create. Possible values are application or network. | <pre>string</pre> | "application" |
| preserve_host_header | Indicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to false. | <pre>bool</pre> | null |
| rules | A map of objects describing the rules by listener. | <pre>any</pre> | {} |
| security_groups | The security groups to attach to the load balancer. e.g. ["sg-edcd9784","sg-edcd9785"]. | <pre>list(string)</pre> | [] |
| subnet_mapping| A list of subnet mapping objects describing subnets to attach to network load balancer. | <pre>any</pre> | [] |
| subnets | A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']. | <pre>list(string)</pre> | null |
| tags | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>any</pre> | {} |
| target_groups | A map of objects that represent the Target Groups. | <pre>any</pre> | {} |

## Output example

```hcl
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
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| aws_alb_listener_arns | The ARN of the TCP and HTTP load Balancer listeners created. | <pre>module.aws_netlb.aws_lb_listener.main.*.arn</pre> |
| aws_alb_listener_rule_arns | The ARNs of the Load Balancer listener rules created. | <pre>module.aws_netlb.aws_lb_listener_rule.rules.*.arn</pre> |
| aws_alb_listener_rule_tags | Tags of the Load Balancer listener rules created. | <pre>module.aws_netlb.aws_lb_listener_rule.rules.*.tags_all</pre> |
| aws_alb_listener_tags | Tags of the TCP and HTTP load Balancer listeners created. | <pre>module.aws_netlb.aws_lb_listener.main.*.tags_all</pre> |
| aws_lb_access_logs | The S3 bucket where resides Load Balancer logs. | <pre>module.aws_netlb.aws_lb.main.access_logs</pre> |
| aws_lb_arn | The ID and ARN of the load Balancer we created. | <pre>aws_lb.main.arn</pre> |
| aws_lb_arn_suffix | ARN suffix of our load Balancer - can be used with CloudWatch. | <pre>module.aws_netlb.aws_lb.main.arn_suffix</pre> |
| aws_lb_dns_name | The DNS name of the load Balancer. | <pre>module.aws_netlb.aws_lb.main.dns_name</pre> |
| aws_lb_name | Load Balancer Name. | <pre>module.aws_netlb.aws_lb.main.name</pre> |
| aws_lb_security_groups | Security Group ids attached to Load Balancer. | <pre>module.aws_netlb.aws_lb.main.security_groups</pre> |
| [aws_lb_subnet_mapping](#output_aws_lb_subnet_mapping) | Subnet mapping configuration attached to Load Balancer. | <pre>module.aws_netlb.aws_lb.main.subnet_mapping</pre> |
| aws_lb_subnets | Subnet ids attached to Load Balancer. | <pre>module.aws_netlb.aws_lb.main.subnets</pre> |
| aws_lb_tags | Load Balancer Tags. | <pre>module.aws_netlb.aws_lb.main.tags_all</pre> |
| aws_lb_vpc_id | VPC Id of the Load Balancer. | <pre>module.aws_netlb.aws_lb.main.vpc_id</pre> |
| aws_lb_zone_id | The zone\_id of the load Balancer to assist with creating DNS records. | <pre>module.aws_netlb.aws_lb.main.zone_id</pre> |
| target_group_arn_suffixes | ARN suffixes of our target groups - can be used with CloudWatch. | <pre>module.aws_netlb.aws_lb_target_group.main.*.arn_suffix</pre> |
| target_group_arns | ARNs of the target groups. Useful for passing to your Auto Scaling group. | <pre>module.aws_netlb.aws_lb_target_group.main.*.arn</pre> |
| target_group_names | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. | <pre>module.aws_netlb.aws_lb_target_group.main.*.name</pre> |
| target_group_tags | Tags of the target groups. | <pre>module.aws_netlb.aws_lb_target_group.main.*.tags_all</pre> |

### Block Parameters

#### <a name="output_aws_lb_subnet_mapping"></a> [aws\_lb\_subnet\_mapping](#output\_aws\_lb\_subnet\_mapping)

| Name | Description | Type |
|------|-------------|------|
| allocation_id | The allocation ID of the Elastic IP address | <pre>module.aws_netlb.aws_lb.main.subnet_mapping.*.allocation_id</pre> |
| ipv6_address |  A private ipv6 address within the subnet to assign to the internal-facing load balancer. | <pre>module.aws_netlb.aws_lb.main.subnet_mapping.*.ipv6_address</pre> |
| private_ipv4_address | A private ipv4 address within the subnet to assign to the internal-facing load balancer. | <pre>module.aws_netlb.aws_lb.main.subnet_mapping.*.private_ipv4_address</pre> |
| subnet_id | The id of the subnet of which to attach to the load balancer. You can specify only one subnet per Availability Zone. | <pre>module.aws_netlb.aws_lb.main.subnet_mapping.*.subnet_id</pre> |

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
