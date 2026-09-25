# Release

When there are already enough new features and/or fixes to generate a release, a new branch should be created, from ***develop***, with the name ***release***.

![Branch Release](../../../../../images/simplified-template/branch-release.png)

With the ***branch*** run the ***build*** in the ***DevOps*** Pipeline to generate a final version of the library.

![Release Version](../../../../../images/simplified-template/release-version.png)

Successfully completed, send a ***MR*** to the ***branch*** ***master***, and then a ***MR*** from ***master*** to ***develop***.

![Merge for Integration Branches](../../../../../images/simplified-template/merge-integration.png)

> When creating MR, select the option to delete the MR after it is approved to remove the development branch when the flow is completed.
