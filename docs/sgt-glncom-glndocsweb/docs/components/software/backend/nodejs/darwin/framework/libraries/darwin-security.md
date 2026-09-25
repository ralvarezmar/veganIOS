
# Darwin Security

## Summary

**Darwin security** is a library designed for the security of micro services under NodeJs.
The functionality of this library is:

- Verify the authenticity of the jwt token provided by the client.
- Securing the application endpoints at the route and method level.

For its configuration we must pass a json with the following attributes:

```js
const config = {
  exclude: [],
  keyCache: {
    enable: true
  },
  headers: {
    propagation: true
  },
  keyProviderType: {
    remote: {
      url: 'some PKM endpoint'
    },
    jku: {
      enable: true,
      url: 'some JWKs endpoint'
    }
  }
};
```

| Attribute | Definition | Default value | [Environment value](#environment-variables) |
|-----------|------------|---------------|---------------------------------------------|
| exclude   | An array with the routes that we want to release from security (whitelist) and they can be of 3 types: **string** ("/authentication/white"), **RegExp** ( \/api\/poc\/domain\/.*\/cancel/) or **route and method** ({ path: `/only/allow/put`, method: 'PUT' }) | Empty Array | -- |
| keyCache.enable | Enables cache generation for the key that validates JWT tokens | true | DARWIN_SECURITY_KEYCACHE_ENABLE |
| keyCache.expiration  | Milliseconds until cache expires | 36000 | DARWIN_SECURITY_KEYCACHE_EXPIRATION |
| keyCache.checkPeriod | Milliseconds for checking cache frequency | 300 | DARWIN_SECURITY_KEYCACHE_CHECK_PERIOD |
| headers.propagation        | Enables/disables the propagation of security headers. | false | DARWIN_SECURITY_HEAD_PROPAGATION |
| keyProvider.authorizationServer     | Enables token validation through JWK | false | DARWIN_SECURITY_AUTH_SERVER |
| keyProviderType.remote.url | Url for PKM authorization | `https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/` | DARWIN_SECURITY_PKM_ENDPOINT |
| keyProvider.jku.url    | Url for JWKs endpoint                | `https://pkm6-sanes-serco1-dev.apps.san01bks.san.dev.bo1.paas.cloudcenter.corp/discovery/v1/keys` | DARWIN_SECURITY_JKU_ENDPOINT |

To understand how to define and make routes, in addition to the possible options, you have to look at [here](https://www.kevinleary.net/regex-route-express/)

> It is essential to initialize the request-context module, under the 'request' key, for correct operation.
> Important: This library has .d.ts declaration files so that it can be instantiated from typescript.

### Authorization Server and Public Key Manager

This module secures Darwin microservices through the use of JSON Web Tokens (JWT). These tokens are sent to the microservice through the request's headers, and this module decodes them and validates them through an external service.

By default, this external service is a **Public Key Manager** (PKM). Upon receiving a request, the microservice sends the will call the PKM and validate the token with the received data from the PKM.

Through configuration and/or [environment variables](#environment-variables), the microservice can use an **Authorization server** (JKU / JWKS).
This way, the microservice will call the JKU periodically, to update an internal list of all the keys that can validate a given JWT. This periodicity is given by the cache expiration time.

## Installation

```sh
npm i -S @darwin-node/security
```

## Unit tests

For unit tests we use [Jest](https://jestjs.io/).

```sh
npm run test:coverage
```

## How to use it

Examples of how to add it to our application. We assume that we will generate a general configuration and use the library **@darwin-node/composer** to generate an application, for that reason we see the **security** attribute in our example.
If we don't use **@darwin-node/composer** we remove the attribute **security**

### GraphQL examples

The following example shows how to use our library with **darwin-node/composer**.

```js
import { generateGraphQLApp } from '@darwin-node/composer'; // Typescript
import { ApolloServerOptions, BaseContext } from '@apollo/server';
import express from 'express';
import { techLog } from '@darwin-node/logger';
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';

const port = 8080;

// Darwin security configuration
const config = {
  security: { // attribute used by '@darwin-node/composer'.
    enable: true,
    exclude: [
      `${prefix}/public/mapping/string/only`,
      /\/api\/poc\/domain\/.*\/cancel/,
      { path: `${prefix}/only/put`, method: 'PUT' }
    ],
     keyCache: {
      enable: true
    }
  }
};


(async () => {
  const app = express();
  const graphqlSchemaSource = new GraphQlSchemaSource();
  const schema = await graphqlSchemaSource.getSchema();

  // You can add context, plugins and another type of Apollo Server instance config available.
  const apolloServerConfig: ApolloServerOptions<BaseContext> = {
    schema
  };

  await generateGraphQLApp(app, apolloServerConfig, config);

  app.listen(port, () => {
    techLog.info(`Server listening on http://localhost:${port}`);
  });
})();
```

The following example is how to use our library without using **darwin-node/composer**.

```js
import contextService from 'request-context';
import express from 'express';
import { techLog } from '@darwin-node/logger';
import { ApoloServer, ApolloServerOptions, BaseContext } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { middleware, init } from '@darwin-node/security';
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';
import get from 'lodash/get';


