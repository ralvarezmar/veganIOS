# What's new in Angular 18

- [What's new in Angular 18](#whats-new-in-angular-18)
  - [New official website](#new-official-website)
  - [Deferrable Views is stable](#deferrable-views-is-stable)
  - [Control Flow Syntax is stable](#control-flow-syntax-is-stable)
  - [`Zoneless` is available as experimental support](#zoneless-is-available-as-experimental-support)
  - [Specifying a fallback content for `ng-content`](#specifying-a-fallback-content-for-ng-content)
  - [Unified state change events in Forms API](#unified-state-change-events-in-forms-api)
  - [Route redirects as functions](#route-redirects-as-functions)

## New official website

[angular.dev](https://angular.dev/)  is the official website of Angular for versions from v18 onwards.

Now, all requests to [angular.io](https://angular.io/) are automatically redirected to [angular.dev](https://angular.dev/).

To ensure that all existing links continue to work, requests for older versions of Angular will be redirected to [angular.io](https://angular.io/).

## Deferrable Views is stable

The `@defer` operator is now stable and ready to be used in production. With it, you can load components in the template **on demand**, making the rendering more optimized and the final bundle lighter!

## Control Flow Syntax is stable

The `@if`, `@for`, `@switch`, and `@defer` operators are now stable and ready to be used in production. With them, you can control the rendering flow in a simpler and more intuitive way.

## `Zoneless` is available as experimental support

Change detection has been undergoing continuous evolution. Traditionally, a library known as `zone.js` was responsible for triggering change detection in Angular. However, this library had several limitations, both in developer experience and performance.

For several years, there has been a search for a way to use Angular without the dependency on `zone.js`, and now, with great satisfaction, the first experimental APIs for zoneless are presented!

From now on, it is possible to test the experimental support for zoneless in Angular! Just add `provideExperimentalZonelessChangeDetection` to the application bootstrap:

``` ts title='main.ts'
bootstrapApplication(App, {
  providers: [
    provideExperimentalZonelessChangeDetection()
  ]
});
```

It is also necessary to remove `zone.js` from the polyfills in `angular.json`.

Looking to the future, zoneless brings many opportunities for developers:

Faster initial rendering and runtime
Reduced package size and faster page loads
Simpler debugging
The most effective way to use zoneless in components is through Signals:

``` ts title='app.component.ts'
@Component({
  ...
  template: `
    <h1>Hello from {{ name() }}!</h1>
    <button (click)="handleClick()">Go Zoneless</button>
  `,
})
export class App {
  protected name = signal('Angular');

  handleClick() {
    this.name.set('Zoneless Angular');
  }
}
```

In the example above, clicking the button triggers the `handleClick` method, updating the Signal value and the user interface. This is similar to how an application using `zone.js` works, with some differences.

With `zone.js`, Angular performed change detection whenever the application state could have changed. Without zones, Angular restricts this check to fewer triggers, such as Signal updates.

This change also includes a new scheduler with coalescence to avoid checking for changes several times in a row.

For example, when clicking the button above, Angular will perform change detection only once, thanks to the scheduler's coalescence.

## Specifying a fallback content for `ng-content`

One of the most voted issues we had was specifying a default content for ng-content. In v18, it is now available! Here is a quick example:

``` ts title='profile.component.ts'
@Component({
  selector: 'app-profile',
  template: `
    <ng-content select=".greeting">Hello </ng-content>

    <ng-content>Unknown user</ng-content>
  `,
})
export class Profile {}
```

Now we can use the component:

``` html title='app.component.html'
<app-profile>
  <span class="greeting">Good morning </span>
</app-profile>
```

Which will result in:

``` html title='app.component.html'
<span class="greeting">Good morning </span>
Unknown user
```

## Unified state change events in Forms API

The `FormControl`, `FormGroup`, and `FormArray` classes of Angular Forms now expose a property called `events`, which allows you to subscribe to an event stream for this form control.

Using it, you can track changes in value, touch state, etc.

Now you can use:

``` typescript title='app.component.ts'
const nameControl = new FormControl<string|null>('name', Validators.required);
nameControl.events.subscribe(event => {
  // process individual events
});
```

## Route redirects as functions

To allow for greater flexibility when dealing with redirects, the `redirectTo` property now accepts a function that returns a string.

For example, if you want to redirect to a route that depends on some runtime state, you can implement more complicated logic in a function:

``` typescript title='app-routing.module.ts'
const routes: Routes = [
  { path: "first-component", component: FirstComponent },
  {
    path: "old-user-page",
    redirectTo: ({ queryParams }) => {
      const errorHandler = inject(ErrorHandler);
      const userIdParam = queryParams['userId'];
      if (userIdParam !== undefined) {
        return `/user/${userIdParam}`;
      } else {
        errorHandler.handleError(new Error('Attempted navigation to user page without user ID.'));
        return `/not-found`;
      }
    },
  },
  { path: "user/:userId", component: OtherComponent },
];
```
