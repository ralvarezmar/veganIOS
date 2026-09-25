
# **Maven Release Image for Trunk Based development**

## **1. Introduction**

The purpose of this documentation is to have a step-by-step guide on how
the integration of Maven applications can be orchestrated in Gluon,
so that you can build and deploy each of our Maven components through a
CI/CD process.

Deployment will be done in Openshift with immutable image functionality.

## **2.What I need to start?**

First of all you have to create a repository from a GitHub `trunk-based` template
project.
There are different project templates that brings you the possibility of creation
an empty workflow ready to work, you can learn more about this in the
[Onboarding documentation](../../../../component-management/create-component.md)

## **3. How to use this workflows?**

We are using the Maven Release Image workflow for `Trunk Based` development.
This workflow is automatically triggered as soon as a new pre-release tag is created.

### **3.1 Creating a new pre-release tag**

After creating a new pre-release tag, this workflow will be called to check the quality
 and security of your code before send it to the desired pre/pro environments.
 It will automatically update your default branch (main/master) to the next
 release version to be launched.

### **3.2 Maven CD Image Workflow**

Here is the Maven CD Image workflow details:
[Maven CD Workflow](./maven-cd-image.md)
