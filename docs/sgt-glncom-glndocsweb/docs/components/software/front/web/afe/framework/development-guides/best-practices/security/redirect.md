# Best practices in redirect

When redirecting or forwarding a user to another URL, we must take care not to allow this URL to be manipulated via user input. This is known as an open redirect.

Unvalidated user input in the redirect can cause users to be able to control where they are redirected. This can be used by attackers to redirect users to malicious websites.

An example of open redirect malpractice is the use of user-provided parameters.
For example, a `redirectTo` parameter being passed through the application's URL that can be intercepted and changed at any time by the user and will redirect them to a specific URL:

``` TS
const params = new URLSearchParams(window.location.search);
const redirectUrl = params.get("redirectTo");

if (redirectUrl != null) {
    document.location.href = redirectUrl;
}else{
    document.location.href = "/";
}
```

This practice is dangerous as the user can change the value of the 'redirectTo' parameter and be redirected to any URL.

## How to avoid open redirect

To avoid open redirects, always validate user inputs(./sanitization.md) when used to compose redirect urls. If you need to redirect to an internal URL, choose to use the [Angular router](https://angular.io/api/router) module.

This prevents any redirects to external websites.

```ts
import { Router } from '@angular/router';

export class ExampleComponent {
  constructor(private router: Router) { }

  redirect() {
    const params = new URLSearchParams(window.location.search);
    const redirectUrl = params.get("redirectTo");

    if (redirectUrl != null) {
        this.router.navigate([redirectUrl]);
    } else {
        this.router.navigate(["/"]);
    }
  }
}
```

In the case of external redirects, always validate the URL before redirecting the user and create a whitelist of which URLs can be redirected.

```ts
const params = new URLSearchParams(window.location.search);
const redirectUrl = params.get("redirectTo");
const allowList = ["https://santander.com", "https://google.com/"];

if(redirectUrl != null && allowList.includes(redirectUrl)){
    document.location.href = redirectUrl;
}else{
    document.location.href = "/";
}
```
