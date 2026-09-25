
### Trunk Based Development

Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the deployment in an artifact repository.

The cycle explained below is based on **Trunk Based Development**.

#### Quality Gates

We want our libraries to have the maximum quality in Gluon prior to deployments to production environments, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage
- **Fortify**: Analysis of the vulnerabilities of our source code
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.

!!! warning "Quality Gates"

    Without these QG resolved we will only be able to deploy snapshot versions, being subject to these validations the release version.

#### Pull Request from Feature to Main

When we create the **Pull Request** event from our **"Feature" branch to the main branch, the quality.yml (Sonar), security.yml (Fortify & Sonatype) and
version-validation.yml (Version Release validation) workflows will be executed automatically.

Next we detail which steps are executed in each of these workflows:

##### Quality workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **npm build & Sonar scan**: Builds the library and scans for vulnerabilities.

??? info "Quality workflow code"

    ```yaml linenums="1"
name: Quality
on:
  pull_request:
    branches:
      - development
      - develop
      - main
      - master
      - release-v[0-9]+.[0-9]+.[xX]

jobs:
  call-reusable-workflow:
    name: Quality
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-quality-image.yml@v1
    secrets: inherit
    ```

##### Security workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Get current version from pom**: Obtain current version from pom.xml.
- **SSDLC Onboarding Check**:Check component and version in Fortify and create it in case it does not exist.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with SAST and SCA analysis.

??? info "Security workflow code"

    ```yaml linenums="1"
name: Security
on:
  pull_request:
    branches:
      - development
      - develop
      - main
      - master
      - release-v[0-9]+.[0-9]+.[xX]

jobs:
  call-reusable-workflow:
    name: Security
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-security-image.yml@v1
    secrets: inherit
    ```

##### Version validation workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Get version**: Obtain current version from pom.xml.
- **Check release**: Check for duplicated versions in the repository.

??? info "Version validation workflow code"

    ```yaml linenums="1"
name: Version validation
on:
  pull_request:
    branches:
      - development
      - develop
      - main
      - master
      - release-v[0-9]+.[0-9]+.[xX]

jobs:
  call-reusable-workflow:
    name: Version validation
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/version-release-validation.yml@v1
    with:
      version_file: 'package.json'
    secrets: inherit
    ```

#### Push to main

When approving the Pull Request of the previous step on the main branch we will generate a push event on this branch.
This will be triggering **ci-tbd.yml workflow** (npm build) and therefore the version is deployed in an artifact repository.

If everything works correctly, we will have our library uploaded to an artifact repository we will have the information in Sonar and Fortify.

##### CI-tbd workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Retrieve the version of the pom.xml.
- **Check if npm uses native build**: Check if native is used.
- **npm build & Sonar scan**: Executes the default commands of npm_BUILD_GOAL: clean verify

??? info "CI-tbd workflow code"

    ```yaml linenums="1"
name: Integration
on:
  push:
    branches:
      - main
      - master
      - release-v[0-9]+.[0-9]+.[xX]

jobs:
  call-reusable-workflow:
    name: Integration
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-ci-artifact-tbd.yml@v1
    secrets: inherit

    ```

#### Publish release

From **github.com** we can generate the release and create a new tag, this will generate a release event on this branch,
and therefore the **release-tbd.yml** workflow will be executed automatically.

This workflow will not create the commit with the release version, but it will publish the release version in artifact
repository.

##### Release-tbd workflow

This workflow contains all the steps from **ci-tbd.yml workflow** (npm build) and **security.yml workflow** (Security) plus:

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Retrieve the version of the pom.xml.
- **Check if npm uses native build**: Check if native is used.
- **npm build & Sonar scan**: Executes the default commands of npm_BUILD_GOAL: clean verify
- **SSDLC Onboarding Check**:Check component and version in Fortify and create it in case it does not exist.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with SAST and SCA analysis.
- **npm artifact upload**: Upload the artifact to the artifact repository.
- **Generate tag and release**: Generate a tag and release in the repository.

??? info "Release-tbd workflow code"

    ```yaml linenums="1"
name: Release
on:
  release:
    types:
      - published

jobs:
  call-reusable-workflow:
    name: Release
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-release-artifact-tbd.yml@v1
    secrets: inherit

    ```
