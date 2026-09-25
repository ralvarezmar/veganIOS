<!--Start Default Properties-->
On `.gluon/ci/properties.env` file you'll be able to customize different topics like the way you install or build your library.
There are many different variables, these are the most relevant for a npm repo:

| **Variable** | **Required** | **Description** | **Default values** |
| ---                               | ---   | --- |---          |
| NPM_RUN_INSTALL_COMMAND           | false | Configure it to change the way you install your dependencies on the CI/CD workflows | `npm install`   |
| NPM_RUN_BUILD_COMMAND             | false | Configure it to change the way you build your project on the CI/CD workflows | `npm run build` |
| NPM_APPLICATION_DIST_DIRECTORY    | false | Lets the workflow know in which directory is your distribution | `dist`          |
| NPM_CONFIGURATION_DIST_DIRECTORY  | false | Lets the workflow know in which directory is your nginx configuration | `conf.d`        |
| NPM_CONFIGURATION_DIST_CONTENT    | false | Allows workflow to identify the distribution content directory used for Angular library during build and deployment process | `*`        |
| NPM_RUN_TEST_COMMAND              | false | Configure it to change the way tests are executed in the CI/CD workflows | `npm test`        |
| NPM_RUN_PUBLISH_COMMAND           | true | Script to publish the library during the CI/CD process. This script must be defined in the root `package.json`. | `""` |
| NPM_RUN_VIEW_COMMAND              | false | Script to preview or serve the library during the CI/CD process. This script must be defined in the root `package.json`. | `""` |
| NPM_SONAR_PROPERTIES              | true | Configure it to change the way sonar behaves, but take into account you can not exclude your code!! | `-Dsonar.sources=./projects -Dsonar.javascript.coveragePlugin=lcov -Dsonar.javascript.lcov.reportPath=coverage/**/lcov.info -Dsonar. typescript.lcov.reportPaths=coverage/**/lcov.info -Dsonar.typescript.coveragePlugin=lcov -DtestExecutionReportPaths=test-result/ut_report.xml,ut_report.xml` |
| RECURSIVE_VERSION                 | false | For monorepos using a fixed version strategy, apply the root version to all packages | `false` |
<!--End Default Properties-->

<!--Start Naming Convention-->
??? info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    For example:

    SONAR_PROJECT_KEY="san-demo-mycomponent"

    FORTIFY_PROJECT="san-demo-mycomponent"
<!--End Naming Convention-->

<!--Start Local Running-->
??? abstract "Cloning your repository"

    ### Cloning your repository

    Once we have the device properly configured, the first step is to clone the project locally.

    To do so, visit [**How to clone the project**](../../../../../application/component-management/create-component.md#cloning-a-repository).

??? abstract "Run your Library"
    ### Running the Library

    Once you have cloned your repo, the next thing to do is to install your dependencies. As with any other Node.js project, you'll need to execute the following command:

    ```text
    npm install
    ```

    In some cases, it may be necessary to add the `--legacy-peer-deps` argument to resolve peer dependency issues:

    ```text
    npm install --legacy-peer-deps
    ```

    When that process ends and you have all your dependencies installed, you'll need to serve the playground application. In order to do this, just run the following command:

    ```text
    npm start
    ```
<!--End Local Running-->

<!--Start Build/Publish-->
### Quality Gates

We want our component to have the maximum quality prior to publish snapshots and releases, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage
- **Fortify**: Analysis of the vulnerabilities of our source code
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.

!!! warning "Quality Gates"
    Without these QG resolved we will only be able to publish snapshots versions, being subject to these validations the release versions.

Please, note that **you should** have configured the workflow **test command** to generate coverage in order to be read by sonar.

```bash
NPM_RUN_TEST_COMMAND='npm test'
```

If coverage generation and the `lcov` report are not configured by default, you can modify the test command to include the necessary arguments. For example, when using `jest`, you can add the following arguments:

```bash
NPM_RUN_TEST_COMMAND='npm test -- --code-coverage --no-watch --no-progress'
```

This ensures that the coverage is generated and the `lcov` report is available for analysis.

### Pull Request from Feature to Develop

We will start working on the "Feature" branches of our GitHub repository and we will be integrating our changes into the integration branch (develop or development)

When we create the **Pull Request** event from:

- The **feature branch** towards the **integration branch** (development)
- The **development branch** towards the **main branch**

The "version check", quality (Sonar) and security (Fortify & Sonatype) workflows will be executed automatically.

Next we detail which steps are executed in each of these three workflows:

#### Version validation workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Get version**: Acquire the current version of the project.
- **Check release**: Check if that version exists on the repository artifactory.

??? info "Version validation"

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

#### Quality workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Npm build & SonarQube**: Executes the build and SonarQube analysis of the project.

??? info "Quality"

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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-quality-image.yml@v1
        secrets: inherit
    ```

#### Security workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Get current version from package:** Acquire the version from the package.json
- **ssdlc-onboarding-check**: Check that the project is correctly onboarded on the security tools.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**: Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send data to Elasticsearch**: Send data to elasticsearch related with SAST and SCA analysis.

??? info "Security"

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

<hr/>

### Push to Develop

When approving the Pull Request of the previous step on the integration branch (development/develop) we will generate a push event on this branch and therefore the Integration workflow (ci-gfw.yml) will be executed automatically.

Next we detail which steps are executed in this workflow:

#### Integration workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Npm build & Sonar scan**: Executes the build and SonarQube analysis of the project.
- **Npm repository upload**: Uploads the library and send data to elasticsearch.

??? info "Integration"

    ```yaml linenums="1"
    name: Integration
    
    on:
      push:
        branches:
          - development
          - develop
          - feature/*
    
    jobs:
      call-reusable-workflow:
        name: Integration
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-ci-artifact-gfw.yml@v1
        secrets: inherit
    ```

If eaverything works correctly, we will have our library uploaded to the npm repository with BETA tag and we will have the information in Sonar and Fortify.

### Pull Request from the development branch to the main branch

When we are ready to publish the release version of our library, we will create a Pull Request from the integration branch (develop or development) to the main branch.

This event will launch the **version-validation.yml workflow**, **quality.yml workflow** (Sonar) and **security.yml workflows** (Fortify & Sonatype).

### Push to the main branch

When we approve the PR of the previous step on the main branch, we will generate a push event on this branch,
and therefore the release-gfw.yml workflow will be executed automatically.
<!--End Build/Publish-->
