# Use it in Angular

## Overview

The Security Library also known as `SecurityContextManager` or `SCM`, offers utilities to manage the CIP authorization flow providing token obtention, rotation & injection.
User login is handled by the Authorization Server during token acquisition, with this in mind a logout feature is also provided.

`@santander/security-angular` wraps `@santander/security`, which is a vanilla layer with the main implementation. This wrapper productivize the library making it easy to use in Angular applications.
This way, the Angular wrapper offers an Angular module called `SCMCipModule` with an `CipAuthGuard` and an `CipAuthService` (among other things) ready to be used in your Angular application.

In a Microfrontend Architecture, it should be used in conjunction with the [http library](../../../http/index.md).

## Capabilities

- **Authentication**: Provide OAuth authorization flow (including implicit login)
- **Logout features**.
- **Token obtention, storage, rotation & injection**. Regarding the token storage, SCM offer two strategies:
    - [Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures).
    - [Session Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage).

## Installation

Install the security library:

`npm install @santander/security-angular`

## Configuration

`@santander/security-angular` provide two types of configuration, dynamic and static. Both have the same fields to configure. This is the definition and the data format expected:

```typescript
export type SCMCipConfig = {
  authentication_service: AuthenticationService;
  backend_services: BackendServices;
  oauth_data: OAuthData;
};

export type AuthenticationService = {
  localAdapter: LocalAdapter;
  remoteAdapter: RemoteAdapter;
};

export type BackendServices = Record<string, BackendService>;

export type InjectionConfig = {
  /**
   * Force service calls even if there is no token found by SCM but the URL does match the injection patterns declared in the SCM configuration.
   * In this case, the service will be the entity who responds with an error if the token is required.
   *
   * This new config attribute tackles the problem tangentially of the use case in which a project needs the token validation omitting the SCM filter to allow just service validation.
   *
   * If the value is not declared in the config file, the default value will be false.
   */
  forceServiceCall?: boolean;
  /**
   * Define the resources that will include the access token. If this property is not set or array is empty, all the resources will be included.
   */
  injectionPatterns?: string[];
  /**
   * the header name where the token will be sended to the API (“<header value of token_header_name>: <token>)
   */
  tokenHeaderName?: string;
};

export type BackendService = {
  isCoexistance?: boolean;
  injectionConfigs?: InjectionConfig[];
};

export type OAuthData = {
  /**
   * Identification  of the Client configured in the OAuth Server
   */
  client_id: string;
  /**
   * Scopes of the information to access
   */
  scopes: string;
};

export type LocalAdapter = {
  requiredCredentials: RequiredCredentials;
};

export type RequiredCredentials = {
  credential: string;
  and: RequiredCredentials[];
  or: RequiredCredentials[];
};

export type RemoteAdapter = {
  mock: boolean;
  loginEndpoint: string;
  logoutEndpoint: string;
  refreshEndpoint: string;
  clientId: string;
  redirectUri: string;
  /**
   * Definition of the strategy to be used to store the authentication tokens
   */
  tokenStrategy: TokenStoreStrategyOptions;
  /**
   * The percentage of time to automatically renovates the refresh token before its expired.
   *
   * If nothing is set, the default value is 75% of the expiration time.
   *
   * @remarks
   * The value of this property should be a decimal value between 0 and 100.
   *
   * @example
   * ```
   * If the value is set to 75, it means that the access token will be
   * renewed when it reaches 75% of its expiration.
   *
   * timePercentageForRefreshToken: 75, // it means that the refresh token will be renewed when it reaches 75% of its expiration time.
   *
   * ```
   */
  timePercentageForRefreshToken?: PercentRange;
  /**
   * Object that configures the retry policy. Adding this parameter all the HTTP requests managed by the SCM are retried
   * when they fail as configured here. Default behaviour is no retries at all.
   * It has two properties: `numberOfRetries` to set the maximun number of retries
   * and `delay` that sets the delay in milliseconds between them
   */
  retry?: RetryConfig;
  handledHeaders?: Array<StringWithAutocomplete<'x-cip-authncustomer' | 'mock'>>;
};
```

Example of how to set injectionPatterns property inside configuration object:

```typescript
// the rest of the configuration above
injectionPatterns: [
  'http://localhost:4200/global-position/',
  'http://localhost:4200/admin/*',
  '^(?!http://localhost:4200/admin/appliances/oven*).*$'
];
```

> [!NOTE]
> The second url with wildcard (*) inside, it means that the token will be injected into the headers in all urls that match the specified pattern.
> You can also specify negation patterns. For example, to inject the token into all routes starting with '<http://localhost:4200/admin/>*' except for the URL starting with '<http://localhost:4200/admin/appliances/oven>'.

