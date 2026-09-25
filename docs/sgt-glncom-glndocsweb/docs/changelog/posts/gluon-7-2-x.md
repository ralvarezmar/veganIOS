---
title: Gluon 7.2 Release Notes
categories:
  - Release
  - Software CICD
  - Security
  - APIs
  - Back
  - Security
  - Testing
date:
  created: 2025-04-30
tags:
  - Feature
  - Improvement
  - Fix
---


## Gluon v7.2.3  

April 30, 2025

### Bug Fixes  

![Capability](https://img.shields.io/badge/Release_Management-yellow)  

- Correction of the invocation URL construction to Octane BR  
&nbsp;

## Gluon v7.2.2  

April 28, 2025

### Bug Fixes  

![Capability](https://img.shields.io/badge/CICD-red)  

- Upgrade reusable workflow to latest version 1.27.1 for npm in GTW  
- [DAST] Dast Failing to Send Data to Opensearch  
&nbsp;

![Capability](https://img.shields.io/badge/Banksphere-lightyellow)  

- Sailpoint crossviewer role validation error: User role validation fails in Sailpoint API when path doesn't exist in JSON response  
&nbsp;

## Gluon v7.2.1  

April 24, 2025

### What's New  

![Capability](https://img.shields.io/badge/CICD-red)  

- Some component templates minor changes and improvements:  

    - Typescript actions component template: User documentation added  
    - Helm chart component template: Add new tbd, fix and release wf  
    - Reuse image:

        - Include Springboot and Tomcat to PaaS (Java War) as available technologies.

    - Binaries component template: Eliminate technologies that have proprietary components, add RPM technology, and allow uploading Large files (LFS GitHub function).
    - Reuse artifact Component template:

        - Add Pythonbatch as component_type.
        - Update component template to add default information in cd.yml files
- Artifact upload to binary repository when deploying a container based component (mvn, py)  

### Bug Fixes  

![Capability](https://img.shields.io/badge/CICD-red)  

- Default environment approval team functionality is not working for organization access teams in the repository  
&nbsp;

## Gluon v7.2.0  

April 22, 2025

### What's New  

![Capability](https://img.shields.io/badge/CICD-red)  

- Deployment checks are now aligned with Release Management strategy: approvals removed in RM deployments to any environments, and DevOps default  
team added as approvals when manually deploying to production.  
- Some component templates minor changes and improvements:  

    - Typescript actions component template: User documentation added.
    - Helm chart component template: Add new tbd, fix and release wf  
    - Reuse image:

        - Include Springboot and Tomcat to PaaS (Java War) as available technologies.

    - Binaries component template: Eliminate technologies that have proprietary components, add RPM technology, and allow uploading Large files (LFS GitHub function).
    - Reuse artifact Component template:

        - Add Pythonbatch as component_type.
        - Update component template to add default information in cd.yml files  
- Artifact upload to binary repository when deploying a container based component (mvn, py)  
&nbsp;

![Capability](https://img.shields.io/badge/Capabilities_APIs-darkblue)  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *IBM API Connect* - Create subscriptions in spaces instead of catalogs, if spaces are enabled  
- *IBM API Connect* - Delete Product Draft only if the Product Publication step fails  
- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *AWS API Gateway* - Create stage variables without apiId to be used in the API configuration, for example,
to integrate with .corp domains  
- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *AWS API Gateway* - Configure authorization by Lambda authorizer in OAM to ensure that developers always include the
Lambda configuration  
- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *AWS API Gateway* - Configure Lambda authorizer at the API level if it is the same for all operations  
&nbsp;

![Capability](https://img.shields.io/badge/Capabilities_back-blue)  
*Darwin Java microservice* component including:  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) Darwin Java framework v6.1.0 including:  
  - ![Capability](https://img.shields.io/badge/NEW-lightgreen) New properties to disable kafka validation for:  
      - Darwin Logging (darwin.logging.kafka.validation.enabled)  
      - Gravity (darwin.logging.gravity.kafka.validation.enabled)  
  - Optimize validation of the connection to Kafka for Gravity topics  
- Dockerfile to latest java base image  

*Darwin Java library* component including:  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) Darwin Java framework v6.1.0.  
  
*Arsenal microservice* component including:  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *Arsenal Backend framework* v3.18.1 including:  
    - Spring Boot to version 3.4.4.  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *Arsenal Backend framework* v4.16.0 including:  
    - Spring Boot to version 3.4.4.  

- Dockerfile to latest java base image  

*Arsenal library* component including:  

- ![Capability](https://img.shields.io/badge/NEW-lightgreen) *Arsenal Backend framework* v3.18.1.  

![Capability](https://img.shields.io/badge/NEW-lightgreen) *Darwin Python deployment Chart* v2.5.0 including:  

- Allow changing the service account that executes the pod using the serviceAccountName properties  
- Add a HorizontalPodAutoscaler using the autoscaling.hpa properties  
- Add a PodDisruptionBudget using the pdb properties  

![Capability](https://img.shields.io/badge/NEW-lightgreen) *Darwin NodeJS deployment Chart* v2.5.0 including:  

- Allow changing the service account that executes the pod using the serviceAccountName properties  
- Add a HorizontalPodAutoscaler using the autoscaling.hpa properties  
- Add a PodDisruptionBudget using the pdb properties  
&nbsp;

![Capability](https://img.shields.io/badge/SecurityService_SGON-darkgreen)  

- Added in auth jwt role creation an '*' at the end of bound_claims.sub to allow multi-environment and multi-component integrations  
- darwin-spring-boot-starter-parent image updated to release v6.0.3.  
&nbsp;

![Capability](https://img.shields.io/badge/Testing-blue)  

- The migration of outdated templates aims to automate the correction of errors encountered during cross-group mapping with projects  
&nbsp;

### Bug Fixes  

![Capability](https://img.shields.io/badge/Testing-blue)  

- SendReport optimized of Performance Service: The sendReport function has been optimised for improved performance regarding the report path from HP-ALM  
- ​Passphrase Use for Performance Service: An issue in the Performance Service, that was preventing tests from deploying on OpenShift when using a passphrase, has been resolved  
&nbsp;

![Capability](https://img.shields.io/badge/Release_Management-yellow)  

- During the scaffolding process, when incorporating the default approval team into the specified environments (certification, preproduction, and production),
it is important to note that if the team being added does not have direct access to the repository, they cannot be designated as reviewers. The issue arises because the action
retrieves teams from the repository, and the returned list includes both teams with direct access and those with organization access  
&nbsp;

![Capability](https://img.shields.io/badge/Capabilities_APIs-darkblue)  

- *Apigee* - Set the default expiration time of the jwsid token to 60 min  
- *Apigee* - Return a 404 if a path that does not exist in the API is consumed  
&nbsp;

![Capability](https://img.shields.io/badge/Capabilities_back-blue)  

- *Darwin Java microservice* component: Solve issue that avoid create a Darwin Async  
- *Darwin Java microservice* component: Bug fix that caused logging configuration (both Darwin and Gravity logging) to fail  
