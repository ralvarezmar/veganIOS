---
title: Cross Team association request
---

Cross Team associations allows members of a certain Cross Team to manage a certain type of waiver for all applications of a certain company.
The company the Cross Team belongs to and the company which waivers will be managed do not need to be the same.
The association also sets whether Application Owners of that company are able to manage their own waivers.

First of all, you need to create a Cross Team in one of your companies unless the team has been created already.
For more information about how to do it follow [these instructions](../../getting-started/company-management/company-teams-management/index.md#create-a-new-company-team).

The process to add a new Cross Team association starts by contacting the Gluon Support Team via ServiceNow and provide the following information for each association:

1. companyId: the id of the company the applications belong to.
    If the application to be managed belongs to the company with id 3 this is the id that needs to be provided in this field. It can be found in the url in the Gluon Portal.
2. crossTeamCompanyId: the id of the company the Cross Team belongs to.
    As before, it can be found in the url in the Gluon Portal.
3. crossTeamId: the id of the Cross Team that will manage the exceptions.
    This can also be found in the url in the Gluon Portal by navigating to the details page of the Cross Team.
4. crossTeamType: TESTING or QUALITY. If both, then two associations must be requested, one for TESTING and another one for QUALITY.
5. applicationOwnerAllowed: true or false. Determines if the Application Owner of each Application can manage their own exceptions.
    If false, only the members of the Cross Team or members of the company Quality Exception Management Team will be able to manage them.

In this [section](../../getting-started/support/index.md) there is additional information about how to open an incidence.
