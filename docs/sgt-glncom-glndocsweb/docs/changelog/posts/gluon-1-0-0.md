---
title: Gluon 1.0 Release Notes
categories:
  - Management
  - Back
  - APIs
  - Software CICD
  - SDLC Tools
date:
  created: 2023-07-19
tags:
  - Feature
---

## Release Notes

19^th^ July 2023

The Gluon platform's 1.0 release introduces several key features aimed at providing users with enhanced capabilities to manage users and applications while also providing tools to streamline the full lifecycle development of APIs and microservices.

## Features included

### Gluon Developer Portal

Gluon provides a multi-company Developer Portal that will allow users to access all Gluon capacities for creating application components, navigate component catalogue, onboard new users,
manage team members and roles, view application information, watch global news and user notifications.

#### Technical Requirements

Network connection to Portal infrastructure.

#### Non-Technical Requirements

Users must have been created in in Global IAM in order to log in into the Portal.

### Application Onboarding

Allows Company owners onboard an application and define the application Owners (who will be allowed to manage access to the application assets). An ALMNextGen workspace (Jira project, Confluence Space and github.com  Team) will be created for each application.

#### Technical Requirements

Use Global ServiceNow APM.  

#### Non-Technical Requirements

Application must be already created as a Technical Application in ServiceNow APM.  

### Application Management

Allows application owners to manage  application team membership and components.

#### Technical Requirements

N/A

#### Non-Technical Requirements

N/A

### Application Team User Management

Company and Application owners can add/update/search/delete Global IAM users to Gluon. Users will have Jira SaaS, Confluence SaaS and github.com licenses when they belong to the first team.

#### Technical Requirements

N/A

#### Non-Technical Requirements

Users already exists in Global IAM.

### Darwin Microservice Component

To improve the development process of Darwin Springboot online microservices components Gluon enables the creation of a Gluon component based on a GitHub repository, and sonar project, and incorporating security tools like SCA (Sonatype) and SAST (Fortify).

#### Technical Requirements

- Openshift/Kubernetes as target deployment cloud.
- Available instance of PKM and STS.
- github.com organization global runners.
- A Harbor project is needed to store microservices docker images.
- Network connection between CI runners and Harbor installation is needed.
- Network connection between CI runners and Global Sonarqube, Global Fortify and Global Nexus.
- Network connection between CI runners and Openshift/Kubernetes target clusters.

#### Non-Technical Requirements

- Deployment Credentials for Openshift/Kubernetes access for deployment automations.
- Harbor image registries credentials to upload images.

### Arsenal Microservice Component

To improve the development process of Arsenal Springboot online microservices components Gluon enables the creation of a Gluon component based on a GitHub repository, and sonar project, and incorporating security tools like SCA (Sonatype) and SAST (Fortify).

#### Technical Requirements

- Openshift/Kubernetes as target deployment cloud.
- ¿Security requirements?
- Github.com organization global runners.
- A Openshift/Jfrog instance is needed to store microservices docker images.
- Network connection between CI runners and Openshift/Jfrog installation is needed.
- Network connection between CI runners and Global Sonarqube, Global Fortify and Global Nexus.
- Network connection between CI runners and Openshift/Kubernetes target clusters.
- Non-Technical Requirements
- Deployment Credentials for Openshift/Kubernetes access for deployment automations.
- Openshift/Jfrog image registries credentials to upload images.

### Application Configuration and Secrets Management

In order to manage application components configuration and secrets, Gluon provides a Configuration component and Secret component that allows users to manage their lifecycle as any other component.
Entities production team will be allowed to set repository secrets. Secrets will be deployed as kubernetes secrets. Configurations will be deployed as configmaps.

#### Technical Requirements

- Openshift/Kubernetes as target deployment cloud.
- Github.com organization global runners.
- Network connection between CI runners and Openshift/Kubernetes target clusters.

#### Non-Technical Requirements

- Deployment Credentials for Openshift/Kubernetes access for deployment automations.

### API Catalogue

Global API Catalogue including API versions definition details, use cases virtualization and deployment instances. Allow consumers to consume API virtualization and subscription.

#### Technical Requirements

N/A

#### Non-Technical Requirements

N/A

### APIs Definition

API definition governance workflow, allowing users to propose new API definitions to be added in Gluon catalogue.
API definitions will be managed as code as an innersource model, ensuring API quality assurance (Standards and patterns / Dictionary terms) and DAF approval before being automatically published in Gluon Catalogue.
Users will be able to define use cases along with API definition to enrich service virtualization for consumers.

#### Technical Requirements

N/A

#### Non-Technical Requirements

N/A

### APIs Deployment Component

Gluon allows to deploy an API definition from Gluon Catalogue to an entity API Manager Gateway.
Through deployment configuration as code a Product Team will be able to set deployment target and properties and manage the full SDLC in their API Manager (API Connect v10. and Apigee OPDK)

#### Technical Requirements

- Only IBM APIConnect v10 and APIgee OPDK v4.52 (recommended) API Managers are supported by deployment automations and must be available previously in target company.
- Github.com organization global runners.
- Network connection between CI runners and API Manager infrastructure.

#### Non-Technical Requirements

- Target API Manager credentials to deploy APIs.

### API Subscription

Gluon will provide API consumers the capability to subscribe to API deployment instances. Consumer application credentials will be managed by Gluon. API Managers consumer applications management will be provided by Gluon.

Consumer credentials will be stored in the github repository of the consumer application selected by the user, so they have the capability to deploy the secret to the related environment.

#### Technical Requirements

- SOS instance available.
- ¿Brazil credentials management?
- Network connection between Gluon and SOS instance.
- Network connection between Gluon and API Manager infrastructure.

#### Non-Technical Requirements

- At an entity level we require API Manager credentials to manage consumer applications and subscriptions.
- At an entity level we require SOS credentials to manage consumer applications credentials.

### Gluon Community

Promote the knowledge and mutual collaboration on the Gluon ecosystem to facilitate its adoption and optimize its use.
Establish Gluon as the strategic solution within the Santander Group, through fostering a collaborative and knowledgeable. Gluon user documentation and training.

#### Technical Requirements

N/A

#### Non-Technical Requirements

N/A
