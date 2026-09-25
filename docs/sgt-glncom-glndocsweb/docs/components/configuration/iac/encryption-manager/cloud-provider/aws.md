# AWS Key Manager Service

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

To deploy the module, the following requirements must be met:

- IAM Role for s3 cross account replication (Optional)
- IAM Role to perform operations for KMS grants (Optional)
- IAM Role to retire the grant for KMS (Optional)
- List of grant tokens to create grants (Optional)
- Key material to create a external KMS (Optional)

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_encryptionmanager = {
  "01_kms_default" = {
    # required variables
    kms_name = "glnd1airemskmstest001"
    external = false

    tags = {
      product     = "Gluon AWS KMS"
      environment = "dev"
      project     = "Gluon"
    }
  }

  "02_kms_external" = {
    # required variables
    kms_name = "glnd1airemskmstest002"
    external             = true

    resource_description = "EMS AWS Testing"
    key_material         = "HAucjioL1egslxneRSCKF4z8/w+s0Cv6Hl452MeDfeM="
    enable_key_rotation  = false
    valid_to             = "2025-08-01T00:00:00Z"

    tags = {
      product     = "Gluon AWS KMS"
      environment = "dev"
      project     = "Gluon"
    }
  }

  "03_kms_custom" = {
    # required variables
    kms_name                 = "glnd1airemskmstest003"
    external                 = false

    resource_description     = "EMS AWS Testing"
    key_usage                = "SIGN_VERIFY"
    customer_master_key_spec = "RSA_4096"
    deletion_window_in_days  = 7
    enable_key_rotation      = false
    key_is_enabled           = false
    multi_region             = true
    additional_aliases       = ["iac-aws-arc-ems-extra-1", "iac-aws-arc-ems-extra-2"]

    # SSE-KMS encryption of the S3 Inventory
    s3_inventory_source_accounts_ids     = ["<aws_account_id>", "<aws_account_id>"]
    s3_inventory_source_buckets_arns     = ["arn:aws:s3:::glnd1airas3emststgene001"]
    s3_notifications_source_accounts_ids = ["<aws_account_id>", "<aws_account_id>"]
    s3_notifications_source_buckets_arns = ["arn:aws:s3:::glnd1airas3emststgene001"]

    # policy
    custom_policy = <<EOF
      {
      "Version": "2012-10-17",

      "Statement": [
              {
                  "Sid": "Enable IAM User Permissions_Custom",
                  "Effect": "Allow",
                  "Principal": {
                      "AWS": "arn:aws:iam::<aws_account_id>:root"
                  },
                  "Action": [
                    "kms:Create*",
                    "kms:Describe*",
                    "kms:Enable*",
                    "kms:List*",
                    "kms:Put*",
                    "kms:Update*",
                    "kms:Revoke*",
                    "kms:Disable*",
                    "kms:Get*",
                    "kms:Delete*",
                    "kms:TagResource",
                    "kms:UntagResource",
                    "kms:ScheduleKeyDeletion",
                    "kms:CancelKeyDeletion",
                    "kms:ImportKeyMaterial"
                  ],
                  "Resource": "*"
              }
          ]
      }
  EOF

    tags = {
      product     = "Gluon AWS KMS"
      environment = "dev"
      project     = "Gluon"
    }
  }

  "04_kms_grant_with_ece" = {
    # required variables
    kms_name                 = "glnd1airemskmstest004"
    external                 = false

    key_usage                = "ENCRYPT_DECRYPT"   // "SIGN_VERIFY"
    customer_master_key_spec = "SYMMETRIC_DEFAULT" // "ECC_NIST_P256" // "RSA_4096" // RSA_3072
    enable_key_rotation      = false
    key_is_enabled           = true

    # grants
    grant_enabled            = true
    grant_name               = "grant-example"
    grantee_principal        = "arn:aws:iam::<aws_account_id>:role/glnd1weuiamkms001"
    retiring_principal       = "arn:aws:iam::<aws_account_id>:role/glnd1weuiamkms001"
    operations = ["CreateGrant", "RetireGrant", "DescribeKey"]

    # encryption context
    encryption_context_equals = {
      Department = "Finance"
    }

    tags = {
      product     = "Gluon AWS KMS"
      environment = "dev"
      project     = "Gluon"
    }
  }
  "05_kms_grant_with_ecs" = {
    # required variables
    kms_name                 = "glnd1airemskmstest005"
    external                 = false

    key_usage                = "ENCRYPT_DECRYPT"   // "SIGN_VERIFY"
    customer_master_key_spec = "SYMMETRIC_DEFAULT" // "ECC_NIST_P256" // "RSA_4096" // RSA_3072
    enable_key_rotation      = false
    key_is_enabled           = true

    # grants
    grant_enabled            = true
    grant_name               = "grant-example"
    grantee_principal        = "arn:aws:iam::<aws_account_id>:role/glnd1weuiamkms001"
    retiring_principal       = "arn:aws:iam::<aws_account_id>:role/glnd1weuiamkms001"
    operations = ["CreateGrant", "RetireGrant", "DescribeKey"]

    # encryption context
    encryption_context_subset = {
      Department = "Technology"
    }

    tags = {
      product     = "Gluon AWS KMS"
      environment = "dev"
      project     = "Gluon"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| external | If true, CMK material must be provided by the user. | <pre>bool</pre> |
| kms_name | The name defined by the user for the resource. | <pre>string</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| additional_aliases | List of additional aliases for the key. | <pre>set(string)</pre> | [] |
| custom_policy | A key policy JSON. If you do not provide a key policy, AWS KMS attaches a default key policy to the CMK. | <pre>string</pre> | null |
| customer_master_key_spec | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`. | <pre>string</pre> | "SYMMETRIC\_DEFAULT" |
| deletion_window_in_days | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. | <pre>number</pre> | 30 |
| enable_key_rotation | Specifies whether key rotation is enabled | <pre>bool</pre> | true |
| encryption_context_equals | A list of key-value pairs that must match the encryption context in subsequent cryptographic operation requests. The grant allows the operation only when the encryption context in the request is the same as the encryption context specified in this constraint. Conflicts with encryption\_context\_subset. | <pre>map(string)</pre> | {} |
| encryption_context_subset | A list of key-value pairs that must be included in the encryption context of subsequent cryptographic operation requests. The grant allows the cryptographic operation only when the encryption context in the request includes the key-value pairs specified in this constraint, although it can include additional key-value pairs. Conflicts with encryption\_context\_equals. | <pre>map(string)</pre> | {} |
| grant_creation_tokens | (Forces new resources) A list of grant tokens to be used when creating the grant. See Grant Tokens for more information about grant tokens. | <pre>list(string)</pre> | [] |
| grant_enabled | If true, a resource-based access control mechanism for a KMS customer master key will be provided. | <pre>bool</pre> | false |
| grant_name | (Forces new resources) A friendly name for identifying the grant. | <pre>string</pre> | null |
| grantee_principal | (Forces new resources) The principal that is given permission to perform the operations that the grant permits in ARN format. Note that due to eventual consistency issues around IAM principals, terraform's state may not always be refreshed to reflect what is true in AWS. | <pre>string</pre> | null |
| key_is_enabled | Specifies whether the key is enabled. | <pre>bool</pre> | true |
| key_material | Required if `external` is `true`. Specifies the material used by the algorithm to encrypt the data. | <pre>string</pre> | null |
| key_usage | Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY` | <pre>string</pre> | "ENCRYPT\_DECRYPT" |
| multi_region | Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false. | <pre>bool</pre> | false |
| operations | (Forces new resources) A list of operations that the grant permits. The permitted values are: Decrypt, Encrypt, GenerateDataKey, GenerateDataKeyWithoutPlaintext, ReEncryptFrom, ReEncryptTo, Sign, Verify, GetPublicKey, CreateGrant, RetireGrant, DescribeKey, GenerateDataKeyPair, or GenerateDataKeyPairWithoutPlaintext. | <pre>set(string)</pre> | [] |
| resource_description | The description of the key as viewed in AWS console. | <pre>string</pre> | "" |
| retire_on_delete | (Forces new resources) If set to false (the default) the grants will be revoked upon deletion, and if set to true the grants will try to be retired upon deletion. Note that retiring grants requires special permissions, hence why we default to revoking grants. See RetireGrant for more information. | <pre>bool</pre> | false |
| retiring_principal | (Forces new resources) The principal that is given permission to retire the grant by using RetireGrant operation in ARN format. Note that due to eventual consistency issues around IAM principals, terraform's state may not always be refreshed to reflect what is true in AWS. | <pre>string</pre> | null |
| s3_inventory_source_accounts_ids | Only relevant if the KMS key is used for SSE-KMS encryption of the S3 Inventory destination bucket. A list of IDs of AWS accounts containing source buckets from which inventory reports are generated. If not specified, defaults to the current AWS account. | <pre>set(string)</pre> | null |
| s3_inventory_source_buckets_arns | Only relevant if the KMS key is used for SSE-KMS encryption of the S3 Inventory destination bucket. A list of ARNs of buckets from which inventory reports are generated. | <pre>set(string)</pre> | [] |
| s3_notifications_source_accounts_ids | Only relevant if the KMS key is used for encryption of the SQS topic / SNS queue which is the destination of S3 notifications. A list of IDs of AWS accounts containing source buckets from which notifications are produced. If not specified, defaults to the current AWS account. | <pre>set(string)</pre> | null |
| s3_notifications_source_buckets_arns | Only relevant if the KMS key is used for encryption of the SQS topic / SNS queue which is the destination of S3 notifications. A list of ARNs of buckets from which notifications are produced. | <pre>set(string)</pre> | [] |
| s3_replication_cross_account_iam_roles | Only relevant if the KMS key is used for SSE-KMS encryption of the S3 cross-account replication destination bucket. A list of IAM roles ARNs which are used for S3 replication from another AWS account. | <pre>set(string)</pre> | [] |
| tags | A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>any</pre> | {} |
| valid_to | Time at which the imported key material expires. When the key material expires, AWS KMS deletes the key material and the CMK becomes unusable. If not specified, key material does not expire. Valid values: RFC3339 time string (`YYYY-MM-DDTHH:MM:SSZ`) | <pre>string</pre> | null |

## Output example

```hcl
aws_encryptionmanager = {
  "01_kms_default" = {
    "grant_id" = null
    "kms_alias" = "alias/glnd1airemskmstest001"
    "kms_arn" = "arn:aws:kms:<aws_account_id>:<aws_account_id>:key/65013c7e-5a8a-4c8b-a0ce-69ff17ed0afc"
    "kms_id" = "65013c7e-5a8a-4c8b-a0ce-69ff17ed0afc"
  }
}
aws_encryptionmanager_sensitive = <sensitive>
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_encryptionmanager|module.aws_encryptionmanager|AWS Encryption Manager Outputs map.<br>[AWS Encryption Manager Outputs](#aws_encryption_manager_outputs). |
|aws_encryptionmanager_sensitive|module.aws_encryptionmanager|AWS Encryption Manager Sensitive Outputs map. <br>[AWS Encryption Manager Sensitive Outputs](#aws_encryption_manager_sensitive_outputs). |

<a name="outputs-section"></a>

<a name="aws_encryption_manager_outputs"></a>

### AWS Encryption Manager Outputs

| Name | Description | Type |
|------|-------------|------|
| grant_id | The unique identifier for the grant. | <pre>module.aws_encryptionmanager.grant_id</pre> |
| kms_alias | main alias of the KMS created | <pre>module.aws_encryptionmanager.kms_alias</pre> |
| kms_arn | arn of the KMS created | <pre>module.aws_encryptionmanager.kms_arn</pre> |
| kms_id | ID of the KMS created | <pre>module.aws_encryptionmanager.kms_id</pre> |
<a name="aws_encryption_manager_sensitive_outputs"></a>

### AWS Encryption Manager Sensitive Outputs

| Name | Description | Type |
|------|-------------|------|
| grant_token | The grant token for the created grant. | <pre>module.aws_encryptionmanager_sensitive.grant_token</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
