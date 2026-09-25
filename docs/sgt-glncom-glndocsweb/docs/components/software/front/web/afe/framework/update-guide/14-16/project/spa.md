# How to update a Single Page Application (SPA) to Angular 16

This session aims to guide the **upgrade of the following projects** to **Angular version 16**:

- **Single Page Application (SPA);**

> **Attention**
>
> Before proceeding, make sure you [meet the prerequisites and configure the local environment](./index.md).

## Create an update branch

Go to the **root of the project** and create a *branch* to start the update process:

```bash
git checkout -b feature/update-angular-16
```

## Follow the steps to update your project

> ⚠️ **Attention**
>
> If any steps fail during the upgrade, **review the execution log** and **query** our knowledge base for [**issues encountered while upgrading Angular**](../../../knowledge-base/obsolescence/index.md).

Visit the [Angular update guide](https://update.angular.io/?l=2&v=14.0-15.0) and follow the steps to update your project to Angular version 16.

It is recommended that you upgrade your project to the **intermediate version** between 14 and 16, **Angular 15**, before upgrading to **version 16**.

> **Attention**
>
> Pay attention to what is displayed in the **update guide** and **do not execute** the update commands without first **analyzing** what will be changed in your project.
> If you face any **problem not yet mapped** in our [knowledge base](../../../knowledge-base/obsolescence/index.md) or are experiencing **difficulties in the update process**, [open a ticket to AFE support](https://afe.paas.santanderbr.pre.corp/suporte).
