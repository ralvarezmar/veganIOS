
# **API Definition**

## **1. Introduction**

The purpose of this documentation is you to have a step-by-step guide on how
the integration of APIs applications can be orchestrated in Gluon,
so that you can build and deploy each of our API components through a
CI definition process.

Deployment will be done in Openshift with immutable image functionality

## **2. What I need to start?**

First of all you have to create a repository from GitHub template project.
There are different project templates that brings you the possibility of
creation an empty workflow ready to work, you can learn more about this in the
[Onboarding documentation](../../../../component-management/create-component.md){:target="_blank"}
.

## **3. How to use the API Definition workflows?**

Once you have created the empty repository from a template, you will have
several workflows ready to use, the first workflow that we going to use is the
Api Pre Release Definition with Api Quality Definition workflow.

### **3.1 Creating a pull request to hotfix/main/master**

There are two workflows that triggers when a pull request is created to
hotfix/main/master destination branches, the Api Quality Deployment workflow
and the Version Validation workflow.

#### **3.1.1 Version Validation**

Here is the Version Validation workflow details:

[Version Validation](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

#### **3.1.2 Api Quality Deployment Workflow**

Here is the Api Quality Definition workflow details:

[APIs Quality Definition](api-quality-definition.md){:target="_blank"}

### **3.2 Merging the pull request into hotfix/main/master branch**

When the PR pass all the quality checks and someone approves the PR the
api-pre-release-definition is triggered and executed in development branch,
at this point, the workflow creates a new tag and then publish the new version
to marketplace.

#### **3.2.1 Api Pre Release Definition Workflow**

[APIs Pre Release](api-pre-release.md){:target="_blank"}

### **3.3  Generating a new release, using CD Image**

When everything is merged and the api-pre-release-definition workflow
has succeeded, we will have generated a new release, when a new release
is created, it launches the api-release-definition workflow, this
workflow retrieves the release version and publish it to marketplace.

#### **3.3.1 Api Release Definition Workflow**

[APIs Release Definition](api-release-definition.md){:target="_blank"}
