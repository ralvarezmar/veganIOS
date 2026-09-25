# Angular 16 Breaking Changes

## **_Angular Compatibility Compiler (ngcc)_** is no longer supported

Support for **_Angular Compatibility Compiler (ngcc)_** has been removed in the framework release.

Libraries that still work with the old **_Angular View Engine_** will no longer be supported.

## Changes to **_Angular Package Format (APF)_**

- Removed format **_FESM2015_**
- Format **_ES2020_** has been replaced by **_ES2022_**
- **_FESM2020_** format has been replaced by **_FESM2022_**

## **_TypeScript 4.8_** is no longer supported

The **_v4.8_** version of **_TypeScript_** is no longer supported by **_Angular v16_**.

Install **_TypeScript v4.9_** or a later version to perform the migration.

## Versions of **_zone.js_** no longer supported

**_0.11.x_** and **_0.12.x_** versions of **_zone.js_** are no longer supported.

## **_entryComponents_** has been removed

The **_entryComponents_** property has been removed from **_@NgModule_**.

As Angular no longer requires extra configuration to create dynamic components, this property can be removed from your code.

## **_ReflectiveInjector_** has been removed

**_ReflectiveInjector_** and related classes have been removed.

Use [**Injector.create**](https://v16.angular.io/api/core/Injector#create) as a substitute to create an instance of an [**Injector**](https://v16.angular.io/api/core/Injector).

## Support for **_Node v14_** has been removed

**_Node v14_** will no longer be supported from **04/30/2023**.

**_Angular v16_** will continue to only support **_^16.14_** and **_^18.10_** versions of **_Node_**.
