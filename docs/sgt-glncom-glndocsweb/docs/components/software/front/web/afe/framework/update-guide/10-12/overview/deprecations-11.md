# Deprecation in Angular 11

Some APIs and features have become deprecated and have needed to be removed or replaced so that Angular can keep up-to-date. To make these transitions easier, the use of APIs and features is suspended for a period of time before removing them.

This gives the project time to update its applications. Here are some of the features that have been deprecated and/or removed:

## Loading modules via string

When Angular introduced lazy loading routes, there was no browser support for dynamically loading JavaScript.

Angular has created its own schema for loading modules using the syntax loadChildren: './lazy/lazy.module#LazyModule'.

Now that dynamic import from ECMAScript is supported by many browsers, Angular is updating to use this new syntax.

Before:

```typescript
const routes: Routes = [{
  path: 'lazy',
  // The following string syntax for loadChildren is deprecated
  loadChildren: './lazy/lazy.module#LazyModule'
}];
```

After:

```typescript
const routes: Routes = [{
  path: 'lazy',
  // The new import() syntax
  loadChildren: () => import('./lazy/lazy.module').then(m => m.LazyModule)
}];
```

## Component style selectors ***/deep/***, ***>>>*** and ***:ng-deep***

The ***shadow-dom-piercing*** downstream combiner is deprecated and support is being removed from major browsers and tools. As such, in v4, we have discontinued Angular support for all 3 of ***/deep/***, ***>>>*** and ***::ng-deep***.

Until removal, ***::ng-deep*** is preferred for further compatibility with the tools.

## ***entryComponents*** and ***ANALYZE_FOR_ENTRY_COMPONENTS*** are no longer required

The ***entryComponents*** property was used to tell the compiler which components would be created and inserted dynamically.

With Ivy, this is no longer a requirement and the property can be removed from existing module declarations.

The same applies to the injection token 'ANALYZE_FOR_ENTRY_COMPONENTS'.

## Properties ***params*** and ***queryParams***

[***ActivatedRoute***](https://v11.angular.io/api/router/ActivatedRoute) contains two properties that will be deprecated in future versions of Angular and should be deprecated:

| Property | Substitute |
| ----------- | ---------- |
| `params`    | `paramMap` |
| `queryParams` | `queryParamMap` |

> Check the full documentation [depreciações](https://v11.angular.io/guide/deprecations)
