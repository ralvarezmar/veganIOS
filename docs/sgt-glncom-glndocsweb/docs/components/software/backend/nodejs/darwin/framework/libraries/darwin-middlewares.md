
# Darwin Middlewares

## Summary

**Library in charge of containing various [middlewares](https://en.wikipedia.org/wiki/Middleware) for [GraphQL](https://www.apollographql.com/docs/) and [Fastify](https://www.fastify.io/) [Hooks](https://en.wikipedia.org/wiki/Hooking),
which are used by Darwin Nodejs Framework.**

It contains 3 middlewares/hooks that can be used in Fastify and GraphQL applications.

- **Headers Propagation:** In charge of propagating the common headers, security and traceability, to this end, it performs a proxy on the outgoing HTTPs AND HTTPs requests.

- **Health Check:** Responsible for returning the status of the service.

- **Request Context:** This hook/middleware is responsible for assigning each incoming request to the application a context (request context) with everything necessary to:
  - Propagation of headings.
  - Create attributes necessary to send logs to the ELK.
  - Correct functioning of the security module (spreading of headings and obtaining the token).

It contains one middleware exclusive to GraphQL applications:

- **Override Response:** Based on the premise of **only one activity log should be sent** for each request in the application,
so we have overwritten **HTTP Response** to send a trace in each response to the client.

It contains one hook exclusive to Fastify applications:

- **Activity Log Hook:** Hook in charge of generating and sending activity logs whenever a response is sent.

> It is essential to initialize the request-context module, under the 'request' key, for correct operation.
> Important: This library has .d.ts declaration files so that it can be instantiated from typescript.

## Installation

```sh
npm i -S @darwin-node/middlewares
```

## Unit tests

For unit tests we use [Jest](https://jestjs.io/).

You can try

```sh
npm run test:coverage
```

## How to use it

Next we will see how to use each of the modules separately.

### Common modules for Fastify and GraphQL

The following modules can be applied to an Fastify or GraphQL application. The implementation may differ between them.

The following modules can be applied to an Express or Fastify application. The implementation may differ between them.

#### Request Context

The purpose is to create a context at the level of each incoming request.
Example of how to add it to a Fastify application:

```js
const fastify = require('fastify');
const app = fastify();
const contextService = require('request-context');
const { reqCntxMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { reqCntxMiddleware } from '@darwin-node/middlewares'; // Typescript

// We initialize the request context module.
app.addHook('onRequest', contextService.middleware('request'));
// We add our hook
app.addHook('onRequest', reqCntxMiddleware);
```

> Important: It should be used as the first 'onRequest' hook of the application (microservice).

Example of how to add it in a GraphQL application:

```js
const express = require('express');
const app = express();
const { ApolloServer } = require('apollo-server-express');
const contextService = require('request-context');
const { reqCntxMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { reqCntxMiddleware } from '@darwin-node/middlewares'; // Typescript
// We initialize the request context module.
app.use(contextService.middleware('request'));
// We add our middleware
app.use(reqCntxMiddleware);
apolloServer.applyMiddleware({ app });
```

> This middleware should be used together with the override response middleware.

#### Health Check

Its purpose is to check the status of the service.
Example of how to add it to an GraphQL or Fastify application.

```js
const express = require('express'); // GraphQL app
let app = express(); // GraphQL app
const { ApolloServer } = require('apollo-server-express'); // GraphQL app

const fastify = require('fastify'); // Fastify app
let app = fastify(); // Fastify app

const { healthCheck } = require('@darwin-node/middlewares'); // Javascript
import { healthCheck } from '@darwin-node/middlewares'; // Typescript

app.get('/health', healthCheck);

//only graphql
apolloServer.applyMiddleware({ app });
```

#### Internationalization(I18n) Middleware

It purpose is to provide internationalization support for both Fastify and GraphQL microservice. It
provides features for translating text, interpolating variables into translated strings, and handling pluralization
rules based on the target language.

`Translation`: Supports translating text into multiple international languages, ensuring that the meaning and context are
accurately conveyed across different languages.

`Interpolation`: Manages the insertion of dynamic content within translations, ensuring that variables and placeholders are
correctly replaced with appropriate values in the translated text.

`Pluralization`: Handles the correct use of plural forms in translations, applying language-specific rules to ensure that
singular and plural forms are appropriately used based on the context and quantity.

##### Internationalization(I18n) Configuration

Translation file definitions adhere to the i18next documentation standards. Reference: `https://www.i18next.com/`

Translation file examples:

```bash
/locales/en.json
```

```json
{
  "hi": "Hi",
  "welcome": "Welcome {{name}}!",
  "order": "You have ordered",
  "mail_zero": "You do not have any mail.",
  "mail_one": "You have a new mail.",
  "mail_other": "You have {{count}} new mails."
}
```

```bash
/locales/es.json
```

```json
{
  "hi": "Hola",
  "welcome": "Bienvenido {{name}}!",
  "order": "Has pedido",
  "mail_zero": "No tienes ningun correo.",
  "mail_one": "Tienes un nuevo correo.",
  "mail_other": "Tienes {{count}} nuevos correos."
}
```

Examples to integrate the `i18nMiddleware` feature into Fastify and GraphQL microservices. Once enabled, it will
automatically handle the translation and localization of your application's endpoint based on the preferred language.

!!! info "Important"
    Before the `i18nMiddleware` library is imported and used, the required environment variables must be set appropriately [Environment_Variables](#environment-variables).

Fastify Example:

```js
const fastify = require('fastify');
const app = fastify();
const contextService = require('request-context');
const { i18nMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { i18nMiddleware } from '@darwin-node/middlewares'; // Typescript

app.addHook("onRequest", i18nMiddleware);
```

GraphQL Example:

```js
const express = require('express'); // GraphQL app
let app = express(); // GraphQL app
const { ApolloServer } = require('apollo-server-express'); // GraphQL app
const middleware = require('i18next-http-middleware');

const { i18nMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { i18nMiddleware } from '@darwin-node/middlewares'; // Typescript

app.use(middleware.handle(i18nMiddleware));

ApolloServer.applyMiddleware({app});

```

#### Headers propagation

This piece is in charge of propagating headers in outgoing requests, whether they are HTTP or HTTPS. The client that is used to make the requests is indifferent.
We propagate the following headers by default:
| Header Name            | Header type   | Default behaviour |
| ---------------------- | ------------- | ----------------- |
| organization           | common        | null              |
| accept-language        | common        | null              |
| x-clientid             | common        | null              |
| x-santander-thirdparty | common        | null              |
| x-santander-device     | common        | null              |
| x-santander-channel    | common        | null              |
| mode                   | common        | null              |
| authorization          | security      | Bearer Token      |
| user-agent             | logging       | null              |
| contact-point          | logging       | null              |
| session-id             | logging       | null              |
| app-init               | logging       | null              |
| b3                     | logging (B3)  | Auto-Generated    |
| x-b3-traceid           | logging (B3)  | Auto-Generated    |
| x-b3-spanid            | logging (B3)  | Auto-Generated    |
| x-b3-sampled           | logging (B3)  | Auto-Generated    |
| x-b3-parentSpanId      | logging (B3)  | Auto-Generated    |
| traceparent            | logging (W3C) | Auto-Generated    |
| tracestate             | logging (W3C) | Auto-Generated    |

> For more information on headers and their functionality visit [here](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/24272994492/Enriched+Communication+Policy).

In addition, an array of exclusions is provided, which excludes the propagation of headers at the path level, this array contains objects with the following properties:

- endpoint: Host to exclude, can be excluded **at a general level** <https://www.api.com/api/v1/test/> (Exclude all suffixes ..test/) o a **atomic level** <https://www.api.com/api/v1/test/892122/test.json>
- common: **true** exclude(headers), **false** include(headers)
- logging: **true** exclude(headers), **false** include(headers)
- security: **true** exclude(headers), **false** include(headers)

GraphQL example:

```js
const express = require('express'); // GraphQL app
let app = express(); // GraphQL app
const { ApolloServer } = require('apollo-server-express'); // GraphQL app

const contextService = require('request-context');
const { HeadersPropagation} = require('@darwin-node/middlewares'); // Javascript
const { requestContext } = require('@darwin-node/apollo-plugins'); //Requires library @darwin-node/apollo-plugins
import { HeadersPropagation } from '@darwin-node/middlewares'; // Typescript
import { requestContext } from '@darwin-node/apollo-plugins'; //Requires library @darwin-node/apollo-plugins

// We inizialize the context module of the request.
app.use(contextService.middleware('request'));
// We add our software to generate the context
app.use(requestContext);

const exclude = [{
    endpoint: 'https://nodejs-san-vostok-dev.appls.san01.san.dev.bo1.paas.cloudcenter.corp',
    common: false,
    logging: false,
    security: false
}];
// We create the instance that creates our proxy for outgoing requests
new HeadersPropagation(exclude);

apolloServer.applyMiddleware({ app });
```

> IMPORTANT: if used in a GraphQL app, the use of @darwin-node/apollo-plugins is REQUIRED. Failure to do so will lead to unexpected problems.

Fastify Example:

```js
const fastify = require('fastify');
const app = fastify();
const contextService = require('request-context');
const { HeadersPropagation, reqCntxMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { HeadersPropagation, reqCntxMiddleware } from '@darwin-node/middlewares'; // Typescript

// We inizialize the context module of the request.
app.addHook('onRequest', contextService.middleware('request'));
// We add our software to generate the context
app.addHook('onRequest', reqCntxMiddleware);
//
const exclude = [{
    endpoint: 'https://nodejs-san-vostok-dev.appls.san01.san.dev.bo1.paas.cloudcenter.corp',
    common: false,
    logging: false,
    security: false
}];
// We create the instance that creates our proxy for outgoing requests
new HeadersPropagation(exclude);
```

> By default the common headers are propagated in order to keep the trace of the services.
> Security traces (Bearer {token}) must be activated.

##### B3/W3C headers

B3 and W3C headers are tracing headers. They are used to monitor the flow of a request in a distributed system.

When a request is sent, the following tracing headers are filled:

B3 headers:

- **x-b3-traceid**: The overall id of the trace.
- **x-b3-spanid**: The current trace id. It is generated upon request.
- **x-b3-parentSpanId**: The position of the parent operation in the trace tree.
- **X-b3-sampled**: The sampling state of the trace.
- **B3**: A concatenation of the previous headers: {TraceId}-{SpanId}-{SamplingState}-{ParentSpanId}

W3C headers:

- **traceparent**: A concatenation of the original trace id and the current trace id.
- **tracestate**: Vendor-specific data represented by a set of name/value pairs. It is propagated as is.

##### Extra header propagation

Many times in our applications we have the need to propagate headers in the call to a service. These headers, we can propagate them throughout the layers of our application, which is not highly recommended.
At Darwin we offer the ability to propagate headers to third-party services and also to be able to specify which headers we want to propagate and which we do not, depending on the domain.

We start from the assumption that everything we fill in the context of extra headers is going to be propagated. In order to fill in this context we will do the following. **The object that we are going to save in the context is a Map.**

```js
const contextService = require('request-context'); // we import the request-context library
const extraHeadersMap = contextService.get('request:headers:extra'); // we get the context
extraHeadersMap.set('a', 'a-value');
extraHeadersMap.set('b', 'a-value');
extraHeadersMap.set('c', 'a-value');
contextService.set('request:headers:extra', extraHeadersMap);
```

With the following instructions we have done the following:

- Get the Map object that we have in the context
- Fill in the headers that I want to share KEY-VALUE
- Resave the modified context

From here, whenever we call a third-party service, all the headers that we have saved in this context will be propagated.

> This context is "alive" as long as we do not respond to the client.

###### Exclude propagation of extra headers

The situation can arise in which we want to exclude the 'a' header from spreading to a google service, but we want to maintain the spread of the 'b' and 'c'. In order to offer this feature, we have enabled exclusion by configuration.
To do this, we have enabled the attribute **customHeaders**. We see the following example to exclude the 'A' header from the spread of extra headings.

GraphQL example:

```js
const express = require('express'); // GraphQL app
let app = express(); // GraphQL app
const { ApolloServer } = require('apollo-server-express'); // GraphQL app

const contextService = require('request-context');
const { HeadersPropagation} = require('@darwin-node/middlewares'); // Javascript
const { requestContext } = require('@darwin-node/apollo-plugins'); //Requires library @darwin-node/apollo-plugins
import { HeadersPropagation } from '@darwin-node/middlewares'; // Typescript
import { requestContext } from '@darwin-node/apollo-plugins'; //Requires library @darwin-node/apollo-plugins

// We inizialize the context module of the request.
app.use(contextService.middleware('request'));
// We add our software to generate the context
app.use(requestContext);

const exclude = [{
    endpoint: 'https://google.com',
    customHeaders: ['a'] // We will propagate all the extra headers except for the header 'a'
}];
// We create the instance that our proxy creates for outgoing requests
new HeadersPropagation(exclude);

apolloServer.applyMiddleware({ app });
```

Fastify Example:

```js
const express = require('express');
const app = express();
const contextService = require('request-context');
const { HeadersPropagation, reqCntxMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { HeadersPropagation, reqCntxMiddleware } from '@darwin-node/middlewares'; // Typescript

// We inizialize the context module of the request.
app.addHook('onRequest', contextService.middleware('request'));
// We add our software to generate the context
app.addHook('onRequest', reqCntxMiddleware);
//
const exclude = [{
    endpoint: 'https://google.com',
    customHeaders: ['a'] // We will propagate all the extra headers except for the header 'a'
}];
// We create the instance that creates our proxy for outgoing requests
new HeadersPropagation(exclude);
```

By filling in the **customHeaders** field we can exclude the propagation of the header 'a' for the google service. In this way, we can fill N headers in the context of extra headers and exclude those we deem appropriate.

### Exclusive GraphQL middlewares

The following middleware is exclusive for GraphQL applications

#### Override Response middleware

Its purpose is the observability of the application.
Example of how to add it to our GraphQL application.

```js
const express = require('express');
const app = express();
const { ApolloServer } = require('apollo-server-express'); // GraphQL app
const contextService = require('request-context');
const { overrideResponse } = require('@darwin-node/middlewares'); // Javascript
import { overrideResponse } from '@darwin-node/middlewares'; // Typescript

// We initialize the request context module.
app.use(contextService.middleware('request'));
// We add our middleware
app.use( overrideResponse );

apolloServer.applyMiddleware({ app });
```

> Important: It should be used as the first middleware of the application.

#### Recommendations

The order to use the modules in GraphQL is as follows:

- Initialize the request context module with the key 'request'
- Add the override response middleware
- Add context middleware

> The override response middleware can only be used on GraphQL applications.
> The darwin security module makes use of the request context, to grab the user's token and to propagate headers.

### Exclusive Fastify Hooks

The following middleware is exclusive for Fastify applications

#### Request Context

The purpose is to create a context at the level of each incoming request.

Example of how to add it to a Fastify application:

```js
const fastify = require('fastify');
const app = fastify();
const contextService = require('request-context');
const { reqCntxMiddleware } = require('@darwin-node/middlewares'); // Javascript
import { reqCntxMiddleware } from '@darwin-node/middlewares'; // Typescript

// We initialize the request context module.
app.addHook('onRequest', contextService.middleware('request'));
// We add our hook
app.addHook('onRequest', reqCntxMiddleware);
```

> Important: It should be used as the first 'onRequest' hook of the application (microservice).

#### Activity Log Hook

Its purpose is the observability of the application.
Example of how to add it to our Fastify application.

```js
const fastify = require('fastify');
const contextService = require('request-context');
const { activityLogHook } = require('@darwin-node/middlewares'); // Javascipt
import { activityLogHook } from '@darwin-node/middlewares'; //Typescript

const app = fastify();

app.addHook('onRequest', contextService.middleware('request'));
app.addHook('onResponse', activityLogHook )
```

> Important: It should be used as an 'onResponse' hook to avoid sending activity logs before a response is sent.

#### Recommendation

The order to use the modules in Fastify is as follows:

- Initialize the request context module with the key 'request'
- Add context hook
- Add the activity log hook

> The activity log hook can only be used on Fastify applications.
> The darwin security module makes use of the request context, to grab the user's token and to propagate headers.

### Environment variables

| Key                               | Default                                 | Description                         |
|-----------------------------------|-----------------------------------------| ------------------------------------|
| DARWIN_CORE_HEADERS_XCLIENTID_COMPATIBILITY    | `true`                     | {bool}: Allow to support x-santander-client-id header |
| DARWIN_MIDDLEWARES_I18N           | `false`                                 | Allows to enable i18n feature       |
| DARWIN_MIDDLEWARES_I18N_LOCALES   | `/etc/i18n/locales`                     | Folder with the translations        |
