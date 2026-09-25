# AWS S3 considerations

!!! note
    Please note the following considerations **are mandatory** for the architecture works when it is deployed in the AWS S3 environment.

## Do not mix environments

To use the AWS S3 architecture **it is mandatory that the Shell and the Microfront are deployed on AWS S3**.
The current architecture does not allow mixing applications deployed in the Kubernetes environment and the AWS S3 environment at the same time.

## Do not share Darwin modules

The Shell and the Microfront have `@ng-darwin/config` and `@ng-darwin-wmf/microfront` modules as dependencies. These modules **must not be shared** in Webpack's `ModuleFederationPlugin`.
Please do not do this, or the architecture will not work correctly when deployed on AWS S3.

!!! failure "DO NOT DO THIS"
    ``` ts
    // webpack.config.js

    new webpack.container.ModuleFederationPlugin({
      shared: {
        ...
        '@ng-darwin/config':                   { ... },
        '@ng-darwin-wmf/microfront':           { ... },
        ...
      },
    }),
    ```

## The `meta` tag `manifest`

The idea behind this tag is that an SPA, Shell, or Microfront can be deployed both in Kubernetes and AWS S3 without requiring any modifications in their repositories.

Somehow, it is necessary to inform the `@ng-darwin/config` module that the configuration of the project must be retrieved from AWS S3,
and the module must generate a request in the right format to the domain where the component and its configuration are deployed:

  - `https://<application-domain>/<app-name>/cm-<component-name>/config.json`

For example, if your application called `myapp` has a Shell component named `myshell` and a Microfront component named `mymfe`, the following requests will be made respectively to retrieve the configuration for each component:

  - `https://<shell-domain>/myapp/cm-myshell/config.json`
  - `https://<mfe-domain>/myapp/cm-mymfe/config.json`

When a Web application is configured for deployment on AWS S3, **the deployment workflow** automatically adds a `meta` tag named `manifest` to the `index.html` file, containing a JSON value where the target is set to `s3`:

```html
<meta name="manifest" content='{"target":"s3"}'>
```

If you want to test how the configuration module handles requests based on the value of this `meta` tag, add it to your project's `index.html`. However, make sure to **never commit** this `meta` tag to the repository.

!!! warning
    This `meta` tag **must never be committed to the repository**, as the application will not work properly if it is also intended to be deployed in Kubernetes.
    For the application to work correctly in both Kubernetes and AWS S3, this tag must not be present, and the workflow must be responsible for adding it.
