---
title: (SCF) Maven EMR
---

This base component template serves as a comprehensive guide for building Scala components with Maven and deploying the `.jar` artifacts to an AWS S3 Bucket.
It streamlines the entire process, providing a clear and efficient pathway from development to production deployment.

In this documentation, users will find detailed instructions, best practices, and examples to effectively utilize the Maven EMR component workflows for their projects.
This includes guidance on setting up the Scala project with Maven, configuring essential files, managing dependencies, packaging the application into a .jar file, and performing the deployment process to an S3 Bucket.

Whether you are starting from scratch or integrating the Maven EMR component into an existing project, this guide will provide the necessary steps to ensure a smooth and efficient development and deployment process.
By following this guide, users can ensure their Scala applications are properly built, the .jar artifacts are uploaded to AWS S3, and are ready for use in an EMR environment.

## Prerequisites: AWS Credentials Request

For this pipeline to work correctly, you need to request a role + OIDC.
Note that this template is cataloged as a `Non Microservice components > Miscellaneous`, detailed information to make the request can be found [here](../support/credentials/data.md).

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
 ┃ ┃ ┣ 📜rc.yml
 ┃ ┃ ┣ 📜maven-quality.yml
 ┃ ┃ ┣ 📜maven-security.yml
 ┃ ┃ ┣ 📜maven-version-validation.yml
 ┃ ┃ ┗ 📜upload-workflow.yml
 ┃ ┗ 📜CODEOWNERS
 ┣ 📂.gluon/ci
 ┃ ┗ 📜properties.env
 ┣ 📂src
 ┃ ┗ your code
 ┣ 📂tests
 ┃ ┗ your tests
 ┣ 📜.gitignore
 ┣ 📜README.md
 ┣ 📜deployment.yml
 ┣ 📜lombok.config
 ┗ 📜pom.xml
```

## Component Configuration

### Git Flow Branches

Gluon works with two branches that will need to be incorporated into our project:

* The main branch (main by default or master in old projects)
* The integration branch (development/develop by default)
This is because the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.

### Configuration files that directly affect the CI/CD workflows

This base component template works with some configuration files that need modifications:

* `properties.env`: file where CI/build parameters are located.
* `deployment.yaml`: file with key information for the deployment.
* `pom.xml`: the main file for maven compilation, with dependencies, build instructions, project metadata and more.

#### properties.env

Found in the .gluon/ci directory, this file contains parameters that the CI workflows can retrieve for different purposes.

In this case, the only parameter meant to be adapted is JAVA_VERSION, setting the value with the version with which you want to build your project.

```txt title="properties.env" linenums="1"
# Sonar parameters
SONAR_ID="SONAR_GLUON_COMMUNITY"
SONAR_PROJECT_KEY=""

# Fortify parameters
FORTIFY_PROJECT=""

# Java version to build your project
JAVA_VERSION="adoptopenjdk-17.0.8+7"
```

#### Deployment.yaml

The `deployment.yaml` file is used to define the CD deploy process depending on the target cloud services and your specific needs. Set the values in this sample deployment.yaml in order to deploy the .jar files on your bucket.

```yaml title="deployment.yaml with instructions" linenums="1"
# Parameters for each environment. The comments written below for the DEV parameters also apply to the PRE and PRO environment parameters.
environments:
  DEV:
    AWS_ACCOUNT_ID: "111222333444"            # The ID of the AWS account where you want to deploy.
    S3BUCKET_NAME: "my-bucket"                # s3://<S3BUCKET_NAME> - It must previously exist
    TARGET_FOLDER: "my/folder"                # s3://<S3BUCKET_NAME>/<TARGET_FOLDER> - If it doesn't exist, it will be created.
    OVERWRITE: 0                              # Set to 1 to replace the uploaded files (other files won't be affected)
    IS_PUBLIC: 0                              ## Set to 1 to make your bucket public (NOTE: this will make your bucket files public)
    REGION: "eu-west-1"                       ## Only change if it's on a different region

  PRE:
    AWS_ACCOUNT_ID: "111222333444"
    S3BUCKET_NAME: "my-bucket"
    TARGET_FOLDER: "my/folder"
    OVERWRITE: 0
    IS_PUBLIC: 0
    REGION: "eu-west-1"

  PRO:
    AWS_ACCOUNT_ID: "111222333444"
    S3BUCKET_NAME: "my-bucket"
    TARGET_FOLDER: "my/folder"
    OVERWRITE: 0
    IS_PUBLIC: 0
    REGION: "eu-west-1"
