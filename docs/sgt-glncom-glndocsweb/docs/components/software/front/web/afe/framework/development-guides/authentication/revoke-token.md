# Closing of session ***Apigee***

To log out, you can run the ***revoke()***, thus logging out of the application. In this method it invalidates the ***refresh_token*** and deletes the tokens from ***SessionStorage***, thus causing a **401** error if another call to Apigee is made.

Here's the example of the implementation:

File: example.component.ts

``` TS
import { Component, OnDestroy } from "@angular/core";
import { AuthenticationService } from "@afe/authentication";

@Component({ /* código omitido */ })
export class AppComponent implements OnInit, OnDestroy {

  public subscription: Subscription = new Subscription();

  constructor(
    private readonly authenticationService: AuthenticationService,
  ) {}

  public ngOnDestroy(): void {
    this.subscription.add(
      this.authenticationService.revoke()
          .subscribe( /* código omitido */ )
    );
    this.subscription.unsubscribe();
  }

  public ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
```
