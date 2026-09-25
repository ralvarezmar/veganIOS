---
title: Atlassian Cloud add a Jira Project Template with Gluon Company
---
## Introduction

- A Gluon Company needs a Jira project used as TEMPLATE for new Jira projects creation through the Gluon Technical Application or Gluon Company teams.<br>
The Jira Project Template have to be created by the Local Jira Administrators in the Jira instance for being able to be linked to a Gluon Company.<br><br>

### Local Self-Managed Sites Admins Considerations to create the Jira project template for Gluon

- Jira Project type: **company-managed**<br>
    - [Atlassian docs to create a Jira Project company-managed](https://support.atlassian.com/jira-cloud-administration/docs/create-and-edit-a-project/)
- The Jira project template schemes in a Self Managed Atlassian Site should be created and edited based on Jira local administrators criteria that meets the Entity requirements.<br>
**For Gluon integration: it is mandatory for Local Admins to configure the Jira project template permissions scheme adding the Gluon Roles.**<br>
???+ tip
    [Atlassian docs to create and manage a Jira scheme permissions](https://support.atlassian.com/jira-cloud-administration/docs/manage-project-permissions/)<br>
    - The needed Gluon Roles that can be consulted in Gluon docs: <br>
        - [Gluon Application Jira roles](https://gluon.gs.corp/community/docs/latest/application/users-teams/user-permissions/#jira)<br>
        - [Gluon Company team roles](https://gluon.gs.corp/community/docs/latest/getting-started/company-management/company-teams-management/team-users-permissions/#jira)

???+ info "Recommendations to Add Gluon Roles to Jira Template Permission Scheme"
    The Gluon roles had to be [created in Jira as Jira project roles](https://support.atlassian.com/jira-cloud-administration/docs/manage-project-roles/).<br>
    By default , Gluon team create all necessary Gluon Roles at the Jira site (instance) creation.<br>
    In case the Jira was transferred or migrated from external instance to corporate instance, during the Gluon integration process:<br>
    - Option 1:the local Jira administrators could create the Gluon roles as Jira Project Roles in Jira.<br>
    - Option 2: Local Jira Admin could request the Gluon roles creation to Gluon team through a [ITSM Support Request](https://gluon.gs.corp/community/docs/latest/getting-started/support/#create-a-new-support-inc) <br>
    The criteria to add Gluon Roles in the Jira template scheme permissions depends on the entity that have to assure that each Gluon role covers the basic Jira permissions for a correct users usage<br><br>
???+ tip "**Considerations about Jira permissions and Gluon Roles**"
    Assure that permissions in the scheme are reviewed and assigned to a Gluon Role at least or to all Gluon roles.<br><br>
    **Example of permissions:**<br>

    - The following following Jira scheme permissions could be assigned to all Gluon roles:<br>
        **Browse projects**, Create Issues, Assignable User , Transition Issues, Add Comments, Create Attachments , View Voters and Watchers, etc<br>

    - The following Jira scheme permission is better to assign to specific Roles or only admins:<br>
        Delete All Comments (In general all "delete all" permission ) etc.
