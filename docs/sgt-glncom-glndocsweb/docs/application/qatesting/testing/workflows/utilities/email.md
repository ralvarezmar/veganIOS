---
title: Email
hide:
  - toc
---

## **Send execution results by email**

When running tests through workflows, exists the possibility of sending the test results via email. For the results to be sent,
the recipients must be configured in the test configuration files found in the .testingConfig folder of the testing project.

To use this functionality, connectivity must be ensured between the cluster where the ephemeral runner is located
and the **smtpcan.gsnet.corp** mail server.

``` yaml title=".testingConfig/ondemand/global.yml" hl_lines="13 14" linenums="1"
email:
  enabled: true
  adresses: <list of email addresses separated by ,>
```
