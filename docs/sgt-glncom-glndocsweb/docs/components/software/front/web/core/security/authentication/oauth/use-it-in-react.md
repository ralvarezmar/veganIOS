# Use it in React

## Overview

The Security Library also known as `SecurityContextManager` or `SCM`, offers utilities to manage the OAuth 2.0 authorization flow providing token obtention, rotation & injection.
User login is handled by the Authorization Server during token acquisition, with this in mind a logout feature is also provided.

`@santander/security-react` wraps `@santander/security`, which is a vanilla layer with the main implementation. This wrapper productivize the library making it easy to use in React applications.

In a Microfrontend Architecture, it should be used in conjunction with the [http library](../../../http/index.md).

## Capabilities

- Authentication: Provide OAuth authorization flow (including implicit login)
- Logout features
- Token obtention, storage, rotation & injection.

  - Regarding the token storage, SCM offer two strategies:

    - [Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures).
    - [Session Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage).

- PKCE (Proof Key for Code Exchange): [PKCE](https://oauth.net/2/pkce/) is a simple extension to the [OAuth 2.0 Authorization Code grant](https://oauth.net/2/grant-types/authorization-code/) that prevents CSRF and authorization code injection attacks.
  It's a lightweight mechanism that can be implemented in any application that requests an authorization code.

## Installation

In order to download the library you need a **.npmrc** file with the following configuration:
`@santander:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases/`

And then install the library in the application running `npm i @santander/security-react`

## Configuration

@santander/security-react provide two types of configuration, Dynamic and Static. Both have the same fields to configure. This is the definition and the data format expected:

```typescript
export interface OAuthConfig {
  client: OAuthClient;
  scope: string[];
  redirectUri: string;
  issuerUri: string;
  storageStrategy: TokenStoreStrategyOptions;
  type: AuthType;
  serverConfig: any;
  timePercentageForRefreshToken?: PercentRange;
  protectedResources?: string[];
  promptParamValue?: PromptType | string;
  includeStateParam?: boolean;
  retry?: RetryConfig;
  httpLibrary?: FetchManager | XHR;
}
```

- `client`: Information about the client, contains:`clientId: string` .
- `scope`: Array of strings that set the scopes to request from the OAuth server.
- `redirectUri`: URL to redirect to after a successful authentication.
- `issuerUri`: Base URI of the OAuth Server.
- `storageStrategy`: Strategy to decide if the OAuth tokens are stored in session storage or in a closure: `TokenStoreStrategyOptions.SESSION_STORAGE` or `TokenStoreStrategyOptions.CLOSURE_STORAGE`.
- `type`: Specifies that the server authentication flow is OAuth: unique possible value for the moment is `AuthType.OAUTH`.
- `serverConfig`: OAuth server configuration data

    Minimum **serverConfig** object example (can have more fields, but these are the minimum required):

    ```typescript
      {
        issuer: "http://localhost:8080/sos/oauth/",
        authorization_endpoint: "http://localhost:8080/sos/oauth/authorize",
        token_endpoint: "http://localhost:8080/sos/oauth/token",
        end_session_endpoint: "http://localhost:8080/sos/oauth/session/end",
      }
    ```

- `protectedResources`: (optional) Array of strings representing the urls to be protected. For The requests that match with some of urls or wildcards of this property,
  a token will be injected into the headers. Furthermore, if this property is not specified or the array is empty, the token will be injected into the headers in all requests.
  Although, if the url of the request doesn't match with some of urls or wildcards of this property, the token will not be injected into the headers.

    Example of how to set protectedResources property inside configuration object:

    ```typescript
    // the rest of the configuration above
    protectedResources: [
      'http://localhost:4200/global-position/',
      'http://localhost:4200/admin/*',
    ];
    // the secound url with wildcard (*) inside, it means that the token will be injected into the headers in all urls that match the specified pattern
    ```

- `timePercentageForRefreshToken`: (optional) Number (between 1 and 100) that sets the percentage of the expiration time of the token to do the refresh. Default is 75.
- `promptParamValue`: (optional) This value configures 'prompt' URL parameter in the Authorization URL redirection. If set, 'prompt' parameter is add in that request with the value set here.
  Possible values are defined in the PromptType enum ('none', 'login', 'consent', 'select_account') or it can be also a free string. By default, if not set, the parameter is not sent in the request.
- `includeStateParam`: (optional) Boolean property that adds the 'state' URL parameter in the Authorization endpoint request if set to true. State parameter is a random number generated by the library.
- `retry`: (optional) Object that configures the retry policy. Adding this parameter all the HTTP requests managed by the SCM are retried when they fail as configured here.
  Default behaviour is no retries at all. It has two properties: `numberOfRetries` to set the maximum number of retries and `delay` that sets the delay in milliseconds between them:

    ```typescript
    export interface RetryConfig {
      numberOfRetries: number;
      delay: number;
    }
    ```

- `httpLibrary` (optional) The instance of the http library for making requests. Can be an instance of FetchManager(`@santander/http` - by default) or XHR(`@gruposantander/web-ui-framework`)

### Loading Configuration in main.tsx

To load previous configurations in the `main.tsx`, the `SecurityContextManagerProvider` is added in the `imports` section and initialized wrapping the `App` component.

```typescript
import { TokenStoreStrategyOptions, AuthType } from '@santander/security';
import { SecurityContextManagerProvider } from '@santander/security-react';
```

#### Static vs dynamic configuration

The main difference between static and dynamic is that in the dynamic approach the definition of the config is stored outside the app code, having a independent lifecycle from the application.

In order to obtain this dynamic configuration, the app should make an additional request to acquire it but it allow you having diffente configuration for different environments. **This is the recommended way to configure SCM**.

In the static config, the configuration is "hardcoded" on the application code, so the same configuration will be used for each environment. This way is just recommended in local scenarios or for testing porpuses.

##### Dynamic configuration

This setup allows to customize OAuth configurations using a function that loads config files asynchronously (`getConfigAsync()` in the example is an async function that returns a `Promise` with the configuration object.
You should create this method before adding it in config prop).

Dynamic loading example:

```tsx
const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);
root.render(
  <StrictMode>
    <SecurityContextManagerProvider
      config={{ asyncConfig: getConfigAsync }}
    >
      <App />
    </SecurityContextManagerProvider>
  </StrictMode>
);
```

You may notice that the dynamic configuration JSON is slightly different from the static one, due the values from `storeStrategy` and `type` must be strings instead of enum values.

config.json

```JSON
{
  ···
  "app": {
    "oauth": {
      "storageStrategy": "sessionStorage",   // "sessionStorage" | "closureStorage"
      "client":{ "clientId": "oauth_client" },
      "type": "oauth",
      "scope": ["read"],
      "redirectUri": "http://localhost:4200/home",
      "issuerUri": "http://localhost:8080"
    },
  }
}
```

##### Static configuration

When the app is configured in in a static way, the config is not being loaded from outside the application but in a hardcored way inside the app.
This is not recommended, it's a better option to use a config file loaded in runtime, but it makes sense for some scenarios like unit tests.

Static loading example:

```tsx
const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);
root.render(
  <StrictMode>
    <SecurityContextManagerProvider
      config={{
        storageStrategy: TokenStoreStrategyOptions.SESSION_STORAGE,
        client: {
          clientId: 'oauth_client',
        },
        type: AuthType.OAUTH,
        scope: ['read'],
        redirectUri: 'http://localhost:4200/home',
        issuerUri: 'http://localhost:8080',
        timePercentageForRefreshToken: 75,
      }}
    >
      <App />
    </SecurityContextManagerProvider>
  </StrictMode>
);

```

##### OAuth Flow Configuration example

```typescript
const oauthSpainTestConfig = {
  storageStrategy: TokenStoreStrategyOptions.SESSION_STORAGE,
  client: {
    clientId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx',
  },
  type: AuthType.OAUTH,
  scope: ['write', 'read'],
  redirectUri: 'http://localhost:4200/home',
  issuerUri: 'http://localhost:8080/sos/oauth/',
  serverConfig: {
    issuer: 'http://localhost:8080/sos/oauth/',
    authorization_endpoint: 'http://localhost:8080/sos/oauth/authorize',
    token_endpoint: 'http://localhost:8080/sos/oauth/token',
    end_session_endpoint: 'http://localhost:8080/sos/oauth/session/end',
  },
};
```

#### Session vs Closure storage strategy

You can choose what kind of token strategy do you want to use, `SESSION_STORAGE` or `CLOSURE_STORAGE`. To provide this information, import the `TokenStoreStrategyOptions` in the `main.tsx` file and configure the `storageStrategy` property.

```typescript
import { TokenStoreStrategyOptions } from '@santander/security';

TokenStoreStrategyOptions.SESSION_STORAGE // TokenStoreStrategyOptions.CLOSURE_STORAGE
```

> Or you can set the literal value of them: `'closureStorage'` and `'sessionStorage'` respectively

##### Closure

**PROs**: Helps protect the Access Token / Refresh Token from exfiltration by a malicious script (or possible abuse by a developer).

**CONs**: The tokens are lost if the user launches a page refresh (by pressing “F5” o clicking on the URL).
This means that a new request to the Auth Server is required when the page is reloaded which may affect the end-user experience (slower page loading).

##### Session Storage

**PROs**: The tokens are persisted during a page refresh. This means that page will reload quicker.

**CONs**: The tokens are more vulnerable to extraction by malicious script and more open to abuse by developers.

The selection of one strategy or the other depends on the sensitivity of the application and the context where it is being executed (internet or intranet for example) balanced with the end-user experience.
The final decision must be reviewed with the application and security architects assigned to the project.

## HTTP requests secured

For making HTTP request secured, you can use `httpRequest` from `useScmAuth` hook.

1 - In your component, import the hook `useScmAuth`, and extract `httpRequest`.

```tsx
import { useScmAuth } from '@santander/security-react';

const { httpRequest } = useScmAuth();
```

2 - Make the request with httpRequest:

```tsx
await httpRequest.GET('https://localhost:8080/users');
```

`httpRequest` will intercept the request and will inject the token or not depending if `protectedResources` config property is defined or not in the configuration of SecurityContextManagerProvider.

If `protectedResources` is defined, it will check the url of the request with the urls defined in `protectedResources` for injecting or not the token. If the url matches with some pattern, will inject the token in the request.

If is not defined, will inject the token in every requests made with `httpRequest`.

## Protecting your inner routes: withAuthGuard

You can protect a route to avoid the user access a route without previous authentication. This is possible using with the HOC `withAuthGuard` passing the component that you want to protect.

Example:

``` tsx
import { withAuthGuard } from '@santander/security-react';
import React from 'react';
import { Route, Routes } from 'react-router-dom'; // or another routing library like Wouter or TanStack Router
import { GlobalPosition, Logout, Welcome } from '../../pages';

const AppRouter: React.FC = (): JSX.Element => {
  return (
    <Routes>
      <Route path="/" element={<Welcome />} />
      <Route path="/home" Component={withAuthGuard(GlobalPosition)} />
      <Route path="/logout" element={<Logout />} />
    </Routes>
  );
};

export default AppRouter;
```

The application checks that the user has a saved oauth token before activate `/home` path in this case. If there isn't a token the auth flow is started.

### Initiate OAuth 2.0 flow programmatically

For this scenario, it's mandatory to use the `withAuthGuard` HOC in the routes file of yor app. Then, import the hook `useScmAuth` in the component and to initiate the login process manually calling the `init()` method.

A use case example would be if you want to add a login button:
The login button would call to the `init` method of `useScmAuth`, and then, the `withAuthGuard` HOC would be ready to check if the user is authenticated or not, and continue the auth flow.

```tsx
import { useScmAuth } from '@santander/security-react';

const { init, logout } = useScmAuth();

login(): void {
 init();
}
```

### Logout the session

For logout, call the `logout()` method from `useScmAuth`.

```tsx
doLogout(): void {
  logout();
}
```

Within this configuration, the SCM will emit an event called `LOGOUT_SUCCESS` when the logout process was successfully finished. This event must be listened by the application to redirect the user to the desired page.

```tsx
useEffect(() => {
  const scmEventsSubs$ = scmEvents$
    .pipe(filter((event: SCMEvent) => event.eventType === SCMEventType.LOGOUT_SUCCESS))
    .subscribe({
      next: (event: SCMEvent) => {
        console.log('Event received from SCM ->', event);
        navigate('/logout');
      },
    });
  return () => {
    scmEventsSubs$.unsubscribe();
  };
});
```

### SCM Events

The library doesn't handle the behaviour of the application when errors happen during the process (for example an error from the auth server) or outside the authentication flow process (for example what happens when authentication finishes successfully).

In order to notice the application about the status of SCM tasks, several events are emitted and can be captured from the application in an easy way.

Events are emitted through `SCMEventService` `onSCMEvent$` observable and their data structure is defined in `SCMEvent` interface:

```typescript
export type SCMEventPayload = {
  message: string;
  error?: unknown;
};

export interface SCMEvent {
  eventType: SCMEventType;
  payload: SCMEventPayload;
  timestamp: number;
  id: string;
  technicalErrorSource?: string;
}
```

All events are identified by a unique `id` and give information about the time they have been emitted in the `timestamp` property. They also are categorized with the `eventType` and usually more information is added in the `payload` property.

These are the event types, they are listed in the `SCMEventType` enum:

| EVENT_TYPE                     | DESCRIPTION                                                                            |
| ------------------------------ | -------------------------------------------------------------------------------------- |
| GLN_SCM_AUTH_CODE_START        | Authentication process starts (login launched)                                         |
| GLN_SCM_AUTH_CODE_SUCCESS      | Authentication process success (login success)                                         |
| GLN_SCM_AUTH_CODE_FAILURE      | Authentication process fails                                                           |
| GLN_SCM_ACQUIRE_TOKEN_START    | Acquire token request launched                                                         |
| GLN_SCM_ACQUIRE_TOKEN_SUCCESS  | Acquire token request successful (AUTHENTICATION PROCESS FINISHED)                     |
| GLN_SCM_ACQUIRE_TOKEN_FAILURE  | Acquire token request failed                                                           |
| GLN_SCM_REFRESH_TOKEN_START    | Access token refresh process started                                                   |
| GLN_SCM_REFRESH_TOKEN_SUCCESS  | Access token refresh process success                                                   |
| GLN_SCM_REFRESH_TOKEN_FAILURE  | Error when trying to refresh access token                                              |
| GLN_SCM_AUTH_PROCESS_COMPLETED | Authentication process completed successfully (either acquiring or refreshing token). Token already available to inject |
| GLN_SCM_MAX_IDLE_TIME_WARNING  | This allows the shell to display a dialog that allows the end-user to continue their session |
| GLN_SCM_MAX_IDLE_TIME_EXCEEDED | User has exceeded the maximum idle time. The shell can use this event to initiate a log out process |
| GLN_SCM_LOGOUT_START           | Logout process starts                                                                  |
| GLN_SCM_LOGOUT_SUCCESS         | Logout process success                                                                 |
| GLN_SCM_LOGOUT_FAILURE         | Error in logout process                                                                |
| GLN_SCM_TECHNICAL_ERROR        | A technical error which source is detailed in SCMEvent `technicalErrorSource` property |

Here is an example of how the application can subscribe to the events emitted by the library through the observable:

1 - In the app's `App.tsx` file, import the hook `useScmAuth`, extract `scmEvents$`, create a function and subscribe to `scmEvents$` observable and handle events as desired.

```tsx
import { SCMEvent } from '@santander/http';
import { useScmAuth } from '@santander/security-react';
import { useCallback, useEffect } from 'react';

export function App() {
  const { scmEvents$ } = useScmAuth();

  const subscribeToSCMEvents = useCallback(() => {
    return scmEvents$.subscribe({
      next: (event: SCMEvent) => {
        console.log('Event received from SCM ->', event);
        console.log('Event details: ', event.payload);
      },
    });
  }, [scmEvents$]);
```

2 - Then launch the execution of that function when the application initializes and when the function `subscribeToSCMEvents` changes. In this case is important to unsubscribe when the `App` component will be destroyed.

```tsx
useEffect(() => {
    const scmEventsSubs$ = subscribeToSCMEvents();
    return () => {
      scmEventsSubs$.unsubscribe();
    };
  }, [subscribeToSCMEvents]);
```

Examples of handling SCM Events:

Inside the subscribe function it is possible to use Rxjs operators such as `pipe` and `filter` to filter events.

For example to receive only the event that is emitted when the access token has been obtained it's possible to do something like this:

```tsx
import { filter } from 'rxjs';
import { SCMEvent } from '@santander/http';
import { SCMEventType } from '@santander/security';
import { useScmAuth } from '@santander/security-react';
import { useCallback } from 'react';

const { scmEvents$ } = useScmAuth();

const subscribeToSCMEvents = useCallback(() => {
  return scmEvents$
  .pipe(filter((event: SCMEvent) => event.eventType == SCMEventType.ACQUIRE_TOKEN_SUCCESS)))
  .subscribe({
    next: (event: SCMEvent) => {
      console.log('User authenticated and access token obtained successfully');
      // do something after authentication
    },
  });
}, [scmEvents$]);
```

Events usually give some details inside `payload.message` property. When the event is an error it also adds some info in `payload.error`. In addition to handle the app behaviour when the error occurs, it can be useful to log the error details, for example:

```tsx
import { filter } from 'rxjs';
import { SCMEventType } from '@santander/security';
import { SCMEvent } from '@santander/http';
import { useScmAuth } from '@santander/security-react';
import { useCallback } from 'react';

const { scmEvents$ } = useScmAuth();

const subscribeToSCMEvents = useCallback(() => {
  const ERROR_EVENTS = [
    SCMEventType.AUTH_CODE_FAILURE,
    SCMEventType.ACQUIRE_TOKEN_FAILURE,
    SCMEventType.REFRESH_TOKEN_FAILURE,
    SCMEventType.LOGOUT_FAILURE
  ];

  return scmEvents$
  .pipe(
  filter(
    (event: SCMEvent) => ERROR_EVENTS.some((errorEvent) => errorEvent === event.eventType)
  ))
  .subscribe({
    next: (event: SCMEvent) => {
        console.log('Error event, details: ', event.payload);
        console.log('message: ', event.payload.message);
        console.log('error details: ', event.payload.error);
    }
  }),
}, [scmEvents$]);
```

Example without using `filter` operator:

```tsx
const subscribeToSCMEvents = useCallback(() => {
  return scmEvents$
  .subscribe({
    next: (event: SCMEvent) => {
      if (event.eventType == SCMEventType.REFRESH_TOKEN_FAILURE) {
        console.log('Refresh token error, details: ', event.payload);
        console.log('error message: ', event.payload.message);
        console.log('more error details: ', event.payload.error);
        // handle behaviour when refresh token error (try to launch login again? redirect to home page?...)
      } else {
        console.log('Not a refresh token error here');
        console.log('Event type received from SCM ->', event.eventType);
        console.log('Event details: ', event.payload);
      }
    }
  }),
}, [scmEvents$]);
```
