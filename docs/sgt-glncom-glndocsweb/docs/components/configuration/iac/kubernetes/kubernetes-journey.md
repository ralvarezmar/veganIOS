# Kubernetes cluster Journey

## Introduction

The purpose of this documentation is to provide a step-by-step guide on how to deploy a Kubernetes cluster component on the GLUON platform, as well as explain the tools available on each Kubernetes cluster component and how to use them.

!!! note
    This component can be used by any team member of an application, being that application allowed to deploy Kubernetes cluster Components.

## What is Kubernetes?

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation.
It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available.

Containers are a good way to bundle and run your applications. In a production environment, you need to manage the containers that run the applications and ensure that there is no downtime.
For example, if a container goes down, another container needs to start. Wouldn't it be easier if this behavior was handled by a system?

That's how Kubernetes comes to the rescue! Kubernetes provides you with a framework to run distributed systems resiliently. It takes care of scaling and failover for your application, provides deployment patterns, and more.
For example: Kubernetes can easily manage a canary deployment for your system.

The IaC Kubernetes cluster component was created for the teams that require to use a container solution in AWS or Azure.
This component allows the provisioning and configuration of the AWS and Azure Kubernetes service with full compliance with Cloud Security Control Framework.

## How to create a Kubernetes cluster component in Gluon

In order to create a new Kubernetes cluster component in the Gluon platform, the next steps must be followed:

* Once logged in the Gluon portal, the first thing that needs to be done is to ensure that the **Company** that we're using is the one that wants to be used to deploy the Kubernetes cluster Component: <br>
    ![company](./images/company.png)

* Now, select **Applications**, to see all the available applications within this company:<br>
    ![applications](./images/applications.png)

* Choose the desired application and select the **Components** option from the menu located on the left side of the screen:<br>
  ![components](./images/components.png)

* Click on **New Component**:<br>
  ![new-component](./images/new-component.png)

* Search for **Kubernetes cluster** component and click on it:<br>
  ![kubernetes-cluster](./images/kubernetes-cluster.png)

* Fill the template and press **next** button: <br>
  ![kubernetes-template](./images/kubernetes-template.png)

* Click on 'next' and select 'Git Flow' as 'Branch Strategy':
  ![git-flow](./images/git-flow.png)

* Click on 'next' again and in the following step, a summary of the component creation request will be shown. Once checked and if everything is correct, click on **Create Component**: <br>
  ![create-component](./images/create-component.png)

* We will see the component created in the **Component Page** and a pop-up will appear in the lower right corner of the screen stating that the component was successfully created: <br>
  ![componente-created](./images/componente-created.png)

* Click on the Github icon to see the newly created repository for the Kubernetes cluster component:<br>
  ![github-icon](./images/github-icon.png)

* The new repository only contains an 'init-branch' that must be used by the Scaffolding' workflow to initialize the repository: <br>
  ![init-branch](./images/init-branch.png)

This workflow should be automatically launched on create, but sometimes it gets stuck. So, click on the Github Actions executions to check this. If the workflow was not run, it can be manually started: <br>
  ![initialize-repo](./images/initialize-repo.png)

* Once the workflow execution is done, if we go back to the 'code' section of the repository, we will now see the 'main' branch and the repository will be ready to be used. <br>
  ![repo-ready](./images/repo-ready.png)

## Component configuration

Once the Kubernetes cluster component repository has been created and initialized, some extra configurations must be done in order to make the Terraform workflows work in the newly created component.
For this, we must follow the step-by-step guide of the [Component Pre-requisites](../../../../application/iac/terraform-workflows/component-prerequisites.md) section.
The Kubernetes cluster component does not need more configuration than the one described on this section.

In summary, the <u><strong>requirements</strong></u> in order to be able to use the Terraform Workflows in the Kubernetes cluster component are:
<ul>
  <li><strong>To have set the PG_CREDENTIALS</strong> secret as organization secret in the newly created component repository. As these are organization secrets, it is very likely that the used organization already has them.
  Please check this before requesting them, since if they're already set, it is not needed to request the addition of these secrets again.
  <li><strong>To have set the IAC_CREDENTIALS_<code>environment</code></strong> secrets as repository secrets in the newly created component repository.
  This is always required, since here the information about the provider that wants to be used for deployment is set and this information is different for each application.
  <li><strong>To have set the Environments protection rules</strong> in the newly created component repository to be able to approve the workflows runs on that environment.
</ul>

