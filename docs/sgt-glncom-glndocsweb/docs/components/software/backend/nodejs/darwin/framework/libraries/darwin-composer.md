
# DARWIN COMPOSER

## Summary

**Darwin Composer** is a library designed for the composition of NodeJs applications. The purpose is to provide to the applications of the **Darwin Framework** with everything necessary for their operation within our ecosystem.
Because the order of insertion of middlewares and hooks is essential, this library is in charge of this. For this purpose, this library is based on a configuration file in which we indicate which framework libraries and features we will use.

This library ships two types of application composition:

- **Fastify**: The Fastify generator is in charge of composing REST APIs under Fastify.
- **GraphQL**: The GraphQL generator is in charge of composing GraphQL APIs under Express. When you use this generator, an environment variable "DARWIN_IS_GRAPHQL" is populated.

!!! info "Important"
    This library has .d.ts declaration files so that it can be implemented from typescript.

## How to install

```sh
npm i -S @darwin-node/compositor
```

## Unit tests

For unit tests we use [Jest](https://jestjs.io/). You can try:

```sh
npm run test:coverage
```

## How it works

Darwin Composer exposes two generators:

- GraphQL generator (under Express)
- Fastify generator

### GraphQL Example

This example is intended for typescript applications.

```js
import 'reflect-metadata';
import { generateGraphQLApp } from '@darwin-node/composer';
import { ApolloServerOptions, BaseContext } from '@apollo/server';
import express from 'express';
import { techLog } from '@darwin-node/logger';
// This options file has been explained above
import opts from '../config/darwin.config';
// We need a schema for our GraphQL Server.
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';

(async () => {
  const app = express();

  // schema generation using type-graphql (recommended)
  const graphqlSchemaSource = new GraphQlSchemaSource();
  const schema = await graphqlSchemaSource.getSchema();

  // You can add context, plugins and another type of Apollo Server instance config available.
  const apolloServerConfig: ApolloServerOptions<BaseContext> = {
    schema
  };

  await generateGraphQLApp(app, apolloServerConfig, opts);

  const port = opts.server.port;

  app.listen(port, () => {
    techLog.info(`Server listening on http://localhost:${port}`);
  });
})();
```

### Fastify example

```js
const fastify = require('fastify');
let app = fastify();
const { techLog } = require('@darwin-node/logger');
const { generateFastifyApp } = require('@darwin-node/composer');
const routes = require('../routes'); // own routes of our app
const darwinConfig = require('./config'); // configuration
/*
HERE WE CAN USE ANY OF THE NECESSARY SOFTWARE PLUGINS FOR THE APPLICATION.
FOR EXAMPLE: The option to upload files.
const plugin = require('some-fastify-plugin');
app.register(plugin());
*/
app = generateFastifyApp(app, routes, darwinConfig); // a fastify application returns to us
const port = 3000;

