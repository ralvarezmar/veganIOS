---
title: Copilot License Details
---

## How is a Copilot License Granted?

Copilot licenses can be granted to companies with an active Azure subscription for their cost center. In this case, companies can decide to grant Copilot to:

A. All GitHub organization users  
B. GitHub active users and users expressly requesting a Copilot license  
C. A subset of users  

### Copilot for All Organization Users

A few companies have decided to have Copilot licenses granted to all their GitHub users.  
In this case, when a user is onboarded into the GitHub organization, they automatically receive a Copilot license.  
When the user is removed from the GitHub organization, they lose the Copilot license unless they are also onboarded into another GitHub organization.

### Copilot for GitHub Active Users and Those Requesting a Copilot License

GitHub active users (i.e., users who generate commits or pull requests in GitHub.com non-private organizations) will automatically be granted a Copilot license after a few days.

GitHub users who are not active users but still need Copilot, or active users who have not yet been granted a Copilot license, can request it through a self-service issue: [HERE](https://github.com/santander-group-gluon/gln-copilot-license-assignment/issues/new?template=request-copilot-license.yml)

### Subset of Users

In this case, the company Copilot focal point must contact the [Gluon Adoption Team](mailto:gluonadoptionteam@santandernet.onmicrosoft.com) to define the list of users to whom the Copilot license will be granted.

## When and How is a Copilot License Revoked?

Unless specifically requested by the company Copilot focal point, a user will lose their Copilot license at the end of the month if they have not used it in the last 30 days or have not been a GitHub active user .

## Additional Information

### How to Check My Copilot License

You can check the details of your Copilot license here: [My Copilot Settings](https://github.com/settings/copilot)  
If you cannot access it, it means you don't have GitHub license. Contact with your responsible  
If page is blank, you don't have Copilot license.

### How My Copilot License is Determined

Users with a Copilot license are members of a specific Active Directory group matching their GitHub organization: GR_ALMNXTGN_COPILOT_[Organization Acronym]_DEV.  
You can check this information here: [Microsoft Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer) with the following query:

```bash
https://graph.microsoft.com/v1.0/me/transitiveMemberOf/microsoft.graph.group?$count=true&$filter=startswith(displayName,'GR_ALMNXTGN_COPILOT')
```
