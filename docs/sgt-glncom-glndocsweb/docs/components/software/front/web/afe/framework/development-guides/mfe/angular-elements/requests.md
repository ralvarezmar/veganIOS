# How to make HTTP requests with Angular Elements

Most of today's MFE applications developed with elements are embedded by another application, commonly known as ***base*** or **shell**.

This base is responsible for performing crucial operations such as [authentication](../../authentication/index.md) within a channel.

This tutorial aims to instruct you on how to configure your Angular Element project to make HTTP requests through the Angular used by the channel base.

## Prerequisites

The base application, which will load the element (MFE), must have installed at least one version **equal** or **higher** than ***1.3.0*** of ***@afe/authentication*** and ***1.6.1*** of ***@afe/event-handler***.

In addition to having performed some guided process in the [authentication session](https://afe.paas.santanderbr.pre.corp/docs/angular/guias/autenticacao) for the ability to communicate with the service HUB, which can be legacy (ZUP) or reference (APIGEE).

## Configuration

Both the element*** and the base** will need to install the most current version of the authentication library and the front-end architecture event piece:

```bash
npm install @afe/authentication@^2 @afe/event-handler@^1.6.1 --save
```

### Base

To be able to onboard Angular Element modules (MFEs) to the Inherited standard, the Channel Base module must:

- Follow the prerequisites mentioned in this documentation
- Configure authentication according to the guides available at: <https://afe.paas.santanderbr.pre.corp/docs/angular/guias/autenticacao>

### Element

Import the ***InheritedAuthenticationModule*** into your project, and via the ***forRoot*** method pass a configuration object containing the ***enableExperimentalEvents*** key as ***true*** (still in **experimental phase**).

``` TS
import { InheritedAuthenticationModule } from '@afe/authentication/inherited';

@NgModule({
  imports: [
    InheritedAuthenticationModule.forRoot({
      enableExperimentalEvents: true
    }),
  ],
})
export class ElementExampleModule { }
```

> If your project has any library compatibility issues with the Angular compiler at development time or in the repository compilation process, please refer to the following documentation:

[How to resolve the issue: the library is expected to be compatible with Ivy](https://afe.paas.santanderbr.pre.corp/docs/angular/base-de-conhecimento/dependencias/compatibility-with-ivy)

### Implementation

All you have to do is implement the desired request by Angular's own HttpClient.

``` TS
//example.component.ts
import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { Subscription } from 'rxjs';
import { take } from 'rxjs/operators';

@Component({
  // código omitido
})
export class ExampleComponent implements OnDestroy {

  public subscription$ = new Subscription();

  constructor(private readonly httpClient: HttpClient) {}

  public doRequest(): void {
    // Neste exemplo foi utilizado o método `get`,
    // mas qualquer outro método também serviria
    this.subscription$.add(
      this.httpClient
        .get('<your-url-to-request>')
        .pipe(take(1))
        .subscribe()
    );
  }

  public ngOnDestroy() {
    this.subscription$.unsubscribe();
  }
}
```

With that, now just make your request normally and be happy!

> **❗ Attention:**
>
> In this last example we use the **[take](https://www.learnrxjs.io/learn-rxjs/operators/filtering/take)** operator of **rxjs** so that, as soon as the data is returned.
> We can complete the request made, for more details, see ["Good coding practices"](https://afe.paas.santanderbr.pre.corp/docs/angular/guias/boas-praticas/desenvolvimento/codificacao#desinscrever-se-dos-observables).
> And the ***[Subscription](https://rxjs.dev/guide/subscription)*** has been added so that calls to asynchronous methods are **centralized** and can be **dropped** as soon as the component is destroyed via [lifecycle hook](https://angular.io/guide/lifecycle-hooks)
>
> 🚀 Both strategies increase the scalability and performance of the application!
