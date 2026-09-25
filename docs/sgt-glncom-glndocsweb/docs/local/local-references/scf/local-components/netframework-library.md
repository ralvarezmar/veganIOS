---
title: (SCF) .NET Framework Library
---

This base component template serves as a comprehensive guide for building, packaging and uploading .NET Framework NuGet packages to Nexus within the Gluon portal.
It streamlines the entire process, providing a clear and efficient pathway from development to deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the .NET Framework workflow for their libraries.
This includes guidance on setting up the project, configuring essential files, managing dependencies, and deploying the library.

While it is a brownfield project, we leverage Gluon's SonarQube and Fortify for code quality and security analysis, rather than using our own tools directly.

Whether you are starting from scratch or integrating .NET Framework into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development and deployment process for .NET Framework libraries.

## Create Component

### Gluon Portal

To begin, you must onboard your application. This involves setting up your application within the system. Once your application is successfully created and onboarded, you can proceed to create your component.

To create a component, follow these detailed steps:

1. **Select the Component Type**:
    First, you need to choose the type of component you wish to create. In this case, select `(SCF) .NET Framework library`.

    ![Create  Component](./images/dotnet/netfr-lib-create-component.png)

2. **Fill in Component Details**:
    Next, you will be prompted to fill in the necessary details for your component. This includes:
    - **Name**: Provide a unique and descriptive name for your component.
    - **Short Name**: Short names can only contain capital letters and digits.
    - **Description**: Write a detailed description that explains the purpose and functionality of the component.
    - **Branch Strategy**: Choose a branch strategy for your component's repository. The recommended branch strategy for this template is `git flow`, which helps in managing the development workflow efficiently.
    - **Contact Information**: Provide the contact information for the person responsible for the component. Include the name and email address.

    ![Complete creation of the component](./images/dotnet/ntfr-lib-create-component-cont.png)

3. **Component Creation**:
    After filling in the required details, proceed to create the component. Once the component is created, you will notice that a new repository is generated under your application.
    This repository will have the name of your component and will be integrated with SonarQube for code quality analysis and Fortify for security analysis.

By following these steps, you will have successfully created a new component. This component will be ready for further development within the GitHub repository.

### Component Repository

When creating a component from scratch, a scaffolding workflow runs automatically and creates the structure of the repository with the development branch, including all configuration files and workflows.

???+ warning "Scaffolding Note"

      Sometimes the scaffolding doesn't trigger automatically, so it needs to be launched manually from the actions tab.

#### Structure

The generated library has a structure similar to the following:

``` bash
📦
 ┣ 📂.github
 ┃ ┣ 📂workflows
 ┃ ┃ ┣ 📜ci.yml
 ┃ ┃ ┣ 📜quality.yml
 ┃ ┃ ┣ 📜release.yml
 ┃ ┃ ┣ 📜security.yml
 ┃ ┃ ┣ 📜update-component-workflow.yml
 ┃ ┃ ┗ 📜version-validation.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon
 ┃ ┣ 📂ci
 ┃ ┗ ┗ 📜properties.env
 ┗ 📜deployment.yml
```

## Component Configuration

This section provides an overview of the necessary configurations for integrating the Gluon component into your project. It covers the required branches and essential configuration files to ensure smooth CI/CD processes.

### Branches

Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main by default or master in old projects)
- The integration branch (development/develop by default)
This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.

### Configuration Files

This base component template works with some configuration files that may need some modifications:

- `properties.env`: Properties with the CI/CD configuration.
- `deployment.yaml`: Library deployment configuration file.

#### Properties

=== "Default"

    ```properties
      # Sonar parameters
      SONAR_ID="SONAR_GLUON_COMMUNITY"
      SONAR_PROJECT_KEY=""

      # Fortify parameters
      FORTIFY_PROJECT=""

      # .NET parameters
      DOTNET_VERSION=""

      # Net Framework Library parameters: NUGET/ARTIFACT
      PACKAGE_TYPE="NUGET"
    ```

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

