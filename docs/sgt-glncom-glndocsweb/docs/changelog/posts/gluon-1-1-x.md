---
title: Gluon 1.1 Release Notes
categories:
  - Management
  - Back
  - APIs
  - Security
  - Software CICD
date:
  created: 2023-09-18
tags:
  - Feature
  - Improvement
  - Fix
---


## Gluon v1.1.6

18^th^ September 2023

![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Optimisations have been made to improve performance and response times in membership functionality.

___

## Gluon v1.1.5

8^th^ September 2023

![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fix incident when creating component

___

## Gluon v1.1.4

30^th^ August 2023

![Static Badge](https://img.shields.io/badge/Fix-ea9999) Microservices components based on Arsenal archetype do not pass Sonar validation

___

## Gluon v1.1.3

28^th^ August 2023

![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Internal improvement on Gluon APIs for Atlassian and GitHub products
___

## Gluon v1.1.2

25^th^ August 2023

![Static Badge](https://img.shields.io/badge/Fix-ea9999) Spectral Validation Error running API Definition Workflow
___

## Gluon v1.1.1

11^th^ August 2023

![Static Badge](https://img.shields.io/badge/Fix-ea9999) Mitigating the issue when onboard an application in Fortify
___

## Gluon v1.1.0

11^th^ August 2023

![Static Badge](https://img.shields.io/badge/New-6fa8dc) Access to Gluon is now available for any new user who is not yet a member of Gluon, (with limited permissions).  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Buttons have been * added to the application for creating workspaces, allowing users to create tools if they have not been provisioned.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) An indicator of the overall status of the application has been added to determine if the entire registration and configuration process was successful.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) An overall status indicator for the component has been added to show if the entire process for its creation was successful.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) An overall status indicator has been added for each tool provided to the component to determine if all registrations were successful.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Added a version selector in the API detail view, allowing users to choose between different API versions.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) A filter has been added to the application view that allows filter by the associated business units for a selected Company.  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Retrieve application Azure configuration  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Unify JSON responses date format to "yyyy-MM-dd'T'HH\:mm\:ss.SSS'Z'"  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Refactor ToolStatus enumerate to retrieve status in lower case  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Provide a human-readable description of ApplicationCriticality types  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Retrieve business units associated to a company  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Retrieve component template configuration  
![Static Badge](https://img.shields.io/badge/New-6fa8dc) Call Get Azure Config from Onboardingback API  

![Static Badge](https://img.shields.io/badge/Improvement-93c47d) An predictive search box has been added to the company selector in the navigation bar for administrators users.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The company change selector in the top bar is locked if the user is already within an application, preventing unwanted company changes.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The usability of all onboarding forms (company, application, app owners, and member onboarding) has been improved.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Validations on the component creation form have been improved.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The user profile now shows the user's corporate ID and the user's corporate email.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Home view widgets now display items sorted by the last onboarded date.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Filters and data sorts have been added for tables.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The cursor pointers that appeared in the member's table when hovering over the rows were removed.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The team members' view now shows the redesigned user roles element.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) For clarity, the button to open new API change proposals has been renamed.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added some missing cursor pointers over some elements, such as the Gluon main menu.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Gluon templates for creating components are now displayed in alphabetical order by default.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Added informative tooltips about the portal icons.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Updated the link to the Gluon documentation in the portal footer.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) The consistency in informational texts has been improved to make them more understandable and clear.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) For better identification, new projects created in Jira will have as their PROJECT-KEY the name of the registered Technical application in Gluon.  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Remove blocking after call external services in User API clients and replace blocking retry implementation with reactive retry  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Enable ITSM Company alias validation  
![Static Badge](https://img.shields.io/badge/Improvement-93c47d) Removed unused clients  

![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fixed some authorization filter issues in certain scenarios, detecting the change of permissions according to the new role assigned to the user.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Some errors have been fixed in the creation forms for API-Deployment, Kubernetes-Configmap, and Kubernetes-Secrets components.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) A rendering issue has been fixed, resulting in a noticeable improvement in user performance and page loading speed.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) An issue has been fixed when refreshing the page in certain contexts that caused an error to be displayed in the view to the user.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) An issue has been fixed in the component creation templates that caused the documentation links to open the form and documentation at the same time.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) An issue has been fixed that caused the loss of some country flags in the company selector and widget has been fixed.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) An issue has been fixed in the widget for displaying the most recently registered applications for users with the company owner role.  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Use application technical name instead of functional name for Jira project name when creating a new one  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Components Search By Search Must applied ShortName and Name  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Sort And Pagination Get Components  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Components Search By any text column Must be Not Case sensitive  
![Static Badge](https://img.shields.io/badge/Fix-ea9999) Fix Deploy in DEV Build helm chart from 'development' to 'v1'  
