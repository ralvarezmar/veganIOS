# How to Set Up Routes Inside an Angular Element

Routing within an Angular Element works very similarly to routing in a conventional Angular application.

The big difference is that, by using the Front-End Architecture's ***ElementRouterModule*** module, the routing will not change the browser's URL, preventing conflicts from happening with the Angular application that is loading it.

## Prerequisites

- Install the [@afe/elements](../../../architecture-libraries/afe/elements/index.md) in the Angular Element project.
- Configure the [ElementRouterModule](../../../architecture-libraries/afe/elements/v2/modules/element-router-module.md) in the main Angular Element module.

## Using Routing in an Angular Element

Routing within Angular Element can be done in the same way as in a conventional Angular application. The only difference is that the browser's URL won't change.

To do this, simply use the ***@angular/router*** module and configure the application routes.

``` TS
//app-routing.module.ts
const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    componente: HomeComponent,
  },
  {
    path: 'outra-pagina',
    pathMatch: 'full',
    component: OutraPaginaComponent,
  }
];

@NgModule({
  ...
  imports: [
    RouterModule.forRoot(routes),
  ],
})
export class MeuMFEModule {
  ...
}
```

Once you've set up your routes, you can navigate from one route to another using Angular's Router service.

``` TS
//home.component.ts
import { Router } from '@angular/router';

@Component({
  ...
})
export class HomeComponent {
  constructor(private router: Router) {}

  navegarParaOutraPagina() {
    this.router.navigate(['outra-pagina']);
  }
}
```

Or through ***routerLink*** directive.

``` HTML
<!-- home.component.html -->
<a [routerLink]="['outra-pagina']">Navegar para outra página</a>
```

This way, the routing within the Angular Element will work normally, without changing the browser's URL.

In applications that use the '@afe/elements' library in ***version 1***, it is necessary to perform the initial navigation of the Angular Element so that the routes within it are accessed correctly.

Whereas there are the following routes below:

``` TS
//app-routing.module.ts
  const routes: Routes = [
    {
      path: '',
      pathMatch: 'full',
      componente: HomeComponent,
    },
    {
      path: 'outra-pagina',
      pathMatch: 'full',
      component: OutraPaginaComponent,
    }
  ];
  ```

For an initial navigation to be performed, you need to use Angular's Router service to navigate to a specific route.

``` TS
//app.component.ts
  this.router.navigate(['']); // navega para a página inicial
```

The above code can be placed in the main component of the Angular Element, or in any other component that is initially loaded.

## Avoiding the lazy loading strategy

Since an Angular Element is loaded using only one file (`bundle.js`), all components and routes will be loaded at once.

Therefore, it is important not to use lazy loading routes.

All routes within the Angular Element should be loaded directly!

``` TS
//app-routing.module.ts
const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    componente: HomeComponent // loading component directly
  },
   {
    path: 'outra-pagina',
    pathMatch: 'full',
    component: OutraPaginaComponent // loading component directly
  }
  ...
];
```
