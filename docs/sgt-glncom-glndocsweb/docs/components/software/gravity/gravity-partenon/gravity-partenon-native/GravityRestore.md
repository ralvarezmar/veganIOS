## Summary

This template allows you to return to a prior situation in the environment restoring from a native NEXUS artifact that we have previously deployed.

![GravityRestore](../../assets/images/gravity-partenon-restore.png)

## Workflow setup configuration

Once you have entered in the appropriate github.com repository, you may click on actions menu and then select Gravity Restore Workflow.

![GravityRestore_Select](../../assets/images/gravity-partenon-restore-select.png)

* Use Workflow from (select properly depending on your branch strategy)

* Enter **comments** for you to trace the workflow about to be executed on 'Set the execution name'. (No restrictions in length,spaces, tabs or special characters).

* type or copy the **NEXUS Release Package** Artifact URL.

* Select the **environment** (either CERT or ED, PRE, PRO).

* Select the **client** where package is going to be restored from the list of available customers (UKEU, ARQ, SVGS, 0049, COSK, MEXM, CHLJ, SCF1).

![GravityRestore_Start](../../assets/images/gravity-partenon-restore-start.png)

Once you hit on 'Run workflow', runner will start working covering the accurate stages

## Workflow stages

* **Check Input & Variables setup**: first of all, given NEXUS URL parameter entered is checked.In case of any issue on checking, workflow will stop showing an error message.

* **Restore to CERT or ED, PRE, PRO**: workflow will trigger ansible deployment that will deposit the contents of the already backup files in the accurate server folders according to predefined inventories controlled by the Gluon Gravity Team.

!!! Warning
    For ED,PRE or PRO, workflow will stop in order you to approve/confirm the restore
    ![Job stopped](../../assets/images/native-job-standby.png)<br>
    and so it will remain till you get your accurate environment check selected
    as follows:
    ![Approval](../../assets/images/approval-prepro-pre.png)

* **Notification**: last stage is intended to inform to the appropriate email box about the restore action just ended.

* **Notification WSC**: in this last stage, If deployment OK and if package contains any Webservice object (WSC), Mfes email box provided will receive a notificatio email saying that those objects must be treated in the affected environment.

* **Send Data**: in this last stage, whether deployment was ok or not, opensearch tool is informed about the most important workflow's parameters used during execution.

You may also see at the workflow execution diagram who launch it and how long it took to execute the complete workflow and the partial and total results of each stage explained above:

* For CERT Restore

![GravityRestoreCert_Summary](../../assets/images/gravity-partenon-restore-cert-summary.png)

* For either ED, PRE or PRO Restore

![GravityRestorePREPRO_Summary](../../assets/images/gravity-partenon-restore-summary.png)
