# AFE-NG01-04: Asset path must start with the project source root

While running the 'npm run start' command, after updating your project, the following error may arise:

```bash
An unhandled exception occurred: The asset path must start with the project source root.
```

## Contextualization

The error **"Asset path must start with the project source root"**, occurs because the path of the *assets*, informed in the ***assets*** property, is divergent from the path defined in the ***sourceRoot*** property.

## Solution

Parse the sourceRoot property and fix the project path in assets:

```diff
{
  "projects": {
    "<NOME_PROJETO>": {
      "sourceRoot": "projects/<SEU_PROJETO>/src",
      "architect": {
        "build": {
          "options": {
            "assets": [
-              "./projects/<SEU_PROJETO>-app/src/app/assets"
+              "./projects/<SEU_PROJETO>/src/app/assets"
            ],
          }
        }
      }
    }
  }
}
```
