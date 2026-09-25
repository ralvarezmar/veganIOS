# Deprecations in Angular 16

## **_EnvironmentInjector.runInContext_** is deprecated

[_**EnvironmentInjector.runInContext**_](https://v16.angular.io/api/core/EnvironmentInjector#runInContext) is deprecated and should be replaced by using the function [_**runInInjectionContext**_]( https://v16.angular.io/api/core/runInInjectionContext).

## Property **_moduleId_** is deprecated

The **_moduleId_** property of the decorators [_**@Directive**_](https://v16.angular.io/api/core/Directive) and [_**@Component**_](https: //v16.angular.io/api/core/Component) is deprecated and will be removed in the **_17_** version of **_Angular_**.

## The **_ApplicationConfig_** interface has been moved

The [_**ApplicationConfig**_](https://v16.angular.io/api/platform-browser/ApplicationConfig) interface, used to configure the application's providers, has been moved to the `@angular/core` package ;

Update the interface import to avoid future problems in your project.

```diff
- import { ApplicationConfig } from '@angular/platform-browser';
+ import { ApplicationConfig } from '@angular/core';
```