RetryConfig contract for help you how to set the `retry` property:

```typescript
export interface RetryConfig {
  numberOfRetries: number;
  delay: number;
}
```

### Loading Configuration in app.config.ts

You can choose what kind of token strategy do you want to use, `SESSION_STORAGE` or `CLOSURE_STORAGE`. To provide this information, import the `TokenStoreStrategyOptions`:

```typescript
import { TokenStoreStrategyOptions } from '@santander/security';
```

#### Static vs Dynamic configuration

The main difference between static and dynamic is that in the dynamic approach the definition of the config is stored outside the app code, having a independent lifecycle from the application.

In order to obtain this dynamic configuration, the app should make an additional request to acquire it but it allow you having diffente configuration for different environments. **This is the recommended way to configure SCM**.

In the static config, the configuration is "hardcoded" on the application code, so the same configuration will be used for each environment. This way is just recommended in local scenarios or for testing porpuses.

##### Dynamic configuration

This setup allows to customize CIP configurations using a function that loads config files asynchronously (`getConfigAsync()` in the example is an async function that returns a `Promise` with the configuration object.
You should create this method before adding it in config prop).

Dynamic loading example:

```typescript
SCMCipModule.forRoot({
  useFactory: getConfigAsync, // getConfigAsync is aa function responsible to provide the configuration
  deps: [],
}),
```

In case of using Darwin configuration service for example, you can do it this way:

```typescript title="app.config.ts"
···
import { ConfigModule, ConfigService } from '@ng-darwin/config';
import { SCMCipModule } from '@santander/security-angular';

async function getConfigAsync(configService: ConfigService): Promise<any> {
  const cfg = await firstValueFrom(configService.onConfigLoaded$);
  return Promise.resolve((cfg['app'] as any)['cip']); // assuming that the cip configuration comes inside cfg.app.cip
}

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(ConfigModule.forRoot({···})),
    importProvidersFrom(SCMCipModule.forRoot({
      useFactory: getConfigAsync,
      deps: [ConfigService],
    }))
  ]
};
```

You may notice that the dynamic configuration JSON is slightly different from the static one, due the values from `tokenStrategy` must be strings instead of enum values.

##### Static configuration

When the app is configured in in a static way, the config is not being loaded from outside the application but in a hardcored way inside the app.
This is not recommended, it's a better option to use a config file loaded in runtime, but it makes sense for some scenarios like unit tests.

Static loading examples:

a) Minimum required configuration:

```typescript title="app.config.ts"
import { TokenStoreStrategyOptions } from '@santander/security';
import { SCMCipModule } from '@santander/security-angular';
···

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(
      SCMCipModule.forRoot({
        authentication_service: {
          localAdapter: {
            requiredCredentials: {
              credential: 'user_pass',
              and: [
                {
                  credential: 'device_context',
                  and: [],
                  or: [],
                },
                {
                  credential: 'risk_evaluation',
                  and: [],
                  or: [],
                },
              ],
              or: [
                {
                  credential: 'cryptogram',
                  and: [],
                  or: [],
                },
              ],
            },
          },
          remoteAdapter: {
            mock: true,
            loginEndpoint: 'https://example.com/login',
            logoutEndpoint: 'https://example.com/logout',
            refreshEndpoint: 'https://example.com/refresh',
            clientId: 'mock-client-id',
            redirectUri: 'https://example.com/redirect',
            tokenStrategy: TokenStoreStrategyOptions.SESSION_STORAGE,
          },
        },
        oauth_data: {
          client_id: 'mock-client-id',
          scopes: 'read write',
        },
      })
    )
  ]
};
```

b) Configuration with some optional parameters:

```typescript title="app.config.ts"
import { TokenStoreStrategyOptions } from '@santander/security';
import { SCMCipModule } from '@santander/security-angular';
···

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(
      SCMCipModule.forRoot({
        authentication_service: {
          localAdapter: {
            requiredCredentials: {
              credential: 'user_pass',
              and: [
                {
                  credential: 'device_context',
                  and: [],
                  or: [],
                },
                {
                  credential: 'risk_evaluation',
                  and: [],
                  or: [],
                },
              ],
              or: [
                {
                  credential: 'cryptogram',
                  and: [],
                  or: [],
                },
              ],
            },
          },
          remoteAdapter: {
            mock: true,
            loginEndpoint: 'https://example.com/login',
            logoutEndpoint: 'https://example.com/logout',
            refreshEndpoint: 'https://example.com/refresh',
            clientId: 'mock-client-id',
            redirectUri: 'https://example.com/redirect',
            handledHeaders: ['x-cip-authncustomer', 'mock'],
            tokenStrategy: TokenStoreStrategyOptions.SESSION_STORAGE,
            timePercentageForRefreshToken: 75,
            retry: {
              numberOfRetries: 3,
              delay: 400,
            }
          },
        },
        backend_services: {
          service1: {
            isCoexistance: true,
            injectionConfigs: [
              {
                forceServiceCall: true,
                injectionPatterns: [
                  'https://example.com/service1',
                  'http://localhost:4200/products/*',
                  '^(?!http://localhost:4200/products/appliances/oven*).*$',
                ],
                tokenHeaderName: 'accessToken',
              },
            ],
          },
          service2: {
            isCoexistance: false,
          },
        },
        oauth_data: {
          client_id: 'mock-client-id',
          scopes: 'read write',
        },
      })
    )
  ]
};
```

