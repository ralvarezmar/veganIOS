# **Continuous Deployment (CD) - Release Management**

## **Introduction**

In this documentation regarding the new deployment model, we will explore the new approach we have for configuring both the deployment and registry infrastructure.
How to we can configure the `CD` and `CI` aspects for our projects in the repository. We will also examine the steps involved in a CD workflow with Helm.

Our new deployment model utilizes an `OAM (Open Application Model)` to manage both the deployment infrastructure and the registries infrastructure.
This single file replaces the previously separate `deployment.yml` and `multiregistry.json` files, consolidating all the necessary information into one place.

This approach simplifies the management and maintenance of our deployment and registry configurations, making it easier to understand and update as needed.

When deploying pre-releases images, (CI flow), the deployments will only go to certification environments automatically.
When using releases, the deployments will no longer be automatic and should be triggered from Release Management.

## **Summary**

This new deployment model allows us to efficiently manage our environments and registries, and facilitates the configuration of our repository for different environments.
By using an `OAM`, we can clearly define our environments and ensure that our deployments and uploads to the registries are done correctly.
