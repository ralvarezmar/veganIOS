# Azure Load Balancer

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

- Azure VNet, Subnets, Network and Network interfaces (depending on config type).
- As this module only deploy Internal Load Balancers, only one VNET is allowed for the frontend_ip_configuration and backend_pools but there is no restriction with the subnets.

<a name="AZInputExample"></a>

## Input example

```hcl
az_netlb = {
  
  "00_lba_basic" {
    name           = "glns1weulbagene001"
    location       = "westeurope"
    resource_group = "glns1weursggene001"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.OperationalInsights/workspaces/glns1weulwkgene001"
    sku            = "Basic"
    frontend_ip_configuration = {
        ip_configuration01 = {
        name      = "glns1weuipcgene001"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        }
        ip_configuration02 = {
        name      = "glns1weuipcgene002"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        }
        // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
        // Example:
        ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
        }
    }

    //TAGS
    tags = {
        product     = "Gluon AZ LBA"
        environment = "dev"
        project     = "Gluon"
    }

  }

  "01_lba_default" {
        name           = "glns1weulbagene002"
    location       = "westeurope"
    resource_group = "glns1weursggene001"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.OperationalInsights/workspaces/glns1weulwkgene001"
    sku            = "Standard"
    frontend_ip_configuration = {
        ip_configuration01 = {
        name      = "Testing_LBA1"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        zones     = ["1"]
        }
        ip_configuration02 = {
        name      = "Testing_LBA2"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        zones     = ["1"]
        }
        // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
        // Example:
        ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
        }
    }

    //TAGS
    tags = {
        product     = "Gluon AZ LBA"
        environment = "dev"
        project     = "Gluon"
    }
  }

  
  "02_lba_availabilty_zone" {
        name           = "glns1weulbagene003"
    location       = "westeurope"
    resource_group = "glns1weursggene001"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.OperationalInsights/workspaces/glns1weulwkgene001"
    sku            = "Standard"
    vnet_id        = "/subscriptions/<azure_subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Network/virtualNetworks/glns1weuvnttest001"

    frontend_ip_configuration = {
        ip_configuration01 = {
        name      = "Testing_LBA1"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        zones     = ["1"]
        }
        ip_configuration02 = {
        name      = "Testing_LBA2"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        zones     = ["1"]
        }
        // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
        // Example:
        ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
        }
    }

    backend_pools = {
        "backendpool01" = {
        name         = "Testing_BackendPool"
        ip_addresses = ["10.0.1.10", "10.0.1.11"]
        }
        "backendpool02" = {
        name         = "Testing_BackendPool2"
        ip_addresses = ["10.0.1.12"]
        }
    }

    lba_probes = {
        probe_01 = {
        name         = "Probe01"
        protocol     = "Http"
        port         = 22
        request_path = "/"

        }
        probe_02 = {
        name         = "Probe02"
        protocol     = "Http"
        port         = 22
        request_path = "/"

        }
    }

    nat_rules = {
        rule_01 = {
        name                           = "NatRule_01"
        protocol                       = "Udp"
        frontend_port                  = 1000
        backend_port                   = 1000
        frontend_ip_configuration_name = "Testing_LBA1"
        enable_floating_ip             = false
        }
        natRule_dynamic = {
        name                           = "NatRule_dynamic"
        protocol                       = "Tcp"
        backend_port                   = 443
        frontend_ip_configuration_name = "Testing_LBA2"
        frontend_port_start            = 100,
        frontend_port_end              = 110,
        backend_address_pool_key       = "backendpool02"
        }
    }

    network_interface_nat_rule_association = {
        assoc_1 = {
        network_interface_id  = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/networkInterfaces/glns1weuvmagene001-nic"
        ip_configuration_name = "glns1weuvmagene001-ipconfig"
        nat_rule_key          = "rule_01"
        }
    }

    lba_rules = {
        rule_01 = {
        backend_pool_keys              = ["backendpool01"]
        probe_key                      = "probe_01"
        name                           = "Rule_3389"
        protocol                       = "Tcp"
        frontend_port                  = 10000
        backend_port                   = 10000
        frontend_ip_configuration_name = "Testing_LBA1"
        load_distribution              = "Default"

        }
    }

    nat_pools = {
        pool_01 = {
        name                           = "NatPool_01"
        protocol                       = "Tcp"
        frontend_port_start            = 80
        frontend_port_end              = 81
        backend_port                   = 8080
        frontend_ip_configuration_name = "Testing_LBA1"
        floating_ip_enabled            = false
        }
        pool_02 = {
        name                           = "NatPool_02"
        protocol                       = "Tcp"
        frontend_port_start            = 22
        frontend_port_end              = 23
        backend_port                   = 433
        frontend_ip_configuration_name = "Testing_LBA2"
        floating_ip_enabled            = false
        }
    }

    //TAGS
    tags = {
        product     = "Gluon AZ LBA"
        environment = "dev"
        project     = "Gluon"
    }
  }

  "03_lba_nat_rules" {
        name           = "glns1weulbagene004"
    location       = "westeurope"
    resource_group = "glns1weursggene001"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.OperationalInsights/workspaces/glns1weulwkgene001"
    sku            = "Standard"
    frontend_ip_configuration = {
    ip_configuration01 = {
        name      = "Testing_LBA1"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        zones     = ["1"]
    }
    ip_configuration02 = {
        name      = "Testing_LBA2"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        zones     = ["1"]
    }
    // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
    // Example:
    ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
    }
    }

    backend_pools = {
    backendpool01 = {
        name = "Testing_BackendPool"
        nic_association = {
        nic01 = {
            network_interface_id  = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/networkInterfaces/glns1weuvmagene001-nic1"
            ip_configuration_name = "ipconfig1"
        }
        nic02 = {
            network_interface_id  = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/networkInterfaces/glns1weuvmagene001-nic2"
            ip_configuration_name = "ipconfig2"
        }
        }
    }
    backendpool02 = {
        name = "Testing_BackendPool2"
        nic_association = {
        nic01 = {
            network_interface_id  = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/networkInterfaces/glns1weuvmagene001-nic1"
            ip_configuration_name = "ipconfig1"
        }
        }
    }
    }

    //TAGS
    tags = {
    product     = "Gluon AZ LBA"
    environment = "dev"
    project     = "Gluon"
    }
  }

  "04_lba_rules_gateway" {
    name           = "glns1weulbagene001"
    location       = "westeurope"
    resource_group = "glns1weursglbaenv"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursglbaenv/providers/Microsoft.OperationalInsights/workspaces/glns1weulwklbaenv"
    sku            = "Gateway"
    frontend_ip_configuration = {
      ip_configuration01 = {
        name      = "Testing_LBA1"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursglbaenv/providers/Microsoft.Network/virtualNetworks/glns1weuvnetlbaenv/subnets/glns1weulbaenv-snt"
        zones     = ["1"]
      }
      ip_configuration02 = {
        name      = "Testing_LBA2"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursglbaenv/providers/Microsoft.Network/virtualNetworks/glns1weuvnetlbaenv/subnets/glns1weulbaenv-snt2"
        zones     = ["1"]
      }
      // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
      // Example:
      ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursglbaenv/providers/Microsoft.Network/virtualNetworks/glns1weuvnetlbaenv/subnets/glns1weulbaenv-snt"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
      }
    }

    vnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursglbaenv/providers/Microsoft.Network/virtualNetworks/glns1weuvnetlbaenv"

    backend_pools = {
      "backendpool01" = {
        name         = "Testing_BackendPool"
        ip_addresses = ["10.0.1.10", "10.0.1.11"]
        tunnel_interface = {
          "interface02" = {
            identifier = 801
            type       = "External"
            protocol   = "VXLAN"
            port       = 443
          }
        }
      }
      "backendpool02" = {
        name         = "Testing_BackendPool2"
        ip_addresses = ["10.0.1.12"]
        tunnel_interface = {
          "interface01" = {
            identifier = 800
            type       = "Internal"
            protocol   = "VXLAN"
            port       = 22
          }
          "interface02" = {
            identifier = 801
            type       = "External"
            protocol   = "VXLAN"
            port       = 443
          }
        }
      }
    }

    log_categories = ["LoadBalancerHealthEvent"]

    //TAGS
    tags = {
      product     = "Gluon AZ LBA"
      environment = "dev"
      project     = "Gluon"
    }
  }

  "05_lba_syncmode" {
    name           = "glns1weulbagene003"
    location       = "westeurope"
    resource_group = "glns1weursggene001"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.OperationalInsights/workspaces/glns1weulwkgene001"
    sku            = "Standard"
    vnet_id        = "/subscriptions/<azure_subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Network/virtualNetworks/glns1weuvnttest001"

    frontend_ip_configuration = {
        ip_configuration01 = {
        name      = "Testing_LBA1"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        zones     = ["1"]
        }
        ip_configuration02 = {
        name      = "Testing_LBA2"
        subnet_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt02"
        zones     = ["1"]
        }
        // If you want to use a static ip address private_ip_address_allocation attribute must be Static.
        // Example:
        ip_configuration03 = {
        name                          = "Testing_LBA3"
        subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001/subnets/glns1weuvntgene001-snt01"
        private_ip_address            = "10.0.1.27"
        private_ip_address_allocation = "Static"
        }
    }

    backend_pools = {
        "backendpool01" = {
        name             = "Testing_BackendPool3"
        synchronous_mode = "Automatic"
        }
        "backendpool02" = {
        name               = "Testing_BackendPool4"
        synchronous_mode   = "Manual"
        ip_addresses       = ["10.0.1.13"]
        virtual_network_id = "/subscriptions/<az_subscription_id>/resourceGroups/glns1weursggene001/providers/Microsoft.Network/virtualNetworks/glns1weuvntgene001"
        }
    }

    lba_probes = {
        probe_01 = {
        name         = "Probe01"
        protocol     = "Http"
        port         = 22
        request_path = "/"

        }
        probe_02 = {
        name         = "Probe02"
        protocol     = "Http"
        port         = 22
        request_path = "/"

        }
    }

    lba_rules = {
        rule_01 = {
        backend_pool_keys              = ["backendpool01"]
        probe_key                      = "probe_01"
        name                           = "Rule_3389"
        protocol                       = "Tcp"
        frontend_port                  = 10000
        backend_port                   = 10000
        frontend_ip_configuration_name = "Testing_LBA1"
        load_distribution              = "Default"

        }
    }

    storage_account_id             = "/subscriptions/<azure_subscription_id>/resourceGroups/<rsg_name>/providers/Microsoft.Storage/storageAccounts/glns1weustakvtest"
    eventhub_name                  = "glns1weuaehemstest011"
    eventhub_authorization_rule_id = "/subscriptions/<azure_subscription_id>/resourceGroups/<rsg_name>/providers/Microsoft.EventHub/namespaces/glns1weuensgene001-nmsp/authorizationRules/RootManageSharedAccessKey"

    //TAGS
    tags = {
        product     = "Gluon AZ LBA"
        environment = "dev"
        project     = "Gluon"
    }
  }

}
```

