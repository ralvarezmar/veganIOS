# Tagging Update

By the end of this session, you will have upgraded ***@afe/tagging*** to a **version compatible with Angular 10 and 8**.

## Prerequisites

- Have the ***1.x.x*** version of ***@afe/tagging*** installed and configured in the project;
- Commit the project files before starting the update process.

## Run the Update Command

Through the command below, you will install the new version of the structuring:

```bash
ng update @afe/tagging@^2 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the `--allow-dirty` parameter in the update command.

## Add local ***serve*** configuration

> Step required only if the project uses the [***Dynatrace Connector***](https://confluence.santanderbr.corp/display/AFE/3.x.x+%7C+Dynatrace+Conector)

Create a **local** configuration on the ***angular.json*** to consume external ***scripts*** while ***serve**** is running, performing the additions as shown in the following example:

```diff
{
    "projects": {
        "aplicacao-referencia": {
            "architect": {
                "build": {
                    "builder": "@angular-devkit/build-angular:browser",
                    "options": {
                        "scripts": [
                            "src/assets/scripts/dtrum.js",
                            "src/assets/scripts/bootstrap.js",
                            "src/assets/scripts/utils.js",
                        ]
                    },
                     "configurations": {
+                        "local": {
+                            "scripts": [
+                              "src/assets/scripts/dtrum.js",
+                              "src/assets/scripts/bootstrap.js",
+                              "src/assets/scripts/utils.js",
+                         ]
+                        }
                    }
                },
                "serve": {
                    "options": {
+                        "browserTarget": "[nome-do-projeto]:build:local"
                    }
                }
            }
        }
    }
}
```

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/tagging*** 😎
