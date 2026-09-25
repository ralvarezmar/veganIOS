# Angular 14 Breaking Changes

## Typed Forms

[Reactive Forms](https://v14.angular.io/guide/reactive-forms) now supports static typing. This improvement brings more clarity when manipulating forms.

All classes, such as [FormControl](https://v14.angular.io/api/forms/FormControl) and [FormGroup](https://v14.angular.io/api/forms/FormGroup), remain with the same signature.

However, now, they map the **type** of value that is being used in each form field, and assume that this will be the final typing.

```ts
const form = new FormGroup({
     title: new FormControl(''),
     price: new FormControl(0),
});

form.value.title // string
form.value.price // number
form.value.price.startsWith('a') // TS Error: Property 'startsWith' does not exist on type 'number'.
```

This improvement can generate **breaking changes** in projects, as forms now assume that the type of value defined when creating each field will be used as typing.

```ts
   const title = new FormControl('');
   title.setValue(0) // Error: field type is "string"

   const name = new FormControl(null);
   name.setValue(''); // Error: field type is "null"
```

To avoid complications when migrating versions, new classes called `UntypedForms` were added to Angular Forms.

```ts
const login = new UntypedFormGroup({
     email: new UntypedFormControl(''),
     password: new UntypedFormControl(''),
});

login.value.email // any
login.value.password // any
```

When running the `ng update` command, all classes starting with ***Form*** will be replaced with ***UntypedForm***.

For example:

```ts
const login = new FormGroup({
     email: new FormControl(''),
     password: new FormControl(''),
});
```

```ts
const login = new UntypedFormGroup({
     email: new UntypedFormControl(''),
     password: new UntypedFormControl(''),
});
```

> For more information, visit [official documentation on typed forms.](https://v14.angular.io/guide/typed-forms)

## Angular CLI: Removing flags in camel case

Flags in **camel case** format (such as `--skipTests`) that were deprecated were **removed** in this version.

All flags now use the **lower skewer case** format.

For example:

```bash
ng new my-project --skip-tests
```

## Removed sanitization from [style] directive

The **[style]** directive will no longer sanitize css properties that may contain malicious JavaScript expressions (such as `url(javascript:...)`), as modern browsers do not support this type of expression.

This change was made in version 10 of Angular.

> For more information, visit [official documentation on deprecations](https://v14.angular.io/guide/deprecations#style-sanitization-for-style-and-styleprop-bindings).
