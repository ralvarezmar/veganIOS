# Development

All development of new functionality or bug fixes must come from the ***develop branch***.

! [Development Branches] (./media/branches.png)

> In this case, it's ideal to use the ***ID*** of the ***issue*** in Jira to compose the ***branch nomenclature***. E.g. ***bugfix/JIRA-999*** or ***feature/JIRA-999***.

When the development of the change is finished, a ***Merge Request (MR)*** should be opened for the ***branch develop***.

! [Merge Develop] (./media/merge-develop.png)

> If before your MR is approved, another branch has been incorporated into the develop branch, you need to pull the changes to avoid conflicts and test that everything will still work.

After approval of the ***MR*** it is possible to proceed with the versioning procedure.

> When creating MR, select the option to delete the MR after it is approved, so that you can remove the development branch when the flow is complete.
