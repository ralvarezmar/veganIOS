
# Apollo Server plugins

## Summary

**Library in charge of containing various Apollo Server plugins which are used by Darwin NodeJS Framework.**

It contains a plugin at this moment:

- **Request Context:** This plugin populates activity log information with GraphQL request related information.

## Installation

```sh
npm i -S @darwin-node/apollo-plugins
```

## Unit tests

For unit tests we use [Jest](https://jestjs.io/).

You can try

```sh
npm run test:coverage
```

## How to use it

Next we will see how to use each of the modules separately. **It is very important to note that these intermediates are developed for Express**

### Request Context plugin

This plugin should be added to apollo plugins array as follows:

```js
const { ApolloServer } = require('@apollo/server');
const { requestContext } = require('darwin-node/apollo-plugins');
const schema = require('./app.schema');
const contextService = require('request-context');

apolloPlugins = [ requestContext ];

const apolloServer = new ApolloServer({
  plugins: apolloPlugins
});

/* server start up code */
```

> This plugin must be used with the library'request-context'.

### Set Request Info in context

This plugin allow add to graphql request context data request method and headers. It can be used in resolvers or apollo security checks. setRequestInfo method has two parameters, one is the context and the another is the request object.

```js
import { ApolloServer } from '@apollo/server';
import { setRequestInfo } from '@darwin-node/apollo-plugins';
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';
import express from 'express';
import contextService from 'request-context';
import { reqCntxMiddleware } from '@darwin-node/middlewares'

export async function bootstrap () {
  const apolloServer = new ApolloServer();
  const app = express();
  await apolloServer.start();
  
  app.use(contextService.middleware('request'));
  app.use(reqCntxMiddleware);
  app.use(
    '/graphql',
    express.json(),
    expressMiddleware(apolloServer, {
      context: ({ req }) => setRequestInfo({}, req)
    })
  );
}

```

> This plugin must be used with the libraries '@darwin-node/middlewares' and 'request-context'.

#### Configure Internationalization(i18n) support

To enable internationalization (i18n) within the Apollo Server requests, set the environment variable `DARWIN_MIDDLEWARES_I18N` to true. When enabled, the i18n object and functionalities are automatically included in the request context.

### Bearer Token Check

This plugin add bearer token check to resolvers are using @Authorized decorator. The bearerTokenCheck has three parameters:

- RequestContext
- DarwinOptions opts
- Boolean to add user data into context after check permissions.

```js
import { buildSchema } from 'type-graphql';
import { join } from 'path';
import { GraphQLSchema } from 'graphql';
import { DarwinOptions } from '@darwin-node/composer';
import { bearerTokenCheck } from '@darwin-node/apollo-plugins';

export class GraphQlSchemaSource {
  schema: GraphQLSchema;

  async getSchema (opts: DarwinOptions) {
    this.schema = await buildSchema({
      resolvers: [join(__dirname, '../modules/**/*.resolver.{ts,js}')],
      authChecker: async (reqCtx) => bearerTokenCheck(reqCtx, opts, true),
    });
    return this.schema;
  }
}

```

> This plugin must be used with the library 'type-graphql'
