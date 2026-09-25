# Using ***node*** version

After the installation of ***Node*** is complete, the added version can be used by running the `nvs use<version>` command.

> Replace ***`<version>`*** with the version of ***Node*** you want to use.

```powershell
nvs use 14
```

If you want to use a specific one, just turn the command specifying it:

```powershell
nvs use 14.12.0
```

## Using a predefined node version

**With a version already added**, do the following according to your operating system.

### Mac/Linux

Run the *NVS* `link` command, it will take care of setting the new version of NODE as **default**.

```zsh
nvs link <version>
```

### Windows

As mentioned about the limitation of NVS settings due to the registry restriction policy in windows on Santander machines, it is not possible to use the *NVS* `link` command.

To simulate the functionality, during the execution of the "script" in the installation step, a function (`ChangeDefaultNode`) was added to your user's **PROFILE**.

To change the node version that will be used in every initialized terminal instance, so just run the following command through PowerShell:

```ps1
ChangeDefaultNode -version <number-version>
```
