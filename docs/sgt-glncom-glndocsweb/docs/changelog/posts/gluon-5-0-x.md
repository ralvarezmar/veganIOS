---
title: Gluon 5.0 Release Notes
categories:
  - Back
  - Software CICD
  - Release
  - Infrastructure CICD
  - Insights
  - Management
  - Events
  - Web
  - Gravity
  - Testing
date:
  created: 2024-08-08
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v5.0.3

August 8, 2024

### COMPONENTS

#### Microservices | Darwin Java

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Resolved the issue in the scaffolding creation when the "call database" option was not selected.  

## Gluon v5.0.2

August 6, 2024

### FEATURES  

#### CI/CD

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;  Resolved the issue when publishing a Base Component Template of type "Local".

#### Release Management

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Release creation button behavior has been improved to avoid multiple release creation in the same process.

### COMPONENTS

#### IaC | Openshift Namespace

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The size of namespace description field has been limited to 62 characters to be aligned with the Openshift cluster rules.

## Gluon v5.0.1

August 1, 2024

### FEATURES

#### Insights

![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; Application Component dashboard updates when components changes.

## Gluon v5.0.0

July 29, 2024

### FEATURES

#### Exception Management

![New](https://img.shields.io/badge/New-6fa8dc) A new kind of exception related to a production incident raised in Service Now with **criticality equal or higher than P3** is now available.  
More details can be found [here](../../application/exceptions-management/incidence-exceptions.md)  
![Imp](https://img.shields.io/badge/Imp-93c47d) New filter button by exception type, category and status has been added in the exception list.  
![Imp](https://img.shields.io/badge/Imp-93c47d) New data column has been added in the exception list such as the full name of creator and a hiperlink to ITSM ticket.  

#### CI/CD

![New](https://img.shields.io/badge/New-6fa8dc) New component that will create a **base component** template that will let define and create local or global custom components to be used in Gluon.  
More details can be found [here](../../contribute/base-component-template/index.md).  
![New](https://img.shields.io/badge/New-6fa8dc) It has been added a new step in the CI/CD workflow to run a image security scan using the Sysdig tool before pushing it to registry. [More details](../../application/ci-cd/sysdig/index.md)  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp;Resolved the issue when the Fortify Timeout was 45 minutes.

#### Insights

![New](https://img.shields.io/badge/New-6fa8dc) A new metric, **Github license consumption** based on Github commit and pull request has been added.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The Insights portal can now be accessed from a new link added in the Gluon portal footer.  
![Imp](https://img.shields.io/badge/Imp-93c47d) The dashboard look&feel has been modified in order to improved the user experience.  

### COMPONENTS  

#### Events

![New](https://img.shields.io/badge/New-6fa8dc) A  **Event catalog** section has been added in the Marketplace menu to display an Event definitions created in Gluon. [More details](../../components/software/events/definition/index.md)  
![New](https://img.shields.io/badge/New-6fa8dc) A new section **Event deployment** has been added in the Marketplace menu to display a list of topics that have been deployed in the Entity's infrastructure.  
![New](https://img.shields.io/badge/New-6fa8dc) A new component **Event deployment** has been added to Component List for creating Event deployment repositories. [More details](./../../components/software/events/deployment/index.md)  

#### Front | Libraries  

![New](https://img.shields.io/badge/New-6fa8dc) New **Android Library** component that will help you to create, build and publish Android Library. [More details](../../components/software/front/mobile/android/lib.md)  
![New](https://img.shields.io/badge/New-6fa8dc) New **iOS Library** component that will help you to create, build and publish iOS technical and functional library. [More details](../../components/software/front/mobile/ios/lib.md)  
![New](https://img.shields.io/badge/New-6fa8dc) New **React Library** component that will help you to create, build and publish React technical and functional library. [More details](../../components/software/front/web/react/lib.md)  
![New](https://img.shields.io/badge/New-6fa8dc) New **@santander/shell library** available in the artifact repository to load a Gluon Microfront in any kind of Gluon Shell.
 [More details](../../components/software/front/web/core/shell/index.md)  
![Imp](https://img.shields.io/badge/Imp-93c47d) Evolution of the following libraries:

- SCM mobile library (for iOS & Android) to fit Customer Identity Platform (CIP) requirements.  
- Web library @santander/security (a.k.a. SCM) towards the new proposed Security Model to integrate the ODS framework.  
- @santander/state (a.k.a. State) towards the new proposed Security Model to integrate the ODS framework.  

#### Gravity | Gravity Altair Sync

![New](https://img.shields.io/badge/New-6fa8dc) Object management in model synchronized for JCL, Sysin and procedures has been added.  

#### Microservices | Arsenal

![New](https://img.shields.io/badge/New-6fa8dc) Java native compilation support has been included for Arsenal Backend framework.  

#### Microservices | Darwin Java

![New](https://img.shields.io/badge/New-6fa8dc) The **Darwin Java Framework v5.1.0** version is now available. This version is including:  

- Update to Spring Boot v3.2.8. You can find more details [here](../../components/software/backend/java/darwin/framework/darwin-5-x/CHANGELOG.md).
- Oracle and PostgreSQL archetypes that integrate the use of Database.
- Automatic code generation using DDL.  
- Gluon Partenon plugin to generate Partenon services in an automatic way.
- Some minor bugfixes and improvements.  

#### Microservices | Photon

![New](https://img.shields.io/badge/New-6fa8dc) A new framework called **Photon based in Java/Quarkus** for building microservices and libraries has been released.  
More details can be found [here](./../../components/software/backend/java/photon/framework/current/index.md).  

#### IaC | Encryption Manager

![New](https://img.shields.io/badge/New-6fa8dc) A component for creating an Encryption Manager in **Azure Key Vault** (AKV v1.0.0) and **AWS Key Management Service** (KMS v1.0.0) has been released.  
<!-- More details can be found [here](../../components/configuration/iac/encryption-manager/index.md).   -->

#### IaC | Kubernetes

![New](https://img.shields.io/badge/New-6fa8dc) A component for creating a Kubernetes in **Azure Kubernetes Services** (AKS v1.0.0) and **AWS Elastic Kubernetes Service** (EKS v1.0.0) has been released.  
<!-- More details can be found [here](./../../components/configuration/iac/kubernetes/index.md).   -->

#### IaC | Object Storage

![Imp](https://img.shields.io/badge/Imp-93c47d) Two new Terraform workflows to import and remove existing infrastructure on AWS and Azure has been added in the component.  

#### IaC | Openshift Namespace

![New](https://img.shields.io/badge/New-6fa8dc) It has been added a new functionality that let creating a egress networkpolicy for your Openshift namespace.  
[More details](../../components/configuration/kubernetes/namespace_harbor.md#file-gluoncdenvegressnetworkpolicyyaml)  
![Imp](https://img.shields.io/badge/Imp-93c47d) Namespace creation workflow in the production environment has been improved including new validations.  

#### Testing

![New](https://img.shields.io/badge/New-6fa8dc) An email is now sent directly when the test component workflow is finished. [More details](../../application/qatesting/testing/workflows/utilities/email.md)  
![New](https://img.shields.io/badge/New-6fa8dc) A version validation action has been added to check if the version testing workflow is correct. [More details](../../application/qatesting/testing/workflows/utilities/check-version.md)  
![Imp](https://img.shields.io/badge/Imp-93c47d) Some user experience improvements has been included.  
![Fix](https://img.shields.io/badge/Fix-ea9999) &nbsp; The issue when an ephemeral runner in the Cloud Section should be selected the first time has been resolved.  
