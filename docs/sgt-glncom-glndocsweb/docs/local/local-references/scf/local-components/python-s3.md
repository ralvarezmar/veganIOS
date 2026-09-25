---
title: (SCF) Python S3
---

This base component template serves as a comprehensive guide for building Python components and deploying the relevant files to an AWS S3 Bucket.
It streamlines the entire process, providing a clear and efficient pathway from development to production deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the Python S3 component workflows for their projects.
The guide includes comprehensive guidance on setting up the Python project, configuring essential files, managing dependencies, packaging the application, and performing the deployment process to an S3 Bucket.

Whether you are starting from scratch or integrating the Python S3 component into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development and deployment process.
By following this guide, users can ensure their Python applications are properly packaged and uploaded to AWS S3, ready for production use.

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../support/credentials/data.md).

The S3 bucket must already exist in the account prior to execution.
This pipeline does not create the S3 bucket; it is intended solely to upload or synchronize its contents.

## Git Flow Lifecycle

As soon as the scaffolding workflow is done, you will find a repository with two branches: main and development.
Both branches will be prepared with the necessary workflows to run the entire component lifecycle.
The following image shows a visual representation of the Git-Flow lifecycle and the workflows executed in each step.

![Git Flow Lifecycle](./images/new-git-flow-lifecycle.png)

In the Git Flow model, developers start by creating a new branch off the `development` branch for each feature, named `feature/*`. Once the feature is complete, they create a pull request to merge the `feature/*`branch into `development`.
When opening the pull request, three workflows are executed automatically: **Security, Quality** running sonar and fortify, and **Version Validation**.
If everything is satisfactory, the pull request is approved and the `feature/*` branch is merged into `development`.
???+ warning "Note"

      The version of the project can remain the same in order to deploy to development environment, but it must be higher than the previous version to deploy to PRE and PRO environments.
When the `development` branch receives the push from the pull request the **CI/CD** workflow is executed automatically. To deploy to PRE environment, a pull request from `development` to `main` has to be created.
As in the `feature` branch, when opening the pull request, these workflows are executed automatically: **Security, Quality and Version Validation**.
If they are correctly executed, merging the pull request moving changes from `development` to `main` will trigger the **CI/CD** to deploy to PRE environment.
The code is now in main and a tag is created. To complete the lifecycle, you need to publish a GitHub release using the mentioned tag to finally deploy to the production environment.

???+ warning "Note"

      Make sure to create your `feature/*` branch off the `development` branch as this branch contains all the necessary workflows and configuration files to run all workflows.

## Create Component

### Gluon Portal

{!
   include-markdown "./snippets/create-component-gluon.md"
   start="<!--Start creation-->"
   end="<!--End creation-->"
!}

### Component Repository

When creating a component from scratch, a scaffolding workflow runs automatically and creates the structure of the repository with the development branch, including all configuration files and workflows.

???+ warning "Scaffolding Note"

      Sometimes the scaffolding doesn't trigger automatically, so it needs to be launched manually from the actions tab.

#### Branches

{!
   include-markdown "./snippets/branch-structure.md"
   start="<!--Start Branch Structure-->"
   end="<!--End Branch Structure-->"
!}

#### Structure

The generated component has a structure similar to the following:

``` bash
📦
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜ci.yml
 ┃ ┃ ┣ 📜cd.yml
 ┃ ┃ ┣ 📜quality.yml
 ┃ ┃ ┣ 📜security.yml
 ┃ ┃ ┣ 📜version-validation.yml
 ┃ ┃ ┗ 📜upload-component-workflow.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon/ci
 ┃ ┗ 📜properties.env
 ┣ 📂src
 ┃ ┗ your code
 ┣ 📂tests
 ┃ ┗ your tests
 ┣ 📜deployment.yml
 ┣ 📜requirements.txt
 ┗ 📜setup.py
```

## Component Configuration

### Git Flow Branches

Gluon works with two branches that will need to be incorporated into our project:

* The main branch (main by default or master in old projects)
* The integration branch (development/develop by default)
This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.

### Configuration files that directly affect the CI/CD workflows

This base component template works with some configuration files that need modifications:

* `requirements.txt`: file where the libraries and dependencies of your project are listed
* `deployment.yaml`: file with key information for the deployment.
* `setup.py`: file with metadata and other relevant information of your project, like the version.
* `properties.env`: file with parameters used by the CI workflows.

