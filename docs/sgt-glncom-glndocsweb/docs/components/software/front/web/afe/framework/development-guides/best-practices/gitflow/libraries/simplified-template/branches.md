# Branches

We recommend that the project follow the branch nomenclature, as shown in the following table:

| ***Branch Name*** | ***Life Cycle*** | ***Description*** |
| - | - | - |
| ***Master*** | Infinity | Integration Branch that includes the updated code of the active version of the library |
| ***release*** | Finite | Branch used to perform the process of generating a new active version of the library |
| ***rc/[version]*** | Finite | Branch used to perform the process of generating ***beta*** versions of the library before following the final version generation flow. e.g. ***rc/9.9.9***. |
| ***feature/[activity-id]*** | Finite | Development branches of new features in the library. E.g.: ***feature/JIRA-9999*** |
| ***bugfix/[activity-id]*** | Finite | Fixes Development Branches for library changes. E.g.: ***bugfix/JIRA-999*** |

> Ideally, every new development should be based on an activity on a ***board***, e.g. from ***Jira***.
