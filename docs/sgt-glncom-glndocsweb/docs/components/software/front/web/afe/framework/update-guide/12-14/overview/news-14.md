# What's new in Angular 14

## Standalone Components

[Standalone components](https://v14.angular.io/guide/standalone-components) is a new feature that allows:

- [components](https://v14.angular.io/api/core/Component)
- [directives](https://v14.angular.io/api/core/Directive)
- [pipes](https://v14.angular.io/api/core/Pipe)

That can be used directly without the need for [NgModules]( https://v14.angular.io/api/core/NgModule).

This functionality can be enabled using the `standalone: true` flag in the class decorator.

```ts
@Component({
   standalone: true,
   selector: 'my-component',
   template: `...`,
})
export class MyComponent { }
```

The big improvement that [Standalone components](https://v14.angular.io/guide/standalone-components) brings is the possibility of importing other standalone components directly, without having to use [NgModules](https://v14.angular.io/api/core/NgModule).

The code below shows how to import these resources directly:

```ts
@Component({
   standalone: true,
   selector: 'other-component',
   template: `<h1>Other Component</h1>`,
})
export class OtherComponent { }

@Component({
   standalone: true,
   selector: 'my-component',
   imports: [OtherComponent],
   template: `<other-component></other-component>`,
})
export class MyComponent { }
```

It is also possible to use [directives](https://v14.angular.io/api/core/Directive) and [pipes](https://v14.angular.io/api/core/Pipe) directly, but the same need to be marked as `standalone: true`.

The code below shows how to use them in a [component](https://v14.angular.io/api/core/Component):

```ts
@Directive({
   standalone: true,
   selector: 'my-directive',
})
class MyDirective {}

@Pipe({
   standalone: true,
   name: 'myPipe'
})
class MyPipe implements PipeTransform {
    transform(value: string) { }
}

@Component({
   standalone: true,
   selector: 'my-component',
   imports: [MyDirective, MyPipe],
   template: `
     <div my-directive></div>
     <div>{{ 'some value' | myPipe }}
   `,
})
export class MyComponent { }
```

Important to note that you can also import [NgModules](https://v14.angular.io/api/core/NgModule) directly into [Standalone components](https://v14.angular.io/guide/standalone-components) .

The code below shows how to do this:

```ts
@Directive({
   selector: 'my-directive',
})
class ItIsNotAStandaloneDirective {}

@NgModule({
   declarations: [ItIsNotAStandaloneDirective]
   exports: [ItIsNotAStandaloneDirective],
   imports: [...],
})
export class MyModule { }

@Component({
   standalone: true,
   selector: 'my-component',
   imports: [MyModule],
   template: `
     <div my-directive></div>
   `,
})
export class MyComponent { }
```

This way, libraries and projects can _gradually_ migrate to this new way of using components.

Reducing the use of [NgModules](https://v14.angular.io/api/core/NgModule) will make it easier to model applications and also shorten the Angular learning curve.

> For more information, access [official documentation on standalone components](https://v14.angular.io/guide/standalone-components).

## Set page title via Angular Router

In version v14 it is possible to define the page title directly through the application routes.

The `title` property has been added to the [Routes](https://v14.angular.io/api/router/Route) class, and can be used as follows:

```ts
const routes: Routes = [
   {
     path: 'home',
     title: 'My App - Home', // defines the page title
     component: HomeComponent,
   },
];
```

If a more customized approach is required, or with greater reusability, it is possible to define how the title will be defined on the page through the [TitleStrategy](https://v14.angular.io/api/router/TitleStrategy) class.

```ts
@Injectable({providedIn: 'root'})
export class MyPageTitleStrategy extends TitleStrategy {

  constructor(private readonly title: Title) {
    super();
  }

  override updateTitle(routerState: RouterStateSnapshot) {
    const title = this.buildTitle(routerState);

    if (title !== undefined) {
      this.title.setTitle(`My Amazing App | ${title}`); // Define um título padronizado
    }
  }
}

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [
    { provide: TitleStrategy, useClass: MyPageTitleStrategy }, // Sobrescreve a estratégia padrão
  ]
})
export class AppRoutingModule {
}
```

> For more information, access the [official documentation on setting the page title](https://v14.angular.io/guide/router#setting-the-page-title).

## Improved error detection

Added improvements to **detection of problems in component templates** through the internal functionality [extended diagnostics](https://v14.angular.io/extended-diagnostics).

Used in the `ng build` and `ng serve commands` and also in [Angular Language Service](https://marketplace.visualstudio.com/items?itemName=Angular.ng-template).

The following issues have received improvements.

### Banana in a box

This version added improvements to warning messages when the _Banana in a box_ syntax is misspelled.

```ts
<input type="text" ([ngModel])="name">
```

> _Banana in a box_, or, in Portuguese, _Banana entre um caso_, is represented by the syntax `[()]`. Useful for working with _two-way data binding_ in Angular templates.

If this problem is identified, the message below will appear.

```bash
Warning: src/app/app.component.ts:7:25 - warning NG8101: In the two-way binding syntax the parentheses should be inside the brackets, e.g. '[(fruit)]="favoriteFruit"'.
         Find more at https://v14.angular.io/guide/two-way-binding
      <app-favorite-fruit ([fruit])="favoriteFruit"></app-favorite-fruit>
```

> For more information visit [official documentation](https://v14.angular.io/extended-diagnostics/NG8101)

### Unnecessary use of the nullish operator

When the **nullish** operator is used on a value that will never be `null` or `undefined`, a warning message will be shown.

```ts
@Component({
   template: `{{ name ?? 'John' }}`
})
class MyComponent {
   name = 'Robert';
}
```

The code above will show the following warning message:

```bash
Warning: src/app/app.component.ts:23:8 - warning NG8102: The left side of this nullish coalescing operation does not include 'null' or 'undefined' in its type, therefore the '??' operator can be safely removed.
```

## Tree-shakeable error messages

Error messages will be removed from the **production bundle**. Only error codes will be shown when an error occurs.

```ts
@Component({...})
class MyComponent {}

@Directive({...})
class MyDirective extends MyComponent {} // Throws an error

// How the error will appear in production:
> NG0903

// in development mode, the error will appear as:
> NG0903: Directives cannot inherit Components. Directive MyDirective is attempting to extend component MyComponent.
```

This change makes the bundle smaller, bringing faster application loading speed.

> For more information, visit [official documentation on improving error messages](https://v14.angular.io/extended-diagnostics/NG8101).

## Support for Typescript 4.7 and ES2020

Angular v14 added support for [TypeScript v4.7](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html) and will by default use:

[ES2020](https: //www.freecodecamp.org/portuguese/news/10-novos-recursos-do-es2020-para-o-javascript-que-voce-precisa-conhecimentor/) as the target version of JavaScript.

This improvement allows applications to be _lighter_, as there will be no need to generate JavaScript compatible with older browsers.

## Improvements in Angular CLI

### `ng completion`

Command that suggests the correct command when it was written wrong.

> **Attention!**
>
> This command is only compatible with Bash.
>
> For more information, access the [official documentation on the **ng completion** command](https://v14.angular.io/cli/completion).

### `ng cache`

Command that allows manipulation of the cache generated by the Angular CLI, providing more control over the data used to build the project.

With the command you can:

- enable and disable
- delete cache
- show information and statistics

> For more information, access the [official documentation on the ng cache command](https://v14.angular.io/cli/cache).
