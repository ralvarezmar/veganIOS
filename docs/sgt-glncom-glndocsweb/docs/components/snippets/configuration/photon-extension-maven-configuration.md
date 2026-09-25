### Branches
<!--Start Gitflow Branches-->
Gluon works with two branches that will need to be incorporated into our project:

- The main branch (main)
- The integration branch (development by default)

This applies in the case we previously selected Git-flow like our branching model then the workflows works with GitFlow strategy, so we need to have the integration branch to merge the feature branches and create the Pull Request to the main branch.
<!--End Gitflow Branches-->

### Configuration Files
<!--Start Configuration Files-->
- **properties.env**: Properties with the CI/CD configuration
<!--End Configuration Files-->
#### Properties
<!--Start Common Properties-->

The **properties.env** file contains the configuration for the CI/CD pipeline. It is generated automatically.
The parameters that are configured by default are:

| **Variable**        | **Required** | **Description** | **Example value**               |
|---------------------|--------------|-----------------|---------------------------------|
| **SONAR_PROJECT_KEY** | true         | Project key in Sonar | sgt-gluonad-probemicroframework |
| **FORTIFY_PROJECT** | true         | Project name in Fortify | sgt-gluonad-probemicroframework |
| **JAVA_VERSION** | true         | Java version to use | adoptopenjdk-17.0.8+7 |

???+ info "Naming convention"

    The project name in **Sonar** and **Fortify** must be the same as the component repository name. 
    To avoid possible errors, the **properties.env** file is generated with the necessary values for the variables **SONAR_PROJECT_KEY** and **FORTIFY_PROJECT**.
    
    Example values:

    SONAR_PROJECT_KEY="sgt-gluonad-probemicroframework"

    FORTIFY_PROJECT="sgt-gluonad-probemicroframework"

??? info "All the properties"

    {!
       include-markdown "**/application/ci-cd/**/maven/snippets/project-properties.md"
    !}
<!--End Common Properties-->

### Secrets Configuration
<!--Start Github Secrets-->

There are three types of secrets in Github.com

- **Organization secrets**: Secrets that can be used by all repositories in the organization
- **Repository secrets**: Secrets that can be used only by the repository
- **Environment secrets**: Secrets that can be used only by the repository and the environment.

???+ warning "Setup GitHub Secrets"

    Secrets are set up, managed and deployed with [the vault](../../../application/security/security-enablers/hashicorp-vault/journeys/developer/index.md).

#### Registry Secrets

Those credentials are referenced in the multiregistry.json file and defined at repository secrets level.

```json title="Simple multiregistry example" linenums="1" hl_lines="7 8"
[
{
    "registry-type": "harbor",
    "registry":   "registry.global.ccc.srvb.can.paas.cloudcenter.corp",
    "image":      "c3-alm-immutable-test/maven-micro-alonextgen",
    "usernameId": "REGISTRY_USERNAME",
    "passwordId": "REGISTRY_PASS"
}
]
```

#### Deploy Secrets

Those credentials are referenced in the **deployment.yaml** file and defined at **environment secrets level**, so we have to create the secrets in each environment (CERT,PRE and PRO).

- credentialsId
- credentialUserId
- credentialPassId
- kubeconfigFile

<!--End Github Secrets-->
