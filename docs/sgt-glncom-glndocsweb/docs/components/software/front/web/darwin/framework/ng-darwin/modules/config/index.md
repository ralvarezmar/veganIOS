# Config Module

The Security and Logger modules require a configuration, which the developer must provide for their correct operation. The Config module provides this configuration through a JSON format file that must be available in the different environments.

For more information about `Config` module follow this [documentation](https://automatic-doodle-rew2y31.pages.github.io/modules/_ng-darwin_config.html){:target="_blank"}.

## How the configuration file works

The main task of the configuration module is to obtain the `config.json` file. This file is obtained through an AJAX request made by the configuration module itself.

If the application is running on the PaaS, the configuration will be recovered thanks to [Nginx](https://www.nginx.com/) redirections.

Currently the file can be generated in two ways:

The following Nginx redirects are already included in the archetype generator.

- [Config Maps](config-maps.md)

``` TEXT
<% if !ENV["CONFIG_END_POINT"] %>
# to get config properties from ConfigMaps
location <%= ENV["relativePath"] %>/APP_NAME/config.json {
  alias /etc/san-configmap-darwin/config.json;
}
<% end %>  
```

- [Spring Cloud Config](spring-cloud-config.md)

``` TEXT
  <% if ENV["CONFIG_END_POINT"] %>
  # to get config properties
  location <%= ENV["relativePath"] %>/APP_NAME/config.json {
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    include conf.d/proxy-cache.conf;
    include conf.d/common-headers.conf;
  }
  <% end %>
```
