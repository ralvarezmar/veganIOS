# Depreciations in Angular 9

Some APIs and features have become deprecated and have needed to be removed or replaced so that Angular can keep up-to-date. To make these transitions easier.

The use of APIs and features is suspended for a period of time before removing them. This gives the project time to update its applications.

Here are some of the features that have been deprecated and/or removed:

## Web Tracing Framework integration

Previously, Angular supported an integration with the Web Tracing Framework (WTF) for performance testing of Angular applications. This integration has not been maintained and extinguished.

As a result, the integration was deprecated in version 8 of Angular and due to no evidence of existing use was removed in version 9.

Alternatively, you should use Lighthouse's [user timing](https://developers.google.com/web/tools/lighthouse/audits/user-timing) feature

## **ngModel** with reactive forms

Support for using the input property ***ngModel*** and the ***ngModelChange*** event with reactive form directives has been deprecated in ***Angular 6*** and will be removed in future versions of ***Angular***.

```html
<input [formControl]="control" [(ngModel)]="value">
```

```typescript
this.value = 'some value';
```
