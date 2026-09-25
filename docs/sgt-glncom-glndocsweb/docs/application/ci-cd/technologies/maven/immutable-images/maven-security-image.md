# Devops workflows

## Security workflow (maven-security-image.yml)

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

* `SAST` Executes the reusable [Fortify SAST workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/main/.github/workflows/README_sast-fortify.md)
  to perform a SAST scan with Fortify and validate the quality gates.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--fortify-start-->"
   end="<!--fortify-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--fortify-start-->"
   end="<!--fortify-end-->"
!}

* `SCA:` Executes the reusable
  [The Sonatype SCA workflow](https://github.com/santander-group-shared-assets/gln-detect-asm-ssdlc-workflows/blob/develop/.github/workflows/README_sca-sonatype.md)
  to perform a Sonatype SCA scan and analyze third party components
  from a repository.

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonatype-start-->"
   end="<!--sonatype-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--sonatype-start-->"
   end="<!--sonatype-end-->"
!}

  See secrets [here](../../../organization-secrets.md#sonatype-secrets){:target="_blank"}

* `Send information to Elasticsearch:` Send data to elasticsearch related with
  SAST and SCA analysis.
