# **Maven Applications Immutables**

## **1. Introduction**

The purpose of this documentation is you to have a step-by-step guide on how
the integration of Maven applications can be orchestrated in ALM,
so that you can build and deploy each of our Maven components through a
CI/CD process.

Deployment will be done in Openshift with immutable image functionality

## **2. What I need to start?**

First of all you have to create a repository from GitHub template project.
There are different project templates that brings you the possibility of creation
an empty workflow ready to work, you can learn more about this in the
[Onboarding documentation](../../../../component-management/create-component.md)

## **3. How to use the project Snapshot Trunk-based workflows?**

Once you have created the empty repository from a trunk-based template,
you will have several workflows ready to use, the first workflow
that we going to use is the Maven Snapshot Image Trunk-based workflow.

### **3.1 Pushing changes to main/master branch, using Maven Snapshot Image Trunk-based**

This workflow is triggered/activated when a change is made/pushed in
main or master branches.
When this workflow is triggered it runs the Maven build, Container build and push,
Deploy in development environment and create a tag and draft-release on github.