!!! warning
    Please, note that if only the Azure part wants to be deployed, the secrets needed are only the Azure ones. This also applies to the AWS part. If both providers should be used, the secrets for both providers would be required.

## Parameters to create a Kubernetes resource

All the information about what parameters can be used to deploy a Kubernetes resource, how to use them or how to build a specific configuration are in the [Cloud Provider](./cloud-provider/index.md) section.
Here all the information about the parameters that can be used to deploy a Kubernetes resource can be found for both providers, Azure and AWS.

In addition to this, please note that all the tfvars files that must be updated to deploy Kubernetes resources are located in the '.gluon/cd/<code>environment</code>' path of the created Kubernetes cluster component:<br>
![environments](./images/environments.png)

Where <code>environment</code> can be: 'dev', 'pre' or 'pro' and this will define the environment where the resource wants to be deployed.
So, in case that the deployment wants to be done on the 'dev' environment, the tfvar files that have to be updated are:
<ul>
<li><strong>.gluon/cd/dev/aws.auto.tfvars</strong> if the AWS provider wants to be used.
<li><strong>.gluon/cd/dev/az.auto.tfvars</strong> if the Azure provider wants to be used.
</ul>
![tfvars-location](./images/tfvars-location.png)

!!! info
    These tfvar files are created by default when the Kubernetes cluster Component is created, and they always contain an example of the parameters needed to deploy a basic and default resource for that component and that provider.
    Most of the time, these examples do not work with the data included there. This data must always be replaced with the real data that should be used for the deployment that wants to be done.
    ![tfvars-example](./images/tfvars-example.png)

Inside the environment folder the 'config.yml' file could be modify to specifie which is the kubernetes archetype version that is going to be used 'kubernetes_arch_version'.
Apart from that, it will be defined post configuration information like the version that is going to be used 'kubernetes_conf_version' and specific parameters for each resource. For more information about post configuration read this [page](./post-conf.md)

```yaml
kubernetes_arch_version: "v1.1.0"
kubernetes_conf_version: "v1.0.0"

resources:
  tfvars_key_1:
    flavour_name: aws_default
    flavour_params:
      # Cert
      cert_daemonset_image_init: <aws_account_id>.dkr.ecr.eu-west-1.amazonaws.com/ecr-public/docker/library/bash:latest
      cert_daemonset_image_pause: <aws_account_id>.dkr.ecr.eu-west-1.amazonaws.com/ecr-public/eks-distro/kubernetes/pause:v1.21.14-eks-1-21-18

      # Dynatrace
      dynatrace_set_host_group: "<dynatrace_host_group>"
      dynatrace_paas_token_secret: "<dynatrace_paas_token_secret_manager_name>"
      dynatrace_api_token_secret: "<dynatrace_api_token_secret_manager_name>"
      dynatrace_data_ingest_token_secret: "<dynatrace_data_ingest_token_secret_manager_name>"

      # Dashboard
      enable_standard_dashboard: true
      custom_dashboard_image: "<custom_dashboard_image_url>"
      custom_metrics_scraper_image: "<custom_metrics_scraper_image_url>"
```

!!! note
    'config.yml' file is created pointing to the latest version of the archetype by default, but this version can be changed in case this is not the version that wants to be used for the deployment.
    If this file is deleted and is not present in the '.gluon/cd/<code>environment</code>' path, the archetype version to be used will also be the latest released version of the archetype.
    In addition to this, a message will appear during the execution of the Terraform workflows to warn the user about this situation.

    ```yaml
    "::warning :: kubernetes_arch_version is not provided in the config.yml file for certification environment then, main branch will be used. Please provide the kubernetes_arch_version in the config.yml file for selecting the specific version of the archetype."
    ```

## Available workflows

Once the component repository and the required configuration files have been properly set, the following Terraform workflows are available for each Kubernetes Cluster component:

* [Terraform Plan](../../../../application/iac/terraform-workflows/terraform-plan.md)
* [Terraform Apply](../../../../application/iac/terraform-workflows/terraform-apply.md)
* [Terraform Destroy](../../../../application/iac/terraform-workflows/terraform-destroy.md)
* [Terraform List](../../../../application/iac/terraform-workflows/terraform-list.md)
* [Terraform State Import](../../../../application/iac/terraform-workflows/terraform-state-import.md)
* [Terraform State Remove](../../../../application/iac/terraform-workflows/terraform-state-remove.md)

In the links listed above, can be found the input parameters required for each one, as well as all the information about how to use them.
