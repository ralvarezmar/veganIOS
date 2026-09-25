# How to set up probes.conf

If your application has been configured to be accessed through a route other than ***/*** (e.g. ***/application-reference***), it will also be necessary to change the ***probes.conf***, inside the **OPENSHIFT** folder.

This folder is created by ***pipeline*** and the parameters ***livenessProbe-path*** and ***readinessProbe-path*** have as ***default*** the value ***/***, and it is necessary to **update** them with the **route used to access your application**.

File: probes.conf

``` CONF
livenessProbe-path=/application-reference
readinessProbe-path=/application-reference
```
