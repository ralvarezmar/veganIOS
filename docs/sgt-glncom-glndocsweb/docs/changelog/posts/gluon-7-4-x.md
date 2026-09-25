---
title: Gluon 7.4 Release Notes
categories:
  - Release
  - Software CICD
  - APIs
  - Quality
  - Mobile
date:
  created: 2025-05-25
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v7.4.0  

![Capability](https://img.shields.io/badge/APIs-brown)

### Improvements

- IBM API Connect: Cease using the Drafts functionality for API and Product deployment. APIs already deployed will continue to be retrieved from Drafts until a new version is deployed.  
- IBM API Connect: Optional configuration to use the Consumer API in subscriptions to allow fewer permissions for users of applications that create a subscription.  
- IBM API Connect: Subscription migration from one plan to another, subject to prior approval from the API Product Owner (Not compatible with the use of Consumer API).  
- API Deployment 2.0: Added "target-url" property to configure the microservice endpoint consumed by the API once, if it is the same for all operations.  
- API Deployment 2.0: New Framework version (1.5.0) with new policy versions:  
    - Apigee:
        - gln-jwsid-validate: 1.5.0  
        - gln-jwsid-generate: 2.4.0  

</br>

---

</br>

![Capability](https://img.shields.io/badge/MOBILE-darkgreen)

### What's New

- Fortify release supporting XCode16 and Swift 6: iOS security check uses last Fortify version released by Micro Focus compatible with Xcode 16 an Swift 6.

</br>

---

</br>

![Capability](https://img.shields.io/badge/QUALITY-purple)

### What's New

- Generate an empty initial baseline for the Greenfield and Brownfield components.
- Allow new framework to parent pom rule for Java.
- Get Project Key from the result of componentManager and not from properties.env.
- Update Appium Component definition to set fixed branch strategy and to be cataloged.

### Bug Fixes

- Fix to get Secrets no visible on logs.

</br>

---

</br>

![Capability](https://img.shields.io/badge/RELEASE_MANAGEMENT-orange)

### Bug Fixes

- OAM returns with the status “Already Deployed” even if there has been no deployment.

</br>

---

</br>

![Capability](https://img.shields.io/badge/SOFTWARE_CI/CD-darkred)

### Improvements

- Deployment logs now include the application's OAM repository path, improving clarity during the process.
- Update Workflow now auto-updates workflows in GitFlow repositories on develop and main branches, without requiring user or Support intervention.
- NPM Workflows now supports monorepo components.
- The Helm deployment has been adapted to use the OCI (Open Container Initiative) standard for uploading and downloading Charts.
- The Helm deployment documentation now includes detailed examples, parameter descriptions, and information on supported authentication methods.
- The validation of the project version used has been improved, checking whether it uses semantic versioning.

### Bug Fixes

- Workflows now properly handle errors to ensure the configured OAM repository required for the application exists.
- Logs in the Container build and push step have been corrected to clearly indicate the CI environments where they are published.
- Resolved an issue with registry login where credentials containing special characters (username and password) caused authentication failures.
- Resolved an issue with Quay registry publishing where the "image" property is now directly retrieved from the defined project-path instead of being set in the OAM.
- Updated trace messages during infrastructure validation to correctly indicate when a defined CI ID(s) is not found.
- In Third-Party Image Template, removed an unnecessary input field and enhanced user documentation, including detailed OAM configuration guidance for this component.
- Resolved a bug in Reuse Image Template where workflows failed to validate if a release version image was already uploaded, leading to errors during the push process.
