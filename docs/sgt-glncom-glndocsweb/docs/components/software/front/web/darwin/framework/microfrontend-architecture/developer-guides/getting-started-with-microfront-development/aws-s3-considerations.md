# AWS S3 considerations

!!! note "Important"
    Before reviewing the considerations for the AWS S3 environment, we **strongly recommend** reading the main [Getting Started with Microfront Development](../getting-started-with-microfront-development/index.md) guide,
    as it contains essential information for development.

## Steps to begin development

Once you have cloned the Microfront Gluon archetype, created the project, and installed its dependencies, you can start developing the Microfrontend. Follow these steps:

### Modify the `index.html` and `proxy.conf.json` files

Refer to the [Microfront Configuration Set Up (AWS S3)](../configuration.md#microfront-configuration-set-up) section in the Configuration development guide to understand the required changes for the `index.html` and `proxy.conf.json` files.

### Update the `config.json` file

Navigate to the Fake API configuration file located at `api/public/shell-lite/config.json` and update the `baseRemoteMfe` property to point to the URL where the Microfrontend will run locally. When executing `npm start`, the URL would be `http://localhost:4201`.

This property is used in the `ShellLite` to load the Microfrontend in development mode.

``` json
// api/config.json

{
  ...
  "app": {
    ...
    "baseRemoteMfe": "http://localhost:4201"
  }
}
```

``` ts
// shell-lite.ts

export class ShellLite extends MicrofrontContainerDirective {
  // inject NgDarwin config service
  private readonly _configService = inject(ConfigService);

  // base uri where the microfront are hosted
  override baseRemoteMfe = this._configService.config.app['baseRemoteMfe'] as string;
  ...
}
```

### Update the `angular.json` file

Modify the `angular.json` file to ensure that the request to the `manifest.json` file are correctly handled in development mode.

!!! success "Correct (AWS S3 Environment)"
    `http://localhost:4201/manifest.json`

!!! failure "Incorrect (Kubernetes Environment)"
    `http://localhost:4201/<technical-grouping>/manifest.json`

To achieve this:

1. Copy the `assets` property and its contents from the path `projects/<project-name>/architect/build/options/assets`.
2. Paste it under `projects/<project-name>/architect/build/configuration/development/assets`.
3. In the pasted content, update the following entry to serve the `manifest.json` file directly from the project root:

    ```json
    assets: [
      ...
      {
        "glob": "manifest.json",
        "input": "",
        "output": "<technical-grouping>"
      }
    ]
    ```

    Replace it with:

    ``` json
    assets: [
      ...
      {
        "glob": "manifest.json",
        "input": "",
        "output": ""
      }
    ]
    ```

### Up and run the Microfront

Use `npm start` to run the Fake API and the Microfrontend in Shell Lite mode. Navigate to `http://localhost:4201/` to verify that the Microfrontend is working.  
You can now begin developing all the components required for your Microfrontend application.

## Related documentation

[AWS S3 Infrastructure](../../../../../../../front/web/darwin/mfe.md#awss3-infrastructure)
