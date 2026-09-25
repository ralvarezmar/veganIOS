# Gluon Darwin Code Analysis Maven-Plugin ![1.0.0](https://img.shields.io/badge/1.0.0-FF073D)

## Introduction

This project is a code analysis tool that uses the ArchUnit library to check the code quality of a project.

## Goals

It has only one goal:

- **arch-test**: This goal checks the code quality of the project.

More details about the goals can be found in the [Usage](#usage) section.

## Installation & Configuration

It's installed by default in the Darwin Microservices and Darwin Libraries but if you want to use it in another project, you can add the following configuration to the _pom.xml_ file:

```xml
<build>
    <plugins>
      <plugin>
        <groupId>com.santander.gluon.plugins</groupId>
        <artifactId>darwin-code-analysis-plugin</artifactId>
        <executions>
          <execution>
            <phase>test</phase>
            <goals>
              <goal>arch-test</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
</build>
```

The configuration property of the darwin-code-analysis-plugin plugin is defined inside the `<configuration>` tag in the pom.xml file.
Here are the properties that can be configured:

| Property | Required | Description     | Default value |
|:---------|----------|:----------------|:--------------|
| **skip** | false    | Skip execution. | false         |

## Usage

To run the plugin, you need to execute the following command:

```shell
mvn com.santander.gluon.plugins:darwin-code-analysis-plugin:arch-test
```

This executes [rules](#rules) to check the code quality of the project.

## Rules

The rules that are executed are the following:

### ParentArchRule

This rule checks if the parent project is one of the following:

- com.santander.darwin:darwin-spring-boot-starter-parent
- com.santander.darwin:darwin-spring-boot-dependencies
