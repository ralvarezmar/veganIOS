
# **NPM Applications Immutables**

## **1. Introduction**

The purpose of this documentation is to have a step-by-step guide on how
the integration of NPM applications can be orchestrated in Gluon,
so that you can build and deploy each of our NPM components through a
CD process.

Deployment will be done in Openshift with immutable image functionality.

## **2. What I need to start?**

First of all you have built and image ready to be deployed using the [NPM CD Workflow](./npm-cd-image.md){:target="_blank"}
If you would like to create a new repository from zero you can learn more about
this in the [Onboarding documentation](../../../../component-management/create-component.md){:target="_blank"}

## **3. How to use the project CD workflows?**

We are using the NPM CD Image workflow, this workflow brings to you the
possibility of use the all Continuous Delivery processes.
There are several ways to launch this process.

- Merging the pull request into development branch
- Merging the pull request into main branch
- Standalone with the NPM CD Image workflow dispatch

### **3.1 Merging the pull request into development branch**

When the PR pass all the security and quality checks and someone approves de PR the
NPM CD Image workflow is triggered and executed in development branch
for the purpose of deploying it in dev.

- [NPM SECURITY WORKFLOW](./npm-security-image.md){:target="_blank"}

- [NPM QUALITY WORKFLOW](./npm-quality-image.md){:target="_blank"}

- [NPM SNAPSHOT WORKFLOW](./npm-snapshot-image.md){:target="_blank"}

- [VERSION VALIDATION](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

### **3.2 Merging the pull request into main branch**

When the PR pass all the security and quality checks and someone approves de PR the
NPM RC Image workflow is triggered and executed in the development branch.
When the NPM RC Image workflow is executed it launches
NPM CD Image workflow for the purpose of deploying it in pre, generates
the release in the project and deploys the release in production environment.

- [NPM SECURITY WORKFLOW](./npm-security-image.md){:target="_blank"}

- [NPM QUALITY WORKFLOW](./npm-quality-image.md){:target="_blank"}

- [NPM RELEASE WORKFLOW](./npm-release-image.md){:target="_blank"}
  
- [VERSION VALIDATION](./../../../../../application/ci-cd/technologies/common/version-validation.md){:target="_blank"}

### **3.3 Standalone with the NPM CD Image workflow dispatch execution**

You can run the NPM CD Image workflow execution in an standalone
way directly launching the NPM CD Image dispatch workflow.
You will be able to select your desired deployment environment.

- [NPM CD WORKFLOW](./npm-cd-image.md){:target="_blank"}
