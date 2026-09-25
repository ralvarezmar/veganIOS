# Depreciation in Angular 10

Some APIs and features have become deprecated and have needed to be removed or replaced so that Angular can keep up-to-date. To make these transitions easier, the use of APIs and features is suspended for a period of time before removing them.

This gives the project time to update its applications.

Here are some of the features that have been deprecated and/or removed:

## Internet Explorer support has been discontinued

Support for Internet Explorer versions 9 and 10 and IE Mobile has been removed.

## No more generation of ***ESM5*** or ***FESM5*** files for libraries

The Angular package format does not include the ESM5 or FESM5 files, saving approximately ~120 MB of download and installation time when running the package manager.

These formats are no longer necessary, as any transpilation to support ***ES5*** is done at the end of the build process.

> For more information, please refer to the [Depreciation and Removal List](https://angular.io/guide/deprecations).
