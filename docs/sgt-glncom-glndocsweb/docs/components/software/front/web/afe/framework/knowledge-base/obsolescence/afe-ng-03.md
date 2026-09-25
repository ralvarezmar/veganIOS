# AFE-NG05-03: Cannot read properties of undefined (reading 'defineProperties')

While running the 'npm run start' command, after updating your project, the following error may arise:

***"Error triggered in console "Cannot read properties of undefined (reading 'defineProperties')" in file polyfills.js"***

## Contextualization

The **"Cannot read properties of undefined (reading 'defineProperties')"** error in the ***polyfills.js*** file in MFE applications with Angular Elements, occurs due to a version mismatch between the project's *polyfills*.

## Architecture Guidelines

Please review the need to use *polyfills* in the project, as as of Angular 12 support for Internet Explorer 11 has been deprecated and [will be removed in Angular 13](https://github.com/angular/angular/issues/41840).

**If possible, remove them.**

## Solution

If your project requires the ***@webcomponents/custom-elements*** and ***@webcomponents/shadydom*** packages, update them to the most current version:

```bash
npm i @webcomponents/custom-elements@latest @webcomponents/shadydom@latest
```
