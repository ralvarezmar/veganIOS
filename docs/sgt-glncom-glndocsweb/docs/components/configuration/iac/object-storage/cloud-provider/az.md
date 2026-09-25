# Azure Storage Account and Private Endpoint

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

To deploy the module, the following requirements must be met:

  - Azure Resource Group within Azure subscription with the following components:
    - Azure Key Vault with network ACLs that allow traffic from STA subnet. (Required only when security level is 'sa')
    - Azure Log Analytics workspace.
  - Azure SPN L3 required to deploy all infrastructure components. This SPN L3 need to have the next permissions:
    - Contributor role into resource group to deploy all artifacts needed.
    - Get and set secrets/keys into Key Vault Access policies.
  - Azure Key Vault must accomplish the following requirements and features:
    - Azure Key Vault and STA must belong to the same Azure Active Directory (Azure AD) tenant.
    - If you want to encrypt STA data, Azure Key vault must have enabled the soft-delete feature, to protect from data loss if an accidental key (or Key Vault) deletion happens.
      Also STA must have access to the key vault with the get, wrapKey, and unwrapKey permissions by using its unique managed identity.
    - Encryption at host requirements **(only for use with cmek)**:
        - Azure Key Vault key must be only asymmetric, RSA 2048.
        - Key activation date (if set) must be a date and time in the past. The expiration date (if set) must be a future date and time.
        - Key must be in the Enabled state.
        - If you're importing an existing key into the key vault, make sure to provide it in the supported file formats (.pfx, .byok, .backup).

<a name="AZInputExample"></a>

## Input example