#### requirements.txt

This file is where we set the libraries we want to use for our project.

One example for requirements.txt is:

```txt title="requirements.txt with sample libraries" linenums="1"
apache-airflow==2.2.2
boto3>=1.23.9
paramiko>=2.9.5
pysftp==0.2.9
apache-airflow-providers-ssh>=2.1.0
apache-airflow-providers-amazon>=6.0.0
acelafw>=0.0.1
```

#### Deployment.yaml

The `deployment.yaml` file is used to define the CD deploy process depending on the target cloud services and your specific needs.

The parameter FILES_FOR_S3 can be a single string or an array of strings separated by spaces, indicating `n` files to be uploaded to the S3.

```yaml title="deployment.yaml with instructions" linenums="1"
# Parameters for each environment. The comments written below for the DEV parameters also apply to the PRE and PRO environment parameters.
environments:
  DEV:
    AWS_ACCOUNT_ID: 001122334455                      # AWS account ID where you want to deploy
    AWS_ROLE_NAME: ""                                 # Name of the AWS Role used to deploy (make sure to check the prerequesites section)
    S3BUCKET_NAME: "trascribetestbucket"              # Your bucket name (it must previously exist)
    TARGET_FOLDER: "test"                             # S3 Target folder(if it doesn't exist, it will be created)
    FILES_FOR_S3: "src/main.py src/core.py ..."       # Route to specific files in the project that will also be uploaded to the target folder, separated by spaces. Each file will keep its filename but will be located in the target folder. If you want to sync the whole src folder, set FILES_FOR_S3: "-r src/*".
    OVERWRITE: 0                                      # Set to 1 to replace everything located at the bucket on each deployment
    IS_PUBLIC: 0                                      # Set to 1 to make your bucket public
    AWS_REGION: "eu-west-1"                           # AWS S3 region where your bucket is located
    FILE_COMPRESSION: "false"                         # Set to "true" to compress the artifact to a tar.gz file
    NAME_COMPRESSION: "compressed-file-name"          # File name for the compressed tar.gz file

  PRE:
    AWS_ACCOUNT_ID: 001122334455
    AWS_ROLE_NAME: ""
    S3BUCKET_NAME: "trascribetestbucket"
    TARGET_FOLDER: "test"
    FILES_FOR_S3: "src/main.py src/core.py ..."
    OVERWRITE: 0
    IS_PUBLIC: 0
    AWS_REGION: "eu-west-1"
    FILE_COMPRESSION: "false"
    NAME_COMPRESSION: "compressed-file-name"

  PRO:
    AWS_ACCOUNT_ID: 001122334455
    AWS_ROLE_NAME: ""
    S3BUCKET_NAME: "trascribetestbucket"
    TARGET_FOLDER: "test"
    FILES_FOR_S3: "src/main.py src/core.py ..."
    OVERWRITE: 0
    IS_PUBLIC: 0
    AWS_REGION: "eu-west-1"
    FILE_COMPRESSION: "false"
    NAME_COMPRESSION: "compressed-file-name"
```

**Parameters Description:**

* **AWS_ACCOUNT_ID:** The 12-digit identifier of the AWS account where the resources will be deployed.
This ID is needed for cross-account access and resource management.

* **AWS_ROLE_NAME:** The name of the AWS IAM role that will be assumed to perform the deployment operations.
This role must have the necessary permissions to perform the specified actions (e.g., S3 uploads).

* **S3BUCKET_NAME:** The name of the S3 bucket where files will be uploaded.
This bucket must exist prior to deployment.

* **TARGET_FOLDER:** The folder path within the S3 bucket where files will be stored.
If this folder doesn't exist, it will be created automatically during deployment.

* **FILES_FOR_S3:** A space-separated list of file paths to be uploaded to the S3 bucket.
Each file will maintain its filename when uploaded but will be placed in the specified target folder.
To achieve synchronization of the entire `src` directory, set `FILES_FOR_S3: "-r src/*"`.
Similarly, you can use this approach with other folders as needed.

* **OVERWRITE:** A flag to determine whether existing files should be replaced:

      * `0`: Do not overwrite existing files (default)
      * `1`: Replace all files in the target folder

* **IS_PUBLIC:** Controls the public access setting for uploaded files:

      * `0`: Files are private (default)
      * `1`: Files are accessible publicly

