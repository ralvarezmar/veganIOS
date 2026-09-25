# Azure Kubernetes Service

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

* Azure Active Directory (AAD) Service Principal Name (SPN) Level 3 to create all required resources in the resource group.
* Network firewall rules required.
* **User Assigned Managed Identity** to use as the AKS identity (identity_ids). This Managed Identity must be member of "*Network Contributor*" Azure role in network where AKS will be located in.
(Optional, can be created through the module with 'var.create_uai', but for this, a Service Principal Name (SPN) Level 2 will be needed.)
* A **virtual network** that allows outbound internet connectivity. More details and reference: <https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic>
* A **subnet** into the previous virtual network that meets the following:
  * The User Assigned Managed Identity that you use as the AKS identity should have "*Network Contributor*" role on the route table assigned to your subnet.
  If the User Assigned identity is created through the module, this role is added automatically to the created User Assigned identity, using the route table provided in the tfvars.
  * ⚠️ Don't create more than one AKS cluster in the subnet. ⚠️
  * The minimum subnet size should be /28 (9 hosts).
  * A dedicated route table (RTB) should be configured in this subnet. Several route table entries will be managed by the AKS.
* It is necessary to provide the **Private DNS Zone** and will be necessary to grant to the Managed Identity read/write permissions on this Private DNS Zone.
If the User Assigned identity is created through the module, these permissions are added automatically to the created User Assigned identity, using the Private DNS Zone provided in the tfvars.
* Workers SSH Admin username and Public Key created as secrets in the key vault provided as input:
  * aks_username
  * aks_ssh_key
