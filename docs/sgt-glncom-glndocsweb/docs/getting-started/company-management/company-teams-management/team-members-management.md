# Team Members Management

## Introduction

This document is provided for admins and team owners profiles and explains how to manage members that belong to teams. It contains two main sections:

  - Onboard a user as a team member.
  - Remove a team member.

## Onboarding Team Member

<div class="steps" markdown>

This functionality is only available to team owners or admins.

- **Manage Team Members.** Once into Team Details click on the Team Members section of the sidebar menu to access the Team Members list.
![Team Members Empty](./images/team-members-empty.png)

- **Onboard a member.**. Click on the "Add +" button to open the onboarding form.
![Team Members Onboard](./images/team-members-onboard-1.png)

- **Select member to onboard.** Once the team's members detail window opens, their information will be visible. To onboard a new one just type the corporate identifier in text box and hit "Add +" button.
![Team Members Onboard](./images/team-members-onboard-2.png)
![Team Members Onboard](./images/team-members-onboard-3.png)
![Team Members Onboard](./images/team-members-onboard-4.png)
![Team Members Onboard](./images/team-members-onboard-5.png)
![Team Members Onboard](./images/team-members-onboard-6.png)

- **Check member is onboarded.** Once the team's member is onboarded a notification appears claiming that "Team member was successfully added", and it will be visible in the detail window.
![Team Members Onboarded](./images/team-members-onboarded.png)

!!! note "Keep in Mind!"

    In order to onboard users they must exist in the corporate LDAP and in Microsoft Entra ID, and the email must be the same in both identity providers.

</div>

## Removing Team Member

<div class="steps" markdown>

This functionality is only available to team owners or admins.

- **Manage Team Members.** Once into Team Details click on the Team Members section of the sidebar menu to access the Team Members list.
![Team Members](./images/team-members.png)

- **Remove Team Member.** Once in the team members detail section just choose the member to remove and click the corresponding delete icon.
![Team Members Remove](./images/team-members-remove-1.png)
![Team Members Remove](./images/team-members-remove-2.png)
![Team Members Remove](./images/team-members-remove-3.png)

- **Check team member is removed.** Once the team's member is removed you will see a notification with the operation result and the team member details will be updated.
![Team Members Removed](./images/team-members-removed.png)

!!! note "Keep in Mind!"

    Every team must always maintain at least two members, so you can not remove a member when only a pair are associated with the team.

</div>
