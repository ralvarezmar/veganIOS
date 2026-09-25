# Deprecations in Angular 14

## FormControl initialValueIsDefault property

The configuration property [***initialValueIsDefault***](https://v14.angular.io/api/forms/FormControlOptions#initialValueIsDefault) is deprecated due to the new property [***nonNullable***](https://v14.angular.io/api/forms/FormControlOptions#nonNullable).

Which serves the same purpose. No changes in behavior were made.

The [***nonNullable***](https://v14.angular.io/api/forms/FormControlOptions#nonNullable) property allows the behavior of [***FormControl***](https://v14.angular.io/api/forms/FormControl) is aligned with the characteristics of [Typed Forms](https://v14.angular.io/api/forms/FormGroup).

```ts
// When nonNullable is set to true, the value used when creating the FormControl will be used as the default value when reset.
const cat = new FormControl('tabby', { nonNullable: true });
cat.reset(); // cat.value will be "tabby"

// By default, the value used in the FormControl when resetting will always be null
const cat = new FormControl('tabby');
cat.reset(); // cat.value will be null
```

> For more information about deprecations, visit [official documentation](https://v14.angular.io/guide/update-to-latest-version#new-deprecations)
