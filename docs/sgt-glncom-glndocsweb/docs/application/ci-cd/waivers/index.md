# **Waiver Action**

## **1. Introduction**

This action allows us to request to Management to check if we have some
active exceptions, whether from QA or SEC.

When we have an error in the QA or SEC analysis we will initialize the
waiver action if the latter does not end with an output RESULT == 'success'
will stop the workflow.

QA and SEC could be excluded. Whether the job is Sonar, Fortify, Sysdig or
Sonatype, a notice will appear in the log announcing the use of this action,
It will still be marked as successful and you could continue with the workflow.

## **3. Available Waiver actions**

Here are the available Waiver actions:

- <a href="https://github.com/santander-group-shared-assets/gln-alm-check-waiver-action" target="_blank">Check Waiver Action</a>
