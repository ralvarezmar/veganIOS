---
title: Gluon 5.6 Release Notes
categories:
  - SDLC Tools
  - Software CICD
  - Infrastructure CICD
  - Events
  - Gravity
  - Back
date:
  created: 2024-10-29
tags:
  - Feature
  - Improvement
---


## Gluon v5.6.0

October 29, 2024

### FEATURES

#### Atlassian

![New](https://img.shields.io/badge/New-6fa8dc) The Atlassian IA is now available for Jira, Confluence and other Atlassian Products.  For further information, visit this [link](https://support.atlassian.com/organization-administration/docs/get-started-with-atlassian-intelligence-guide/)

#### CI/CD

![Imp](https://img.shields.io/badge/Imp-93c47d)  **Workflow execution time** has been reduced by updating some internal tools.  
![Imp](https://img.shields.io/badge/Imp-93c47d) New improvements in the **Base Component Template** have been implemented as follow:  

- Only Application TL team are now included the in the .CODEOWNERS file created by a Local Component Template removing the APP360_DEV team.  
- The "Label" parameter can now be configured during the creation process.  

#### Infrastructure | Authorized Infrastructure

![New](https://img.shields.io/badge/New-6fa8dc)  New Authorized Infrastructure for UK, Mexico and USA companies is now available for using with the Namespace Openshift component.  For further information, visit this [link](./../../components/configuration/kubernetes/namespace_harbor.md).

### COMPONENTS

#### Events

![Imp](https://img.shields.io/badge/Imp-93c47d) New improvements have been implemented in the Event Deployment as follows:

- The **asset ID** and the **asset version** are now used in the Event deployment creation process instead of the Event repository.  
- The name of the deployment credential has been changed.  

For more details, visit this [link](./../../components/software/events/deployment/index.md).  

#### Gravity | Altair

![New](https://img.shields.io/badge/New-6fa8dc) The Sonar step is now available in the Altair Native Component.  

#### IaC | Encryption Manager

![New](https://img.shields.io/badge/New-6fa8dc) Released a new component template **version 1.1.0** that includes the Quality Gates Workflow for Fortify SAST - SCA and Sonar scanner.  

#### IaC | Kubernetes

![New](https://img.shields.io/badge/New-6fa8dc) Released a new component template **version 1.2.0** that includes two new post-configuration actions. **Sysdig** and **Ingress Controller** can now be configured.
<!-- For more details, visit this [link](./../../components/configuration/iac/kubernetes/post-conf.md).   -->

#### IaC | Log Storage  

![New](https://img.shields.io/badge/New-6fa8dc) A new component for creating a **Log Storage** on AWS Cloud Watch (ACW v1.0.0) and Azure Log Analytics Workspace (LWK v1.0.0) has been released.  
<!-- For more details, visit this [link](./../../components/configuration/iac/log-storage/index.md).   -->

#### IaC | VPC Lite

![New](https://img.shields.io/badge/New-6fa8dc) A new component for creating a **VPC** on AWS VPC Lite (VLI v1.0.0) has been released.  
<!-- For more details, visit this [link](./../../components/configuration/iac/vpc-lite/index.md).   -->

#### Microservices | Arsenal

![Imp](https://img.shields.io/badge/Imp-93c47d) The **Arsenal Backend v3.14.0** and **Arsenal Integration v4.14.0** versions are now available. These versions include:  

- Support for businessId and sessionId observability headers.  
- Updated Spring Boot version to 3.2.11 to address framework vulnerabilities.  

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.3.2** version is now available. This version includes:  

- Support for businessId and sessionId observability headers.  
- Bump Spring framework dependency version for solving vulnerability.  
You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).  

#### Microservices | Photon

![New](https://img.shields.io/badge/New-6fa8dc) The **Photon Framework v1.2.0** version is now available including an extension for the Observability. More details,
 [here](../../components/software/backend/java/photon/framework/current/index.md).  
