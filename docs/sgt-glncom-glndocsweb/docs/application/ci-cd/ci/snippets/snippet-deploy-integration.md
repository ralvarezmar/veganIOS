##### Deploying to Certification Environments from a Feature Branch

Gluon allows **deploy feature branches** directly **to certification environments**, without merging into an integration branch. This functionality is useful for testing and validating changes in a before merging them into integration branches.
This functionality is **available for** both `GitFlow` and `Trunk Based Development` branching strategies.

###### How It Works

First, **configure** the `.gluon/ci/deploy-target.yml` file within the repository to specify rules that determine when and how deployments to certification environments should occur.

Next, simply **open a pull request** from your `feature branch` to an `integration branch`.

If the `source` and `target` branches of the pull request match the configuration in the `deploy-target.yml` file, the deployment process will automatically deploy your changes to the specified certification environment.

This enables you to validate and test your feature branch in a controlled environment before integration.

---

###### Example Configuration

Place the following configuration in `.gluon/ci/deploy-target.yml`:

```yaml
ci-checks:
  source-branch: feature/your-feature
  target-branch: development
  environment: cert
```

In this example, when a pull request is opened from `feature/your-feature` to `development`, the Workflow will deploy the changes to the cert environment.

- **source-branch**: The source branch name of the PR, also known as HEAD branch.
- **target-branch:** The target branch name where the changes will be integrated in the PR.
- **environments**: The environment name where changes will be deployed. This nanme must match with the folder name defined in `.gluon/cd/`.

---

###### About using wildcards

You can use wildcards (e.g., `feature/*`) in the `source-branch` field to allow deployments from any feature branch.

In the example below, a deploy in the environment `aws-test` will be made when a PR is open from **ANY feature branch** to branch development:

```yaml
ci-checks:
  source-branch: feature/*
  target-branch: development
  environment: aws/test
```

!!! warning "Important"
    Note that concurrent pull requests from different feature branches may overwrite each other's deployments in the same environment.

###### Important Considerations

- The deployment will only occur if the specified environment folder exists in your project.
- This feature is intended for certification-type environments only.
- The image tag used for deployment will be derived from the last segment of the source branch name (e.g., `feature/test` will use `test` as the tag).

By leveraging this configuration, teams can efficiently test feature branches in certification environments, streamlining the validation process before integration.
