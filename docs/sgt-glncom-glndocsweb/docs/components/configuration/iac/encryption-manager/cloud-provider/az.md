# Azure Key Vault and Private Endpoint

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- Azure Resource Group in an Azure Subscription.
- Azure Active Directory (AAD) Service Principal Name (SPN) Level 3 to create all required resources in the previous resource group.

### New Key Vault

- **(Only for Key Vault with allowed Azure subnets into nacls)** If you want to enable firewall rules over the Azure Key Vault, you have to complete the next steps:
  - *(To allow access from all sources): Specify 'Allow' as 'default action'.
  - *(To allow Azure subnet access)* Specify 'Deny' as 'default action' and Specify Azure IP/CIDR network that you want to allow access into the Key Vault.
  - *(To allow Azure subnet access)* Specify 'Deny' as 'default action' and specify 'Microsoft.Keyvault' Service Endpoint has to be enabled into target subnet.
  - *(To allow Azure subnet access)* Specify 'Deny' as 'default action' and take into account that the Service Endpoint network policies has to be enabled into target subnet.
- To deploy key vault with access policies, you need to know the object ID of the user, group, spn, apn designed to allow access and his permissions.
If you only want to allow default permissions, you only put on the variable named "akv_policies" the object id.
- Azure log analytics workspace for Diagnostic settings.
- Azure Storage Account for Diagnostic settings. (Optional)
- Azure Eventhub for Diagnostic settings. (Optional)
- Azure Eventhub Rule for Diagnostic settings. (Optional)

### Existing Key Vault

- An existing Azure key Vault used to store the keys, which should have setup the required permissions and access policy rules to allow the key management/usage.

<a name="AZInputExample"></a>

## Input example

