# AWS Elastic Kubernetes Service

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

* AWS VPC and subnets required settings.
  * Endpoints required, without this the nodes will not be able to communicate or join the cluster.
* If nodes are needed, check that the 'image_ids' are appropriate for the EKS version.
* If addons are required, check that the 'addon_version' is appropriate for the EKS version.
* Role to control EKS Control Plane. (Required if EKS Cluster wants to be created)
* Role to control EKS Nodes.(Required if EKS Nodes wants to be created)
* Role to control EKS Fargate. (Required if EKS Fargate wants to be created)
* If 'create_cluster' is false, an existing EKS cluster.
* KMS Key to encrypt the EKS cluster secrets and the EBS of the node groups launch template. (Optional, if not provided, it will be created through the module.)

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_kubernetes = {
  eks_default = {
    # -------------
    # Tags
    # -------------
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon EKS"
    }

    # -------------
    # Security
    # -------------
    kms_name                = "glnd1airkmstest00gene001"
    deletion_window_in_days = 7

    # -------------
    # EKS Cluster
    # -------------
    cluster_name              = "glnd1airekstest00gene001"
    iam_role_arn              = "arn:aws:iam::<aws_account_id>:role/testing-gln-cluster-role"
    cluster_version           = "1.29"
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    subnet_ids                = ["subnet-08b42edeb4952cdaf", "subnet-0714d26447e9c8740", "subnet-0dbcd35889c8cb4fe"]
    security_group_ids        = ["sg-00ffa2ad41e50e2c3"]
    cluster_create_timeout    = "60m"
    cluster_delete_timeout    = "30m"

    cluster_tags = {
      cluster_tag = "eks_cluster_tag"
    }
  }
  eks_complete = {
    # -------------
    # Tags
    # -------------
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon EKS"
    }

    # -------------
    # Security
    # -------------
    kms_key_arn = "arn:aws:kms:eu-west-1:<aws_account_id>:key/03470af8-47c0-4ca4-966d-5950c1525e58"

    # -------------
    # EKS Cluster
    # -------------
    cluster_name           = "glnd1airekstest00gene002"
    iam_role_arn           = "arn:aws:iam::<aws_account_id>:role/testing-gln-cluster-role"
    cluster_version        = "1.28"
    subnet_ids             = ["subnet-0f25a306a4dfe811b", "subnet-059bc2c58103823a8", "subnet-0f239a237b5b44863"]
    security_group_ids     = ["sg-0fd2af969cd92c564"]
    cluster_create_timeout = "60m"
    cluster_delete_timeout = "30m"
    cluster_tags = {
      cluster_tag = "eks_cluster_tag"
    }

    # ---------------------
    # EKS Node Group
    # ---------------------
    node_groups = {
      "node_linux" = {
        disk_size      = 30
        instance_types = "t3.small"
        desired_size   = 1
        capacity_type  = "ON_DEMAND"
        max_size       = 2
        min_size       = 1
        volume_type    = "gp2"
        image_id       = "<image_id>"
        max_pods       = 6
        kubelet_extra_args = {
          "image-gc-high-threshold" = 77
          "image-gc-low-threshold"  = 50
        }
        update_max_unavailable_percentage = 100
        subnet_ids                        = ["subnet-0f25a306a4dfe811b", "subnet-059bc2c58103823a8", "subnet-0f239a237b5b44863"]
        node_role_arn                     = "arn:aws:iam::<aws_account_id>:role/testing-iac.aws.modules.node-role"
        security_group_ids                = ["sg-00e8349e2ea2f66ef"]
      },
      "node_windows" = {
        disk_size      = 30
        instance_types = "t3.small"
        desired_size   = 1
        capacity_type  = "ON_DEMAND"
        max_size       = 2
        min_size       = 1
        volume_type    = "gp2"
        image_id       = "<image_id>" //WINDOWS
        # Note : On Windows nodes, max-pods cannot be indicated because it is deprecated and is done through the Kubelet config
        update_max_unavailable_percentage = 100
        node_role_arn                     = "arn:aws:iam::<aws_account_id>:role/testing-iac.aws.modules.node-role"
        subnet_ids                        = ["subnet-0f25a306a4dfe811b", "subnet-059bc2c58103823a8", "subnet-0f239a237b5b44863"]
        security_group_ids                = ["sg-00e8349e2ea2f66ef"]
      }
    }

    # ---------------------
    # EKS Fargate Profile
    # ---------------------
    fargate_profiles = {
      "profile1" = {
        fargate_profile_name   = "glnd1airfgttest00gene001"
        pod_execution_role_arn = "arn:aws:iam::<aws_account_id>:role/testing-gln-fargate-role"
        subnet_ids             = ["subnet-0s7jha309h2dfe88g", "subnet-0937c2c534353824a"]
        namespace              = "default"
        fargate_tags = {
          fargate_test_tag = "eks_fargate_tag"
        }
      }

      "profile2" = {
        fargate_profile_name   = "glnd1airfgttest00gene002"
        pod_execution_role_arn = "arn:aws:iam::<aws_account_id>:role/testing-gln-fargate-role2"
        subnet_ids             = ["subnet-92k6vc830hs93jkd8", "subnet-099ma62h3430378gd"]
        namespace              = "default"
      }
    }

    # ---------------------
    # EKS cluster Addon
    # ---------------------
    # It is important to note that many of the addons require at least one Linux node as a requirement.
    cluster_addons = {
      # The kube-proxy addon will ALWAYS be deployed to avoid the use of self-managed kube-proxy daemonSet.
      # Kube Proxy version will be the default addon version for the EKS cluster version.
      "vpc-cni" = {
        # It's highly recommended that when specifying custom configurations, the cluster decides the addon version.
        # addon_version = "v1.29.0-eksbuild.1"
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
        preserve                    = false

        # This configuration specifies that your pods may use subnets and security groups that are independent of your worker node's VPC configuration.
        # The pods will use the cdir block from the specified subnet.
        configuration_values = {
          "env" = {
            "AWS_VPC_K8S_CNI_EXTERNALSNAT"       = "false"
            "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG" = "true",
            "ENI_CONFIG_LABEL_DEF"               = "failure-domain.beta.kubernetes.io/zone"
            "ENABLE_PREFIX_DELEGATION"           = "true"
            "WARM_PREFIX_TARGET"                 = "1"
          }
          "eniConfig" = {
            "create" = true
            "region" = "eu-west-1"
            "subnets" = {
              "eu-west-1a" = {
                "id"             = "subnet-0f25a306a4dfe8000"
                "securityGroups" = ["sg-0fd2af969cd92c564"]
              }
              "eu-west-1b" = {
                "id"             = "subnet-0f25a306a4dfe8000"
                "securityGroups" = ["sg-0fd2af969cd92c564"]
              }
            }
          }
        }
      }
      "coredns" = {
        # addon_version = "v1.29.0-eksbuild.1"
        preserve = false
        configuration_values = {
          "replicaCount" = 3
          "resources" = {
            "limits" = {
              "cpu"    = "100m"
              "memory" = "150Mi"
            }
            "requests" = {
              "cpu"    = "100m"
              "memory" = "150Mi"
            }
          }
          "podDisruptionBudget" = {
            "enabled"        = true
            "maxUnavailable" = 5
          }
        }
      }
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| cluster_name | Name of the EKS cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^"0-9A-Za-z-A-Za-z0-9\-\_"*$). In case that 'var.create\_cluster is 'false', it must be the name of an existing EKS cluster. | <pre>string</pre> |

