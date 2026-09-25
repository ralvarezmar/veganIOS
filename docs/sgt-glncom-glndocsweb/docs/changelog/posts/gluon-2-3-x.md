---
title: Gluon 2.3 Release Notes
categories:
  - APIs
  - UX & Accessibility
  - Management
  - Marketplace
  - Documentation
  - Back
date:
  created: 2024-01-25
tags:
  - Feature
  - Improvement
  - Fix
---
## Gluon v2.3.2

Jaunary 25, 2024

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Blocking the runners between them when executing a Legacy API migration.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) A fix is released to avoid launching the quality workflow for the type of API Legacy components, since this type of control is not applied and resources are being consumed unnecessarily.  

## Gluon v2.3.1

Jaunary 23, 2024

![Static Badge](https://img.shields.io/badge/CAPABILITIES-APIs-red)  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Bug fixes when deploying with Gluon Pipelines a legacy API or an API deployment with a long description field.  

## Gluon v2.3.0

Jaunary 17, 2024

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Portal-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) User Management: Remove any team member from the application easily. (requires application owner privileges).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) User management: Add new roles or delete roles assigned to each member of the application. (requires application owner privileges).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) User Management: Add more users as company owners from the company details view easily. (requires admin privileges).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Component Management: Application components are now automatically catalogued in ITSM-APM when they are created.
Use the new ServiceNow icon on your component to access them in APM or to catalogue pending ones.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Component management: Register the application components with a single click in any associated tool (GitHub, Sonar, Fortify, ServiceNow).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New ReadOnly mode for users not yet onboarded in Gluon (anonymous users).
It allows them to consult sections of interest, such as the Marketplace APIs catalogue, and basic information on companies and applications.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) For the company onboarding process, it is now checked whether the company is already registered in Gluon. If yes, the process is prevented and a notification is displayed.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) For the application onboarding process, it is now checked whether the application is already registered in Gluon for the selected company.
If yes, the process is prevented and a notification is displayed.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The API deployment component creation form, from the API detail view, now checks that the application has the required GitHub tool configured in advance.
If not, it prevents the process and a notification is displayed.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) An "autofill not available" notification is displayed when using the creation of an API deployment component from within the application
without having previously copied the required API reference data to the clipboard.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) In the API detail view, the button to create a new API deployment component remains locked when selecting API snapshot versions.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) A link to the Gluon documentation has been added to the API deployment form from the API detail view to improve user access to technical information.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) A quick search by category tags of the component templates is now possible by clicking directly on any of them.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added infinite scrolling to the country selector on the company onboarding form. Also, the country filter in the companies view now shows only those already registered in Gluon.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added infinite scrolling to improve interaction in the component templates grid view.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added scrolling bar to view the full list of application owners.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added scrolling bar to application team member onboarding form.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The cancel button on filters now has dual behavior: simple cancel or clear filters when some value has been selected.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Use the tab key to navigate through onboarding form fields to a more versatile experience.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Sorting icons have been added to the column headers of tables to improve usability.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Some improvements to the responsive design of lists and tables.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed a bug in Marketplace BIAN filters, with those filter values containing more than 30 characters.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed a bug that prevented the onboarding of users with corporate identifiers (IDs) smaller than 6 digits.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed an unnecessary hostname that appeared as part of the operation path in the API detail view.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed a pagination bug in the Legacy APIs catalogue.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed the country flag icon appearing next to the company name in the detail view of an application.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Minor corrections to page titles, form labels, typographical styles, typos and placeholder text in search boxes.  

![Static Badge](https://img.shields.io/badge/PLATFORM-Gluon_Docs-blue)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New section for Gluon [videos](./../../training/index.md).

![Static Badge](https://img.shields.io/badge/CAPABILITIES-Back-red)  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) New version for Microservice Java Darwin 4.1.1, that includes an update to SpringBoot 3.1.6 version in order to resolve vulnerabilities,
also includes a new functionality to retrieve the Framework Channel through the JWSiD.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Added documentation regarding [Darwin NodeJS](../../components/software/backend/nodejs/darwin/framework/index.md) framework in Gluon Community.
