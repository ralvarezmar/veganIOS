
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

## **3. How to use the project CD workflows?**

We are using the Api CD workflow, this workflow brings to you the
possibility of use the all Continuous Delivery processes.
There are several ways to launch this process.

- Merging the pull request into hotfix/main branch
- Publish a release
- Standalone with the Api CD workflow dispatch

### **3.1 Merging the pull request into hotfix/main branch**

When the PR pass all the security checks and someone approves de PR the
Snapshot workflow is triggered and executed in hotfix/main branch.
When the Snapshot workflow is executed it launches api-cd-deployment
workflow for the purpose of deploying it in certification.

### **3.2 Publish a release**

When the release is published, is triggered Release workflow and executes
Api CD deployment workflow for the purpose of deploying it in
pre/production environment.

### **3.3 Standalone with the Api CD workflow dispatch**

You can run the Api CD workflow execution in an standalone
way directly launching the api-cd-deployment workflow.
You will be able to select your desired deployment environment.

### **3.4 Api CD workflow**

Here is the Api CD workflow details:
[Api CD workflow](./api-cd-deployment.md){:target="_blank"}
