# Documentation for NPM Release Library Workflow

This workflow is named `npm release library` and it's designed to automate
the release process of a NPM project. It includes several jobs that perform
different tasks, from setting up environment variables to uploading the
artifact.

## Workflow Triggers

The workflow is triggered by a `workflow_call` event. This means it can be
invoked from other workflows.

## Jobs

### 1. Setup Environment Variables

This job uses a reusable workflow to set up environment variables that will be
used in the subsequent jobs. The variables are set based on the repository and
branch information.

### 2. Preparing a Release

This job prepares the project for a release. It performs several steps:

- Gets a project token.
- Checks out the repository.
- Creates a new branch for the release.
- Sets the release version in the `package.json` file.
- Commits the new release version.
- Creates a pull request and merges it.
- Checks out the integration branch and merges the release branch into it.
- Sets the next development version in the `package.json` file and commits it.

### 3. Npm Build & SonarQube

This job uses a reusable workflow to build the project with NPM and perform
a Sonar scan. It needs the environment variables set up in the first job.

### 4. Fortify SAST

This job performs a Fortify Static Application Security Testing (SAST) scan.
It uses a reusable workflow and requires the NPM build and Sonar scan to be
successful.

### 5. Sonatype SCA

This job performs a Sonatype Software Composition Analysis (SCA). It uses a
reusable workflow and requires the Fortify SAST scan to be successful.

### 6. Send Information to Elasticsearch

This job sends information about the Fortify SAST and Sonatype SCA scans to
Elasticsearch. It uses a reusable workflow and runs regardless of the success
of the previous jobs.

### 7. Publish Library

This job uploads the NPM library. It uses a reusable workflow and runs if
the Sonatype SCA scan was successful and the workflow was triggered by a
release event.

## Secrets

The workflow uses several secrets to authenticate with different services,
such as APPLICATION_ID, APPLICATION_PRIVATE_KEY, FORTIFY_CLIENT_AUTH_TOKEN_PRO,
FORTIFY_USER, FORTIFY_PASSWORD, SONATYPE_USER, and SONATYPE_PASSWORD. These
secrets should be stored securely in the GitHub repository settings.

## Inputs

The workflow requires an input named `runner` which specifies the type of
runner to use for the jobs.

## Error Handling

The workflow includes error handling logic in several jobs. For example, if
there are conflicts when merging branches, the workflow will attempt to resolve
them automatically. If this is not possible, a warning is issued and the
workflow continues.

**NOTE:**

- See [here](../project-properties.md){:target="_blank"}
  to set the necessary project properties.
- See [here](../project-secrets.md){:target="_blank"} to
  set the necessary project secrets.
- See [here](../../../organization-properties.md){:target="_blank"}
  to set the necessary organization properties.
- See [here](../../../organization-secrets.md){:target="_blank"} to
  set the necessary organization secrets.
