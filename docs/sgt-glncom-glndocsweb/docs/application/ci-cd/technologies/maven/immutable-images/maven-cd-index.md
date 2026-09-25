
# **Maven Applications Immutables**

## **1. Introduction**

The purpose of this documentation is to have a step-by-step guide on how
the integration of Maven applications can be orchestrated in Gluon,
so that you can build and deploy each of our Maven components through a
CI/CD process.

Deployment will be done in Openshift with immutable image functionality.

## **2. What I need to start?**

First of all you have, after using [Maven CI Workflow](./maven-ci-image.md){:target="_blank"}
, a built image ready to be deployed using the [Maven CD Workflow](./maven-cd-image.md){:target="_blank"}
If you would like to create a new repository from zero you can learn more about
this in the [Onboarding documentation](../../../../component-management/create-component.md){:target="_blank"}

## **3. How to use the project CD workflows?**

We are using the Maven CD Image workflow, this workflow brings to you the
possibility of use the all Continuous Delivery processes.
There are several ways to launch this process.

- Merging the pull request into development branch
- Merging the pull request into main branch
- Standalone with the Maven CD Image workflow dispatch

### **3.1 Merging the pull request into development branch**

When the PR pass all the security checks and someone approves de PR the
Maven CI Image workflow is triggered and executed in development branch.
When the Maven CI Image workflow is executed it launches Maven CD Image
workflow for the purpose of deploying it in dev.

### **3.2 Merging the pull request into main branch**

When the PR pass all the security checks and someone approves de PR the
Maven RC Image workflow is triggered and executed in the development branch.
When the Maven RC Image workflow is executed it launches
Maven CD Image workflow for the purpose of deploying it in pre, generates
the release in the project and deploys the release in production environment.

### **3.3 Standalone with the Maven CD Image workflow dispatch execution**

You can run the Maven CD Image workflow execution in an standalone
way directly launching the Maven CD Image dispatch workflow.
You will be able to select your desired deployment environment.

### **3.4 Maven CD Image Workflow**

Here is the Maven CD Image workflow details:
[Maven CD Workflow](./maven-cd-image.md){:target="_blank"}
