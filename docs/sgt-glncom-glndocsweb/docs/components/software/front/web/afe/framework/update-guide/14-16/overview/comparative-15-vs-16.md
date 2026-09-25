# Comparison between Angular 15 and 16

The main differences between the versions are:

| ***Angular 15*** | ***Angular 16*** |
| --------- | ---------- |
| ***Angular Compatibility Compiler (ngcc)*** is supported. | ***Angular Compatibility Compiler (ngcc)*** is no longer supported.   |
| Versions ***14.20.x***, ***16.13.x*** and ***18.10.x*** are supported. | Versions ***^16.14*** and ***^18.10*** are supported. |
| Support for TypeScript version ***4.8***. |   Minimal support for ***TypeScript v4.9***. |
| Support for ***Webpack v5*** only. | Support for ***Webpack v5***, ***Vite*** and ***esbuild***. |
| Remove ***Subscriptions*** on components or directives manually. | Added the ***takeUntilDestroyed*** operator that automatically removes subscription when a component or directive is destroyed |
| Support for ***Destructive Hydration*** in ***SSR*** applications. | Support for ***Non-Destructive Hydration*** in ***SSR*** applications. |
| Support for reactivity only via ***RxJS***. | Support for reactivity via ***RxJS*** and ***Signals***. |
| Manual migration of an application to ***Standalone API***. | Automated migration to ***Standalone API*** through schematics. |
| Support for ***Jasmine*** and ***Karma*** as testing libraries. | Support for ***Jasmine***, ***Karma*** and ***Jest*** as test libraries. |
| ***Mandatory inputs*** were not officially supported.   | Official support for mandatory ***Inputs***. |

And regarding your ecosystem compatibility:

| ***Angular 14*** | ***Angular 15*** |
| --------------- | ---------- |
| ***Webpack***: 5.81.0 | ***Webpack***: 5.86.0 |
| ***TypeScript***: ~4.8 | ***TypeScript***: ~4.9.4 |
| ***RxJs***: ~7.8.0 | ***RxJs***: ~7.8.0 |
| ***jasmine***: ~4.6.0 | ***jasmine***: ~4.6.0 |
| ***karma***: ~6.4.0 |  ***karma***: ~6.4.0 |
| ***node***: 14.20/16.13/18.10 | ***node***: 16.13/18.10 |