* **AWS_REGION:** The AWS region identifier where the S3 bucket is located (e.g., "eu-west-1", "us-east-1").

* **FILE_COMPRESSION:** Determines whether the files should be compressed before uploading:

      * `"false"`: Files are uploaded individually without compression (default)
      * `"true"`: Files are compressed into a single tar.gz archive before uploading

* **NAME_COMPRESSION:** The filename to use for the compressed archive when FILE_COMPRESSION is set to "true".
This will be the name of the tar.gz file uploaded to the target folder.

Each environment (DEV, PRE, PRO) can have different values for these parameters, allowing for environment-specific configurations while maintaining the same deployment structure.

#### setup.py

This is one of the key files in your python project, where you can add your project metadata. Make sure to update the 'version' field every time you want to deploy to PRE or PRO environments.

```python title="setup.py with placeholder values" linenums="1"
import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="my-component",
    version="1.0.0",
    author="Jonh Doe",
    author_email="jonhdoe@mail.com",
    description="Python repository to do very cool stuff",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="http://mypythoncomponent.com",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    install_requires=[
    ],
    python_requires='>=3.9',
)
```

???+ warning "Note"

      There is no need to upgrade the version of the project in order to deploy to development environment, but it must be higher than the previous set version to deploy to PRE and PRO environments.

#### properties.env

Found in the .gluon/ci directory, this file contains parameters that the CI workflows can retrieve for different purposes.

In this case, the only parameter meant to be adapted is PYTHON_REQUIRES, setting the value with the python version of your project in order to generate the virtual environment.
This Python version has to be within one of the supported by the Gluon Runners. These versions can be found [here](https://gluon.gs.corp/community/docs/latest/getting-started/company-management/technical-requirements/ephemeral-runners/flavours/#python-versions).

```txt title="properties.env" linenums="1"
# Sonar parameters
SONAR_ID="SONAR_GLUON_COMMUNITY"
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

# Python version (REPLACE with the python version of your app, for example: PYTHON_REQUIRES="3.9.18")
PYTHON_REQUIRES="3.11.5"
```

### Secrets Configuration

There is no need to add any secret at repository or organization level. Even though the workflow is capable to use them if they exist, the preferred way to deploy is using roles set in the GitHub Actions workflows.

## Build and Deploy your application

To start working, create a new branch from the existing development branch that starts with `feature/`, like `feature/init`, for example.

You can now add your source code to the new repository. Pay attention to the following information to ensure the GitHub Actions CI/CD workflows run properly.

In order to deploy to the target service or resource for each environment, follow the next steps.

### Deploying process - DEV environment

* Create a `feature/my-branch` branch from the `development` branch.

* Make all the changes in the `feature` branch.

* Commit your changes to the `feature` branch. This will trigger the `ci.yml` workflow, which builds the application but does not deploy it.

* Once your changes are ready, create a Pull Request from `feature/my-branch` to `development`. This will trigger the `ci.yml` workflow again.

* After the Pull Request is merged into `development`, the `cd.yml` workflow will be triggered automatically to deploy to the DEV environment.

* The deployment to the DEV environment is allowed directly from the `development` branch.

### Deploying process - PRE environment

* Once the source code is in the `development` branch, create a Pull Request from `development` to `main`.

* After merging the Pull Request into `main`, the `release.yml` workflow will be triggered. This workflow builds the application and creates a new tag and release in the repository but does not deploy it.

* To deploy to the PRE environment, [manually trigger](#manual-workflow-execution) the `cd.yml` workflow from the repository's Actions tab. Select the "PRE" environment when running the workflow.

* Note: Deployment to the PRE environment is only allowed from the `main` branch or a tag.

### Deploying process - PRO environment

* To deploy to the PRO environment, use the tag created by the `release.yml` workflow.

* [Manually trigger](#manual-workflow-execution) the `cd.yml` workflow from the repository's Actions tab. Select the "PRO" environment when running the workflow.

* Note: Deployment to the PRO environment is only allowed from a tag, and the tag name must follow the format `1.0.0`.

### Manual Workflow Execution

To manually trigger the `cd.yml` workflow:

1. Go to the repository's **Actions** tab.
2. Select the **CD** workflow.
3. Click **Run workflow** and choose the target environment (`cert`, `pre`, or `pro`).
4. Confirm and execute the workflow.

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
