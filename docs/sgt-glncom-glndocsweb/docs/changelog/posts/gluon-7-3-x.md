---
title: Gluon 7.3 Release Notes
categories:
  - Release
  - Software CICD
  - Back
  - Gravity
  - APIs
  - Testing
  - Marketplace
date:
  created: 2025-05-14
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v7.3.3  

May 14, 2025  

### What's New

![Capability](https://img.shields.io/badge/RELEASE_MANAGEMENT-yellow)  

- ![Capability](https://img.shields.io/badge/Improvement-blue) Time Zone Management Enhancements:  

    - Handling user-specific data in window management  
    - Creation and validation of releases and deployments aligned with the user's time zone  
- Error Management and Log Standardization: Improvements implemented to standardize logs and exception handling across all microservices  
- Documentation has been added for the batch operations of the Service Now adapter  

### Bug Fixes  

- OAM Linter Issue: Resolved linter error caused by incorrect ordering of dependency functions  
&nbsp;

## Gluon v7.3.2  

May 13, 2025  

### What's New  

Several internal improvements and bug fixes.  
&nbsp;

## Gluon v7.3.1  

May 12, 2025  

### What's New  

Several internal improvements and bug fixes.  
&nbsp;

## Gluon v7.3.0  

May 8, 2025  

### What's New  

![Capability](https://img.shields.io/badge/CI/CD-red)  

- [SUPRA] Pass GitHub credentials to the Playbook to replace them in the property file  
&nbsp;

![Capability](https://img.shields.io/badge/CAPABILITIES_BACK-darkblue)  
Darwin Gateway Deployment template version including:  

- ![Capability](https://img.shields.io/badge/New-lightgreen) Support Release Management model deployment (OAM)  
    - ⚠️ Note that Darwin Gateway Api Deployment is obsolete  
    - ![Capability](https://img.shields.io/badge/Configuration_change-grey) Use Kubernetes ConfigMap 2.0 Component instead of "Darwin Gateway Api Deployment"
    to the possibility of using Gluon's Release Management functionality  

Darwin Python Microservice component including:  

- Darwin Python framework version 4.1.5.  
&nbsp;

![Capability](https://img.shields.io/badge/GRAVITY-darkgreen)  
Gravity Altair:  

- ![Capability](https://img.shields.io/badge/New-lightgreen) Create a baseline after the massive migration of the code to github.com in Altair  

Gravity Partenon:  

- Several enhancements required by ‘Gobierno de Entornos’ such as descriptor.yaml format and URL
validations on MainframeRLSE and MainframeCERT workflows  
- Integration of new microfocus paths done in CERT-UK  
- ![Capability](https://img.shields.io/badge/Configuration_change-grey) New configuration in GravityOne calls  
- New "adaptaJCL" version set for all clients/environments  
&nbsp;

![Capability](https://img.shields.io/badge/CAPABILITIES_APIs-brown)  

- ![Capability](https://img.shields.io/badge/New-lightgreen) AWS API Gateway - CloudWatch configuration in API Deployment 2.0 component  
&nbsp;

![Capability](https://img.shields.io/badge/Q&A_TESTING-lightyellow)  

Testing:  

- ![Capability](https://img.shields.io/badge/New-lightgreen) New Appium-Kotlin testing component: New framework for mobile testing based in Appium Spain  
- ![Capability](https://img.shields.io/badge/New-lightgreen) New runner input to testing WFs: New input to set the testing runner for future local implementations  

Sonar:  

- ![Capability](https://img.shields.io/badge/New-lightgreen) Sonar Way Gln new Tech: New combination to new templates  

### Bug Fixes  

![Capability](https://img.shields.io/badge/CI/CD-red)  

- Fix Npm ci and release (tbd|gfw) immutable workflows to upload artifacts to Nexus with the correct version suffix  
- Fix error login in registries when the username or password contains special characters  
&nbsp;

![Capability](https://img.shields.io/badge/Q&A_TESTING-lightyellow)  

- Portal CI/CD GitHub link: Fixed link url to GitHub repository  
- Portal Scheduler: Fixed scheduler in Portal Automatic Testing  
&nbsp;

![Capability](https://img.shields.io/badge/GRAVITY-darkgreen)  
Cobol-linux:  

- Fix error on dependencies symbolic-links  
&nbsp;

![Capability](https://img.shields.io/badge/CAPABILITIES_BACK-blue)  
Darwin Python Microservice component including:  

- Darwin Logger library version 4.3.2 updating confluent-kafka dependency to version 2.8.2  

Darwin Gateway Deployment template version including:  

- When updating Darwin Gateway Deployment component “darwin.region” parameter in “values.yml” file is fixed to new chart support  
&nbsp;

![Capability](https://img.shields.io/badge/MARKETPLACE-darkgreen)  

- Solution to version display error in the API Catalog: INC053795626  
