# Angular 13 Breaking Changes

## View Engine is no longer supported

Support for **View Engine** has been removed. Applications using Angular 13 will be using the [**Ivy**](https://v12.angular.io/guide/ivy) compiler by default.

Libraries that are still incompatible with [**Ivy**](https://v12.angular.io/guide/ivy) can _temporarily_ use [ngcc](<https://v13.angular.io/guide/glossary#ngcc>) (Angular compatibility compiler) to maintain compatibility.

## Removed support for IE11

Removing support for **IE11** allows more modern browser features to be used, such as:

[CSS Variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)

[Web Animations API](https://developer.mozilla.org/pt-BR/docs/Web/API/Web_Animations_API/Using_the_Web_Animations_API).

Furthermore, applications will become lighter and more uncomplicated as there will no longer be the need for specific polyfills.

## RxJS Update

When creating a project in Angular 13, [RxJS](https://rxjs.dev/) in version **7.4** will be used.

Existing projects using [RxJS](https://rxjs.dev/) on 6.x will need to update manually, using the following command:

```bash
npm install rxjs@7.4
```

To better understand the differences between version 6 and 7 of RxJS, check out the [official documentation](https://rxjs.dev/6-to-7-change-summary)

## TypeScript Update

Angular 13 updated the version of [TypeScript](https://www.typescriptlang.org/) to 4.4.2.

Existing projects using [TypeScript](https://www.typescriptlang.org/) in older versions will need to update manually, using the following command:

```bash
npm install typescript@4.4.2
```

> For more information about the new version of Typescript, visit [official documentation](https://devblogs.microsoft.com/typescript/announcing-typescript-4-4/).

## NodeJS Update

Angular 13 requires [NodeJS](https://nodejs.org/en) at version **12.20.0** or above.

> For more details about the breaking changes in this version, visit the [official CHANGELOG](https://github.com/angular/angular/blob/13.0.0/CHANGELOG.md#breaking-changes).

## LoadChildren does not support string

The [LoadChildren](https://v13.angular.io/api/router/LoadChildren) property in [Route](https://v13.angular.io/api/router/Route)(used to work with lazy loading ) no longer supports values of type _string_.

This change reflects the standardization of the use of [dynamic imports](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import) in routing Angular applications.

```ts
[{
   path: 'example',
   loadChildren: () => import('./example-route/example.module').then(mod => mod.ExampleModule),
}];
```

> For more information, access [official documentation](https://v13.angular.io/guide/deprecations#loadchildren-string-syntax-in-angularrouter).