=== "Properties.env"

    | **Variable**        | **Required** | **Description** | **Example value**               |
    |---------------------|--------------|-----------------|---------------------------------|
    | **SONAR_PROJECT_KEY** | true         | Project key in Sonar | sgt-gluonad-probemicroframework |
    | **FORTIFY_PROJECT** | true         | Project name in Fortify | sgt-gluonad-probemicroframework |

=== "SONAR Configuration"

    | Property             | Required   | Description                         | Example |
    |----------------------|------------|-------------------------------------|---------------|
    | SONAR_ID             | false      | The name of the Sonar instance to be used. This value is unique and its value will be 'SONAR_GLUON_COMMUNITY'   | 'SONAR_GLUON_COMMUNITY' |
    | SONAR_PROJECT_KEY    | true       | Project key that's created in the sonar instance | "ccc:ccc:test-project:mvn-immutable-test" |
    | SONAR_REPORT_PATH    | false      | Location where the scanner writes the report-task.txt  | 'target/site' |
    | SONAR_MEMORY_PROPERTIES | false   | Memory properties                   | '-Xmx256m' |
    | ELASTICSEARCH_API_URL | true      | Elasticsearch api url with protocol | `https://[url]` |
    | ELASTICSEARCH_ALIAS   | true      | Elastic Search index                | 'index-x' |
    | ELASTICSEARCH_TYPE    | true      | Elasticsearch type                  | '_doc' |
    | QG_ENABLED    | false      | Enables or disables Sonar, Fortify, and Sonatype scans in CI, with 'high' for blocking, 'none' for non-blocking, and empty to skip scans.                  | 'high' |

=== ".NET Framework Configuration"

    | Property             | Required   | Description                                                                                         | Example                  |
    |----------------------|------------|-----------------------------------------------------------------------------------------------------|--------------------------|
    | **PROJECT_PATH**     | false      | Project's path (if is not set, it will look for a .sln file in the repository root).                | dir1/my-solution.sln     |
    | **PACKAGE_TYPE**     | false      | Set "NUGET" to upload to the NuGet repository, or "ARTIFACT" to upload the artifact to Nexus.       | "ARTIFACT"               |

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name.
    To avoid possible errors, the **properties.env** file is generated with the necessary values for the variables **SONAR_PROJECT_KEY** and **FORTIFY_PROJECT**.

    Example values:

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"

    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

#### Deployment.yml

The `deployment.yml` file is used to define the deployment configurations for different environments.
It specifies the libraries and their respective details that need to be deployed in each environment.
This file helps in managing and organizing the deployment parameters for both the CERT and PRO environments.

If the package type is DLL instead of CSPROJ, the deployment process differs.
For CSPROJ, the code is compiled and packaged before deployment. In contrast, for DLL, the precompiled DLL files are uploaded directly without any additional compilation.

``` yaml
environments:
  CERT:
    Libraries:
      Library1:
        Library Name: ''
        Package Type: ''
        Package Version: ''
        Package Path: ''
        NetFramework Version: ''
        Solution Path: ''
  PRO:
    Libraries:
      Library1:
        Library Name: ''
        Package Type: ''
        Package Version: ''
        Package Path: ''
        NetFramework Version: ''
        Solution Path: ''
```

### Secrets Configuration

Nexus credentials for the SCQ NuGet repository are required. `REPOSITORY_SCF_NUGET_USERNAME` and `REPOSITORY_SCF_NUGET_PASSWORD` should be checked at the organization level as GitHub secrets.
It is not necessary to add them since they should already be present, but ensure that they are correctly configured.
To do so, go to Settings > Security > Secrets and variables > Actions and add check following secrets at “Organization secrets” level.

## Application Lifecycle Management: How to build and deploy

{!
   include-markdown "./snippets/lib-git-flow-lifecycle.md"
   start="<!--Start Flow-->"
   end="<!--End Flow-->"
!}

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
