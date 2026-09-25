---
title: Gluon 6.3 Release Notes
categories:
  - Back
  - Security
  - Infrastructure CICD
  - Web
  - APIs
  - Release
  - Software CICD
  - UX & Accessibility
  - Management
  - Insights
  - Gravity
  - Quality
date:
  created: 2025-02-26
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v6.3.3

Feb 26, 2025

### Components

#### Back

![Fix](https://img.shields.io/badge/Fix-ea9999) ![Framework](https://img.shields.io/badge/Darwin-0000ab)
 ![Component](https://img.shields.io/badge/Java_Microservice-9347dc)
 ![New](https://img.shields.io/badge/New-6fa8dc) Release/fix workflow has been added.  
![Fix](https://img.shields.io/badge/Fix-ea9999) ![Framework](https://img.shields.io/badge/Arsenal-0000ab)
 ![Component](https://img.shields.io/badge/Arsenal_Microservice-9347dc)
 ![New](https://img.shields.io/badge/New-6fa8dc) Release/fix workflow has been added.  

### Features

#### Vault

![Fix](https://img.shields.io/badge/Fix-ea9999) Developer and Access Management policies have been updated to fix the conflicts that exist when an access manager is also a developer in an application.  
![Fix](https://img.shields.io/badge/Fix-ea9999) Vault Access Management groups that are managed by OHE Portal have been migrated and now they will be managed by Gluon's Crossed Teams functionality.
 These access management predefined teams are already registered in all the Gluon entities.
 More info [here](https://gluon.gs.corp/community/docs/latest/getting-started/company-management/company-teams-management/team-predefined/).  

## Gluon v6.3.2

Feb 20, 2025

### Components

#### IaC

![Fix](https://img.shields.io/badge/Fix-ea9999) ![Component](https://img.shields.io/badge/Kubernetes_Cluster-9347dc) Documentation link to Gluon Docs fixed.  
![Fix](https://img.shields.io/badge/Fix-ea9999) ![Component](https://img.shields.io/badge/Log_Storage-9347dc) Documentation link to Gluon Docs fixed.  
![Fix](https://img.shields.io/badge/Fix-ea9999) ![Component](https://img.shields.io/badge/Encryption_Manager-9347dc) Documentation link to Gluon Docs fixed.  

#### Front

![Imp](https://img.shields.io/badge/Imp-93c47d) ![Component](https://img.shields.io/badge/Front_Web-9347dc) LivenessProbe and ReadinessProbe has been enabled.  

#### Back

![Imp](https://img.shields.io/badge/Update-11117d)
 ![Framework](https://img.shields.io/badge/Darwin-0000ab)
 ![Component](https://img.shields.io/badge/Java_Microservices-9347dc)
  ![Component](https://img.shields.io/badge/Java_Libraries-9347dc) Framework version 5.7.2. More info [here](https://gluon.gs.corp/community/docs/latest/components/software/backend/java/darwin/framework/current/CHANGELOG/).  
![Imp](https://img.shields.io/badge/Update-11117d) ![Framework](https://img.shields.io/badge/Darwin-0000ab) ![Component](https://img.shields.io/badge/Gateway-9347dc) Version 3.3.0 and deployment chart to version 3.1.0.  
![Imp](https://img.shields.io/badge/Update-11117d) ![Framework](https://img.shields.io/badge/Darwin-0000ab)
![Component](https://img.shields.io/badge/Pyton_Microservice-9347dc) Version 4.1.3 available. More info [here](https://gluon.gs.corp/community/docs/latest/components/software/backend/python/darwin/framework/changelog/)  

### Features

#### APIs

![Fix](https://img.shields.io/badge/Fix-ea9999) ![Component](https://img.shields.io/badge/API_Deployment-9347dc) ![Component](https://img.shields.io/badge/API_Product-9347dc) Validate that a draft exists before creating it.  

## Gluon v6.3.1

Feb 14, 2025

### Features

#### Release Management

![Fix](https://img.shields.io/badge/Fix-ea9999) Validation when OAM does not have any component associated. Now it is mandatory to have, at least, one component defined.  

## Gluon v6.3.0

Feb 13, 2025

### Components

#### Front - Web

![Imp](https://img.shields.io/badge/Imp-93c47d) Now only OAM strategy deployment is allowed for front-end components.  
![Fix](https://img.shields.io/badge/Fix-ea9999)![Framework](https://img.shields.io/badge/Darwin-0000ab)
![Component](https://img.shields.io/badge/Shell-9347dc) Darwin now enable SCM to redirect to an specific i18n URL due to changes on the default Nginx configuration.  

#### Back

![Imp](https://img.shields.io/badge/Imp-93c47d)![Framework](https://img.shields.io/badge/Darwin-0000ab)
![Component](https://img.shields.io/badge/Java_Microservices-9347dc) Darwin Java Microservices are no longer available. Use Darwin Java 2.0 instead.  
![Imp](https://img.shields.io/badge/Imp-93c47d)![Framework](https://img.shields.io/badge/Arsenal-0000ab)
![Component](https://img.shields.io/badge/Java_Microservices-9347dc) Arsenal Java Microservices are no longer available. Use Arsenal Java Microservices 2.0 instead.  
![Imp](https://img.shields.io/badge/Imp-93c47d)![Component](https://img.shields.io/badge/Kubernetes_Configmaps-9347dc) Kubernetes Configmaps are no longer available. Use Kubernetes Configmaps 2.0 instead.  
![Imp](https://img.shields.io/badge/Imp-93c47d)![Component](https://img.shields.io/badge/Kubernetes_Secrets-9347dc) [Application Secrets](../../components/configuration/kubernetes/application-secrets.md)
 is the new component available to store secrets from Vault and Github. Kubernetes secrets are no longer available.  

### Features

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) Deployment of multiple component versions associated to the same application release.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Better control over deployment windows, allowing more precise scheduling and management of the deployment activities.  
![Fix](https://img.shields.io/badge/Fix-ea9999) Several fixes and improvements.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc) ![Framework](https://img.shields.io/badge/PowerBI-0000ab) Component template for PowerBI.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Framework](https://img.shields.io/badge/Typescript-0000ab) Component template for Typescript actions.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Component](https://img.shields.io/badge/Github_Actions-9347dc) Action to publish in SGS portal.  
![Fix](https://img.shields.io/badge/Fix-ea9999) Several minor fixes.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Component](https://img.shields.io/badge/Github_Runners-9347dc) Databricks CLI v0.239.0 for workflows.  

#### Security

![New](https://img.shields.io/badge/New-6fa8dc) ![PKM](https://img.shields.io/badge/PKM-9347dc) Add the JWKS_URI endpoint to the issuer.  
![New](https://img.shields.io/badge/New-6fa8dc) ![STS](https://img.shields.io/badge/STS-9347dc) Add a new JWKS_URI endpoint to provide the public keys.  

#### Gluon Portal

![New](https://img.shields.io/badge/New-6fa8dc) Enable application owners configure application workspace.  
![New](https://img.shields.io/badge/New-6fa8dc) Enable team owners configure team workspace.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Github configuration button removed from Company Team Detail View.  

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) ![Metric](https://img.shields.io/badge/Metric-9347dc) Active users VS total users metric.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Metric](https://img.shields.io/badge/Metric-9347dc) Gluon Releases VS total releases metric.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Metric](https://img.shields.io/badge/Metric-9347dc) Gluon Apps VS total Apps metric.  
![New](https://img.shields.io/badge/New-6fa8dc) ![Metric](https://img.shields.io/badge/Metric-9347dc) Gluon components VS total components metric.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Daily refresh for exception information. Currently waiver information comes from a weekly refresh.  

#### Gravity

![Imp](https://img.shields.io/badge/Imp-93c47d) ![Altair](https://img.shields.io/badge/Altair-9347dc) GravityOne reports retrieval for Altair users (native & synchro models).  
![Imp](https://img.shields.io/badge/Imp-93c47d) ![Altair](https://img.shields.io/badge/Altair-9347dc) Added new input to generate JCLs artifact is needed.  
![Imp](https://img.shields.io/badge/Imp-93c47d) ![Altair](https://img.shields.io/badge/Altair-9347dc) Native model improvements.  
![Imp](https://img.shields.io/badge/Imp-93c47d) ![Partenon](https://img.shields.io/badge/Partenon-9347dc) Secrets migration from ALMMC to Gluon.  
![Imp](https://img.shields.io/badge/Imp-93c47d) ![Partenon](https://img.shields.io/badge/Partenon-9347dc) Model 2 improvements.  
![Imp](https://img.shields.io/badge/Imp-93c47d) ![Partenon](https://img.shields.io/badge/Partenon-9347dc) Synchronized model introducing TransitionalBuild workflow.  

### Local

#### Exception Management

![New](https://img.shields.io/badge/New-6fa8dc) Application Owners can no longer create QA Exceptions. Only QA team is allowed. This applies only for Santander Spain users.  
