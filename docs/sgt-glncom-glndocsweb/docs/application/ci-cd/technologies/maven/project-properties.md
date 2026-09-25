# Maven Properties

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

## Common properties

See common properties [here](../../common-project-properties.md){:target="_blank"}

## Sonar properties

| Property             | Required   | Description                         | Example       |
|----------------------|------------|-------------------------------------|---------------|
| SONAR_PROPERTIES     | false      | Sonar properties for Sonar analysis | '-Dsonar.coverage.jacoco.xmlReportPaths=target/jacoco.xml' |

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonar-start-->"
   end="<!--sonar-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--notapie-start-->"
   end="<!--notapie-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-int-start-->"
   end="<!--setupenvironment-int-end-->"
!}
