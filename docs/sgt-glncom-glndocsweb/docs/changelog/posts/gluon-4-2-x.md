---
title: Gluon 4.2 Release Notes
categories:
  - Security
  - Audit Compliance
  - Infrastructure CICD
  - Back
  - Management
  - Release
  - APIs
  - Web
  - Testing
date:
  created: 2024-07-05
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v4.2.3

July 05, 2024

### COMPONENTS

#### Security | STS

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved an issue with **component installation** due to incorrect variable naming for profile selection.  
For more information, please refer to this [link](https://cipdoc.sgtech.dev.corp/workstream/components/sts/).

## Gluon v4.2.2

July 01, 2024

### FEATURES

#### General

![Conf](https://img.shields.io/badge/Conf-9C9C9A) Gluon credentials for Service Now integration had to be updated due to CYBER requirements.  

## Gluon v4.2.1.1

July 01, 2024

### COMPONENTS

#### IaC | Openshift Namespace

![Conf](https://img.shields.io/badge/Conf-9C9C9A) New authorized infrastructure for Santander España and Santader Factoring Confirming is now ready for creating namespace.  

## Gluon v4.2.1

June 25, 2024

### COMPONENTS

#### Microservices | Deployment

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; To resolve an issue identified in the workflow execution, we rolled back to a previous version of the Arsenal chart and Configmap deployment.  

## Gluon v4.2.0

June 24, 2024

### FEATURES

#### Application Management

![New](https://img.shields.io/badge/New-6fa8dc) A new selector button has been added in the Component List view to filter by _Gluon_ or _Third-Party_ templates.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The Jira project name is now shown in the Application Onboarding summary instead of the JIRA project Key.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Filters in the application component template view has been improved to offer a better experience.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The _clear filter_ button located in the application component view has been fixed.  

#### CI/CD

![Imp](https://img.shields.io/badge/Imp-93c47d) The Release Candidate workflow can now be retried if necessary.  

#### Release Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The date format shown in the date selector in the Releases List view has been changed to a numeric format.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The release creation now is supported by all kind of corporate user format.

### COMPONENTS

#### APIs

![Fix](https://img.shields.io/badge/Fix-ea9999) The issue in the Apigee legacy, caused by a special character in the password, has been resolved.  
![Fix](https://img.shields.io/badge/Fix-ea9999) The problem affecting the quality workflow of API definitions for APIs Legacy has been successfully fixed.

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Backend Framework v3.12.0** for microservices and libraries is now available, including:

- OpenAPI Code generator. You can find more details [here](../../components/software/backend/java/arsenal/framework/arsenal-backend/tutorials/code-generator-openapi-maven-plugin.md).  
- Altair Code generator. You can find more details [here](../../components/software/backend/java/arsenal/framework/arsenal-backend/how-to-guides/integration/use-altair-maven-plugin.md)
- Some minor bug fixes.
  
#### Microservices | Darwin Java

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The new fix version **Darwin Java Framework v5.0.1** is now available. This version is including:  

- Update to Spring Boot v3.2.6
- Some minor bug fixes.  

#### Microservices | Darwin Python

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Deployment of Darwin Python error caused by _No module named 'wsgi'_ has been fixed.  

#### Microservices | Deployment

![New](https://img.shields.io/badge/New-6fa8dc) The **k8s nodeSelector** configuration is now available for deployments in Darwin Java, Python and Node JS microservices Helm Charts.  
![New](https://img.shields.io/badge/New-6fa8dc) **Configmap deployment** as environment variable is now available for Python and NodeJS microservices.  

#### IaC | Openshift Namespace

![Imp](https://img.shields.io/badge/Imp-93c47d) The error message in the namespace creation workflow has been updated to guide users to check _My Infra_ when a connection timeout error occurs.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;The ingress timeout connection has been increased to solve a connectivity time out error.

#### React SPA

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;The issue concerning the scaffolding in the React Single Page Application (SPA) component has been resolved.  

#### Reuse Image

![Imp](https://img.shields.io/badge/Imp-93c47d) The parameter named **framework** can now be configured in the deployment file.  

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) Availability of setting ephemeral runners in those new components based on Selenium frameworks (TalosBDD, Cilantrum, Nitro).  
![Imp](https://img.shields.io/badge/Imp-93c47d) A new version of Cilantrum Framework has been added in the testing platform.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;Some minor fixes related to authentication token refresh.  
