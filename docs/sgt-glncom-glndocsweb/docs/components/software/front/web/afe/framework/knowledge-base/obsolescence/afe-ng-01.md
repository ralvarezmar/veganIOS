# AFE-NG05-01: Package cannot be resolved from the workspace root directory

During some stage of updating your project, the following error may arise:

```bash
The "@angular-devkit/schematics" package cannot be resolved from the workspace root directory. This may be due to an unsupported node modules structure.
Please remove both the "node_modules" directory and the package lock file; and then reinstall.
If this does not correct the problem, please temporarily install the "@angular-devkit/schematics" package within the workspace. It can be removed once the update is complete.
```

> In the example above, the problem was caused by the ***@angular-devkit/schematics*** package, however it can be caused by other packages as well.

## Contextualization

The **"Package cannot be resolved from the workspace root directory"** error occurs due to the specified package not being found in the ***node_modules*** folder.

## Solution

**Delete the ***node_modules***** folder and the ***package-lock.json*** file, if any, and **run the command to clear the NPM cache**:

```bash
npm cache clean --force
```

And finally, reinstall the dependencies:

```bash
npm install
```

If the issue persists, install the package version corresponding to the current Angular version of your project:

For an Angular 10 project to install a compatible version of ***@angular-devkit/schematics***, it must run the command `npm i @angular-devkit/schematics@^10 --save-dev`.

For an Angular 12 project, it should use the command: `npm i @angular-devkit/schematics@^12 --save-dev`

For an Angular 16 project, it should use the command: `npm i @angular-devkit/schematics@^16 --save-dev`

> Use the '--save-dev' parameter, as the package is only consumed during the development period.

And run the update command again.

At the end, remove the package with the command: `npm un @angular-devkit/schematics`
