# AFE-NG06-01: Data path "" must NOT have additional properties(customWebpackConfig)

During the execution of the `npm run build` **script**, the following message may be displayed:

```bash
An unhandled exception occurred: An unhandled exception occurred: Schema validation failed with the following errors:
         Data path "" must NOT have additional properties(customWebpackConfig).
```

## Contextualization

The "Data path must NOT have additional properties(customWebpackConfig)" error occurs in projects that declared the ***customWebpackConfig*** property of the ***@angular-builders/custom-webpack*** package.
In their ***angular.json*** and updated the ***builders*** to the ones available in ***@afe/devkit-angular***.

## Solution

Remove the ***customWebpackConfig*** object and configure a new property called ***extraWebpackConfig*** that takes the path of the ***Webpack***custom config file as a parameter, as shown in the example below:

```diff
{
  "projects": {
    "crm-webcomponents": {
      "architect": {
        "build": {
          "builder": "@afe/devkit-angular:browser",
          "options": {
-            "customWebpackConfig": {
-              "path": "./extra-webpack.config.ts"
-            },
+            "extraWebpackConfig": "./extra-webpack.config.ts",
          }
        }
      }
    }
  }
}
```

Based on the above change, the following errors may arise:

**📝 Related Errors:**

- [AFE-NG06-02: webpackMerge is not a function](./afe-ng-02.md)
- [AFE-NG05-04: configuration.output has an unknown property 'jsonpFunction'](../obsolescence/afe-ng-04.md)
- [AFE-NG01-02: Cannot use import statement outside a module](../development/afe-ng-02.md)
