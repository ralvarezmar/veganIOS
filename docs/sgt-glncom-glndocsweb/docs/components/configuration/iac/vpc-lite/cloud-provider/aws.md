# AWS VPC Lite

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

  * AWS VPC.
  * Subnets.
  * Route table(s).

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_vli = {
  "01_default" = {

    vpc_id = "<vpc_id>"

    security_groups = {
      sg-local-vpc = {
        name               = "gln_sg_001"
        description        = "Allow all local communications inside the VPC"
        ingress_rules_keys = ["asg01", "asg02"]
        egress_rules_keys  = ["asg01"]
      },
      sg-exposed-https = {
        name               = "gln_sg_002"
        description        = "To be able to expose most common services (through ALBs, NLBs, Api Gw, EC2 insts, routable Endpoints...)"
        ingress_rules_keys = ["asg02"]
        egress_rules_keys  = ["asg01"]
      },
      sg-exposed-ssh = {
        name               = "gln_sg_003"
        description        = "SSH access"
        ingress_rules_keys = ["asg03"]
        egress_rules_keys  = ["asg01"]
      }
    }

    ingress_asg_rules = {
      asg01 = {
        ip_protocol = "-1"
        cidr_ipv4   = "10.0.0.32/28"
      }
      asg02 = {
        from_port   = 443
        to_port     = 443
        ip_protocol = "tcp"
        cidr_ipv4   = "10.2.0.0/22"
      }
      asg03 = {
        from_port   = 22
        to_port     = 22
        ip_protocol = "tcp"
        cidr_ipv4   = "10.2.0.0/28"
      }
    }

    egress_asg_rules = {
      asg01 = {
        ip_protocol = "-1"
        cidr_ipv4   = "10.2.0.0/28"
      }
    }

    endpoints = {
      ep-s3 = {
        name                = "gln_ep_001"
        service_type        = "s3"
        vpc_endpoint_type   = "Gateway"
        auto_accept         = true
        private_dns_enabled = null
        route_table_ids     = ["<rtb-id>"]
      },
      ep-ecr-dkr = {
        name                = "gln_ep_002"
        service_type        = "ecr.dkr"
        vpc_endpoint_type   = "Interface"
        auto_accept         = true
        private_dns_enabled = true
        subnet_ids          = ["<subnet-id>"]
        security_group_keys = ["sg-exposed-https", "sg-local-vpc"]
      },
      ep-is3 = {
        name                = "gln_ep_003"
        service_type        = "s3"
        vpc_endpoint_type   = "Interface"
        auto_accept         = true
        private_dns_enabled = false
        subnet_ids          = ["<subnet-id>"]
        security_group_keys = ["sg-exposed-https", "sg-local-vpc"]
      },
      ep-firehose = {
        name                = "gln_ep_004"
        service_type        = "kinesis-firehose"
        vpc_endpoint_type   = "Interface"
        auto_accept         = true
        private_dns_enabled = true
        subnet_ids          = ["<subnet-id>"]
        security_group_keys = ["sg-exposed-https", "sg-local-vpc"]
      },
      ep-logs = {
        name                = "gln_ep_005"
        service_type        = "logs"
        vpc_endpoint_type   = "Interface"
        auto_accept         = true
        private_dns_enabled = true
        subnet_ids          = ["<subnet-id>"]
        security_group_keys = ["sg-local-vpc"]
      }
    }

    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon VPC Lite"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| vpc_id | Id of vpc where apply the resources. | <pre>any</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| [egress_asg_rules](#input_egress_asg_rules) | Map to define Rules to be applied in Security Groups. | <pre>any</pre> | {} |
| [endpoints](#input_endpoints) | Map to create endpoints for different services. | <pre>any</pre> | {} |
| [ingress_asg_rules](#input_ingress_asg_rules) | Map to define Rules to be applied in Security Groups. | <pre>any</pre> | {} |
| [nat_gateways](#input_nat_gateways) | Map to create Nat Gateways. | <pre>any</pre> | {} |
| [security_groups](#input_security_groups) | Map to create SGs. | <pre>any</pre> | {} |
| tags | A map of tags to assign to the resource. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_egress_asg_rules"></a> [egress\_asg\_rules](#input\_egress\_asg\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| asg_key | (Optional) (key) The key to create security\_group\_id. | <pre>string</pre> |
| cidr_ipv4 | (Optional) The destination  IPv4 CIDR range. | <pre>list(string)</pre> |
| cidr_ipv6 | (Optional) The destination  IPv6 CIDR range. | <pre>list(string)</pre> |
| description | (Optional) Description of the rule. | <pre>string</pre> |
| from_port | (Optional) Start port (or ICMP type number if protocol is "icmp" or "icmpv6"). | <pre>string</pre> |
| ip_protocol | (Optional)The IP protocol name or number. Use -1 to specify all protocols. Note that if ip\_protocol is set to -1, it translates to all protocols, all port ranges, and from\_port and to\_port values should not be defined. | <pre>string</pre> |
| prefix_list_id | (Optional) List of Prefix List IDs. | <pre>list(string)</pre> |
| referenced_security_group_id | (Optional) The destination security group that is referenced in the rule. | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>list(string)</pre> |
| to_port | (Optional) End port (or ICMP code if protocol is "icmp"). | <pre>string</pre> |

### <a name="input_endpoints"></a> [endpoints](#input\_endpoints)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| auto_accept | (Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account). | <pre>bool</pre> |
| name | (Required) Name of the endpoint. | <pre>string</pre> |
| policy | (Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway and some Interface endpoints support policies - see the relevant AWS documentation for more details. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. | <pre>string</pre> |
| private_dns_enabled | (Optional) (AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Default: true. | <pre>string</pre> |
| route_table_ids | (Required) One or more route table IDs. Applicable for endpoints of type Gateway. | <pre>list(string)</pre> |
| security_group_ids | (Optional) The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint. | <pre>list(string)</pre> |
| service_type | (Required) Service type to create service\_name. For AWS services the service name is usually in the form `com.amazonaws.<region>.<service>` (the SageMaker Notebook service is an exception to this rule, the service name is in the form `aws.sagemaker.<region>.notebook`). For service endpoints, like the ones used by MongoDB-Atlas, provide the endpoint service ID (e.g. `vpce-svc-05493e6aa4893d38c`). | <pre>string</pre> |
| subnet_ids | (Required) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. | <pre>list(string)</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>list(string)</pre> |
| vpc_endpoint_type | (Optional) The VPC endpoint type: `Gateway`, `GatewayLoadBalancer`, or `Interface`. Default: `Gateway`. | <pre>string</pre> |

### <a name="input_ingress_asg_rules"></a> [ingress\_asg\_rules](#input\_ingress\_asg\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| asg_key | (Optional) (key) The key to create security\_group\_id. | <pre>string</pre> |
| cidr_ipv4 | (Optional) The source IPv4 CIDR range. | <pre>list(string)</pre> |
| cidr_ipv6 | (Optional) The source IPv6 CIDR range. | <pre>list(string)</pre> |
| description | (Optional) Description of the rule. | <pre>string</pre> |
| from_port | (Optional) Start port (or ICMP type number if protocol is "icmp" or "icmpv6"). | <pre>string</pre> |
| ip_protocol | (Optional)The IP protocol name or number. Use -1 to specify all protocols. Note that if ip\_protocol is set to -1, it translates to all protocols, all port ranges, and from\_port and to\_port values should not be defined. | <pre>string</pre> |
| prefix_list_id | (Optional) List of Prefix List IDs. | <pre>list(string)</pre> |
| referenced_security_group_id | (Optional) The source security group that is referenced in the rule. | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>list(string)</pre> |
| to_port | (Optional) End port (or ICMP code if protocol is "icmp"). | <pre>string</pre> |

### <a name="input_nat_gateways"></a> [nat\_gateways](#input\_nat\_gateways)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| allocation_id | (Optional) The Allocation ID of the Elastic IP address for the gateway. Required for connectivity\_type of public. | <pre>string</pre> |
| connectivity_type | (Optional) Connectivity type for the gateway. Valid values are private and public. Defaults to public. | <pre>string</pre> |
| name | (Required) Name of the NAT gateway. | <pre>string</pre> |
| secondary_allocation_ids | (Optional) A list of secondary allocation EIP IDs for this NAT Gateway. | <pre>list(string)</pre> |
| secondary_private_ip_address_count | (Optional) [Private NAT Gateway only] The number of secondary private IPv4 addresses you want to assign to the NAT Gateway. | <pre>number</pre> |
| secondary_private_ip_addresses | (Optional) A list of secondary private IPv4 addresses to assign to the NAT Gateway. | <pre>list(string)</pre> |
| subnet_id | (Required) The subnet to use. | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>list(string)</pre> |

### <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| description | (Optional) Security group description. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | (Required) Name of the security group. | <pre>string</pre> |
| revoke_rules_on_delete | (Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. | <pre>bool</pre> |
| tags | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>list(string)</pre> |

## Output example

```hcl
aws_vli = {
  "01_default" = {
    endpoints = {
      "ep-ecr-dkr" = {
        "arn" = "arn:aws:ec2:eu-west-1:<aws_account_id>:vpc-endpoint/vpce-0ce51b38767233f0d"
        "auto_accept" = true
        "cidr_blocks" = []
        "dns_entry" = [
          {
            "dns_name" = "vpce-0ce51b38767233f0d-9g7ebdmt.dkr.ecr.eu-west-1.vpce.amazonaws.com"
            "hosted_zone_id" = "Z38GZ743OKFT7T"
          },
          {
            "dns_name" = "vpce-0ce51b38767233f0d-9g7ebdmt-eu-west-1a.dkr.ecr.eu-west-1.vpce.amazonaws.com"
            "hosted_zone_id" = "Z38GZ743OKFT7T"
          },
          {
            "dns_name" = "vpce-0ce51b38767233f0d-9g7ebdmt-eu-west-1b.dkr.ecr.eu-west-1.vpce.amazonaws.com"
            "hosted_zone_id" = "Z38GZ743OKFT7T"
          },
          {
            "dns_name" = "dkr.ecr.eu-west-1.amazonaws.com"
            "hosted_zone_id" = "Z03445362KGVA2HL1RWR6"
          },
          {
            "dns_name" = "*.dkr.ecr.eu-west-1.amazonaws.com"
            "hosted_zone_id" = "Z03445362KGVA2HL1RWR6"
          },
        ]
        "dns_options" = [
          {
            "dns_record_ip_type" = "ipv4"
            "private_dns_only_for_inbound_resolver_endpoint" = false
          },
        ]
        "id" = "vpce-0ce51b38767233f0d"
        "ip_address_type" = "ipv4"
        "network_interface_ids" = [
          "eni-067ced4102d62fbbe",
          "eni-09e71d13a4c77346a",
        ]
        "owner_id" = "<aws_account_id>"
        "policy" = "{\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\"}]}"
        "prefix_list_id" = null
        "private_dns_enabled" = true
        "requester_managed" = false
        "route_table_ids" = []
        "security_group_ids" = [
          "sg-03b5be4a41a572a8c",
          "sg-0b0ecc54bd04918e2",
        ]
        "service_name" = "com.amazonaws.eu-west-1.ecr.dkr"
        "state" = "available"
        "subnet_configuration" = [
          {
            "ipv4" = "10.10.10.14"
            "ipv6" = ""
            "subnet_id" = "subnet-0d38ff0cf92204d1f"
          },
          {
            "ipv4" = "10.10.16.4"
            "ipv6" = ""
            "subnet_id" = "subnet-03e433d08520be7df"
          },
        ]
        "subnet_ids" = [
          "subnet-03e433d08520be7df",
          "subnet-0d38ff0cf92204d1f",
        ]
        "tags" = {
          "Name" = "epgln02"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "tags_all" = {
          "Name" = "epgln02"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "timeouts" = null
        "vpc_endpoint_type" = "Interface"
        "vpc_id" = "vpc-07f6c9a6417cae4b7"
      }
      "ep-kms" = {
        "arn" = "arn:aws:ec2:eu-west-1:<aws_account_id>:vpc-endpoint/vpce-01c5487e1c36538cd"
        "auto_accept" = true
        "cidr_blocks" = []
        "dns_entry" = [
          {
            "dns_name" = "vpce-01c5487e1c36538cd-5hwv1xj7.kms.eu-west-1.vpce.amazonaws.com"
            "hosted_zone_id" = "Z38GZ743OKFT7T"
          },
          {
            "dns_name" = "vpce-01c5487e1c36538cd-5hwv1xj7-eu-west-1c.kms.eu-west-1.vpce.amazonaws.com"
            "hosted_zone_id" = "Z38GZ743OKFT7T"
          },
          {
            "dns_name" = "kms.eu-west-1.amazonaws.com"
            "hosted_zone_id" = "Z03450596O4G2BZ1C03V"
          },
        ]
        "dns_options" = [
          {
            "dns_record_ip_type" = "ipv4"
            "private_dns_only_for_inbound_resolver_endpoint" = false
          },
        ]
        "id" = "vpce-01c5487e1c36538cd"
        "ip_address_type" = "ipv4"
        "network_interface_ids" = [
          "eni-09006bff4315d3b0d",
        ]
        "owner_id" = "<aws_account_id>"
        "policy" = "{\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\"}]}"
        "prefix_list_id" = null
        "private_dns_enabled" = true
        "requester_managed" = false
        "route_table_ids" = []
        "security_group_ids" = [
          "sg-0b66af2b6ba432e90",
        ]
        "service_name" = "com.amazonaws.eu-west-1.kms"
        "state" = "available"
        "subnet_configuration" = [
          {
            "ipv4" = "10.10.17.10"
            "ipv6" = ""
            "subnet_id" = "subnet-084fdffe30339b0e8"
          },
        ]
        "subnet_ids" = [
          "subnet-084fdffe30339b0e8",
        ]
        "tags" = {
          "Name" = "epgln03"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "tags_all" = {
          "Name" = "epgln03"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "timeouts" = null
        "vpc_endpoint_type" = "Interface"
        "vpc_id" = "vpc-07f6c9a6417cae4b7"
      }
      "ep-s3" = {
        "arn" = "arn:aws:ec2:eu-west-1:<aws_account_id>:vpc-endpoint/vpce-09f0c6a67f0872ee0"
        "auto_accept" = true
        "cidr_blocks" = [
          "3.5.64.0/21",
          "3.5.72.0/23",
          "52.92.0.0/17",
          "52.218.0.0/17",
        ]
        "dns_entry" = []
        "dns_options" = []
        "id" = "vpce-09f0c6a67f0872ee0"
        "ip_address_type" = ""
        "network_interface_ids" = []
        "owner_id" = "<aws_account_id>"
        "policy" = "{\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\"}]}"
        "prefix_list_id" = "pl-6da54004"
        "private_dns_enabled" = false
        "requester_managed" = false
        "route_table_ids" = [
          "rtb-05c2e981bdae5926d",
        ]
        "security_group_ids" = []
        "service_name" = "com.amazonaws.eu-west-1.s3"
        "state" = "available"
        "subnet_configuration" = []
        "subnet_ids" = []
        "tags" = {
          "Name" = "epgln01"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "tags_all" = {
          "Name" = "epgln01"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "timeouts" = null
        "vpc_endpoint_type" = "Gateway"
        "vpc_id" = "vpc-07f6c9a6417cae4b7"
      }
    }
    security_groups = {
      "sg1" = {
        "arn" = "arn:aws:ec2:eu-west-1:<aws_account_id>:security-group/sg-0b0ecc54bd04918e2"
        "description" = "SG1 for tests"
        "egress" = []
        "id" = "sg-0b0ecc54bd04918e2"
        "ingress" = [
          {
            "cidr_blocks" = [
              "10.10.10.0/28",
            ]
            "description" = ""
            "from_port" = 0
            "ipv6_cidr_blocks" = []
            "prefix_list_ids" = []
            "protocol" = "-1"
            "security_groups" = []
            "self" = false
            "to_port" = 0
          },
        ]
        "name" = "sggln01"
        "name_prefix" = ""
        "owner_id" = "<aws_account_id>"
        "revoke_rules_on_delete" = true
        "tags" = {
          "Name" = "sggln01"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "tags_all" = {
          "Name" = "sggln01"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "timeouts" = null
        "vpc_id" = "vpc-07f6c9a6417cae4b7"
      }
      "sg2" = {
        "arn" = "arn:aws:ec2:eu-west-1:<aws_account_id>:security-group/sg-03b5be4a41a572a8c"
        "description" = "SG2 for tests"
        "egress" = []
        "id" = "sg-03b5be4a41a572a8c"
        "ingress" = [
          {
            "cidr_blocks" = [
              "10.10.16.0/28",
            ]
            "description" = ""
            "from_port" = 22
            "ipv6_cidr_blocks" = []
            "prefix_list_ids" = []
            "protocol" = "tcp"
            "security_groups" = []
            "self" = false
            "to_port" = 22
          },
          {
            "cidr_blocks" = [
              "10.10.16.0/28",
            ]
            "description" = ""
            "from_port" = 443
            "ipv6_cidr_blocks" = []
            "prefix_list_ids" = []
            "protocol" = "tcp"
            "security_groups" = []
            "self" = false
            "to_port" = 443
          },
        ]
        "name" = "sggln02"
        "name_prefix" = ""
        "owner_id" = "<aws_account_id>"
        "revoke_rules_on_delete" = true
        "tags" = {
          "Name" = "sggln02"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "tags_all" = {
          "Name" = "sggln02"
          "environment" = "dev"
          "product" = "Gluon VPC Lite"
        }
        "timeouts" = null
        "vpc_id" = "vpc-07f6c9a6417cae4b7"
      }
    }
  }
}  
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_vli|module.aws_vli|AWS VLI outputs map. <br>[Map AWS VLI Outputs](#AWS VLI Outputs). |

<a name="AWS VLI Outputs"></a>

### AWS VLI Outputs

| Name | Description | Type |
|------|-------------|------|
| [endpoints](#output_endpoints) | All outputs got from aws\_vpc\_endpoint resource. | module.aws_vli<br>.endpoints |
| [nat_gateways](#output_nat_gateways) | All outputs got from nat\_gateway resource. | module.aws_vli<br>.nat_gateways |
| [security_groups](#output_security_groups) | All outputs got from security\_group resource. | module.aws_vli<br>.security_groups |

### Block Parameters

#### <a name="output_endpoints"></a> [endpoints](#output\_endpoints)

| Name | Description | Type |
|------|-------------|------|
| arn | The ARN of the endpoint. | module.aws_vli<br>.endpoints.arn |
| auto\_accept | Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account). | module.aws_vli<br>.endpoints.auto_accept |
| cidr\_blocks | The list of CIDR blocks for the exposed AWS service. Applicable for endpoints of type Gateway. | module.aws_vli<br>.endpoints.cidr_blocks |
| dns\_entry | The DNS entries for the VPC Endpoint. Applicable for endpoints of type Interface. DNS blocks are documented below. | module.aws_vli<br>.endpoints.dns_entry |
| dns\_options | The DNS records created for the endpoint. Valid values are ipv4, dualstack, service-defined, and ipv6. | module.aws_vli<br>.endpoints.dns_options |
| id | The ID of the VPC endpoint. | module.aws_vli<br>.endpoints.id |
| ip\_address\_type | The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6. | module.aws_vli<br>.endpoints.ip_address_type |
| network\_interface\_ids | One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type Interface. | module.aws_vli<br>.endpoints.network_interface_ids |
| owner\_id | The ID of the AWS account that owns the VPC endpoint. | module.aws_vli<br>.endpoints.owner_id |
| policy | A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. All Gateway and some Interface endpoints support policies - see the relevant AWS documentation for more details. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. | module.aws_vli<br>.endpoints.policy |
| prefix\_list\_id | The prefix list ID of the exposed AWS service. Applicable for endpoints of type Gateway. | module.aws_vli<br>.endpoints.prefix_list_id |
| private\_dns\_enabled | Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. | module.aws_vli<br>.endpoints.private_dns_enabled |
| requester\_managed | Whether or not the VPC Endpoint is being managed by its service - true or false. | module.aws_vli<br>.endpoints.requester_managed |
| route\_table\_ids | One or more route table IDs. Applicable for endpoints of type Gateway. | module.aws_vli<br>.endpoints.route_table_ids |
| security\_group\_ids | The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint. | module.aws_vli<br>.endpoints.security_group_ids |
| service\_name | The service name. For AWS services the service name is usually in the form com.amazonaws.`<region>`.`<service>` (the SageMaker Notebook service is an exception to this rule, the service name is in the form aws.sagemaker.`<region>`g.notebook). | module.aws_vli<br>.endpoints.service_name |
| state | The state of the VPC endpoint. | module.aws_vli<br>.endpoints.state |
| subnet\_ids | The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. | module.aws_vli<br>.endpoints.subnet_ids |
| tags | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | module.aws_vli<br>.endpoints.tags |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | module.aws_vli<br>.endpoints.tags_all |
| timeouts | Timeout of the resource. | module.aws_vli<br>.endpoints.timeouts |
| vpc\_endpoint\_type | The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. | module.aws_vli<br>.endpoints.vpc_endpoint_type |
| vpc\_id | The ID of the VPC in which the endpoint will be used. | module.aws_vli<br>.endpoints.vpc_id |

#### <a name="output_nat_gateways"></a> [nat\_gateways](#output\_nat\_gateways)

| Name | Description | Type |
|------|-------------|------|
| allocation\_id | The Allocation ID of the Elastic IP address for the gateway. | module.aws_vli<br>.nat_gateways.allocation_id |
| connectivity\_type | Connectivity type for the gateway. Valid values are private and public. | module.aws_vli<br>.nat_gateways.connectivity_type |
| id | The ID of the NAT Gateway. | module.aws_vli<br>.nat_gateways.id |
| network\_interface\_id | The ENI ID of the network interface created by the NAT gateway. | module.aws_vli<br>.nat_gateways.network_interface_id |
| private\_ip | The private IP address of the NAT Gateway. | module.aws_vli<br>.nat_gateways.private_ip |
| public\_ip | The public IP address of the NAT Gateway. | module.aws_vli<br>.nat_gateways.public_ip |
| subnet\_id | The Subnet ID of the subnet in which the NAT gateway is placed. | module.aws_vli<br>.nat_gateways.subnet_id |
| tags | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | module.aws_vli<br>.nat_gateways.tags |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | module.aws_vli<br>.nat_gateways.tags_all |

#### <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups)

| Name | Description | Type |
|------|-------------|------|
| arn | ARN of the security group. | module.aws_vli.<br>security_groups.arn |
| description | Security group description.Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags. | module.aws_vli<br>.security_groups.description |
| egress | Map for Configuration block for egress rules. Can be specified multiple times for each egress rule. Each egress block supports fields documented below. This argument is processed in attribute-as-blocks mode. | module.aws_vli<br>.security_groups.egress |
| egress<br/>.cidr\_blocks | List of CIDR blocks. | module.aws_vli<br>.security_groups.egress.cidr_blocks |
| egress<br/>.description | Description of this egress rule. | module.aws_vli<br>.security_groups.egress.description |
| egress<br/>.from\_port | Start port (or ICMP type number if protocol is icmp). | module.aws_vli<br>.security_groups.egress.from_port |
| egress<br/>.ipv6\_cidr\_blocks | List of IPv6 CIDR blocks. | module.aws_vli<br>.security_groups.egress.ipv6_cidr_blocks |
| egress<br/>.prefix\_list\_ids | List of Prefix List IDs. | module.aws_vli<br>.security_groups.egress.prefix_list_ids |
| egress<br/>.protocol | Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from\_port and to\_port equal to 0. The supported values are defined in the IpProtocol argument in the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using Terraform 0.12.x and above. Please make sure that the value of the protocol is specified as lowercase when used with older version of Terraform to avoid issues during upgrade. | module.aws_vli<br>.security_groups.egress.protocol |
| egress<br/>.self | Whether the security group itself will be added as a source to this egress rule. | module.aws_vli<br>.security_groups.egress.self |
| egress<br/>.security_groups | List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID. | module.aws_vli<br>.security_groups.egress.security_groups |
| egress<br/>.to\_port | End range port (or ICMP code if protocol is icmp). | module.aws_vli<br>.security_groups.egress.to_port |
| id | The Allocation ID of the Elastic IP address for the gateway. | module.aws_vli<br>.security_groups.id |
| ingress | The Allocation ID of the Elastic IP address for the gateway. | module.aws_vli<br>.security_groups.ingress |
| ingress<br/>.cidr\_blocks | List of CIDR blocks. | module.aws_vli<br>.security_groups.ingress.cidr_blocks |
| ingress<br/>.description | Description of this ingress rule. | module.aws_vli<br>.security_groups.ingress.description |
| ingress<br/>.from\_port | Start port (or ICMP type number if protocol is icmp). | module.aws_vli<br>.security_groups.ingress.from_port |
| ingress<br/>.ipv6\_cidr\_blocks | List of IPv6 CIDR blocks. | module.aws_vli<br>.security_groups.ingress.ipv6_cidr_blocks |
| ingress<br/>.prefix\_list\_ids | List of Prefix List IDs. | module.aws_vli<br>.security_groups.ingress.prefix_list_ids |
| ingress<br/>.protocol | Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from\_port and to\_port equal to 0. The supported values are defined in the IpProtocol argument in the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using Terraform 0.12.x and above. Please make sure that the value of the protocol is specified as lowercase when used with older version of Terraform to avoid issues during upgrade. | module.aws_vli<br>.security_groups.ingress.protocol |
| ingress<br/>.security\_groups | List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID. | module.aws_vli<br>.security_groups.ingress.security_groups |
| ingress<br/>.self | Whether the security group itself will be added as a source to this ingress rule. | module.aws_vli<br>.security_groups.ingress.self |
| ingress<br/>.to\_port | End range port (or ICMP code if protocol is icmp). | module.aws_vli<br>.security_groups.ingress.to_port |
| name | Name of the security group. If omitted, Terraform will assign a random, unique name. | module.aws_vli<br>.security_groups.name |
| name\_prefix | Creates a unique name beginning with the specified prefix. Conflicts with name. | module.aws_vli<br>.security_groups.name_prefix |
| owner\_id | Owner ID. | module.aws_vli<br>.security_groups.owner_id |
| revoke\_rules\_on\_delete | Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. | module.aws_vli<br>.security_groups.revoke_rules_on_delete |
| tags | Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | module.aws_vli<br>.security_groups.tags |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | module.aws_vli<br>.security_groups.tags_all |
| timeouts | Timeout of the resource. | module.aws_vli<br>.security_groups.timeouts |
| vpc\_id | VPC ID. | module.aws_vli<br>.security_groups.vpc_id |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
|Second run of the plan/apply command shows changes made outside the terraform. | As security group rules are updated via separate terraform resources, the security group configuration in tf.state becomes outdated after first run. | The second run of "terraform apply" or "terraform refresh" commands will update state of the resources and the module configuration becomes idempotent. |