#### Session vs Closure storage strategy

You can choose what kind of token strategy do you want to use, `SESSION_STORAGE` or `CLOSURE_STORAGE`. To provide this information, import the `TokenStoreStrategyOptions` in the `app.config.ts` file and configure the `storageStrategy` property:

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
import { useScmCipAuth } from '@santander/security-react';

const { httpRequest } = useScmCipAuth();
```

2 - Make the request with httpRequest:

```tsx
await httpRequest.GET('https://localhost:8080/users');
```

`httpRequest` will intercept the request and will inject the token or not depending if `injectionPatterns` config property is defined or not in the configuration of SCMCipProvider.

If `protectedResources` is defined, it will check the url of the request with the urls defined in `injectionPatterns` for injecting or not the token. If the url matches with some pattern, will inject the token in the request.

If is not defined, will inject the token in every requests made with `httpRequest`.

## Protecting your inner routes: CipAuthGuard

You can protect a route to avoid the user access a route without previous authentication. This is possible using with the Guard `CipAuthGuard`. If the user is not authenticated, will emit an `SCMEvent` of type `GLN_SCM_NOT_AUTHENTICATED`.

- `canActivateFn`: Checks if a user can access a page. Emits an `GLN_SCM_NOT_AUTHENTICATED` event if the user is not authenticated.

``` typescript
export const CipAuthGuard: CanActivateFn = (): boolean => {
  const cipAuthService = inject(CipAuthService);

  if (!cipAuthService.isUserAuthenticated()) {
    emitSCMEvent(SCMEventType.NOT_AUTHENTICATED, { message: SCMEventMessage.NOT_AUTHENTICATED });
    return false;
  }
  return true;
};
```

As an Angular Guard it can be used in the Angular router config to avoid the user access a route without previous authentication.

```typescript
import { CipAuthGuard } from '@santander/security-angular';

export const appRoutes: Route[] = [
  {
    path: 'logout',
    component: Logout,
  },
  {
    path: 'home',
    canActivate: [CipAuthGuard],
    component: GlobalPositionHost,
  },
  {
    path: '',
    component: Welcome,
  },
];
```

### Initiate CIP flow programmatically

Instead of using the guard explained before, it is possible to inject the `CipAuthService` in the component and to initiate the OAuth 2.0 flow calling the `init()` method.

```typescript
import { CipAuthService } from '@santander/security-angular';

