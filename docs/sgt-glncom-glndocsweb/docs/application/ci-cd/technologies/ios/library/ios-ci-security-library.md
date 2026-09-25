# iOS Security Library Workflow (`ios-ci-security-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous integration (CI) to ensure the security of the iOS library.

## Purpose

Automates setup, security scan, and reporting processes.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from pom.xml and verifies it has correcto format (MAYOR.MINOR.PATCH). |
| `jobFortifyInstallScan` | It depends on the `setup-env-vars` job. Compiles the project to form a list of dependencies. It requires a macOS runner from github |
| `jobFortify` | It depends on the `jobFortifyInstallScan` job. This job parts from the fortify processed file and uploads it to the fortify tool service to check if the project pass the security gate. |
| `jobFortifyWaver` | It depends on the `jobFortify` job. In case the project does not pass the security gate this job checks if there is any exception for the project |
| `send-data-to-elastic` | Sends data to elactic to write down details of the workflow execution |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run.

## Secrets

The workflow uses several secrets to authenticate with Fortify service.
All secrets for this workflow are defined by default in the organization in which the component was created.

## Trigger

This workflow is triggered when a pull request is made to the main or development branches.

## Steps Breakdown

### Job: Setup Environment Variables

- **Setup environment variables**: Uses a reusable workflow to set up necessary environment variables.

### Job: Get Project Version

- **Checkout repository**: Checks out the repository.
- **Get Project Version**: Reads version from pom.xml.
- **Validate Version Format**: Check if the version format is correct. Semantic version (MAYOR.MINOR.PATCH).

### Job: Fortify Install Scan

- **Get GitHub App token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Apply Xcode version**: Switches to the specified Xcode version.
- **Set up Java**: Configures the Java environment.
- **Set Settings**: Configures mobile settings.
- **Download pipe config dependencies**: Downloads and installs pipeline dependencies.
- **Fortify Scan**: Runs Fortify scan with the specified parameters.
- **Upload coverage file**: Uploads the Fortify scan results.
- **Extract Maven project version**: Extracts the Maven project version.

### Job: Fortify Analysis

- **Fortify Results Analysis**: Uses a reusable workflow to analyze Fortify results.
- **Check Waivers**: Checks for quality gate waivers if the analysis fails.

### Job: Send Data to Elasticsearch

- **Send results to Elasticsearch**: Logs Fortify results to Elasticsearch.
