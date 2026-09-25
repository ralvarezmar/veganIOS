# Good performance practices

## Use of Change Detection Strategy

Angular uses a mechanism called [Change Detection](https://angular.io/guide/change-detection) to **track changes** in the data and **update the user interface**.

By default, Angular scans all components in each change detection cycle, even if the component data hasn't changed. This can be costly to performance if your application has a lot of components.

To optimize this, you can change the change detection strategy to 'OnPush' on components that don't need to be checked all the time.

So Angular only checks the component when one of its data inputs changes, an event is triggered, or you manually request change detection.

To enable the 'OnPush' strategy, add the 'ChangeDetectionStrategy' decorator to the component:

``` TS
import { ChangeDetectionStrategy } from '@angular/core';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush
})

```

### Use of the Lazy Loading Technique

The [Lazy Loading](https://angular.io/guide/lazy-loading-ngmodules) technique allows feature modules to be loaded only when needed.

In practice, this means that Angular does not download the code of a module until the user navigates to the route that carries out its loading.

## Use `trackBy` with `*ngFor`

When we use '*ngFor' to display a list, Angular creates, updates, and destroys elements as needed.

If we provide a ***trackBy***, Angular will be able to track which items have been added or removed based on each item's unique identity. In this way, it will create or destroy only the necessary elements.

## Unsubscribe from observables

An observable channel through which data can be transmitted. When you subscribe to an observable, you receive a notification whenever a new value is issued.

If you don't unsubscribe, the observable will continue to issue values, even if you're no longer interested in them. This can cause memory leaks.

Unsubscribing from ***observable*** prevents memory leaks.

This can be done manually, at the moment when a component [is destroyed](https://angular.io/api/core/OnDestroy) by storing the reference of all observables and destroying them in the `ngOnDestroy` method.

``` TS
import { Component, OnDestroy } from '@angular/core';
import { Subscription, of } from 'rxjs';

@Component({
  selector: 'meu-componente',
  template: `<div>Meu Componente</div>`
})
export class MeuComponente implements OnDestroy {
  public subscriptions: Array<Subscription> = [];
  public anyObservable = of([1, 2, 3]);


  ngOnInit(): void {
    this.subscriptions.push(this.anyObservable.subscribe());
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription: Subscription) => subscription.unsubscribe());
  }
}
```

Or done more elegantly, using the ['takeUntil'](https://www.learnrxjs.io/learn-rxjs/operators/filtering/takeuntil) operator:

``` TS
import { OnDestroy } from '@angular/core';
import { takeUntil } from 'rxjs/operators';
import { Subject, of } from 'rxjs';

class DefaultComponent implements OnDestroy {
  private destroyRef = new Subject<void>();
  public observable$ = of([]);

  constructor() {
    this.observable$
      .pipe(
        takeUntil(this.destroyRef) // Cria um subject para desinscreve-se automaticamente quando o componente é destruído
      )
      .subscribe();
  }

  public ngOnDestroy() {
    this.destroyRef.next();
    this.destroyRef.complete();
  }
}
```

Starting with Angular 16, you can use the `takeUntilDestroyed` operator that simplifies unsubscribing observables. It is an alternative to `takeUntil` and `OnDestroy` that allows you to automatically unsubscribe without the need to implement `OnDestroy`.

``` TS
import { takeUntilDestroyed } from 'angular/core/rxjs-interop';
import { OnDestroy } from '@angular/core';
import { Subject, of } from 'rxjs';

class DefaultComponent {
  public observable$ = of([]);

  constructor() {
    this.observable$
      .pipe(
        takeUntilDestroyed()
      )
      .subscribe();
  }
}
```

We can also use the ['first'](https://rxjs.dev/api/operators/first) operator to automatically unsubscribe from an observable after the first issuance.

``` TS
import { Component, OnInit } from '@angular/core';
import { from } from 'rxjs';
import { first } from 'rxjs/operators';

@Component({
  selector: 'app-meu-componente',
  template: `<p>{{ value }}</p>`
})
export class DefaultComponent implements OnInit {
  value: number;

  ngOnInit() {
    const numbers = from([1, 2, 3, 4, 5]);

    numbers.pipe(first()).subscribe(val => this.value = val); // 1, pois irá se desinscrever após a primeira emissão
  }
}
```

## Use of ***shareReplay*** for data sharing between multiple subscribers

The ***shareReplay*** operator allows multiple subscribers from an ***observable*** to share their same value update, avoiding the need to create separate subscriptions for each registrant.

``` TS
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { shareReplay } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private data$;

  constructor(private http: HttpClient) {
     this.data$ = this.http.get('https://api.meusite.com/data')
     .pipe(
      shareReplay(1)
    );

    this.logData();
  }

  public logData() {
    this.data$.subscribe(data => console.log('Subscriber 1:', data)); // Faz uma solicitação HTTP
    this.data$.subscribe(data => console.log('Subscriber 2:', data)); // Utiliza o valor emitido pelo primeiro inscrito e não faz uma nova solicitação HTTP
  }
}
```

With `shareReplay`, the HTTP request is made only once, regardless of the number of subscribers. The value emitted by Observable is shared among all subscribers, improving performance.
