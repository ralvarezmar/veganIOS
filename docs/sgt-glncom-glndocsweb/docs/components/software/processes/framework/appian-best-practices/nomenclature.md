# Nomenclature

## Overview

This pages provides standard Appian design objects. For many design objects we recommend:

* Short and descriptive name.
* Always include a description to give more detail.
* The name should not use only capital letters.
* Spaces and not underscores should be used to separate words.

## Applications

  * Always start with a prefix.
  * The objects of an application must be prefixed with the prefix of the application rules.
  * Using the prefix when creating an application allows you to avoid having to include it in the application name.

???+ example
    Name: HR Onboarding

## Data Object

### Data Store

* Start the name with the application prefix.
* Use title case with spaces.
* The name must be unique in the Appian environment

???+ example
    Name: HRO Employee Data

### Custom Data Type

* Start the name with the application prefix.
* Use title case with underscores.
* Keep the names assigned to your custom data types and CDT elements shorter than 27 characters.
* Names must start with a letter or an underscore, and may contain only letters, numbers, hyphens, periods, and underscores.
* The name must be unique in the Appian environment.
* Use a custom namespace for your CDTs to group them and associate them with a specific application.

???+ example
    Name: HRO_Employee_Data  <br> namespace: urn:appian:hro

### Record Type

* Start the name with the application prefix.
* Use a short, descriptive, singular name. Appian creates a plural name (without the prefix) that is displayed to end users.
* The name must be unique in the Appian environment

???+ example
    Name: HRO Employee

## Process objects

### Process Model

* For most process models, process model folders, and running process instances, start the name with the application prefix.
However, if you've configured a related action to use the process model name for the action's display name, don't use the prefix in the process model name.
* Use title case with spaces.
* For running process instances, include key data points in the name to help identify the process instances in a process report.
* The name can be the same as another object's name in the same environment.

???+ example
    Name: HRO Onboard New Employee <br> Running instance: HRO Onboard John Doe * 2014 01 01

### Process Report

* Start the name with the application prefix.
* Use title case with spaces.
* The name can be the same as another object's name in the same environment.

???+ example
    Name: HRO-I9-retrieval

### Robotic Tasks

* Start the name with the application prefix.
* If the robotic task isn't associated with an Appian application, use a prefix that can be used for all related object names.
* The name must be less than 100 characters.
* Use letters, numbers, underscores, periods, and dashes only.
* The name must be unique in the Appian environment.

???+ example
    Name: CSC Claims

## User objects

### Interface

* Start the name with the application prefix.
* Use Pascal case.
* Do not use special characters or spaces.
* Use an underscore between the application prefix and the rest of the name.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_AddNewEmployee

### Report

* Do not start the name with the application prefix, because the name is intended to be seen directly by end users.
* Use a short, descriptive name that is meaningful to the end users.
* Because a report is composed of several graphical elements (grids and charts) as well as editable fields used to filter and sort the report data, the report name should not be narrowed down to a specific timeframe or subset of the data.
* Do not suffix the report name with Report.
* The name can be the same as another object's name in the same environment.

???+ example
    Name: HR Onboarding Department

### Site

* Start the name with the application prefix; the site name is internal and won't be seen directly by end users.
* For the site display name, don't start the site display name with the application prefix, because end users will see it directly in the site navigation menu and browser tab.
* Use a short site display name that is meaningful to end users.
* Use title case for site display names.
* When you create a site, Appian uses the site display name to construct a web address identifier for the site by default. To define the site URL, edit the default web address identifier. The web address identifier must be unique.
* After you've created a site, the web address identifier (URL) won't automatically update if you edit the site display name or define it using an expression.

???+ example
    Name: HRO Onboarding  <br> Site Display Name: Onboarding

### Portal

* Start the name with the application prefix.
* If the robotic task isn't associated with an Appian application, use a prefix that can be used for all related object names.
* The name must be less than 100 characters.
* Use letters, numbers, underscores, periods, and dashes only.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO Registration  <br> Portal Display Name: Account Registration

## Rule objects

### Constant

* Start the name with the application prefix. Optionally, use an additional prefix to group related constants.
* Use uppercase for all letters.
* Do not use special characters or spaces.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_IMG_CAREER_HISTORY_ICON

### Decision

* Start the name with the application prefix.
* Use Pascal case.
* Do not use special characters or spaces.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_DetermineEligibilityStatus

### Expression Rule

* Start the name with the application prefix. Optionally, use an additional prefix to group related rules.
* Use Pascal case.
* Do not use special characters or spaces.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_GetEmployeeOnboardingTasksStatus

### AI Skill

* Start the name with the application prefix. Optionally, use an additional prefix to group related rules.
* Use Pascal case.
* Do not use special characters or spaces.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_ClassifyPurchaseOrders

## Integration objects

### Connected System

* If the connected system will be used by a single application, start the name with the application prefix. Otherwise, do not use an application prefix.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO Google Drive

### Integration

* Start the name with the application prefix.
* Use Pascal case.
* Do not use special characters or spaces.
* Use an underscore between the application prefix and the rest of the name.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO_getApplicationInformation

### Web API

* Start the name with the application prefix.
* The name can use special characters and spaces.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO Get LinkedIn Profile

## Group objects

### Group

* Start the name with the application prefix, except when the group is intended to be seen directly by end users. For example, you would not use the prefix for a Tempo audience group.
* Use a short, descriptive name for each group.
* Create a parent group named for each application.
* Name child groups according to their security role.
* Each application should include the following child groups at a minimum:
* Application Administrators
* Application Users.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO HR Onboarding

### Group Type

* Start the name with the application prefix.
* Use a short, descriptive name that clearly indicates the business purpose that connects the groups in the group type.
* The name must be unique in the Appian environment.

???+ example
    Name: HRO Corporate

## Content-management objects

### Document

* Start the name with the application prefix, except when the document is intended to be seen directly by end users.
* The name must be at least four characters long (including the three character file extension, such as .doc).
* If you use any of the following characters in the name, Appian replaces the character with an underscore: \ / ; : | ? ' < > *
* If you include the file extension in the name, make sure it matches the file type by which the file was saved.
* If the extension in the name does not match with the uploaded file, it may not display properly.
* The name can be the same as another object's name in the same environment..

???+ example
    Name: HRO_ProfilePhoto_Employee223

### Folder

* These recommendations apply to all folder types, including knowledge centers and document folders.
* Start the name with the application prefix.
Use title case with spaces.
* Use standard names across applications for folders that serve the same purpose. For example, you would use HRO Process Models to store process models in the HRO application.
* For rule folders, the name must be unique in the Appian environment. For any other type of folder, the name can duplicate another name

???+ example
    Name: HRO Interfaces

## Notification objects

### Feed

* Do not start the name with the application prefix, because the name is intended to be seen directly by end users.
* Use a short, descriptive name that is meaningful to end users.
* The name can be the same as another object's name in the same environment.

???+ example
    Name: New Hire Feed

## Object properties

### Action

* These recommendations apply to application actions (visible in the Actions tab in Tempo) and record actions (visible in record views).
* Do not start the name with the application prefix, because the name is intended to be seen directly by end users.
For example, in Tempo, application actions are grouped by application names using filters, and in record views, record action names appear in buttons and links.
* Use a short, descriptive name that is meaningful to the end users.

???+ example
    Application action: Start New Employee Onboarding <br>  Record action: Update Employee

### Variable / Rule Input

* Do not start the name with the application prefix.
* Use camel case to differentiate words without adding clumsy underscores.
* Use the suffix List to indicate that the variable is a multiple.

???+ example
    Name: firstName
