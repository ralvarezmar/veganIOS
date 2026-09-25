---
title: Gluon 7.0 Release Notes
categories:
  - Marketplace
  - Release
  - APIs
  - Web
  - Mobile
  - Back
  - Insights
  - Security
date:
  created: 2025-03-27
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v7.0.2

March 27, 2025

### Bug Fixes

![Capability](https://img.shields.io/badge/Marketplace-magenta) The issue displaying the latest API version catalog (different version in catalog vs. API detail) and
 API versions not being sorted in the API details has now been fixed (INC050831735).  

## Gluon v7.0.0

March 27, 2025

### What's New

![Capability](https://img.shields.io/badge/Release_Management-orange) Rollback Process for an Application Release now is implemented allowing to revert to a previous stable version
 of your application in case of issues with the current release.  
![Capability](https://img.shields.io/badge/Release_Management-orange) Deploy Draft Releases (draft Github releases) on the Preproduction Environment:
 Enabled the deployment of draft releases to the preproduction environment. This allows for thorough testing and validation of new features and fixes before they are officially released.  
![Capability](https://img.shields.io/badge/Release_Management-orange) Customization Change Management Predefined Team for a Company: Added the ability to define a predefined team for managing the Change Management tasks within a company.  
![Capability](https://img.shields.io/badge/Release_Management-orange) The OAM Linter validation process has been improved to ensure the correct deployment and rollback of application releases.  
![Capability](https://img.shields.io/badge/Release_Management-orange) Enhancements in the ITSM State management: All open releases in GLUON with the state "implement" and updated by users in ITSM will be synchronized in GLUON.  
![Capability](https://img.shields.io/badge/API-darkblue) Use of local policies for IBM API Connect and Apigee in the API Deployment 2.0 component, subject to Cybersecurity approval.  
![Capability](https://img.shields.io/badge/API-darkblue) Migration of subscriptions in IBM API Connect.  
![Capability](https://img.shields.io/badge/API-darkblue) Include Client Credentials security profile.  
![Capability](https://img.shields.io/badge/API-darkblue) AWS API Gateway: Configuration of encrypted S3 buckets for API deployment.  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: IBM API Connect: Configure iss in OAM (policy gln-jwsid-generate v2.3.0).  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: Apigee: Enable use of message path instead of pathsuffix in target-url to call microservices.  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: Apigee: Allow disable pathsuffix in target-url to call microservices.  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: API Subscription: Remove subscriptions to previous versions of an API Product when generating a new version
 of the API Subscription component to subscribe to the higher version of the minor version of the API Product configured.  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: API Subscription: Include release workflow.  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: Key Set: Include release workflow.  
![Capability](https://img.shields.io/badge/Front-green) New version of SPAs and Microfronts component templates to allow deployment of static web files to AWS S3 Buckets.  
![Capability](https://img.shields.io/badge/Front-green) New Web S3 Config component template to configure the deploymet to an S3 Bucket. Similar to Configmaps for Kubernetes.  
![Capability](https://img.shields.io/badge/Mobile-darkgreen) Android Library Component Template can now generate a SampleApp and upload it to TestFairy.  
![Capability](https://img.shields.io/badge/Darwin_Framework-darkviolet) New version 6.0.3 of Java Microservices and Libraries. This includes bug fixes, new Docker base image and a Springboot update to 3.4.4 (fixing CVE-2025-22228).  
![Capability](https://img.shields.io/badge/Darwin_Framework-darkviolet) New Darwin Java deployment Chart v3.4.0, which is allows to change the service account that executes the pod using
 the serviceAccountName properties, to add a HorizontalPodAutoscaler using the autoscaling.hpa properties and to add a PodDisruptionBudget using the pdb properties.  
![Capability](https://img.shields.io/badge/Insights-olive) Dast Information to Insights Dashboard at CICD tabs.  
![Capability](https://img.shields.io/badge/Insights-olive) Include component version field at CICD tabs.  
![Capability](https://img.shields.io/badge/Insights-olive) Include last version filter at CICD tabs.  
![Capability](https://img.shields.io/badge/Insights-olive) Change numerator compoenent filter at CTO KPI´s, only “Brownfield” values will be retrieved.  

### Bug Fixes

![Capability](https://img.shields.io/badge/STS_Service-purple) The issue of receiving a 500 response when a generic JWSID is created has now been resolved (INC052774536).  
![Capability](https://img.shields.io/badge/API-darkblue) API Framework 1.3.0: API Subscription: Fix integration with STS for subscriptions.  
![Capability](https://img.shields.io/badge/Insights-olive) Include number formats in all tabs.  
![Capability](https://img.shields.io/badge/Insights-olive) Category filter fixed. This has been changed from retrieving Category code to retrieving category name.  
