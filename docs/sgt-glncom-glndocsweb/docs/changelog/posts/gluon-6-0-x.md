---
title: Gluon 6.0 Release Notes
categories:
  - Infrastructure CICD
  - Management
  - Software CICD
  - Back
  - Marketplace
  - Release
  - Insights
  - SDLC Tools
  - Security
  - APIs
  - Back
  - Events
  - Web
  - Testing
date:
  created: 2024-12-12
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v6.0.5

Dec 12, 2024

### COMPONENTS

#### IaC | Namespace

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved the incident (INC049073670) related to Namespace creation with the latest version of OpenShift managed by CCC.  

## Gluon v6.0.4

Dec 10, 2024

![Conf](https://img.shields.io/badge/Conf-9C9C9A) Configuration change without a software release.  

## Gluon v6.0.3

Dec 4, 2024

### FEATURES

#### Exception Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The type of the predefined team *QA Exception* is now displayed correctly in the Company Team view.  

#### Ephemeral Runner

![Imp](https://img.shields.io/badge/Imp-93c47d) Added support for new technologies in Gluon Ephemeral Runners, including:

- ODBC packages
- Ansible collection for PostgreSQL
- Liquidbase 4.30.0

### COMPONENTS

#### Image Reuse

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Updated the component to include the **Update Workflow**.  

## Gluon v6.0.2

Nov 27, 2024

### FEATURES

#### Company Team Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Implemented minor fixes and improvements.  

#### Marketplace

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Implemented minor fixes and improvements.  

#### Release Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved the following issues:

- The project number is now registered in ITSM ServiceNow.  
- Draft releases are no longer shown on the release page view.  
- The last state handled by this feature is now "Review" instead of "Closed", so promoting the release to "Closed" is not allowed.  
- Deployment tasks are now correctly created for the appropriate environment.  

## Gluon v6.0.1

Nov 22, 2024

### FEATURES

#### Component Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Updated the internal configuration service due to the infrastructure migration of the Cyber API service.  

## Gluon v6.0.0

Nov 20, 2024

### FEATURES

#### Company Team Management

![New](https://img.shields.io/badge/New-6fa8dc) A new predefined type **QA Exception** can now be created as a Company Team to manage Quality Exceptions through the Exception Management feature.  
![New](https://img.shields.io/badge/New-6fa8dc) A new predefined type **Security** can now be created as a Company Team to mute vulnerabilities in Fortify.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc) A new branch strategy for Fixes and Releases has been implemented in the following components: API Product, Appian, Docker, Maven libraries, NPM microservices, OAM, Python microservices, Secrets.  
![New](https://img.shields.io/badge/New-6fa8dc) Credentials to push an image to the registry, for APIs and Kubernetes deployments can now be retrieved from Vault by setting `CredentialFromVault=true` in your component.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Sonar Baseline is now established when a Release tag is created, changing the Quality Gate to "Sonarway".
This makes all developments follow a Clean as Code Policy (quality and thresholds guaranteed for new code).  
![Imp](https://img.shields.io/badge/Imp-93c47d) SysDig analysis moved to Pull Request creation on development branch (Shift left).

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) CICD Aggregated Information: Added information about deploys, builds, and tests aggregated by application, entity, and Cost Centers.  
![New](https://img.shields.io/badge/New-6fa8dc) Exception Information: Added information about waivers.  
![New](https://img.shields.io/badge/New-6fa8dc) Atlassian Information: Added information about Atlassian usage.

#### Ephemeral Runners

![New](https://img.shields.io/badge/New-6fa8dc) Ephemeral Runners Distributed Model published. Base Runners Images available for all Cloud platforms, defined by size and environment type.

#### Release Management  

![New](https://img.shields.io/badge/New-6fa8dc) Service Now Release Ticket (Request Ticket ID) can optionally be provided to deploy in a PRODUCTION environment for any component supported by this feature.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Authorization changed to PRE step.

#### Authorized Infrastructure  

![New](https://img.shields.io/badge/New-6fa8dc) Authorized infrastructure is now available for the following entities:

- Santander Mediación
- Santander Consumer Benelux (only for Development environment)
- Santander Consumer Italy (only Development environment)

### COMPONENTS  

#### API

![Imp](https://img.shields.io/badge/Imp-93c47d) Allow API Subscription from an entity that is not the owner of the API Product.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Integration with API Connect to use consumer organizations created in the Manager instead of always creating them from Gluon (complying with the naming convention of Gluon `<App code (ITSM)>-pro`).  
![Imp](https://img.shields.io/badge/Imp-93c47d) New versions of policies:

- BM: jwsid-generate
- Apigee: burst-limit
- Apigee: rate-limit
- Apigee: verify-client-id
- Apigee: error-control
- Apigee: schema validation to include response validation

#### Base Image

![New](https://img.shields.io/badge/New-6fa8dc) New **Base Image** component available to create Docker base images.

#### Events

![New](https://img.shields.io/badge/New-6fa8dc) The **Event Subscription** is now available from the Integration page. You can request and approve a subscription to an event.
 The Event Subscription component is also supported by Release Management.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The **Event Deployment** component can now be used with Release Management.

#### Front | React Microfront  

![New](https://img.shields.io/badge/New-6fa8dc) Released a new **React Microfront** component in the Gluon portal (leveraging Vite + Module Federation).

#### Front | React SPA  

![New](https://img.shields.io/badge/New-6fa8dc) Released a new **React SPA** flavor (leveraging Vite + Module Federation) in the current React SPA component.

#### Front | Angular Library  

![New](https://img.shields.io/badge/New-6fa8dc) New **Angular observability library** capable of monitoring HTTP requests and injecting s3/w3c headers.

#### Image Reuse

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the component to support ECR, ACR, and Artifactory registries for origin images (in addition to the current Harbor support).

#### Microservices | Darwin NodeJs

![Imp](https://img.shields.io/badge/Imp-93c47d) The Darwin NodeJs Component is now supported by Release Management.

#### Microservices | Darwin Python

![Imp](https://img.shields.io/badge/Imp-93c47d) The Darwin Python Component is now supported by Release Management.

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) Available for the testing workflow:

- HP ALM report
- Xray report