```

#### pom.xml

This pom.xml file contains some of the minimum requirements in order to build a Scala project. There are different placeholders that you have to replace with the metadata of your own project.
Follow the instrtuctions present in the comments inside the file.

???+ warning "Note"

      The needs of your specific project must be different from the current pom.xml configuration. The version of your project can remain the same for different deployments to the DEV environment, **but it must be upgraded from the previous version deployed** to PRE or PRO environments.

Find below a `pom.xml` file:

```xml title="pom.xml with placeholder values" linenums="1"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!--REPLACE with the groupId info of your component, like: schq.datalake, or supra.cleonalm...-->
    <groupId>com.santander.org.apm</groupId>
     <!--REPLACE with the artifactId for your component-->
    <artifactId>org-apm-component</artifactId>
    <name>org-apm-name-of-component</name>
    <description>Scala project built with MAVEN for AWS EMR Service</description>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <scope>your-scope</scope>

        <!--REPLACE with the Scala specifications of your project-->
        <scala.version>2.12.15</scala.version>
        <scala.version.shortName>2.12</scala.version.shortName>
        <spark.version>3.4.1</spark.version>

    </properties>

    <dependencies>
    <!-- Basic Scala libraries -->
        <!-- Main Scala library -->
        <dependency>
            <groupId>org.scala-lang</groupId>
            <artifactId>scala-library</artifactId>
            <version>${scala.version}</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>org.scala-lang</groupId>
            <artifactId>scala-library</artifactId>
            <version>${scala.version}</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>org.apache.spark</groupId>
            <artifactId>spark-core_${scala.version.shortName}</artifactId>
            <version>${spark.version}</version>
            <scope>provided</scope>
        </dependency>

            <!--OTHER DEPENDENCIES -->
            <dependency>
                  <groupId>org.projectlombok</groupId>
                  <artifactId>lombok</artifactId>
                  <scope>provided</scope>
            </dependency>

            <!-- Test -->
            <dependency>
                  <groupId>org.springframework.boot</groupId>
                  <artifactId>spring-boot-starter-test</artifactId>
                  <exclusions>
                        <exclusion>
                              <groupId>org.springframework.boot</groupId>
                              <artifactId>spring-boot-starter-logging</artifactId>
                        </exclusion>
                        <exclusion>
                              <groupId>junit</groupId>
                              <artifactId>junit</artifactId>
                        </exclusion>
                  </exclusions>
                  <scope>test</scope>
            </dependency>
            <dependency>
                  <groupId>org.junit.jupiter</groupId>
                  <artifactId>junit-jupiter</artifactId>
                  <scope>test</scope>
            </dependency>
            <dependency>
                  <groupId>org.junit.platform</groupId>
                  <artifactId>junit-platform-launcher</artifactId>
                  <scope>test</scope>
            </dependency>
      </dependencies>

<!--
#######                            													#######
        #  REPLACE with the specific needs of you project to be properly built
#######                           													#######
-->
      <build>
          <sourceDirectory>src/main/scala</sourceDirectory>
          <finalName>${project.artifactId}-${project.version}</finalName>
      <!-- <finalName></finalName> -->
            <plugins>
              <!-- Scala compiler for Maven -->
              <plugin>
                  <groupId>net.alchim31.maven</groupId>
                  <artifactId>scala-maven-plugin</artifactId>
                  <version>4.4.0</version>
                  <executions>
                       <execution>
                          <goals>
                              <goal>compile</goal>
                              <!--<goal>testCompile</goal>-->
                          </goals>
                        </execution>
                  </executions>
              </plugin>
              <!-- Generate JAR -->
              <plugin>
                  <groupId>org.apache.maven.plugins</groupId>
                  <artifactId>maven-shade-plugin</artifactId>
                  <version>3.2.4</version>
                  <executions>
                     <execution>
                     <phase>package</phase>
                          <goals>
                              <goal>shade</goal>
                          </goals>
                          <configuration>
                              <!--<finalName></finalName>-->
                              <shadedArtifactAttached>true</shadedArtifactAttached>
                              <createDependencyReducedPom>false</createDependencyReducedPom>
                              <shadedClassifierName>shaded</shadedClassifierName>
                          </configuration>
                      </execution>
                  </executions>
              </plugin>
              <plugin>
                  <groupId>org.apache.maven.plugins</groupId>
                  <artifactId>maven-compiler-plugin</artifactId>
                  <configuration>
                      <source>8</source><!--REPLACE with a different version if required-->
                      <target>8</target><!--REPLACE with a different version if required-->
                  </configuration>
              </plugin>
          </plugins>
      </build>
