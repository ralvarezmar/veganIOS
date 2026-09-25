# Devops workflows

## Quality gate (maven-quality-image.yml)

This workflow is executed when a pull request is created to merge
a change to these target branches:

* development
* develop
* master
* main

### Requirements

The GitHub runner must have:

* Maven with required version for the application.
* JDK with required version for the application.
* JDK 11 and according Node version required for Sonar (default 16).
* Tools: asdf, jq, yq, curl, unzip
* Connectivity to the different tools

### Jobs

All the jobs described clones the project repository when starts the execution
and reads the properties from `Setup environment variables` job output, the
repository itself and resources necessaries to the proper workflow execution.

* `Setup environment variables:` Load the properties defined in
  `properties.env` file and in the `configuration project`. The configuration
  project is obtained according to the secrets defined.

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-start-->"
   end="<!--setupenvironment-end-->"
!}

  Generate a json file with all properties (param=value).

* `Maven build & Sonar scan:` Executes the default commands of MAVEN_BUILD_GOAL
  variable. If you want overwrite the maven command you can configure in
  `properties.env`.

{!
   include-markdown "**/ci-cd/technologies/maven/snippets/project-properties.md"
   start="<!--build-sonar-start-->"
   end="<!--build-sonar-end-->"
!}
