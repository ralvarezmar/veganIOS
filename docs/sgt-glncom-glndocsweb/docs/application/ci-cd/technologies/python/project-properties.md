# NPM Properties

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

## Common properties

See common properties [here](../../common-project-properties.md){:target="_blank"}

## Application distribution properties

<!--application-start-->

| Property                         | Required | Description                                            | Example    |
|----------------------------------|----------|--------------------------------------------------------|------------|
| NODE_VERSION                     | false    | Node version tu use                                    | '12.12.12' |
| NPM_APPLICATION_DIST_DIRECTORY   | false    | Application distribution folder                        | 'dist'     |
| NPM_APPLICATION_DIST_CONTENT     | false    | Content to include when the artifact is created        | '*'        |
| NPM_CONFIGURATION_DIST_DIRECTORY | false    | Configuration distribution folder                      | 'conf.d'   |
| NPM_CONFIGURATION_DIST_CONTENT   | false    | Content to include when the config artifact is created | '*'        |

<!--application-end-->

## Build properties

<!--build-start-->

| Property                 | Required   | Description           | Example        |
|--------------------------|------------|-----------------------|----------------|
| NODE_VERSION             | false      | Node version tu use   | '12.12.12'     |
| NPM_RUN_INSTALL_COMMAND  | false      | Npm install command   | 'npm install'  |
| NPM_RUN_BUILD_COMMAND    | false      | Npm build command     | 'npm run build'|
| NPM_RUN_AUDIT_COMMAND    | false      | Npm audit command     | 'npm audit'    |
| NPM_RUN_TEST_COMMAND     | false      | Npm test command      | 'npm test'     |

<!--build-end-->

## Library distribution properties

<!--library-start-->

| Property                         | Required | Description                                            | Example    |
|----------------------------------|----------|--------------------------------------------------------|------------|
| NODE_VERSION                     | false    | Node version tu use                                    | '12.12.12' |
| NPM_LIBRARY_DIRECTORY            | false    | Library distribution folder                            | '.'        |

<!--library-end-->

## Artifacts distribution properties

<!--artifacts-start-->

| Property                         | Required | Description                                            | Example    |
|----------------------------------|----------|--------------------------------------------------------|------------|
| NODE_VERSION                     | false    | Node version tu use                                    | '12.12.12' |
| NPM_APPLICATION_GROUP            | false    | Group in Nexus repository where the artifacts are pushed  | 'groupName'     |

<!--artifacts-end-->

## Sonar properties

<!--sonarnpm-start-->

| Property             | Required   | Description                         | Example       |
|----------------------|------------|-------------------------------------|---------------|
| NPM_SONAR_PROPERTIES | false      | Sonar properties for Sonar analysis | '-Dsonar.sources=src' |

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--sonar-start-->"
   end="<!--sonar-end-->"
!}

<!--sonarnpm-end-->

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
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--notapie-start-->"
   end="<!--notapie-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--setupenvironment-int-start-->"
   end="<!--setupenvironment-int-end-->"
!}

{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--zero-touch-start-->"
   end="<!--zero-touch-end-->"
!}
