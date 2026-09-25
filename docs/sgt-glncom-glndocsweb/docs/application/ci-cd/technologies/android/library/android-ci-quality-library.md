# Android Quality Library Workflow (`android-ci-quality-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous integration (CI) to ensure the quality of the Android library.

## Purpose

Automates setup, build, test, and code quality analysis processes.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from version.txt and verifies it has correct format (MAYOR.MINOR.PATCH). |
| `jobunitTests` | It depends on the `setup-env-vars` and `get-project-version` jobs. Compiles and executes every unit test coded for the Android Library project and generates a code coverage required for sonarqube. It includes the step of sonarqube and shows if the library pass the quality gate. |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run. Android runner by default.

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
- **Get Project Version**: Reads version from version.txt file.
- **Validate Version Format**: Check if the version format is correct. Semantic version (MAYOR.MINOR.PATCH).

### Job: Execute Unit Tests

- **Checkout repository**: Checks out the repository.
- **Set versions using action runner OHE**: Specify Android tools and version required.
- **Gradle download Poeditor**: Download translations.
- **Gradle Detekt**: Perform static code analysis using Detekt.
- **Gradle lint**: Perform lint checks.
- **Gradle Unit Tests**: Execute unit tests.
- **Gradle Jacoco Test Report**: Generate a test coverage report using Jacoco.
- **SonarQube - Getting data sonar instance**: Get data sonar instance config
- **SonarQube - Scan and QG**: Run SonarQube analysis with the specified project key, name, URL, token, and properties.
- **Waiver QA - check-waiver-qa**: Checks for quality gate waivers.
- **SonarQube - Create annotation**: Creates an annotation based on SonarQube results.
- **Send results to Elasticsearch**: Logs SonarQube results to Elasticsearch.