```hcl
az_encryptionmanager = {
  # A new default AKV + Keys are created.
  "01_create_default_akv_keys" = {
    # required variables
    name = "glnd1weuakvemstest011"
    resource_group = "glnd1weursgakvtst080"
    location       = "westeurope"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkakvtst080"
    tenant_id      = "<az_tenant_id>"

    # security
    akv_security_level = "basic"

    # keys
    keys = {
      key_rsa = {
        key_name = "glnd1weuakvkeytest011"
        key_type = "RSA"
        key_size = 2048
        key_opts = [
          "decrypt",
          "encrypt",
          "sign",
          "unwrapKey",
          "verify",
          "wrapKey",
        ]
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_ec = {
        key_name = "glnd1weuakvkeytest002"
        key_type = "EC"
        curve    = "P-256"
        key_opts = ["sign", "verify"]
        # Rotation Policy Block
        expire_after                     = "P28D"
        notify_before_expiry             = "P7D"
        enable_automatic_rotation_policy = true
        time_after_creation              = "P15D"
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      }
    }

    # private endpoint
    pep_name                        = "glnd1weupepiactest011"
    private_service_connection_name = "glnd1weupsciactest011"
    subnet_id                       = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.Network/virtualNetworks/glnd1weuvnetakvtst080/subnets/glnd1weuakvtst080-snt"

    tags = {
      product     = "Gluon AZ KV"
      environment = "dev"
      project     = "Gluon"
    }
  }

  # A new custom AKV + Keys are created.
  "02_create_custom_akv_keys" = {
    # required variables
    name           = "glnd1weuakvemstest012"
    resource_group = "glnd1weursgakvtst080"
    location       = "westeurope"
    tenant_id      = "<az_tenant_id>"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkakvtst080"

    # network access
    subnet_ids = ["/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.Network/virtualNetworks/glnd1weuvnetakvtst080/subnets/glnd1weuakvtst080-snt"]

    # security
    akv_security_level = "basic"

    akv_sku_name                    = "premium"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    soft_delete_retention_days      = 7

    # log analytics workspace
    metrics                         = ["AllMetrics"]
    logs                            = ["AuditEvent"]
    storage_account_id             = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.Storage/storageAccounts/glnd1weustaakvtst080"
    eventhub_name                  = "glnd1weuaehemstest011"
    eventhub_authorization_rule_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.EventHub/namespaces/glnd1weuensakvtst080/authorizationRules/glnd1weunsrakvtst080"
    log_analytics_destination_type = "Dedicated"

    # policies
    akv_policies = {
      "<az_tenant_id>" = {
        key_permissions         = ["Get", "List", "Update", "Delete", "Backup", "Create", "Encrypt", "Decrypt", "Import", "Verify", "WrapKey", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
        secret_permissions      = ["Get", "List", "Delete", "Recover", "Purge", "Restore", "Set", "Backup"]
        certificate_permissions = ["Get", "List", "Update", "Delete", "Backup", "Create", "GetIssuers", "ListIssuers", "DeleteIssuers", "Import", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers"]
        storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
      }
      "<az_tenant_id>" = {
        key_permissions         = ["Get", "List", "Update", "Delete", "Backup", "Create", "Encrypt", "Decrypt", "Import", "Verify", "WrapKey", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
        secret_permissions      = ["Get", "List", "Delete", "Recover", "Purge", "Restore", "Set", "Backup"]
        certificate_permissions = ["Get", "List", "Update", "Delete", "Backup", "Create", "GetIssuers", "ListIssuers", "DeleteIssuers", "Import", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers"]
        storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
      }
    }

    # keys
    keys = {
      key_rsa = {
        key_name = "glnd1weuakvkeytest001"
        key_type = "RSA"
        key_size = 2048
        key_opts = [
          "decrypt",
          "encrypt",
          "sign",
          "unwrapKey",
          "verify",
          "wrapKey",
        ]
        # Rotation Policy Block
        expire_after = "P60D"

        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_ec = {
        key_name = "glnd1weuakvkeytest002"
        key_type = "EC"
        curve    = "P-256"
        key_opts = ["sign", "verify"]
        # Rotation Policy Block
        enable_automatic_rotation_policy = true
        time_after_creation              = "P15D"

        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_rsa_hsm = {
        key_name = "glnd1weuakvkeytest003"
        key_type = "RSA-HSM"
        key_size = 2048
        key_opts = [
          "decrypt",
          "encrypt",
          "sign",
          "unwrapKey",
          "verify",
          "wrapKey",
        ]
        # Rotation Policy Block
        expire_after                     = "P28D"
        notify_before_expiry             = "P7D"
        enable_automatic_rotation_policy = true
        time_after_creation              = "P15D"
        time_before_expiry               = "P14D"

        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_ec_hsm = {
        key_name = "glnd1weuakvkeytest004"
        key_type = "EC-HSM"
        curve    = "P-521"
        key_opts = [
          "sign",
          "verify",
        ]
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      }
    }

    # private endpoint
    subnet_id  = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtst080/providers/Microsoft.Network/virtualNetworks/glnd1weuvnetakvtst080/subnets/glnd1weuakvtst080-snt"

    tags = {
      product     = "Gluon AZ KV"
      environment = "dev"
      project     = "Gluon"
    }
  }

  # An existing AKV is used to create the keys. When an existing AKV is used, only key_vault_id and keys should be provided.
  "03_existing_standard_akv_keys" = {
    # The sku of this key can be both `standard` or `Premium`
    # required variables
    key_vault_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgksctst701/providers/Microsoft.KeyVault/vaults/glnd1weuakvstaksctst701"

    # keys
    keys = {
      key_rsa = {
        key_name = "glnd1weuakvkeytest031"
        key_type = "RSA"
        key_size = 3072
        key_opts = [
          "decrypt",
          "encrypt",
          "sign",
          "unwrapKey",
          "verify",
          "wrapKey",
        ]
        # Rotation Policy Block
        expire_after                     = "P28D"
        notify_before_expiry             = "P7D"
        enable_automatic_rotation_policy = true
        time_before_expiry               = "P14D"

        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_ec = {
        key_name        = "glnd1weuakvkeytest032"
        key_type        = "EC"
        curve           = "P-521"
        not_before_date = "2023-06-01T00:00:00Z"
        key_opts = [
          "sign",
          "verify",
        ]
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      }
    }
  }
  "04_existing_premium_akv_keys" = {
    # The sku of this key has to be `Premium`
    # required variables
    key_vault_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgksctst701/providers/Microsoft.KeyVault/vaults/glnd1weuakvpreksctst701"

    # keys
    keys = {
      key_rsa_hsm = {
        key_name = "glnd1weuakvkeytest033"
        key_type = "RSA-HSM"
        key_size = 2048
        key_opts = [
          "decrypt",
          "encrypt",
          "sign",
          "unwrapKey",
          "verify",
          "wrapKey",
        ]
        # Rotation Policy Block
        notify_before_expiry             = "P7D"
        enable_automatic_rotation_policy = false
        # time_after_creation              = "P15D"
        not_before_date = "2023-06-01T00:00:00Z"
        expiration_date = "2024-12-19T00:00:00Z"
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      },
      key_ec_hsm = {
        key_name = "glnd1weuakvkeytest034"
        key_type = "EC-HSM"
        curve    = "P-521"
        key_opts = [
          "sign",
          "verify",
        ]
        key_tag = {
          product     = "Gluon AZ KV"
          environment = "dev"
          project     = "Gluon"
        }
      }
    }
  }
}
```

