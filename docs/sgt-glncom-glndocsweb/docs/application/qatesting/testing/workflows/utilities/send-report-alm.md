---
title: Send report to HP-ALM
hide:
  - toc
---

## **Pre-requisites**

We need the following:

* HP-ALM Instance
* The credentials to report in HP-ALM
* Domain and project created in HP-ALM

## **Report execution results to HP-ALM**

When running tests through workflows, exists the possibility of sending the test results and report to HP-ALM. The data required for sending the report and the test results must be configured in the test configuration files found in
the .testingConfig folder of the testing project.

Additionally, the HP-ALM host where the report is sent should be set as GitHub organization variable with the name GLUON_TESTING_HP_ALM_HOST.
This info is treated as the same way the CICD variables, see [here](../../../../ci-cd/organization-properties.md), that are managed by Gluon Operations Team.

The credentialsAnd the HP-ALM username and password should be set as GitHub secret with the following names:
GLUON_TESTING_HP_ALM_USER and GLUON_TESTING_HP_ALM_PASS (See [how to create a new secret](../../../../ci-cd/howtos/index.md#2-secrets-in-githubcom)).
This info is treated as the same way the CICD secrets, see [here](../../../../ci-cd/organization-secrets.md), that are managed by Gluon Operations Team.

To use this functionality, connectivity must be ensured between the cluster where the ephemeral runner is located
and the HP-ALM host.

The following elements apply to both files, **.testingConfig/ondemand/global.yml** and **.testingConfig/cicd/global.yml**:

``` yaml title=".testingConfig/ondemand/global.yml" linenums="1"
report:
  #The following secrets are mandatory: GLUON_TESTING_HP_ALM_USER and GLUON_TESTING_HP_ALM_PASS.
  #The following variables are mandatory: GLUON_TESTING_HP_ALM_HOST.
  #The following fields are mandatory: enabled, domain and project.
  hpAlm:
    enabled: true
    domain: # ALM Domain
    project: # ALM Project
    qcApplication: # Qc Application, by default is default
    reportLevel: # Report Level, by default is Default
    prefix: #Folder path prefix to the report is saved, by default this value is empty
```
