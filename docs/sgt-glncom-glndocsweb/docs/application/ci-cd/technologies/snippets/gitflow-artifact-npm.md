Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the deployment in an artifact repository.

The cycle explained below is based on **GitFlow**.

### Quality Gates

We want our artifacts to have the maximum quality in Gluon prior to deployments to production environments, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage.
- **Fortify**: Analysis of the vulnerabilities of our source code.
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.

!!! warning "Quality Gates"

    Without these QG resolved we will only be able to deploy snapshot versions, being subject to these validations the release version.

### Push to Feature

We will start working on the "Feature" branches of our GitHub repository and later, we will be integrating our changes into the integration branch (develop or development).
The first step is to create a new branch from the integration branch (develop or development) and push the changes to this branch.

When we push the changes to the **"Feature"** branch, the **ci-gfw.yml** (Npm build) workflow will be executed automatically.

#### CI-gfw workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Retrieve the version of the package.json
- **Npm build & SonarQube**: Executes the default commands of NPM_RUN_BUILD_COMMAND: npm run build

??? info "CI-gfw workflow code"

    ```yaml linenums="1"
    name: Integration
    on:
        push:
            branches:
                - development
                - develop
                - feature/*
                - fix/*
    
    jobs:
        call-reusable-workflow:
            name: Integration
            uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-ci-artifact-gfw.yml@v1
            secrets: inherit
    ```

### Pull Request from Feature to Develop

When we create the **Pull Request** event from our **"Feature" branch to the integration branch** (develop or development), the quality.yml (Sonar), security.yml (Fortify & Sonatype),
version-validation.yml (Version Release validation) workflows will be executed automatically.

Next we detail which steps are executed in each of these workflows:

#### Quality workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Npm build & SonarQube**: Executes the default commands of NPM_RUN_BUILD_COMMAND: npm run build

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
     
    jobs:
      call-reusable-workflow:
        name: Quality
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-quality.yml@v1
        secrets: inherit
    ```

#### Security workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Get current version from package**: Obtain current version from package.json.
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
     
    jobs:
      call-reusable-workflow:
        name: Security
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-security-image.yml@v1
        secrets: inherit
    ```

#### Version validation workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Get version**: Obtain current version from package.json.
- **Check release**: Check for duplicated versions in the repository.

??? info "Version validation workflow code"

    ```yaml linenums="1"
    name: Npm version release validation
    on:
      pull_request:
        branches:
          - development
          - develop
          - main
          - master
     
    jobs:
      call-reusable-workflow:
        name: Version release validation
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/version-release-validation.yml@v1
        with:
          version_file: 'package.json'
        secrets: inherit
    ```

### Push to Develop

When approving the Pull Request of the previous step on the integration branch (development/develop) we will generate a push event on this branch.
This will be triggering **ci-gfw.yml workflow** (Npm build) and therefore the version is deployed in an artifact repository.

If everything works correctly, we will have our library uploaded to an artifact repository we will have the information in Sonar and Fortify.

#### Integration workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Resolve the version of the component.
- **Npm build & SonarQube**: Executes the default commands of NPM_RUN_BUILD_COMMAND: npm run build
- **Fortify SAST** Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **Sonatype SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**: Send data to elasticsearch related with SAST and SCA analysis.
- **Npm artifact upload**: Then execute the command 'npm run build' to build the application artifact.
- **Deploying a development(if applicable)**: This job call to workflow cd.yaml for deploy our artifact to cert environment

#### Deploy workflow (if applicable)

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

### Pull Request from develop to main

When we are ready to promote our library to production, we will create a Pull Request from the integration branch (develop or development) to the main branch.

This event will launch the **quality.yml workflow** (Sonar), the **security.yml workflows** (Fortify & Sonatype) and the **version-validation.yml workflow** (Version Release validation).

### Push to main

When we approve the PR of the previous step on the main branch, we will generate a push event on this branch and therefore the **release-gfw.yml** workflow will be executed automatically.

This workflow will create a commit with the release version in the main branch.

#### Release-gfw workflow

This workflow contains all the steps from **ci-gfw.yml workflow** (Npm build) and **security.yml workflow** (Security) plus:

- **Getting release id**: Get the release id.
- **Generate tag and release**: Generate a tag and release in the repository.
- **Npm artifact upload**: Upload the artifact to the artifact repository.

??? info "Release-gfw workflow code"

    ```yaml linenums="1"
    name: Release
    on:
        push:
            branches:
                - main
                - master
    jobs:
        call-reusable-workflow:
            name: Release
            uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-release-artifact-gfw.yml@v1
            with:
                technology: 'npm'
            secrets: inherit
    ```

### Publish release

From **github.com** we can generate the release and create a new tag, this will generate a release event on this branch,
and therefore the **release-gfw.yml** workflow will be executed automatically.

This workflow will not create the commit with the release version, but it will publish the release version in artifact
repository.

### PRE and PRO Deploymnet

The **Deploy Workflow** can be called manually to deploy the artifact in the PRE and PRO environment.

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

## Deploy using the Gluon Release Management

Gluon Release Management is a Gluon portal integration process that aims to automate the creation of
releases and tasks in Servicenow ITSM, as well as the orchestration of deployment in Github through
the portal itself.

For getting to know how to deploy using this tool, please refer to the [Release Management](../../../release-management/zero-touch/index.md)
documentation.