* It is important to note that you have to check the **versions** available for the region where you want to deploy the cluster (To find out what versions are currently available for your subscription and region, use the az aks get-versions command.
The following example lists available Kubernetes versions for the WestEurope region: $az aks get-versions --location westeurope --output table).
* If you want to manage **VirtualDisks** from the AKS, it will be necessary to grant on the Managed Identity the role "*Contributor*" to the resource group where the disk is going to be located.
* ⚠️ If you want to use the **KMS plugin**, used for encryption at rest of your Kubernetes secrets in etcd using Azure Key Vault, it is **highly recommended to use an AKV dedicated to the AKS only**.
This is because you need the "*Key Vault Contributor*" role in the identity used on the AKV, which will make all the secrets and keys of that AKV available to the AKS. ⚠️
* Group name or group ID to bind the K8S RBAC admin role in the default namespace.
More details and reference: <https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration> (Feature deprecated).
  * Previously, another Service Principal was required to manage the integration between Azure AD and AKS RBAC --> [Legacy Service Principal Documentation Link](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli).
  * This feature is now deprecated, and now the AKS automatically manages this integration --> [AKS-managed Azure Active Directory integration](https://docs.microsoft.com/en-us/azure/aks/managed-aad)

<a name="AZInputExample"></a>

## Input example

```hcl
az_kubernetes = {
  "aks_default" = {
    # -----------------------
    # Tagging
    # -----------------------
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon AKS"
    }

    # -------------
    # Security
    # -------------
    akv_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest001"

    # -------------
    # AKS Cluster
    # -------------
    cluster_name            = "glnd1weuaksglobaltest001"
    resource_group          = "glnd1weursgglobaltest001"
    kubernetes_version      = "1.29.0"
    private_cluster_enabled = true
    lwk_id                  = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest001"

    # AKS Secret names
    aks_username = "<akv_secret_user_name>"
    aks_ssh_key  = "<akv_secret_ssh_key_name>"

    # Main NodePool settings
    agent_pool_name      = "aksdefnpl"
    agent_pool_vm_size   = "Standard_Ds2_v2"
    agent_pool_subnet_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt01"

    # User Assigned Managed Identity id
    identity_ids        = ["/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/glnd1weuuaiglobaltest001"]
    private_dns_zone_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/privateDnsZones/<private_dns_zone_name>"
  }
  "aks_extensions" = {
    # -----------------------
    # Tagging
    # -----------------------
    tags = {
      test_tag    = "test_tag"
      environment = "dev"
      product     = "Gluon AKS"
    }

    # -------------
    # Security
    # -------------
    akv_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest001"

    # -------------
    # AKS Cluster
    # -------------
    cluster_name            = "glnd1weuaksglobaltest005"
    resource_group          = "glnd1weursgglobaltest001"
    private_cluster_enabled = true
    lwk_id                  = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest001"
    node_resource_group     = "glnd1weuaksnodersg005"
    kubernetes_version      = "1.29.0"
    sku_tier                = "Standard"

    # User Assigned Managed Identity id
    identity_ids        = ["/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/glnd1weuuaiglobaltest001"]
    private_dns_zone_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/privateDnsZones/<private_dns_zone_name>"

    # Main NodePool settings
    agent_pool_name         = "aksdefnpl"
    agent_pool_count        = 1
    agent_pool_vm_size      = "Standard_Ds2_v2"
    agent_pool_os_disk_size = 80
    agent_pool_max_pods     = 60
    agent_pool_subnet_id    = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt01"

    # AKS Secret names
    aks_username = "<akv_secret_user_name>"
    aks_ssh_key  = "<akv_secret_ssh_key_name>"

    # ----------------
    # AKS Node Pools
    # ----------------
    extra_node_pools = {
      node001 = {
        name               = "npl001"
        min_count          = 2
        max_count          = 3
        os_disk_size_gb    = 40
        vm_size            = "Standard_D4s_v3"
        max_pods           = 100
        eviction_policy    = "Deallocate"
        ultra_ssd_enabled  = true
        message_of_the_day = "daily message"
        workload_runtime   = "OCIContainer"
        scale_down_mode    = "Delete"
        extra_node_tags = {
          test1 = "test"
        }
      }
      node002 = {
        name               = "npl002"
        node_count         = 1
        max_count          = 3
        os_disk_size_gb    = 40
        vm_size            = "Standard_Ds2_v2"
        max_pods           = 100
        message_of_the_day = "daily message"
        workload_runtime   = "OCIContainer"
        scale_down_mode    = "Delete"
        extra_node_tags = {
          test2 = "test"
        }
      }
    }

    # ------------------------------
    # Kubernetes Cluster Extension
    # ------------------------------
    gitops_enabled = true
    # If gitops_enabled is 'true', the 'Flux' extension is added by default.
    extensions = {
      "dapr" = {
        extension_type = "Microsoft.Dapr"
      }
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| agent_pool_name | Specifies the name of the agent pool to be created. | <pre>string</pre> |
| agent_pool_subnet_id | The ID of a Subnet where the Kubernetes Node Pool should exist. A Route Table must be configured on this Subnet. Changing this forces a new resource to be created. | <pre>string</pre> |
| agent_pool_vm_size | The size of the Virtual Machine, such as Standard\_DS2\_v2. | <pre>string</pre> |
| cluster_name | The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created. | <pre>string</pre> |
| kubernetes_version | Version of Kubernetes specified when creating the AKS managed cluster. To find out what versions are currently available for your subscription and region, use the az aks get-versions command. The following example lists available Kubernetes versions for the WestEurope region: $az aks get-versions --location westeurope --output table. | <pre>string</pre> |
| lwk_id | Log Analytics Workspace id. | <pre>string</pre> |
| private_dns_zone_id | The ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this. This is always required since 'private\_cluster\_enabled' has been hardcoded to 'true'. | <pre>string</pre> |
| resource_group | Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | <pre>string</pre> |

!!! info
    Post-configuration parameters required for Kubernetes clusters should be provided in the config.yml file. Please, check required and optional parameters to configure clusters deployed [here](../post-conf.md)

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aeh_enabled | Boolean value that indicates whether or not to use an Event Hub to stream the logs. | <pre>string</pre> | false |
| agent_pool_availability_zones | Specifies a list of Availability Zones in which this Kubernetes Cluster should be located. | <pre>list(string)</pre> | [<br>  "1",<br>  "2",<br>  "3"<br>] |
| agent_pool_count | The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between 'min\_count' and 'max\_count'. | <pre>number</pre> | 3 |
| agent_pool_enable_auto_scaling | Should the Kubernetes Auto Scaler be enabled for this Node Pool?. | <pre>bool</pre> | true |
| agent_pool_enable_node_public_ip | Should each node have a Public IP Address? Changing this forces a new resource to be created. | <pre>bool</pre> | false |
| [agent_pool_kubelet_config](#input_agent_pool_kubelet_config) | Map containing the configuration for the Kubelet config for the agent pool. | <pre>any</pre> | {} |
| agent_pool_kubelet_disk_type | The type of disk used by kubelet. Possible values are 'OS' and 'Temporary'. | <pre>string</pre> | null |
| [agent_pool_linux_os_config](#input_agent_pool_linux_os_config) | Map containing the configuration for the Linux OS config for the agent pool. | <pre>any</pre> | {} |
| agent_pool_max_count | The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000. | <pre>number</pre> | null |
| agent_pool_max_pods | The maximum number of pods that can run on each agent. | <pre>number</pre> | 150 |
| agent_pool_message_of_the_day | :warning: DEPRECATED :warning:. A base64-encoded string which will be written to /etc/motd after decoding. This allows customization of the message of the day for Linux nodes. It cannot be specified for Windows nodes and must be a static string (i.e. will be printed raw and not executed as a script) (forces replacement). Changing this forces a new resource to be created. This parameter has been deprecated in the AzureRM provider v3.116, so it must not be used. It will be removed in the next major version. | <pre>string</pre> | null |
| agent_pool_min_count | The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000. | <pre>number</pre> | null |
| agent_pool_node_labels | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. | <pre>map(any)</pre> | {} |
| agent_pool_only_critical_addons_enabled | Enabling this option will taint default node pool with CriticalAddonsOnly=true:NoSchedule taint. | <pre>bool</pre> | false |
| agent_pool_orchestrator_version | Version of Kubernetes used for the Agents. If not specified, the default node pool will be created with the version specified by kubernetes\_version (Only at provisioning time). | <pre>string</pre> | null |
| agent_pool_os_disk_size | The size of the OS Disk in GB which should be used for each agent in the Node Pool. | <pre>number</pre> | 40 |
| agent_pool_os_disk_type | The type of disk which should be used for the Operating System. Possible values are 'Ephemeral' and 'Managed'. | <pre>string</pre> | null |
| agent_pool_os_sku | Specifies the OS SKU used by the agent pool. Possible values are AzureLinux, Ubuntu, Windows2019 and Windows2022. If not specified, the default is Ubuntu if OSType=Linux or Windows2019 if OSType=Windows. And the default Windows OSSKU will be changed to Windows2022 after Windows2019 is deprecated. | <pre>string</pre> | null |
| agent_pool_scale_down_mode | Specifies how the node pool should deal with scaled-down nodes. Allowed values are 'Delete' and 'Deallocate'. | <pre>string</pre> | "Delete" |
| agent_pool_tags | A mapping of tags to assign to the Node Pool. This is a merged structure between 'var.tags' and 'var.agent\_pool\_tags'. | <pre>any</pre> | {} |
| agent_pool_ultra_ssd_enabled | Used to specify whether the UltraSSD is enabled in the Default Node Pool. See the [documentation](https://learn.microsoft.com/es-es/azure/aks/use-ultra-disks) for more information. | <pre>bool</pre> | false |
| agent_pool_upgrade_settings_max_surge | The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade. | <pre>string</pre> | null |
| agent_pool_workload_runtime | Used to specify the workload runtime. Allowed values are 'OCIContainer', 'WasmWasi' and 'KataMshvVmIsolation'. :warning: WebAssembly System Interface node pools are in Public Preview - more information and details on how to opt into the preview can be found in this [article](https://learn.microsoft.com/es-es/azure/aks/use-wasi-node-pools). :warning: Pod Sandboxing / KataVM Isolation node pools are in Public Preview - more information and details on how to opt into the preview can be found in this [article](https://learn.microsoft.com/azure/aks/use-pod-sandboxing). | <pre>string</pre> | null |
| aks_ssh_key | Secret name for admin user ssh key of kubernetes cluster. | <pre>string</pre> | "glnaksadm-ssh-key" |
| aks_username | Secret name for admin user of kubernetes cluster. | <pre>string</pre> | "glnaksadm" |
| akv_id | (Required if 'disk\_encryption\_set' is 'true') Key Vault ID where the CMK Key of the AKS will be saved or is stored. | <pre>string</pre> | null |
| akv_key_id | The ID of the key to use for encrypting AKS. If not provided, a new key will be created through the module with the name '<cluster\_name>-cmkkey-<random\_String>'. | <pre>string</pre> | null |
| analytics_diagnostic_monitor_name | The name of the Analytics Diagnostic Monitor. | <pre>string</pre> | "" |
| api_auth_ips | :warning: DEPRECATED :warning:. Whitelist of IP addresses that are allowed to access the AKS Master Control Plane API. This parameter has been removed from the module, since now only private clusters can be created to follow Security Control for Cloud procedures, and the API server authorized IP ranges feature isn't supported on private clusters. It will be deprecated in the next major version. | <pre>list(string)</pre> | [<br>  "193.127.200.0/24",<br>  "193.127.207.0/24",<br>  "51.138.8.176/28",<br>  "193.127.193.44/32",<br>  "193.127.193.53/32",<br>  "193.127.217.10/32",<br>  "193.127.229.35/32",<br>  "195.149.215.225/32",<br>  "195.149.215.232/32",<br>  "195.149.215.235/32",<br>  "195.149.215.238/32",<br>  "195.149.215.60/32",<br>  "195.149.215.61/32"<br>] |
| [auto_scaler_profile](#input_auto_scaler_profile) | Map containing the configuration for the auto scaler profile. | <pre>any</pre> | {} |
| automatic_channel_upgrade | The upgrade channel for this Kubernetes Cluster. Possible values are 'patch', 'rapid', 'node-image' and 'stable'. See this [link](https://docs.microsoft.com/en-gb/azure/aks/auto-upgrade-cluster#using-auto-upgrade). | <pre>string</pre> | "patch" |
| azure_ad_admin_group_object_ids | A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster. | <pre>list(string)</pre> | [] |
| azure_policy_enabled | Should the Azure Policy Add-On be enabled? For more details please visit [Understand Azure Policy for Azure Kubernetes Service](https://learn.microsoft.com/en-ie/azure/governance/policy/concepts/policy-for-kubernetes). | <pre>bool</pre> | true |
| container_registry_ids | List containing the Azure Container Registry IDs that need an authentication mechanism with Azure Kubernetes Service (AKS). Changing this forces some new resources to be created. | <pre>list(string)</pre> | [] |
| contreg_ids | :warning: DEPRECATED :warning:. Map containing the Azure Container Registry IDs that need an authentication mechanism with Azure Kubernetes Service (AKS). Map key must be static string as acr's name, the value is acr's resource id. This property has been superseded by 'container\_registry\_ids' and will be deprecated in the next major version, so in order to use this feature, you must set 'container\_registry\_ids' instead of this one. You must use the 'https\_traffic\_only\_enabled' variable instead. | <pre>map(string)</pre> | {} |
| create_disk_encryption_set | Enable Encryption at rest. | <pre>bool</pre> | true |
| create_log_analytics_solution | Enables the creation of a Log Analytics Solution Resource. | <pre>bool</pre> | false |
| create_private_dns_zone_virtual_network_link | Enables the creation of a Private DNS Zone Virtual Network Link. | <pre>bool</pre> | false |
| create_uai | Enables the creation of an user assign identity to use for the AKS. :warning: SPN L2 would be required to create this user assign identity. | <pre>bool</pre> | false |
| defender_lwk_id | Specifies the ID of the Log Analytics Workspace where the audit logs collected by Microsoft Defender should be sent to. If not provided and 'microsoft\_defender\_enabled' is true, the 'lwk\_id' variable will be used as Microsoft Denfender Log Analytics Workspace. | <pre>string</pre> | null |
| dns_prefix | DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created. | <pre>string</pre> | "glnaks" |
| dns_prefix_private_cluster | Specifies the DNS prefix to use with private clusters. One of dns\_prefix or dns\_prefix\_private\_cluster must be specified. Changing this forces a new resource to be created. | <pre>string</pre> | null |
| enable_automatic_rotation_policy | Enables the automatic rotation policy for the created AKV key. :warning: If it is set to 'false', the attribute 'time\_before\_expiry' must not be set. This parameter must only be set when 'akv\_key\_id' is not provided. | <pre>bool</pre> | true |
| enable_key_management_service | Enables the encryption for the AKS cluster. For more details, please visit [Key Management Service (KMS) etcd encryption to an AKS cluster](https://learn.microsoft.com/en-us/azure/aks/use-kms-etcd-encryption). | <pre>bool</pre> | false |
| eventhub_authorization_rule_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. :warning: At least one of 'eventhub\_authorization\_rule\_id', 'lwk\_id' and 'storage\_account\_id' must be specified. | <pre>string</pre> | null |
| eventhub_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. If this isn't specified then the default Event Hub will be used. | <pre>string</pre> | null |
| expire_after | Expire a Key Vault Key after given duration as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Must always be, at least, 7 days greater than the attribute 'time\_before\_expiry'. Minimum allowed value is 'P28D'. This parameter must only be set when 'akv\_key\_id' is not provided. | <pre>string</pre> | "P25M" |
| [extensions](#input_extensions) | Map containing the configuration for the Kubernetes Cluster extensions. If 'gitops\_enabled' is true, the 'Flux' extension is created by default. | <pre>any</pre> | {} |
| [extra_node_pools](#input_extra_node_pools) | Map to define the extra node pools to deploy in the AKS. | <pre>any</pre> | {} |
| [gitops_config](#input_gitops_config) | Map containing the configuration for the Kubernetes Cluster Flux extensions. It only applies when 'gitops\_enabled' is 'true'. | <pre>any</pre> | {} |
| gitops_enabled | (optional) Is required to install the Flux extension to use GitOps? If 'true', the 'gitops\_config' variable must also be provided with the desired Flux configuration. | <pre>bool</pre> | false |
| [http_proxy_config](#input_http_proxy_config) | Map containing the configuration for the HTTP proxy. | <pre>any</pre> | {} |
| identity_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster. If not provided, one User Assigned Managed Identity ID must be created setting the variable 'create\_uai' as true. | <pre>list(string)</pre> | [] |
| [ingress_application_gateway](#input_ingress_application_gateway) | Map containing the configuration for the ingress application gateway. See [this page](https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-new) for further details. | <pre>any</pre> | {} |
| key_expiration_date | Expiration UTC datetime (Y-m-d'T'H:M:S'Z'). When this parameter gets changed on reruns, if newer date is ahead of current date, an update is performed. If the newer date is before the current date, resource will be force created.'. This parameter must only be set when 'akv\_key\_id' is not provided. | <pre>string</pre> | null |
| [key_vault_secrets_provider](#input_key_vault_secrets_provider) | Map containing the configuration for the key vault secrets provider. For more details, please see this [link](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver). | <pre>any</pre> | {} |
| [kubelet_identity](#input_kubelet_identity) | Map containing the configuration for the kubelet identity. | <pre>any</pre> | {} |
| local_account_disabled | If 'true' local accounts will be disabled. See the [documentation](https://learn.microsoft.com/es-es/azure/aks/enable-authentication-microsoft-entra-id#disable-local-accounts) for more information. | <pre>bool</pre> | false |
| location | The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | <pre>string</pre> | null |
| log_analytics_destination_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | <pre>string</pre> | "AzureDiagnostics" |
| log_analytics_solution_tags | A mapping of tags to assign to the Log Analytics Solution. This is a merged structure between 'var.tags' and 'var.log\_analytics\_solution\_tags'. | <pre>any</pre> | {} |
| logs | Specifies the log types that are going to be saved. If a specific log is not longer needed, you could remove the log type from the list. These are all the available logs types ['kube-controller-manager', 'cloud-controller-manager', 'kube-audit', 'csi-azuredisk-controller', 'kube-audit-admin', 'csi-azurefile-controller', 'csi-snapshot-controller', 'guard', 'cluster-autoscaler', 'kube-apiserver', 'kube-scheduler']. | <pre>any</pre> | [<br>  "kube-controller-manager",<br>  "kube-scheduler",<br>  "kube-audit",<br>  "cluster-autoscaler",<br>  "guard",<br>  "kube-apiserver",<br>  "kube-audit-admin",<br>  "cloud-controller-manager",<br>  "csi-azuredisk-controller",<br>  "csi-azurefile-controller",<br>  "csi-snapshot-controller"<br>] |
| [maintenance_window](#input_maintenance_window) | Map containing the configuration for the maintenance window. | <pre>any</pre> | {} |
| [maintenance_window_auto_upgrade](#input_maintenance_window_auto_upgrade) | Map containing the configuration for the maintenance window auto upgrade. | <pre>any</pre> | {} |
| [maintenance_window_node_os](#input_maintenance_window_node_os) | Map containing the configuration for the maintenance window node OS. | <pre>any</pre> | {} |
| metrics | Specifies the metric types that are going to be saved. These are all the available metrics types ["AllMetrics"]. | <pre>any</pre> | [<br>  "AllMetrics"<br>] |
| [microsoft_defender](#input_microsoft_defender) | :warning: DEPRECATED :warning:. Map containing the configuration for the Microsoft Defender. This property has been superseded by 'microsoft\_defender\_enabled' and 'defender\_lwk\_id' and will be deprecated in the next major version. You must use the 'microsoft\_defender\_enabled' and 'defender\_lwk\_id' variables instead. It will be removed in the next major version. | <pre>any</pre> | {} |
| microsoft_defender_enabled | Is Microsoft Defender on the cluster enabled? If 'true' and 'defender\_lwk\_id' is not provided, the 'lwk\_id' variable will be used as Microsoft Denfender Log Analytics Workspace. | <pre>bool</pre> | true |
| msi_auth_for_monitoring_enabled | Is managed identity authentication for monitoring enabled?. | <pre>bool</pre> | true |
| [network_profile](#input_network_profile) | Map containing the configuration for the network profile. If not specified it will use kubenet as default. | <pre>any</pre> | {} |
| node_resource_group | The name of the Resource Group where the Kubernetes Nodes should exist. If not provided, the node resource group name would be '<cluster\_name-rsg>' by default. Changing this forces a new resource to be created. | <pre>string</pre> | null |
| notify_before_expiry | Notify at a given duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). Minimum allowed value is 'P7D'. This parameter must only be set when 'akv\_key\_id' is not provided. | <pre>string</pre> | "P7D" |
| private_cluster_enabled | :warning: DEPRECATED :warning:. Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. This parameter has been hardcoded to 'true' to follow Security Control for Cloud procedures and cannot be changed. This means that now only private clusters can be created. It will be deprecated in the next major version. | <pre>bool</pre> | true |
| private_cluster_public_fqdn_enabled | Specifies whether a Public FQDN for this Private Cluster should be added. | <pre>bool</pre> | false |
| private_dns_zone_virtual_network_link_name | Specifies the name of the Private DNS Zone Virtual Network Link to be created. | <pre>string</pre> | null |
| private_dns_zone_virtual_network_link_tags | A mapping of tags to assign to the Private DNS Zone Virtual Network Link. This is a merged structure between 'var.tags' and 'var.private\_dns\_zone\_virtual\_network\_link\_tags'. | <pre>any</pre> | {} |
| role_based_access_control_enabled | :warning: DEPRECATED :warning:. Whether Role Based Access Control for the Kubernetes Cluster should be enabled. This parameter has been hardcoded to 'true' to follow Security Control for Cloud procedures and cannot be changed. It will be deprecated in the next major version. | <pre>bool</pre> | true |
| run_command_enabled | Whether to enable run command for the cluster or not. | <pre>bool</pre> | true |
| sku_tier | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are 'Free', 'Standard' and 'Premium'. | <pre>string</pre> | "Standard" |
| sta_enabled | Boolean value that indicates whether or not to use a storage account to store the logs. | <pre>string</pre> | false |
| storage_account_id | The ID of the Storage Account where logs should be sent. :warning: At least one of 'eventhub\_authorization\_rule\_id', 'lwk\_id' and 'storage\_account\_id' must be specified. | <pre>string</pre> | null |
| [storage_profile](#input_storage_profile) | A storage\_profile block as defined below. | <pre>any</pre> | {} |
| tags | A map of tags to add to all resources. | <pre>any</pre> | {} |
| time_before_expiry | Rotate automatically at a duration before expiry as an [ISO 8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This attribute must only be set when 'enable\_automatic\_rotation\_policy' is 'true'. Defaults to 'P1M' if 'enable\_automatic\_rotation\_policy' is 'true', otherwise 'null'. :warning: The attribute 'expire\_after' must always be, at least, 7 days greater than this parameter. This parameter must only be set when 'akv\_key\_id' is not provided. | <pre>string</pre> | null |
| uai_name | Specifies the name of the User Assigned Identity to be created. | <pre>string</pre> | null |
| uai_tags | A mapping of tags to assign to the User Assign Identity. This is a merged structure between 'var.tags' and 'var.uai\_tags'. | <pre>any</pre> | {} |
| [windows_profile](#input_windows_profile) | Map containing the configuration for the Windows profile. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_agent_pool_kubelet_config"></a> [agent\_pool\_kubelet\_config](#input\_agent\_pool\_kubelet\_config)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| allowed_unsafe_sysctls | (Optional) Specifies the allow list of unsafe sysctls command or patterns (ending in *). | <pre>string</pre> |
| container_log_max_line | (Optional) Specifies the maximum number of container log files that can be present for a container. must be at least 2. | <pre>number</pre> |
| container_log_max_size_mb | (Optional) Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. | <pre>number</pre> |
| cpu_cfs_quota_enabled | (Optional) Is CPU CFS quota enforcement for containers enabled? | <pre>bool</pre> |
| cpu_cfs_quota_period | (Optional) Specifies the CPU CFS quota period value. | <pre>string</pre> |
| cpu_manager_policy | (Optional) Specifies the CPU Manager policy to use. Possible values are none and static. | <pre>string</pre> |
| image_gc_high_threshold | (Optional) Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. | <pre>number</pre> |
| image_gc_low_threshold | (Optional) Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. | <pre>number</pre> |
| pod_max_pid | (Optional) Specifies the maximum number of processes per pod. | <pre>number</pre> |
| topology_manager_policy | (Optional) Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. | <pre>string</pre> |

### <a name="input_agent_pool_linux_os_config"></a> [agent\_pool\_linux\_os\_config](#input\_agent\_pool\_linux\_os\_config)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| swap_file_size_mb | (Optional) Specifies the size of swap file on each node in MB. | <pre>number</pre> |
| sysctl_config | (Optional) A sysctl\_config block as defined below. | <pre>any</pre> |
| sysctl_config<br/>.fs_aio_max_nr | Optional) The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. | <pre>number</pre> |
| sysctl_config<br/>.fs_file_max | (Optional) The sysctl setting fs.file-max. Must be between 8192 and 12000500. | <pre>number</pre> |
| sysctl_config<br/>.fs_inotify_max_user_watches | (Optional) The sysctl setting fs.inotify.max\_user\_watches. Must be between 781250 and 2097152. | <pre>number</pre> |
| sysctl_config<br/>.fs_nr_open | (Optional) The sysctl setting fs.nr\_open. Must be between 8192 and 20000500. | <pre>number</pre> |
| sysctl_config<br/>.kernel_threads_max | (Optional) The sysctl setting kernel.threads-max. Must be between 20 and 513785. | <pre>number</pre> |
| sysctl_config<br/>.net_core_netdev_max_backlog | (Optional) The sysctl setting net.core.netdev\_max\_backlog. Must be between 1000 and 3240000. | <pre>number</pre> |
| sysctl_config<br/>.net_core_optmem_max | (Optional) The sysctl setting net.core.optmem\_max. Must be between 20480 and 4194304. | <pre>number</pre> |
| sysctl_config<br/>.net_core_rmem_default | (Optional) The sysctl setting net.core.rmem\_default. Must be between 212992 and 134217728. | <pre>number</pre> |
| sysctl_config<br/>.net_core_rmem_max | (Optional) The sysctl setting net.core.rmem\_max. Must be between 212992 and 134217728. | <pre>number</pre> |
| sysctl_config<br/>.net_core_somaxconn | (Optional) The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. | <pre>number</pre> |
| sysctl_config<br/>.net_core_wmem_default | (Optional) The sysctl setting net.core.wmem\_default. Must be between 212992 and 134217728. | <pre>number</pre> |
| sysctl_config<br/>.net_core_wmem_max | (Optional) The sysctl setting net.core.wmem\_max. Must be between 212992 and 134217728. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_ip_local_port_range_max | (Optional) The sysctl setting net.ipv4.ip\_local\_port\_range max value. Must be between 1024 and 60999. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_ip_local_port_range_min | (Optional) The sysctl setting net.ipv4.ip\_local\_port\_range min value. Must be between 1024 and 60999. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh1 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh1. Must be between 128 and 80000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh2 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh2. Must be between 512 and 90000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh3 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh3. Must be between 1024 and 100000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_fin_timeout | (Optional) The sysctl setting net.ipv4.tcp\_fin\_timeout. Must be between 5 and 120. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_keepalive_intvl | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_intvl. Must be between 10 and 75. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_keepalive_probes | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_probes. Must be between 1 and 15. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_keepalive_time | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_time. Must be between 30 and 432000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_max_syn_backlog | (Optional) The sysctl setting net.ipv4.tcp\_max\_syn\_backlog. Must be between 128 and 3240000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_max_tw_buckets | (Optional) The sysctl setting net.ipv4.tcp\_max\_tw\_buckets. Must be between 8000 and 1440000. | <pre>number</pre> |
| sysctl_config<br/>.net_ipv4_tcp_tw_reuse | (Optional) Is sysctl setting net.ipv4.tcp\_tw\_reuse enabled? | <pre>bool</pre> |
| sysctl_config<br/>.net_netfilter_nf_conntrack_buckets | (Optional) The sysctl setting net.netfilter.nf\_conntrack\_buckets. Must be between 65536 and 147456. | <pre>number</pre> |
| sysctl_config<br/>.net_netfilter_nf_conntrack_max | (Optional) The sysctl setting net.netfilter.nf\_conntrack\_max. Must be between 131072 and 1048576. | <pre>number</pre> |
| sysctl_config<br/>.vm_max_map_count | (Optional) The sysctl setting vm.max\_map\_count. Must be between 65530 and 262144. | <pre>number</pre> |
| sysctl_config<br/>.vm_swappiness | (Optional) The sysctl setting vm.swappiness. Must be between 0 and 100. | <pre>number</pre> |
| sysctl_config<br/>.vm_vfs_cache_pressure | (Optional) The sysctl setting vm.vfs\_cache\_pressure. Must be between 0 and 100. | <pre>number</pre> |
| transparent_huge_page_defrag | (Optional) specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. | <pre>string</pre> |
| transparent_huge_page_enabled | (Optional) Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. | <pre>string</pre> |

### <a name="input_auto_scaler_profile"></a> [auto\_scaler\_profile](#input\_auto\_scaler\_profile)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| balance_similar_node_groups | (Optional) Detect similar node groups and balance the number of nodes between them. Defaults to false. | <pre>bool</pre> |
| empty_bulk_delete_max | (Optional) Maximum number of empty nodes that can be deleted at the same time. Defaults to 10. | <pre>string</pre> |
| expander | (Optional) Expander to use. Possible values are least-waste, priority, most-pods and random. Defaults to random. | <pre>string</pre> |
| max_graceful_termination_sec | (Optional) Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to 600. | <pre>string</pre> |
| max_node_provisioning_time | (Optional) Maximum time the autoscaler waits for a node to be provisioned. Defaults to 15m. | <pre>string</pre> |
| max_unready_nodes | (Optional) Maximum Number of allowed unready nodes. Defaults to 3. | <pre>string</pre> |
| max_unready_percentage | (Optional) Maximum percentage of unready nodes the cluster autoscaler will stop if the percentage is exceeded. Defaults to 45. | <pre>string</pre> |
| new_pod_scale_up_delay | (Optional) For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age. Defaults to 10s. | <pre>string</pre> |
| scale_down_delay_after_add | (Optional) How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to 10m. | <pre>string</pre> |
| scale_down_delay_after_delete | (Optional) How long after node deletion that scale down evaluation resumes. Defaults to the value used for scan\_interval. | <pre>string</pre> |
| scale_down_delay_after_failure | (Optional) How long after scale down failure that scale down evaluation resumes. Defaults to 3m. | <pre>string</pre> |
| scale_down_unneeded | (Optional) How long a node should be unneeded before it is eligible for scale down. Defaults to 10m. | <pre>string</pre> |
| scale_down_unready | (Optional) How long an unready node should be unneeded before it is eligible for scale down. Defaults to 20m. | <pre>string</pre> |
| scale_down_utilization_threshold | (Optional) Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to 0.5. | <pre>string</pre> |
| scan_interval | (Optional) How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to 10s. | <pre>string</pre> |
| skip_nodes_with_local_storage | (Optional) If true cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath. Defaults to true. | <pre>bool</pre> |
| skip_nodes_with_system_pods | (Optional) If true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods). Defaults to true. | <pre>bool</pre> |

### <a name="input_extensions"></a> [extensions](#input\_extensions)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| configuration_settings | (Optional) Configuration settings, as name-value pairs for configuring this extension | <pre>any</pre> |
| extension_type | (Required) Specifies the type of extension. It must be one of the extension types registered with Microsoft.KubernetesConfiguration by the Extension publisher. For more information, please refer to [Available Extensions for AKS](https://learn.microsoft.com/en-us/azure/aks/cluster-extensions?tabs=azure-cli#currently-available-extensions). Changing this forces a new Kubernetes Cluster Extension to be created. | <pre>string</pre> |
| release_namespace | (Optional) Namespace where the extension release must be placed for a cluster scoped extension. If this namespace does not exist, it will be created. Changing this forces a new Kubernetes Cluster Extension to be created. | <pre>string</pre> |
| release_train | (Optional) The release train used by this extension. Possible values include but are not limited to Stable, Preview. Changing this forces a new Kubernetes Cluster Extension to be created. | <pre>string</pre> |
| target_namespace | (Optional) Namespace where the extension will be created for a namespace scoped extension. If this namespace does not exist, it will be created. Changing this forces a new Kubernetes Cluster Extension to be created. | <pre>string</pre> |
| version | (Optional) User-specified version that the extension should pin to. If it is not set, Azure will use the latest version and auto upgrade it. Changing this forces a new Kubernetes Cluster Extension to be created. | <pre>string</pre> |

### <a name="input_extra_node_pools"></a> [extra\_node\_pools](#input\_extra\_node\_pools)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| availability_zones | (Optional) List of availability\_zones in which the VMSS workers should be created (Default ["1", "2", "3"]). | <pre>list(string)</pre> |
| enable_auto_scaling | (Optional) Use autoscale in the pool (Default true). | <pre>bool</pre> |
| eviction_policy | (Optional) The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are Deallocate and Delete. Changing this forces a new resource to be created (Default Delete). | <pre>string</pre> |
| extra_node_tags | (Optional) A map of tags to assign to the resource. This is a merged structure between 'var.tags' and 'var.extra\_node\_tags'. | <pre>any</pre> |
| kubelet_config | (Optional) A kubelet\_config block. | <pre>any</pre> |
| kubelet_config<br/>.allowed_unsafe_sysctls | (Optional) Specifies the allow list of unsafe sysctls command or patterns (ending in *). | <pre>string</pre> |
| kubelet_config<br/>.container_log_max_line | (Optional) Specifies the maximum number of container log files that can be present for a container. must be at least 2. | <pre>number</pre> |
| kubelet_config<br/>.container_log_max_size_mb | (Optional) Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. | <pre>number</pre> |
| kubelet_config<br/>.cpu_cfs_quota_enabled | (Optional) Is CPU CFS quota enforcement for containers enabled? | <pre>bool</pre> |
| kubelet_config<br/>.cpu_cfs_quota_period | (Optional) Specifies the CPU CFS quota period value. | <pre>string</pre> |
| kubelet_config<br/>.cpu_manager_policy | (Optional) Specifies the CPU Manager policy to use. Possible values are none and static. | <pre>string</pre> |
| kubelet_config<br/>.image_gc_high_threshold | (Optional) Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. | <pre>number</pre> |
| kubelet_config<br/>.image_gc_low_threshold | (Optional) Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. | <pre>number</pre> |
| kubelet_config<br/>.pod_max_pid | (Optional) Specifies the maximum number of processes per pod. | <pre>number</pre> |
| kubelet_config<br/>.topology_manager_policy | (Optional) Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. | <pre>string</pre> |
| kubelet_disk_type | (Optional) The type of disk used by kubelet. Possible values are OS and Temporary (Default OS). | <pre>string</pre> |
| linux_os_config | (Optional) A linux\_os\_config block. | <pre>any</pre> |
| linux_os_config<br/>.swap_file_size_mb | (Optional) Specifies the size of swap file on each node in MB. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config | (Optional) A sysctl\_config block as defined below. | <pre>any</pre> |
| linux_os_config<br/>.sysctl_config<br/>.fs_aio_max_nr | Optional) The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.fs_file_max | (Optional) The sysctl setting fs.file-max. Must be between 8192 and 12000500. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.fs_inotify_max_user_watches | (Optional) The sysctl setting fs.inotify.max\_user\_watches. Must be between 781250 and 2097152. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.fs_nr_open | (Optional) The sysctl setting fs.nr\_open. Must be between 8192 and 20000500. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.kernel_threads_max | (Optional) The sysctl setting kernel.threads-max. Must be between 20 and 513785. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_netdev_max_backlog | (Optional) The sysctl setting net.core.netdev\_max\_backlog. Must be between 1000 and 3240000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_optmem_max | (Optional) The sysctl setting net.core.optmem\_max. Must be between 20480 and 4194304. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_rmem_default | (Optional) The sysctl setting net.core.rmem\_default. Must be between 212992 and 134217728. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_rmem_max | (Optional) The sysctl setting net.core.rmem\_max. Must be between 212992 and 134217728. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_somaxconn | (Optional) The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_wmem_default | (Optional) The sysctl setting net.core.wmem\_default. Must be between 212992 and 134217728. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_core_wmem_max | (Optional) The sysctl setting net.core.wmem\_max. Must be between 212992 and 134217728. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_ip_local_port_range_max | (Optional) The sysctl setting net.ipv4.ip\_local\_port\_range max value. Must be between 1024 and 60999. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_ip_local_port_range_min | (Optional) The sysctl setting net.ipv4.ip\_local\_port\_range min value. Must be between 1024 and 60999. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh1 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh1. Must be between 128 and 80000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh2 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh2. Must be between 512 and 90000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_neigh_default_gc_thresh3 | (Optional) The sysctl setting net.ipv4.neigh.default.gc\_thresh3. Must be between 1024 and 100000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_fin_timeout | (Optional) The sysctl setting net.ipv4.tcp\_fin\_timeout. Must be between 5 and 120. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_keepalive_intvl | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_intvl. Must be between 10 and 75. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_keepalive_probes | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_probes. Must be between 1 and 15. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_keepalive_time | (Optional) The sysctl setting net.ipv4.tcp\_keepalive\_time. Must be between 30 and 432000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_max_syn_backlog | (Optional) The sysctl setting net.ipv4.tcp\_max\_syn\_backlog. Must be between 128 and 3240000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_max_tw_buckets | (Optional) The sysctl setting net.ipv4.tcp\_max\_tw\_buckets. Must be between 8000 and 1440000. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_ipv4_tcp_tw_reuse | (Optional) Is sysctl setting net.ipv4.tcp\_tw\_reuse enabled? | <pre>bool</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_netfilter_nf_conntrack_buckets | (Optional) The sysctl setting net.netfilter.nf\_conntrack\_buckets. Must be between 65536 and 147456. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.net_netfilter_nf_conntrack_max | (Optional) The sysctl setting net.netfilter.nf\_conntrack\_max. Must be between 131072 and 1048576. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.vm_max_map_count | (Optional) The sysctl setting vm.max\_map\_count. Must be between 65530 and 262144. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.vm_swappiness | (Optional) The sysctl setting vm.swappiness. Must be between 0 and 100. | <pre>number</pre> |
| linux_os_config<br/>.sysctl_config<br/>.vm_vfs_cache_pressure | (Optional) The sysctl setting vm.vfs\_cache\_pressure. Must be between 0 and 100. | <pre>number</pre> |
| linux_os_config<br/>.transparent_huge_page_defrag | (Optional) specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. | <pre>string</pre> |
| linux_os_config<br/>.transparent_huge_page_enabled | (Optional) Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. | <pre>string</pre> |
| max_count | (Optional) The maximum number of nodes which should exist within this Node Pool. | <pre>number</pre> |
| max_pods | (Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created (Default 30). | <pre>number</pre> |
| message_of_the_day | (Optional) :warning: DEPRECATED :warning:. A base64-encoded string which will be written to /etc/motd after decoding. This allows customization of the message of the day for Linux nodes. It cannot be specified for Windows nodes and must be a static string (i.e. will be printed raw and not executed as a script) (forces replacement). Changing this forces a new resource to be created. This parameter has been deprecated in the AzureRM provider v3.116, so it must not be used. It will be removed in the next major version." | <pre>string</pre> |
| min_count | (Optional) The minimum number of nodes which should exist within this Node Pool. | <pre>number</pre> |
| mode | (Optional) Should this Node Pool be used for System or User resources? Possible values are System and User (Default User). | <pre>string</pre> |
| name | (Required) AKS Node pool name to create. Name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9. Changing this forces a new resource to be created. :warning: A Windows Node Pool cannot have a name longer than 6 characters. | <pre>string</pre> |
| node_count | (Optional) Specifies max number of nodes to be started in the pool (Default 3). | <pre>number</pre> |
| node_labels | (Optional) A map of Kubernetes labels which should be applied to nodes in this Node Pool. | <pre>any</pre> |
| node_taints | (Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created. | <pre>list(string)</pre> |
| orchestrator_version | (Optional) Version of Kubernetes used for the Agents. If not specified, the latest recommended version will be used at provisioning time. | <pre>string</pre> |
| os_disk_size_gb | (Optional) The Agent Operating System disk size in GB. Changing this forces a new resource to be created (Default 40). | <pre>number</pre> |
| os_disk_type | (Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Changing this forces a new resource to be created (Default Managed). | <pre>string</pre> |
| os_type | (Optional) The Operating System which should be used for this Node Pool. Changing this forces a new resource to be created. Possible values are Linux and Windows (Default Linux). | <pre>string</pre> |
| priority | (Optional) The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are Regular and Spot. Changing this forces a new resource to be created (Default Regular). | <pre>string</pre> |
| proximity_placement_group_id | (Optional) The ID of the Proximity Placement Group where the Virtual Machine Scale Set that powers this Node Pool will be placed. Changing this forces a new resource to be created. | <pre>string</pre> |
| scale_down_mode | (Optional) Specifies how the node pool should deal with scaled-down nodes. Allowed values are Delete and Deallocate. Defaults to Delete. | <pre>string</pre> |
| spot_max_price | (Optional) The maximum price you're willing to pay in USD per Virtual Machine. Valid values are -1 (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places. Changing this forces a new resource to be created (Default -1). | <pre>number</pre> |
| ultra_ssd_enabled | (Optional) Used to specify whether the UltraSSD is enabled in the Node Pool (Default false). | <pre>bool</pre> |
| upgrade_settings_max_surge | (Optional) The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade. | <pre>string</pre> |
| vm_size | (Required) The size of the nodes in the pool. | <pre>string</pre> |
| workload_runtime | (Optional) Used to specify the workload runtime. The allowed value for the moment is OCIContainer. (WebAssembly System Interface (WasmWasi) node pools are in Public Preview). | <pre>string</pre> |

### <a name="input_gitops_config"></a> [gitops\_config](#input\_gitops\_config)

```hcl
object({
    name            = string
    namespace       = string
    scope           = string
    url             = string
    reference_type  = string
    reference_value = string
    token_base64    = string
    kustomizations  = map(string)
  })
```

| Name | Description | Type |
|------|-------------|------|
| https_user | (Optional) Specifies the plaintext HTTPS username used to access private git repositories over HTTPS. | <pre>string</pre> |
| kustomizations | (Required) Is a Map of key/value to set the group of desired customizations, the key specifies the name of the customization and the value specifies the path in the source reference to reconcile on the cluster. Defaults to '{bootstrap = null}'. | <pre>map(string)</pre> |
| kustomizations<br/>.garbage_collection_enabled | (Optional) Whether garbage collections of Kubernetes objects created by this kustomization is enabled. Defaults to 'true'. | <pre>bool</pre> |
| kustomizations<br/>.name | (Required) Specifies the name of the kustomization. | <pre>string</pre> |
| kustomizations<br/>.path | (Optional) Specifies the path in the source reference to reconcile on the cluster. | <pre>string</pre> |
| kustomizations<br/>.retry_interval_in_seconds | (Optional) The interval at which to re-reconcile the kustomization on the cluster in the event of failure on reconciliation. Defaults to '60'. | <pre>number</pre> |
| kustomizations<br/>.sync_interval_in_seconds | (Optional) The interval at which to re-reconcile the kustomization on the cluster. Defaults to '60'. | <pre>number</pre> |
| name | (Required) Specifies the name which should be used for this Kubernetes Flux Configuration. Changing this forces a new Kubernetes Flux Configuration to be created. | <pre>string</pre> |
| namespace | (Required) Specifies the namespace to which this configuration is installed to. Changing this forces a new Kubernetes Flux Configuration to be created. | <pre>string</pre> |
| reference_type | (Required if 'git\_repository' wants to be used) Specifies the source reference type for the GitRepository object. Possible values are 'branch', 'commit', 'semver' and 'tag'. | <pre>string</pre> |
| reference_value | (Required if 'git\_repository' wants to be used) Specifies the source reference value for the tag. | <pre>string</pre> |
| scope | (Optional) Specifies the scope at which the operator will be installed. Possible values are 'cluster' and 'namespace'. Defaults to 'cluster'. Changing this forces a new Kubernetes Flux Configuration to be created. | <pre>string</pre> |
| token_base64 | (Optional) Specifies the Base64-encoded HTTPS certificate authority contents used to access git private git repositories over HTTPS. | <pre>string</pre> |
| url | (Required if 'git\_repository' wants to be used) Specifies the URL to sync for the flux configuration git repository. It must start with http://, https://, git@ or ssh://. | <pre>string</pre> |

### <a name="input_http_proxy_config"></a> [http\_proxy\_config](#input\_http\_proxy\_config)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| http_proxy | (Optional) The proxy address to be used when communicating over HTTP. Changing this forces a new resource to be created. | <pre>string</pre> |
| https_proxy | (Optional) The proxy address to be used when communicating over HTTPS. Changing this forces a new resource to be created. | <pre>string</pre> |
| no_proxy | (Optional) The list of domains that will not use the proxy for communication. Changing this forces a new resource to be created. | <pre>list(string)</pre> |
| trusted_ca | (Optional) The base64 encoded alternative CA certificate content in PEM format. | <pre>string</pre> |

### <a name="input_ingress_application_gateway"></a> [ingress\_application\_gateway](#input\_ingress\_application\_gateway)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| gateway_id | (Optional) The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster. See this page for further details. | <pre>string</pre> |
| gateway_name | (Optional) The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. | <pre>string</pre> |
| subnet_cidr | (Optional) The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. See this page for further details. | <pre>string</pre> |
| subnet_id | (Optional) The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. See this page for further details. | <pre>string</pre> |

### <a name="input_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#input\_key\_vault\_secrets\_provider)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| secret_rotation_enabled | (Optional) Should the secret store CSI driver on the AKS cluster be enabled? | <pre>bool</pre> |
| secret_rotation_interval | (Optional) The interval to poll for secret rotation. This attribute is only set when secret\_rotation is true and defaults to 2m. | <pre>string</pre> |

### <a name="input_kubelet_identity"></a> [kubelet\_identity](#input\_kubelet\_identity)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| client_id | (Optional) The Client ID of the user-defined Managed Identity to be assigned to the Kubelets. If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created. | <pre>string</pre> |
| object_id | (Optional) The Object ID of the user-defined Managed Identity assigned to the Kubelets.If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created. | <pre>string</pre> |
| user_assigned_identity_id | (Optional) The ID of the User Assigned Identity assigned to the Kubelets. If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created. | <pre>string</pre> |

### <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| allowed | (Optional) One or more allowed blocks as defined below. | <pre>any</pre> |
| allowed<br/>.day | (Required) A day in a week. Possible values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday and Saturday. | <pre>string</pre> |
| allowed<br/>.hours | (Required) An array of hour slots in a day. For example, specifying 1 will allow maintenance from 1:00am to 2:00am. Specifying 1, 2 will allow maintenance from 1:00am to 3:00m. Possible values are between 0 and 23. | <pre>list(number)</pre> |
| not_allowed | (Optional) One or more not\_allowed block as defined below. | <pre>any</pre> |
| not_allowed<br/>.end | (Required) The end of a time span, formatted as an RFC3339 string. | <pre>string</pre> |
| not_allowed<br/>.start | (Required) The start of a time span, formatted as an RFC3339 string. | <pre>string</pre> |

### <a name="input_maintenance_window_auto_upgrade"></a> [maintenance\_window\_auto\_upgrade](#input\_maintenance\_window\_auto\_upgrade)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| day_of_month | (Optional) The day of the month for the maintenance run. Required in combination with RelativeMonthly frequency. Value between 0 and 31 (inclusive). | <pre>number</pre> |
| day_of_week | (Optional) The day of the week for the maintenance run. Required in combination with weekly frequency. Possible values are Friday, Monday, Saturday, Sunday, Thursday, Tuesday and Wednesday. | <pre>string</pre> |
| duration | (Required) The duration of the window for maintenance to run in hours. Value between 4 and 24. | <pre>number</pre> |
| frequency | (Required) Frequency of maintenance. Possible options are Weekly, AbsoluteMonthly and RelativeMonthly. | <pre>string</pre> |
| interval | (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based. It must be an integer in range 1-4. For interval longer than 4 weeks, use monthly schedule types instead. | <pre>number</pre> |
| not_allowed | (Optional) One or more not\_allowed block as defined below. | <pre>any</pre> |
| not_allowed<br/>.end | (Required) The end of a time span, formatted as an RFC3339 string. | <pre>string</pre> |
| not_allowed<br/>.start | (Required) The start of a time span, formatted as an RFC3339 string. | <pre>string</pre> |
| start_date | (Optional) The date on which the maintenance window begins to take effect. | <pre>string</pre> |
| start_time | (Optional) The time for maintenance to begin, based on the timezone determined by utc\_offset. Format is HH:mm. | <pre>string</pre> |
| utc_offset | (Optional) Used to determine the timezone for cluster maintenance. | <pre>string</pre> |
| week_index | (Optional) Specifies on which instance of the allowed days specified in day\_of\_week the maintenance occurs. Options are First, Second, Third, Fourth, and Last. Required in combination with relative monthly frequency. | <pre>string</pre> |

### <a name="input_maintenance_window_node_os"></a> [maintenance\_window\_node\_os](#input\_maintenance\_window\_node\_os)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| day_of_month | (Optional) The day of the month for the maintenance run. Required in combination with RelativeMonthly frequency. Value between 0 and 31 (inclusive). | <pre>number</pre> |
| day_of_week | (Optional) The day of the week for the maintenance run. Required in combination with weekly frequency. Possible values are Friday, Monday, Saturday, Sunday, Thursday, Tuesday and Wednesday. | <pre>string</pre> |
| duration | (Required) The duration of the window for maintenance to run in hours. Value between 4 and 24. | <pre>number</pre> |
| frequency | (Required) Frequency of maintenance. Possible options are Weekly, AbsoluteMonthly and RelativeMonthly. | <pre>string</pre> |
| interval | (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based. It must be an integer in range 1-4. For interval longer than 4 weeks, use monthly schedule types instead. | <pre>number</pre> |
| not_allowed | (Optional) One or more not\_allowed block as defined below. | <pre>any</pre> |
| not_allowed<br/>.end | (Required) The end of a time span, formatted as an RFC3339 string. | <pre>string</pre> |
| not_allowed<br/>.start | (Required) The start of a time span, formatted as an RFC3339 string. | <pre>string</pre> |
| start_date | (Optional) The date on which the maintenance window begins to take effect. | <pre>string</pre> |
| start_time | (Optional) The time for maintenance to begin, based on the timezone determined by utc\_offset. Format is HH:mm. | <pre>string</pre> |
| utc_offset | (Optional) Used to determine the timezone for cluster maintenance. | <pre>string</pre> |
| week_index | (Optional) Specifies on which instance of the allowed days specified in day\_of\_week the maintenance occurs. Options are First, Second, Third, Fourth, and Last. Required in combination with relative monthly frequency. | <pre>string</pre> |

### <a name="input_microsoft_defender"></a> [microsoft\_defender](#input\_microsoft\_defender)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| log_analytics_workspace_id | (Required) Specifies the ID of the Log Analytics Workspace where the audit logs collected by Microsoft Defender should be sent to. You must use the 'microsoft\_defender\_enabled' and 'defender\_lwk\_id' variables instead, because this variable will be removed in the next major version. If 'microsoft\_defender.log\_analytics\_workspace\_id' and 'defender\_lwk\_id' are not provided and 'microsoft\_defender\_enabled' is true, the 'lwk\_id' variable will be used as Microsoft Denfender Log Analytics Workspace. | <pre>string</pre> |

### <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| dns_service_ip | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | <pre>string</pre> |
| docker_bridge_cidr | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created. | <pre>string</pre> |
| ip_versions | (Optional) Specifies a list of IP versions the Kubernetes Cluster will use to assign IP addresses to its nodes and pods. Possible values are IPv4 and/or IPv6. IPv4 must always be specified. Changing this forces a new resource to be created. | <pre>list(string)</pre> |
| network_plugin | (Required) Network plugin to use for networking. Currently supported values are azure, kubenet and none. Changing this forces a new resource to be created. | <pre>string</pre> |
| network_policy | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created. | <pre>string</pre> |
| outbound_type | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer. Changing this forces a new resource to be created. | <pre>string</pre> |
| pod_cidr | (Optional) The CIDR to use for pod IP addresses. This field can only be set when network\_plugin is set to kubenet. Changing this forces a new resource to be created. | <pre>string</pre> |
| pod_cidrs | (Optional) A list of CIDRs to use for pod IP addresses. For single-stack networking a single IPv4 CIDR is expected. For dual-stack networking an IPv4 and IPv6 CIDR are expected. | <pre>list(string)</pre> |
| service_cidr | (Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | <pre>string</pre> |
| service_cidrs | (Optional) A list of CIDRs to use for Kubernetes services. For single-stack networking a single IPv4 CIDR is expected. For dual-stack networking an IPv4 and IPv6 CIDR are expected. | <pre>list(string)</pre> |

### <a name="input_storage_profile"></a> [storage\_profile](#input\_storage\_profile)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| blob_driver_enabled | (Optional) Is the Blob CSI driver enabled? Defaults to false. | <pre>bool</pre> |
| disk_driver_enabled | (Optional) Is the Disk CSI driver enabled? Defaults to true. | <pre>bool</pre> |
| disk_driver_version | (Optional) :warning: DEPRECATED :warning:. Disk CSI Driver version to be used. This parameter has been deprecated in the AzureRM provider v3.116, so it must not be used. It will be removed in the next major version. | <pre>string</pre> |
| file_driver_enabled | (Optional) Is the File CSI driver enabled? Defaults to true. | <pre>bool</pre> |
| snapshot_controller_enabled | (Optional) Is the Snapshot Controller enabled? Defaults to true. | <pre>bool</pre> |

### <a name="input_windows_profile"></a> [windows\_profile](#input\_windows\_profile)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| admin_password | (Optional) The Admin Password for Windows VMs. Length must be between 14 and 123 characters. | <pre>string</pre> |
| admin_username | (Required) The Admin Username for Windows VMs. Changing this forces a new resource to be created. | <pre>string</pre> |
| license | (Optional) Specifies the type of on-premise license which should be used for Node Pool Windows Virtual Machine. At this time the only possible value is Windows\_Server. | <pre>string</pre> |

## Output example

```hcl
az_kubernetes = {
  "aks_extensions" = {
    cluster_ca_certificate = <sensitive>
    cluster_client_certificate = <sensitive>
    cluster_client_key = <sensitive>
    cluster_dskset_enabled = false
    cluster_extensions = [
      "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001/providers/Microsoft.KubernetesConfiguration/extensions/dapr",
      "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001/providers/Microsoft.KubernetesConfiguration/extensions/flux",
    ]
    cluster_fqdn = ""
    cluster_host = <sensitive>
    cluster_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001"
    cluster_name = "glnd1weuaksglobaltest001"
    cluster_network_profile = {
      "dns_service_ip" = "10.115.252.10"
      "docker_bridge_cidr" = ""
      "ebpf_data_plane" = ""
      "ip_versions" = [
        "IPv4",
      ]
      "load_balancer_profile" = [
        {
          "effective_outbound_ips" = []
          "idle_timeout_in_minutes" = 0
          "managed_outbound_ip_count" = 0
          "managed_outbound_ipv6_count" = 0
          "outbound_ip_address_ids" = []
          "outbound_ip_prefix_ids" = []
          "outbound_ports_allocated" = 0
        },
      ]
      "load_balancer_sku" = "standard"
      "nat_gateway_profile" = []
      "network_data_plane" = "azure"
      "network_mode" = ""
      "network_plugin" = "kubenet"
      "network_plugin_mode" = ""
      "network_policy" = "calico"
      "outbound_ip_address_ids" = []
      "outbound_ip_prefix_ids" = []
      "outbound_type" = "userDefinedRouting"
      "pod_cidr" = "10.112.0.0/16"
      "pod_cidrs" = [
        "10.112.0.0/16",
      ]
      "service_cidr" = "10.115.252.0/22"
      "service_cidrs" = [
        "10.115.252.0/22",
      ]
    }
    cluster_password = <sensitive>
    cluster_portal_fqdn = "5a0eb8ed53c40d7daa35b70c539781c4-priv.portal.hcp.westeurope.azmk8s.io"
    cluster_private_fqdn = "glnaks-nprhuplr.privatelink.westeurope.azmk8s.io"
    cluster_rsg = "glnd1weursgglobaltest001"
    cluster_username = <sensitive>
    cluster_version = "1.29.5"
    extra_ndpl = {
      "node001" = {
        "capacity_reservation_group_id" = ""
        "custom_ca_trust_enabled" = false
        "enable_auto_scaling" = true
        "enable_host_encryption" = true
        "enable_node_public_ip" = false
        "eviction_policy" = "Delete"
        "fips_enabled" = false
        "gpu_instance" = null
        "host_group_id" = ""
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001/agentPools/npl001"
        "kubelet_config" = []
        "kubelet_disk_type" = "OS"
        "kubernetes_cluster_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001"
        "linux_os_config" = []
        "max_count" = 2
        "max_pods" = 50
        "message_of_the_day" = "daily message"
        "min_count" = 0
        "mode" = "User"
        "name" = "npl001"
        "node_count" = 1
        "node_labels" = {
          "kubernetes.azure.com/scalesetpriority" = "spot"
        }
        "node_network_profile" = []
        "node_public_ip_prefix_id" = ""
        "node_taints" = [
          "kubernetes.azure.com/scalesetpriority=spot:NoSchedule",
        ]
        "orchestrator_version" = "1.29.5"
        "os_disk_size_gb" = 40
        "os_disk_type" = "Managed"
        "os_sku" = "Ubuntu"
        "os_type" = "Linux"
        "pod_subnet_id" = ""
        "priority" = "Spot"
        "proximity_placement_group_id" = ""
        "scale_down_mode" = "Delete"
        "snapshot_id" = null
        "spot_max_price" = 0.05
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AKS"
          "test1" = "test"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
        "ultra_ssd_enabled" = false
        "upgrade_settings" = []
        "vm_size" = "Standard_D4s_v3"
        "vnet_subnet_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt01"
        "windows_profile" = []
        "workload_runtime" = "OCIContainer"
        "zones" = [
          "1",
          "2",
          "3",
        ]
      }
      "node002" = {
        "capacity_reservation_group_id" = ""
        "custom_ca_trust_enabled" = false
        "enable_auto_scaling" = true
        "enable_host_encryption" = true
        "enable_node_public_ip" = false
        "eviction_policy" = ""
        "fips_enabled" = false
        "gpu_instance" = null
        "host_group_id" = ""
        "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001/agentPools/npl002"
        "kubelet_config" = []
        "kubelet_disk_type" = "OS"
        "kubernetes_cluster_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.ContainerService/managedClusters/glnd1weuaksglobaltest001"
        "linux_os_config" = []
        "max_count" = 3
        "max_pods" = 100
        "message_of_the_day" = ""
        "min_count" = 0
        "mode" = "User"
        "name" = "npl002"
        "node_count" = 1
        "node_labels" = {}
        "node_network_profile" = []
        "node_public_ip_prefix_id" = ""
        "node_taints" = []
        "orchestrator_version" = "1.29.5"
        "os_disk_size_gb" = 40
        "os_disk_type" = "Managed"
        "os_sku" = "Ubuntu"
        "os_type" = "Linux"
        "pod_subnet_id" = ""
        "priority" = "Regular"
        "proximity_placement_group_id" = ""
        "scale_down_mode" = "Delete"
        "snapshot_id" = null
        "spot_max_price" = -1
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AKS"
          "test2" = "test"
          "test_tag" = "test_tag"
        }
        "timeouts" = null
        "ultra_ssd_enabled" = false
        "ultra_ssd_enabled" = false
        "upgrade_settings" = []
        "vm_size" = "Standard_Ds2_v2"
        "vnet_subnet_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001-snt01"
        "windows_profile" = []
        "workload_runtime" = null
        "zones" = [
          "1",
          "2",
          "3",
        ]
      }
    }
    kube_config_raw = <sensitive>
    ndpl_rsg = "glnd1weuaksglobaltest001-rsg"
    ndpl_rsg_id = "/subscriptions/<azure_subscription_id>/resourceGroups/glnd1weuaksglobaltest001-rsg"
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|az_kubernetes|module.az_kubernetes|AZ Kubernetes outputs map. <br>[Map AZ Kubernetes Outputs](#AZ Kubernetes Outputs). |
|az_kubernetes_sensitive|module.az_kubernetes|AZ Kubernetes Sensitive outputs map. <br>[Map AZ Kubernetes Sensitive Outputs](#AZ Kubernetes Sensitive Outputs). |

<a name="AZ Kubernetes Outputs"></a>

### AZ Kubernetes Outputs

| Name | Description | Type |
|------|-------------|------|
| cluster_dskset_enabled | If an Azure Disk Encryption Set will be used in the AKS worker nodes. | <pre>module.az_kubernetes.cluster_dskset_enabled</pre> |
| cluster_dskset_id | If 'create\_disk\_encryption\_set' is true, the ID of the Azure Disk Encryption Set used by the AKS worker nodes. | <pre>module.az_kubernetes.cluster_dskset_id</pre> |
| cluster_dskset_name | If 'create\_disk\_encryption\_set' is true, the name of the Azure Disk Encryption Set used by the AKS worker nodes. | <pre>module.az_kubernetes.cluster_dskset_name</pre> |
| cluster_extensions | List containing all The IDs of Cluster extensions created. | <pre>module.az_kubernetes.cluster_extensions</pre> |
| cluster_fqdn | The FQDN of the Azure Kubernetes Managed Cluster. | <pre>module.az_kubernetes.cluster_fqdn</pre> |
| cluster_id | The Kubernetes Managed Cluster ID. | <pre>module.az_kubernetes.cluster_id</pre> |
| cluster_name | The Kubernetes Managed Cluster name. | <pre>module.az_kubernetes.cluster_name</pre> |
| cluster_network_profile | Map containing the configuration for the AKS network profile. | <pre>module.az_kubernetes.cluster_network_profile</pre> |
| cluster_portal_fqdn | The FQDN for the Azure Portal resources when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster. | <pre>module.az_kubernetes.cluster_portal_fqdn</pre> |
| cluster_private_fqdn | The FQDN for the Kubernetes Cluster when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster. | <pre>module.az_kubernetes.cluster_private_fqdn</pre> |
| cluster_rsg | The Kubernetes Managed Cluster Resource Group. | <pre>module.az_kubernetes.cluster_rsg</pre> |
| cluster_version | The current version running on the Azure Kubernetes Managed Cluster. | <pre>module.az_kubernetes.cluster_version</pre> |
| extra_ndpl | Map containing the configuration for the extra node pools created. | <pre>module.az_kubernetes.extra_ndpl</pre> |
| key_vault_key | If 'create\_disk\_encryption\_set' is true, the ID of the Key Vault Key used to encrypt the AKS. | <pre>module.az_kubernetes.key_vault_key</pre> |
| ndpl_rsg | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. | <pre>module.az_kubernetes.ndpl_rsg</pre> |
| ndpl_rsg_id | The ID of the Resource Group containing the resources for this Managed Kubernetes Cluster. | <pre>module.az_kubernetes.ndpl_rsg_id</pre> |

<a name="AZ Kubernetes Sensitive Outputs"></a>

### AZ Kubernetes Sensitive Outputs

| Name | Description | Type |
|------|-------------|------|
| cluster_ca_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. | <pre>module.az_kubernetes.cluster_ca_certificate</pre> |
| cluster_client_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. | <pre>module.az_kubernetes.cluster_client_certificate</pre> |
| cluster_client_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. | <pre>module.az_kubernetes.cluster_client_key</pre> |
| cluster_host | The Kubernetes cluster server host. | <pre>module.az_kubernetes.cluster_host</pre> |
| cluster_password | The password or token used to authenticate to the Kubernetes cluster. | <pre>module.az_kubernetes.cluster_password</pre> |
| cluster_username | The username used to authenticate to the Kubernetes cluster. | <pre>module.az_kubernetes.cluster_username</pre> |
| kube_config_raw | Raw Kubernetes config (YAML) to be used by kubectl and other compatible tools. | <pre>module.az_kubernetes.kube_config_raw</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
|'ultra_ssd_enabled' is only available with certain types of 'vm_size' | Some of the available 'vm_size' do not support 'ultra_ssd_enabled', for more information: [Documentation Link](https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal#ga-scope-and-limitations) | Not yet implemented |
| Encryption at host is only available with certain types of 'vm_size' | Some of the available 'vm_size' do not support encryption at host, for more information: [Documentation Link](https://docs.microsoft.com/en-us/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) | Not yet implemented |

[Register Preview Features](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/preview-features?tabs=azure-portal)
