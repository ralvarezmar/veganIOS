# Session time

> **❗ Note**
>
> This documentation originated from the resolution of the call [AFE-993](https://jira.santanderbr.corp/browse/AFE-993)

## Reason

One of the reasons why **authorization errors** occur during coexistence may be related to the ***Apigee session time***, which by default is 15 minutes.
But which can be configured with a shorter time and consequently expiring the session of the user who is logged in to the application.

Another similar cause is the timing of the state manager, which is responsible for copying the session from Zup to Apigee. and replicate it in the ***RHSSO***.

## Solution

In both cases, it is necessary to align on the changes to be configured via [opening a ticket to the CDG team](https://jira.santanderbr.corp/projects/SCDGHUBBR/).
