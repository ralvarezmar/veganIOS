# Angular 15 Breaking Changes

## Support for NodeJS versions **14.20**, **16.13** and **18.10**

Angular added support for NodeJS **v18** and increased support for versions **14.20** and **16.13** of the same.

Therefore, NodeJS versions **14.15** to **14.19** and **16.10** to **16.12** are no longer supported.

## Support for TypeScript v4.8

Added support for **TypeScript v4.8**. Versions **earlier** than this will no longer be supported.

> For more information, visit [official documentation on **TypeScript v4.8**](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-8.html).

## **_setDisabledState_** method will always be called when **_ControlValueAccessor_** is created

The **_setDisabledState_** method from this version onwards will be called by default whenever the class that implements the **_ControlValueAccessor_** API is initialized by Angular.

In previous versions, the method was only called when the control (in English, **_FormControl_**) was manually disabled.

This change in behavior is a **_Breaking Change_** that may affect projects that use **_ControlValueAccessor_** directly.

As a _palliative_ measure, a configuration was added to `FormsModule.withConfig` and `ReactiveFormsModule.withConfig` that allows informing which behavior will be used.

Two constants can be entered to configure the behavior, namely `whenDisabledForLegacyCode` and `always` (default).

```ts
ReactiveFormsModule.withConfig({
   callSetDisabledState: 'whenDisabledForLegacyCode'
})
```

Note that the solution above is _palliative_, only useful to avoid major breakdowns in projects! Whenever possible, use the most current behavior, which is recommended.

> For more information, access [official documentation about **ControlValueAccessor**](https://v15.angular.io/api/forms/ControlValueAccessor).

## **_enableIvy_** setting has been removed from Angular Compiler

The **_enableIvy_** setting has been removed, as **_Ivy_** is Angular's only rendering engine.
