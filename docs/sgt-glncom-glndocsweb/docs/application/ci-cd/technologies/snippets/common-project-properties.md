<!--description-start-->

Below are the properties that the user must or can set up in the
**`envs/properties.env`** file within their GitHub project. These properties
are necessary for the execution of some jobs.

<!--description-end-->

<!--general-start-->

`General properties`

| Property    | Required   | Description            | default      | Example       |
|-------------|------------|------------------------|---------------|---------------|
| QG_ENABLED  | false      | With this user parameter we can enable or disable 'Sonar','Fortify' and 'Sonatype' jobs execution and restrict the next job execution,in CI workflows. So depending on the value: -High: Run all blocking. -None: Runs all without blocking. -Empty: Don´t run the jobs. By default the parameter isn't defined so the value is empty | - | QG_ENABLED='None' |

<!--general-end-->

<!--deployment-start-->

`Deployment properties`

| Property    | Required   | Description            | default      | Example |
|-------------|------------|------------------------|---------------|---------------|
| DEPLOYMENT_YAML | false | File name of the file with the deployment configuration | deployment.yaml | 'deployment.yaml' |
| CERT_DEPLOYMENT | false | Environment name to be deployed in Certification | cert | 'cert' |
| PRE_DEPLOYMENT | false | Environment name to be deployed in Preproduction | pre | 'pre' |
| PRO_DEPLOYMENT | false | Environment name to be deployed in Production | pro | 'pro' |
| IMAGE_DEPLOY_TYPE | false | Deployment type for immutable workflows. See the types supported by the action 'https://github.com/santander-group-shared-assets/gln-alm-deployment-manager-action' | 'helm' |

<!--deployment-end-->

<!--container-start-->

`Container properties`

(only for immutable workflows)

| Property    | Required   | Description            | default      | Example       |
|-------------|------------|------------------------|---------------|---------------|
| CONTAINER_BUILD_ARGUMENTS   | false       | Arguments to apply to the 'build' command | - | '--build-arg IMAGE_TARGET_VERSION=${TAG_VERSION}' |
| DOCKER_BUILD_ARGUMENTS      | false       | Arguments to apply to the 'build' command (deprecated) | - | '--build-arg IMAGE_TARGET_VERSION=${TAG_VERSION}' |

<!--container-end-->

<!--fortify-start-->

`Fortify properties`

| Property             | Required   | Description            | default      | Example       |
|----------------------|------------|------------------------|---------------|---------------|
| FORTIFY_PROJECT      | true       | Project name created on Fortify SSC  | -  | 'project1'  |
| FORTIFY_TIMEOUT      | false      | Timeout for the workflow execution   | 15 | 20          |

<!--fortify-end-->

<!--sonatype-start-->

<!--sonatype-end-->

<!--sonar-start-->

`Sonar properties`

| Property             | Required   | Description                        | default      | Example       |
|----------------------|------------|------------------------------------|---------------|---------------|
| SONAR_ID             | false       | Sonar instance name                | 'SONAR_GLUON_COMMUNITY' | 'SONAR_GLUON_COMMUNITY' |
| SONAR_PROJECT_KEY    | true       | Project key that's created in the sonar instance | - | "sgt-app360-example1" |
| SONAR_REPORT_PATH    | false      | Location where the scanner writes the report-task.txt  | depends on thecnology | 'target/site' |
| SONAR_TIMEOUT        | false      | Timeout for the workflow execution | 15 | 15 |
| SONAR_MEMORY_PROPERTIES | false   | Memory properties                  | - | '-Xmx256m' |
| SONAR_PROPERTIES     | false      | Sonar properties for Sonar analysis | '-Dsonar.coverage.jacoco.xmlReportPaths=target/jacoco.xml' |

<!--sonar-end-->

<!--helm-start-->

(only for immutable workflows and IMAGE_DEPLOY_TYPE=='helm')

| Property             | Required   | Description            | Example |
|----------------------|------------|------------------------|---------------|
| HELM_CHART_PATH      | false | Path to Chart.yaml file. If it's not set, the Chart.yaml is found in the workspace | - |
| HELM_PLACEHOLDER     | false | List of place holders to replace in Chart.yaml and values.json. Multiline string. | '> key1=value1 key2=value2 key3=value3' |
| HELM_PACKAGE         | false | Indicates whether the workflow has to package a local helm chart and push to registry | 'true' |
| HELM_PACKAGE_ARGUMENTS | false | Arguments to apply to the 'package' command | - |
| HELM_LINT_ARGUMENTS    | false | Arguments to apply to the 'lint' command | - |

<!--helm-end-->

<!--zero-touch-start-->

`Zero-touch properties`

| Property                 | Required   | Description                    | Example        |
|--------------------------|------------|--------------------------------|----------------|
| ZERO_TOUCH_ENABLE        | false      | Zero-touch enabled or disabled | true           |

<!--zero-touch-end-->

<!--testing-start-->

`Testing properties`

| Property                 | Required   | Description                    | Example        |
|--------------------------|------------|--------------------------------|----------------|
| TESTING_ORGANIZATION     | false      | Name of the git organization where the testing component is located. If it's not set, the same organization of the component will be used. | git-organization-name |
| TESTING_REPOSITORY     | false      | Name of the git repository where the testing component is located. If it's not set, the test execution will use configuration created on [Testing Portal](../../../qatesting/testing/portal/testing-portal/cicd.md). | git-repository-name           |
| TESTING_BRANCH     | false      | Name of the branch or tag for the testing component repository.| git-ref-name           |

<!--testing-end-->
