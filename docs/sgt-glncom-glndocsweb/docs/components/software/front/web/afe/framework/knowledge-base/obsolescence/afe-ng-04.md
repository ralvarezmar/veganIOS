# AFE-NG05-04: configuration.output has an unknown property 'jsonpFunction'

While running the 'npm run build' command, after updating your project, the following error may be triggered:

```bash
-- removing ".d.ts" unnecessary from "node_modules".
-- files ".d.ts" removed or not existent.
- Generating browser application bundles (phase: setup)...
An unhandled exception occurred: Invalid configuration object. Webpack has been initialized using a configuration object that does not match the API schema.
 - configuration.output has an unknown property 'jsonpFunction'.
```

## Contextualization

The error **"configuration.output has an unknown property 'jsonpFunction'"** occurs when trying to declare the ***jsonpFunction*** property in a file. This property has been renamed in webpack 5 to chunkLoadingGlobal.

## Solution

Rename the **jsonpFunction*** property to ***chunkLoadingGlobal***:

```diff
module.exports = {
  output: {
-   jsonpFunction: '<CUSTOMIZED_NAME>',
+   chunkLoadingGlobal: '<CUSTOMIZED_NAME>',
  },
}
```

> The value of `<CUSTOMIZED_NAME>` remains the same.
