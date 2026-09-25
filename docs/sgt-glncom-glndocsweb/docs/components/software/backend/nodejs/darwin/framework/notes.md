<div class="panel alert-danger">
  <div class="panel-body">
    Darwin Advice: Express Microservice Archetype will be deprecated in version 3.1.0. Please, migrate your microservices to Fastify Microservice Archetype.
  </div>
</div>

## Required

This version is compatible between v12.* and v16.20.2 of Nodejs

**In order to update to the current version you must to execute.**

### Upgrade to Darwin v3.0.4

#### Javascrip microservices

Upgrade the composer version to v3.0.2 with the following command:

```bash
npm i @darwin-node/composer@3.0.2
```

> **DO NOT CHANGE IT MANUALLY**

#### Typescript microservices

With TypeScript microservices **Darwin GraphQl and Darwin Fastify** we must update the following dependencies. There are located in the package.json
> **DO NOT CHANGE IT MANUALLY** use ```npm i @types/jest@27.5.2 @types/node@20.9.0 ...```

```json
"devDependencies": {
  "@types/jest": "^27.5.2",
  "@types/node": "^20.9.0",
  "@typescript-eslint/eslint-plugin": "^6.10.0",
  "@typescript-eslint/parser": "^6.10.0",
  "jest": "^28.1.3",
  "jest-mock-extended": "^3.0.5",
  "ts-jest": "^28.0.8",
  "ts-node": "^10.9.1",
  "typescript": "^5.2.2"
},
"dependencies": {
  "@darwin-node/composer": "^3.0.2"
}
```

### Configuration changes

* change the content of the file `.npmrc` located inside your project with the following content.

```sh
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
@darwin-node:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases
strict-ssl=false
```

* Remove the proxy flag in `package.json` if the command `npm run audit` didn't works property

```json
 --proxy=http://proxyapps.gsnet.corp:80
```

* In order to maintain the compatibility with the catalogation in Spain, you must to create a file called `catalog.properties` in your microservices with the following content

```properties
atlas.system=<YOUR_SYSTEM>
atlas.subsystem=<YOUR_SUBSYSTEM>
atlas.application.acronym=<YOUR_APP_KEY>
atlas.application.code=<YOUR_APPLICATION>
atlas.subapplication.code=<YOUR_SUBAPPLICATION>
```

## Notable changes in our components

## Welcome to Fastify

Darwin v3.* includes a new microservice archetype based on Fastify that it is a highly performant web application framework for NodeJS. Similarly to Express, it allows us to build microservices easy and fast.  

* Fastify handles over 50% more concurrent requests than Express.
* Fastify takes 20% less time to respond to a given request.
* Fastify fails faster and less often. This means that failed requests are less common and will spend a lower time waiting.
* Fastify consumes slightly more resources than Express.

> To extend the documentation about How to migrate, benchmarking ... visit [Official Documentation](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/24779980801/Darwin+Fastify)
