# Configurations

After the [prerequisites](./pre-reqs.md) step, let's move on to the required settings.

If it doesn't exist, create the ***config*** folder in the project. Inside it, create the ***oauth2-authentication.config.ts*** file and export a constant of type ***OAuth2AuthenticationConfig***, which belongs to the sub-library ***@afe/authentication/oauth2***.

Below is an example of this configuration file(config/oauth2-authentication.config.ts):

``` TS
import { OAuth2AuthenticationConfig } from "@afe/authentication/oauth2";

export const authenticationConfig: OAuth2AuthenticationConfig = {
    idleTimeout: true,
    appKey: `<YOUR_APP_KEY>`,
    clientId: `<YOUR_CLIENT_ID>`,
    systemCode: '<YOUR_SYSTEM_CODE>',
    clientSecret: `<YOUR_CLIENT_SECRET>`,
    redirectUri: `<REDIRECT_URI_AFTER_LOGIN>`,
    urlsToIntercept: [ '<APIGEE_GATEWAY_URL>' ],
    urlLogin: '/<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/token',
    urlLogout: '/<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/logout',
    authorizeUrl: '/<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/authorize',
};
```

> ❗ **Notes**
>
> The ***<...>*** variables used must be replaced with the respective values of your project:
>
> `<YOUR_APP_KEY>`: app-key (client-id) of your application in ***Apigee GHS***
>
> `<YOUR_CLIENT_ID>`: app-key (client-id) of your application in ***Apigee GHS***
>
> `<YOUR_SYSTEM_CODE>`: System acronym of your application in ***Apigee GHS***
>
> `<YOUR_CLIENT_SECRET>`: client-secret of your application in ***Apigee GHS***
>
> ***Notes***: the value changes according with the environment (DEV, PRE, PRD).
>
> `<OAUTH_API_VERSION>`: API version of OAuth product who must access.
>
> `<APIGEE_GATEWAY_ALIAS>`: alias (usually configured as ***/apigee-url***) to point to the gateway endpoint in Apigee.
>
> `<REDIRECT_URI_AFTER_LOGIN>`: endpoint registered in the RHSSO for redirection to the application that requested authentication.
> This capability provides the possibility of redirecting to a page (component) in order to display some need before the login screen is closed.
>
> ***Note***: at the moment, this ability will not be noticeable and needs evolution, because as soon as the redirect occurs and the application initializes, the part module is waiting through the ***APP_INITIALIZER*** to proceed with the flow.
>
>
> ***Notes***
>
> Check more details of the ***idleTimeout*** property in the "[Session Update Policy](./../refresh-policy.md)".
> In addition to the mandatory configuration properties mentioned above, there are other optional properties that can be configured as needed by the project, for example:

File: config/oauth2-authentication.config.ts

``` TS
import { OAuth2AuthenticationConfig } from "@afe/authentication/oauth2";
import { EncryptionService } from "@afe/encryption";

export const authenticationConfig: OAuth2AuthenticationConfig = {
    //  ...
    urlsToIgnore: [ `<YOUR_PART_OF_URL_TO_IGNORE>` ],
    windowOpenFeatures: { `<YOUR_CUSTOM_WINDOW_OPENED>` }
    queryParamsResolver: `<YOUR_SERVICE_TO_CUSTOM_PARAMS>`,
    encryptionResolver: EncryptionService, // Or `<YOUR_SERVICE_TO_ENCRYPTION_RESOLVER>`
};
```

> ❗ **Notes**
>
> ***encryptionResolver***: receives a service responsible for providing the encryption ticket of the initialized cryptographic context, for this, just pass the ***EncryptionService*** of ***@afe/encryption***.
>
> If the project has a different crypto flow, it is possible to provide its own service <YOUR_SERVICE_TO_ENCRYPTION_RESOLVER>'' capable of solving the ticket (following some established premises).
>
> ***Notes**: Since the project will use cryptography, this field is now mandatory, as it will be necessary to link the ticket from the cryptographic context to the authentication flow*.
>
> ***urlsToIgnore***: Receives snippets of urls that **should not** be contemplated for adding the access token to communicate with the gateway. Replace '<YOUR_PART_OF_URL_TO_IGNORE>' with the urls you want to ignore.
>
> ***windowOpenFeatures***: receives an object allowing customization of the window that will open and load the RH-SSO login screen. Replace '<YOUR_CUSTOM_WINDOW_OPENED>' with the properties available on the object.
>
> ***queryParamsResolver***: receives a service responsible for providing customized parameters in the authorization flow to obtain the access code before authentication in Apigee happens.
>
> The service will provide an object with the desired parameters to compose the URL via 'QueryParameters'.
>
> ***WARNING***
>
> If you're going to use encryption in your stream, do the following!!

The need for encryption tied to the authentication flow needs to be fixed, and we are working on a new version to be released, for now, to cover the need, instead of using the ***encryptionResolver property***.

Instead, use the ***queryParamsResolver*** property to provide the class that will solve the encryption ticket, as shown in the following example.

> Create a temporary service by injecting the encryption service to get the ticket and pass it as a parameter, and provide it to the ***queryParamsResolver***.
>
> ***Note**: Don't forget to provide the service as the provider of your application.*

File: src/config/temporary-encryption-resolver.service.ts

``` TS
import { Injectable } from "@angular/core";

import { Observable, of } from "rxjs";

import { EncryptionService } from "@afe/encryption";
import { OAuth2AuthorizeQueryParamsConfig, OAuth2AuthorizeQueryParamsResolver } from "@afe/authentication/oauth2";

@Injectable()
export class TemporaryEncryptionResolver implements OAuth2AuthorizeQueryParamsResolver {
    constructor(private readonly encryption: EncryptionService) {}
    resolve(): Observable<OAuth2AuthorizeQueryParamsConfig> {
        const ticket = this.encryption.getTicket();

        return of({ ticket });
    }
}
```

After the aforementioned configurations, import into the main module of the application the OAuth2AuthenticationModule from the ***@afe/authentication/oauth2***.

Passing to your ***forRoot*** method the ***authenticationConfig*** constant exported from the ***oauth2-authentication.config.ts*** file.

> Note: the import should not be performed on the main module, do not use on lazy-load modules.

File: app.module.ts

``` TS
import { OAuth2AuthenticationModule } from "@afe/authentication/oauth2";
import { authenticationConfig } from "./config/authentication.config";

@NgModule({
  //  ...
  imports: [
    //  ...
    OAuth2AuthenticationModule.forRoot(authenticationConfig),
  ],
})
export class AppModule {}
```

> **✅ Perfect!**
>
> We set up the architecture library in our application **Angular**!
