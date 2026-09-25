---
title: Gluon 7.1 Release Notes
categories:
  - Back
  - APIs
  - Management
  - Web
  - Quality
  - Software CICD
  - Release
  - Testing
  - UX & Accessibility
date:
  created: 2025-04-10
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v7.1.1  

April 10, 2025

### Bug Fixes

![Capability](https://img.shields.io/badge/Banksphere-orange) Automatic configuration of certification environments and associated credentials.  
![Capability](https://img.shields.io/badge/Banksphere-orange) Update Banksphere Chart version in composite chart.  
![Capability](https://img.shields.io/badge/Capabilities_back-blue) Arsenal Microservices updated to latest Arsenal frameworks versions:

- Arsenal Backend v3.17.0 including:  
    - Spring Boot to v3.3.10 to solve vulnerability CVE-2025-22228  
    - New in memory database module  
- Arsenal Integration v4.15.5 including:  
    - SpringBoot version to 3.3.10 to solve vulnerability CVE-2025-22228  
    - Apache Camel version to 4.8.5 to solve vulnerabilities CVE-2025-27636 and CVE-2025-29891  

![Capability](https://img.shields.io/badge/Capabilities_back-blue) Arsenal Libraries updated to latest Arsenal framework version v3.17.0 including:  

- Spring Boot to v3.3.10 to solve vulnerability CVE-2025-22228  

![Capability](https://img.shields.io/badge/Capabilities_back-blue) Arsenal deployment Chart v2.7.1 default parameters fixed. It includes v2.7.0 capabilities:  

- Allow changing the service account that executes the pod using the serviceAccountName properties.  
- Add a HorizontalPodAutoscaler using the autoscaling.hpa properties.  
- Add a PodDisruptionBudget using the pdb properties.  

![Capability](https://img.shields.io/badge/Capabilities_back-blue) Photon Microservices and Extensions to latest Photon framework version v1.2.3:  

- Quarkus version to 3.19.3 to solve vulnerability CVE-2025-24970.  

## Gluon v7.1.0

April 8, 2025

### What's New

![Capability](https://img.shields.io/badge/API-darkblue) Added API definition version in the API deployment details.  
![Capability](https://img.shields.io/badge/API-darkblue) Added link to the technical applications of the product in the product catalog. Clicking on this new link will open a new tab with the application details.  
![Capability](https://img.shields.io/badge/Component_Manager-orange) The Company Owner can now mark a component as brownfield, allowing the identification of components originating from a migration,
even if they were created directly in Gluon using a local template.  
![Capability](https://img.shields.io/badge/Front-green) Dockerfile base image for Frontend components (Darwin SPA, Darwin Microfront, AFE SPA, AFE Microfront, React SPA & React Microfront) to
“nginx-1-25-ubi8:1.2.13.RELEASE” to fix Sysdig vulnerabilities.  
![Capability](https://img.shields.io/badge/Testing_Sonar-blue) Execute Regularization for templates: New script to associate cross group to projects that match a regEx (SANTemplate).  
![Capability](https://img.shields.io/badge/CICD-red) [ReuseArtifact] Add SAS and Microstrategy as a component type.  
![Capability](https://img.shields.io/badge/CICD-red) [SUPRA] Don't display values ​​for sensitive properties.  

### Bug Fixes

![Capability](https://img.shields.io/badge/Release_Management-orange) Fixed ITSM User Service permissions to allow promoting releases between states.  
![Capability](https://img.shields.io/badge/API-darkblue) Correct the version displayed when navigating to the API definition view from the API list.  
![Capability](https://img.shields.io/badge/API-darkblue) Resolve styling issues within the API definition view.  
![Capability](https://img.shields.io/badge/DX-darkgreen) Issues with styles and names in the My Applications widget on the homepage.  
![Capability](https://img.shields.io/badge/DX-darkgreen) Adjust the visibility of the switch button in the list view component.  
![Capability](https://img.shields.io/badge/Testing-blue) SendReport for Performance: Fixed sendReport for performance of report path from HP-ALM.  
![Capability](https://img.shields.io/badge/Testing-blue) Passphrase use for Performance: Fixed performance-service that was causing the tests to not deploy on openshift when testing with a passphrase.  
![Capability](https://img.shields.io/badge/Testing_Sonar-blue) Front Settings Sonar OnBoarding: Fix front settings templates Sonar OnBoarding.  
![Capability](https://img.shields.io/badge/CICD-red) Fix a problem when running the deploy workflow manually from the run workflow interface when the users don’t provide the environment type input.  
