---
title: Gluon 4.3 Release Notes
categories:
  - Management
  - Insights
  - Security
  - APIs
  - Back
  - Infrastructure CICD
  - Testing
  - Software CICD
date:
  created: 2024-07-11
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v4.3.0

July 11, 2024

### FEATURES

#### Application Management

![Imp](https://img.shields.io/badge/Imp-93c47d) The form for onboarding application members and owners has been redesigned to enhance user experience.  

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) A new metric, **Active Developers** has been introduced based on commit or pull-request done in Gluon Components.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The **list of APM applications** created in Gluon can be now displayed in the Application KPI dashboard.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The Deployment KPI dashboard has been enhanced with a summary view and detailed information for improved visualization.

#### Security

![New](https://img.shields.io/badge/New-6fa8dc)  A new security policy will be applied for all applications, which will enable Vault Secret management in the certification environment for all application members.

### COMPONENTS  

#### APIs

![Imp](https://img.shields.io/badge/Imp-93c47d) All applications affiliated to an API definition are now displayed in the modal view.  
![Fix](https://img.shields.io/badge/Fix-ea9999)  &nbsp;Correction in the Apigee deployment due to a problem downloading a freemarker dependency from Nexus.  

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Helm Chart v2.5.2** version is now available. This version is including:  

- Possibility to configure the Pod Node Selector.  

![Fix](https://img.shields.io/badge/Fix-ea9999)  &nbsp; The new fix version **Arsenal Backend Framework v3.12.3** for microservices and libraries is now available, including:  

- Some minor bug fixes. You can find more details [here](../../components/software/backend/java/arsenal/framework/arsenal-backend/CHANGELOG.md).

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.0.2** version is now available. This version is including:  

- Update to Spring Boot v3.2.7. You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).
- Some minor bug fixes.  

![Fix](https://img.shields.io/badge/Fix-ea9999)  &nbsp; The new fix version **Darwin Java Helm Chart v3.1.1** for microservices and libraries is now available, including:  

- Unnedeed files from chart package has been excluded. You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-helm.md).

#### Microservices | Deployment

![New](https://img.shields.io/badge/New-6fa8dc) The **ConfigMap Helm Chart v0.2.1** version is now available and introduces some key features and improvements:

- **Configmap Deployment**: Deploy ConfigMaps as environment variables in your Python and NodeJS microservices.
- **Pod Node Selector Configuration**: Specify on which nodes your pods should run.  

You can find more details [here](../../components/configuration/kubernetes/configmaps-rm.md).

#### IaC | Openshift Namespace

![Imp](https://img.shields.io/badge/Imp-93c47d) The Namespace Creation workflow has been made more resilient by ensuring the validation process is executed in all cases.  

#### IaC | Container Registry

![New](https://img.shields.io/badge/New-6fa8dc) Two new Terraform workflows to import and remove existing infrastructure on AWS and Azure has been added in the component.  
![Imp](https://img.shields.io/badge/Imp-93c47d) To keep the archetype standard, *aws_ecr* and *az_acrs* has been renamed to *aws_containerregistry* and *az_containerregistry*.  

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) Test reporter execution will now be displayed on the workflow run summary page.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Introduced a new check connection workflow across all testing components.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;The Apdex value is now accurately calculated during JMeter workflow execution.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;Addressed minor issues related to Selenium deploy action and Nitro workflow.  
