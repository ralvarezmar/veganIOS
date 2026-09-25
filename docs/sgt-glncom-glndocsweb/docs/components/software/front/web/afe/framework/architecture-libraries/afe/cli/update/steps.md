# Available Steps

Here we list all the **available steps** in our CLI for the project update.

Expand the content as your app version update:

## Common Steps

| Step | Description |
| ----- | --------- |
| **prepare-environment** | **@angular/cli** and **@afe/cli** global installation |
| **update-angular** | Updates the dependencies that angular uses and validates that the project has the configuration files, otherwise generates one with the basic settings. |
| **update-angular-versions** | Updated Angular based on the source and target versions pertinent to the migration. |
| **update-angular-libs** | Installs/updates dependencies that angular needs. |
| **deep-replace** | Updating ***/deep/*** and ***>>>*** styles to ***::ng-deep*** due to deprecation. |
| **replace-property-decorators** | Updating the ***ViewChild*** and ***ContentChild*** decorators according to the default used in **Angular 8** |
| **remove-garbage-code** | Removes invalid code from project files. |
| **update-dependencies** | Updates the versions of dependencies, such as architecture pieces and ***libs*** that have been identified with the need for updating in ***package.json***. |

### Specific to ***SPA*** and ***app-front***

| Step | Description |
| ----- | --------- |
| **update-docker-image** | Do ***replace*** in the project's ***Dockerfile*** by updating the current ***dependencies*** with the dependencies of the ***artifactory.santanderbr.corp/docker-base/spa-10:1.0.0*** image.|

### Specific to ***base-front***, ***lean*** and ***library***

| Step | Description |
| ----- | --------- |
| **add-polyfills** | Adding ***polyfills*** needed to the execution of the project. |

## Common Steps-

| Step | Description |
| ----- | --------- |
| **install-angular-cli-globally** | **Angular** Global Installation |
| **update-afe-cli** | Update the ***@afe/cli*** in the project based on the version of the project installed globally for execution in the terminal. |
| **update-angular-versions** | Updated Angular based on the source and target versions pertinent to the migration. |
| **update-afe-packages-version** | Updating the versions of the Architecture parts based on the versions for the migration. |
| **update-project-packages-version** | Updating Project Dependencies |
| **update-property-type-afe-json** | Update ***type*** property in ***afe.json*** |
| **replace-method-testbed** | Update ***TestBed*** ***get*** method for service injection |
| **remove-es5-browser-support** | Remove ***es5BrowserSupport*** key from ***angular.json*** file |

### SPA-specific

steps | Step | Description |
| ----- | --------- |
| **add-ngcc-postinstall-script** | Add **ngcc** script from 'postinstall' |

### Element-Specific Steps

| Step | Description |
| ----- | --------- |
| **add-ngcc-postinstall-script** | Add **ngcc** script from 'postinstall' |

### Library-specific steps

| Step | Description |
| ----- | --------- |
| **remove-lib-build-ng-packagr** | Remove dependency '@angular-devkit/build-ng-package' |
| **update-node-version-pipeline** | Node version update |
