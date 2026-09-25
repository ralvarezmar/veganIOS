# Angular 11's Breaking Changes

As usual, the major releases include important changes, below are some of them:

- Removed support for ~~***IE 9, 10, and IE mobile***~~.
- Removed ~~***TSLint***~~. This has been deprecated by the project's creators who recommend migrating to ***ESLint***. -
- ~~***TypeScript 3.9***~~ is no longer supported. Updated to ***TypeScript 4.0***.
- ~~***NavigationExtras#preserveQueryParams***~~ and ~~***CollectionChangeRecord***~~ have been removed from ***@angular/router***.
- ~~***@angular/platform-webworker***~~ is no longer supported and will no longer be updated.
- ~~***ViewEncapsulation.Native***~~ has been removed.
- ***Locale data arrays*** are now read-only.
- ***DatePipe*** no longer rounds milliseconds.
- Injected ***ControlValueAccessor*** to ***NG***VALUE***ACCESSOR*** is now read-only
- Calling ***overrideProvider*** before initializing ***TestBed*** will now throw an error.
- Fixed a bug in the router where arguments were reversed in the call to **shouldReuseRoute** when processing secondary routes.
- Usually, this sorting error doesn't matter because most implementations of ***shouldReuseRoute*** only make an equal comparison between the current and future route.
- However, some implementations actually rely on values specifically in one of the two and will need to be updated.
- Changed the default value for ***relativeLinkResolution*** from ***legacy*** to ***corrected*** so that new applications are automatically included in the corrected behavior.
- Applications that use the current default are updated by a migration to specify ***legacy*** to ensure the current behavior is maintained when the default is updated.
- The directives in the ***@angular/forms*** package used to have ***any[]*** as a type of validators and ***asyncValidators*** arguments in the constructors.
- These arguments are now typed correctly, so if your code is based on policy builder types, it may require some updates to improve type safety.
- ***Pipes***: ***Slice*** pipe now returns null for the ***undefined*** input value.
- ***Pipes***: The ***date*** and ***number*** pipe type are now fixed, they used to use the ***any*** type as input previously.
- ***Pipes***: ***DatePipe*** will round the part of the given date and time millisecond to the nearest millisecond.
- ***Pipes***: ***Async*** Pipe will no longer return ***null*** as an input value ***undefined***.
