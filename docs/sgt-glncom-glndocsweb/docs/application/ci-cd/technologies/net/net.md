# .NET Framework

Gluon Component for .NET Framework is a complete CI/CD system for .NET Framework application's deployment.

- [.NET Framework](#net-framework)
  - [Requirements](#requirements)
    - [Components](#components)
    - [Components Configuration](#components-configuration)
    - [Runners](#runners)
  - [Artifact Build Process](#artifact-build-process)
    - [Steps](#steps)
    - [Detailed Script](#detailed-script)
  - [Examples](#examples)
  - [More Information](#more-information)
  - [Links of Interest](#links-of-interest)

## Requirements

### Components

1. **Ansible Inventory**: Contains information about global variables and URL for .NET Framework scripts. An inventory component will be required, selecting the technology "win".
2. **Gluon Application Model**: Contains oam-application-definition.yml which is the definition file of the OAM application associated with the Gluon application. It will allow us to define
the structure of environment trails, as well as the infrastructure of the application. For more
information on how to use this component, please refer to the [Gluon Application Component](https://gluon.gs.corp/community/docs/latest/develop/component/catalog/app-component/)
3. **.NET Framework**: This component.

### Components Configuration

`1. Ansible Inventory`
        Please contact your DevOps Team in case of doubts.

`2. Gluon Application Model`
        For each environment in oam-application-definition.yml add this section:

```yaml
    - id: netframework
        type: ANSIBLE
        properties:
            type: ANSIBLE
            inventoryGit: <organization>/<ansible-inventory-name>
            inventory: <environment-inventory-folder-name>/host
```

Example

```yaml
  - name: cert
    type: certification
    infraestructures:
      - id: netframework
        type: ANSIBLE
        properties:
            type: ANSIBLE
            winrmCredentialUser: ANSIBLECREDENTIALWINUSER  # Secret used to connect to the machine
            winrmCredentialPassword: ANSIBLECREDENTIALWINPASSWORD  # Secret used to connect to the machine
            ansibleVaultCredentialId: PASSVAULT  # Used for variable substitution if necessary; can be removed if not needed
            inventoryGit: santander-group-sds-gln/sgt-apmt016-wininvsonda
            inventory: certification/host
            disableMitogen: true
```

`3. .NET Framework`

Configure Github.com component repository in .gluon/cd/*-environment-*/cd.yml.
    *-environment-* stands for name clause in oam-application-definition.yml:  *cert*, *pre*, *pro*; for instance in above example: ***cert***

.gluon/cd/***cert***/cd.yml

```yaml
    #infrastructure identifiers
    - ci_id: netframework
    extra_params:
        - artifact_url: ${ARTIFACT_REPOSITORY_URL}
        - target: CERT
    ansible_debug: false
```

- `ci_id`: Label id in oam-application-definition.yml
- `target`: Environment name. This is the tag that will be searched in the host file to determine the machine or machines where the deployment will be performed.

### Runners

Currently, by default, the runner used is `windows-2019`. If for any reason you wish to use the `windows-2022` runner, you must specify it in the `properties.env` file using the `RUNNER_WINDOWS` variable.

List of all installed .NET runtime versions and all available .NET SDK versions according to the runner:

- `windows-2019` -> [runner-images/images/windows/Windows2019-Readme.md at main · actions/runner-images](https://github.com/actions/runner-images/blob/main/images/win/Windows2019-Readme.md)
- `windows-2022` -> [runner-images/images/windows/Windows2022-Readme.md at main · actions/runner-images](https://github.com/actions/runner-images/blob/main/images/win/Windows2022-Readme.md)

These are the runners provided by GitHub. You can also add your own custom runners if needed. Please refer to the official documentation for the most up-to-date list of available runners and instructions on how to add custom runners.

## Artifact Build Process

This document explains the steps involved in the artifact build process for a .NET Framework project. The process includes compiling the project, cleaning the code, restoring packages, and packaging the artifact.

### Steps

1. **Define Variables**:
   - Set the publication path.
   - Determine the project file path. If the project path is not specified, it searches for `.sln` files in the repository. If multiple or no `.sln` files are found, it exits with an error.

2. **Find MSBuild.exe**:
   - Dynamically locate the `MSBuild.exe` path using `vswhere.exe`.
   - If `MSBuild.exe` is not found, it exits with an error.

3. **Restore Packages**:
   - Restore NuGet packages using `nuget restore`. If a `nuget.config` file is present, it uses that configuration file.

4. **Clean the Code**:
   - Clean the project using `MSBuild.exe`.

5. **Build and Compile Code**:
   - Build the project using `MSBuild.exe` with specified parameters such as configuration, platform, output directory, and logging options.
   - If the build fails, it exits with an error.

6. **Delete Specified Files**:
   - If the `FILES_TO_REMOVE` variable is set, it deletes the specified files from the artifact. If not, it provides instructions on how to set this variable.

7. **Package Artifact**:
   - Package the build output into a ZIP file.
   - Calculate and display the size of the ZIP file.
   - Print the directory structure of the publication path.

### Detailed Script

```yaml
    # Compile .NET project
    # Define variables
    $pubPath = "$ENV:GITHUB_WORKSPACE\OutDirPub"
    if ("${{ fromJSON(inputs.env-vars-json).PROJECT_PATH }}" -eq 'unspecified') {
        $slnFiles = Get-ChildItem -Path $env:GITHUB_WORKSPACE -Filter *.sln -Recurse
        if ($slnFiles.Count -eq 1) {
            $projectName = $slnFiles[0].Name
        } elseif ($slnFiles.Count -gt 1) {
            Write-Output "::error::Multiple .sln files found. Please specify the project file explicitly in ci/properties.env as PROJECT_PATH."
            exit 1
        } else {
            Write-Output "::error::No .sln file found in the repository's root directory. Please specify the project file in ci/properties.env as PROJECT_PATH."
            exit 1
        }
    } else {
        $projectName = "${{ fromJSON(inputs.env-vars-json).PROJECT_PATH }}"
    }
    $projectPath= "$ENV:GITHUB_WORKSPACE\$projectName"
    $nugetConfigFilePath = "./nuget.config"

    # Find MSBuild.exe dynamically
    $msbuildPath = $null
    $msbuildPath = & vswhere.exe -latest -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe
    if ($msbuildPath -eq $null) {
        Write-Output "::error::MSBuild.exe not found. Please install Visual Studio or MSBuild tools."
        exit 1
    } else {
        Write-Output "MSBuild.exe found at: $msbuildPath"
    }

    Write-Output " `n**********************`n  RESTORING PACKAGES  `n**********************"
    if (Test-Path $nugetConfigFilePath) {
        & nuget restore -ConfigFile $nugetConfigFilePath
    } else {
        & nuget restore
    }

    Write-Output " `n******************`n  CLEAN THE CODE  `n******************"
    & "$msbuildPath" "$projectName" /t:Clean  

    Write-Output " `n*******************************`n  BUILDING AND COMPILING CODE  `n*******************************"
    Write-Output "File to build: $projectName"
    & "$msbuildPath" "$projectPath" /t:rebuild /tv:Current /p:"Configuration=Release;Platform=`"Any CPU`";DebugSymbols=false;WarningLevel=0;DebugType=none;OutDir=`"$pubPath`";DeployOnBuild=true;ExcludeGeneratedDebugSymbol=true" /clp:Summary /consoleloggerparameters:'WarningsOnly;ErrorsOnly' /nologo /flp:'logfile=build.log;errorsonly:ErrorsOnly' /nologo /flp:'logfile=build.log;errorsonly'
    if (-Not $?) {
        Write-Output "::error::$projectName Build failed"
        exit 1
    }

    Write-Output "`n****************************"
    Write-Output "  DELETING FILES_TO_REMOVE  "
    Write-Output "****************************"
    if (-not "${{ fromJSON(inputs.env-vars-json).FILES_TO_REMOVE }}") {
        Write-Output "No files have been provided to delete. If you want to remove specific files from the artifact you can use the FILES_TO_REMOVE variable in the envs/properties.env file like this examples:`nFILES_TO_REMOVE=`"'Oracle.DataAccess.dll'`"`nFILES_TO_REMOVE=`"'*.pbd', 'Oracle.DataAccess.dll', 'IBM.Data.DB2.iSeries.dll'`""
    } else {
        $files_to_remove_string = "${{ fromJSON(inputs.env-vars-json).FILES_TO_REMOVE }}"
        $files_to_remove = $files_to_remove_string.Replace("'", "").Split(',').Trim()
        Write-Output "$files_to_remove"
        ForEach($file in $files_to_remove) {
            Get-ChildItem $file -Recurse | ForEach-Object {
                Write-Output "Removing file $($_.FullName)"
                Remove-Item -Path $_.FullName -Force
            }
        }
    }

    Write-Output "`n**********************"
    Write-Output "  PACKAGING ARTIFACT  "
    Write-Output "**********************"
    $zip_filename = "$ENV:GITHUB_WORKSPACE\${{ github.event.repository.name }}.zip"
    Get-ChildItem -Path $pubPath | Compress-Archive -DestinationPath
    $zip_filename
    $zipFileSizeBytes = (Get-Item -Path $zip_filename).Length
    $zipFileSizeMB = [math]::Round($zipFileSizeBytes / 1MB, 2)
    Write-Output "Artifact ${{ inputs.git-tag-version }} successfully generated ($zipFileSizeMB MB)"
    Write-Output "Content:`n"
    # Function to print the directory structure without the root folder prefix
    function Get-Tree($path, $indent = "") {
        $items = Get-ChildItem -Path $path
        foreach ($item in $items) {
            if ($item.PSIsContainer) {
                $dirSizeBytes = (Get-ChildItem -Path $item.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
                if ($dirSizeBytes -ge 1MB) {
                    $dirSizeMB = [math]::Round($dirSizeBytes / 1MB, 1)
                    Write-Host "$indent$item/ ($dirSizeMB MB)"
                } else {
                    $dirSizeKB = [math]::Round($dirSizeBytes / 1KB)
                    if ($dirSizeKB -eq 0) {
                        $dirSizeKB = [math]::Round($dirSizeBytes / 1KB, 1)
                    }
                    Write-Host "$indent$item/ ($dirSizeKB KB)"
                }
                Get-Tree -path $item.FullName -indent ("$indent| ")
            } else {
                $sizeBytes = (Get-Item -Path $item.FullName).Length
                if ($sizeBytes -ge 1MB) {
                    $sizeMB = [math]::Round($sizeBytes / 1MB, 1)
                    Write-Host "$indent$item ($sizeMB MB)"
                } else {
                    $sizeKB = [math]::Round($sizeBytes / 1KB)
                    if ($sizeKB -eq 0) {
                        $sizeKB = [math]::Round($sizeBytes / 1KB, 1)
                    }
                    Write-Host "$indent$item ($sizeKB KB)"
                }
            }
        }
    }
    Get-Tree -path $pubPath
```

## Examples

Here is a complete example with the software repository, inventory, and OAM

- [Source repository](https://github.com/santander-group-sds-gln/sgt-apmt016-netframewrksonda.git)
- [OAM](https://github.com/santander-group-sds-gln/sgt-apmt016-oam/blob/main/oam-application-definition.yml)
- [Inventory](https://github.com/santander-group-sds-gln/sgt-apmt016-wininvsonda)

## More Information

For more information, please refer to the [Gluon Docs](https://gluon.gs.corp/community/docs/latest/).

## Links of Interest

- [CI/CD Documentation](https://gluon.gs.corp/community/docs/latest/application/ci-cd/)
- [Gluon Application Model (OAM)](https://gluon.gs.corp/community/docs/latest/application/ci-cd/cd/cd-rm/gluon-application-model-oam/)
