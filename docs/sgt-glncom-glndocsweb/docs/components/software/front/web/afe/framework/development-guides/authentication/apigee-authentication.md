# Apigee Authentication

The process is carried out through the 'AuthenticationService' service of '@afe/authentication', which is responsible for initiating the flow and obtaining the access and refresh tokens.

| Token | Description |
| ------- | ---------- |
| ***access_token*** | is sent in requests to ***Apigee GHS***. |
| ***refresh_token*** | is used to generate a new ***access_token***. |

> Both tokens have an expiration time configured per application.

As mentioned in the previous steps, as much as encryption is optional, it ends up being a mandatory procedure for sensitive data traffic, so before performing the authentication.

We will start the cryptographic context first, and then request the authentication process.

File: app.component.ts

``` TS
import { Component, OnInit, OnDestroy } from "@angular/core";
import { AuthenticationService } from "@afe/authentication";
import { EncryptionService } from "@afe/encryption";
import { switchMap } from 'rxjs/operators';

@Component({ /* código omitido */ })
export class AppComponent implements OnInit, OnDestroy {

  public subscription: Subscription = new Subscription();

  constructor(
    private readonly encryptionService: EncryptionService,
    private readonly authenticationService: AuthenticationService) {}

  public ngOnInit(): void {
    this.subscription.add(
      this.encryptionService.changeKeys()
      .pipe(
        switchMap(() => this.authenticationService.authenticate())
      )
      .subscribe( /* implementação de sucesso e error omitidos */ )
    );
  }

  public ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
```