async login(credentials: LoginRequest): Promise<AuthActionResult | FetchResponseError> {
 this.cipAuthService.initialize();
 await this.cipAuthService.validateCredentials(credentials);
}
```

### Logout the session

For logout, call the `logout()` method from `useScmCipAuth`.

```typescript
async doLogout(): Promise<AuthActionResult | FetchResponseError> {
  await this.cipAuthService.logout();
}
```

Within this configuration, the SCM will emit an event called `LOGOUT_SUCCESS` when the logout process was successfully finished. This event must be listened by the application to redirect the user to the desired page.

```typescript
eventService.onSCMEvent$.subscribe({
  next: (event: SCMEvent) => {
    if (event.eventType === SCMEventType.LOGOUT_SUCCESS) {
      router.navigate(['/logout']);
    }
  },
});
```

### Set an external token

In certain scenarios, the user will be authenticated with the “old” authentication method rather than the “new”. An app can provide its own token. The SCM will remain responsible for injecting it into requests.
Two public methods are available for managing external tokens: `this.cipAuthService.setToken` and `this.cipAuthService.removeToken`. Only services configured as `isCoexistance` can be managed this way.

### SCM Events

The library doesn't handle the behaviour of the application when errors happen during the process (for example an error from the auth server) or outside the authentication flow process (for example what happens when authentication finishes successfully).

In order to notice the application about the status of SCM tasks, several events are emitted and can be captured from the application in an easy way.

Events are emitted through the `onSCMEvent$` observable of the `SCMEventService`, and their data structure is defined in `SCMEvent` interface:

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

| EVENT_TYPE                    | DESCRIPTION                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------------- |
| GLN_SCM_AUTH_CODE_START       | Authentication process starts (login launched)                                         |
| GLN_SCM_AUTH_CODE_SUCCESS     | Authentication process success (login success)                                         |
| GLN_SCM_AUTH_CODE_FAILURE     | Authentication process fails                                                           |
| GLN_SCM_ACQUIRE_TOKEN_START   | Acquire token request launched                                                         |
| GLN_SCM_ACQUIRE_TOKEN_SUCCESS | Acquire token request successful (AUTHENTICATION PROCESS FINISHED)                     |
| GLN_SCM_ACQUIRE_TOKEN_FAILURE | Acquire token request failed                                                           |
| GLN_SCM_REFRESH_TOKEN_START   | Access token refresh process started                                                   |
| GLN_SCM_REFRESH_TOKEN_SUCCESS | Access token refresh process success                                                   |
| GLN_SCM_REFRESH_TOKEN_FAILURE | Error when trying to refresh access token                                              |
| GLN_SCM_LOGOUT_START          | Logout process starts                                                                  |
| GLN_SCM_LOGOUT_SUCCESS        | Logout process success                                                                 |
| GLN_SCM_LOGOUT_FAILURE        | Error in logout process                                                                |
| GLN_SCM_TECHNICAL_ERROR       | A technical error which source is detailed in SCMEvent `technicalErrorSource` property |
| GLN_SCM_NOT_AUTHENTICATED     | The user is not authenticated                                                          |

#### Examples of how handling SCM Events

Inside the subscribe function it is possible to use Rxjs operators such as `pipe` and `filter` to filter events.

For example, to receive only the event that is emitted when the authentication process is completed and access token has been obtained it's possible to do something like this:

```typescript
...

const eventService = inject(SCMEventService);

eventService.onSCMEvent$
  .pipe(
    filter((event: SCMEvent) => event.eventType == SCMEventType.GLN_SCM_AUTH_PROCESS_COMPLETED)
  )
  .subscribe({
    next: (event: SCMEvent) => {
      console.log('Authentication process finished successfully, application is ready to inject token in the requests');
      // do something after authentication
    },
  });
```

Events usually give some details inside `payload.message` property. When the event is an error it also adds some info in `payload.error`. In addition to handle the app behaviour when the error occurs, it can be useful to log the error details, for example:

```typescript
...

const eventService = inject(SCMEventService);

const ERROR_EVENTS = [
  SCMEventType.AUTH_CODE_FAILURE,
  SCMEventType.ACQUIRE_TOKEN_FAILURE,
  SCMEventType.REFRESH_TOKEN_FAILURE,
  SCMEventType.LOGOUT_FAILURE
];

eventService.onSCMEvent$
  .pipe(
    filter((event: SCMEvent) => ERROR_EVENTS.some((errorEvent) => errorEvent === event.eventType))
  )
  .subscribe({
    next: (event: SCMEvent) => {
      console.log('Error event, details: ', event.payload);
      console.log('message: ', event.payload.message);
      console.log('error details: ', event.payload.error);
    }
  }),
```

Example without using `filter` operator:

```typescript
...

const eventService = inject(SCMEventService);

eventService.onSCMEvent$.subscribe({
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
  },
});
```

## States

SCM handles different states, these states are continuously updated, so the client must observe them to perform the tasks needed. To report these state changes, different events related to each type of state are generated.

Current states and handled by SCM are the following:

``` typescript
export enum AuthStateEnum {
  AUTHENTICATION_REQUIRED = 'AUTHENTICATION_REQUIRED',
  CREDENTIALS_REQUIRED = 'CREDENTIALS_REQUIRED',
  INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
  TECHNICAL_ERROR = 'TECHNICAL_ERROR',
  LOGIN_SUCCESSFUL = 'LOGIN_SUCCESSFUL',
  REFRESH_SUCCESSFUL = 'REFRESH_SUCCESSFUL',
  LOGOUT_SUCCESSFUL = 'LOGOUT_SUCCESSFUL',
  REDIRECT_SUCCESSFUL = 'REDIRECT_SUCCESSFUL',
  IDLE = 'IDLE',
}
```

You can use the following methods for getting the current state and for doing an action when the state changes.

``` typescript
import { CipAuthService } from '@santander/security-angular';

...

this.cipAuthService.getCurrentState(): StateGeneric
this.cipAuthService.onStateChange(callback: (state: StateGeneric) => void): void
```
