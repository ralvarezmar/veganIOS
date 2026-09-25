# Builders

AFE's custom builders are responsible for wrapping the calls from the original ***angular*** builders (***@angular-devkit/build-angular***, ***@angular-devkit/build-ng-packagr***) with the addition of some internal processes.

| Builder | Objective | | ----------------------------- | ---------------------------------------------------------------------------- |
| [browser](./browser/index.md) | Perform the ***build*** process of projects of type ***application*** and ***element*** |
| [dev-server](./dev-server/index.md) | Perform the ***serve*** process of projects of type ***application*** and ***element*** |
| [lint](./lint/index.md) | Perform the ***lint*** process in projects |

> For more curiosities, visit Angular's documentation on [builders](https://angular.io/guide/cli-builder)
