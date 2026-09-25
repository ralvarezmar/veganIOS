---
title: Gluon 6.1 Release Notes
categories:
  - Software CICD
  - Release
  - Documentation
  - Management
  - Security
  - APIs
  - Back
  - Events
  - Web
  - Gravity
  - Infrastructure CICD
  - Process
  - Testing
date:
  created: 2025-01-17
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v6.1.7

Jan 17, 2025

### FEATURES

#### CICD

![Fix](https://img.shields.io/badge/Fix-ea9999) Fixing downloading the Sysdig client during the workflow.

## Gluon v6.1.6

Jan 16, 2025

### FEATURES

#### RELEASE MANAGEMENT

![Fix](https://img.shields.io/badge/Fix-ea9999) Fixing incident INC050336766 (fixing basic authentication to Oauth).

## Gluon v6.1.5

Jan 9, 2025

### FEATURES

#### RELEASE MANAGEMENT

![Fix](https://img.shields.io/badge/Fix-ea9999) Fixing incident INC050192908.

## Gluon v6.1.4

Jan 9, 2025

### FEATURES

#### GLUON DOCS

![New](https://img.shields.io/badge/New-6fa8dc) New documentation.

## Gluon v6.1.3

Dec 27, 2024

### FEATURES

#### CICD

![Fix](https://img.shields.io/badge/Fix-ea9999) Error when running the “publish a Maven library pipeline” to the brazilian Artifactory due to a problem when building the artifact url.  

## Gluon v6.1.2

Dec 19, 2024

### FEATURES

#### CICD

![Fix](https://img.shields.io/badge/Fix-ea9999) Fixing incidents INC049541688, INC049537858 (error during Nexus publication for Python and NPM).

## Gluon v6.1.1

Dec 17, 2024

### FEATURES

#### GLUON DOCS

![New](https://img.shields.io/badge/New-6fa8dc) Documentation updates.

## Gluon v6.1.0

Dec 16, 2024

### FEATURES

#### Company Team Management

![New](https://img.shields.io/badge/New-6fa8dc) Added the ability for a Company Owner to create a JIRA and/or Confluence project for the Predefined Company Team.  

#### CI/CD
  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the OAM component for ConfigMap deployment so that it is not required to set the "chartUnzip" property.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the Sysdig action to include more information about the analysis results.  

#### Exception Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved the incident that prevented QA Quality predefined company custom teams from adding a quality exception.  

#### Marketplace

![New](https://img.shields.io/badge/New-6fa8dc) You can now search for information about the latest Event definitions using the Definition Copilot Knowledge Base.  

#### Security  

![New](https://img.shields.io/badge/New-6fa8dc) New **Vault Policies**: updated developers' policies to read/write in ci-tools at the application for certification environment.  

#### Brownfield

![New](https://img.shields.io/badge/New-6fa8dc) Available new local component templates, including the following technology: BKS Parameters table, SAS, Norkom, Qliksense, SUPRA.  

### COMPONENTS  

### APIs

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the OAM component to allow setting the owner of consumer organization.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Added the ability to get deployment secrets from Vault for API Subscription and Key Set component.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the API Subscription validation to remove the gluon organization and create a new one with IBM API Connect ID if the consumer organization already exists on IBM API Connect.  

#### Back

![Imp](https://img.shields.io/badge/Imp-93c47d) A new version is now available for all backend components. Please refer to each component's documentation for further details.  

#### Base Image

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the template version to simplify configuration deployment.  

#### Events

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the OAM component for Event Deployment, including:

- Added a new "brokertype" property.
- Removed the "schemaRegistry" property.  
  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the Event Definition, Event Deployment and Event Subscription to include the update workflow.  

#### Front

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the **AFE SPA & Microfront** template to Angular version 18.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated all frontend templates to address Sysdig vulnerabilities, including a new Docker base image: nginx-1-25-ubi8:1.2.3.RELEASE.  

#### Gravity

![Imp](https://img.shields.io/badge/Imp-93c47d) Available new version of the component template.  Please refer to the component's documentation for further details.  

#### IaC | Kubernetes

![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the post-configuration including:  

- New `custom_alb_controller_image` variable.
- Modified Sysdig template default tag variable.
- Ability to define `no_proxy`, `http_proxy`, and `https_proxy` in `config.yml`.

#### Process

![New](https://img.shields.io/badge/New-6fa8dc) New Appian template version supported by Release Management and Secret Management with Vault.  

#### Testing

![Imp](https://img.shields.io/badge/Imp-93c47d) Role-based control has been implemented to allow testing in the PRO environment.  
