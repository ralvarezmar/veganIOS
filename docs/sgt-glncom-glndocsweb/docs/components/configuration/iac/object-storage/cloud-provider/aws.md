# AWS S3

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

To deploy the module, the following requirements must be met:

- KMS key deployed in the same region where the bucket is created. (Only for security level 'sa')
- A lambda function for the S3 notifications. (Optional)
- A SNS topic for the S3 notifications. (Optional)
- A SQS queue for the S3 notifications. (Optional)
- A replication IAM role. (Optional, if not provided it will be created with the module)
- VPC endpoint for S3.

!!! warning

    If an existing role wants to be used for the S3 replication, this existing replication role must have an existing replication policy attached with, at least, the following permissions granted for the S3 replication to work properly, since the module does not create yet this replication policy for existing roles:
    <ul>
    <li>Allow 's3:GetReplicationConfiguration', 's3:ListBucket', 's3:GetObjectVersionForReplication', 's3:GetObjectVersionAcl', 's3:GetObjectVersionTagging' for the S3 bucket that wants to be created with the module.
    <li>Allow 's3:ReplicateObject', 's3:ReplicateDelete', 's3:ReplicateTags', 's3:ObjectOwnerOverrideToBucketOwner' for the S3 bucket/s included in the replication rules.
    </ul>

    If 'as3_security_level' is set as 'sa', another policy with, at least, the following permissions granted must also be attached to the existing replication role:
    <ul>
    <li>Allow 'kms:Decrypt' for the KMS key used to encrypt the S3 bucket created with the module.
    <li>Allow 'kms:Encrypt' for the KMS key/s used to encrypt the S3 bucket/s included in the replication rules.
    </ul>

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_objectstorage = {
  as3_default = {
    bucket_name = "glnd1weuas3globaltest001"

    tags = {
      product     = "Gluon AWS S3"
      environment = "dev"
      project     = "Gluon"
    }

    force_destroy            = true
    log_bucket_force_destroy = true
  }

  as3_full = {
    bucket_name = "glnd1weuas3globaltest002"

    tags = {
      product     = "Gluon AWS S3"
      environment = "dev"
      project     = "Gluon"
    }

    security_level = "sa"
    force_destroy  = true

    // SSE
    kms_key_arn        = "arn:aws:kms:eu-west-1:<aws_account_id>:key/0588da8c-7482-4f37-aec8-b6430ac79edf"
    bucket_key_enabled = false

    // versioning
    versioning = "Enabled"

    // logging
    log_bucket_name          = "gln-global-test-log-bucket"
    log_bucket_acl           = "log-delivery-write"
    log_bucket_ownership     = "ObjectWriter"
    log_bucket_force_destroy = true

    // lifecycle main bucket
    transition_lifecycle_rule_enabled  = true
    transition_lifecycle_rule_prefix   = "test"
    noncurrent_version_transition_days = 31
    standard_transition_days           = 31
    glacier_transition_days            = 61

    expiration_lifecycle_rule_enabled  = true
    expiration_lifecycle_rule_prefix   = "foo"
    noncurrent_version_expiration_days = 180
    expiration_days                    = 151

    // lifecycle log bucket
    log_bucket_transition_lifecycle_rule_enabled = true
    log_bucket_transition_lifecycle_rule_prefix  = "logs"
    log_bucket_standard_transition_days          = 31
    log_bucket_glacier_transition_days           = 70

    log_bucket_expiration_lifecycle_rule_enabled = true
    log_bucket_expiration_lifecycle_rule_prefix  = "logs"
    log_bucket_expiration_days                   = 200

    // acl
    log_bucket_ownership = "ObjectWriter"
    bucket_grants = [{
      id          = "<aws_user_id>"
      type        = "CanonicalUser"
      permissions = ["READ"]
      uri         = ""
    }]

    // object lock
    object_lock_enabled = true
    object_lock_rule_default_retention = {
      mode = "COMPLIANCE"
      days = 7
    }

    // additional policies
    bucket_statements_policy = <<EOF
    {
      "Statement": [
          {
              "Sid": "",
              "Effect": "Deny",
              "Principal": {
                  "AWS": "*"
              },
              "Action": "s3:*",
              "Resource": "arn:aws:s3:::glnd1weuas3globaltest002/*",
              "Condition": {
                  "Bool": {
                      "aws:SecureTransport": "false"
                  }
              }
          }
      ]
    }
    EOF

    // acceleration
    acceleration_status = "Enabled"

    // intelligent tiering
    intelligent_tiering = {
      EntireBucket = {
        tiering = [
          { access_tier = "ARCHIVE_ACCESS", days = 125 },
          { access_tier = "DEEP_ARCHIVE_ACCESS", days = 180 },
        ]
      }
      ImportantBlueDocuments = {
        prefix = "documents/"
        tags = {
          priority = "high"
          class    = "blue"
        }
        tiering = [
          { access_tier = "ARCHIVE_ACCESS", days = 125 },
        ]
      }
    }

    // inventory
    inventory = {
      MinimalExample = {
        included_object_versions = "All"
        schedule_frequency       = "Weekly"
        destination = {
          format     = "CSV"
          bucket_arn = "arn:aws:s3:::glnd1weuas3globaltest002"
        }
      }
      CompleteExample = {
        included_object_versions = "Current"
        schedule_frequency       = "Daily"
        destination = {
          format      = "Parquet"
          bucket_arn  = "arn:aws:s3:::glnd1weuas3globaltest002"
          prefix      = "custom-prefix"
          kms_key_arn = "arn:aws:kms:eu-west-1:<aws_account_id>:key/0588da8c-7482-4f37-aec8-b6430ac79edf"
        }
        filter_prefix   = "foo/"
        optional_fields = ["Size", "LastModifiedDate"]
      }
    }

    // metrics
    metrics = {
      EntireBucket = {
      }
      ImportantBlueDocuments = {
        prefix = "documents/"
        tags = {
          priority = "high"
          class    = "blue"
        }
      }
    }

    // notifications
    notifications = {
      eventbridge_enabled = true
      lambda_function = {
        LambdaEntireBucket = {
          arn    = "arn:aws:lambda:eu-west-1:<aws_account_id>:function:glnd1airlamas3t01gene002"
          events = ["s3:ObjectCreated:Put"]
        }
        LambdaFilterPrefixSuffix = {
          arn           = "arn:aws:lambda:eu-west-1:<aws_account_id>:function:glnd1airlamas3t01gene002"
          events        = ["s3:ObjectCreated:Copy", "s3:ObjectRemoved:*"]
          filter_prefix = "foo/"
          filter_suffix = ".txt"
        }
      }
      sqs_queue = {
        SQSEntireBucket = {
          arn    = "arn:aws:sqs:eu-west-1:<aws_account_id>:glnd1airsqsas3t01gene002"
          events = ["s3:ObjectCreated:Post"]
        }
      }
      sns_topic = {
        SNSFilterPrefixSuffix = {
          arn           = "arn:aws:sns:eu-west-1:<aws_account_id>:glnd1airsnsas3t01gene002"
          events        = ["s3:ObjectCreated:CompleteMultipartUpload"]
          filter_prefix = "foo/"
          filter_suffix = ".txt"
        }
      }
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| bucket_name | Name of the bucket. Must be lowercase and less than or equal to 63 characters in length. The name must not be in the format [bucket_name]--[azid]--x-s3. Changing this, forces a new resource to be created. | string |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| acceleration_status | The transfer acceleration state of the bucket. Valid values: `Enabled`, `Suspended`. If not set, acceleration will not be configured. | string | null |
| bucket_acl | The canned ACL to apply to main bucket. Cannot be specified with `var.bucket_object_ownership` == `BucketOwnerEnforced` (default), which disables ACLs. Valid values are `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, and `log-delivery-write`. | string | null |
| [bucket_grants](#input_bucket_grants) | List of maps containing with each list element containing a map with type, id and permissions/uri keys: [{'type':'', 'id':'', 'permissions':''},]. Cannot be specified with `var.bucket_object_ownership` == `BucketOwnerEnforced` (default), which disables ACLs. | list(any) | [] |
| bucket_key<br>_enabled | Whether or not to use Amazon S3 Bucket Keys for SSE-KMS. | bool | true |
| bucket_ownership | Object ownership. Valid values: `BucketOwnerEnforced`, `ObjectWriter` or `BucketOwnerPreferred`.<br>-`BucketOwnerEnforced`: The bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket, so `var.s3_bucket_acl` must be null.<br>-`ObjectWriter`: The uploading account will own the object if the object is uploaded with the `bucket-owner-full-control` canned ACL.<br>-`BucketOwnerPreferred`: Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the `bucket-owner-full-control` canned ACL. | string | "BucketOwnerEnforced" |
| bucket_owner | The ID of the bucket owner. Used only with grants. Defaults to the current user. | string | null |
| bucket_<br>statements_<br>policy | A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws\_iam\_policy\_document, in the form that designates a principal, can be used. | string | null |
| [custom_lifecycle<br>_rules](#input_custom_lifecycle_rules) | Custom S3 Lifecycle configuration rules. | any | {} |
| expiration_days | Lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer. | number | 90 |
| expiration_<br>lifecycle_<br>rule_enabled | If true, the expiration lifecycle rule will be enabled. | bool | false |
| expiration_<br>lifecycle_<br>rule_prefix | Prefix identifying one or more objects to which the expiration rule applies. | string | "" |
| force_destroy | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation. | bool | false |
| glacier_transition_<br>days | Number of days after creation when objects are transitioned to the glacier storage tier. The value must be a positive integer. Valid values depend on storage\_class, see [Transition objects using Amazon S3 Lifecycle for more details](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html). | number | 60 |
| [intelligent_tiering](#input_intelligent_tiering) | Map of S3 Intelligent-Tiering configuration objects, keyed by the configuration name. | any | {} |
| [inventory](#input_inventory) | Map of S3 Inventory configuration objects, keyed by the configuration name. | any | {} |
| inventory_<br>source_<br>accounts_ids | Only relevant if the bucket is the destination of the S3 Inventory. A list of IDs of AWS accounts containing source buckets from which inventory reports are generated. If not specified, defaults to the current AWS account. | set(string) | null |
| inventory_<br>source_<br>buckets_arns | Only relevant if the bucket is the destination of the S3 Inventory. A list of ARNs of buckets from which inventory reports are generated. | set(string) | [] |
| kms_key_arn | The ARN of the KMS Key used for the SSE-KMS encryption. Required for security level 'sa'. | string | null |
| log_bucket_acl | The canned ACL to apply to log bucket. Cannot be specified with `var.bucket_log_object_ownership` == `BucketOwnerEnforced` (default), which disables ACLs. If not `null`, a bucket policy granting permissions to the logging service <b>WILL NOT BE CREATED</b>. Valid values are `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, and `log-delivery-write`. | string | null |
| log_bucket_<br>expiration_days | Lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer. | number | 360 |
| log_bucket_<br>expiration_<br>lifecycle_<br>rule_enabled | If true, the expiration lifecycle rule for the log bucket will be enabled. | bool | true |
| log_bucket_<br>expiration_<br>lifecycle_<br>rule_prefix | Prefix identifying one or more objects to which the expiration rule applies. | string | "" |
| log_bucket_force_destroy | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation. | bool | false |
| log_bucket_<br>glacier_<br>transition_days | Number of days after creation when objects are transitioned to the glacier storage tier. The value must be a positive integer. Valid values depend on storage\_class, see [Transition objects using Amazon S3 Lifecycle for more details](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html). | number | 120 |
| log_bucket_name | The name of the bucket that will receive the log objects. Must be lowercase and less than or equal to 63 characters in length. The name must not be in the format [bucket_name]--[azid]--x-s3. Changing this, forces a new resource to be created. | string | "" |
| log_bucket_ownership | Object ownership. Valid values: `BucketOwnerEnforced`, `ObjectWriter` or `BucketOwnerPreferred`.<br>-`BucketOwnerEnforced`: The bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket, so `var.s3_bucket_acl` must be null.<br>-`ObjectWriter`: The uploading account will own the object if the object is uploaded with the `bucket-owner-full-control` canned ACL.<br>-`BucketOwnerPreferred`: Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the `bucket-owner-full-control` canned ACL. | string | "BucketOwnerEnforced" |
| log_bucket_<br>standard_<br>transition_days | Number of days after creation when objects are transitioned from the standard storage tier to the infrequent access storage tier. The value must be a positive integer. Valid values depend on storage\_class, see [Transition objects using Amazon S3 Lifecycle for more details](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html). | number | 30 |
| log_bucket_<br>transition_<br>lifecycle_<br>rule_enabled | If true, the transition lifecycle rule for the log bucket will be enabled. | bool | true |
| log_bucket_<br>transition_<br>lifecycle_<br>rule_prefix | Prefix identifying one or more objects to which the transition rule applies. | string | "" |
| [metrics](#input_metrics) | Map of S3 metrics configuration objects, keyed by the configuration name. Metrics can be either collected for all objects in the bucket or filtered by a prefix, tags, or a logical AND of prefix and tags. | any | {} |
| noncurrent_<br>version_<br>expiration_days | Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer. | number | 90 |
| noncurrent_<br>version_<br>transition_days | Number of days an object is noncurrent before Amazon S3 can perform the associated action. | number | 30 |
| [notifications](#input_notifications) | Object describing S3 notifications configuration. | any | {} |
| object_lock<br>_enabled | Boolean to enable object lock | bool | true |
| [object_lock_rule_<br>default_retention](#input_object_lock_rule_default_retention) | Block specifying the default Object Lock retention settings for new objects placed in the bucket. Required if `object_lock_enabled` is true (due to provider issue). Once the issue is resolved, it will be optional. See: <https://github.com/hashicorp/terraform-provider-aws/issues/25070> | any | null |
| object_lock_token | A token to:<br>- allow Object Lock to be enabled for an existing bucket<br>- allow replication to be enabled on an Object Lock-enabled bucket<br>You must contact AWS support for the bucket's \"Object Lock token\"." | string | null |
| replication_enabled | Whether to enable S3 replication. | bool | false |
| replication_iam<br>_role | Name of externally created IAM role used for replication purposes. IAM policies required for replication will be attached to this role. | string | null |
| [replication_rules](#input_replication_rules) | Map of S3 replication rule objects, keyed by the configuration name. Both source and destination buckets must have versioning enabled. If the source bucket has S3 Object Lock enabled, the destination buckets must also have S3 Object Lock enabled. | any | {} |
| replication_source<br>_cross_account<br>_iam_roles | Only relevant if the bucket is the destination of cross-account S3 replication. A list of IAM roles ARNs which are used for S3 replication from another AWS account. | set(string) | [] |
| role_description | Description of the IAM role created for the replication when created as part of the module. | string | "" |
| role_path | Path of the IAM role, when created as part of the module, for example for S3 replication (for SLZ>=3.6 must be '/service-role/'). | string | "/" |
| role_permissions_<br>boundary | Name of the boundary IAM policy used by the role when created as part of the module. | string | "" |
| role_policy_<br>name_suffix | Custom suffix for the custom policies when created as part of the module, for example for S3 replication (for SLZ>=3.6 must be '\_policy'). | string | "" |
| role_policy_path | Path for the custom policies when created as part of the module, for example for S3 replication (for SLZ>=3.6 must be '/custom-service-role/'). | string | "/" |
| security_level | Security level of this bucket s3 (sm or sa), for CMEK active is necessary to set this attribute as 'sa'. (Possible values: sa or sm). | string | "sm" |
| standard_<br>transition_<br>days | Number of days after creation when objects are transitioned from the standard storage tier to the infrequent access storage tier. The value must be a positive integer. Valid values depend on storage\_class, see [Transition objects using Amazon S3 Lifecycle for more details](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html). | number | 30 |
| tags | A map of tags to assign to the resource. This map is a merged structure between custom tags and standard tags. | any | {} |
| transition_lifecycle<br>_rule_enabled | If true, the transition lifecycle rule will be enabled. | bool | false |
| transition_lifecycle<br>_rule_prefix | Prefix identifying one or more objects to which the transition rule applies. | string | "" |
| versioning | Versioning state of the bucket. One of: `Enabled`, `Suspended`, or `Disabled`.<br>For migrating existing bucket:<br>- created with provider `< v3.70.0` and with versioning disabled: it should be `Suspended`<br>- created with provider `< v3.70.0` and with versioning enabled: it should be `Enabled`<br>- created with provider `>= v3.70.0` and with versioning disabled and bucket versioning was never enabled: it should be `Disabled`.<br>- created with provider `>= v3.70.0` and with versioning disabled and bucket versioning enabled at one point: it should be `Suspended`<br>- created with provider `>= v3.70.0` and with versioning enabled: it should be `Enabled`<br>See this [link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning#versioning_configuration). | string | "Enabled" |

## Block Parameters

#### <a name="input_bucket_grants"></a> [bucket\_grants](#input\_bucket\_grants)

```hcl
list(any)
```

| Name | Description | Type |
|------|-------------|------|
| id | (Optional) The canonical user ID of the grantee. | string |
| permissions | (Required) List of logging permissions assigned to the grantee for the bucket. | list(string) |
| type | (Required) Type of grantee. Valid values: `CanonicalUser`, `AmazonCustomerByEmail`, `Group`. | string |
| uri | (Optional) URI of the grantee group. | string |

#### <a name="input_custom_lifecycle_rules"></a> [custom\_lifecycle\_rules](#input\_custom\_lifecycle\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| abort_incomplete_multipart_upload_days | (Optional) Specifies the days since the initiation of an incomplete multipart upload that Amazon S3 will wait before permanently removing all parts of the upload. | number |
| expiration_days | (Optional) Specifies the expiration for the lifecycle of the object in the form of days. The value must be a non-zero positive integer. :warning: We strongly recommend to use this custom expiration rule or the standard lifecycle rule that can be created with the variable 'expiration\_lifecycle\_rule\_enabled' but not both, if possible. Keep in mind that apply several expiration rules for the same prefix (or the entire bucket) but with different expiration days, may inccur in extra costs if the minimum duration that an object must have in a certain storage class is not met. For more information, [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-expire-general-considerations.html#lifecycle-expire-minimum-storage) you can find it. | number |
| expired_object_delete_marker | (Optional) Conflicts with 'expiration\_days'. Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired; if set to false the policy takes no action. | bool |
| filter | (Optional) Configuration block used to identify objects that a Lifecycle Rule applies to. Must be specified with exactly one of prefix, tag, and, object\_size\_greater\_than or object\_size\_less\_than specified. If not specified, the filter will be the entire bucket. | map(object) |
| filter<br/>.and | (Optional) Configuration block used to apply a logical AND to two or more predicates. The Lifecycle Rule will apply to any object matching all the predicates configured inside the and block. | map(object) |
| filter<br/>.and<br/>.object_size_greater_than | (Optional) Minimum object size to which the rule applies. Value must be at least 0 if specified. | number |
| filter<br/>.and<br/>.object_size_less_than | (Optional) Maximum object size to which the rule applies. Value must be at least 1 if specified. | number |
| filter<br/>.and<br/>.prefix | (Optional) Prefix identifying one or more objects to which the rule applies. | string |
| filter<br/>.and<br/>.tags | (Optional) Key-value map of resource tags. All of these tags must exist in the object's tag set in order for the rule to apply. | map(string) |
| filter<br/>.object_size_greater_than | (Optional) Minimum object size (in bytes) to which the rule applies. | number |
| filter<br/>.object_size_less_than | (Optional) Maximum object size (in bytes) to which the rule applies. | number |
| filter<br/>.prefix | (Optional) Prefix identifying one or more objects to which the rule applies. Defaults to an empty string ("") if not specified. | string |
| filter<br/>.tag_key | (Required if 'filter.tag\_value' wants to be set) Name of the object key. | string |
| filter<br/>.tag_value | (Required if 'filter.tag\_key' wants to be set) Value of the tag. | string |
| noncurrent_version_expiration_days | (Required if 'noncurrent\_version\_expiration' wants to be set) Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer. | number |
| noncurrent_version_expiration_newer | (Optional) Number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer. | bool |
| noncurrent_version_transition | (Optional) Set of configuration blocks that specify the transition rule for the lifecycle rule that describes when noncurrent objects transition to a specific storage class. | list(object) |
| noncurrent_version_transition<br/>.newer_noncurrent_versions | (Optional) Number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer. | number |
| noncurrent_version_transition<br/>.noncurrent_days | (Required if 'noncurrent\_version\_transition' wants to be set) Number of days an object is noncurrent before Amazon S3 can perform the associated action. | number |
| noncurrent_version_transition<br/>.storage_class | (Required if 'noncurrent\_version\_transition' wants to be set) Class of storage used to store the object. Valid Values: GLACIER, STANDARD\_IA, ONEZONE\_IA, INTELLIGENT\_TIERING, DEEP\_ARCHIVE, GLACIER\_IR. | string |
| rule_name | (Required) Unique identifier for the rule. The value cannot be longer than 255 characters. | string |
| status | (Required) Whether the rule is currently being applied. Valid values: Enabled or Disabled. | string |
| transition | (Optional) Set of configuration blocks that specify when an Amazon S3 object transitions to a specified storage class. :warning: We strongly recommend to use these custom transition rules or the standard lifecycle rule that can be created with the variable 'transition\_lifecycle\_rule\_enabled' but not both, if possible. Keep in mind that apply several transition rules for the same prefix (or the entire bucket) to the same storage class but with different transition days, may inccur in extra costs if the minimum duration between storage classes is not met. For more information, [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html) you can find it. | list(object) |
| transition<br/>.days | (Required if 'transition' wants to be set) Number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer. Valid values depend on storage\_class, see [Transition objects using Amazon S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html) for more details. | number |
| transition<br/>.storage_class | (Required if 'transition' wants to be set) Class of storage used to store the object. Valid Values: GLACIER, STANDARD\_IA, ONEZONE\_IA, INTELLIGENT\_TIERING, DEEP\_ARCHIVE, GLACIER\_IR. | string |

#### <a name="input_intelligent_tiering"></a> [intelligent\_tiering](#input\_intelligent\_tiering)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| prefix | (Optional) An object key name prefix that identifies the subset of objects to which the configuration applies. | string |
| tags | (Optional) All of these tags must exist in the object's tag set in order for the configuration to apply. | map(string) |
| tiering | (Required) The S3 Intelligent-Tiering storage class tiers of the configuration. At least one must be specified. | list(object) |
| tiering<br/>.access_tier | (Required) S3 Intelligent-Tiering access tier. Valid values: `ARCHIVE_ACCESS`, `DEEP_ARCHIVE_ACCESS`. | string |
| tiering<br/>.days | (Required)  The number of consecutive days of no access after which an object will be eligible to be transitioned to the corresponding tier. | number |

#### <a name="input_inventory"></a> [inventory](#input\_inventory)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| destination | (Required) Contains information about where to publish the inventory results. | object |
| destination<br/>.bucket_arn | (Required) The ARN of the destination S3 bucket. You can safely use the same destination bucket for multiple inventory configurations. | string |
| destination<br/>.format | (Required) Specifies the output format of the inventory results. Can be `CSV`, `ORC` or `Parquet`. | string |
| destination<br/>.kms_key_arn | (Optional) Required if `as3_security_level` of the destination bucket is `sa`. The ARN of the KMS key for the destination bucket to encrypt the inventory file. | string |
| destination<br/>.prefix | (Optional) The prefix that is prepended to all inventory results. See this [link](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-inventory-location.html) for details. | string |
| filter_prefix | (Optional) Specifies an inventory filter. The inventory only includes objects with given prefix. | string |
| included_object_versions | (Required) Object versions to include in the inventory list. Valid values: `All`, `Current`. | string |
| optional_fields | (Optional) List of optional fields that are included in the inventory results. Valid values: `Size`, `LastModifiedDate`, `StorageClass`, `ETag`, `IsMultipartUploaded`, `ReplicationStatus`, `EncryptionStatus`, `ObjectLockRetainUntilDate`, `ObjectLockMode`, `ObjectLockLegalHoldStatus`, `IntelligentTieringAccessTier`, `BucketKeyStatus`, `ChecksumAlgorithm`. See this [link](https://docs.aws.amazon.com/AmazonS3/latest/API/API_InventoryConfiguration.html#AmazonS3-Type-InventoryConfiguration-OptionalFields) for details. | list(string) |
| schedule_frequency | (Required) Specifies how frequently inventory results are produced. Valid values: `Daily`, `Weekly`. | string |

#### <a name="input_metrics"></a> [metrics](#input\_metrics)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| prefix | (Optional) An object key name prefix that identifies the subset of objects to which the configuration applies. If both `prefix` and `tags` are specified, the configuration applies only to objects that satisfy both conditions. | string |
| tags | (Optional) All of these tags must exist in the object's tag set in order for the configuration to apply. Max 10 tags are supported. If both `prefix` and `tags` are specified, the configuration applies only to objects that satisfy both conditions. | map(string) |

#### <a name="input_notifications"></a> [notifications](#input\_notifications)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| eventbridge_enabled | (Optional) Whether to enable Amazon EventBridge notifications. | bool |
| lambda_function | (Optional) Map of Lambda Function notification configuration objects, keyed by the unique configuration name. | map(object) |
| lambda_function<br/>.arn | (Required) Lambda function ARN. | string |
| lambda_function<br/>.events | (Required) Events for which to send notifications. Event types must be unique across rules: two rules cannot share the same event type. See: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/notification-how-to-event-types-and-destinations.html#supported-notification-event-types> | set(string) |
| lambda_function<br/>.filter_prefix | (Optional) Object key name prefix. Filters must be unique across rules: prefixes cannot overlap in two rules if the suffixes are overlapping for the same event type. | string |
| lambda_function<br/>.filter_suffix | (Optional) Object key name suffix. Filters must be unique across rules: suffixes cannot overlap in two rules if the prefixes are overlapping for the same event type. | string |
| sns_topic | (Optional) Map of SNS Topic notification configuration objects, keyed by the unique configuration name. | map(object) |
| sns_topic<br/>.arn | (Required) SNS topic ARN. | string |
| sns_topic<br/>.events | (Required) Events for which to send notifications. Event types must be unique across rules: two rules cannot share the same event type. See: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/notification-how-to-event-types-and-destinations.html#supported-notification-event-types> | set(string) |
| sns_topic<br/>.filter_prefix | (Optional) Object key name prefix. Filters must be unique across rules: prefixes cannot overlap in two rules if the suffixes are overlapping for the same event type. | string |
| sns_topic<br/>.filter_suffix | (Optional) Object key name suffix. Filters must be unique across rules: suffixes cannot overlap in two rules if the prefixes are overlapping for the same event type. | string |
| sqs_queue | (Optional) Map of SQS Queue notification configuration objects, keyed by the unique configuration name. | map(object) |
| sqs_queue<br/>.arn | (Required) SQS queue ARN. | string |
| sqs_queue<br/>.events | (Required) Events for which to send notifications. Event types must be unique across rules: two rules cannot share the same event type. See: <https://docs.aws.amazon.com/AmazonS3/latest/userguide/notification-how-to-event-types-and-destinations.html#supported-notification-event-types> | set(string) |
| sqs_queue<br/>.filter_prefix | (Optional) Object key name prefix. Filters must be unique across rules: prefixes cannot overlap in two rules if the suffixes are overlapping for the same event type. | string |
| sqs_queue<br/>.filter_suffix | (Optional) Object key name suffix. Filters must be unique across rules: suffixes cannot overlap in two rules if the prefixes are overlapping for the same event type. | string |

#### <a name="input_object_lock_rule_default_retention"></a> [object\_lock\_rule\_default\_retention](#input\_object\_lock\_rule\_default\_retention)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| days | (Optional) The number of days that you want to specify for the default retention period. Required if `years` is not specified. Conflicts with `years`. | number |
| mode | (Required) The default Object Lock retention mode you want to apply to new objects placed in the specified bucket. Valid values: `COMPLIANCE`, `GOVERNANCE`. | string |
| years | (Optional) The number of years that you want to specify for the default retention period. Required if `days` is not specified. Conflicts with `days`. | number |

#### <a name="input_replication_rules"></a> [replication\_rules](#input\_replication\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| delete_marker_replication | (Optional) Whether delete markers should be replicated. Note: delete marker replication is not supported for tag-based replication rules. Default: false. | bool |
| destination | (Required) Specifies the destination for the rule. | object |
| destination<br/>.bucket_arn | (Required) The ARN of the S3 bucket where you want Amazon S3 to store replicas of the objects identified by the rule. | string |
| destination<br/>.kms_key_arn | (Optional) Required if `as3_security_level` is `sa`. The ARN of the KMS key for the destination bucket. The destination KMS key must be valid and must be created in the same region as the destination S3 bucket. | string |
| destination<br/>.region | (Optional) The region of the S3 bucket (and KMS key, if used). Default: source bucket region. | string |
| destination<br/>.replica_owner_account_id | (Optional) If specified, replicated objects ownership is changed to the given AWS account. This must be the same account that owns the destination bucket. | string |
| destination<br/>.storage_class | (Optional) The storage class used to store the object. By default, Amazon S3 uses the storage class of the source object to create the object replica. | string |
| filter_prefix | (Optional) An object key name prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length. If both `filter_prefix` and `filter_tags` are specified, the rule applies only to objects that satisfy both conditions. | string |
| filter_tags | (Optional) A map of tags (key and value pairs) that identifies a subset of objects to which the rule applies. The rule applies only to objects having all the tags in its tagset. If both `filter_prefix` and `filter_tags` are specified, the rule applies only to objects that satisfy both conditions. | map(string) |
| metrics_enabled | (Optional) Whether the Destination Metrics should be enabled. Default: true. | bool |
| priority | (Required) The priority associated with the rule. If there are two or more conflicting rules with the same destination bucket, then objects are replicated according to the rule with the highest priority. The higher the number, the higher the priority. | number |
| replica_modifications_sync | (Optional) Whether to replicate object metadata changes made to the replica copies back to the source object (only viable in case of bidirectional replication). Default: false. | bool |
| replication_time_control | (Optional) Whether S3 Replication Time Control should be enabled. Default: false. | bool |

## Output example

```hcl
aws_objectstorage = {
  "as3_default" = {
    "bucket_accelerate_configuration" = "Disabled"
    "bucket_acl" = []
    "bucket_arn" = "arn:aws:s3:::glnd1weuas3globaltest016"
    "bucket_domain_name" = "glnd1weuas3globaltest016.s3.amazonaws.com"
    "bucket_encryption_configuration" = {
      "bucket" = "glnd1weuas3globaltest016"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016"
      "rule" = [
        {
          "apply_server_side_encryption_by_default" = [
            {
              "kms_master_key_id" = ""
              "sse_algorithm" = "AES256"
            },
          ]
          "bucket_key_enabled" = true
        },
      ]
    }
    "bucket_id" = "glnd1weuas3globaltest016"
    "bucket_info" = {
      "acceleration_status" = "Disabled"
      "acl" = []
      "arn" = "arn:aws:s3:::glnd1weuas3globaltest016"
      "bucket" = "glnd1weuas3globaltest016"
      "bucket_domain_name" = "glnd1weuas3globaltest016.s3.amazonaws.com"
      "bucket_prefix" = ""
      "bucket_regional_domain_name" = "glnd1weuas3globaltest016.s3.***.amazonaws.com"
      "cors_rule" = []
      "force_destroy" = true
      "hosted_zone_id" = "Z1BKCTXD74EZPE"
      "id" = "glnd1weuas3globaltest016"
      "lifecycle_rule" = {
        "bucket" = "glnd1weuas3globaltest016"
        "expected_bucket_owner" = ""
        "id" = "glnd1weuas3globaltest016"
        "rule" = [
          {
            "abort_incomplete_multipart_upload" = []
            "expiration" = []
            "filter" = [
              {
                "and" = []
                "object_size_greater_than" = ""
                "object_size_less_than" = ""
                "prefix" = ""
                "tag" = []
              },
            ]
            "id" = "glnd1weuas3globaltest016-transition-rule"
            "noncurrent_version_expiration" = []
            "noncurrent_version_transition" = [
              {
                "newer_noncurrent_versions" = ""
                "noncurrent_days" = 30
                "storage_class" = "GLACIER"
              },
            ]
            "prefix" = ""
            "status" = "Disabled"
            "transition" = [
              {
                "date" = ""
                "days" = 30
                "storage_class" = "STANDARD_IA"
              },
              {
                "date" = ""
                "days" = 60
                "storage_class" = "GLACIER"
              },
            ]
          },
          {
            "abort_incomplete_multipart_upload" = []
            "expiration" = [
              {
                "date" = ""
                "days" = 150
                "expired_object_delete_marker" = false
              },
            ]
            "filter" = [
              {
                "and" = []
                "object_size_greater_than" = ""
                "object_size_less_than" = ""
                "prefix" = ""
                "tag" = []
              },
            ]
            "id" = "glnd1weuas3globaltest016-expiration-rule"
            "noncurrent_version_expiration" = [
              {
                "newer_noncurrent_versions" = ""
                "noncurrent_days" = 120
              },
            ]
            "noncurrent_version_transition" = []
            "prefix" = ""
            "status" = "Disabled"
            "transition" = []
          },
        ]
        "timeouts" = null /* object */
      }
      "object_lock_configuration" = [
        {
          "object_lock_enabled" = "Enabled"
          "rule" = []
        },
      ]
      "object_lock_enabled" = true
      "policy" = "{\"Id\":\"IaCAS3DefaultPolicy\",\"Statement\":[{\"Action\":\"s3:*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"false\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016/*\",\"Sid\":\"s3_bucket_ssl_requests_only_rule\"}],\"Version\":\"2012-10-17\"}"
      "region" = "***"
      "replication_configuration" = []
      "server_side_encryption_configuration" = {
        "bucket" = "glnd1weuas3globaltest016"
        "expected_bucket_owner" = ""
        "id" = "glnd1weuas3globaltest016"
        "rule" = [
          {
            "apply_server_side_encryption_by_default" = [
              {
                "kms_master_key_id" = ""
                "sse_algorithm" = "AES256"
              },
            ]
            "bucket_key_enabled" = true
          },
        ]
      }
      "tags" = {
        "environment" = "dev"
        "product" = "Gluon AWS S3"
        "project" = "Gluon"
      }
      "tags_all" = {
        "environment" = "dev"
        "product" = "Gluon AWS S3"
        "project" = "Gluon"
      }
      "timeouts" = null /* object */
      "versioning" = {
        "bucket" = "glnd1weuas3globaltest016"
        "expected_bucket_owner" = ""
        "id" = "glnd1weuas3globaltest016"
        "mfa" = null
        "versioning_configuration" = [
          {
            "mfa_delete" = ""
            "status" = "Enabled"
          },
        ]
      }
      "website" = []
    }
    "bucket_intelligent_tiering_configuration" = {}
    "bucket_inventory_configuration" = {}
    "bucket_lambda_permission" = {}
    "bucket_lifecycle_configuration" = {
      "bucket" = "glnd1weuas3globaltest016"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016"
      "rule" = [
        {
          "abort_incomplete_multipart_upload" = []
          "expiration" = []
          "filter" = [
            {
              "and" = []
              "object_size_greater_than" = ""
              "object_size_less_than" = ""
              "prefix" = ""
              "tag" = []
            },
          ]
          "id" = "glnd1weuas3globaltest016-transition-rule"
          "noncurrent_version_expiration" = []
          "noncurrent_version_transition" = [
            {
              "newer_noncurrent_versions" = ""
              "noncurrent_days" = 30
              "storage_class" = "GLACIER"
            },
          ]
          "prefix" = ""
          "status" = "Disabled"
          "transition" = [
            {
              "date" = ""
              "days" = 30
              "storage_class" = "STANDARD_IA"
            },
            {
              "date" = ""
              "days" = 60
              "storage_class" = "GLACIER"
            },
          ]
        },
        {
          "abort_incomplete_multipart_upload" = []
          "expiration" = [
            {
              "date" = ""
              "days" = 150
              "expired_object_delete_marker" = false
            },
          ]
          "filter" = [
            {
              "and" = []
              "object_size_greater_than" = ""
              "object_size_less_than" = ""
              "prefix" = ""
              "tag" = []
            },
          ]
          "id" = "glnd1weuas3globaltest016-expiration-rule"
          "noncurrent_version_expiration" = [
            {
              "newer_noncurrent_versions" = ""
              "noncurrent_days" = 120
            },
          ]
          "noncurrent_version_transition" = []
          "prefix" = ""
          "status" = "Disabled"
          "transition" = []
        },
      ]
      "timeouts" = null /* object */
    }
    "bucket_logging" = {
      "bucket" = "glnd1weuas3globaltest016"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016"
      "target_bucket" = "glnd1weuas3globaltest016-log"
      "target_grant" = []
      "target_object_key_format" = []
      "target_prefix" = "log/"
    }
    "bucket_metric_configuration" = {}
    "bucket_notification_configuration" = []
    "bucket_ownership_controls" = {
      "bucket" = "glnd1weuas3globaltest016"
      "id" = "glnd1weuas3globaltest016"
      "rule" = [
        {
          "object_ownership" = "BucketOwnerEnforced"
        },
      ]
    }
    "bucket_policy" = {
      "bucket" = "glnd1weuas3globaltest016"
      "id" = "glnd1weuas3globaltest016"
      "policy" = "{\"Id\":\"IaCAS3DefaultPolicy\",\"Statement\":[{\"Action\":\"s3:*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"false\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016/*\",\"Sid\":\"s3_bucket_ssl_requests_only_rule\"}],\"Version\":\"2012-10-17\"}"
    }
    "bucket_public_access_block" = {
      "glnd1weuas3globaltest016" = {
        "block_public_acls" = true
        "block_public_policy" = true
        "bucket" = "glnd1weuas3globaltest016"
        "id" = "glnd1weuas3globaltest016"
        "ignore_public_acls" = true
        "restrict_public_buckets" = true
      }
      "glnd1weuas3globaltest016-log" = {
        "block_public_acls" = true
        "block_public_policy" = true
        "bucket" = "glnd1weuas3globaltest016-log"
        "id" = "glnd1weuas3globaltest016-log"
        "ignore_public_acls" = true
        "restrict_public_buckets" = true
      }
    }
    "bucket_region" = "***"
    "bucket_replication_role_arn" = null
    "bucket_versioning" = {
      "bucket" = "glnd1weuas3globaltest016"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016"
      "mfa" = null
      "versioning_configuration" = [
        {
          "mfa_delete" = ""
          "status" = "Enabled"
        },
      ]
    }
    "log_bucket_acl" = []
    "log_bucket_encryption_configuration" = {
      "bucket" = "glnd1weuas3globaltest016-log"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016-log"
      "rule" = [
        {
          "apply_server_side_encryption_by_default" = [
            {
              "kms_master_key_id" = ""
              "sse_algorithm" = "AES256"
            },
          ]
          "bucket_key_enabled" = true
        },
      ]
    }
    "log_bucket_id" = "glnd1weuas3globaltest016-log"
    "log_bucket_info" = {
      "acl" = []
      "arn" = "arn:aws:s3:::glnd1weuas3globaltest016-log"
      "bucket" = "glnd1weuas3globaltest016-log"
      "bucket_domain_name" = "glnd1weuas3globaltest016-log.s3.amazonaws.com"
      "bucket_prefix" = ""
      "bucket_regional_domain_name" = "glnd1weuas3globaltest016-log.s3.***.amazonaws.com"
      "cors_rule" = []
      "force_destroy" = true
      "hosted_zone_id" = "Z1BKCTXD74EZPE"
      "id" = "glnd1weuas3globaltest016-log"
      "lifecycle_rule" = {
        "bucket" = "glnd1weuas3globaltest016-log"
        "expected_bucket_owner" = ""
        "id" = "glnd1weuas3globaltest016-log"
        "rule" = [
          {
            "abort_incomplete_multipart_upload" = []
            "expiration" = []
            "filter" = [
              {
                "and" = []
                "object_size_greater_than" = ""
                "object_size_less_than" = ""
                "prefix" = ""
                "tag" = []
              },
            ]
            "id" = "glnd1weuas3globaltest016-log-transition-rule"
            "noncurrent_version_expiration" = []
            "noncurrent_version_transition" = []
            "prefix" = ""
            "status" = "Enabled"
            "transition" = [
              {
                "date" = ""
                "days" = 120
                "storage_class" = "GLACIER"
              },
              {
                "date" = ""
                "days" = 30
                "storage_class" = "STANDARD_IA"
              },
            ]
          },
          {
            "abort_incomplete_multipart_upload" = []
            "expiration" = [
              {
                "date" = ""
                "days" = 360
                "expired_object_delete_marker" = false
              },
            ]
            "filter" = [
              {
                "and" = []
                "object_size_greater_than" = ""
                "object_size_less_than" = ""
                "prefix" = ""
                "tag" = []
              },
            ]
            "id" = "glnd1weuas3globaltest016-log-expiration-rule"
            "noncurrent_version_expiration" = []
            "noncurrent_version_transition" = []
            "prefix" = ""
            "status" = "Enabled"
            "transition" = []
          },
        ]
        "timeouts" = null /* object */
      }
      "logging" = []
      "object_lock_configuration" = []
      "object_lock_enabled" = false
      "policy" = "{\"Id\":\"IaCAS3DefaultPolicy\",\"Statement\":[{\"Action\":\"s3:*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"false\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"s3_bucket_ssl_requests_only_rule\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"ArnLike\":{\"aws:SourceArn\":\"arn:aws:s3:::glnd1weuas3globaltest016\"},\"StringEquals\":{\"aws:SourceAccount\":\"***\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"logging.s3.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"S3ServerAccessLogsPolicy\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"ArnNotLike\":{\"aws:SourceArn\":\"arn:aws:s3:::glnd1weuas3globaltest016\"},\"StringNotEquals\":{\"aws:SourceAccount\":\"***\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"S3ServerDenyAccessLogsPolicy\"}],\"Version\":\"2012-10-17\"}"
      "region" = "***"
      "replication_configuration" = []
      "server_side_encryption_configuration" = {
        "bucket" = "glnd1weuas3globaltest016-log"
        "expected_bucket_owner" = ""
        "id" = "glnd1weuas3globaltest016-log"
        "rule" = [
          {
            "apply_server_side_encryption_by_default" = [
              {
                "kms_master_key_id" = ""
                "sse_algorithm" = "AES256"
              },
            ]
            "bucket_key_enabled" = true
          },
        ]
      }
      "tags" = {
        "environment" = "dev"
        "product" = "Gluon AWS S3"
        "project" = "Gluon"
      }
      "tags_all" = {
        "environment" = "dev"
        "product" = "Gluon AWS S3"
        "project" = "Gluon"
      }
      "timeouts" = null /* object */
      "versioning" = [
        {
          "enabled" = false
          "mfa_delete" = false
        },
      ]
      "website" = []
    }
    "log_bucket_lifecycle_configuration" = {
      "bucket" = "glnd1weuas3globaltest016-log"
      "expected_bucket_owner" = ""
      "id" = "glnd1weuas3globaltest016-log"
      "rule" = [
        {
          "abort_incomplete_multipart_upload" = []
          "expiration" = []
          "filter" = [
            {
              "and" = []
              "object_size_greater_than" = ""
              "object_size_less_than" = ""
              "prefix" = ""
              "tag" = []
            },
          ]
          "id" = "glnd1weuas3globaltest016-log-transition-rule"
          "noncurrent_version_expiration" = []
          "noncurrent_version_transition" = []
          "prefix" = ""
          "status" = "Enabled"
          "transition" = [
            {
              "date" = ""
              "days" = 120
              "storage_class" = "GLACIER"
            },
            {
              "date" = ""
              "days" = 30
              "storage_class" = "STANDARD_IA"
            },
          ]
        },
        {
          "abort_incomplete_multipart_upload" = []
          "expiration" = [
            {
              "date" = ""
              "days" = 360
              "expired_object_delete_marker" = false
            },
          ]
          "filter" = [
            {
              "and" = []
              "object_size_greater_than" = ""
              "object_size_less_than" = ""
              "prefix" = ""
              "tag" = []
            },
          ]
          "id" = "glnd1weuas3globaltest016-log-expiration-rule"
          "noncurrent_version_expiration" = []
          "noncurrent_version_transition" = []
          "prefix" = ""
          "status" = "Enabled"
          "transition" = []
        },
      ]
      "timeouts" = null /* object */
    }
    "log_bucket_ownership_controls" = {
      "bucket" = "glnd1weuas3globaltest016-log"
      "id" = "glnd1weuas3globaltest016-log"
      "rule" = [
        {
          "object_ownership" = "BucketOwnerEnforced"
        },
      ]
    }
    "log_bucket_policy" = {
      "bucket" = "glnd1weuas3globaltest016-log"
      "id" = "glnd1weuas3globaltest016-log"
      "policy" = "{\"Id\":\"IaCAS3DefaultPolicy\",\"Statement\":[{\"Action\":\"s3:*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"false\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"s3_bucket_ssl_requests_only_rule\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"ArnLike\":{\"aws:SourceArn\":\"arn:aws:s3:::glnd1weuas3globaltest016\"},\"StringEquals\":{\"aws:SourceAccount\":\"***\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"logging.s3.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"S3ServerAccessLogsPolicy\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"ArnNotLike\":{\"aws:SourceArn\":\"arn:aws:s3:::glnd1weuas3globaltest016\"},\"StringNotEquals\":{\"aws:SourceAccount\":\"***\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:s3:::glnd1weuas3globaltest016-log/*\",\"Sid\":\"S3ServerDenyAccessLogsPolicy\"}],\"Version\":\"2012-10-17\"}"
    }
  }
}
```

## Outputs list

| Name | Output value | Description |
|------|--------------|-------------|
| aws_objectstorage | module.aws_objectstorage | AWS Object Storage outputs map. <br> [Map AWS Object Storage Outputs](#outputs-section) |

<a name="outputs-section"></a>

### AWS Object Storage Outputs

| Name | Description | Type |
|------|-------------|------|
| bucket_accelerate_configuration | Accelerate configuration status of the bucket. | module.aws_objectstorage<br>.bucket_accelerate_configuration |
| bucket_acl | Access Control List configuration applied to the Main bucket. | module.aws_objectstorage<br>.bucket_acl |
| bucket_arn | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. | module.aws_objectstorage<br>.bucket_arn |
| bucket_domain_name | The bucket domain name. Will be of format bucketname.s3.amazonaws.com | module.aws_objectstorage<br>.bucket_domain_name |
| bucket_encryption_configuration | Encryption configuration applied to the Main bucket. | module.aws_objectstorage<br>.bucket_encryption_configuration |
| bucket_id | The name of the bucket. | module.aws_objectstorage<br>.bucket_id |
| [bucket_info](#output_bucket_info) | Map with all the S3 Bucket information. | module.aws_objectstorage<br>.bucket_info |
| bucket_intelligent_tiering_configuration | Intelligent Tiering configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_intelligent_tiering_configuration |
| [bucket_inventory_configuration](#output_bucket_inventory_configuration) | Inventory configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_inventory_configuration |
| bucket_lambda_permission | Lambda permissions configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_lambda_permission |
| bucket_lifecycle_configuration | Lifecycle configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_lifecycle_configuration |
| bucket_logging | Logging configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_logging |
| bucket_metric_configuration | Metric configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_metric_configuration |
| bucket_notification_configuration | Notification configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_notification_configuration |
| bucket_ownership_controls | Ownership Control configuration applied to the Main bucket. | module.aws_objectstorage<br>.bucket_ownership_controls |
| bucket_policy | Policy applied to the Main bucket. | module.aws_objectstorage<br>.bucket_policy |
| bucket_public_access_block | Public Access Block configuration applied to the bucket. | module.aws_objectstorage<br>.bucket_public_access_block |
| bucket_region | The AWS region this bucket resides in. | module.aws_objectstorage<br>.bucket_region |
| bucket_replication_role_arn | Replication IAM role ARN | module.aws_objectstorage<br>.bucket_replication_role_arn |
| bucket_versioning | Versioning configuration of the bucket. | module.aws_objectstorage<br>.bucket_versioning |
| log_bucket_acl | Access Control List configuration applied to the Log bucket. | module.aws_objectstorage<br>.log_bucket_acl |
| log_bucket_encryption_configuration | Encryption configuration applied to the Log bucket. | module.aws_objectstorage<br>.log_bucket_encryption_configuration |
| log_bucket_id | The name of the log bucket. | module.aws_objectstorage<br>.log_bucket_id |
| [log_bucket_info](#output_log_bucket_info) | Map with all the S3 Log Bucket information. | module.aws_objectstorage<br>.log_bucket_info |
| log_bucket_lifecycle_configuration | Lifecycle configuration applied to the log bucket. | module.aws_objectstorage<br>.log_bucket_lifecycle_configuration |
| log_bucket_ownership_controls | Ownership Control configuration applied to the Log bucket. | module.aws_objectstorage<br>.log_bucket_ownership_controls |
| log_bucket_policy | Policy applied to the Log bucket. | module.aws_objectstorage<br>.log_bucket_policy |

### Block Parameters

#### <a name="output_bucket_info"></a> [bucket\_info](#output\_bucket\_info)

| Name | Description | Type |
|------|-------------|------|
| acceleration\_status | The accelerate configuration of an existing bucket. Can be Enabled or Suspended. | module.aws_objectstorage<br>.bucket_info.<br>acceleration\_status |
| acl | The Access Control List configuration of the main bucket. | module.aws_objectstorage<br>.bucket_info.acl |
| arn | ARN of the bucket. Will be of format arn:aws:s3:::bucketname. | module.aws_objectstorage<br>.bucket_info.arn |
| bucket | Name of the bucket. | module.aws_objectstorage<br>.bucket_info.bucket |
| bucket\_domain\_name | Bucket domain name. Will be of format bucketname.s3.amazonaws.com. | module.aws_objectstorage<br>.bucket_info<br>.bucket\_domain\_name |
| bucket\_prefix | Unique bucket name beginning with the specified prefix. | module.aws_objectstorage<br>.bucket_info<br>.bucket\_prefix |
| bucket\_regional\_domain\_name | The bucket region-specific domain name. The bucket domain name including the region name. | module.aws_objectstorage<br>.bucket_info<br>.bucket\_regional\_domain\_name |
| cors\_rule | Rule of Cross-Origin Resource Sharing. | module.aws_objectstorage<br>.bucket_info<br>.cors\_rule |
| force\_destroy | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. | module.aws_objectstorage<br>.bucket_info<br>.force\_destroy |
| grant | The ACL policy grants for the main bucket. | module.aws_objectstorage<br>.bucket_info.grant|
| hosted\_zone\_id | Route 53 Hosted Zone ID for this bucket's region. | module.aws_objectstorage<br>.bucket_info<br>.hosted\_zone\_id |
| id | Name of the bucket. | module.aws_objectstorage<br>.bucket_info.id |
| lifecycle\_rule | Configuration of object lifecycle management. | module.aws_objectstorage<br>.bucket_info<br>.lifecycle\_rule |
| logging | Configuration of S3 bucket logging parameters. | module.aws_objectstorage<br>.bucket_info.logging |
| object\_lock\_configuration | Configuration of S3 object locking. | module.aws_objectstorage<br>.bucket_info<br>.object\_lock\_configuration |
| object\_lock\_enabled | If true, S3 object locking configuration is enabled. | module.aws_objectstorage<br>.bucket_info<br>.object\_lock\_enabled |
| policy | Valid main bucket policy JSON document. | module.aws_objectstorage<br>.bucket_info.policy |
| region | AWS region this main bucket resides in. | module.aws_objectstorage<br>.bucket_info.region |
| replication\_configuration | Configuration of replication configuration. | module.aws_objectstorage<br>.bucket_info<br>.replication\_configuration |
| server\_side\_encryption\_configuration | Configuration of server-side encryption configuration. | module.aws_objectstorage<br>.bucket_info<br>.server\_side\_encryption\_configuration |
| tags | Specifies object tags key and value. | module.aws_objectstorage<br>.bucket_info.tags |
| tags\_all | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | module.aws_objectstorage<br>.bucket_info.tags\_all  |
| timeouts | Timeouts configured for the S3 bucket. | module.aws_objectstorage<br>.bucket_info.timeouts |
| versioning | Configuration of the S3 bucket versioning state. | module.aws_objectstorage<br>.bucket_info.versioning |
| website | Configuration of the S3 bucket website. | module.aws_objectstorage<br>.bucket_info.website |

#### <a name="output_bucket_inventory_configuration"></a> [bucket\_inventory\_configuration](#output\_bucket\_inventory\_configuration)

| Name | Description | Type |
|------|-------------|------|
| bucket | Name of the source bucket that inventory lists the objects for. | module.aws_objectstorage<br>.bucket_inventory_configuration.bucket |
| destination | Contains information about where to publish the inventory results. | module.aws_objectstorage<br>.bucket_inventory_configuration.destination |
| enabled | Specifies whether the inventory is enabled or disabled. | module.aws_objectstorage<br>.bucket_inventory_configuration.enabled |
| filter | Specifies an inventory filter. | module.aws_objectstorage<br>.bucket_inventory_configuration.filter |
| id | The ID of the S3 inventory. | module.aws_objectstorage<br>.bucket_inventory_configuration.id |
| included\_object\_versions | Object versions to include in the inventory list. | module.aws_objectstorage<br>.bucket_inventory_configuration.included\_object\_versions |
| name | Unique identifier of the inventory configuration for the bucket. | module.aws_objectstorage<br>.bucket_inventory_configuration.name |
| optional\_fields | List of optional fields that are included in the inventory results. | module.aws_objectstorage<br>.bucket_inventory_configuration.optional\_fields |
| schedule | Specifies the schedule for generating inventory results. | module.aws_objectstorage<br>.bucket_inventory_configuration.schedule |

#### <a name="output_log_bucket_info"></a> [log\_bucket\_info](#output\_log\_bucket\_info)

| Name | Description | Type |
|------|-------------|------|
| acceleration\_status | The accelerate configuration of an existing log bucket. Can be Enabled or Suspended. | module.aws_objectstorage<br>.log_bucket_info<br>.acceleration\_status |
| acl | The Access Control List configuration of the log bucket. | module.aws_objectstorage<br>.log_bucket_info.acl |
| arn | ARN of the log bucket. Will be of format arn:aws:s3:::bucketlogname. | module.aws_objectstorage<br>.log_bucket_info.arn |
| bucket | Name of the log bucket. | module.aws_objectstorage<br>.log_bucket_info.bucket |
| bucket\_domain\_name | Log Bucket domain name. Will be of format bucketlogname.s3.amazonaws.com. | module.aws_objectstorage<br>.log_bucket_info<br>.bucket\_domain\_name |
| bucket\_prefix | Unique log bucket name beginning with the specified prefix. | module.aws_objectstorage<br>.log_bucket_info<br>.bucket\_prefix |
| bucket\_regional\_domain\_name | The log bucket region-specific domain name. The log bucket domain name including the region name. | module.aws_objectstorage<br>.log_bucket_info<br>.bucket\_regional\_domain\_name |
| cors\_rule | Rule of Cross-Origin Resource Sharing. | module.aws_objectstorage<br>.log_bucket_info<br>.cors\_rule |
| force\_destroy | Boolean that indicates all objects (including any locked objects) should be deleted from the log bucket when the bucket is destroyed so that the log bucket can be destroyed without error. These objects are not recoverable. | module.aws_objectstorage<br>.log_bucket_info<br>.force\_destroy |
| grant | The ACL policy grants for the log bucket. | module.aws_objectstorage<br>.log_bucket_info.grant |
| hosted\_zone\_id | Route 53 Hosted Zone ID for this log bucket's region. | module.aws_objectstorage<br>.log_bucket_info<br>.hosted\_zone\_id |
| id | Name of the log bucket. | module.aws_objectstorage<br>.log_bucket_info.id |
| lifecycle\_rule | Configuration of object lifecycle management. | module.aws_objectstorage<br>.log_bucket_info<br>.lifecycle\_rule |
| logging | Configuration of S3 log bucket logging parameters. | module.aws_objectstorage<br>.log_bucket_info.logging |
| object\_lock\_configuration | Configuration of S3 log bucket object locking. | module.aws_objectstorage<br>.log_bucket_info<br>.object\_lock\_configuration |
| object\_lock\_enabled | If true, S3 object locking configuration is enabled. | module.aws_objectstorage<br>.log_bucket_info<br>.object\_lock\_enabled |
| policy | Valid log bucket policy JSON document. | module.aws_objectstorage<br>.log_bucket_info.policy |
| region | AWS region this log bucket resides in. | module.aws_objectstorage<br>.log_bucket_info.region |
| replication\_configuration | Configuration of replication configuration. | module.aws_objectstorage<br>.log_bucket_info<br>.replication\_configuration |
| server\_side\_encryption\_configuration | Configuration of server-side encryption configuration. | module.aws_objectstorage<br>.log_bucket_info<br>.server\_side\_encryption\_configuration |
| tags | Specifies object tags key and value. | module.aws_objectstorage<br>.log_bucket_info.tags |
| tags\_all | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | module.aws_objectstorage<br>.log_bucket_info.tags\_all |
| timeouts | Timeouts configured for the S3 log bucket. | module.aws_objectstorage<br>.log_bucket_info.timeouts |
| versioning | Configuration of the S3 log bucket versioning state. | module.aws_objectstorage<br>.log_bucket_info.versioning |
| website | Configuration of the S3 log bucket website. | module.aws_objectstorage<br>.log_bucket_info.website |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
| Insufficient rule blocks<br><br>on (...), in resource "aws_s3_bucket_object_lock_configuration" "this":<br>(...)<br><br>At least 1 "rule" blocks are required. | Due to provider issue, default rule is required for object lock configuration by Terraform even though AWS does not require it. | Add `object_lock_rule_default_retention` parameter to the module.<br><br>See: <https://github.com/hashicorp/terraform-provider-aws/issues/25070>|
| Error putting Bucket Notification Configuration: InvalidArgument: Unable to validate the following destination configurations | When a notification (resource `aws_s3_bucket_notification`) is created from the S3 bucket to the SQS queue, the bucket will send a few initial test messages (pings) to verify that it reaches the SQS; this error usually occurs when trying to create a notification in the bucket but the destination SQS queue policy does not yet give said bucket permissions to execute the `SQS:SendMessage` operation. | Create the elements in the following order:<ol><li>Bucket A, without activating any notification to SQS.</li><li>The SQS queue, with a policy that allows bucket A to execute the `SQS:SendMessage` operation on the queue itself.</li><li>Update bucket A to create notification to that queue when events `"s3:ObjectCreated:*"` occur.</li><ol>|
|Waiting for S3 Bucket Object Lock Configuration (<bucket_name>) delete: found resource|This error appears when object lock configuration resource is trying to be destroyed with AWS provider versions: 5.19, 5.20 and 5.21. You can find more information about this issue in the following [link](https://github.com/hashicorp/terraform-provider-aws/issues/33943).|Avoid using the AWS provider versions mentioned before when deploying/destroying an object lock configuration resource. |
