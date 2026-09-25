# Configuration of ***afe version***

You can perform some pre-settings of the command in the ***afe.json*** file within the ***version*** property:

Property | Description
----------- | ------------
***test*** | Defines whether the 'afe test' command will be executed before the versioning process is executed. If this command fails, the process will be terminated. Default value ***true***
***build*** | Defines whether the 'afe build' command will be executed before the versioning process is executed. If this command fails, the process will be terminated. Default value ***true***
***Tag*** | Defines whether to run the tag generation process. It is highly recommended to leave this property with the value ***true***, as the ***standard-version*** library relies on the tags for generating/updating ***CHANGELOG.md***. Default value ***true***
***bump*** | Defines whether to run the version *bump* process on the files defined in the ***bumpFiles*** property. Default value ***true***
***changelog*** | Defines whether to run the ***CHANGELOG.md*** file update process based on the commits made since the last tag. Default value ***true***
***commit*** | Defines whether to run the *commit* process for changes made by running the *release* process. The changes include updating the version of the files defined in the ***bumpFiles*** property, when the ***bump*** property is set to ***true*** and updating the ***CHANGELOG.md***** file, when the ***changelog*** property is set to ***true***. Default value ***true***
***tagPrefix*** | Sets a prefix for the name of tags, generated when the ***tag*** property is set to ***true***. If, for example, the value of this property is set to ***"v"*** the generated tag will be named ***v9.9.9***, where ***9.9.9*** is the generated version number. It is highly recommended that you do not use spaces in this prefix, as it implies a bug identified in the use of ***standard-version***. If you don't want a prefix, just leave an empty *string* (e.g.: "***tagPrefix***": ""). Default value "***v***"
***issueUrlFormat*** | Url of an issue tracking tool such as Github, Gitlab, or Jira. When passing this url it is necessary to put a placeholder ***{{id}}*** to replace the *id* of the *issue* to be referenced in the *commit*. Default value ***"<https://jira.santanderbr.corp/browse/{{id}}>"***
***bumpFiles*** | List of file paths to have the ***version*** property updated to the new version to be generated, when the ***bump*** property is set to ***true***. In the case of *library* projects, the package.json in the ***projects/[project-name]/package.json*** folder must be added to the *array*. Default value ***["./package.json"]***
***scripts*** | Some scripts that can be run before or after the ***release***, ***bump***, ***changelog***, ***commit***, and ***tag***. Default value ***{}***
***scripts.prerelease*** | Executed first and foremost. If the prerelease script returns a non-zero exit code, the process aborts without having executed anything
***scripts.prebump*** | Executed before the version bump process on the files defined in the bumpFiles. If this script has an *output*, it must necessarily be a version number. E.g.: `{ "prerelease": "echo 1.2.3" }`, in which case the ***bump*** of the version will be 1.2.3 and not the one calculated by ***standard-version***
***scripts.postbump*** | Executed after the version bump process on the files defined in the ***bumpFiles*** property scripts
***prechangelog*** | Executed before the file update process ***CHANGELOG.md***
***scripts.postchangelog*** | Executed after the file update process ***CHANGELOG.md***
***scripts.precommit*** | Executed before the commit process of changes to version *bump* files in the files defined in the ***bumpFiles*** and ***CHANGELOG.md*** property
***scripts.postcommit*** | Executed after the commit process of changes to version *bump* files in the files defined in the ***bumpFiles*** and ***CHANGELOG.md*** property
***scripts.pretag*** | Executed before the git tag generation process
***scripts.posttag*** | Executed after the git tag generation process
***types*** | Definition of commit types and, respectively, their sections in the ***CHANGELOG.md*** update. It must be an *Array* of objects that have the properties ***type***, which is the prefix to be used in commits, and ***section***, which defines the name of the section in ***CHANGELOG.md***. Default value ***[ { "type": "feat", "section": "What's New" }, { "type": "fix", "section": "Fixes" }, { "type": "deprecated", "section": "Deprecations" } ]***

See below an example of version property configuration in ***afe.json***:

```json
{
    "version": {
        "test": true,
        "build": true,
        "tag": true,
        "bump": true,
        "changelog": true,
        "commit": true,
        "tagPrefix": "",
        "bumpFiles": [
            "./package.json",
            "./projects/[nome-projeto]/package.json"
        ]
    }
}
```
