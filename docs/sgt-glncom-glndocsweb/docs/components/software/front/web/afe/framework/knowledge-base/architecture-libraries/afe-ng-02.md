# AFE-NG01-02: webpackMerge is not a function

While running the `npm run build` command, after updating your project, the following error may arise:

```bash
-- Removendo arquivos ".d.ts" desnecessários do "node_modules".
-- Arquivos ".d.ts" removidos ou não existentes.
- Generating browser application bundles (phase: setup)...
An unhandled exception occurred: webpackMerge is not a function
See "/private/var/folders/r0/kp25rzb934q6fnnm6z0j4ykd02_r8q/T/ng-vWJYEK/angular-errors.log" for further details.
```

## Contextualization

The error "An unhandled exception occurred: webpackMerge is not a function", occurs due to the declaration of the extrawepackConfig property in ***angular.json***, which when defined in the file, generates the need to use the ***webpack-merge*** package.

## Solution

Install the updated package from ***@afe/devkit-angular*** that fixes the problem mentioned in your project:

```diff
npm i @afe/devkit-angular@^2 --save-dev
```
