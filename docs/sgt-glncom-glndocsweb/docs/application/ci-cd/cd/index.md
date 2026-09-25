
# **Continuous Delivery Workflows (CD)**

## **1. Introduction**

The purpose of this documentation is to have a step-by-step guide on how
the deployment of applications can be orchestrated in Gluon,
so that you can deploy each of our available components through a
CD process.

Deployment will be done by the CD workflows.

## **2. How to use the project CD workflows?**

These workflows are called after using [CI Workflows](./../ci/index.md) after using
those workflows you will have a built component ready to deploy using the
CD Workflows.

## **3. How to use the project CD workflows?**

We are using the Maven CD Image workflow; this workflow brings you the
possibility to use the all Continuous Delivery processes.
There are several ways to launch this process.

- Merging the pull request into production branch
- Merging the pull request into development branch
- Standalone with the Maven CD Image workflow dispatch

## **4. Available CD deployments**

Here are the available type of deployments according to specific
technology:

- OpenShift: We can see the appropriate action with all configurations needed
[here](https://github.com/santander-group-shared-assets/gln-openshift-deploy-action).
- Helm: We can see the appropriate action with all configurations needed
[here](https://github.com/santander-group-shared-assets/gln-helm-deploy-action).
- Ansible: We can see the appropriate action with all configurations needed
[here](https://github.com/santander-group-shared-assets/gln-alm-ansible-deploy-action).
- Api Connect: We can see the appropriate action with all configurations needed
[here](https://github.com/santander-group-shared-assets/gln-apiconnect-deploy-ansible-scripts).

## CD Release Management

- [CD Release Management](cd-rm/index.md)
