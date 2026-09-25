# Express to Fastify Migration

## Summary

The Darwin NodeJS Framework brings you the option to use Fastify instead of Express for your microservices.
This article is a step-by-step guide to migrate a Darwin Express microservice to Darwin Fastify.

??? warning "GraphQL and Fastify Compatibility"

      GraphQL microservices are not supported in Fastify yet.

## Updating the modules

Before you do anything, you have to make sure the darwin module you are using is up to date. You can check the current darwin version. To do so In your microservice directory, through command line, run:

```bash
npm version @darwin-node/composer
```

If your version is lower than **3.0.0**, run the command:

```bash
npm install @darwin-node/composer@^3.0.0
```

Now, the module should be up to date.

Other modules should be updated in the same fashion:

```bash
npm version @darwin-node/logger
```

```bash
npm install @darwin-node/logger@^3.0.0
```

## Replacing Express with Fastify

A correct Darwin Express implementation uses Express Routers to wrap their routes. An Express router looks like this:

```js
// routers.js

const express = require('express');
const { preHandlerLogic } = require('someDependency');
const { businessLogic } = require('./logic')

// Contained router
const routerEndpoint = express.Router();
routerEndpoint.route('/logic1')
  .post(
    preHandlerLogic,
    businessLogic
  );

// Container router
const router = express.Router();

// Prefixed route
router.use('/prefix', routerEndpoint);

//No prefix route
router.get('/logic2', (req, res) => {
  /* Some Logic */
  res.send(/* something */)
})

//No prefix route
router.get('/logic3', (req, res) => {
  /* Some Logic */
  res.status(/* some status code */).json(/* some json */)
})

/**
 * @returns module functions.
 */
module.exports = router;
```

The file above, “routers.js” exposes two routes, the prefixed route ‘/prefix/logic1’ and ‘/logic2’. These routes are wrapped in a router that will be later passed to the Darwin Composer, like this:

```js
// index.js

const express = require('express');
let app = express();
const { techLog } = require('@darwin-node/logger');
const { generateExpressApp } = require('@darwin-node/composer');
const routes = require('./routers.js'); // own routes of our app
const darwinConfig = require('./config'); // Your darwin configuration

app = generateExpressApp(app, routes, darwinConfig); // How we plug our routes
const port = 3000;

app.listen(port, () => {
  techLog.info(`Application listen in port: ${port}`);
});
```

As we can see, the ‘index.js’ are passed to the function ‘generateExpressApp’. This function composes the Express App by adding the Darwin middlewares and routes following the Configuration (more on that later).

Now, back to the ‘routers.js' file. Let’s remove Express from our routes!

```js
// routers.js

const { preHandlerLogic } = require('someDependency');
const { businessLogic } = require('./logic')

// Prefixed route logic
const logic1 = (app, options, done) => {
  app.route({
    method: 'POST',
    url: '/logic1',
    handler: businessLogic,
    preHandler: preHandlerLogic
  });
  done();
};

//No prefix route logic
const logic2 = (app, options, next) => {
  app.route({
    method: 'GET',
    url: '/logic2',
    handler: (req, res) => {
        /* Some Logic */
        res.send(/* something */);
    },
  });
  next();
};

//No prefix route logic
const logic3 = (app, options) => {
  app.route({
    method: 'GET',
    url: '/logic2',
    handler: (req, res) => {
        /* Some Logic */
        res.code(/* some status code */).send(/* some json */);
    },
  });
  next();
};

// Router Array
const router = [
  // prefixed route
  {
    route: logic1,
    prefix: '/prefix'
  },
  // no prefix route
  {
    route: logic2,
    prefix: ''
  },
  {
    route: logic3,
    prefix: ''
  }
];

/**
 * @returns module functions.
 */
module.exports = router;
```

This is how we migrate our Routes to Fastify: Here is what we have done to our ‘routers.js’ file:

1. We have removed the express import and express.Route()

2. We have swapped some Express response methods for Fastify response methods, most notably **"res.json()"** for **"res.send()"**. Other methods should be replaced, check and compare both the Express API and the Fastify API.