</project>
```

???+ warning "Note"

      There is no need to upgrade the version of the project in order to deploy to development environment, but it must be higher than the previous set version to deploy to PRE and PRO environments.

### Other configuration files

#### Lombok.config

The configuration system of Lombok offers us many valuable settings that frequently are the same across all the components of our project.
However, it also lets us change or customize Lombok’s behavior and sometimes even defines what can or cannot be used out of all the available features.

```yaml
config.stopBubbling = true
lombok.addLombokGeneratedAnnotation = true
lombok.toString.doNotUseGetters = true
lombok.equalsAndHashCode.doNotUseGetters = true
```

### Secrets Configuration

There is no need to add any secret at repository or organization level. Even though the workflow is capable to use them if they exist, the preferred way to deploy is using roles set in the GitHub Actions workflows.

## Build and Deploy your application

To start working, create a new branch from the existing development branch that starts with feature/ like feature/init, for example.

You can now add your source code to the new repository. Pay attention to the following information in order to make the GitHub Actions CI/CD workflows properly run.

In order to deploy to the target service or resource for each environment, follow the next steps.

### Deploying process - DEV environment

* Create feature/my-branchfrom development branch.

* Make all the changes in the feature branch.

* To deploy to the DEV environment follow these steps:

* First create a Pull Request from feature/my-branch to development. This will trigger the following workflows

![Workflows triggered by new PR](./images/data/newPR.png)

* Wait until quality, security and version validation workflows end.

* Once the previous workflows have finished, if you merge the Pull Request, the CI workflow will be executed automatically.
Once the CI workflow ends you can manually run the CD workflow to deploy to the DEV environment.

![Workflow triggered by merging PR](./images/data/mergedPR.png)

???+ warning "Note"

      You can deploy to the DEV environment even if Quality and Security gates fail. However it won't be possible to deploy to PRE or PRO environments if those workflows fail.

### Deploying process - PRE environment

* now that we have the source code in the development branch, the first step is creating a Pull Request from development to main.

* Quality, security and version validation workflows will be executed again, wait until they finish.

![Workflows triggered by new PR PRE](./images/data/newPR2.png)

* Once the previous workflows have finished, if you merge the Pull Request, the CI workflow will be executed automatically.
Once the CI workflow ends you can manually run the CD workflow to deploy to the PRE environment.

![Workflow triggered by merging PR PRE](./images/data/mergedPR2.png)

### Deploying process - PRO environment

Finally, in order to deploy to the PRO environment, the trigger is publishing a GitHub Release.

* In the releases section of your repository, there should be an existing release generated automatically, similar to the one you can see in the following screenshot:

![Auto generated release](./images/data/release.png)

* Press the edit button (above the red mark) and then go to the bottom of the page, disable the “Set as pre-release” option and click on Set as the latest release. Then, click the publish release button.

![Publishing release](./images/data/publishedRelease.png)

* This will trigger the CI workflow that will be executed automatically.
Once the CI workflow ends you can manually run the CD workflow to deploy to the PRO environment.

![Triggered workflow by release published](./images/data/workflowRelease.png)

* If you don’t find an automatically generated release, you can always generate a new one by clicking the Draft a new release button and choosing the latest tag generated in the previous workflows.

## Contact Information and Support

{!
   include-markdown "./snippets/contact-information.md"
   start="<!--Start-->"
   end="<!--End-->"
!}