app.listen({ port }, () => {
  techLog.info(`Application listen in port: ${port}`);
});
```

## Recommendations

!!! info "Important"
    For the proper functioning of micro-services it is essential to use the module to make up our app. This is because the order of use of the modules is very important.

## Darwin Configuration Parameters

The application to be generated can be configured by passing a darwinConfig Object, containing the following parameters:

| Name                        | Description                                          | Default Value   |
| --------------------------- | -----------------------------------------------------| --------------- |
| `security`                  | Configuration for security middleware                | `{}`            |
| `security.exclude`          | Array of routes excluded from security checks        | `[]`            |
| `security.headers`          | Configuration for header propagation                 | `{}`            |
| `security.headers.enable`   | Enable or disable header propagation                 | `false`         |
| `security.headers.exclude`  | Array of routes excluded from header propagation     | `[]`            |
| `apiSpecification`          | Configuration for documentation route                | `{}`            |
| `apiSpecification.enable`   | Enable or disable documentation route                | `false`         |
| `bodyParsers`               | Adds support to urlencoded and json bodies           | `{}`            |
| `bodyParsers.enable`        | Enable or disable body parser middleware             | `false`         |
| `gracefulShutdown`          | Adds graceful shutdown to running microservice       | `{}`            |
| `gracefulShutdown.enable`   | Enable or disable graceful shutdown                  | `false`         |
| `gracefulShutdown.options`  | Graceful shutdown [options](https://github.com/sebhildebrandt/http-graceful-shutdown/blob/master/README.md#options) | `{}`            |
| `helmet`                    | Sets various HTTP security headers                   | `{}`            |
| `helmet.enable`             | Enable or disable security headers                   | `true`          |
| `hpp`                       | Prevents HTTP parameter pollution                    | `{}`            |
| `hpp.enable`                | Enable or disable HTTP parameter pollution prevention| `true`          |

### Example

```js
const prefix = '/api/poc';
module.exports = {
  bodyParsers: {
    enable: true
  },
  hpp: {
    enable: true
  },
  helmet: {
    enable: true
  },
  security: { // this level indicates which module use
    exclude: [ // we can exclude some endpoint to the security verification
      `${prefix}/cats/:catId([0-9]{6})`, // example
      `${prefix}/public/mapping/string/only`, // example
      /\/api\/poc\/domain\/.*\/cancel/, // example
      { path: `${prefix}/only/put`, method: 'PUT' } // example
    ],
    headers: {
      propagation: true,
      exclude: [{ // we can exclude header propagation
        endpoint: 'http://127.0.0.1:3001',
        common: false,
        logging: false,
        security: false,
        customHeaders: ['a'] // Whose headers you dont want to propagate from Extra headers context
      }]
    }
  },
  gracefulShutdown: {
    enable: true,
    options: {
      timeout: 30000
    }
  },
  healthEndpoint: {
    enable: true
  },
  apiSpecification: {
    enable: true
  }
};
```

We have identified problems in the [```increase in PODS production```](https://sanes.atlassian.net/browse/ESPNUARMIC-3064).
To solve this, we have enabled the option of fatty shutdown, enabled by default. When we are replacing the previous version of our application,
we have to stop our current application by sending a ```SIGTERM``` signal to the application to notify it that it will be removed.
Once the application receives this signal, it should stop accepting new requests, terminate all ongoing requests, clean up the resources it used, including database connections and file locks, and then exit.
For the implementation of this feature, we have used the following library [```http://graceful-shutdown```](https://www.npmjs.com/package/graceful-shutdown).
In addition, we can enable two configurations for the keep-alive-time of the http clients. The configurations are enabled by following this [article](https://shuheikagawa.com/blog/2019/04/25/keep-alive-timeout/).

## Environment variables

| Key                                             | Default Value                  | Type       | Description                                          |
|-------------------------------------------------|--------------------------------|------------|------------------------------------------------------|
| DARWIN_GRACEFUL_SHUTDOWN_TIMEOUT                | `120000`                       | Number     | Grace time from SIGTERM signal until actual shutdown |
| DARWIN_CORE_WEBCLIENT_MAX_LIFE_TIME             | `60000`                        | Number     | Maximum lifetime for an HTTP Client                  |
| DARWIN_CORE_HEADERS_XCLIENTID_COMPATIBILITY     | `true`                         | Boolean    | Allow to support x-santander-client-id header        |
| DARWIN_MIDDLEWARES_I18N                         | `false`                        | Boolean    | Enables i18n feature                                 |
| DARWIN_MIDDLEWARES_I18N_LOCALES                 | `/etc/i18n/locales`            | String     | Folder with the translations                         |
| DARWIN_SECURITY_KEYCACHE_ENABLE                 | `true`                         | Boolean    | Enables cache generation for the key that validates JWT tokens |
| DARWIN_SECURITY_KEYCACHE_EXPIRATION             | `36000`                        | Number     | Milliseconds until cache expires                     |
| DARWIN_SECURITY_KEYCACHE_CHECK_PERIOD           | `300`                          | Number     | Milliseconds for checking cache frequency            |
| DARWIN_SECURITY_HEAD_PROPAGATION                | `false`                        | Boolean    | Enables/disables the propagation of security headers |
| DARWIN_SECURITY_AUTH_SERVER                     | `false`                        | Boolean    | Enables token validation through JWK                 |
| DARWIN_SECURITY_PKM_ENDPOINT                    | `<https://srvnuarintra.santander.dev.corp/pkm/v1/publicKey/>` | String | Url for PKM authorization |
| DARWIN_SECURITY_JKU_ENDPOINT                    | `<https://pkm6-sanes-serco1-dev.apps.san01bks.san.dev.bo1.paas.cloudcenter.corp/discovery/v1/keys>` | String | Url for JWKs endpoint |
| DARWIN_CORE_EXCEPTIONS_ERROR_FORMAT             | `DARWIN`                       | String     | Allowed ['DARWIN', 'GLUON']. It allows to change the error format. It is only allowed in Express and Fastify applications |
| PROJECT_NAME                                    | `UNSPECIFIED_PROJECT_NAME`     | String     | Project name                                         |
| DARWIN_LOGGER_ENTITY                            | `ESP`                          | String     | Application Entity                                   |
| APP_NAME                                        | `UNSPECIFIED_APP_NAME`         | String     | Cluster application name                             |
| NODE_ENV                                        | `CERT`                         | String     | Defines the environment (`TEST, CERT, PRE, PRO`) for Python applications |
| HOSTNAME                                        | `NODEJS`                       | String     | Cluster application name                             |
| REGION                                          | `NODEJS`                       | String     | Cluster region                                       |
| DARWIN_LOGGING_KAFKA_HOST                       | None                           | Array      | Kafka host                                           |
| DARWIN_LOGGING_KAFKA_UNIQUE_TOPIC               | `nuar-mrsv-log`                | String     | Enable unique topic for each application.            |
| DARWIN_LOGGING_TRANSPORT                        | `KAFKA`                        | String     | Transport type (`KAFKA, CONSOLE`).                   |
| DARWIN_LOGGING_FORMAT                           | `GLOBAL`                       | String     | Log format (`GLOBAL, GLUON`).                        |
| DARWIN_LOGGING_KAFKA_SSL                        | `true`                         | Boolean    | Enable SSL for Kafka transport.                      |
| DARWIN_LOGGING_KAFKA_TIMEOUT                    | `30000`                        | Number     | Timeout for Kafka transport.                         |
| DARWIN_LOGGING_KAFKA_USERNAME                   | None                           | String     | Kerberos username.                                   |
| DARWIN_LOGGING_KAFKA_PASSWORD                   | None                           | String     | Kerberos password.                                   |
| DARWIN_LOGGING_COMPANY                          | `ERROR_COMPANY_NOT_DEFINED`    | String     | Maps to the company code in Gluon.                   |
| DARWIN_LOGGING_COMPANY_COMPONENT_NAME           | `ERROR_COMPONENT_NAME_NOT_DEFINED` | String | Maps to the short-name of the component in Gluon.    |
| DARWIN_LOGGING_COMPANY_COMPONENT_ID             | `DARWIN_LOGGING_COMPANY_COMPONENT_ID` | String | Maps to the ID of the component in Gluon.         |
| DARWIN_LOGGING_COMPANY_COMPONENT_TYPE           | `DARWIN_LOGGING_COMPANY_COMPONENT_TYPE` | String | Maps to the component type in Gluon.            |
| DARWIN_LOGGING_COMPANY_APP_NAME                 | `DARWIN_LOGGING_COMPANY_APP_NAME` | String     | Maps to technical application in Gluon.           |
| DARWIN_LOGGING_APP_ID                           | `DARWIN_LOGGING_APP_ID`       | String     | Maps to the technical application ID in Gluon.        |
