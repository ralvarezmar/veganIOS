{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

<!--build-sonar-start-->

`Maven properties`

| Property                   | Required | Description          | default      | Example       |
|----------------------------|----------|----------------------|---------------|---------------|
| MAVEN_VERSION              | false    | Maven version used   | 3.8.1         | '3.8.1' |
| MAVEN_BUILD_GOAL           | false    | Maven goal used      | clean verify  | 'clean verify'  |

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonar-start-->"
   end="<!--sonar-end-->"
!}

<!--build-sonar-end-->

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--fortify-start-->"
   end="<!--fortify-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonatype-start-->"
   end="<!--sonatype-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--container-start-->"
   end="<!--container-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--deployment-start-->"
   end="<!--deployment-end-->"
!}

<!--other-start-->

`Others properties`

| Property                   | Required | Description          | default      | Example       |
|----------------------------|----------|----------------------|---------------|---------------|
| JAVA_VERSION               | false    | Java version used    | adoptopenjdk-8.0.292+10 | 'adoptopenjdk-17.0.7+7'  |

<!--other-end-->

Example:
=== "properties.env"

    ```properties
    # Sonar parameters
    SONAR_ID="SONAR_GLUON_COMMUNITY"
    SONAR_PROJECT_KEY="sgt-app360-example1"

    # Java version(optional)
    JAVA_VERSION="adoptopenjdk-17.0.7+7"

    # Fortify parameters
    FORTIFY_PROJECT="Test_ALM_NextGen_jdk8"

    # Sonatype parameters(optional)
    SONATYPE_JAVA_VERSION="adoptopenjdk-17.0.7+7"

    # Deploy(optional)
    IMAGE_DEPLOY_TYPE='helm'

    ```
