# Angular 18 Breaking Changes

## Support for NodeJS has been updated

The following NodeJS versions are supported.

- **18.19**
- **20.11**
- **22.0**

## Support for TypeScript

## Angular does not support **_TypeScript_** versions lower than **_5.4_**

Changes in `ComponentFixture.whenStable`

`ComponentFixture.whenStable` now corresponds to the `ApplicationRef.isStable` observable.

Before this change, fixture stability did not include everything considered in `ApplicationRef`.

Fixture's `whenStable` will now include unfinished router navigations and unfinished `HttpClient` requests. This will cause tests waiting for the `whenStable` promise to time out when there are incomplete requests.

To fix this, remove `whenStable`, wait for another condition, or ensure that the `HttpTestingController` simulates responses for all requests. Try adding `HttpTestingController.verify()` before waiting for `fixture.whenStable` to identify open requests.

## Change Detection Outside of Zone in Angular 18

Angular will ensure that change detection is run, even when state updates originate outside of the zone. Tests may observe additional rounds of change detection compared to previous behavior.

This update may affect unit tests, urging updates for accuracy. If debugging is hard, revert to old behavior with `provideZoneChangeDetection({schedulingMode: NgZoneSchedulingMode.NgZoneOnly})`.

Apps can avoid change detection for external state updates with `provideZoneChangeDetection({schedulingMode: NgZoneSchedulingMode.NgZoneOnly})` in `bootstrapApplication` or `schedulingMode: NgZoneSchedulingMode.NgZoneOnly` in `bootstrapModule`.

## `async` Method Removed

The `async` method from `@angular/core/testing` has been removed. Use `waitForAsync` or `fakeAsync` instead.

## Changes in `withHttpTransferCache`

By default, we now prevent caching of HTTP requests that require authorization. To disable this behavior, use the `includeRequestsWithAuthHeaders` option in `withHttpTransferCache`.

```ts title='app-config.ts'
withHttpTransferCache({
  includeRequestsWithAuthHeaders: true,
})
```
