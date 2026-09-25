# Temporary Setup Required

There is a new definition by the Solution Architecture regarding the procedures adopted for the SSO Ticket flow.
Which **before** was used the Product API **SSO Ticket Auth**, the Product API **Authentication Oauth Client** is now used, changing the **payload sent to the API**.

While a new version with the adaptation is not released, it is necessary to perform an additional configuration for the authentication flow to work correctly, as follows.

`@afe/authentication` has been built in such a way that we can extend specific capabilities needed by customizing any need.

Therefore, create the file 'temporary-sso-ticket-authenticator.service.ts' in the **config** folder that will contain a temporary service to replace the authentication class of the ***SSOTicket*** module, adding the following contents:

File: config/temporary-sso-ticket-authenticator.service.ts

``` TS
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import {
  AuthenticateRequest,
  AuthenticatorService,
  OAuth2Tokens,
  OAuthToken,
} from '@afe/authentication';

export interface SsoTicketAuthenticateRequest extends AuthenticateRequest {
  appKey: string;
  systemCode: string;
  urlLogin: string;
  ticket: string;
  sessionTicket: string;
}

export interface SsoTicketAuthenticateResponse {
  scope: string;
  id_token: string;
  token_type: string;
  expires_in: number;
  access_token: string;
  refresh_token: string;
  session_state: string;
  'not-before-policy': string;
  refresh_expires_in: number;
}

@Injectable()
export class TemporarySsoTicketAuthenticatorService implements AuthenticatorService {
  constructor(private readonly httpClient: HttpClient) {}

  public authenticate(
    authenticationRequest: SsoTicketAuthenticateRequest
  ): Observable<OAuth2Tokens> {
    const { appKey, urlLogin, systemCode, ticket, sessionTicket } =
      authenticationRequest;

    const HttpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/x-www-form-urlencoded',
      }),
    };

    const payload = {
      grant_type: 'password',
      scope: 'openid',
      client_id: appKey,
      client_secret: '<YOUR_CLIENT_SECRET>',
      username: appKey,
      session_ticket: sessionTicket,
      session_system: systemCode,
      security_ticket: ticket,
      security_system: systemCode,
    };

    const payloadEncoded = new URLSearchParams(
      Object.entries(payload)
    ).toString();

    return this.httpClient
      .post<SsoTicketAuthenticateResponse>(
        urlLogin,
        payloadEncoded,
        HttpOptions
      )
      .pipe(
        map((result: SsoTicketAuthenticateResponse) => {
          return new OAuth2Tokens(
            {
              authorization: result.access_token,
              expiration: result.expires_in,
            },
            {
              authorization: result.refresh_token,
              expiration: result.refresh_expires_in,
            }
          );
        })
      );
  }
}
```

> Replace `<YOUR_CLIENT_SECRET>` by your respective value.

Next, provide the service created as your application's provider replacing the authentication service for `@afe/authentication`:

``` TS
// other omitted imports ...
import { HttpClient } from '@angular/common/http';

import { AuthenticatorService } from '@afe/authentication';
import { NewSsoTicketAuthenticatorService } from './config/temporary-sso-ticket-authenticator.service';

@NgModule({
  // other omitted configurations ...
  providers: [
    // other omitted providers ...
    {
      provide: AuthenticatorService,
      useClass: NewSsoTicketAuthenticatorService,
      deps: [HttpClient],
    },
  ],
})
export class AppModule {}
```

Now we can proceed with authentication process.
