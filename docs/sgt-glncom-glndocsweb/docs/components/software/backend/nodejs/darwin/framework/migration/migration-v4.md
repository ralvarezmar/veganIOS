# Darwin NodeJS migration to version 4

The new Darwin NodeJS framework version requires some changes moving from the previous version.

## General changes

### NodeJS version

Darwin NodeJS no longer supports NodeJS v14.
To develop and maintain your microservice, an update towards NodeJS v16 or NodeJS v18 is required. You can update your local NodeJS version following [this guide](../../../../../../../getting-started/setup-your-environment/technologies/javascript-node.md).

To update the version in a deployed microservice, you will have to redeploy with the following changes:

- In the file **/.chart/values.yaml**, you must change the darwin version to 4.0.0, and the technologyVersion to 18:

```yaml
darwin:
  version: "4.0.0"
  technologyVersion: "18"
```

- In **/Dockerfile**, the registry must be changed to fetch the NodeJS 18 image and remove the ``--verbose`` argument from thg npm install command:

```dockerfile
FROM registry.global.ccc.srvb.bo.paas.cloudcenter.corp/produban/nodejs-18-ubi8:1.1.5.RELEASE

# other code

RUN npm install

# more code
```

- In **/properties.yaml**, replace the helm version from ``2.0.1``, the project to ``gluon-alm`` and the host to ``registry.global.ccc.srvb.can.paas.cloudcenter.corp``:

```yaml
helm:
    host: registry.global.ccc.srvb.can.paas.cloudcenter.corp
    project: gluon-alm
    chart:  micro-nodejs
    version: 2.0.1
```

- Update the ``NODE_VERSION`` in **/env/properties.env**:

```env
NODE_VERSION='18.18.2'
```

- Update ```nodejs``` in **/.tools-version**:

```bash
nodejs 18.18.2
```

### Compatibility with previous Darwin v3

