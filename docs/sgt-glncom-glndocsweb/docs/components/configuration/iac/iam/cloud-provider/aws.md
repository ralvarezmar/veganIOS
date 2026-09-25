# AWS IAM

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

No additional prerequisites are needed. You should only have an AWS account.

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_iam = {
  eks_cluster = {
    role_name        = "EKSClusterRole"
    role_description = "EKS cluster role"

    # -------------------
    # Role data
    # -------------------
    service_acronym = "eks" # eks.amazonaws.com
    aws_policies    = ["AmazonEKSClusterPolicy"]

    # -------------------
    # Tags
    # -------------------
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
    }

    # -------------------
    # Custom policy data
    # -------------------
    create_custom_policy      = true
    custom_policy_name        = "EKSClusterPolicy"
    custom_policy_description = "Custom EKS cluster policy"
    # Following placeholder values should be filled in policies/eks_cluster_policy.json file
    # <aws_region>, <aws_account_id>, <aws_kms_key_id>
    # This is an example policy
    custom_policy_filename    = "policies/eks_cluster_policy.json"
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| role_name | Name of the IAM role. | <pre>string</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| assume_role_arn | ARN for the assume role policy for IAM role. One of `service_acronym`, `service_account`, `assume_role_arn`, `custom_assume_role_policy`. | <pre>string</pre> | "" |
| aws_policies | List of AWS managed policies to attach. | <pre>list(string)</pre> | [] |
| create_custom_policy | Determines if the IAM custom policy role will be created. | <pre>bool</pre> | false |
| create_role | Determines if the IAM role will be created. | <pre>bool</pre> | true |
| custom_assume_role_policy | Custom Assume Role policy JSON. One of `service_acronym`, `service_account`, `assume_role_arn`, `custom_assume_role_policy`. | <pre>string</pre> | "" |
| custom_policy_description | Description for the new custom policy to attach. | <pre>string</pre> | "" |
| custom_policy_filename | File name for custom policy included in this module. One of `custom_policy_filename`, `custom_policy_json_content`. | <pre>string</pre> | "" |
| custom_policy_json_content | Custom json content for custom policy. One of `custom_policy_filename`, `custom_policy_json_content`. | <pre>string</pre> | "" |
| custom_policy_name | Name for the new custom policy to attach. If `custom_policy_filename` or `custom_policy_json_content` is set. | <pre>string</pre> | "" |
| custom_policy_path | Path for the new custom policy to attach. | <pre>string</pre> | "/" |
| existing_policies_arns | List of existing custom policies to attach. | <pre>list(string)</pre> | [] |
| permissions_boundary | Name of the boundary IAM policy. | <pre>string</pre> | "" |
| policy_tags | Policy extra tags. This map will be merged with the common tags defined in the variable var.tags. | <pre>map(string)</pre> | {} |
| role_description | Description of the IAM role. | <pre>string</pre> | "" |
| role_path | Path of the IAM role. | <pre>string</pre> | "/" |
| role_tags | Role extra tags. This map will be merged with the common tags defined in the variable var.tags. | <pre>map(string)</pre> | {} |
| service_account | Service account for IAM role. One of `service_acronym`, `service_account`, `assume_role_arn`, `custom_assume_role_policy`. | <pre>string</pre> | "" |
| service_acronym | Service module acronym for IAM role. Possible values are: `api`, `amq`, `bch`, `acm`, `clt`, `aas`, `ecr`, `emr`, `ses`, `ec2`, `agl`, `far`, `as3`, `dyn`, `lam`, `rds`, `rdo`, `eks`, `ecs`, `cst`, `cac`, `elb`, `qst`, `apa`, `kds`, `kfh`, `efs`, `vfl`, `acw` and `fsx`. | <pre>string</pre> | "" |
| tags | Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>any</pre> | {} |

### Service identifiers catalog

| Acronym | Service name |
|------|-------------|
|`api`|apigateway.amazonaws.com|
|`amq`|mq.amazonaws.com|
|`bch`|batch.amazonaws.com|
|`acm`|acm.amazonaws.com|
|`clt`|cloudtrail.amazonaws.com|
|`aas`|autoscaling.amazonaws.com|
|`ecr`|ecr.amazonaws.com|
|`emr`|elasticmapreduce.amazonaws.com|
|`ses`|ses.amazonaws.com|
|`ec2`|ec2.amazonaws.com|
|`agl`|glue.amazonaws.com|
|`far`|eks-fargate.amazonaws.com|
|`as3`|s3.amazonaws.com|
|`dyn`|dynamodb.amazonaws.com|
|`lam`|lambda.amazonaws.com|
|`rds`|rds.amazonaws.com|
|`rdo`|rds.amazonaws.com|
|`eks`|eks.amazonaws.com|
|`ecs`|ecs.amazonaws.com|
|`cst`|ecs-tasks.amazonaws.com|
|`cac`|elasticache.amazonaws.com|
|`elb`|elasticloadbalancing.amazonaws.com|
|`qst`|quicksight.amazonaws.com|
|`apa`|application-autoscaling.amazonaws.com|
|`kds`|kinesis.amazonaws.com|
|`kfh`|firehose.amazonaws.com|
|`efs`|elasticfilesystem.amazonaws.com|
|`vfl`|vpc-flow-logs.amazonaws.com|
|`acw`|logs.amazonaws.com|
|`fsx`|fsx.amazonaws.com|

## Output example

```hcl
aws_iam = {
  "eks_cluster" = {
    "instance_profile_role" = ""
    "policy_arn" = {
      "custom_policy_arn" = "arn:aws:iam::<aws_account_id>:policy/EKSClusterPolicy"
    }
    "role_arn" = "arn:aws:iam::<aws_account_id>:role/EKSClusterRole"
    "role_name" = "EKSClusterRole"
  }
}

```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_iam|module.aws_iam|AWS IAM outputs map. <br>[Map AWS IAM Outputs](#AWS IAM Outputs). |

<a name="outputs-section"></a>

<a name="AWS IAM Outputs"></a>

### AWS IAM Outputs

| Name | Description | Type |
|------|-------------|------|
| instance_profile_role | Amazon Resource Name (ARN) specifying the instance profile role. | <pre>aws_iam_instance_profile.this.arn</pre> |
| policy_arn | The ARN assigned by AWS to this policy. | <pre>aws_iam_policy.custom.arn</pre> |
| role_arn | Amazon Resource Name (ARN) specifying the role created as part of the module. If empty, the module didn't create the role, it was an existing one. | <pre>aws_iam_role.this.arn</pre> |
| role_name | Name of the role. | <pre>aws_iam_role.this.name</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
