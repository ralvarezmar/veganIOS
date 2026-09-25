---
title: User Permissions
---

This section explains the different users available in a Company Team of Gluon and the licenses of each user in the tools available within the Gluon platform.

## Permissions by role

In this section, we will explain which actions can be performed by each type of user in Gluon in the company teams.

### :fontawesome-solid-building-user: Company owner

The actions that can be performed by a company owner in the Gluon portal related to the company teams are:

- [Create a new company team](../company-teams-management/index.md#create-a-new-company-team)
- [Onboard a user as a company team owner in the company team](../company-teams-management/team-owners-management.md#onboarding-team-owner)
- [Remove a company team owner from the company team](../company-teams-management/team-owners-management.md#removing-team-owner)
- [Provision a Jira project to the company team](../company-teams-management/team-tools-management.md#jira)
- [Provision a Confluence space to the company team](../company-teams-management/team-tools-management.md#confluence)

!!! warning ""
    :fontawesome-solid-triangle-exclamation: No roles are assigned for company owners in company teams.

### :fontawesome-solid-user-tie: Company team owner

The actions that can be performed by a company team owner in the Gluon portal related to the company teams are:

- [Onboard a user as a company team member in the company team](../company-teams-management/team-members-management.md#onboarding-team-member)
- [Delete a company team member](../company-teams-management/team-members-management.md#removing-team-member)
- [Provision a Jira project to the company team](../company-teams-management/team-tools-management.md#jira)
- [Provision a Confluence space to the company team](../company-teams-management/team-tools-management.md#confluence)

### :fontawesome-solid-user: Company team member

!!! info
    <p id="company-team-member">**Company team member actions**</p>
    As of today, company team members do not have any specific action assigned in the Gluon portal.

## Licenses

In this section, we will explain the licenses assigned to each user of a company team and the capabilities related to each tool.

### Toolchain overview

The table below provides a comprehensive overview of the licenses assigned to each user in each tool within a company team:

||<a href="#jira">**Jira**</a> :fontawesome-brands-jira:|<a href="#confluence">**Confluence**</a> :fontawesome-brands-confluence:|
|:---:|:---:|:---:|
|<a href="#company-team-owner">Company team owner</a>         |:material-check-outline:|:material-check-outline:|
|<a href="#company-team-member">Company team member</a>       |:material-check-outline:|:material-check-outline:|

^^**Legend**^^  
:material-check-outline: - User has access to the tool. Refer to the tool's specific section for detailed permissions.  
:material-close-outline: - User does not have licenses in the tool.  

### :fontawesome-brands-jira: Jira

Users will be assigned different **company-managed roles** in Jira according to the roles they have in the company team. Find the roles in the table below:

=== "Company Team Owner & Company Team Member"

    !!! abstract ""

        **Company Team Owner** and **Company Team Member** roles are assigned to the role of **'Company Team Member'** in Jira, which is a company managed role that represents the members of the company team in a project.

The permissions granted for the role will depend on the permission scheme configured for the Jira project, that in the end depends on the permission scheme configured for the template used to create the project.

See the official Jira Documentation regarding [permissions for company-managed projects](https://confluence.atlassian.com/jirakb/permissions-for-company-managed-projects-1368985776.html).

You can contact with the administrators of the Jira site where the project is available to discover the particular set of permissions defined for your project depending on the role.

### :fontawesome-brands-confluence: Confluence

As of today, when creating a Confluence space, the only permissions assigned are the permissions associated with the [default groups](https://support.atlassian.com/user-management/docs/default-groups-and-permissions/)
configured for the site where the space is available. You can contact with the administrators of that site to discover these particular permissions. If other permissions need to be configured in the Confluence space,
please contact with the Gluon Support team.

See the official Confluence Documentation regarding [space permissions](https://confluence.atlassian.com/doc/space-permissions-overview-139521.html).
