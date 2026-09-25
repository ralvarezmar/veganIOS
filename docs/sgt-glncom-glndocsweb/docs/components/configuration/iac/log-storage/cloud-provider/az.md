# Azure Log Analytics Workspace

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- Azure Resource Group within Azure subscription with the following components:
    - Azure private link scoped service. (Required if private_link_scoped_service_enabled is true)
    - Data Collection rule to use for the workspace. (Optional)

<a name="AZInputExample"></a>

## Input example

```hcl
az_logstorage = {
  "lwk_default" = {
    name           = "glnd1weulwkglniactest001"
    resource_group = "glnd1weursgglniactest001"
    location       = "westeurope"

    # Tagging
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon Azure Log Analytics Workspace"
    }
  }

  "lwk_complete" = {
    name              = "glnd1weulwkglniactest002"
    resource_group    = "glnd1weursgglniactest001"
    location          = "westeurope"
    lwk_sku_name      = "PerGB2018"
    retention_in_days = 90

    lwk_enabled = true
    lwk_id      = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobalplat001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobalplat001"

    internet_ingestion_enabled = true
    internet_query_enabled     = true

    allow_resource_only_permissions = true
    local_authentication_disabled   = false

    # Tagging
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon Azure Log Analytics Workspace"
    }
  }

  "lwk_w_private" = {
    name           = "glnd1weulwkglniactest003"
    resource_group = "glnd1weursgglniactest001"
    location       = "westeurope"

    lwk_sku_name      = "PerGB2018"
    retention_in_days = 90

    # Private Link
    private_link_scoped_service_enabled = true
    private_link_rsg                    = "glnd1weursgglniactest001"
    private_link_scope_name             = "glnd1weuaislinkglobaltest001"
    private_link_scoped_service_name    = "glnd1weulwkpipglniactest001"

    # Tagging
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon Azure Log Analytics Workspace"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created. | <pre>string</pre> |
| resource_group | The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created. | <pre>string</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aeh_enabled | Boolean value that indicates whether or not to use an Event Hub to stream the logs. | <pre>string</pre> | false |
| allow_resource_only_permissions | Specifies if the log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace. | <pre>bool</pre> | true |
| analytics_diagnostic_monitor_name | The name of the Analytics Diagnostic Monitor. | <pre>string</pre> | "" |
| daily_quota_gb | The workspace daily quota for ingestion in GB. | <pre>number</pre> | -1 |
| data_collection_rule_id | The ID of the Data Collection Rule to use for this workspace. | <pre>string</pre> | null |
| eventhub_authorization_rule_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | <pre>string</pre> | null |
| eventhub_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. If this isn't specified then the default Event Hub will be used. | <pre>string</pre> | null |
| internet_ingestion_enabled | Should the Log Analytics Workspace support ingestion over the Public Internet? | <pre>bool</pre> | false |
| internet_query_enabled | Should the Log Analytics Workspace support querying over the Public Internet? | <pre>bool</pre> | false |
| local_authentication_disabled | Specifies if the log Analytics workspace should enforce authentication using Azure AD. | <pre>bool</pre> | false |
| log_analytics_destination_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | <pre>string</pre> | "AzureDiagnostics" |
| logs | Specifies the log types that are going to be saved. If a specific log is not longer needed, you could remove the log type from the list. | <pre>any</pre> | [<br>  "Audit",<br>  "SummaryLogs"<br>] |
| lwk_enabled | Boolean value that indicates whether or not to use an Log Analytics Workspace to stream the logs. | <pre>string</pre> | false |
| lwk_id | Log Analytics Workspace id. | <pre>string</pre> | null |
| lwk_sku_name | Specifies the Sku of the Log Analytics Workspace. Possible values are CapacityReservation and PerGB2018. Changing sku forces a new Log Analytics Workspace to be created, except when changing between PerGB2018 and CapacityReservation. :warning: changing sku to 'CapacityReservation' or changing 'reservation\_capacity\_in\_gb\_per\_day' to a higher tier will lead to a 31-days commitment period, during which the SKU cannot be changed to a lower one. | <pre>string</pre> | "PerGB2018" |
| metrics | Specifies the metric types that are going to be saved. These are all the available metrics types ["AllMetrics"]. | <pre>any</pre> | [<br>  "AllMetrics"<br>] |
| private_link_rsg | (Required if private\_link\_scoped\_service\_enabled is true) The name of the Resource Group where the Azure Monitor Private Link Scoped Service should exist. Changing this forces a new resource to be created. | <pre>string</pre> | "" |
| private_link_scope_name | (Required if private\_link\_scoped\_service\_enabled is true) The name of the Azure Monitor Private Link Scope. The Private link resource indicated here must exist in the resource group indicated in the 'private\_link\_rsg' variable, otherwise the deployment will fail. Changing this forces a new resource to be created. | <pre>string</pre> | "" |
| private_link_scoped_service_enabled | Should the Log Analytics WorkSpace component have a private link associated with it? | <pre>bool</pre> | false |
| private_link_scoped_service_name | (Required if private\_link\_scoped\_service\_enabled is true) The name of the Azure Monitor Private Link Scoped Service. Changing this forces a new resource to be created. | <pre>string</pre> | "" |
| reservation_capacity_in_gb_per_day | The capacity reservation level in GB for this workspace. Possible values are 100, 200, 300, 400, 500, 1000, 2000 and 5000. :warning: changing 'reservation\_capacity\_in\_gb\_per\_day' to a higher tier will lead to a 31-days commitment period, during which the SKU cannot be changed to a lower one. | <pre>number</pre> | null |
| retention_in_days | The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | <pre>number</pre> | 30 |
| sta_enabled | Boolean value that indicates whether or not to use a storage account to store the logs. | <pre>string</pre> | false |
| storage_account_id | The ID of the Storage Account where logs should be sent. | <pre>string</pre> | null |
| tags | A map of tags to assign to the resource. This map is a merged structure between custom tags and standard tags. | <pre>any</pre> | {} |

## Output example

```hcl
az_logstorage = {
  "lwk_complete" = {
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobalplat001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglniactest002"
    "name" = "glnd1weulwkglniactest002"
    "private_service_id" = []
    "resource_group_name" = "glnd1weursgglobalplat001"
    "workspace_id" = "a18705cf-25d5-41bb-a5f7-9f237dff323f"
  }
  "lwk_default" = {
    "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobalplat001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglniactest001"
    "name" = "glnd1weulwkglniactest001"
    "private_service_id" = []
    "resource_group_name" = "glnd1weursgglobalplat001"
    "workspace_id" = "0de0d5b1-4c0b-41f0-82f4-962dbc4a7bfe"
  }
}
az_logstorage_sensitive = <sensitive>
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|az_logstorage|module.az_logstorage|AZ Log Storage outputs map. <br>[Map AZ Log Storage Outputs](#AZ Log Storage Outputs). |
|az_logstorage|module.az_logstorage|AZ Log Storage Sensitive outputs map. <br>[Map AZ Log Storage Sensitive Outputs](#AZ Log Storage Sensitive Outputs). |

<a name="AZ Log Storage Outputs"></a>

### AZ Log Storage Outputs

| Name | Description | Type |
|------|-------------|------|
| id | Azure Log Analytics Id. | <pre>module.az_logstorage.id</pre> |
| name | Azure Log Analytics Workspace Name. | <pre>module.az_logstorage.name</pre> |
| private_service_id | The ID of the Azure Monitor Private Link Scoped Service. | <pre>module.az_logstorage.private_service_id</pre> |
| resource_group_name | Azure Log Analytics Workspace Resource Group Name. | <pre>module.az_logstorage.resource_group_name</pre> |
| workspace_id | The Workspace (or Customer) ID for the Log Analytics Workspace. | <pre>module.az_logstorage.workspace_id</pre> |

<a name="AZ Log Storage Sensitive Outputs"></a>

### AZ Log Storage Sensitive Outputs

| Name | Description | Type |
|------|-------------|------|
| primary_shared_key | The Primary shared key for the Log Analytics Workspace. | <pre>module.az_logstorage.primary_shared_key</pre> |
| secondary_shared_key | The Secondary shared key for the Log Analytics Workspace. | <pre>module.az_logstorage.secondary_shared_key</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
| Workspaces cannot be created or updated to free, standard or premium tiers.|New workspaces to be created cannot be Free, Standard, or Premium tier. [Documentation Cost Tier](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs#free-trial-pricing-tier). | Those that are already created can continue to be used but the new ones must be of a different level from those already mentioned.|
