# 8.x.x

## 8.6.1 - 2021-01-12

Added | Changed | Removed
----- | ------- | -------
\- | Added `onSessionInitialized$` method to the SecurityService stub that was causing playground tests to fail | -

## 8.6.0 - 2020-12-04

Added | Changed | Removed
----- | ------- | -------
Universal cookie deletion at the end of the session | - | -

## 8.5.0 - 2020-10-08

Added | Changed | Removed
----- | ------- | -------
Adds `X-Santander-Client-Id` header required to consume API Connect with BKS token | - | -
Add Organization header that identifies the organization calling an API | - | -

## 8.4.1 - 2020-10-05

Added | Changed | Removed
----- | ------- | -------
\- | Fixes the `forRoot` method of the Security and Logger modules that caused an error when compiled in production mode | -

## 8.4.0 - 2020-09-25

Added | Changed | Removed
----- | ------- | -------
Add `SESSION_INITIALIZED` event and the `onSessionInitialized$` observable to listen for it. This event is emitted when the session has been initialized with a fresh token the first time, or when the cookie is exchanged for a token | - | -
Improved README.md file documentation on the forRoot method of the `ConfigTestingModule` module | - | -
Internal enhancements to our processes for automatic documentation in Github Pages | - | -

## 8.3.3 - 2020-06-20

Added | Changed | Removed
----- | ------- | -------
Adds configuration `forRoot` to the `ConfigTestingModule` module. Allows to configure the configuration json properties. Useful when you want to test methods that access configuration service properties | - | -

## 8.3.2 - 2020-05-29

Added | Changed | Removed
----- | ------- | -------
Improved `killSession` method of the `SecurityServiceStub` mock for more realistic testing of applications that use the `SecurityService` service | - | -

## 8.3.1 - 2020-05-28

Added | Changed | Removed
----- | ------- | -------
Adds mode property, `onSessionKilled$` observable, and `onSessionKilled` method to the `SecurityServiceStub` service, necessary for unit testing. The absence of these attributes caused the tests to fail silently | - | -

## 8.3.0 - 2020-02-20

Added | Changed | Removed
----- | ------- | -------
Possibility to initialize the @ng-darwin/security module with new Auth modes: POST and PARAM | The language property, common to all modules and necessary to configure them, becomes optional | -
The `enableLocalPostMode` function to enable the local authentication mode to hide and isolate the internal code of a possible archetype that uses it | The `tokenQueryParam` property required to configure the security module in `Auth.URL` mode becomes optional due to the possibility of using other authentication modes | -
Documentation and examples with possible error codes to be listened by the applications | - | -

## 8.2.0 - 2019-11-26

Added | Changed | Removed
----- | ------- | -------
Public method `initializeFronNonStructural` is added in the Security module | - | The public `restart` method of the Security module is removed

## 8.1.0 - 2019-10-30

Added | Changed | Removed
----- | ------- | -------
New `killSession()` method | Modifies observable name `onSessionAboutToExpired$` to `onSessionAboutToTimeout$` | -
New `onSessionKilled$` observable to the `SESSION_KILLED` event | Modify observable name `onSessionExpired$` to `onSessionTimeout$` | -

## 8.0.0 - 2019-09-26

Added | Changed | Removed
----- | ------- | -------
Config module | - | -
Security  module | - | -
Logger  module | - | -
