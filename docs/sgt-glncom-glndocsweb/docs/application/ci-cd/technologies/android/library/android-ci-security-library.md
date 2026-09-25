# Android Security Library Workflow (`android-ci-security-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous integration (CI) to ensure the security of the Android library.

## Purpose

Automates setup, security scan, and reporting processes.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from version.txt and verifies it has correct format (MAYOR.MINOR.PATCH). |
| `jobFortify` | It depends on the `setup-env-vars` job. Runs a Fortify static application security testing (SAST) using a reusable workflow sast-fortify.yml from the gln-detect-asm-ssdlc-workflows repository. |
| `jobSonatype` | It depends on the `setup-env-vars` job. Runs a Sonatype component analysis using a reusable workflow sca-sonatype.yml from the gln-detect-asm-ssdlc-workflows repository. |
| `send-data-to-elastic` | Sends data to elactic to write down details of the workflow execution |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run. Android runner by default.

## Secrets

The workflow uses several secrets to authenticate
with various services, such as Fortify and Sonatype.
These secrets must be available in the GitHub Actions environment.

## Pull Request

Creating a pull request to development or main will trigger a series
of workflows, one of these workflows is Version Validation.

## Steps Breakdown

### Setup Environment Variables Job

- **Setup environment variables**: Uses a reusable workflow to set up necessary environment variables.

### Job: Fortify

- **Fortify**: Runs a Fortify static application security testing (SAST) using a reusable workflow sast-fortify.yml from the gln-detect-asm-ssdlc-workflows repository.

### Job: Sonatype Component Analysis

- **Sonatype Component Analysis**: Runs a Sonatype component analysis using a reusable workflow sca-sonatype.yml from the gln-detect-asm-ssdlc-workflows repository.v

### Job: Send Data to Elasticsearch

- **Send results to Elasticsearch**: Logs Fortify and Sonatype results to Elasticsearch.
