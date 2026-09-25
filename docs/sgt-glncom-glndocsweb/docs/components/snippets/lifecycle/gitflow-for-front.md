<!--Start Intro-->
Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the deployment through the DEV, PRE and PRO environments (CD)

The cycle explained below is based on **GitFlow**
<!--End Intro-->

<!--Start Prerequisites-->
### Pre requisites

As we commented in previous points, the scaffolding process in the creation of the repository will create an empty **main** branch and a **develop** branch with the scaffold of our component.

!!! warning "Prerequisites"
    If your project uses **Karma** as the test runner (e.g., in Angular projects), you'll need to install **Puppeteer** to run your tests. This is because the installed runners do not contain Chrome/Chromium.

    To install Puppeteer, run the following command:

    ```bash
    npm install puppeteer@19.7.5 --save-dev
    ```

    It is **important** to use this **specific version (19.7.5)** because there are some issues regarding the binary download of Chromium from the latest Puppeteer versions behind corporate proxies.

    Once it is installed, you'll need to configure Karma to use it:

    ```javascript title="Sample for karma.conf.js" linenums="1" hl_lines="3 4"
    // Karma configuration file, see link for more information
    // https://karma-runner.github.io/1.0/config/configuration-file.html
    const puppeteer = require('puppeteer');
    process.env.CHROME_BIN = puppeteer.executablePath();

    module.exports = function (config) {
      // ...your Karma configuration
    };
    ```

<hr/>
<!--End Prerequisites-->

<!--Start Description-->
### Quality Gates

We want our component to have the maximum quality prior to deploy to production environments, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage
- **Fortify**: Analysis of the vulnerabilities of our source code
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.
- **Gluon Testing**: Functional tests (Execution of Functional Test with Gluon Testing frameworks after the deployment PRE is successful)

!!! warning "Quality Gates"
    Without these QG resolved we will only be able to deploy to development environments, being subject to these validations the pre/production environments.

Please, note that **you should** have configured the workflow **test command** to generate coverage in order to be read by sonar.

```bash
NPM_RUN_TEST_COMMAND='npm test --coverage'
```

### Pull Request from Feature to Develop

We will start working on the "Feature" branches of our GitHub repository and we will be integrating our changes into the integration branch (develop or development)

When we create the **Pull Request** event from:

- The **feature branch** towards the **integration branch** (development)
- The **development branch** towards the **main branch**

The "version check", quality (Sonar) and security (Fortify & Sonatype) workflows will be executed automatically.

Next we detail which steps are executed in each of these three workflows:

#### NPM version release validation workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Get version**: Acquire the current version of the project.
- **Check release**: Check if that version exists on the repository artifactory.

??? info "Version Validation"

    ```yaml linenums="1"
    name: NPM version release validation
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
        name: Version release validation
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
          - release-v[0-9]+.[0-9]+.[xX]
    
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
          - release-v[0-9]+.[0-9]+.[xX]

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
- **Resolve version**: Read the version from the package.json
- **Npm build & Sonar scan**: Executes the build and SonarQube analysis of the project.
- **Fortify SAST** Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **Sonatype SCA**: Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**: Send data to elasticsearch related with SAST analysis.
- **Container build and push**:
    - It takes the feature or development branch as image version and sets the environment variable TAG_VERSION with this value.
    - To continue, it builds the docker image based on Dockerfile located in the project and make a push to one or several harbor registries definided in the multiregistry.yaml file.
    - Finally, scan the image vulnerabilities in Harbor.
- **Send data to Elasticsearch**: Related to the deployment
- **Deploying a development**:  This job call the deploy workflow (cd.yml) for deploy our image to cert environment

??? info "Integration"

    ```yaml linenums="1"
    name: Integration
    on:
      push:
        branches:
          - development
          - develop

    jobs:
      call-reusable-workflow:
        name: Integration
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-ci-gfw.yml@v1
        secrets: inherit
    ```

If everything works correctly, we will have our image uploaded to the registry and we will have the information in Sonar and Fortify.

{!
   include-markdown "../../../application/ci-cd/ci/snippets/snippet-deploy-integration.md"
!}

#### Deploy workflow

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

If everything works correctly, we will have our image deployed in the CERT environment.

### Pull Request from the development branch to the main branch

When we are ready to promote our image to the PRE/PRO environments, we will create a Pull Request from the integration branch (develop or development) to the main branch.

This event will launch the **version-validation.yml workflow**, **quality.yml workflow** (Sonar) and **security.yml workflows** (Fortify & Sonatype).

### Push to the main branch

When we approve the PR of the previous step on the main branch, we will generate a push event on this branch,
and therefore the release-gfw.yml workflow will be executed automatically.

#### Release workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project. The configuration project is obtained according to the secrets defined here.
- **Preparing release version**: Update version pom in the branch (main or master).
- **Npm build & Sonar scan**: Executes the build and SonarQube analysis of the project.
- **SAST** Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**: Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with Fortify analysis.
- **Send information to Elasticsearch**:Send data to elasticsearch related with Sonatype analysis.
- **Generate tag and release**: Create the release tag and generate the GitHub Release.
- **Container build and push**:
    - It takes the version from the resolve version job to generate the release identifier as the image version,
      and sets the environment variable TAG_VERSION with this value.
    - After that, it generates the application and the distribution of the configuration, to continue,
    - It builds the docker image based on Dockerfile located in the project and make a push to one or several image registries associated with the Kubernetes infrastructures configured in the environment `cd.yaml` file.
    - The container images are pushed with the calculated release version tag.
    - It executes a [sysdig scan](../../../application/ci-cd/sysdig/index.md).
    - Finally, scan the image vulnerabilities and send the data related to the image build to elasticsearch.
- **Send data to elasticsearch** related to the image.

??? info "Release"

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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/npm-release-gfw.yml@v1
        with:
          technology: 'npm'
        secrets: inherit
    ```

At the end of the workflow, we can see a GitHub Release has been created using the GitHub Tag generated with the Release workflow.

![Alt text](images/release-workflow-0-github.png)

And a new container image has been pushed to the container registry using the same name as the tag of the version.

![Alt text](images/release-workflow-0-ecr.png)

#### PRE and PRO Deployment

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

### Retry a deploy

#### Retry a deployment execution

If the **"Container build and push"** job runs successfully and publishes the Release version, you can rerun the deployment workflow.

## Deploy using the Gluon Release Management

Gluon Release Management is a Gluon portal integration process that aims to automate the creation of
releases and tasks in Servicenow ITSM, as well as the orchestration of deployment in Github through
the portal itself.

For getting to know how to deploy using this tool,
please refer to the
[Release Management](../../../application/release-management/zero-touch/index.md)
documentation.
<!--End Description-->
