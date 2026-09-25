
# **API Deployment**

## **1. Introduction**

The purpose of this documentation is you to have a step-by-step guide on how
the integration of APIs applications can be orchestrated in Gluon,
so that you can build and deploy each of our API components through a
CI/CD process.

Deployment will be done in ApiGee or IBM Apiconnect

## **2. What I need to start?**

First of all you have to create a repository from GitHub template project.
There are different project templates that brings you the possibility of
creation an empty workflow ready to work, you can learn more about this in the
[Onboarding documentation](../../../../component-management/create-component.md){:target="_blank"}

## **3. How to use the API Deployment workflows?**

Once you have created the empty repository from a template, you will have
several workflows ready to use, the first workflow that we are going to use is the
Api Snapshot Deployment workflow.

### **3.1 Creating a pull request to hotfix/main/master**

There are two workflows that triggers when a pull request is created to
hotfix/main/master destination branches, the Api Quality Deployment workflow
and the Version Validation workflow.

#### **3.1.1 Version Validation**

Here is the Version Validation workflow details:

[Version Validation](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

#### **3.1.2 Api Quality Deployment Workflow**

Here is the Api Quality Deployment workflow details:

[APIs Quality Deployment](./api-quality-deployment.md){:target="_blank"}

### **3.2 Merging the pull request into hotfix/main/master branch**

When the PR pass all the quality checks and someone approves the PR the
api-snapshot-deployment is triggered, at this point,
the workflow creates a new tag, a draft release, and then deploys the new version.

#### **3.2.1 Api Snapshot Deployment Workflow**

[APIs Snapshot](./api-snapshot-deployment.md){:target="_blank"}

### **3.3  Generating a new release, using draft release**

When draft release is published and the api-snapshot-deployment workflow
has succeeded, we will have generated a new release, when a new release
is created, it launches the api-release-deployment workflow, this
workflow retrieves the release version and deploy to pre/production
environments.

#### **3.3.1 Api Release Deployment Workflow**

[APIs Release Deployment](./api-release-deployment.md){:target="_blank"}
