---
title: Gluon 6.5 Release Notes
categories:
  - Infrastructure CICD
  - Software CICD
  - Testing
  - Security
  - Quality
  - Release
date:
  created: 2025-03-20
tags:
  - Feature
  - Improvement
  - Fix
---

## Gluon v6.5.2

March 20, 2025

### Bug Fixes

![Capability](https://img.shields.io/badge/IaC-green) You can now create namespaces with identical names across different clusters (INC051584504).  
![Capability](https://img.shields.io/badge/CICD-blue) The workflow now can retrieve variables from the pom.xml (INC050753103).  
![Capability](https://img.shields.io/badge/CICD-blue) Resolved the issue with building the application in the Fortify action (INC052037986).  
![Capability](https://img.shields.io/badge/CICD-blue) Optimized the call to the GitHub API to verify if the PR has been created during the setup of the base component template workflows (INC051235730).  
![Capability](https://img.shields.io/badge/Testing-darkred) A Gluon Docs documentation review has been conducted to update all DNS references and any mentions of Laika.  
![Capability](https://img.shields.io/badge/STS_Service-purple) Add assert audience mandatory in token generation.  
![Capability](https://img.shields.io/badge/STS_Service-purple) Add claimRegexp to configuration to modify extraClaims.  

## Gluon v6.5.1

March 18, 2025

### What's New

![Capability](https://img.shields.io/badge/Sonar-darkblue) Excluding test folders from analysis (INC051410512).  

## Gluon v6.5.0

March 13, 2025

### What's New

![Capability](https://img.shields.io/badge/Release_Management-blue) New column "Release Version" added to Releases table view.
 This column will display the version of the application to be deployed.  
![Capability](https://img.shields.io/badge/Release_Management-blue) New Cursor focus behaviour. Now Release Management views have the same behaviour than the rest of Gluon Portal, keeping the focus on the form fields when selected.  

### Bug Fixes

![Capability](https://img.shields.io/badge/Release_Management-blue) Error installing Release Management Deploy Action on Brazil runners (INC052192563).  
![Capability](https://img.shields.io/badge/Release_Management-blue) "New release" button enabled when the technical application does not have a customized configuration in Release Management admin page.  
![Capability](https://img.shields.io/badge/STS_Service-darkgreen) Null pointer with security logging when body is "null" (INC051892902).  
