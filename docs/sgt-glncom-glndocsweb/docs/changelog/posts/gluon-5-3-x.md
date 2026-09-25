---
title: Gluon 5.3 Release Notes
categories:
  - Release
  - Documentation
  - Management
  - SDLC Tools
  - Software CICD
  - Release
  - APIs
  - Events
  - Web
  - Infrastructure CICD
  - Back
  - Quality
date:
  created: 2024-10-11
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v5.3.1

October 11, 2024

### Release Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;  Addressed a problem encountered with artifact deployment via Release Management.  

## Gluon v5.3.0

October 8, 2024

### FEATURES

#### General

![New](https://img.shields.io/badge/New-6fa8dc) New navigation experience in Gluon Docs, aligned with Portal and new sections as "My Gluon" and "Gluon Applications".  
![New](https://img.shields.io/badge/New-6fa8dc) Enabled the Jira integration with GitHub.com Organizations using the free **"GitHub for Jira"** app to keep traceability between Jira issues and related Github.com repositories.  
More details can be found [here](../../getting-started/setup-your-environment/tools/Jira/jira-github-integration/index.md)  
![New](https://img.shields.io/badge/New-6fa8dc) Available a new tool to migrate repositories from Github Enterprise Official Instance to GitHub Cloud.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc)  Now, all Component Templates are created as a **local template**. To create a Global Component Template, the Gluon Application where is created must belong to a Global Gluon Organization.  

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) The **Multi-Environment Deployment** has been included to allow users to manage and deploy releases in various environments.  
![New](https://img.shields.io/badge/New-6fa8dc) New components integrated with **Gluon Application Model** component aligned to new Release Management model.  

- **Darwin SPA**  
- **Darwin Microfront**  
- **React SPA**

A new parameter has been added in the creation of these components to select this model.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Performance improvements and some minor fixes has been implemented.  

### COMPONENTS

#### APIs

![New](https://img.shields.io/badge/New-6fa8dc) Enabled the **API Product Subscription** for API Product based on API Deployment 2.0. More details can be found [here](./../../components/software/api/apisubscription.md).  

#### Events

![Imp](https://img.shields.io/badge/Imp-93c47d) New improvements has been implemented in the Event Definition and Event Deployment as follow:

- The Event Local Head team has been modified to be managed as a Gluon Company Custom Team. Go [here](./../../components/software/events/proposal/index.md#roles) for more details.  
- Technical Application and Company values have been added to Event Definition proposal to help its identification.  
- Validation enhancement in the Event Definition and Event Deployment workflow.  

#### Front | React Lib

![Imp](https://img.shields.io/badge/Imp-93c47d)  The workflow has been updated to be aligned with the new CI/CD framework.  

#### IaC | Application Load Balancer

![New](https://img.shields.io/badge/New-6fa8dc) A new component for creating an **Application Load Balancer** in AWS Elastic Load Balancer (ELBv2 ALB v1.0.0) or Azure Application Gatewa (AGW v1.0.0) has been released.  

#### IaC | Object Storage

![Imp](https://img.shields.io/badge/Imp-93c47d) The Quality Gates workflow now incorporates Fortify SAST - SCA and Sonar scanner for AS3 v1.2.0 and STA v1.1.0.  

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) An new **Architecture** validation workflow is running when a Pull Request into a protected branch is created.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The **Arsenal Backend v3.13.12** and **Arsenal Integration 4.13.4** versions are now available. These versions are including:  

- Altair connection library

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.3.1** version is now available. This version is including:  

- Update Spring Boot version to v3.2.10 solving **CVE-2024-41909**.  
You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).  

#### Microservices | Darwin Python

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Python Framework v4.1.0** version including several fixes and improvements. More details,
 [here](../../components/software/backend/python/darwin/framework/changelog.md).  
