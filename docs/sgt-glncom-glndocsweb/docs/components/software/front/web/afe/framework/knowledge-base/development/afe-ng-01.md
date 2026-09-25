# AFE-NG01-01: An unhandled exception occurred: ENOENT: no such file or directory, open '/dist/main.js'

While running the `npm run build` command, the following error may arise:

```bash
An unhandled exception occurred: ENOENT: no such file or directory, open '/Users/t770167/Documents/workspace/updating/crm-webcomponents/dist/main.js'
```

## Contextualization

The error **"An unhandled exception occurred: ENOENT: no such file or directory, open '/dist/main.js'"**:

Usually occurs in MFE applications with Angular Elements because the file generated during the **build** command should contain the name ***main.js***, but when compiling for production, Angular ends up generating a random hash, such as: ***main543233248.js***.

## Solution

Change in ***angular.json***, the ***outputHashing*** property from **all** to **none**, in this way the ***bundle*** will be generated with the expected name to perform the unification of the bundles.

```diff
{
  "projects": {
    "<YOUR_ACTUAL_PROJECT>": {
      "architect": {
        "build": {
          "configurations": {
            "production": {
-            "outputHashing": "all",
+            "outputHashing": "none",
            }
          }
        },
      }
    }
  }
}
```
