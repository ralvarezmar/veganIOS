---
title: SCF Node S3 Assets Adaptation Guide
---

This page aims to assist in the migration of components that previously relied on the ALM Multicloud pipeline `pipelineForNPMAssetsS3` in Jenkins.
The guide focuses on the migration and adaptation of the GitHub repository files to comply with Gluon.
Full information about how to use this component template can be found in [documentation](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/node-assets/).

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../../support/credentials/data.md).

The S3 bucket must already exist in the account prior to execution.
This pipeline does not create the S3 bucket; it is intended solely to upload or synchronize its contents.

## Create component in Gluon

When creating a component in Gluon it will automatically create a repository in `http://github.com` with the following naming convention: `acronym_company`**-**`acronym_application`**-**`short_name_component`.

- acronym-company: Length of 3 characters, this field comes from APM.
- acronym-application: Length of 7 characters, it will be requested in the application onboarding in Gluon.
- short-name-component Length of 16 characters, it will be requested when creating the component in Gluon.

In order to create the component go to your application in Gluon portal > Components > New Component and select `(SCF) Node S3 Assets`.

![Create Component](images/node/assets-create-component.png)

When selecting the component to create, you will be prompted to enter the short-name-component and contact information for the maintainer.
The mandatory branch strategy for this template is *git flow*, which helps in managing the development workflow efficiently.
The *git-flow* branch strategy is explained indetail in [git-flow lifecycle](https://gluon.gs.corp/community/docs/latest/local/local-references/scf/local-components/ansible-execute/#gitflow-lifecycle).

Once the component is created, it will appear in the component list of your application followed by the used template, a short description and links to the GitHub repository.

The repository is created with a branch named `init-branch` that will run a scaffolding workflow to set up all required branches, environments and configuration files.
This workflow is expected to run automatically, so the expected behaviour is to find everything correctly configured.

???+ info "Scaffolding workflow"

    In some cases the scaffolding workflow will not run automatically. To solve this go to the Actions section of the repository and run the workflow manually from the *init-branch.*

## Repository and CI/CD

When scaffolding is executed, the repository will have this structure in the `development`branch, which must be respected for the workflow to work correctly:

![Workflows](images/node/lambda-wf.png)

To start working, create a new branch from the existing `development` branch that starts with `feature/` like `feature/init`, for example.

You can now add your source code to the new repository. Pay attention to the following information in order to make the GitHub Actions CI/CD workflows properly run.

### Git flow and CI/CD

In order to deploy to the target service or resource for each environment, follow the next steps.

#### Deploying process - DEV environment

- Create feature/my-branchfrom development branch.
- Make all the changes in the feature branch.
- To deploy to the DEV environment follow these steps:
- First create a Pull Request from feature/my-branch to development. This will trigger the following workflows

![Lambda wf](images/node/lambda-dev-wf.png)

- Wait until quality, security and version validation workflows end.
- Once the previous workflows have finished, if you merge the Pull Request, the CI/CD workflow will be executed automatically, deploying to the DEV environment.

![Lambda wf](images/node/lambda-dev.png)

???+ info "Note"

    You can deploy to the DEV environment even if Quality and Security gates fail. However it won't be possible to deploy to PRE or PRO environments if those workflows fail.

#### Deploying process - PRE environment

- Now that we have the source code in the development branch, the first step is creating a Pull Request from development to main.
- Quality, security and version validation workflows will be executed again, wait until they finish.

![Lambda wf](images/node/lambda-development.png)

- Once the previous workflows have finished, if you merge the Pull Request, the CI/CD workflow will be automatically executed, but deploying to the PRE environment.

![Lambda wf](images/node/lambda-pre-wf.png)

#### Deploying process - PRO environment

- Finally, in order to deploy to the PRO environment, the trigger is publishing a a GitHub Release.
- In the releases section of your repository, there should be an existing release generated automatically, similar to the one you can see in the following screenshot:

![Lambda wf](images/node/lambda-rl.png)

- Press the edit button (above the red mark) and then go to the bottom of the page, disable the “Set as pre-release” option and click on Set as the latest release. Then, click the publish release button.

![Lambda wf](images/node/lambda-rl-edit.png)

- This will trigger the following CI/CD workflow that deploys to the PRO environment.

![Lambda wf](images/node/lambda-pro.png)

- If you don’t find an automatically generated release, you can always generate a new one by clicking the Draft a new release button and choosing the latest tag generated in the previous workflows.

## Relevant files in the repository

### Deployment.yaml file

You will have a deployment file with the following parameters. Set the values accordingly to the specified instructions and your specific needs.

Based on certain values the workflows will behave differently.

- If you set the LAMBDA_NAME & LAMBDA_HANDLER values instead of empty or commented out, the workflow will update with your code the specified Lambda service.
- If you set the CLOUDFRONT_ID instead of empty or commented out, the workflow will execute the following command to remove CloudFront cache:
- `aws cloudfront create-invalidation --distribution-id <CLOUDRONT_ID> --paths '/*'`

```yaml
environments:
  DEV:
    AWS_ACCOUNT_ID: 111222333444          ## Required to deploy using roles instead of access_key and secret_key.
    S3BUCKET_NAME: "myBucket"             ## s3://<S3BUCKET_NAME> - It must previously exist
    TARGET_FOLDER: "my/folder"            ## s3://<S3BUCKET_NAME>/<TARGET_FOLDER> - If it doesn't exist, it will be created.
    COMPRESS_FILE_NAME: "testing"         ## Name of the compressed artifact that will be uploaded to the S3
    COMPRESSION_TYPE: ".zip"              ## Value must be: .zip || .tar.gz || .tar
    OVERWRITE: 0                          ## Set to 1 to replace everything located at s3://<S3BUCKET_NAME>/<TARGET_FOLDER>
    IS_PUBLIC: 0                          ##
    AWS_REGION: "eu-west-1"               ##
    # LAMBDA_NAME: "myLambdaName"           ## - OPTIONAL! The lambda name that will be updated. When updating a lambda is required, set the value.
    # LAMBDA_HANDLER: "index.handler"       ## - OPTIONAL! This refers to file.function. For example, index.js and handler() -> index.handler. When updating a lambda is required, set the value.
    # CLOUDFRONT_ID: "E0ANDSPI0CYM0"        ## - OPTIONAL! Set the value if you need to invalidate CloudFront Cache.

  PRE:
    AWS_ACCOUNT_ID: 111222333444
    S3BUCKET_NAME: "myBucket"
    TARGET_FOLDER: "my/folder"
    COMPRESS_FILE_NAME: "testing"
    COMPRESSION_TYPE: ".zip"
    OVERWRITE: 0
    IS_PUBLIC: 0
    AWS_REGION: "eu-west-1"
    # LAMBDA_NAME: "myLambdaName"
    # LAMBDA_HANDLER: "index.handler
    # CLOUDFRONT_ID: "E0ANDSPI0CYM0"

  PRO:
    AWS_ACCOUNT_ID: 111222333444
    S3BUCKET_NAME: "myBucket"
    TARGET_FOLDER: "my/folder"
    COMPRESS_FILE_NAME: "testing"
    COMPRESSION_TYPE: ".zip"
    OVERWRITE: 0
    IS_PUBLIC: 0
    AWS_REGION: "eu-west-1"
    # LAMBDA_NAME: "myLambdaName"
    # LAMBDA_HANDLER: "index.handler"
    # CLOUDFRONT_ID: "E0ANDSPI0CYM0"
```

### package.json

Classic file to include metadata, build scripts and other relevant configuration of your project.

```json
{
  "name": "my-component",
  "version": "0.1.0",
  "description": "Nodejs S3 Assets component",
  "author": "",
  "license": "ISC",
  "scripts": {
  },
  "engines": {
  },
  "files": [
  ],
  "devDependencies": {
  }
}
```

### Properties.env

This file contains parameters relevant to the CI process. The parameters can be adapted to the specific configuration of a project, except the following values, that should be let intact: `SONAR_ID`, `SONAR_PROJECT_KEY` & `FORTIFY_PROJECT`.

```yaml
# For TypeScript dist/
NPM_APPLICATION_DIST_DIRECTORY='dist/'

# For JavaScript src/
NPM_APPLICATION_DIST_DIRECTORY='app/'

NPM_RUN_INSTALL_COMMAND='npm install'
NPM_RUN_TEST_COMMAND='npm run test:coverage'

# Sonar Properties for Typescript library
NPM_SONAR_PROPERTIES='-Dsonar.sources=./src,package.json -Dsonar.javascript.coveragePlugin=lcov -Dsonar.javascript.lcov.reportPath=./coverage/lcov.info -Dsonar.typescript.lcov.reportPaths=./coverage/lcov.info -Dsonar.typescript.coveragePlugin=lcov'

# Sonar parameters
SONAR_ID="SONAR_GLUON_COMMUNITY"
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

# Replace with the current version of your project
NODE_VERSION='18.18.2'
```
