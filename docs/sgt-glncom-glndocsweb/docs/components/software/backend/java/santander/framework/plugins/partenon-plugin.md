# Gluon Partenon Maven-Plugin

## Introduction

Gluon Java Partenon Maven-Plugin is a code generator that creates all necessary sources (a service and request/response
transaction POJOs)
from configuration to call Partenon transactions in a microservice.

## Goals

It has three goals that can be executed independently:

- **[partenon:run](#run-generate-sources-from-transactions)**: It is the main operating mode, which allows to **generate
  the
  sources from a list of Partenon transactions** configured in the plugin in the _pom.xml_.
- **[partenon:download](#download-download-copies-from-transactions)**: Allows to **download the copyBooks with
  transactions
  fields information to files** from a list of Partenon transactions.
- **[partenon:generate-sources](#generate-sources-generate-sources-from-copies)**: Allows to **generate the sources to
  call Partenon
  transactions from files** with copyBooks information.

More details about the goals can be found in the [Usage](#usage) section.

## Installation & Configuration

To install the plugin in a Maven project, add the plugin and your configuration in the pom.xml as follows:

```xml

<build>
    <plugins>
        <plugin>
            <groupId>com.santander.gluon.plugins</groupId>
            <artifactId>partenon-maven-plugin</artifactId>
            <version>1.0.0</version>
            <configuration>
                <copyBooks>
                    <copyBook>
                        <transactionId>TRX1</transactionId>
                        <operation>V</operation>
                        <version>00001</version>
                    </copyBook>
                    <copyBook>
                        <transactionId>TRX2</transactionId>
                        <operation>V</operation>
                        <version>00013</version>
                    </copyBook>
                </copyBooks>
                <copyBooksFolder>Any/Path/From/Project/Folder</copyBooksFolder>
                <mode>SERVLET</mode>
                <overrideGeneratedSources>false</overrideGeneratedSources> <!-- Set to false by default -->
                <packageNameBase>com.santander.gluon
                </packageNameBase> <!-- Base package of the application, needed for locating the generated Partenon files -->
                <!-- Optional parameters for controlling the target folders -->
                <targetFolderParameters>
                    <includeTxNameAsPackage>false</includeTxNameAsPackage>
                    <infraFolder>infraestructure.adapters.output.partenon.data</infraFolder>
                    <modelFolder>domain.entity</modelFolder>
                    <serviceFolder>infraestructure.adapters.output.partenon</serviceFolder>
                    <includeMapper>true</includeMapper>
                    <serviceSuffix>ManagementAdapter</serviceSuffix>
                    <serviceImplementInterface>true</serviceImplementInterface>
                </targetFolderParameters>
            </configuration>
        </plugin>
    </plugins>
</build>
```

The configuration properties of the partenon-maven-plugin plugin are defined inside the `<configuration>` tag in the
pom.xml file.
Here are the properties that can be configured:

| Property                                             | Required | Description                                                                                                     | Default value                 |
|:-----------------------------------------------------|----------|:----------------------------------------------------------------------------------------------------------------|:------------------------------|
| **copyBooks**                                        | true     | List of `copyBook` with transactions info used to generate Partenon POJOs and service.                          |                               |
| **copyBooks.copyBook.transactionId**                 | true     | The Partenon transaction ID                                                                                     |                               |
| **copyBooks.copyBook.operation**                     | true     | The operation of the transaction to be performed                                                                |                               |
| **copyBooks.copyBook.version**                       | true     | The version of the transaction-operation to be performed                                                        |                               |
| **copyBooksFolder**                                  | false    | The folder where the copyBook files with transaction info will be saved                                         | `src/main/resources/partenon` |
| **mode**                                             | false    | Indicates the type of Partenon client and service to be used: `SERVLET` or `REACTIVE`                           | `SERVLET`                     |
| **overrideGeneratedSources**                         | false    | Indicates if the generated Partenon models and services files should be overridden                              | `false`                       |
| **packageNameBase**                                  | true*    | It's the base package of the application where the generated Partenon models and service will be located        |                               |
| **targetFolderParameters**                           | false    | Object that contains the parameters to modify the target folder names and behaviour. It is optional             |                               |
| **targetFolderParameters.includeTxNameAsPackage**    | false    | Wraps the file generated inside a package with the name of the Partenon transaction                             | `true`                        |
| **targetFolderParameters.infraFolder**               | false    | Allows to change the name of the infrastructure folder                                                          | `infra.mainframe.model`       |
| **targetFolderParameters.modelFolder**               | false    | Allows to change the name of the model folder                                                                   | `model`                       |
| **targetFolderParameters.serviceFolder**             | false    | Allows to change the name of the service folder                                                                 | `service`                     |
| **targetFolderParameters.includeMapper**             | false    | Removes the conversion from record to entity from the service file and creates a mapper that performs this role | `false`                       |
| **targetFolderParameters.serviceSuffix**             | false    | Suffix used to name Service implementation class                                                                | `Service`                     |
| **targetFolderParameters.serviceImplementInterface** | false    | Create an interface to be implemented by the service                                                            | `false`                       |
| **targetFolderParameters.interfaceServiceFolder**    | false    | Allows to change the name of the interface implemented by service folder                                        | `service`                     |
| **targetFolderParameters.interfaceServiceSuffix**    | false    | Default suffix use to create interface                                                                          | ``                            |

!!! info "packageNameBase property is only required for run and generate-sources goals"

    The `packageNameBase` property is only required for the `run` and `generate-sources` goals.
    It is used to locate the generated Partenon files in the project.

!!! info "targetFolderParameters properties are completely optional, and they can be used to customize the target
folders"

## Usage

### Run: Generate sources from transactions

To **generate the sources from a list of Partenon transactions** configured in the plugin, the following command must be
executed:

```shell
mvn partenon:run
```

This command will
first [download the Partenon transactions copies to files](#download-download-copies-from-transactions)
and then [generate the sources](#generate-sources-generate-sources-from-copies) (service and Partenon POJOs) from them.

### Download: download copies from transactions

To **download the Partenon transaction copies into files**, the following command must be executed:

```shell
mvn partenon:download
```

??? tip "Generate Java code sources"

    The command `mvn partenon:download` only downloads the Partenon transaction copies into files.
    To generate the sources from the files, the command `mvn partenon:generate-sources` must be executed after this one.

The plugin will generate a file for each transaction in the folder configured in the `copyBooksFolder` property
following
this naming with the `copyBook` info: **_transactionId_-_operation_-_version_.json**.

!!! info "Files are not overwritten"

    If the files already exist, they will not be overwritten because the tuple transaction-operation-version must be unique.
    If you want to overwrite the files, you must delete them manually before executing the command `mvn partenon:download` or `mvn partenon:run.
    In case the version number is updated in plugin configuration, a new file will be created with the new version number.

### Generate-sources: generate sources from copies

To **generate the sources to call Partenon transactions from the files** with copyBooks information, the following
command should be executed:

```shell
mvn partenon:generate-sources
```

!!! warning "Transactions copies files must already exist"

    The command `mvn partenon:generate-sources` generates the sources to call Partenon transactions from the files with copyBooks information.
    The files must already exists or must have been downloaded previously using the command `mvn partenon:download`.

#### Generate-sources: default target folder parameters

When executing the `partenon:generate-sources` goal with the default target folder parameters, the plugin will generate
the following structure:

    ├── infra
    │    └── mainframe
    │        └── model
    │            └── TRXName
    │                ├── InputTRX.java
    │                └── OutputTRX.java
    ├── model
    │    └── TRXName
    │        └── InputTRXRecord.java
    │        └── OutputTRXRecord.java
    └── service
        └── TRXNameService.java

- These packages will be created from the base package defined in the `packageNameBase` property.
- The package 'infra.mainframe.model' contains the Partenon POJOs (InputTRX and OutputTRX) for each transaction.
- The package 'model' contains the POJOs (InputTRXRecord and OutputTRXRecord) that represent the transaction records.
- The package 'service' contains the service class (TRXNameService) that calls the Partenon transaction.

#### Generate-sources: custom target folder parameters

If we wished the generated files to be placed in different folders, we could use the `targetFolderParameters` property
to customize the target folders.

As an example, the following configuration will be used to generate the sources:

```xml

<targetFolderParameters>
    <includeTxNameAsPackage>false</includeTxNameAsPackage>
    <infraFolder>infrastructure.adapters.output.partenon.data</infraFolder>
    <modelFolder>domain.entity</modelFolder>
    <serviceFolder>infrastructure.adapters.output.partenon</serviceFolder>
    <includeMapper>true</includeMapper>
    <serviceSuffix>Service</serviceSuffix>
    <serviceImplementInterface>false</serviceImplementInterface>
</targetFolderParameters>
```

In this case, we will generate the following structure:

    ├── infrastructure
    │    └── adapters
    │        └── output
    │            └── partenon
    │                │── TRXNameService.java
    │                │── mapper
    │                │   └── TRXNameMapper.java
    │                └── data
    │                    ├── InputTRX.java
    │                    └── OutputTRX.java
    └── domain
          └── entity
                ├── InputTRXRecord.java
                └── OutputTRXRecord.java

- These packages will be created from the base package defined in the `packageNameBase` property.
- The package 'infrastructure.adapters.output.partenon.data' contains the Partenon POJOs (InputTRX and OutputTRX) for each transaction.
- The package 'infrastructure.adapters.output.partenon' contains the service class (TRXNameService) that calls the Partenon transaction.
- The package 'infrastructure.adapters.output.partenon.mapper' contains the mapper class (TRXNameMapper) that transform from record to entity and vice-versa.
- The package 'domain.entity' contains the POJOs (InputTRXRecord and OutputTRXRecord) that represent the transaction records.

It is important to note that there are **few things that the plugin does not generate and must be added (even
previously)
manually**:

- The project **must include the Partenon Starter dependency** (
  `com.santander.framework.springboot:santander-spring-boot-starter-partenon`)
  in the pom.xml file.
- The project **must include and configure the Partenon connection properties** in the application.yml file.