## Variables & Configuration

### Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| lwk_id | Specifies the name of a Log Analytics Workspace where Diagnostics Data should be sent. | <pre>string</pre> |
| name | Specifies the name of the Load Balancer. Changing this forces a new resource to be created. | <pre>string</pre> |
| resource_group | The name of the Resource Group in which to create the Load Balancer. Changing this forces a new resource to be created. | <pre>string</pre> |

### Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| analytics_diagnostic_monitor | The name of the Analytics Diagnostic Monitor for Load Balancer Monitor. | <pre>string</pre> | "" |
| [backend_pools](#input_backend_pools) | A map of one or multiple Backendpools blocks as documented below. | <pre>any</pre> | {} |
| edge_zone | Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Changing this forces a new Load Balancer to be created. | <pre>string</pre> | null |
| [frontend_ip_configuration](#input_frontend_ip_configuration) | A map of one or multiple frontend\_ip\_configuration blocks as documented below. | <pre>any</pre> | {} |
| [lba_probes](#input_lba_probes) | A map of one or multiple Probe blocks as documented below. | <pre>any</pre> | {} |
| [lba_rules](#input_lba_rules) | A map of one or multiple Rules blocks as documented below. | <pre>any</pre> | {} |
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created. | <pre>string</pre> | "" |
| [metrics](#input_metrics) | Specifies if metrics are going to be stored or not. In case we want to store, the key will be 0 and the value should be a list of the different metrics. We have to add all metrics to some list. If a specific metric is not longer needed, it should have a key '-1'. | <pre>any</pre> | {<br>  "0": [<br>    "AllMetrics"<br>  ]<br>} |
| [nat_pools](#input_nat_pools) | Specifies map of the Pools Nat | <pre>any</pre> | {} |
| [nat_rules](#input_nat_rules) | A map of one or multiple Nat Rules blocks as documented below. | <pre>any</pre> | {} |
| [network_interface_nat_rule_association](#input_network_interface_nat_rule_association) | A map of one or multiple associations between a Network Interfaces and a Load Balancer's NAT Rules. | <pre>any</pre> | {} |
| sku | The SKU of the Azure Load Balancer. Accepted values are Basic, Standard and Gateway. Defaults to Standard. | <pre>string</pre> | "Standard" |
| sku_tier | The Sku Tier of this Load Balancer. The only possible value is Regional. Changing this forces a new resource to be created. | <pre>string</pre> | "Regional" |
| tags | Map of tags to assign to the KeyVault. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | <pre>any</pre> | {} |
| vnet_id | (Required if var.backend\_pools.ip\_addresses is provided) The id of the Vnet where the frontend IP addresses and backend pool IP addresses are located. | <pre>string</pre> | "" |

## Block Parameters

#### <a name="input_backend_pools"></a> [backend\_pools](#input\_backend\_pools)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| identifier | (Required) The unique identifier of this Gateway Lodbalancer Tunnel Interface. | <pre>number</pre> |
| ip_addresses | (Optional) IPs to configure as destinations of the Load Balancer. | <pre>list(string)</pre> |
| ip_configuration_name | (Required) The Name of the IP Configuration within the Network Interface which should be connected to the Backend Address Pool. Changing this forces a new resource to be created. | <pre>string</pre> |
| loadbalancer_id | (Required) The ID of the Load Balancer in which to create the Backend Address Pool. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | (Required) Specifies the name of the Backend Address Pool. Changing this forces a new resource to be created. | <pre>string</pre> |
| network_interface_id | (Required) The ID of the Network Interface. Changing this forces a new resource to be created. | <pre>string</pre> |
| nic_association | (Optional) One or more blocks that manages the association between a Network Interface and a Load Balancer's Backend Address Pool. | <pre>object({<br>network_interface_id=(string),<br>ip_configuration_name=(string)})</pre> |
| port | (Required) The port number that this Gateway Lodbalancer Tunnel Interface listens to. | <pre>number</pre> |
| protocol | (Required) The protocol used for this Gateway Lodbalancer Tunnel Interface. Possible values are None, Native and VXLAN. | <pre>string</pre> |
| tunnel_interface | (Optional) One or more tunnel\_interface blocks as defined below. | <pre>object({<br>identifier=(number),<br>type=(string),<br>protocol=(string),<br>port=(number)<br>})</pre> |
| type | (Required) The traffic type of this Gateway Lodbalancer Tunnel Interface. Possible values are None, Internal and External. | <pre>string</pre> |

#### <a name="input_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#input\_frontend\_ip\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| gateway_load_balancer_frontend_ip_configuration_id | (Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer. | <pre>string</pre> |
| name | (Required) Specifies the name of the frontend IP configuration. | <pre>string</pre> |
| private_ip_address | (Optional) Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned. | <pre>string</pre> |
| private_ip_address_allocation | (Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static. | <pre>string</pre> |
| private_ip_address_version | (Optional) The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6. | <pre>string</pre> |
| public_ip_address_id | (Optional) The ID of a Public IP Address which should be associated with the Load Balancer. | <pre>string</pre> |
| public_ip_prefix_id | (Optional) The ID of a Public IP Prefix which should be associated with the Load Balancer. Public IP Prefix can only be used with outbound rules. | <pre>string</pre> |
| subnet_id | (Optional) The ID of the Subnet which should be associated with the IP Configuration. | <pre>string</pre> |
| zones | (Optional) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located. | <pre>list(string)</pre> |

#### <a name="input_lba_probes"></a> [lba\_probes](#input\_lba\_probes)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| interval_in_seconds | (Optional) The interval, in seconds between probes to the backend endpoint for health status. The default value is 15, the minimum value is 5. | <pre>number</pre> |
| loadbalancer_id | (Required) The ID of the LoadBalancer in which to create the NAT Rule. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | (Required) Specifies the name of the Probe. Changing this forces a new resource to be created. | <pre>string</pre> |
| number_of_probes | (Optional) The number of failed probe attempts after which the backend endpoint is removed from rotation. The default value is 2. NumberOfProbes multiplied by intervalInSeconds value must be greater or equal to 10.Endpoints are returned to rotation when at least one probe is successful. | <pre>number</pre> |
| port | (Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive. | <pre>number</pre> |
| probe_threshold | (Optional) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100. The default value is 1. | <pre>number</pre> |
| protocol | (Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If TCP is specified, a received ACK is required for the probe to be successful. If HTTP is specified, a 200 OK response from the specified URI is required for the probe to be successful. | <pre>string</pre> |
| request_path | (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed. | <pre>string</pre> |

#### <a name="input_lba_rules"></a> [lba\_rules](#input\_lba\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| backend_pool_keys | (Optional) A list of reference to a Backend Address Pool over which this Load Balancing Rule operates. | <pre>list(string)</pre> |
| backend_port | (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive. | <pre>number</pre> |
| disable_outbound_snat | (Optional) Is snat enabled for this Load Balancer Rule? Default false. | <pre>bool</pre> |
| enable_floating_ip | (Optional) Are the Floating IPs enabled for this Load Balncer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false. | <pre>string</pre> |
| enable_tcp_reset | (Optional) Is TCP Reset enabled for this Load Balancer Rule? | <pre>bool</pre> |
| frontend_ip_configuration_name | (Required) The name of the frontend IP configuration to which the rule is associated. | <pre>string</pre> |
| frontend_port | (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive. | <pre>number</pre> |
| idle_timeout_in_minutes | (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes. | <pre>number</pre> |
| load_distribution | (Optional) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively. | <pre>string</pre> |
| name | (Required) Specifies the name of the LB Rule. Changing this forces a new resource to be created. | <pre>string</pre> |
| probe_key | (Optional) A reference to a Probe used by this Load Balancing Rule. | <pre>list(string)</pre> |
| protocol | (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All. | <pre>string</pre> |

#### <a name="input_metrics"></a> [metrics](#input\_metrics)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| -1 | (Optional) To disable the metrics and logs. | <pre>string</pre> |
| 0 | (Optional) To store logs without retention. | <pre>string</pre> |

#### <a name="input_nat_pools"></a> [nat\_pools](#input\_nat\_pools)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| backend_port | (Required) The port used for the internal endpoint. Possible values range between 1 and 65535, inclusive. | <pre>string</pre> |
| floating_ip_enabled | (Optional) Are the floating IPs enabled for this Load Balancer Rule? A floating IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. | <pre>bool</pre> |
| frontend_ip_configuration_name | (Required) The name of the frontend IP configuration exposing this rule. | <pre>string</pre> |
| frontend_port_end | (Required) The last port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive. | <pre>string</pre> |
| frontend_port_start | (Required) The first port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive. | <pre>string</pre> |
| idle_timeout_in_minutes | (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30. Defaults to 4. | <pre>number</pre> |
| loadbalancer_id | (Required) The ID of the Load Balancer in which to create the NAT pool. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | (Required) Specifies the name of the NAT pool. Changing this forces a new resource to be created. | <pre>string</pre> |
| protocol | (Required) The transport protocol for the external endpoint. Possible values are All, Tcp and Udp. | <pre>string</pre> |
| resource_group_name | (Required) The name of the resource group in which to create the resource. Changing this forces a new resource to be created. | <pre>string</pre> |
| tcp_reset_enabled | (Optional) Is TCP Reset enabled for this Load Balancer Rule? | <pre>bool</pre> |

#### <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| backend_address_pool_key | (Optional) Specifies a reference to tfvars backend\_pools map key. | <pre>string</pre> |
| backend_port | (Required) The port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive. | <pre>number</pre> |
| enable_floating_ip | (Optional) Are the Floating IPs enabled for this Load Balancer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false. | <pre>bool</pre> |
| enable_tcp_reset | (Optional) Is TCP Reset enabled for this Load Balancer Rule? | <pre>bool</pre> |
| frontend_ip_configuration_name | (Required) The name of the frontend IP configuration exposing this rule. | <pre>string</pre> |
| frontend_port | (Optional) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 1 and 65534, inclusive. | <pre>number</pre> |
| frontend_port_end | (Optional) The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534, inclusive. | <pre>number</pre> |
| frontend_port_start | (Optional) The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534, inclusive. | <pre>number</pre> |
| idle_timeout_in_minutes | (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes. | <pre>number</pre> |
| loadbalancer_id | (Required) The ID of the Load Balancer in which to create the NAT Rule. Changing this forces a new resource to be created. | <pre>string</pre> |
| name | (Required) Specifies the name of the NAT Rule. Changing this forces a new resource to be created. | <pre>string</pre> |
| protocol | (Required) The transport protocol for the external endpoint. Possible values are Udp, Tcp or All. | <pre>string</pre> |
| resource_group_name | (Required) The name of the resource group in which to create the resource. Changing this forces a new resource to be created. | <pre>string</pre> |

#### <a name="input_network_interface_nat_rule_association"></a> [network\_interface\_nat\_rule\_association](#input\_network\_interface\_nat\_rule\_association)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| ip_configuration_name | (Required) The Name of the IP Configuration within the Network Interface which should be connected to the NAT Rule. Changing this forces a new resource to be created. | <pre>string</pre> |
| nat_rule_key | (Required) The key map of the Load Balancer NAT Rule defined in tfvars which this Network Interface should be connected to. Changing this forces a new resource to be created. | <pre>string</pre> |
| network_interface_id | (Required) The ID of the Network Interface. Changing this forces a new resource to be created. | <pre>string</pre> |

## Output example

```hcl
"lb_backend_address_pool" = {
  "backendpool01" = {
      "backend_ip_configurations" = []
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/backendAddressPools/Testing_BackendPool"
      "inbound_nat_rules" = []
      "load_balancing_rules" = [
      "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/loadBalancingRules/Rule_3389",
      ]
      "outbound_rules" = []
  }
}
"lb_backend_address_pool_addresses" = {
  "backendpool01_10.0.1.30" = {
      "backend_address_pool_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/backendAddressPools/Testing_BackendPool"
      "ip_address" = "10.0.1.30"
      "name" = "backendpool01_10.0.1.30"
      "virtual_network_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/virtualNetworks/glns1weuvnetglntsts2490"
  }
  "backendpool01_10.0.1.31" = {
      "backend_address_pool_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/backendAddressPools/Testing_BackendPool"
      "ip_address" = "10.0.1.31"
      "name" = "backendpool01_10.0.1.31"
      "virtual_network_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/virtualNetworks/glns1weuvnetglntsts2490"
  }
}
"lb_diagnostic_monitor_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb|test_lb-dgs"
"lb_interface_address_pool" = {}
"lb_nat_pool" = {
  "pool_01" = {
      "backend_port" = 8080
      "frontend_ip_configuration_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/frontendIPConfigurations/Testing_LBA1"
      "frontend_ip_configuration_name" = "Testing_LBA1"
      "frontend_port_end" = 81
      "frontend_port_start" = 80
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/inboundNatPools/NatPool_01"
      "loadbalancer_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb"
      "name" = "NatPool_01"
      "protocol" = "Tcp"
      "resource_group_name" = "test_rsg"
  }
}
"lb_nat_rules" = {
  "rule_01" = {
      "backend_address_pool_id" = null
      "backend_port" = 23
      "enable_floating_ip" = false
      "enable_tcp_reset" = true
      "frontend_ip_configuration_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/frontendIPConfigurations/Testing_LBA1"
      "frontend_port" = 22
      "frontend_port_end" = null
      "frontend_port_start" = null
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/inboundNatRules/NatRule_01"
      "idle_timeout_in_minutes" = 30
      "loadbalancer_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb"
      "name" = "NatRule_01"
      "protocol" = "Tcp"
      "resource_group_name" = "test_rsg"
  }
  "rule_22" = {
      "backend_address_pool_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/backendAddressPools/Testing_BackendPool2"
      "backend_port" = 443
      "enable_floating_ip" = false
      "enable_tcp_reset" = false
      "frontend_ip_configuration_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/frontendIPConfigurations/Testing_LBA2"
      "frontend_port" = 0
      "frontend_port_end" = 110
      "frontend_port_start" = 100
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/inboundNatRules/NatRule_22"
      "idle_timeout_in_minutes" = 4
      "loadbalancer_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb"
      "name" = "NatRule_22"
      "protocol" = "Tcp"
      "resource_group_name" = "test_rsg"
  }
}
"lb_probes" = {
  "probe_01" = {
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/probes/Probe01"
      "interval_in_seconds" = 15
      "loadbalancer_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb"
      "name" = "Probe01"
      "number_of_probes" = 2
      "port" = 22
      "probe_threshold" = 1
      "protocol" = "Http"
      "request_path" = "/"
}
  "probe_02" = {
      "id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/probes/Probe02"
      "interval_in_seconds" = 15
      "loadbalancer_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb"
      "name" = "Probe02"
      "number_of_probes" = 2
      "port" = 22
      "probe_threshold" = 1
      "protocol" = "Http"
      "request_path" = "/"
  }
}
"lb_rules" = {
  "rule_01" = {
      "backend_address_pool_ids" = [
      "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/backendAddressPools/Testing_BackendPool",
      ]
      "backend_port" = 10000
      "frontend_ip_configuration_id" = "/subscriptions/<azure_subscription_id>/resourceGroups/test_rsg/providers/Microsoft.Network/loadBalancers/test_lb/frontendIPConfigurations/Testing_LBA1"
      "frontend_ip_configuration_name" = "Testing_LBA1"
      "frontend_port" = 10000
      "name" = "Rule_3389"
  }
}
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| [lb_backend_address_pool](#output_lb_backend_address_pool) | All outputs got from backend address pool resource. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool</pre> |
| [lb_backend_address_pool_addresses](#output_lb_backend_address_pool_addresses) | All outputs got from load balancer backend address pool addresses resource. | <pre>module.az_netlb.azurerm_lb_backend_address_pool_address.pool_address</pre> |
| lb_diagnostic_monitor_id | The ID of the Diagnostic Setting | <pre>azure_monitor_diagnostic_setting.dgm[0].id</pre> |
| [lb_interface_address_pool](#output_lb_interface_address_pool) | All outputs got from load balancer interface address pool resource. | <pre>module.az_netlb.azurerm_network_interface_backend_address_pool_association.nic_associate</pre> |
| [lb_nat_pool](#output_lb_nat_pool) | All outputs got from load balancer nat pools resource. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool</pre> |
| [lb_nat_rules](#output_lb_nat_rules) | All outputs got from load balancer nat rules resource. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule</pre> |
| [lb_nic_nat_rule_association](#output_lb_nic_nat_rule_association) | All outputs got from network interface and nat rule association. | <pre>module.az_netlb.azurerm_network_interface_nat_rule_association.nic_nat_rule_association</pre> |
| [lb_probes](#output_lb_probes) | The Map of the Load Balancer Probe. | <pre>module.az_netlb.azurerm_lb_probe.probes</pre> |
| [lb_rules](#output_lb_rules) | All outputs got from load balancer rules resource. | <pre>module.az_netlb.azurerm_lb_rule.rules</pre> |
| [load_balancer](#output_load_balancer) | All outputs got from load balancer resource. | <pre>module.az_netlb.azurerm_lb.load_balancer</pre> |

### Block Parameters

#### <a name="output_lb_backend_address_pool"></a> [lb\_backend\_address\_pool](#output\_lb\_backend\_address\_pool)

| Name | Description | Type |
|------|-------------|------|
| backend\_ip\_configurations | The Backend IP Configurations associated with this Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool.backend_ip_configurations</pre> |
| id | The ID of the Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool.id</pre> |
| inbound\_nat\_rules | An array of the Load Balancing Inbound NAT Rules associated with this Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool.inbound_nat_rules</pre> |
| load\_balancing\_rules | The Load Balancing Rules associated with this Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool.load_balancing_rules</pre> |
| outbound\_rules | An array of the Load Balancing Outbound Rules associated with this Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool.bkd_address_pool.outbound_rules</pre> |

#### <a name="output_lb_backend_address_pool_addresses"></a> [lb\_backend\_address\_pool\_addresses](#output\_lb\_backend\_address\_pool\_addresses)

| Name | Description | Type |
|------|-------------|------|
| backend\_address\_pool\_id | Backed address pool identifier. | <pre>module.az_netlb.azurerm_lb_backend_address_pool_address.pool_address.backend_address_pool_id</pre> |
| ip\_address | The IP Address which allocated to this Backend Address Pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool_address.pool_address.ip_address</pre> |
| name | The name of the backend address pool. | <pre>module.az_netlb.azurerm_lb_backend_address_pool_address.pool_address.name</pre> |
| virtual\_network\_id | The ID of the Virtual Network within which the Backend Address Pool exist. | <pre>module.az_netlb.azurerm_lb_backend_address_pool_address.pool_address.virtual_network_id</pre> |

#### <a name="output_lb_interface_address_pool"></a> [lb\_interface\_address\_pool](#output\_lb\_interface\_address\_pool)

| Name | Description | Type |
|------|-------------|------|
| backend\_address\_pool\_id | Backend address pool identifier. | <pre>module.az_netlb.azurerm_network_interface_backend_address_pool_association.nic_associate.backend_address_pool_id</pre> |
| id | Network interface backend address pool association nic identifier. | <pre>module.az_netlb.azurerm_network_interface_backend_address_pool_association.nic_associate.id</pre> |
| ip\_configuration\_name | Ip configuration name. | <pre>module.az_netlb.azurerm_network_interface_backend_address_pool_association.nic_associate.ip_configuration_name</pre> |
| network\_interface\_id | Network interface identifier. | <pre>module.az_netlb.azurerm_network_interface_backend_address_pool_association.nic_associate.network_interface_id</pre> |

#### <a name="output_lb_nat_pool"></a> [lb\_nat\_pool](#output\_lb\_nat\_pool)

| Name | Description | Type |
|------|-------------|------|
| backend\_port | The port used for the internal endpoint. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.backend_port</pre> |
| frontend\_ip\_configuration\_id | The id of the frontend IP configuration exposing this rule. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.frontend_ip_configuration_id</pre> |
| frontend\_ip\_configuration\_name | The name of the frontend IP configuration exposing this rule. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.frontend_ip_configuration_name</pre> |
| frontend\_port\_end | The last port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.frontend_port_end</pre> |
| frontend\_port\_start | The first port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.frontend_port_start</pre> |
| id | Identifiar of nat rule. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.id</pre> |
| loadbalancer\_id | The ID of the Load Balancer in which to create the NAT pool. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.loadbalancer_id</pre> |
| name | Specifies the name of the NAT Pool. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.name</pre> |
| protocol | The transport protocol for the external endpoint. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.protocol</pre> |
| resource\_group\_name | The name of the resource group in which to create the resource. | <pre>module.az_netlb.azurerm_lb_nat_pool.nat_pool.resource_group_name</pre> |

#### <a name="output_lb_nat_rules"></a> [lb\_nat\_rules](#output\_lb\_nat\_rules)

| Name | Description | Type |
|------|-------------|------|
| backend\_address\_pool\_id | Specifies a reference to backendAddressPool resource. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.backend_address_pool_id</pre> |
| backend\_port | The port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.backend_port</pre> |
| enable\_floating\_ip | Are the Floating IPs enabled for this Load Balancer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.enable_floating_ip</pre> |
| enable\_tcp\_reset | Is TCP Reset enabled for this Load Balancer Rule? | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.enable_tcp_reset</pre> |
| frontend\_ip\_configuration\_id | The id of the frontend IP configuration exposing this rule. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.frontend_ip_configuration_id</pre> |
| frontend\_port | The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 1 and 65534, inclusive. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.frontend_port</pre> |
| frontend\_port\_end | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534, inclusive. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.frontend_port_end</pre> |
| frontend\_port\_start | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534, inclusive. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.frontend_port_start</pre> |
| id | Specifies the id of the NAT Rule. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.id</pre> |
| idle\_timeout\_in\_minutes | Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30 minutes. Defaults to 4 minutes. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.idle_timeout_in_minutes</pre> |
| loadbalancer\_id | The ID of the Load Balancer in which to create the NAT Rule. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.loadbalancer_id</pre> |
| name | Specifies the name of the NAT Rule. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.name</pre> |
| protocol | The transport protocol for the external endpoint. Possible values are Udp, Tcp or All. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.protocol</pre> |
| resource\_group\_name | The name of the resource group in which to create the resource. | <pre>module.az_netlb.azurerm_lb_nat_rule.nat_rule.resource_group_name</pre> |

#### <a name="output_lb_nic_nat_rule_association"></a> [lb\_nic\_nat\_rule\_association](#output\_lb\_nic\_nat\_rule\_association)

| Name | Description | Type |
|------|-------------|------|
| ip\_configuration\_name | The Name of the IP Configuration within the Network Interface which should be connected to the NAT Rule. | <pre>module.az_netlb.azurerm_network_interface_nat_rule_association.nic_nat_rule_association.ip_configuration_name</pre> |
| nat\_rule\_id | The ID of the Load Balancer NAT Rule which this Network Interface which should be connected to. | <pre>module.az_netlb.azurerm_network_interface_nat_rule_association.nic_nat_rule_association.nat_rule_id</pre> |
| network\_interface\_id | The ID of the Network Interface. | <pre>module.az_netlb.azurerm_network_interface_nat_rule_association.nic_nat_rule_association.network_interface_id</pre> |

#### <a name="output_lb_probes"></a> [lb\_probes](#output\_lb\_probes)

| Name | Description | Type |
|------|-------------|------|
| interval\_in\_seconds | The interval, in seconds between probes to the backend endpoint for health status. | <pre>module.az_netlb.azurerm_lb_probe.probes.interval_in_seconds</pre> |
| loadbalancer\_id | The ID of the LoadBalancer in which to create the NAT Rule. | <pre>module.az_netlb.azurerm_lb_probe.probes.loadbalancer_id</pre> |
| name | (azurerm\_lb\_probe.probes.name) Specifies the name of the Probe. | <pre>string</pre> |
| number\_of\_probes | The number of failed probe attempts after which the backend endpoint is removed from rotation. | <pre>module.az_netlb.azurerm_lb_probe.probes.number_of_probes</pre> |
| port | Port on which the Probe queries the backend endpoint. | <pre>module.az_netlb.azurerm_lb_probe.probes.port</pre> |
| probe\_threshold | The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. | <pre>module.az_netlb.azurerm_lb_probe.probes.probe_threshold</pre> |
| protocol | Specifies the protocol of the end point. | <pre>module.az_netlb.azurerm_lb_probe.probes.protocol</pre> |
| request\_path | The URI used for requesting health status from the backend endpoint. | <pre>module.az_netlb.azurerm_lb_probe.probes.request_path</pre> |

#### <a name="output_lb_rules"></a> [lb\_rules](#output\_lb\_rules)

| Name | Description | Type |
|------|-------------|------|
| backend\_address\_pool\_ids | A list of reference to a Backend Address Pool over which this Load Balancing Rule operates. | <pre>module.az_netlb.azurerm_lb_rule.rules.backend_address_pool_ids</pre> |
| backend\_port | The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive. | <pre>module.az_netlb.azurerm_lb_rule.rules.backend_port</pre> |
| frontend\_ip\_configuration\_id | The id of the frontend IP configuration to which the rule is associated. | <pre>module.az_netlb.azurerm_lb_rule.rules.frontend_ip_configuration_id</pre> |
| frontend\_ip\_configuration\_name | The name of the frontend IP configuration to which the rule is associated. | <pre>module.az_netlb.azurerm_lb_rule.rules.frontend_ip_configuration_name</pre> |
| frontend\_port | The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. | <pre>module.az_netlb.azurerm_lb_rule.rules.frontend_port</pre> |
| name | Specifies the name of the LB Rule. | <pre>module.az_netlb.azurerm_lb_rule.rules.name</pre> |

#### <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer)

| Name | Description | Type |
|------|-------------|------|
| frontend\_ip\_configuration | A frontend\_ip\_configuration block as documented below. | <pre>module.az_netlb.azurerm_lb.load_balancer.frontend_ip_configuration</pre> |
| id | The Load Balancer ID. | <pre>module.az_netlb.azurerm_lb.load_balancer.id</pre> |
| name | Name of Load Balancer resource. | <pre>module.az_netlb.azurerm_lb.load_balancer.name</pre> |
| private\_ip\_address | The first private IP address assigned to the load balancer in frontend\_ip\_configuration blocks, if any. | <pre>module.az_netlb.azurerm_lb.load_balancer.private_ip_address</pre> |
| private\_ip\_addresses | The list of private IP address assigned to the load balancer in frontend\_ip\_configuration blocks, if any. | <pre>module.az_netlb.azurerm_lb.load_balancer.private_ip_addresses</pre> |

## Known Issues

|Error|Description|Workaround|
|--|:-|--|
| Two Pool Gateway Lb Rule Should Have Two Pools Each With Single Tunnel Interface| BackendAddressPool of a two-pool loadBalancingRule on a gateway load balancer should have 1 tunnelInterfaces per pool (Internal and External) or 2 tunnelInterfaces (1 Internal and 1 External).| BackendAddressPool of a two-pool loadBalancingRule on a gateway load balancer should have 1 tunnelInterfaces per pool.|
| Idempotency error on test | Inside load balancer frontend_ip_configutation there is a parameter named "zones". If zones is declared as null or [], after first apply the output value is null but if a plan is done after that, the provider tries to turn null -> []. | Not check idempotency for these test, testCase.SetupEnv(t, nil, false). |
| Idempotency error on test | Inside load balancer frontend_ip_configutation, these output parameters "inbound_nat_rules" and "load_balancer_rules" are empty in the first apply but on the second ones returns values.  | Not check idempotency for these test, testCase.SetupEnv(t, nil, false). |
| Idempotency error on test | On module.az_netlb.azurerm_lb_backend_address_pool resource these output parameters "backend_ip_configurations", "inbound_nat_rules" and "load_balancer_rules" are empty in the first apply but on the second ones returns values. | Not check idempotency for these test, testCase.SetupEnv(t, nil, false). |
| Idempotency error on test | On module.az_netlb.azurerm_lb_nat_rule resource this output parameter "backend_ip_configuration_id" is empty in the first apply but on the second ones returns values. | Not check idempotency for these test, testCase.SetupEnv(t, nil, false). |
