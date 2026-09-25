---
title: Gluon 4.0 Release Notes
categories:
  - Infrastructure CICD
  - Testing
  - Web
  - APIs
  - Back
  - Quality
  - Software CICD
  - Security
  - Release
  - Insights
date:
  created: 2024-05-24
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v4.0.3

May 24, 2024

![Static Badge](https://img.shields.io/badge/CAPABILITIES-IaC-6A1717)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) In infrastructure shared between several companies, namespaces were created with the acronym of the principal entity. *company_short_name* is now correctly reported.

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-127F16)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Failed to submit the report to HP ALM from the Testing Platform. Detected in functional tests on-demand.  

## Gluon v4.0.2

May 17, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Workflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Duplication of the environments (cert/certification, pre/preproduction,
pro/production) during the scaffolding process (all the components) now is fixed.  

![Static Badge](https://img.shields.io/badge/PLATFORM-IaC-6A1717)  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Technical Lead Group of Gluon application is automatically added
by environment as approver to run the terraform workflow.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Security-purple)  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) New version of Fortify SaaS are updated in our platform.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-127F16)  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) The JMeter version no longer needs to be selected with a combo and the latest available version will be used.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Reviewed literals on laika front.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) The Infrastructure configuration not visible for all roles on
CI/CD section, is visible again.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Refresh issues fixed in ondemand performance creation sections.  

## Gluon v4.0.1

May 10, 2024  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Front-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Darwin SPA Archetype** - New version 0.0.10:

- Including new parameter flavour to select whether to generate the archetype using the **Security Context Manager** (SCM) and **HTTP libraries** or the **@darwin/security library**.
- New parameter **technologyVersion** to select the version of Angular with which the archetype will be generated, currently allowing versions 15 and 16.  

![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Darwin Microfront Archetype** - New version 0.0.9:

- Including new parameter flavour to select whether to generate the archetype using the **HTTP library** or the **@darwin/security library**.
- New parameter **technologyVersion** to select the version of Angular with which the archetype will be generated, currently allowing versions 15 and 16.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-127F16)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Non Ephemeral role not accessing infra at test component creation.  

## Gluon v4.0.0

May 7, 2024  

![Static Badge](https://img.shields.io/badge/PLATFORM-Release_Management-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Integration with Laika tool to query evidence from automated tests in *Release Management section*.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Improved error messages when the user fills in incorrect information in the release creation form in *Release Management section*.  

![Static Badge](https://img.shields.io/badge/PLATFORM-IaC-6A1717)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Object Storage component creation is now possible from GLUON as an infrastructure component in Azure or AWS Clouds.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Insights-113685)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New KPI %Developers Onboarded vs Total Developers.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New KPI %Gluon Applications vs Total Applications indicator.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New KPI %Gluon Legacy API's vs Total API's.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Improvement in the KPI of team members, removed people are now updated.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Workflows_CI/CD-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) **Multicloud Image Registry - AWS**: Upload immutable images in ECR and download images to deploy in EKS without stored credentials in Hasicorp Vault.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) **Appian**: Error when using proxy to connect to Appian cloud instance.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-green)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New versions of JWSID policies.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Deploy APIs Legacy deployment Apigee and Apiconnect.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Testing-127F16)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New testing component to launch performance testing: JMeter.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Launch Newman testing and JMeter performance testing execution by WFs supported on GitHub ephemeral runners.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Encode proxy password to let all chars: Adding encoding on the use of proxy during checkout test component repo.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Refresh units used on request and limits to raise pods based on newest OCP versions.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Basic Auth forced on GitHub checkout via proxy: Allow to get GitHub test component repo via proxy to every entities.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New **Image Reuse** component for reusing existing images in other applications/entities.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc)  **Arsenal Backend**: New version 3.11.0 including JPA Code Generator for SQL Types, Repository and Config.
And new Logstash Udp Appender preventing pod crashes. And Update Spring Boot version to 3.2.5.
More detail [here](../../components/software/backend/java/arsenal/framework/arsenal-backend/CHANGELOG.md).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc)  **Arsenal Integration**: New version 4.11.0 including *Altair Connector* error when there are multiple mainframe transactions. And Update Spring Boot version to 3.2.5.
More detail [here](../../components/software/backend/java/arsenal/framework/arsenal-integration/CHANGELOG.md)  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Several documentation improvements for SOAP Integration, REST Integration and extracting Encrypted object from Security Token.  

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Quality-purple)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New plugin bitegarden-sonarqube-report-2.19.4.jar in Gluon SonarQube instance.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Update plugin findbugs to his last version sonar-findbugs-plugin-4.2.8.jar.  
![Static Badge](https://img.shields.io/badge/Imp-93c47d) Update plugin yaml to his last version sonar-yaml-plugin-1.9.1.jar.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Delete plugin sonar-dependency-check-plugin.jar in Gloun SonarQube instance.  
