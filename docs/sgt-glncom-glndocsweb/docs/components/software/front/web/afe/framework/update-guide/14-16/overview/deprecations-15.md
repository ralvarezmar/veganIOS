# Deprecations in Angular 15

## The **_DATE_PIPE_DEFAULT_TIMEZONE_** token is deprecated

The **_DATE_PIPE_DEFAULT_TIMEZONE_** token is deprecated and should be replaced by **_DATE_PIPE_DEFAULT_OPTIONS_**, which allows the same configuration through a JavaScript object.

> For more information, visit [official documentation about **_DATE_PIPE_DEFAULT_TIMEZONE_**](https://v15.angular.io/api/common/DATE_PIPE_DEFAULT_TIMEZONE).

## **_providedIn: NgModule_** and **_providedIn: 'any'_** are deprecated

The use of `providedIn: NgModule` and `providedIn: 'any'` with the `@Injectable` decorator and also with the `InjectionToken` class did not have wide adoption by the Angular community.

Therefore, these two settings are deprecated and will be removed in the next versions of the framework.

It is recommended to use `providedIn: 'root'` to override such settings.

## Signatures of the **_Injector.get()_** and **_TestBed.inject()_** methods are deprecated

The signatures of the [_**Injector.get()**_](https://v15.angular.io/api/core/Injector#get) and [_**TestBed.inject()**_] methods (<https://v15.angular.io/api/core/testing/TestBed#inject>)
that use the enum [_**InjectFlags**_](https://v15.angular.io/api/core) as parameters /InjectFlags) are deprecated.

It is recommended to use their signatures that use the [_**InjectOptions**_](https://v15.angular.io/api/core/InjectOptions) interface.
