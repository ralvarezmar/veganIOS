# AWS Elastic Container Registry

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- VPC
    - If you want to access ECR repository to download Docker images from your VPC you need to add these endpoints:
        - ```com.amazonaws.eu-west-1.ecr.api```
        - ```com.amazonaws.eu-west-1.ecr.dkr```
        - ```com.amazonaws.eu-west-1.ecr.s3``` (Gateway)
        - ```com.amazonaws.eu-west-1.ecr.sts```
    - On-Premise CI/CD Pipeline must be able to map ECR domain names to private IPs inside VPC Endpoint:
        - Option 1: Pipeline must have the ability to modify his /etc/hosts file.
        - Option 2: Provide a local DNS server that might have specific rules for specific domain names.
        - Option 3: Is docker container is used to run the pipeline, you can add the following parameter: ```--add-host```.
        - Option 4 (Analysis in progress): we are investigating how to make that corporative DNS overrides the domain resolution for shared ECR.

### Recommendations

This archetype has some guidelines that you must follow in order to avoid problems:

- Repository Tag Mutability: The input 'repository_image_tag_mutability' is `IMMUTABLE` by default, you only need to use the `MUTABLE` option when your CI/CD workflow uses the `latest` tag strategy.

- Authentication against ECR service: It is useful that you install [amazon-ecr-credential-helper](https://github.com/awslabs/amazon-ecr-credential-helper) to refresh authentication tokens automatically.

- KMS encryption: If you create the repository and specify KMS encryption type you will need to grant permissions to AWS Services that will use this KMS Key to decrypt repository images. [See documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-services.html).

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_containerregistry = {
  "00_ecr_sa" = {
    #   --------------------------------------
    #   Tagging
    #   --------------------------------------
    tags = {
      product     = "Gluon AWS Container Registry"
      environment = "dev"
      project     = "Gluon"
    }

    #   --------------------------------------
    #   Naming
    #   --------------------------------------
    name = "glnd1weuecrglobaltest001"

    #   --------------------------------------
    #   Security Level
    #   --------------------------------------
    security_level             = "sa"
    repository_encryption_type = "KMS"
    repository_kms_key         = "<repository_kms_key>"
  },

  "01_ecr_complete" = {
    #--------------------------------------
    # Tagging
    #--------------------------------------
    tags = {
      product     = "Gluon AWS Container Registry"
      environment = "dev"
      project     = "Gluon"
    }

    #--------------------------------------
    # Naming
    #--------------------------------------
    name = "glnd1weuecrglobaltest031"

    #--------------------------------------
    # Security Level
    #--------------------------------------
    security_level = "sm"

    #--------------------------------------
    # Repository Policy
    #--------------------------------------
    allow_pull_from_current_account          = true
    allow_pull_from_current_account_services = true

    read_only_access_enabled    = true
    read_only_access_principals = ["arn:aws:iam::<aws_account_id>:root"]
    read_only_conditions = [{
      test     = "ForAnyValue:StringLike"
      variable = "aws:sourceArn"
      value    = ["arn:aws:*:*:<aws_account_id>:*"]
    }]

    full_access_enabled    = true
    full_access_principals = ["arn:aws:iam::<aws_account_id>:root"]
    full_access_conditions = [{
      test     = "ForAnyValue:StringLike"
      variable = "aws:sourceArn"
      value    = ["arn:aws:*:*:<aws_account_id>:*"]
    }]

    repository_policy_statements = {
      "BlockPullFromNotAllowedAccounts" = {
        effect = "Deny"
        principals = {
          type = "Service"
          identifiers = [
            "lambda.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "ecs.amazonaws.com",
            "eks.amazonaws.com",
            "eks-nodegroup.amazonaws.com",
            "eks-fargate.amazonaws.com",
            "elasticbeanstalk.amazonaws.com",
            "emr-containers.amazonaws.com",
            "sagemaker.amazonaws.com"
          ]
        }
        actions = [
          "ecr:*"
        ]
        condition = {
          test     = "ForAllValues:StringNotLike"
          variable = "aws:sourceArn"
          values   = ["arn:aws:*:*:<aws_account_id>:*", "arn:aws:*:*:<aws_account_id>:*"]
        }
      }
    }

    #--------------------------------------
    # Lifecycle Policy
    #--------------------------------------
    repository_lifecycle_policy = {
      "rules" : [
        {
          "rulePriority" : 2,
          "description" : "Expire tagged images older than 14 days",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["v"],
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 14
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| name | Name of the repository. | string |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| allowed_ip_addresses | List of IP's that are allowed to access to the repository. | any | [] |
| allowed_vpc_endpoints | List of the VPC Endpoints ID's that are allowed to access private repository. | any | [] |
| allow_pull_from_current_account | Determines if you want allow image pull from current AWS account. | bool | false |
| allow_pull_from_current_account_services | Determines if you want allow image pull from services in the current AWS account. | bool | false |
| enforce_push_from_private_nets | Determines if you want allow connections just from IPs specified in `allowed_ip_addresses`. If this value is true, `allowed_ip_addresses` could not be empty. | bool | false |
| full_access_conditions | List of condition objects for full access repository policy. | any | [] |
| full_access_enabled | Determines if you want allow full access for some AWS principals (full_access_principals and full_access_conditions). If this value is true, `full_access_principals` must be provided. | bool | false |
| full_access_principals | Principal ARNs to provide with full access to the ECR. | any | [] |
| read_only_conditions | List of condition objects for readonly access repository policy. | any | [] |
| read_only_access_enabled | Determines if you want allow read only access for some AWS principals (read_only_access_principals and read_only_conditions). If this value is true, `read_only_access_principals` or `allow_pull_from_current_account` must be provided. | bool | false |
| read_only_access_principals | Principal ARNs to provide with readonly access to the ECR. | any | [] |
| repository_encryption_<br>type | The encryption type for the repository. Must be one of: `KMS` or `AES256`. | string | "AES256" |
| repository_image_<br>tag_mutability | The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. See [recommendations](#recommendations). | string | null |
| repository_kms_key | The ARN of the KMS key to use when encryption_type is `KMS`. | string | null |
| repository_lifecycle_policy | The policy document (in HCL format). You could find more details about [Lifecycle Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) at the official AWS docs. | any | {} |
| [repository_policy_<br>statements](#input_repository_policy_statements) | The statements that will be added to repository policy. | any | {} |
| security_level | Security level of this ECR repository (sm or sa), for cmek active is necessary define security\_level in sa. (Possible values: sa or sm). | string | "sm" |
| tags | Map of tags to assign to the container. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | any | {} |

## Block Parameters

<a name="input_repository_policy_statements"></a>

#### <a name="input_repository_policy_statements"></a> [repository policy statements](#input\_repository\_policy\_statements)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| actions | (Optional) List of actions that this statement either allows or denies. For example, ['ec2:RunInstances', 's3:*']. | list |
| condition | (Required) A condition constrains whether a statement applies in a particular situation. Conditions can be specific to an AWS service. | object |
| condition.test | (Required) Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate. | string |
| condition.values | (Required) Values to evaluate the condition against. If multiple values are provided, the condition matches if at least one of them applies. That is, AWS evaluates multiple values as though using an 'OR' boolean operation. | string |
| condition.variable | (Required) Name of a [Context Variable](http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html#AvailableKeys) to apply the condition to. Context variables may either be standard AWS variables starting with aws: or service-specific variables prefixed with the service name. | string |
| effect | (Optional) Whether this statement allows or denies the given actions. Valid values are Allow and Deny. Defaults to Allow. | string |
| principals | (Required) The principals argument define to whom a statement applies or does not apply, respectively. You can see more information [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html). | object |
| principals.identifiers | (Required) The identifier that we are going to deny or allow access to the resource. | list |
| principals.type | (Required) The type of principal identifier that we are going to deny or allow access to the resource. | string |

## Output example

```hcl
aws_containerregistry = {
  "00_ecr_sa" = {
    "repository_arn" = "arn:aws:ecr:***:***:repository/glnd1airecrtest00gene020"
    "repository_lifecycle_policy" = {
      "rules" = [
        {
          "action" = {
            "type" = "expire"
          }
          "description" = "Expire images older than 1 day"
          "rulePriority" = 1
          "selection" = {
            "countNumber" = 1
            "countType" = "sinceImagePushed"
            "countUnit" = "days"
            "tagStatus" = "untagged"
          }
        },
      ]
    }
    "repository_name" = "glnd1airecrtest00gene020"
    "repository_url" = "***.dkr.ecr.***.amazonaws.com/glnd1airecrtest00gene020"
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_containerregistry|module.aws_containerregistry|AWS Container Registry outputs map. <br>[Map AWS Container Registry Outputs](#AWS Container Registry Outputs). |

<a name="outputs-section"></a>

<a name="AWS Container Registry Outputs"></a>

### AWS Container Registry Outputs

| Name| Output value | Description |
|:--|:--|:--|
| repository_arn | module.aws_containerregistry.repository_arn |Full ARN of the repository. |
| repository_name | module.aws_containerregistry.repository_name |The name of the repository. |
| repository_url | module.aws_containerregistry.repository_url |The URL of the repository. |
| [repository_lifecycle_policy](#output_repository_lifecycle_policy) | module.aws_containerregistry.repository_lifecycle_policy |The lifecycle policy for the repository. |

### Block Parameters

#### <a name="output_repository_lifecycle_policy"></a> [repository\_lifecycle\_policy](#output\_repository\_lifecycle\_policy)

| Name | Output Value | Description |
|:--|:--|:--|
| action |  module.aws_containerregistry.repository_lifecycle_policy.action | Specify an action type. |
| description | module.aws_containerregistry.repository_lifecycle_policy.description | Describes the purpose of a rule within a lifecycle policy. |
| rulePriority | module.aws_containerregistry.repository_lifecycle_policy.rulePriority | Sets the order in which rules are applied, lowest to highest. |
| selection |  module.aws_containerregistry.repository_lifecycle_policy.selection | Block selection the specify detailed conditions for selecting resources based on tags. |
| selection.countNumber | module.aws_containerregistry.repository_lifecycle_policy.selection.countNumber | Specify a count number. |
| selection.countType | module.aws_containerregistry.repository_lifecycle_policy.selection.countType | If countType is set to imageCountMoreThan, you also specify countNumber to create a rule that sets a limit on the number of images that exist in your repository. |  
| selection.countUnit | module.aws_containerregistry.repository_lifecycle_policy.selection.countUnit | Specify a count unit of days to indicate that as the unit of time, in addition to countNumber, which is the number of days. |
| selection.tagPrefixList | module.aws_containerregistry.repository_lifecycle_policy.selection.tagPrefixList | Only used if you specified "tagStatus": "tagged" and you aren't specifying a tagPatternList. |  
| selection.tagStatus | module.aws_containerregistry.repository_lifecycle_policy.selection.tagStatus | Determines whether the lifecycle policy rule that you are adding specifies a tag for an image. |  
| tagPatternList | module.aws_containerregistry.repository_lifecycle_policy.tagPatternList | When creating a lifecycle policy for tagged images, it's best practice to use a tagPatternList to specify the tags to expire. |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
| Your authorization token has expired. (Push / Pull Operations) | This happens because your token has expired. | `aws ecr get-login-password --region <AWS_REGION> --profile= \| docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com`. |
|  The image tag 'latest' already exists in the 'my-repo-name' repository and cannot be overwritten because the repository is immutable. (Push Operation) | This happens when tag mutability is set to false and you are using "tag latest workflow". | Disable tag mutability at repository level <b>(Not Recommended)</b>, change the CI/CD workflow of your project <b>(Recommended)</b> to not use latest tags, always have to reference the version of the tag you want to deploy. |
| <ul><li>docker CLI: EOF message after multiple retries.</li><li>container docker compatible CLIs: failed to do request: Post "https://<ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/v2//blobs/uploads/": EOF</li></ul> (Push Operation) | This happens when you are using public endpoint and private network policy of repository is active. | You must update your push workflow to use VPC Endpoint. |
| <ul><li>docker CLI: EOF message after multiple retries.</li><li>container docker compatible CLIs: HTTP 403 (Forbidden) codes, or message "no basic auth credentials", or message "failed to do request: Get <https://'ACCOUNT_ID'.dkr.ecr.'AWS_REGION'.amazonaws.com/v2/blobs/uploads/>: EOF"</li></ul> (Push / Pull Operations) | This happens when you do not have permissions to push/pull in this repository. | Contact to repository maintainer and request for permissions. |
