# Project Configuration

After the [prerequisites](./pre-reqs.md) step, let's move on to the necessary settings.

If it doesn't exist, create the ***config*** folder in the project. Inside it, create the ***sso-ticket-authentication.config.ts*** file and export a constant of type ***SsoTicketAuthenticationConfig***, which belongs to the sub-library ***@afe/authentication/sso-ticket***.

Below is an example of this configuration file:

File: config/sso-ticket-authentication.config.ts

``` TS
import { SsoTicketAuthenticationConfig } from "@afe/authentication/sso-ticket";

export const authenticationConfig: SsoTicketAuthenticationConfig = {
    idleTimeout: true,
    appKey: `<YOUR_APP_KEY>`,
    clientId: `<YOUR_CLIENT_ID>`,
    systemCode: '<YOUR_SYSTEM_CODE>',
    clientSecret: `<YOUR_CLIENT_SECRET>`,
    urlsToIntercept: [ '<APIGEE_GATEWAY_URL>' ],
    urlLogin: '/<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/token',
    urlLogout: '/<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/logout',
    refreshTokenUrl: `<APIGEE_GATEWAY_URL>/auth/oauth/<OAUTH_API_VERSION>/token`,
};
```

❗ > **Notes**
>
> The ***<...>*** variables used must be replaced with the respective values of your project:
>
> '<YOUR_APP_KEY>': app-key (client-id) of your application in the ***Apigee GHS***
>
> '<YOUR_CLIENT_ID>': app-key (client-id) of your application in the ***Apigee GHS***
>
> '<YOUR_SYSTEM_CODE>': application system acronym in ***Apigee GHS***
>
> ***Note***: The system acronym must be the same as the source application that generated the DLB ticket.
>
> '<YOUR_CLIENT_SECRET>': client-secret of your application on ***Apigee GHS***
>
> ***Note***: the value changes according to the environment used (DEV, PRE, PRD).
>
> '<OAUTH_API_VERSION>': Version of the OAuth product API that requested consumption permission
>
> '<APIGEE_GATEWAY_ALIAS>': alias (usually configured as ***/apigee-url***) to point to the gateway endpoint.
>
> **⚠️ Note**
>
> Check more details of the ***idleTimeout*** property in the [Session Update Policy](./../refresh-policy.md).
> In addition to the mandatory configuration properties mentioned above, there are other optional properties that can be configured as needed by the project, for example:

File: config/sso-ticket-authentication.config.ts

``` TS
import { SsoTicketAuthenticationConfig } from "@afe/authentication/sso-ticket";
import { EncryptionService } from "@afe/encryption";

export const authenticationConfig: SsoTicketAuthenticationConfig = {
    // other properties omitted ...
    urlsToIgnore: [ `<YOUR_PART_OF_URL_TO_IGNORE>` ],
    ticketQueryStringName: `<YOUR_TICKET_PARAM_NAME>`,
    encryptionService: EncryptionService, // Or `<YOUR_SERVICE_TO_ENCRYPTION_RESOLVER>`
};
```

❗ > **Notes**
>
> ***encryptionResolver***: receives a service responsible for providing the encryption ticket of the initialized cryptographic context, for this, just pass the ***EncryptionService*** of ***@afe/encryption***.
>
>
> If the project has a different crypto flow, it is possible to provide its own service <YOUR_SERVICE_TO_ENCRYPTION_RESOLVER>'' capable of solving the ticket (following some established premises).
>
> ***Note**: Since the project will use cryptography, this field is now mandatory, as it will be necessary to link the ticket from the cryptographic context to the authentication flow*.
>
> ***urlsToIgnore***: Receives snippets of urls that **should not** be contemplated for adding the access token to communicate with the gateway. Replace '<YOUR_PART_OF_URL_TO_IGNORE>' with the urls you want to ignore.
>
> ***ticketQueryStringName***: allows you to change the name of the parameter to be used to capture the DLB ticket. Replace ***<YOUR_TICKET_PARAM_NAME> with the name of the parameter you want to use.
>
> After the aforementioned configurations, import the ***SsoTicketAuthenticationModule*** from the ***@afe/authentication/sso-ticket*** package into the main application module.
> Passing to your ***forRoot*** method the ***authenticationConfig*** constant exported from the ***sso-ticket-authentication.config.ts*** file.
> Note: the import should not be performed on the main module, do not use on lazy-load modules.

File: app.module.ts

``` TS
import { SsoTicketAuthenticationModule } from '@afe/authentication/sso-ticket';
import { authenticationConfig } from "./config/authentication.config";

@NgModule({
  // ...
  imports: [
    // ...
    SsoTicketAuthenticationModule.forRoot(ssoTicketAuthenticationConfig),
  ],
})
export class AppModule {}
```

> **✅ Perfect!**
>
> We set up the architecture library in our application **Angular**!
> **❗ ❗ ❗ ⚠️ ATTENTION ❗ ❗ ❗**
>
> **Temporary Setup Required**
>
> Before proceeding to the authentication process, perform the mandatory temporary configuration step as follows: [temporary procedure required](./temp-authenticator-service.md)
