# What's new in Angular 9

## Ivy

The biggest new feature in this release is Ivy, codenamed for Angular's next-generation build and render pipeline.

With the release of the Angular 9, the new engine is used as standard instead of the older one known as the View Engine, and it has brought numerous advantages, including:

- Smaller bundles;
- Faster tests;
- Better debug
- Improved performance
- Improvements in CSS styles;
- Better typing verification;
- Improved compilation errors;
- Shorter build times;
- Better internationalization;

### Ivy and AOT

**Ivy** sets the build to ***AOT***.

```json
{
  "projects": {
    "example-project": {
      "architect": {
        "build": {
          "options": {
            "aot": true,
          }
        }
      }
    }
  }
}
```

> If you are using Ivy, internationalization also needs to set up AOT.

### Ivy & Libraries

Ivy can be ***built*** with libraries that use the ***View Engine*** compiler, for this you just need to run ***ngcc*** after installing the libraries:

```json
{
  "scripts": {
    "postinstall": "ngcc"
  }
}
```

You should still use ***View Engine*** for library publishing, so using ***ngcc***, compatibility with both ***View Engine*** and ***Ivy***. Both the Angular CLI and the Angular CLI still use the View Engine.

> For more information, visit [how to create a library](https://angular.io/guide/creating-libraries).

### Ivy and Universal / Ivy and App Shell

The ***bundleDependencies*** setting is now active by default. If there is a need to deactivate, you should run ***ngcc*** after each installation of the library, otherwise ***node*** will not be able to resolve the libraries with ***Ivy***.

> Do not use the ***flag*** '--create-ivy-entry-points' together with [***Angular Universal***](https://angular.io/guide/universal) or [***App Shell***](https://angular.io/guide/app-shell).

### Debugging Code with Ivy

The new Angular engine now has its own tools for [***debugging***](https://angular.io/guide/ivy-compatibility#debugging)

## ***TypeScript*** support in version 3.7

Version 9 now supports version **3.7** of ***typescript***. ## ***Injectable*** has new ***providedIn*** options When using the ***@Injectable*** decorator in a service, you can declare where it should be added in the dependency injector.

In addition to root, there are now two more new options:

- ***platform***: Declaring ***providedIn: 'platform'*** makes the service single for all applications on the page.
- ***any***: Provides a unique instance in each module, including lazy Loading modules.

> To learn more about provideIn, visit the official documentation on [***Injectable***](https://angular.io/api/core/Injectable)

## ***ViewChild*** defaults to ***static option***

ViewChild now uses the static: false option by default, and there is no longer a need to explicitly declare.

## ***Component harnesses***

[***Component harnesses***] (<https://material.angular.io/guide/using-component-harnesses>) is a class that allows a test to interact with a component through an API, interacting in exactly the same way as a user would.

```javascript
it("should switch to bug report template", async () => {
    expect(fixture.debugElement.query("bug-report-form")).toBeNull();
    const select = await loader.getHarness(MatSelect);
    await select.clickOptions({ text: "Bug" });
    expect(fixture.debugElement.query("bug-report-form")).not.toBeNull();
});
```

## New ***API*** Components

The [Youtube](https://github.com/angular/components/tree/master/src/youtube-player) components have been introduced in the ***@angular/youtube-player*** package and [Google Maps](https://github.com/angular/components/tree/master/src/google-maps).
