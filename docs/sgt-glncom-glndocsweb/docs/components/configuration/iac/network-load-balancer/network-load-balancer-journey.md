# Network Load Balancer Journey

## Introduction

The purpose of this documentation is to provide a step-by-step guide on how to deploy a Network Load Balancer component on the GLUON platform, as well as explain the tools available on each Network Load Balancer component and how to use them.

!!! note
    This component can be used by any team member of an application, being that application allowed to deploy Network Load Balancer Components.

## What is Network Load Balancer?

A Network Load Balancer is a type of tool that is able distribute incoming network traffic across a group of backend servers or resources.

The IaC Network Load Balancer component was created for the teams that require to use a Network Load Balancer solution in AWS or Azure.

* Amazon Elastic Load Balancer: Elastic Load Balancer automatically distributes your incoming traffic across multiple targets, such as EC2 instances, containers, and IP addresses, in one or more Availability Zones.
It monitors the health of its registered targets, and routes traffic only to the healthy targets. Elastic Load Balancing scales your load balancer incoming traffic changes over time. It can automatically scale to the vast majority of workloads.

* Azure Load Balancer: Azure Load Balancer allows you to scale your applications and create high availability for your services. Load Balancer can be used for inbound as well as outbound scenarios and provides low latency,
high throughput, and scales up to millions of flows for all TCP and UDP applications. Standard Load Balancer is a new Load Balancer product for all TCP and UDP applications with an expanded and more granular feature set over Basic Load Balancer.
While there are many similarities, it is important to familiarize yourself with the differences as outlined in this article. The Load Balancer resource's functions are always expressed as a frontend, a rule, a health probe, and a backend pool definition.
A resource can contain multiple rules. Standard Load Balancer enables you to scale your applications and create high availability for small scale deployments to large and complex multi-zone architectures.

## How to create a Network Load Balancer component in Gluon

In order to create a new Network Load Balancer component in the Gluon platform, the next steps must be followed:

* Once logged in the Gluon portal, the first thing that needs to be done is to ensure that the **Company** that we're using is the one that wants to be used to deploy the Network Load Balancer Component:<br>
  ![company](./images/company.png)

* Now, select **Applications**, to see all the available applications within this company:<br>
  ![applications](./images/applications.png)

* Choose the desired application and select the **Components** option from the menu located on the left side of the screen:<br>
  ![components](./images/components.png)

* Click on **New Component**:<br>
  ![new-component](./images/new-component.png)

* Search for **Network Load Balancer** component and click on it:<br>
  ![network-load-balancer-component](./images/network-load-balancer.png)

* Fill the template and press **next** button: <br>
  ![networklb-template](./images/networklb-template.png)

* Fill the template with Branch Strategy **next** button: <br>
  ![networklb-template-branchstrategy](./images/networklb-template-branchstrategy.png)

* Click on 'next' again and in the following step, a summary of the component creation request will be shown. Once checked and if everything is correct, click on **Create Component**:<br>
  ![create-component](./images/create-component.png)

* We will see the component created in the **Component Page** and a pop-up will appear in the lower right corner of the screen stating that the component was successfully created (Automatic scaffolding workflow will be executed by automated bot):<br>
  ![componente-created](./images/component-created.png)

  * Scaffolding executed workflow:
  
    ![scaffolding-workflow](./images/scaffolding.png)

!!! warning
    Please, note that if Automatic scaffolding has not been triggered (bot execution), please, access to github icon and execute following actions.

    The new repository only contains an 'init-branch' that must be used by the 'Scaffolding' workflow to initialize the repository.

    This workflow must be manually started and wait for action execution:
      ![initialize-repo](./images/initialize-repo.png)

* When scaffolding workflow is successfully executed, status will be modified and changed to "Ready", Click on the Github icon to see the newly created repository for the Network Load Balancer component:<br>
  ![github-icon](./images/component-created-git.png)

* If we check the 'code' section of the repository, we will now see the 'main' and 'development' branch and the repository will be ready to be used.<br>
  ![repo-ready-main](./images/repo-ready-main.png)
  ![repo-ready-development](./images/repo-ready-development.png)

## Component configuration