One of the biggest changes Darwin version 4 brings is upgrading [Apollo](https://www.apollographql.com/) to version 4.
This change does not interfere with your Fastify microservices' logic directly, but it does interact with previous versions of the Darwin modules. Therefore **Darwin v4 modules are incompatible with Darwin v3**.

The incompatibility with previous versions means that updating the modules will have to be done simultaneously.
We'll show how to do it in the relevant sections.

!!! warning "Unsupported Darwin Libraries"

    Darwin Kafka, Darwin Datagrid and Darwin Config-Service support has been dropped from the framework.
    They have have **not** been upgraded to version 4 and must be uninstalled.

### Express microservices

In the past, Darwin supported Express microservices. With the release of Darwin NodeJS version 3, these microservices were deprecated, and we encouraged the migration towards Fastify.

Darwin NodeJS version 4 pulled out Express support. If your microsevice has yet to migrate to Fastify, follow [this steps](./express-to-fastify-migration.md) before migrating to Darwin version 4.

### Fastify microservices

Minimal changes are required to migrate from Darwin v3 to darwin v4.

#### Step 1: Uninstalling Modules

First, you'll have to uninstall all Darwin modules installed in your microservice. You can check which ones your microservice uses in the 'package.json' file:

```json
 "dependencies": {
    "@darwin-node/composer": "^3.0.4",
    "@darwin-node/error": "^3.0.3",
    "@darwin-node/logger": "^3.0.1",
    "other libraries": "..."
 }
```

Once you know which libraries your microservice uses, you will have to uninstall them by running the following command:

```bash
npm uninstall [your libraries]
```

Following the example:

```bash
npm uninstall @darwin-node/composer @darwin-node/error @darwin-node/logger
```

#### Step 2: Removal of kafka-node

After uninstalling the Darwin modules, you should delete all kafka-node references in testing **if your microservice does not use the library explicitly**.
For example, microservices generated in Gluon with Darwin version v3 will reference kafka-node in its mocks for testing, in its 'global.mocks.js' file:

```js
// some mocks
jest.mock('kafka-node');
//some other mocks
```

In the case of newly-generated microservices in Gluon with Darwin v3, eliminating that single line of code will do.

??? info "Why this step?"
    In Darwin v3, generated microservices mocked 'kafka-node' by default during tests.
    In Darwin v4, '@darwin-node/logger' no longer depends on 'kafka-node' to send logs to the ELK circuit.
    Mocking a non-installed library will yield errors during testing.

#### Step 3: Installing Modules

It is time to install the new Darwin version.

First, you'll have to add the following line to the '.npmrc' file:

```bash
@darwin-node:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases
```

Take note of the libraries you uninstalled in [step 1](#step-1-uninstalling-modules), and install them again with the following command:

```bash
npm install [your libraries@4.0.0]
```

Using the example in [step 1](#step-1-uninstalling-modules);

```bash
npm install @darwin-node/composer@4.0.0 @darwin-node/error@4.0.0 @darwin-node/logger@4.0.0
```

### GraphQL microservices

Minimal changes are required to migrate from Darwin v3 to darwin v4.

#### Step 1: Uninstalling Modules

First, you'll have to uninstall all Darwin modules installed in your microservice and the libraries 'apollo-server-express' and 'type-graphql'.
You can check which ones your microservice uses in the 'package.json' file:

```json
 "dependencies": {
    "@darwin-node/composer": "^3.0.4",
    "@darwin-node/error": "^3.0.3",
    "@darwin-node/logger": "^3.0.1",
    "apollo-server-express": "^3.13.0",
    "type-graphql": "^1.1.1",
    "other libraries": "..."
 }
```

Once you know which libraries your microservice uses, you will have to uninstall them by running the following command:

```bash
npm uninstall [your libraries]
```

Following the example:

```bash
npm uninstall @darwin-node/composer @darwin-node/error @darwin-node/logger apollo-server-express type-graphql
```

#### Step 2: Installing Modules

It is time to install the new Darwin version.

First, you'll have to add the following line to the '.npmrc' file:

```bash
@darwin-node:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases
```

Take note of the libraries you uninstalled in [step 1](#step-1-uninstalling-modules), and install them again with the following command:

```bash
npm install [your libraries@4.0.0]
```

Using the example in [step 1](#step-1-uninstalling-modules);

```bash
npm install @darwin-node/composer@4.0.0 @darwin-node/error@4.0.0 @darwin-node/logger@4.0.0
```

You will also have to install the following libraries:

- '@apollo/server': This library is the new version of 'apollo-server-express'

```bash
npm install @apollo/server
```

- 'type-graphql' beta version: Upgrading to the new version of apollo also upgrades Graphql to version 16, which the current 'type-graphql' version (1.1.1) does not support.
The beta version is stable.

```bash
npm install type-graphql@2.0.0-beta.6
```

#### Step 3: Code refactoring

With the relevant modules installed, we'll move to the code migration.

We have to change all 'apollo-server-express' references into the corresponding '@apollo', as indicated in [Apollo's documentation](https://www.apollographql.com/docs/apollo-server/migration/).

As an example, we'll use a newly-generated microservice that uses Darwin v3, and we will migrate its code to Darwin v4.

Let's take a look at the file 'src/server/index.ts' in Darwin v3:

```ts
import 'reflect-metadata';
import { DarwinOptions, generateGraphqlApp } from '@darwin-node/composer';
import { Config, ExpressContext } from 'apollo-server-express'; //(1)
import express from 'express';
import { techLog } from '@darwin-node/logger';
import { setRequestInfo } from '@darwin-node/apollo-plugins'; //(2)
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';

export async function bootstrap (opts: DarwinOptions) {
  const app = express();
  const graphqlSchemaSource = new GraphQlSchemaSource();
  const schema = await graphqlSchemaSource.getSchema(opts);
  const apolloServerConfig: Config<ExpressContext> = {
    schema,
    context: ({ req }) => setRequestInfo({}, req) //(2)
  };

  try {
    await generateGraphqlApp(app, apolloServerConfig, opts);

    const port = 8080;

    await app.listen(port, () => {
      techLog.info(`Server listening on http://localhost:${port}`);
    });
  } catch (err) {
    techLog.error(`Error initializing application: ${err.message}`);
  }
}
```

We've commented the following changes necessary to migrate:

1. We'll change 'apollo-server-express' references into the corresponding '@apollo' terms
2. The context configuration has been moved to Darwin Composer, so we'll have to remove it from this file.

```ts
import 'reflect-metadata';
import { DarwinOptions, generateGraphqlApp } from '@darwin-node/composer';
import { ApolloServerOptions, BaseContext } from '@apollo/server'; //(1)
import express from 'express';
import { techLog } from '@darwin-node/logger';
import { GraphQlSchemaSource } from '../tools/graphql.schema.source';

export async function bootstrap (opts: DarwinOptions) {
  const app = express();
  const graphqlSchemaSource = new GraphQlSchemaSource();
  const schema = await graphqlSchemaSource.getSchema(opts);
  const apolloServerConfig: ApolloServerOptions<BaseContext> = {
    schema //(2)
  };

  try {
    await generateGraphqlApp(app, apolloServerConfig, opts);

    const port = 8080;

    await app.listen(port, () => {
      techLog.info(`Server listening on http://localhost:${port}`);
    });
  } catch (err) {
    techLog.error(`Error initializing application: ${err.message}`);
  }
}
```

Other files may need changes. For example, the default 'tools/graphql.schema.source.ts' with Darwin v3 used absolute paths to format its resolvers into schemas:

```ts
export class GraphQlSchemaSource {
  schema: GraphQLSchema;

  /**
   * Build schema dinamically from
   * application resolvers
   *
   * @returns {GraphQLSchema}
   * @memberof GraphQlSchemaSource
   */
  async getSchema (opts: DarwinOptions) {
    this.schema = await buildSchema({
      resolvers: [join(__dirname, '../modules/**/*.resolver.{ts,js}')], // Array of absolute paths
      authChecker: async (reqCtx) => bearerTokenCheck(reqCtx, opts, true),
      // Don't forget disable emitSchemaFile before to deploy a container in openshift
      emitSchemaFile: false
    });
    return this.schema;
  }
}
```

In Darwin v4, and using 'type-graphql' beta version, the resolvers must be imported directly:

```ts
import { CommentsResolver } from '../modules/comments/resolvers/comments.resolver';

export class GraphQlSchemaSource {
  schema: GraphQLSchema;

  /**
   * Build schema dinamically from
   * application resolvers
   *
   * @returns {GraphQLSchema}
   * @memberof GraphQlSchemaSource
   */
  async getSchema (opts: DarwinOptions) {
    this.schema = await buildSchema({
      resolvers: [CommentsResolver],
      authChecker: async (reqCtx) => bearerTokenCheck(reqCtx, opts, true),
      // Don't forget disable emitSchemaFile before to deploy a container in openshift
      emitSchemaFile: false
    });
    return this.schema;
  }
}
```

For tests, similarly to the 'server/index.ts' file, replace any referwnce of 'apollo-server-express' with its corresponding '@apollo/server', as indicated in the  [Apollo documentation](https://www.apollographql.com/docs/apollo-server/migration/).

### Other changes

Depending on your specific microservice, further changes may be required.
Most of these other changes are related to the configuration of environment variables in your microservice.

For example, in Darwin v4, logs are no longer sent to the ELK circuit by default. They are printed raw in the terminal console.
To keep the original behaviour, several environment variables must be configured, such as:

- DARWIN_LOGGING_TRANSPORT
- DARWIN_LOGGING_FORMAT
- DARWIN_LOGGING_KERBEROS_AUTHENTICATION
- DARWIN_LOGGING_KAFKA_USERNAME
- DARWIN_LOGGING_KAFKA_PASSWORD

These changes are specific to the intended behaviour of any specific microservice, and go on a case-by-case pattern.
For more information, check the [Documentation](../index.md).
