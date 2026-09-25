# How to set up the ***build***

If your project has been configured to be accessed via a route other than ***/*** e.g:

***/application-reference***

In the ***paas***, you need to **add** the **--base-href** parameter in the **build script** inside the ***package.json*** in order to perform the ***build*** using the **correct context** of the application.

> **⚠️ Note**
>
> If the parameter **not** is passed as an argument, when the ***deploy***, the ***scripts*** will not be downloaded correctly by the application, because it will be using the root (***/***) as a reference, causing in most cases a **white screen**.

So, if to access my application I need to use the route **/application-reference/** (***<https://afe.paas.santanderbr.pre.corp/aplicacao-referencia/>***).

I need to add in my ***package.json***, inside the **build script** the argument '--base-href /application-reference/', like this:

File: package.json

``` JSON
{
    "name": "application-reference",
    "version": "0.0.0",
    "scripts": {
        "build": "afe build --base-href /application-reference/",
    },
}
```

> **⚠️ Note**
>
> In the build script, replace ***/application-reference/***, with the route that was configured when you created your project.
