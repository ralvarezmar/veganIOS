# MAINFRAME SYNCHRONIZED MODEL

## 1. ABSTRACT

This particular model aims for the Change Management Teams to deploy non yet sinchronized packages from Mainframe to Gravity. This is quite a temporal scenario to be used for 'on-the-fly' packages not possible to be promoted using Gipih since may be
it's been decommissioned for a given client. This is the way to make those packages included in Gluon deployed either in PRE or PRO environments.

## 2. ONBOARDING

You may follow instructions given in GLUON onboarding:

 * [**Teams Onboarding**](../../../../../application/application-management/application-members-management.md)

 * [**Application onboarding**](../../../../../application/application-management/application-onboard.md)

 * [**Component Creation**](../../../../../application/component-management/create-component.md)

## 3. WORKFLOWS AND ACTORS

To carry out continuous deployment, users have the following workflows available:

|**Workflow**|**Actor**|**Description**|
|---     |---        |---   |
| [MainframeSync](./MainframeSync.md)   | Change Management / SIM Team (for ARQ) | This worlkflow allows to  deploy specific freeze Nexus packages into PRE or PRO environment |
| [MainframeRestoreSync](./MainframeSyncRestore.md)    | Change Management / SIM Team (for ARQ) | This workflow allows to restore a given freeze Nexus package in PRE or PRO environment |
