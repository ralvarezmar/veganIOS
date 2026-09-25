# Refreshing the Session Token Manually

As seen in the previous step ([refresh policy](./refresh-policy.md)), there is an automatic refresh of the session token performed by the library.

However, if necessary, the application can force this process by executing the ***refresh()*** method of the ***AuthenticationService*** service as shown in the example below:

File: example.component.ts

``` TS
import { Component } from "@angular/core";
import { AuthenticationService } from "@afe/authentication";

@Component({ /* hidden code */ })
export class AppComponent implements OnInit, OnDestroy {

  public subscription: Subscription = new Subscription();

  constructor(
    private readonly authenticationService: AuthenticationService,
  ) {}

  public callRefreshToken(): void {
    this.subscription.add(
      this.authenticationService.refresh()
          .subscribe( /* hidden code */ )
    );
  }

  public ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
```
