# Deprecations in Angular 17

## Deprecation of `ChangeDetectorRef.checkNoChanges`

The `ChangeDetectorRef.checkNoChanges` method has been deprecated.

For test code, `ComponentFixture` should be used instead of `ChangeDetectorRef`.

Application code should not directly call `ChangeDetectorRef.checkNoChanges`.

## Changes to the context object for EmbeddedViewRef

Switching the context object for `EmbeddedViewRef` is no longer supported. Support for this was introduced in version **12.0.0**, but this pattern is rarely used.

There is no direct replacement, but in many cases, you can use simple assignments or `Object.assign`. Alternatively, it is still possible to replace the entire object using a `Proxy` (see `NgTemplateOutlet` as an example).
