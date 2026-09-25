# iOS Quality Library Workflow (`ios-ci-quality-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous integration (CI) to ensure the quality of the iOS library.

## Purpose

Automates setup, build, test, and code quality analysis processes.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from pom.xml and verifies it has correct format (MAYOR.MINOR.PATCH). |
| `jobExecuteUnitTests` | It depends on the `setup-env-vars` job. Compiles and executes every unit test coded for the iOS Library project and generates a code coverage required for sonarqube. |
| `jobSonar` | It depends on the `jobExecuteUnitTests` job. This job parts from the code coverage and uploads it to the sonar tool service to check if the project pass the quality gate. It also allows to pass in case there is a waiver activated. |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run.

## Secrets

The workflow uses several secrets to authenticate with Sonar services.
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

### Job: Execute Unit Tests

- **Get GitHub App token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Apply Xcode version**: Switches to the specified Xcode version.
- **Set up Java**: Configures the Java environment.
- **Set Settings**: Configures mobile settings.
- **Download pipe config dependencies**: Downloads and installs pipeline dependencies.
- **Gluon Fastlane Framework Action**: Sets up Fastlane for testing.
- **Build and run tests**: Installs `swiftlint`, builds, and runs tests via Fastlane.
- **Rename coverage file**: Renames the coverage file for SonarQube.
- **Upload coverage file**: Uploads the coverage artifact.

### Job: SonarQube Analysis

- **Checkout repository**: Checks out the repository.
- **Download coverage artifact**: Downloads the coverage artifact.
- **Set versions using action runner OHE**: Sets up tools and versions.
- **Extract Maven project version**: Extracts the Maven project version.
- **SonarQube - QG**: Runs SonarQube analysis and quality gate check.
- **Waiver QA - check-waiver-qa**: Checks for quality gate waivers.
- **SonarQube - Create annotation**: Creates an annotation based on SonarQube results.
- **Send results to Elasticsearch**: Logs SonarQube results to Elasticsearch.
