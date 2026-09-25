# Setting the ***nginx*** variables

To complete the configuration, we need to set the variables ***REPLACE_IN_FILES*** for the replacement process to be enabled and the ***NGINX_APP_LOCATION*** to specify which route created in **PAAS** is linked to our project.

| Variable | Description |
| -------- | ------ |
| **REPLACE_IN_FILES** | Enables **token replacement**. Must be set to **true**; |
| **NGINX_APP_LOCATION** | Tells you the route to access your application. If it is necessary to pass a relative path to access your application (e.g. ***/application-reference***), it will need to be added to this variable. Otherwise, the value will be ***/***. |

In the 'env.conf' file under `OPENSHIFT/DEPLOYMENT_CONFIG/**/`, set the variables:

``` BASH
REPLACE_IN_FILES=true
NGINX_APP_LOCATION=/application-reference
```

And finally, we can also set the following **environment variables**:

| Variable | Description |
| -------- | ------ |
| **FORCE_TIMESTAMP** | Forces the update of the ***timestamp*** of the changed files when performing the **deploy** of the application. Assists in cache management. |
| **COMPRESS_FILES** | Enables the server's GZIP compression feature; |

That way, the env.conf file would look like this:

``` BASH
REPLACE_IN_FILES=true
NGINX_APP_LOCATION=/application-reference
FORCE_TIMESTAMP=true
COMPRESS_FILES=true
```

Configure each environment (**DEV**, **PRE**, and **PRO**) according to your preferred settings.

> **❗ Information**
>
> To consult the **current** image of ***nginx*** **used** by **bank** can be consulted through the page [official base images](https://confluence.santanderbr.corp/display/PAASDEVBR/Imagens+Base+Oficiais).
>
> At the time of publishing this tutorial, the most up-to-date image is (***artifactory.santanderbr.corp/docker-base/rhel8/nginx-1.21:1.3.0.RELEASE***)
