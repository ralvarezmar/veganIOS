# Application Load Balancer Journey

## Introduction

The purpose of this documentation is to provide an step-by-step guide on how to deploy an Application Load Balancer component on the GLUON platform, as well as explain the tools available on each Application Load Balancer component and how to use them.

!!! note
    This component can be used by any team member of an application, being that application allowed to deploy Application Load Balancer Components.

## What is Application Load Balancer?

An Application Load Balancer is a type of tool that is able distribute incoming Application traffic across a group of backend servers or resources.

The IaC Application Load Balancer component was created for the teams that require to use an Application Load Balancer solution in AWS or Azure.

* Amazon Elastic Load Balancer: Elastic Load Balancer automatically distributes your incoming traffic across multiple targets, such as EC2 instances, containers, and IP addresses, in one or more Availability Zones.
It monitors the health of its registered targets, and routes traffic only to the healthy targets. Elastic Load Balancing scales your load balancer incoming traffic changes over time. It can automatically scale to the vast majority of workloads.

* Azure Application Gateway: AGW is a web traffic (OSI layer 7) load balancer that enables you to manage traffic to your web applications.
Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP) and route traffic based on source IP address and port, to a destination IP address and port.
Application Gateway can make routing decisions based on additional attributes of an HTTP request, for example URI path or host headers. For example, you can route traffic based on the incoming URL.

## How to create a Application Load Balancer component in Gluon

In order to create a new Application Load Balancer component in the Gluon platform, the next steps must be followed:

* Once logged in the Gluon portal, the first thing that needs to be done is to ensure that the **Company** that we're using is the one that wants to be used to deploy the Application Load Balancer Component:
  ![company](./images/company.png)

* Now, select **Applications**, to see all the available applications within this company: <br>

    ![applications](./images/applications.png)

* Choose the desired application and select the **Components** option from the menu located on the left side of the screen:<br>
  ![components](./images/components.png)

* Click on **New Component**:<br>
  ![new-component](./images/new-component.png)

* Search for **Application Load Balancer** component and click on it:<br>
  ![Application-load-balancer-component](./images/application-load-balancer.png)

* Fill the template and press **next** button: <br>
  ![applicationlb-template](./images/applicationlb-template.png)

* Fill the template with Branch Strategy **next** button: <br>
  ![Applicationlb-template-branchstrategy](./images/applicationlb-template-branchstrategy.png)

* Click on 'next' again and in the following step, a summary of the component creation request will be shown. Once checked and if everything is correct, click on **Create Component**: <br>
  ![create-component](./images/create-component.png)

* We will see the component created in the **Component Page** and a pop-up will appear in the lower right corner of the screen stating that the component was successfully created: <br>
  ![componente-created](./images/component-created.png)

* Click on the Github icon to see the newly created repository for the Application Load Balancer component:<br>
  ![github-icon](./images/github-icon.png)

* The new repository only contains an 'init-branch' that must be used by the 'Scaffolding' workflow to initialize the repository: <br>
  ![scaffolding-workflow](./images/scaffolding.png)

This workflow should be automatically launched on create, but sometimes it gets stuck. So, click on the Github Actions executions to check this. If the workflow was not run, it can be manually started: <br>
  ![initialize-repo](./images/initialize-repo.png)

* Once the workflow execution is done, if we go back to the 'code' section of the repository, we will now see the 'main' branch and the repository will be ready to be used. <br>
  ![repo-ready-main](./images/repo-ready-main.png)
  ![repo-ready-development](./images/repo-ready-development.png)

## Component configuration

Once the Application Load Balancer component repository has been created and initialized, some extra configurations must be done in order to make the Terraform workflows work in the newly created component.
For this, we must follow the step-by-step guide of the [Component Pre-requisites](../../../../application/iac/terraform-workflows/component-prerequisites.md) section.
The Application Load Balancer component does not need more configuration than the one described on this section.

