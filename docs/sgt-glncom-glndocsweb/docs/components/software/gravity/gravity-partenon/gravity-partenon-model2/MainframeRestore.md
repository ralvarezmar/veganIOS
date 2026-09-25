## Aim & scope

This template allows you to return to a prior situation in the environment restoring from an NEXUS artifact that it was previously deployed.

![MainframeRestore](../../assets/images/mainframerestore.png)

## Workflow setup configuration

Once you have entered in the appropriate github.com repository, you may click on actions menu and then select Mainframe Restore Workflow.

![MainframeRestore_Select](../../assets/images/mainframerestore-select.png)

* Use Workflow from (select properly depending on your branch strategy)

* Enter **comments** for you to trace the workflow about to be executed on 'Set the execution name'. (No restrictions in length,spaces, tabs or special characters).

* type or copy the **NEXUS Release Package** Artifact URL.

* Select the **environment** (either CERT, ED, PRE or PRO).

* Select the **client** where package is going to be restored from the list of available customers (UKEU, ARQ, SVGS, 0049, COSK, MEXM, CHLJ, SCF1).

![MainframeRestore_Start](../../assets/images/mainframerestore-start.png)

Once you hit on 'Run workflow', runner will start working covering the accurate stages

## Workflow stages

* **Check Input & Variables setup**: first of all, given NEXUS URL parameter entered is checked.In case of any issue on checking, workflow will stop showing an error message.

* **Restore to CERT, ED, PRE or PRO**: workflow will trigger ansible deployment that will deposit the contents of the already backup files in the accurate  server folders according to predefined inventories controlled by the Gluon Gravity Team. Also
SQAI TrX will be executed in order tables to be updated according to the object's version restored.

!!! Warning
    For ED,PRE or PRO, workflow will stop in order you to approve/confirm the restore
    ![Job stopped](../../assets/images/job-standby.png)
    and so it will remain till you get your accurate environment check selected
    as follows:
    ![Approval](../../assets/images/approval-prepro-pre.png)

This stage also includes the **Notification** intended to inform to the appropriate email box about the restore action just ended.

???+ note "None XREF validations on restore pipelines"

    There is no xref stages included in any Mainframe Restore Pipeline execution (whatever the environment)

## Workflow summary

You may also see at the workflow execution diagram who launch it and how long it took to execute the complete workflow and the partial and total results of each stage explained above

* For CERT Restore:

![MainframeRestoreCert_Summary](../../assets/images/mainframerestore-cert-summary.png)

* For ED, PRE or PRO Restore:

![MainframeRestore_Summary](../../assets/images/mainframerestores-summary.png)
