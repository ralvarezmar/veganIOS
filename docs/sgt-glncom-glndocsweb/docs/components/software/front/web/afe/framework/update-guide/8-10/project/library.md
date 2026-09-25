# How to upgrade a Library to Angular 10

This session aims to guide the upgrade of a library to Angular version 10.

> **Warning**
>
> Before proceeding, make sure that you [meet the prerequisites and set up the on-premises environment](../../8-10/index.md).

Go to the root of your project and run the command:

```bash
afe update
```

A list of options will be presented. Select the **Library** option.

```bash
Select the type of project! › - Use arrow keys. Return to submit.
❯ Library: a library to be published on artifactory.
    Element: a self-contained application that uses the Micro Front End concept.
    Application: a common Angular application to be deployed in environments.
```

Once the correct option is selected, the process of updating your application will begin.

And **wait for the command to run**. By the end, your application should have been successfully updated!**

> **Warning**
>
> If any step fails, **review the execution log** and **consult** in our knowledge base [**problems encountered during the Angular upgrade**](../../../knowledge-base/obsolescence/index.md).

If you encounter any **unmapped issues** or are experiencing **difficulties in the process**, open a ticket [ticket opening](https://afe.paas.santanderbr.pre.corp/suporte).
