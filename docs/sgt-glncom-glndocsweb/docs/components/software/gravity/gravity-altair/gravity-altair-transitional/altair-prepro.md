# Gravity Altair PREPRO Synchronization model

## Scope

After the package was generated, deployed and uploaded to Nexus or Artifactory. It’s possible to execute the deploy in. PRE and PRO environments.

## -PRM and -APR files in reception folder

Just like in the CI, the workflow is started after a file is received in the reception folder. It`s important to have the right suffix in the file name for the desired environment.

* If -PRM the deploy will be made in PRE.
* If -APR the deploy will be made in PRO

File name examples:
`3ABG_013923-D230719-H115430-PRM.TXT`
`ABG_013923-D230719-H153543-APR.TXT`

## Deployment

Based on the file name, the package name will be retrieved, and the package will be downloaded from the remote repository (Nexus or Artifactory) and the deploy will be made the same way as in DEV( seethe Altair Sync section). About the destination
    folder, we have as example( can be different in each org):

* PRE

|**Object Type**|**File Type**|**Destination**|
|---     |---        |---   |
| PGM online   | .idy, .gnt | orpgm/exe |
| PGM batch    | .idy, .gnt | orcics/exe |
| MAP (BMS) | .mod | orfases/exe |

* PRO

|**Object Type**|**File Type**|**Destination**|
|---     |---        |---   |
| PGM online   | .idy, .gnt | expgm/exe |
| PGM batch    | .idy, .gnt | excics/exe |
| MAP (BMS) | .mod | exfases/exe |

Besides binary files deployment, sources are also deployed in their appropriate folders for future debugging purposes. Typically sources will reside at the same level as binaries paths but in a separate folder called fte
