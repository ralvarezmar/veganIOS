# Azure Container Registry and Private Endpoint

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- Azure Resource Group within Azure subscription with the following components:
    - Azure Key Vault to store the key created with the module or Azure Key Vault Key to encrypt the Container Registry. (Required when security level is 'sa').
    - Azure Keyvault Key for the encryption. (Optional)
    - Azure User Assigned Identity for the encryption. (Optional)
    - Azure log analytics workspace for Diagnostic settings. (Optional)
    - Azure Storage Account for Diagnostic settings. (Optional)
    - Azure Eventhub for Diagnostic settings. (Optional)
    - Azure subnet for the Private Endpoint.

<a name="AZInputExample"></a>

## Input example

```hcl
az_containerregistry = {
  "00_acr_default" = {
    # -----------------------
    # Required variables
    # -----------------------
    name           = "glnd1weucreiactest001"
    resource_group = "glnd1weursgiactest001"
    location       = "westeurope"

    # ---------------------------
    # Azure Diagnostic settings
    # ---------------------------
    lwk_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkiactest001"

    # -----------------------
    # Azure Private Endpoint
    # -----------------------
    subnet_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvnetiactest001/subnets/glnd1weusnetiactest001-snt002"

    # -----------------------
    # Tagging
    # -----------------------
    tags = {
      product     = "Gluon Azure Container Registry"
      description = "Gluon Azure Container Registry Test"
      environment = "dev"
    }
  }

  "01_acr_full" = {
    # -----------------------
    # Required variables
    # -----------------------
    name           = "glnd1weucreiactest003"
    resource_group = "glnd1weursgiactest001"
    location       = "westeurope"

    # -----------------------
    # User Managed Identity
    # -----------------------
    create_identity = false

    # -----------------------
    # AKV Key
    # -----------------------
    security_level = "sa"
    akv_id         = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.KeyVault/vaults/glnd1weuakviactest001"
    akv_key_tags = {
      test = "Test Key Tag"
    }

    # --------------------------
    # Azure Container Registry
    # --------------------------
    admin_enabled          = true
    managed_identity_ids   = ["/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/glnd1weuuaicretest001", "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/glnd1weuuaienccretest001"]
    encryption_identity_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/glnd1weuuaienccretest001"

    zone_redundancy_enabled   = true
    export_policy_enabled     = true
    data_endpoint_enabled     = true
    quarantine_policy_enabled = true

    retention_policy = {
      days    = 10
      enabled = true
    }

    georeplications = {
      centralus = {
        location                  = "centralus"
        regional_endpoint_enabled = false
        zone_redundancy_enabled   = false
        tags                      = {}
      }
      eastus = {
        location                  = "eastus"
        regional_endpoint_enabled = true
        zone_redundancy_enabled   = true
        tags                      = {}
      }
    }

    registry_tags = {
      test = "Test ACR Tag"
    }

    # ------------------------------------
    # Azure Container Registry Scope Map
    # ------------------------------------
    scope_maps = {
      scope1 = {
        description = "description scope 1"
        actions = [
          "repositories/repo1/content/read",
          "repositories/repo1/content/write"
        ]
      }
      scope2 = {
        description = "description scope 2"
        actions = [
          "repositories/repo1/content/read"
        ]
      }
    }

    # ---------------------------
    # Azure Diagnostic settings
    # ---------------------------
    analytics_diagnostic_monitor_name = "glnd1weudgsiactest001"
    sta_enabled                       = true
    storage_account_id                = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.Storage/storageAccounts/glnd1weustaiactest001"

    # -----------------------
    # Azure Private Endpoint
    # -----------------------
    pep_name  = "glnd1weupepiactest003"
    subnet_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvnetiactest001/subnets/glnd1weusnetiactest001-snt002"

    # -----------------------
    # Tagging
    # -----------------------
    tags = {
      product     = "Gluon Azure Container Registry"
      description = "Gluon Azure Container Registry Test"
      environment = "dev"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | string |
| name | Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created. | string |
| resource_group | The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | string |
| subnet_id | Subnet Id that must be used to deploy the Private Endpoint that will be attached to the Container Registry. | string |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| admin_enabled | Specifies whether the admin user is 'enabled' or not. | bool | false |
| aeh_enabled | Boolean value that indicates whether or not to use an Event Hub to stream the logs. | bool | false |
| akv_id | ID of the Azure Key Vault used to store sensitive data. The AKV ID is required when the security level is 'sa'. | string | "" |
| akv_key | The ID of the existing AKV key that will be used to encrypt the Container Registry resource when 'var.security_level' is 'sa'. If not provided and 'var.security_level' is 'sa', a new AKV key will be created with the name '<var.name>-cmkkey'. | string | "" |
| akv_key_tags | AKV Key extra tags. This map will be merged with the common tags defined in the variable 'var.tags'. | any | {} |
| analytics_diagnostic_monitor_name | The name of the Analytics Diagnostic Monitor. | string | "" |
| create_identity | Boolean value that indicates whether or not to create the managed identity. | bool | true |
| data_endpoint_enabled | Whether to enable dedicated data endpoints for this Container Registry. This is only supported on resources with the Premium SKU. | bool | false |
| enable_automatic_rotation_policy | Enables the automatic rotation policy for the created AKV key. :warning: If it is set to 'false', the attribute 'time\_before\_expiry' must not be set. | bool | true |
| encryption_identity_id | Specifies the user assigned managed identity that is going to be used in the encryption. If not specified the user assigned identity created in the module is going to be used. | string | "" |
| eventhub_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. If this isn't specified then the default Event Hub will be used. | string | null |
| eventhub_authorization_rule_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. :warning: At least one of 'eventhub_authorization_rule_id', 'lwk_id' and 'storage_account_id' must be specified. | string | null |
| expire_after | Expire a Key Vault Key after given duration as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Must always be, at least, 7 days greater than the attribute 'time\_before\_expiry'. Minimum allowed value is 'P28D'. | string | "P25M" |
| export_policy_enabled | Boolean value that indicates whether export policy is enabled. In order to set it to true, make sure the public_network_access_enabled is also set to true. 'export_policy_enabled' is only supported on resources with the Premium SKU. | bool | false |
| [georeplications](#input_georeplications) | Updated structure for Azure locations where the container registry should be geo-replicated. :warning: The georeplications is only supported on new resources with the Premium SKU. :warning: The georeplications list cannot contain the location where the Container Registry exists. If more than one georeplications block is specified, they are expected to follow the alphabetic order on the location property. | any | {} |
| identity_name | Specifies the name of the User Assigned Identity. If not provided, the name will be: <var.name>-idm. Changing this forces a new User Assigned Identity to be created. | string | "" |
| identity_tags | User assigned identity extra tags. This map will be merged with the common tags defined in the variable 'var.tags'. | any | {} |
| ips_filter | List of CIDR blocks from which requests will match the rule. Only supported with the Premium SKU at this time. | list(any) | [] |
| log_analytics_destination_type | Supported values are 'AzureDiagnostics' and 'Dedicated', default to 'AzureDiagnostics'. When set to 'Dedicated', logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. :warning: This setting will only have an effect if a 'lwk_id' is provided. | string | "AzureDiagnostics" |
| logs | Specifies the log types that are going to be saved. These are all the available logs types: 'ContainerRegistryLoginEvents, 'ContainerRegistryRepositoryEvents'. | any | [<br>  "ContainerRegistry<br>LoginEvents",<br>  "ContainerRegistry<br>RepositoryEvents"<br>] |
| lwk_id | Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. :warning: At least one of 'eventhub_authorization_rule_id', 'lwk_id' and 'storage_account_id' must be specified. | string | null |
| managed_identity_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry. | list(any) | [] |
| metrics | Specifies the metrics types that are going to be saved. These are all the available metrics types:['AllMetrics']. | any | ["AllMetrics"] |
| network_rule_bypass_option | Whether to allow trusted Azure services to access a network restricted Container Registry. Possible values are 'None' and 'AzureServices'. | string | "AzureServices" |
| notify_before_expiry | Notify at a given duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Minimum allowed value is 'P7D'. | string | "P7D" |
| pep_name | "Specifies the Name of the Private Endpoint. If not specified, the private endpoint name will be <private_connection_resource_name>-<endpoint_subresource>-pep. Changing this forces a new resource to be created. | string | "" |
| private_service_connection_name | Specifies the Name of the Private Service Connection. If not specified, the private service connection name will be <private_connection_resource_name>-<endpoint_subresource>. Changing this forces a new resource to be created. | string | "" |
| public_network_access_enabled | Whether public network access is allowed for the container registry. :warning: Disabling public network access is only supported on resources with the Premium SKU. | bool | false |
| quarantine_policy_enabled | Boolean value that indicates whether quarantine policy is enabled. | bool | false |
| registry_tags | Container registry extra tags. This map will be merged with the common tags defined in the variable var.tags. | any | {} |
| [retention_policy](#input_retention_policy) | Map to define retention policy. retention_policy is only supported on resources with the Premium SKU. | any | {} |
| [scope_maps](#input_scope_maps) | Map to define multiple scope maps for Container Registry. | any | {} |
| security_level | Security level for Container Registry. Possible values are 'sm' or 'sa'. | string | "sm" |
| sku | The SKU name of the container registry. Possible values are: 'Basic', 'Standard', 'Premium' and 'Classic' (which is currently 'Basic') is supported only for existing resources. | string | "Premium" |
| storage_account_id | The ID of the Storage Account where logs should be sent. :warning: At least one of 'eventhub_authorization_rule_id', 'lwk_id' and 'storage_account_id' must be specified. | string | null |
| sta_enabled | Boolean value that indicates whether or not to use a storage account to store the logs. | bool | false |
| tags | map of tags to assign to the resource. This map contains the tags that are common to all the resources deployed by the module. | any | {} |
| tenant_id | Tenant id. | string | null |
| time_before_expiry | Rotate automatically at a duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This attribute must only be set when 'enable\_automatic\_rotation\_policy' is 'true'. Defaults to 'P1M' if 'enable\_automatic\_rotation\_policy' is 'true', otherwise 'null'. :warning: The attribute 'expire\_after' must always be, at least, 7 days greater than this parameter. | string | null |
| trust_policy_enabled | Boolean value that indicates whether the policy is enabled. 'trust_policy' is only supported on resources with the Premium SKU and without CMK encryption. | bool | false |
| zone_redundancy_enabled | Whether zone redundancy is enabled for this Container Registry. :warning: 'zone_redundancy_enabled' is only supported on resources with the Premium SKU. Changing this forces a new resource to be created. | bool | false |

## Block Parameters

### <a name="input_georeplications"></a> [Georeplications](#input_georeplications)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| location | (Required) A location where the container registry should be geo-replicated. | string |
| regional_endpoint_enabled | (Optional) Whether regional endpoint is enabled for this Container Registry?. Default is false. | bool |
| tags | A mapping of tags to assign to this replication location. | any |
| zone_redundancy_enabled | (Optional) Whether zone redundancy is enabled for this replication location? :warning: Changing the zone_redundancy_enabled forces the a underlying replication to be created. Defaults to false. | bool |

### <a name="input_retention_policy"></a> [Retention policy](#input\_retention\_policy)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| days | (Optional) The number of days to retain an untagged manifest after which it gets purged. Default is 7. | number |
| enabled | (Optional) Boolean value that indicates whether the policy is enabled. | bool |

### <a name="input_scope_maps"></a> [Scope maps](#input\_scope\_maps)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| actions | (Required) A list of actions to attach to the scope map (e.g. repo/content/read, repo2/content/delete). | list(string) |
| description | (Optional) The description of the Container Registry. | string |
| scope_name | (Optional) Specifies the name of the scope map. Changing this forces a new resource to be created. If not specified the scope map name will be defined using the following format: <container\_registry\_name>-scope-<map\_key>. | string |
| token_name | (Optional) Specifies the name of the token. Changing this forces a new resource to be created. If not specified the token name will be defined using the following format: <container\_registry\_name>-token-<map\_key>. | string |

## Output example

```hcl
az_containerregistry = {
  "00_acr_default" = {
    "admin_username" = ""
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest001"
    "key_vault_key_id" = null
    "location" = "westeurope"
    "login_server" = "glnd1weucreiactest001.azurecr.io"
    "name" = "glnd1weucreiactest001"
    "network_rule_set" = {
      "default_action" = [
        "Deny",
      ]
      "ip_rule" =[]
      "virtual_network" = null
    }
    "private_endpoints" = {
      "glnd1weucreiactest001-registry-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.Network/privateEndpoints/glnd1weucreiactest001-registry-pep"
        "name" = "glnd1weucreiactest001-registry-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weucreiactest001.westeurope.data.azurecr.io"
            "ip_addresses" = [
              "172.17.0.11",
            ]
          },
          {
            "fqdn" = "glnd1weucreiactest001.azurecr.io"
            "ip_addresses" = [
              "172.17.0.12",
            ]
          },
        ]
      }
    }
    "resource_group" = "glnd1weursgiactest001"
    "scope_ids" = {}
    "token_ids" = {}
  }
  "01_acr_scopemaps" = {
    "admin_username" = ""
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004"
    "key_vault_key_id" = "https://glnd1weuakviactest001.vault.azure.net/keys/glnd1weucreiactest004-cmkkey/531fda922b7f4d678b8e66495bb7fa8f"
    "location" = "westeurope"
    "login_server" = "glnd1weucreiactest004.azurecr.io"
    "name" = "glnd1weucreiactest004"
    "network_rule_set" = {
      "default_action" = [
        "Deny",
      ]
      "ip_rule" = []
      "virtual_network" = null
    }
    "private_endpoints" = {
      "glnd1weucreiactest004-registry-pep" = {
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.Network/privateEndpoints/glnd1weucreiactest004-registry-pep"
        "name" = "glnd1weucreiactest004-registry-pep"
        "private_ip_fqdn" = [
          {
            "fqdn" = "glnd1weucreiactest004.westeurope.data.azurecr.io"
            "ip_addresses" = [
              "172.17.0.15",
            ]
          },
          {
            "fqdn" = "glnd1weucreiactest004.azurecr.io"
            "ip_addresses" = [
              "172.17.0.6",
            ]
          },
        ]
      }
    }
    "resource_group" = "glnd1weursgiactest001"
    "scope_ids" = {
      "scope1" = {
        "actions" = [
          "repositories/repo1/content/read",
          "repositories/repo1/content/write",
        ]
        "container_registry_name" = "glnd1weucreiactest004"
        "description" = "description scope 1"
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/scopeMaps/myscope01"
        "name" = "myscope01"
        "resource_group_name" = "glnd1weursgiactest001"
        "timeouts" = null /* object */
      }
      "scope2" = {
        "actions" = [
          "repositories/repo1/content/read",
        ]
        "container_registry_name" = "glnd1weucreiactest004"
        "description" = "description scope 2"
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/scopeMaps/myscope02"
        "name" = "myscope02"
        "resource_group_name" = "glnd1weursgiactest001"
        "timeouts" = null /* object */
      }
    }
    "token_ids" = {
      "scope1" = {
        "container_registry_name" = "glnd1weucreiactest004"
        "enabled" = true
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/tokens/mytoken01"
        "name" = "mytoken01"
        "resource_group_name" = "glnd1weursgiactest001"
        "scope_map_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/scopeMaps/myscope01"
        "timeouts" = null /* object */
      }
      "scope2" = {
        "container_registry_name" = "glnd1weucreiactest004"
        "enabled" = true
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/tokens/mytoken02"
        "name" = "mytoken02"
        "resource_group_name" = "glnd1weursgiactest001"
        "scope_map_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgiactest001/providers/Microsoft.ContainerRegistry/registries/glnd1weucreiactest004/scopeMaps/myscope02"
        "timeouts" = null /* object */
      }
    }
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|az_containerregistry|module.az_containerregistry && module.az_containerregistry_pep |AZ Container Registry outputs map. <br>[Map AZ Container Registry Outputs](#AZ Container Registry Outputs). |
|az_containerregistry_sensitive|module.az_containerregistry|AZ Container Registry sensitive outputs map. <br>[Map AZ Container Registry Sensitive Outputs](#AZ Container Registry Sensitive Outputs).  |

<a name="AZ Container Registry Outputs"></a>

### AZ Container Registry Outputs

| Name| Output value | Description |
|:--|:--|:--|
| admin_username | module.az_containerregistry.admin_username | The Username associated with the Container Registry Admin account. Only when 'admin' account is enabled. |
| id | module.az_containerregistry.id | The Container Registry ID. |
| key_vault_key_id | module.az_containerregistry.key_vault_key_id | Key vault key ID used to encrypt the Container Registry. |
| location | module.az_containerregistry.location | The Azure Container Registry location. |
| login_server | module.az_containerregistry.login_server | The URL that can be used to log into the container registry. |
| name | module.az_containerregistry.name | The name of the Container Registry. |
| [network_rule_set](#output_network_rule_set)| module.az_containerregistry.network_rule_set | The Container Registry network rule set.|
| resource_group | module.az_containerregistry.resource_group | The Azure Container Registry Resource group name. |
|[scope_ids](#output_scope_ids) | module.az_containerregistry.scope_ids | Key/value structure with the Container Registry Scope IDs. |
|[token_ids](#output_token_ids) | module.az_containerregistry.token_ids | Key/value structure with the Container Registry Token IDs. |
| [private_endpoints](#output_private_endpoints) | module.az_containerregistry_pep.private_endpoints | Map with all the Private Endpoints information.|

<a name="AZ Container Registry Sensitive Outputs"></a>

### AZ Container Registry Sensitive Outputs

| Name| Output value | Description |
|:--|:--|:--|
|admin_password | module.az_containerregistry_sensitive.admin_password | The Password associated with the Container Registry Admin account. Only when 'admin' account is enabled. |

### Block Parameters

#### <a name="output_network_rule_set"></a> [network_rule_set](#output_network_rule_set)

| Name | Description | Type |
|------|-------------|------|
| default_action | The behaviour for requests matching no rules. | module.az_containerregistry.network_rule_set.default_action |
| ip_rule | One or more ip_rules. | module.az_containerregistry.network_rule_set.ip_rule |

#### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

| Name | Description | Type |
|------|-------------|------|
| id |  The ID of the Private Endpoint. | module.az_containerregistry_pep.private_endpoints.id |
| name | The name of the Private Endpoint. | module.az_containerregistry_pep.private_endpoints.name |
| private\_ip\_fqdn | A list of all IP Addresses that map to the private_endpoint fqdn and the fully qualified domain name to the private_endpoint. | module.az_containerregistry_pep.private_endpoints.private\_ip\_fqdn |

#### <a name="output_scope_ids"></a> [Scope ids](#output\_scope\_ids)

| Name | Output value | Description |
|------|-------------|------|
| actions | module.az_containerregistry.scope_ids.actions | A list of actions to attach to the scope map. |
| container_registry_name | module.az_containerregistry.scope_ids.container_registry_name | The name of the Container Registry. |
| description | module.az_containerregistry.scope_ids.description | The description of the Container Registry. |
| name | module.az_containerregistry.scope_ids.name | Specifies the name of the scope map. |
| resource_group_name | module.az_containerregistry.scope_ids.resource_group_name | The name of the resource group in which to create the Container Registry token. |

#### <a name="output_token_ids"></a> [Token ids](#output\_token\_ids)

| Name | Output value | Description |
|------|-------------|------|
| container_registry_name | module.az_containerregistry.token_ids.container_registry_name | The name of the Container Registry. |
| enabled | module.az_containerregistry.token_ids.enabled | Specifies if the container registry token is enabled or not. |
| name | module.az_containerregistry.token_ids.name | Specifies the name of the token. |
| resource_group_name | module.az_containerregistry.token_ids.resource_group_name | The name of the resource group in which to create the Container Registry token. |
| scope_map_id | module.az_containerregistry.token_ids.scope_map_id | The ID of the Container Registry Scope Map associated with the token. |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
