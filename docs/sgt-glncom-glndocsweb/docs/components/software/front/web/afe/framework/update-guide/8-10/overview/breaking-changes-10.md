# Breaking Changes in Angular 10

## Browser Support

The settings for [browser support](https://angular.io/guide/browser-support) have been updated for new projects, excluding older and lesser-used browsers, with Internet Explorer 9, 10, and Internet Explorer Mobile being the main removal.

If necessary, simply add the intended browsers in the ***.browserslistrc*** file to enable ***ES5*** builds and ***differential loading*** (differential loading***).

> This has a side effect as it disables ***ES5*** builds by default for new projects.

## Angular Ecosystem

Several updates have been made to the dependencies used by Angular, in order to evolve its ecosystem.

- TypeScript: Updated to 3.9 so that previous versions are no longer supported.
- ***TSlib***: updated to **v2.0**
- ***TSLint***: (static analysis tool for ***TypeScript***) has been updated to **v6**.
- ***Angular Package Format***: No longer includes ***ESM5*** or ***FESM5***, saving download and installation time.

> There is a new ***tsconfig.base.json.*** file, and this additional file better supports the way IDEs and tools resolve type and package configurations.

## Service Workers

[***vary***](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Vary) headers were previously taken into account when retrieving resources from the cache, preventing the retrieval of cached assets.

Leading to unpredictable behavior due to inconsistent implementations such as errors in different browsers. These headers are now ignored when retrieving cached resources from the Service Worker.

Which can result in resources returning even when their headers are different. If your application needs to differentiate its responses based on request headers, make sure that the Service Worker is configured to prevent caching of the affected resources.

## Forms

Input fields of type ***number*** fire the ***valueChanges*** event only once per value change (as opposed to twice in some cases), and the ***minLength*** and ***maxLength*** validators only validate values that have the ***length*** numeric property.

## Router

***UrlMatcher*** can now return values of type ***null*** and any ***resolver*** that returns ***EMPTY*** will cancel navigation. To allow navigation to continue, you'll need to update the resolver to emit any value.

## Core

The generic type has been made mandatory for ***ModuleWithProviders*** if it is working with the ***Ivy*** compiler. During the upgrade to version 10, the required code will be updated.

However, if a developer is using the View Engine, they may receive a compilation error such as:

```bash
Erro TS2314: tipo genérico 'ModuleWithProviders <T>' requer 1 argumento (s) de tipo.
```

In this case, you will need to contact the author of the library to correct this point.
