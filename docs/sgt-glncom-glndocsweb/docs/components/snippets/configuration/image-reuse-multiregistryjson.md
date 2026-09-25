This file (**multigregistry.json**) will include both origin of the image and the registry list where it will be uploaded.
To do so you must use the `reused-image` environment to configure your image origin and the `dev/pre/pro` environment to configure the destination of it.

The IDs of the names of the credentials (user/pass) will have to be registered as secret as indicated in the following point of the documentation.

The following tables describe the parameters for each kind environment.

Environment **`reused-image`**:

| Property      | Required | Description                                                | default     | Example                                                   |
|---------------|----------|------------------------------------------------------------|-------------|-----------------------------------------------------------|
| registry      | true     | Registry hostname (without protocol)                       | -           | 'registry.global.ccc.srvb.can.paas.cloudcenter.corp'      |
| image         | true     | Image ID composed with `project_name/image_name`           | -           | 'c3-alm-immutable-test/nextgen-darwin-hello-world-1-cert' |
| version       | true     | Version of the image in the origin registry                | -           | '1.0.0'                                                   |
| usernameId    | true     | Secret name with the username with access to the registry  | -           | 'REGISTRY_USERNAME'                                       |
| passwordId    | true     | Secret name with the password with access to the registry  | -           | 'REGISTRY_PASS'                                           |

!!! warning
    The `reused-image` environment is used to configure the origin of the image.
    In this environment, it is mandatory to include the version of the image.
    The version value **must be a Release** version of the image.

Environments **`dev`, `pre` and `pro`**:

| Property      | Required | Description                                               | default | Example                                                   |
|---------------|----------|-----------------------------------------------------------|---------|-----------------------------------------------------------|
| registry      | true     | Registry hostname (without protocol)                      | -       | 'registry.global.ccc.srvb.can.paas.cloudcenter.corp'      |
| registry-type | false    | Type of registry (harbor,artifactory)                     | harbor  | 'artifactory'                                             |
| image         | true     | Image ID composed with `project_name/image_name`          | -       | 'c3-alm-immutable-test/nextgen-darwin-hello-world-1-cert' |
| usernameId    | true     | Secret name with the username with access to the registry | -       | 'REGISTRY_USERNAME'                                       |
| passwordId    | true     | Secret name with the password with access to the registry | -       | 'REGISTRY_PASS'                                           |

!!! note
    Note: The names of the dev, pre, pro environments are static values and
    cannot be modified, and correspond to the execution that will be carried
    out with the integration (dev), release candidate (pre) and release (pro)
    workflows.

!!! warning
    Although in other Gluon components it's possible to configure a single
    registry to use across all environments, in the Image Reuse component it's
    mandatory to configure the source image (`reused-image` node) and destination
    registries in all environments (`dev`, `pre`, and `pro` nodes), even if they are
    the same and the values are repeated in all of them.

Example of a multiregistry configuration file:

=== "multiregistry.json"

```json title="Multiregistry initial example" linenums="1"
[
  {
    "environment": "reused-image",
    "registries": [
      {
        "registry": "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "image": "harbor-project/reusable-microservice",
        "version": "1.0.0",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
      }
    ]
  },
  {
    "environment": "dev",
    "registries": [
      {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "registry-type": "harbor",
        "image":      "c3-alm-immutable-test/nextgen-darwin-hello-world-1-dev",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
      }
    ]
  },
  {
    "environment": "pre",
    "registries": [
      {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "registry-type": "harbor",
        "image":      "c3-alm-immutable-test/nextgen-darwin-hello-world-1-pre",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
      }
    ]
  },
  {
    "environment": "pro",
    "registries": [
      {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "registry-type": "harbor",
        "image":      "c3-alm-immutable-test/nextgen-darwin-hello-world-1-pro",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
      }
    ]
  }
]
```
