<!--description-start-->

For the execution of some jobs it is necessary that certain secrets exist in
the github repository.

You can learn more about the secrets creation
[here](../../howtos/index.md#2-secrets-in-githubcom)

<!--description-end-->

<!--secrets-start-->

## Configuration project secrets

| Property                | Description                                                                                                            | Example     |
|-------------------------|------------------------------------------------------------------------------------------------------------------------|-------------|
| ACTIONS_PA              | Secret id of a github token with access to `configuration project` and the project from which the workflow is executed | 'secret-id' |

## Fortify secrets

<!--fortify-start-->

| Property    | Description                         |
|-------------|-------------------------------------|
| FORTIFY_USER         | User created in Fortify SSC in the onboarding process. The user is unique for each organization |
| FORTIFY_PASWORD      | User password in Fortify SSC |

<!--fortify-end-->

<!--secrets-end-->

<!--registry-start-->

It will be necessary to create two secrets for uploads to the registry (Harbor,
Artifactory). These secrets will be one for the username and one for the
password. Both secrets must have the names referenced in the
`multiregistry.json`.

Example:
=== "multiregistry.json"
    ```json
    [
    {
        "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
        "image":      "c3-alm-immutable-test/nextgen-darwin-hello-world-1",
        "registry-type": "harbor",
        "usernameId": "REGISTRY_USERNAME",
        "passwordId": "REGISTRY_PASS"
    }
    ]

    ```

=== "secrets in repository"
    ```text
    - REGISTRY_USERNAME: Username with access to the registry
    - REGISTRY_PASS: Password with access to the registry

    ```
<!--registry-end-->

<!--deployment-start-->
It will be necessary to create as many secrets with the same name as have been
referenced 'deployment.yaml'. These secrets will be registered in the
**Environment secrets** level. Environments: certification, preproduction,
production.
<!--deployment-end-->

<!--helm-deployment-start-->
Helm example:
=== "deployment.yaml"
    ```yaml
      environments:
        - name: cert
          regions:
            - name: dev1
              properties:
                apiServer: 'https://api.ccc01alm.ccc.pre.cn1.paas.cloudcenter.corp:6443'
                namespace: 'sgt-almmc-tests-v4-dev'
                credentialsId: 'CRED_TOKEN'
                repo: 'registry.global.ccc.srvb.can.paas.cloudcenter.corp'
                project: 'c3-alm-immutable-test'
                script: 'helm upgrade --install --atomic --wait --debug'
                application: 'alm-darwin-hello-world-1-dev'
                chart: 'nextgen-darwin-hello-world-1-dev'
                version: '1.0.0'
                chartPath: 'helmvalues'
                valuesFile:
                    - values-dev.yaml

    ```

=== "secrets in `certification` environment"
    ```text
    - CRED_TOKEN: Token with access to the cluster

    ```
<!--helm-deployment-end-->