const port = 8080;

// Darwin security configuration
const config =  {
    enable: true,
    exclude: [
      `${prefix}/public/mapping/string/only`,
      /\/api\/poc\/domain\/.*\/cancel/,
      { path: `${prefix}/only/get`, method: 'GET' }
    ],
     keyCache: {
      enable: true
    }
};


(async () => {
  const app = express();
  const graphqlSchemaSource = new GraphQlSchemaSource();
  const schema = await graphqlSchemaSource.getSchema();

  // You can add context, plugins and another type of Apollo Server instance config available.
  const apolloServerConfig: Config<ExpressContext> = {
    schema
  };

  // required dependency middleware
  app.use(contextService.middleware('request'));
  
  security.init(config);
  app.use(security.middleware);

  const apolloServer = new ApolloServer(apolloServerConfig);
  await apolloServer.start();

  app.use(
    '/graphql',
    express.json(),
    expressMiddleware(apolloServer, {})
  );

  app.listen(port, () => {
    techLog.info(`Server listening on http://localhost:${port}`);
  });
})();
```

### Fastify examples

Similarly, we can apply the middleware (as a hook!) in a fastify app, with the **darwin-node/composer** or not

**darwin-node/composer** version:

```js
// we create a configuration
const config = {
  security: { // attribute that tells to '@darwin-node/composer'.
    enable: true,
    exclude: [
      `${prefix}/public/mapping/string/only`,
      /\/api\/poc\/domain\/.*\/cancel/,
      { path: `${prefix}/only/put`, method: 'PUT' }
    ],
     keyCache: {
      enable: true
    }
  }
};
const { generateFastifyApp } = require('@darwin-node/composer'); // Javascript
import { generateFastifyApp } from '@darwin-node/composer'; // Typescript

const fastify = require('fastify');
let app = fastify();
const routes = require('../routes'); // the routes of our app
app = generateExpressApp(app, routes, config);
const port = 8080;

app.listen({ port }, async () => {
  techLog.info(`Application listen in port: testing kibana ${port}`);
});
```

Without **darwin-node/composer**:

```js
const fastify = require('fastify');
const contextService = require('request-context');
const app = fastify();
const security = require('@darwin-node/security'); // Javascript
import security from '@darwin-node/security'; // Typescript

app.addHook('onRequest', contextService.middleware('request'));

const prefix = '/api';

const config = {
  enable: true,
  exclude: [
    `${prefix}/public/mapping/string/only`,
    /\/api\/poc\/domain\/.*\/cancel/,
    { path: `${prefix}/only/put`, method: 'PUT' }
  ],
    keyCache: {
    enable: true
  }
};
security.init(config);
app.addHook('onRequest', security.hook);
```

### Recommendations in case of using the module by itself

Recommendations if we use the module by itself.
The order to follow to use the modules is as follows:

- Initialize the request context library with the key 'request'.
- Add the override response middleware (GraphQL) / activity log hook (Fastify).
- Add context middleware/hook.
- Add security middleware/hook.

> Use '@darwin-node/middlewares' with this module to enable header propagation functionality
> Important: It must be used before use the routes of our application (microservice).
> The darwin security module makes use of the request context, to grab the user's token.

## Environment Variables

| Variable                                | Definition                                                         | Default value |
|-----------------------------------------|--------------------------------------------------------------------|---------------|
| DARWIN_SECURITY_KEYCACHE_ENABLE         | Enables cache generation for the key that validates JWT tokens     | true          |
| DARWIN_SECURITY_KEYCACHE_EXPIRATION     | Milliseconds until cache expires                                   | 36000         |
| DARWIN_SECURITY_KEYCACHE_CHECK_PERIOD   | Milliseconds for checking cache frequency                          | 300           |
| DARWIN_SECURITY_HEAD_PROPAGATION        | Enables/disables the propagation of security headers.              | false         |
| DARWIN_SECURITY_AUTH_SERVER             | Enables token validation through JWK                               | false         |
| DARWIN_SECURITY_PKM_ENDPOINT            | Url for PKM authorization                                          | '<https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/>' |
| DARWIN_SECURITY_JKU_ENDPOINT            | Url for JWKs endpoint                                              | '<https://pkm6-sanes-serco1-dev.apps.san01bks.san.dev.bo1.paas.cloudcenter.corp/discovery/v1/keys>' |
