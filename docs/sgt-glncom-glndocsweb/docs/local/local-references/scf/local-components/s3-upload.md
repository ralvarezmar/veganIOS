---
title: (SCF) S3 Upload
---

This documentation provides clear instructions and examples to use the S3 Upload component workflow for deploying artifacts or repository files to an AWS S3 Bucket.
Use this guide whether you are starting from scratch or integrating the S3 Upload component into an existing project.

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../support/credentials/data.md).

The S3 bucket must already exist in the account prior to execution.
This pipeline does not create the S3 bucket; it is intended solely to upload or synchronize its contents.

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

This repository can work with any branch, make sure you select the correct branch with your files when manually execute the workflow.

#### Structure

The generated component has a structure similar to the following:

``` bash
📦
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┗ 📜S3-upload.yml
 ┗ 📜README.md
```

## Component Configuration

Starting from version `2.2.2`, the S3 Upload workflow is configured using a `deployment.yml` file instead of manual workflow inputs.
Components created before version 2.2.2 will continue to work with manual inputs, but new components (created with version 2.2.2 or later) require the `deployment.yml` file for configuration.

If you want to migrate an existing component to use the new configuration method, you can run the "Update Component" workflow specifying version 2.2.2 and manually create the `deployment.yml` file as shown below.

### Example deployment.yml for S3 Upload

```yaml title="deployment.yml for S3 Upload workflow" linenums="1"
environments:
  cert:
    S3_BUCKET_NAME: "bucket_name"
    TARGET_FOLDER: "folder_name_inside_s3"
    COMPRESSION_TYPE: "none/zip/tar/tar.gz"
    NAME_COMPRESSION: "compressed-file-name"
    EXCLUDED_FILES: "list, of, comma, separated, files, or, folders, to, exclude"
    AWS_ACCOUNT_ID: 001122334455
    AWS_REGION: "eu-west-1"
    OVERWRITE: true
    CUSTOM_UPLOAD: "example/path/to/upload"         # Custom path for single directory upload
  pre:
    #...
  pro:
    #...
```

### Workflow Inputs (for components before 2.2.2)

The S3 Upload workflow is unique in that it is the only process responsible for handling the upload of the files you specify.
To use this workflow, simply add or create the necessary project files, then manually execute the workflow by setting the required inputs.

#### Workflow Inputs Explanation

Below are the details for each input parameter defined in the S3 Upload workflow:

- **Environment** to deploy to (choice): Specifies the deployment environment. Options: `dev`, `pre`, `pro`. Default is `dev`.
- **S3 Bucket Name** (string): The name of the target S3 bucket.
- Name of the **S3 target folder** inside the S3 bucket (string): The folder inside the S3 bucket where files will be uploaded.
- **Compression type** (choice): Defines the compression format. Options: none, zip, tar, tar.gz. Default: none.
- Compressed **artifact name** (string): Custom name for the compressed artifact; leave empty if compression is not required.
- List of comma-separated **files to exclude** (string): A comma-separated list of files or directories to exclude (e.g., folder1, file1.py).
- **AWS Account ID** where the S3 is located (string): AWS Account ID where the S3 bucket is located.
- **AWS Region** (string): AWS region hosting the S3 bucket. Default: eu-west-1.
- **Overwrite** (boolean): When enabled, this setting overwrites uploaded files (different files won't be affected). Default: false.
- **Custom path** for single directory upload (string): Specifies a custom directory path for uploading a single folder. Default: /example/path/to/upload.

???+ warning "Custom path for single directory upload"

      By default, the workflow uploads the entire repository—respecting the list of files to exclude—to the bucket.

      If you want to upload only a single folder from the repository, specify its path in the `Custom path for single directory upload` field.
      Note: The path should not start with a `/`; use a relative path instead (e.g., scr/example).

      If a custom directory is defined, the exclude files input remains compatible and will apply to the files within the specified directory rather than at the repository root.

      Leave this field blank to upload the entire repository, or provide a custom path to upload only the specified folder.

Once all the values are correctly set, you can click the button `Run workflow` in order to start the deployment.

That's everything you need, you can now deploy specific files that are not meant to be part of a build process.

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
