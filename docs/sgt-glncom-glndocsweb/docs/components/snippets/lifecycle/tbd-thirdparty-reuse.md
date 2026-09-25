Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the upload a release version to destination registry (Release).

The cycle explained below is based on **Trunk based development**

### Quality Gates

We want our Third Party images to have the maximum security in Gluon prior to upload to destination registry, so it will be necessary to have the OK in:

- **Sysdig**: Code security vulnerabilities and test coverage

### Pull Request to Main

We will start working on the "Feature" branches of our GitHub repository, and we will be integrating our changes into the main branch.

When we create the **Pull Request** event from our feature branch to the main branch, security.yml (Sysdig),
and version-validation.yml (Version Release validation) workflows will be executed automatically.

Next, we detail which steps are executed in each of these two workflows:

#### Version validation workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Check release**: Validate if actual version exits how release version.

??? info "Version validation workflow code"

    ```yaml linenums="1"
    name: Version validation
    on:
      pull_request:
        branches:
          - main
          - master
    
    jobs:
      call-reusable-workflow:
      name: Version validation
      uses: santander-group-shared-assets/gln-workflows/.github/workflows/version-release-validation.yml@v1
      with:
        version_file: 'VERSION'
      secrets: inherit
    ```

#### Security workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Pull image**: Pull Third Party image.
- **Sysdig**: Executes the reusable Sysdig workflow to perform a vulnerabilities scan with Sysdig and validate the quality gates.
- **Check Waiver**: If Sysdig step is KO then it validate if a valid waiver exist to continue with the workflow.
- **Send information to Elasticsearch**:Send data to elasticsearch related with Sysdig analysis.

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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/container-image-security.yml@v1
        secrets: inherit
    ```

### Push to Main

When push to the main branch (main/master) we will generate a push event on this branch and therefore the **Integration** workflow will be executed automatically.

Next we detail which steps are executed in this workflow:

#### Reuse snapshot Third party image TBD workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Resolve Version**:Validates the version of the reusable image being used. The version must be a RELEASE.
- **Retag container image**:
    - Retag the source image to the destination registry with the following pattern x.x.x-SNAPSHOT-SHOT_COMMIT_HASH-GITHUB_WORKFLOW_EXECUTION_ID (x.x.x is the version)
    - The retag image version sets the environment variable TAG_VERSION with this value.
- **Create tag and Pre release**: Creates a new draft release and select the check Set as a pre-release.

??? info "Reuse CI Third Party image"

    ```yaml linenums="1"
    name: Integration
    on:
      push:
        branches:
          - main
          - master

    jobs:
      call-reusable-workflow:
        name: Integration
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/third-party-image-ci-tbd.yml@v1
        secrets: inherit
    ```

If everything works correctly, we will have our image retaged to the registry with following pattern x.x.x-SNAPSHOT-SHOT_COMMIT_HASH-GITHUB_WORKFLOW_EXECUTION_ID (x.x.x is the version).

### Publish release

When we are ready to promote our image to upload a release version, we will publish the draft-release generated in integration workflow.

This event will launch the **Release workflow**.

#### Reuse release Third Party image workflow trunk based workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project. The configuration project is obtained according to the secrets defined here.
- **Sysdig validation**: Check vulnerabilities with Sysdig tool.
- **Retag container image**:
    - Retag the source image to the destination registry with the following pattern x.x.x (x.x.x is the version)
    - The retag image version sets the environment variable TAG_VERSION with this value.
- **Generate tag and release**: Creates a new git tag for the release.

??? info "Reuse release Third Party image workflow code"

    ```yaml linenums="1"
    name: Release
    on:
      release:
        types:
          - published

    jobs:
      call-reusable-workflow:
        name: Release
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/third-party-image-release-tbd.yml@v1
        secrets: inherit
    ```

At the end of the workflow we can see the image retaged to the registry with following pattern x.x.x (x.x.x is the version).
