# Deprecations in Angular 12

Some APIs and features have become deprecated and have needed to be removed or replaced so that Angular can keep up-to-date.

To make these transitions easier, the use of APIs and features is suspended for a period of time before removing them. This gives the project time to update its applications.

Here are some of the features that have been deprecated and/or removed:

## Deprecation of support for Internet Explorer 11

Angular is a platform that is constantly evolving, which makes it keep up with the advancement of the ecosystem around it.

With the elimination of support for legacy browsers, the framework team can focus on providing modern solutions to help engineers and customers.

The team also included a new deprecation warning message as another feature in Angular 12 and eliminated support for Internet Explorer 11 in Angular 13.

## Import from ***sass***

***sass*** imports by ***@angular/material/theming*** have been discontinued.

There is a new API in Angular Material to import the **sass**, via the '@use'. Run the migration script `ng g @angular/material:themingApi` to migrate all your ***sass*** imports in Angular CDK and Angular Material to the new ***API***.

## Publishing libraries with ***View Engine***

Support for publishing libraries with **View Engine** has been discontinued. You should now compile your libraries in Ivy compatibility mode.

### Internationalization (***i18n***)

Libraries compiled in partial compilation mode will not contain legacy message IDs.

If the library was previously compiled by the View Engine and contained legacy message IDs, your applications may have translation files that you will need to migrate to the new message ID format.

For more information, see [Migrating Legacy Location IDs](https://angular.io/guide/migration-legacy-message-id).

> To know more about deprecations, check [Deprecation list](https://v12.angular.io/guide/deprecations).
