---
title: Xray report action
hide:
  - toc
---

> **_NOTE:_** Only Nitro and TalosBDD can report to Xray for now

## **Pre-requisites**

We need the following:

* Xray already configured in the Jira project associated, with the Gluon Application of the component we want to report the execution of tests.
* The credentials to report, client id and secret.
* All tests in the feature files have the Xray tags.

## **Report execution results to Xray**

When running test through workflows, we can report the execution results directly to Xray. For this, we need to enable the report in the configuration files found in the ".testingConfig" folder of the testing project.

We must also have the credentials to report to Xray, client id and client secret set as secrets with the following names:
XRAY_CLIENT_ID and XRAY_CLIENT_SECRET ([See how to create a new secret](../../../../ci-cd/howtos/index.md#2-secrets-in-githubcom)).
The user associated to this pair of credentials needs to have granted access to the project where we want to report in.
This secrets can be, at organization level if the entity have a service user to report in all projects, or at repository level if the application team have a user to report in its own Jira project.

This action will first retrieve all the features files of the project, given they are in "src/test/resources/features" for Nitro or "test/features" for TalosBDD.
It will put them into a Zip file and send them to Xray to update all tests.
While this step does not need the feature files to have the Xray test reference on each test to be reported, the next step does so make sure all tests have the associated Xray tag before trying to report.

Then, it will send the test results to Xray for the Test Execution to be created and associated to the corresponding tests.
Only tests who have the Xray tags will be reported. If no valid tests are found the step will fail and the execution will be marked as failed.

``` yaml title=".testingConfig/ondemand/global.yml" linenums="15"
report:
  ...
  #The following secrets are mandatory: XRAY_CLIENT_ID, XRAY_CLIENT_SECRET
  #The host is not required because this is the default value, and this line can be deleted if the user wants
  xray:
    enabled: true
    host: https://xray.cloud.getxray.app
    projectKey: # Optional, overrides the project set in Gluon
    labels: [] # List of labels to be set to each execution separated by commas
    testPlanKey: # The Test Plan Key, must be already created
```
