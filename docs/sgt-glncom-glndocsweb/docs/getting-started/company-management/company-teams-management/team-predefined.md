---
title: Company Predefined Teams
---

This section lists and details the different Predefined Company Teams created with a Company Onboarding

| Team Name                          | Team Short Name | Functions | Permissions|
|------------------------------------|-----------------|-------------|----|
| Access Management CERT Team        | AMC             | Create/Edit/List Secrets in Vault for CERT Environment under Company structure | Vault |
| Access Management PRE Team         | AMP             | Create/Edit/List Secrets in Vault for PRE Environment under Company structure | Vault |
| Access Management PRO Team         | AMX             | Create/Edit/List Secrets in Vault for PRO Environment under Company structure | Vault |
| API Local Heads Team               | APIH            | Set as Writer of APIs Definition Repositories by Global Head of APIs | GitHub santander-group-shared-assets |
| API Designers Team                 | APID            | Set as Writer of APIs Definition Repositories by Global Head of APIs |GitHub santander-group-shared-assets |
| DevOps Team                        | DVOP            | Edit Application Secrets in GitHub / Approve Deployments to Production | GitHub Company Organization|
| Event Heads Team                   | EVNT            | Review and Approve Events Proposals| GitHub santander-group-shared-assets/santander-events-community |
|JFROG Team                          |JFRO             |JFROG Group for users with Read Only permissions with no access through Company Onboarding . | JFROG - Readonly|
| Mobile Testers Team                | MOBT            | Groups for access to TestFairy Marketplace |TestFairy|
| Quality Exception Management Team | QEMT            | Create Quality Exceptions for all Company Applications| Gluon Portal/Exception Module|
| Testing Exception Management Team | TEMT            | Create Testing Exceptions for all Company Applications| Gluon Portal/Exception Module|
| Security Exception Management Team | SEMT            | Create Security Exceptions for all Company Applications, and mute False Positives in Fortify| Gluon Portal/Exception Module, Fortify|
| License Volume Exception Management Team | LVMG            | Group with members in charge of Housekeeping and Volume Control management. They will be able to edit the VIPs and Banned files, to prevent or force GitHub & Atlassian license loss.|This group is will be linked to a specific GitHub Repository with write permissions.|

## Additional Details

### Access Management Teams

Those teams are used in [Hashicorp Vault](../../../application/security/security-enablers/hashicorp-vault/index.md) for Secret Management.  
Developers can Create/Edit/List Secrets of their respective applications for CERT Environmnent, under their Company Structure. They can also visualize Secrets contents.  
Members of Access Management Teams can Create/Edit/List Secrets in their respective environments for all applications and global structure at Company level.  

Vault grants minimum privileges to users. In case a same user is member of groups for different Environmnents, it will only have permissions on the lower one.
For example in case of being member of CERT and PRE, user will only be able to create and edit secrets in CERT.

### APIS Local Head/ API Designers Teams

APIs Local Head and API Designers Teams are important roles in [API definition lifecycle](../../../components/software/api/framework/lifecycle/index.md)

### DevOps Team

DevOps Team has privilege permissions on the GitHub Company Organization.  
Assigned roles : All-repository admin

### Event Heads Team

Events Heads can review and approve [Events Proposals](../../../components/software/events/life-cycle/index.md). Those are GitHub issues in santander-group-shared-assets/santander-events-community. The team has read access to the GitHub repository.

### JFROG Team

All Gluon users are granted JFROG Read Only access through a specific team filled with each user onboarded. However, this specific JFROG Team can be used to grant access to users who report they cannot access JFROG.

### Mobile Testers Team

Mobile Testers Teams are linked to TestFairy in order to grant them License. Specific role/permission has to be given individually for each member. Role can be admin,contributor, or reader.

### Quality Exception Management Team

Quality Exception Management Team can manage [QA Exceptions](../../../application/exceptions-management/quality-exceptions.md) and [Testing Exceptions](../../../application/exceptions-management/testing-exceptions.md)
for all Company Applications through Exception Module.  
For Santander Spain Cost Center, this team is the only one allowed to manage QA Exceptions.
Application Owners don't have the permission.

### Security Exception Management Team

Security Exception Management Team can manage [Security Exceptions](../../../application/exceptions-management/security-exceptions.md) for all Company Applications through Exception Module.

### License Volume Exception Management Team

License Volume Exception Management Team is responsible for Housekeeping and Volume Control management.  

Members can edit VIPs and Banned files to prevent or force GitHub & Atlassian license loss.  

This team is linked to a specific GitHub repository with write permissions.
