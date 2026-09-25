# Comparison between Angular 13 and 14

The main differences between the versions are:

| ***Angular 13*** | ***Angular 14*** |
| --------- | ---------- |
| [Reactive Forms](https://v13.angular.io/guide/reactive-forms) does not allow value typing. | [Typed Forms](https://v14.angular.io/guide/typed-forms) which allows static typing of [Reactive Forms](https://v14.angular.io/guide/reactive-forms) |
| Angular CLI flags in **camel case** format (like `--skipTests`) are deprecated | Angular CLI removed flags in **camel case** format and standardized the **lower skewer case** format (like --skip-tests). |
| [initialValueIsDefault](https://v13.angular.io/api/forms/FormControlOptions#initialValueIsDefault) property allows you to set the value used as the default | [initialValueIsDefault](https://v14.angular.io/api/forms/FormControlOptions#initialValueIsDefault) property is deprecated. Use the [nonNullable](https://v14.angular.io/api/forms/FormControlOptions#nonNullable) property. |

And regarding your ecosystem compatibility:

| ***Angular 13*** | ***Angular 14*** |
| --------------- | ---------- |
| ***Webpack***: 5.80.0 | ***Webpack***: 5.81.0 |
| ***TypeScript***: ~4.6.2 | ***TypeScript***: ~4.7.2 |
| ***RxJs***: ~7.5.0 | ***RxJs***: ~7.5.0 |
| ***jasmine***: ~4.6.0 | ***jasmine***: ~4.6.0 |
| ***karma***: ~6.3.0 |  ***karma***: ~6.4.0 |
| ***node***: 12.20.x/14.15.x/16.10.x | ***node***: 14.15.x/16.10.x |
