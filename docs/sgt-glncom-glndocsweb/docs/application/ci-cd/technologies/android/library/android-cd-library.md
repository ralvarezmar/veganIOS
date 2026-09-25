# Android Continuous Delivery Library Workflow (`android-cd-library.yml`)

This YAML file defines a series of jobs that are run on GitHub Actions
as part of a continuous Delivery (CD).

## Purpose

Automates the setup, build, and deployment processes for the Android library.

## Jobs

| Job Name | Description |
| --- | --- |
| `setup-env-vars` | Sets up the necessary environment variables for subsequent jobs. It uses a reusable workflow stored in another repository. |
| `get-project-version` | It depends on the `setup-env-vars` job. Reads version from version.txt and verifies it has correct format (MAYOR.MINOR.PATCH). |
| `jobDeployToNexus` | It depends on the `setup-env-vars` job. Compiles and generates the binary as a dependency for other Android projects.  |
| `generate-tag-and-release` | It depends on the `jobUploadLib` job. Generates tag and version release and publishes all. |

## Input Variables

The workflow accepts one input, `runner`, which is used to specify
the type of runner on which the jobs should run. Android runner by default.

## Secrets

The workflow uses several secrets to authenticate with Nexus services.
All secrets for this workflow are defined by default in the organization in which the component was created.

## Trigger

The trigger for this workflow is the push event on main branch.

## Steps Breakdown

### Job: Setup Environment Variables

- **Setup environment variables**: Uses a reusable workflow to set up necessary environment variables.

### Job: Get Project Version

- **Checkout repository**: Checks out the repository.
- **Get Project Version**: Reads version from version.txt file.
- **Validate Version Format**: Check if the version format is correct. Semantic version (MAYOR.MINOR.PATCH).

### Job: Deploy to Nexus

- **Checkout repository**: Checks out the repository.
- **Set versions using action runner OHE**: Specify Android tools and version required.
- **Gradle download Poeditor**: Download translations.
- **Gradle Detekt**: Perform static code analysis using Detekt.
- **Gradle Build**: Build the project.
- **Gradle Publish to Nexus**: Publishes the built artifacts to Nexus using the specified URL, user, password, and version.

### Job: Generate tag and release

- **Get project token**: Retrieves a GitHub App token.
- **Checkout repository**: Checks out the repository.
- **Generating new tag for release**: Adds tag.
- **Publish release and tag**: Publish tag with version.
