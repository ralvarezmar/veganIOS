# Breaking Changes

To migrate **ng-darwin** libraries to a **13.x.x** version, the following **breaking changes** must be considered:

- This new release does not involve any _breaking change_ related to Darwin. The great advantage it has is to offer compatibility with a newer version of the Angular framework, and that application developers can take advantage of it.
The different modules of **ng-darwin** version **13.x.x** only work with **Angular version 13**, so it will be necessary for applications to migrate to this version of Angular.
You can help yourself with the [Angular Update Guide](https://update.angular.io/){:target="_blank"} provided by the Angular team itself.
- We no longer generate UMD bundles. These UMD modules should not affect applications, since they do not make use of them. It should only be taken into account if they are explicitly used. The below options which were used for UMD bundle generation has also been removed. <!-- markdownlint-disable MD013 -->
    - `umdModuleIds`
    - `umdId`
