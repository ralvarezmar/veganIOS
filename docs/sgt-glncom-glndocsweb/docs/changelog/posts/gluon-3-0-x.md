---
title: Gluon 3.0 Release Notes
categories:
  - APIs
  - UX & Accessibility
  - Management
  - Documentation
  - Back
  - Software CICD
  - Release
  - Security
  - Insights
  - Infrastructure CICD
  - Testing
date:
  created: 2024-02-08
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v3.0.1

February 8, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fix on the onboarding of a team member with a special email character.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fix on the query that searches the release-candidate versions of components in elasticsearch in new Releases View.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fixed when executing Scaffolding Action some jobs are executed when not needed.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Error when no secrets defined in appian properties files.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Updated Arsenal Backend framework to version 3.9.3 including: Fix Spring Core 6.1.2 Vulnerability CVE-2024-22233 & Improve archetype Sonar coverage.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug to solve the problem when virtualizing an API and change the Organization.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Improvement to allow cyclical reference in API virtualization.  

## Gluon v3.0.0

February 5, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Ephemeral Runners adoption process for Private Cloud. It consists of a horizontal autoscaling that increases the number of parallel executions,
achieving an improvement in workflow execution times.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Software Catalog: Include how to discover the technical application identifier in ITSM.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Filters have been added to the infrastructure views.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Corporative ID has been added in the team members view of the application. Search and sort a member by this value.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Detection of application already onboarded in the onboarding process.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Control over components that will not have security assurance tool.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Duplicated notification fixed.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Adecuated placeholder searchers.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Zero_Touch-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Releases** menu in the application UI on the Gluon portal.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Feature for creating a release through the portal (for a component).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Feature that lists the releases created by the gluon portal.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Feature to change the release status in servicenow.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Feature to display the workflow with the release phases.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Feature for orchestrating deployment via the Gluon portal.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Security-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Gluon relies on **Hashicorp Vault** for its secret management, and they will be gradually moved there.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Insights-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) First version of the dashboard of applications and components to measure the use of the Gluon platform.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Infraestructure_As_A_Code-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Infraestructure** menu in the application UI on the Gluon portal, for managing Namespaces in Openshift Clusters for OHE Clusters and Harbor projects.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Docs-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Gluon Docs updated.

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) GLUON component for  Darwin Gateway deployment - ONLY FOR SPAIN USE.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) GLUON component for API deployment in Darwin Gateway - ONLY FOR SPAIN USE.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Deployment for **IBM Apiconnect V10** offering next improvements:
Allow user to configure API deployments by space or catalog. Allow configure all use cases security (global): [authorization-code | authorization-code-cosac | authorization-code-jwsid | jwt-profile | jwt-profile-cosac | jwt-profile-jwsid |
client-credentials | client-credentials-cosac | client-credentials-jwsid | jwt | jwsid].
Allow user configure scopes by operations in API Product deployments.
Inventory for entities API Managers configuration; allow entities for make pull requests to configure environments for deployment and exposition use cases.
Allow users to configure custom plans for APIS, and a default plan for all API deployments.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Deployment for **APIGee** allow deploy APIs for JWSID and COSAC use cases.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) JWSID new validation and generation  of iat, and nbf.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Darwin Java version 4.2.0** for libraries and microservices, which includes: New API First approach in microservices creation and Upgrade Spring Boot version to **3.1.8**.  ****
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Arsenal Backend version 3.9.0** for libraries and microservices which includes: Get channel identifier from JWSId Token and ArchUnit rules equalized to Gluon custom rules.
Upgrade Spring Boot version to **3.2.0**.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Arsenal Integration** version for microservices which includes: Secure microservices with Spring Security 6 and Add ArchUnit plugin to framework.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Gluon component to create **NodeJS libraries** for backend developments.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Darwin NodeJS version 3.0.5** for libraries and microservices which includes: Fix a version in archetype generation.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Blue & green deployment process for microservices.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Front-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Blue-Green deployment reference for front journeys.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Testing Framework: **Nitro**.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Testing Framework: **Cilantrum**.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Testing Framework: **Newman**.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) A fix is created to solve a problem with the namespace Quota [#881](https://github.com/santander-group-shared-assets/gln-adoption-entities/issues/881)  