## Required parameters for deployment

### New Key Vault

| Name | Description | Type |
|------|-------------|------|
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | <pre>string</pre> |
| lwk_id | Log Analytics Workspace Id to connect the product. | <pre>string</pre> |
| name | Specifies the name of the Key Vault. Changing this forces a new resource to be created. | <pre>string</pre> |
| resource_group | The name of the resource group where to create the Key Vault. Changing this forces a new resource to be created. | <pre>string</pre> |
| tenant_id | Specifies the tenant id to which belongs the subscription. | <pre>string</pre> |

### Existing Key Vault

| Name | Description | Type |
|------|-------------|------|
| key_vault_id | The ID of the Key Vault where the keys should be created. It should only be provided in case you want to use an existing AKV. :warning When the key vault is not created as part of the deployment, ensure SPN used for deployment has an Access Policy and permissions that allows the Keys creation. Changing this forces a new resource to be created. | <pre>string</pre> |

## Optional parameters for deployment

### New Key Vault

| Name | Description | Type | Default |
|------|-------------|------|---------|
| [akv_policies](#input_akv_policies) | A list of up to 16 objects describing access policies with the following parameters: object\_id, permissions. The key is the object\_id of a user, service principal or security group in the Azure Active Directory tenant for the vault. | <pre>map(object({<br>    key_permissions         = list(string)<br>    secret_permissions      = list(string)<br>    certificate_permissions = list(string)<br>    storage_permissions     = list(string)<br>  }))</pre> | {} |
| akv_security_level | Security level of this AKV (basic or sm). | <pre>string</pre> | "sm" |
| akv_sku_name | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | <pre>string</pre> | "standard" |
| analytics_diagnostic_monitor | Specifies the monitor diagnostic name. | <pre>string</pre> | "" |
| bypass | Specifies which traffic can bypass the network rules. Possible values are AzureServices and None. | <pre>string</pre> | "AzureServices" |
| enable_rbac_authorization | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data action. | <pre>bool</pre> | false |
| enabled_for_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. When is true, var.bypass = "AzureServices". | <pre>bool</pre> | false |
| enabled_for_disk_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | <pre>bool</pre> | false |
| enabled_for_template_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | <pre>bool</pre> | false |
| eventhub_authorization_rule_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | <pre>string</pre> | null |
| eventhub_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | <pre>string</pre> | null |
| ip_rules | One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault. | <pre>list(string)</pre> | ["180.156.105.0/24", "193.127.207.0/24", "193.127.200.0/24", "193.127.195.0/24", "40.114.160.224/28", "51.105.242.66", "51.138.73.204", "195.149.215.60", "195.149.215.61", "195.149.215.232", "195.149.215.235", "195.149.215.238", "195.149.215.225", "193.127.193.53", "193.127.193.44", "193.127.217.10", "193.127.229.35", "193.127.251.155", "155.190.0.0/18", "180.156.108.0/25", "180.156.108.128/25", "180.197.190.0/24", "193.127.219.0/24", "193.127.255.1", "193.127.219.1"] |
| log_analytics_destination_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | <pre>string</pre> | "AzureDiagnostics" |
| logs | Specifies the log types that are going to be saved. If a specific log is not longer needed, you could remove the log type from the list. These are all the available logs types ["AuditEvent", "AzurePolicyEvaluationDetails"]. | <pre>any</pre> | [<br>  "AuditEvent",<br>  "AzurePolicyEvaluationDetails"<br>] |
| metrics | Specifies the metric types that are going to be saved. These are all the available metrics types ["AllMetrics"]. | <pre>any</pre> | [<br>  "AllMetrics"<br>] |
| nacl_default_action | The Default Action to use when no rules match from ip\_rules / virtual\_network\_subnet\_ids. Possible values are Allow and Deny. | <pre>string</pre> | "Deny" |
| soft_delete_retention_days | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | <pre>number</pre> | 90 |
| storage_account_id | The ID of the Storage Account where logs should be sent. | <pre>string</pre> | null |
| subnet_ids | One or more Subnet ID's which should be able to access this Key Vault. | <pre>list(string)</pre> | [] |
| pep_name | "Specifies the Name of the Private Endpoint. If not specified, the private endpoint name will be <private_connection_resource_name>-<endpoint_subresource>-pep. Changing this forces a new resource to be created. | string | "" |
| private_service_connection_name | Specifies the Name of the Private Service Connection. If not specified, the private service connection name will be <private_connection_resource_name>-<endpoint_subresource>. Changing this forces a new resource to be created. | string | "" |
| subnet_id | (Required to deploy a Private Endpoint) Subnet Id that must be used to deploy the Private Endpoint that will be attached to the Key Vault. | string | null |
| tags | A map of tags to assign to the resource. This map is a merged structure between custom tags and standard tags. | any | {} |

### New and existing Key Vault

| Name | Description | Type | Default |
|------|-------------|------|---------|
| [keys](#input_keys) | Specifies the map of keys to be created. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_akv_policies"></a> [akv\_policies](#input\_akv\_policies)

```hcl
map(object({
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  }))
```

| Name | Description | Type |
|------|-------------|------|
| certificate_permissions | (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update. | <pre>list(string)</pre> |
| key_permissions | (Optional) List of key permissions. Possible values are Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy and SetRotationPolicy. | <pre>list(string)</pre> |
| secret_permissions | (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set. | <pre>list(string)</pre> |
| storage_permissions | (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update. | <pre>list(string)</pre> |

### <a name="input_keys"></a> [keys](#input\_keys)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| curve | (Optional) Specifies the curve to use when creating an EC key. Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. This field will be required in a future release if key\_type is EC or EC-HSM. The API will default to P-256 if nothing is specified. **Changing this forces a new resource to be created**. | <pre>string</pre> |
| enable_automatic_rotation_policy | (Optional) Enables the Automation Rotation Policy Block within the Rotation Policy Block. :warning: When this parameter is true, at least one of the parameters 'time\_after\_creation' or 'time\_before\_expiry' must be specified. :warning: At least this block or the parameter 'expire\_after' must be defined within a rotation policy block. Default is false. | <pre>bool</pre> |
| expiration_date | (Optional) Expiration UTC datetime (Y-m-d'T'H:M:S'Z'). | <pre>string</pre> |
| expire_after | (Optional) Expire a Key Vault Key after given duration as an ISO 8601 duration. | <pre>string</pre> |
| key_name | (Required) Specifies the name of the Key Vault Key. **Changing this forces a new resource to be created**. | <pre>string</pre> |
| key_opts | (Required) A list of JSON web key operations. Possible values include: `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify` and `wrapKey`. Please note these values are case sensitive. | <pre>list</pre> |
| key_size | (Optional) Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key\_type is `RSA` or `RSA-HSM`. **Changing this forces a new resource to be created**. | <pre>number</pre> |
| key_type | (Required) Specifies the Key Type to use for this Key Vault Key. Possible values are `EC (Elliptic Curve)`, `EC-HSM`, `RSA` and `RSA-HSM`. Be aware that if RSA-HSM or EC-HSM are chosen then the specified key vault needs a Premium sku. **Changing this forces a new resource to be created**. | <pre>string</pre> |
| key_vault_id | (Required) The ID of the Key Vault where the Key should be created. **Changing this forces a new resource to be created**. | <pre>string</pre> |
| not_before_date | (Optional) Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z'). | <pre>string</pre> |
| notify_before_expiry | (Optional) Notify at a given duration before expiry as an ISO 8601 duration. | <pre>string</pre> |
| tags | (Optional) A custom mapping of tags to assign to the resource. | <pre>map</pre> |
| time_after_creation | (Optional) Rotate automatically at a duration after create as an ISO 8601 duration. Cannot be less than 7 days. | <pre>string</pre> |
| time_before_expiry | (Optional) Rotate automatically at a duration before expiry as an ISO 8601 duration. Cannot be less than 7 days. :warning: If this parameter is defined, the parameter 'expire\_after' must also be defined. In addition to this, 'expire\_after' must always be, at least, 7 days greater than this parameter. | <pre>string</pre> |

## Output example

```hcl
az_encryptionmanager = {
  "key_vaults" = {
    "01_create_default_akv_keys" = {
      "akv_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014"
      "akv_location" = "westeurope"
      "akv_name" = "glnd1weuakvemstest014"
      "akv_rsg" = "glnd1weursgakvtest"
      "akv_tags" = tomap({
        "environment" = "dev"
        "product" = "Gluon AZ KV"
        "project" = "Gluon"
      })
      "akv_uri" = "https://glnd1weuakvemstest014.vault.azure.net/"
      "private_endpoints" = {
        "glnd1weupepiactest011-vault-pep" = {
          "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.Network/privateEndpoints/glnd1weupepiactest011-vault-pep"
          "name" = "glnd1weupepiactest011-vault-pep"
          "private_ip_fqdn" = tolist([
            {
              "fqdn" = "glnd1weuakvemstest014.vault.azure.net"
              "ip_addresses" = tolist([
                "10.4.1.4",
              ])
            },
          ])
        }
      }
    }
  }
  "keys" = {
    "01_create_default_akv_keys" = {
      "key_ec" = {
        "akv_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014"
        "akv_rsg" = "glnd1weursgakvtest"
        "e" = ""
        "id" = "https://glnd1weuakvemstest014.vault.azure.net/keys/glnd1weuakvkeytest002/36998fc071b643da918fe74a6d941e1e"
        "n" = ""
        "name" = "glnd1weuakvkeytest002"
        "public_key_openssh" = <<-EOT
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPvGBP4Z+8heUB10Jh5cKOe7G69bnO3FaJz0f0aH+aajGS1QgnPWdMz1GLUqtUfEhwC8ssSNz4th8il1JJLrhQc=
        EOT
        "public_key_pem" = <<-EOT
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE+8YE/hn7yF5QHXQmHlwo57sbr1uc
        7cVonPR/Rof5pqMZLVCCc9Z0zPUYtSq1R8SHALyyxI3Pi2HyKXUkkuuFBw==
        -----END PUBLIC KEY-----
        EOT
        "resource_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014/keys/glnd1weuakvkeytest002/versions/36998fc071b643da918fe74a6d941e1e"
        "resource_versionless_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014/keys/glnd1weuakvkeytest002"
        "version" = "36998fc071b643da918fe74a6d941e1e"
        "versionless_id" = "https://glnd1weuakvemstest014.vault.azure.net/keys/glnd1weuakvkeytest002"
        "x" = "-8YE_hn7yF5QHXQmHlwo57sbr1uc7cVonPR_Rof5pqM"
        "y" = "GS1QgnPWdMz1GLUqtUfEhwC8ssSNz4th8il1JJLrhQc"
      }
      "key_rsa" = {
        "akv_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014"
        "akv_rsg" = "glnd1weursgakvtest"
        "e" = "AQAB"
        "id" = "https://glnd1weuakvemstest014.vault.azure.net/keys/glnd1weuakvkeytest011/399492de1f4545dc869232d7ca03f959"
        "n" = "xU326bpqqJZNThKNaB5lF6SCXx3Nq6L1vSI27FIy_muJsu-hUDxgidwRCXnSD9UTrAmcBQhK5xmCxlFJBtZFstDCK5YRUyXFdAwHMIyut5JgVicuZ3KZaCh3SyvQMG7eimdDpzI0EVOSnnuIJQS0C_cWLZ7ZxONlTQZhq1xKSDV5EDbwWfa4nCAbxxgdr6_72hm9i7f4gTgg5YWAnqmmtNI7iwubdla_tQ7UUTPg9vC6NNKGk7_77ZeLcArZGUb6jYXeBSHXy4zskvXgt0fAgexJtnKa5gkWQMo0G9e546cTSKLfZjNsx98qQOdJGsqCj7-aVTkYxc4wQdfD19FjFQ"
        "name" = "glnd1weuakvkeytest011"
        "public_key_openssh" = <<-EOT
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFTfbpumqolk1OEo1oHmUXpIJfHc2rovW9IjbsUjL+a4my76FQPGCJ3BEJedIP1ROsCZwFCErnGYLGUUkG1kWy0MIrlhFTJcV0DAcwjK63kmBWJy5ncploKHdLK9Awbt6KZ0OnMjQRU5Kee4glBLQL9xYtntnE42VNBmGrXEpINXkQNvBZ9ricIBvHGB2vr/vaGb2Lt/iBOCDlhYCeqaa00juLC5t2Vr+1DtRRM+D28Lo00oaTv/vtl4twCtkZRvqNhd4FIdfLjOyS9eC3R8CB7Em2cprmCRZAyjQb17njpxNIot9mM2zH3ypA50kayoKPv5pVORjFzjBB18PX0WMV
        EOT
        "public_key_pem" = <<-EOT
        -----BEGIN PUBLIC KEY-----
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxU326bpqqJZNThKNaB5l
        F6SCXx3Nq6L1vSI27FIy/muJsu+hUDxgidwRCXnSD9UTrAmcBQhK5xmCxlFJBtZF
        stDCK5YRUyXFdAwHMIyut5JgVicuZ3KZaCh3SyvQMG7eimdDpzI0EVOSnnuIJQS0
        C/cWLZ7ZxONlTQZhq1xKSDV5EDbwWfa4nCAbxxgdr6/72hm9i7f4gTgg5YWAnqmm
        tNI7iwubdla/tQ7UUTPg9vC6NNKGk7/77ZeLcArZGUb6jYXeBSHXy4zskvXgt0fA
        gexJtnKa5gkWQMo0G9e546cTSKLfZjNsx98qQOdJGsqCj7+aVTkYxc4wQdfD19Fj
        FQIDAQAB
        -----END PUBLIC KEY-----
        EOT
        "resource_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014/keys/glnd1weuakvkeytest011/versions/399492de1f4545dc869232d7ca03f959"
        "resource_versionless_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgakvtest/providers/Microsoft.KeyVault/vaults/glnd1weuakvemstest014/keys/glnd1weuakvkeytest011"
        "version" = "399492de1f4545dc869232d7ca03f959"
        "versionless_id" = "https://glnd1weuakvemstest014.vault.azure.net/keys/glnd1weuakvkeytest011"
        "x" = ""
        "y" = ""
      }
    }
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|az_encryptionmanager|module.az_encryptionmanager + module.az_encryptionmanager_pep + module.az_encryptionmanager_ksc |AZ Encryption Manager outputs map. <br>[Map AZ Encryption Manager Outputs](#az_encryption_manager_outputs). |

<a name="az_encryption_manager_outputs"></a> [az_encryption_manager_outputs](#az\_encryption\_manager\_outputs)

### AZ Encryption Manager Outputs

| Name | Description | Type |
|------|-------------|------|
| [key_vaults](#output_key_vaults) | Map with the Key Vault information. | <pre>module.az_encryptionmanager.key_vaults</pre> |
| [keys](#output_keys) | Map with all the Key Vault Keys information. | <pre>module.az_encryptionmanager_ksc.keys</pre> |
| [private_endpoints](#output_private_endpoints) | Map with all the Private Endpoints information.| <pre>module.az_encryptionmanager_pep.private_endpoints</pre>|

### Block Parameters

#### <a name="output_key_vaults"></a> [key_vaults](#output\_key\_vaults)

| Name | Description | Type |
|------|-------------|------|
| akv_id | Azure Key Vault Id. | <pre>module.az_encryptionmanager.key_vaults.akv_id</pre> |
| akv_location | Specifies the supported Azure location where the resource has been created. | <pre>module.az_encryptionmanager.key_vaults.akv_location</pre> |
| akv_name | Azure Key Vault Name. | <pre>module.az_encryptionmanager.key_vaults.akv_name</pre> |
| akv_rsg | Azure Key Vault Resource Group Name. | <pre>module.az_encryptionmanager.key_vaults.akv_rsg</pre> |
| akv_tags | Azure Key Vault Tags. | <pre>module.az_encryptionmanager.key_vaults.akv_tags</pre> |
| akv_uri | Azure Key Vault URI. | <pre>module.az_encryptionmanager.key_vaults.akv_uri</pre> |

#### <a name="output_keys"></a> [keys](#output\_keys)

| Name | Description | Type |
|------|-------------|------|
| akv\_id | The ID of the Key Vault where the Key is created. | <pre>module.az_encryptionmanager_ksc.akv_id</pre> |
| akv\_rsg | The Resource Group of the Key Vault where the Key is created. | <pre>module.az_encryptionmanager_ksc.akv_rsg</pre> |
| e | The RSA public exponent of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.e</pre> |
| id | The Key Vault Key ID. | <pre>module.az_encryptionmanager_ksc.id</pre> |
| n | The RSA modulus of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.n</pre> |
| name | The Key Vault Key name. | <pre>module.az_encryptionmanager_ksc.name</pre> |
| public\_key\_openssh | The OpenSSH encoded public key of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.public_key_openssh</pre> |
| public\_key\_pem | The PEM encoded public key of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.public_key_pem</pre> |
| resource\_id | The (Versioned) ID for this Key Vault Key. This property points to a specific version of a Key Vault Key, as such using this won't auto-rotate values if used in other Azure Services. | <pre>module.az_encryptionmanager_ksc.resource_id</pre> |
| resource\_versionless\_id | The Versionless ID of the Key Vault Key. This property allows other Azure Services (that support it) to auto-rotate their value when the Key Vault Key is updated. | <pre>module.az_encryptionmanager_ksc.resource_versionless_id</pre> |
| version | The current version of the Key Vault Key. | <pre>module.az_encryptionmanager_ksc.version</pre> |
| versionless\_id | The Base ID of the Key Vault Key. | <pre>module.az_encryptionmanager_ksc.versionless_id</pre> |
| x | The EC X component of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.x</pre> |
| y | The EC Y component of this Key Vault Key. | <pre>module.az_encryptionmanager_ksc.y</pre> |

#### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

| Name | Description | Type |
|------|-------------|------|
| id |  The ID of the Private Endpoint. | <pre>module.az_encryptionmanager_pep.private_endpoints.id</pre> |
| name | The name of the Private Endpoint. | <pre>module.az_encryptionmanager_pep.private_endpoints.name</pre> |
| private\_ip\_fqdn | A list of all IP Addresses that map to the private_endpoint fqdn and the fully qualified domain name to the private_endpoint. | <pre>module.az_encryptionmanager_pep.private_endpoints.private\_ip\_fqdn</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
