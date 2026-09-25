# What's new in Angular 12

## Angular Ivy

The ***View Engine*** was finally discontinued in the Angular 12 version.

As a result, applications can no longer use the `enableIvy: false` property to disable ***Ivy***, as the libraries created will all be ***built*** and ***deployed*** with the new engine.

Since the ***View Engine*** is deprecated now, it will also be eliminated in future significant releases.

Current libraries that are using ***View Engine*** will work with Angular ***Ivy*** with no work required for developers, but library authors should begin transitioning to ***Ivy*** ASAP.

## The future of Protractor

The team has been working with the community to decide the eventual fate of ***Protractor***. The team chose to exclude him from further tasks and, considering all aspects, to provide alternatives for him.

The team is currently working with ***Cypress***, ***WebdriverIO*** and ***TestCafe*** to assist the Angular development company in receiving elective solutions. More data will come as this evolves.

## Nullish Coalescing

The null coalescing operator (??) has been helping engineers compose cleaner code in ***TypeScript*** classes for some time.

One of the main highlights of this feature is that you can now use the operator in your Angular ***templates*** (.html files), ensuring better validation and defensive programming practices.

In templates today, engineers can use the new syntax structure to improve complex conditionals. For example:

Before:

```typescript
{{ age !== null && age !== undefined ? age : calculateAge() }}
```

After:

```typescript
{{ age ?? calculateAge() }}
```

## Style improvements

### Package ***node-sass*** replaced

Angular CDK and Angular Material have adopted the new ***sass*** module structure, now using the ***sass*** package and no longer ***node-sass***, as it is no longer maintained.

When migrating your application to the Angular 12 version, it will execute the ***schematics*** to replace any expressions using `@import` to use the new form with `@use`, check out:

Before:

```scss
@import '~@angular/material/theming';
@include mat-core();
$primary: mat-palette($mat-indigo);
$accent: mat-palette($mat-pink);
$theme: mat-light-theme((
     color: (
         primary: $primary,
         accent: $accent
     )
));

@include angular-material-theme($theme);
```

After:

```scss
@use '~@angular/material' as mat;
@include mat.core();
$primary: mat.define-palette(palette.$indigo-palette);
$accent: mat.define-palette(palette.$pink-palette);
$theme: mat.define-light-theme((
     color: (
         primary: $primary,
         accent: $accent
     )
));
@include mat.all-component-themes($theme);
```

### New option for stylesheet configuration

There is now a new configuration option called `inlineStyleLanguage`, which sets the stylesheet language in inline components. Currently supported language options are ***CSS*** (default), ***Sass***, ***SCSS*** and ***LESS***.

The CSS standard allows existing designs to continue to work as expected.

## Community Support

The Angular team is continually trying to improve the Angular learning experience for developers as well. As part of the new features in Angular 12, they have implemented some significant improvements to their documentation.

They also updated the angular.io contributor guide which will help people who want to improve the documentation.

## Strict mode by default

Angular strict mode has now been enabled by default in the CLI as one of the features in Angular 12.

> Strict mode improves maintainability and helps catch bugs early in the process.
> Additionally, strict mode applications are simpler to examine statically and can help the `ng update` command refactor code more safely and accurately when you are upgrading to newer versions of Angular.

It is also possible to create a new application within an existing non-strict ***workspace***, passing the ***flag*** `--strict` to the command:

```bash
ng generate application [project-name] --strict
```

## Compilation in production mode by default

In version 12 of Angular, ***build*** of applications will all be done in production mode.

## Improvements to ***HttpClient***

Angular 12 introduces a number of updates around its HTTP support.

### Metadata for requests and ***interceptors***

***HttpClient*** can now be used to store and retrieve custom metadata in requests. This is especially useful when using ***interceptors***. This capability can be enjoyed through [***HttpContext***](https://angular.io/api/common/http/HttpContext).

### ***.appendAll()*** in request parameters

The ***HttpParams*** class now has a new method `.appendAll()`, which can be used to effortlessly add a series of parameters:

```typescript
appendAll(params: {[param: string]: string|string[]}): HttpParams
```

### New status codes for requests

Angular 12 presents its own list of understandable names for ***HTTP*** status codes.
Available through an [***enum***](<https://www.typescriptlang.org/docs/handbook/enums.html>). Because of this new element, we can now use ***HttpStatusCode*** instead of creating our own interfaces.

```typescript
if (response.status === HttpStatusCode.Ok) {
     // code omitted
}
```

## Language service enabled by default

- [Language Service](https://angular.io/guide/language-service), or language service, based on [***Ivy***](#angular-ivy) is now enabled by default, through from the ***angularCompilerOptions.strictTemplates*** property of ***tsconfig.json***:

```json
"angularCompilerOptions": {
   "strictTemplates": true
}
```

## New development tools

The Angular team reported on some accessibility tools available in ***Angular Dev Tools*** for ***Google Chrome***. By enabling the extension, you can monitor and record all events detected by a component, to find out if there is any performance bottleneck.

> **🎓Did you know?**
>
> The Angular community only had semi-official tools that were not compatible with ***Ivy***. In other words, this is a big victory for accessibility!

## Universal Angular

In addition to offering improvements to Inline critical CSS, which is, by default, in the ***nguniversal/common*** package, Angular Universal in this version appears with a new engine that looks promising.

The new mechanism aims to simplify the generation of ***shells*** of applications without an extra compilation and remove the need for multiple compilations for ***pre-render*** or ***server side rendering***.

## Internationalization (i18n)

The algorithm based on ***Angular***'s ***View Engine*** for generating message IDs has been deprecated.

Angular version 12 added the ***flag*** `--migrateMapFile` to generate a file mapping all legacy message IDs or run the ***localize-migrate*** script to migrate them all the IDs.

> **⚠️ Note**
>
> If you don't perform this migration, all your generated message IDs will change when Angular removes the ***View Engine*** compiler.

## Support for ***TypeScript*** in version 4.2

One of the major feature updates in Angular 12 is the support of ***Typescript*** **4.2**. The stable version was released on February 23, 2021.

> For more information see [what's new in Typescript 4.2.x](./ecosystem-12/typescript.md)

## Support for Webpack 5.37

Angular 12 introduces the experimental support for Webpack 5 that was introduced in Angular 11.

It incorporates several important changes and features. It helps improve build performance, long-term caching, web platform compatibility, bundle size with better code generation, and more!

> For more information see [webpack 5.x.x news](./ecosystem-12/webpack.md)
