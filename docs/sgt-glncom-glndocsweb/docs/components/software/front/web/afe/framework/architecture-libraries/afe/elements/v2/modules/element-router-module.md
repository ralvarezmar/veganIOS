# Element Router Module

The module has the functionality to adapt the routing part ***@angular/router*** so that it does not change the url of the browser during navigation, thus making it compatible with Angular Element.

## How it works

Its operation is very simple, when adding the module, the library changes the navigate and ***navigateByUrl*** methods of the Angular ***Router*** service so that the skipLocationChange parameter is always ***true***, not changing the url during navigation.

## Prerequisites

- Installation and configuration of [@afe/elements](../index.md)

## Configuration

For use, simply import the asset into the main module of Angular Element. With the import done, call the ***forRoot()*** method of the ***ElementRouterModule*** module declaring it in the ***imports*** property, as shown in the example below:

``` TS
//app.module.ts
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { ElementRouterModule } from '@afe/elements';
import { AppComponent } from './app.component';
import { TestComponent } from './test/test.component';

const routes: Routes = [
    { path: 'teste', component: TestComponent }
];

@NgModule({
    declarations: [ AppComponent, TestComponent ],
    imports: [
        RouterModule.forRoot(routes),
        ElementRouterModule.forRoot(), // importa o módulo ElementRouterModule
    ],
    exports: [ AppComponent ],
    bootstrap: [ AppComponent ],
})
export class AppModule { }
```

> For more information, access our documentation about [Angular Elements Routing](../../../../../development-guides/mfe/angular-elements/routing.md)
