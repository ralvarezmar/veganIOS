---
title: Gluon 5.1 Release Notes
categories:
  - Software CICD
  - Management
  - Marketplace
  - Release
  - Back
  - Testing
date:
  created: 2024-09-10
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v5.1.3

September 10, 2024

### FEATURES

#### CI/CD

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Two issues in the deployment pipeline that uses Maven technology has been resolved. For more details, you can refer to incident reports INC045776086 and INC045796181.  

## Gluon v5.1.2

September 5, 2024

### FEATURES

#### Application Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Data correction in the database to resolve an error with Github onboarding tool in the application onboarding of some applications.  

## Gluon v5.1.1

August 30, 2024

### FEATURES

#### Marketplace

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The business domain "Market Operations" catalogue used in the validation workflow has been updated to include "Trade Settlement" service domain.  

## Gluon v5.1.0

August 27, 2024

### FEATURES

#### Company Management

![New](https://img.shields.io/badge/New-6fa8dc) New Company Teams option available to company owners to manage specific teams not directly related to applications.  
More details can be found [here](../../getting-started/company-management/company-teams-management/index.md).  

#### Application Management  

![Imp](https://img.shields.io/badge/Imp-93c47d) The error messages have been enhanced to provide clearer explanations of the reasons for failures.  

#### Component Management

![New](https://img.shields.io/badge/New-6fa8dc) Application owners can now control whether application components are visible or hidden in the application component list.  
More details can be found [here](../../application/component-management/disable-component.md).  
![New](https://img.shields.io/badge/New-6fa8dc) Clicking on any field within the component list now opens a detailed view of that component.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;Minor bugs affecting the creation of new components have been fixed.  

#### Exception Management

![New](https://img.shields.io/badge/New-6fa8dc) The "Status" and the "Service Now Number" information is now displayed in the Exception list view.  

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) The Release Orchestration process now includes two additional stages: "Review" and "Closed".  
![New](https://img.shields.io/badge/New-6fa8dc) An error messages is now shown if the approval task is closed by someone who isn't authorized to do so.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc) The **Github Runner Set Up** action now has been updated to only use tools and versions installed by image flavor.  
Check the image flavor list in this [link](../../getting-started/company-management/technical-requirements/ephemeral-runners/flavours.md)  
![New](https://img.shields.io/badge/New-6fa8dc) In the Base Component Template, there is a new action that lets you add and update the environment approver list.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The SCA and SAST workflows now run in parallel, decreasing the total execution time.  

### COMPONENTS

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) Java native compilation support has been included for Arsenal Integration. More details,
 [here](./../../components/software/backend/java/arsenal/framework/arsenal-integration/tutorials/native-compilation.md).  

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.2.1** version is now available. This version is including:

- Java native compilation. More details, [here](../../components/software/backend/java/darwin/framework/guides/native-development-guide.md).  
- Some updates of automatic code generation using DDL.  
You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).

#### Microservices | Photon

![New](https://img.shields.io/badge/New-6fa8dc) The **Photon Framework v1.1.0** version is now available. This version is including an Error Handling feature.  
More details can be found [here](./../../components/software/backend/java/photon/framework/current/index.md).  

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) The look and feel of the Testing Platform has been updated to better align with the Gluon design.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The session expiration time has been extended, allowing users to stay connected for more than 5 minutes.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The testing framework field required during project creation now is autofilled.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Several user experience improvements have been implemented.  
![Fix](https://img.shields.io/badge/Fix-ea9999) The Internet Talos Execution option has been disabled in the portal.  