3. We have wrapped our business logic in a new format, based on Fastify full declaration Routes. These will be our individual Fastify Routes. These **Fastify Routes** are not prefixed yet.

4. We lump our logic in an Array of Route Objects. These Route Objects have only two attributes: **‘route’**, which will contain our **Fastify Route**, and ‘prefix’, that will contain our routes' prefix as a string..

5. We export our Array.

Just as in Express, with the new ‘router.js’ file, the **exact same two routes** are exposed: the prefixed route **‘/prefix/logic1’** and **‘/logic2’**, with the **exact same behaviour**.

Now, we will feed these Fastify routes to our Generator, but first, we have to do some changes to our ‘index.js’ file:

```js
// index.js

const fastify = require('fastify');
let app = fastify();
const { techLog } = require('@darwin-node/logger');
const { generateFastifyApp } = require('@darwin-node/composer');
const routes = require('./routers.js'); // own routes of our app
const darwinConfig = require('./config'); // Your darwin configuration

app = generateFastifyApp(app, routes, darwinConfig); // How we plug our routes
const host = '0.0.0.0';
const port = 3000;

app.listen({ host, port }, () => {
  techLog.info(`Application listen in port: ${port}`);
});
```

On a first glance, you may not notice the difference. Here is what has changed:

1. The **Express import** has been replaced by a **Fastify import**.

2. The **‘generateExpressApp’** function has been replaced by **'generateFastifyApp'**.

3. The **‘app.listen’** function’s first parameter is now an object **containing both** the **host and port** of the app, instead of just the port.

And that is it! You have successfully migrated your app from Express to Fastify.

**But what about the Darwin Configuration?** - You may ask.
Here is **all the changes needed** to the Darwin Configuration: **None**.

## Recommended Practices

At this point, you should have a working Fastify microservice. Here are some practices that we recommend:

### Keeping your Route Array and Fastify Routes in different files

In this guide, we have coded both the **Fastify Routes** and the **Route Array** in the same file, so it would be easier to follow.
In your microservice, we recommend keeping every Fastify route in its own file, and exporting them to the Route Array in a separate file, like this:

```js
// logic1.js

const { preHandlerLogic } = require('someDependency');
const { businessLogic } = require('./logic')

// Prefixed route logic
const logic1 = (app, options, done) => {
  app.route({
    method: 'POST',
    url: '/logic1',
    handler: businessLogic,
    preHandler: preHandlerLogic
  });
  done();
};

module.exports = logic1;
```

```js
// logic2.js

//No prefix route logic
const logic2= (app, options, next) => {
  app.route({
    method: 'GET',
    url: '/logic2',
    handler: (req, res) => {
        /* Some Logic */
        res.send(/* something */);
    },
  });
  next();
};

module.exports = logic2;
```

```js
// routers.js

const logic1 = import('./routes/logic1.js');
const logic2 = import('./routes/logic2.js');

// Router Array
const router = [
  // prefixed route
  {
    route: logic1,
    prefix: '/prefix'
  },
  // no prefix route
  {
    route: logic2,
    prefix: ''
  }
];

/**
 * @returns module functions.
 */
module.exports = router;
```

### Host and Port as Environment variables

In this guide, we have set the app host and port as constant. If the microservice needs to use a different address or port, those changes would have to be hard-coded. To avoid this, we recommend using environment variables. Here is an example:

```js
// fastify.config.js

module.exports = {
  host: process.env.DARWIN_FASTIFY_HOST || '0.0.0.0',
  port: process.env.DARWIN_FASTIFY_PORT || 8080
};
```

```js
// index.js

const fastify = require('fastify');
let app = fastify();
const { techLog } = require('@darwin-node/logger');
const { generateFastifyApp } = require('@darwin-node/composer');
const routes = require('./routers.js'); // own routes of our app
const darwinConfig = require('./config'); // Your darwin configuration
const { host, port }= require('./config/fastify.config.js')

app = generateFastifyApp(app, routes, darwinConfig); // How we plug our routes

app.listen({ host, port }, () => {
  techLog.info(`Application listen in port: ${port}`);
});
```
