# Good Coding Practices

During the development of a project, we must always make the right decisions aiming at the scalability, maintainability and performance of our applications. Here we've rounded up some of the best practices for the architecture:

## Unsubscribe from ***Observables***

When using reactivity in our Angular project, especially when subscribing to some data that will be updated, we must always make sure that unsubscribing will be done when the data is no longer needed for the application.

This can be done by creating a [Subscription](https://rxjs.dev/guide/subscription), which through the '.add()' method, stores the execution of ***Observable*** that will have its value modified.

Through this, we can call the '.unsubscribe()' method on the component's [***OnDestroy***](https://angular.io/api/core/OnDestroy), so that the ***Observables*** are removed at the time of component destruction.

``` TS
import { Component, OnInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { HttpClient } from '@angular/http';

@Component({
  // hidden code
})
export class ExampleComponent implements OnInit, OnDestroy {
  public subscription$: Subscription = new Subscription();

  constructor(private readonly http: HttpClient) { }

  public ngOnInit(): void {
    this.subscription$.add(
      this.http.get('/hub-url/resource/id/1').subscribe()
    )
  }

  public ngOnDestroy() {
    this.subscription$.unsubscribe();
  }
}
```
