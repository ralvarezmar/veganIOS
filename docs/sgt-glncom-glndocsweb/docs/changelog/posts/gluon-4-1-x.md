---
title: Gluon 4.1 Release Notes
categories:
  - Management
  - UX & Accessibility
  - Quality
  - Security
  - Software CICD
  - Insights
  - Marketplace
  - Release
  - APIs
  - Back
  - Infrastructure CICD
date:
  created: 2024-06-03
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v4.1.0

June 3, 2024

### FEATURES

#### Application Management

![New](https://img.shields.io/badge/New-6fa8dc) A new step has been added to the **Application Onboarding** process. Selection of an existing Jira project is now possible. Additionally, a Confluence instance can be chosen.  
![New](https://img.shields.io/badge/New-6fa8dc) New application ITSM status (Test, Friends & Family, Certification/Homologation) have been added to the filter in the **Applications list** view.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Simplification of the Search Box in the **Component Catalog** view. Searching by name and filtering by fields such as type is now possible.  

#### CI/CD

![Imp](https://img.shields.io/badge/Imp-93c47d) A new authentication method has been introduced for Kubernetes deployment in EKS. Now, you can use an ephemeral token for this purpose.

#### Exception Management

![New](https://img.shields.io/badge/New-6fa8dc) Quality and security exceptions can now be managed through a new section. More information is available at this [link](../../application/exceptions-management/index.md).  

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) New KPIs related to **Github Copilot** use have been introduced.  
![New](https://img.shields.io/badge/New-6fa8dc) New KPIs related to the **Software Development Lifecycle** have been introduced.  
![Imp](https://img.shields.io/badge/Imp-93c47d) KPIs view related to **Gluon Use**, such as % Developers, % Applications, %APIs Legacy, have been improved including more details. More details can be found [here](./../../application/observability-insights/insights/index.md).

#### Marketplace

![Imp](https://img.shields.io/badge/Imp-93c47d) The Subscription Plans in the Subscription Flow now is visible for those users who are registered in Gluon.  

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) Deployment execution button is only available in the deployment window.  
![Imp](https://img.shields.io/badge/Imp-93c47d) User experience improvements have been implemented on new release creation form such as remark with "*" the required field, release time field retrieved from Company or Application setting.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Translation issues have been resolved.  

### COMPONENTS

#### APIs

![Imp](https://img.shields.io/badge/Imp-93c47d) A new shortcut has been added in the application integration view to access the subscription client-secret stored in Vault.  
![Imp](https://img.shields.io/badge/Imp-93c47d) An issue in the **API Subscription** process where a client already in use could be selected has been fixed. Now, clients already in use are displayed as disabled and cannot be selected.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The usage and translations of version selectors in the **API Version Comparison** have been improved.  

#### Microservices | Darwin Python

![New](https://img.shields.io/badge/New-6fa8dc) Availability of the **Darwin Python Framework v4.0.0** for microservices and libraries has been announced.  
![New](https://img.shields.io/badge/New-6fa8dc) A component for creating **Microservices** with the Darwin Python Framework v4.0.0 based on **FastAPI** has been introduced.  

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Backend Framework v3.11.2** for microservices and libraries is now available, including:

- JPA Code Generator for generating entities and repositories for database access from table creation DDLs.  
- A fix for NPE and configuration enabling in the Embedded crypto library has been implemented.

#### IaC | Container Registry

![New](https://img.shields.io/badge/New-6fa8dc) A component for creating a **Container Registry** in Azure and AWS Cloud Provider has been added.
<!-- More details can be found [here](../../components/configuration/iac/container-registry/index.md). -->

#### IaC | Openshift Namespace

![New](https://img.shields.io/badge/New-6fa8dc) Namespace creation functionality is available in **all OHE regions**.  
![New](https://img.shields.io/badge/New-6fa8dc) **Modification** of the initial base settings is now possible, allowing for more **advanced configuration** of quotas and limits.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Configuration of the **Harbor Registry** is no longer necessary when creating the component. This value will be obtained from internal information.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Harbor registry entries have been removed from the authorized infrastructure as they are no longer used in creation.  
