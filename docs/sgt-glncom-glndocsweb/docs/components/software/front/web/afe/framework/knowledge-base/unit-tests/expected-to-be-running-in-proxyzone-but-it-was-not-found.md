# How to solve the problem "Expected to be running in 'ProxyZone', but it was not found."

When running the unit tests of an Angular application, you may come across the above error.

## Contextualization

This error occurs when the application is not running unit tests within the Zone, which is an Angular library that allows the detection of changes happening in the application.

Usually the error occurs when in the process of migrating to Angular 16 the file 'src/test.ts' is still being used by the Angular CLI to set up the test environment.

Note that in Angular 16 the 'src/test.ts' file is no longer needed, as the configuration of the test environment is done automatically by the Angular CLI.

## Solution

In file 'angular.json', remove the ***main*** property that uses file 'src/test.ts'.

```diff
"projects": {
  "your-project": {
    "architect": {
      "test": {
        "builder": "@angular-devkit/build-angular:karma",
        "options": {
-         "main": "src/test.ts",
          "polyfills": [
            "zone.js",
            "zone.js/testing"
          ],
          "tsConfig": "tsconfig.spec.json",
          "inlineStyleLanguage": "scss",
          "assets": [
            "src/favicon.ico",
            "src/assets"
          ],
          "styles": [
            "src/styles.scss"
          ],
          "scripts": [],
          "karmaConfig": "karma.conf.js",
          "codeCoverage": true
        }
      },
    }
  }
},
```

Also remove the `src/tests.ts` file from the project, as it will no longer be used.

```diff
  your-project
  │
  └───src
- │   │   test.ts
  │   │   main.ts
  │   │   index.html
  │   │   ...
```
