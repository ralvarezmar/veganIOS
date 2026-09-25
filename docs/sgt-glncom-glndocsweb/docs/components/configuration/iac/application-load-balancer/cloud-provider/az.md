# Azure Application Gateway

The resource should be defined as a map of maps with one key per resource. See the following [Azure Input example](#AZInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

* Azure key Vault to store the certificates to use for the TLS listener. If you're using an Azure Key Vault with Network Access Control List enabled, please check the following
[documentation](https://learn.microsoft.com/en-us/azure/application-gateway/key-vault-certs) in order to know the required configuration needed for the Application Gateway to work.
* A PFX certificate to be used with the HTTPS endpoints.
* A minimum **dedicated** subnet size of /24 is recommended. Application Gateway (Standard_v2 or WAF_v2 SKU) can support up to 125 instances (125 instance IP addresses + 1 private front-end IP + 5 Azure reserved).
* Azure Public Ip resource to assign to the front end ip configuration.
* A Virtual Network and a dedicated Subnet to assign to Application Gateway.
* Azure log analytics workspace for Diagnostic settings.
* Azure Storage Account for Diagnostic settings. (Optional)
* Azure Eventhub for Diagnostic settings. (Optional)

<a name="AZInputExample"></a>

## Input example

```hcl
az_applb = {
  "01_default" = {
    # General settings
    name           = "glnd1weuagwglobaltest001"
    resource_group = "glnd1weursgglobaltest000"
    location       = "westeurope"
    sku_tier       = "Standard"
    subnet_id      = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest000/subnets/glnd1weusntglobaltest000"
    lwk_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest000"
    akv_id         = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest000"

    public_ip_address_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Network/publicIPAddresses/acceptanceTestPublicIp1"
    private_ip_configuration = {
      private_ip_address              = "10.5.1.6"
      private_link_configuration_name = "link1"
    }

    frontend_port = {
      port1 = {
        name = "frontend_port_https_8081"
        port = 8081
      },
      port2 = {
        name = "frontend_port_https_443"
        port = 443
      }
    }

    http_listener = { # required.
      listener1 = {
        name                 = "listener_https_py_8081"
        frontend_port_name   = "port1" # It must have the same name as one of those configured in the  frontend_port block
        ssl_certificate_name = "certificate1"
      },
      listener2 = {
        name                 = "listener_https_443"
        frontend_port_name   = "port2"
        ssl_certificate_name = "certificate1" # It must have the same name as one of those configured in the  ssl_certificate block
        ssl_profile_name     = "profile1"
        require_sni          = false # https://docs.microsoft.com/en-us/azure/application-gateway/multiple-site-overview#host-headers-and-server-name-indication-sni
        custom_error_configuration = [
          {
            status_code           = "HttpStatus403"
            custom_error_page_url = "https://glnd1weustaglobaltest000.blob.core.windows.net/glnd1weustaglobaltest000-blob/error_403.html"
          }
        ]
      }
    }

    backend_address_pool = {
      pool1 = {
        name         = "bck_pool_01"
        ip_addresses = ["10.3.0.4", "10.3.0.5"]
      },
      pool2 = {
        name         = "bck_pool_02"
        ip_addresses = ["10.3.0.6"]
      },
    }

    backend_http_settings = {
      settings1 = {
        cookie_based_affinity               = "Disabled"
        affinity_cookie_name                = "ApplicationGatewayAffinity"
        name                                = "http_py_81"
        path                                = ""
        port                                = 81
        request_timeout                     = 60
        host_name                           = "Test_host_name"
        pick_host_name_from_backend_address = true
        connection_draining = {
          enabled           = false
          drain_timeout_sec = 3600
        }
      },
      settings3 = {
        cookie_based_affinity               = "Disabled"
        affinity_cookie_name                = "ApplicationGatewayAffinity"
        name                                = "https_py_443"
        path                                = ""
        port                                = 443
        request_timeout                     = 60
        host_name                           = "Test_host_name"
        pick_host_name_from_backend_address = true
        trusted_root_certificate_names      = ["trusted_certificate1"]
        connection_draining = {
          enabled           = false
          drain_timeout_sec = 3600
        }
      }
    }
    request_routing_rule = { # required.
      routing_rule1 = {
        name                       = "routing_rule_http_py_8081-81"
        rule_type                  = "Basic" #  or "PathBasedRouting"
        http_listener_name         = "listener1"
        backend_address_pool_name  = "pool1"
        backend_http_settings_name = "settings1" # This argument must be the same as the one specified in var.backend_http_settings.name, because this request_routing_rule is bound to that backend http setting
        priority                   = 1
      },
      routing_rule3 = {
        name                       = "routing_rule_http_py_8443-443"
        rule_type                  = "Basic" #  or "PathBasedRouting"
        http_listener_name         = "listener2"
        backend_address_pool_name  = "pool2"
        backend_http_settings_name = "settings3"
        priority                   = 2
      }
    }

    ssl_profile = {
      profile1 = {
        name = "SSL_Test_Profile"
      }
    }

    ssl_policy = {
      policy1 = {
        policy_type = "Predefined" # "Custom"
        policy_name = "AppGwSslPolicy20170401S"
      }
    }

    ssl_certificate = {
      certificate1 = {
        name                = "generated-cert-pfx"
        key_vault_secret_id = "https://glnd1weuakvglobaltest000.vault.azure.net/secrets/generated-cert-pfx/0ee951c31c684bb496e794de4c301151"
      }
    }

    global = {
      request_buffering_enable   = true
      response_buffering_enabled = false
    }

    # Tagging
    tags = {
      product     = "Gluon AZ AGW"
      environment = "dev"
      project     = "Gluon"
    }
  }

  "02_complete" = {
    name                 = "glnd1weuagwglobaltest008"
    resource_group       = "glnd1weursgglobaltest000"
    location             = "westeurope"
    sku_tier             = "WAF"
    zones                = ["1"]
    subnet_id            = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest000/subnets/glnd1weusntglobaltest000"
    lwk_id               = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.OperationalInsights/workspaces/glnd1weulwkglobaltest000"
    public_ip_address_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Network/publicIPAddresses/acceptanceTestPublicIp1"
    akv_id               = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.KeyVault/vaults/glnd1weuakvglobaltest000"
    private_ip_configuration = {
      private_ip_address              = "10.5.1.6"
      private_link_configuration_name = "link1"
    }


    frontend_port = {
      port1 = {
        name = "frontend_port_http_8081_2"
        port = 8081
      },
      port2 = {
        name = "frontend_port_https_443_2"
        port = 443
      }
    }

    http_listener = { # required.
      listener1 = {
        name                 = "listener_https_py_8081"
        frontend_port_name   = "port1" # It must have the same name as one of those configured in the  frontend_port block
        ssl_certificate_name = "certificate1"
      },
      listener2 = {
        name                 = "listener_https_443"
        frontend_port_name   = "port2"
        ssl_certificate_name = "certificate1" # It must have the same name as one of those configured in the  ssl_certificate block
        ssl_profile_name     = "profile1"
        require_sni          = false # https://docs.microsoft.com/en-us/azure/application-gateway/multiple-site-overview#host-headers-and-server-name-indication-sni
        custom_error_configuration = [
          {
            status_code           = "HttpStatus403"
            custom_error_page_url = "https://glnd1weustaglobaltest000.blob.core.windows.net/glnd1weustaglobaltest000-blob/error_403.html"
          }
        ]
      }
    }

    backend_address_pool = {
      pool1 = {
        name         = "bck_pool_01_2"
        ip_addresses = ["10.3.0.4", "10.3.0.5"]
      },
      pool2 = {
        name         = "bck_pool_02_2"
        ip_addresses = ["10.3.0.6"]
      },
    }

    backend_http_settings = {
      settings1 = {
        cookie_based_affinity               = "Disabled"
        affinity_cookie_name                = "ApplicationGatewayAffinity"
        name                                = "https_py_81_2"
        path                                = ""
        port                                = 81
        probe_name                          = "probe2"
        protocol                            = "Http" # review
        request_timeout                     = 60
        host_name                           = "Test_host_name"
        pick_host_name_from_backend_address = true
        connection_draining = {
          enabled           = false
          drain_timeout_sec = 3600
        }
      },
      settings3 = {
        cookie_based_affinity               = "Disabled"
        affinity_cookie_name                = "ApplicationGatewayAffinity"
        name                                = "https_py_443_2"
        path                                = ""
        port                                = 443
        probe_name                          = "probe1"
        protocol                            = "Https"
        request_timeout                     = 60
        host_name                           = "Test_host_name"
        pick_host_name_from_backend_address = true
        trusted_root_certificate_names      = ["trusted_certificate1"]
        connection_draining = {
          enabled           = false
          drain_timeout_sec = 3600
        }
      }
    }
    request_routing_rule = { # required.
      routing_rule1 = {
        name                        = "routing_rule_http_py_8081-81_2"
        rule_type                   = "Basic" #  or "PathBasedRouting"
        http_listener_name          = "listener1"
        redirect_configuration_name = "redirect1"
        priority                    = 1
      },
      routing_rule3 = {
        name                       = "routing_rule_http_py_8443-443_2"
        rule_type                  = "Basic" #  or "PathBasedRouting"
        http_listener_name         = "listener2"
        backend_address_pool_name  = "pool2"
        backend_http_settings_name = "settings3"
        rewrite_rule_set_name      = "rewrite_rule1"
        priority                   = 2
      }
    }

    trusted_root_certificate = {
      trusted_certificate1 = {
        name                = "generated-cert-pfx"
        key_vault_secret_id = "https://glnd1weuakvglobaltest000.vault.azure.net/secrets/generated-cert-pfx/507ece94778440ada36a5a6eb488cf73"
      }
    }

    ssl_profile = {
      profile1 = {
        name = "SSL_Test_Profile_2"
      }
    }

    ssl_policy = {
      policy1 = {
        policy_type = "Predefined" # "Custom"
        policy_name = "AppGwSslPolicy20220101"
      }
    }

    ssl_certificate = {
      certificate1 = {
        name                = "generated-cert-pfx"
        key_vault_secret_id = "https://glnd1weuakvglobaltest000.vault.azure.net/secrets/generated-cert-pfx/507ece94778440ada36a5a6eb488cf73"
      }
    }

    global = {
      request_buffering_enable   = true
      response_buffering_enabled = false
    }

    redirect_configuration = {
      redirect1 = {
        name                 = "my_http_healthy_probe"
        redirect_type        = "Temporary"
        target_listener_name = "listener_https_443"
      }
    } # optional

    rewrite_rule_set = {
      rewrite_rule1 = {
        name = "rewrite_rule1"
        rewrite_rule = {
          rule1 = {
            name          = "test"
            rule_sequence = 100
            response_header_configuration = {
              header_name  = "Location"
              header_value = "(https?)://.*azurewebsites.net(.*)$"
            }
            condition = {
              ignore_case = true
              negate      = false
              pattern     = ".*path/(.*)"
              variable    = "var_uri_path"
            }
          }
        }
      }
      rewrite_rule2 = {
        name = "rewrite_rule2"
        rewrite_rule = {
          rule1 = {
            name          = "test"
            rule_sequence = 100
            response_header_configuration = {
              header_name  = "Location"
              header_value = "(https?)://.*azurewebsites.net(.*)$"
            }
            condition = {
              ignore_case = true
              negate      = false
              pattern     = ".*path/(.*)"
              variable    = "var_uri_path"
            }
          }
          rule2 = {
            name          = "test2"
            rule_sequence = 100
            response_header_configuration = {
              header_name  = "Location"
              header_value = "(https?)://.*azurewebsites.net(.*)$"
            }
            condition = {
              ignore_case = true
              negate      = false
              pattern     = ".*example/(.*)"
              variable    = "var_uri_path"
            }
          }
          rule3 = {
            name          = "test3"
            rule_sequence = 100
            request_header_configuration = {
              header_name  = "Request"
              header_value = "image/png"
            }
            condition = {
              ignore_case = true
              negate      = false
              pattern     = ".*test/(.*)"
              variable    = "var_uri_path"
            }
          }
          rule4 = {
            name          = "test4"
            rule_sequence = 100
            condition = {
              ignore_case = true
              negate      = false
              pattern     = ".*admin/(.*)"
              variable    = "var_uri_path"
            }
            url = {
              components = "path_only"
              path       = "/article.aspx"
              reroute    = true
              # components = "query_string_only"
              # query_string = "id={var_uri_path_1}&title={var_uri_path_2}"
              # reroute = false
            }
          }
        }
      }
    }

    probe = { # optional
      probe1 = {
        interval                                  = 30
        name                                      = "my_http_healthy_probe_2"
        protocol                                  = "Https"
        path                                      = "/healthy.html"
        timeout                                   = 5
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        backend_http_settings                     = "settings3"
        match = {
          body        = ""
          status_code = ["200-399"]
        }
      },
      probe2 = {
        interval                                  = 30
        name                                      = "my_http_healthy_probe02_2"
        protocol                                  = "Http"
        path                                      = "/healthy.html"
        timeout                                   = 5
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        backend_http_settings                     = "settings1"
        match = {
          body        = ""
          status_code = ["200-399"]
        }
      }
    }

    private_link_configuration = {
      link1 = {
        name = "test"
        ip_configuration = {
          name                          = "test"
          private_ip_address_allocation = "Dynamic"
          primary                       = false
          subnet_id                     = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest000/subnets/glnd1weusntglobaltest000"
        }
      }
    }

    waf_configuration = {
      enabled          = true
      firewall_mode    = "Detection"
      rule_set_type    = "OWASP"
      rule_set_version = "3.2"

      disabled_rule_group = {
        rule1 = {
          rule_group_name = "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
        }
      }
      exclusion = {
        exclusion1 = {
          match_variable          = "RequestHeaderNames"
          selector_match_operator = "StartsWith"
          selector                = "A"
        }
      }
    } # optional

    url_path_map = {
      url1 = {
        name                               = "url_path_map_ubuntu_website"
        default_backend_address_pool_name  = "pool2"
        default_backend_http_settings_name = "settings3"
        path_rule = [
          {
            name                       = "path_video"
            paths                      = ["/video/*"]
            backend_address_pool_name  = "pool2"
            backend_http_settings_name = "settings3"
          }
        ]
      }
    }

    sta_enabled                    = true
    storage_account_id             = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.Storage/storageAccounts/glnd1weustaglobaltest000"
    aeh_enabled                    = true
    eventhub_name                  = "glnd1weuaehglobaltest000"
    eventhub_authorization_rule_id = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest000/providers/Microsoft.EventHub/namespaces/glnd1weuaehglobaltest000-nmsp/authorizationRules/RootManageSharedAccessKey"

    # Tagging
    tags = {
      product     = "Gluon AZ AGW"
      environment = "dev"
      project     = "Gluon"
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| [backend_address_pool](#input_backend_address_pool) | A configuration block to define backend address pool information. At least one is required. Supported more than one. | <pre>any</pre> |
| [backend_http_settings](#input_backend_http_settings) | A configuration block to define backend HTTP settings information. | <pre>any</pre> |
| [frontend_port](#input_frontend_port) | A configuration block to define frontend\_port information. | <pre>map(object({<br>    name = string<br>    port = string<br>  }))</pre> |
| [http_listener](#input_http_listener) | A configuration block to define http\_listener information. | <pre>any</pre> |
| location | The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created. | <pre>string</pre> |
| lwk_id | Log Analytics Workspace id. | <pre>string</pre> |
| name | The name of the Application Gateway. Changing this forces a new resource to be created. | <pre>string</pre> |
| [private_ip_configuration](#input_private_ip_configuration) | A configuration block to define private frontend\_ip\_configuration information. | <pre>any</pre> |
| public_ip_address_id | The ID of a Public IP Address which the Application Gateway should use. The allocation method for the Public IP Address depends on the sku of this Application Gateway. Please refer to the [Azure documentation for public IP addresses](https://learn.microsoft.com/en-gb/azure/virtual-network/ip-services/public-ip-addresses#application-gateways) for details. | <pre>string</pre> |
| [request_routing_rule](#input_request_routing_rule) | A list of maps to define request\_routing\_rule information. | <pre>any</pre> |
| resource_group | The name of the resource group in which to the Application Gateway should exist. Changing this forces a new resource to be created. | <pre>string</pre> |
| subnet_id | The ID of the Subnet which the Application Gateway should be connected to. | <pre>string</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aeh_enabled | Boolean value that indicates whether or not to use an Event Hub to stream the logs. | <pre>string</pre> | false |
| agw_create_timeout | How long to wait for the Application Gateway to be created. | <pre>string</pre> | "60m" |
| agw_update_timeout | How long to wait for the Application Gateway to be updated. | <pre>string</pre> | "60m" |
| akv_id | ID of the Azure Key Vault used. | <pre>string</pre> | null |
| analytics_diagnostic_monitor_name | Specifies the monitor diagnostic name. | <pre>string</pre> | "" |
| [autoscale_config](#input_autoscale_config) | The min and max capacity for autoscaling (min value 0=>100 and max value 2=>125). | <pre>any</pre> | {} |
| [custom_error_configuration](#input_custom_error_configuration) | A list of maps to define custom\_error\_configuration information. | <pre>any</pre> | {} |
| enable_http2 | Is HTTP2 enabled on the application gateway resource?. | <pre>bool</pre> | false |
| eventhub_authorization_rule_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. :warning: At least one of 'eventhub\_authorization\_rule\_id', 'lwk\_id' and 'storage\_account\_id' must be specified. | <pre>string</pre> | null |
| eventhub_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. If this isn't specified then the default Event Hub will be used. | <pre>string</pre> | null |
| fips_enabled | Is FIPS enabled on the Application Gateway?. | <pre>bool</pre> | false |
| firewall_policy_id | The ID of the Web Application Firewall Policy. | <pre>string</pre> | null |
| force_firewall_policy_association | Is the Firewall Policy associated with the Application Gateway?. | <pre>bool</pre> | false |
| [global](#input_global) | A configuration block to define global information. | <pre>any</pre> | {} |
| log_analytics_destination_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | <pre>string</pre> | "AzureDiagnostics" |
| logs | Specifies the log types that are going to be saved. If a specific log is not longer needed, you could remove the log type from the list. These are all the available logs types ["ApplicationGatewayAccessLog", "ApplicationGatewayPerformanceLog", "ApplicationGatewayFirewallLog"]. | <pre>any</pre> | [<br>  "ApplicationGatewayAccessLog",<br>  "ApplicationGatewayPerformanceLog",<br>  "ApplicationGatewayFirewallLog"<br>] |
| metrics | Specifies the metric types that are going to be saved. These are all the available metrics types ["AllMetrics"]. | <pre>any</pre> | [<br>  "AllMetrics"<br>] |
| [private_link_configuration](#input_private_link_configuration) | One or more private\_link\_configuration block. :warning: The AllowApplicationGatewayPrivateLink feature must be registered on the subscription before enabling private link. | <pre>any</pre> | {} |
| [probe](#input_probe) | A list of maps to define probe information. | <pre>any</pre> | {} |
| [redirect_configuration](#input_redirect_configuration) | A configuration block to define redirect\_configuration information. | <pre>any</pre> | {} |
| [rewrite_rule_set](#input_rewrite_rule_set) | A configuration block to define rewrite\_rule\_set information. | <pre>any</pre> | {} |
| sku_capacity | The Capacity of the SKU to use for this Application Gateway. This value must be between 1 to 125 for a V2 SKU. This property is optional if autoscale\_configuration is set. | <pre>number</pre> | 2 |
| sku_tier | The Tier of the SKU to use for this Application Gateway. Only supported v2 tiers. Possible values to introduce are: 'waf' and 'standard'. Internally 'waf' and 'standard' will be transformed to v2. | <pre>string</pre> | "Standard" |
| [ssl_certificate](#input_ssl_certificate) | A configuration block to define ssl\_certificate information. | <pre>any</pre> | {} |
| [ssl_policy](#input_ssl_policy) | A collection of ssl\_policy to use. | <pre>any</pre> | {} |
| [ssl_profile](#input_ssl_profile) | A collection of ssl\_profile to use. | <pre>any</pre> | {} |
| sta_enabled | Boolean value that indicates whether or not to use a storage account to store the logs. | <pre>string</pre> | false |
| storage_account_id | The ID of the Storage Account where logs should be sent. :warning: At least one of 'eventhub\_authorization\_rule\_id', 'lwk\_id' and 'storage\_account\_id' must be specified. | <pre>string</pre> | null |
| tags | A mapping of tags to assign to the resource. | <pre>any</pre> | {} |
| [trusted_client_certificate](#input_trusted_client_certificate) | One or more trusted\_client\_certificate configuration blocks. | <pre>any</pre> | {} |
| [trusted_root_certificate](#input_trusted_root_certificate) | A collection to define trusted\_root\_certificate information. At least data or key\_vault should be provided. If key\_vault is not, data has to. | <pre>any</pre> | {} |
| uai_name | Specifies the name of the User Assigned Identity to be created. If not provided, the pre-defined name will be '<var.name>-uai'. | <pre>string</pre> | null |
| uai_tags | A mapping of tags to assign to the User Assign Identity. This is a merged structure between 'var.tags' and 'var.uai\_tags'. | <pre>any</pre> | {} |
| [url_path_map](#input_url_path_map) | A list of maps to define url\_path\_map information. | <pre>any</pre> | {} |
| [waf_configuration](#input_waf_configuration) | A list of maps to define waf\_configuration information. | <pre>any</pre> | {} |
| zones | Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created. :warning: Availability Zones are not supported in all regions at this time, please check the [official documentation](https://learn.microsoft.com/en-gb/azure/reliability/availability-zones-overview?tabs=azure-cli) for more information. They are also only supported for [v2 SKUs](https://learn.microsoft.com/en-gb/azure/application-gateway/application-gateway-autoscaling-zone-redundant). | <pre>any</pre> | [] |

## Block Parameters

### <a name="input_backend_address_pool"></a> [backend\_address\_pool](#input\_backend\_address\_pool)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| fqdns | (Optional) A list of FQDN's which should be part of the Backend Address Pool. | <pre>list</pre> |
| ip_addresses | (Optional) A list of IP Addresses which should be part of the Backend Address Pool. | <pre>list</pre> |
| name | (Required) The name of the Backend Address Pool. | <pre>string</pre> |

### <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| affinity_cookie_name | (Optional) The name of the affinity cookie. | <pre>string</pre> |
| connection_draining | (Optional) A connection\_draining configuration block. | <pre>map</pre> |
| connection_draining<br/>.drain_timeout_sec | (Required) The number of seconds connection draining is active. Acceptable values are from 1 second to 3600 seconds. | <pre>number</pre> |
| connection_draining<br/>.enabled | (Required) If connection draining is enabled or not. | <pre>bool</pre> |
| cookie_based_affinity | (Required) Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled. | <pre>string</pre> |
| host_name | (Optional) Host header to be sent to the backend servers. Cannot be set if pick\_host\_name\_from\_backend\_address is set to true. | <pre>string</pre> |
| name | (Required) The name of the Backend HTTP Settings Collection. | <pre>string</pre> |
| path | (Optional) The Path which should be used as a prefix for all HTTP requests. | <pre>string</pre> |
| pick_host_name_from_backend_address | (Optional) Whether host header should be picked from the host name of the backend server. Defaults to false. | <pre>bool</pre> |
| port | (Required) The port which should be used for this Backend HTTP Settings Collection. | <pre>number</pre> |
| probe_name | (Optional) The name of the HTTP Probe that is wanted to associate with this setting. | <pre>string</pre> |
| request_timeout | (Required) The request timeout in seconds, which must be between 1 and 86400 seconds. Defaults to 30. | <pre>number</pre> |
| trusted_root_certificate_names | (Optional) A list of trusted\_root\_certificate key names. | <pre>list</pre> |

### <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port)

```hcl
map(object({
    name = string
    port = string
  }))
```

| Name | Description | Type |
|------|-------------|------|
| name | (Required) The name of the Frontend Port. | <pre>string</pre> |
| port | (Required) The port used for this Frontend Port. | <pre>number</pre> |

### <a name="input_http_listener"></a> [http\_listener](#input\_http\_listener)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| custom_error_configuration | (Optional) One or more custom\_error\_configuration blocks. | <pre>list(map)</pre> |
| firewall_policy_id | (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTPS Listener. | <pre>string</pre> |
| frontend_port_name | (Required) The key Name of the Frontend Port use for this HTTPS Listener. | <pre>string</pre> |
| host_name | (Optional) The Hostname which should be used for this HTTPS Listener. Setting this value changes Listener Type to 'Multi site'. :warning: The 'host\_names' and 'host\_name' are mutually exclusive and cannot both be set. | <pre>string</pre> |
| host_names | (Optional) A list of Hostname(s) should be used for this HTTPS Listener. It allows special wildcard characters. :warning: The 'host\_names' and 'host\_name' are mutually exclusive and cannot both be set. | <pre>list</pre> |
| name | (Required) The Name of the HTTPS Listener. | <pre>string</pre> |
| require_sni | (Optional) Should Server Name Indication be Required? Defaults to false. | <pre>bool</pre> |
| ssl_certificate_name | (Required) The key name of the associated SSL Certificate which should be used for this HTTPS Listener. | <pre>string</pre> |
| ssl_profile_name | (Optional) The key name of the associated SSL Profile which should be used for this HTTPS Listener. | <pre>string</pre> |

### <a name="input_private_ip_configuration"></a> [private\_ip\_configuration](#input\_private\_ip\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| private_ip_address | (Required) The Private IP Address to use for the Application Gateway. | <pre>string</pre> |
| private_link_configuration_name | (Optional) The key name of the private link configuration to use for this frontend IP configuration. | <pre>string</pre> |

### <a name="input_request_routing_rule"></a> [request\_routing\_rule](#input\_request\_routing\_rule)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| backend_address_pool_name | (Optional) The key Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if redirect\_configuration\_name is set. | <pre>string</pre> |
| backend_http_settings_name | (Optional) The key Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if redirect\_configuration\_name is set. | <pre>string</pre> |
| http_listener_name | (Required) The key Name of the HTTPS Listener which should be used for this Routing Rule. | <pre>string</pre> |
| name | (Required) The Name of this Request Routing Rule. | <pre>string</pre> |
| priority | (Required) Rule evaluation order can be dictated by specifying an integer value from 1 to 20000 with 1 being the highest priority and 20000 being the lowest priority. | <pre>number</pre> |
| redirect_configuration_name | (Optional) The key Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either backend\_address\_pool\_name or backend\_http\_settings\_name is set. | <pre>string</pre> |
| rewrite_rule_set_name | (Optional) The key Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs. Only when rule\_type is Basic. | <pre>string</pre> |
| rule_type | (Required) The Type of Routing that should be used for this Rule. Possible values are Basic and PathBasedRouting. | <pre>string</pre> |
| url_path_map_name | (Optional) The key Name of the URL Path Map which should be associated with this Routing Rule. Only when rule\_type is PathBasedRouting. | <pre>string</pre> |

### <a name="input_autoscale_config"></a> [autoscale\_config](#input\_autoscale\_config)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| max_capacity | (Optional) Maximum capacity for autoscaling. Accepted values are in the range 2 to 125. | <pre>number</pre> |
| min_capacity | (Required) Minimum capacity for autoscaling. Accepted values are in the range 0 to 100. | <pre>number</pre> |

### <a name="input_custom_error_configuration"></a> [custom\_error\_configuration](#input\_custom\_error\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| custom_error_page_url | (Required) Error page URL of the application gateway customer error. | <pre>string</pre> |
| status_code | (Required) Status code of the application gateway customer error. Possible values are HTTPStatus403 and HTTPStatus502. | <pre>string</pre> |

### <a name="input_global"></a> [global](#input\_global)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| request_buffering_enabled | (Required) Whether Application Gateway's Request buffer is enabled. | <pre>bool</pre> |
| response_buffering_enabled | (Required) Whether Application Gateway's Response buffer is enabled. | <pre>bool</pre> |

### <a name="input_private_link_configuration"></a> [private\_link\_configuration](#input\_private\_link\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| ip_configuration | (Required) One or more ip\_configuration blocks. | <pre>map(string)</pre> |
| ip_configuration<br/>.name | (Required) The name of the IP configuration. | <pre>string</pre> |
| ip_configuration<br/>.primary | (Required) Is this the Primary IP Configuration? | <pre>string</pre> |
| ip_configuration<br/>.private_ip_address | (Optional) The Static IP Address which should be used. | <pre>string</pre> |
| ip_configuration<br/>.private_ip_address_allocation | (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. | <pre>string</pre> |
| ip_configuration<br/>.subnet_id | (Required) The ID of the subnet the private link configuration should connect to. | <pre>string</pre> |
| name | (Required) The name of the private link configuration. | <pre>string</pre> |

### <a name="input_probe"></a> [probe](#input\_probe)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| host | (Optional) The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as ‘127.0.0.1’, unless otherwise configured in custom probe. Cannot be set if pick\_host\_name\_from\_backend\_http\_settings is set to true. | <pre>string</pre> |
| interval | (Required) The Interval between two consecutive probes in seconds. Possible values range from 1 second to a maximum of 86,400 seconds. | <pre>number</pre> |
| match | (Optional) A match block. | <pre>map</pre> |
| match<br/>.body | (Optional) A snippet from the Response Body which must be present in the Response. | <pre>string</pre> |
| match<br/>.status_code | (Required) A list of allowed status codes for this Health Probe. | <pre>list</pre> |
| minimum_servers | (Optional) The minimum number of servers that are always marked as healthy. Defaults to 0. | <pre>number</pre> |
| name | (Required) The Name of the Probe. | <pre>string</pre> |
| path | (Required) The Path used for this Probe. | <pre>string</pre> |
| pick_host_name_from_backend_http_settings | (Optional) Whether the host header should be picked from the backend HTTPS settings. Defaults to false. | <pre>bool</pre> |
| port | (Optional) Custom port which will be used for probing the backend servers. The valid value ranges from 1 to 65535. In case not set, port from HTTP settings will be used. This property is valid for Standard\_v2 and WAF\_v2 only. | <pre>number</pre> |
| timeout | (Required) The Timeout used for this Probe, which indicates when a probe becomes unhealthy. Possible values range from 1 second to a maximum of 86,400 seconds. | <pre>number</pre> |
| unhealthy_threshold | (Required) The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy. Possible values are from 1 to 20. | <pre>number</pre> |

### <a name="input_redirect_configuration"></a> [redirect\_configuration](#input\_redirect\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| include_path | (Optional) Whether or not to include the path in the redirected Url. Defaults to false. | <pre>string</pre> |
| include_query_string | (Optional) Whether or not to include the query string in the redirected Url. Default to false. | <pre>string</pre> |
| name | (Required) Unique name of the redirect configuration block. | <pre>string</pre> |
| redirect_type | (Required) The type of redirect. Possible values are Permanent, Temporary, Found and SeeOther. | <pre>string</pre> |
| target_listener_name | (Optional) The name of the listener to redirect to. Cannot be set if target\_url is set. | <pre>string</pre> |
| target_url | (Optional) The Url to redirect the request to. Cannot be set if target\_listener\_name is set. | <pre>string</pre> |

### <a name="input_rewrite_rule_set"></a> [rewrite\_rule\_set](#input\_rewrite\_rule\_set)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| name | (Required) Unique name of the rewrite rule set block. | <pre>string</pre> |
| rewrite_rule | (Required) One or more rewrite\_rule configuration blocks. | <pre>map</pre> |
| rewrite_rule<br/>.condition | (Optional) One or more condition blocks. | <pre>map</pre> |
| rewrite_rule<br/>.condition<br/>.ignore_case | (Optional) Perform a case in-sensitive comparison. Defaults to false. | <pre>bool</pre> |
| rewrite_rule<br/>.condition<br/>.negate | (Optional) Negate the result of the condition evaluation. Defaults to false. | <pre>bool</pre> |
| rewrite_rule<br/>.condition<br/>.pattern | (Required) The pattern, either fixed string or regular expression, that evaluates the truthfulness of the condition. | <pre>string</pre> |
| rewrite_rule<br/>.condition<br/>.variable | (Required) The variable of the condition. | <pre>string</pre> |
| rewrite_rule<br/>.name | (Required) Unique name of the rewrite rule block. | <pre>string</pre> |
| rewrite_rule<br/>.request_header_configuration | (Optional) One or more request\_header\_configuration blocks. At least one of request\_header, response\_header or url should be provided. | <pre>map</pre> |
| rewrite_rule<br/>.request_header_configuration<br/>.header_name | (Required) Header name of the header configuration. | <pre>string</pre> |
| rewrite_rule<br/>.request_header_configuration<br/>.header_value | (Required) Header value of the header configuration. To delete a response header set this property to an empty string. | <pre>string</pre> |
| rewrite_rule<br/>.response_header_configuration | (Optional) One or more response\_header\_configuration blocks. At least one of request\_header, response\_header or url should be provided. | <pre>map</pre> |
| rewrite_rule<br/>.response_header_configuration<br/>.header_name | (Required) Header name of the header configuration. | <pre>string</pre> |
| rewrite_rule<br/>.response_header_configuration<br/>.header_value | (Required) Header value of the header configuration. To delete a response header set this property to an empty string. | <pre>string</pre> |
| rewrite_rule<br/>.rule_sequence | (Required) Rule sequence of the rewrite rule that determines the order of execution in a set. | <pre>number</pre> |
| rewrite_rule<br/>.url | (Optional) One url block. At least one of request\_header, response\_header or url should be provided. | <pre>map</pre> |
| rewrite_rule<br/>.url<br/>.components | (Required) The components used to rewrite the URL. Possible values are path\_only and query\_string\_only to limit the rewrite to the URL Path or URL Query String only. | <pre>string</pre> |
| rewrite_rule<br/>.url<br/>.path | (Optional) The URL path to rewrite. One or both of path and query\_string must be specified. If one of these is not specified, it means the value will be empty. If you only want to rewrite path or query\_string, use components. | <pre>string</pre> |
| rewrite_rule<br/>.url<br/>.query_string | (Optional) The query string to rewrite. One or both of path and query\_string must be specified. If one of these is not specified, it means the value will be empty. If you only want to rewrite path or query\_string, use components. | <pre>string</pre> |
| rewrite_rule<br/>.url<br/>.reroute | (Optional) Whether the URL path map should be reevaluated after this rewrite has been applied. | <pre>string</pre> |

### <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| data | (Optional) The base64-encoded PFX certificate data. Required if 'key\_vault\_secret\_id' is not set. When specifying a file, use data = filebase64("path/to/file") to encode the contents of that file. | <pre>string</pre> |
| key_vault_secret_id | (Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set. | <pre>string</pre> |
| name | (Required) The Name of the SSL certificate that is unique within this Application Gateway. | <pre>string</pre> |
| password | (Optional) Password for the pfx file specified in data. Required if data is set. | <pre>string</pre> |

### <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| cipher_suites | (Optional) A List of accepted cipher suites. Can only be set when 'policy\_type' is Custom. Possible values are: TLS\_DHE\_DSS\_WITH\_AES\_128\_CBC\_SHA, TLS\_DHE\_DSS\_WITH\_AES\_128\_CBC\_SHA256, TLS\_DHE\_DSS\_WITH\_AES\_256\_CBC\_SHA, TLS\_DHE\_DSS\_WITH\_AES\_256\_CBC\_SHA256, TLS\_DHE\_RSA\_WITH\_AES\_128\_CBC\_SHA, TLS\_DHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_DHE\_RSA\_WITH\_AES\_256\_CBC\_SHA, TLS\_DHE\_RSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_ECDHE\_ECDSA\_WITH\_AES\_128\_CBC\_SHA, TLS\_ECDHE\_ECDSA\_WITH\_AES\_128\_CBC\_SHA256, TLS\_ECDHE\_ECDSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_ECDHE\_ECDSA\_WITH\_AES\_256\_CBC\_SHA, TLS\_ECDHE\_ECDSA\_WITH\_AES\_256\_CBC\_SHA384, TLS\_ECDHE\_ECDSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_ECDHE\_RSA\_WITH\_AES\_128\_CBC\_SHA, TLS\_ECDHE\_RSA\_WITH\_AES\_128\_CBC\_SHA256, TLS\_ECDHE\_RSA\_WITH\_AES\_256\_CBC\_SHA, TLS\_ECDHE\_RSA\_WITH\_AES\_256\_CBC\_SHA384, TLS\_RSA\_WITH\_3DES\_EDE\_CBC\_SHA, TLS\_RSA\_WITH\_AES\_128\_CBC\_SHA, TLS\_RSA\_WITH\_AES\_128\_CBC\_SHA256, TLS\_RSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_RSA\_WITH\_AES\_256\_CBC\_SHA, TLS\_RSA\_WITH\_AES\_256\_CBC\_SHA256, TLS\_RSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_AES\_128\_GCM\_SHA256 and TLS\_AES\_256\_GCM\_SHA384. | <pre>list</pre> |
| disabled_protocols | (Optional) A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are TLSv1\_0, TLSv1\_1, TLSv1\_2 and TLSv1\_3. :warning: 'disabled\_protocols' cannot be set when 'policy\_name' or 'policy\_type' are set. | <pre>list</pre> |
| min_protocol_version | (Optional) The minimal TLS version. Possible values are TLSv1\_0, TLSv1\_1 TLSv1\_2 and TLSv1\_3. | <pre>string</pre> |
| policy_name | (Optional) The Name of the Policy e.g AppGwSslPolicy20170401S. Required if policy\_type is set to Predefined. Possible values can change over time and are published here <HTTPS://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview>. Not compatible with disabled\_protocols. | <pre>string</pre> |
| policy_type | (Optional) The Type of the Policy. Possible values are Predefined, Custom and CustomV2. :warning: 'policy\_type' is Required when 'policy\_name' is set - cannot be set if disabled\_protocols is set. | <pre>string</pre> |

### <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| name | (Required) The name of the SSL Profile that is unique within this Application Gateway. | <pre>string</pre> |
| trusted_client_certificate_names | (Optional) The name of the Trusted Client Certificate that will be used to authenticate requests from clients. | <pre>string</pre> |
| verify_client_cert_issuer_dn | (Optional) Should client certificate issuer DN be verified? Defaults to false. | <pre>string</pre> |

### <a name="input_trusted_client_certificate"></a> [trusted\_client\_certificate](#input\_trusted\_client\_certificate)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| data | (Required) The base-64 encoded certificate. | <pre>string</pre> |
| name | (Required) The name of the Trusted Client Certificate that is unique within this Application Gateway. | <pre>string</pre> |

### <a name="input_trusted_root_certificate"></a> [trusted\_root\_certificate](#input\_trusted\_root\_certificate)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| data | (Optional) The contents of the Trusted Root Certificate which should be used. Required if key\_vault\_secret\_id is not set. | <pre>string</pre> |
| key_vault_secret_id | (Optional) The Secret ID of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if data is not set. | <pre>string</pre> |
| name | (Required) The Name of the Trusted Root Certificate to use. | <pre>string</pre> |

### <a name="input_url_path_map"></a> [url\_path\_map](#input\_url\_path\_map)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| default_backend_address_pool_name | (Optional) The Name of the Default Backend Address Pool which should be used for this URL Path Map. Cannot be set if default\_redirect\_configuration\_name is set. | <pre>string</pre> |
| default_backend_http_settings_name | (Optional) The Name of the Default Backend HTTP Settings Collection which should be used for this URL Path Map. Cannot be set if default\_redirect\_configuration\_name is set. | <pre>string</pre> |
| default_redirect_configuration_name | (Optional) The Name of the Default Redirect Configuration which should be used for this URL Path Map. Cannot be set if either default\_backend\_address\_pool\_name or default\_backend\_http\_settings\_name is set. | <pre>string</pre> |
| default_rewrite_rule_set_name | (Optional) The Name of the Default Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs. | <pre>string</pre> |
| name | (Required) The Name of the URL Path Map. | <pre>string</pre> |
| path_rule | (Required) One or more path\_rule blocks. | <pre>map</pre> |
| path_rule<br/>.backend_address_pool_name | (Optional) The Name of the Backend Address Pool to use for this Path Rule. Cannot be set if redirect\_configuration\_name is set. | <pre>string</pre> |
| path_rule<br/>.backend_http_settings_name | (Optional) The Name of the Backend HTTP Settings Collection to use for this Path Rule. Cannot be set if redirect\_configuration\_name is set. | <pre>string</pre> |
| path_rule<br/>.firewall_policy_id | (Optional) The ID of the Web Application Firewall Policy which should be used as an HTTP Listener. | <pre>string</pre> |
| path_rule<br/>.name | (Required) The Name of the Path Rule. | <pre>string</pre> |
| path_rule<br/>.paths | (Required) A list of Paths used in this Path Rule. | <pre>list</pre> |
| path_rule<br/>.redirect_configuration_name | (Optional) The Name of a Redirect Configuration to use for this Path Rule. Cannot be set if backend\_address\_pool\_name or backend\_http\_settings\_name is set. | <pre>string</pre> |
| path_rule<br/>.rewrite_rule_set_name | (Optional) The Name of the Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs. | <pre>string</pre> |

### <a name="input_waf_configuration"></a> [waf\_configuration](#input\_waf\_configuration)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| disabled_rule_group | (Optional) one or more disabled\_rule\_group blocks. | <pre>map</pre> |
| disabled_rule_group<br/>.rule_group_name | (Required) The rule group where specific rules should be disabled. Possible values are BadBots, crs\_20\_protocol\_violations, crs\_21\_protocol\_anomalies, crs\_23\_request\_limits, crs\_30\_http\_policy, crs\_35\_bad\_robots, crs\_40\_generic\_attacks, crs\_41\_sql\_injection\_attacks, crs\_41\_xss\_attacks, crs\_42\_tight\_security, crs\_45\_trojans, crs\_49\_inbound\_blocking, General, GoodBots, KnownBadBots, Known-CVEs, REQUEST-911-METHOD-ENFORCEMENT, REQUEST-913-SCANNER-DETECTION, REQUEST-920-PROTOCOL-ENFORCEMENT, REQUEST-921-PROTOCOL-ATTACK, REQUEST-930-APPLICATION-ATTACK-LFI, REQUEST-931-APPLICATION-ATTACK-RFI, REQUEST-932-APPLICATION-ATTACK-RCE, REQUEST-933-APPLICATION-ATTACK-PHP, REQUEST-941-APPLICATION-ATTACK-XSS, REQUEST-942-APPLICATION-ATTACK-SQLI, REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION, REQUEST-944-APPLICATION-ATTACK-JAVA, UnknownBots, METHOD-ENFORCEMENT, PROTOCOL-ENFORCEMENT, PROTOCOL-ATTACK, LFI, RFI, RCE, PHP, NODEJS, XSS, SQLI, FIX, JAVA, MS-ThreatIntel-WebShells, MS-ThreatIntel-AppSec, MS-ThreatIntel-SQLI and MS-ThreatIntel-CVEs. | <pre>string</pre> |
| disabled_rule_group<br/>.rules | (Optional) A list of rules which should be disabled in that group. Disables all rules in the specified group if rules is not specified. | <pre>list</pre> |
| enabled | (Required) Is the Web Application Firewall be enabled?. | <pre>bool</pre> |
| exclusion | (Optional) one or more exclusion configuration blocks. | <pre>map</pre> |
| exclusion<br/>.match_variable | (Required) Match variable of the exclusion rule to exclude header, cookie or GET arguments. Possible values are RequestArgKeys, RequestArgNames, RequestArgValues, RequestCookieKeys, RequestCookieNames, RequestCookieValues, RequestHeaderKeys, RequestHeaderNames and RequestHeaderValues. | <pre>string</pre> |
| exclusion<br/>.selector | (Optional) String value which will be used for the filter operation. If empty will exclude all traffic on this match\_variable. | <pre>string</pre> |
| exclusion<br/>.selector_match_operator | (Optional) Operator which will be used to search in the variable content. Possible values are Contains, EndsWith, Equals, EqualsAny and StartsWith. If empty will exclude all traffic on this match\_variable. | <pre>string</pre> |
| file_upload_limit_mb | (Optional) The File Upload Limit in MB. Accepted values are in the range 1MB to 750MB for the WAF\_v2 SKU. Defaults to 100MB. | <pre>string</pre> |
| firewall_mode | (Required) The Web Application Firewall Mode. Possible values are Detection and Prevention. | <pre>string</pre> |
| max_request_body_size_kb | (Optional) The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB. | <pre>number</pre> |
| request_body_check | (Optional) Is Request Body Inspection enabled? Defaults to true. | <pre>bool</pre> |
| rule_set_type | (Optional) The Type of the Rule Set used for this Web Application Firewall. Possible values are OWASP, Microsoft\_BotManagerRuleSet and Microsoft\_DefaultRuleSet. Defaults to OWASP. | <pre>string</pre> |
| rule_set_version | (Required) The Version of the Rule Set used for this Web Application Firewall. Possible values are 0.1, 1.0, 2.1, 2.2.9, 3.0, 3.1 and 3.2. | <pre>string</pre> |

## Output example

```hcl
az_applb = {
  "01_default" = {
    "autoscale_configuration" = [
      {
        "max_capacity" = 2
        "min_capacity" = 0
      },
    ]
    "backend_address_pool" = [
      {
        "fqdns" = []
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendAddressPools/bck_pool_01"
        "ip_addresses" = [
          "10.3.0.4",
          "10.3.0.5",
        ]
        "name" = "bck_pool_01"
      },
      {
        "fqdns" = []
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendAddressPools/bck_pool_02"
        "ip_addresses" = [
          "10.3.0.6",
        ]
        "name" = "bck_pool_02"
      },
    ]
    "backend_http_settings" = [
      {
        "affinity_cookie_name" = ""
        "authentication_certificate" = []
        "connection_draining" = [
          {
            "drain_timeout_sec" = 3600
            "enabled" = false
          },
        ]
        "cookie_based_affinity" = "Disabled"
        "host_name" = ""
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendHttpSettingsCollection/https_py_443"
        "name" = "https_py_443"
        "path" = ""
        "pick_host_name_from_backend_address" = true
        "port" = 443
        "probe_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/probes/my_http_healthy_probe"
        "probe_name" = "my_http_healthy_probe"
        "protocol" = "Https"
        "request_timeout" = 60
        "trusted_root_certificate_names" = [
          "generated-cert-pfx",
        ]
      },
      {
        "affinity_cookie_name" = ""
        "authentication_certificate" = []
        "connection_draining" =[
          {
            "drain_timeout_sec" = 3600
            "enabled" = false
          },
        ]
        "cookie_based_affinity" = "Disabled"
        "host_name" = ""
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendHttpSettingsCollection/https_py_81"
        "name" = "https_py_81"
        "path" = ""
        "pick_host_name_from_backend_address" = true
        "port" = 81
        "probe_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/probes/my_http_healthy_probe02"
        "probe_name" = "my_http_healthy_probe02"
        "protocol" = "Http"
        "request_timeout" = 60
        "trusted_root_certificate_names" = []
      },
    ]
    "custom_error_configuration" = []
    "force_firewall_policy_association" = false
    "frontend_ip_config" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendIPConfigurations/Private"
        "name" = "Private"
        "private_ip_address" = "10.5.1.6"
        "private_ip_address_allocation" = "Static"
        "private_link_configuration_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/privateLinkConfigurations/test"
        "private_link_configuration_name" = "test"
        "public_ip_address_id" = ""
        "subnet_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001"
      },
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendIPConfigurations/Public"
        "name" = "Public"
        "private_ip_address" = ""
        "private_ip_address_allocation" = "Dynamic"
        "private_link_configuration_id" = ""
        "private_link_configuration_name" = ""
        "public_ip_address_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/publicIPAddresses/acceptanceTestPublicIp1"
        "subnet_id" = ""
      },
    ]
    "frontend_port" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendPorts/frontend_port_http_8081"
        "name" = "frontend_port_http_8081"
        "port" = 8081
      },
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendPorts/frontend_port_https_443"
        "name" = "frontend_port_https_443"
        "port" = 443
      },
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendPorts/frontend_port_https_8443"
        "name" = "frontend_port_https_8443"
        "port" = 8443
      },
    ]
    "gateway_ip_configuration" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/gatewayIPConfigurations/glnd1weuagwglobaltest001-ipconfig"
        "name" = "glnd1weuagwglobaltest001-ipconfig"
        "subnet_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001"
      },
    ]
    "http_listener" = [
      {
        "custom_error_configuration" =[
          {
            "custom_error_page_url" = "https://glnd1weustaglobaltest001.blob.core.windows.net/glnd1weustaglobaltest001-blob/error_403.html"
            "id" = ""
            "status_code" = "HttpStatus403"
          },
        ]
        "firewall_policy_id" = ""
        "frontend_ip_configuration_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendIPConfigurations/Public"
        "frontend_ip_configuration_name" = "Public"
        "frontend_port_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendPorts/frontend_port_https_443"
        "frontend_port_name" = "frontend_port_https_443"
        "host_name" = ""
        "host_names" = []
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/httpListeners/listener_https_443"
        "name" = "listener_https_443"
        "protocol" = "Https"
        "require_sni" = false
        "ssl_certificate_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/sslCertificates/generated-cert-pfx"
        "ssl_certificate_name" = "generated-cert-pfx"
        "ssl_profile_id" = ""
        "ssl_profile_name" = ""
      },
      {
        "custom_error_configuration" = []
        "firewall_policy_id" = ""
        "frontend_ip_configuration_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendIPConfigurations/Public"
        "frontend_ip_configuration_name" = "Public"
        "frontend_port_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/frontendPorts/frontend_port_http_8081"
        "frontend_port_name" = "frontend_port_http_8081"
        "host_name" = ""
        "host_names" =[]
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/httpListeners/listener_http_py_8081"
        "name" = "listener_http_py_8081"
        "protocol" = "Http"
        "require_sni" = false
        "ssl_certificate_id" = ""
        "ssl_certificate_name" = ""
        "ssl_profile_id" = ""
        "ssl_profile_name" = ""
      },
    ]
    "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001"
    "name" = "glnd1weuagwglobaltest001"
    "private_link_configuration" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/privateLinkConfigurations/test"
        "ip_configuration" = [
          {
            "name" = "test"
            "primary" = false
            "private_ip_address" = ""
            "private_ip_address_allocation" = "Dynamic"
            "subnet_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/virtualNetworks/glnd1weuvntglobaltest001/subnets/glnd1weusntglobaltest001"
          },
        ]
        "name" = "test"
      },
    ]
    "probe" = [
      {
        "host" = ""
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/probes/my_http_healthy_probe"
        "interval" = 30
        "match" = [
          {
            "body" = ""
            "status_code" = [
              "200-399",
            ]
          },
        ]
        "minimum_servers" = 0
        "name" = "my_http_healthy_probe"
        "path" = "/healthy.html"
        "pick_host_name_from_backend_http_settings" = true
        "port" = 443
        "protocol" = "Https"
        "timeout" = 5
        "unhealthy_threshold" = 3
      },
      {
        "host" = ""
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/probes/my_http_healthy_probe02"
        "interval" = 30
        "match" = [
          {
            "body" = ""
            "status_code" = [
              "200-399",
            ]
          },
        ]
        "minimum_servers" = 0
        "name" = "my_http_healthy_probe02"
        "path" = "/healthy.html"
        "pick_host_name_from_backend_http_settings" = true
        "port" = 81
        "protocol" = "Http"
        "timeout" = 5
        "unhealthy_threshold" = 3
      },
    ]
    "redirect_configuration" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/redirectConfigurations/my_http_healthy_probe"
        "include_path" = false
        "include_query_string" = false
        "name" = "my_http_healthy_probe"
        "redirect_type" = "Temporary"
        "target_listener_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/httpListeners/listener_https_443"
        "target_listener_name" = "listener_https_443"
        "target_url" = ""
      },
    ]
    "request_routing_rule" = [
      {
        "backend_address_pool_id" = ""
        "backend_address_pool_name" = ""
        "backend_http_settings_id" = ""
        "backend_http_settings_name" = ""
        "http_listener_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/httpListeners/listener_http_py_8081"
        "http_listener_name" = "listener_http_py_8081"
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/requestRoutingRules/routing_rule_http_py_8081-81"
        "name" = "routing_rule_http_py_8081-81"
        "priority" = 1
        "redirect_configuration_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/redirectConfigurations/my_http_healthy_probe"
        "redirect_configuration_name" = "my_http_healthy_probe"
        "rewrite_rule_set_id" = ""
        "rewrite_rule_set_name" = ""
        "rule_type" = "Basic"
        "url_path_map_id" = ""
        "url_path_map_name" = ""
      },
      {
        "backend_address_pool_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendAddressPools/bck_pool_02"
        "backend_address_pool_name" = "bck_pool_02"
        "backend_http_settings_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendHttpSettingsCollection/https_py_443"
        "backend_http_settings_name" = "https_py_443"
        "http_listener_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/httpListeners/listener_https_443"
        "http_listener_name" = "listener_https_443"
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/requestRoutingRules/routing_rule_http_py_8443-443"
        "name" = "routing_rule_http_py_8443-443"
        "priority" = 2
        "redirect_configuration_id" = ""
        "redirect_configuration_name" = ""
        "rewrite_rule_set_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/rewriteRuleSets/rewrite_rule1"
        "rewrite_rule_set_name" = "rewrite_rule1"
        "rule_type" = "Basic"
        "url_path_map_id" = ""
        "url_path_map_name" = ""
      },
    ]
    "rewrite_rule_set" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/rewriteRuleSets/rewrite_rule1"
        "name" = "rewrite_rule1"
        "rewrite_rule" = [
          {
            "condition" = []
            "name" = "test"
            "request_header_configuration" =[]
            "response_header_configuration" = [
              {
                "header_name" = "Location"
                "header_value" = "(https?)://.*azurewebsites.net(.*)$"
              },
            ]
            "rule_sequence" = 100
            "url" = []
          },
        ]
      },
    ]
    "sku" = [
      {
        "capacity" = 0
        "name" = "WAF_v2"
        "tier" = "WAF_v2"
      },
    ]
    "ssl_policy" = [
      {
        "cipher_suites" = null /* of string */
        "disabled_protocols" = null /* of string */
        "min_protocol_version" = ""
        "policy_name" = "AppGwSslPolicy20170401S"
        "policy_type" = "Predefined"
      },
    ]
    "ssl_profile" = [
      {
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/sslProfiles/SSL_Test_Profile"
        "name" = "SSL_Test_Profile"
        "ssl_policy" = [
          {
            "cipher_suites" = null /* of string */
            "disabled_protocols" = null /* of string */
            "min_protocol_version" = ""
            "policy_name" = "AppGwSslPolicy20170401S"
            "policy_type" = "Predefined"
          },
        ]
        "trusted_client_certificate_names" = null /*of string */
        "verify_client_cert_issuer_dn" = false
      },
    ]
    "trusted_client_certificate" = []
    "url_path_map" = [
      {
        "default_backend_address_pool_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendAddressPools/bck_pool_01"
        "default_backend_address_pool_name" = "bck_pool_01"
        "default_backend_http_settings_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendHttpSettingsCollection/https_py_81"
        "default_backend_http_settings_name" = "https_py_81"
        "default_redirect_configuration_id" = ""
        "default_redirect_configuration_name" = ""
        "default_rewrite_rule_set_id" = ""
        "default_rewrite_rule_set_name" = ""
        "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/urlPathMaps/url_path_map_ubuntu_website"
        "name" = "url_path_map_ubuntu_website"
        "path_rule" = [
          {
            "backend_address_pool_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendAddressPools/bck_pool_02"
            "backend_address_pool_name" = "bck_pool_02"
            "backend_http_settings_id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/backendHttpSettingsCollection/https_py_443"
            "backend_http_settings_name" = "https_py_443"
            "firewall_policy_id" = ""
            "id" = "/subscriptions/<az_subscription_id>/resourceGroups/glnd1weursgglobaltest001/providers/Microsoft.Network/applicationGateways/glnd1weuagwglobaltest001/urlPathMaps/url_path_map_ubuntu_website/pathRules/path_video"
            "name" = "path_video"
            "paths" = [
              "/video/*",
            ]
            "redirect_configuration_id" = ""
            "redirect_configuration_name" = ""
            "rewrite_rule_set_id" = ""
            "rewrite_rule_set_name" = ""
          },
        ]
      },
    ]
    "waf_configuration" = [
      {
        "disabled_rule_group" = [
          {
            "rule_group_name" = "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
            "rules" = []
          },
        ]
        "enabled" = true
        "exclusion" = [
          {
            "match_variable" = "RequestHeaderNames"
            "selector" = ""
            "selector_match_operator" = ""
          },
        ]
        "file_upload_limit_mb" = 100
        "firewall_mode" = "Detection"
        "max_request_body_size_kb" = 128
        "request_body_check" = true
        "rule_set_type" = "OWASP"
        "rule_set_version" = "3.2"
      },
    ]
    "zones" = null /* of string*/
  }
}
az_applb_sensitive = <sensitive>
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|az_applb|module.az_applb|AZ Application Load Balancer outputs map. <br>[Map AZ Application Load Balancer Outputs](#AZ Application-Load-Balancer Outputs). |
|az_applb_sensitive|module.az_applb|AZ Application Load Balancer Sensitive outputs map. <br>[Map AZ Application Load Balancer Sensitive Outputs](#AZ Application-Load-Balancer-sensitive Outputs). |

<a name="AZ Application-Load-Balancer Outputs"></a>

### AZ Application Load Balancer

| Name | Description | Type |
|------|-------------|------|
| autoscale\_configuration | An autoscale\_configuration block. | <pre>module.az_applb.autoscale_configuration</pre> |
| backend\_address\_pool | A list of backend\_address\_pool blocks. | <pre>module.az_applb.backend_address_pool</pre> |
| backend\_http\_settings | A list of backend\_http\_settings block. | <pre>module.az_applb.backend_http_settings</pre> |
| custom\_error\_configuration | A list of custom\_error\_configuration blocks. | <pre>module.az_applb.custom_error_configuration</pre> |
| force\_firewall\_policy\_association | Indicates whether the FW policy is associated with the ApplicationGateway. | <pre>module.az_applb.force_firewall_policy_association</pre> |
| frontend\_ip\_configuration | A list of frontend\_ip\_configuration blocks. | <pre>module.az_applb.frontend_ip_configuration</pre> |
| frontend\_port | A list of frontend\_port blocks. | <pre>module.az_applb.frontend_port</pre> |
| gateway\_ip\_configuration | A list of gateway\_ip\_configuration blocks. | <pre>module.az_applb.gateway_ip_configuration</pre> |
| global | A global block. | <pre>module.az_applb.global</pre> |
| http\_listener | A list of http\_listener blocks. | <pre>module.az_applb.http_listener</pre> |
| id | The ID of the Application Gateway. | <pre>module.az_applb.id</pre> |
| name | The name of the Application Gateway. | <pre>module.az_applb.name</pre> |
| private\_link\_configuration | A list of private\_link\_configuration blocks. | <pre>module.az_applb.private_link_configuration</pre> |
| probe | A probe block. | <pre>module.az_applb.probe</pre> |
| redirect\_configuration | A list of redirect\_configuration blocks. | <pre>module.az_applb.redirect_configuration</pre> |
| request\_routing\_rule | A list of request\_routing\_rule blocks. | <pre>module.az_applb.request_routing_rule</pre> |
| rewrite\_rule\_set | A list of rewrite\_rule\_set blocks. | <pre>module.az_applb.rewrite_rule_set</pre> |
| sku | A sku block. | <pre>module.az_applb.sku</pre> |
| ssl\_policy | A list of ssl\_policy blocks. | <pre>module.az_applb.ssl_policy</pre> |
| ssl\_profile | A list of ssl\_profile blocks. | <pre>module.az_applb.ssl_profile</pre> |
| trusted\_client\_certificate | A list of trusted\_client\_certificate blocks. | <pre>module.az_applb.trusted_client_certificate</pre> |
| url\_path\_map | A list of url\_path\_map blocks. | <pre>module.az_applb.url_path_map</pre> |
| waf\_configuration | A waf\_configuration block. | <pre>module.az_applb.waf_configuration</pre> |
| zones | Availability Zones in which this Application Gateway is located. | <pre>module.az_applb.zones</pre> |

<a name="AZ Application-Load-Balancer-sensitive Outputs"></a>

### AZ Application Load Balancer Sensitive Outputs

| Name | Description | Type |
|------|-------------|------|
| ssl\_certificate | A list of ssl\_certificate blocks. | <pre>module.az_applb.ssl_certificate</pre> |
| trusted\_root\_certificate | A list of trusted\_root\_certificate blocks. | <pre>module.az_applb.trusted_root_certificate</pre> |

## Known Issues

### At deployment time of this terraform module

|Error|Description|Workaround|
|--|:-|--|
