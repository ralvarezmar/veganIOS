# What's new in Angular 16

## **_Signals_**

Added in this version of Angular as _Developer Preview_, **_Signals_** brings a huge improvement to how changes within the framework are detected.

This new functionality, very similar to those that already exist in other technologies, allows the reactivity in components and directives to be completely restructured.

New ways of controlling data flows have been created, simplifying how code is written in applications.

Below is an example of how to use **_Signals_** in a component.

```ts
@Component({
   selector: 'my-app',
   standalone: true,
   template: `
     {{ fullName() }} <button (click)="setName('John')">Click</button>
   `,
})
export class App {
   firstName = signal('Jane');
   lastName = signal('Donate');
   fullName = computed(() => `${this.firstName()} ${this.lastName()}`);

   constructor() {
     effect(() => console.log('Name changed:', this.fullName()));
   }

   setName(newName: string) {
     this.firstName.set(newName);
   }
}
```

> For more information, visit [official documentation on **Signals**](https://v16.angular.io/guide/signals).

## Integration between **_RxJS_** and **_Signals_**

Two new functions that seek to improve the integration between **_RxJS_** and **_Signals_** have been added to Angular.

Through the `@angular/core/rxjs-interop` package, you can use the _**toObservable**_ and _**toSignal**_ functions.

### **_toObservable_** function

Converts a **_Signal_** to a **_Observable_**, facilitating migration between synchronous and asynchronous data streams.

```ts
import { toObservable } from '@angular/core/rxjs-interop';

@Component({...})
export class App {
   count = signal(0);
   count$ = toObservable(this.count);

   ngOnInit() {
     this.count$.subscribe(() => ...);
   }
}
```

### **_toSignal_** function

Converts a **_Observable_** to **_Signal_**, facilitating migration between asynchronous to synchronous data flows.

```ts
import { toSignal } from '@angular/core/rxjs-interop';

@Component({
   template: `
     <li *ngFor="let row of data()"> {{ row }} </li>
   `
})
export class App {
   dataService = inject(DataService);
   data = toSignal(this.dataService.data$, []);
}
```

## New operator **_takeUntilDestroyed_**

Allows you to destroy a **_Subscription_** automatically.

This new **_RxJS_** operator integrates seamlessly with component and directive lifecycles through the recently added [_**DestroyRef**_](https://angular.io/api/core/DestroyRef) class to the framework.

```ts
import { takeUntilDestroyed } from "@angular/core/rxjs-interop";

@Component({
   ...
})
export class MyComponent {
   data$ = http.get('…')
     .pipe(
       takeUntilDestroyed()
     );
}
```

> For more information, access the [official documentation about the **takeUntilDestroyed** operator](https://v16.angular.io/api/core/rxjs-interop/takeUntilDestroyed).

## **_Server-side rendering_** and **_Non-Destructive Hydration_**

**_Server-side rendering_**, or **_SSR_**, brings many improvements to SEO (Search Engine Optimization), file loading time and user experience.

Until then, Angular, when used with **_SSR_**, used a technique called **Destructive Hydration**, which basically destroys all elements already rendered on the server and recreates them in the browser again.

This technique causes performance problems and worsens the experience of using the application.

Angular v16 supports the technique called **_Non-Destructive Hydration_**, which allows you to reuse elements already rendered on the server. This technique brings a huge improvement to how the **_SSR_** application is rendered in the browser.

Below is an example of how to enable this functionality.

```ts
import {
   bootstrapApplication,
   provideClientHydration,
} from '@angular/platform-browser';

bootstrapApplication(RootCmp, {
   providers: [
     provideClientHydration()
   ]
});
```

> For more information, visit [official documentation on **Hydration**.](https://v16.angular.io/guide/hydration)

## Automated migration to Standalone API

A new [_**schematics**_](https://v16.angular.io/guide/schematics) has been made available to simplify the process of migrating applications based on:

[_**NgModules**_](https: //v16.angular.io/guide/ngmodules) for the new [_**Standalone API**_](https://v16.angular.io/guide/standalone-components).

The code below shows how to execute the command.

```bash
ng generate @angular/core:standalone
```

> For more information, visit [official documentation on **migration to the Standalone API**.](https://v16.angular.io/guide/standalone-migration)

## Creation of a project that uses **_Standalone API_**

A new flag has been added to the [_**ng new**_](https://v16.angular.io/cli/new) command, called _**standalone**_.

The code below shows how to execute the command.

```bash
ng new --standalone
```

## Support for **_esbuild_** and **_Vite_**

Support for [_**esbuild**_](https://esbuild.github.io/) and [_**Vite**_](https://esbuild.github.io/) allows you to benefit from a faster development server and up to 100x more efficient builds.

Note that **_Vite_** can only be used as a development server.

**_esbuild_** is available for development and production builds!

To use **_esbuild_** and **_Vite_** in your project, just define the _builder_ in the `angular.json` file as follows:

```json
{
   "architect": {
     "build": {
       "builder": "@angular-devkit/build-angular:browser-esbuild",
     }
   }
}
```

## Support for **_Jest_**

Angular added support for [_**Jest**_](https://jestjs.io/pt-BR/) as a testing library.

This approach brings more modernity and speed when testing projects.

To use Jest in your project, install it as a dependency using the command `npm install jest --save-dev` and change the `angular.json` file as follows:

```json
{
   "projects": {
     "my-app": {
       "architect": {
         "test": {
           "builder": "@angular-devkit/build-angular:jest",
           "options": {
             "tsConfig": "tsconfig.spec.json",
             "polyfills": ["zone.js", "zone.js/testing"]
           }
         }
       }
     }
   }
}
```

## **_Inputs_** mandatory

After several requests from the community, Angular added support for mandatory [Inputs](https://v16.angular.io/api/core/Input) in components and directives!

```ts
@Component(...)
export class App {
   @Input({ required: true }) title: string = '';
}
```

## Use routing data in **_Inputs_** of components

This functionality allows you to send routing data, such as **_resolvers_** and parameters, directly to **_Inputs_** of components. The idea is to bring more agility when manipulating data within components that are rendered via routing.

```ts
const routes = [
   {
     path: 'about',
     loadComponent: import('./about'),
     resolve: { contact: () => getContact() }
   }
];

@Component(...)
export class About {
   // the "contact" value, created by the resolver, will be assigned to the Input.
   @Input() contact?: string;
}
```

To enable this functionality, use the function [_**withComponentInputBinding**_](https://v16.angular.io/api/router/withComponentInputBinding) as follows:

```ts
const appRoutes: Routes = [...];

bootstrapApplication(AppComponent,
   {
     providers: [
       provideRouter(appRoutes, withComponentInputBinding())
     ]
   }
);
```

## More flexibility with **_DestroyRef_**

[_**DestroyRef**_](https://angular.io/api/core/DestroyRef) allows greater control and flexibility to perform actions when a component or directive is destroyed.

```ts
@Component(...)
class MyComponent {

   destroyRef = inject(DestroyRef);

   ngOnInit() {
     destroyRef.onDestroy(() => {
       ...
     });
   }
}
```

## Self-closing tags

This functionality, common in other technologies, was added to Angular v16 as an improvement to the component development experience.

**_Self-closing tags_** allows a component's _tag_ to be closed without the need for a specific _tag_ to do so. The [**input**](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/Input) element of HTML is an example of a **Self-closing tag** .

No extra configuration needs to be done, as this functionality is enabled by default.

```ts
<super-duper-long-component-name [prop]="someVar"/>
```
