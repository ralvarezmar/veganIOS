# AFE-NG01-04: Cannot use import statement outside a module

While running the 'npm run build' command, after updating your project, the following error may be triggered:

```bash
-- Removing files ".d.ts" unnecessary from "node_modules".
-- File ".d.ts" removed or not existent.
- Generating browser application bundles (phase: setup)...
An unhandled exception occurred: Cannot use import statement outside a module
See "/private/var/folders/r0/kp25rzb934q6fnnm6z0j4ykd02_r8q/T/ng-vWJYEK/angular-errors.log" for further details.
```

## Contextualization

The error **"An unhandled exception occurred: Cannot use import statement outside a module"** can occur in any file that contains the statement import as webpack from `webpack`.

## Solution

Remove the **import** statement and any existing references in the file, and also change the `export default` statement to `module.exports`.

In this scenario, this issue was identified in a webpack configuration file:

**Before:**

```typescript
import * as webpack from 'webpack';

export default {
  output: {
    // conteúdo omitido
  },
} as webpack.Configuration;
```

**After:**

```typescript
module.exports = {
  output: {
    // conteúdo omitido
  },
}
```

Based on the above change, the following errors may arise:

**📝 Related Errors:**

- [AFE-NG05-04: configuration.output has an unknown property 'jsonpFunction'](../obsolescence/afe-ng-04.md)
