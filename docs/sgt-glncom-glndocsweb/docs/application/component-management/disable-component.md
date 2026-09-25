---
title: Disable Component
---

## Introduction

The Components Management Page is your place for managing and expanding your project's components on Gluon. Discover and add new components with ease, elevating your project to new heights.

In this guide, we'll explore the key features of the Components Management Page. Navigate the component listing, search and filter by various criteria, and access detailed views revealing vital information like associated projects, dependencies, and licenses.

By the end, you will:

- Effortlessly navigate and comprehend the component listing.
- Master search and filtering for precise component discovery.
- Access detailed views with crucial project insights.

To get started, simply access the Gluon platform. Let's dive in and unleash the full potential of your project's components!

## Accessing the Components Management Page

- **Select an Application.** From the Gluon home menu, navigate to the "Applications" section, and select the desired application from the list to proceed.
![component-access-home](./images/component-onboarding-1.png)

- **Navigate to the Components Section.** Inside the selected application, locate the left-side menu. Scroll through the menu options and find the "Components" item. Click on it to access the Components page.
![component-access-home](./images/component-onboarding-2.png)

- **Exploring the Components Page.** On the Components page, you will find a comprehensive listing of all the components associated with the application.
Here you can search, filter, or add new components to your application.
![component-access-home](./images/component-onboarding-3.png)

The Components page is divided into two main sections:

- **Component Global**: Section that allows you to search for components by name or short name, and add new components to the application.
- **Components Listing**: The main section of the page is dedicated to the listing of components. Here you can find all the components associated with the application.

Each component created in Gluon shows information about the name, short name, template used for the creation of the component, its status, and the set of tools that we've configured on the component.

### Component Tools

On the right side of each component listed, a link is shown with access to the component tools.

![Template Catalog With GitHub, Sonar, Fortify and ITSM](./images/component-tools-3.png)

Below, the set of tools associated to the component:

  ![Github](./images/component-tool-github-1.png){: style="float:left;vertical-align:bottom"} `GitHub`: Link to the GitHub repository.

  ![Sonar](./images/component-tool-sonar-1.png){: style="float:left;align:baseline"} `Sonar`: Link to the Sonar project.

  ![Fortify](./images/component-tool-fortify-1.png){: style="align:baseline;float:left"} `Fortify`: Link to the Fortify project.

  ![ITSM](./images/component-tool-itsm-1.png){: style="float:left"} `ITSM`: Link to the component Catalog.

!!! warning "Only ITSM and GitHub tools are mandatory"  
    All components created from a template have a SCM (GitHub) repository and all are catalogued in ITSM tool (ITSM).  
    Quality and security gates inclusion (Sonar and Fortify tools respectively) depends on the technical component definition.

    - For components from a template that has **quality gates** defined, Gluon creates a project into **Sonar**.  
    ![Template Catalog Without Fortify](./images/component-tools-1.png){: style="width:50%"}
    
    - For components from a template that has **security gates** defined, Gluon create a Project into  **Fortify**.  
    ![Template Catalog Without Sonar](./images/component-tools-2.png){: style="width:50%"}

### Component Status

The status of the component can be:

  - `In Progress`: At least one tool creation is still in progress, with no creation failures in the rest.
  ![Component In Progress](./images/component-onboarding-3-status-in-progress.png)
  - `Ready`: All tools are rightly configured.
      ![Component ready](./images/component-onboarding-3-status-ready.png)
      - GitHub repository created, team added and scaffolding done.
      - Sonar project created and teams added.
      - SECaaS project created and teams added.
      - APM Catalog component created and associated with the application.
  - `Requires attention`. At least one tools failed in the onboarding process.
      ![Component requires attention](./images/component-onboarding-3-status-failed.png)
  - `Archived`: The component is archived and no longer active.
      ![Component archived](./images/component-onboarding-3-status-archived.png)
  - `Archived requires attention`: The component is going to be archived but requires attention due to issues in the archived process.
      ![Component archived requires attention](./images/component-onboarding-3-status-archived-requires-attention.png)
  - `Unarchived requires attention`: The component is going to beunarchived but requires attention due to issues in the archived process.
      ![Component unarchived requires attention](./images/component-onboarding-3-status-unarchived-requires-attention.png)

!!! info
    **A component will be rightly configured when all tools are rightly created and configured.**

## Disabling visibility of a component

This functionality is only available to application owners or admins.

- **Locate the Component.** On the Components page, see a button to toggle between enabled or disabled components. Use search or filter options to locate the desired component.
![component-disable](./images/component-list-appowner.png)

- **Disable the Component.** Click on the button to disable the component's visibility in Gluon.
![component-disable](./images/component-disable-1.png)

- **View Disabled Components.** Disabled components are still accessible but hidden from the main listing. You can view them by toggling the visibility filter.
![component-disable](./images/component-disable-2.png)
![component-disable](./images/component-disable-3.png)

An application member will only see the enabled components and will not be able to filter by enabled/disabled.
![component-disable](./images/component-list-appmember.png)

Congratulations! You've successfully disabled the visibility of a component in Gluon. Continue managing your components with ease and efficiency.
