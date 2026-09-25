In this file (**multigregistry.json**) will go the registry list where it is
necessary to upload the container images once the build process is finished
The IDs of the names of the credentials (user/pass) will have to be
registered as secret as indicated in the following point of the documentation.

To be able to make use of this action, it is enough to include it in a Github
Action workflow to push and scan in several image registries: Harbor v1, Harbor
v2, Artifactory and ECR (AWS).

Multiregistry parameters for `Harbor` and `Artifactory` registries:

| Property       | Required | Description                                               | default    | Example              |
|----------------|----------|-----------------------------------------------------------|-------------|----------------------|
| registry       | true     | Registry hostname (without protocol)                      | -           | 'registry.global.ccc.srvb.can.paas.cloudcenter.corp'  |
| registry-type  | false    | Type of registry: harbor,artifactory, oci                     | harbor      | 'artifactory'        |
| image          | true     | Image ID composed with `repository_name/image_name`       | -           | 'c3-alm-immutable-test/nextgen-darwin-hello-world-1-dev'  |
| usernameId     | true     | Secret name with the username with access to the registry | -           | 'REGISTRY_USERNAME'  |
| passwordId     | true     | Secret name with the password with access to the registry | -           | 'REGISTRY_PASS'      |

Multiregistry parameters for `ECR(AWS)` registry:

| Property       | Required | Description                                               | Default    | Example              |
|----------------|----------|-----------------------------------------------------------|-------------|----------------------|
| awsRegion       | true     | AWS region to use                  | -           | 'region-1'  |
| registry-type  | true    | Type of registry: ecr. Required for ECR(AWS)                    | harbor      | 'ecr'        |
| image          | true     | Image ID composed       | -           | 'sgt-app360/mdarwinnpmgf'  |
| awsAccount          | true     | The Amazon Web Services account ID associated with the registry to create the repository       | -           | '1111111111111'  |
| awsRoleArn          | false     | AWS role arn ID    | -           | 'role-arn'  |
| awsAccessKeyId     | true     | Secret name with the value of the AWS access key with access to the registry | -           | 'AWS_ACCESS_KEY_ID'  |
| awsSecretAccessKeyId     | true     | Secret name with the value of the AWS secret access key with access to the registry | -           | 'AWS_SECRET_ACCESS_KEY_ID'      |
| awsRegistryKeyId     | false     | If you use the KMS encryption type, specify the secret id of the KMS key to use for encryption | -           | 'AWS_REGISTRY_KEY_ID'      |

!!! note
    Note: The names of the dev, pre, pro environments are static values ​​and
    cannot be modified, and correspond to the execution that will be carried
    out with the integration (dev), release candidate (pre) and release (pro)
    workflows.

Example of a multiregistry configuration file with environments:

=== "multiregistry.json"
    ```json
    [
        {
            "environment": "dev",
            "registries": [
            {
                "registry-type":"harbor",
                "registry":   "registry.url",
                "image":      "project/image-name",
                "usernameId": "REGISTRY_USERNAME",
                "passwordId": "REGISTRY_PASS"
            }
            ]
        },
        {
            "environment": "pre",
            "registries": [
            {
                "registry-type":"artifactory",
                "registry":   "registry-harbor.url",
                "image":      "project/image-name",
                "usernameId": "REGISTRY_USERNAME2",
                "passwordId": "REGISTRY_PASS2"
            }
            ]
        },
        {
            "environment": "pro",
            "registries": [
            {
                "registry-type":"ecr",
                "awsRegion":   "region-1",
                "image":      "release/project/image-name",
                "awsAccount": "1111111111111",
                "awsRoleArn": "role-arn",
                "awsAccessKeyId": "AWS_ACCESS_KEY_ID",
                "awsSecretAccessKeyId": "AWS_SECRET_ACCESS_KEY_ID",
                "awsRegistryKeyId": "AWS_REGISTRY_KEY_ID"
            }
            ]
        }
    ]

    ```

Example of a multiregistry configuration file without environments:

=== "multiregistry.json"
    ```json
    [
    {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "image":      "c3-alm-immutable-test/nextgen-darwin-hello-world-1",
        "registry-type": "harbor",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
    },
    {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "image":      "c3-alm-test/nextgen-darwin-hello-world-1",
        "registry-type": "harbor",
        "usernameId": "REGISTRY_USERNAME2",
        "passwordId": "REGISTRY_PASS2"
    }
    ]

    ```
