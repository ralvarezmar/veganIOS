# iOS Continuous Delivery Library Workflow (`ios-cd-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous Delivery (CD).

## Purpose

Automates the setup, build, and deployment processes for the iOS library.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from pom.xml and verifies it has correct format (MAYOR.MINOR.PATCH). |
| `buildLibrary` | It depends on the `setup-env-vars` job. Compiles and generates the binary as a dependency for other iOS projects as xcframework. |
| `jobUploadLibToNexus` | It depends on the `buildLibrary` job. Upload the binary to Nexus ready to be consumed as dependency. |
| `jobUploadLibToGithub` | It depends on the `buildLibrary` job. Upload the binary to Github Packages ready to be consumed as dependency. |
| `generate-tag-and-release` | It depends on the `jobUploadLib` job. Generates tag and version release and publishes all. |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run.

## Secrets

The workflow uses several secrets to authenticate
with various services, such as Nexus and Github Packages.
All secrets for this workflow are defined by default in the organization in which the component was created.

## Trigger

The trigger for this workflow is the push event on main branch.

## Steps Breakdown

### Job: Setup Environment Variables

- **Setup environment variables**: Uses a reusable workflow to set up necessary environment variables.

### Job: Get Project Version

- **Checkout repository**: Checks out the repository.
- **Get Project Version**: Reads version from pom.xml.
- **Validate Version Format**: Check if the version format is correct. Semantic version (MAYOR.MINOR.PATCH).

### Job: Build Library

- **Get GitHub App token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Apply Xcode version**: Switches to the specified Xcode version.
- **Set up Java**: Configures the Java environment.
- **Set Settings**: Configures mobile settings.
- **Download pipe config dependencies**: Downloads and installs pipeline dependencies.
- **Gluon Fastlane Framework Action**: Runs the Gluon Fastlane Framework.
- **Framework Generation**: Generates the framework using Fastlane.
- **Extract Product Name**: Reads a JSON file to extract the product name.
- **Upload artifact**: Uploads the generated framework as an artifact.

### Job: Upload Library to Nexus

- **Get GitHub App token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Download artifact**: Downloads the previously uploaded artifact.
- **Set Settings**: Configures mobile settings.
- **Extract Product Name**: Reads a JSON file to extract the product name.
- **Upload Maven artifact to Nexus**: Deploys the artifact to Nexus.

### Job: Upload Library to Github Packages

- **Get GitHub App token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Download artifact**: Downloads the previously uploaded artifact.
- **Set Settings**: Configures mobile settings.
- **Extract Product Name**: Reads a JSON file to extract the product name.
- **Upload Maven artifact to Github Packages**: Deploys the artifact to GitHub Packages.

### Job: Generate tag and release

- **Get project token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Generating new tag for release**: Adds tag.
- **Publish release and tag**: Publish tag with version.