```hcl
az_objectstorage = {
  sta_sm_default = {
    # General Settings
    name           = "glnd1weustaglobaltest001"
    resource_group = "glnd1weursgglobaltest001"
    location       = "westeurope"

    # Security Settings
    security_level = "sm"

    # Logging Settings
    lwk_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest001"

    # Tagging
    tags = {
      product     = "Gluon AZ Storage Account"
      environment = "dev"
      project     = "Gluon"
    }

    # Private Endpoint
    subnet_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt002"
  }

  sta_sa_byok = {
    # General Settings
    name           = "glnd1weustaglobaltest002"
    resource_group = "glnd1weursgglobaltest001"
    location       = "westeurope"
    tenant_id      = "<azure_tenant_id>"

    # Security Settings
    security_level = "sa"

    enable_https_traffic_only = true
    large_file_share_enabled  = true
    shared_access_key_enabled = true
    akv_id                    = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest001"
    akv_key                   = "glnd1weukeyglobaltest001"
    akv_key_version           = "80ebcc90aa0b4044a097f81b985af2c6"

    # Logging Settings
    lwk_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest001"

    # Tagging
    tags = {
      product     = "Gluon AZ Storage Account"
      environment = "dev"
      project     = "Gluon"
    }

    # Private Endpoint
    subnet_id             = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt002"
    endpoint_subresources = ["blob", "table"]
  }

  sta_sa_cmek = {
    # General Settings
    name               = "glnd1weustaglobaltest003"
    resource_group     = "glnd1weursgglobaltest001"
    location           = "westeurope"
    tenant_id          = "<azure_tenant_id>"
    allowed_copy_scope = "PrivateLink"
    sftp_enabled       = true
    is_hns_enabled     = true

    # Security Settings
    security_level = "sa"

    enable_https_traffic_only = true
    large_file_share_enabled  = true
    shared_access_key_enabled = true
    akv_id                    = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest001"

    # Logging Settings
    lwk_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest001"

    # Network Settings
    public_network_access_enabled = true
    ip_rules = [
      "1.2.3.4/24",
      "5.6.7.8/18"
    ]

    private_link_access = {
      pla_dbr = {
        endpoint_resource_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Databricks/accessConnectors/test-dbr-access-connector001"
      }
      pla_dcr = {
        endpoint_resource_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Insights/dataCollectionRules/glnd1weudcrastacortest099"
        endpoint_tenant_id   = "<azure_tenant_id>"
      }
    }

    # Tagging
    tags = {
      product     = "Gluon AZ Storage Account"
      environment = "dev"
      project     = "Gluon"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | string |
| lwk_id | Log Analytics Workspace ID. | string |
| name | Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group. | string |
| resource_group | The name of the resource group in which to create the storage account. Changing this forces a new resource to be created. | string |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| access_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool. | string | "Hot" |
| account_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Changing this value from Storage to StorageV2 will not trigger a force new on the storage account, it will only upgrade the existing storage account from Storage to StorageV2 keeping the existing storage account in place. | string | "StorageV2" |
| account_replication_type | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. | string | "ZRS" |
| account_tier | Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Blobs with a tier of Premium are of account kind StorageV2. Changing this forces a new resource to be created. | string | "Standard" |
| akv_id | (Required if security level is 'sa') Key Vault ID where the CMK Key of the sta will be saved. | string | "" |
| akv_key | The name of the AKV key used to encrypt the sta. | string | "" |
| akv_key_version | The version of the AKV key used to encrypt the sta. | string | "" |
| allowed_copy_scope | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are 'AAD' and 'PrivateLink'. | string | null |
| analytics_diagnostic_monitor_name | The name of the Analytics Diagnostic Monitor. | string | "" |
| [blob_properties](#input_blob_properties) | A map that contains the blob properties. | any | {} |
| bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. | list(string) | [<br>  "AzureServices"<br>] |
| default_to_oauth_authentication | Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. | bool | false |
| edge_zone | Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created. | string | null |
| enable_automatic_rotation_policy | Enables the automatic rotation policy for the created AKV key. :warning: If it is set to 'false', the attribute 'time\_before\_expiry' must not be set. | bool | true |
| enable_https_traffic_only | Boolean flag which forces HTTPS if enabled, see [here](https://learn.microsoft.com/en-gb/azure/storage/common/storage-require-secure-transfer) for more information. | bool | true |
| endpoint_subresources | A list of subresource names which the Private Endpoint is able to connect to. Possible values for storage account are: "blob", "table", "queue", "file" and "dfs". Changing this forces a new resource to be created.|list(string)|["blob"]|
| expire_after | Expire a Key Vault Key after given duration as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Must always be, at least, 7 days greater than the attribute 'time\_before\_expiry'. Minimum allowed value is 'P28D'. | string | "P25M" |
| [immutability_policy](#input_immutability_policy) | A map that contains the configuration for the immutability policy. :warning: This argument specifies the default account-level immutability policy which is inherited and applied to objects that do not possess an explicit immutability policy at the object level. The object-level immutability policy has higher precedence than the container-level immutability policy, which has a higher precedence than the account-level immutability policy. | any | {} |
| infrastructure_encryption_enabled | Is infrastructure encryption enabled? Changing this forces a new resource to be created. :warning: This can only be true when 'account\_kind' is 'StorageV2' or when 'account\_tier' is 'Premium' and 'account\_kind' is one of 'BlockBlobStorage' or 'FileStorage'. | bool | null |
| ip_rules | List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918#section-3)) are not allowed. | list(string) | [] |
| is_hns_enabled | Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. :warning: This can only be true when 'account\_tie'r' is 'Standard' or when 'account\_tier' is 'Premium' and 'account\_kind' is 'BlockBlobStorage'. Changing this forces a new resource to be created. | bool | false |
| large_file_share_enabled | Is Large File Share Enabled?. | bool | false |
| logs | Specifies the logs types that are going to be saved. These are all the available logs types: ["StorageRead", "StorageWrite", "StorageDelete"]. | any | [<br>  "StorageRead",<br>  "StorageWrite",<br>  "StorageDelete"<br>] |
| [management_policy_rules](#input_management_policy_rules) | Map of rules used to manage an Azure Storage Account Management Policy. The key of the key-value map you pass as input will be the name of the rule. | any | null |
| metrics | Specifies the metrics types that are going to be saved. These are all the available metrics types: ["Transaction", "Capacity"]. | any | [<br>    "Transaction",<br>    "Capacity"<br>  ] |
| min_tls_version | The minimum supported TLS version for the storage account. Possible values are TLS1\_0, TLS1\_1, and TLS1\_2. :warning: At this time min\_tls\_version is only supported in the Public Cloud, China Cloud, and US Government Cloud. | string | "TLS1\_2" |
| nacl_default_action | Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow. | string | "Deny" |
| nfsv3_enabled | Is NFSv3 protocol enabled? Changing this forces a new resource to be created. :warning: This can only be true when account\_tier is Standard and account\_kind is StorageV2, or account\_tier is Premium and account\_kind is BlockBlobStorage. Additionally, the is\_hns\_enabled is true and account\_replication\_type must be LRS or RAGRS. | bool | false |
| notify_before_expiry | Notify at a given duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Minimum allowed value is 'P7D'. | string | "P7D" |
| pep_name | "Specifies the Name of the Private Endpoint. If not specified, the private endpoint name will be <private_connection_resource_name>-<endpoint_subresource>-pep. Changing this forces a new resource to be created. | string | "" |
| private_service_connection_name | Specifies the Name of the Private Service Connection. If not specified, the private service connection name will be <private_connection_resource_name>-<endpoint_subresource>. Changing this forces a new resource to be created. | string | "" |
| [private_link_access](#input_private_link_access) | A map that contains the private link information for the Network Access Control List. | any | {} |
| public_network_access_enabled | Whether the public network access is enabled? Can be 'true' if 'var.nacl\_default\_action' is 'Deny' and ACLs are provided. | bool | false |
| queue_encryption_key_type | The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. :warning: The Account key type is only allowed when 'security\_level' is 'sa' and the 'account\_kind' is set to 'StorageV2'. | string | null |
| [queue_properties](#input_queue_properties) | A map that contains the queue properties. | any | {} |
| security_level | Type of storage account depending of Security Control for Cloud applied to this resource (Possible values: sa or sm). | string | "sm" |
| sftp_enabled | Boolean, enable SFTP for the storage account. :warning: SFTP support requires 'is\_hns\_enabled' set to true. [More information on SFTP support can be found here](https://learn.microsoft.com/en-gb/azure/storage/blobs/secure-file-transfer-protocol-support). | bool | false |
| shared_access_key_enabled | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). :warning: Terraform uses Shared Key Authorisation to provision Storage Containers, Blobs and other items - when Shared Key Access is disabled, you will need to enable the storage\_use\_azuread flag in the Provider block to use Azure AD for authentication, however not all Azure Storage services support Active Directory authentication. | bool | true |
| [storage_defender](#input_storage_defender) | A map that contains the defender for storage settings to be configured. | any | {} |
| subnet_id | (Required to deploy a Private Endpoint) Subnet Id that must be used to deploy the Private Endpoint that will be attached to the Storage Account. | list(string) | [] |
| table_encryption_key_type | The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. :warning: The Account key type is only allowed when 'security\_level' is 'sa' and the 'account\_kind' is set to 'StorageV2'. | string | null |
| time_before_expiry | Rotate automatically at a duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This attribute must only be set when 'enable\_automatic\_rotation\_policy' is 'true'. Defaults to 'P1M' if 'enable\_automatic\_rotation\_policy' is 'true', otherwise 'null'. :warning: The attribute 'expire\_after' must always be, at least, 7 days greater than this parameter. | string | null |
| tags | A map of tags to assign to the resource. This map is a merged structure between custom tags and standard tags. | any | {} |
| tenant_id | Tenant id. | string | null |

## Block Parameters

#### <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| container_delete_retention_policy_days | (Optional) Specifies the number of days that the container should be retained, between 1 and 365 days. | number |
| delete_retention_policy_days | (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days. | number |
| last_access_time_enabled | (Optional) Is the last access time based tracking enabled? Default to false. | bool |
| versioning_enabled | (Optional) Is versioning enabled? Default to false. | bool |

#### <a name="input_immutability_policy"></a> [immutability\_policy](#input\_immutability\_policy)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| allow_protected_append_writes | (Required) When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. | bool |
| period_since_creation_in_days | (Required) The immutability period for the blobs in the container since the policy creation, in days. | number |
| state | (Required) Defines the mode of the policy. Disabled state disables the policy, Unlocked state allows increase and decrease of immutability retention time and also allows toggling allowProtectedAppendWrites property, Locked state only allows the increase of the immutability retention time. A policy can only be created in a Disabled or Unlocked state and can be toggled between the two states. Only a policy in an Unlocked state can transition to a Locked state which cannot be reverted. | string |

#### <a name="input_management_policy_rules"></a> [management\_policy\_rules](#input\_management\_policy\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| actions | (Required) Object to specify different actions that will be applied to the management policy. | any |
| actions<br/>.base_blob | (Optional) Object to specify base\_blob parameter that will be applied to the actions inside management policy. | any |
| actions<br/>.base_blob<br/>.delete_after_days_since_last_access_time_greater_than | (Optional) The age in days after last access time to delete the blob. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.delete_after_days_since_modification_greater_than | (Optional) The age in days after last modification to delete the blob. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.tier_to_archive_after_days_since_last_access_time_greater_than | (Optional) The age in days after last access time to tier blobs to archive storage. Supports blob currently at Hot or Cool tier. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.tier_to_archive_after_days_since_last_tier_change_greater_than | (Optional) The age in days after last tier change to the blobs to skip to be archived. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.tier_to_archive_after_days_since_modification_greater_than | (Optional) The age in days after last modification to tier blobs to archive storage. Supports blob currently at Hot or Cool tier. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.tier_to_cool_after_days_since_last_access_time_greater_than | (Optional) The age in days after last access time to tier blobs to cool storage. Supports blob currently at Hot tier. Must be between 0 and 99999. | number |
| actions<br/>.base_blob<br/>.tier_to_cool_after_days_since_modification_greater_than | (Optional) The age in days after last modification to tier blobs to cool storage. Supports blob currently at Hot tier. Must be between 0 and 99999. | number |
| actions<br/>.snapshot | (Optional) Object to specify snapshot parameter that will be applied to the actions inside management policy. | any |
| actions<br/>.snapshot<br/>.change_tier_to_archive_after_days_since_creation | (Optional) The age in days after creation to tier blob snapshot to archive storage. Must be between 0 and 99999. | number |
| actions<br/>.snapshot<br/>.change_tier_to_cool_after_days_since_creation | (Optional) The age in days after creation to tier blob snapshot to cool storage. Must be between 0 and 99999. | number |
| actions<br/>.snapshot<br/>.delete_after_days_since_creation_greater_than | (Optional) The age in days after creation to delete the blob snapshot. Must be between 0 and 99999. | number |
| actions<br/>.snapshot<br/>.tier_to_archive_after_days_since_last_tier_change_greater_than | (Optional) The age in days after last tier change to the blobs to skip to be archived. Must be between 0 and 99999. | number |
| actions<br/>.version | (Optional) Object to specify version parameter that will be applied to the actions inside management policy. | any |
| actions<br/>.version<br/>.change_tier_to_archive_after_days_since_creation | (Optional) The age in days after creation to tier blob version to archive storage. Must be between 0 and 99999. | number |
| actions<br/>.version<br/>.change_tier_to_cool_after_days_since_creation | (Optional) The age in days creation create to tier blob version to cool storage. Must be between 0 and 99999. | number |
| actions<br/>.version<br/>.delete_after_days_since_creation | (Optional) The age in days after creation to delete the blob version. Must be between 0 and 99999. | number |
| actions<br/>.version<br/>.tier_to_archive_after_days_since_last_tier_change_greater_than | (Optional) The age in days after last tier change to the blobs to skip to be archived. Must be between 0 and 99999. | number |
| enabled | (Required) Boolean to specify whether the rule is enabled. | bool |
| filters | (Required) Object to specify different filters that will be applied to the management policy. | any |
| filters<br/>.blob_types | (Required) An array of predefined values. Valid options are blockBlob and appendBlob. | list(string) |
| filters<br/>.match_blob_index_tag | (Optional) A match\_blob\_index\_tag block as defined below. The block defines the blob index tag based filtering for blob objects. :warning: The 'match\_blob\_index\_tag' property requires enabling the 'blobIndex' feature with PSH or CLI commands. | object |
| filters<br/>.match_blob_index_tag<br/>.name | (Required) The filter tag name used for tag based filtering for blob objects. | string |
| filters<br/>.match_blob_index_tag<br/>.operation | (Optional) The comparison operator which is used for object comparison and filtering. Possible value is ==. Defaults to ==. | string |
| filters<br/>.match_blob_index_tag<br/>.value | (Required) The filter tag value used for tag based filtering for blob objects. | string |
| filters<br/>.prefix_match | (Optional) An array of strings for prefixes to be matched. | list(string) |
| name | (Required) The name of the rule. Rule name is case-sensitive. It must be unique within a policy. | string |

#### <a name="input_private_link_access"></a> [private\_link\_access](#input\_private\_link\_access)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| endpoint_resource_id | (Required) The resource id of the resource access rule to be granted access. | string |
| endpoint_tenant_id | (Optional) The tenant id of the resource of the resource access rule to be granted access. Defaults to the current tenant id. | string |

#### <a name="input_queue_properties"></a> [queue\_properties](#input\_queue\_properties)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| hour_metrics_days | (Optional) Specifies the number of days that logs will be retained. | number |
| hour_metrics_enabled | (Required) Indicates whether hour metrics are enabled for the Queue service. | bool |
| hour_metrics_include_apis | (Optional) Indicates whether metrics should generate summary statistics for called API operations. | bool |
| hour_metrics_version | (Required) The version of storage analytics to configure. Supports both versions '1.0' and '2.0'. | string |
| logging_days | (Optional) Specifies the number of days that logs will be retained. | number |
| logging_delete | (Required) Indicates whether all delete requests should be logged. | bool |
| logging_read | (Required) Indicates whether all read requests should be logged. | bool |
| logging_version | (Required) The version of storage analytics to configure. Supports both versions '1.0' and '2.0'. | string |
| logging_write | (Required) Indicates whether all write requests should be logged. | bool |
| minute_metrics_days | (Optional) Specifies the number of days that logs will be retained. | number |
| minute_metrics_enabled | (Required) Indicates whether hour metrics are enabled for the Queue service. | bool |
| minute_metrics_include_apis | (Optional) Indicates whether metrics should generate summary statistics for called API operations. | bool |
| minute_metrics_version | (Required) The version of storage analytics to configure. Supports both versions '1.0' and '2.0'. | string |

#### <a name="input_storage_defender"></a> [storage\_defender](#input\_storage\_defender)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| enabled | (Optional) Whether to enable or not the Defender for Storage. :warning: Take into account that, if defender for cloud is enabled at subscription level and you don't set this value or set it to false, it will be enabled anyway. Defaults to false. | bool |
| override_subscription_settings_enabled | (Optional) Whether the settings defined for this storage account should override the settings defined for the subscription. Defaults to false. | bool |
| malware_scanning_on_upload_enabled | (Optional) Whether On Upload malware scanning should be enabled. Defaults to false. | bool |
| malware_scanning_on_upload_cap_gb_per_month | (Optional) The max GB to be scanned per Month. Must be -1 or above 0. Omit this property or set to -1 if no capping is needed. Defaults to -1. | number |
| sensitive_data_discovery_enabled | (Optional) Whether Sensitive Data Discovery should be enabled. Defaults to false. | bool |

## Output example

```hcl
az_objectstorage = {
  "sta_sa_byok" = {
    "blob_endpoint" = {
      "primary_blob_endpoint" = "https://glnd1weustaglobaltest002.blob.core.windows.net/"
      "secondary_blob_endpoint" = null
    }
    "dfs_endpoint" = {
      "primary_dfs_endpoint" = "https://glnd1weustaglobaltest002.dfs.core.windows.net/"
      "secondary_dfs_endpoint" = null
    }
    "file_endpoint" = {
      "primary_file_endpoint" = "https://glnd1weustaglobaltest002.file.core.windows.net/"
      "secondary_file_endpoint" = null
    }
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Storage/storageAccounts/glnd1weustaglobaltest002"
    "key_vault_key_name" = "cibs1weukeyglobaltest001"
    "location" = "westeurope"
    "name" = "glnd1weustaglobaltest002"
    "primary_location" = "westeurope"
    "principal_id" = "1c929c00-079b-440d-a85c-5eeb08b05397"
    "private_endpoints" = {
      "glnd1weustaglobaltest002-blob-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/glnd1weustaglobaltest002-blob-pep"
        "name" = "glnd1weustaglobaltest002-blob-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weustaglobaltest002.blob.core.windows.net"
            "ip_addresses" = [
              "10.179.1.10",
            ]
          },
        ]
      }
      "glnd1weustaglobaltest002-table-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/glnd1weustaglobaltest002-table-pep"
        "name" = "glnd1weustaglobaltest002-table-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weustaglobaltest002.table.core.windows.net"
            "ip_addresses" = [
              "10.179.1.12",
            ]
          },
        ]
      }
    }
    "queue_endpoint" = {
      "primary_queue_endpoint" = "https://glnd1weustaglobaltest002.queue.core.windows.net/"
      "secondary_queue_endpoint" = null
    }
    "secondary_location" = ""
    "table_endpoint" = {
      "primary_table_endpoint" = "https://glnd1weustaglobaltest002.table.core.windows.net/"
      "secondary_table_endpoint" = null
    }
  }
  "sta_core_sa_cmek_nacl" = {
    "blob_endpoint" = {
      "primary_blob_endpoint" = "https://glnd1weustaglobaltest003.blob.core.windows.net/"
      "secondary_blob_endpoint" = null
    }
    "dfs_endpoint" = {
      "primary_dfs_endpoint" = "https://glnd1weustaglobaltest003.dfs.core.windows.net/"
      "secondary_dfs_endpoint" = null
    }
    "file_endpoint" = {
      "primary_file_endpoint" = "https://glnd1weustaglobaltest003.file.core.windows.net/"
      "secondary_file_endpoint" = null
    }
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Storage/storageAccounts/glnd1weustaglobaltest003"
    "key_vault_key_name" = "glnd1weustaglobaltest003-cmkkey"
    "location" = "westeurope"
    "name" = "glnd1weustaglobaltest003"
    "primary_location" = "westeurope"
    "principal_id" = "4234cdf1-b892-46b7-a1ab-50e7ec234639"
    "private_endpoints" = {
      "gln-pep-test-blob-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/gln-pep-test-blob-pep"
        "name" = "gln-pep-test-blob-pep"
        "private_ip_fqdn" =[
          {
            "fqdn" = "glnd1weustaglobaltest003.blob.core.windows.net"
            "ip_addresses" = [
              "10.179.1.11",
            ]
          },
        ]
      }
      "gln-pep-test-file-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/gln-pep-test-file-pep"
        "name" = "gln-pep-test-file-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weustaglobaltest003.file.core.windows.net"
            "ip_addresses" = [
              "10.179.1.13",
            ]
          },
        ]
      }
      "gln-pep-test-queue-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/gln-pep-test-queue-pep"
        "name" = "gln-pep-test-queue-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weustaglobaltest003.queue.core.windows.net"
            "ip_addresses" = [
              "10.179.1.14",
            ]
          },
        ]
      }
    }
    "queue_endpoint" = {
      "primary_queue_endpoint" = "https://glnd1weustaglobaltest003.queue.core.windows.net/"
      "secondary_queue_endpoint" = null
    }
    "secondary_location" = ""
    "table_endpoint" = {
      "primary_table_endpoint" = "https://glnd1weustaglobaltest003.table.core.windows.net/"
      "secondary_table_endpoint" = null
    }
  }
  "sta_core_sm_default" = {
    "blob_endpoint" = {
      "primary_blob_endpoint" = "https://glnd1weustaglobaltest001.blob.core.windows.net/"
      "secondary_blob_endpoint" = null
    }
    "dfs_endpoint" = {
      "primary_dfs_endpoint" = "https://glnd1weustaglobaltest001.dfs.core.windows.net/"
      "secondary_dfs_endpoint" = null
    }
    "file_endpoint" = {
      "primary_file_endpoint" = "https://glnd1weustaglobaltest001.file.core.windows.net/"
      "secondary_file_endpoint" = null
    }
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Storage/storageAccounts/glnd1weustaglobaltest001"
    "key_vault_key_name" = null
    "location" = "westeurope"
    "name" = "glnd1weustaglobaltest001"
    "primary_location" = "westeurope"
    "principal_id" = "b9f946d9-c26c-4586-9d6d-beb09812eee3"
    "private_endpoints" = {
      "glnd1weustaglobaltest001-blob-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/cibs1weursgglobaltest001/providers/Microsoft.Network/privateEndpoints/glnd1weustaglobaltest001-blob-pep"
        "name" = "glnd1weustaglobaltest001-blob-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weustaglobaltest001.blob.core.windows.net"
            "ip_addresses" = [
              "10.179.1.15",
            ]
          },
        ]
      }
    }
    "queue_endpoint" = {
      "primary_queue_endpoint" = "https://glnd1weustaglobaltest001.queue.core.windows.net/"
      "secondary_queue_endpoint" = null
    }
    "secondary_location" = ""
    "table_endpoint" = {
      "primary_table_endpoint" = "https://glnd1weustaglobaltest001.table.core.windows.net/"
      "secondary_table_endpoint" = null
    }
  }
}
az_objectstorage_sensitives = <sensitive>
```

## Outputs list

| Name | Output value | Description |
|------|--------------|-------------|
| az_objectstorage | module.az_objectstorage | Azure Object Storage outputs map. <br> [Map Azure Object Storage Outputs](#outputs-section) |
| az_objectstorage_sensitives | module.az_objectstorage | Azure Object Storage sensitive outputs map. <br>[Map Azure Object Storage Sensitive Outputs](#AzureObjectStorageSensitiveOutputs) |

<a name="outputs-section"></a>

### Azure Object Storage Outputs

| Name | Description | Type |
|:--|:--|:--|
| [blob_endpoint](#output_blob_endpoint) | Map with all the Storage Account Blob Endpoint information. | module.az_objectstorage.blob_endpoint |
| [dfs_endpoint](#output_dfs_endpoint) | Map with all the Storage Account DFS Endpoint information. | module.az_objectstorage.dfs_endpoint |
| [file_endpoint](#output_file_endpoint) | Map with all the Storage Account file Endpoint information. | module.az_objectstorage.file_endpoint |
| id | Storage Account Resource ID. | module.az_objectstorage.id |
| key_vault_key_name | Storage Account Key Vault Key Name used to encrypt the Storage Account when the attribute 'security\_level' is 'sa'. | module.az_objectstorage.key_vault_key_name |
| location | Storage Account Location. | module.az_objectstorage.location |
| name | Storage Account Name. | module.az_objectstorage.name |
| primary_location | The primary location of the storage account. | module.az_objectstorage.primary_location |
| principal_id | Storage Account Principal ID. | module.az_objectstorage.principal_id |
| [private_endpoints](#output_private_endpoints) | Map with all the Private Endpoints information. | module.az_pep_storage.private_endpoints |
| [queue_endpoint](#output_queue_endpoint) | Map with all the Storage Account queue Endpoint information. | module.az_objectstorage.queue_endpoint |
| secondary_location | The secondary location of the storage account. | module.az_objectstorage.secondary_location |
| storage_defender | The Defender for Storage ID. | module.az_objectstorage.storage_defender |
| [table_endpoint](#output_table_endpoint) | Map with all the Storage Account table Endpoint information. | module.az_objectstorage.table_endpoint |

<a name="AzureObjectStorageSensitiveOutputs"></a>

### Azure Object Storage Sensitive Outputs

| Name| Description | Type |
|:--|:--|:--|
| [access_keys](#output_access_keys) | Map with all the Storage Account Access Keys information. | module.az_objectstorage<br>.access_keys |
| [connection_strings](#output_connection_strings) | Map with all the Storage Account Connection Strings information. | module.az_objectstorage<br>.connection_strings |

### Block Parameters

#### <a name="output_access_keys"></a> [access\_keys](#output\_access\_keys)

| Name | Description | Type |
|------|-------------|------|
| primary\_access\_key | Storage Account Primary access key. |  module.az_objectstorage.access_keys.primary\_access\_key |
| secondary\_access\_key | Storage Account Secondary access key. |  module.az_objectstorage.access_keys.secondary\_access\_key |

#### <a name="output_blob_endpoint"></a> [blob\_endpoint](#output\_blob\_endpoint)

| Name | Description | Type |
|------|-------------|------|
| primary\_blob\_endpoint | The endpoint URL for blob storage in the primary location. |  module.az_objectstorage.blob_endpoint.primary\_blob\_endpoint |
| secondary\_blob\_endpoint | The endpoint URL for blob storage in the secondary location. |  module.az_objectstorage.blob_endpoint.secondary\_blob\_endpoint |

#### <a name="output_connection_strings"></a> [connection\_strings](#output\_connection\_strings)

| Name | Description | Type |
|------|-------------|------|
| primary\_connection\_string | Storage Account Primary connection string. | module.az_objectstorage<br>.connection_strings.primary\_connection\_string |
| secondary\_connection\_string | Storage Account Secondary connection string. | module.az_objectstorage<br>.connection_strings.secondary\_connection\_string |

#### <a name="output_dfs_endpoint"></a> [dfs\_endpoint](#output\_dfs\_endpoint)

| Name | Description | Type |
|------|-------------|------|
| primary\_dfs\_endpoint | The endpoint URL for DFS storage in the primary location. | module.az_objectstorage.dfs_endpoint.primary\_dfs\_endpoint |
| secondary\_dfs\_endpoint | The endpoint URL for DFS storage in the secondary location. | module.az_objectstorage.dfs_endpoint.secondary\_dfs\_endpoint |

#### <a name="output_file_endpoint"></a> [file\_endpoint](#output\_file\_endpoint)

| Name | Description | Type |
|------|-------------|------|
| primary\_file\_endpoint | The endpoint URL for file storage in the primary location. | module.az_objectstorage.file_endpoint.primary\_file\_endpoint |
| secondary\_file\_endpoint | The endpoint URL for file storage in the secondary location. | module.az_objectstorage.file_endpoint.secondary\_file\_endpoint |

#### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

| Name | Description | Type |
|------|-------------|------|
| id |  The ID of the Private Endpoint. | module.az_pep_storage.private_endpoints.id |
| name | The name of the Private Endpoint. | module.az_pep_storage.private_endpoints.name |
| private\_ip\_fqdn | A list of all IP Addresses that map to the private_endpoint fqdn and the fully qualified domain name to the private_endpoint. | module.az_pep_storage.private_endpoints.private\_ip\_fqdn |

#### <a name="output_queue_endpoint"></a> [queue\_endpoint](#output\_queue\_endpoint)

| Name | Description | Type |
|------|-------------|------|
| primary\_queue\_endpoint | The endpoint URL for queue storage in the primary location. | module.az_objectstorage.queue_endpoint. primary\_queue\_endpoint |
| secondary\_queue\_endpoint | The endpoint URL for queue storage in the secondary location. | module.az_objectstorage.queue_endpoint.secondary\_queue\_endpoint |

#### <a name="output_table_endpoint"></a> [table\_endpoint](#output\_table\_endpoint)

| Name | Description | Type |
|------|-------------|------|
| primary\_table\_endpoint | The endpoint URL for table storage in the primary location. | module.az_objectstorage.table_endpoint.primary\_table\_endpoint |
| secondary\_table\_endpoint | The endpoint URL for table storage in the secondary location. | module.az_objectstorage.table_endpoint.secondary\_table\_endpoint |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
|Error: retrieving static website for Storage Account (Subscription: "<azure_subscription_id>" Resource Group Name: "<azure_resource_group_name>" Storage Account Name: "<azure_storage_account_name>"): accounts.Client#GetServiceProperties: Failure responding to request: StatusCode=404 -- Original Error: autorest/azure: Service returned an error. Status=404 Code="ResourceNotFound" Message="The specified resource does not exist.| This error appears randomly when trying to recreate an Azure Storage Account. This issue is related to Azure Storage DNS cache. According to DNS protocol, each storage DNS name is cached at DNS resolvers in the path including client local DNS cache, determined by TTL (Time to Live) and this probably happens due to the DNS endpoint of the storage account name was deleted and changed before the TTL could expire resulting in stale cache value on the client. It may take up to 14 days before a storage account name, that was previously destroyed, can be used again. | Change the name of the storage account you want to create or wait until the name is available again to do the recreation of the Storage Account.|
