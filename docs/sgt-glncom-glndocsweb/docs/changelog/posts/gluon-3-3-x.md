---
title: Gluon 3.3 Release Notes
categories:
  - APIs
  - UX & Accessibility
  - Management
  - Marketplace
  - Software CICD
  - Security
  - Infrastructure CICD
  - Release
  - Back
date:
  created: 2024-04-17
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v3.3.4

April 17, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_Infrastructure-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) New SDS clusters are updated.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixes the problem when configuring a network policy URL with an https.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The infra is set up for Santander Factoring Confirming.  

## Gluon v3.3.3

April 12, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Update secrets to connect to STS for Api Deployment workflows.  

## Gluon v3.3.2

April 9, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) An issue that prevented some applications from being onboarded to the portal has been resolved.  

## Gluon v3.3.1

April 4, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix related with Laika integration in Workflow CICD.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug Fix & vulnerabilities mitigated in Darwin Java Library and Darwin Java Microservice  

## Gluon v3.3.0

April 3, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) *Gluon administrators* can now manage (add/remove) *Company-Owners* in the company.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Users with application-owner role can now manage the application's useful links.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) The application component list can now be sorted by component template name.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) The application component list now has new filters, by component status and template name.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) The *Release Management* deployment window can be configured in the Company view at *Company* level or *Application* level.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Evidence can be included in the ITSM Release in the pre-production deployment phase.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The application onboarding process now helps and ensures that registration is done within the correct company.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Access controls to application sections have been enhanced based on user affiliation.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Users with the company-owner role now see all of their company's applications by default.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Component templates are now displayed alphabetically by type.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Component creation forms have been enhanced with validations and required field flags.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The usability of the filters available in the *API subscription* process has been improved.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The usability of the filters available in the *Integrations* section of the application has been improved.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Selecting a snapshot version of an API now shows in the menu bar which options are not enabled.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The *consumer-app* selector in the API subscription process has been enhanced with infinite scrolling and search by name or description.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The Gluon main menu now displays the sections in a hierarchical order.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Some placeholders, icons, tooltips, naming consistency and displayed messages have been improved.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Include clear button in the text area on create Release Management form.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Solved an issue that prevented some applications onboarding when their ITSM code had matching results.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) The company filter in the *Legacy APIs* catalog has been fixed and now shows all available companies and search by name.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) The *API detail* view can now be accessed directly through the URL.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Expandable rows in tables are now closed correctly when paginating results.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed error when refreshing the *Release Management* page.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed error when components have a different name from the repository in GitHub in *Release Management* View.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed error standardizing the business owner and application owner emails to lower case in the Release Management view.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Wrokflows_CI/CD-blue)  

- **NPM & Maven Libraries**  
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) Add create automatic draft release and git tag in Maven and NPM library workflows (Gitflow workflows)  
- **NPM**  
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) Integrate Laika into NPM CD workflows for functional tests  
- **APIs**  
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) Improvements to the API deployment & definition archetype  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  

- **Arsenal Backend 3.10.0 & Arsenal Library 3.10.0**  
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) Error handling messages I18n and L10n support.  
    - ![Static Badge](https://img.shields.io/badge/New-6fa8dc) Encrypted Object extraction from Security Token.  
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Updated com.squareup.okio:okio-jvm 3.3.0 library to 3.4.0 version.  
    - ![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Updated org.apache.zookeeper:zookeeper 3.4.14 library to 3.7.2 version.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixes some Sonar issues detected in archetype generated code.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Updated com.fasterxml.jackson.core:jackson-databind:2.10.1 library for fixing vulnerabilities CVE-2022-42004, CVE-2022-42003, CVE-2021-46877, CVE-2020-36518 and CVE-2020-25649.  

- **Arsenal Integration 4.9.2**
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Updated SpringBoot v3.2.3 to version 3.2.4 for fixing vulnerabilities CVE-2022-42004, CVE-2022-42003, CVE-2021-46877, CVE-2020-36518, and CVE-2020-25649.  
    - ![Static Badge](https://img.shields.io/badge/Fix-ea9999) Updated Apache Camel version 4.0.3 to version 4.0.4 for fixing vulnerability CVE-2024-22371.  
