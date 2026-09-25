# **APIs** Consume

After completing the [Apigee Authentication](./apigee-authentication.md) step we can now consume the new ***APIs*** that are in ***Apigee GHS***. To do this, we just need to use the ***HttpClient*** from ***@angular/common/http***.

As shown in the following example:

> The interceptor used internally by the @afe/authentication will add the authentication header to the calls from the URLs or hosts configured with the part module.

File: app.service.ts

``` TS
import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

@Injectable({ providedIn: "root" })
export class AppService {
  constructor(private readonly httpClient: HttpClient) {}

  public yourMethodThatWillMakeTheRequest(): Observable<unknown> {
    return this.httpClient.get('<YOUR_API_URL_FOR_CONSUMPTION>');
  }
}
```

> ❗ **Notes**
>
> The variable `<YOUR_API_URL_FOR_CONSUMPTION>` must be replaced by the resource endpoint published in the Services HUB.
> Which application you want to consume and has requested consumption permission with the [Technical Arch - Integration and Streaming](https://confluence.santanderbr.corp/display/PADROESARQINT/CoE+Arquitetura) team.