Once the Network Load Balancer component repository has been created and initialized, some extra configurations must be done in order to make the Terraform workflows work in the newly created component.
For this, we must follow the step-by-step guide of the [Component Pre-requisites](../../../../application/iac/terraform-workflows/component-prerequisites.md) section.
The Network Load Balancer component does not need more configuration than the one described on this section.

In summary, the <u><strong>requirements</strong></u> in order to be able to use the Terraform Workflows in the Network Load Balancer component are:
<ul>
  <li><strong>To have set the PG_CREDENTIALS</strong> secret as organization secret in the newly created component repository. As these are organization secrets, it is very likely that the used organization already has them.
  Please check this before requesting them, since if they're already set, it is not needed to request the addition of these secrets again.
  <li><strong>To have set the IAC_CREDENTIALS_<code>environment</code></strong> secrets as repository secrets in the newly created component repository.
  This is always required, since here the information about the provider that wants to be used for deployment is set and this information is different for each application.
  <li><strong>To have set the Environments protection rules</strong> in the newly created component repository to be able to approve the workflows runs on that environment.
</ul>

!!! warning
    Please, note that if only the Azure part wants to be deployed, the secrets needed are only the Azure ones. This also applies to the AWS part. If both providers should be used, the secrets for both providers would be required.

## Parameters to create a Network Load Balancer resource

All the information about what parameters can be used to deploy a Network Load Balancer resource, how to use them or how to build a specific configuration are in the [Cloud Provider](./cloud-provider/index.md) section.
Here all the information about the parameters that can be used to deploy a Network Load Balancer resource can be found for both providers, Azure and AWS.

In addition to this, please note that all the tfvars files that must be updated to deploy Network Load Balancer resources are located in the '.gluon/cd/<code>environment</code>' path of the created Network Load Balancer component:<br>
![environments](./images/environments.png)

Where <code>environment</code> can be: 'dev', 'pre' or 'pro' and this will define the environment where the resource wants to be deployed.
So, in case that the deployment wants to be done on the 'dev' environment, the tfvar files that have to be updated are:
<ul>
<li><strong>.gluon/cd/dev/aws.auto.tfvars</strong> if the AWS provider wants to be used.
<li><strong>.gluon/cd/dev/az.auto.tfvars</strong> if the Azure provider wants to be used.
</ul>
![tfvars-location](./images/tfvars-location.png)

!!! info
    These tfvar files are created by default when the Network Load Balancer Component is created, and they always contain an example of the parameters needed to deploy a basic and default resource for that component and that provider.
    Most of the time, these examples do not work with the data included there. This data must always be replaced with the real data that should be used for the deployment that wants to be done.
    ![tfvars-example](./images/tfvars-example.png)

Also, in the 'config.yml' file of the environment that wants to be used, must be set the archetype version to be used to deploy the Network Load Balancer resources:

```yaml
netlb_arch_version: "v1.0.0"
```

or

```yaml
netlb_arch_version: "develop"
```

This file is created pointing to the latest version of the archetype by default, but this version can be changed in case this is not the version that wants to be used for the deployment.
If this file is deleted and is not present in the '.gluon/cd/<code>environment</code>' path, the archetype version to be used will also be the latest released version of the archetype.
In addition to this, a message will appear during the execution of the Terraform workflows to warn the user about this situation.

```yaml
"::warning :: netlb_arch_version is not provided in the config.yml file for certification environment then, main branch will be used. Please provide the netlb_arch_version in the config.yml file for selecting the specific version of the archetype."
```

## Available workflows

Once the component repository and the required configuration files have been properly set, the following Terraform workflows are available for each Network Load Balancer component:

* [Terraform Plan](../../../../application/iac/terraform-workflows/terraform-plan.md)
* [Terraform Apply](../../../../application/iac/terraform-workflows/terraform-apply.md)
* [Terraform Destroy](../../../../application/iac/terraform-workflows/terraform-destroy.md)
* [Terraform List](../../../../application/iac/terraform-workflows/terraform-list.md)
* [Terraform State Import](../../../../application/iac/terraform-workflows/terraform-state-import.md)
* [Terraform State Remove](../../../../application/iac/terraform-workflows/terraform-state-remove.md)

In the links listed above, can be found the input parameters required for each one, as well as all the information about how to use them.
