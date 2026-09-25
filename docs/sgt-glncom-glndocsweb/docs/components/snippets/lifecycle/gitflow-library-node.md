Now we are going to describe the steps that a user has to perform in order to make a complete cycle, from the construction process (CI) to the deployment in an artifact repository.

The cycle explained below is based on **GitFlow**.

### Quality Gates

We want our libraries to have the maximum quality in Gluon prior to deployments to production environments, so it will be necessary to have the OK in:

- **Sonar**: Code Quality and test coverage
- **Fortify**: Analysis of the vulnerabilities of our source code
- **Sonatype**: Analysis of the vulnerabilities of our dependencies.

!!! warning "Quality Gates"

    Without these QG resolved we will only be able to deploy beta versions, being subject to these validations the release version.

#### Workflows

##### Npm Integration Library

- **Setup environment variables**:Load the properties defined  in the configuration project.
- **Npm build & Sonar scan**: Executes the default commands of npm install and npm build

##### Npm Security

- **Setup environment variables**:Load the properties defined in the configuration project.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with SAST and SCA analysis.

##### Npm Quality Gate

- **Setup environment variables**:Load the properties defined  in the configuration project.
- **Npm build & Sonar scan**: Executes the default commands of npm install and npm build

##### Npm Release Library

- **Setup environment variables**:Load the properties defined in the configuration project.
- **Npm build & Sonar scan**: Executes the default commands of npm install and npm build
- **Prepare release**: Creates a branch to update library version.
- **SAST**: Executes the reusable Fortify SAST workflow to perform a SAST scan with Fortify and validate the quality gates.
- **SCA**:Executes the reusable The Sonatype SCA workflow to perform a Sonatype SCA scan and analyze third party components from a repository.
- **Send information to Elasticsearch**:Send data to elasticsearch related with SAST and SCA analysis.
- **Npm repository upload**: Publishes release version into library repository.

### Events

#### Push to a Feature/Bugfix Branch

To work properly on the project, we first must create a new branch from the **development** branch, usually **feature/gluon-[Your task code here]**.
Once this branch is created, we apply our changes and push them to the github repository.

On a **push**, the ***NPM Integration Library*** workflow is executed.

![Push to feature action](images/Push2feat.png)
![Push to feature workflow](images/Push2feat-flow.png)

#### Pull Request from Feature to Development

Once the necessary changes have been applied to the **feature** branch, the changes must be merged into the **development** branch through a **Pull Request**.

When we create the **Pull Request** event from our **"Feature" branch to the Development branch** (develop or development), two workflows are executed: ***Npm Security*** and ***Npm Quality Gate***.

![PR to dev action](images/PR2dev.png)
![PR to dev workflow](images/PR2dev-flow1.png)
![PR to dev workflow](images/PR2dev-flow2.png)

#### Push to Development

When approving the Pull Request of the previous step on the integration branch (development/develop) we will generate a push event on this branch.

The ***NPM Integration Library*** workflow is executed and a **Beta version is released**.

![Push to dev action](images/Push2dev.png)
![Push to dev workflow](images/Merge2dev-flow.png)

#### Pull Request from Development to Main

When we are ready to promote our library to production, we will create a Pull Request from the integration branch (develop or development) to the main branch.

When we create the **Pull Request** event from our **Development branch to the Main branch**, three workflows are executed: ***Version Validation***, ***Security*** and ***Quality***.

![PR to Main action](images/PR2main.png)
![PR to Main workflow](images/PR2main-flow-node.png)
![PR to Main workflow](images/PR2main-flow1-node.png)
![PR to Main workflow](images/PR2main-flow2-node.png)

#### Push to main

When we approve the PR of the previous step on the main branch, we will generate a push event on this branch and therefore the ***Release*** workflow will be executed automatically.

This workflow will create a commit with the release version in the main branch.

#### Publish release

While the ***Release*** workflow executes automatically, it will also generate both the tag and release without manual intervention.

![Release action](images/Release-action.png)
![Release workflow](images/Release-flow.png)

![Generate tag and release](images/Generate_tag_n_release.png)

This workflow will publish the release version in artifact
repository.

Your library is now ready to use!
Check the Nexus repository for both beta versions (released through pushing to development) and release versions (released through pushing to main).

![Repository](images/Nexus_artifact1.png)

You can view its installation command in the repository:

![Install](images/Nexus_artifact2.png)

### Generate a new version of the library

When we want to generate a new version of the library, we must create a new branch from the **development** branch, usually **feature/gluon-[Your task code here]**.

Once this branch is created, we have to clone it and execute the following command to change the **package.json** and **package-lock.json** files:

```bash
npm --no-git-tag-version version [version]-beta
```

???+ warning "Versioning"

    Do not change the package.json and package-lock.json files manually, always use the command above.
    The new version MUST contain `-beta` at the end of the version number.
    Version must be a valid version number (e.g. 1.0.0) following senmantic versioning.

Apply our changes and push them to the github repository, now you are able to start the CI process from the beginning.
