
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

When we create the **Pull Request** event from our **"Feature" branch to the main branch, the quality.yml (Sonar), security.yml (Fortify & Sonatype),
version-validation.yml (Version Release validation) and archunit.yml (Santander Code Analysis Plugin) workflows will be executed automatically.

Next we detail which steps are executed in each of these workflows:

##### Quality workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Maven build & Sonar scan**: Executes the default commands of MAVEN_BUILD_GOAL: clean verify

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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/maven-quality.yml@v1
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
        uses: santander-group-shared-assets/gln-workflows/.github/workflows/maven-security-image.yml@v1
        secrets: inherit
    ```

##### Version validation workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Get version**: Obtain current version from pom.xml.
- **Check release**: Check for duplicated versions in the repository.

??? info "Version validation workflow code"

    ```yaml linenums="1"
    name: Maven version release validation
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
          version_file: 'pom.xml'
        secrets: inherit
    ```

##### Santander Code Analysis Plugin ArchUnit workflow

- **Setup environment variables**:Load the properties defined in properties.env file and in the configuration project.
- **Santander Code Analysis Plugin**: Executes the analysis plugin.

Please be aware that this workflow will not block or stop the build, it will either generate a warning in the logs in case of failure,
or it will notify the success of the execution.

??? info "Santander Code Analysis Plugin workflow code"

    ```yaml linenums="1"
    name: Santander Code Analysis Plugin
    on:
      pull_request:
        branches:
          - development
          - develop
          - main
          - master

    jobs:
      call-reusable-workflow:
        name: Santander Code Analysis
        uses: santander-group-shared-assets/gln-back-workflows/.github/workflows/santander-code-validation.yml@v1
        secrets: inherit
    ```

???+ note "Availability"

    This workflow is only available in new components created since Gluon 5.8.0 version.

    If you want to add it to a previously created component you can include a file named `santander-code-analysis.yml` in
    the `.github/workflows/` folder of your repository. The content of the file is as detailed in the previous point.

    To add this file you will need the PR to be approved with a user with permissions like the DevOps of your organization.

#### Push to main

When approving the Pull Request of the previous step on the main branch we will generate a push event on this branch.
This will be triggering **ci-tbd.yml workflow** (Maven build) and therefore the version is deployed in an artifact repository.

If everything works correctly, we will have our library uploaded to an artifact repository we will have the information in Sonar and Fortify.

##### CI-tbd workflow

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Retrieve the version of the pom.xml.
- **Check if maven uses native build**: Check if native is used.
- **Maven build & Sonar scan**: Executes the default commands of MAVEN_BUILD_GOAL: clean verify

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
            uses: santander-group-shared-assets/gln-workflows/.github/workflows/maven-ci-artifact-tbd.yml@v1
            secrets: inherit
    ```

#### Publish release

From **github.com** we can generate the release and create a new tag, this will generate a release event on this branch,
and therefore the **release-tbd.yml** workflow will be executed automatically.

This workflow will not create the commit with the release version, but it will publish the release version in artifact
repository.

##### Release-tbd workflow

This workflow contains all the steps from **ci-tbd.yml workflow** (Maven build) and **security.yml workflow** (Security) plus:

- **Setup environment variables**: Load the properties defined in properties.env file and in the configuration project.
- **Resolve version**: Retrieve the version of the pom.xml.
- **Check if maven uses native build**: Check if native is used.
- **Maven build & Sonar scan**: Executes the default commands of MAVEN_BUILD_GOAL: clean verify
- **SSDLC Onboarding Check**:Check component and version in Fortify and create it in case it does not exist.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with SAST and SCA analysis.
- **Maven artifact upload**: Upload the artifact to the artifact repository.
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
            uses: santander-group-shared-assets/gln-workflows/.github/workflows/maven-release-artifact-tbd.yml@v1
            with:
                technology: 'Java_Maven'
            secrets: inherit
    ```
