# How to Troubleshoot "LCOV File Was Not Generated or Is Invalid" Issue

## Contextualization

Some projects when performing a new deployment may come across the following error: **"LCOV file was not generated or is invalid, please check"**.

This issue occurs due to a failure to generate the ***lcov.info***, which is generated after running the unit tests.

Failure to generate the file can happen if ***chrome headless disconnects***, ***unit tests break***, and etc.

> The ***lcov.info*** file is used to generate the test coverage report.

## Solution

To resolve this issue, it is important to review the pipeline execution log so that you can identify the error that is actually occurring. Specifically at the time when the 'npm run test' command is executed.

You can analyze the entire pipeline execution log as follows:

In CloudBees, go to the pipeline of the project that is having the problem and click on the "Go to classic" button, as shown in the image below:

![Go to classic](../../../../../images/pipeline/go-to-classic-pipeline.png)

After performing the above step, you will be redirected to the ***Managed Master*** page, on this page on the left side, click on the ***"View as plain text"*** option so that the ***log*** is displayed in full, as shown in the image below:

! [View as plain text](../../../../../images/pipeline/view-as-plain-text.png)

With this, you will be able to analyze the ***pipeline*** execution log and identify the error that is actually occurring. Pay attention to the part of the log where unit tests are run and see what might be happening.
