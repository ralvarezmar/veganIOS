# Branches

We recommend that the project follow the branch nomenclature, as shown in the following table:

| ***Branch Name*** | ***Life Cycle*** | ***Description*** |
| -------------- | ------------- | --------- |
| ***master*** | Infinity | Integration Branch that includes the updated code of the active version of the library |
| ***develop*** | Infinity | Integration Branch that serves as a bridge between new features and fixes with ***branch*** ***master*** |
| ***release*** | Finite | Branch used to perform the process of generating a new active version of the library |
| ***rc/[version]*** | Finite | Branch used to perform the process of generating ***beta*** versions of the library before following the final version generation flow, ***rc/9.9.9***. |
| ***feature/[activity-id]*** | Finite | Development Branches of new features in the library, ***feature/JIRA-9999*** |
| ***bugfix/[activity-id]*** | Finite | Fixes Development Branches/Library Changes, ***bugfix/JIRA-999*** |
| ***hotfix/[activity-id]*** | Finite | Development Branches of urgent fixes/changes to the library, ***bugfix/JIRA-999*** |

> Ideally, every new development should be based on an activity on a ***board***, e.g. from ***Jira***.