!!! info
    Post-configuration parameters required for Kubernetes clusters should be provided in the config.yml file. Please, check required and optional parameters to configure clusters deployed [here](../post-conf.md)

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| [access_config](#input_access_config) | Map to define EKS cluster Access Configuration. | <pre>any</pre> | {} |
| access_policy_arn | The ARN of the access policy to be associated with 'cluster\_admin\_role'. | <pre>string</pre> | "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" |
| [cluster_addons](#input_cluster_addons) | Object map to manage EKS addons. Kube-proxy addon will ALWAYS be deployed to avoid the use of self-managed kube-proxy daemonSet, using default addon version for the EKS cluster version. If another addon version is needed, this map must be specified with the desired version. :warning: Note that the addon name will be the key of the addon configuration map. | <pre>any</pre> | {} |
| cluster_admin_role | Roles to be associated with AmazonEKSClusterAdminPolicy. Roles should be compliance with the 'role\_regex' pattern. If 'var.access\_config' is specified along with this variable, it is mandatory to set the 'access\_config' authentication mode to 'API\_AND\_CONFIG\_MAP' or 'API'. | <pre>list(string)</pre> | [] |
| cluster_create_timeout | How long to wait for the EKS Cluster to be created. | <pre>string</pre> | "60m" |
| cluster_delete_timeout | How long to wait for the EKS Cluster to be deleted. | <pre>string</pre> | "30m" |
| cluster_service_ipv4_cidr | The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC.  The block must meet the following requirements: Within one of the following private IP address blocks: 10.0.0.0/8, 172.16.0.0/12, or 192.168.0.0/16, doesn't overlap with any CIDR block assigned to the VPC that you selected for VPC, Between /24 and /12. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created. | <pre>string</pre> | null |
| cluster_tags | EKS cluster unique tags. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> | {} |
| cluster_version | (Required when 'create\_cluster' is 'true') Desired Kubernetes master version. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS. | <pre>string</pre> | null |
| create_cluster | Specifies if a new EKS cluster must be created or an existing one must be used. | <pre>bool</pre> | true |
| deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Should only be used when 'kms\_key\_arn' is not provided. | <pre>number</pre> | 30 |
| enabled_cluster_log_types | List of the desired control plane logging to enable. For more information, see [Amazon EKS Control Plane Logging](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html). | <pre>list(any)</pre> | [<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>] |
| [fargate_profiles](#input_fargate_profiles) | Map of fargate profiles that will be attached to the EKS Cluster. | <pre>any</pre> | {} |
| iam_role_arn | (Required when 'create\_cluster' is 'true') The Amazon Resource Name (ARN) of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf. | <pre>string</pre> | null |
| kms_key_arn | The ARN of the KMS Key to use when encrypting EKS cluster secrets and the EBS of the node groups launch template. If not provided, a new KMS key will be created. | <pre>string</pre> | null |
| kms_name | The name of the KMS Key that will be created to encrypt the EKS cluster secrets and the EBS of the node groups launch template. This parameter is required when 'kms\_key\_arn' is not provided and must only be used in this case. | <pre>string</pre> | null |
| kms_tags | KMS key unique tags. This map will be merged with the common tags defined in the variable 'var.tags'. Should only be used when 'kms\_key\_arn' is not provided. | <pre>any</pre> | {} |
| [node_groups](#input_node_groups) | Map of node groups that will be attached to the EKS Cluster. | <pre>any</pre> | {} |
| role_regex | Regex to control roles. | <pre>string</pre> | "^(AWSReservedSSO\_)?(Global)?SysOps(\_[0-9a-f]{12,20})?$" |
| security_group_ids | (Required when 'create\_cluster' is 'true') List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane. | <pre>list(string)</pre> | null |
| subnet_ids | (Required when 'create\_cluster' is 'true') List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane. | <pre>list(string)</pre> | null |
| tags | A map of tags to add to all resources. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_access_config"></a> [access\_config](#input\_access\_config)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| authentication_mode | (Optional) The authentication mode for the cluster. Valid values are 'CONFIG\_MAP', 'API' or 'API\_AND\_CONFIG\_MAP'. 'CONFIG\_MAP' cannot be specified when specifying 'var.cluster\_admin\_role', instead, it should be 'API\_AND\_CONFIG\_MAP' or 'API'. | <pre>string</pre> |
| bootstrap_cluster_creator_admin_permissions | (Optional) Whether or not to bootstrap the access config values to the cluster. For existing clusters changing this parameter will FORCE a redeployment. Default is 'true'. | <pre>bool</pre> |

### <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| addon_tags | (Optional) Key-value map of resource tags. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| addon_version | (Optional) The version of the EKS add-on. The version must match one of the versions returned by [describe-addon-versions](https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html). | <pre>string</pre> |
| configuration_values | (Optional) Custom configuration values for addons in HCL format. This map must match the JSON schema derived from [describe-addon-configuration](https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-configuration.html). | <pre>string</pre> |
| preserve | (Optional) Indicates if you want to preserve the created resources when deleting the EKS add-on. | <pre>string</pre> |
| resolve_conflicts_on_create | (Optional) How to resolve field value conflicts when migrating a self-managed add-on to an Amazon EKS add-on. Valid values are NONE and OVERWRITE. | <pre>string</pre> |
| resolve_conflicts_on_update | (Optional) How to resolve field value conflicts for an Amazon EKS add-on if you've changed a value from the Amazon EKS default value. Valid values are NONE, OVERWRITE, and PRESERVE. | <pre>string</pre> |
| service_account_role_arn | (Optional) The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account. The role must be assigned the IAM permissions required by the add-on. If you don't specify an existing IAM role, then the add-on uses the permissions assigned to the node IAM role. For more information, see [Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html) in the Amazon EKS User Guide. | <pre>string</pre> |

### <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| fargate_profile_name | (Required) Name of the EKS Fargate Profile. | <pre>string</pre> |
| fargate_tags | (Optional) Key-value map of resource tags. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| labels | (Optional) Key-value map of Kubernetes labels for selection. | <pre>map(string)</pre> |
| namespace | (Required) Kubernetes namespace for selection. | <pre>string</pre> |
| pod_execution_role_arn | (Required) Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile. | <pre>string</pre> |
| subnet_ids | (Required) Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER\_NAME (where CLUSTER\_NAME is replaced with the name of the EKS Cluster). | <pre>list(string)</pre> |

### <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| capacity_type | (Optional) Type of capacity associated with the EKS Node Group. Valid values: ON\_DEMAND, SPOT. Terraform will only perform drift detection if a configuration value is provided. | <pre>string</pre> |
| container_runtime | (Optional) Kubernetes runtime. Default: containerd. | <pre>string</pre> |
| delete_on_termination | (Optional) Whether the volume should be destroyed on instance termination. | <pre>bool</pre> |
| desired_size | (Required) Desired number of worker nodes. It is important to note that if the node group auto scale up and this property are not aligned, a scale down will be performed, so existing nodes will be deleted. | <pre>number</pre> |
| disk_size | (Required) The size of the volume in gigabytes. | <pre>number</pre> |
| ebs_tags | (Optional) A map of tags to assign to the EBS volumes. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| ec2_ssh_key | (Optional) The key name to use for the instance. | <pre>string</pre> |
| ec2_tags | (Optional) A map of tags to assign to the EC2 instances. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| image_id | (Required) The AMI from which to launch the instance. | <pre>string</pre> |
| instance_types | (Optional) The type of the instance. | <pre>string</pre> |
| iops | (Optional) The amount of provisioned IOPS. This must be set with a volume\_type of "io1/io2/gp3". | <pre>number</pre> |
| kubelet_extra_args | (Optional) Key-value map containing the extra arguments that want to be passed to the kubelet. The key would be the argument name (without '--', this is added in the module when processing the parameters) and the value is the argument value. | <pre>any</pre> |
| labels | (Optional) Key-value map of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed. | <pre>map(string)</pre> |
| lt_description | (Optional) Description of the launch template. | <pre>string</pre> |
| lt_name | (Optional) The name of the launch template. If you leave this blank, Terraform will auto-generate a unique name. | <pre>string</pre> |
| lt_tags | (Optional) Key-value map of resource tags to assign to Launch Template. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| max_pods | (Optional) Maximum number of pods per worker node. This only applies on 'Linux' OS nodes. For 'Windows' nodes, this value is ignored. | <pre>number</pre> |
| max_size | (Required) Maximum number of worker nodes for scaling configuration. | <pre>number</pre> |
| min_size | (Required) Minimum number of worker nodes for scaling configuration. | <pre>number</pre> |
| nic_description | (Optional) Description of the network interface. | <pre>string</pre> |
| node_name | (Optional) Name of the EKS Node Group. If omitted, Terraform will assign a random, unique name. The node group name can't be longer than 63 characters. It must start with a letter or digit, but can also include hyphens and underscores for the remaining characters. | <pre>string</pre> |
| node_role_arn | (Required) Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group. | <pre>string</pre> |
| node_tags | (Optional) Key-value map of resource tags. This map will be merged with the common tags defined in the variable 'var.tags'. | <pre>any</pre> |
| security_group_ids | (Optional) A list of security group IDs to associate to network interface. | <pre>list(string)</pre> |
| subnet_ids | (Required) Identifiers of EC2 Subnets to associate with the EKS Node Group. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER\_NAME (where CLUSTER\_NAME is replaced with the name of the EKS Cluster). | <pre>list(string)</pre> |
| taint | (Optional) The Kubernetes taints to be applied to the nodes in the node group. Maximum of 50 taints per node group. | <pre>list(object({<br/>key=string,<br/>value=string,<br/>effect=string<br/>}))</pre> |
| taint<br/>.effect | (Required) The effect of the taint. Valid values: NO\_SCHEDULE, NO\_EXECUTE, PREFER\_NO\_SCHEDULE. | <pre>string</pre> |
| taint<br/>.key | (Required) The key of the taint. Maximum length of 63. | <pre>string</pre> |
| taint<br/>.value | (Optional) The value of the taint. Maximum length of 63. | <pre>string</pre> |
| update_max_unavailable | (Optional) Desired max number of unavailable worker nodes during node group update. This parameter is mutually exclusive with 'update\_max\_unavailable\_percentage', so both parameters cannot be set together. | <pre>number</pre> |
| update_max_unavailable_percentage | (Optional) Desired max percentage of unavailable worker nodes during node group update. This parameter is mutually exclusive with 'update\_max\_unavailable', so both parameters cannot be set together. | <pre>number</pre> |
| volume_type | (Required) The volume type. Can be `standard`, `gp2`, `gp3`, `io1`, `io2`, `sc1` or `st1` (Default: `gp2`). | <pre>string</pre> |

## Output example

```hcl
aws_kubernetes = {
  "eks_complete" = {
    addon_info = {
      "kube-proxy" = {
        "addon_name" = "kube-proxy"
        "addon_version" = "v1.27.8-eksbuild.1"
        "arn" = "arn:aws:eks:eu-west-1:<aws_account_id>:addon/glnd1airekstest00gene000/kube-proxy/e8c85e1d-2da9-15b6-a68d-ca83c29447bc"
        "cluster_name" = "glnd1airekstest00gene000"
        "configuration_values" = ""
        "created_at" = "2024-07-16T15:47:39Z"
        "id" = "glnd1airekstest00gene000:kube-proxy"
        "modified_at" = "2024-07-16T15:49:47Z"
        "preserve" = false
        "resolve_conflicts" = null
        "resolve_conflicts_on_create" = null
        "resolve_conflicts_on_update" = null
        "service_account_role_arn" = ""
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
      }
      "vpc-cni" = {
        "addon_name" = "vpc-cni"
        "addon_version" = "v1.15.1-eksbuild.1"
        "arn" = "arn:aws:eks:eu-west-1:<aws_account_id>:addon/glnd1airekstest00gene000/vpc-cni/7ac85e1d-2daa-4a0d-9ee6-762109726bae"
        "cluster_name" = "glnd1airekstest00gene000"
        "configuration_values" = ""
        "created_at" = "2024-07-16T15:47:39Z"
        "id" = "glnd1airekstest00gene000:vpc-cni"
        "modified_at" = "2024-07-16T15:49:49Z"
        "preserve" = false
        "resolve_conflicts" = null
        "resolve_conflicts_on_create" = null
        "resolve_conflicts_on_update" = null
        "service_account_role_arn" = ""
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
      }
    }
    cluster_arn = "arn:aws:eks:eu-west-1:<aws_account_id>:cluster/glnd1airekstest00gene000"
    cluster_certificate_authority = {
      "data" = "LS0tLS1CRUdJTiBDRVJUSUZ"
    }
    cluster_endpoint = "https://BEEAFB1E108338E0C450990DE2C8E2B4.gr7.eu-west-1.eks.amazonaws.com"
    cluster_id = "glnd1airekstest00gene000"
    cluster_identity = [
      {
        "oidc" = [
          {
            "issuer" = "https://oidc.eks.eu-west-1.amazonaws.com/id/BEEAFB1E108338E0C450990DE2C8E2B4"
          },
        ]
      },
    ]
    cluster_tlz_admin_token = <sensitive>
    cluster_vpc_config = [
      {
        "cluster_security_group_id" = "sg-03e8032cef33c7f47"
        "endpoint_private_access" = true
        "endpoint_public_access" = false
        "public_access_cidrs" = []
        "security_group_ids" = [
          "sg-0ebcc9156d1a7abfb",
        ]
        "subnet_ids" = [
          "subnet-06d93eb57be4634df",
          "subnet-0ebd98072cc937816",
          "subnet-0edb63d6b37ad5c86",
        ]
        "vpc_id" = "vpc-0f5396eddd0abbb02"
      },
    ]
    fargate_profile_info = {
      "profile1" = {
        "arn" = "arn:aws:eks:eu-west-1:<aws_account_id>:fargateprofile/glnd1airekstest00gene000/glnd1airfgttest00gene001/08c85e1d-2dd8-e855-9f82-4d7d277d5c91"
        "cluster_name" = "glnd1airekstest00gene000"
        "fargate_profile_name" = "glnd1airfgttest00gene001"
        "id" = "glnd1airekstest00gene000:glnd1airfgttest00gene001"
        "pod_execution_role_arn" = "arn:aws:iam::<aws_account_id>:role/testing-gln-fargate-role"
        "selector" = [
          {
            "labels" = null
            "namespace" = "default"
          },
        ]
        "status" = "ACTIVE"
        "subnet_ids" = [
          "subnet-0ebd98072cc937816",
          "subnet-0edb63d6b37ad5c86",
        ]
        "tags" = {
          "environment" = "dev"
          "fargate_test_tag" = "eks_fargate_tag"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "fargate_test_tag" = "eks_fargate_tag"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
      }
      "profile2" = {
        "arn" = "arn:aws:eks:eu-west-1:<aws_account_id>:fargateprofile/glnd1airekstest00gene000/glnd1airfgttest00gene002/ecc85e1f-6586-82ae-5255-744373ea4021"
        "cluster_name" = "glnd1airekstest00gene000"
        "fargate_profile_name" = "glnd1airfgttest00gene002"
        "id" = "glnd1airekstest00gene000:glnd1airfgttest00gene002"
        "pod_execution_role_arn" = "arn:aws:iam::<aws_account_id>:role/testing-gln-fargate-role"
        "selector" = [
          {
            "labels" = null
            "namespace" = "default"
          },
        ]
        "status" = "ACTIVE"
        "subnet_ids" = [
          "subnet-06d93eb57be4634df",
          "subnet-0ebd98072cc937816",
          "subnet-0edb63d6b37ad5c86",
        ]
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
      }
    }
    kms_key_arn = "arn:aws:kms:eu-west-1:<aws_account_id>:key/4cc129c6-70a1-498d-baa9-cd9d381ab308"
    node_groups_info = {
      "node1" = {
        "ami_type" = "CUSTOM"
        "arn" = "arn:aws:eks:eu-west-1:<aws_account_id>:nodegroup/glnd1airekstest00gene000/nodecustomtest05/4ec85e1d-2eed-4871-04db-168956e705a5"
        "capacity_type" = "ON_DEMAND"
        "cluster_name" = "glnd1airekstest00gene000"
        "disk_size" = 0
        "force_update_version" = null
        "id" = "glnd1airekstest00gene000:nodecustomtest05"
        "instance_types" = []
        "labels" = {
          "work_type" = "deep_learning"
        }
        "launch_template" = [
          {
            "id" = "lt-0807a90d30bad8f64"
            "name" = "ltcustomtest05"
            "version" = "1"
          },
        ]
        "node_group_name" = "nodecustomtest05"
        "node_group_name_prefix" = ""
        "node_role_arn" = "arn:aws:iam::<aws_account_id>:role/testing-gln-node-role"
        "release_version" = "<aws_ami_id>"
        "remote_access" = []
        "resources" = [
          {
            "autoscaling_groups" = [
              {
                "name" = "eks-nodecustomtest05-4ec85e1d-2eed-4871-04db-168956e705a5"
              },
            ]
            "remote_access_security_group_id" = ""
          },
        ]
        "scaling_config" = [
          {
            "desired_size" = 1
            "max_size" = 2
            "min_size" = 1
          },
        ]
        "status" = "ACTIVE"
        "subnet_ids" = [
          "subnet-0ebd98072cc937816",
          "subnet-0edb63d6b37ad5c86",
        ]
        "tags" = {
          "eks.amazonaws.com/nodegroup" = "nodecustomtest05"
          "eks.amazonaws.com/nodegroup-image" = "<aws_ami_id>"
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "tags_all" = {
          "eks.amazonaws.com/nodegroup" = "nodecustomtest05"
          "eks.amazonaws.com/nodegroup-image" = "<aws_ami_id>"
          "environment" = "dev"
          "product" = "Gluon EKS"
          "test_tag" = "test_tag"
        }
        "taint" = []
        "timeouts" = {
          "create" = "60m"
          "delete" = "30m"
          "update" = null
        }
        "update_config" = [
          {
            "max_unavailable" = 0
            "max_unavailable_percentage" = 100
          },
        ]
        "version" = "1.27"
      }
    }
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_kubernetes|module.aws_kubernetes|AWS Kubernetes outputs map. <br>[Map AWS Kubernetes Outputs](#AWS Kubernetes Outputs). |
|aws_kubernetes_sensitive|module.aws_kubernetes|AWS Kubernetes Sensitive outputs map. <br>[Map AWS Kubernetes Sensitive Outputs](#AWS Kubernetes Sensitive Outputs). |

<a name="outputs-section"></a>

<a name="AWS Kubernetes Outputs"></a>

### AWS Kubernetes Outputs

| Name | Description | Type |
|------|-------------|------|
| [addon_info](#output_addon_info) | Map with all the addons information. | <pre>module.aws_kubernetes.addon_info</pre> |
| cluster_arn | The Amazon Resource Name (ARN) of the cluster. | <pre>module.aws_kubernetes.cluster_arn</pre> |
| [cluster_certificate_authority](#output_cluster_certificate_authority) | Attribute block containing certificate-authority-data for the cluster.cluster_certificate_authority | <pre>module.aws_kubernetes.cluster_certificate_authority</pre> |
| cluster_endpoint | Endpoint for your Kubernetes API server. | <pre>module.aws_kubernetes.cluster_endpoint</pre> |
| cluster_id | The name/ID of the EKS cluster. Will block on cluster creation until the cluster is really ready. | <pre>module.aws_kubernetes.cluster_id</pre> |
| [cluster_identity](#output_cluster_identity) | Attribute block containing identity provider information for the cluster. Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019. | <pre>module.aws_kubernetes.cluster_identity</pre> |
| [cluster_vpc_config](#output_cluster_vpc_config) | Configuration block argument that also includes attributes for the VPC associated with the cluster. | <pre>module.aws_kubernetes.cluster_vpc_config</pre> |
| [fargate_profile_info](#output_fargate_profile_info) | Map with all the fargate profile information. | <pre>module.aws_kubernetes.fargate_profile_info</pre> |
| kms_key_arn | KMS Key ARN used to encrypt Cluster secrets and EBS Volumes. | <pre>module.aws_kubernetes.kms_key_arn</pre> |
| [node_groups_info](#output_node_groups_info) | Map with all the node group information. | <pre>module.aws_kubernetes.node_groups_info</pre> |

<a name="AWS Kubernetes Sensitive Outputs"></a>

### AWS Kubernetes Sensitive Outputs

| Name | Description | Type |
|------|-------------|------|
| cluster_tlz_admin_token | User token for the initial k8s super admin (the IAM user/role who created the cluster). | <pre>module.aws_kubernetes.cluster_tlz_admin_token</pre> |

### Block Parameters

#### <a name="output_addon_info"></a> [addon\_info](#output\_addon\_info)

| Name | Description | Type |
|------|-------------|------|
| arn | Amazon Resource Name (ARN) of the EKS add-on. | <pre>module.aws_kubernetes.addon_info.arn</pre> |
| id | EKS Cluster name and EKS Addon name separated by a colon (:). | <pre>module.aws_kubernetes.addon_info.id</pre> |
| status | Status of the EKS add-on. | <pre>module.aws_kubernetes.addon_info.status</pre> |
| tags\_all | Key-value map of resource tags, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_kubernetes.addon_info.tags\_all</pre> |

#### <a name="output_cluster_certificate_authority"></a> [cluster\_certificate\_authority](#output\_cluster\_certificate\_authority)

| Name | Description | Type |
|------|-------------|------|
| data | Base64 encoded certificate data required to communicate with the cluster. Add this to the certificate-authority-data section of the kubeconfig file for the cluster. | <pre>module.aws_kubernetes.cluster_certificate_authority.data</pre> |

#### <a name="output_cluster_identity"></a> [cluster\_identity](#output\_cluster\_identity)

| Name | Description | Type |
|------|-------------|------|
| oidc | Nested block containing [OpenID Connect](https://openid.net/connect/) identity provider information for the cluster. | <pre>module.aws_kubernetes.cluster_identity.oidc</pre> |
| oidc<br/>.issuer | Issuer URL for the OpenID Connect identity provider. | <pre>module.aws_kubernetes.cluster_identity.oidc.issuer</pre> |

#### <a name="output_cluster_vpc_config"></a> [cluster\_vpc\_config](#output\_cluster\_vpc\_config)

| Name | Description | Type |
|------|-------------|------|
| cluster\_security\_group\_id | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. | <pre>module.aws_kubernetes.cluster_vpc_config.cluster\_security\_group\_id</pre> |
| vpc\_id | ID of the VPC associated with your cluster. | <pre>module.aws_kubernetes.cluster_vpc_config.vpc\_id</pre> |

#### <a name="output_fargate_profile_info"></a> [fargate\_profile\_info](#output\_fargate\_profile\_info)

| Name | Description | Type |
|------|-------------|------|
| arn | Amazon Resource Name (ARN) of the EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.arn</pre> |
| cluster\_name | Name of the EKS Cluster. | <pre>module.aws_kubernetes.fargate_profile_info.cluster_name</pre> |
| fargate\_profile\_name | Name of the EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.fargate_profile_name</pre> |
| id | EKS Cluster name and EKS Fargate Profile name separated by a colon (:). | <pre>module.aws_kubernetes.fargate_profile_info.id</pre> |
| pod\_execution\_role\_arn | Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.pod_execution_role_arn</pre> |
| selector | Configuration block(s) for selecting Kubernetes Pods to execute with this EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.selector</pre> |
| status | Status of the EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.status</pre> |
| subnet\_ids | Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.subnet_ids</pre> |
| tags | Key-value map of resource tags. | <pre>module.aws_kubernetes.fargate_profile_info.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_kubernetes.fargate_profile_info.tags_all</pre> |
| timeouts | The timeouts set on create, update and delete operations for EKS Fargate Profile. | <pre>module.aws_kubernetes.fargate_profile_info.timeouts</pre> |

#### <a name="output_node_groups_info"></a> [node\_groups\_info](#output\_node\_groups\_info)

| Name | Description | Type |
|------|-------------|------|
| ami\_type | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.ami_type</pre> |
| arn | Amazon Resource Name (ARN) of the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.arn</pre> |
| capacity\_type | Type of capacity associated with the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.capacity_type</pre> |
| cluster\_name | Name of the EKS Cluster. | <pre>module.aws_kubernetes.node_groups_info.cluster_name</pre> |
| disk\_size | Disk size in GiB for worker nodes. | <pre>module.aws_kubernetes.node_groups_info.disk_size</pre> |
| force\_update\_version | Force version update if existing pods are unable to be drained due to a pod disruption budget issue. | <pre>module.aws_kubernetes.node_groups_info.force_update_version</pre> |
| id | EKS Cluster name and EKS Node Group name separated by a colon (:). | <pre>module.aws_kubernetes.node_groups_info.id</pre> |
| instance\_types | List of instance types associated with the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.instance_types</pre> |
| labels | Key-value map of Kubernetes labels. | <pre>module.aws_kubernetes.node_groups_info.labels</pre> |
| launch\_template | Configuration block with Launch Template settings. | <pre>module.aws_kubernetes.node_groups_info.launch_template</pre> |
| node\_group\_name | Name of the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.node_group_name</pre> |
| node\_group\_name\_prefix | Unique name beginning with the specified prefix. | <pre>module.aws_kubernetes.node_groups_info.node_group_name_prefix</pre> |
| node\_role\_arn | Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.node_role_arn</pre> |
| release\_version | AMI version of the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.release_version</pre> |
| remote\_access | Configuration block with remote access settings. | <pre>module.aws_kubernetes.node_groups_info.remote_access</pre> |
| resources | List of objects containing information about autoscaling groups and remote access security group. | <pre>module.aws_kubernetes.node_groups_info.resources</pre> |
| scaling\_config | Configuration block with scaling settings. | <pre>module.aws_kubernetes.node_groups_info.scaling_config</pre> |
| status | Status of the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.status</pre> |
| subnet\_ids | Identifiers of EC2 Subnets to associate with the EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.subnet_ids</pre> |
| tags | Key-value map of resource tags. | <pre>module.aws_kubernetes.node_groups_info.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_kubernetes.node_groups_info.tags_all</pre> |
| taint | The Kubernetes taints to be applied to the nodes in the node group. | <pre>module.aws_kubernetes.node_groups_info.taint</pre> |
| timeouts | The timeouts set on create, update and delete operations for EKS Node Group. | <pre>module.aws_kubernetes.node_groups_info.timeouts</pre> |
| update\_config | Configuration block with update settings. | <pre>module.aws_kubernetes.node_groups_info.update_config</pre> |
| version | Kubernetes version. | <pre>module.aws_kubernetes.node_groups_info.version</pre> |

## Known Issues

### At deployment time of this terraform archetype

|Error|Description|Workaround|
|--|:-|--|
| Error updating EKS Cluster (xxxx) version: InvalidParameterException: Nodegroups xxx must be updated to match cluster version 1.19 before updating cluster version. | :warning:This happens because EKS does not allow the control plane to have more than one version ahead of data plane nodes. | Not yet implemented. |
| NodeCreationFailure: Instances failed to join the kubernetes cluster | :warning:This can happen due to several reasons:<ul><li>There is no connectivity between the worker nodes and the control plane. Note that launching EKS in private mode will link the Kubernetes API endpoint domain with local private IPs to your VPC.</li><li>The node groups do not have an IAM role or the one assigned to them does not have the necessary permissions to generate Kubernetes credentials. </li></ul>| <ul><li>If there is no connectivity between the worker nodes and the control plane please check Security Groups, NACLs, network routes, etc. </li><li>Give the necessary permissions to generate Kubernetes credentials (see the *AmazonEKSWorkerNodePolicy* policy in the prerequisites section). </li></ul> |
| Error: AsgInstanceLaunchFailures: Instance became unhealthy while waiting for instance to be in InService state | :warning:This will happen if the precondition that allows the *autoscaling.amazonaws.com* service linked role to encrypt EBS volumes with the KMS key passed to the module is not met; in this case, you will notice that the ASG terminates and starts new instances continuously, and such EC2 nodes will never reach the *Running* state, they will always go from *Pending* to *Shutting-down/Terminated*. | Not yet implemented. |
| Error: InsufficientFreeAddresses | :warning:This happens due Amazon AutoScaling was unable to launch instances because there are not enough free addresses in the subnet associated with your AutoScaling group (s). | Not yet implemented. |

### At deployment time of kubernetes applications

|Error|Description|Workaround|
|--|:-|--|
|Error: ErrImagePull - Failed to pull image - ImagePullBackOff |:warning:This happens when there is no network connectivity with the image repository (Harbour, ECR...). | <ul><li>If you are using ECR, make sure of you have ECR vpc endpoints (see prerequisites section) </li><li>If you are using a corporate Harbour, make sure of you have the needed firewall rules (contact with Protect). Please note that from SLZ accounts you will not have direct Internet connectivity, so this error is common when trying to deploy samples or third-party applications that reference public image registries (eg: DockerHub, ArtifactHub, ECR/ACR/Helm public repositories, etc.) </li></ul> |
