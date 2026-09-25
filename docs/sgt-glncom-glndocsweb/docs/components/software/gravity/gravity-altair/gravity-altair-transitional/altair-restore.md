# Gravity Altair Restore Synchronization model

## Scope

After a deploy is done, it is possible to run the restore action to set the environment to the previous version.

## -DMT and -BAK files in reception folder

Just like in the CI, the workflow is started after a file is received in the reception folder. It`s important to have the right suffix in the file name for the desired environment:

* If -DMT the restore will be made in PRE
* If -BAK the restore will be made in PRO

File name examples:
`ABG_013923-D230719-H153543-BAK.TXT`
`ABG_013923-D230719-H115024-DMT.TXT`

## Restore

Based on the file name, the package name will be retrieved, and the restore of this package will be made.
