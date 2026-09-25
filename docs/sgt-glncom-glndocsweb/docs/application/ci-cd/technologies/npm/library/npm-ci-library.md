# CI (`npm-ci-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous integration (CI) workflow for a NPM library project.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `build-sonar` | Compiles the NPM project and performs a Sonar scan. It depends on the `setup-env-vars` job. |
| `fortify-sast` | Performs a static application security testing (SAST) with Fortify. It runs whenever the `build-sonar` job succeeds and the workflow has not been cancelled. |
| `sonatype-sca` | Performs a software composition analysis (SCA) with Sonatype. It runs whenever the `build-sonar` and `fortify-sast` jobs succeed and the workflow has not been cancelled. |
| `send-data-to-elastic` | Sends the results of the `fortify-sast` and `sonatype-sca` jobs to Elasticsearch. It runs regardless of the success or failure of the previous jobs. |
| `npm-repository-upload` | Uploads the resulting NPM artifact to an artifact repository. It runs whenever the `build-sonar` and `sonatype-sca` jobs succeed, the workflow has not been cancelled, and the current branch is `development` or `develop`. |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run.

## Secrets

The workflow uses several secrets to authenticate
with various services, such as Fortify and Sonatype.
These secrets must be available in the GitHub Actions environment.

## Pull Request

Creating a pull request to development or main will trigger a series
of workflows, one of these workflows is Version Validation.

#### **Version Validation workflow**

Here is the Version Validation workflow details:
[VERSION VALIDATION](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

**NOTE:**

- See [here](../project-properties.md){:target="_blank"}
  to set the necessary project properties.
- See [here](../project-secrets.md){:target="_blank"} to
  set the necessary project secrets.
- See [here](../../../organization-properties.md){:target="_blank"}
  to set the necessary organization properties.
- See [here](../../../organization-secrets.md){:target="_blank"} to
  set the necessary organization secrets.
