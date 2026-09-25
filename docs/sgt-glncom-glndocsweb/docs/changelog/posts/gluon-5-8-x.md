---
title: Gluon 5.8 Release Notes
categories:
  - Release
  - APIs
  - Web
  - Gravity
  - Back
date:
  created: 2024-11-12
tags:
  - Feature
  - Improvement
  - Fix
---


## Gluon v5.8.0

November 12, 2024

### FEATURES

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) The new **Image Reuse** component can be now selected at both Company Level and Application Level.  
For more details, visit this [link](./../../application/release-management/zero-touch/deployment-window-configuration.md).  

### COMPONENTS

#### API

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved the following issues raised by entities:

- Avoided the "argument is too long" error before generating the elastic payload. Refer to INC047763734.  
- Fixed the issue in subscriptions when a technical application name contains the characters [].  
- Resolved compatibility issues in subscriptions with API Connect version 10.0.8.0.  
- Fixed inconsistencies with producer organizations created in the Manager before having the API Deployment 2.0 API, and producer organizations manually removed in the API Manager that were created with Gluon.  

#### Front | Darwin

![Imp](https://img.shields.io/badge/Imp-93c47d) New versions of Darwin SPA and Darwin Microfront templates include an update to the latest published Docker image that fixes Sysdig vulnerabilities.  

#### Front | AFE

![Imp](https://img.shields.io/badge/Imp-93c47d) New versions of AFE SPA and AFE Microfront templates include an update to the latest published Docker image that fixes Sysdig vulnerabilities.  

#### Front | React

![Imp](https://img.shields.io/badge/Imp-93c47d)New version of React SPA template includes an update to the latest published Docker image that fixes Sysdig vulnerabilities.  

#### Gravity | Altair Native

![Imp](https://img.shields.io/badge/Imp-93c47d)  The new **Gravity Altair Native** template version includes several improvements to the quality workflow, such as the waiver feature and elastic logging.  

#### Gravity | Altair Sync

![Imp](https://img.shields.io/badge/Imp-93c47d)  The new **Gravity Altair Sync** template version includes several improvements such as CPY management and deployment, DCL management and deployment and GravityOne response code OnlyGravity.  

#### Image Reuse

![New](https://img.shields.io/badge/New-6fa8dc) A new version of the Image Reuse component is now available for all Gluon-supported registries in destination, including Harbor, ECR, ACR and JFrog but it is restricted to the Harbor origin registry.  
For further detail, visit this [link](./../../components/configuration/kubernetes/image-reuse.md).  
This component is only supported for use with the OAM component.  

#### Microservices | Arsenal Frameworks

![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Backend v3.15.0** and **Arsenal Integration v4.14.3** versions are now available including:

 - Capability to manage "businessId" and "sessionId" observability fields and header propagation.  
 - Several bugfixes and minor improvements.  

#### Microservices | Darwin Java Frameworks

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java framework v5.4.0** version are now available including:

 - Darwin Java Code Analysis plugin to validate microservice and library architecture.  
 - Capability to manage "businessId" and "sessionId" observability fields and header propagation.  
 - Several bugfixes and minor improvements.  

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Helm Chart v3.2.0** version are now available including:

 - Capability to customize the configuration and i18n ConfigMap names and secret name.  
 - Capability to set the config type to “none” indicating that you don’t need to use a configmap with the microservice.  

#### Microservices | Darwin  

![Imp](https://img.shields.io/badge/Imp-93c47d) New versions of the Darwin Java, Arsenal, and Photon templates include an update to the latest published Docker image that fixes Sysdig vulnerabilities.  
