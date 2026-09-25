# Breaking Changes

To migrate **ng-darwin** libraries to **16.x.x** version, the following **breaking changes** must be considered:

## Angular framework upgrading

The different libraries of `@ng-darwin` **16.x.x** only work with **Angular 16**, so it will be necessary for applications to migrate to this version of Angular.
You can help yourself with the [Angular Update Guide](https://update.angular.io/) provided by the Angular team itself.

## Msal Migration

Msal has been updated from V2 to V3. The biggest change is that, Msal has to be initialized before anything else, and the library will initialize it as soon as possible.
Meaning that for projects consuming the library, Msal will be already initialized when Msal get's consumed.

More information about this can be found here:

* [Msal Browser migration](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/v2-migration.md)
* [Msal Angular migration](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-angular/docs/v2-v3-upgrade-guide.md)

## The configuration request through `@ng-darwin/config` module

The `@ng-darwin/config` module will request the configuration to a `<TECHNICAL-GROUPING>/config.json` instead of `config/<TECHNICAL-GROUPING>/config.json`.
This change in the request will need some files of your application to be modified so that the proxies work.

### SPA Project

  ``` json
  // proxy.conf.json BEFORE
  "/config": {
    "target": "http://localhost:3000",
    "pathRewrite": {
      "^/config/<TECHNICAL-GROUPING>": ""
    }
  }

  // proxy.conf.json AFTER
  "/<TECHNICAL-GROUPING>/config": {
    "target": "http://localhost:3000",
    "pathRewrite": {
      "^/<TECHNICAL-GROUPING>": ""
    }
  }
  ```

  ``` bash
  # nginx/default.conf BEFORE
  location /config/<TECHNICAL-GROUPING>/config.json {
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location /config/<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }

  # nginx/default.conf AFTER
  location /<TECHNICAL-GROUPING>/config.json {
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location /<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }
  ```

### Shell Project

  ``` json
  // proxy.conf.json BEFORE
  "/config/<TECHNICAL-GROUPING>": {
    "target": "http://localhost:3000",
    "pathRewrite": {
      "^/config/<TECHNICAL-GROUPING>": ""
    }
  }

  // proxy.conf.json AFTER
  "/<TECHNICAL-GROUPING>/config": {
    "target": "http://localhost:3000",
    "pathRewrite": {
      "^/<TECHNICAL-GROUPING>": ""
    }
  }
  ```

  ``` bash
  # nginx/default.conf BEFORE
  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json {
    rewrite ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json /<TECHNICAL-GROUPING>/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }

  # nginx/default.conf AFTER
  location ~ ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json {
    rewrite ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json /<TECHNICAL-GROUPING>/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }
  ```

!!! warning
    If you are using the files located under `nginx/local` folder to test your application in a local nginx, please be aware you need to update these files as well.

### Microfront Project

  ``` json
  // proxy.conf.json BEFORE
  "/config/<TECHNICAL-GROUPING>sl": {
    "target": "http://localhost:3001",
    "pathRewrite": {
      "^/config/<TECHNICAL-GROUPING>sl": "shell-lite"
    }
  },
  "/config/<TECHNICAL-GROUPING>": {
    "target": "http://localhost:3001",
    "pathRewrite": {
      "^/config/<TECHNICAL-GROUPING>": ""
    }
  }
  
  // proxy.conf.json AFTER
  "/<TECHNICAL-GROUPING>sl/config": {
    "target": "http://localhost:3001",
    "pathRewrite": {
      "^/<TECHNICAL-GROUPING>sl": "shell-lite"
    }
  },
  "/<TECHNICAL-GROUPING>/config": {
    "target": "http://localhost:3001",
    "pathRewrite": {
      "^/<TECHNICAL-GROUPING>": ""
    }
  }
  ```

  ``` bash
  # nginx/default.conf BEFORE
  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>-sl/config.json {
    rewrite ^/(en-US|es)/config/<TECHNICAL-GROUPING>-sl/config.json /<TECHNICAL-GROUPING>-sl/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>-sl.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json {
    rewrite ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json /<TECHNICAL-GROUPING>/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>-sl/config.json {
    alias /etc/san-configmap-darwin/config-sl.json;
    ...
  }

  location ~ ^/(en-US|es)/config/<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }

  # nginx/default.conf AFTER
  location ~ ^/(en-US|es)/<TECHNICAL-GROUPING>-sl/config.json {
    rewrite ^/(en-US|es)/<TECHNICAL-GROUPING>-sl/config.json /<TECHNICAL-GROUPING>-sl/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>-sl.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json {
    rewrite ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json /<TECHNICAL-GROUPING>/<%= ENV["ACTIVE_ENVIRONMENT"] %>/<%= ENV["ACTIVE_BRANCH"] %>/<TECHNICAL-GROUPING>.json break;
    proxy_pass <%= ENV["CONFIG_END_POINT"] %>;
    ...
  }

  location ~ ^/(en-US|es)/<TECHNICAL-GROUPING>-sl/config.json {
    alias /etc/san-configmap-darwin/config-sl.json;
    ...
  }

  location  ~ ^/(en-US|es)/<TECHNICAL-GROUPING>/config.json {
    alias /etc/san-configmap-darwin/config.json;
    ...
  }
  ```

!!! warning
    If you are using the files located under `nginx/local` folder to test your application in a local nginx, please be aware you need to update these files as well.
