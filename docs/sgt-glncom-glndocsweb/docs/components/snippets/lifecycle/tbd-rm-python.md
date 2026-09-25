
### Trunk Based Development

Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the deployment through the DEV, PRE and PRO environments (CD)

The cycle explained below is based on **Trunk Based Development**.

#### Quality Gates

We want our microservices to have the maximum quality in Gluon prior to deployments to production environments, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage
- **Fortify**: Analysis of the vulnerabilities of our source code
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.
- **Gluon Testing**: Functional tests (Execution of Functional Test with Gluon Testing frameworks after the deployment PRE is successful)

!!! warning "Quality Gates"
    Without these QG resolved we will only be able to deploy to development environments, being subject to these validations the pre/production environments.

#### Pull Request from Feature to Main

We will start working on the "Feature" branches of our GitHub repository, and we will be integrating our changes into the main branch.

When we create the **Pull Request** event from our "Feature" branch to the main branch, the quality.yml (Sonar), security.yml (Fortify & Sonatype),
version-validation.yml (Version Release validation) and archunit.yml (Darwin Code Analysis Plugin) workflows will be executed automatically.

Next, we detail which steps are executed in each of these two workflows:

##### Quality gate workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Python build & Sonar scan**: Executes the default commands of PYTHON_BUILD_GOAL: clean verify

![Workflow](images/python-qa-workflow-0-github.png)

??? info "python quality gate workflow code"

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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/python-quality-image.yml@v1
        secrets: inherit
    ```

##### Security workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Get the current version from pom**: Read the pom.xml to get the version of the component.
- **SSDLC Onboarding Check**: Check if the component already exists in Fortify SSC.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**: Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**: Send data to elasticsearch related with Fortify analysis.
- **Send information to Elasticsearch**: Send data to elasticsearch related with Sonatype analysis.
- **Container build and push**:
    - It takes the feature branch as image version, and sets the environment variable TAG_VERSION with this value.
    - It builds the docker image based on Dockerfile located in the project and makes a push to one or several image registries associated with the Kubernetes infrastructures configured in the environment `cd.yaml` file.
    - It executes a [sysdig scan](../../../application/ci-cd/sysdig/index.md).
    - Finally, scan the image vulnerabilities and send the data related to the image build to elasticsearch.

??? info "python security workflow code"

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
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/python-security-image.yml@v1
    secrets: inherit

    ```
![Alt text](images/security-workflow-0-github-tbd.png)

#### Push to Main

When approving the Pull Request of the previous step on the main branch we will generate a push event on this branch and therefore the ci-tbd.yml workflow will be executed automatically.

Next, we detail which steps are executed in this workflow:

##### Integration workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Resolve the version of the component.
- **Check if python uses native build**: Check if it is necessary to configure a native compilation.
- **Python build and Sonar scan**: Executes the default commands of PYTHON_BUILD_GOAL: clean verify
- **Container build and push**:
    - It takes the feature or development branch as image version, and sets the environment variable TAG_VERSION with this value.
    - It builds the docker image based on Dockerfile located in the project and makes a push to one or several image registries associated with the Kubernetes infrastructures configured in the environment `cd.yaml` file.
    - It executes a [sysdig scan](../../../application/ci-cd/sysdig/index.md).
    - Finally, scan the image vulnerabilities and send the data related to the image build to elasticsearch.
- **Send data to elasticsearch** related with the image registries where the image has been published.
- **Create tag and Pre release** Create a tag with the version of the component and generate a pre-release in GitHub.
- **Deploying a development**: This job call to workflow python-cd-image.yaml for deploy our microservice to cert environment

??? info "python CI Image workflow code"

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
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/python-ci-tbd.yml@v1
    with:
      technology: 'python'
    secrets: inherit

    ```
![Alt text](images/python-ci-workflow-0-github.png)

If everything works correctly, we will have our image uploaded to the registry, and we will have the information in Sonar and Fortify.

![Alt text](images/integration-workflow-1-ecr.png)

##### Deploy workflow

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

If everything works correctly, we will have our image deployed in the CERT environment.

![Alt text](images/deploy-workflow-0-eks.png)

#### Release

When we want to publish a final version, we will do it from the GitHub releases page. First, we select the previously created version (pre-release or draft version) and then, uncheck the "Set as pre-release" option and click "Publish release".
The release-tbd.yml workflow will run automatically.

##### Release workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project. The configuration project is obtained according to the secrets defined here.
- **Getting pre-release id**: Get pre-release version, update version pom in the branch (main or master) with the Release version. Get last commit in the branch.
- **Check if python uses native build**: Check if it is necessary to configure a native compilation.
- **Python build & Sonar scan**: Executes the default commands of PYTHON_BUILD_GOAL: clean verify. If you want to overwrite the python command you can configure in properties.env.
- **SSDLC Onboarding Check**: Check if the component already exists in Fortify SSC.
- **SAST** Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**: Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**: Send data to elasticsearch related with Fortify analysis.
- **Send information to Elasticsearch**: Send data to elasticsearch related with Sonatype analysis.
- **Container build and push**:
    - It takes the version from the resolve version job to generate the release identifier as the image version,
      and sets the environment variable TAG_VERSION with this value.
    - After that, it generates the application and the distribution of the configuration, to continue,
    - It builds the docker image based on Dockerfile located in the project and make a push to one or several image registries associated with the Kubernetes infrastructures configured in the environment `cd.yaml` file.
    - The container images are pushed with the calculated release version tag.
    - It executes a [sysdig scan](../../../application/ci-cd/sysdig/index.md).
    - Finally, scan the image vulnerabilities and send the data related to the image build to elasticsearch.
- **Send data to elasticsearch** related to the image.
- **Release container build and push application to production**: Generate tag and push them to the artifact store.
- **Release container build and push application to certification**: Generate tag and push them to the artifact store.
- **Generate tag and release**: Create the release tag and generate the GitHub Release.

??? info "Release workflow code"

    ```yaml linenums="1"
name: Release

on:
  release:
    types:
      - published
jobs:
  call-reusable-workflow:
    name: Release
    uses: santander-group-shared-assets/gln-workflows/.github/workflows/python-release-tbd.yml@v1
    with:
      technology: 'python'
    secrets: inherit

    ```

![Alt text](images/python-release-workflow-1-github-tbd.png)

At the end of the workflow, we can see a GitHub Release has been created using the GitHub Tag generated with the Release workflow.

![Alt text](images/release-workflow-0-github.png)

And a new container image has been pushed to the container registry using the same name as the tag of the version:

![Alt text](images/release-workflow-0-ecr.png)

##### PRE and PRO Deployment

The **Deploy Workflow** can be called manually to deploy the microservice in the PRE and PRO environments.

To learn how the common deployment workflow works, applicable to all technologies, you can refer to the [Common CD Workflow](../../../application/ci-cd/cd/cd-rm/cd-workflow/index.md) section of the documentation.

#### Retry a deploy

##### Retry a deployment execution

If the **"Container build and push"** job runs successfully and publishes the Release version, you can rerun the deployment workflow.

### Deploy using the Gluon Release Management

Gluon Release Management is a Gluon portal integration process that aims to automate the creation of
releases and tasks in Servicenow ITSM, as well as the orchestration of deployment in Github through
the portal itself.

For getting to know how to deploy using this tool,
please refer to the
[Release Management](../../../application/release-management/zero-touch/index.md)
documentation.
