# Best practices in protecting against XSRF Attacks

The Cross-Site Request Forgery (XSRF) attack happens when an attacker **manipulates** an authenticated user on a website to perform unauthorized actions, such as changing the password, deleting an account, or making a bank transfer.

This attack is possible because the browser automatically includes session cookies in HTTP requests, allowing the request to be sent with the authenticated user's credentials.

Thus, the attacker is able to perform actions on behalf of the user without their consent.

To protect your Angular application from XSRF attacks, you can use the HttpClientXsrfModule that provides protection against cross-site request forgery (XSRF) attacks by adding an XSRF token to each HTTP request.

That changes the server state and verifies that a valid token is sent with the request.

To use the HttpClientXsrfModule, you need to import it into the main module of the project:

```typescript
import { HttpClientModule, HttpClientXsrfModule } from '@angular/common/http';

@NgModule({
  imports: [
    HttpClientModule,
    HttpClientXsrfModule.withOptions({
      cookieName: 'xsrf-cookie',
      headerName: 'xsrf-header',
    }),
  ],
})
export class AppModule { }
```

In this example, the ***HttpClientXsrfModule*** is configured to read the XSRF token of the cookie named 'xsrf-cookie' and add the token to the HTTP request using the `xsrf-header` header.

This way, when the server receives a request, it will verify that the XSRF token in the request header matches the XSRF token that was issued to the user.

If the tokens match, the server knows that the request is legitimate and processes it. If the tokens don't match, or if the token is missing, the server rejects the request.

This way, even if an attacker manages to trick a user into making a malicious request, the attacker will not have access to the user's XSRF token and the **malicious request will be rejected by the server.**

## How to Prevent XSRF Attacks

While the HttpClientXsrfModule provides a layer of protection against XSRF attacks, it is important to implement other security measures, such as [user input sanitization](./sanitization.md) and enforcement of [content security policies](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/CSP).