In summary, the <u><strong>requirements</strong></u> in order to be able to use the Terraform Workflows in the Application Load Balancer component are:
<ul>
  <li><strong>To have set the PG_CREDENTIALS</strong> secret as organization secret in the newly created component repository. As these are organization secrets, it is very likely that the used organization already has them.
  Please check this before requesting them, since if they're already set, it is not needed to request the addition of these secrets again.
  <li><strong>To have set the IAC_CREDENTIALS_<code>environment</code></strong> secrets as repository secrets in the newly created component repository.
  This is always required, since here the information about the provider that wants to be used for deployment is set and this information is different for each application.
  <li><strong>To have set the Environments protection rules</strong> in the newly created component repository to be able to approve the workflows runs on that environment.
</ul>

!!! warning
    Please, note that if only the Azure part wants to be deployed, the secrets needed are only the Azure ones. This also applies to the AWS part. If both providers should be used, the secrets for both providers would be required.

## Parameters to create an Application Load Balancer resource

All the information about what parameters can be used to deploy an Application Load Balancer resource, how to use them or how to build a specific configuration are in the [Cloud Provider](./cloud-provider/index.md) section.
Here all the information about the parameters that can be used to deploy an Application Load Balancer resource can be found for both providers, Azure and AWS.

In addition to this, please note that all the tfvars files that must be updated to deploy Application Load Balancer resources are located in the '.gluon/cd/<code>environment</code>' path of the created Application Load Balancer component:<br>
![environments](./images/environments.png)

Where <code>environment</code> can be: 'dev', 'pre' or 'pro' and this will define the environment where the resource wants to be deployed.
So, in case that the deployment wants to be done on the 'dev' environment, the tfvar files that have to be updated are:
<ul>
<li><strong>.gluon/cd/dev/aws.auto.tfvars</strong> if the AWS provider wants to be used.
<li><strong>.gluon/cd/dev/az.auto.tfvars</strong> if the Azure provider wants to be used.
</ul>

![tfvars-location](./images/tfvars-location.png)

!!! info
    These tfvar files are created by default when the Application Load Balancer Component is created, and they always contain an example of the parameters needed to deploy a basic and default resource for that component and that provider.
    Most of the time, these examples do not work with the data included there. This data must always be replaced with the real data that should be used for the deployment that wants to be done.
    ![tfvars-example](./images/tfvars-example.png)

Also, in the 'config.yml' file of the environment that wants to be used, must be set the archetype version to be used to deploy the Application Load Balancer resources:

```yaml
applb_arch_version: "v1.0.0"
```

or

```yaml
applb_arch_version: "develop"
```

This file is created pointing to the latest version of the archetype by default, but this version can be changed in case this is not the version that wants to be used for the deployment.
If this file is deleted and is not present in the '.gluon/cd/<code>environment</code>' path, the archetype version to be used will also be the latest released version of the archetype.
In addition to this, a message will appear during the execution of the Terraform workflows to warn the user about this situation.

```yaml
"::warning :: applb_arch_version is not provided in the config.yml file for certification environment then, main branch will be used. Please provide the applb_arch_version in the config.yml file for selecting the specific version of the archetype."
```

## Available workflows

Once the component repository and the required configuration files have been properly set, the following Terraform workflows are available for each Application Load Balancer component:

* [Terraform Plan](../../../../application/iac/terraform-workflows/terraform-plan.md)
* [Terraform Apply](../../../../application/iac/terraform-workflows/terraform-apply.md)
* [Terraform Destroy](../../../../application/iac/terraform-workflows/terraform-destroy.md)
* [Terraform List](../../../../application/iac/terraform-workflows/terraform-list.md)
* [Terraform State Import](../../../../application/iac/terraform-workflows/terraform-state-import.md)
* [Terraform State Remove](../../../../application/iac/terraform-workflows/terraform-state-remove.md)

In the links listed above, can be found the input parameters required for each one, as well as all the information about how to use them.
