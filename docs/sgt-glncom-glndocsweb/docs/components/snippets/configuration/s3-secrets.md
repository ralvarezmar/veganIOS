<!--Start Deployment Infra Github Secrets-->

The S3 deployment workflow do not use Github secrets. The secrets should be acquired from the Hashicorp Vault.

#### Configure your secrets in Hashicorp Vault

Secrets in Vault should be [configured in the corresponding path of the technical application and environment](../../../application/ci-cd/howtos/index.md#21-how-to-register-a-secret-in-a-githubcom-repository).

For the cases of Gluon components, a naming convention has been defined to search for secrets in the corresponding path:

{url-vault}/ui/vault/secrets/kv-v2/data/{company}/{application_short_name}/{environment}/deployment/{ci_id}_{secret}

- company: short name of the company
- application_short_name: short name of the application
- environment: type of environment. Valid values are certification, preproduction, and production
- ci_id: infrastructure identifier in the Gluon Application Model component

For the specific case of Front components, the secrets that need to be configured are `aws-access-key-id` and `aws-secret-access-key`.

Consider the following example:

- company: sgt
- application_short_name: gluon
- environment: certification
- ci_id: s3-demo-active

The secrets that need to be created are:

  - `kv-v2/data/sgt/gluon/certification/deployment/s3-demo-active_aws-access-key-id`
  - `kv-v2/data/sgt/gluon/certification/deployment/s3-demo-active_aws-secret-access-key`

<!--End Deployment Infra Github Secrets-->