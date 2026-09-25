# How to set up the ***proxy***

The proxy configuration is used to facilitate API calls locally so that you don't run into CORS issues during an application development.

> **What is CORS?**
>
> Cross-Origin Resource Sharing or CORS is a mechanism that allows restricted resources on a web page to be retrieved by another domain outside of the domain to which the resource to be retrieved belongs.
>
> For more details, see the [CORS documentation](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/CORS) available on Mozilla's website.

## Configuration

Inside the ***angular.json*** file there is the ***serve*** property, responsible for some settings for running the application locally.

The options sub-property contains the build settings and proxy file definition. To configure it in your application, simply point to the file containing the defined proxy settings in the proxyConfig property.

We create this file in **JSON** format with the name ***proxy.conf.json***:

``` JSON
// angular.json
  ...
  "serve": {
    "builder": "@angular-devkit/build-angular:dev-server",
    "options": {
      "browserTarget": "app-example:build",
      "proxyConfig": "proxy.conf.json"
    }
  }
  ...
```

And in the ***proxy.config.json*** file we'll add the proxy settings for the ***urls*** used in the application. Each object within this JSON represents the configuration of a URL through a key and an object, which can contain the following properties:

- ***target***: sets the ***url*** to which the ***proxy*** will redirect the request;
- ***secure***: turns off security-related warnings;
- ***changeOrigin***: change the ***header*** of the request to avoid **CORS** issues;
- ***logLevel***: Sets the verbosity level of the generated logs;
- ***pathRewrite***: removes the specified snippet from the ***url*** when performing the rewrite;

Take a look at the configuration below:

``` JSON
// proxy.conf.json:
{
  "/hub-url": {
    "target": "https://esbapi.santanderbr.pre.corp",
    "secure": false,
    "logLevel": "debug",
    "changeOrigin": true,
    "pathRewrite": {
      "^/hub-url": ""
    }
  },
}
```

It will tell the application to redirect all the calls that have in the composition of its ***url*** the occurrence ***/hub-url*** to <https://esbapi.santanderbr.pre.corp>.
