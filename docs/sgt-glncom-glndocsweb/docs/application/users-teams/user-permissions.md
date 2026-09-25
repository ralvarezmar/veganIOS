---
title: User Permissions
---

This section explains the different users available in Gluon and the licenses of each role in the tools available within the Gluon platform.

## Permissions by role

In this section, we will explain which actions can be performed by each type of user in Gluon and the roles that can be assigned to each user.

### :fontawesome-solid-building-user: Company owner

The actions that can be performed by a company owner in the Gluon portal are:

- [Create a new application](../application-management/index.md#onboard-application)
- [Onboard a user as an application owner in the application](../application-management/application-owners-management.md#onboarding-application-owner)
- [Remove an application owner from the application](../application-management/application-owners-management.md#removing-application-owner)
- [Provide GitHub tool to the application](../application-management/application-tools-management.md#github)
- [Provide Jira tool to the application](../application-management/application-tools-management.md#jira)
- [Provide Confluence tool to the application](../application-management/application-tools-management.md#confluence)
- [Provide Secret Storage to the application](../application-management/application-tools-management.md#secrets-storage)

!!! warning ""
    :fontawesome-solid-triangle-exclamation: No roles are assigned for company owners in applications.

### :fontawesome-solid-user-tie: Application owner

The actions that can be performed by an application owner in the Gluon portal are:

- [Onboard a user as an application member with different roles in the application](../application-management/application-members-management.md#add-new-members-to-a-team)
- [Update roles of an application member](../application-management/application-members-management.md#editing-a-team-member)
- [Delete an application member](../application-management/application-members-management.md#removing-a-team-member)
- [Create a new component in the application](../component-management/create-component.md#adding-new-components-to-your-application)
- [Register a component](../component-management/component-catalog.md)
- [Provide GitHub tool to the application](../application-management/application-tools-management.md#github)
- [Provide Jira tool to the application](../application-management/application-tools-management.md#jira)
- [Provide Confluence tool to the application](../application-management/application-tools-management.md#confluence)
- [Provide Secret Storage to the application](../application-management/application-tools-management.md#secrets-storage)

!!! note "Application owner roles"
    Application owners have all the available roles in applications by default (developer, technical-lead and product-owner).

### :fontawesome-solid-user: Application member

The actions that can be performed by an application member in the Gluon portal are:

- [Create a new component in the application](../component-management/create-component.md#adding-new-components-to-your-application)
- [Register a component](../component-management/component-catalog.md)

#### Roles

Concerning an application, there are three roles available for an application member. These roles can be combined with each other
The roles available for an application member are:

- ![Static Badge](https://img.shields.io/badge/Developer-aa8822) Application Members with this role are into the DEV Azure AD group of the application
- ![Static Badge](https://img.shields.io/badge/Technical_Lead-aa2262) Application Members with this role are into the TL Azure AD group of the application
- ![Static Badge](https://img.shields.io/badge/Product_Owner-aa2222) Application Members with this role are into the PO Azure AD group of the application

## Licenses

In this section, we will explain the licenses assigned to each role of an application member and the capabilities related to each tool.

### Toolchain overview

The table below provides a comprehensive overview of the licenses assigned to each user in each tool within an application:

||<a href="#jira-confluence">**Jira**</a> :fontawesome-brands-jira:|<a href="#jira-confluence">**Confluence**</a> :fontawesome-brands-confluence:|<a href="#github">**Github**</a>:fontawesome-brands-github:|<a href="#fortify">**Fortify**</a>:material-alpha-f-box-outline:|<a href="#sonarqube">**SonarQube** ![Sonarqube](../images/sonarqube.svg)</a>|
|:---:|:---:|:---:|:---:|:---:|:---:|
|<a href="#application-member">Developer</a>        |:material-check-outline:|:material-check-outline:|:material-check-outline:|:material-check-outline:|:material-check-outline:|
|<a href="#application-member">Technical Lead</a>   |:material-check-outline:|:material-check-outline:|:material-check-outline:|:material-check-outline:|:material-check-outline:|
|<a href="#application-member">Product Owner</a>    |:material-check-outline:|:material-check-outline:|:material-close-outline:|:material-check-outline:|:material-check-outline:|

^^**Legend**^^  
:material-check-outline: - User has access to the tool. Refer to the tool's specific section for detailed permissions.  
:material-close-outline: - User does not have licenses in the tool.  

!!! info
    <p id="confluence">**Confluence permissions**</p>
    As of today, members and owners of the application do not have any permissions assigned in Confluence tool.

### :fontawesome-brands-github: GitHub

The permissions assigned to each role of an application member in GitHub are:

=== "Developer"

    !!! abstract ""

        **Developer** role in an application corresponds with the role of **'Write'** in GitHub. The permissions assigned to the role 'Write' in GitHub are the following:

        - **Issue and Pull Request**

            - Assign or remove a user

            - Remove an assigned user

            - Remove a label

            - Add or remove a label

        - **Issue**

            - Close an issue

            - Reopen a closed issue

            - Mark an issue as a duplicate

        - **Pull Request**

            - Close a pull request

            - Reopen a closed pull request

            - Request a pull request review

        - **Repository**

            - Set milestones

        - **Security**

            - View code scanning alerts

            - Dismiss or reopen code scanning alerts

            - View Dependabot alerts

            - Dismiss or reopen Dependabot alerts

        - **Discussions**

            - Convert issues to discussions

            - Delete a discussion

            - Edit a discussion category

            - Create a discussion category

            - Mark or unmark discussion answers

            - Hide or unhide discussion comments

            - Close a discussion

            - Reopen a discussion

            - Edit category on a discussion

            - Edit a discussion comment

            - Award and revoke discussion badges

            - Delete a discussion comment

=== "Technical Lead"

    !!! abstract ""

        **Technical Lead** role in an application corresponds with the role of **'Maintain'** in GitHub. Also, it is added as a **CODEOWNERS** in the repository, so it will be automatically requested to review the Pull Request.  
        
        The permissions assigned to the role 'Maintain' in GitHub are the following:

        
        - **Issue and Pull Request**

            - Assign or remove a user

            - Remove an assigned user

            - Remove a label

            - Add or remove a label

        - **Issue**

            - Close an issue

            - Reopen a closed issue

            - Mark an issue as a duplicate

        - **Pull Request**

            - Close a pull request

            - Reopen a closed pull request

            - Request a pull request review

        - **Repository**

            - Manage pull request merging settings

            - Manage GitHub Page settings

            - Manage project settings

            - Manage wiki settings

            - Manage topics

            - Push commits to protected branches

            - Set interaction limits

            - Set milestones

            - Set the social preview

            - Edit repository metadata

            - Create a protected tag

            - Edit repository announcement banners

        - **Security**

            - View code scanning alerts

            - Dismiss or reopen code scanning alerts

            - View Dependabot alerts

            - Dismiss or reopen Dependabot alerts

        - **Discussions**

            - Convert issues to discussions

            - Delete a discussion

            - Edit a discussion category

            - Create a discussion category

            - Mark or unmark discussion answers

            - Hide or unhide discussion comments

            - Close a discussion

            - Reopen a discussion

            - Edit category on a discussion

            - Edit a discussion comment

            - Award and revoke discussion badges

            - Delete a discussion comment

=== "Product Owner"

    !!! warning ""

        :fontawesome-solid-triangle-exclamation: **Product owner** role in an application does not have permissions assigned in GitHub.

### :material-alpha-f-box-outline: Fortify

The permissions assigned to each role of an application member in Fortify are:

=== "Developer"

    !!! abstract ""

        **Developer** role in an application corresponds with the role of **'User Developer'** in Fortify. The permissions assigned to the role 'User Developer' in Fortify are the following:

        - **Comment on issues**

            User can comment on issues for application versions to which the user has access. This permission requires the "View application versions" permission.

        - **Generate reports**

            User can generate reports and view report definitions. Reports that expose application version application data are restricted to the application versions applications to which the user has access.

        - **Use data exports**

            Users can create, view, download and delete own data exports.

        - **View application versions**

            User can view applications and application versions and their associated items including events, artifacts, issues, process templates, issue templates, custom tags, personas, performance indicators, and attributes.

        - **View generated reports**

            User can view generated reports. Reports that expose application version application data will be restricted to the application versions applications to which the user has access.

=== "Technical Lead & Product Owner"

    !!! abstract ""

        **Technical Lead** and **Product Owner** roles in an application corresponds with the role of **'User Product owner'** in Fortify. The permissions assigned to the role 'User Product owner' in Fortify are the following:

        - **Approve analysis results upload**

            User can approve uploaded analysis results for application versions to which the user has access. This permission requires the "View application versions" permission.

        - **Comment on issues**

            User can comment on issues for application versions to which the user has access. This permission requires the "View application versions" permission.

        - **Delete generated reports**

            User can delete generated reports. Reports that expose application version application data will be restricted to the application versions applications to which the user has access.

        - **Download application version FPR with source code**

            User can download FPRs with the source code.

        - **Edit application versions only**

            User can edit general settings and processing rules for application versions to which the user has access. User cannot edit the parent application name and description.

        - **Generate reports**

            User can generate reports and view report definitions. Reports that expose application version application data are restricted to the application versions applications to which the user has access.

        - **Suppress/unsuppress issues**

            User can suppress and unsuppress issues for application versions to which the user has access. This permission requires that the user have the "View application versions" permission.

        - **Use data exports**

            Users can create, view, download and delete own data exports.

        - **View application versions**

            User can view applications and application versions and their associated items including events, artifacts, issues, process templates, issue templates, custom tags, personas, performance indicators, and attributes.

        - **View generated reports**

            User can view generated reports. Reports that expose application version application data will be restricted to the application versions applications to which the user has access.

        - **View personas**

            User can view personas.

        - **View ScanCentral SAST**

            User can view ScanCentral SAST data, except for jobs not assigned to any application version.

### ![SonarQube Icon](../images/sonarqube.svg) SonarQube

The permissions assigned to each role of an application member in SonarQube are:

=== "Developer, Technical Lead & Product Owner"

    !!! abstract ""

        **Developer**, **Technical Lead** and **Product Owner** have the same permissions in SonarQube. The permissions assigned to these roles in SonarQube are the following:

        - **user**

            User can view the basic dashboard of the project.

        - **codeviewer**

            User can view the project's source code.

        - **securityhotspotadmin**

            User can administer the status of the security hotspots.

### ![Jira Icon](../images/jira.svg) Jira

Users will be assigned different **company-managed roles** in Jira according to the roles they have in the application. Find the roles in the table below:

=== "Developer"

    !!! abstract ""

        **Developer** role in an application corresponds with the role of **'Developer'** in Jira, which is a project role that represents developers in a project.

=== "Technical Lead"

    !!! abstract ""

        **Technical Lead** role in an application corresponds with the role of **'Technical Lead'** in Jira. This roles oversees development tasks and the integration of the different branches. Has a cross/functional knowledge of the product, having the ability to approach it technically.

=== "Product Owner"

    !!! warning ""

        **Product Owner** role in an application corresponds with the role of **'Product Owner'** in Jira. This role manages the project needs.

The permissions granted for each role will depend on the permission scheme configured for the Jira project, that in the end depends on the permission scheme configured for the template used to create the project.

See the official Jira Documentation regarding [permissions for company-managed projects](https://confluence.atlassian.com/jirakb/permissions-for-company-managed-projects-1368985776.html).

You can contact with the administrators of the Jira site where the project is available to discover the particular set of permissions defined for your project depending on the role.
