---
title: Gluon 5.2 Release Notes
categories:
  - APIs
  - Back
  - UX & Accessibility
  - Management
  - Software CICD
  - Release
  - Insights
  - Events
  - Web
  - Infrastructure CICD
  - Testing
date:
  created: 2024-10-01
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v5.2.3

October 1, 2024

### COMPONENTS

#### APIs

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; API Deployment issue when the catalog has no space configured has been resolved.  
![Imp](https://img.shields.io/badge/Imp-93c47d) Updated the scaffolding to change the 'dev' folder environment to 'cert' and the 'value.yml' extension to facilitate its configuration.  

## Gluon v5.2.2

September 27, 2024

### COMPONENTS

#### Microservices | Darwin Java

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;  Improved the Darwin Java scaffolding to address a vulnerability in an Apache Library.  

## Gluon v5.2.1

September 25, 2024

### FEATURES

#### General

![Imp](https://img.shields.io/badge/Imp-93c47d) The Gluon Portal has been updated for optimal performance with Chrome version 129.  

## Gluon v5.2.0

September 17, 2024

### FEATURES

#### Component Management

![Imp](https://img.shields.io/badge/Imp-93c47d) The Component Detail View has been updated to include the status of your component's tools.  

#### Exception Management

![New](https://img.shields.io/badge/New-6fa8dc) New Testing Exception available that allows to deploy to production even if the functional testing in workflow is failed.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Minor improvements and fixes have been made to enhance both performance and reliability.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc) In the Base Component Template, there is a new Sonar profile "SonarWay" that allows analyzing the technologies available in SonarQube with the out of the box rules.  

#### Release Management

![New](https://img.shields.io/badge/New-6fa8dc) A new **Gluon Application Model** component is released that lets you centralize the infrastructure data required to integrate and deploy all technical application components.  
The following new components has been released to be used with it:

- **Arsenal Java Microservice 2.0**  
- **Darwin Java Microservice 2.0**  
- **Kubernetes ConfigMap 2.0**  
- **Kubernetes Secrets 2.0**  

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) A new dashboard is now available in the Component Tab, providing insights into Local components.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The "End User Computing" application is no longer included in the Gluon Apps vs APM indicator.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The ToH indicator has been enhanced with a detailed list of legacy APIs.  

### COMPONENTS

#### APIs

![New](https://img.shields.io/badge/New-6fa8dc) A new **API Deployment 2.0** component is available, simpler and more homogeneous for IBM API Connect (on-premise and PaaS) and Apigee deployments.  
![New](https://img.shields.io/badge/New-6fa8dc) A new **API Product** that allows several APIs to be included in the same product.  
![New](https://img.shields.io/badge/New-6fa8dc) The **Dictionary of Terms** validation now is not required in the API definition and API deployment workflows.  
![New](https://img.shields.io/badge/New-6fa8dc) There is a new version of API Policies that removes the dependency on APImConfig and extensions.  

#### Events

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Minor improvements have been implemented in both the Event Catalog and Event Deployment view.  

#### Front | React SPA

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; In the React SPA component, Node.js version 18.20.0 is now set by default in the runner, resolving the issue INC046000281.

#### IaC | Network Load Balancer

![New](https://img.shields.io/badge/New-6fa8dc) A new component for creating a Network Load Balancer in **Azure Load Balancer** (LBA v1.0.0) and **AWS Elastic Load Balancer** (ELB v1.0.0) has been released.  
<!-- More details can be found [here](../../components/configuration/iac/network-load-balancer/index.md).   -->

#### IaC | IAM role

![New](https://img.shields.io/badge/New-6fa8dc) A new component for creating an IAM in **AWS IAM** (IAM v1.0.0) has been released.  
<!-- More details can be found [here](../../components/configuration/iac/iam/index.md).   -->

#### IaC | Kubernetes

![Imp](https://img.shields.io/badge/Imp-93c47d) Kubernetes cluster default post-configuration (including Cert Daemonset, Dynatrace, and Dashboard) is now part of the execution workflow.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The Quality Gates workflow now incorporates Fortify SAST - SCA and Sonar scanner for EKS v1.1.0 and AKS v1.1.0.  
Also, Test cases for automated unit testing has been added.  

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Backend Framework v3.13.7** version including several Security Vulnerabilities and improvements.  
![New](https://img.shields.io/badge/New-6fa8dc) The **Arsenal Integration Framework v4.13.2** version including several Security Vulnerabilities and improvements.  

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.3.0** version is now available. This version is including:  

- Support the use of cid JWSId token claim as App-Init in application context.  
- Update Spring Boot version to v3.2.9.  
- Manage dependency of spring-integration-sftp version to solve vulnerability **CVE-2024-41909**.  
You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).  

#### Microservices | Darwin Python

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Python Framework v4.1.0** version including several fixes and improvements. More details,
 [here](../../components/software/backend/python/darwin/framework/changelog.md).  

#### Microservices | Helm Chart

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Python Helm Chart version 2.4.0** is now available including several fixes and improvements.
 More details, [here](../../components/software/backend/python/darwin/framework/helm.md).  

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin NodeJS Helm Chart version 2.4.0** is now available including several fixes and improvements.
 More details, [here](../../components/software/backend/nodejs/darwin/framework/helm.md).  

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) The Testing workflow now includes new properties that allow you to run tests directly within the workflow. This means you can easily check the logs right on the workflow.  
More details, [here](../../application/qatesting/testing/workflows/snippets/workflows-steps.md)
