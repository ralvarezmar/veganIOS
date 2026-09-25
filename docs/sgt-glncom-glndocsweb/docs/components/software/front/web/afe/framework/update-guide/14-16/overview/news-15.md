# What's new in Angular 15

## **_Standalone API_** is stable

Introduced in version 14 as _developer preview_, Standalone API is now fully integrated with other Angular packages such as `HttpClient`, `Angular Elements`, `Router` and more.

Therefore, this new API can be used safely in all projects.

> For more information, access the [official documentation on **Standalone API**](https://v15.angular.io/guide/standalone-components).

## Load child routes on demand in a hassle-free way

Loading child routes on demand has become much simpler with the implementation of the Standalone API!

It is now possible to load a list of routes on demand in a much simpler way, without the need to use `RouterModule.forChild`.

The codes below show how you can configure on-demand loading using Angular v15.

```ts
import { Routes } from '@angular/router';
import { LazyComponent } from './lazy.component';

export const lazyRoutes: Routes = [
   { path: '', component: LazyComponent }
];
```

```ts
import { Routes } from '@angular/router';

export const appRoutes: Routes = [{
   path: 'lazy',
   loadChildren: () => import('./lazy-routes').then(routes => routes.lazyRoutes)
}];
```

```ts
import { provideRouter } from '@angular/router';
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { appRoutes } from './routes';

bootstrapApplication(AppComponent, {
   providers: [
     provideRouter(appRoutes)
   ]
});
```

## **_Router_** and **_HttpClient_** with reduced size

Standalone API made it possible for the **_Router_** and **_Http_** packages to reduce the final size of the code generated in _build time_.

The improvement happens because, with the new implementation API, it is simpler and more efficient to remove codes that are not used by the project (in English, the expression `tree-shake` is used to reference this).

An **11%** decrease in final application size was recorded.

## **_Directive Composition API_**

Directive Composition API is a functionality added in this version of the framework, which allows for an exponential increase in code reuse in applications.

This functionality makes it possible to reuse directives in components and also other directives, creating a type of composition.

Composing visual elements is one of the main use cases for Directive Composition API.

The code below shows how to use this new functionality.

```ts
@Component({
   selector: 'mat-menu',
   hostDirectives: [
     HasColor,
     {
       directive: CdkMenu,
       inputs: ['cdkMenuDisabled: disabled'],
       outputs: ['cdkMenuClosed: closed']
     }
   ]
})
class MatMenu {}
```

> For more information, access the [official documentation on **Directive Composition API**](https://v15.angular.io/guide/directive-composition-api).

## Route storage in the form of a function

Angular v15 has simplified how **_Route Guards_** and **_Resolvers_** can be created.

The new approach allows them to be created using only functions, bringing much more agility and reducing the amount of code written.

The codes below show how a **_route guards_** and **_resolvers_** can be created.

```ts
const isLogginInGuard = () => inject(LoginService).isLoggedIn();

const route = {
   path: 'admin',
   canActivate: [
     isLogginInGuard
   ]
}
```

```ts
const heroResolver: ResolveFn<Hero> =
     (route: ActivatedRouteSnapshot, state: RouterStateSnapshot) => {
       return inject(HeroService).getHero(route.paramMap.get('id')!);
     };

const route = {
   path: 'admin',
   resolve: {
     hero: heroResolver
   },
}
```

## Support for **_default imports_** in on-demand loading

The on-demand loading (or **_lazy loading_**) functionality now supports **_default import_**.

This improvement brings more simplicity when importing components and routes, without the need to map them using the `.then(...)` instruction.

The code below shows how to use this functionality.

```ts
@Component({
   standalone: true,
   template: '...'
})
export default class LazyComponent { ... }
```

```ts
{
   path: 'lazy',
   loadComponent: () => import('./lazy.component'),
}
```
