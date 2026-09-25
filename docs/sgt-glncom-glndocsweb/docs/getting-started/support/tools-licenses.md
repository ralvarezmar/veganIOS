---
title: Licenses HouseKeeping
---
Different processes are run on a periodic basis to ensure that companies are not exceeding their contracted licenses and to guarantee available licenses for new users in companies under their contracted licenses.

## GitHub.com - Cleaning Process for lack of user Activity

GitHub.com informs us daily about users who have not logged into GitHub.com for more than 30 days; these users are referred to as Dormants. There is a daily process that removes these users from the system to free up licenses.

With this information, licenses are regularized according to the following criteria:

Every Monday, an automated process is initiated to send an email to users who are candidates for the removal of their GitHub.com license.

For morte information: [Housekeeping Process Overview - GitHub.com](https://gluon.dev.corp/internal/docs/latest/platform/tools/Github/Housekeeping/housekeeping-process/)

- #### Email

    ---
    Dear user,

            We inform you that your GitHub user (user) with github login: (login-github.com) has been identified as "dormant" (inactive) in our platform due to lack of activity in the last 30 days.

            These dormant users may be subject to review and potentially deactivated as part of our efficient resource management policies.

            If you want to keep your user active, we recommend that you perform some activity on the github.com in the coming days, such as:

            - Logging into GitHub
            - Making commits to a repository
            - Participating in pull requests or issues

            For more information: [Dormant users documentation](https://docs.github.com/en/enterprise-cloud@latest/admin/managing-accounts-and-repositories/managing-users-in-your-enterprise/managing-dormant-users)

The email provides instructions on how to change users’ dormant status to avoid being included in the license release process, as well as the actions required to retain their license.

A few days after the email notification, the license release process will take place, which consists of the following steps:

1. For Gluon users, the Developer and/or Technical Lead roles will be changed to Product Owner.
2. For all other users, they will be removed from the group that grants access to GitHub.com.

Please note that a license may be lost for the following reasons:

1. License release processes due to inactivity
2. SailPoint, if your manager does not certify your group memberships

**To recover your license**, please follow these steps:

1. If your role has been changed to Product Owner, an Application Owner must update your role to Developer and/or Technical Lead.
2. If you have the correct role but still do not have access, an Application Owner must remove and re-add you to the application.

If you cannot recover your license, please open a support ticket as indicated in [support documentation](https://gluon.gs.corp/community/docs/latest/getting-started/support/).

## Atlassian - Cleaning Process for excessive consumption

There are internal processes that verify the consumed licenses on the different Atlassian sites. If the number of contracted licenses is exceeded, processes are launched to remove licenses from users who have not accessed the site in the last 30 days.
For more information: [Atlassian Housekeeping Process](https://gluon.dev.corp/internal/docs/latest/platform/tools/atlassian/housekeeping/housekeeping-atlassian/)

**To recover your license**, please follow these steps:

1. If the license was assigned due to membership in an application, you must contact an Application Owner to add you to the application again and recover the licenses.
2. If the license was assigned due to membership in a company team, you must contact a custom owner to add you to the team again and recover the permissions.

If users need to recover licenses in Atlassian, they should contact their project manager to request the necessary licenses to be reassigned. If this does not work, please open a support ticket as indicated in [support documentation](https://gluon.gs.corp/community/docs/latest/getting-started/support/).

## All Tools - SailPoint Certifications

There are group certification campaigns in SailPoint. In these campaigns, the access of users to the different tools and groups of Gluon must be certified.
A user loses a license because they are removed from a group/tool either because their manager considers they should no longer belong to the group/tool, or because they have not completed the certification (not certified for use).
In these cases, to obtain the Atlassian license again, they should contact their project manager, requesting to remove them from the application they were in Gluon and re-include them.
If you cannot recover your license, please open a support ticket as indicated in [support documentation](https://gluon.gs.corp/community/docs/latest/getting-started/support/).

## Summary of License Removal

| Tool       | When                                             | Details                                                                                       |
|------------|--------------------------------------------------|-------------------------------------------------------------------------------------------------|
| GitHub.com | > 30 days without logging in via Web and Copilot Activity| Removed Dormants users from the system to free up licenses. |
| Atlassian  | > 30 days without logging in                     | Performed when the number of contracted licenses is exceeded.                                   |
| All Tools  | SailPoint Campaign with no confirmed access  | The user is removed from the teams that are not certified.                                       |
