---
title: Gluon 3.2 Release Notes
categories:
  - APIs
  - UX & Accessibility
  - Management
  - Marketplace
  - Insights
  - Documentation
  - Software CICD
  - Security
  - Infrastructure CICD
  - Testing
  - Release
  - Back
date:
  created: 2024-03-26
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v3.2.2

March 26, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) The version-type *toggle switch* button for legacy APIs has been hidden. The Legacy API catalog now only shows Releases versions.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix when create a specified template on Jira project creation.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Azure AD groups are not synchronized in SonarQube Enterprise.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix to the problem when trying to subscribe to a API Deployment.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix when publishing the API Definition to the marketplace when the description contains special characters.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Error referencing the inventoryGit and git properties in the deployment-apiconnect of the scaffolding action.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Insight-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fix to the problem when a person is removed from a team, the event is not being stored in the Insights Data Base.  

## Gluon v3.2.1

March 14, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Marketplace-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix to solve the problem of APIs being duplicated in the Marketplace when deployed.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Permissions updated for Laika's GitHub App in the Ephemmeral Runner to create the tags.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Update to use the new version of Spectral rules, v3.0.1.  

## Gluon v3.2.0

March 5, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) API subscription is now available for applications through Gluon. View the API instances and versions deployed by each company,
choose the desired location, and view the associated consumption plans.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Visit the new *Integrations* section, within your application. This new section will show you the integrations made between your application and the APIs you have subscribed to.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Use the new predictive search-box in the *Infrastructure* section to quickly locate available infrastructure items.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Try the improved filters in the *Infrastructure* section of the application. The selectors show the list of available options and includes a predictive search-box on them.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Improvement of the *Application Owner Management Process*, which makes the owners registration and deleting process independent.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Improvement control over application-tools creation to meet prerequisites where at least two registered application owners are required.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed an issue about records being displayed when using pagination on tables.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fix minor errors about typos and styles.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Zero_Touch-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Integration of Zero Touch with the octane tool to consult the results of functional tests.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Creation of releases and tasks in ServiceNow: Handling timezone scenarios for different companies.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Correction of the documentation link on the release creation page.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Docs-blue)  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Zero Touch documentation updated with more details on using the functionality.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Arsenal Capability: New version **3.9.4** of Arsenal Backend.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Darwin Capability: New version **4.3.0** of Darwin Java.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Improvements Apigee deployment KVM definition + products.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Change deployment config from pom to properties.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Subscription: First Version of Gluon Api Subscription.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Darwin gateway deployment: Remove binary secrets in GitHub.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Legacy Load: execute the initialization workflow using the GitHub api instead of the on: create: event.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Legacy Load: API Definitions must be onboarded in the *API catalogue* with the long company name instead of the company’s short name (Adoption).  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) API Legacy Load: Verify github application toolchain status before creating component.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Infrastructure-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fixed when creating a namespace and assigning according name pattern of Spain.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Security-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Security Gluon ON Boarding Service (**SGON**): Add new policies onboarding applications.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Vault: Properties configuration in order to use appRegistration in Azure AD login.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Security As A Service (SECaaS) Bug fixed when onbording users in SECaaS with special characters in their email address.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-red)  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Migration of Laika components to Gluon organization (Gluon line in Gluon)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Laika Random failures not finding the repo/branch [#1011](https://github.com/santander-group-gluon/gln-adoption-entities/issues/1011){:target="_blank"}.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Laika running tasks from CI/CD cannot be online monitored or checked after execution [#1008](https://github.com/santander-group-gluon/gln-adoption-entities/issues/1008){:target="_blank"}.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Laika Waiver List not showing results [#1007](https://github.com/santander-group-gluon/gln-adoption-entities/issues/1007){:target="_blank"}.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Broken UK image flag on Gluon Testing [#1006](https://github.com/santander-group-gluon/gln-adoption-entities/issues/1006){:target="_blank"}.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  

- **Darwin Java 4.3.0**
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) New feature that allows loading i18n files from the filepath. Previously they could only be loaded from classpath.
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Update to Spring Boot 3.1.9  
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Now nimbus-jose-jwt library version is managed from Darwin instead of Spring Security. To solve vulnerability **CVE-2023-52428**  
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Updated Partenon, SAT and MDS to last versions  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Events W3CTraceContext feature was activated by default for the Events library. Now it is disabled by default.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Logging: Fix issue with empty fields when sending logs with Gluon format to Kafka.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Logging: Fix bug with Gluon format logs when using W3C traceability mode.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Authorization: Fix a bug that was initializing *clientId* and *contractId* as "null" String.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Microservice archetype: Add base folder for java sources and cache java class configuration to API First microservice.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Partenon: Now, activateLocalDateResponse property in the Darwin properties of Partenon is being transferred correctly to the created object.  

- **Arsenal Backend 3.9.4**
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Update to Spring Boot 3.2.3. Solves vulnerability in jackson.core library **CVE-2020-25649**  
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Update to nimbus-jose-jwt 9.37.3. Solves vulnerability in nimbus-jose-jwt library **CVE-2023-52428**  

- **Arsenal Integration 4.9.1**
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Update to Spring Boot 3.2.3. Solves vulnerability in jackson.core library **CVE-2020-25649**  
