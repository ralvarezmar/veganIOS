# AFE-NG05-02: Cannot find module 'util'

While running the 'npm run start' or 'npm run test' *script*, the following error may arise:

```bash
Error: Module not found: Error: Can't resolve 'util' in path

BREAKING CHANGE: webpack < 5 used to include polyfills for node.js core modules by default.
This is no longer the case. Verify if you need this module and configure a polyfill for it.

If you want to include a polyfill, you need to:
        - add a fallback 'resolve.fallback: { "util": require.resolve("util/") }'
        - install 'util'
If you don't want to include a polyfill, you can use an empty module like this:
        resolve.fallback: { "util": false }

Error TS2307: Cannot find module 'util' or its corresponding type declarations.
```

## Contextualization

The error **"TS2307: Cannot find module 'util' or its corresponding type declarations"** occurs due to an internal change of ***webpack***.

Which removed the **util*** package from its dependencies in its version 5, impacting all projects that use any of the methods of this package without having defined it as a dependency in their ***package.json***.

## Architecture Guidelines

We advise the channel, before following the solution proposed in the next session, to carry out a survey of the methods of the ***util*** package used by the application and a possible replacement.

Use the code snippet with the deprecated method as a base: ***isNullOrUndefined***:

```typescript
import { isNullOrUndefined } from 'util';

if (!isNullOrUndefined(window.dataLayer)) {
    // código omitido
}
```

Choose to internalize the method's logic into the project, if possible, as in the example below:

```typescript
import { isNullOrUndefined } from 'util';

if (!(window.dataLayer === undefined || window.dataLayer === null)) {
    // código omitido
}
```

In this way, the package can be removed as a dependency.

## Solution

If the replacement is too complex, choose to just install the ***uti package

```bash
npm i util
```
