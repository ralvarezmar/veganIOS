# Comparison between Angular 12 and 13

The main differences between the versions are:

| ***Angular 12*** | ***Angular 13*** |
| --------- | ---------- |
| Suspension of support for IE11 | Removal of support for IE11 |
| Deprecation of support for View Engine | Removed support for View Engine. [**Ivy**](https://v12.angular.io/guide/ivy) should be used as the default compiler. |
| To create components dynamically it is necessary to use [ComponentFactoryResolver](https://v13.angular.io/api/core/ComponentFactoryResolver) and [ViewContainerRef](https://v13.angular.io/api/core/ViewContainerRef#viewcontainerref) | [ViewContainerRef.createComponent](https://v13.angular.io/api/core/ViewContainerRef#createComponent) allows you to dynamically create components more easily, removing the need to use [ComponentFactoryResolver](<https://v13.angular.io/api/core/ComponentFactoryResolver>) |

And regarding your ecosystem compatibility:

| ***Angular 12*** | ***Angular 13*** |
| --------------- | ---------- |
| ***Webpack***: 5.50.0  | ***Webpack***: 5.80.0 |
| ***TypeScript***: ~4.3.5 | ***TypeScript***: ~4.6.2 |
| ***RxJs***: ~6.6.0 | ***RxJs***: ~7.5.0 |
| ***jasmine***: ~3.8.0 | ***jasmine***: ~4.6.0 |
| ***karma***:  ~6.3.0 | ***karma***: ~6.3.0 |
| ***node***: 12.x.x/14.x.x  | ***node***: 12.20.x/14.15.x/16.10.x |
