---
title: Gluon 5.4 Release Notes
categories:
  - Release
  - Back
  - Security
  - Software CICD
date:
  created: 2024-10-17
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v5.4.1

October 17, 2024

### COMPONENTS

#### Release Management

![Imp](https://img.shields.io/badge/Imp-93c47d)  A new update workflow has been introduced, allowing for seamless updates from one template to another within the Gluon Application Model component.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The link to the User Guide in the Gluon Application Model documentation has been corrected, ensuring users have access to accurate and helpful information.  

#### Microservices  

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;  Updated versions of component templates have been released to address vulnerabilities identified by Sysdig scans.  

- **Darwin Java Microservices v1.1.4**: Updated Dockerfile base image to 1.2.26.RELEASE  
- **Darwin Java Microservices 2.0 v1.2.6**: Updated Dockerfile base image to 1.2.26.RELEASE  
- **Darwin Python Microservices v1.0.14**: Updated Dockerfile base image to 1.3.4.RELEASE  
- **Arsenal Microservices v0.4.6**: Updated Dockerfile base image to 1.2.26.RELEASE  
- **Arsenal Microservices 2.0 v1.3.3**: Updated Dockerfile base image to 1.2.26.RELEASE  

## Gluon v5.4.0

October 15, 2024

### FEATURES

#### Security | Sysdig

![New](https://img.shields.io/badge/New-6fa8dc)  Activated Sysdig Scan within the workflow. Now, if any vulnerability is detected, the workflow will halt to ensure security compliance before proceeding.  
Go to this [link](./../../application/ci-cd/sysdig/index.md) for further information.  
